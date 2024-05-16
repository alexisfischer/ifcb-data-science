%% plot manual vs classifier results for a list of classes you indicate
%  Alexis D. Fischer, University of California - Santa Cruz, April 2020
%
clear;
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
addpath(genpath('~/MATLAB/UCSC/ACIDD/')); % add new data to search path

filepath = '~/MATLAB/bloom-baby-bloom/IFCB-Data/SCW/'; 
outpath = '~/MATLAB/UCSC/Figs/'; 

%load classifier summary data
load([filepath '/class/summary_allTB_2019'],...
    'class2useTB','ml_analyzedTB','mdateTB','classcountTB_above_optthresh'); % ADF note: be sure to use classcountTB_above_optthresh for classifier output
%%
%load manual summary data
load([filepath 'Data/IFCB_summary/manual/count_class_manual_2020'],...
    'matdate','ml_analyzed','classcount','filelist','class2use');

% enter the classes you want to plot
classname={'Akashiwo','Alexandrium','Amy-Gony-Protoc','Asterionellopsis',...
    'Centric','Ceratium','Chaetoceros','Cochlodinium','NanoP-less10',...
    'Cyl-Nitz','Det-Cer-Lau','Dictyocha','Dinophysis','Eucampia','Guin-Dact',...
    'Gymnodinium','Lingulodinium','Pennate','Prorocentrum','Pseudo-nitzschia',...
    'Scrip-Het','Skeletonema','Thalassionema','Thalassiosira','unclassified'};

%% merge manual files for merged classes
%%%% merge Cryptophyte, NanoP_less10, small_misc
idx = strcmp('Cryptophyte',class2use);
classcount(:,idx)=nansum(...
    [classcount(:,strcmp('Cryptophyte',class2use)),...
    classcount(:,strcmp('NanoP_less10',class2use)),...
    classcount(:,strcmp('small_misc',class2use))],2);
class2use(idx)={'Cryptophyte,NanoP_less10,small_misc'};
classcount(:,strcmp('NanoP_less10',class2use))=[];
class2use(strcmp('NanoP_less10',class2use))=[];
classcount(:,strcmp('small_misc',class2use))=[];
class2use(strcmp('small_misc',class2use))=[];

%%%% merge Gymnodinium, Peridinium
idx = strcmp('Gymnodinium',class2use);
classcount(:,idx)=nansum(...
    [classcount(:,strcmp('Gymnodinium',class2use)),...
    classcount(:,strcmp('Peridinium',class2use))],2);
class2use(idx)={'Gymnodinium,Peridinium'};
classcount(:,strcmp('Peridinium',class2use))=[];
class2use(strcmp('Peridinium',class2use))=[];

%% plot
figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.05], [0.07 0.03], [0.05 0.02]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

for i=1:length(class2useTB)
    id = strcmp(class2useTB(i), class2use); %change this for whatever class you are analyzing
   % idTB = strcmp(classlistTB(i), class2useTB); %change this for whatever class you are analyzing

    subplot(5,5,i)
    plot(classcount(:,id),classcountTB(:,i),'.','markersize',8); hold on;
    axis square
    
    lin_fit{i} = fitlm(classcount(:,id),classcountTB(:,i));
    Rsq(i) = lin_fit{i}.Rsquared.ordinary;
    Coeffs(i,:) = lin_fit{i}.Coefficients.Estimate;
    coefPs(i,:) = lin_fit{i}.Coefficients.pValue;
    RMSE(i) = lin_fit{i}.RMSE;
    eval(['fplot(@(x)x*' num2str(Coeffs(i,2)) '+' num2str(Coeffs(i,1)) ''' , xlim, ''color'', ''r'')'])
    
   if i==11
       ylabel('Automated','fontsize',16,'fontweight','bold'); 
   else
   end
    
   if i==23
       xlabel('Manual','fontsize',16,'fontweight','bold'); 
   else
   end
   
    m=max(classcount(:,id)); mTB=max(classcountTB(:,i));
    if m>mTB
        set(gca,'xlim',[0 m],'ylim',[0 m]);
    else
        set(gca,'xlim',[0 mTB],'ylim',[0 mTB]);
    end
    title(classname(i),'fontweight','normal');
    
    hold on    
end

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r300',[outpath '/classifiercompare.tif']);
hold off