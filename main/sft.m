function [dataout]=sft(datain,tr1,tr2,shift)

%[dataout]=sft(datain,tr1,tr2,shift)
%
%This function requires input data in DSI format.  A time
%shift can be applied by an amount given in the parameter 'shift' (sec).
%Shifts are to the nearest sampling point.  All time shifts will be
%recorded in trace header word 21 in seconds.
%
%tr1 and tr2 specify the first and last traces to apply the time shift to
%Shifts will be applies to all records.
%
%Convention: positive value = shift traces down
%            negative value = shift traces up
%
%DSI customized VSP processing software
%written by Kristen Beaty November, 1997

%$Id: sft.m,v 3.0 2000/06/13 19:21:24 gilles Exp $
%$Log: sft.m,v $
%Revision 3.0  2000/06/13 19:21:24  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:32  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:08  kay
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

disp('[dataout]=sft(datain,tr1,tr2,shift)');

dataout=datain;

nrec=datain.fh{12}; %number of records
int=datain.fh{8}; %sampling interval (sec)
tstart=datain.fh{9}; %start time (sec)
samples=datain.fh{7}; %number of points per trace

for COUNT=1:nrec %loop over records
 dataout.dat{COUNT}(:,tr1:tr2)=0; %initialize traces that will be shifted
 %put shift times into trace headers
 dataout.th{COUNT}(21,tr1:tr2)=dataout.th{COUNT}(21,tr1:tr2)+shift;
 index=round((abs(shift)-tstart)./int);
 i=tr1:tr2;
  if index==0 %no shift
   dataout.dat{COUNT}(:,tr1:tr2)=datain.dat{COUNT}(:,i);
  elseif shift<0 %shift upwards
   dataout.dat{COUNT}(1:(samples-index+1),i)=datain.dat{COUNT}(index:samples,i);
  else %shift downwards
   dataout.dat{COUNT}(index:samples,i)=datain.dat{COUNT}(1:(samples-index+1),i);
  end %if
end %loop over records
