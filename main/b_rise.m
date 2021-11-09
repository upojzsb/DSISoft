function [dataout,risetime]=b_rise(datain,headwd)

%function [dataout,risetime]=b_rise(datain,headwd)
%	  dataout=b_rise(datain,headwd)
%
%function to calculate rise time of a picked arrival
%requires first break picks to be set in headers (use pick1comp
%or pickfb to set picks)
%
%INPUT
%datain - dataset in DSI format
%headwd - index of trace header containing pick times
%
%OUTPUT
%dataout - dataset in DSI format with rise times stored in trace header 10
%risetime - cell array with a vector of rise times for each record
%
%Based on the description of how to determine rise time given in:
%Gladwin, M.T. and Stacey, F.D, Anelastic Degradation of Acoustic Pulses
%in Rock, Physics of the Earth and Planetary Interiors, 8 (1974) 332-336.
%
%Customized VSP processing software
%written by K.S. Beaty

%$Id: b_rise.m,v 3.0 2000/06/13 19:19:49 gilles Exp $
%$Log: b_rise.m,v $
%Revision 3.0  2000/06/13 19:19:49  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:12  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:01  kay
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

disp('[dataout,risetime]=b_rise(datain,headwd)')

tstart=datain.fh{9}; %start time (s)
smp=datain.fh{8}; %sampling rate (s)
npts=datain.fh{7}; %number of points per trace
nrec=datain.fh{12}; %number of records
dataout=datain;

for COUNT=1:nrec %loop over records
 fbtimes=datain.th{COUNT}(headwd,:);
 fbindex=round((fbtimes-tstart)/smp)+1;
 ntr=datain.th{COUNT}(12,1); %number of traces in this record
 risetime{COUNT}(1:ntr)=0; %initialize
 for tr=1:ntr
  xd=datain.dat{COUNT}(:,tr); %data for single trace
  k=fbindex(tr); %index
  tau=findrisetime(xd,k,npts);
  risetime{COUNT}(tr)=tau;
 end %loop over traces
 risetime{COUNT}=(risetime{COUNT}+1)*smp; %convert to time (s)
 dataout.th{COUNT}(10,:)=risetime{COUNT};
end %loop over records

%_____________________________________________________________

function risetime=findrisetime(xd,k,npts)

%function for finding rise time
%xd is data for single seismic trace
%k is the index of first break pick

n=5; %order of polynomial to fit to rise of the curve

if xd(k)<0
 pxd=-xd;
else
 pxd=xd;
end %if
low=k;
high=k;
while pxd(low)>0
 low=low-1;
 if low==1
  break;
 end %if
end %while
while pxd(high)>0
 high=high+1;
 if high==npts
  break;
 end %if
end %while
low=low+1;
high=high-1;
qxd=pxd(low:high);
[maxval,maxind]=max(qxd);
if pxd==zeros(length(pxd),1)
 risetime=NaN;
 return;
end %if
rise=pxd(low:maxind+low)';
p=polyfit(1:length(rise),rise,n);
dp=polyder(p); %1st derivative
xscale=[1:0.1:length(rise)];
py=polyval(p,xscale);
maxval=max(py); %more accurate than taking max of data
dpy=polyval(dp,xscale);
[slope,slopeind]=max(dpy);
slopexpt=xscale(slopeind);
slopeypt=polyval(p,slopexpt);
risetime=abs(maxval/slope); %rise time (indexes)
