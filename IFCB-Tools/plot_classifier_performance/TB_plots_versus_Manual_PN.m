%% script to plot manual vs classifier PN results for Shimada data
% plots opt score threshold output from TB
% this sums PN classes of 1,2,3.5 cells
% A.D. Fischer, May 2024
clear;

%%%%USER
fprint = 1; % 1 = print; 0 = don't
filepath = '~/Documents/MATLAB/ifcb-data-science/'; % enter your path

% load in data
addpath(genpath(filepath)); % add new data to search path
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
load([filepath 'IFCB-Data/Shimada/manual/count_class_manual'],...
    'class2use','classcount','matdate','ml_analyzed','filelist'); % manual data summary from "summarize_manual_cells"
load([filepath 'IFCB-Data/Shimada/class/summary_biovol_allTB'],'class2useTB','classcount_above_optthreshTB',...
    'filelistTB','mdateTB','ml_analyzedTB'); %classified data summary from "summarize_class_cells_biovol_size"

%%%% find and select matching manual and class files using filenames
for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24); %format manual filenames like class filenames
end
[~,im,it] = intersect({filelist.newname}, filelistTB); 
mdateTB=datetime(mdateTB(it),'convertfrom','datenum');
ml_analyzedTB=ml_analyzedTB(it);
filelistTB=filelistTB(it);
matdate=datetime(matdate,'convertfrom','datenum');

%%%% sum up grouped PN classes for manual data
class2do_full='Pseudo-nitzschia_large_1cell,Pseudo-nitzschia_small_1cell';
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
man1=sum(classcount(im,imclass),2);
auto1=classcount_above_optthreshTB(it,strcmp(class2do_full,class2useTB));

class2do_full='Pseudo-nitzschia_large_2cell,Pseudo-nitzschia_small_2cell';
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
man2=sum(classcount(im,imclass),2);
auto2=classcount_above_optthreshTB(it,strcmp(class2do_full,class2useTB));

class2do_full='Pseudo-nitzschia_large_3cell,Pseudo-nitzschia_large_4cell,Pseudo-nitzschia_small_3cell,Pseudo-nitzschia_small_4cell';
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
man34=sum(classcount(im,imclass),2);
auto34=classcount_above_optthreshTB(it,strcmp(class2do_full,class2useTB));

man_cellsmL=sum([man1,2*man2,3.5*man34]./ml_analyzedTB,2);
auto_cellsmL=sum([auto1,2*auto2,3.5*auto34]./ml_analyzedTB,2);

T=table(filelistTB,matdate,ml_analyzed,man_cellsmL,auto_cellsmL,man1,auto1,man2,auto2,man34,auto34);

clearvars im it i imclass ind ia man* auto* matdate mdateTB ml_analyzed* classcount* filelist*;

%% Plot summed automated vs manual classification cell counts, each panel = year
figure('Units','inches','Position',[1 1 3.5 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.08 0.08], [0.2 0.06]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

ymax=ceil(max(max([T.auto_cellsmL;T.man_cellsmL]))); %set yaxis max to highest value

yr=[2019;2021;2023];
for i=1:length(yr)
    h(i)=subplot(3,1,i);
    stem(T.matdate,T.auto_cellsmL,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
        plot(T.matdate,T.man_cellsmL,'r*','Markersize',6,'linewidth',.8);
        set(gca,'xgrid','on','tickdir','out','ylim',[0 ymax],'fontsize',10,'xlim',...
            [datetime(['' num2str(yr(i)) '-06-15']) datetime(['' num2str(yr(i)) '-09-15'])]); 
        ylabel(num2str(yr(i)),'fontsize',11);   
        datetick('x', 'mmm', 'keeplimits');                
end
h(1).Title.String ={'Pseudo-nitzschia (cells mL^{-1})'};
legend('classifier','manual','location','nw');legend boxoff;

if fprint
    if contains(class2do_full,',') %modify filename for grouped classes so not as long
        class2do_string = [extractBefore(class2do_full,',') '_grouped'];
    else
        class2do_string=class2do_full;
    end    
    exportgraphics(gcf,[filepath 'IFCB-Data/Shimada/class/Figs/Manual_automated_PN_total.png'],'Resolution',100)    
end
hold off

%% Plot automated vs manual classification cell counts, each panel = different chain length
% note that this is plotting the number of each image in that class, does
% not include number of cells/chain
%
yr=2023; %2021 %2023 select plotting year
TT=T((T.matdate.Year==yr),:);

figure('Units','inches','Position',[1 1 3.5 3.8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.12 0.07], [0.18 0.06]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(3,1,1);
ymax=ceil(max(max([TT.auto1;TT.man1]))); %set yaxis max to highest value
stem(TT.matdate,TT.auto1,'k-','Linewidth',.5,'Marker','none'); hold on;
plot(TT.matdate,TT.man1,'r*','Markersize',5,'linewidth',.8); hold on
    set(gca,'xgrid','on','tickdir','out','xticklabel',{},'ylim',[0 ymax],'fontsize',10,...
        'xlim',[datetime(['' num2str(yr) '-06-15']) datetime(['' num2str(yr) '-09-15'])]); 
    ylabel('1 cell','fontsize',11); 
 legend('classifier','manual','location','nw');% legend boxoff;
title('# Pseudo-nitzschia per class','fontsize',11);
    
subplot(3,1,2);
ymax=ceil(max(max([TT.auto2;TT.man2]))); %set yaxis max to highest value
stem(TT.matdate,TT.auto2,'k-','Linewidth',.5,'Marker','none'); hold on;
plot(TT.matdate,TT.man2,'r*','Markersize',5,'linewidth',.8); hold on
    set(gca,'xgrid','on','tickdir','out','xticklabel',{},'ylim',[0 ymax],'fontsize',10,...
        'xlim',[datetime(['' num2str(yr) '-06-15']) datetime(['' num2str(yr) '-09-15'])]); 
    ylabel('2 cells','fontsize',11); 

subplot(3,1,3);
ymax=ceil(max(max([TT.auto34;TT.man34]))); %set yaxis max to highest value
stem(TT.matdate,TT.auto34,'k-','Linewidth',.5,'Marker','none'); hold on; 
plot(TT.matdate,TT.man34,'r*','Markersize',5,'linewidth',.8); hold on
    set(gca,'xgrid','on','tickdir','out','ylim',[0 ymax],'fontsize',10,...
        'xlim',[datetime(['' num2str(yr) '-06-15']) datetime(['' num2str(yr) '-09-15'])]); 
    ylabel('3-4 cells','fontsize',11); 

if fprint
    exportgraphics(gcf,[filepath 'IFCB-Data/Shimada/class/Figs/Manual_automated_PN_bychain_' num2str(yr) '.png'],'Resolution',100)    
end
hold off

