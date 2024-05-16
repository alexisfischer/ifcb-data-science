function [ ] = summarize_PN_width_from_classifier(summarydir,feapath_generic,roibasepath_generic,classpath_generic,micron_factor,yrrange)
%function [ ] = summarize_PN_width_from_classifier(summarydir,feapath_generic,roibasepath_generic,classpath_generic,yrrange)
% Inputs classifier and features files and outputs a summary file of
% minor axis length for all Pseudo-nitzschia chain lengths
%
% Alexis D. Fischer, NOAA NWFSC, April 2023
%
% Example inputs
% clear
% summarydir = 'C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\class\';
% feapath_generic = 'D:\Shimada\features\xxxx\'; %Put in your featurepath byyear
% roibasepath_generic = 'D:\Shimada\data\xxxx\'; %location of raw data
% classpath_generic = 'D:\Shimada\class\CCS_NOAA-OSU_v7\classxxxx_v1\';
% yrrange = 2019:2021;
% micron_factor=1/3.8;

classfiles = [];
filelistTB = [];
feafiles = [];
hdrname = [];

%get the names and paths of the files to summarize
for i = 1:length(yrrange)
    yr = yrrange(i);  
    classpath = regexprep(classpath_generic, 'xxxx', num2str(yr));
    feapath = regexprep(feapath_generic, 'xxxx', num2str(yr));
    roibasepath = regexprep(roibasepath_generic, 'xxxx', num2str(yr));
    
    addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\ifcb-analysis\'));
    addpath(genpath(summarydir));    
    addpath(genpath(classpath));
    addpath(genpath(feapath));
    addpath(genpath(roibasepath));    

    temp = dir([classpath 'D*.mat']);
    if ~isempty(temp) 
        names = char(temp.name);
        filelistTB = [filelistTB; cellstr(names(:,1:24))];    
        
        pathall = repmat(roibasepath, length(temp),1);
        xall = repmat('.hdr', size(names,1),1);      
        fall = repmat('\', size(names,1),1);            
        hdrname = [hdrname; cellstr([pathall names(:,1:9) fall names(:,1:24) xall])];

        pathall = repmat(classpath, length(temp),1);
        classfiles = [classfiles; cellstr([pathall names])];
        
        pathall = repmat(feapath, length(temp),1);
        xall = repmat('_fea_v2.csv', length(temp),1);
        feafiles = [feafiles; cellstr([pathall names(:,1:24) xall])];   
    end
   clearvars temp names pathall classpath feapath roibasepath xall fall yr    
end

% preallocate
mdateTB = IFCB_file2date(filelistTB);
ml_analyzedTB = IFCB_volume_analyzed(hdrname); 
load(classfiles{1},'class2useTB');
runtypeTB=filelistTB;
filecommentTB=filelistTB;
num2dostr = num2str(length(classfiles));
PNcount_above_optthresh=NaN(length(classfiles),1);
PNcount=NaN(length(classfiles),1);

%%%% extract PN 
for i = 1:length(classfiles)
    if ~rem(i,100), disp(['reading ' num2str(i) ' of ' num2dostr]), end  
    [PNcount_above_optthresh(i),PNcount(i),opt_cell1,opt_cell2,opt_cell3,...
        wta_cell1,wta_cell2,wta_cell3]=TBclass_summarize_PN_width(classfiles{i},feafiles{i},micron_factor);

    PNwidth_opt(i).cell1=opt_cell1;
    PNwidth_opt(i).cell2=opt_cell2;
    PNwidth_opt(i).cell3=opt_cell3;
    PNwidth_opt(i).total=[opt_cell1,opt_cell2,opt_cell3];
    PNwidth_opt(i).mean=mean(PNwidth_opt(i).total);

    PNwidth_wta(i).cell1=wta_cell1;
    PNwidth_wta(i).cell2=wta_cell2;
    PNwidth_wta(i).cell3=wta_cell3;
    PNwidth_wta(i).total=[wta_cell1,wta_cell2,wta_cell3];
    PNwidth_wta(i).mean=mean(PNwidth_wta(i).total);
    
    hdr=IFCBxxx_readhdr2(hdrname{i});
    runtypeTB{i}=hdr.runtype;
    filecommentTB{i}=hdr.filecomment;    

    clearvars opt_cell1 opt_cell2 opt_cell3 wta_cell1 wta_cell2 wta_cell3 hdr
end

micron_factor=round(1./micron_factor,2);

save([summarydir 'summary_PN_allTB_micron-factor' num2str(micron_factor) '.mat'],...
    'runtypeTB','filecommentTB','class2useTB','ml_analyzedTB','mdateTB','filelistTB','micron_factor','PN*');

disp('Summary file stored here:')
disp([summarydir 'summary_PN_allTB_micron-factor' num2str(micron_factor) ''])
end
