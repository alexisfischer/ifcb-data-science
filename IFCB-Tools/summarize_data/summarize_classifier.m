%% Summarize manual and classification results
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

% modify according to dataset
%ifcbdir='F:\IFCB104\'; %SCW
%ifcbdir='F:\IFCB113\'; %USGS cruises
%ifcbdir='F:\IFCB113\Exploratorium\'; %Exploratorium
ifcbdir='F:\IFCB113\ACIDD2017\'; %ACIDD
%ifcbdir='F:\CAWTHRON\'; %New Zealand

%summarydir='C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\IFCB-Data\SCW\'; %SCW
%summarydir='C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\IFCB-Data\SFB\'; %USGS cruises
%summarydir='C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Exploratorium\'; %Exploratorium
summarydir='C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\IFCB-Data\ACIDD\'; %ACIDD
%summarydir='C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\IFCB-Data\NZ\'; %New Zealand
%summarydir='F:\CAWTHRON\summary\'; %New Zealand

addpath(genpath(summarydir));
addpath(genpath([ifcbdir 'data\']));
addpath(genpath('C:\Users\kudelalab\Documents\GitHub\'));

%% Step 2: Summarize manual and classifier results for cell counts
%addpath(genpath([ifcbdir 'manual\']));
summarize_cells_from_manual([ifcbdir 'manual\'],[ifcbdir 'data\'],[summarydir 'manual\']); 

summarize_cells_from_classifier([ifcbdir 'class\classXXXX_v1\'],...
    [ifcbdir 'data\'],[summarydir 'class\'],2020); %you will need to do this separately for each year of data

%% Step 3: Summarize manual and classifier results for biovolume 
biovolume_summary_manual_user_training([ifcbdir 'manual\'],...
    [ifcbdir 'data\'],[ifcbdir 'features\XXXX\'],[summarydir 'manual\']);
   
summarize_biovol_from_classifier([summarydir 'class\'],[ifcbdir 'class\classxxxx_v1\'],...
    [ifcbdir 'features\xxxx\'],[ifcbdir 'data\xxxx\'],0.5,2017:2018);

%% Export Eqdiam and biovolume from feature files
biovol_eqdiam_summary(summarydir,[ifcbdir 'data\'],[ifcbdir 'features\2017\'],'2017')
biovol_eqdiam_summary(summarydir,[ifcbdir 'data\'],[ifcbdir 'features\2018\'],'2018')
biovol_eqdiam_summary(summarydir,[ifcbdir 'data\'],[ifcbdir 'features\2019\'],'2019')

%% PART 3: Assign threshold scores to specific classes
% Summarize counts for thresholds 0.1 to 1 for the specified class
yrrange = 2017:2018;
classpath_generic = [indir 'class\classxxxx_v1\'];
out_path = [summarydir 'class\'];
in_dir = [indir 'data\'];

%dinos
%countcells_allTB_class('Akashiwo', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Ceratium', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Cochlodinium', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Dinophysis', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Lingulodinium', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Prorocentrum', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Gymnodinium', yrrange, classpath_generic, out_path, in_dir)

%diatoms
countcells_allTB_class('Chaetoceros', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Det_Cer_Lau', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Eucampia', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Pseudo-nitzschia', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('NanoP_less10', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Cryptophyte', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Skeletonema', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Centric', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Guin_Dact', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Pennate', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Hemiaulus', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Asterionellopsis', yrrange, classpath_generic, out_path, in_dir)
countcells_allTB_class('Thalassiosira', yrrange, classpath_generic, out_path, in_dir)

countcells_allTB_class('Umbilicosphaera', yrrange, classpath_generic, out_path, in_dir)

%% extract data for a certain date range
filelist(1:140)=[];
ml_analyzed(1:140)=[];
matdate(1:140)=[];
classbiovol(1:140,:)=[];
classcount(1:140,:)=[];
