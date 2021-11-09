function seisatrplot(datain,rec,t1,t2,tr1,tr2,smp,cmap,tstart)

%seisatrplot(datain,rec,t1,t2,tr1,tr2,smp,cmap,tstart)
%
%function for plotting seismic attributes data
%
%INPUT
%datain - input matrix of seismic attributes data 
%rec -  record number (each record of original data file has 3 consecutive 
%       seismic attributes records assigned to it - amplitude, frequency, and 
%       phase, in that order.  'rec' is a flag used to correctly annotate 
%       the plot.
%t1,t2 - beginning and end times to be displayed
%tr1,tr2 - first and last traces to be displayed
% note - to display traces in reverse direction set tr1 equal to larger trace #
%smp - sampling interval (s)
%cmap - colourmp to use (eg. 'gray','hsv','jet')
%tstart - start time itself
%
%OUPTPUT
%
%DSI customized VSP processing software
%written by K.S. Beaty July, 1998

%$Id: seisatrplot.m,v 3.0 2000/06/13 19:19:13 gilles Exp $
%$Log: seisatrplot.m,v $
%Revision 3.0  2000/06/13 19:19:13  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:43:58  mah
%Release 2
%
%Revision 1.2  1999/01/14 22:15:50  perron
%Added tstart variable to take into account subset variables
%
%Revision 1.1  1999/01/06 19:08:35  kay
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

if tr1>tr2
 inc=-1;
 traces=tr2:tr1;
else
 inc=1;
 traces=tr1:tr2;
end %if/else

a=datain(round((t1-tstart)/smp)+1:round((t2-tstart)/smp)+1,traces);
imagesc(traces,t1:smp:t2,a);
colormap(cmap)
colorbar
xlabel('Trace Number')
ylabel('Time (s)')
if tr1>tr2
 set(gca,'xdir','reverse')
end %if

switch rem(rec,3)
 case 1
  title('Amplitude')
 case 2
  title('Frequency (Hz)')
 case 0
  title('Phase')
end %switch
 
