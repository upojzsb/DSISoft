function [dataout]=unflat2(datain,datum_time,word)
%
%function [dataout]=unflat2(datain,datum_time,word)
%
%The funcion unflat2 unflattens the times stored in a header word from a desired datum time
%
%Input arguments are:
% datain= input data in official DSI format
% datum_time= datum time at which to unflatten the data from in seconds
% word=	header word containing the picked times of the horizon
%
%DSI customized VSP processing software
%Written by Marko Mah February 1999

%$Id: unflat2.m,v 3.0 2000/06/13 19:22:36 gilles Exp $
%$Log: unflat2.m,v $
%Revision 3.0  2000/06/13 19:22:36  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:47:02  mah
%Release 2
%
%Revision 1.1  1999/02/09 21:47:55  mah
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

disp('[dataout]=unflat2(datain,datum_time,word)');

dataout=datain; %initializes the data

nrec=datain.fh{12}; %number of records
int=datain.fh{8}; %sampling interval (sec)
tstart=datain.fh{9}; %start time (sec)
samples=datain.fh{7}; %number of points per trace
 
for COUNT1=1:nrec
 [a,ntraces]=size(datain.dat{COUNT1}); %ntraces is the number of traces in the record
 dataout.dat{COUNT1}(:,1:ntraces)=0; %initialize traces
 for COUNT2=1:ntraces
  %calculates shift time from datum time and from trace header word 'word'
  shift=datain.th{COUNT1}(word,COUNT2)-datum_time;
  index=round(abs(shift)/int); %converts shift from time to samples
  if shift==0 %no shift
   dataout.dat{COUNT1}(:,COUNT2)=datain.dat{COUNT1}(:,COUNT2);
  elseif shift<0 %shift upwards
   dataout.dat{COUNT1}(1:(samples-index),COUNT2)=datain.dat{COUNT1}(index+1:samples,COUNT2);
  else %shift downwards
   dataout.dat{COUNT1}(index+1:samples,COUNT2)=datain.dat{COUNT1}(1:(samples-index),COUNT2);
  end %if index
 end %for COUNT2
end %for COUNT1

