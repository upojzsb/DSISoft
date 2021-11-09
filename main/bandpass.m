function [dataout]=bandpass(datain,F1,F2,F3,F4)

%[dataout]=bandpass(datain,F1,F2,F3,F4)
%
%simple linear bandpass filter
%
%Frequencies <=F1 and >=F4 are zeroed
%Frequencies between F2 and F3 are untouched
%Frequencies between F2 and F1 as well as between F3 and F4 are linearily
%reduced
%All frequencies is in Hertz (Hz)
%
%DSI customized VSP processing software
%written by Kristen Beaty January, 1998

%$Id: bandpass.m,v 3.0 2000/06/13 19:19:51 gilles Exp $
%$Log: bandpass.m,v $
%Revision 3.0  2000/06/13 19:19:51  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:14  mah
%Release 2
%
%Revision 1.2  1999/05/17 14:56:44  mah
%fixed up help message
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

disp('[dataout]=bandpass(datain,F1,F2,F3,F4)');

dataout=datain;
nrec=datain.fh{12};
int=datain.fh{8}; %sampling interval
Ny=1./(int.*2); %Nyquist frequency
npts=datain.fh{7}; %number of points in each trace
N=2^(nextpow2(npts)+1); %number of points to be used in fft

f=2*Ny*(0:N/2-1)/N; %frequency vector

%create filter function in frequency domain
x=[0 0 1 1 0 0];
xf=[0 F1 F2 F3 F4 f(N/2)];
m=interp1(xf,x,f);

filt=zeros(N,1);
filt(1:N/2)=m;
m2=fliplr(m);
filt(N/2+1)=0;
filt(N/2+2:N)=m2(1:length(m2)-1);
%'filt' is filter function in frequency domain

for COUNT=1:nrec %loop over records
 ntr=datain.th{COUNT}(12,1); %number of traces in this record
 filtmat=ndgrid(filt,1:ntr); %create filter matrix
 in_freq=fft(datain.dat{COUNT},N); %performs N points fft on columns
 out_freq=zeros(N,ntr); %initialize
 out_freq=in_freq.*filtmat; %multiply in freq. domain
 out=ifft(out_freq,N); %N points inverse fft
 dataout.dat{COUNT}=real(out(1:npts,:));

 %error check
 re=real(out(1:npts,1));
 im=imag(out(1:npts,1));
 for i=npts:-1:1
  rat(i)=im(i)./re(i);
 end;
 x=find(rat>10^-6);
 if ~ isempty(x)
  error('imaginary part of inverse fft is too large');
 end %if
end %loop over records
