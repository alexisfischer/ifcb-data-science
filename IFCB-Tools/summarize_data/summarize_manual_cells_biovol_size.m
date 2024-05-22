function [ ] = summarize_manual_cells_biovol_size(manualpath,roibasepath,feapath_base,summarydir,micron_factor)
%function [ ] = summarize_manual_cells_biovol_size(manualpath,roibasepath,feapath_base,summarydir,micron_factor)
% Inputs manually classified results and outputs a summary file of counts,
% total biovolume, and mean equivalent spherical diameter
% A.D. Fischer, August 2021
%
% %Example inputs
% manualpath = 'F:\Shimada\manual\'; %location of manual files
% summarydir = 'C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\IFCB-Data\Shimada\manual\'; %Where you want the summary file to go
% roibasepath = 'F:\Shimada\data\'; %location of raw data
% feapath_base = 'F:\Shimada\features\'; %location of feature files
%  micron_factor = 1/3.8; %microns per pixel conversion

filelist = dir([manualpath 'D*.mat']);
 
% %calculate date
matdate = IFCB_file2date({filelist.name});

% load([manualpath filelist(1).newname]) %read first file to get classes
load([manualpath filelist(1).name],'class2use_manual') %read first file to get classes
numclass = length(class2use_manual);
class2use_manual_first = class2use_manual;
classcount = NaN(length(filelist),numclass);  %initialize output
classbiovol = classcount;
eqdiam = classcount;
ml_analyzed = NaN(length(filelist),1);

%Loops over each file and pulls out, the parameters you want
for filecount = 1:length(filelist) % If you want to do the whole filelist
%    filename = filelist(filecount).newname;
    filename = filelist(filecount).name;
    disp(filename)
%    hdrname = [roibasepath filename(1:9) filesep [filename '.hdr']];  
    
    hdrname = [roibasepath filesep filename(2:5) filesep filename(1:9) filesep regexprep(filename, 'mat', 'hdr')]; 
    ml_analyzed(filecount) = IFCB_volume_analyzed(hdrname);
     
    load([manualpath filename])
    clear targets
    
    [~,file] = fileparts(filename);
    feastruct = importdata([feapath_base file(2:5) '\' file '_fea_v2.csv'], ','); %imports feature file
    ind = strmatch('Biovolume', feastruct.colheaders); %indexes which column is Biovolume, so on and so forth for each parameter below
    targets.Biovolume = feastruct.data(:,ind); %pulls out all Biovolume values, so on and so forth for each parameter below
    ind = strmatch('roi_number', feastruct.colheaders);
    tind = feastruct.data(:,ind);
    ind = strmatch('EquivDiameter', feastruct.colheaders);
    targets.EquivDiameter = feastruct.data(:,ind);    
        
    classlist = classlist(tind,:);
    if ~isequal(class2use_manual, class2use_manual_first)
        disp('class2use_manual does not match previous files!!!')
        %     keyboard
    end
    temp = zeros(1,numclass); %init as zeros for case of subdivide checked but none found, classcount will only be zero if in class_cat, else NaN
    tempvol = temp;
    temp2 = temp;
    for classnum = 1:numclass
        cind = find(classlist(:,2) == classnum | (isnan(classlist(:,2)) & classlist(:,3) == classnum));
        temp(classnum) = length(cind);
        tempvol(classnum) = sum(targets.Biovolume(cind)*micron_factor.^3);  
    	temp2(classnum) = mean(targets.EquivDiameter(cind)*micron_factor);        
    end
    
    classcount(filecount,:) = temp;
    classbiovol(filecount,:) = tempvol;  
    eqdiam(filecount,:) = temp2;      

    clear class2use_manual class2use_auto class2use_sub* classlist    
    
end

class2use = class2use_manual_first;

notes1 = 'Biovolume in units of cubed micrometers';
notes2= 'Eqdiam and axis lengths in micrometers';
%
%saves the result file in the summary folder with a name that will be used 
%every time this is run, but with the date you ran it ammended on the end
save([summarydir 'count_class_biovol_manual'],'matdate','ml_analyzed', ...
    'classcount','classbiovol','filelist','class2use','eqdiam','notes1','notes2');