function thwrite(datain,rec,thwords,thfile)

%thwrite(datain,rec,thwords,thfile)
%
%module for writing contents of an ascii file into trace headers
%
%INPUT
%datain - data in DSI format
%rec - record number to write information to
%thwords - vector containing trace header word numbers in the order
%that they are organized in input file ex. [1 2 15] (original
%trace number, FFID, pick times)
%thfile - filename containing trace header information.  Must be enclosed
%in single quotes
%
%Warning - no error checking, all previous trace header word contents
%will be overwritten, and all entries in the fiel will be treated as floats.
%
%DSISoft Customized VSP Processing software
%written by K.S. Beaty June, 1998

%$Id: thwrite.m,v 3.0 2000/06/13 19:22:21 gilles Exp $
%$Log: thwrite.m,v $
%Revision 3.0  2000/06/13 19:22:21  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:51  mah
%Release 2
%
%Revision 1.2  1999/01/19 13:56:56  kay
%Fixed typo in help section.
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

disp('thwrite(datain,rec,thwords,thfile)')

fid=fopen(thfile,'r'); %open file

if fid==-1
 error('Could not open file');
end %if

ntr=datain.th{1}(12,1);
fseek(fid,0,-1); %move pointer to beginning of file
out=fscanf(fid,'%f',[length(thwords),ntr]); %read file into matrix as floats

datain.th{rec}(thwords,:)=out;

fclose(fid); %close file
disp(['Trace headers from file ',thfile,' written to DSI variable'])
