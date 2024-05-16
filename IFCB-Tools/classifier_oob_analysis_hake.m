function [ ] = classifier_oob_analysis_hake( classifierpath,outpath )
%[ ] = classifier_oob_analysis_hake( classifierpath,outpath )
%For example:
% input classifier file name with full path
% expects output from make_TreeBaggerClassifier*.m
% test classifier on Hake survey dataset
%   Alexis D. Fischer, NOAA NWFSC, February 2023
%
%% Example Inputs
% clear
% classifierpath ='D:\general\classifier\summary\Trees_CCS_v17';
% outpath='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\';
% adhocthresh=0.5;

load(classifierpath,'b','classes','maxthre','targets');

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

% test performance on only Hake data
idx = contains(targets,{'IFCB777' 'IFCB117'}); %'IFCB122'
YfitN=Yfit(idx);
YN=b.Y(idx);
SfitN=Sfit(idx,:);

clearvars b ii idx Sstdfit mSfit mSstdfit count

%% select max of 1000 images for each class to test against
Nclass=NaN*ones(size(classes));
testtotal=1000; 
for i=1:length(classes)
    imclass = find(strcmp(YN,classes(i)));
    n=length(imclass);
    if n>testtotal
        n2del=n-testtotal;
        shuffle_ind=randperm(n);
        shuffle_ind = shuffle_ind(1:n2del);
        shuffle_ind=sort(shuffle_ind);    
        i2del=imclass(shuffle_ind);    
        YN(i2del)=[];
        YfitN(i2del)=[];
        SfitN(i2del,:)=[];
    else
    end
    imclass = find(strcmp(YN,classes(i)));
    n=length(imclass);    
    Nclass(i)=n;
end

clearvars n imclass i n2del i2del shuffle_ind

%% calculate FP, FN, etc for each class at each threshold score
classes2 = [classes(:); 'unclassified'];
threlist = (0:.1:1);

fPos=NaN*ones(length(classes2),length(threlist));
fNeg=NaN*ones(length(classes2),length(threlist));
tPos=NaN*ones(length(classes2),length(threlist));
Recall=NaN*ones(length(classes2),length(threlist));
Precision=NaN*ones(length(classes2),length(threlist));
F1score=NaN*ones(length(classes2),length(threlist));

for i=1:length(threlist)
    t = repmat(threlist(i),length(YfitN),1);
    win = (SfitN > t);
    [ia,ib] = find(win);
    Yfit_max = NaN(size(YfitN));
    Yfit_max(ia) = ib;
    ind = find(sum(win')>1);
    for count = 1:length(ind)
        [~,Yfit_max(ind(count))] = max(SfitN(ind(count),:));
    end
    Yfit_max(isnan(Yfit_max)) = length(classes)+1; %unclassified set to last class
    
    [C, ~] = confusionmat(YN,classes2(Yfit_max));

    total = sum(C')';
    if length(total)<length(classes2)
        C(end+1,:)=zeros(size(C(end,:)));
        C(:,end+1)=zeros(size(C(:,end)));
        total(end+1)=0;
    else
    end
    
    [TP TN FP FN] = conf_mat_props(C);
    R = TP./(TP+FN); %recall
    P = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c1)./sum(c1)'
    F1= 2*((P.*R)./(P+R));  

    fPos(:,i)=FP./total;
    fNeg(:,i)=FN./total;
    tPos(:,i)=TP./total;  
    Recall(:,i)=R;
    Precision(:,i)=P;
    F1score(:,i)=F1;
end

for i=1:length(Nclass)
    if Nclass(i)<testtotal
        Recall(i,:)=NaN;
        Precision(i,:)=NaN;
        F1score(i,:)=NaN;        
    else
    end
end

clearvars i ia ib F1 R P t TP TN FP FN ind win Yfit_max count

%% winner takes all interpretation of scores
[C, ~] = confusionmat(YN,YfitN); 
total = sum(C')';

[TP TN FP FN] = conf_mat_props(C);
R = TP./(TP+FN); %recall
P = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c1)./sum(c1)'
F1= 2*((P.*R)./(P+R));  

fxUnclass = C(:,end)./total;
class=classes;
all=table(class,total,R,P,F1,fxUnclass);
clearvars i ia ib F1 R P t TP TN FP FN ind win Yfit_max

%% winning score assessment where only take probabilities greater than adhocthresh
% if winning score is less than adhocthresh, then leave zero
t = ones(size(SfitN))*adhocthresh;
win = (SfitN > t);

[ia,ib] = find(win);
Yfit_max = NaN(size(YfitN));
Yfit_max(ia) = ib;
ind = find(sum(win')>1);
for count = 1:length(ind)
    [~,Yfit_max(ind(count))] = max(SfitN(ind(count),:));
end
Yfit_max(isnan(Yfit_max)) = length(classes)+1; %unclassified set to last class

[C, ~] = confusionmat(YN,classes2(Yfit_max));
total = sum(C')';

[TP TN FP FN] = conf_mat_props(C);
R = TP./(TP+FN); %recall
P = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c1)./sum(c1)'
F1= 2*((P.*R)./(P+R));  

fxUnclass = C(:,end)./total;
class=classes2;
aht=table(class,total,R,P,F1,fxUnclass);
aht(end,:)=[];
clearvars i ia ib F1 R P t TP TN FP FN ind win Yfit_max

%% opt threshold
t = repmat(maxthre,length(YfitN),1);
win = (SfitN > t);
[ia,ib] = find(win);
Yfit_max = NaN(size(YfitN));
Yfit_max(ia) = ib;
ind = find(sum(win')>1);
for count = 1:length(ind)
    [~,Yfit_max(ind(count))] = max(SfitN(ind(count),:));
end
Yfit_max(isnan(Yfit_max)) = length(classes)+1; %unclassified set to last class

[C, ~] = confusionmat(YN,classes2(Yfit_max));
total = sum(C')';

[TP TN FP FN] = conf_mat_props(C);
R = TP./(TP+FN); %recall
P = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c1)./sum(c1)'
F1= 2*((P.*R)./(P+R));  

fxUnclass = C(:,end)./total;
class=classes2;
optthr=[maxthre';NaN];
opt=table(class,total,R,P,F1,fxUnclass,optthr);
opt(end,:)=[];
clearvars i ia ib F1 R P t TP TN FP FN ind win Yfit_max

%% make plot of Autoclassifier probability
% % this might be wrong
% mSfitN=mSfit(idx);
% classid=ii(idx);
% val=20
% %total=length(mSfit)
% 
% figure;
% histogram(mSfitN(classid==val),0:.05:1); hold on;
% %set(gca,'xdir','reverse')
% xlabel('Autoclassifier Probability')
% ylabel('number of images')
% title(classes(val))
%%
save([outpath 'threshold/' classifierpath(37:end) '/HakeTestSet_performance_' classifierpath(37:end) ''],...
    'Nclass','maxthre','threlist','opt','aht','all','adhocthresh','class','Precision','Recall','F1score','tPos','fNeg','fPos');
