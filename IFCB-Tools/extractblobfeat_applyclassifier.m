%% Extacting Blobs and Features and Applying a Classifier
%  A.D Fischer, August 2021
clear;

%%%% modify according to dataset
%ifcbdir='F:\Shimada\'; 
ifcbdir='F:\BuddInlet\';
%ifcbdir='F:\LabData\'; 
%ifcbdir='F:\general\classifier\'; 

%summarydir='C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\IFCB-Data\Shimada\';
summarydir='C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\IFCB-Data\BuddInlet\';
%summarydir='C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\IFCB-Data\UCSC\SCW\';
%summarydir=[ifcbdir 'summary\'];

yr='2024';

addpath(genpath(summarydir));
addpath(genpath(ifcbdir));
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\ifcb-analysis\'));
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\'));

classifier='F:\general\classifier\summary\Trees_BI_NOAA_v15';
%classifier='F:\general\classifier\summary\Trees_CCS_NOAA-OSU_v7';

%sort_data_into_folders('F:\KudelaSynology\',[ifcbdir 'data\' yr '\']);
copy_data_into_folders('C:\SFTP-BuddInlet\2024\',[ifcbdir 'data\' yr '\']);

% Step 2: Extract blobs
start_blob_batch_user_training([ifcbdir 'data\' yr '\'],[ifcbdir 'blobs\' yr '\'],true);

%%%% Step 3: Extract features
start_feature_batch_user_training([ifcbdir 'data\' yr '\'],[ifcbdir 'blobs\' yr '\'],[ifcbdir 'features\' yr '\'],true)

%%%% Step 4: Apply classifier
start_classify_batch_user_training(classifier,[ifcbdir 'features\' yr '\'],[ifcbdir 'class\v15\class' yr '_v1\']);


%% adjust classlists
% start_mc_adjust_classes_user_training('F:\general\config\class2use_17','F:\general\classifier\manual_merged_NOAA\')
% start_mc_adjust_classes_user_training('F:\general\config\class2use_17','F:\BuddInlet\manual\')
% start_mc_adjust_classes_user_training('F:\general\config\class2use_17','F:\LabData\manual\')
% start_mc_adjust_classes_user_training('F:\general\config\class2use_17','F:\Shimada\manual\')
% start_mc_adjust_classes_user_training('F:\general\config\class2use_17','F:\BuddInlet\manual_DiscreteSamples\')
% start_mc_adjust_classes_user_training('F:\general\config\class2use_17','F:\BuddInlet\manual_AltSamples\')
