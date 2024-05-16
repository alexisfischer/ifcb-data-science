function [] = remove_empty_blob_folders(blob_path)
% deletes empty blob folders that occur when 'start_blob_batch_user_training' errors and result in other problems
% Alexis D. Fischer, June 2019

%%%% Example inputs
%blob_path='F:\IFCB104\blobs\2019\';

folder = dir([blob_path 'D*']);

for i=1:length(folder)
    
    subfolder = dir([blob_path folder(i).name '\', 'D*']);
    for j=1:length(subfolder)
        if subfolder(j).isdir == true
            rmdir([blob_path folder(i).name '\' subfolder(j).name '\'],'s'); %remove empty folders            
        else
        end
    end

end

end