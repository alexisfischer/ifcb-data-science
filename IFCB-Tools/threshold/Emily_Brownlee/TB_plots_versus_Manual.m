
clear all

%For a threshold of 0.7, the Laboea slope is 0.7994 %After running the
%threshold summary, I determined this slope to be the most appropriate


load '/Volumes/IFCB_products/MVCO/Manual_fromClass/summary/count_biovol_manual_current.mat' %load manual count result file that you made from running 'biovolume_summary_manual_user_training.m'
load /Volumes/IFCB_products/MVCO/class/summary/summary_allTB_bythre_Laboea %load automated count file with all thresholds you made from running 'countcells_allTB_class_by_thre_user.m'
cd '/Users/markmiller/Documents/Thesis/Figures/Chapter3_figure_final/'


[~,im,it] = intersect(filelist, filelistTB); %finds the matched files between automated and manually classified files

[matdate_bin_match, classcount_bin_match, ml_analyzed_mat_bin_match] = make_day_bins(mdateTB(it),classcountTB_above_thre(it,8),ml_analyzedTB(it)); %This makes day bins for the matched automated counts. I've used column 8 because this is for the 0.7 threshold. You need to make sure you put in the right column. 
[ mdate_mat_match, y_mat_match, yearlist, yd ] = timeseries2ydmat(matdate_bin_match,classcount_bin_match./ml_analyzed_mat_bin_match ); %This takes the series of day bins and puts it into a year x day matrix.


ind2 = strmatch('Laboea', class2use); %change this for whatever class you are analyzing
[matdate_bin_auto, classcount_bin_auto, ml_analyzed_mat_bin_auto] = make_day_bins(matdate(im),classcount(im,ind2), ml_analyzed_mat(im,ind2)); %This makes day bins for the matched manual counts.
[mdate_mat_manual, y_mat_manual, yearlist, yd ] = timeseries2ydmat(matdate_bin_auto,classcount_bin_auto./ml_analyzed_mat_bin_auto);  %This takes the series of day bins and puts it into a year x day matrix.
%%
figure
plot(mdate_mat(:), y_mat(:)/0.7994*1000,'k-') %This adjusts the automated counts by the chosen slope. 
hold on
for i=1:length(yearlist)
    ind_nan=find(~isnan(y_mat_manual(:,i)));
    plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i)*1000,'r*')
end
datetick,set(gca, 'xgrid', 'on')
ylabel('\itLaboea strobila\rm concentration (L^{-1})\bf', 'fontsize',16, 'fontname', 'Times');
set(gca, 'fontsize', 16, 'fontname', 'Times')
lh=legend('Automated classification', 'Manual classification');
set(lh,'fontsize',12)
set(gcf,'PaperOrientation','landscape');
set(gcf,'units','inches')
set(gcf,'position',[6 7 12 4],'paperposition', [-0.5 3 12 4]);
set(gcf,'color','w')
set(gca, 'xtick', datenum(['1-1-2006';'1-1-2007'; '1-1-2008'; '1-1-2009'; '1-1-2010'; '1-1-2011'; '1-1-2012'; '1-1-2013'; '1-1-2014'; '1-1-2015'; '1-1-2016']))
set(gca,'xticklabels',{'               2006','               2007','               2008','               2009','               2010',...
    '               2011','               2012','               2013','               2014','               2015','               2016'});
%datetick('x', 'keeplimits', 'keepticks')
%ylim([0 3000])

%%
%print Laboea_TB_manual_matched -dpdf %I use this to export a pdf plot. It
%will export into current directory. 

%%


