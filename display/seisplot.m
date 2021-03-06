function [fact]=seisplot(datain,t1,t2,tr1,tr2,smp,scal,pltflg,scfact,colour,tstart)

%[fact]=seisplot(datain,t1,t2,tr1,tr2,smp,scal,pltflg,scfact,colour,tstart)
%
%function for plotting seismic traces
%
%INPUT
%datain - input matrix of seismic traces
%t1,t2 - beginning and end times to be displayed
%tr1,tr2 - first and last traces to be displayed
% note - to display traces in reverse direction set tr1 equal to larger trace #
%smp - sampling interva (s)
%scal - 1 for max, 0 for ave
%pltflg - 1 plot only filled peaks, 0 plot wiggle traces and filled peaks,
% 2 plots wiggle traces only and 3 or more plots grayscale image
%scfact - scaling factor
%colour - trace colour, default is black
%
%OUPTPUT
%fact - factor that matrix was scaled by for plotting
%if you want to plot several matrices using the same scaling factor,
%capture 'fact' and pass it as input variable 'scal' to future matrices
%with 'scfact' set to 1
%
%DSI customized VSP processing software
%written by G. Perron January, 1998

%$Id: seisplot.m,v 3.0 2000/06/13 19:19:15 gilles Exp $
%$Log: seisplot.m,v $
%Revision 3.0  2000/06/13 19:19:15  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:44:00  mah
%Release 2
%
%Revision 1.5  1999/05/21 17:56:09  mah
%checked in file which wasn't checked in properly
%
%Revision 1.4  1999/05/21 17:36:41  mah
%checking in file which wasn't checked in properly
%
%Revision 1.3  1999/01/14 21:08:18  perron
%Fixing a typo in the previous version
%
%Revision 1.2  1999/01/14 20:43:10  perron
%Adding tstart variable to take into account subset variables when computing sample range to plot
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

if nargin<10
 colour='k';
end %if
if nargin<11
 tstart=0;
end %if

a=datain(round((t1-tstart)/smp)+1:round((t2-tstart)/smp)+1,traces);
if scal==1
   fact=max(max(abs(a)));
elseif scal==0
   fact=max(mean(abs(a)));
else
   fact=scal;
end
fact=fact./scfact;
a=a./fact;

if pltflg>=3
  imagesc(traces,t1:smp:t2,a);
  colormap(gray)
  colorbar
  xlabel('Trace Number')
  ylabel('Time (s)')
  if tr1>tr2
   set(gca,'xdir','reverse')
  end %if
  return;
end %if

b=find(a<0);
c=a;
c(b)=0;
[xmat,ymat]=meshgrid(traces,t1:smp:t2);
c=c.*inc+xmat;
c(1,:)=xmat(1,:);
c(round(t2/smp+1-t1/smp),:)=xmat(1,:);
a=a.*inc+xmat;

if pltflg==0
   h=fill(c,ymat,colour);
   set(h,'edgecolor','none')
   hold on
   plot(a,ymat,colour);
   hold off
elseif pltflg==1
   h=fill(c,ymat,colour);
   set(h,'edgecolor','none')
elseif pltflg==2
   plot(a,ymat,colour);
end
set(gca,'ydir','reverse')
if tr1>tr2
 axis([tr2-1 tr1+1 t1 t2])
 set(gca,'xdir','reverse')
else
 axis([tr1-1 tr2+1 t1 t2])
end %if/else
xlabel('Trace Number')
ylabel('Time (s)')
set(gca,'ygrid','on')
