function [ ] = summarize_cells_from_classifier(roibasepath_generic,classpath_generic,summarydir,adhoc,yrrange)
%function [ ] = summarize_cells_from_classifier(roibasepath_generic,classpath_generic,summarydir,adhoc,yrrange)
% Inputs classified data and outputs a summary file of cell counts for each 
% class for 3 different different classifier outputs (winner takes all, opt 
% score threshold, adhoc threshold)
%
% A.D. Fischer, June 2021
%
% %Example inputs
% roibasepath_generic = 'F:\BuddInlet\data\xxxx\'; %location of raw data
% classpath_generic = 'F:\BuddInlet\class\v15\classxxxx_v1\'; %location of classified data
% summarydir = 'C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\IFCB-Data\BuddInlet\class\'; %where you want the summary file to go
% yrrange = 2021:2023; %years that you want summarized
% adhoc = 0.50; %adhoc score threshold of interest

classfiles = [];
filelistTB = [];
hdrname = [];
for i = 1:length(yrrange)
    yr = yrrange(i);  
    classpath = regexprep(classpath_generic, 'xxxx', num2str(yr));
    roibasepath = regexprep(roibasepath_generic, 'xxxx', num2str(yr));

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
%adhocthresh(contains(class2useTB,'Dinophysis')) = 0.7; %reassign value for specific class

runtypeTB=filelistTB;
filecommentTB=filelistTB;
num2dostr = num2str(length(classfiles));
clearvars classpath_generic roibasepath_generic i

for i = 1:length(classfiles)
    if ~rem(i,10), disp(['reading ' num2str(i) ' of ' num2dostr]), end
    [classcountTB(i,:),classcount_above_optthreshTB(i,:),classcount_above_adhocthreshTB(i,:)]...
        =count_class_cells_byfile(classfiles{i},adhocthresh);    

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
