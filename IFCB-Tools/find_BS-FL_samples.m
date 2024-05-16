%% find BuddInlet scattering files
clear;
classifiername='NOAA-OSU_v1';
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';

addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'IFCB-Data/BuddInlet/class/summary_biovol_allTB_' classifiername],...
    'class2useTB','classcountTB_above_optthresh','filelistTB','mdateTB','ml_analyzedTB','filecommentTB','runtypeTB');


% find discrete samples (data with file comment)
idx=find(contains(runtypeTB,'ALT')); 

BS_runtype=runtypeTB(idx);
BS_filelist=filelistTB(idx);
FL_runtype=runtypeTB(idx+1);
FL_filelist=filelistTB(idx+1);

M=[[BS_filelist;FL_filelist],[BS_runtype;FL_runtype]];