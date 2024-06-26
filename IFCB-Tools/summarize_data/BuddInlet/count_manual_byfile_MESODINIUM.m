function [total,small,large,size]=count_manual_byfile_MESODINIUM(manualfile,feafile,micron_factor)
%
% A.D. Fischer, May 2023
%
%% % % %Example inputs for testing
% i=161
% manualfile=manualfiles{i};
% feafile=feafiles{i};

load(manualfile,'class2use_manual','classlist')

feastruct = importdata(feafile);
ind = strcmp('EquivDiameter',feastruct.textdata); 
targets.ESD = feastruct.data(:,ind)*micron_factor;
ind = strcmp('roi_number',feastruct.textdata); 
targets.roi_number = feastruct.data(:,ind);

[~,~,ig]=intersect(find(classlist(:,2)==find(strcmp('Mesodinium',class2use_manual))),targets.roi_number); 
[~,~,ib]=intersect(find(classlist(:,2)==find(strcmp('Mesodinium_bad',class2use_manual))),targets.roi_number); 
total=length([ig;ib]);
size=[targets.ESD(ig);targets.ESD(ib)];

large=length(find(size>19));
small=total-large;

mlen=classlist(end,1); flen=targets.roi_number(end);
if mlen==flen
else
    disp([feafile(end-34:end-11) ': unequal rois in manual (' num2str(mlen) ') and feature files (' num2str(flen) ')'])
end
