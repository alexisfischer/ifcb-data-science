%% plot_HakeTest_performance 
% requires input from classifier_oob_analysis_hake
clear;
Mac=0;
name='CCS_v16';

if Mac
    basepath = '~/Documents/MATLAB/bloom-baby-bloom/';    
    filepath = [basepath 'IFCB-Data/Shimada/threshold/' name '/'];
    classidx=[basepath 'IFCB-Tools/convert_index_class/class_indices.mat'];
    figpath = [filepath 'Figs/'];
else
    basepath='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\';
    filepath = [basepath 'IFCB-Data\Shimada\threshold\' name '\'];
    classidx=[basepath 'IFCB-Tools\convert_index_class\class_indices.mat'];    
    figpath = [filepath 'Figs\'];    
end
addpath(genpath(filepath));

class2do_full='Pseudo-nitzschia_large_1cell,Pseudo-nitzschia_small_1cell';

load([filepath 'HakeTestSet_performance_' name ''],'Nclass','maxthre','aht',...
    'adhocthresh','threlist','opt','all','class','Precision','Recall','F1score','tPos','fNeg','fPos');
testtotal=max(opt.total);

%% plot winner-takes-all: Recall and Precision, sort by F1
[all,~]=sortrows(all,'F1','descend');
[all,~]=sortrows(all,'total','descend');
[~,class_s]=get_class_ind( all.class, 'all', classidx);

figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
yyaxis left;
b=bar([all.R all.P],'Barwidth',1,'linestyle','none'); hold on
hline(.9,'k--');
vline((find(all.total<testtotal,1)-.5),'k-')
set(gca,'ycolor','k', 'xtick', 1:length(class_s), 'xticklabel', class_s); hold on
ylabel('Performance');
col=flipud(brewermap(2,'RdBu')); 
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
yyaxis right;
plot(1:length(class_s),all.total,'k*'); hold on
ylabel('total images in test set');
set(gca,'ycolor','k', 'xtick', 1:length(class_s),'ylim',[0 max(all.total)], 'xticklabel', class_s); hold on
legend('Recall', 'Precision','Location','W')
title([num2str(max(all.total)) ' image Hake test set: ' num2str(length(all.class)) ' classes ranked by F1 score (Winner-takes-all)'])
xtickangle(45);

set(gcf,'color','w');
exportgraphics(gca,[figpath 'HakeTest_F1score_all_' name '.png'],'Resolution',100)    
hold off

%% plot adhocthreshold: Recall and Precision, sort by F1
[aht,~]=sortrows(aht,'F1','descend');
[aht,~]=sortrows(aht,'total','descend');
[~,class_s]=get_class_ind( aht.class, 'all', classidx);

figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
yyaxis left;
b=bar([aht.R aht.P],'Barwidth',1,'linestyle','none'); hold on
hline(.9,'k--');
vline((find(aht.total<testtotal,1)-.5),'k-')
set(gca,'ycolor','k', 'xtick', 1:length(class_s), 'xticklabel', class_s); hold on
ylabel('Performance');
col=flipud(brewermap(2,'RdBu')); 
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
yyaxis right;
plot(1:length(class_s),aht.total,'k*'); hold on
ylabel('total images in test set');
set(gca,'ycolor','k', 'xtick', 1:length(class_s),'ylim',[0 max(aht.total)], 'xticklabel', class_s); hold on
legend('Recall', 'Precision','Location','W')
title([num2str(max(aht.total)) ' image Hake test set: ' num2str(length(aht.class)) ' classes ranked by F1 score (ad hoc threshold=' num2str(adhocthresh) ')'])
xtickangle(45);

set(gcf,'color','w');
exportgraphics(gca,[figpath 'HakeTest_F1score_aht_' name '.png'],'Resolution',100)    
hold off

%% plot OPT: Recall and Precision, sort by F1
[opt,~]=sortrows(opt,'F1','descend');
[opt,~]=sortrows(opt,'total','descend');
[~,class_s]=get_class_ind( opt.class, 'all', classidx);

figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
yyaxis left;
b=bar([opt.R opt.P],'Barwidth',1,'linestyle','none'); hold on
hline(.9,'k--');
vline((find(opt.total<testtotal,1)-.5),'k-')
set(gca,'ycolor','k', 'xtick', 1:length(class_s), 'xticklabel', class_s); hold on
ylabel('Performance');
col=flipud(brewermap(2,'RdBu')); 
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
yyaxis right;
plot(1:length(class_s),opt.total,'k*'); hold on
ylabel('total images in test set');
set(gca,'ycolor','k', 'xtick', 1:length(class_s),'ylim',[0 max(opt.total)], 'xticklabel', class_s); hold on
legend('Recall', 'Precision','Location','W')
title([num2str(max(opt.total)) ' image Hake test set: ' num2str(length(opt.class)) ' classes ranked by F1 score (opt score threshold)'])
xtickangle(45);

set(gcf,'color','w');
exportgraphics(gca,[figpath 'HakeTest_F1score_opt_' name '.png'],'Resolution',100)    
hold off

%% plot FP and FN as function of threshold
[~,label]=get_class_ind(class2do_full, 'all',classidx);

figure('Units','inches','Position',[1 1 4 4],'PaperPositionMode','auto');
plot(threlist,fPos(i,:),'-',threlist,fNeg(i,:),'-');hold on
vline(maxthre(i),'k--','opt threshold'); hold on
xlabel('threshold')
ylabel('Proportion of images')
title({char(label);['(Dataset: Hake, ' num2str(Nclass(i)) ' images)']})

legend('False Positives','False Negatives','location','NW'); legend boxoff

if contains(class2do_full,',')
    label=[extractBefore(class2do_full,',') '_grouped'];
else
    label=class2do_full;
end

set(gcf,'color','w');
exportgraphics(gca,[figpath 'Threshold_eval_' label '.png'],'Resolution',100)    
hold off
