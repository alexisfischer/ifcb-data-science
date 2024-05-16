function [classcount_above_adhocthresh,classbiovol_above_adhocthresh,...
    ESD_above_adhocthresh, graylevel_above_adhocthresh] = ...
    summarize_TBclass_adhoc_BI(classfile, feafile, micron_factor, adhocthresh)
% Alexis D. Fischer, NOAA, January 2024

%% uncomment for troubleshooting
%i=1;
%clearvars *TB
%classfile=classfiles{i};
%feafile=feafiles{i};

load(classfile,'TBclass','TBclass_above_threshold','TBscores','class2useTB');
%disp(classfile)
classcount_above_adhocthresh = NaN(length(class2useTB),1);
classbiovol_above_adhocthresh = classcount_above_adhocthresh;
ESD_above_adhocthresh = classcount_above_adhocthresh;
graylevel_above_adhocthresh = classcount_above_adhocthresh;
feastruct = importdata(feafile);

% make sure same number of rois in feature and class files
len_f=height(feastruct.data);
len_c=length(TBclass);
if len_f == len_c
    %disp('successful matchup')
else
    disp([classfile(end-36:end-21) ' - Mismatch between number of ROIs in class(' num2str(len_c) ') and feature(' num2str(len_f) ') files!'])
end

ind = strcmp('Biovolume', feastruct.textdata);
targets.Biovolume = feastruct.data(:,ind)*micron_factor.^3;
ind = strcmp('EquivDiameter',feastruct.textdata);
targets.ESD = feastruct.data(:,ind)*micron_factor;
ind = strcmp('texture_average_gray_level',feastruct.textdata);
targets.GrayLevel = feastruct.data(:,ind);

%% get the TBclass labels with application of adhocthresh
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

%% sum up everything
for ii = 1:length(class2useTB)
    ind = strmatch(class2useTB(ii), TBclass_above_adhocthresh);
    classcount_above_adhocthresh(ii) = size(ind,1);
    classbiovol_above_adhocthresh(ii) = sum(targets.Biovolume(ind)); %sum biovolume
    ESD_above_adhocthresh(ii) = mean(targets.ESD(ind)); %take mean ESD
    graylevel_above_adhocthresh(ii) = mean(targets.GrayLevel(ind)); %take mean Gray Level
    
end
end

