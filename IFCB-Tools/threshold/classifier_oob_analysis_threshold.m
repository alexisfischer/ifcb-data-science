%% classifier_oob_analysis_threshold
% analyzes classifier output with chosen thresholds
% Out of bag assessment
%   Alexis D. Fischer, NOAA NWFSC, February 2023
clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath(filepath));
classifiername='CCS_v2';
classifierpath='~/Downloads/';

load([classifierpath 'Trees_' classifiername],'b','classes','featitles','maxthre','targets');

[slope,bin,chosen_threshold] = summarize_chosen_thresholds(...
    classes,[filepath 'IFCB-Data/Shimada/threshold/' classifiername '/'],classifiername);

%%%%
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

%%%% chosen threshold interpretation of scores
t = repmat(chosen_threshold',length(Yfit),1);
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
[c_thr, class] = confusionmat(b.Y,classes2(Yfit_max));
total = sum(c_thr')';
[TP TN FP FN] = conf_mat_props(c_thr);
R = TP./(TP+FN); %recall
P = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c1)./sum(c1)'
F1= 2*((P.*R)./(P+R));
disp(['chosen threshold error rate = ' num2str(1-sum(TP)./sum(total)) '']);

totalfxun=length(find(Yfit_max==length(classes2)))./length(Yfit_max);
fxUnclass = c_thr(:,end)./total;
fxUnclass(end)=totalfxun;
thr=table(class,total,R,P,F1,fxUnclass);

%%%% ignore unclassified
c_thrb = c_thr(1:end-1,1:end-1); %ignore the instances in 'unknown'
total = sum(c_thrb')';
[TP TN FP FN] = conf_mat_props(c_thrb);
R = TP./(TP+FN); %recall
P = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c1)./sum(c1)'
F1= 2*((P.*R)./(P+R));
disp(['chosen threshold error rate (ignore unclassified) = ' num2str(1-sum(TP)./sum(total)) '']);

thrb=table(class(1:end-1),total,R,P,F1);

clearvars TP TN FP FN total ind count i ii t j classes2 class Pm P R ind F1 totalfxun fxUnclass

load([filepath 'IFCB-Data/Shimada/class/performance_classifier_' classifiername],...
    'topfeat','NOAA','UCSC','OSU','all','opt','optb','c_all','c_opt','c_optb');

save([filepath 'IFCB-Data/Shimada/class/performance_classifier_' classifiername ],...
    'thr','thrb','c_thr','c_thrb','chosen_threshold','maxthre','topfeat','NOAA','UCSC','OSU','all','opt','optb','c_all','c_opt','c_optb');

