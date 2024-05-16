%% plot threshold summaries
class2do_string = 'Pseudo-nitzschia'; %USER
summarydir = 'C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\';
load([summarydir 'Coeff_' num2str(class2do_string) ''],'class2do_string','slope','bin','chosen_threshold');


%%
figure 
subplot(2,2,1), plot(threlist, Rsq, '.-'), xlabel('threshold score'), ylabel('r^2'), line([chosen_threshold chosen_threshold], ylim, 'color', 'r')
subplot(2,2,2), plot(threlist, Coeffs(:,1), '.-'), xlabel('threshold score'), ylabel('y-intercept'), line([chosen_threshold chosen_threshold], ylim, 'color', 'r')
subplot(2,2,3), plot(threlist, Coeffs(:,2), '.-'), xlabel('threshold score'), ylabel('slope'), line([chosen_threshold chosen_threshold], ylim, 'color', 'r')
subplot(2,2,4), plot(threlist, RMSE, '.-'), xlabel('threshold score'), ylabel('RMSE'), line([chosen_threshold chosen_threshold], ylim, 'color', 'r')

%to calculate what percentage of the classifier counts are within a poisson
%confidence interval of the manual counts

ii = find(threlist == chosen_threshold);
% [ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat_sum( m.matdate(im), m.classcount(im,imclass) );
% x = y_mat(:);
%[matdate_bin, classcount_bin, ml_analyzed_mat_bin] = make_hour_bins(m.matdate(im),m.classcount(im,imclass), m.ml_analyzed_mat(im,imclass));
%x=classcount_bin;
% [ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat_sum( mdateTB(it), classcountTB_above_thre(it,ii) );
% y = y_mat(:);
%[matdate_bin, classcount_bin, ml_analyzed_mat_bin] = make_hour_bins(mdateTB(it), classcountTB_above_thre(it,ii), ml_analyzedTB(it));
%y=classcount_bin;
y = classcountTB_above_thre(it,ii);
%x = m.classcount(im,imclass);
cix=poisson_count_ci(x,0.95);
good = length(find(y>=cix(:,1) & y <= cix(:,2)));
bad = length(find(y<cix(:,1) | y > cix(:,2)));
all = length(find(~isnan(x)));
%check good+bad = all
fraction_inside_ci=good/all; %fraction inside conf interval

a = axes;
t1 = title(['\it' num2str(class2do_string) '\rm spp.'],'fontsize',12, 'fontname', 'Arial');
a.Visible = 'off'; % set(a,'Visible','off');
t1.Visible = 'on'; % set(t1,'Visible','on');

%%
figure

for count = ii
    handle_1=subplot(2,2,1);
    set(handle_1,'fontsize',12,'fontname','arial')
%     [matdate_bin, classcount_bin, ml_analyzed_mat_bin] = make_hour_bins(mdateTB(it), classcountTB_above_thre(it,ii), ml_analyzedTB(it));
%     y=classcount_bin;
    plot(x,y, '.')
    hold on
    %axis square
    line(xlim, xlim,'linewidth',1.5) % line w/ .5 slope
    eval(['fplot(@(x)x*' num2str(Coeffs(ii,2)) '+' num2str(Coeffs(ii,1)) ''' , xlim, ''color'', ''r'', ''linewidth'', 1.5)'])
    %legend(' ','1:1 line','line of best fit')
    subplot(2,2,1), ylabel('Automated counts','fontsize',12','fontname','arial')
    subplot(2,2,1), xlabel('Manual counts','fontsize',12','fontname','arial')
    set(gca,'xlim',[0 hi],'ylim',[0 hi],'TickDir','out'); %
    box(handle_1,'on');
end
set(gca, 'fontsize',11);

handle_2=subplot(2,2,2); plot(threlist, Rsq, '.-','linewidth',1.5),...
    xlabel('threshold score','fontsize',12,'fontname','arial'),...
    ylabel('r^2','fontsize',12,'fontname','arial'),...
    line([chosen_threshold chosen_threshold], [0 1], 'color', 'g','linewidth',1.5)
    set(handle_2,'fontsize',12,'xlim',[0 1],'fontname','arial','TickDir','out')
 
handle_3=subplot(2,2,3); plot(threlist, Coeffs(:,1), '.-','linewidth',1.5),...
    xlabel('threshold score','fontsize',12,'fontname','arial'),...
    ylabel('y-intercept','fontsize',12,'fontname','arial'),...
    line([chosen_threshold chosen_threshold],[-2 4], 'color', 'g','linewidth',1.5)
    set(handle_3,'ylim',[0 1],'xlim',[0 1],'fontsize',12,'fontname','arial','TickDir','out')

handle_4=subplot(2,2,4); plot(threlist, Coeffs(:,2), '.-','linewidth',1.5),...
    xlabel('threshold score','fontsize',12,'fontname','arial'),...
    ylabel('slope','fontsize',12,'fontname','arial'),...
    line([chosen_threshold chosen_threshold], [0 2], 'color', 'g','linewidth',1.5)
set(handle_4,'ylim',[0 2],'xlim',[0 1],'fontsize',12','fontname','arial','TickDir','out')

a = axes;
t1 = title(['\it' num2str(class2do_string) '\rm spp.'],'fontsize',12, 'fontname', 'Arial');
a.Visible = 'off'; % set(a,'Visible','off');
t1.Visible = 'on'; % set(t1,'Visible','on');

exportgraphics(gca,[summarydir 'Figs/' num2str(class2do_string) 'Threshold' num2str(chosen_threshold) '.png'],'Resolution',100)    
hold off