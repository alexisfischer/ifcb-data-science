function [ n, class_all, varargin ] = handle_train_maxn_subsample_NOAA( class2use, maxn, class_all, varargin )
% function [ n, class_all, varargin ] = handle_train_maxn_subsample_NOAA( class2use, maxn, class_all, varargin )
% ifcb-analysis; function called by compile_train_features*; 
%
% This is a function that replaces handle_train_maxn within 
% compile_train_features. If number of images exceed the USER defined maxn, 
% this randomly removes excess images from the training set so that 
% BI images are preferentially selected over NCC images
%  A.D Fischer, June 2022

% %% Example inputs for testing
% varargin{1}=fea_all;
% varargin{2}=files_all;
% varargin{3}=roinum;
      
n=NaN*ones(length(class2use),1);
for i = 1:length(class2use)
    id1=find(endsWith(varargin{2},'IFCB150')); %find Budd Inlet or Lab files    
    id2=find(endsWith(varargin{2},'IFCB777') | endsWith(varargin{2},'IFCB117')); %find Shimada files
    j = find(class_all == i);
    n(i) = length(j); %total number of images
    n2del = round(n(i)-maxn,0); %number of images that need to be deleted
    
    if n2del > 0 %if your images exceeds the maxn...
        ind_1=(intersect(id1,j)); %find file subset that are BI and that class
        ind_2=(intersect(id2,j)); %find file subset that are NCC and that class
        d1=length(ind_1)-maxn; %difference between BI files and maxn
   %     d1=5100-5000
        disp(['' class2use{i} ': n2del=' num2str(n2del) ' BI=' num2str(length(ind_1)) ' NCC=' num2str(length(ind_2)) ')'])         

        if d1<0 %if BI files exceed maxn, delete d1 and all of NCC

            shuffle_ind = randperm(length(ind_1));
            shuffle_ind = shuffle_ind(1:n2del);
            idx2del=ind_2(shuffle_ind); 
            disp('only delete from NCC')                 

        elseif d2<0 %don't delete any from NCC
            shuffle_ind = randperm(length(ind_1));
            shuffle_ind = shuffle_ind(1:n2del);
            idx2del=ind_1(shuffle_ind); 
            disp('only delete from BI')                   
            
        else
            shuffle_ind = randperm(length(ind_1));
            shuffle_ind1 = shuffle_ind(1:d1);            
            shuffle_ind = randperm(length(ind_2));
            shuffle_ind2 = shuffle_ind(1:d2);
            idx2del=[ind_1(shuffle_ind1);ind_2(shuffle_ind2)];   
            disp('delete from BI and NCC')            
        end

        if diff([length(idx2del),n2del])<10
        else
            disp(['ERROR! ' class2use{i} ' idx2del=' num2str(length(idx2del)) ' n2del=' num2str(n2del) '' ])            
        end
    %    disp(num2str(length(idx2del)));
     %   disp(num2str(n2del))        ;

        class_all(idx2del) = []; %set those classes as []                  
        for vc = 1:length(varargin)
            varargin{vc}(idx2del,:) = [];
        end
        j = find(class_all == i);
        n(i) = length(j); %total number of images     

        %n(i) = maxn;
        id1=find(endsWith(varargin{2},'IFCB150')); %find Budd Inlet or Lab files    
        id2=find(endsWith(varargin{2},'IFCB777') | endsWith(varargin{2},'IFCB117')); %find Shimada files
        j = find(class_all == i);        
        ind_1=(intersect(id1,j)); %find file subset that are BI and that class
        ind_2=(intersect(id2,j)); %find file subset that are NCC and that class
        disp(['' class2use{i} ' final: BI=' num2str(length(ind_1)) ' NCC=' num2str(length(ind_2)) ')'])                 
    else
        %disp(['' class2use{i} ': no extra images!'])
    end
        clearvars j d1 d2 val idx2del ind_1 ind_2 n2del shuffle_ind shuffle_ind1 shuffle_ind2 
end


