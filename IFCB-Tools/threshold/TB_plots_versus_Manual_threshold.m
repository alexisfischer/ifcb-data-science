clear; 
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath(filepath));
classifiername='CCS_NOAA-OSU_v4'; %USER
load([filepath 'IFCB-Data/Shimada/class/performance_classifier_' classifiername],'all'); %get classlist from classifier

class2do_full = char(all.class(1)); %USER

if contains(class2do_full,',')
    class2do_string = [extractBefore(class2do_full,',') '_grouped'];
else
    class2do_string=class2do_full;
end

load([filepath 'IFCB-Data/Shimada/threshold/' classifiername '/Coeff_' class2do_string],'slope','bin','chosen_threshold');
load([filepath 'IFCB-Data/Shimada/threshold/' classifiername '/summary_allTB_bythre_' class2do_string],'threlist','classcountTB_above_thre','ml_analyzedTB','filelistTB','mdateTB');
load([filepath 'IFCB-Data/Shimada/manual/count_class_biovol_manual'],'class2use','classcount','matdate','ml_analyzed','filelist');

[~,label]=get_class_ind(class2do_full, 'all',[filepath 'IFCB-Tools/convert_index_class/class_indices.mat']);

for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24);
end

[~,im,it] = intersect({filelist.newname}, filelistTB); %finds the matched files between automated and manually classified files

mdateTB=datetime(mdateTB(it),'convertfrom','datenum');
y_mat=classcountTB_above_thre(it,bin)./ml_analyzedTB(it);
y_mat((y_mat<0)) = 0; % cannot have negative numbers 

ind = strfind(class2do_full, ',');
if ~isempty(ind)
    ind = [0 ind length(class2do_full)];
    for c = 1:length(ind)-2
        imclass(c)=find(strcmp(class2use,class2do_full(ind(c)+1:ind(c+1)-1)),1);
    end
    c=length(ind)-1;
    imclass(c)=find(strcmp(class2use,class2do_full(ind(c)+1:ind(c+1))),1);
else
    imclass = find(strcmp(class2use,class2do_full));
end

mdate_mat_manual=datetime(matdate,'convertfrom','datenum');
y_mat_manual=sum(classcount(:,imclass)./ml_analyzed,2);
ymax=round(max(y_mat_manual));

clearvars ml_analyzedTB bin threlist ind2 i ind2 it im classcount ml_analyzed matdate classcountTB_above_thre class2use

% Plot automated vs manual classification cell counts
figure('Units','inches','Position',[1 1 4 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.1 0.1], [0.14 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(2,1,1);
stem(mdateTB, y_mat./slope,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    ind_nan=find(~isnan(y_mat_manual));
    plot(mdate_mat_manual(ind_nan), y_mat_manual(ind_nan),'r*','Markersize',6,'linewidth',.8);
    datetick('x', 'mmm', 'keeplimits');        
    set(gca,'xgrid','on','tickdir','out','xlim',[datetime('2019-06-01') datetime('2019-09-15')],...
        'xticklabel',{},'ylim',[0 ymax],'fontsize',10); 
    ylabel('2019','fontsize',12);    
    title([char(label) ' (cells mL^{-1})'],'fontsize',12); 
 legend('classifier','manual','location','nw');legend boxoff;

subplot(2,1,2);
stem(mdateTB, y_mat./slope,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    ind_nan=find(~isnan(y_mat_manual));
    plot(mdate_mat_manual(ind_nan), y_mat_manual(ind_nan),'r*','Markersize',6,'linewidth',.8);
    set(gca,'xgrid','on','tickdir','out','ylim',[0 ymax],...
        'xlim',[datetime('2021-06-01') datetime('2021-09-15')],'fontsize',10); 
    datetick('x', 'mmm', 'keeplimits');    
    ylabel('2021','fontsize',12);    
 
% set figure parameters
exportgraphics(gcf,[filepath 'IFCB-Data/Shimada/threshold/' classifiername '/Figs/Manual_automated_' num2str(class2do_string) '.png'],'Resolution',100)    
hold off
