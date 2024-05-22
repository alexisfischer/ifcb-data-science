function [] = summarize_class_cells_biovol_size(roibasepath_generic,feapath_generic,classpath_generic,summarydir,micron_factor,adhoc,yrrange)
%function [] = summarize_class_cells_biovol_size(roibasepath_generic,feapath_generic,classpath_generic,summarydir,micron_factor,adhoc,yrrange)
% Inputs class and feature files and outputs a summary file of cell counts,
% biovolume, and equivalent spherical diameter for 3 different
% classifier outputs (winner takes all, opt score threshold, adhoc threshold)
%
% A.D. Fischer, September 2022
%%
%Example inputs
% summarydir = 'C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\IFCB-Data\Shimada\class\'; %where you want the summary file to go
% classpath_generic = 'F:\Shimada\class\CCS_NOAA-OSU_v7\classxxxx_v1\'; %location of classified data
% feapath_generic = 'F:\Shimada\features\xxxx\'; %Put in your featurepath byyear
% roibasepath_generic = 'F:\Shimada\data\xxxx\'; %location of raw data
% yrrange = 2019:2023; %years that you want summarized
% micron_factor=1/3.8; %pixel to micron conversion
% adhoc = 0.50; %adhoc score threshold of interest

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

%%%% preallocate
load(classfiles{1}, 'class2useTB');
classcountTB = NaN(length(classfiles),length(class2useTB));
classcount_above_optthreshTB = classcountTB;
classcount_above_adhocthreshTB = classcountTB;

classbiovolTB = classcountTB;
classbiovol_above_optthreshTB = classcountTB;
classbiovol_above_adhocthreshTB = classcountTB;

ESDTB = classcountTB;
ESD_above_optthreshTB = classcountTB;
ESD_above_adhocthreshTB = classcountTB;

adhocthresh = adhoc.*ones(1,length(class2useTB)-1); %leave off 1 for unclassified
%adhocthresh(contains(class2useTB,'Dinophysis')) = 0.75; %example to change a specific class

runtypeTB=filelistTB;
filecommentTB=filelistTB;
num2dostr = num2str(length(classfiles));
clearvars feapath_generic classpath_generic roibasepath_generic i

for i = 1:length(classfiles)
    if ~rem(i,10), disp(['reading ' num2str(i) ' of ' num2dostr]), end

     [classcountTB(i,:), classcount_above_optthreshTB(i,:), classcount_above_adhocthreshTB(i,:),...
         classbiovolTB(i,:), classbiovol_above_optthreshTB(i,:), classbiovol_above_adhocthreshTB(i,:),...
         ESDTB(i,:), ESD_above_optthreshTB(i,:), ESD_above_adhocthreshTB(i,:)]...
         = count_class_cells_biovol_size_byfile(classfiles{i}, feafiles{i}, micron_factor, adhocthresh); 

    hdr=IFCBxxx_readhdr2(hdrname{i});
    runtypeTB{i}=hdr.runtype;
    filecommentTB{i}=hdr.filecomment;    

end

save([summarydir 'summary_biovol_allTB'] ,'*TB')

disp('Summary file stored here:')
disp([summarydir 'summary_biovol_allTB'])

end
