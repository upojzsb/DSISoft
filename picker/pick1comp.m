function pick1comp(action)

%pick1comp
%Interactive module for picking first breaks on a single component or record.
%Has options for picking, killing traces, clear, zoom, and flat.
%Flat is for display only.  Killed traces are flagged in header word 6 if 'save'
%is chosen on exiting the program.  Pick times can be stored in a trace header
%word of the user's choice.  The default is word 15.
%
%picking is done as follows:
%	first mouse button: clears a single trace pick
%	second mouse button: selects a single trace pick
%	third mouse button: starts dragging a line
%	  followed by 1st or 3d button: erases picks on all selected traces
%	  followed by 2nd button: picks times on all selected traces
%
%DSI customized processing software
%written by K.S. Beaty February, 1998

%$Id: pick1comp.m,v 3.0 2000/06/13 19:22:50 gilles Exp $
%$Log: pick1comp.m,v $
%Revision 3.0  2000/06/13 19:22:50  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:47:13  mah
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

if ~nargin
 pick1compmenu;
 return;
end %if

switch action
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'getdataset'
  dataset=get(gcbo,'userdata');
  H=findobj(gcbf,'Name','Picker Menu');
  handle(1)=findobj(H,'Tag','EditRec1');
  set(handle(1),'String','1');
  handle(2)=findobj(H,'Tag','EditRec2');
  rec2=dataset.fh{12};
  set(handle(2),'String',num2str(rec2));
  handle(3)=findobj(H,'Tag','EditTr1');
  tr1=1;
  set(handle(3),'String','1');
  handle(4)=findobj(H,'Tag','EditTr2');
  tr2=dataset.th{1}(12,1);
  set(handle(4),'String',num2str(tr2));
  handle(5)=findobj(H,'Tag','EditT1');
  t1=dataset.fh{9};
  set(handle(5),'String',num2str(t1));
  handle(6)=findobj(H,'Tag','EditT2');
  t2=dataset.fh{10};
  set(handle(6),'String',num2str(t2));
  handle(7)=findobj(H,'Tag','EditDir');
  dir=1;
  set(handle(7),'String','1');
  set(H,'userdata',handle);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'plot'
  handle=findobj(gcbf,'Tag','PopMaxAve');
  maxav=abs(2-get(handle,'Value'));
  H=findobj('name','Picker Menu');
  dataset=get(findobj(H,'Tag','EditText1'),'userdata');
  value=get(findobj(H,'tag','PopupMenu1'),'value'); %indicates scale
  window=str2num(get(findobj(H,'Tag','EditWind'),'String'));
  switch value
   case 2
    dataset=agc(dataset,window,1);
   case 3
    dataset=ener(dataset,0,window);
  end
  pltflg=0;
  scfact=1;
  G=findobj('Tag','pick1fig');
  if isempty(G)
    pick1compplot;
    G=findobj('Tag','pick1fig');
  else
   figure(G)
   hold off
   clear global temp
   clear global ptimes
  end
  set(G,'userdata',{dataset;maxav;pltflg;scfact});
  [rec1,rec2,tr1,tr2,t1,t2,dir]=getstrings;
  if dir~=1 %plot traces backwards by switching tr1 and tr2 values
   a=tr1;
   tr1=tr2;
   tr2=a;
  end %if
  seisplot(dataset.dat{rec1},t1,t2,tr1,tr2,dataset.fh{8},maxav,pltflg,scfact);
  picktimes2;
  killint('firstcall',dataset.th{rec1});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'quitall'
  handle=findobj('tag','pick1fig');
  if ~isempty(handle)
   pick1comp quit
   close(handle)
  else
   close all
  end %if
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'quit'
  global temp
  handle=findobj('tag','pick1fig');
  data=get(handle,'userdata');
  axhand=findobj(handle,'type','axes');
  killflg=get(axhand,'userdata');
  rec=get(findobj('tag','EditRec1'),'string');
  tr1=get(findobj('tag','EditTr1'),'string');
  tr2=get(findobj('tag','EditTr2'),'string');
  temp(1)=str2num(rec);
  temp(2)=str2num(tr1);
  temp(3)=str2num(tr2);
  global ptimes
  dataset=data{1};
  smp=dataset.fh{8};
  t1=str2num(get(findobj('tag','EditT1'),'string'));
  tr=find(ptimes(1,:)~=0);
  ptimes(1,tr)=(ptimes(1,tr)-1)*smp+t1;
  badtr=find(killflg(1,:)~=0);
  if ~isempty(badtr)
   ptimes(3,badtr)=-1; %dead trace flags
  end %if
  headwd=str2num(get(findobj('tag','EditHead1'),'string'));
  close(gcbf)
  pick1quit;
  set(findobj(gcf,'style','edit'),'string',num2str(headwd));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'tune'
  handle=findobj('Tag','PopTune');
  option=get(handle,'Value'); %1 for peaks, 2 for troughs, 3 for zeros
  dir=str2num(get(findobj('tag','EditDir'),'string'));
  if dir~=1
   if option==1
    option=2;
   elseif option==2
    option=1;
   end %if/elseif
  end %if
  tune1comp(option)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'zoom'
  zoom on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'zoomall'
  zoom off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'full'
  zoom out;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 case 'scale'
  global ptimes
  G=findobj(gcbf,'Tag','pick1fig');
  data=get(G,'userdata');
  scfact_old=data{4};
  scfact=str2num(get(gcbo,'String'));
  data{4}=scfact;
  set(G,'userdata',data);
  child=get(gca,'children');
  L=flipud(findobj(child,'type','line'));
  P=flipud(findobj(child,'type','patch'));
  tr1=str2num(get(findobj('tag','EditTr1'),'string'));
  for i=1:length(ptimes)
   k=i+tr1-1;
   a=get(L(i),'xdata');
   set(L(i),'xdata',(a-k).*scfact./scfact_old+k)
   a=get(P(i),'xdata');
   set(P(i),'xdata',(a-k).*scfact./scfact_old+k)
   if ptimes(2,i)~=0
    a=get(ptimes(2,i),'xdata');
    set(ptimes(2,i),'xdata',(a-k).*scfact./scfact_old+k)
   end %if
  end %for

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'menu'
  H=findobj('Name','Picker Menu');
 % H=1;
  figure(H)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'pick'
  zoom off;
  set(gcf,'windowbuttondownfcn','picktimes2 down1;');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'clear'
  global ptimes
  global temp
  peaks=find(ptimes(2,:)~=0);
  if ~isempty(peaks)
   delete(ptimes(2,peaks))
   ptimes(:,:)=0;
  end %if
  a=ptimes(1,:);
  a(:)=NaN;
  set(temp(3),'ydata',a)
  set(gcf,'windowbuttondownfcn','')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'kill'
  killint killbutton

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'flat'
  set(gcf,'windowbuttondownfcn','')
  global ptimes
  global temp
  data=get(gcf,'userdata');
  dataset=data{1};
  npts=dataset.fh{7};
  smp=dataset.fh{8};
  buff=50; %buffer time (pts)
  ntr=length(ptimes);
  tr1=str2num(get(findobj('tag','EditTr1'),'string'));
  rec=str2num(get(findobj('tag','EditRec1'),'string'));

  child=get(gca,'children');
  L=flipud(findobj(child,'type','line'));
  P=flipud(findobj(child,'type','patch'));
  set(L(1:ntr),'erasemode','normal')
  set(P(1:ntr),'erasemode','normal')
  tr=find(ptimes(1,:)~=0);
  if isempty(tr)
   msgbox('No picks to flatten.', 'Warning' ,'warn')
   return;
  end %if
  ydata=get(temp(3),'ydata');

  if ptimes(1,tr(1))<0 %unflat
   set(findobj(gcf,'string','PICK'),'enable','on') %for pick and clear and tune
   set(findobj(gcf,'string','TUNE'),'enable','on')
   set(findobj(gcf,'string','CLEAR'),'enable','on')
   set(findobj(gcf,'string','KILL'),'enable','on')
   datamat=get(gcbo,'userdata');
   for i=tr
    set(L(i),'xdata',datamat.l{i})
    set(P(i),'xdata',datamat.p{i})
    if ptimes(2,i)~=0
     ypeak=get(ptimes(2,i),'ydata');
     ypeak=ypeak-(ptimes(1,i)+buff+1).*smp;
     set(ptimes(2,i),'ydata',ypeak)
    end %if
   end %for
   ydata(tr)=ydata(tr)-(ptimes(1,tr)+buff+1).*smp;
  else %flat
   set(findobj(gcf,'string','PICK'),'enable','off') %for pick and clear and tune
   set(findobj(gcf,'string','TUNE'),'enable','off')
   set(findobj(gcf,'string','CLEAR'),'enable','off')
   set(findobj(gcf,'string','KILL'),'enable','off')
   datamat.l=get(L(1:ntr),'xdata');
   datamat.p=get(P(1:ntr),'xdata');
   set(gcbo,'userdata',datamat)
   newtr=datamat.l{1};
   row=length(newtr);
   newp=datamat.p{1};

   for i=tr
    newtr(:)=i+tr1-1;
    newp(:)=i+tr1-1;
    xdtr=datamat.l{i};
    xdp=datamat.p{i};
    index=ptimes(1,i)-buff;
    newtr(1:row-index+1)=xdtr(index:row);
    newp(2:row-index+1)=xdp(index+1:row);
    set(L(i),'xdata',newtr)
    set(P(i),'xdata',newp)
    if ptimes(2,i)~=0
     ypeak=get(ptimes(2,i),'ydata');
     ypeak=ypeak-(index-1).*smp;
     set(ptimes(2,i),'ydata',ypeak)
    end %if
   end %for
   ydata(tr)=ydata(tr)-(ptimes(1,tr)-buff-1).*smp;
  end %flat/unflat
  set(temp(3),'ydata',ydata)
  ptimes(1,:)=ptimes(1,:).*(-1); %multiply by -1 to mark whether flat or unflat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'slider'
 zoom off
 xlim=get(gca,'xlim');
 realxlim=get(get(gca,'ZLabel'),'UserData');
 value=get(gcbo,'value');
 dxreal=realxlim(2)-realxlim(1);
 dx=xlim(2)-xlim(1);
 newxlim=zeros(1,2);
 newxlim(1)=value*(dxreal-dx);
 newxlim(2)=newxlim(1)+dx;
 set(gca,'xlim',newxlim)
end %switch


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [rec1,rec2,tr1,tr2,t1,t2,dir]=getstrings
 H=findobj('Name','Picker Menu');
% H=1;
 handle=get(H,'userdata');
 rec1=str2num(get(handle(1),'string'));
 rec2=str2num(get(handle(2),'string'));
 tr1=str2num(get(handle(3),'string'));
 tr2=str2num(get(handle(4),'string'));
 t1=str2num(get(handle(5),'string'));
 t2=str2num(get(handle(6),'string'));
 dir=str2num(get(handle(7),'string'));
