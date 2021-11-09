function [dataout]=corrot(datain,headw1,tint,comp1,comp2)

%corrot -> function to rotate components of 3-C borehole data (DSI etc.)
%into radial and transverse components using matrix eigenvalue algorithm.
%
%function [dataout]=corrot(datain,headw1,tint,comp1,comp2)
%
%
%INPUT VARIABLES
%'datain' must be in official DSI data format
%Each record must represent a component h1, h2, or z.
%This can be achieved using 'sortrec'.
%
%headw1 = 	header word containing first break picks
%tint =     half width of time window to use around first breaks (s)
%comp1 =    record representing one of the components to be rotated
%comp2 =    record number of other component to be rotated
%
%OUTPUT VARIABLES
%Trace header word 4 contains component information.
%This word will be incremented by 3 for components that have
%been rotated.
%
%By convention: h1=>1; h2=>2; z=>3; radial or oriented horizontal=>4;
%transverse horizontal=>5; direct P-arrival (Pd)=>6; orthoganal
%component to Pd=>7 (see Handbook of Geophysical Exploration, sect.1,vol.14B).  
%Components 6 and 7 are the results of rotating 3 and 4; 4 and 5 are
%the results of rotating 1 and 2.
%The largest singular value of the covarience matrix is stored in header
%word 10, and the ratio of sigular value 2 to singular value 1 is stored 
%in word 11.
%
%DSI customized VSP processing software
%by I. Kay and G. Perron (Jan 1998)

%$Id: corrot.m,v 3.0 2000/06/13 19:19:57 gilles Exp $
%$Log: corrot.m,v $
%Revision 3.0  2000/06/13 19:19:57  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:20  mah
%Release 2
%
%Revision 1.5  1999/02/23 15:33:23  kay
%Using matlab's cov is a bad idea here...
%
%Revision 1.2  1999/01/28 14:07:30  kay
%Added svd(1) to header word 10 and ratio of svd(2)/svd(1) to word 11.
%
%Revision 1.1  1999/01/06 19:09:07  kay
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

disp('[dataout]=corrot(datain,headw1,tint,comp1,comp2)');

%check to make sure data is separated into components
for i=3:-1:1 %get number of traces in each component
 ntr(i)=datain.th{i}(12,1);
end %for

if (ntr(1)~=ntr(2)) | (ntr(1)~=ntr(3))
 error('check data format - different number of traces in components');
end%if

if length(datain.dat)~=3
 error('data must have only 3 records - one for each of x, y and z');
end %if

%***********************************************************************
%w=180/pi;
tstart=datain.fh{9}; %start time in seconds
int=datain.fh{8}; %sampling interval in seconds
nsamp=datain.fh{7}; %number of points per trace
dataout=datain;
a=comp1;
b=comp2;

ntr=ntr(1);
%increment component trace header word
dataout.th{a}(4,:)=datain.th{a}(4,:)+3;
dataout.th{b}(4,:)=datain.th{b}(4,:)+3;
ca=dataout.th{a}(4,1);
cb=dataout.th{b}(4,1);
rotang=zeros(1,ntr); %initialize variable for angles

%only want to rotate picked traces
traces=find(datain.th{a}(headw1,:)~=0);

for j=traces
	samp1=round((datain.th{a}(headw1,j)-tstart)/int-(tint/int)) +1;
	if samp1<1
	samp1=1;
	end %if
	samp2=samp1+2.*round(tint/int) +1;
% I've decided that cov() is bad.  It removes the mean, so if the
%window of data does not have a zero mean, the relative
%amplitudes/energies between traces will change, biasing the result. 

   %corrmat=cov(datain.dat{a}(samp1:samp2,j),datain.dat{b}(samp1:samp2,j));

%instead, use the raw data...

   v1=datain.dat{a}(samp1:samp2,j);
   v2=datain.dat{b}(samp1:samp2,j);
   corrmat=[ dot(v1,v1) dot(v1,v2); dot(v2,v1) dot(v2,v2)];

%For a linearly polarized waveform with source signature w(t), arriving at
% an angle \phi from H1 (x), the observed data is 
%		u=w(t)[\cos(\phi) \hat{x} + \sin(\phi) \hat{y}]
% The covarience matrix [ <x,x>, <x,y>, <y,x>, <y,y>] is then of the form
% [ (\cos(\phi))^2, \cos(\phi)*\sin(\phi); 
%     \cos(\phi)*\sin(\phi), (\sin(\phi))^2]
% \phi can be estimated from the elements of the covarience matrix as:

   rotang(j)=atan2(corrmat(1,2),corrmat(1,1));

   rotmat=[cos(rotang(j)) -sin(rotang(j)); sin(rotang(j)) cos(rotang(j))];
   rotdata=(rotmat'*[datain.dat{a}(:,j) datain.dat{b}(:,j)]')';

   dataout.dat{a}(:,j)=rotdata(:,1); %rotated h1 component
   dataout.dat{b}(:,j)=rotdata(:,2); %rotated h2 component


end %for j=trace
firsttr=traces(1);
pilotsamp1=round((datain.th{a}(headw1,firsttr)-tstart)/int-(tint/int)) +1;
if pilotsamp1<1
	pilotsamp1=1;
end %if
pilotsamp2=pilotsamp1+2.*round(tint/int)+1;
pilot=dataout.dat{a}(pilotsamp1:pilotsamp2,1);

for j=traces
  samp1=round((datain.th{a}(headw1,j)-tstart)/int-(tint/int)) +1;
  if samp1<1
     samp1=1;
  end %if
  samp2=samp1+(pilotsamp2-pilotsamp1);
  corrmat=cov(pilot, dataout.dat{a}(samp1:samp2,j));
  %v2=dataout.dat{a}(samp1:samp2,j);
  %corrmat=[ dot(pilot,pilot) dot(pilot, v2); dot(v2, pilot) dot(v2,v2)];
  if  corrmat(1,2) < 0.
     rotang(j)=rotang(j)+pi;
     dataout.dat{a}(:,j)=dataout.dat{a}(:,j).*-1. ;
     dataout.dat{b}(:,j)=dataout.dat{b}(:,j).*-1. ;
  end %if
end %for j=traces
dataout.th{a}(5,:)=mod(rotang*180/pi+360,360);
dataout.th{b}(5,:)=mod(rotang*180/pi+360,360);
