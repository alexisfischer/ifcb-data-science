function [ ] = find_tagged_samples_hdr( tag, datapath, summarydir)
%function [ ] = find_discrete_samples( datapath, summarydir)
%
% finds discrete samples that have labels BS_trigger, Fl_trigger or FL_trigger
% excludes data D20220518T190328_IFCB150 through  D20220520T163514_IFCB150
% 
% Alexis D. Fischer, NOAA, June 2022
%%
%Example inputs:
datapath = 'C:\SFTP-BuddInlet\'; %where to access data (hdr files)
summarydir='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\BuddInlet\';
tag='trigger';

addpath(genpath(datapath)); % add new data to search path
addpath(genpath(summarydir)); % add new data to search path

%make sure input paths end with filesep
if ~isequal(datapath(end), filesep)
    datapath = [datapath filesep];
end

filelist = dir([datapath 'D*.hdr']);

%calculate date
matdate = IFCB_file2date({filelist.name});
dt=datetime(matdate,'ConvertFrom','datenum');

runtype={filelist.name}';
filecomment={filelist.name}';
for i = 1:length(filelist)
    fullfilename = [datapath filelist(i).name];
    disp(fullfilename);
    hdr=IFCBxxx_readhdr2(fullfilename);
    runtype{i}=hdr.runtype;
    filecomment{i}=hdr.filecomment;   
end

% % remove incorrect BS_trigger labels from filecomment
% % dates when I accidentally forgot to turn off file comment!
% idx=dt>=datetime(2022,05,18,19,03,28) & dt<=datetime(2022,05,20,16,35,14);
% filecomment(idx)={' '};

% get filelist of discrete samples
idx=contains(filecomment,tag);
filename_discrete={filelist(idx).name}';
triggertype=filecomment(idx);

save([summarydir 'DiscreteSampleIDs_BuddInlet'],'filename_discrete','triggertype');



