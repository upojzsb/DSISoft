function thread(datain,rec,thwords,thfile)

%thread(datain,rec,thwords,thfile)
%
%module for reading trace headers and outputting to an ascii file
%
%INPUT
%datain - data in DSI forma
%rec - record number to output information from
%thwords - vector containing trace header word numbers in the order
%that they should be organized in output file ex. [1 2 15] (original
%trace number, FFID, pick times)
%thfile - filename to write the above information to.  Must be enclosed
%in single quotes
%
%DSISoft Customized VSP Processing software
%written by K.S. Beaty June, 1998

%$Id: thread.m,v 3.0 2000/06/13 19:22:19 gilles Exp $
%$Log: thread.m,v $
%Revision 3.0  2000/06/13 19:22:19  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:49  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:09  kay
%Initial revision
%
%
%Copyright (C) 1998 Seismology and Electromagnetic Section/
%Continental Geosciences Division/Geological Survey of Canada
%
%This library is free software; you can redistribute it and/or
%modify it under the terms of the GNU Library General Public
%License as published by the Free Software Foundation; either
%version 2 of the License, or (at your option) any later version.
%
%This library is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%Library General Public License for more details.
%
%You should have received a copy of the GNU Library General Public
%License along with this library; if not, write to the
%Free Software Foundation, Inc., 59 Temple Place - Suite 330,
%Boston, MA  02111-1307, USA.
%
%DSI Consortium
%Continental Geosciences Division
%Geological Survey of Canada
%615 Booth St.
%Ottawa, Ontario
%K1A 0E9
%
%email: dsi@cg.nrcan.gc.ca

disp('thread(datain,rec,thwords,thfile)')

fid=fopen(thfile,'w');

if fid==-1
 error('Could not open file');
end %if

out=datain.th{rec}(thwords,:);

format=' %12.8f';
outform=format;
for i=1:length(thwords)-1
 outform=strcat(outform,format);
end %for
outform=strcat(outform,'\n');

fprintf(fid,outform,out);

fclose(fid);
disp(['Trace headers written to file ',thfile])
