%% Corrects hdr files that have incorrect filecomments for a date range
%%change data [e.g. initial conditions] in model file
%scans for the specified SearchString in the InputFile and replaces it 
% with the ReplaceString in the OutputFile. If the same file is specified 
% as both the input and output file, the file is overwritten.
% Alexis Fischer
clear
roibasepath='C:\SFTP-BuddInlet\';
filelist = dir([roibasepath 'D*.hdr']);

matdate = IFCB_file2date({filelist.name});
dt=datetime(matdate,'ConvertFrom','datenum');

fixID=find(dt>=datetime(2022,06,30,19,58,22) & dt<=datetime(2022,07,05,17,21,34));
% remove incorrect BS_trigger labels from filecomment
% dates when I accidentally forgot to turn off file comment!

for i=1:length(fixID)
    InputFile=[roibasepath filelist(fixID(i)).name];
    OutputFile=[roibasepath filelist(fixID(i)).name];
    SearchString='FileComment: BS_trigger';
    ReplaceString='FileComment: ';
    
    fid = fopen(InputFile);
    data = textscan(fid, '%s', 'Delimiter', '\n', 'CollectOutput', true);
    fclose(fid);
    % modify the cell array
    % find the position where changes need to be applied and insert new data
    for I = 1:length(data{1})
        tf = strcmp(data{1}{I}, SearchString); % search for this string in the array
        if tf == 1
            data{1}{I} = ReplaceString; % replace with this string
        end
    end
    % write the modified cell array into the text file
    fid = fopen(OutputFile, 'w');
    for I = 1:length(data{1})
        fprintf(fid, '%s\n', char(data{1}{I}));
    end
    fclose(fid);
end