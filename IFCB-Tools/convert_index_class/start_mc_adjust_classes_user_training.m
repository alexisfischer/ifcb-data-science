function [ ] = start_mc_adjust_classes_user_training(class2useName, manualpath)
%function [ ] = start_mc_adjust_classes_user_training(class2useName, manualpath)
%For example:
%start_mc_adjust_classes_user_training('C:\training\config\class2use', 'C:\training\manual\2014\')
%IFCB image processing: replace class2use in annotated files
%McLane Research Labs, Jul 2019
%
%example input variables
% class2useName='D:\Shimada\config\class2use_6'; %USER file containing new class2use (full path)
% manualpath='D:\Shimada\manual\'; % manual annotation file location

class2usefile = load([class2useName '.mat'], 'class2use');
manualdir = dir([manualpath 'D*']);
for ii = 1:length(manualdir)
    manualfile = open([manualpath manualdir(ii).name]);
    manualfile.class2use_manual = class2usefile.class2use;
    if ~isempty(manualfile.class2use_auto)
        manualfile.class2use_auto = transpose(class2usefile.class2use);
    end
    save([manualpath manualdir(ii).name], '-struct', 'manualfile');
end
end
