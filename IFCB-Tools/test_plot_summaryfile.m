
i=122
val=classcount(:,i);

idx=~isnan(val);
figure;
plot(matdate(idx),val)
title(class2use(i))