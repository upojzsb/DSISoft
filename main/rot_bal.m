
function [dataout]=rot_bal(datain,headw1,angvec,tint,comp1,comp2)
%
%function [dataout]=rot_bal(datain,headw1,angvec,tint,comp1,comp2)
%
%This function balances amplitudes on one horizontal component according
%to an angle between the receiver-to-shot azimuth and one
%of the horizontal component
%
%headw1=header word containing the first break pick times
%angvec=vector of angles of rotation (one value per trace to process)
%tint=time interval around 1st breaks (-tint -> pick time <- tint)
%comp1, comp2= component 1 and 2
%
%DSI customized VSP processing software
%by I. Kay and G. Perron (Jan 1998)

%$Id: rot_bal.m,v 3.0 2000/06/13 19:21:16 gilles Exp $
%$Log: rot_bal.m,v $
%Revision 3.0  2000/06/13 19:21:16  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:23  mah
%Release 2
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

disp('[dataout]=rot_bal(datain,headw1,angvec,tint,comp1,comp2)');

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
w=180/pi;
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


for j=ntr:-1:1
   samp1=round((datain.th{a}(headw1,j)-tstart)/int-(tint/int)) +1;
   if samp1<1
      samp1=1;
   end %if
   samp2=samp1+2.*round(tint/int) +1;

   suma=sum(dataout.dat{a}(samp1:samp2,j).^2);
   sumb=sum(dataout.dat{b}(samp1:samp2,j).^2);
   factx(j)=tan(angvec(j)).*sqrt(suma/sumb);
   if factx(j)<0
      factx(j)=factx(j)*-1;
   else
      factx(j)=factx(j);
   end

   dataout.dat{b}(:,j)=dataout.dat{b}(:,j).*factx(j);
end %for j=1:ntr
