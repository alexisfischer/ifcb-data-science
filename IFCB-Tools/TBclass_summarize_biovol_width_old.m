function[classcountTB,classbiovolTB,classC_TB,classwidthTB,...
    classcountTB_above_optthresh,classbiovolTB_above_optthresh,classC_TB_above_optthresh,classwidthTB_above_optthresh,...
    classcountTB_above_adhocthresh,classbiovolTB_above_adhocthresh,classC_TB_above_adhocthresh,classwidthTB_above_adhocthresh]...
    =TBclass_summarize_biovol_width(classfile,feafile,adhocthresh,micron_factor,filepath)
%%
% Alexis D. Fischer, NOAA, September 2022

clearvars i j ii ind ind_diatom TB* t targets win roinum feastruct classwidth* classcount* classC*

% %Example inputs for testing
i=1523
classfile=classfiles{i};
feafile=feafiles{i};
filepath='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\';

load(classfile)

% if contains(char(classfile),'IFCB777') 
%     micron_factor=1/3.7695;
% elseif contains(char(classfile),'IFCB117') 
%     micron_factor=1/3.8617;
% elseif contains(char(classfile),'IFCB150') 
%     micron_factor=1/3.8149;
% end

classcountTB = NaN(length(class2useTB),1);
classcountTB_above_optthresh = classcountTB;
classcountTB_above_adhocthresh = classcountTB;
classbiovolTB = classcountTB;
classbiovolTB_above_optthresh = classcountTB;
classbiovolTB_above_adhocthresh = classcountTB;
classC_TB = classcountTB;
classC_TB_above_optthresh = classcountTB;
classC_TB_above_adhocthresh = classcountTB;
classwidthTB = classcountTB;
classwidthTB_above_optthresh = classcountTB;
classwidthTB_above_adhocthresh = classcountTB;
feastruct = importdata(feafile);
ind = strcmp('Biovolume', feastruct.textdata);
targets.Biovolume = feastruct.data(:,ind)*micron_factor.^3;
ind = strcmp('MinorAxisLength',feastruct.textdata);
targets.MinorAxisLength = feastruct.data(:,ind)*micron_factor;

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

[ind_diatom,~]=get_class_ind(class2useTB,'diatom',[filepath 'IFCB-Tools/convert_index_class/class_indices.mat']);
diatom_flag = zeros(size(class2useTB));
diatom_flag(ind_diatom) = 1;
cellC_diatom = biovol2carbon(targets.Biovolume,1);
cellC_notdiatom = biovol2carbon(targets.Biovolume,0);
for ii = 1:length(class2useTB)
    if diatom_flag(ii)
        cellC = cellC_diatom;
    else
        cellC = cellC_notdiatom;
    end
    ind = strmatch(class2useTB(ii), TBclass,'exact')
    classcountTB(ii) = size(ind,1)
    classbiovolTB(ii) = sum(targets.Biovolume(ind));
    classC_TB(ii) = sum(cellC(ind));
    classwidthTB(ii) = mean(targets.MinorAxisLength(ind));
    if exist('TBclass_above_threshold', 'var')
        ind = strmatch(class2useTB(ii), TBclass_above_threshold, 'exact');
        classcountTB_above_optthresh(ii) = size(ind,1);
        classbiovolTB_above_optthresh(ii) = sum(targets.Biovolume(ind));
        classC_TB_above_optthresh(ii) = sum(cellC(ind));
        classwidthTB_above_optthresh(ii) = mean(targets.MinorAxisLength(ind));        
    else 
        TBclass_above_threshold = NaN;
    end
    ind = strmatch(class2useTB(ii), TBclass_above_adhocthresh, 'exact');
    classcountTB_above_adhocthresh(ii) = size(ind,1);
    classbiovolTB_above_adhocthresh(ii) = sum(targets.Biovolume(ind));
    classC_TB_above_adhocthresh(ii) = sum(cellC(ind));
    classwidthTB_above_adhocthresh(ii) = mean(targets.MinorAxisLength(ind));        
    
end
disp('done')

end

