%% Training and Making a Seascape classifier
%  A.D Fischer, February 2023
%
clear;
filepath='C:\Users\ifcbuser\Documents\';
summarydir='C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\';
addpath(genpath(filepath));
addpath(genpath('D:\general\classifier\'));

%USER
class2useName ='D:\general\config\class2use_13';
ssnum=19; 

%%%% Step 1: select topclasses for seascape of interest
load([summarydir 'NOAA\SeascapesProject\Data\seascape_topclasses'],'SS');
TopClass=(SS([SS.ss]==ssnum).topclasses)';

%%%% Step 2: find class2skip
[class2skip] = find_class2skip(class2useName,TopClass);
class2skip(end+1)={'Bacteriastrum'};
class2skip(end+1)={'Thalassiosira_single'};
class2skip(end+1)={'pennate'};
class2skip(end+1)={'nanoplankton'};
class2skip(end+1)={'cryptophyta'};

%% Step 3: compile features for the training set
ssdir='C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\NOAA\SeascapesProject\Data\SeascapeSummary_NOAA-OSU-UCSC';
manualpath = 'D:\general\classifier\manual_merged_ungrouped\'; % manual annotation file location
feapath_base = 'D:\general\classifier\features_merged_ungrouped\'; %feature file location, assumes \yyyy\ organization
outpath = 'D:\general\classifier\summary\'; % location to save training set
maxn = 5000; %maximum number of images per class to include
minn = 200; %minimum number for inclusion
class2group={{'Pseudo-nitzschia' 'Pseudo_nitzschia_small_1cell' 'Pseudo_nitzschia_large_1cell' 'Pseudo_nitzschia_large_2cell' 'Pseudo_nitzschia_small_2cell' 'Pseudo_nitzschia_small_3cell' 'Pseudo_nitzschia_large_3cell' 'Pseudo_nitzschia_small_4cell' 'Pseudo_nitzschia_large_4cell' 'Pseudo_nitzschia_small_5cell' 'Pseudo_nitzschia_large_5cell' 'Pseudo_nitzschia_small_6cell' 'Pseudo_nitzschia_large_6cell'}...
        {'Dinophysis' 'Dinophysis_acuminata' 'Dinophysis_acuta' 'Dinophysis_caudata' 'Dinophysis_fortii' 'Dinophysis_norvegica' 'Dinophysis_odiosa' 'Dinophysis_parva' 'Dinophysis_rotundata' 'Dinophysis_tripos'}...
        {'Chaetoceros_chain' 'Chaetoceros_single'}...
        {'Stephanopyxis' 'Melosira'}...      
        {'Cerataulina' 'Dactyliosolen' 'Detonula' 'Guinardia'}... 
        {'Rhizosolenia' 'Proboscia'}...                
        {'Gymnodinium' 'Heterosigma' 'Scrippsiella'}};

group=[]; %[]; %'NOAA-OSU'; %'OSU'; 
classifiername=['ss' num2str(ssnum) '_' group '_v1']; 

compile_train_features_SS(manualpath,feapath_base,outpath,maxn,minn,classifiername,class2useName,class2skip,class2group,group,ssnum,ssdir);
addpath(genpath(outpath)); % add new data to search path

% Step 4: Train (make) the classifier
result_path = 'D:\general\classifier\summary\'; %USER location of training file and classifier output
nTrees = 100; %USER how many trees in your forest; choose enough to reach asymptotic error rate in "out-of-bag" classifications
make_TreeBaggerClassifier(result_path, classifiername, nTrees)

determine_classifier_performance([result_path 'Trees_' classifiername],[summarydir 'IFCB-Data\Shimada\class\']);
%determine_classifier_performance([result_path 'Trees_' classifiername],'C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\IFCB-Data\Shimada\class\');

