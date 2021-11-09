function [dataout]=debias(datain,starttime,endtime)

%[dataout]=debias(datain,starttime,endtime)
%
%This function will debias the data
% datain is the input data
% starttime is the time in seconds at which the analysis starts
% endtime is the time in seconds at which the analysis ends
%
%The debias correction is applied to the whole data!
%
% Warning: The program does not check for unreasonable parameters
%
%Written by Marko Mah March 1999

%$Id: debias.m,v 3.0 2000/06/13 19:20:03 gilles Exp $
%$Log: debias.m,v $
%Revision 3.0  2000/06/13 19:20:03  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:27  mah
%Release 2
%
%Revision 1.1  1999/03/15 14:52:12  mah
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
 
disp('[dataout]=debias(datain,starttime,endtime)')

smpint=datain.fh{8}; %smpint is the sampling interval
nrec=datain.fh{12}; %nrec is number of records is file

dataout=datain;

startpoint=round(starttime/smpint)+1; %startpoint is the starting time in samples
endpoint=round(endtime/smpint)+1; %endpoint is the end time in samples

for COUNT1=1:nrec
 [a,ntraces]=size(datain.dat{COUNT1}); %ntraces is the number of traces in the record
 correction=mean(datain.dat{COUNT1}(startpoint:endpoint,:)); %correction is the debias to be applied to each trace

 for COUNT2=1:ntraces
  dataout.dat{COUNT1}(:,COUNT2)=datain.dat{COUNT1}(:,COUNT2)-correction(1,COUNT2); % debiases trace by trace
 end %for COUNT2
end %for COUNT1



