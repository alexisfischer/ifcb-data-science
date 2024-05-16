%% Extacting Blobs and Features and Applying a Classifier
%  Alexis D. Fischer, NOAA NWFSC, August 2021
clear;

%%%% modify according to dataset
%ifcbdir='F:\Shimada\'; 
ifcbdir='F:\BuddInlet\';
%ifcbdir='F:\LabData\'; 
%ifcbdir='F:\general\classifier\'; 

%summarydir='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\';
summarydir='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\BuddInlet\';
%summarydir='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\UCSC\SCW\';
%summarydir=[ifcbdir 'summary\'];

yr='2024';

addpath(genpath(summarydir));
addpath(genpath(ifcbdir));
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\ifcb-analysis\'));
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\'));

classifier='F:\general\classifier\summary\Trees_BI_NOAA_v15';
%classifier='F:\general\classifier\summary\Trees_CCS_NOAA-OSU_v7';

%sort_data_into_folders('F:\KudelaSynology\',[ifcbdir 'data\' yr '\']);
copy_data_into_folders('C:\SFTP-BuddInlet\2024\',[ifcbdir 'data\' yr '\']);

%% Step 2: Extract blobs
start_blob_batch_user_training([ifcbdir 'data\' yr '\'],[ifcbdir 'blobs\' yr '\'],false);

%%%% Step 3: Extract features
start_feature_batch_user_training([ifcbdir 'data\' yr '\'],[ifcbdir 'blobs\' yr '\'],[ifcbdir 'features\' yr '\'],false)

%%%% Step 4: Apply classifier
start_classify_batch_user_training(classifier,[ifcbdir 'features\' yr '\'],[ifcbdir 'class\v15\class' yr '_v1\']);


%%
%%%% Step 5: Summaries
summarydir_base='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\';
summaryfolder='IFCB-Data\BuddInlet\class\';
classpath_generic = [ifcbdir 'class\v16\classxxxx_v1\'];
feapath_generic = [ifcbdir 'features\xxxx\']; %Put in your featurepath byyear
roibasepath_generic = [ifcbdir 'data\xxxx\']; %location of raw data
micron_factor=1/2.7; %pixels/micron
adhoc=0.5;

countcells_allTB_class_by_threshold(2021:2023,.4:.05:.8,[ifcbdir 'class\v16\classxxxx_v1\'],summarydir,[ifcbdir 'data\'])

%summarize_cells_from_manual([ifcbdir 'manual\'],[ifcbdir 'data\'],[summarydir 'manual\']); 

summarize_biovol_from_classifier_BI(summarydir_base,summaryfolder,classpath_generic,feapath_generic,roibasepath_generic,micron_factor,2021)

%summarize_cells_from_classifier(ifcbdir,classpath_generic,summaryfolder,2021:2023,adhoc)

%summarize_biovol_from_manual([ifcbdir 'manual\'],[summarydir 'manual\'],[ifcbdir 'data\'],[ifcbdir 'features\'],micron_factor)

%% summarize PN width
% summarize_PN_width_from_classifier([summarydir_base 'IFCB-Data\Shimada\class\'],...
%     feapath_generic,roibasepath_generic,classpath_generic,micron_factor,2019:2021)


%summarize_cells_from_manual([ifcbdir 'manualEmilie\AlternateSamples\'],[ifcbdir 'data\'],[summarydir 'manual\']); 


%% adjust classlists
start_mc_adjust_classes_user_training('F:\general\config\class2use_17','F:\general\classifier\manual_merged_NOAA\')
start_mc_adjust_classes_user_training('F:\general\config\class2use_17','F:\BuddInlet\manual\')
start_mc_adjust_classes_user_training('F:\general\config\class2use_17','F:\LabData\manual\')
start_mc_adjust_classes_user_training('F:\general\config\class2use_17','F:\Shimada\manual\')
start_mc_adjust_classes_user_training('F:\general\config\class2use_17','F:\BuddInlet\manual_DiscreteSamples\')
start_mc_adjust_classes_user_training('F:\general\config\class2use_17','F:\BuddInlet\manual_AltSamples\')

