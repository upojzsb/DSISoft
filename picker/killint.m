function killint(action,thm)

%interactive module for killing traces
%works with 'pick1comp'
%saves killed trace data in matrix 'killflg'
%kills are only saved if 'save' is chosen on exiting program
%flagged traces are ignored by picking module and are diplayed as flat red lines
%thm is trace header matrix
%
%DSI customised processing software
%written by K.S. Beaty February, 1998

%$Id: killint.m,v 3.0 2000/06/13 19:22:46 gilles Exp $
%$Log: killint.m,v $
%Revision 3.0  2000/06/13 19:22:46  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:47:10  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:25  kay
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
global temp

child=get(gca,'children');
L=flipud(findobj(child,'type','line'));
P=flipud(findobj(child,'type','patch'));
row=length(get(L(1),'xdata'));
tr1=str2num(get(findobj('tag','EditTr1'),'string'));
tr2=str2num(get(findobj('tag','EditTr2'),'string'));
ntr=tr2-tr1+1;

switch action
 case 'firstcall'
  set(L(1:ntr),'erasemode','background')
  set(P(1:ntr),'erasemode','background')
  bad=find(thm(6,tr1:tr2)<0);
  killflg=zeros(row,ntr);

 case 'killbutton'
  wbdf=get(gcf,'windowbuttondownfcn');
  if ~isempty(wbdf) & length(wbdf)==10
   set(gcf,'windowbuttondownfcn','');
   set(findobj(gcf,'string','PICK'),'enable','on')
  else
   set(gcf,'windowbuttondownfcn','killint on')
   set(findobj(gcf,'string','PICK'),'enable','off')
   set(L(1:ntr),'erasemode','background')
   set(P(1:ntr),'erasemode','background')
  end %if
  return;

 case 'on'
  pt=get(gca,'currentpoint');
  bad=round(pt(1,1))-tr1+1;
  killflg=get(gca,'userdata');
  deadtr=find(killflg(1,bad)~=0);
  if ~isempty(deadtr) %if trace has already been killed
   set(L(bad),'xdata',killflg(:,bad),'color','k')
   set(L(bad),'linestyle','-')
   set(P(bad),'visible','on')
   killflg(:,bad)=0;
   set(gca,'userdata',killflg)
   return;
  end %if

end %case

for i=bad
 killflg(:,i)=get(L(i),'xdata')';
 flatline(1:row)=i+tr1-1;
 set(L(i),'xdata',flatline,'color','r');
 set(P(i),'visible','off');
end %for
set(gca,'userdata',killflg)

a=get(temp(3),'ydata');
a(bad)=NaN;
set(temp(3),'ydata',a)
a=find(ptimes(1,bad)~=0);
if ~isempty(a)
 b=find(ptimes(2,bad)~=0);
 if ~isempty(b)
  delete(ptimes(2,bad(b)))
 end %if
 ptimes(1:2,bad(a))=0;
end %if
