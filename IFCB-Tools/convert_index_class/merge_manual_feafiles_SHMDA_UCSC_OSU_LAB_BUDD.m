function [] = merge_manual_feafiles_SHMDA_UCSC_OSU_LAB_BUDD(class2useName,mergedpath,UCSCpath,OSUpath,SHMDApath,LABpath,BUDDpath)
%merge_manual_feafiles_UCSC_SHMDA merges manual and feature files in
%preparation for building a training set
%   copies all UCSC and Shimada manual and feature files to merged folders
%   converts UCSC manual classes to SHMDA classes
%   Alexis D. Fischer, SHMDA NWFSC, September 2021

% % % Input path names
% class2useName ='D:\general\config\class2use_14';
% mergedpath = 'D:\general\classifier\';
% UCSCpath = 'D:\SCW\';
% OSUpath = 'D:\OSU\';
% SHMDApath = 'D:\Shimada\';
% LABpath = 'D:\LabData\';
% BUDDpath = 'D:\BuddInlet\';

%%%%
manualpath = [mergedpath 'manual_merged_selectUCSC\'];
feapathbase = [mergedpath 'features_merged_selectUCSC\'];
load([class2useName '.mat'], 'class2use');

%% Shimada
% copy manual files to merged manual folder
SHMDAmanualpath = [SHMDApath 'manual\'];
manual_files = dir([SHMDAmanualpath 'D*.mat']); %only select manual files
for i=1:length(manual_files)  
    copyfile([SHMDAmanualpath manual_files(i).name],manualpath); 
end

% copy corresponding features files to merged features folder
SHMDAfeapathbase = [SHMDApath 'features\']; 
manual_files = {manual_files.name}';
fea_files = regexprep(manual_files, '.mat', '_fea_v2.csv');
for i=1:length(fea_files)  
    SHMDAfeapath=[SHMDAfeapathbase manual_files{i}(2:5) filesep]; %use correct yr structure
    feapath = [feapathbase manual_files{i}(2:5) filesep];    
    copyfile([SHMDAfeapath fea_files{i}],feapath); 
end

clearvars manual_files fea_files SHMDAmanualpath i SHMDAfeapath feapath
disp('Finished copying corresponding SHIMADA manual and feature files');

%% Lab Data
addpath(genpath(LABpath));
addpath(genpath(mergedpath));

% copy manual files to merged manual folder
LABmanualpath = [LABpath 'manual\'];
manual_files = dir([LABmanualpath 'D*.mat']); %only select manual files
for i=1:length(manual_files)  
    copyfile([LABmanualpath manual_files(i).name],manualpath); 
end

% copy corresponding features files to merged features folder
LABfeapathbase = [LABpath 'features\']; 
manual_files = {manual_files.name}';
fea_files = regexprep(manual_files, '.mat', '_fea_v2.csv');
for i=1:length(fea_files)  
    LABfeapath=[LABfeapathbase manual_files{i}(2:5) filesep]; %use correct yr structure
    feapath = [feapathbase manual_files{i}(2:5) filesep];    
    copyfile([LABfeapath fea_files{i}],feapath); 
end

clearvars manual_files fea_files LABmanualpath i LABfeapath feapath
disp('Finished copying corresponding LAB manual and feature files');

%% Budd Inlet Data
addpath(genpath(BUDDpath));
addpath(genpath(mergedpath));

% copy manual files to merged manual folder
BUDDmanualpath = [BUDDpath 'manual\'];
manual_files = dir([BUDDmanualpath 'D*.mat']); %only select manual files
for i=1:length(manual_files)  
    copyfile([BUDDmanualpath manual_files(i).name],manualpath); 
end

% copy corresponding features files to merged features folder
BUDDfeapathbase = [BUDDpath 'features\']; 
manual_files = {manual_files.name}';
fea_files = regexprep(manual_files, '.mat', '_fea_v2.csv');
for i=1:length(fea_files)  
    BUDDfeapath=[BUDDfeapathbase manual_files{i}(2:5) filesep]; %use correct yr structure
    feapath = [feapathbase manual_files{i}(2:5) filesep];    
    copyfile([BUDDfeapath fea_files{i}],feapath); 
end

clearvars manual_files fea_files BUDDmanualpath i BUDDfeapath feapath
disp('Finished copying corresponding BUDD manual and feature files');

%% Emilie's Budd Inlet Discrete and alternate sample annotations

% copy manual files to merged manual folder
BUDDmanualpath = [BUDDpath 'manual_AltSamples\'];
manual_files = dir([BUDDmanualpath 'D*.mat']); %only select manual files
for i=1:length(manual_files)  
    copyfile([BUDDmanualpath manual_files(i).name],manualpath); 
end

% copy corresponding features files to merged features folder
BUDDfeapathbase = [BUDDpath 'features\']; 
manual_files = {manual_files.name}';
fea_files = regexprep(manual_files, '.mat', '_fea_v2.csv');
for i=1:length(fea_files)  
    BUDDfeapath=[BUDDfeapathbase manual_files{i}(2:5) filesep]; %use correct yr structure
    feapath = [feapathbase manual_files{i}(2:5) filesep];    
    copyfile([BUDDfeapath fea_files{i}],feapath); 
end

% copy manual files to merged manual folder
BUDDmanualpath = [BUDDpath 'manual_DiscreteSamples\'];
manual_files = dir([BUDDmanualpath 'D*.mat']); %only select manual files
for i=1:length(manual_files)  
    copyfile([BUDDmanualpath manual_files(i).name],manualpath); 
end

% copy corresponding features files to merged features folder
BUDDfeapathbase = [BUDDpath 'features\']; 
manual_files = {manual_files.name}';
fea_files = regexprep(manual_files, '.mat', '_fea_v2.csv');
for i=1:length(fea_files)  
    BUDDfeapath=[BUDDfeapathbase manual_files{i}(2:5) filesep]; %use correct yr structure
    feapath = [feapathbase manual_files{i}(2:5) filesep];    
    copyfile([BUDDfeapath fea_files{i}],feapath); 
end

clearvars manual_files fea_files BUDDmanualpath i BUDDfeapath feapath
disp('Finished copying corresponding Alt and Discrete BUDD manual and feature files');

%% UCSC
addpath(genpath(mergedpath));

% copy manual files to merged manual folder and convert classes
UCSCmanualpath = [UCSCpath 'manual\'];
addpath(genpath(UCSCmanualpath));
manual_files = dir([UCSCmanualpath 'D*104.mat']); %only select UCSC files
for i=1:length(manual_files)  
    copyfile([UCSCmanualpath manual_files(i).name],manualpath);  
    baseFileName = manual_files(i).name;        
    fullFileName = fullfile(manualpath, baseFileName);
    fprintf(1, 'Now converting classes in file %s\n', fullFileName);
    load(fullFileName,'class2use_auto','classlist','default_class_original','list_titles');
    
    %overwrite UCSC classes with NWFSC classes    
    [classlist(:,2)]=convert_classnum_UCSC2NWFSC(classlist(:,2)); 
    [classlist(:,3)]=convert_classnum_UCSC2NWFSC(classlist(:,3));     
    class2use_manual=class2use;
    if isempty(class2use_auto)
    else
        class2use_auto = class2use;
    end    
    
    save(fullFileName,'class2use_auto','class2use_manual','classlist','default_class_original','list_titles');
    clearvars class2use_auto class2use_manual classlist default_class_original list_titles baseFileName fullFileName; 
end

% copy corresponding features files to merged features folder
UCSCfeapathbase = [UCSCpath 'features\']; 
addpath(genpath(UCSCfeapathbase));
manual_files = {manual_files.name}';
fea_files = regexprep(manual_files, '.mat', '_fea_v2.csv');
for i=1:length(fea_files)  
    UCSCfeapath=[UCSCfeapathbase manual_files{i}(2:5) filesep]; %use correct yr structure
    feapath = [feapathbase manual_files{i}(2:5) filesep];
    copyfile([UCSCfeapath fea_files{i}],feapath); 
end

clearvars manual_files fea_files i UCSCfeapath feapath
disp('Finished copying corresponding UCSC manual and feature files');

%% OSU
addpath(genpath(mergedpath));

% copy manual files to merged manual folder and convert classes
OSUmanualpath = [OSUpath 'manual\'];
addpath(genpath(OSUmanualpath));
manual_files = dir([OSUmanualpath 'D*122.mat']); %only select IFCB122 files
for i=1:length(manual_files)  
    copyfile([OSUmanualpath manual_files(i).name],manualpath);  
    baseFileName = manual_files(i).name;        
    fullFileName = fullfile(manualpath, baseFileName);
    fprintf(1, 'Now converting classes in file %s\n', fullFileName);
    load(fullFileName,'class2use_auto','classlist','default_class_original','list_titles');
    
    %overwrite OSU classes with NWFSC classes    
    [classlist(:,2)]=convert_classnum_OSU2NWFSC(classlist(:,2)); 
    [classlist(:,3)]=convert_classnum_OSU2NWFSC(classlist(:,3));     
    class2use_manual=class2use;
    if isempty(class2use_auto)
    else
        class2use_auto = class2use;
    end    
    
    save(fullFileName,'class2use_auto','class2use_manual','classlist','default_class_original','list_titles');
    clearvars class2use_auto class2use_manual classlist default_class_original list_titles baseFileName fullFileName; 
end

% copy corresponding features files to merged features folder
OSUfeapathbase = [OSUpath 'features\']; 
addpath(genpath(OSUfeapathbase));
manual_files = {manual_files.name}';
fea_files = regexprep(manual_files, '.mat', '_fea_v2.csv');
for i=1:length(fea_files)  
    OSUfeapath=[OSUfeapathbase manual_files{i}(2:5) filesep]; %use correct yr structure
    feapath = [feapathbase manual_files{i}(2:5) filesep];
    copyfile([OSUfeapath fea_files{i}],feapath); 
end

%% convert to preferred classlist
manualdir = dir([manualpath 'D*']);
for ii = 1:length(manualdir)
    manualfile = open([manualpath manualdir(ii).name]);
    manualfile.class2use_manual = class2use;
    if ~isempty(manualfile.class2use_auto)
        manualfile.class2use_auto = transpose(class2use);
    end
    save([manualpath manualdir(ii).name], '-struct', 'manualfile');
end

clearvars manual_files fea_files i OSUfeapath feapath
disp('Finished copying corresponding OSU manual and feature files');

end

