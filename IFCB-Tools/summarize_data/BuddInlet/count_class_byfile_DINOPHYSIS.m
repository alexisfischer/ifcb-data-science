function [dinocount_above_adhocthresh, dinobiovol_above_adhocthresh,...
         dinoESD_above_adhocthresh, dinogray_above_adhocthresh,...
         smallcount_above_adhocthresh,largecount_above_adhocthresh]...
         = count_class_byfile_DINOPHYSIS(classfile, feafile, micron_factor, adhocthresh)
%% summarizes total Dinophysis cell count and biovolume, mean gray level, 
% mean size, and small and large size classes in each file
% A.D. Fischer, April 2024
%
% %uncomment for troubleshooting
% i=2200;
% clearvars *TB
% classfile=classfiles{i};
% feafile=feafiles{i};

load(classfile,'TBclass','TBscores','class2useTB');
%disp(classfile)

feastruct = importdata(feafile);
ind = strcmp('Biovolume', feastruct.textdata);
targets.Biovolume = feastruct.data(:,ind)*micron_factor.^3;
ind = strcmp('EquivDiameter',feastruct.textdata);
targets.ESD = feastruct.data(:,ind)*micron_factor;
ind = strcmp('texture_average_gray_level',feastruct.textdata);
targets.GrayLevel = feastruct.data(:,ind);

%%%% make sure same number of rois in feature and class files
len_f=height(feastruct.data);
len_c=length(TBclass);
if len_f == len_c
    %disp('successful matchup')
else
    disp([classfile(end-36:end-21) ' - Mismatch between number of ROIs in class(' num2str(len_c) ') and feature(' num2str(len_f) ') files!'])
end

%%%% get the TBclass labels with application of adhocthresh
if length(adhocthresh) == 1
    t = ones(size(TBscores))*adhocthresh;
else
    t = repmat(adhocthresh,length(TBclass),1);
end
win = (TBscores > t);
[i,j] = find(win);
if ~exist('TBclass', 'var')
    [~,TBclass] = max(TBscores');
    TBclass = class2useTB(TBclass)';
end
TBclass_above_adhocthresh = cell(size(TBclass));
TBclass_above_adhocthresh(:) = deal(repmat({'unclassified'},1,length(TBclass)));
TBclass_above_adhocthresh(i) = class2useTB(j); %most are correct his way (zero or one case above threshold)
ind = find(sum(win')>1); %now go back and fix the conflicts with more than one above threshold
for count = 1:length(ind)
    [~,ii] = max(TBscores(ind(count),:));
    TBclass_above_adhocthresh(ind(count)) = class2useTB(ii);
end

%%%% sum up Dinophysis
ind=find(contains(TBclass_above_adhocthresh,'Dinophysis'));
dinocount_above_adhocthresh = size(ind,1);
dinobiovol_above_adhocthresh = sum(targets.Biovolume(ind));
dinoESD_above_adhocthresh = mean(targets.ESD(ind));    
dinogray_above_adhocthresh = mean(targets.GrayLevel(ind));

%%%% split data into small and large Dinophysis
largecount_above_adhocthresh=length(find(targets.ESD(ind)>37));
smallcount_above_adhocthresh=dinocount_above_adhocthresh-largecount_above_adhocthresh;

end

