function [large_PN,small_PN,Lcell1,Lcell2,Lcell3,Scell1,Scell2,Scell3]=manual_summarize_PN_width(manualfile,feafile,micron_factor)
%function [large_PN,small_PN,Lcell1,Lcell2,Lcell3,Lcell4,Scell1,Scell2,Scell3,Scell4]=manual_summarize_PN_width(manualfile,feafile,micron_factor)
%
% Alexis D. Fischer, NOAA, May 2023
%
%% % % %Example inputs for testing
%i=304
%manualfile=manualfiles{i};
%feafile=feafiles{i};

load(manualfile,'class2use_manual','classlist')

feastruct = importdata(feafile);
ind = strcmp('MinorAxisLength',feastruct.textdata); targets.MinorAxisLength = feastruct.data(:,ind)*micron_factor;
ind = strcmp('roi_number',feastruct.textdata); targets.roi_number = feastruct.data(:,ind);

[~,~,it]=intersect(find(classlist(:,2)==find(strcmp('Pseudo-nitzschia_large_1cell',class2use_manual))),targets.roi_number); Lcell1=targets.MinorAxisLength(it)';
[~,~,it]=intersect(find(classlist(:,2)==find(strcmp('Pseudo-nitzschia_large_2cell',class2use_manual))),targets.roi_number); Lcell2=targets.MinorAxisLength(it)';
[~,~,it]=intersect(find(classlist(:,2)==find(strcmp('Pseudo-nitzschia_large_3cell,Pseudo-nitzschia_large_4cell,Pseudo-nitzschia_small_3cell,Pseudo-nitzschia_small_4cell',class2use_manual))),targets.roi_number); Lcell3=targets.MinorAxisLength(it)';
large_PN=size(Lcell1,2)+2*size(Lcell2,2)+3*size(Lcell3,2);

[~,~,it]=intersect(find(classlist(:,2)==find(strcmp('Pseudo-nitzschia_small_1cell',class2use_manual))),targets.roi_number); Scell1=targets.MinorAxisLength(it)';
[~,~,it]=intersect(find(classlist(:,2)==find(strcmp('Pseudo-nitzschia_small_2cell',class2use_manual))),targets.roi_number); Scell2=targets.MinorAxisLength(it)';
[~,~,it]=intersect(find(classlist(:,2)==find(strcmp('Pseudo-nitzschia_large_3cell,Pseudo-nitzschia_large_4cell,Pseudo-nitzschia_small_3cell,Pseudo-nitzschia_small_4cell',class2use_manual))),targets.roi_number); Scell3=targets.MinorAxisLength(it)';
small_PN=size(Scell1,2)+2*size(Scell2,2)+3.5*size(Scell3,2);

mlen=classlist(end,1); flen=targets.roi_number(end);
if mlen==flen
else
    disp([feafile(26:41) ': unequal rois in manual (' num2str(mlen) ') and feature files (' num2str(flen) ')'])
end

