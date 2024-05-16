clear
filepath = 'C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\';
addpath(genpath(filepath));
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\ifcb-analysis\'));

load([filepath 'IFCB-Data\LabData\manual\count_class_manual.mat']);


idx=isnan(ml_analyzed);
ml_analyzed(idx)=[];
classcount(idx,:)=[];
matdate(idx)=[];
filecomment(idx)=[];
rois=sum(classcount,2);

Dml=classcount(:,strcmp(class2use,'Dinophysis_acuminata'))./ml_analyzed;

figure;
subplot(2,1,1)
yyaxis left
bar(Dml); hold on
hline(50)
ylabel('Dinophysis cells/ml')

yyaxis right
plot([1:1:length(ml_analyzed)],rois,'*','markersize',10,'LineWidth',2);
ylabel('rois')
set(gca,'xlim',[1 length(ml_analyzed)],'xticklabel',filecomment)

subplot(2,1,2)
plot([1:1:length(ml_analyzed)],ml_analyzed,'*','markersize',10,'LineWidth',2);
ylabel('ml analyzed')
set(gca,'xlim',[1 length(ml_analyzed)],'xticklabel',filecomment)

