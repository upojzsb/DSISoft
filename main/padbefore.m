function [dataout]=padbefore(datain,padding)

% [dataout]=padbefore(datain,padding)
%
%This function just addings zeros to the beginning of the data
%
% padding is the amount of time in seconds to be added to the beginning of the data
%
% Warning: The program does not check for unreasonable parameters
%
%Written by Marko Mah February 1999

%$Id: padbefore.m,v 3.0 2000/06/13 19:21:02 gilles Exp $
%$Log: padbefore.m,v $
%Revision 3.0  2000/06/13 19:21:02  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:12  mah
%Release 2
%
%Revision 1.1  1999/05/14 13:15:01  mah
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
 
disp('[dataout]=padbefore(datain,padding)')

smpint=datain.fh{8}; %smpint is the sampling interval
trclengthold=datain.fh{7}; %trclength is the trace length
nrec=datain.fh{12}; %nrec is number of records is file
nppad=round(padding/smpint); %nppad is the number of zeros to add to the beginning of each trace
trclengthnew=trclengthold+nppad; %trclengthnew is the new trace length
trcendtime=(trclengthnew-1)*smpint; %trcendtime is the new trace end time

dataout=datain;

dataout.fh{7}=trclengthnew; %updates the number of points per trace
dataout.fh{10}=trcendtime; %updates the trace end time

for COUNT=1:nrec
 [trclength,ntraces]=size(datain.dat{COUNT}); %ntraces is the number of traces in the record
 dataout.dat{COUNT}=zeros(trclengthnew,ntraces); %zeros the output data
 dataout.dat{COUNT}(nppad+1:trclengthnew,:)=datain.dat{COUNT}; %copies the input data to the output data
end %for COUNT
