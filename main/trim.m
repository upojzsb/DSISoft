function [dataout]=trim(datain,t1,t2,tmax)

%[dataout]=trim(datain,t1,t2,tmax)
%
%Trim Statics
%Used to align traces in time by making small adjustments.
%
%T1 and T2 are the start and end of the time window that will be used to
%align the traces.  A trace representing the sum of all traces in the
%record will be created within this time window and this summed trace
%will be cross correlated with each trace in the same time window.
%
%tmax is the maximum time shift that will be allowed i.e. it cross
%correlateion lag times will only be allowed between (tmax) and (-tmax)
%and a maximum will be found between these lag times.
%
%Time shifts will be stored in trace header word 25.
%
%Convention: positive value = shift traces down
%            negative value = shift traces up
%
%Successive applications of this module will improve final trace alignment.
%Similar to INSIGHT module 'trim'.
%
%DSI customized VSP processing software
%written by Kristen Beaty November, 1997

%$Id: trim.m,v 3.0 2000/06/13 19:22:26 gilles Exp $
%$Log: trim.m,v $
%Revision 3.0  2000/06/13 19:22:26  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:54  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:10  kay
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

disp('[dataout]=trim(datain,t1,t2,tmax)');

dataout=datain;

nrec=datain.fh{12}; %get number of records
int=datain.fh{8}; %sampling interval (sec)
tstart=datain.fh{9}; %start time (sec)
samples=datain.fh{7}; %number of points per trace

%find index values of t1, t2 and tmax
t1=round((t1-tstart)./int)+1;
t2=round((t2-tstart)./int)+1;
tmax=ceil((tmax)./int);

for COUNT=1:nrec %loop over records
 ntpr=datain.th{COUNT}(12,1); %number of traces this record
 dataout.dat{COUNT}(:,:)=0; %initialize dataout.dat


 subdata=datain.dat{COUNT}(t1:t2,:); %make subset of data
 for tr=1:ntpr %loop over traces
  baseline=mean(subdata(:,tr));
  subdata(:,tr)=subdata(:,tr)-baseline; %each trace must have mean value of 0
 end %loop over traces

 pilot=sum(subdata,2); %make pilot trace
 pilot=pilot-mean(pilot); %must have mean of 0 for cross correlation

 %find the cross correlation function in the Fourier domain
% tic;
 [shift_f]=xcor_f(pilot,subdata,tmax);
% disp('Fourier domain solution')
% toc;

%using Fourier solution because it gives same solution in less time
 %now find the cross correlation function in the time domain
% tic;
% [shift_t]=xcor_t(pilot,subdata,tmax);
% disp('time domain solution')
% toc;

 shift=shift_f;
 %put shift times into trace headers
 dataout.th{COUNT}(25,:)=dataout.th{COUNT}(25,:)+shift(1,:).*int;

 for t=1:ntpr %loop over number of traces
  index=abs(shift(1,t));
  if shift(1,t)==0 %no shift
   dataout.dat{COUNT}(:,t)=datain.dat{COUNT}(:,t);
  elseif shift(1,t)<0 %shift upwards
   dataout.dat{COUNT}(1:(samples-index),t)=datain.dat{COUNT}(index+1:samples,t);
  else %shift downwards
   dataout.dat{COUNT}(index+1:samples,t)=datain.dat{COUNT}(1:(samples-index),t);
  end %if
 end %loop over number of traces
end %loop over records

%end of function trim

%------------------------------------------------------------------------
function [shift]=xcor_t(pilot,data,tmax)
%returns the shift in units of number of indexes that the data needs to
%be moved by for trim statics
%performs cross correlation in the time domain

l=length(pilot);
n=tmax;
self=pilot;
pilot=[zeros(size(1:n)),pilot',zeros(size(1:n))];
pilot=pilot';

%perform autocorrelation on pilot trace
for k = 0:2*n
 ac(k+1,1) = sum(self(1:l,1).*pilot(1+k:l+k,1));
end %for k = 0:2*n
[junk,ac_max]=max(ac(:,1)); %find index of the peak of autocorrelation

%perform cross correlation
for tr=size(data,2):-1:1 %loop over traces
 for k = 0:2*n
  cc(k+1,tr) = sum(data(1:l,tr).*pilot(1+k:l+k,1));
 end %for k = 0:2*n

 [junk,cc_max]=max(cc(:,tr)); %find index of peak of cross correlation
 shift(tr)=cc_max-ac_max; %find shift (in indexes)
end %loop over traces

%end of function xcor_t


%------------------------------------------------------------------------
function [shift]=xcor_f(pilot,data,tmax)
%returns the shift in units of number of indexes that the data needs to
%be moved by for trim statics
%performs cross correlation in the Fourier domain
%
%flips data traces upside down, then multiplies the magnitudes and adds
%the phases of the pilot and data traces in the Fourier domain

if tmax>length(pilot)/2
 error('tmax must be less than half of size of time window')
end

self=pilot;
pilot=[zeros(size(1:tmax)),pilot',zeros(size(1:tmax))];
pilot=pilot';

fpoints=2^nextpow2(length(pilot)); %number of points to be used in fft

%take fft of flipped pilot before zero padding to use for autocorrelation
au_fft=fft(flipud(self),fpoints);

data=flipud(data); %flip data traces upside down
pilot_fft=fft(pilot,fpoints);
sub_fft=fft(data,fpoints);

%multiply magnitudes and add phases to get cross correlation function fft
pfabs=abs(pilot_fft);
pfang=angle(pilot_fft);
for tr=1:size(data,2) %loop over traces
 mag(:,tr)=abs(sub_fft(:,tr)).*pfabs;
 phase(:,tr)=angle(sub_fft(:,tr))+pfang;
end %loop over traces

xcor_fft=mag.*exp(phase.*i); %convert to complex
xcor=ifft(xcor_fft,fpoints); %perform inverse fft to return to time domain

%perform autocorrelation
mag=abs(au_fft).*pfabs;
phase=angle(au_fft)+pfang;
aucorr_fft=mag.*exp(phase.*i); %convert to complex
aucorr=ifft(aucorr_fft,fpoints); %inverse fft
aucorr=fftshift(aucorr); %unwrap autocorrelation
[junk,ac_max]=max(aucorr); %find peak within window

k=1;
for t=-tmax:tmax
 if ac_max+t>size(xcor,1)
  row(k)=ac_max+t-size(xcor,1);
 elseif ac_max+t<1
  row(k)=ac_max+t+size(xcor,1);
 else
  row(k)=ac_max+t;
 end %if/else
 k=k+1;
end %for t=-tmax:tmax

for tr=1:size(data,2)
 xcor(:,tr)=fftshift(xcor(:,tr)); %unwrap correlation
 %only consider shifts of <+-tmax
 sub_xcor(:,tr)=real(xcor(row,tr));
 [junk,xcor_max]=max(sub_xcor(:,tr)); %find index of peak of cross correlation
 shift(tr)=xcor_max-tmax-1; %find trim shift in indexes
end %loop over traces

%end of function xcor_f
