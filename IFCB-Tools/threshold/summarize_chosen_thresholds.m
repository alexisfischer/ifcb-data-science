function [slope,bin,chosen_threshold] = summarize_chosen_thresholds(classes,thresholdpath,classifiername)
%summarize_chosenthresholds_forclassifier 
%   determine classifier performance with new thresholds
%
% % % Example inputs
% classes=list of classes;
% thresholdpath ='~/Documents/MATLAB/bloom-baby-bloom/IFCB-Data/Shimada/threshold/';
% classifiername ='CCS_v2';

chosen_threshold=NaN*ones(size(classes));
bin=chosen_threshold;
slope=chosen_threshold;

for i=1:length(classes)
    class2do_full = char(classes(i));
    if contains(class2do_full,',')
        class2do_string = [extractBefore(class2do_full,',') '_grouped'];
    else
        class2do_string=class2do_full;
    end
    m=load([thresholdpath 'Coeff_' class2do_string],'slope','bin','chosen_threshold');
    slope(i)=m.slope;
    chosen_threshold(i)=m.chosen_threshold;
    bin(i)=m.bin;    
    clearvars m class2do_full class2do_string
end
save([thresholdpath 'threshold_summary_' classifiername],'classes','slope','bin','chosen_threshold');

end