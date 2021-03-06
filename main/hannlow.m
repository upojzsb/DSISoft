function [dataout]=hannlow(datain,passband,stopband)

%[dataout]=hannlow(datain,passband,stopband)
%
%This function will filter your data using a lowpass
%Finite Impulse Response (FIR) filter where a hanning window
%will be used.
%'passband' is the frequency in Hz of signal transmitted
%'stopband' is the frequency in Hz of signal not transmitted
% W<Wp is passed
% W>Ws is not passed
% A hanning window will be used in order to give a 
% passband ripple of 3dB and a stopband ripple of 40dB in the power domain
%
% Warning: The program does not check for unreasonable parameters
%
%This is based off of the theory developed in
%Digital Signal Processing by Alan V. Oppenheim & Ronald W. Schafer
%
%Written by Marko Mah January 1999

%$Id: hannlow.m,v 3.0 2000/06/13 19:20:26 gilles Exp $
%$Log: hannlow.m,v $
%Revision 3.0  2000/06/13 19:20:26  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:43  mah
%Release 2
%
%Revision 1.1  1999/01/25 20:03:31  mah
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
 
disp('[dataout]=hannlow(datain,passband,stopband)')

smpint=datain.fh{8}; %smpint is the sampling interval
trclength=datain.fh{7}; %trclength is the trace length
nrec=datain.fh{12}; %nrec is number of records is file

dataout=datain;

fsample=1/smpint; %fsample is the sampling freq. in Hz

Wp=passband*2*pi/fsample; %normalized passband frequency in Rads/sec
Ws=stopband*2*pi/fsample; %normalized stopband frequency in Rads/sec

% transwidth is the transwidth of the filter
% M is the order of the filter

transwidth=Ws-Wp;
M=floor(6.2*pi/transwidth);
M=2*(floor(M/2))+1; % this is to make sure M is odd

disp('The order of the filter is:')
M

Mhalf=(M-1)/2;
n=[0:1:M-1];

Wc=(Wp+Ws)/2; % Wc is the cutoff frequency

%hd is the desired impulse response of the filter
%eps is added in to make sure division by zero does not occur
hd=sin(Wc*(n-Mhalf+eps))./(pi*(n-Mhalf+eps));

%w_hann is the hanning window or finite duration window
w_hann=0.5*(1-cos(2*pi*n/(M-1)));

h=hd.*w_hann; %h is the impulse response of the hanning filter
h=h'; %to put h in column format instead of row format
lencor=floor(length(h)/2); %length correction to the data
pos=[lencor+1:1:trclength+lencor]; %is the position of the resultant data in the temp variable

for COUNT1=1:nrec
 [a,ntraces]=size(datain.dat{COUNT1}); %ntraces is the number of traces in the record
 for COUNT2=1:ntraces
  temp=conv(datain.dat{COUNT1}(:,COUNT2),h); %convolves the lowpass filter with the data
  dataout.dat{COUNT1}(:,COUNT2)=temp(pos,1); %out puts the filtered data using the positions defined by pos
 end %for COUNT2
end %for COUNT1



