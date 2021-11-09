function greenpeaks(pt,n)

%function greenpeaks(pt,n)
%
%pt is vector of trace/picktime/index of picktime
%n is row in 'ptimes' in which to store patch handle (default is 2)
%sets global ptimes to proper values
%shades a picked peak or trough of a seismic trace
%called by 'picktimes2' and 'tune'
%
%written by K.S. Beaty February, 1998

%$Id: greenpeaks.m,v 3.0 2000/06/13 19:22:44 gilles Exp $
%$Log: greenpeaks.m,v $
%Revision 3.0  2000/06/13 19:22:44  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:47:08  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:24  kay
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

global ptimes
if nargin==1
 n=2;
end %if
tr1=get(findobj(findobj('Name','Picker Menu'),'tag','EditTr1'),'string');
tr1=str2num(tr1);
child=get(gca,'children');
L=flipud(findobj(child,'type','line'));
xd=get(L(pt(1,1)-tr1+1),'xdata');
yd=get(L(pt(1,1)-tr1+1),'ydata');
npts=length(xd);
k=pt(1,3); %index
if xd(k)<pt(1,1)
 pxd=2.*pt(1,1)-xd;
else
 pxd=xd;
end %if
low=k;
high=k;
while pxd(low)>pt(1,1)
 low=low-1;
 if low==1
  break;
 end %if
end %while
while pxd(high)>pt(1,1)
 high=high+1;
 if high==npts
  break;
 end %if
end %while
low=low+1;
high=high-1;
peakx=[pt(1,1) xd(low:high) pt(1,1)];
peaky=[yd(low) yd(low:high) yd(high)];
ptimes(n,pt(1,1)-tr1+1)=patch(peakx,peaky,'g', 'EraseMode', 'xor');
ptimes(1,pt(1,1)-tr1+1)=pt(1,3);

