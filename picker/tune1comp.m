function tune1comp(option)

%function tune1comp(option)
%
%tune works with pick1comp
%it tunes first break pick times
%option=1 for peaks; 2 for troughs; and 3 for zero crossings
%option is selected in interactive module using popupmenu
%
%DSI customized processing software
%written by K.S.Beaty February, 1998

%$Id: tune1comp.m,v 3.0 2000/06/13 19:23:21 gilles Exp $
%$Log: tune1comp.m,v $
%Revision 3.0  2000/06/13 19:23:21  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:48:02  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:29  kay
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

%ptimes is pick times in indexes

global ptimes
global temp

data=get(gcf,'userdata');
dataset=data{1};
smp=dataset.fh{8};
ntr=length(ptimes);
child=get(gca,'children');
L=flipud(findobj(child,'type','line'));
t1=str2num(get(findobj('tag','EditT1'),'string'));
tr1=str2num(get(findobj('tag','EditTr1'),'string'));

tr=find(ptimes(1,:)~=0);
nopeaks=find(ptimes(2,tr)==0);
for i=tr(nopeaks)
 greenpeaks([i+tr1-1 (ptimes(1,i)-1)*smp+t1 ptimes(1,i)]);
end %for
for i=tr
 xd=get(ptimes(2,i),'xdata');
 yd=get(ptimes(2,i),'ydata');
 switch option
  case 1 %peaks
   [newpick]=findpeak(xd,yd,t1,smp,i,tr1,L);
  case 2 %troughs
    xdrev=2*(i+tr1-1)-xd;
   [newpick]=findpeak(xdrev,yd,t1,smp,i,tr1,L,[]);
  case 3 %zero crossing
    lowi=round((yd(1)-t1)./smp+1)+1;
    highi=round((yd(length(yd))-t1)./smp+1)-1;
    xdtr=get(L(i),'xdata');
    while abs(xdtr(lowi)-i-tr1+1)<abs(xdtr(lowi+1)-i-tr1+1)
     lowi=lowi-1;
    end %while
    while abs(xdtr(highi)-i-tr1+1)<abs(xdtr(highi-1)-i-tr1+1)
     highi=highi+1;
    end %while
    if (ptimes(1,i)-lowi)<=(highi-ptimes(1,i))
     newpick=lowi+1;
    else
     newpick=highi-1;
    end %if/else
    delete(ptimes(2,i)); %get rid of shaded peaks
    ptimes(2,i)=0;
 end %switch
 ptimes(1,i)=newpick;
end %for

a=get(temp(3),'ydata');
a(tr)=(ptimes(1,tr)-1).*smp+t1;
set(temp(3),'ydata',a) %update line



function [newpick]=findpeak(xd,yd,t1,smp,i,tr1,L,troughflg)

global ptimes

   if xd(2)>i+tr1-1
    [xmax,peak]=max(abs(xd-i-tr1+1));
    newpick=round((yd(peak)-t1)./smp+1); %in indexes of real trace
   else
    xdtr=get(L(i),'xdata');
    if nargin==8
     xdtr=2*(i+tr1-1)-xdtr;
    end %if
    lowi=round((yd(1)-t1)./smp+1);
    highi=round((yd(length(yd))-t1)./smp+1);
    while xdtr(lowi)>xdtr(lowi+1)
     lowi=lowi-1;
    end %while
    while xdtr(highi)>xdtr(highi-1)
     highi=highi+1;
    end %while
    if abs(xdtr(lowi+1))>=abs(xdtr(highi-1))
     newpick=lowi+1;
    else
     newpick=highi-1;
    end %if/else
    delete(ptimes(2,i));
    ptimes(2,i)=0;
    greenpeaks([i+tr1-1 (newpick-1)*smp+t1 newpick]);
   end %if/else

