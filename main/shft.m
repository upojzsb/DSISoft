function [dataout]=shft(datain,scale,word)

%[dataout]=shft(datain,scale,word)
%
%This function requires input data in DSI format.
%A time shift will be applied or removed on a per trace basis
%by an amount given in trace header word 'word'.
%Shifts are to the nearest sampling point. 
%
%scale is what the desired time shifts will be multiplied by
%1.0: Apply static shift
%-1.0: Remove previously applied shifts
%
%word is the trace header word containing the time in seconds
%by which the trace is to be shifted
%
%Shifts will be applied to all traces and records.
%
%Convention: positive value = shift traces down
%            negative value = shift traces up
%
% Warning: Program does not check for reasonable parameters
%
%DSI customized VSP processing software
%Written by Marko Mah January 1999

%$Id: shft.m,v 3.0 2000/06/13 19:22:03 gilles Exp $
%$Log: shft.m,v $
%Revision 3.0  2000/06/13 19:22:03  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:35  mah
%Release 2
%
%Revision 1.4  1999/05/21 15:11:38  mah
%eof problem
%
%Revision 1.3  1999/05/21 15:10:41  mah
%eof problem
%
%Revision 1.2  1999/02/09 21:58:02  mah
%fixed up shift because it was off by one sample
%
%Revision 1.1  1999/01/26 19:45:45  mah
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

disp('[dataout]=shft(datain,scale,word)');

dataout=datain;

nrec=datain.fh{12}; %number of records
int=datain.fh{8}; %sampling interval (sec)
samples=datain.fh{7}; %number of points per trace

for COUNT1=1:nrec
 [a,ntraces]=size(datain.dat{COUNT1}); %ntraces is the number of traces in the record
 dataout.dat{COUNT1}(:,1:ntraces)=0; %initialize traces
 for COUNT2=1:ntraces
  %takes shift times from trace header word 'word'
  shift=datain.th{COUNT1}(word,COUNT2);
  shift=shift*scale; %multiplies shift by scale to get "total" shift
  index=round(abs(shift)/int); %converts shift from time to samples
  if index==0 %no shift
   dataout.dat{COUNT1}(:,COUNT2)=datain.dat{COUNT1}(:,COUNT2);
  elseif shift<0 %shift upwards
   dataout.dat{COUNT1}(1:(samples-index),COUNT2)=datain.dat{COUNT1}(index+1:samples,COUNT2);
  else %shift downwards
   dataout.dat{COUNT1}(index+1:samples,COUNT2)=datain.dat{COUNT1}(1:(samples-index),COUNT2);
  end %if index
 end %for COUNT2
end %for COUNT1



