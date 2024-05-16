function [ ] = summarize_manual_cells_biovol_size_byROI(manualpath,out_dir,roibasepath,feapath_base,yr,micron_factor)
%function [ ] = summarize_manual_cells_biovol_size_byROI(manualpath,out_dir,roibasepath,feapath_base,yr,micron_factor)
%
% Inputs manually classified results and outputs a summary file of counts, 
% biovolume, and equivalent spherical diameter
% Alexis D. Fischer, NOAA, August 2021
%
%Example inputs
%  manualpath = 'D:\Shimada\manual\'; %USER
%  out_dir = 'C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\manual\';
%  roibasepath = 'D:\Shimada\data\'; %USER
%  feapath_base = 'D:\Shimada\features\2021\'; %USER
%  yr='2021';
%  micron_factor = 1/3.4; %microns per pixel conversion

% determine where MC and feature files intersect
fefilelist = dir([feapath_base 'D*.csv']);
mcfilelist = dir(manualpath);
A={fefilelist(:).name}'; AA = cellfun(@(x) x(1:end-11), A, 'un', 0);
B={mcfilelist(:).name}'; BB = cellfun(@(x) x(1:end-4), B, 'un', 0);
[~,ia,~] = intersect(AA,BB, 'stable');
filelist=fefilelist(ia);
clearvars fefilelist A B AA BB ia;

matdate = IFCB_file2date({filelist.name}); %calculate date
ml_analyzed = NaN(length(filelist),1);
load([manualpath filelist(1).name(1:24) '.mat'],'class2use_manual') %read first file to get classes

for i = 1:length(filelist)
    filename = filelist(i).name;
    disp(filename)
    hdrname = [roibasepath filename(2:5) filesep filename(1:9) filesep regexprep(filename,'_fea_v2.csv','.hdr')];
    ml_analyzed(i) = IFCB_volume_analyzed(hdrname);
     
    [~,file] = fileparts(filename);
    feastruct = importdata([feapath_base file '.csv'], ',');
    ind = strmatch('Biovolume', feastruct.colheaders);
    biovol = feastruct.data(:,ind);
    ind = strmatch('roi_number', feastruct.colheaders);
    roi = feastruct.data(:,ind);
    ind = strmatch('EquivDiameter', feastruct.colheaders);
    eqdiam = feastruct.data(:,ind);
        
        clearvars ind hdrname file

    load([manualpath filename(1:24) '.mat'],'classlist')
    
    list=nan*[roi,roi,roi];
    for ii=1:size(classlist,1)
        for j=1:length(roi)
            if roi(j) == classlist(ii,1)
                list(j,1)=classlist(ii,1);      
                list(j,2)=classlist(ii,2);      
                list(j,3)=classlist(ii,3);      
            else
            end
        end
    end
    
    % preferentially take manual files over class files
    class=nan*(list(:,1));
    for ii=1:size(list,1)
        if ~isnan(list(ii,2))
            class(ii) = list(ii,2);  
        else
            class(ii) = list(ii,3);
        end
    end
    
    BiEq(i).filename=[filename(1:24) '.mat'];
    BiEq(i).matdate=matdate(i);
    BiEq(i).ml_analyzed=ml_analyzed(i);    
    BiEq(i).roi=list(:,1);
    BiEq(i).class=class;
    BiEq(i).eqdiam=eqdiam*micron_factor;
    BiEq(i).biovol=biovol*micron_factor.^3;
    
    clearvars roi filename class eqdiam biovol;
end


%%
note1 = 'Biovolume: cubed micrometers';
note2= 'Equivalent spherical diameter: micrometers';
save([out_dir 'class_eqdiam_biovol_manual_' yr], 'BiEq', 'class2use_manual', 'note1', 'note2')

disp('Summary file stored here:')
disp([out_dir 'class_eqdiam_biovol_manual_' yr])

end
