%% convert Emilie's clunky classlist to a streamlined Dinophysis-only version
clear
class2useName ='D:\general\config\class2use_Emilie_v2';
manualpath = 'D:\BuddInlet\manualEmilie_v2\';
load([class2useName '.mat'], 'class2use');

addpath(genpath(manualpath));
manual_files = dir([manualpath 'D*.mat']); %only select manual files

for i=1:length(manual_files)      
    baseFileName = manual_files(i).name;        
    fullFileName = fullfile(manualpath, baseFileName);
    fprintf(1, 'Now converting classes in file %s\n', fullFileName);
    load(fullFileName,'class2use_auto','classlist','default_class_original','list_titles');
    
    [classlist(:,2)]=change_Em_classlist(classlist(:,2)); 
     class2use_manual=class2use;
%     if isempty(class2use_auto)
%     else
%         class2use_auto = class2use;
%     end    
    
    save(fullFileName,'class2use_auto','class2use_manual','classlist','default_class_original','list_titles');
    clearvars class2use_auto class2use_manual classlist default_class_original list_titles baseFileName fullFileName; 
end

fprintf('Finished converting Emilie classes');

%% make sure didn't mess it up
ifcbdir='D:\BuddInlet\'; 
manualpath = 'D:\BuddInlet\manualEmilie\';
summarydir='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\BuddInlet\';

summarize_cells_from_manual(manualpath,[ifcbdir 'data\'],[summarydir 'Emilie\']); 
