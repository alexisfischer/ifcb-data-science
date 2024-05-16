
load summary_allTB_bythre_Laboea.mat %or whatever class you choose

mdate = mdateTB;
y = classcountTB_above_thre(:,8)./ml_analyzedTB;
x = mdateTB;

[ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat( x, y ); %takes a timeseries and makes it into a year x day matrix


figure;
[ y_wkmat, mdate_wkmat, yd_wk ] = ydmat2weeklymat( y_mat, yearlist ); %takes a year x day matrix and makes it a year x 2 week matrix
pcolor([yd_wk ;yd_wk(end)+7],[yearlist(1:9) yearlist(9)+1],[[y_wkmat(:,1:9)';zeros(1,52)] zeros(10,1)]) %for just 2006:2014
caxis([0 0.6])
ylabel('Year', 'fontsize',16, 'fontname', 'Times New Roman');
xlabel('Month', 'fontsize',16, 'fontname', 'Times New Roman');
h=colorbar;
set(get(h,'ylabel'),'string','Cell concentration (mL^{-1})','fontsize',16,'fontname','Times New Roman');
datetick('x',4)
axis square
shading flat


