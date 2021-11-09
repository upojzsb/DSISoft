function [dataout]=mix(datain,weights)

%function [dataout]=mix(datain,weights)
%
%lateral trace mixing with user specified weights
%similar to INSIGHT module 'mix'
%
%datain - is in official DSI format
%weights - is a vector of weight factors for the mix.  ex. [0.12,0.76,0.12]
%is a typical triangle weighted mix.  elements of 'weight' should add up to 1
%length of weights or number of weights must be an odd number
%
%DSI customized VSP processing software
%written by Kristen Beaty November, 1997

%$Id: mix.m,v 3.0 2000/06/13 19:20:50 gilles Exp $
%$Log: mix.m,v $
%Revision 3.0  2000/06/13 19:20:50  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:02  mah
%Release 2
%
%Revision 1.2  1999/05/17 17:15:02  mah
%fixed help message
%
%Revision 1.1  1999/01/06 19:09:06  kay
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

disp('[dataout]=mix(datain,weights)');
dataout=datain;
buff=(length(weights)-1)/2;
nrec=datain.fh{12};
npts=datain.fh{7};

for COUNT=1:nrec %loop over records
 ntpr=datain.th{COUNT}(12,1); %get number of traces in this record
 for i=1+buff:ntpr-buff
  dataout.dat{COUNT}(:,i)=0;
  n=1;
  for k=i-buff:i+buff
   dataout.dat{COUNT}(:,i)=dataout.dat{COUNT}(:,i)+datain.dat{COUNT}(:,k).*weights(n);
   n=n+1;
  end %for k=i-buff:i+buff
 end %loop over mixable traces
end %loop over records
