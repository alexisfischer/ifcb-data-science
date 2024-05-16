function [class] = summarize_class(class2do_string,Thr_sum,biovol_sum,class_sum,resultpath)

% class2do_string = 'Alexandrium_singlet'; 
% Thr_sum = ['C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\Data\Coeff_' class2do_string];
% biovol_sum = 'F:\IFCB113\manual\summary\count_biovol_manual_11Jun2018';
% class_sum = ['F:\IFCB113\class\summary\summary_allTB_bythre_' class2do_string];
% resultpath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\';
%%
load(Thr_sum);
load(biovol_sum);
load(class_sum);

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

[ mdateTBi, y_mati] = filltimeseriesgaps( mdateTB, y_mat );
[y_matii] = interp1babygap(y_mati,3);

ind2 = strmatch(class2do_string, class2use); %change this for whatever class you are analyzing

% Makes day bins for the matched manual counts.
[matdate_bin_auto, classcount_bin_auto, ml_analyzed_mat_bin_auto] =...
    make_day_bins(matdate(im),classcount(im,ind2), ml_analyzed(im)); 

% Takes the series of day bins and puts it into a year x day matrix.
[mdate_mat_manual, y_mat_manual, yearlist, yd ] =...
    timeseries2ydmat(matdate_bin_auto,classcount_bin_auto./ml_analyzed_mat_bin_auto); 

%ind=(find(y_mat)); % find dates associated with nonzero elements
%mdate_val=[mdateTB(ind),y_mat(ind)];

class(1).name = class2do_string;
class(1).chosen_threshold=chosen_threshold;
class(1).bin=bin;
class(1).slope=slope;
class(1).y_mat=y_matii;
class(1).y_mat_manual=y_mat_manual;
class(1).mdateTB=mdateTBi;
class(1).mdate_mat_manual=mdate_mat_manual;
class(1).filelist=string(filelistTB);

save([resultpath 'Data/IFCB_summary/class/' num2str(class2do_string) '_summary'],'class');

end

