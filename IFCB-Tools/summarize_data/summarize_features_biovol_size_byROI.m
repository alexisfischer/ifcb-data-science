function [ ] = summarize_features_biovol_size_byROI(summarydir,roibasepath,feapath_base,yr)
%function [ ] = summarize_features_biovol_size_byROI(summarydir,roibasepath,feapath_base,yr)
% Inputs features files and outputs a summary file of biovolume and 
% equivalent spherical diameter
%
% A.D. Fischer, September 2022
%
% %Example inputs
% yr='2021'; %year of interest
% roibasepath = 'F:\BuddInlet\data\'; %location of raw data
% feapath_base = ['F:\BuddInlet\features\' yr '\']; %put in your featurepath by year
% summarydir = 'C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\IFCB-Data\BuddInlet\'; %where you want the summary file to go
% adhoc = 0.50; %adhoc score threshold of interest
% micron_factor=1/3.8; %pixel to micron conversion

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

save([summarydir 'eqdiam_biovol_' yr], 'filelist','filecomment','roi','ESD','runtype','matdate')

disp('Summary file stored here:')
disp([summarydir 'eqdiam_biovol_' yr])

end
