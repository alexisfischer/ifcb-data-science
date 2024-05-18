%% plot manual vs classifier results for Shimada
clear;
classifiername='CCS_v16';
class2do_full='Pseudo-nitzschia_large_1cell,Pseudo-nitzschia_small_1cell';

filepath = '~/Documents/MATLAB/ifcb-data-science/';
outpath = [filepath 'IFCB-Data/Shimada/threshold/' classifiername '/Figs/'];
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'IFCB-Data/Shimada/manual/count_class_biovol_manual'],'class2use','classcount','matdate','ml_analyzed','filelist');
load([filepath 'IFCB-Data/Shimada/class/summary_biovol_allTB_' classifiername],...
    'class2useTB','classcountTB','classcountTB_above_optthresh','classcountTB_above_adhocthresh','filelistTB','mdateTB','ml_analyzedTB');

mdateTB=datetime(mdateTB,'convertfrom','datenum');
matdate=datetime(matdate,'convertfrom','datenum');

%%%% sum up grouped classes
ind = strfind(class2do_full, ',');
if ~isempty(ind)
    ind = [0 ind length(class2do_full)];
    for i = 1:length(ind)-2
        imclass(i)=find(strcmp(class2use,class2do_full(ind(i)+1:ind(i+1)-1)),1);
    end
    i=length(ind)-1;
    imclass(i)=find(strcmp(class2use,class2do_full(ind(i)+1:ind(i+1))),1);
else
    imclass = find(strcmp(class2use,class2do_full));
end

man=sum(classcount(:,imclass),2);
auto=classcountTB(:,strcmp(class2do_full,class2useTB));
%auto=classcountTB_above_optthresh(:,strcmp(class2do_full,class2useTB));
%auto=classcountTB_above_adhocthresh(:,strcmp(class2do_full,class2useTB));

%%
clearvars im it i imclass ind;

%%%% Plot automated vs manual classification cell counts
figure('Units','inches','Position',[1 1 3.2 3],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.1 0.1], [0.16 0.1]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

[~,label]=get_class_ind(class2do_full, 'all',class_indices_path);

ymax=ceil(max(max([auto./ml_analyzedTB;man./ml_analyzed])));

subplot(2,1,1);
stem(mdateTB,auto./ml_analyzedTB,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    plot(matdate,man./ml_analyzed,'r*','Markersize',6,'linewidth',.8);
    datetick('x', 'mmm', 'keeplimits');        
    set(gca,'xgrid','on','tickdir','out','xlim',[datetime('15-Jun-2019') datetime('15-Sep-2019')],...
        'xticklabel',{},'ylim',[0 ymax],'fontsize',10); 
    ylabel('2019','fontsize',12);    
    title([char(label) ' (cells mL^{-1})'],'fontsize',12); 
 legend('classifier','manual','location','nw');legend boxoff;

subplot(2,1,2);
stem(mdateTB,auto./ml_analyzedTB,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    plot(matdate,man./ml_analyzed,'r*','Markersize',6,'linewidth',.8);
    set(gca,'xgrid','on','tickdir','out','ylim',[0 ymax],...
        'xlim',[datetime('2021-06-15') datetime('2021-09-15')],'fontsize',10); 
    datetick('x', 'mmm', 'keeplimits');    
    ylabel('2021','fontsize',12);    
 
if contains(class2do_full,',')
    class2do_string = [extractBefore(class2do_full,',') '_grouped'];
else
    class2do_string=class2do_full;
end

% set figure parameters
exportgraphics(gcf,[outpath 'nomatch_Manual_automated-all_' num2str(class2do_string) '.png'],'Resolution',100)    
hold off

%% match up data
%%%% find matched files and class of interest
for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24);
end
[~,im,it] = intersect({filelist.newname}, filelistTB); %finds the matched files between automated and manually classified files
mdateTB=datetime(mdateTB(it),'convertfrom','datenum');
ml_analyzedTB=ml_analyzedTB(it);
filelistTB=filelistTB(it);
matdate=datetime(matdate,'convertfrom','datenum');

%%%% sum up grouped classes
ind = strfind(class2do_full, ',');
if ~isempty(ind)
    ind = [0 ind length(class2do_full)];
    for i = 1:length(ind)-2
        imclass(i)=find(strcmp(class2use,class2do_full(ind(i)+1:ind(i+1)-1)),1);
    end
    i=length(ind)-1;
    imclass(i)=find(strcmp(class2use,class2do_full(ind(i)+1:ind(i+1))),1);
else
    imclass = find(strcmp(class2use,class2do_full));
end

man=sum(classcount(im,imclass),2);
%auto=classcountTB(it,strcmp(class2do_full,class2useTB));
%auto=classcountTB_above_optthresh(it,strcmp(class2do_full,class2useTB));
auto=classcountTB_above_adhocthresh(it,strcmp(class2do_full,class2useTB));

clearvars im it i imclass ind;

%%%% Plot automated vs manual classification cell counts
figure('Units','inches','Position',[1 1 3.2 3],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.1 0.1], [0.16 0.1]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

[~,label]=get_class_ind(class2do_full, 'all',class_indices_path);

ymax=ceil(max(max([auto./ml_analyzedTB,man./ml_analyzed])));

subplot(2,1,1);
stem(mdateTB,auto./ml_analyzedTB,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    plot(matdate,man./ml_analyzed,'r*','Markersize',6,'linewidth',.8);
    datetick('x', 'mmm', 'keeplimits');        
    set(gca,'xgrid','on','tickdir','out','xlim',[datetime('2019-06-15') datetime('2019-09-15')],...
        'xticklabel',{},'ylim',[0 ymax],'fontsize',10); 
    ylabel('2019','fontsize',12);    
    title([char(label) ' (cells mL^{-1})'],'fontsize',12); 
 legend('classifier','manual','location','nw');legend boxoff;

subplot(2,1,2);
stem(mdateTB,auto./ml_analyzedTB,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    plot(matdate,man./ml_analyzed,'r*','Markersize',6,'linewidth',.8);
    set(gca,'xgrid','on','tickdir','out','ylim',[0 ymax],...
        'xlim',[datetime('2021-06-15') datetime('2021-09-15')],'fontsize',10); 
    datetick('x', 'mmm', 'keeplimits');    
    ylabel('2021','fontsize',12);    
 
if contains(class2do_full,',')
    class2do_string = [extractBefore(class2do_full,',') '_grouped'];
else
    class2do_string=class2do_full;
end

% set figure parameters
exportgraphics(gcf,[outpath 'Manual_automated-adhoc_' num2str(class2do_string) '.png'],'Resolution',100)    
hold off
