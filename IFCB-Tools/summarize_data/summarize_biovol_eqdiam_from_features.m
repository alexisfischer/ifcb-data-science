function [ ] = summarize_biovol_eqdiam_from_features(out_dir,roibasepath,feapath_base,yr)
%function [ ] = summarize_biovol_eqdiam_from_features(out_dir,roibasepath,feapath_base,yr)
%
% Inputs Features files and outputs a summary file of biovolume and equivalent spherical diameter
% Alexis D. Fischer, University of California - Santa Cruz, April 2018
%
%% Example inputs
out_dir = 'C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\BuddInlet\sizes\';
roibasepath = 'F:\BuddInlet\data\'; %Where you raw data is
feapath_base = 'F:\BuddInlet\features\2023\'; %Put in your featurepath byyear

micron_factor = 1/3.8; %USER PUT YOUR OWN microns per pixel conversion
filelist = dir([feapath_base 'D*.csv']);
matdate = IFCB_file2date({filelist.name}); %calculate date
ml_analyzed = NaN(length(filelist),1);

for i = 1:length(filelist)

    filename = filelist(i).name;
    disp(filename)
    hdrname = [roibasepath filename(2:5) filesep filename(1:9) filesep regexprep(filename,'_fea_v2.csv','.hdr')];
    ml_analyzed(i) = IFCB_volume_analyzed(hdrname);
     
    [~,file] = fileparts(filename);
    feastruct = importdata([feapath_base file '.csv'], ',');
    ind = strmatch('Biovolume', feastruct.colheaders);
    biovol = feastruct.data(:,ind);
    ind = strmatch('roi_number', feastruct.colheaders);
    roi = feastruct.data(:,ind);
    ind = strmatch('EquivDiameter', feastruct.colheaders);
    eqdiam = feastruct.data(:,ind);
    % ind = strmatch('MinorAxisLength', feastruct.colheaders);
    % minoraxislength = feastruct.data(:,ind);
    
    BiEq(i).filename=filename;
    BiEq(i).matdate=matdate(i);
    BiEq(i).ml_analyzed=ml_analyzed(i);    
    BiEq(i).roi=roi;
    %BiEq(i).minoraxislength=minoraxislength;    
    BiEq(i).eqdiam=eqdiam*micron_factor;
    BiEq(i).biovol=biovol*micron_factor.^3;    
    
    clearvars roi eqdiam biovol hdrname feastruct ind;
end

note1 = 'Biovolume: cubed micrometers';
note2= 'Equivalent spherical diameter: micrometers';
save([out_dir 'eqdiam_biovol_' yr], 'BiEq', 'note1', 'note2')

disp('Summary file stored here:')
disp([out_dir 'eqdiam_biovol_' yr])



end
