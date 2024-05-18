function [Yi] = interp1babygap(Y,maxgap)
%  A.D. Fischer, July 2018 

% Y = input data, 1 column with nans
% maxgap = maximum gap size that you want to exclude from interpolation    

Yi=Y; %output
Yi(Yi==Inf)=NaN;

idx = isnan(Yi);
Yi(idx) = interp1(find(~idx), Yi(~idx), find(idx), 'linear');
[b, n] = RunLength(idx);
longRun = RunLength(b & (n > maxgap), n);
Yi(longRun) = NaN;
