function [badfilelist] = findmanualfiles_w_highUnclassified(manualpath,fx,class2do)
%function [badfilelist] = findmanualfiles_w_highUnclassified(manualpath,fx,class2do)
%   Detailed explanation goes here
%find files with <fx of images annotated and none of them are class2do
% 
% clear
% %Example inputs;
% manualpath='~/Documents/MATLAB/bloom-baby-bloom/IFCB-Data/Shimada/manual/count_class_biovol_manual';
% fx=0.4;
% class2do='Pseudo-nitzschia';

load(manualpath,'class2use','classcount','filelist');

totalPN=sum(classcount(:,contains(class2use,class2do)),2);
total=sum(classcount,2);

idUN=find(classcount(:,strcmp('unclassified',class2use))>fx.*total);
idPN=find(totalPN==0);

idx=intersect(idPN,idUN);

newfilelist={filelist.name}';
badfilelist=newfilelist(idx);

end