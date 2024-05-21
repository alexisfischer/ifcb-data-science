function[classcountTB,classbiovolTB,classC_TB,classcountTB_above_optthresh,classbiovolTB_above_optthresh,classC_TB_above_optthresh]=count_class_cells_biovol_carbon_byfile(classfile,feafile,micron_factor,classindexpath)
%function[classcountTB,classbiovolTB,classC_TB,classcountTB_above_optthresh,classbiovolTB_above_optthresh,classC_TB_above_optthresh]=count_class_cells_biovol_carbon_byfile(classfile,feafile,micron_factor,classindexpath)
% loads class and feature files corresponding to one sample and sums up 
% cells, biovolume, and carbon for two different classifier outputs 
% (winner takes all and opt score threshold)
% Note: for carbon calculations, large diatoms are are weighted higher per
% biovol2carbon function
%
% A.D. Fischer, September 2022
%
%% uncomment for troubleshooting
%clearvars i j ii ind ind_diatom TB* t targets win roinum feastruct classcount* classC* cell*
% i=1523
% classfile=classfiles{i};
% feafile=feafiles{i};
% filepath='C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\';

load(classfile)

% % applies different pixel to micron conversion for different ifcbs
% if contains(char(classfile),'IFCB777') 
%     micron_factor=1/3.7695;
% elseif contains(char(classfile),'IFCB117') 
%     micron_factor=1/3.8617;
% elseif contains(char(classfile),'IFCB150') 
%     micron_factor=1/3.8149;
% end

classcountTB = NaN(length(class2useTB),1);
classcountTB_above_optthresh = classcountTB;
classbiovolTB = classcountTB;
classbiovolTB_above_optthresh = classcountTB;
classC_TB = classcountTB;
classC_TB_above_optthresh = classcountTB;
feastruct = importdata(feafile);
ind = strcmp('Biovolume', feastruct.textdata);
targets.Biovolume = feastruct.data(:,ind)*micron_factor.^3;

[ind_diatom,~]=get_class_ind(class2useTB,'diatom',classindexpath);
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
    ind = strmatch(class2useTB(ii), TBclass,'exact');
    classcountTB(ii) = size(ind,1);
    classbiovolTB(ii) = sum(targets.Biovolume(ind));
    classC_TB(ii) = sum(cellC(ind));
    if exist('TBclass_above_threshold', 'var')
        ind = strmatch(class2useTB(ii), TBclass_above_threshold, 'exact');
        classcountTB_above_optthresh(ii) = size(ind,1);
        classbiovolTB_above_optthresh(ii) = sum(targets.Biovolume(ind));
        classC_TB_above_optthresh(ii) = sum(cellC(ind));
    else 
        TBclass_above_threshold = NaN;
    end     
    
end

end
