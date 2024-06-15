function [] = sort_data_into_folders(in_dir_base, out_dir_data_base)

% sorts raw IFCB data into folders according to datestamp
% Alexis Fischer, April 2018

% in_dir_base = 'F:\IFCB104\data\raw\'; % example input
% out_dir_data_base = 'F:\IFCB104\data\2018\'; % example input

daydir = dir([in_dir_base 'D*']);

for ii = 1:length(daydir)
    daystr=daydir(ii).name(1:9);
    out_folder=[out_dir_data_base, daystr,'\'];
    if ~exist(out_folder, 'dir')
        mkdir(out_folder)
    end
    in_dir_temp = [in_dir_base daydir(ii).name];
    movefile(in_dir_temp, out_folder);
end
end
