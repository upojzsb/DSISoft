function [dataout]=butw(datain,low1,low2,high1,high2,Rp,Rs)

%[dataout]=butw(datain,low1,low2,high1,high2,Rp,Rs)
%
%Zero phase Butterworth bandpass filter.
%
%low1,low2,high1,high2 - frequencies describing the filter
%Filter is designed so that region between 'low2' and 'high1' is attenuated
%by less than 3 dB and region before 'low1' and after 'high2' is attenuated
%by at least 20 dB.
%Rp - attenuation max within pass band (dB) (around 3 dB is good)
%Rs - attenuation at outside frequencies (dB) (try 20 or 40)
%
%All frequencies are in Hertz (Hz)
%
%Note - uses functions from signal processing toolbox
%
%DSI customized VSP processing software
%written by Kristen Beaty January, 1998

%$Id: butw.m,v 3.0 2000/06/13 19:19:55 gilles Exp $
%$Log: butw.m,v $
%Revision 3.0  2000/06/13 19:19:55  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:18  mah
%Release 2
%
%Revision 1.2  1999/05/17 14:58:15  mah
%fixed up help message
%
%Revision 1.1  1999/01/06 19:09:02  kay
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

disp('[dataout]=butw(datain,low1,low2,high1,high2,Rp,Rs)');

int=datain.fh{8}; %sampling interval (s)
Ny=1/(int*2); %Nyquist frequency
Wp=[low2 high1]./Ny; %pass frequencies (normalized)
Ws=[low1 high2]./Ny; %outside frequencies (normalized)

%build Butterworth filter function
[n,Wn]=buttord(Wp,Ws,Rp,Rs);
[b,a]=butter(n,Wn);

dataout=datain;
nrec=datain.fh{12};

for COUNT=1:nrec %loop over records
 ntr=datain.th{COUNT}(12,1);
 for tr=1:ntr
  in=datain.dat{COUNT}(:,tr)';
  out=filtfilt(b,a,in); %apply filter
  dataout.dat{COUNT}(:,tr)=out';
 end %loop over traces
end %loop over records
