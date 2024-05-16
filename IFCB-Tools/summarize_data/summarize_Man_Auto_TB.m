function [X] = summarize_Man_Auto_TB(class2do_string)

%class2do_string = 'Akashiwo'; 

resultpath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\';
load([resultpath 'Data\Coeff_' class2do_string]);

load('F:\IFCB104\manual\summary\count_biovol_manual_30Mar2018'); %USER
summary_path = 'F:\IFCB104\class\summary\'; %load automated count file with all thresholds you made from running 'countcells_allTB_class_by_thre_user.m'
load([summary_path 'summary_allTB_bythre_' class2do_string]);

for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24);
end

[~,im,it] = intersect({filelist.newname}, filelistTB); %finds the matched files between automated and manually classified files

% % Makes day bins for the matched automated counts
% [matdate_bin_match, classcount_bin_match, ml_analyzed_mat_bin_match] =...
%     make_day_bins(mdateTB(it),classcountTB_above_thre(it,bin),ml_analyzedTB(it)); 

% Makes day bins automated counts
[matdate_bin_match, classcount_bin_match, ml_analyzed_mat_bin_match] =...
    make_day_bins(mdateTB,classcountTB_above_thre(:,bin),ml_analyzedTB); 

% Takes the series of day bins for automated counts and puts it into a year x day matrix.
[ mdate_mat_match, y_mat_match, yearlist, yd ] =...
    timeseries2ydmat(matdate_bin_match,classcount_bin_match./ml_analyzed_mat_bin_match ); 

y_mat=classcount_bin_match./ml_analyzed_mat_bin_match;
y_mat((y_mat<0)) = 0; % cannot have negative numbers 

%fill gaps w NaNs
refvec =(matdate_bin_match(1):matdate_bin_match(end))';
newmat=nan(numel(refvec),size(matdate_bin_match,2));
newmat(ismember(refvec,matdate_bin_match(:,1)),:)=matdate_bin_match;
newy=nan(numel(refvec),size(matdate_bin_match,2));
newy(ismember(refvec,matdate_bin_match(:,1)),:)=y_mat;

ind2 = strmatch(class2do_string, class2use); %change this for whatever class you are analyzing

% Makes day bins for the matched manual counts.
[matdate_bin_auto, classcount_bin_auto, ml_analyzed_mat_bin_auto] =...
    make_day_bins(matdate(im),classcount(im,ind2), ml_analyzed(im)); 

% Takes the series of day bins and puts it into a year x day matrix.
[mdate_mat_manual, y_mat_manual, yearlist, yd ] =...
    timeseries2ydmat(matdate_bin_auto,classcount_bin_auto./ml_analyzed_mat_bin_auto); 

ind=(find(y_mat)); % find dates associated with nonzero elements
mdate_val=[mdateTB(ind),y_mat(ind)];

X.dn_auto=newmat;
X.y_auto=newy;
X.dn_man=mdate_mat_manual;
X.y_man=y_mat_manual;
%X.dn_man=[mdate_mat_manual(:,1);mdate_mat_manual(:,2);mdate_mat_manual(:,3);mdate_mat_manual(:,4)];
%X.y_man=[y_mat_manual(:,1);y_mat_manual(:,2);y_mat_manual(:,3);y_mat_manual(:,4)];
X.slope=slope;
X.yearlist=yearlist;

save([resultpath 'Data\AutoMan_'  class2do_string],'X');
end