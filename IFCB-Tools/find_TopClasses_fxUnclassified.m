%% Use MC files to find who is representing the biomass to determine which classes should be used in classifier
% remove files where >70% of biomass is unclassified from top classses estimate
clear;

CCS=0;

% filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
% addpath(genpath(filepath)); % add new data to search path
% addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
% classidx=[filepath 'IFCB-Tools/convert_index_class/class_indices'];

filepath='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\';
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\ifcb-analysis\')); % add new data to search path
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\')); % add new data to search path
classidx=[filepath 'IFCB-Tools\convert_index_class\class_indices'];

if CCS==1
    load([filepath 'IFCB-Data/Shimada/manual/count_class_biovol_manual'])
    outdir=[filepath 'IFCB-Data/Shimada/manual/'];
    num=45;
else
    load([filepath 'IFCB-Data/BuddInlet/manual/count_class_biovol_manual'],'ml_analyzed','classbiovol','class2use','filelist')
    outdir=[filepath 'IFCB-Data/BuddInlet/manual/'];    
    num=35;
end
%new=class2use';

% Exclude nonliving, misc zooplankton, and misc larvae
classbiovol(:,get_class_ind(class2use,'nonliving',classidx))=NaN;
classbiovol(:,get_class_ind(class2use,'larvae',classidx))=NaN;
classbiovol(:,get_class_ind(class2use,'zooplankton',classidx))=NaN;

% find files where >70% of images are unclassified and remove those files from top classses estimate
bioml=classbiovol./ml_analyzed;

sampletotal=repmat(nansum(bioml,2),1,size(bioml,2));
fxUnc=bioml(:,strcmp('unclassified',class2use))./sampletotal(:,strcmp('unclassified',class2use)); 
idx=(fxUnc>.5);
%filename={filelist.name}'; filename_unclassified=filename(idx);
classbiovol(idx,:)=[]; sampletotal(idx,:)=[]; fxUnc(idx)=[]; bioml(idx,:)=[];
clearvars classbiovol fxUnc idx filelist  ml_analyzed

% Exclude select misc phytoplankton
bioml(:,strcmp('unclassified',class2use))=NaN;
bioml(:,strcmp('flagellate',class2use))=NaN;
bioml(:,strcmp('Dinophyceae_pointed',class2use))=NaN;
bioml(:,strcmp('Dinophyceae_round',class2use))=NaN;
bioml(:,strcmp('centric',class2use))=NaN;
bioml(:,strcmp('nanoplankton',class2use))=NaN;
bioml(:,strcmp('Chaetoceros_external_pennate',class2use))=NaN;

% find highest biomass cells
fxC_all=bioml./sampletotal;
classtotal=sum(bioml,1);
[~,idx]=maxk(classtotal,num); %find top biomass classes
fxC=fxC_all(:,idx);
topclasses=class2use(idx);

fxCC=classtotal./(nansum(classtotal));
fxCC=fxCC(idx);

% produce classlists to allow for grouped classes in classifier
%add back in species for Pseudo-nitzschia, Dinophysis, Chaetoceros, Thalassiosira classes

if sum(contains(topclasses,'Dinophysis'))>0
    disp('Dinophysis')
    temp={'Dinophysis_acuminata' 'Dinophysis_fortii' 'Dinophysis_norvegica' 'Dinophysis_parva'};
    topclasses=[topclasses,temp];
end

if sum(contains(topclasses,'Pseudo-nitzschia'))>0
    disp('Pseudo-nitzschia')
    temp={'Pseudo-nitzschia_small_1cell' 'Pseudo-nitzschia_small_2cell' 'Pseudo-nitzschia_small_3cell' 'Pseudo-nitzschia_small_4cell' 'Pseudo-nitzschia_small_5cell' 'Pseudo-nitzschia_small_6cell' ...
        'Pseudo-nitzschia_large_1cell' 'Pseudo-nitzschia_large_2cell' 'Pseudo-nitzschia_large_3cell' 'Pseudo-nitzschia_large_4cell' 'Pseudo-nitzschia_large_5cell' 'Pseudo-nitzschia_large_6cell'};
    topclasses=[topclasses,temp];    
end

if sum(contains(topclasses,'Chaetoceros'))>0
    disp('Chaetoceros')    
    topclasses=[topclasses,{'Chaetoceros_chain' 'Chaetoceros_single'}];   
end

[topclasses,~]=unique(topclasses);
topclasses=sort(topclasses)';

save([outdir 'TopClasses'],'topclasses');


