function [dataout]=equa(datain,fmin,fmax,fwind,taper,window)

%[dataout]=equa(datain,fmin,fmax,fwind,taper,window)
%
%Performs spectral balancing using a sliding frequency window linear bandpass
%filter with tapers overlapping at the half way point.  An agc is applied to
%each filtered signal and the frequency ranges are then recombined. Similar
%to INSIGHT module EQUA.
%
%fmax, fmin = maximum and minimum frequencies in the data (Hz)
%fwind =      width of each bandpass filter to be applied (Hz)
%taper =      width of linear taper of each bandpass filter (Hz) (around 2-5 Hz)
%window =     length of agc window to be used (s)
%
%DSI customized VSP processing software
%written by K.S. Beaty January, 1998

%$Id: equa.m,v 3.0 2000/06/13 19:20:12 gilles Exp $
%$Log: equa.m,v $
%Revision 3.0  2000/06/13 19:20:12  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:33  mah
%Release 2
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

disp('[dataout]=equa(datain,fmin,fmax,fwind,taper,window)');

tstart=datain.fh{9}; %start time in seconds
int=datain.fh{8}; %sampling interval in seconds
%convert agc 'window' from seconds to indexes
w=round(window./int)+1;
pt=round(w/2); %index of point in the centre of the window

Ny=1./(int.*2); %Nyquist frequency
npts=datain.fh{7}; %number of points in each trace
N=2^(nextpow2(npts)+1); %number of points to be used in fft

f=2*Ny*(0:N/2-1)/N; %frequency vector

%create filter function in frequency domain
x=[0 0 1 1 0 0];
filt=zeros(N,1); %initialize filter vector

if w==npts
 pt=npts;
elseif w>npts %error check for agc
 error('choose a smaller window')
end %if/else

nfreq=(taper+fmax-fmin)./(taper+fwind);
nfreq=round(nfreq);

nrec=datain.fh{12}; %number of records

dataout=datain;

for COUNT=1:nrec
 dataout.dat{COUNT}(:,:)=0; %initialize dataout.dat
end %loop over records

for k=1:nfreq
 low=fmin+(k-1).*(fwind+taper);
 high=low+fwind;

%=======================================

 xf=[0 (low-taper) low high (high+taper) f(N/2)];
 m=interp1(xf,x,f);

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
  freq=real(out(1:npts,:));

%============apply agc=================

  fact=sum(abs(freq(1:w,:)))./w;
  factgr=meshgrid(fact,1:pt);
  freq_agc(1:pt,:)=freq(1:pt,:)./factgr;

  for k=1:npts-w;
   fact=fact-abs(freq(k,:))./w+abs(freq(k+w,:))./w;
   freq_agc(k+pt,:)=freq(k+pt,:)./fact;
  end %for

  i=npts-w+1:npts;
  factgr=meshgrid(fact,i);
  freq_agc(i,:)=freq(i,:)./factgr;

%======================================

  dataout.dat{COUNT}=dataout.dat{COUNT}+freq_agc; %add balanced frequency
 end %loop over records

 %error check
 re=real(out(1:npts,1));
 im=imag(out(1:npts,1));
 for i=npts:-1:1
  rat(i)=im(i)./re(i);
 end;
 r=find(rat>10^-6);
 if ~ isempty(r)
  error('imaginary part of inverse fft is too large');
 end %if
end %loop over frequency windows
