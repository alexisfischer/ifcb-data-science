%% Threshold tuning
% A.D. Fischer, February 2023
clear;
ifcbdir='D:\Shimada\'; 
summarydir='C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\IFCB-Data\Shimada\';
addpath(genpath(ifcbdir));
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\'));
yrrange = 2019:2021;
classifiername='CCS_v9';

classifier='D:\general\classifier\summary\Trees_CCS_v9';
yr='2019';
start_classify_batch_user_training(classifier,[ifcbdir 'features\' yr '\'],[ifcbdir 'class\' classifiername '\class' yr '_v1\']);
yr='2021';
start_classify_batch_user_training(classifier,[ifcbdir 'features\' yr '\'],[ifcbdir 'class\' classifiername '\class' yr '_v1\']);

% %% Step 1) Make a biovolume summary file from manual results
% summarize_biovol_from_manual([ifcbdir 'manual\'],[summarydir 'manual\'],[ifcbdir 'data\'],[ifcbdir 'features\'],1/3.4)
%  
% %% Step 2) Make summary file of counts for thresholds 0.1 to 1 for all classes
load([summarydir 'class\performance_classifier_' classifiername],'all'); %get classlist from classifier
classlist = all.class;
for i=1:length(classlist)
    countcells_allTB_class_by_threshold(char(classlist(i)),yrrange,[ifcbdir 'class\' classifiername '\classxxxx_v1\'],...
        [summarydir 'threshold\' classifiername '\'],[ifcbdir 'data\'])
end

%% Step 3) Manually evaluate the best threshold to use for your class files
% evaluate_thresholds_byclass

%% Step 4) Manually plot your data against annotations with chosen thresholds
% TB_plots_versus_Manual_NOAA

%% Step 5) Determine classifier performance w chosen thresholds
% classifier_oob_analysis_threshold