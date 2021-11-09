function [dataout]=preddecon(datain,tstart,tend,lag,oplength,prewhit)

%[dataout]=preddecon(datain,tstart,tend,lag,oplength,prewhit)
%
%This program will perform a predictive deconvolution on the data
% datain is the input data
% tstart is the start of the window of data in seconds to be pred. deconed
% tend is the end of the window of data in seconds to be pred. deconed
% lag is the lag of the operator in seconds
% oplength is the length of the operator to be applied in seconds
% prewhit is the percent of prewhitening to be applied
%
% Warning: The program does not check for unreasonable parameters
%
%This is based off of the theory developed in
%Predictive Deconvolution: Theory and Practice in Geophysics 1969 by Peacock and Treitel
%Seismic Data Processing by Yilmaz
%
%Written by Marko Mah February 1999

%$Id: preddecon.m,v 3.0 2000/06/13 19:21:05 gilles Exp $
%$Log: preddecon.m,v $
%Revision 3.0  2000/06/13 19:21:05  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:14  mah
%Release 2
%
%Revision 1.1  1999/02/15 19:07:43  mah
%Initial revision
%
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
 
disp('[dataout]=preddecon(datain,tstart,tend,lag,oplength,prewhit)')

smpint=datain.fh{8}; %smpint is the sampling interval
trclength=datain.fh{7}; %trclength is the trace length
nrec=datain.fh{12}; %nrec is number of records is file
tstart=round(tstart/smpint)+1; %converts tstart to samples
tend=round(tend/smpint)+1; %converts tend to samples
lag=round(lag/smpint); %converts tend to samples
oplength=round(oplength/smpint); %converts oplength to samples
prewhit=prewhit/100; %converts to prewhitening from % to decimal

dataout=datain;

for COUNT1=1:nrec
 % make a copy of the data to be worked on
 data=datain.dat{COUNT1}(tstart:tend,:);
 %datalen is the length of the data
 %ntraces is the number of traces in the record
 [datalen,ntraces]=size(data);

 for COUNT2=1:ntraces
  %datatr is the data to be worked on for this trace
  datatr=data(:,COUNT2);
  % take autocorrelation of data
  autocorrdata=xcorr(datatr);
  %take only the last half of the autocorr
  autocorrdata=autocorrdata(datalen:2*datalen-1);
  %fcoltop is the first column of the toeplitz matrix
  fcoltop=autocorrdata(1:oplength);
  %incorporate prewhitening into the decon
  fcoltop(1)=fcoltop(1)*(1+prewhit);
  %toemat is the toeplitz matrix
  toemat=toeplitz(fcoltop);
  %predout is the predicted output
  predout=autocorrdata(1+lag:oplength+lag);
  %predop is the prediction operator
  predop=toemat\predout;
  %prederrop is the prediction error operator
  prederrop=[1; zeros(lag-1,1); -predop;];
  %decondata is the predictive deconed data
  decondata=conv(datatr,prederrop);
  %take the right length of the data
  decondata=decondata(1:datalen);
  %write out the data
  dataout.dat{COUNT1}(tstart:tend,COUNT2)=decondata;
 end %for COUNT2
end %for COUNT1
