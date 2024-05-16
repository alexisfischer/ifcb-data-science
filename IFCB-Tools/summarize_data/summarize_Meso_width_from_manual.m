function [ ] = summarize_Meso_width_from_manual(summarydir,feapath_generic,roibasepath_generic,manualpath,micron_factor,yrrange)
%function [ ] = summarize_Meso_width_from_manual(summarydir,feapath_generic,roibasepath_generic,manualpath_generic,yrrange)
% Inputs classifier and features files and outputs a summary file of
% minor axis length for all Pseudo-nitzschia chain lengths
%
% Alexis D. Fischer, NOAA NWFSC, April 2023
%%
% %% Example inputs
clear
summarydir = 'C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\BuddInlet\manual\';
feapath_generic = 'F:\BuddInlet\features\xxxx\'; %Put in your featurepath byyear
roibasepath_generic = 'F:\BuddInlet\data\xxxx\'; %location of raw data
manualpath = 'F:\BuddInlet\manual\';
yrrange = 2021:2023;
micron_factor=1/3.8;

manualfiles = [];
filelist = [];
feafiles = [];
hdrname = [];

% get the names and paths of the files to summarize
for i = 1:length(yrrange)
    yr = yrrange(i);  
    feapath = regexprep(feapath_generic, 'xxxx', num2str(yr));
    roibasepath = regexprep(roibasepath_generic, 'xxxx', num2str(yr));
    
    addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\ifcb-analysis\'));
    addpath(genpath(summarydir));    
    addpath(genpath(manualpath));
    addpath(genpath(feapath));
    addpath(genpath(roibasepath));    

    temp = dir([manualpath 'D' num2str(yr) '*.mat']);
    if ~isempty(temp) 
        names = char(temp.name);
        filelist = [filelist; cellstr(names(:,1:24))];    
        
        pathall = repmat(roibasepath, length(temp),1);
        xall = repmat('.hdr', size(names,1),1);      
        fall = repmat('\', size(names,1),1);            
        hdrname = [hdrname; cellstr([pathall names(:,1:9) fall names(:,1:24) xall])];

        pathall = repmat(manualpath, length(temp),1);
        manualfiles = [manualfiles; cellstr([pathall names])];
        
        pathall = repmat(feapath, length(temp),1);
        xall = repmat('_fea_v2.csv', length(temp),1);
        feafiles = [feafiles; cellstr([pathall names(:,1:24) xall])];   
    end
   clearvars temp names pathall feapath roibasepath xall fall yr    
end

%%%% preallocate
mdate = IFCB_file2date(filelist);
ml_analyzed = IFCB_volume_analyzed(hdrname); 
load(manualfiles{1},'class2use_manual');
runtype=cell(length(mdate),1);
filecomment=runtype;
total=NaN(length(filelist),1);
large=total;
small=total;
ESD=cell(length(mdate),1);

%%%% extract meso size 
num2dostr = num2str(length(manualfiles));
for i = 1:length(manualfiles)
   if ~rem(i,100), disp(['reading ' num2str(i) ' of ' num2dostr]), end
     [total(i),small(i),large(i),size]=manual_summarize_Meso_width_individual(manualfiles{i},feafiles{i},micron_factor);

    hdr=IFCBxxx_readhdr2(hdrname{i});
    runtype{i}=hdr.runtype;
    filecomment{i}=hdr.filecomment;    

     ESD(i)={size};    
end

% Mcount=NaN(length(manualfiles),1);
% Msize=NaN(length(manualfiles),1);
% Mstdev=NaN(length(manualfiles),1);
% 
% %%%% extract PN 
% for i = 1:length(manualfiles)
%    if ~rem(i,100), disp(['reading ' num2str(i) ' of ' num2dostr]), end  
%     [Mcount(i), Msize(i), Mstdev(i)]=manual_summarize_Meso_width(manualfiles{i},feafiles{i},micron_factor);
%     hdr=IFCBxxx_readhdr2(hdrname{i});
%     runtype{i}=hdr.runtype;
%     filecomment{i}=hdr.filecomment;    
% end

save([summarydir 'summary_meso_width_manual'],'total','large','small','runtype','filecomment',...
    'class2use_manual','ml_analyzed','mdate','filelist','micron_factor','ESD');

disp('Summary file stored here:')
disp([summarydir 'summary_meso_width_manual'])
end
