function [dataout]=ener(datain,T1,T2)

%[dataout]=ener(datain,T1,T2)
%
%This function will do energy balancing on the traces in datain based
%on the amplitudes of the data in the time window between times T1
%and T2 (both in seconds).  Each trace is multiplied by a factor equal to
%the sum over the specified time window of one over the amplitude squared 
%of that trace. 
%
%DSI customized VSP processing software
%written by Kristen Beaty Nov. 1997
%based on INSIGHT module 'ener'

%$Id: ener.m,v 3.0 2000/06/13 19:20:10 gilles Exp $
%$Log: ener.m,v $
%Revision 3.0  2000/06/13 19:20:10  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:31  mah
%Release 2
%
%Revision 1.2  1999/01/08 15:32:51  adam
%reset T2 to npts if too large
%
%Revision 1.1  1999/01/06 19:09:03  kay
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

disp('[dataout]=ener(datain,T1,T2)')

dataout=datain;

tstart=datain.fh{9}; %start time in seconds
int=datain.fh{8}; %sampling interval in seconds
npts=datain.fh{7}; %number of points per trace

%find indexes of T1 and T2
T1=round((T1-tstart)./int)+1; 
T2=round((T2-tstart)./int)+1;

%if T2 is larger than tmax then reset to npts
if (T2 > npts)
   T2= npts;
end

nrec=datain.fh{12}; %number of records in datain
for COUNT=1:nrec 
 x=datain.dat{COUNT}(T1:T2,:);
 x=x.*x;
 fact=sum(x);
 fact=sqrt(fact);
 i=find(fact==0);
 fact(i)=1; %avoid divide by zero error for dead traces
 factgr=meshgrid(fact,1:npts);
 dataout.dat{COUNT}=datain.dat{COUNT}./factgr;
end %loop over records
