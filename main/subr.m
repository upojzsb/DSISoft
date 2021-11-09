function [dataout]=subr(datain1,datain2)

%function [dataout]=subr(datain1,datain2)
%
%subtracts traces in datain1.dat from those in datain2.dat and outputs
%the resulting traces to dataout
%similar to INSIGHT module 'subr'
%
%datain1 and datain2 must have same number of records, traces, points per
%trace, and time scales
%user should make sure that same time shifts have been applied to both
%
%DSI customized VSP processing software
%written by Kristen Beaty November, 1997

%$Id: subr.m,v 3.0 2000/06/13 19:22:11 gilles Exp $
%$Log: subr.m,v $
%Revision 3.0  2000/06/13 19:22:11  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:42  mah
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

disp('[dataout]=subr(datain1,datain2)');

%check to make sure datain1 and datain2 match in size
for i=[1 7 8 9 10 12 13]
 if datain1.fh{i}~=datain2.fh{i}
  error('file headers not the same for both input variables');
 end %if
end %for

dataout.fh=datain2.fh;
nrec=datain1.fh{12};

for COUNT=1:nrec %loop over records
 dataout.dat{COUNT}=datain2.dat{COUNT}-datain1.dat{COUNT};
 dataout.th{COUNT}=datain2.th{COUNT};
end %loop over records
