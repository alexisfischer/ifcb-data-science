clear
load('D:\general\config\class2use_16');

classpath='D:\Shimada\class\CCS_v16\class2021_v1\';

c=dir([classpath '*.mat']);

load([classpath c(1).name])

ind = find(contains(class2useTB, ','));
for i=1:length(ind)
    class2use(end+1)=class2useTB(ind(i));
end


save('D:\general\config\class2use_16_forgroupedclassifier','class2use');
