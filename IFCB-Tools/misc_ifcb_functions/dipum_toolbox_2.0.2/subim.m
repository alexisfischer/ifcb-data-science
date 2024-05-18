function s = subim(f,m,n,rx,cy)
%SUBIM Extract subimage.
%   S = SUBIM(F, M, N, RX, CY) extracts a subimage, S, from the input
%   image, F.  The subimage is of size M-by-N, and the coordinates of
%   its top, left corner are (RX, CY).
%
%   Sample M-file used in Chapter 2.

%   Copyright 2002-2012 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

s = zeros(m,n,class(f));
for r = 1:m
   for c = 1:n
      s(r,c) = f(r + rx - 1, c + cy - 1);
   end
end

