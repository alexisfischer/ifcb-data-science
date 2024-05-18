% A.D. Fischer, January 2023
clear;
Mac=0;
%name='CCS_NOAA-OSU_v7';
%name='BI_NOAA-OSU_v2';
name='BI_NOAA_v15';

if Mac
    basepath = '~/Documents/MATLAB/ifcb-data-science/';    
    filepath = [basepath 'IFCB-Data/BuddInlet/class/'];
    classidx=[basepath 'IFCB-Tools/convert_index_class/class_indices.mat'];
    figpath = [filepath 'Figs/'];
else
    basepath='C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\';
    filepath = [basepath 'IFCB-Data\BuddInlet\class\'];
    classidx=[basepath 'IFCB-Tools\convert_index_class\class_indices.mat'];    
    figpath = [filepath 'Figs\'];    
end
addpath(genpath(basepath));

load([filepath 'performance_classifier_' name],'topfeat','maxthre','all',...
    'opt','c_all','c_opt','c_aht','aht','adhocthresh','trainingset');
disp(['optimal fx unclassified = ' num2str(opt.fxUnclass(end)) '']); 

[id,class]=get_class_ind( all.class,'all',classidx);

[~,classU]=get_class_ind( opt.class,'all',classidx);
opt(end,:)=[]; 
maxn=round(max([opt.total]),-2);

% if exist('thr')    
%     disp(['chosen threshold fx unclassified = ' num2str(thr.fxUnclass(end)) '']); thr(end,:)=[];
% end


%% plot stacked total in set
figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
col=[(brewermap(3,'Set2'));[.1 .1 .1]]; 
b = bar([trainingset.BI trainingset.NCC],'stack','linestyle','none','Barwidth',.7);
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
set(gca,'xlim',[0.5 (length(class)+.5)], 'xtick', 1:length(class), 'ylim',[0 maxn],...
    'xticklabel', class,'tickdir','out');
ylabel('total images in set'); hold on
lh=legend('BI','NCC','Location','NorthOutside');

set(gcf,'color','w');
exportgraphics(gca,[figpath 'TrainingSet_' name '.png'],'Resolution',300)    
hold off

% %% F1 scores Winner take all
% % plot bar Recall and Precision, sort by F1
% [all,~]=sortrows(all,'F1','descend');
% [~,class_s]=get_class_ind( all.class, 'all', classidx);
% 
% figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
% yyaxis left;
% b=bar([all.R all.P],'Barwidth',1,'linestyle','none'); hold on
% hline(.9,'k--');
% set(gca,'ycolor','k', 'xtick', 1:length(class_s), 'xticklabel', class_s); hold on
% ylabel('Performance');
% col=flipud(brewermap(2,'RdBu')); 
% for i=1:length(b)
%     set(b(i),'FaceColor',col(i,:));
% end  
% yyaxis right;
% plot(1:length(class_s),all.total,'k*'); hold on
% ylabel('total images in set');
% set(gca,'ycolor','k', 'xtick', 1:length(class_s),'ylim',[0 maxn], 'xticklabel', class_s); hold on
% legend('Sensitivity', 'Precision','Location','W')
% title(['Winner-takes-all: ' num2str(length(class)) ' classes ranked by F1 score'])
% xtickangle(45);
% 
% set(gcf,'color','w');
% exportgraphics(gca,[figpath 'F1score_all_' name '.png'],'Resolution',100)    
% hold off
% 
% %% Winner takes All
% %plot manual vs classifier checkerboard
% figure('Units','inches','Position',[1 1 7 6],'PaperPositionMode','auto');
% cplot = zeros(size(c_all)+1);
% cplot(1:length(class),1:length(class)) = c_all;
% total=[sum(c_all,2);0];
% fx_unclass=sum(c_all(:,end))./sum(total);   % what fraction of images went to unclassified?
% 
% C = bsxfun(@rdivide, cplot, total); C(isnan(C)) = 0;
% pcolor(C); col=flipud(brewermap([],'Spectral')); colormap([ones(1,3); col]); 
% set(gca,'ylim',[1 (length(class)+1)],'xlim',[1 (length(class)+1)],...
%     'ytick',1.5:1:(length(class)+.5), 'yticklabel', class,...
%     'xtick',1.2:1:(length(class)+.2), 'xticklabel',class)
% 
% axis square;  col=colorbar; caxis([0 1])
% colorTitleHandle = get(col,'Title');
% titleString = {'Fx of test'; 'images/class'};
% set(colorTitleHandle ,'String',titleString);
% 
% ylabel('Actual Classifications','fontweight','bold');
% xlabel('Predicted Classifications','fontweight','bold')
% title('Winner-takes-all');
% 
% set(gcf,'color','w');
% exportgraphics(gca,[figpath 'confusion_matrix_all_' name '.png'],'Resolution',100)    
% hold off

%% F1 scores Winner take all, above adhocthresh
% plot bar Recall and Precision, sort by F1
[aht,~]=sortrows(aht,'F1','descend');
[~,class_s]=get_class_ind( aht.class, 'all', classidx);

figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
yyaxis left;
b=bar([aht.R aht.P],'Barwidth',1,'linestyle','none'); hold on
hline(.9,'k--');
set(gca,'ycolor','k', 'xtick', 1:length(class_s), 'xticklabel', class_s); hold on
ylabel('Performance');
col=flipud(brewermap(2,'RdBu')); 
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
yyaxis right;
plot(1:length(class_s),aht.total,'k*'); hold on
ylabel('total images in set');
set(gca,'ycolor','k', 'xtick', 1:length(class_s),'ylim',[0 maxn], 'xticklabel', class_s); hold on
legend('Sensitivity', 'Precision','Location','W')
title(['adhocthreshold(' num2str(adhocthresh) '): ' num2str(length(class)) ' classes ranked by F1 score'])
xtickangle(45);

set(gcf,'color','w');
exportgraphics(gca,[figpath 'F1score_aht_' name '.png'],'Resolution',100)    
hold off

%% F1 scores OPT
% plot bar Recall and Precision, sort by F1
[opt,~]=sortrows(opt,'F1','descend');
[~,class_s]=get_class_ind( opt.class, 'all', classidx);

figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
yyaxis left;
b=bar([opt.R opt.P],'Barwidth',1,'linestyle','none'); hold on
hline(.9,'k--');
set(gca,'ycolor','k', 'xtick', 1:length(class_s), 'xticklabel', class_s); hold on
ylabel('Performance');
col=flipud(brewermap(2,'RdBu')); 
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
yyaxis right;
plot(1:length(class_s),opt.total,'k*'); hold on
ylabel('total images in set');
set(gca,'ycolor','k', 'xtick', 1:length(class_s),'ylim',[0 maxn], 'xticklabel', class_s); hold on
legend('Sensitivity', 'Precision','Location','W')
title(['Opt score threshold: ' num2str(length(class)) ' classes ranked by F1 score'])
xtickangle(45);

set(gcf,'color','w');
exportgraphics(gca,[figpath 'F1score_opt_' name '.png'],'Resolution',100)    
hold off

%% plot opt manual vs classifier checkerboard with unclassified
figure('Units','inches','Position',[1 1 7 6],'PaperPositionMode','auto');
cplot = zeros(size(c_opt)+1);
cplot(1:length(classU),1:length(classU)) = c_opt;
total=[sum(c_opt,2);0];

C = bsxfun(@rdivide, cplot, total); C(isnan(C)) = 0;
pcolor(C); col=flipud(brewermap([],'Spectral')); colormap([ones(4,3); col]); 
set(gca,'ylim',[1 (length(classU)+1)],'xlim',[1 (length(classU)+1)],...
    'ytick', 1.5:1:(length(classU)+.5), 'yticklabel', classU,...
    'xtick', 1.2:1:(length(classU)+.2), 'xticklabel',classU)
axis square;  col=colorbar; caxis([0 1])
colorTitleHandle = get(col,'Title');
titleString = {'Fx of test'; 'images/class'};
set(colorTitleHandle ,'String',titleString);

ylabel('Actual Classifications','fontweight','bold');
xlabel('Predicted Classifications','fontweight','bold')
title('Optimal score threshold');

set(gcf,'color','w');
exportgraphics(gca,[figpath 'confusion_matrix_opt_' name '.png'],'Resolution',100)    
hold off

%% F1 scores Chosen thresholds
% plot bar Recall and Precision, sort by F1
if exist('thr')
    [thr,~]=sortrows(thr,'F1','descend');
    [~,class_s]=get_class_ind( thr.class, 'all', classidx);
    
    figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
    yyaxis left;
    b=bar([thr.R thr.P],'Barwidth',1,'linestyle','none'); hold on
    hline(.9,'k--');
    set(gca,'ycolor','k', 'xtick', 1:length(class_s), 'xticklabel', class_s); hold on
    ylabel('Performance');
    col=flipud(brewermap(2,'RdBu')); 
    for i=1:length(b)
        set(b(i),'FaceColor',col(i,:));
    end  
    yyaxis right;
    plot(1:length(class_s),thr.total,'k*'); hold on
    ylabel('total images in set');
    set(gca,'ycolor','k', 'xtick', 1:length(class_s),'ylim',[0 maxn], 'xticklabel', class_s); hold on
    legend('Recall', 'Precision','Location','W')
    title(['Chosen thresholds: ' num2str(length(class)) ' classes ranked by F1 score'])
    xtickangle(45);
    
    set(gcf,'color','w');
    exportgraphics(gca,[figpath 'F1score_thr_' name '.png'],'Resolution',100)    
    hold off
else 
end

%% plot thr manual vs classifier checkerboard with unclassified
if exist('thr')
    figure('Units','inches','Position',[1 1 7 6],'PaperPositionMode','auto');
    cplot = zeros(size(c_thr)+1);
    cplot(1:length(classU),1:length(classU)) = c_thr;
    total=[sum(c_thr,2);0];
    
    C = bsxfun(@rdivide, cplot, total); C(isnan(C)) = 0;
    pcolor(C); col=flipud(brewermap([],'Spectral')); colormap([ones(4,3); col]); 
    set(gca,'ylim',[1 (length(classU)+1)],'xlim',[1 (length(classU)+1)],...
        'ytick', 1.5:1:(length(classU)+.5), 'yticklabel', classU,...
        'xtick', 1.2:1:(length(classU)+.2), 'xticklabel',classU)
    axis square;  col=colorbar; caxis([0 1])
    colorTitleHandle = get(col,'Title');
    titleString = {'Fx of test'; 'images/class'};
    set(colorTitleHandle ,'String',titleString);
    
    ylabel('Actual Classifications','fontweight','bold');
    xlabel('Predicted Classifications','fontweight','bold')
    title('Optimal score threshold');
    
    set(gcf,'color','w');
    exportgraphics(gca,[figpath 'confusion_matrix_thr_' name '.png'],'Resolution',100)    
    hold off
else 
end

