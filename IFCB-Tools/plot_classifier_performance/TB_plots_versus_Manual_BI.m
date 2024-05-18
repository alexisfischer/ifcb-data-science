%% plot manual vs classifier results for Budd Inlet
% A.D. Fischer, January 2023
clear;
class2do_string='Dinophysis'; ymax=20; 
%class2do_string='Mesodinium'; ymax=20;

filepath = '~/Documents/MATLAB/ifcb-data-science/';
outpath = [filepath 'IFCB-Data/BuddInlet/class/Figs/'];
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'IFCB-Data/BuddInlet/manual/count_class_manual'],'class2use','classcount','matdate','ml_analyzed','filelist');
load([filepath 'IFCB-Data/BuddInlet/class/summary_cells_allTB_2021_2023'],...
    'class2useTB','classcount_above_optthreshTB','classcount_above_adhocthreshTB','classcountTB','filelistTB','mdateTB','ml_analyzedTB');

% match up data
%%%% find matched files and class of interest
for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24);
end
[~,im,it] = intersect({filelist.newname}, filelistTB); %finds the matched files between automated and manually classified files
mdateTB=datetime(mdateTB(it),'convertfrom','datenum');
ml_analyzedTB=ml_analyzedTB(it);

ml_analyzed=ml_analyzed(im);
filelist={filelist(im).name}';
matdate=datetime(matdate(im),'convertfrom','datenum');
imclass=find(contains(class2use,class2do_string));

man=sum(classcount(im,imclass),2);
%auto=classcountTB(it,contains(class2useTB,class2do_string)); type='wta';
auto=classcount_above_optthreshTB(it,contains(class2useTB,class2do_string)); type='opt';
%auto=classcount_above_adhocthreshTB(it,contains(class2useTB,class2do_string)); type='adhoc';
clearvars filelistTB im it i imclass ind classcount_above_optthreshTB class2use class2useTB classcount_above_adhocthreshTB classcount;

[~,label]=get_class_ind(class2do_string,'all',class_indices_path);

%%%% plot manual vs classifier, scatter plot
figure('Units','inches','Position',[1 1 3.5 3.5],'PaperPositionMode','auto');
plot([0 ymax],[0 ymax],'r-'); hold on;
plot(man./ml_analyzed,auto./ml_analyzed,'ko','Markersize',5); hold on;
set(gca,'xlim',[0 ymax],'ylim',[0 ymax]);
axis square;
xlabel('manual')
ylabel('classifier')
title([type ' ' char(label) ' (cells mL^{-1})'],'fontsize',12); 

%%%% stem plot by year
figure('Units','inches','Position',[1 1 4 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.1 0.1], [0.14 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(3,1,1);
yr='2021';
plot(matdate,man./ml_analyzed,'r*','Markersize',5,'linewidth',.8); hold on;
stem(matdate,auto./ml_analyzedTB,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    set(gca,'xgrid','on','tickdir','out','xlim',[datetime([num2str(yr) '-05-01']) datetime([num2str(yr) '-10-01'])],...
        'xticklabel',{},'ylim',[0 ymax],'fontsize',10); 
    datetick('x', 'mmm', 'keeplimits');            
    set(gca,'xticklabel',{});
    ylabel(yr,'fontsize',12);    
    title([type ' ' char(label) ' (cells mL^{-1})'],'fontsize',12); 
 legend('manual','classifier','location','nw');legend boxoff;
 
subplot(3,1,2); 
yr='2022';
plot(matdate,man./ml_analyzed,'r*','Markersize',5,'linewidth',.8); hold on;
stem(matdate,auto./ml_analyzedTB,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    set(gca,'xgrid','on','tickdir','out','xlim',[datetime([num2str(yr) '-05-01']) datetime([num2str(yr) '-10-01'])],...
        'xticklabel',{},'ylim',[0 ymax],'fontsize',10); 
    datetick('x', 'mmm', 'keeplimits');            
    set(gca,'xticklabel',{});
    ylabel(yr,'fontsize',12);    

subplot(3,1,3);
yr='2023';
plot(matdate,man./ml_analyzed,'r*','Markersize',5,'linewidth',.8); hold on;
stem(matdate,auto./ml_analyzedTB,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    set(gca,'xgrid','on','tickdir','out','ylim',[0 ymax],...
        'xlim',[datetime([num2str(yr) '-05-01']) datetime([num2str(yr) '-10-01'])],'fontsize',10); 
    datetick('x', 'mmm', 'keeplimits');    
    ylabel(yr,'fontsize',12);    
 
% set figure parameters
exportgraphics(gcf,[outpath 'Manual_automated_' num2str(class2do_string) ' ' type '.png'],'Resolution',100)    
hold off

% 
% [a,ia]=maxk(auto./ml_analyzed,5)
% i=3
% auto(ia(i))
% man(ia(i))
% filelist(ia(i)).name