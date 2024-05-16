
%class2do_string = 'Akashiwo'; ymax=1000; 
%class2do_string = 'Ceratium'; ymax=100; 
% class2do_string = 'Dinophysis'; ymax=12;
% class2do_string = 'Lingulodinium'; ymax=12;
% class2do_string = 'Pennate'; ymax=70;
% class2do_string = 'Prorocentrum'; ymax=240;
% class2do_string = 'Chaetoceros'; ymax=350;
% class2do_string = 'Det_Cer_Lau'; ymax=50; 
% class2do_string = 'Eucampia'; ymax=120;
% class2do_string = 'Umbilicosphaera'; chosen_threshold = 0.7; hi=50;
% class2do_string = 'Cochlodinium'; chosen_threshold = 0.5; hi=10;

class2do_string = 'Pseudo-nitzschia'; ymax=30;
%class2do_string = 'NanoP_less10'; ymax=600;
%class2do_string = 'Cryptophyte'; ymax=50;
% class2do_string = 'Thalassiosira'; ymax=30;
% class2do_string = 'Skeletonema'; ymax=50;
% class2do_string = 'Centric'; ymax=150;
% class2do_string = 'Guin_Dact'; ymax=35;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([filepath 'Data/IFCB_summary/Coeff_' class2do_string]);
load([filepath 'Data/IFCB_summary/manual/count_biovol_manual_05Feb2019']); 
load([filepath 'Data/IFCB_summary/class/summary_allTB_bythre_' class2do_string]);
load([filepath 'Data/SCW_master'],'SC');

for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24);
end

[~,im,it] = intersect({filelist.newname}, filelistTB); %finds the matched files between automated and manually classified files

% Makes day bins for the matched automated counts. I've used column 6 because this is for the 0.5 threshold. 
[matdate_bin_match, classcount_bin_match, ml_analyzed_mat_bin_match] =...
    make_day_bins(mdateTB(it),classcountTB_above_thre(it,bin),ml_analyzedTB(it)); 

% Takes the series of day bins for automated counts and puts it into a year x day matrix.
[ mdate_mat_match, y_mat_match, yearlist, yd ] =...
    timeseries2ydmat(matdate_bin_match,classcount_bin_match./ml_analyzed_mat_bin_match ); 

y_mat=classcountTB_above_thre(:,bin)./ml_analyzedTB(:);
y_mat((y_mat<0)) = 0; % cannot have negative numbers 

ind2 = strmatch(class2do_string, class2use); %change this for whatever class you are analyzing

% Makes day bins for the matched manual counts.
[matdate_bin_auto, classcount_bin_auto, ml_analyzed_mat_bin_auto] =...
    make_day_bins(matdate(im),classcount(im,ind2), ml_analyzed(im)); 

% Takes the series of day bins and puts it into a year x day matrix.
[mdate_mat_manual, y_mat_manual, yearlist, yd ] =...
    timeseries2ydmat(matdate_bin_auto,classcount_bin_auto./ml_analyzed_mat_bin_auto); 

ind=(find(y_mat)); % find dates associated with nonzero elements
mdate_val=[mdateTB(ind),y_mat(ind)];

%% Plot automated vs manual classification cell counts
%2016-2019

figure('Units','inches','Position',[1 1 8 2.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.09 0.2], [0.09 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(1,3,1);
stem(mdateTB, y_mat./slope,'k-','Linewidth',.5,'Marker','none'); %This adjusts the automated counts by the chosen slope. 
hold on
for i=1:length(yearlist)
    ind_nan=find(~isnan(y_mat_manual(:,i)));
    plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),...
        'r*','Markersize',6,'linewidth',.8);
end
hold on
set(gca,'xgrid','on','ylim',[0 ymax],...
    'xlim',[datenum('2016-08-01') datenum('2016-11-05')],...
    'xtick',[datenum('2016-08-01'),datenum('2016-09-01'),...
    datenum('2016-10-01'),datenum('2016-11-01')],'fontsize',10,...    
    'Xticklabel',{'A16','S','O','N'},'tickdir','out');  
ylabel(['\it' num2str(class2do_string) '\rm cells mL^{-1}\bf'],...
    'fontsize',12, 'fontname', 'Arial');    
hold on

