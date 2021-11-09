function [dataout]=hannband(datain,lowstop,lowpass,highpass,highstop)

% [dataout]=hannband(datain,lowstop,lowpass,highpass,highstop)
%
%This function will filter your data using a bandpass
%Finite Impulse Response (FIR) filter where a hanning window
%will be used.
%'lowstop' is the frequency in Hz below which the signal is not transmitted
%'lowpass' is the frequency in Hz above which the signal is transmitted
%'highpass' is the frequency in Hz below which the signal is transmitted
%'highstop' is the frequency in Hz above which the signal is not transmitted
%
% A hanning window will be used in order to give a 
% passband ripple of 3dB and a stopband ripple of 40dB in the power domain
%
% Warning: The program does not check for unreasonable parameters
%
%This is based off of the theory developed in
%Digital Signal Processing by Alan V. Oppenheim & Ronald W. Schafer
%
%Written by Marko Mah January 1999

%$Id: hannband.m,v 3.0 2000/06/13 19:20:22 gilles Exp $
%$Log: hannband.m,v $
%Revision 3.0  2000/06/13 19:20:22  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:40  mah
%Release 2
%
%Revision 1.1  1999/02/01 21:21:48  mah
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
 
disp('[dataout]=hannband(datain,lowstop,lowpass,highpass,highstop)')

smpint=datain.fh{8}; %smpint is the sampling interval
trclength=datain.fh{7}; %trclength is the trace length
nrec=datain.fh{12}; %nrec is number of records is file

dataout=datain;

fsample=1/smpint; %fsample is the sampling freq. in Hz

Wls=lowstop*2*pi/fsample; %normalized low stop frequency in Rads/sec
Wlp=lowpass*2*pi/fsample; %normalized low pass frequency in Rads/sec
Whp=highpass*2*pi/fsample; %normalized high pass frequency in Rads/sec
Whs=highstop*2*pi/fsample; %normalized high stop frequency in Rads/sec

%% the following calculates the low pass part of the filter

% transwidth is the transwidth of the filter
% M is the order of the filter

transwidth=Whs-Whp;
M=floor(6.2*pi/transwidth);
M=2*ceil(M/2); % this is to make sure M is even

Mhalf=(M-1)/2;
n=[0:1:M-1];

Wc=(Whp+Whs)/2; % Wc is the cutoff frequency

%hd is the desired impulse response of the filter
%eps is added in to make sure division by zero does not occur
hd=sin(Wc*(n-Mhalf+eps))./(pi*(n-Mhalf+eps));

%w_hann is the hanning window or finite duration window
w_hann=0.5*(1-cos(2*pi*n/(M-1)));

hlow=hd.*w_hann; %h is the impulse response of the lowpass hanning filter

%% the following calculates the high pass part of the filter

% transwidth is the transwidth of the filter
% M is the order of the filter

transwidth=Wlp-Wls;
M=floor(6.2*pi/transwidth);
M=2*ceil(M/2); % this is to make sure M is even

Mhalf=(M-1)/2;
n=[0:1:M-1];

Wc=(Wlp+Wls)/2; % Wc is the cutoff frequency

%hd is the desired impulse response of the filter
%eps is added in to make sure division by zero does not occur
hd=(sin(pi*(n-Mhalf+eps))-sin(Wc*(n-Mhalf+eps)))./(pi*(n-Mhalf+eps));

%w_hann is the hanning window or finite duration window
w_hann=0.5*(1-cos(2*pi*n/(M-1)));

hhigh=hd.*w_hann; %h is the impulse response of the highpass hanning filter

%% the following calculates the total impulse response

h=conv(hlow,hhigh);
h=h'; %to put h in column format instead of row format

disp('Order of filter is:')
M=length(h)

lencor=floor(length(h)/2); %length correction to the data
pos=[lencor+1:1:trclength+lencor]; %is the position of the resultant data in the temp variable

for COUNT1=1:nrec
 [a,ntraces]=size(datain.dat{COUNT1}); %ntraces is the number of traces in the record
 for COUNT2=1:ntraces
  temp=conv(datain.dat{COUNT1}(:,COUNT2),h); %convolves the highpass filter with the data
  dataout.dat{COUNT1}(:,COUNT2)=temp(pos,1); %out puts the filtered data using the positions defined by pos
 end %for COUNT2
end %for COUNT1
