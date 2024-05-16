function [] = summarize_biovol_from_classifier_Dinophysis_yrrange(summarydir_base,summaryfolder,classpath_generic,feapath_generic,roibasepath_generic,micron_factor,yrrange)
%function [] = summarize_biovol_from_classifier(summarydir_base,summaryfolder,classpath_generic,feapath_generic,roibasepath_generic,yrrange)
%
% Inputs automatic classified results and outputs a summary file of counts and biovolume
% only for Dinophysis
%
%%
clear
summarydir_base='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\';
summaryfolder='IFCB-Data\BuddInlet\class\';
classpath_generic = 'F:\BuddInlet\class\v15\classxxxx_v1\';
feapath_generic = 'F:\BuddInlet\features\xxxx\'; %Put in your featurepath byyear
roibasepath_generic = 'F:\BuddInlet\data\xxxx\'; %location of raw data
yrrange = 2021:2023;
micron_factor=1/3.8;

classfiles = [];
filelistTB = [];
feafiles = [];
hdrname = [];
for i = 1:length(yrrange)
    yr = yrrange(i);  
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
   clearvars temp names pathall classpath feapath roibasepath xall fall yr
end

mdateTB = IFCB_file2date(filelistTB);
ml_analyzedTB = IFCB_volume_analyzed(hdrname); 

%%% preallocate
load(classfiles{1}, 'class2useTB');
adhocthresh = 0.5.*ones(1,length(class2useTB)-1); %leave off 1 for unclassified
adhocthresh(contains(class2useTB,'Dinophysis')) = 0.75; %example to change a specific class

dinocount_above_adhocthreshTB = NaN(length(classfiles),1);
smallcount_above_adhocthreshTB = dinocount_above_adhocthreshTB;
largecount_above_adhocthreshTB = dinocount_above_adhocthreshTB;
dinobiovol_above_adhocthreshTB = dinocount_above_adhocthreshTB;
dinoESD_above_adhocthreshTB = dinocount_above_adhocthreshTB;
dinogray_above_adhocthreshTB = dinocount_above_adhocthreshTB;

runtypeTB=filelistTB;
filecommentTB=filelistTB;
num2dostr = num2str(length(classfiles));
clearvars feapath_generic classpath_generic roibasepath_generic i
%%
for i = 10500:length(classfiles)
%for i = 1:length(classfiles)
    if ~rem(i,10), disp(['reading ' num2str(i) ' of ' num2dostr]), end

     [dinocount_above_adhocthreshTB(i), dinobiovol_above_adhocthreshTB(i),...
         dinoESD_above_adhocthreshTB(i), dinogray_above_adhocthreshTB(i),...
         smallcount_above_adhocthreshTB(i),largecount_above_adhocthreshTB(i)]...
         = summarize_Dinophysis_BI(classfiles{i}, feafiles{i}, micron_factor, adhocthresh); 

    hdr=IFCBxxx_readhdr2(hdrname{i});
    runtypeTB{i}=hdr.runtype;
    filecommentTB{i}=hdr.filecomment;    

end

if ~exist([summarydir_base summaryfolder], 'dir')
    mkdir(resultpath)
end

save([summarydir_base summaryfolder 'summary_Dinophysis_allTB'] ,'*TB')

disp('Summary file stored here:')
disp([summarydir_base summaryfolder 'summary_Dinophysis_allTB'])

end
