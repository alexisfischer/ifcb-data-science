function [] = summarize_biovol_from_classifier_BI(summarydir_base,summaryfolder,classpath_generic,feapath_generic,roibasepath_generic,micron_factor,yr)
%function [] = summarize_biovol_from_classifier(summarydir_base,summaryfolder,classpath_generic,feapath_generic,roibasepath_generic,yr)
%
% Inputs automatic classified results and outputs a summary file of counts and biovolume
% Alexis D. Fischer, University of California - Santa Cruz, June 2018
%%
% clear
% summarydir_base='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\';
% summaryfolder='IFCB-Data\test\';
% classpath_generic = 'F:\LabData\Brian_PN_expt\class\classxxxx_v1\';
% feapath_generic = 'F:\LabData\Brian_PN_expt\features\xxxx\'; %Put in your featurepath byyear
% roibasepath_generic = 'F:\LabData\Brian_PN_expt\data\xxxx\'; %location of raw data
% yr = 2023;
% micron_factor=1/2.7;

clear
summarydir_base='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\';
summaryfolder='IFCB-Data\BuddInlet\class\';
classpath_generic = 'F:\BuddInlet\class\v15\classxxxx_v1\';
feapath_generic = 'F:\BuddInlet\features\xxxx\'; %Put in your featurepath byyear
roibasepath_generic = 'F:\BuddInlet\data\xxxx\'; %location of raw data
yr = 2023;
micron_factor=1/3.8;

%classifier='F:\general\classifier\summary\Trees_BI_NOAA_v15';
%start_blob_batch_user_training(['F:\BuddInlet\data\' num2str(yr) '\'],['F:\BuddInlet\blobs\' num2str(yr) '\'],false);
%start_feature_batch_user_training(['F:\BuddInlet\data\' num2str(yr) '\'],['F:\BuddInlet\blobs\' num2str(yr) '\'],['F:\BuddInlet\features\ ' num2str(yr) '\'],false)
%start_classify_batch_user_training(classifier,['F:\BuddInlet\features\' num2str(yr) '\'],['F:\BuddInlet\class\v15\class' num2str(yr) '_v1\']);

classfiles = [];
filelistTB = [];
feafiles = [];
hdrname = [];

classpath = regexprep(classpath_generic, 'xxxx', num2str(yr));
feapath = regexprep(feapath_generic, 'xxxx', num2str(yr));
roibasepath = regexprep(roibasepath_generic, 'xxxx', num2str(yr));

addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\ifcb-analysis\'));
addpath(genpath(summarydir_base));    
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
clearvars temp names pathall classpath feapath roibasepath xall fall

mdateTB = IFCB_file2date(filelistTB);
ml_analyzedTB = IFCB_volume_analyzed(hdrname); 

%%%% preallocate
load(classfiles{1}, 'class2useTB');
classcount_above_adhocthreshTB = NaN(length(classfiles),length(class2useTB));
classbiovol_above_adhocthreshTB = classcount_above_adhocthreshTB;
ESD_above_adhocthreshTB = classcount_above_adhocthreshTB;
graylevel_above_adhocthreshTB = classcount_above_adhocthreshTB;

adhocthresh = 0.5.*ones(1,length(class2useTB)-1); %leave off 1 for unclassified
adhocthresh(contains(class2useTB,'Dinophysis')) = 0.7; %example to change a specific class
adhocthresh(contains(class2useTB,'Mesodinium')) = 0.5;

runtypeTB=filelistTB;
filecommentTB=filelistTB;
num2dostr = num2str(length(classfiles));
clearvars feapath_generic classpath_generic roibasepath_generic i

for i = 1:length(classfiles)
    if ~rem(i,10), disp(['reading ' num2str(i) ' of ' num2dostr]), end

     [classcount_above_adhocthreshTB(i,:),classbiovol_above_adhocthreshTB(i,:),...
          ESD_above_adhocthreshTB(i,:),graylevel_above_adhocthreshTB(i,:)]...
         = summarize_TBclass_adhoc_BI(classfiles{i},feafiles{i},micron_factor,adhocthresh); 

    hdr=IFCBxxx_readhdr2(hdrname{i});
    runtypeTB{i}=hdr.runtype;
    filecommentTB{i}=hdr.filecomment;    

end

if ~exist([summarydir_base summaryfolder], 'dir')
    mkdir(resultpath)
end

save([summarydir_base summaryfolder 'summary_biovol_allTB_' num2str(yr) ''] ,'*TB')

disp('Summary file stored here:')
disp([summarydir_base summaryfolder 'summary_biovol_allTB_' num2str(yr) ''])

clear *files* classcount* classbiovol* classwidth*

end


