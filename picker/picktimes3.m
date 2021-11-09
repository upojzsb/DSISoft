function picktimes3(action)

%meant to work on top of a figure that has one axis with seismic traces on it
%this is an attempt to imitate the picking process as it is set up in
%INSIGHT's vaq2
%stores pick times as indexes in variable 'ptimes'
%
%picking is done as follows:
%	first mouse button: clears a single trace pick
%	second mouse button: selects a single trace pick
%	third mouse button: starts dragging a line
%	  followed by 1st or 3d button: erases picks on all selected traces
%	  followed by 2nd button: picks times on all selected traces
%
%written by K.S. Beaty February, 1998

%$Id: picktimes3.m,v 3.0 2000/06/13 19:23:19 gilles Exp $
%$Log: picktimes3.m,v $
%Revision 3.0  2000/06/13 19:23:19  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:48:01  mah
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

global temp
global ptimes

rec=str2num(get(findobj('tag','EditRec1'),'string'));
tr1=str2num(get(findobj('tag','EditTr1'),'string'));
tr2=str2num(get(findobj('tag','EditTr2'),'string'));
t1=str2num(get(findobj('tag','EditT1'),'string'));
t2=str2num(get(findobj('tag','EditT2'),'string'));
data=get(gcf,'userdata');
axhand=data{5};
dataset=data{1};
ntr=tr2-tr1+1;
smp=dataset.fh{8};

if nargin==0
 ptimes=zeros(6,ntr);
 headwd=str2num(get(findobj('tag','EditHead1'),'string'));
 ptimes(1,:)=dataset.th{rec}(headwd,tr1:tr2);
 t=ptimes(1,:);
 if (min(t)<t1 & min(t)~=0) | max(t)>t2
  close(findobj('name','Pick First Breaks'))
  msgbox('Pick times are not within t1 and t2.  Try again.', 'Warning','warn')
  error('Pick times are not within t1 and t2');
 end %if
 k=find(ptimes(1,:)~=0);
 ptimes(1,k)=round((ptimes(1,k)-t1)./smp+1);
 z=find(ptimes(1,:)==0);
 a=ptimes(1,:);
 a(z)=NaN;
 for n=5:-1:3
  set(gcf,'currentaxes',axhand(n-2))
  hold on
  for i=k
   greenpeaks([i+tr1-1,t(i),ptimes(1,i)],n-1)
  end %for
  temp(n)=line(tr1:tr2,(a-1)*smp+t1,'erasemode','xor');
  set(temp(n),'color','r','linewidth',[2])
 end %for
% set(gcf,'windowbuttondownfcn','picktimes3 down1;');
 return;
end %if

switch action
 case 'down1'
  pt=get(gca,'CurrentPoint');
  index=round((pt(1,2)-t1)./smp+1);
  pt=[round(pt(1,1)) pt(1,2) index];
  but=get(gcf,'SelectionType');
  switch but
   case 'alt' %button 3 - start dragging line for multiple picks/clears
    temp(2)=plot(pt(1,1),pt(1,2),'ro', 'EraseMode', 'xor');
    temp(1)=line('XData',[pt(1,1);pt(1,1)],'YData',[pt(1,2);pt(1,2)], 'EraseMode', 'xor');
    set(temp(1),'color','r');

    set(gcf,'windowbuttonmotionfcn','picktimes3 motion1;');
    set(gcf,'windowbuttondownfcn','picktimes3 down2;');

   case 'extend' %button 2 - pick single peak
    killflg=get(findobj(gcf,'string','KILL'),'userdata');
    if killflg{1}(1,round(pt(1,1))-tr1+1)~=0 %if trace has been killed
     return;
    end %if to ignore killed traces
    if ptimes(2,pt(1,1)-tr1+1)~=0 %delete greenpeak if it exists
      delete(ptimes(2:4,pt(1,1)-tr1+1))
      ptimes(2:4,pt(1,1)-tr1+1)=0;
    end %if
    for n=1:3
     set(gcf,'currentaxes',axhand(n))
     greenpeaks(pt,n+1);
    end %for
    a=get(temp(3),'ydata');
    a(pt(1,1)-tr1+1)=(ptimes(1,pt(1,1)-tr1+1)-1)*smp+t1;
    for n=3:5
     set(temp(n),'ydata',a)
    end %for

   case 'normal' %button 1 - remove pick from single trace
    if ptimes(2,pt(1,1)-tr1+1)~=0
      delete(ptimes(2:4,pt(1,1)-tr1+1))
      ptimes(2:4,pt(1,1)-tr1+1)=0;
    end %if
    ptimes(1,pt(1,1)-tr1+1)=0;
    a=get(temp(3),'ydata');
    a(pt(1,1)-tr1+1)=NaN;
    for n=3:5
     set(temp(n),'ydata',a)
    end %for
  end %switch but

 case 'motion1'
  newpt=get(gca,'currentpoint');
  xd=get(temp(1),'xdata');
  xd(2)=newpt(1,1);
  yd=get(temp(1),'ydata');
  yd(2)=newpt(1,2);
  set(temp(1),'xdata',xd,'ydata',yd);

 case 'down2'
  set(gcf,'windowbuttonmotionfcn','')
  set(gcf,'windowbuttondownfcn','picktimes3 down1;')
  down2pt=get(gca,'currentpoint');
  index=round((down2pt(1,2)-t1)./smp+1);
  down2pt=[round(down2pt(1,1)),down2pt(1,2),index];
  delete(temp(2))
  a=get(temp(1),'ydata');
  pt(1,2)=a(1,1);
  a=get(temp(1),'xdata');
  pt(1,1)=round(a(1,1));
  if pt(1,1)<down2pt(1,1)
    tr=pt(1,1):down2pt(1,1);
  else
    tr=down2pt(1,1):pt(1,1);
  end %if
  previous=find(ptimes(2,tr-tr1+1)~=0);
  if ~isempty(previous)
   previous=previous+tr(1)-tr1;
   delete(ptimes(2:4,previous))
   ptimes(2:4,previous)=0;
  end

  but=get(gcf,'SelectionType');
  switch but
   case {'normal','alt'} %button 1 or 3- clears picks on selected traces
    ptimes(:,tr-tr1+1)=0;
    a=get(temp(3),'ydata');
    a(tr-tr1+1)=NaN;
    for n=3:5
     set(temp(n),'ydata',a)
    end %for
   case 'extend' %button 2 - sets pick on selected traces
    killflg=get(findobj(gcf,'string','KILL'),'userdata');
    bad=find(killflg{1}(1,:)~=0);
    yi=interp1([pt(1,1) down2pt(1,1)],[pt(1,2) down2pt(1,2)],tr);
    if isempty(bad)
     for n=1:3
      set(gcf,'currentaxes',axhand(n))
      for i=1:length(tr)
       greenpeaks([tr(i),yi(i),round((yi(i)-t1)./smp)],n+1);
      end %for
     end %for
    else
     for n=1:3
      set(gcf,'currentaxes',axhand(n))
      for i=1:length(tr)
       h=find(bad==tr(i)-tr1+1);
       if isempty(h) %only plot peak if trace has not been killed
        greenpeaks([tr(i),yi(i),round((yi(i)-t1)./smp)],n+1);
       end %if
      end %for
     end %for
    end %if/else
    z=find(ptimes(1,:)==0);
    a=ptimes(1,:);
    a(z)=NaN;
    for n=3:5
     set(temp(3:5),'ydata',(a-1).*smp+t1)
    end %for
  end %switch but
  delete(temp(1)) %take off line
end %switch action