% vfill([datenum('2016-09-14'),0,datenum('2016-09-21'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
% vfill([datenum('2016-10-20'),0,datenum('2016-10-26'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
% vfill([datenum('2016-10-20'),0,datenum('2016-10-26'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
% hold on

subplot(1,3,2);
stem(mdateTB, y_mat./slope,'k-','Linewidth',.5,'Marker','none'); %This adjusts the automated counts by the chosen slope. 
hold on
for i=1:length(yearlist)
    ind_nan=find(~isnan(y_mat_manual(:,i)));
    h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),...
        'r*','Markersize',6,'linewidth',.8);
end
hold on
set(gca,'xgrid','on','ycolor','none','ylim',[0 ymax],...
    'xlim',[datenum('2017-02-22') datenum('2017-06-24')],...
    'xtick',[datenum('2017-03-01'),datenum('2017-04-01'),...
    datenum('2017-05-01'),datenum('2017-06-01')],'fontsize',10,...    
    'Xticklabel',{'M17','A','M','J'},'tickdir','out');  
ylabel(['\it' num2str(class2do_string) '\rm cells mL^{-1}\bf'],...
    'fontsize',12, 'fontname', 'Arial');    
% vfill([datenum('2017-03-28'),0,datenum('2017-04-21'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
% hold on

subplot(1,3,3);
h1=stem(mdateTB, y_mat./slope,'k-','Linewidth',.5,'Marker','none'); %This adjusts the automated counts by the chosen slope. 
hold on
for i=1:length(yearlist)
    ind_nan=find(~isnan(y_mat_manual(:,i)));
    h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),'r*','Markersize',6,'linewidth',.8);
end
hold on
set(gca,'xgrid','on','ycolor','none','ylim',[0 ymax],...
    'xlim',[datenum('2018-01-17') datenum('2018-07-01')],...
    'xtick',[datenum('2018-02-01'),datenum('2018-03-01'),...
    datenum('2018-04-01'),datenum('2018-05-01'),datenum('2018-06-01'),...
    datenum('2018-07-01')],'fontsize',10,...    
    'Xticklabel',{'F18','M','A','M','J','J'},'tickdir','out');  
ylabel(['\it' num2str(class2do_string) '\rm cells mL^{-1}\bf'],...
    'fontsize',12, 'fontname', 'Arial');    
% vfill([datenum('2018-01-28'),0,datenum('2018-02-01'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
% vfill([datenum('2018-02-09'),0,datenum('2018-02-15'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
% vfill([datenum('2018-03-02'),0,datenum('2018-03-06'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
% vfill([datenum('2018-04-14'),0,datenum('2018-04-17'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
% vfill([datenum('2018-04-28'),0,datenum('2018-05-11'),500],[200 200 200]/255,'FaceAlpha',.3,'Edgecolor','none');
% hold on

lh = legend([h1,h2], ['Automated classification (' num2str(threlist(bin)) ')'],...
    'Manual classification');
set(lh,'fontsize',9,'Position',...
    [0.387586811686913 0.825694448418087 0.27213541053546 0.15208332935969]);
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs/Manual_automated_' num2str(class2do_string) '.tif']);
hold off

%% Plot automated vs manual classification vs microscopy cell counts

figure('Units','inches','Position',[1 1 7.5 3],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.12 -0.7], [0.1 0.05]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings. 
xax1=datenum(['2018-01-01']); xax2=datenum(['2018-07-01']);     

subplot(2,1,1)
    sz=linspace(1,60,100); 
    A=SC.rai.PN'./4;
    A(A<=.01)=.01; %replace values <0 with 0.01  
    ii=~isnan(A); Aok=A(ii); 
    Asz=zeros(length(Aok),1); 
    for j=1:length(Asz)  
         Asz(j)=sz(round(Aok(j)*length(sz)));
    end
    h=scatter(SC.rai.dn(ii)',ones(size(Asz)),Asz,'m','filled');
    set(gca,'visible','off','xlim',[xax1 xax2],'ylim',[1 1.5],'xticklabel',{},...
        'yticklabel',{},'fontsize',14);  
    hold on  
    
subplot(2,1,2)    
    h1=stem(mdateTB, y_mat./slope,'k-','Linewidth',.5,'Marker','none'); %This adjusts the automated counts by the chosen slope. 
    hold on
    for i=1:length(yearlist)
        ind_nan=find(~isnan(y_mat_manual(:,i)));
        h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),'r*','Markersize',6,'linewidth',.8);
    end
    hold on
    h3=plot(SC.dn,SC.Pn*.001,'b^','Linewidth',2,'Markersize',5);
    hold on

    set(gca,'xgrid','on','xlim',[xax1 xax2],'fontsize',14,'tickdir','out');  
    ylabel(['\it' num2str(class2do_string) '\rm cells mL^{-1}\bf'],...
        'fontsize',16, 'fontname', 'Arial','fontweight','bold');    
    hold on
    datetick('x','m','keeplimits');
     lh = legend([h1,h2,h3,h], ['Auto class'],...
        'Manual class','Microscopy','RAI','location','Northeast');
    set(lh,'fontsize',14,'box','off')
    
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs/Manual_automated_' num2str(class2do_string) '.tif']);
hold off

%% plot Automatic classification cell counts

figure('Units','inches','Position',[1 1 6 3.],'PaperPositionMode','auto');

xax1=datenum(['2018-01-01']); xax2=datenum(['2018-08-15']);     

h1=plot(mdateTB, y_mat./slope,'k-','Linewidth',.5,'Marker','none'); %This adjusts the automated counts by the chosen slope. 
% hold on
% for i=1:length(yearlist)
%     ind_nan=find(~isnan(y_mat_manual(:,i)));
%     h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),'r*','Markersize',6,'linewidth',.8);
% end

hold on
datetick('x','m','keeplimits');
set(gca,'xgrid','on',...
    'xlim',[xax1 xax2],'fontsize',14,'tickdir','out');  
ylabel(['\it' num2str(class2do_string) '\rm cells mL^{-1}\bf'],...
    'fontsize',16, 'fontname', 'Arial','fontweight','bold');    

hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs/Manual_automated_line_' num2str(class2do_string) '.tif']);
hold off
