function [dataout]=equa3c(datain,fmin,fmax,fwind,taper,window)

%[dataout]=equa3c(datain,fmin,fmax,fwind,taper,window)
%
%Performs spectral balancing using a sliding frequency window linear bandpass
%filter with tapers overlapping at the half way point.  An agc which
%preserves the amplitude ratio between components is applied to
%each filtered signal and the frequency ranges are then recombined. Similar
%to INSIGHT module EQUA.
%
%fmax, fmin = maximum and minimum frequencies in the data (Hz)
%fwind =      width of each bandpass filter to be applied (Hz)
%taper =      width of linear taper of each bandpass filter (Hz) (around 2-5 Hz)
%window =     length of agc window to be used (s)
%
%DSI customized VSP processing software
%written by G. Bellefleur March, 2000  
%based on equa.m written by K.S. Beaty January, 1998

%$Id: equa3c.m,v 3.0 2000/06/13 19:20:13 gilles Exp $
%$Log: equa3c.m,v $
%Revision 3.0  2000/06/13 19:20:13  gilles
%*** empty log message ***
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

disp('[dataout]=equa3c(datain,fmin,fmax,fwind,taper,window)');

dataout=datain;
temp=datain;

npts=datain.fh{7};         %number of points in each trace
int=datain.fh{8};          %sampling interval in seconds
tstart=datain.fh{9};       %start time in seconds
nrec=datain.fh{12};        %number of records

%initialize dataout.dat
for COUNT=1:nrec
 dataout.dat{COUNT}(:,:)=0; 
 temp.dat{COUNT}(:,:)=0;
end 

Ny=1./(int.*2);            %Nyquist frequency
N=2^(nextpow2(npts)+1);    %number of points to be used in fft
f=2*Ny*(0:N/2-1)/N;        %frequency vector
nfreq=(taper+fmax-fmin)./(taper+fwind);
nfreq=round(nfreq);

%create and initialize filter function in frequency domain
x=[0 0 1 1 0 0];
filt=zeros(N,1);


for k=1:nfreq
 low=fmin+(k-1).*(fwind+taper);
 high=low+fwind;

 xf=[0 (low-taper) low high (high+taper) f(N/2)];
 m=interp1(xf,x,f);

%'filt' is filter function in frequency domain
 filt(1:N/2)=m;
 m2=fliplr(m);
 filt(N/2+1)=0;
 filt(N/2+2:N)=m2(1:length(m2)-1);

 for COUNT=1:nrec                      % begin loop over records
  ntr=datain.th{COUNT}(12,1);          % number of traces in this record
  filtmat=ndgrid(filt,1:ntr);          % create filter matrix
  in_freq=fft(datain.dat{COUNT},N);    % performs N points fft on columns
  out_freq=zeros(N,ntr);               % initialize
  out_freq=in_freq.*filtmat;           % multiply in freq. domain
  out=ifft(out_freq,N);                % N points inverse fft
  temp.dat{COUNT}=real(out(1:npts,:)); % assign filtered data to temp
 end                                   % end loop over records
 
% apply agc3c
  freq_agc=agc3c(temp,window,1); 

% add balanced frequency
for COUNT=1:nrec                          
  dataout.dat{COUNT}=dataout.dat{COUNT}+freq_agc.dat{COUNT}; 
end

% Error check
 re=real(out(1:npts,1));
 im=imag(out(1:npts,1));
 
 for i=npts:-1:1
  rat(i)=im(i)./re(i);
 end;
 r=find(rat>10^-6);

 if ~ isempty(r)
  error('imaginary part of inverse fft is too large');
 end

end %loop over frequency windows
