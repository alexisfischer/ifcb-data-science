%IFCB777
% http://localhost:8000/image?image=00340&dataset=Shimada&bin=D20190722T130522_IFCB777
% http://localhost:8000/image?image=00491&dataset=Shimada&bin=D20190724T032751_IFCB777
% http://localhost:8000/image?image=01626&dataset=Shimada&bin=D20190731T184454_IFCB777
% http://localhost:8000/image?image=00690&dataset=Shimada&bin=D20190730T044653_IFCB777
% http://localhost:8000/image?image=00289&dataset=Shimada&bin=D20190817T070259_IFCB777

%IFCB117 
%http://localhost:8000/image?image=01683&dataset=Shimada&bin=D20210722T220341_IFCB117
%http://localhost:8000/image?image=00011&dataset=Shimada&bin=D20210731T221907_IFCB117
%http://localhost:8000/image?image=00257&dataset=Shimada&bin=D20210806T152317_IFCB117
%http://localhost:8000/image?image=00168&dataset=Shimada&bin=D20210917T000551_IFCB117
%http://localhost:8000/image?image=00729&dataset=Shimada&bin=D20210903T214137_IFCB117

%IFCB150
%https://habon-ifcb.whoi.edu/image?image=00203&dataset=buddinlet&bin=D20220802T200427_IFCB150
%https://habon-ifcb.whoi.edu/image?image=00346&dataset=buddinlet&bin=D20220801T173741_IFCB150
%https://habon-ifcb.whoi.edu/image?image=00061&bin=D20220801T174529_IFCB150
%https://habon-ifcb.whoi.edu/image?image=00002&bin=D20220801T180551_IFCB150
%https://habon-ifcb.whoi.edu/image?image=00001&bin=D20220801T175858_IFCB150
%%
%100um bead test
% D20230420T195649_IFCB150_00046
% D20230420T200047_IFCB150_00680
% D20230420T200047_IFCB150_00325
% D20230420T200047_IFCB150_00587
%%
clear;
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\ifcb-analysis\'));
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\ifcb-data-science\'));
addpath(genpath('D:\Shimada\'));

% bead_dim_um=100; %um
% filename{1}='D20230420T195649_IFCB150'; roi_number(1)=46;
% filename{2}='D20230420T200047_IFCB150'; roi_number(2)=680;
% filename{3}='D20230420T200047_IFCB150'; roi_number(3)=325;
% filename{4}='D20230420T200047_IFCB150'; roi_number(4)=587;

bead_dim_um=5.7; %um
filename{1}='D20190722T130522_IFCB777'; roi_number(1)=340;
filename{2}='D20190724T032751_IFCB777'; roi_number(2)=491;
filename{3}='D20190731T184454_IFCB777'; roi_number(3)=1626;
filename{4}='D20190730T044653_IFCB777'; roi_number(4)=690;
filename{5}='D20190817T070259_IFCB777'; roi_number(5)=289;
%%
% filename{6}='D20210722T220341_IFCB117'; roi_number(6)=1683;
% filename{7}='D20210731T221907_IFCB117'; roi_number(7)=11;
% filename{8}='D20210806T152317_IFCB117'; roi_number(8)=257;
% filename{9}='D20210917T000551_IFCB117'; roi_number(9)=168;
% filename{10}='D20210903T214137_IFCB117'; roi_number(10)=729;

filename=filename';
% preallocate
MinorAxisLength=NaN*ones(length(filename),1);
MajorAxisLength=MinorAxisLength;
roi_number=MajorAxisLength;
micron_factor=MajorAxisLength;

for i=1:length(roi_number)
    currentfile=filename{i};
    feafile=['D:\Shimada\features\' currentfile(2:5) '\' currentfile '_fea_v2.csv']
    
    feastruct = importdata(feafile);
    ind = strcmp('roi_number',feastruct.textdata);
    targets.roi_number = feastruct.data(:,ind);
    ind = strcmp('MinorAxisLength',feastruct.textdata);
    targets.MinorAxisLength = feastruct.data(:,ind);
    ind = strcmp('MajorAxisLength',feastruct.textdata);
    targets.MajorAxisLength = feastruct.data(:,ind);
    
    ind=find(targets.roi_number==roi_number(i));
    MinorAxisLength(i)=targets.MinorAxisLength(ind);
    MajorAxisLength(i)=targets.MajorAxisLength(ind);
    micron_factor(i)=mean([MinorAxisLength(i),MajorAxisLength(i)])./bead_dim_um;

end

T=table(filename,roi_number,MinorAxisLength,MajorAxisLength,micron_factor);

micron_factor_IFCB150=mean(T.micron_factor(1:end))

%%
micron_factor_IFCB777=mean(T.micron_factor(1:5))
micron_factor_IFCB117=mean(T.micron_factor(6:10))

%%
imageJ=17.5; %pixels

micron_factor=imageJ./bead_dim_um


