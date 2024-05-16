function [] = copy_data_into_folders_og(in_dir_base, out_dir_data_base)

% sorts raw IFCB data into folders according to datestamp
% Alexis Fischer, April 2018

% in_dir_base = 'D:\FTP-BuddInlet\'; % example input
% out_dir_data_base = 'D:\BuddInlet\data\2022\'; % example input

%in_dir_base = 'D:\FTP-BuddInlet\'; % example input
%out_dir_data_base = 'D:\BuddInlet\data\2022\'; % example input

daydir = dir([in_dir_base 'D2*']);

for i = 1:length(daydir)
    daystr=daydir(i).name(1:9);
    out_folder=[out_dir_data_base, daystr,'\'];
    if ~exist(out_folder, 'dir');
        mkdir(out_folder);
    end
    in_dir_temp = [in_dir_base daydir(i).name];
    
    if ~isfile([out_folder daydir(i).name]);
        copyfile(in_dir_temp, out_folder);
    end
end
end
