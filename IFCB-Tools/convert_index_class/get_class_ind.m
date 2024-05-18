function [ ia, class_label ] = get_class_ind( class2use, target, file)
%function [ ia, class_label ] = get_class_ind( class2use, target ,filepath)
% class list specific to return of indices that correspond to phytoplankton
%  Alexis D. Fischer, NOAA, May 2022

% %Example inputs
% class2use = {'Ditylum';'Entomoneis';'Eucampia';'Flagilaria';'Guinardia';'Gyrosigma';...
%     'Helicotheca';'Hemiaulus';'Lauderia';'Leptocylindrus';'Licmophora';...
%     'Lioloma';'Lithodesmium';'Melosira';'Nitzschia';'Odontella'};
%file = '~/Documents/MATLAB/ifcb-data-science/IFCB-Tools/convert_index_class/class_indices.mat';
%target= 'all';%'diatom'; %'all' 'dinoflagellate' 'unclassified' 'otherphyto' 'nonliving' 'nanoplankton' 'zooplankton' 'larvae'

load(file,'class','class_proper','category');

if strcmp('all',target)
    [~,ia,ib]=intersect(class2use, class,'stable');
    class_label=class_proper(ib);
else
    ind_cat=strcmp(target, category);
    class2get=class(ind_cat); %indices of that category
    classp=class_proper(ind_cat); %indices of corresponding class_label of that category
    
    [~,ia,ib] = intersect(class2use, class2get,'stable'); %indices of where target intersects w input class list
    class_label=classp(ib);
end
