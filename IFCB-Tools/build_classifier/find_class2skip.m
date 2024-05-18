function [class2skip] = find_class2skip(class2useName,TopClass)
%find_class2skip Finds class2skip from an input of the classes that you
%want in your training set
%   can use before compile_train_features_PNW
%  A.D Fischer, September 2021

%%
% % Example inputs
% TopClassName = 'C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\IFCB-Data\Shimada\manual\TopClasses';
% class2useName = 'D:\general\config\class2use_12'; %classlist to subtract "class" from

load([class2useName '.mat'],'class2use');

TopClass=sort(TopClass)';
[~,~,ib] = intersect(TopClass,class2use,'stable'); %find difference
num=(1:1:length(class2use))';
ia=setdiff(num,ib);
class2skip_all=(class2use(ia));
class2skip=unique(class2skip_all); %remove extra unclassified

clearvars ia ib num  class2skip_all

end

