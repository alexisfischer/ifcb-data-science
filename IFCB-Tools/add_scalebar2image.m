clear; close all;
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path
%filepath = '~/Documents/MATLAB/bloom-baby-bloom/CharacteristicPNGs/dinophysis/4publication/';
filepath = '~/Documents/MATLAB/bloom-baby-bloom/CharacteristicPNGs/mesodinium/4publication/';

pixPerUm = 3.8;
scalebarLength = 10; % scalebar will be X micrometer long
unit = sprintf('%sm', '\mu'); % micrometer

P=dir([filepath '*.png']);

for i=1:length(P)
    imagename=P(i).name;
    f = figure(); hAx = axes(f);
    imshow([filepath imagename], 'Parent', hAx);
    hScalebar = scalebar(hAx,'x',scalebarLength, unit,'Location','southeast',...
        'ConversionFactor',pixPerUm,'FontSize',.1,'LineWidth',6); hold on
    
    f = getframe(gca); im = frame2im(f);
    imwrite(im,[filepath 'scalebar/' imagename]) 
    hold off
end

