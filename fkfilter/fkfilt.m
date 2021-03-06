function [dataout]=fkfilt(datain,poly,freq,taper,filtflg,dx,rec)

%[dataout]=fkfilt(datain,poly,freq,taper,filtflg,dx,rec)
%
%F-K Filter
%Does not loop over records.
%
%datain = input data in DSI format
%poly =   x,y coordinates of the corners of filter polygone
%         use 'fkpoly' to pick polygone
%freq =   maximum frequency in the data (Hz)
%taper =  taper to be used around polygone
%filtflg =1 for reject
%        =0 for pass
%dx =     distance between traces (m) used to compute wave number
%rec =    record number to be filtered
%
%DSI customized VSP processing software
%developed by G. Perron

%$Id: fkfilt.m,v 3.0 2000/06/13 19:19:21 gilles Exp $
%$Log: fkfilt.m,v $
%Revision 3.0  2000/06/13 19:19:21  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:44:44  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:08:49  kay
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

disp('[dataout]=fkfilt(datain,poly,freq,taper,filtflg,dx,rec)');

dataout=datain;

int=datain.fh{8}; %sampling interval (s)
datain=datain.dat{rec};


%----------finding nextpow2-------------
[m,n]=size(datain);
m2=2^nextpow2(m);
n2=2^nextpow2(n);

if filtflg==0
   matfilt=zeros(m2,n2); %initializing filter matrix
elseif filtflg==1
   matfilt=ones(m2,n2); %initializing filter matrix
end

kn=1/(2*dx); %Nyquist wavenumber
fn=1/(2*int); %Nyquist frequency
x=[kn:-kn*2/n2:-kn+kn*2/n2];
y=fliplr([0:2*fn/m2:freq]);
[xmat,ymat]=meshgrid(x,y); %creating polymatrix


%-------------computing fft---------------
fkdata=fft2(datain,m2,n2);
fkdata=fftshift(fkdata);



%--------finding points in polygon---------
in=inpolygon(xmat,ymat,poly(:,1),poly(:,2));



%-------------mean filtering---------------
nfreq=length(y);
[a,b]=size(in);
for i=1:a
   in(i,:)=meanfilt(in(i,:),taper);
end
for i=1:b
   in(:,i)=meanfilt(in(:,i),taper);
end

%---------inverting filter matrix----------
if filtflg==1
   in=1-in;
end

%--------creating mirror filt matrix-------
flipin=flipud(fliplr(in));


%---------creating filter matrix------------
matfilt(m2/2-nfreq+1:m2/2,:)=in;
matfilt(m2/2:m2/2+nfreq-1,:)=flipin;


clear xmat ymat in datain



%---------------filtering--------------------
fd=fkdata.*matfilt;
clear matfilt


%---------computing inverse fft--------------
fd=fftshift(fd);
dataout.dat{rec}=ifft2(fd);
dataout.dat{rec}=real(dataout.dat{rec}(1:m,1:n));
