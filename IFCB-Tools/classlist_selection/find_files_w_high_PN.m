%% find Shimada files with high PN
%  A.D Fischer, January 2023
%
clear;
classifiername='CCS_v10';

filepath = '~/Documents/MATLAB/ifcb-data-science/';
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   
outpath = [filepath 'IFCB-Data/Shimada/threshold/' classifiername '/Figs/'];

addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'IFCB-Data/Shimada/manual/count_class_biovol_manual'],'class2use','classcount','matdate','ml_analyzed','filelist');
load([filepath 'IFCB-Data/Shimada/class/summary_biovol_allTB_' classifiername],...
    'class2useTB','classcountTB_above_optthresh','filelistTB','mdateTB','ml_analyzedTB');

%%%% sum up grouped classes and account for different chain length
class2do_full=['Pseudo-nitzschia_large_1cell,Pseudo-nitzschia_small_1cell,'...
    'Pseudo-nitzschia_large_2cell,Pseudo-nitzschia_small_2cell,'...
    'Pseudo-nitzschia_large_3cell,Pseudo-nitzschia_small_3cell,'...
    'Pseudo-nitzschia_large_4cell,Pseudo-nitzschia_small_4cell'];
ind = strfind(class2do_full, ',');
if ~isempty(ind)
    ind = [0 ind length(class2do_full)];
    for i = 1:length(ind)-2
        imclass(i)=find(strcmp(class2use,class2do_full(ind(i)+1:ind(i+1)-1)),1);
    end
    i=length(ind)-1;
    imclass(i)=find(strcmp(class2use,class2do_full(ind(i)+1:ind(i+1))),1);
else
    imclass = find(strcmp(class2use,class2do_full));
end
man1=classcount(:,imclass);
m=ones(size(man1)); m(:,3:4)=2*m(:,3:4); m(:,5:6)=3*m(:,5:6); m(:,7:8)=4*m(:,7:8);
man=sum(man1.*m,2);

auto1=classcountTB_above_optthresh(:,strcmp('Pseudo-nitzschia_large_1cell,Pseudo-nitzschia_small_1cell',class2useTB));
auto2=classcountTB_above_optthresh(:,strcmp('Pseudo-nitzschia_large_2cell,Pseudo-nitzschia_small_2cell',class2useTB));
auto3=classcountTB_above_optthresh(:,strcmp('Pseudo-nitzschia_large_3cell,Pseudo-nitzschia_small_3cell',class2useTB));
auto4=classcountTB_above_optthresh(:,strcmp('Pseudo-nitzschia_large_4cell,Pseudo-nitzschia_small_4cell',class2useTB));
auto=sum([auto1,2*auto2,3*auto3,4*auto4],2);
mdateTB=datetime(mdateTB,'convertfrom','datenum');
matdate=datetime(matdate,'convertfrom','datenum');


%%%% find matched files and class of interest
for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24);
end
[~,ia]=setdiff(filelistTB,{filelist.newname}');

ib=find(auto(ia,:)>120);
high=auto(ia(ib),:);
files2do=filelistTB(ia(ib));
%clearvars man1 man2 auto1 auto2 imclas ind i

%%%% Plot automated vs manual classification cell counts
figure('Units','inches','Position',[1 1 4 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.1 0.1], [0.14 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

[~,label]=get_class_ind('Pseudo-nitzschia', 'all',class_indices_path);

subplot(2,1,1);
stem(mdateTB(ia),auto(ia,:)./ml_analyzedTB(ia),'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    plot(matdate,man./ml_analyzed,'r*','Markersize',6,'linewidth',.8);
    datetick('x', 'mmm', 'keeplimits');        
    set(gca,'xgrid','on','tickdir','out','xlim',[datetime('2019-06-01') datetime('2019-09-15')],...
        'xticklabel',{},'fontsize',10); 
    ylabel('2019','fontsize',12);    
    title([char(label) ' (cells mL^{-1})'],'fontsize',12); 
 legend('classifier (no manual matchup)','manual','location','nw');legend boxoff;

subplot(2,1,2);
stem(mdateTB(ia),auto(ia,:)./ml_analyzedTB(ia),'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    plot(matdate,man./ml_analyzed,'r*','Markersize',6,'linewidth',.8);
    set(gca,'xgrid','on','tickdir','out',...
        'xlim',[datetime('2021-06-01') datetime('2021-09-15')],'fontsize',10); 
    datetick('x', 'mmm', 'keeplimits');    
    ylabel('2021','fontsize',12);    
 
if contains(class2do_full,',')
    class2do_string = [extractBefore(class2do_full,',') '_grouped'];
else
    class2do_string=class2do_full;
end

% set figure parameters
exportgraphics(gcf,[outpath 'Pseudo-nitzschia_annotations_Feb2023.png'],'Resolution',100)    
hold off
