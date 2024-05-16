%% plot manual vs classifier results for Budd Inlet
clear;

class2do_string='Dinophysis'; ymax=20;
%class2do_string='Mesodinium'; ymax=35; 

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
outpath = [filepath 'IFCB-Data/BuddInlet/class/Figs/'];
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'IFCB-Data/BuddInlet/manual/count_class_manual'],...
    'class2use','classcount','matdate','ml_analyzed','filelist');
load([filepath 'NOAA/BuddInlet/Data/BuddInlet_data_summary'],'T');
load([filepath 'IFCB-Data/BuddInlet/class/summary_allTB_bythre_Dinophysis_Mesodinium'],...
    'dinocount_above_threTB','mesocount_above_threTB','threlist','filelistTB','mdateTB','ml_analyzedTB');

if contains(class2do_string,'Dinophysis')==1    
    classcountTB_above_thre=dinocount_above_threTB;
else
    classcountTB_above_thre=mesocount_above_threTB;    
end

T((T.dt<datetime('04-Aug-2021')),:)=[];

% match up data
%%%% find matched files and class of interest
for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24);
end
[~,im,it] = intersect({filelist.newname}, filelistTB); %finds the matched files between automated and manually classified files
mdateTB=datetime(mdateTB(it),'convertfrom','datenum');
ml_analyzedTB=ml_analyzedTB(it);

ml_analyzed=ml_analyzed(im);
filelist={filelist(im).name}';
matdate=datetime(matdate(im),'convertfrom','datenum');
imclass=find(contains(class2use,class2do_string));

man=sum(classcount(im,imclass),2)./ml_analyzed;
auto=classcountTB_above_thre(it,:)./ml_analyzedTB; type='th';
clearvars filelist im it i imclass ind class2use classcount ml_analyzed;

[~,label]=get_class_ind(class2do_string,'all',class_indices_path);

%%%% stem plot by year
yrlist={'2021';'2022';'2023'};

%fit = goodnessOfFit(auto(:,i),man,'MSE');

for i=1:length(threlist)

    %%%% plot scatter plot
    figure('Units','inches','Position',[1 1 3.5 3.5],'PaperPositionMode','auto');
    plot([0 ymax],[0 ymax],'k--'); hold on;  
    plot(man,auto(:,i),'ko','Markersize',5); hold on;
    lin_fit{i} = fitlm(man,auto(:,i));
    Rsq(i) = lin_fit{i}.Rsquared.ordinary;
    Coeffs(i,:) = lin_fit{i}.Coefficients.Estimate;
    coefPs(i,:) = lin_fit{i}.Coefficients.pValue;
    RMSE(i) = lin_fit{i}.RMSE;
    eval(['fplot(@(x)x*' num2str(Coeffs(i,2)) '+' num2str(Coeffs(i,1)) ''' , xlim, ''color'', ''r'')'])
    set(gca,'xlim',[0 ymax],'ylim',[0 ymax],'fontsize',10,'TickDir','out','fontsize',10,'box','on');
    axis square;
    addFigureLetter(gca,[' r^2=' num2str(round(Rsq(i),2)), ', RMSE=' num2str(round(RMSE(i),2))],2,'fontsize',12); hold on    
    
    xlabel('manual','fontsize',12)
    ylabel('classifier','fontsize',12)
    title(['th=' num2str(threlist(i)) ' ' char(label) ' (cells mL^{-1})'],'fontsize',12);
    m(i) = Coeffs(i,2);

    % set figure parameters
    exportgraphics(gcf,[outpath 'Scatter_' num2str(class2do_string) ' ' type '_' num2str(threlist(i)) '.png'],'Resolution',100)    
    hold off

    %%%% plot by year
    figure('Units','inches','Position',[1 1 4 4],'PaperPositionMode','auto');
    subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.08 0.08], [0.14 0.14]);
    %subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
    %where opt = {gap, width_h, width_w} describes the inner and outer spacings.

    for j=1:length(yrlist)
        ax(j)=subplot(3,1,j);
        hm=plot(matdate,man,'r*','Markersize',3,'linewidth',.8); hold on;   

    if contains(class2do_string,'Dinophysis')==1 %adjust slope only if Dinophysis
        hc=stem(matdate,auto(:,i)./m(i),'k-','Linewidth',.5,'Marker','none'); hold on;
    else
        hc=stem(matdate,auto(:,i),'k-','Linewidth',.5,'Marker','none'); hold on;
    end
        hmm=plot(T.dt,T.mesoML_microscopy,'bo','MarkerSize',4); hold on;     

    if contains(class2do_string,'Dinophysis')==1    
            hmm=plot(T.dt,T.dinoML_microscopy,'bo','MarkerSize',4); hold on;    
    end
        set(gca,'xgrid','on','tickdir','out','xlim',[datetime([char(yrlist(j)) '-05-01']) datetime([char(yrlist(j)) '-10-01'])],...
            'xticklabel',{},'ylim',[0 ymax],'fontsize',10,'ycolor','k'); 
        ylabel(char(yrlist(j)),'fontsize',12);   
  
    end
    datetick('x', 'mmm', 'keeplimits');            
    ax(1).Title.String=[type '=' num2str(threlist(i)) ' ' char(label) ' (cells mL^{-1})'];
    lh=legend([hmm hm hc],'microscopy','manual',['class (' type '=' num2str(threlist(i)) ')'],'location','nw'); hp=get(lh,'pos');
    lh.Position=[hp(1) hp(2)+.58 hp(3) hp(4)]; hold on    
     
    % set figure parameters
    exportgraphics(gcf,[outpath 'Manual_auto_' num2str(class2do_string) ' ' type '_' num2str(threlist(i)) '.png'],'Resolution',100)    
    hold off

end

clearvars classcountTB_above_thre threlist filelistTB mdateTB ml_analyzedTB; 

%%%% save data
% load([filepath 'IFCB-Data/BuddInlet/class/' filename ],'class2do','class2useTB',...
%     'classcountTB_above_thre','threlist','filelistTB','mdateTB','ml_analyzedTB');
load([filepath 'IFCB-Data/BuddInlet/class/summary_allTB_bythre_Dinophysis_Mesodinium'],...
    'dinocount_above_threTB','mesocount_above_threTB','threlist','filelistTB',...
    'filecommentTB','runtypeTB','mdateTB','ml_analyzedTB');

if (contains(class2do_string,'Dinophysis'))==1   
    chosen_threshold=.75;
    idx=find(threlist>=chosen_threshold,1);        
    slope=m(idx);
    classcount_adjust_TB=dinocount_above_threTB(:,idx)./slope;  
elseif (contains(class2do_string,'Mesodinium'))==1   
    chosen_threshold=.5;  
    idx=find(threlist>=chosen_threshold,1);        
    slope=1;    
    classcount_adjust_TB=mesocount_above_threTB(:,idx)./slope;    
end

save([filepath 'IFCB-Data/BuddInlet/class/summary_adjustedTB_' class2do_string],...
    'chosen_threshold','slope','class2do_string',...
    'classcount_adjust_TB','filelistTB','mdateTB','ml_analyzedTB','filecommentTB','runtypeTB');

