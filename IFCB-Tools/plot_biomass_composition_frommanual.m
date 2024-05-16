% Use MC files to find who is representing the biomass to determine which classes should be used in classifier
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
clear;

CCS=0;
filepath = '/Users/afischer/MATLAB/bloom-baby-bloom/';

if CCS==1
    load([filepath 'IFCB-Data/Shimada/manual/count_class_biovol_manual'])
    load([filepath 'IFCB-Data/Shimada/manual/TopClasses'],'class2use');
    remove={'D_acuminata' 'D_acuta' 'D_caudata' 'D_fortii' ...
        'D_norvegica' 'D_odiosa' 'D_parva' 'D_rotundata' 'D_tripos'};
    xax1=datetime('2019-07-20'); xax2=datetime('2019-08-20');     
    
else
    load([filepath 'IFCB-Data/BuddInlet/manual/count_class_biovol_manual'])
    load([filepath 'IFCB-Data/BuddInlet/manual/TopClasses'],'class2use'); 
    remove={'D_acuminata' 'D_acuta' 'D_caudata' 'D_fortii' ...
        'D_norvegica' 'D_odiosa' 'D_parva' 'D_rotundata' 'D_tripos'};
    xax1=datetime('2021-08-04'); xax2=datetime('2021-08-14');     
end

% concatenate biovolume for each class in each sample
volB=NaN*ones(length(BiEq),length(class2use_manual)); %preset biovolume matrix
volC=(volB); %preset carbon matrix
ind_diatom = get_diatom_ind_PNW(class2use_manual);

for i=1:length(class2use_manual)
    for j=1:length(BiEq)
        idx=find([BiEq(j).class]==i); %find indices of a particular class
        b=nansum(BiEq(j).biovol(idx)); %match and sum biovolume
        volB(j,i)=b./BiEq(j).ml_analyzed; %convert to um^3/mL
    end
end

% convert from biovolume to carbon
for i=1:length(BiEq)    
    volC(i,:)=biovol2carbon(volB(i,:),ind_diatom)./1000; %convert from pg/cell to ug/L 
end

% only plot Top classes + unclassified
if CCS==0
    idx=find(ismember(class2use,remove));
    idxD=find(ismember(class2use,{'Dinophysis'}));
    volC(:,idxD)=sum(volC(:,[idx;idxD]),2);
end
class2use(ismember(class2use,remove))=[]; %remove preset classes

class2use{end+1}='unclassified'; %add unclassified back
idx=~ismember(class2use_manual,class2use);
volC(:,idx)=[]; class2use_manual(idx)=[];
[~,label] = get_phyto_ind_PNW(class2use_manual);   

% find fraction Carbon
sampletotal=repmat(nansum(volC,2),1,size(volC,2));
fxC=volC./sampletotal;
fxC(isnan(fxC))=0;

clearvars i j idx b note1 note2 ind_diatom volB

figure('Units','inches','Position',[1 1 8 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.1 0.04], [0.08 0.3]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

mdate=datetime([BiEq.matdate]','convertfrom','datenum');

subplot(2,1,1);
h = bar(mdate,fxC,'stack','Barwidth',15,'EdgeColor','none');
    ylabel('Fx total C','fontsize',12);
    %datetick('x', 'mm/dd', 'keeplimits');    
    set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
        'fontsize', 12,'fontname', 'arial','tickdir','out',...
        'yticklabel',{'.2','.4','.6','.8','1'},'xticklabel',{});    
    col=brewermap(length(class2use),'Spectral'); col(1,:)=[.8 .8 .8];
    for i=1:length(h)
        set(h(i),'FaceColor',col(i,:));
    end   
    lh=legend(label,'location','EastOutside');
    legend boxoff; lh.FontSize = 10; hp=get(lh,'pos');
    lh.Position=[hp(1)*1.83 hp(2)+.04 hp(3) hp(4)]; hold on    
 
subplot(2,1,2);
    % exlude unclassified
    volC(:,get_unclassified_ind_PNW(class2use))=[];    
    sampletotal=repmat(nansum(volC,2),1,size(volC,2));
    fxC=volC./sampletotal;
        
h = bar(mdate,fxC,'stack','Barwidth',15,'EdgeColor','none');
    ylabel('Fx total C (excluding unclassified)','fontsize',12);
    %datetick('x', 'mm/dd', 'keeplimits');    
    set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
        'fontsize', 12,'fontname', 'arial','tickdir','out',...
        'yticklabel',{'.2','.4','.6','.8','1'});    
    
    col(1,:)=[];
    for i=1:length(h)
        set(h(i),'FaceColor',col(i,:));
    end   

set(gcf,'color','w');
if CCS==1
    print(gcf,'-dtiff','-r100',[filepath 'NOAA/Shimada/Figs/FxCarbonBiomass_Manual_Shimada.tif']);
else
    print(gcf,'-dtiff','-r100',[filepath 'NOAA/BuddInlet/Figs/FxCarbonBiomass_Manual_BuddInlet.tif']);
end
    hold off
