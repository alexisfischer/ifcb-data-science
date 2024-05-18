function [] = copy_data_into_folders(in_dir_base, out_dir_data_base)
% copies raw IFCB data into Synology folder
% A.D. Fischer, March 2024

%Example inputs
%in_dir_base='C:\SFTP-BuddInlet\2024\'; % example input
%out_dir_data_base = 'F:\BuddInlet\data\2024\'; % example input

yeardir = dir([in_dir_base 'D*']);

for i = 1:length(yeardir)
    daystr=yeardir(i).name;
    daydir = dir([in_dir_base daystr '\' 'D*']);
    out_folder=[out_dir_data_base daystr '\'];
    if ~exist(out_folder, 'dir')
        mkdir(out_folder)
    end

    for j=1:length(daydir)
        in_dir_temp = [in_dir_base daystr '\' daydir(j).name];      
        if ~isfile([out_folder daydir(j).name])
            copyfile(in_dir_temp, out_folder);
        end
    end

end
end
