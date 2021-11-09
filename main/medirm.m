function [dataout,medi_data]=medirm(datain,tmax,win,v,static)

%[dataout,medi_data]=medirm(datain,tmax,win,v,static)
%(flattens by velocity and shot static)
%or
%[dataout,medi_data]=medirm(datain,tmax,win,headwd)
%(flattens by pick times)
%
%Module to remove a downgoing wave using a median filter.
%Data (in DSI format) is flattened according to the velocity of the wave to
%be removed or else according to pick times and trim statics are applied.
%Flattened data are then median filtered and this filtered dataset is stored
%in the variable 'filt_data' and subtracted form the dataset.  Trim static
%shifts are stored in trace header word 25.  Shifts done to flatten the
%velocity are removed but trim statics are not.
%
%This routine is advantageous because it buffers the data so that none is
%lost from doing time shifts.  This is especially good for trying to remove
%the S wave without loosing reflections that arrive before it.
%
%tmax - maximum time shift to be considered by trim statics (try ~ 0.01s)
%win - window for median filter (must be an odd number)
%v - velocity of wave to be removed
%static - shot static (s) (used to calculate window in which to perform trim
%headwd - header word that first break pick times are stored in
%
%Uses other DSI modules (tred, flat, unflat, trim, ener, medi_filt, and subr)
%
%DSI customized VSP processing software
%written by Kristen Beaty January, 1998

%$Id: medirm.m,v 3.0 2000/06/13 19:20:46 gilles Exp $
%$Log: medirm.m,v $
%Revision 3.0  2000/06/13 19:20:46  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:59  mah
%Release 2
%
%Revision 1.2  1999/01/11 19:55:53  mah
%removed repeated lines of code
%
%Revision 1.1  1999/01/06 19:09:05  kay
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

tredway=(nargin==5);
if tredway
 disp('[dataout,medi_data]=medirm(datain,tmax,win,v,static)');
else
 disp('[dataout,medi_data]=medirm(datain,tmax,win,headwd)');
 headwd=v;
end %if

%half of time window to which trim statics will be applied
thalf=0.015;

nrec=datain.fh{12}; %number of records
npts=datain.fh{7}; %number of points per trace
data=datain;

for COUNT=1:nrec %loop over records
 ntr=datain.th{COUNT}(12,1); %number of traces in this record
 data.dat{COUNT}=zeros(2.*npts,ntr); %zero pad data
 data.dat{COUNT}(npts+1:2.*npts,:)=datain.dat{COUNT};
end %loop over records
data.fh{7}=2.*npts; %reset number of points per trace
if tredway
 [data]=tred(data,-v,0); %flatten wave
 tw=static+datain.fh{10}; %add end time to account for zero padding
else
 [data]=flat(data,0,headwd); %flatten by pick times
 tw=datain.fh{10};
end %if/else

[data]=ener(data,tw-thalf,tw+thalf); %energy balance wave

[data]=trim(data,tw-thalf,tw+thalf,tmax); %trim statics

[medi_data]=medi_filt(data,win); %median filter
for COUNT=1:nrec
 medi_data.dat{COUNT}(1:npts-50)=0; %mute filtered data before first breaks
end %for

[data]=subr(medi_data,data); %subtract filtered wave

if tredway
 [data]=tred(data,v,0); %unflatten wave
else
 [data]=unflat(data,0,headwd); %unflatten by pick times
end %if/else

dataout=data;
%remove zero padding
for COUNT=1:nrec %loop over records
 dataout.dat{COUNT}=data.dat{COUNT}(npts+1:2.*npts,:);
 medi_data.dat{COUNT}=medi_data.dat{COUNT}(npts+1:2.*npts,:);
end %loop over records
dataout.fh{7}=npts; %reset number of points per trace
medi_data.fh{7}=npts; %reset number of points per trace


