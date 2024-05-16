function [PNcount_above_optthresh,PNcount,...
    opt_cell1,opt_cell2,opt_cell3,opt_cell4,...
    wta_cell1,wta_cell2,wta_cell3,wta_cell4]=...
    count_class_byfile_PNchains(classfile,feafile,micron_factor)
%
% A.D. Fischer, April 2023
%%
% % % %Example inputs for testing
% i=1; %122
% classfile=classfiles{i}
% feafile=feafiles{i};

load(classfile,'roinum','TBclass','TBclass_above_threshold')

% if contains(char(classfile),'IFCB777') 
%     micron_factor=1/3.7695;
% elseif contains(char(classfile),'IFCB117') 
%     micron_factor=1/3.8617;
% elseif contains(char(classfile),'IFCB150') 
%     micron_factor=1/3.8149;
% end

feastruct = importdata(feafile);
ind = strcmp('MinorAxisLength',feastruct.textdata); targets.MinorAxisLength = feastruct.data(:,ind)*micron_factor;
ind = strcmp('roi_number',feastruct.textdata); targets.roi_number = feastruct.data(:,ind);

opt_cell1=targets.MinorAxisLength(contains(TBclass_above_threshold,'1cell'))';
opt_cell2=targets.MinorAxisLength(contains(TBclass_above_threshold,'2cell'))';
opt_cell3=targets.MinorAxisLength(contains(TBclass_above_threshold,'3cell'))';
opt_cell4=targets.MinorAxisLength(contains(TBclass_above_threshold,'4cell'))';
PNcount_above_optthresh=size(opt_cell1,2)+2*size(opt_cell2,2)+3*size(opt_cell3,2)+4*size(opt_cell4,2);

wta_cell1=targets.MinorAxisLength(contains(TBclass,'1cell'))';
wta_cell2=targets.MinorAxisLength(contains(TBclass,'2cell'))';
wta_cell3=targets.MinorAxisLength(contains(TBclass,'3cell'))';
wta_cell4=targets.MinorAxisLength(contains(TBclass,'4cell'))';
PNcount=size(wta_cell1,2)+2*size(wta_cell2,2)+3*size(wta_cell3,2)+4*size(wta_cell4,2);

clen=roinum(end); flen=targets.roi_number(end);
if clen==flen
else
    disp([feafile(26:41) ': unequal rois in class (' num2str(clen) ') and feature files (' num2str(flen) ')'])
end
%%
end

