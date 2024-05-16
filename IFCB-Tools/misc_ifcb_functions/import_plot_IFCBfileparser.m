%% plot data from IFCB fileparser
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path

%import ADC data
filename="/Users/alexis.fischer/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/IFCBparserresult_labtestPMTsettingsDANY1.xlsx";
opts = spreadsheetImportOptions("NumVariables", 19);
opts.Sheet = "ADC";
opts.DataRange = "A2:S16879";
opts.VariableNames = ["VarName1", "trigger", "Var3", "PMTA", "PMTB", "Var6", "Var7", "PeakA", "PeakB", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "RoiWidth", "RoiHeight", "StartByte"];
opts.SelectedVariableNames = ["VarName1", "trigger", "PMTA", "PMTB", "PeakA", "PeakB", "RoiWidth", "RoiHeight", "StartByte"];
opts.VariableTypes = ["categorical", "double", "char", "double", "double", "char", "char", "double", "double", "char", "char", "char", "char", "char", "char", "char", "double", "double", "double"];
opts = setvaropts(opts, ["Var3", "Var6", "Var7", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["VarName1", "Var3", "Var6", "Var7", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16"], "EmptyFieldRule", "auto");
A = readtable(filename, opts, "UseExcel", false);
clear opts 

% import HDR data
opts = spreadsheetImportOptions("NumVariables", 59);
opts.Sheet = "HDR";
opts.DataRange = "A2:BG18";
opts.VariableNames = ["VarName1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "Var25", "Var26", "Var27", "Var28", "Var29", "Var30", "Var31", "Var32", "Var33", "Var34", "Var35", "Var36", "Var37", "Var38", "Var39", "Var40", "Var41", "PMTAtriggerThreshold_DAQ_MCConly", "PMTBtriggerThreshold_DAQ_MCConly", "Var44", "Var45", "Var46", "Var47", "PMTtriggerSelection_DAQ_MCConly", "Var49", "Var50", "Var51", "Var52", "Var53", "Var54", "Var55", "Var56", "Var57", "PMTAhighVoltage", "PMTBhighVoltage"];
opts.SelectedVariableNames = ["VarName1", "PMTAtriggerThreshold_DAQ_MCConly", "PMTBtriggerThreshold_DAQ_MCConly", "PMTtriggerSelection_DAQ_MCConly", "PMTAhighVoltage", "PMTBhighVoltage"];
opts.VariableTypes = ["char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "double", "double", "char", "char", "char", "char", "double", "char", "char", "char", "char", "char", "char", "char", "char", "char", "double", "double"];
opts = setvaropts(opts, ["VarName1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "Var25", "Var26", "Var27", "Var28", "Var29", "Var30", "Var31", "Var32", "Var33", "Var34", "Var35", "Var36", "Var37", "Var38", "Var39", "Var40", "Var41", "Var44", "Var45", "Var46", "Var47", "Var49", "Var50", "Var51", "Var52", "Var53", "Var54", "Var55", "Var56", "Var57"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["VarName1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "Var25", "Var26", "Var27", "Var28", "Var29", "Var30", "Var31", "Var32", "Var33", "Var34", "Var35", "Var36", "Var37", "Var38", "Var39", "Var40", "Var41", "Var44", "Var45", "Var46", "Var47", "Var49", "Var50", "Var51", "Var52", "Var53", "Var54", "Var55", "Var56", "Var57"], "EmptyFieldRule", "auto");
H = readtable(filename, opts, "UseExcel", false);

clear opts filename

%% remove rois with multiple triggers and organize in structure

% apply PMT settings to structure
for i=1:length(H.VarName1)
    P(i).filename=string(H.VarName1(i));        
    P(i).selection=H.PMTtriggerSelection_DAQ_MCConly(i);
    P(i).setPMTA=H.PMTAhighVoltage(i);
    P(i).setPMTB=H.PMTBhighVoltage(i);
    P(i).setTrigA=H.PMTAtriggerThreshold_DAQ_MCConly(i);
    P(i).setTrigB=H.PMTBtriggerThreshold_DAQ_MCConly(i);    
end

%find ranges of files within large dataset
t0=find(A.trigger==1); tend=[t0(2:end)-1;length(A.trigger)];
for i=1:length(t0)
    filerange=(t0(i):tend(i))';
    idx=unique(A.trigger(filerange));

    P(i).trigger=A.trigger(filerange(idx));
    P(i).PMTA=A.PMTA(filerange(idx));
    P(i).PMTB=A.PMTB(filerange(idx));
    P(i).PeakA=A.PeakA(filerange(idx));
    P(i).PeakB=A.PeakB(filerange(idx));
    P(i).RoiWidth=A.RoiWidth(filerange(idx));
    P(i).RoiHeight=A.RoiHeight(filerange(idx));
    P(i).StartByte=A.StartByte(filerange(idx));
    clearvars filerange idx
end
clearvars A H i t0 tend


%% plot frequency histograms
filepath= '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Figs/';

%% pmtB
figure('Units','inches','Position',[1 1 7 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.1 0.1], [0.1 0.05], [0.1 0.05]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

pmtb=find([P.selection]==2);
for i=1:length(pmtb)
    subplot(3,3,i)
    idx=pmtb(i);
    histogram(P(idx).PeakB); hold on;  
    set(gca,'xlim',[0 3],'ylim',[0 500])
    title(['PMTB= ' num2str(P(idx).setPMTB) ', TrigB= ' num2str(P(idx).setTrigB) ''])
    ylabel('triggers');
    xlabel('PeakB (V)')    ;
    hold on
end

set(gcf,'color','w');
print(gcf,'-dpng','-r200',[filepath 'PMTB_DinophysisCalibration.png']);
hold off

%% pmtA
figure('Units','inches','Position',[1 1 7 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.1 0.1], [0.1 0.05], [0.1 0.05]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

pmta=find([P.selection]==1);
for i=1:length(pmta)
    subplot(3,3,i)
    idx=pmta(i);
    histogram(P(idx).PeakA); hold on;  
    set(gca,'xlim',[0 3],'ylim',[0 200])
    title(['PMTA= ' num2str(P(idx).setPMTA) ', TrigA= ' num2str(P(idx).setTrigA) ''])
    ylabel('triggers');
    xlabel('PeakA (V)')    ;
    hold on
end

set(gcf,'color','w');
print(gcf,'-dpng','-r200',[filepath 'PMTA_DinophysisCalibration.png']);
hold off

%% cell size pmtB
figure('Units','inches','Position',[1 1 7 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.1 0.1], [0.1 0.05], [0.1 0.05]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

pmtb=find([P.selection]==2);
for i=1:length(pmtb)
    subplot(3,3,i)
    idx=pmtb(i);
    histogram(log10(P(idx).RoiWidth.*P(idx).RoiHeight)); hold on;      
    set(gca,'xlim',[3 5])
    title(['PMTB= ' num2str(P(idx).setPMTB) ', TrigB= ' num2str(P(idx).setTrigB) ''])
    ylabel('triggers');
    xlabel('log(Roi W*H)');
    hold on
end
set(gcf,'color','w');
print(gcf,'-dpng','-r200',[filepath 'ROIsize_PMTB_DinophysisCalibration.png']);
hold off

%% cell size pmtA
figure('Units','inches','Position',[1 1 7 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.1 0.1], [0.1 0.05], [0.1 0.05]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

pmta=find([P.selection]==1);
for i=1:length(pmta)
    subplot(3,3,i)
    idx=pmta(i);
    histogram(log10(P(idx).RoiWidth.*P(idx).RoiHeight)); hold on;      
    set(gca,'xlim',[2.9 5])
    title(['PMTA= ' num2str(P(idx).setPMTA) ', TrigA= ' num2str(P(idx).setTrigA) ''])
    ylabel('triggers');
    xlabel('log(Roi W*H)');
    hold on
end
set(gcf,'color','w');
print(gcf,'-dpng','-r200',[filepath 'ROIsize_PMTA_DinophysisCalibration.png']);
hold off