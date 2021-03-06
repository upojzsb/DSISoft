function [dataout]=medi_filt(datain,window)

%function [dataout]=medi_filt(datain,window)
%
%median filter - traces should be lined up before using
%medi_filt takes the user specified number of traces (window) and sets the
%middle trace points equal to the median values of the group
%
%datain  - is in official DSI format
%window - is the size of the median filter window, which must be
%an odd number
%
%DSI customized VSP processing software
%written by Kristen Beaty November, 1997

%$Id: medi_filt.m,v 3.0 2000/06/13 19:20:44 gilles Exp $
%$Log: medi_filt.m,v $
%Revision 3.0  2000/06/13 19:20:44  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:57  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:05  kay
%Initial revision
%
%Revision 1.1  1999/01/05 22:09:18  kay
%Initial revision
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

disp('[dataout]=medi_filt(datain,window)');

window=(window-1)/2;

dataout=datain; %initialize dataout
nrec=datain.fh{12};

for COUNT=1:nrec %loop over records
 ntpr=datain.th{COUNT}(12,1); %number of traces in this record

 %bulk of traces
 for i=window+1:ntpr-window
  temp=datain.dat{COUNT}(:,i-window:i+window); %data within window
  dataout.dat{COUNT}(:,i)=median(temp,2);
 end %loop over bulk of traces

 %first traces
 for i=1:window
  %set first traces equal to filtered trace in column window+1
  dataout.dat{COUNT}(:,i)=dataout.dat{COUNT}(:,window+1);
 end %loop over first traces

 %last traces
 for i=ntpr-window+1:ntpr
  %set last traces equal to filtered trace in column ntpr-window
  dataout.dat{COUNT}(:,i)=dataout.dat{COUNT}(:,ntpr-window);
 end %loop over last traces
end %loop over records

