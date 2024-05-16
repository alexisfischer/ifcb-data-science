function [ ] = summarize_biovol_eqdiam_from_features(out_dir,roibasepath,feapath_base,yr)
%function [ ] = summarize_biovol_eqdiam_from_features(out_dir,roibasepath,feapath_base,yr)
%
% Inputs Features files and outputs a summary file of biovolume and equivalent spherical diameter
% Alexis D. Fischer, University of California - Santa Cruz, April 2018
%
%% Example inputs
clear;
yr='2021';
out_dir = 'C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\BuddInlet\';
roibasepath = 'F:\BuddInlet\data\'; %Where you raw data is
feapath_base = ['F:\BuddInlet\features\' yr '\']; %Put in your featurepath byyear

micron_factor = 1/3.8; %USER PUT YOUR OWN microns per pixel conversion
filelist = dir([feapath_base 'D*.csv']);
matdate = IFCB_file2date({filelist.name}); %calculate date
runtype=cell(length(matdate),1);
filecomment=runtype;
ESD=cell(length(matdate),1);
roi=ESD;

for i = 1:length(filelist)
    filename = filelist(i).name;
    disp(filename)
    hdrname = [roibasepath filename(2:5) filesep filename(1:9) filesep regexprep(filename,'_fea_v2.csv','.hdr')];     
    [~,file] = fileparts(filename);

    hdr=IFCBxxx_readhdr2(hdrname);
    runtype{i}=hdr.runtype;
    filecomment{i}=hdr.filecomment;    

    feastruct = importdata([feapath_base file '.csv'], ',');
    ind = strmatch('roi_number', feastruct.colheaders);
    roi(i) = {feastruct.data(:,ind)};

    ind = strmatch('EquivDiameter', feastruct.colheaders);
    ESD(i) = {feastruct.data(:,ind)*micron_factor};
    
    clearvars hdrname feastruct ind;
end

save([out_dir 'eqdiam_biovol_' yr], 'filelist','filecomment','roi','ESD','runtype','matdate')

disp('Summary file stored here:')
disp([out_dir 'eqdiam_biovol_' yr])

end
