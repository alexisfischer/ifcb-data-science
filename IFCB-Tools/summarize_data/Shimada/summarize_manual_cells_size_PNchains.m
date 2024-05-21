function [ ] = summarize_manual_cells_size_PNchains(summarydir,feapath_generic,roibasepath_generic,manualpath,micron_factor,yrrange)
%function [ ] = summarize_manual_cells_size_PNchains(summarydir,feapath_generic,roibasepath_generic,manualpath,micron_factor,yrrange)
% Inputs classifier and features files and outputs a summary file of
% minor axis length for all Pseudo-nitzschia chain lengths
%

% Inputs classified data and feature files and outputs a summary file of 
% cell counts for each class for 3 different different classifier outputs (winner takes all, opt 
% score threshold, adhoc threshold)

% Alexis D. Fischer, NOAA NWFSC, April 2023
%
% %% Example inputs
% clear
% summarydir = 'C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\manual\';
% feapath_generic = 'D:\Shimada\features\xxxx\'; %Put in your featurepath byyear
% roibasepath_generic = 'D:\Shimada\data\xxxx\'; %location of raw data
% manualpath = 'D:\Shimada\manual\';
% yrrange = 2019:2021;
% micron_factor=1/2.7;

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

% preallocate
mdate = IFCB_file2date(filelist);
ml_analyzed = IFCB_volume_analyzed(hdrname); 
load(manualfiles{1},'class2use_manual');
runtype=filelist;
filecomment=filelist;
num2dostr = num2str(length(manualfiles));
large_PN=NaN(length(manualfiles),1);
small_PN=NaN(length(manualfiles),1);

%%%% extract PN 
for i = 1:length(manualfiles)
   if ~rem(i,100), disp(['reading ' num2str(i) ' of ' num2dostr]), end  

    [large_PN(i),small_PN(i),Lcell1,Lcell2,Lcell3,Lcell4,...
        Scell1,Scell2,Scell3,Scell4]=count_manual_byfile_PNchains(manualfiles{i},feafiles{i},micron_factor);

    PNwidth_large(i).cell1=Lcell1;
    PNwidth_large(i).cell2=Lcell2;
    PNwidth_large(i).cell3=Lcell3;
    PNwidth_large(i).cell4=Lcell4;
    PNwidth_large(i).total=[Lcell1,Lcell2,Lcell3,Lcell4];
    PNwidth_large(i).mean=mean(PNwidth_large(i).total);

    PNwidth_small(i).cell1=Scell1;
    PNwidth_small(i).cell2=Scell2;
    PNwidth_small(i).cell3=Scell3;
    PNwidth_small(i).cell4=Scell4;
    PNwidth_small(i).total=[Scell1,Scell2,Scell3,Scell4];
    PNwidth_small(i).mean=mean(PNwidth_small(i).total);
    
    hdr=IFCBxxx_readhdr2(hdrname{i});
    runtype{i}=hdr.runtype;
    filecomment{i}=hdr.filecomment;    

    clearvars Lcell1 Lcell2 Lcell3 Lcell4 Scell1 Scell2 Scell3 Scell4 hdr
end

micron_factor=round(1./micron_factor,2);

save([summarydir 'summary_PN_width_manual_micron-factor' num2str(micron_factor) ''],'runtype','filecomment',...
    'class2use_manual','ml_analyzed','mdate','filelist','micron_factor','PN*');

disp('Summary file stored here:')
disp([summarydir 'summary_PN_manual_micron-factor' num2str(micron_factor) ''])
end
