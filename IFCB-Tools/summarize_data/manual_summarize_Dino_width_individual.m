function [acuminata,fortii,norvegica,parva,odiosa,rotundata,acuta,unknownDinophysis]=manual_summarize_Dino_width_individual(manualfile,feafile,micron_factor)
%function [large_PN,small_PN,Lcell1,Lcell2,Lcell3,Lcell4,Scell1,Scell2,Scell3,Scell4]=manual_summarize_Meso_width(manualfile,feafile,micron_factor)
%
% Alexis D. Fischer, NOAA, May 2023
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

[~,~,i1]=intersect(find(classlist(:,2)==find(strcmp('Dinophysis_acuminata',class2use_manual))),targets.roi_number); 
[~,~,i2]=intersect(find(classlist(:,2)==find(strcmp('Dinophysis_fortii',class2use_manual))),targets.roi_number); 
[~,~,i3]=intersect(find(classlist(:,2)==find(strcmp('Dinophysis_norvegica',class2use_manual))),targets.roi_number); 
[~,~,i4]=intersect(find(classlist(:,2)==find(strcmp('Dinophysis_parva',class2use_manual))),targets.roi_number); 
[~,~,i5]=intersect(find(classlist(:,2)==find(strcmp('Dinophysis_odiosa',class2use_manual))),targets.roi_number); 
[~,~,i6]=intersect(find(classlist(:,2)==find(strcmp('Dinophysis_rotundata',class2use_manual))),targets.roi_number); 
[~,~,i7]=intersect(find(classlist(:,2)==find(strcmp('Dinophysis_acuta',class2use_manual))),targets.roi_number); 
[~,~,i8]=intersect(find(classlist(:,2)==find(strcmp('Dinophysis',class2use_manual))),targets.roi_number); 

acuminata=targets.ESD(i1);
fortii=targets.ESD(i2);
norvegica=targets.ESD(i3);
parva=targets.ESD(i4);
odiosa=targets.ESD(i5);
rotundata=targets.ESD(i6);
acuta=targets.ESD(i7);
unknownDinophysis=targets.ESD(i8);

mlen=classlist(end,1); flen=targets.roi_number(end);
if mlen==flen
else
    disp([feafile(end-34:end-11) ': unequal rois in manual (' num2str(mlen) ') and feature files (' num2str(flen) ')'])
end
