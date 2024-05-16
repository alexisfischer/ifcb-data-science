resultpath= '/Volumes/IFCB_products/MVCO/Manual_fromClass/'; %where manual files are
urlbase = 'http://ifcb-data.whoi.edu/mvco/'; %where your dashboard is
outputpath = '/Volumes/MCLANE/ROI_test/';% where you want images to go
imclass = strmatch('Ceratium', class2use_auto); %class to export

filelist = dir([resultpath 'D*.mat']);
class_name=char(class2use_auto(imclass));
mkdir([outputpath class_name]);


for filecount = 1:length(filelist), %this is where you could potentially put filecount=1:10:length(filelist) if you had tons of files.

    filename = filelist(filecount).name;
    disp(filename)
    load([resultpath filename])
    
   
    roi_ind=find(classlist(:,3)==imclass);
   
    
    for i=1:length(roi_ind) %this is where you could potentially put i=1:10:length(roi_ind) if your categories were huge.
        pngnumber=num2str(classlist(roi_ind(i),1));
    pngname = [filename(1:24) '_' pngnumber];
        image = get_image([urlbase pngname]);
        if length(image) > 0,
            imwrite(image, [outputpath class_name '/' pngname '.png'], 'png');
        end;
    end;
  end
    