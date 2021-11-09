function [dataout]=tred(datain,v,shift)

%[dataout]=tred(datain,v,shift)
%
%This function requires input data in DSI format.  It takes the velocity
%of the waves, v (m/s), and flattens the data using this information and
%the source-receiver offset distance found in trace header word 53.  A time
%shift can be applied also by an amount given in the parameter 'shift' (sec).
%Shifts are to the nearest sampling point so trim statics should be
%applied to achieve better alignment if needed.  All time shifts will be
%recorded in trace header word 8 in seconds.
%
%Convention: positive value = shift traces down
%            negative value = shift traces up
%
%DSI customized VSP processing software
%written by Kristen Beaty November, 1997

%$Id: tred.m,v 3.0 2000/06/13 19:22:23 gilles Exp $
%$Log: tred.m,v $
%Revision 3.0  2000/06/13 19:22:23  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:53  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:10  kay
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

disp('[dataout]=tred(datain,v,shift)');

dataout=datain;

nrec=datain.fh{12};
int=datain.fh{8}; %sampling interval (sec)
tstart=datain.fh{9}; %start time (sec)
samples=datain.fh{7}; %number of points per trace

for COUNT=1:nrec %loop over records
 dataout.dat{COUNT}(:,:)=0; %initialize dataout.dat
 times(1,:)=datain.th{COUNT}(53,:)./v+shift;
 %put shift times into trace headers
 dataout.th{COUNT}(8,:)=dataout.th{COUNT}(8,:)+times(1,:);
 indexes=round((abs(times(1,:))-tstart)./int);
 for i=1:length(indexes) %loop over number of traces
  index=indexes(i);
  if index==0 %no shift
   dataout.dat{COUNT}(:,i)=datain.dat{COUNT}(:,i);
  elseif times(i)<0 %shift upwards
   dataout.dat{COUNT}(1:(samples-index+1),i)=datain.dat{COUNT}(index:samples,i);
  else %shift downwards
   dataout.dat{COUNT}(index:samples,i)=datain.dat{COUNT}(1:(samples-index+1),i);
  end %if
 end %loop over number of traces
end %loop over records
