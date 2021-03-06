function [dataout]=kill(datain,kword,bad)

%function [dataout]=kill(datain,kword,bad)
%
%similar to 'kill' module in INSIGHT
%marks bad traces by writing '-1' to trace header word 6
%marked traces will be omitted when using filtering modules
%marked traces can be removed using the function 'pack'
%
%datain is in DSI official data format
%kword is the trace header word number by which bad trace is identified
%       kword=1 sequential record number
%       kword=26 receiver station
%       kword=27 shot station
%bad is a vector of numbers identifying the traces to be flagged
%
%DSI customized VSP processing software
%written by Kristen Beaty October, 1997

%$Id: kill.m,v 3.0 2000/06/13 19:20:36 gilles Exp $
%$Log: kill.m,v $
%Revision 3.0  2000/06/13 19:20:36  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:50  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:04  kay
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

disp('[dataout]=kill(datain,kword,bad)');

dataout=datain;

for COUNT=1:datain.fh{12} %loop over records
 k=1;
 for i=1:length(bad)
  temp=find(datain.th{COUNT}(kword,:)==bad(i));
  dead(k:k+length(temp)-1)=temp;
  k=k+length(temp);
 end %for
 for k=dead
  dataout.th{COUNT}(6,k)=-1;
 end %for
end %loop over records
