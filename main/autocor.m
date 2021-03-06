function [dataout]=autocor(datain)

%[dataout]=autocor(datain)
%
%Autocorrelation
%Performs autocorrelation on each trace.
%Uses signal processing toolbox but contains commented out code that works
%without the toolbox.
%
%Similar to INSIGHT module 'auto'.
%
%DSI customized VSP processing software
%written by Kristen Beaty December, 1997

%$Id: autocor.m,v 3.0 2000/06/13 19:19:45 gilles Exp $
%$Log: autocor.m,v $
%Revision 3.0  2000/06/13 19:19:45  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:09  mah
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

disp('[dataout]=autocor(datain)');

dataout=datain;

nrec=datain.fh{12}; %get number of records
samples=datain.fh{7}; %number of points per trace
fpoints=2^nextpow2(3*samples); %number of points to be used in fft

for COUNT=1:nrec %loop over records
 ntpr=datain.th{COUNT}(12,1); %number of traces this record

 baseline=mean(datain.dat{COUNT},1);
 basegr=meshgrid(baseline,1:samples);
 dataout.dat{COUNT}=datain.dat{COUNT}-basegr;
 %each trace must have mean value of 0

  %----find the auto correlation functions in the Fourier domain---------

  %take fft of flipped data before zero padding to use for autocorrelation
  %au_fft=fft(flipud(dataout.dat{COUNT}),fpoints);
  %pilot=zeros(samples*3,ntpr); %initialize pilot
  %pilot(samples+1:2*samples,:)=dataout.dat{COUNT};
  %pilot_fft=fft(pilot,fpoints);

  %multiply magnitudes and add phases to get autocorrelation function fft
  %pfabs=abs(pilot_fft);
  %pfang=angle(pilot_fft);

  %perform autocorrelation
  %mag=abs(au_fft).*pfabs;
  %phase=angle(au_fft)+pfang;
  %aucorr_fft=mag.*exp(phase.*i); %convert to complex
  %aucorr=ifft(aucorr_fft,fpoints); %inverse fft
  %normgr=meshgrid(max(real(aucorr)),1:fpoints);
  %aucorr=real(aucorr)./normgr;
  %dataout.dat{COUNT}=flipud(aucorr(samples+1:2*samples,:));
%-----------------use signal processing toolbox xcor below------------

 aucorr=zeros(samples*2+1:datain.th{COUNT}(12,1));
 for tr=1:datain.th{1}(12,1)
  aucorr(:,tr)=xcorr(dataout.dat{COUNT}(:,tr));
 end %loop over traces
 normgr=meshgrid(max(aucorr),1:size(aucorr,1));
 dataout.dat{COUNT}=aucorr./normgr;
 dataout.dat{COUNT}=dataout.dat{COUNT}(samples:size(dataout.dat{COUNT},1),:);

end %loop over records

%end of function autocor
