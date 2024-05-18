function [ ] = make_TreeBaggerClassifier( result_path, classifiername, nTrees)
%function [ ] = make_TreeBaggerClassifier( result_path, train_filename, result_str, nTrees )
%For example:
%   make_TreeBaggerClassifier_user_training( 'C:\work\IFCB\user_training_test_data\manual\summary\', 'UserExample_Train_06Aug2015', 'UserExample_Trees_', 100)
% IFCB classification: create Random Forest classifier from training data
% modified HSosik code
%  A.D Fischer, December 2022
%
%run compile_train_features_user_training.m first to store input results in train_filename
% Example inputs:
% clear;
% result_path = 'D:\general\classifier\summary\'; %USER location of training file and classifier output
% classifiername='BI_NOAA-OSU_v2';
% nTrees = 100; %USER how many trees in your forest; choose enough to reach asymptotic error rate in "out-of-bag" classifications

load([result_path 'Train_' classifiername],'class2use','class_vector','featitles','nclass','targets','train'); 

% ungroup class2group {'NanoP_less10' 'Cryptophyte' 'small_misc'}  {'Gymnodinium' 'Peridinium'}};
%idx=strmatch('NanoP_less10',class2use); class_vector((class_vector==96))=idx;
%idx=strmatch('Gymnodinium',class2use); class_vector((class_vector==97))=idx;

%load fea2use
fea2use = 1:length(featitles);
featitles = featitles(fea2use);
classes = class2use;

%sort training set
if max(class_vector)>length(classes)
    idx=find(class_vector==max(class_vector));
    train(idx,:)=[];
    targets(idx)=[];
    class_vector(idx)=[];
else
end

[class_vec_str,sort_ind] = sort(classes(class_vector));
train = train(sort_ind,:);
targets = targets(sort_ind);
%%
disp('Growing trees...please be patient')
paroptions = statset('UseParallel','always');
b = TreeBagger(nTrees,train(:,fea2use),class_vec_str,'Method','c','OOBVarImp','on','MinLeaf',1,'Options',paroptions);

figure, hold on
plot(oobError(b), 'b-');
xlabel('Number of Grown Trees');
ylabel('Out-of-Bag Classification Error');

%%
%use code like this to add trees to an existing forest
%b = growTrees(b,100); %specify how many to add
%plot(oobError(b), 'g');

[Yfit,Sfit,Sstdfit] = oobPredict(b);
[mSfit, ii] = max(Sfit');
for count = 1:length(mSfit), mSstdfit(count) = Sstdfit(count,ii(count)); t(count)= Sfit(count,ii(count)); end; 
if isempty(find(mSfit-t)), clear t, else disp('check for error...'); end;
[c1, gord1] = confusionmat(b.Y,Yfit); %transposed from mine
clear t

%% find optimal threshold
classes = b.ClassNames;
maxthre = NaN(1,length(classes));

for count = 1:length(classes)
    old_ind = strmatch(b.ClassNames(count), class2use, 'exact');
    [X,Y,T,~,OPTROCPT] = perfcurve(b.Y,Sfit(:,count), class2use{old_ind});
    maxthre(count)=T((X==OPTROCPT(1))&(Y==OPTROCPT(2)));
end
clear count fpr tpr thr iaccu accu

save([result_path 'Trees_' classifiername],'b', 'targets','featitles','classes','maxthre','-v7.3')

disp('Classifier file stored here:')
disp([result_path 'Trees_' classifiername])

end