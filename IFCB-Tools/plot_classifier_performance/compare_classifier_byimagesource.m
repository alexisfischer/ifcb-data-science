%% map underway environmental data along CCS
% A.D. Fischer, February 2022
clear;
basepath = '~/Documents/MATLAB/ifcb-data-science/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(basepath)); % add new data to search path
classidx=[basepath 'IFCB-Tools/convert_index_class/class_indices.mat'];
figpath=[basepath 'IFCB-Data/Shimada/class/Figs/'];
N=load([basepath 'IFCB-Data/Shimada/class/performance_classifier_CCS_NOAA_v1'],'opt');
A=load([basepath 'IFCB-Data/Shimada/class/performance_classifier_CCS_NOAA-OSU_v1'],'opt');

%%CCS_NOAA-OSU_v1

N.opt(end,:)=[]; A.opt(end,:)=[]; 

%match up classes
[~,ia,~]=intersect(A.opt.class,N.opt.class);
N.new=A.opt;
N.new.total=NaN*(N.new.total); N.new.R=NaN*(N.new.total); N.new.P=NaN*(N.new.total); N.new.F1=NaN*(N.new.total); N.new.fxUnclass=NaN*(N.new.total);
N.new.total(ia)=N.opt.total; N.new.R(ia)=N.opt.R; N.new.P(ia)=N.opt.P; N.new.F1(ia)=N.opt.F1; N.new.fxUnclass(ia)=N.opt.fxUnclass;

[~,class]=get_class_ind( A.opt.class,'all',classidx);

% F1 scores Winner take all
figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
b=bar([N.new.R A.opt.R],'Barwidth',1,'linestyle','none'); hold on
hline(.9,'k--');
set(gca,'ycolor','k', 'xtick', 1:length(class), 'xticklabel', class); hold on
ylabel('Sensitivity');
col=(brewermap(2,'Set2')); 
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
legend('NOAA images', '+select OSU images','Location','NorthOutside')
xtickangle(45);
set(gcf,'color','w');
exportgraphics(gca,[figpath 'NOAA_vs_selectOSU_Sensitivity.png'],'Resolution',100)    
hold off

figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
b=bar([N.new.P A.opt.P],'Barwidth',1,'linestyle','none'); hold on
hline(.9,'k--');
set(gca,'ycolor','k', 'xtick', 1:length(class), 'xticklabel', class); hold on
ylabel('Precision');
col=(brewermap(2,'Set2')); 
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
legend('NOAA images', '+select OSU images','Location','NorthOutside')
xtickangle(45);

set(gcf,'color','w');
exportgraphics(gca,[figpath 'NOAA_vs_selectOSU_Precision.png'],'Resolution',100)    
hold off