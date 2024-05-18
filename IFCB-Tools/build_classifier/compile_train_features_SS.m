function [  ] = compile_train_features_SS(manualpath,feapath_base,outpath,maxn,minn,classifiername,class2useName,varargin)
%% function [  ] = compile_train_features_user_training( manualpath , feapath_base, maxn, minn, class2skip, class2group)
% class2skip and class2merge are optional inputs
% For example:
%compile_train_features_user_training('C:\work\IFCB\user_training_test_data\manual\', 'C:\work\IFCB\user_training_test_data\features\', 100, 30, {'other'}, {'misc_nano' 'Karenia'})
%IFCB classifier production: get training features from pre-computed bin feature files
%  A.D Fischer, September 2021

%% %Example inputs: 
% clear
% class2useName ='D:\general\config\class2use_13';
% manualpath = 'D:\general\classifier\manual_merged_ungrouped\'; % manual annotation file location
% feapath_base = 'D:\general\classifier\features_merged_ungrouped\'; %feature file location, assumes \yyyy\ organization
% outpath = 'D:\general\classifier\summary\'; % location to save training set
% maxn = 5000; %maximum number of images per class to include
% minn = 500; %minimum number for inclusion
% varargin{1}={'Actiniscus','Actinoptychus','Akashiwo','Amphidinium','Asteromphalus','Attheya','Aulacodiscus','Azadinium','Bacillaria','Boreadinium','Ceratium','Chaetoceros_external_pennate','Chaetoceros_setae','Chaetoceros_socialis','Clusterflagellate','Corethron','Coscinodiscus','Dictyocha','Dinobryon','Dinophyceae_pointed','Dinophyceae_round','Dinophysis','Ebria','Entomoneis','Ephemera','Fibrocapsa','Fragilaria','Gonyaulux','Gyrodinium','Helicotheca','Hemiaulus','Heterocapsa_triquetra','Karenia','Laboea_strobila','Licmophora','Lingulodinium','Lioloma','Lithodesmium','Margalefidinium','Meringosphaera','Mesodinium','Nematodinium','Noctiluca','Odontella','Oxyphysis','Paralia','Phaeocystis','Plagiogrammopsis','Pleuronema','Pleurosigma','Polykrikos','Proterythropsis','Protoperidinium','Pseudo_nitzschia_external_parasite','Pyrophacus','Sea_Urchin_larvae','Striatella','Strombidium','Thalassionema','Tiarina_fusus','Tintinnida','Tontonia','Torodinium','Tropidoneis','Verrucophora farcimen (cf)','bead','bubble','centric','ciliate','coccolithophorid','cyanobacteria','cyst','detritus','flagellate','nauplii','pollen','unclassified','veliger','zooplankton','Bacteriastrum','Thalassiosira_single','pennate','nanoplankton','cryptophyta'};
% varargin{2}={{'Pseudo-nitzschia' 'Pseudo_nitzschia_small_1cell' 'Pseudo_nitzschia_large_1cell' 'Pseudo_nitzschia_large_2cell' 'Pseudo_nitzschia_small_2cell' 'Pseudo_nitzschia_small_3cell' 'Pseudo_nitzschia_large_3cell' 'Pseudo_nitzschia_small_4cell' 'Pseudo_nitzschia_large_4cell' 'Pseudo_nitzschia_small_5cell' 'Pseudo_nitzschia_large_5cell' 'Pseudo_nitzschia_small_6cell' 'Pseudo_nitzschia_large_6cell'}...
%         {'Dinophysis' 'Dinophysis_acuminata' 'Dinophysis_acuta' 'Dinophysis_caudata' 'Dinophysis_fortii' 'Dinophysis_norvegica' 'Dinophysis_odiosa' 'Dinophysis_parva' 'Dinophysis_rotundata' 'Dinophysis_tripos'}...
%         {'Chaetoceros_chain' 'Chaetoceros_single'}... 
%         {'Stephanopyxis' 'Melosira'}...      
%         {'Cerataulina' 'Dactyliosolen' 'Detonula' 'Guinardia'}... 
%         {'Rhizosolenia' 'Proboscia'}...                
%         {'Gymnodinium' 'Heterosigma' 'Scrippsiella'}};
% varargin{3}='NOAA'; %which group of annotations that annotations should be selected from
% varargin{4}=19; %which seascape that annotations should be selected from
% varargin{5}='C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\NOAA\SeascapesProject\Data\SeascapeSummary_NOAA-OSU-UCSC';
% classifiername=['CCS_ss' num2str(varargin{4}) '_v1']; 

% %other examples
% varargin{1}=[]; %class2group with nothing to skip
% varargin{2}=[]; %class2group with nothing to group
% varargin{3}=[]; %annotations from all user groups
% varargin{4}=[]; %annotations from all seascapes

addpath(genpath(manualpath));
addpath(genpath(feapath_base));

class2skip = []; %initialize
class2group = {[]};
if length(varargin) >= 1
    class2skip = varargin{1};
end
if length(varargin) > 1
    class2group = varargin{2};
end

if length(class2group{1}) > 1 && ischar(class2group{1}{1}) %input of one group without outer cell 
    class2group = {class2group};
end

% select annotations from either NOAA, UCSC, OSU, or all combined
if strcmp(varargin{3},'NOAA')
    group_files = [dir([manualpath 'D*IFCB777.mat']);dir([manualpath 'D*IFCB117.mat']);dir([manualpath 'D*IFCB150.mat'])];    
elseif strcmp(varargin{3},'UCSC')
    group_files = dir([manualpath 'D*IFCB104.mat']);
elseif strcmp(varargin{3},'OSU')
    group_files = dir([manualpath 'D*IFCB122.mat']);
elseif strcmp(varargin{3},'NOAA-OSU')
    group_files = [dir([manualpath 'D*IFCB777.mat']);dir([manualpath 'D*IFCB117.mat']);dir([manualpath 'D*IFCB150.mat']);dir([manualpath 'D*IFCB122.mat'])];        
else
    group_files = dir([manualpath 'D*.mat']);
end

group_files = {group_files.name}';

%%%% select annotations from a particular seascape
load(varargin{5},'S');
ss_files=S.filename(([S.ss]==varargin{4}));
[~,ia,~]=intersect(group_files,ss_files);        
manual_files=group_files(ia);

fea_files = regexprep(manual_files, '.mat', '_fea_v2.csv');
manual_files = regexprep(manual_files, '.mat', '');    

load([class2useName '.mat'],'class2use');

if ~(manualpath(end) == filesep), manualpath = [manualpath filesep]; end

fea_all = [];
class_all = [];
files_all = [];
%test for feapath format
feapath_flag = 0;
feapath=[feapath_base manual_files{1}(2:5) filesep];
if ~exist([feapath fea_files{1}], 'file')
    feapath=[feapath_base 'features' manual_files{1}(2:5) '_v2' filesep];
    feapath_flag = 1;
    if ~exist([feapath fea_files{1}], 'file')
        disp('Error: First feature file not found; Check input path')
        return
    end
end
 
for filecount = 1:length(manual_files) %looping over the manual files
    if feapath_flag
        feapath=[feapath_base 'features' manual_files{filecount}(2:5) '_v2' filesep];
    else
        feapath=[feapath_base manual_files{filecount}(2:5) filesep];
    end
    
    disp(['file ' num2str(filecount) ' of ' num2str(length(manual_files)) ': ' manual_files{filecount}])
    manual_temp = load([manualpath manual_files{filecount}]);
    
    fea_temp = importdata([feapath fea_files{filecount}]); %import data from the feature files
    
    if ~isequal(manual_temp.class2use_manual, class2use)
        class2use_min = min([length(manual_temp.class2use_manual) length(class2use)]);
        disp('class2use_manual does not match previous files!!!')
        if isequal(manual_temp.class2use_manual(1:class2use_min), class2use(1:class2use_min))
            disp('class2use missing entries on end')
            if length(class2use) < class2use_min %if the loaded file has more entries update class2use
                class2use = manual_temp.class2use_manual;
            end
        else
            disp('error here: class2use entries do not match')
            keyboard
        end
    end
    %ind_nan=isnan(manual_temp.classlist(fea_temp.data(:,1),2));
    class_temp = manual_temp.classlist(fea_temp.data(:,1),2);
    ind_nan = find(isnan(class_temp));
    class_temp(ind_nan) = manual_temp.classlist(fea_temp.data(ind_nan,1),3);
    ind_nan = find(isnan(class_temp));
    class_temp(ind_nan) = [];
    fea_temp.data(ind_nan,:) = [];
    class_all = [class_all; class_temp];%This assume you have only manual annotations not classifier pre classified classes
    fea_all = [fea_all; fea_temp.data];
    files_all = [files_all; repmat(manual_files(filecount),size(fea_temp.data,1),1)];

end

featitles = fea_temp.textdata;
[~,i] = setdiff(featitles, {'FilledArea' 'summedFilledArea' 'Area' 'ConvexArea' 'MajorAxisLength' 'MinorAxisLength' 'Perimeter', 'roi_number'}');
featitles = featitles(i);
roinum = fea_all(:,1);
fea_all = fea_all(:,i);

clear *temp

if ~isempty(varargin{3})
    [n, class_all, varargout] = handle_train_maxn( class2use, maxn, class_all, fea_all, files_all, roinum );
    fea_all = varargout{1};
    files_all = varargout{2};
    roinum = varargout{3};
else
    disp('evenly distribute NOAA, UCSC, and OSU image annotations')    
    [n, class_all, varargout] = handle_train_maxn_subsample( class2use, maxn, class_all, fea_all, files_all, roinum );
    fea_all = varargout{1};
    files_all = varargout{2};
    roinum = varargout{3};
end

if iscolumn(n)%make sure that n is a row
    n=n';
end

[ n, class_all, varargout ] = handle_train_class2skip( class2use, class2skip, n, class_all, fea_all, files_all, roinum );
fea_all = varargout{1};
files_all = varargout{2};
roinum = varargout{3};

save([outpath 'Temporary_' classifiername],'n','maxn','minn','class2skip','class2group','class_all', 'fea_all','files_all','roinum','class2use', 'featitles');

[ n, class_all, class2use, varargout ] = handle_train_class2group_NWFSC( class2use, class2group, maxn, n, class_all, fea_all, files_all, roinum );
fea_all = varargout{1};
files_all = varargout{2};
roinum = varargout{3};

[ n, class_all, varargout ] = handle_train_minn( minn, n, class_all, fea_all, files_all, roinum );
fea_all = varargout{1};
files_all = varargout{2};
roinum = varargout{3};

train = fea_all;
class_vector = class_all;
targets = cellstr([char(files_all) repmat('_', length(class_vector),1) num2str(roinum, '%05.0f')]);
nclass = n;

save([outpath 'Train_' classifiername], 'train', 'class_vector', 'targets', 'class2use', 'nclass', 'featitles');
disp('Training set feature file stored here:')
disp([outpath 'Train_' classifiername])