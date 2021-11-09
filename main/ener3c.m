function [dataout]=ener3c(datain,T1,T2)

%[dataout]=ener3c(datain,T1,T2)
%
%This function will do energy balancing on the traces in datain based
%on the amplitudes of the data in the time window between times T1
%and T2 (both in seconds).  Each trace is multiplied by a factor equal to
%the sum over the specified time window of one over the amplitude squared 
%of the traces from the 3 components. This version preserves the
%amplitude ratio between the components.  
%
%DSI customized VSP processing software
%written by G. Bellefleur March,2000  
%based on ener.m written by Kristen Beaty Nov. 1997
%written based on INSIGHT module 'ener'
  
%$Id: ener3c.m,v 3.0 2000/06/13 19:20:10 gilles Exp $
%$Log: ener3c.m,v $
%Revision 3.0  2000/06/13 19:20:10  gilles
%*** empty log message ***
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

disp('[dataout]=ener3c(datain,T1,T2)')

dataout=datain;

tstart=datain.fh{9};  %start time in seconds
int=datain.fh{8};     %sampling interval in seconds
npts=datain.fh{7};    %number of points per trace
nrec=datain.fh{12};   %number of records in datain

% Check if nrec=3
if (nrec==3)

%find indexes of T1 and T2
T1=round((T1-tstart)./int)+1; 
T2=round((T2-tstart)./int)+1;

%if T2 is larger than tmax then reset to npts
if (T2 > npts)
   T2= npts;
end

 temp1=datain.dat{1}(T1:T2,:);
 temp2=datain.dat{2}(T1:T2,:);
 temp3=datain.dat{3}(T1:T2,:);
 
 temp1=temp1.*temp1;
 temp2=temp2.*temp2;
 temp3=temp3.*temp3;
 
 fact=sum([temp1; temp2; temp3])/3;
 fact=sqrt(fact);
 i=find(fact==0);
 fact(i)=1;      %avoid divide by zero error for dead traces
 factgr=meshgrid(fact,1:npts);
 dataout.dat{1}=datain.dat{1}./factgr;
 dataout.dat{2}=datain.dat{2}./factgr;
 dataout.dat{3}=datain.dat{3}./factgr;
 
 else
  text = sprintf('WARNING! This version of ener3c requires 3 components');
  disp(text);
 end %end check if nrec=3   
