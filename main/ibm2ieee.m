function d = ibm2ieee (ibmf)

% Name:         ibm2ieee
% Abstract:     convert a matrix of IBM/360 32-bit floats
%               to IEEE doubles.
%
%               IBMF is the matrix of IBM/360 32-bit floats each
%               stored as a 32 bit unsigned big-endian integer
%               in a MATLAB double.
%
%               The format of a IBM/360 32-bit float is:
%                  sign 7-bit exponent  24 bit fraction
%                  The base is 16. The decimal point is to
%                  the left of the fraction. The exponent is
%                  biased by +64.
%
%               The basic idea is that you use floating point on
%               the various fields.
%
%               ieee = sign * 16 ^ (exponent - 64) * fraction / 16 ^ 6
%
% By:           Martin Knapp-Cordes
%               The MathWorks, Inc.
%
% Date(s):      Jun 95 - 28, 29

% $Revision: 3.0 $  $Date: 2000/06/13 19:20:32 $
% $Id: ibm2ieee.m,v 3.0 2000/06/13 19:20:32 gilles Exp $
% $Log: ibm2ieee.m,v $
% Revision 3.0  2000/06/13 19:20:32  gilles
% Release 3
%
% Revision 2.0  1999/05/21 18:45:47  mah
% Release 2
%
% Revision 1.1  1999/01/11 19:14:47  kay
% Initial revision
%
%----------------------------------------------------------------------------
%
if (nargin ~= 1)
	error ('Wrong number of arguments.');
elseif (isempty(ibmf))
    error ('Argument is an empty matrix');
end
%
aibmf = sprintf('%08x',ibmf);
%
% hexd(1) - 1st hex digit - first bit is sign, next 3 bits high order exponent
% hexd(2) - 2nd hex digit - bits of low order exponent
% hexd(3) - 3rd-8th hex digit - bits of fraction
%
hexd = sscanf(aibmf,'%1x%1x%6x',[3,inf]);
d = (1 - (hexd(1,:) >= 8) .* 2) .* ...
      16 .^ ((hexd(1,:) - (hexd(1,:) >= 8) .* 8) .* 16 + hexd(2,:) ...
              - 70).* hexd(3,:);
d = reshape(d,size(ibmf));

%------------------------ END : ibm2ieee.m ----------------------------
% Here's an example on how to use the ibm2ieee.m file above.

%Assuming you have a file, which contains IBM float 32 format binary
%data, called 5702.seg, then you must use the following FOPEN and FREAD
%call the read the file:

% fid = fopen('5702.seg','r','b');

%
% Read first data record - IBM/360 32-bit floating format
%                          Read them as unsigned (32-bit) integers.
% Convert to IEEE doubles using ibm2ieee.
%
% size - number of elements to read

%ibm1 = fread(fid,size,'uint');
%ieee1 = ibm2ieee(ibm1);

