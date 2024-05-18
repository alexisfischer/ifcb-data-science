% A.D. Fischer, January 2023
clear;
Mac=1;
nameA='CCS_NOAA-OSU_v4';
nameB='CCS_v6';
nameC='CCS_v9';

if Mac
    basepath = '~/Documents/MATLAB/ifcb-data-science/';    
    filepath = [basepath 'IFCB-Data/Shimada/class/'];
    classidx=[basepath 'IFCB-Tools/convert_index_class/class_indices.mat'];
    figpath = [filepath 'Figs/'];
else
    basepath='C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\';
    filepath = [basepath 'IFCB-Data\Shimada\class\'];
    classidx=[basepath 'IFCB-Tools\convert_index_class\class_indices.mat'];    
    figpath = [filepath 'Figs\'];    
end
addpath(genpath(basepath));

load([filepath 'performance_classifier_' nameA],'all'); Ai=flipud(all); 
load([filepath 'performance_classifier_' nameB],'all'); Bi=flipud(all);
load([filepath 'performance_classifier_' nameC],'all'); C=flipud(all);

maxn=round(max([C.total]),-2);

% find and fill gaps, if they exist
A=C;
[~,ib]=ismember(C.class,Ai.class);
for i=1:length(ib)
    if ib(i)>0
        A.total(i)= Ai.total(ib(i));
        A.R(i)= Ai.R(ib(i));
        A.P(i)= Ai.P(ib(i));        
        A.F1(i)= Ai.F1(ib(i));                
    else
        A.total(i)=0;
        A.R(i)=NaN;
        A.P(i)=NaN;        
        A.F1(i)=NaN;                
    end
end

B=C;
[~,ib]=ismember(C.class,Bi.class);
for i=1:length(ib)
    if ib(i)>0
        B.total(i)= Bi.total(ib(i));
        B.R(i)= Bi.R(ib(i));
        B.P(i)= Bi.P(ib(i));        
        B.F1(i)= Bi.F1(ib(i));                
    else
        B.total(i)=0;
        B.R(i)=NaN;
        B.P(i)=NaN;        
        B.F1(i)=NaN;                
    end
end
clearvars Ai Bi i ib Mac


%% pcolor comparison
[C,idx]=sortrows(C,'F1','ascend');
A=A(idx,:); B=B(idx,:);
[~,class]=get_class_ind( C.class,'all',classidx);

figure('Units','inches','Position',[1 1 5 6],'PaperPositionMode','auto');

tiledlayout(1,1)
blankY=ones(size(B.F1));
blankX=ones(1,4);
C1 = [[A.F1,B.F1,C.F1,blankY];blankX];
pcolor(nexttile,C1)

set(gca,'ylim',[1 (length(class)+1)],'ytick',1.5:1:length(class)+.5,...
    'yticklabel',class,'xlim',[1 4],'xtick',1.5:1:4.5,'tickdir','out',...
    'xticklabel',{'NOAA-OSU (v4)','NOAA-OSU-UCSC (v6)','hybrid (v4 v6)'},'fontsize',10,'xaxislocation','top');
    xtickangle(30);

    colormap(parula); caxis([0.8 1]);
    h=colorbar('north'); %h.Label.String = label; h.Label.FontSize = 12;               
    hp=get(h,'pos'); 
    hp=[.2*hp(1) 1.08*hp(2) .6*hp(3) 0.7*hp(4)]; % [left, bottom, width, height].
    set(h,'pos',hp,'xaxisloc','top','fontsize',9); 
    h.Label.String = 'F1 score (out-of-bag)';    
    h.Label.FontSize = 11;  

    set(gcf,'color','w');
    exportgraphics(gcf,[figpath 'pcolor_CCS_classifier_compare.png'],'Resolution',100)    
hold off

%% plot comparison or Regional vs Local classifier
[C,idx]=sortrows(C,'F1','descend');
A=A(idx,:); B=B(idx,:);
[~,class]=get_class_ind( C.class,'all',classidx);

figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');

yyaxis left;
b=bar([A.F1 B.F1 C.F1],'Barwidth',1,'linestyle','none'); hold on
col=flipud(brewermap(3,'Set2')); 
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
hold on;
hline(.9,'k--'); hold on;
set(gca,'xlim',[0.5 (length(class)+.5)], 'xtick', 1:length(class), 'ylim',[0 1],...
    'xticklabel', class,'ycolor','k','tickdir','out');
ylabel('F1 score (out-of-bag)','color','k');

yyaxis right;
plot(.8:1:length(class),A.total,'k*',1:1:length(class),B.total,'k^',...
    1.2:1:length(class)+.2,C.total,'ks','Markersize',4); hold on
ylabel('total images in set');
set(gca,'ycolor','k', 'xtick', 1:length(class),'ylim',[0 maxn], 'xticklabel', class); hold on
legend('NOAA-OSU (v4)','NOAA-OSU-UCSC (v6)','hybrid (v4 v6)','Location','NorthOutside')
xtickangle(45);

set(gcf,'color','w');
    exportgraphics(gcf,[figpath 'F1_classifier_compare.png'],'Resolution',100)    
hold off
