function [Dc, Db, De, Dg, Mc, Mb, Me, Mg] = summarize_TBclass_dino_meso(classfile, feafile, micron_factor, adhocthresh)
% Alexis D. Fischer, NOAA, January 2024
% %% uncomment for troubleshooting
% i=2000;
% clearvars *TB
% classfile=classfiles{i};
% feafile=feafiles{i};

load(classfile,'TBclass','TBscores','class2useTB');
%disp(classfile)
feastruct = importdata(feafile);

%% make sure same number of rois in feature and class files
len_f=height(feastruct.data);
len_c=length(TBclass);
if len_f == len_c
    %disp('successful matchup')
else
    disp([classfile(end-36:end-21) ' - Mismatch between number of ROIs in class(' num2str(len_c) ') and feature(' num2str(len_f) ') files!'])
end

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

%%
ind = strcmp('Biovolume', feastruct.textdata);
targets.Biovolume = feastruct.data(:,ind)*micron_factor.^3;
ind = strcmp('EquivDiameter',feastruct.textdata);
targets.ESD = feastruct.data(:,ind)*micron_factor;
ind = strcmp('texture_average_gray_level',feastruct.textdata);
targets.GrayLevel = feastruct.data(:,ind);

idx=find(contains(TBclass_above_adhocthresh,'Dinophysis'));
    Dc=length(idx);
    Db = sum(targets.Biovolume(idx));
    De = mean(targets.ESD(idx));
    Dg = mean(targets.GrayLevel(idx));

idx=find(contains(TBclass_above_adhocthresh,'Mesodinium'));
    Mc=length(idx);
    Mb = sum(targets.Biovolume(idx));
    Me = mean(targets.ESD(idx));
    Mg = mean(targets.GrayLevel(idx));

end

