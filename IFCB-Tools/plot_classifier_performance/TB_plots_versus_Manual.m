%% basic script to plot manual vs classifier results for Shimada data
% this works for any class
% A.D. Fischer, May 2024
clear;

%%%%USER
fprint = 1; % 1 = print; 0 = don't
class2do_full='Asterionellopsis'; %class to plot
type='opt'; %'adhoc' %'all' select your classifier output. Note:'opt' is the final CCS classifier
filepath = '~/Documents/MATLAB/ifcb-data-science/'; % enter your path

% load in data
addpath(genpath(filepath)); % add new data to search path
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   
load([filepath 'IFCB-Data/Shimada/manual/count_class_manual'],...
    'class2use','classcount','matdate','ml_analyzed','filelist'); % manual data summary
load([filepath 'IFCB-Data/Shimada/class/summary_biovol_allTB'],'class2useTB',...
    'classcountTB','classcount_above_optthreshTB','classcount_above_adhocthreshTB',...
    'filelistTB','mdateTB','ml_analyzedTB'); %classified data summary

%%%% find and select matching manual and class files using filenames
for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24); %format manual filenames like class filenames
end
[~,im,it] = intersect({filelist.newname}, filelistTB); 
mdateTB=datetime(mdateTB(it),'convertfrom','datenum');
ml_analyzedTB=ml_analyzedTB(it);
filelistTB=filelistTB(it);
matdate=datetime(matdate,'convertfrom','datenum');

%%%% sum up grouped classes for manual data
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

%%%% select only data associated with preferred classifier output
if strcmp(type,'all')
    auto=classcountTB(it,strcmp(class2do_full,class2useTB));
elseif strcmp(type,'opt')
    auto=classcount_above_optthreshTB(it,strcmp(class2do_full,class2useTB));
elseif strcmp(type,'adhoc')
    auto=classcount_above_adhocthreshTB(it,strcmp(class2do_full,class2useTB));
end

clearvars im it i imclass ind ia;

% Plot automated vs manual classification cell counts
figure('Units','inches','Position',[1 1 3.5 3.8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.08 0.13], [0.16 0.1]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

[~,label]=get_class_ind(class2do_full, 'all',class_indices_path); %make a pretty label
ymax=ceil(max(max([auto./ml_analyzedTB;man./ml_analyzed]))); %set yaxis max to highest value

subplot(3,1,1);
yr='2019';
stem(mdateTB,auto./ml_analyzedTB,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    plot(matdate,man./ml_analyzed,'r*','Markersize',6,'linewidth',.8);
    datetick('x', 'mmm', 'keeplimits');        
    set(gca,'xgrid','on','tickdir','out','xlim',[datetime(['' yr '-06-15']) datetime(['' yr '-09-15'])],...
        'xticklabel',{},'ylim',[0 ymax],'fontsize',10); 
    ylabel(yr,'fontsize',12);    
    title({type;[char(label) ' (cells mL^{-1})']},'fontsize',12); 
 legend('classifier','manual','location','nw');legend boxoff;

subplot(3,1,2);
yr='2021';
stem(mdateTB,auto./ml_analyzedTB,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    plot(matdate,man./ml_analyzed,'r*','Markersize',6,'linewidth',.8);
    datetick('x', 'mmm', 'keeplimits');        
    set(gca,'xgrid','on','tickdir','out','xlim',[datetime(['' yr '-06-15']) datetime(['' yr '-09-15'])],...
        'xticklabel',{},'ylim',[0 ymax],'fontsize',10); 
    ylabel(yr,'fontsize',12);    

subplot(3,1,3);
yr='2023';
stem(mdateTB,auto./ml_analyzedTB,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    plot(matdate,man./ml_analyzed,'r*','Markersize',6,'linewidth',.8);
    set(gca,'xgrid','on','tickdir','out','ylim',[0 ymax],...
        'xlim',[datetime(['' yr '-06-15']) datetime(['' yr '-09-15'])],'fontsize',10); 
    datetick('x', 'mmm', 'keeplimits');    
    ylabel(yr,'fontsize',12);   

if fprint
    if contains(class2do_full,',') %modify filename for grouped classes so not as long
        class2do_string = [extractBefore(class2do_full,',') '_grouped'];
    else
        class2do_string=class2do_full;
    end    
    exportgraphics(gcf,[filepath 'IFCB-Data/Shimada/class/Figs/Manual_automated_' type '_' num2str(class2do_string) '.png'],'Resolution',100)    
end
hold off

