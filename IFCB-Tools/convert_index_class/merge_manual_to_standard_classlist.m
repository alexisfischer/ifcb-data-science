%% merge manual files for annotations that used random classlists so they can be used in the training set
%   converts manual classes to latest classlist
%   Alexis D. Fischer, February 2023

%% Input path names
clear;
class2useName ='D:\general\config\class2use_15';
NEWpath = 'D:\BuddInlet\manual_DiscreteSamples\';
OLDpath = 'D:\BuddInlet\manualEmilie\Discretsamples\';

%NEWpath = 'D:\BuddInlet\manual_AltSamples\';
%OLDpath = 'D:\BuddInlet\manualEmilie\Alternatesamples\';

addpath(genpath(NEWpath));
addpath(genpath(OLDpath));
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\'));
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\ifcb-analysis\'));

load([class2useName '.mat'], 'class2use');

%% Emilie's discrete and alternate samples

% copy manual files to merged manual folder and convert classes
manual_files = dir([OLDpath 'D*150.mat']); 
for i=1:length(manual_files)  
    copyfile([OLDpath manual_files(i).name],NEWpath);  
    baseFileName = manual_files(i).name;        
    fullFileName = fullfile(NEWpath, baseFileName);
    fprintf(1, 'Now converting classes in file %s\n', fullFileName);
    load(fullFileName,'class2use_auto','classlist','default_class_original','list_titles');
    
    %overwrite UCSC classes with NWFSC classes    
    [classlist(:,2)]=convert_classnum_Emilie2NWFSC(classlist(:,2)); 
    [classlist(:,3)]=convert_classnum_Emilie2NWFSC(classlist(:,3));     
    class2use_manual=class2use;
    if isempty(class2use_auto)
    else
        class2use_auto = class2use;
    end    
    
    save(fullFileName,'class2use_auto','class2use_manual','classlist','default_class_original','list_titles');
    clearvars class2use_auto class2use_manual classlist default_class_original list_titles baseFileName fullFileName; 
end

%% Brian_manual
% 
% % copy manual files to merged manual folder and convert classes
% manual_files = dir([OLDpath 'D*150.mat']); 
% for i=1:length(manual_files)  
%     copyfile([OLDpath manual_files(i).name],NEWpath);  
%     baseFileName = manual_files(i).name;        
%     fullFileName = fullfile(NEWpath, baseFileName);
%     fprintf(1, 'Now converting classes in file %s\n', fullFileName);
%     load(fullFileName,'class2use_auto','classlist','default_class_original','list_titles');
%     
%     %overwrite UCSC classes with NWFSC classes    
%     [classlist(:,2)]=convert_classnum_Brianmanual2NWFSC(classlist(:,2)); 
%     [classlist(:,3)]=convert_classnum_Brianmanual2NWFSC(classlist(:,3));     
%     class2use_manual=class2use;
%     if isempty(class2use_auto)
%     else
%         class2use_auto = class2use;
%     end    
%     
%     save(fullFileName,'class2use_auto','class2use_manual','classlist','default_class_original','list_titles');
%     clearvars class2use_auto class2use_manual classlist default_class_original list_titles baseFileName fullFileName; 
% end
% 

