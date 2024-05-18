function [ ] = classifier_oob_analysis_og( classifiername,outpath,adhocthresh)
%[ ] = classifier_oob_analysis_hake( classifername,outpath,adhocthresh)
%For example:
% determine_classifier_performance('D:\Shimada\classifier\summary\Trees_12Oct2021')
% input classifier file name with full path
% expects output from make_TreeBaggerClassifier*.m
% test classifier on Hake survey dataset
%   Alexis D. Fischer, NOAA NWFSC, September 2021
%
%% Example Inputs
% clear
% classifiername ='F:\general\classifier\summary\Trees_BI_NOAA_v10';
% outpath='C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\IFCB-Data\BuddInlet\class\';
% adhocthresh=0.5;

load(classifiername,'b','featitles','classes','maxthre','targets');
%%
[Yfit,Sfit,Sstdfit] = oobPredict(b);
[mSfit, ii] = max(Sfit');
for count = 1:length(mSfit) 
    mSstdfit(count) = Sstdfit(count,ii(count)); 
    t(count)= Sfit(count,ii(count)); 
end
if isempty(find(mSfit(:)-t(:), 1))
    clear t 
else disp('check for error...'); 
end

%% winner takes all interpretation of scores
[c_all, class] = confusionmat(b.Y,Yfit); 
total = sum(c_all')'; 
[TP TN FP FN] = conf_mat_props(c_all); % true positive (TP), true negative (TN), false positive (FP), false negative (FN)

R = TP./(TP+FN); %recall (or probability of detection)
P = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c_all)./sum(c_all)'
F1= 2*((P.*R)./(P+R));

all=table(class,total,R,P,F1);
disp(['winner-takes-all error rate = ' num2str(1-sum(TP)./sum(total)) '']);

clearvars TP TN FP FN total Pm P R ii F1 count class

%% optimal threshold interpretation of scores
t = repmat(maxthre,length(Yfit),1);
win = (Sfit > t);
[i,j] = find(win);
Yfit_max = NaN(size(Yfit));
Yfit_max(i) = j;
ind = find(sum(win')>1);
for count = 1:length(ind)
    [~,Yfit_max(ind(count))] = max(Sfit(ind(count),:));
end
ind = find(isnan(Yfit_max));
Yfit_max(ind) = length(classes)+1; %unclassified set to last class
ind = find(Yfit_max);
classes2 = [classes(:); 'unclassified'];
[c_opt, class] = confusionmat(b.Y,classes2(Yfit_max));
total = sum(c_opt')';
[TP TN FP FN] = conf_mat_props(c_opt);
R = TP./(TP+FN); %recall
P = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c1)./sum(c1)'
F1= 2*((P.*R)./(P+R));
disp(['optimal error rate = ' num2str(1-sum(TP)./sum(total)) '']);

totalfxun=length(find(Yfit_max==length(classes2)))./length(Yfit_max);
fxUnclass = c_opt(:,end)./total;
fxUnclass(end)=totalfxun;
opt=table(class,total,R,P,F1,fxUnclass);

clearvars TP TN FP FN total Pm P R ii F1 count class i j ind win

%% winning score assessment where only take probabilities greater than adhocthresh
% if winning score is less than adhocthresh, then leave zero
t = ones(size(Sfit))*adhocthresh;
win = (Sfit > t);

[ia,ib] = find(win);
Yfit_max = NaN(size(Yfit));
Yfit_max(ia) = ib;
ind = find(sum(win')>1);
for count = 1:length(ind)
    [~,Yfit_max(ind(count))] = max(Sfit(ind(count),:));
end
Yfit_max(isnan(Yfit_max)) = length(classes)+1; %unclassified set to last class

[c_aht, ~] = confusionmat(b.Y,classes2(Yfit_max));
total = sum(c_aht')';

[TP TN FP FN] = conf_mat_props(c_aht);
R = TP./(TP+FN); %recall
P = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c1)./sum(c1)'
F1= 2*((P.*R)./(P+R));  

fxUnclass = c_aht(:,end)./total;
class=classes2;
aht=table(class,total,R,P,F1,fxUnclass);
aht(end,:)=[];
clearvars i ia ib F1 R P t TP TN FP FN ind win Yfit_max

%% count whos in training set
%find gaps, if they exist
% dt = NaT((size(targets)));
% for i=1:length(dt)
%     val=targets(i);
%     dt(i)=datetime([val{1}(2:9) ' ' val{1}(11:16)],'InputFormat','yyyyMMdd HHmmss');
% end

idx = find(contains(targets,'IFCB150'));
[C, classT] = confusionmat(b.Y(idx),Yfit(idx)); 
[~,idx]=sort(classT);classT=classT(idx);C=C(idx,idx);
totalT = sum(C')'; 
BI=zeros(size(classes));
[~,ib]=ismember(classes,classT);
for i=1:length(ib)
    if ib(i)>0
        BI(i)= totalT(ib(i));        
    else
    end
end

idx = contains(targets,'IFCB122');
[C, classT] = confusionmat(b.Y(idx),Yfit(idx)); 
[~,idx]=sort(classT);classT=classT(idx);C=C(idx,idx);
totalT = sum(C')'; 
OSU=zeros(size(classes));
[~,ib]=ismember(classes,classT);
for i=1:length(ib)
    if ib(i)>0
        OSU(i)= totalT(ib(i));        
    else
    end
end

idx = contains(targets,{'IFCB777' 'IFCB117'}); %'IFCB122'
[C, classT] = confusionmat(b.Y(idx),Yfit(idx)); 
[~,idx]=sort(classT);classT=classT(idx);C=C(idx,idx);
totalT = sum(C')'; 
NCC=zeros(size(classes));
[~,ib]=ismember(classes,classT);
for i=1:length(ib)
    if ib(i)>0
        NCC(i)= totalT(ib(i));        
    else
    end
end

total=sum([BI,NCC,OSU],2);

trainingset=table(classes,total,BI,NCC,OSU);
trainingset = renamevars(trainingset,'classes','class');

clearvars idx C class BI NCC OSU 

%% sorting features according to the best ones
figure('Units','inches','Position',[1 1 3.5 3],'PaperPositionMode','auto');
[~,ind]=sort(b.OOBPermutedVarDeltaError,2,'descend');
bar(sort(b.OOBPermutedVarDeltaError,2,'descend'))
ylabel('Feature importance')
xlabel('Feature ranked index')

topfeat=featitles(ind(1:20))';

%% plot threshold scores
figure('Units','inches','Position',[1 1 6 4.5],'PaperPositionMode','auto');
boxplot(max(Sfit'),b.Y)
ylabel('Out-of-bag winning scores')
set(gca, 'xtick', 1:length(classes), 'xticklabel', [], 'ylim', [0 1])
text(1:length(classes), -.1*ones(size(classes)), classes, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
set(gca, 'position', [ 0.13 0.35 0.8 0.6])
hold on, plot(1:length(classes), maxthre, '*g')

lh = legend('optimal threshold score','Location','NE'); set(lh, 'fontsize', 10)

set(gcf,'color','w');
exportgraphics(gca,[outpath 'Figs/class_vs_thresholdscores_' classifiername(37:end) '.png'],'Resolution',100)    
hold off

save([outpath 'performance_classifier_' classifiername(37:end) ''],'all','c_all','c_aht','aht','adhocthresh','opt','c_opt','maxthre','topfeat','trainingset');
disp(['summary location: ' outpath 'performance_classifier_' classifiername(37:end) '']);
end