function [] = summarize_class_cells_biovol_carbon(roibasepath_generic,feapath_generic,classpath_generic,classindexpath,summarydir,micron_factor,yrrange)
%function [] = summarize_class_cells_biovol_carbon(roibasepath_generic,feapath_generic,classpath_generic,classindexpath,summarydir,micron_factor,yrrange)
% Inputs class and feature files and outputs a summary file of cell counts,
% biovolume, and carbon, and for each class for 2 different
% classifier outputs (winner takes all, opt score threshold)
%
% A.D. Fischer, September 2022
%
% %Example inputs
% summarydir = 'C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\IFCB-Data\BuddInlet\class\'; %where you want the summary file to go
% classindexpath ='C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\IFCB-Tools\convert_index_class\class_indices.mat'; %location of class index path to identify which classes are diatoms for carbon conversion
% classpath_generic = 'F:\BuddInlet\class\v15\classxxxx_v1\'; %location of classified data
% feapath_generic = 'F:\BuddInlet\features\xxxx\'; %Put in your featurepath byyear
% roibasepath_generic = 'F:\BuddInlet\data\xxxx\'; %location of raw data
% yrrange = 2021:2023; %years that you want summarized
% micron_factor=1/3.8; %pixel to micron conversion

classfiles = [];
filelistTB = [];
feafiles = [];
hdrname = [];

for i = 1:length(yrrange)
    yr = yrrange(i);  
    classpath = regexprep(classpath_generic, 'xxxx', num2str(yr));
    feapath = regexprep(feapath_generic, 'xxxx', num2str(yr));
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
        
        pathall = repmat(feapath, length(temp),1);
        xall = repmat('_fea_v2.csv', length(temp),1);
        feafiles = [feafiles; cellstr([pathall names(:,1:24) xall])];   
    end
   clearvars temp names pathall classpath feapath roibasepath xall fall yr
end

mdateTB = IFCB_file2date(filelistTB);
ml_analyzedTB = IFCB_volume_analyzed(hdrname); 

%preallocate
load(classfiles{1}, 'class2useTB');
classcountTB = NaN(length(classfiles),length(class2useTB));
classcountTB_above_optthresh = classcountTB;
classbiovolTB = classcountTB;
classbiovolTB_above_optthresh = classcountTB;
classC_TB = classcountTB;
classC_TB_above_optthresh = classcountTB;
runtypeTB=filelistTB;
filecommentTB=filelistTB;
num2dostr = num2str(length(classfiles));
clearvars feapath_generic classpath_generic roibasepath_generic i

for i = 1:length(classfiles)
    if ~rem(i,10), disp(['reading ' num2str(i) ' of ' num2dostr]), end

    [classcountTB(i,:),classbiovolTB(i,:),classC_TB(i,:),classcountTB_above_optthresh(i,:),...
    classbiovolTB_above_optthresh(i,:),classC_TB_above_optthresh(i,:)]...
    =count_class_cells_carbon_byfile(classfiles{i},feafiles{i},micron_factor,classindexpath);
        
    hdr=IFCBxxx_readhdr2(hdrname{i});
    runtypeTB{i}=hdr.runtype;
    filecommentTB{i}=hdr.filecomment;    
    
end

if ~exist(summarydir, 'dir')
    mkdir(resultpath)
end

save([summarydir 'summary_biovol_allTB'] ,'runtypeTB','filecommentTB',...
    'class2useTB', 'classC_TB*', 'classcountTB*', 'classbiovolTB*', 'ml_analyzedTB', 'mdateTB', 'filelistTB')

disp('Summary file stored here:')
disp([summarydir 'summary_biovol_allTB_'])

clear *files* classcount* classbiovol* classC* 

end


