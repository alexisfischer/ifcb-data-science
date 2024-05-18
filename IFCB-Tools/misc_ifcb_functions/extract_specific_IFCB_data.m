function [data] = extract_specific_IFCB_data(classidxpath,class2useTB,classbiovolTB,classcountTB,ml_analyzedTB,target,dataformat)
% Extracts correct data format ('carbonml' 'biovolml' 'cellsml) for target
% data (either a classifier class or a grouping, like 'diatom')
% A.D. Fischer, May 2022

% %Example Inputs
% classidxpath = '~/Documents/MATLAB/bloom-baby-bloom/IFCB-Tools/convert_index_class/class_indices.mat';
% target= 'Akashiwo'; %'diatom' 'all' 'dinoflagellate' 'unclassified' 'otherphyto' 'nonliving' 'nanoplankton' 'zooplankton' 'larvae'
% dataformat='cells'; %'carbon' 'biovol' 'cells';
% class2useTB
% classbiovolTB
% classcountTB
% ml_analyzedTB

% find index
idx=(strcmp(target, class2useTB));

if ~any(idx,'all')
   [idx,~] = get_class_ind(class2useTB,target,classidxpath);
end

% find associated data
if strcmp(dataformat,'carbon') % Use Carbon (ugC/l)
    [ind_diatom,~] = get_class_ind(class2useTB,'diatom',classidxpath);
    [pgCcell] = biovol2carbon(classbiovolTB,ind_diatom); 
    ugCml=NaN*pgCcell;
    for i=1:length(pgCcell)
        ugCml(i,:)=.001*(pgCcell(i,:)./ml_analyzedTB(i)); %convert from pg/cell to pg/mL to ug/L 
    end  
    data = sum(ugCml(:,idx),2);

elseif strcmp(dataformat,'biovol') %Use Biovolume (cubic microns/cell/ml)
    data = sum(classbiovolTB(:,idx),2)./ml_analyzedTB;

elseif strcmp(dataformat,'cells')
    data = sum(classcountTB(:,idx),2)./ml_analyzedTB;    
        
end