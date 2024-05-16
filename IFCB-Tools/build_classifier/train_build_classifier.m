%% Training and Making a classifier
%   Alexis D. Fischer, NOAA NWFSC, December 2022
clear;
filepath='C:\Users\ifcbuser\Documents\GitHub\';
summarydir='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\BuddInlet\';
addpath(genpath(filepath));
class2useName ='F:\general\config\class2use_17';

%% Step 1: create SCW and Shimada merged manual and feature file folders to pull from for training set
mergedpath = 'F:\general\classifier\';
SHMDApath = 'F:\Shimada\';
LABpath = 'F:\LabData\';
BUDDpath = 'F:\BuddInlet\';
manualpath='F:\general\classifier\manual_merged_BI_NCC_Lab\';
feapathbase='F:\general\classifier\features_merged_BI_NCC_Lab\';

%update classlist to latest
%start_mc_adjust_classes_user_training(class2useName,[LABpath 'manual\']);
%start_mc_adjust_classes_user_training(class2useName,[SHMDApath 'manual\'])
%start_mc_adjust_classes_user_training(class2useName,[BUDDpath 'manual\']);

merge_manual_feafiles_SHMDA_OSU_LAB_BUDD(class2useName,mergedpath,SHMDApath,LABpath,BUDDpath,manualpath,feapathbase)
clearvars  mergedpath UCSCpath SHMDApath LABpath BUDDpath OSUpath;

% Step 2: select classes of interest and find class2skip
% % Regional CCS classifier
% load([filepath 'bloom-baby-bloom\NOAA\Shimada\Data\seascape_topclasses'],'SS');
% SS(end).topclasses(end+1)={'Navicula'};
% 
% [class2skip] = find_class2skip(class2useName,SS(end).topclasses);
% class2skip(end+1)={'Bacteriastrum'};
% class2skip(end+1)={'Thalassiosira_single'};
% class2skip(end+1)={'Heterosigma'};
% class2skip(end+1)={'pennate'};
% class2skip(end+1)={'nanoplankton'};
% class2skip(end+1)={'cryptophyta'};
% class2skip(end+1)={'Pseudo-nitzschia'};
% class2skip(end+1)={'Dinophysis'};
% class2skip(end+1)={'Gonyaulax'};

%%%% Budd Inlet
load([filepath 'bloom-baby-bloom\IFCB-Data\BuddInlet\manual\TopClasses'],'topclasses');
topclasses(end+1)={'Strombidium'};

[class2skip] = find_class2skip(class2useName,topclasses);
class2skip(end+1)={'Thalassiosira_single'};
class2skip(end+1)={'Dinophysis_sp'};
%class2skip(end+1)={'pennate'};
%class2skip(end+1)={'Pseudo-nitzschia'};
class2skip(end+1)={'Scrippsiella'};

% Step 2: Compile features for the training set
addpath(genpath('F:\general\classifier\'));
addpath(genpath('C:\Users\ifcbuser\Documents\'));

%manualpath = 'D:\BuddInlet\manual\'; % manual annotation file location
%feapath_base = 'D:\BuddInlet\features\'; %feature file location, assumes \yyyy\ organization
manualpath = 'F:\general\classifier\manual_merged_BI_NCC_Lab\'; % manual annotation file location
feapath_base = 'F:\general\classifier\features_merged_BI_NCC_Lab\'; %feature file location, assumes \yyyy\ organization
outpath = 'F:\general\classifier\summary\'; % location to save training set
maxn = 7000; %maximum number of images per class to include
minn = 1000; %minimum number for inclusion
class2group={{'Dinophysis_acuminata' 'Dinophysis_fortii' 'Dinophysis_norvegica' 'Dinophysis_parva'},...
    {'Chaetoceros_chain' 'Chaetoceros_single'}}; %{'Heterocapsa_triquetra' 'Scrippsiella'}};

% class2group={{'Pseudo-nitzschia_small_1cell' 'Pseudo-nitzschia_large_1cell'}...
%         {'Pseudo-nitzschia_small_2cell' 'Pseudo-nitzschia_large_2cell'}...
%         {'Pseudo-nitzschia_small_3cell' 'Pseudo-nitzschia_large_3cell' ...
%         'Pseudo-nitzschia_small_4cell' 'Pseudo-nitzschia_large_4cell'}...
%         {'Dinophysis_acuminata' 'Dinophysis_acuta' 'Dinophysis_caudata' 'Dinophysis_fortii' 'Dinophysis_norvegica' 'Dinophysis_odiosa' 'Dinophysis_parva' 'Dinophysis_rotundata' 'Dinophysis_tripos'}...
%         {'Chaetoceros_chain' 'Chaetoceros_single'}...      
%         {'Cerataulina' 'Dactyliosolen' 'Detonula' 'Guinardia'}... %CCS
%         {'Heterocapsa_triquetra' 'Scrippsiella'}...              %CCS
%         {'Rhizosolenia' 'Proboscia'}}; %CCS

group=[]; %'NOAAOSU'; %[]; %'NOAA'; %'OSU'; 
%group='NOAA-OSU'; %[]; %'NOAA'; %'OSU'; 
classifiername=['BI_NOAA_v16']; 
%classifiername=['BI_' group '_v2']; 
%classifiername=['CCS_' group '_v7']; 

compile_train_features_NWFSC(manualpath,feapath_base,outpath,maxn,minn,classifiername,class2useName,class2skip,class2group,group);
addpath(genpath(outpath)); % add new data to search path

%%%% Step 3: Train (make) the classifier
result_path = 'F:\general\classifier\summary\'; %USER location of training file and classifier output
nTrees = 100; %USER how many trees in your forest; choose enough to reach asymptotic error rate in "out-of-bag" classifications
make_TreeBaggerClassifier(result_path, classifiername, nTrees)

classifier_oob_analysis_og([result_path 'Trees_' classifiername],[summarydir 'class\'],0.5);

%plot_classifier_performance

