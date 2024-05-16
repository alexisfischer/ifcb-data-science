function [ runtype,filecomment ] = IFCB_RunType_FileComment( hdrname )

%hdrname='~/Documents/MATLAB/bloom-baby-bloom/IFCB-Data/D20220521T005008_IFCB150.hdr';

if ischar(hdrname), hdrname = cellstr(hdrname); end
runtype = NaN(size(hdrname));
filecomment = NaN(size(hdrname));
for count = 1:length(hdrname)
    hdr = IFCBxxx_readhdr2(hdrname{count});
    if ~isempty(hdr)
        filecomment = hdr.filecomment;
        runtype = hdr.runtype;        
    end
end
