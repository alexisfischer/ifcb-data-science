function [ ] = summarize_cells_from_classifier(ifcbdir,classpath_generic,summarydir,yrrange,adhoc)
%function [ ] = summarize_cells_from_classifier(ifcbdir, summarydir, yrrange)
% Inputs automatic classified results and summarizes class results for a series of classifier output files (TreeBagger)
% A.D. Fischer, June 2018
%
%% %test inputs
% clear
% summarydir='C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\IFCB-Data\test\';
% classpath_generic = 'F:\LabData\Brian_PN_expt\class\classxxxx_v1\';
% roibasepath_generic = 'F:\LabData\Brian_PN_expt\data\xxxx\'; %location of raw data
% yrrange = 2023;
% adhoc=0.50;

% clear
% summarydir='C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\IFCB-Data\BuddInlet\class\';
% classpath_generic = 'F:\BuddInlet\class\v15\classxxxx_v1\';
% roibasepath_generic = 'F:\BuddInlet\data\xxxx\'; %location of raw data
% yrrange = 2021:2023;
% adhoc=0.50;

classfiles = [];
filelistTB = [];
hdrname = [];
for i = 1:length(yrrange)
    yr = yrrange(i);  
    classpath = regexprep(classpath_generic, 'xxxx', num2str(yr));
    roibasepath = regexprep(roibasepath_generic, 'xxxx', num2str(yr));

    addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\ifcb-analysis\'));
    addpath(genpath(summarydir));    
    addpath(genpath(classpath));
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
 
    end
   clearvars temp names pathall classpath roibasepath xall fall yr
end

mdateTB = IFCB_file2date(filelistTB);
ml_analyzedTB = IFCB_volume_analyzed(hdrname); 

%%%% preallocate
load(classfiles{1}, 'class2useTB');
classcountTB = NaN(length(classfiles),length(class2useTB));
classcount_above_optthreshTB = classcountTB;
classcount_above_adhocthreshTB = classcountTB;

adhocthresh = adhoc*ones(size(class2useTB)); %assign all classes the same adhoc decision threshold between 0 and 1
adhocthresh(contains(class2useTB,'Dinophysis')) = 0.7; %reassign value for specific class
adhocthresh(contains(class2useTB,'Mesodinium')) = 0.5; %reassign value for specific class

runtypeTB=filelistTB;
filecommentTB=filelistTB;
num2dostr = num2str(length(classfiles));
clearvars classpath_generic roibasepath_generic i

for i = 1:length(classfiles)
    if ~rem(i,10), disp(['reading ' num2str(i) ' of ' num2dostr]), end
    [classcountTB(i,:),classcount_above_optthreshTB(i,:),classcount_above_adhocthreshTB(i,:)]...
        =summarize_TBclass(classfiles{i},adhocthresh);    

    hdr=IFCBxxx_readhdr2(hdrname{i});
    runtypeTB{i}=hdr.runtype;
    filecommentTB{i}=hdr.filecomment;    
end

if ~exist(summarydir, 'dir')
    mkdir(resultpath)
end

yrrangestr = num2str(yrrange(1));
if length(yrrange) > 1
    yrrangestr = [yrrangestr '_' num2str(yrrange(end))];
end

save([summarydir 'summary_cells_allTB_' yrrangestr],'*TB');
disp('Summary cell count file stored here:')
disp([summarydir 'summary_cells_allTB_' yrrangestr])

%%
% %% not using for now
% 
% mdate = IFCB_file2date(filelist);
% 
% %presumes all class files have same class2useTB list
% temp = load(classfiles{1}, 'class2useTB');
% class2use = temp.class2useTB; clear temp classfilestr
% classcount = NaN(length(classfiles),length(class2use));
% classcount_above_optthresh = classcount;
% classcount_above_adhocthresh = classcount;
% num2dostr = num2str(length(classfiles));
% ml_analyzed = NaN(size(classfiles));
% runtype=filelist;
% filecomment=filelist;
% adhocthresh = adhoc*ones(size(class2use)); %assign all classes the same adhoc decision threshold between 0 and 1
% adhocthresh(contains(class2use,'Dinophysis')) = 0.55; %reassign value for specific class
% adhocthresh(contains(class2use,'Mesodinium')) = 0.5; %reassign value for specific class
% %%
% for i = 1:length(classfiles)
%     if ~rem(i,10), disp(['reading ' num2str(i) ' of ' num2dostr]), end
%     ml_analyzed(i) = IFCB_volume_analyzed(hdrname{i});
%     [classcount(i,:),classcount_above_optthresh(i,:),classcount_above_adhocthresh(i,:)]...
%         =summarize_TBclass(classfiles{i},adhocthresh);
% 
%     hdr=IFCBxxx_readhdr2(hdrname{i});
%     runtype{i}=hdr.runtype;
%     filecomment{i}=hdr.filecomment;  
% end
% 
% if ~exist(summarydir, 'dir')
%     mkdir(summarydir)
% end
% 
% ml_analyzedTB = ml_analyzed;
% mdateTB = mdate;
% filelistTB = filelist;
% class2useTB = class2use;
% classcountTB = classcount;
% classcountTB_above_optthresh = classcount_above_optthresh;
% 
% yrrangestr = num2str(yrrange(1));
% if length(yrrange) > 1
%     yrrangestr = [yrrangestr '_' num2str(yrrange(end))];
% end
% 
% clear mdate filelist class2use classcount classcount_above_optthresh i yrrange yrcount yr classfiles in_dir num2dostr
% 
% %if exist('adhocthresh', 'var')
%     classcountTB_above_adhocthresh = classcount_above_adhocthresh;
%     save([summarydir 'summary_cells_allTB_' yrrangestr] , 'class2useTB', 'classcountTB', 'classcountTB_above_optthresh', 'classcountTB_above_adhocthresh', 'ml_analyzedTB', 'mdateTB', 'filelistTB', 'adhocthresh', 'classpath_generic')
% % else
% %     save([summarydir 'summary_cells_allTB'] , 'class2useTB', 'classcountTB', 'classcountTB_above_optthresh', 'ml_analyzedTB', 'mdateTB', 'filelistTB', 'classpath_generic')
% % end
% 
% disp('Summary cell count file stored here:')
% disp([summarydir 'summary_cells_allTB_' yrrangestr])
% 
% return
% %example plotting code for all of the data (load summary file first)
% figure
% classind = 2;
% plot(mdateTB, classcountTB(:,classind)./ml_analyzedTB, '.-')
% hold on
% plot(mdateTB, classcountTB_above_optthresh(:,classind)./ml_analyzedTB, 'g.-')
% plot(mdateTB, classcountTB_above_adhocthresh(:,classind)./ml_analyzedTB, 'r.-')
% legend('All wins', 'Wins above optimal threshold', 'Wins above adhoc threshold')
% ylabel([class2useTB{classind} ', mL^{ -1}'])
% datetick('x')
