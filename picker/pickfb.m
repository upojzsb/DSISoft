function pickfb(action)

%pickfb
%
%To use this module type 'pickfb' and a menu will appear.
%Graphic interface program for displaying 3 component data and picking interactively.
%Allows 3 component picking, tuning, rotation on the fly, zooming, and killing of traces.
%Flattening of traces is available for display only, as is rotation, but picking can
%be done while components are rotated.  Pick times will be stored in a header word of
%the user's choice.  Killed traces will be flagged in trace header word 6.  Pack_good
%must be used externally to remove or zero flagged traces.  To work with single component
%data, use 'pick1comp'.
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

%$Id: pickfb.m,v 3.0 2000/06/13 19:23:04 gilles Exp $
%$Log: pickfb.m,v $
%Revision 3.0  2000/06/13 19:23:04  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:47:41  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:27  kay
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
 pickmenu;
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
  if rec2~=3
   msgbox('This program only works with 3 component data.  Use SORTREC to sort into 3 components or else use PICK1COMP to pick only one component.','Warning','warn')
   set(findobj(gcbf,'string','PLOT'),'enable','off')
   return
  else
   set(findobj(gcbf,'string','PLOT'),'enable','on')
  end %if/else
  set(H,'userdata',handle);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 case 'plot'
  H=findobj('name','Picker Menu');
  handle=findobj(H,'Tag','PopMaxAve');
  maxav=abs(2-get(handle,'Value'));
  dataset=get(findobj(H,'Tag','EditText1'),'userdata');
  value=get(findobj(H,'tag','PopupMenu1'),'value'); %indicates scale
  window=str2num(get(findobj(H,'Tag','EditWind'),'String'));
  t1=str2num(get(findobj(H,'tag','EditT1'),'string'));
  switch value
   case 2
    dataset=agc(dataset,window,1);
   case 3
    dataset=ener(dataset,t1,t1+window);
  end %switch
  pltflg=0;
  scfact=1;
  G=findobj('Tag','pickfig');
  if isempty(G)
   pickplot;
   G=findobj('Tag','pickfig');
   ax(1)=findobj(G,'Tag','Axes1');
   ax(2)=findobj(G,'Tag','Axes2');
   ax(3)=findobj(G,'Tag','Axes3');
  else
   scfact=get(findobj(G,'tag','EditText1'),'userdata');
   if isempty(scfact)
    scfact=1;
   end %if
   data=get(G,'userdata');
   ax=data{5};
   if get(gcbo,'string')=='UNDO'
    global ptimes
    tr=find(ptimes(1,:)~=0);
    if ~isempty(tr)
     headwd=str2num(get(findobj(H,'tag','EditHead1'),'string'));
     tr1=str2num(get(findobj(H,'tag','EditTr1'),'string'));
     ntr=length(ptimes);
     dataset.th{1}(headwd,tr1:tr1+ntr-1)=0;
     dataset.th{1}(headwd,tr+tr1-1)=(ptimes(1,tr)-1).*dataset.fh{8}+t1;
    end %if isempty
   end %if UNDO
  end %if/else
  set(G,'userdata',{dataset;maxav;pltflg;scfact;ax});
  compplot(dataset,maxav,pltflg,scfact);
  datasetname=get(findobj(H,'Tag','EditText1'),'string');
  set(findobj(G,'Tag','Supertitle'),'string',datasetname)
  picktimes3;
  killint3('firstcall',dataset.th{1});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'quitall'
  handle=findobj('tag','pickfig');
  if ~isempty(handle)
   pickfb quit
   close(handle)
  else
   close all
  end %if/else

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'quit'
  global ptimes
  global temp
  killflg=get(findobj('string','KILL'),'userdata');
  bad=find(killflg{1}(1,:)~=0);
  ptimes(2,:)=0;
  if ~isempty(bad)
   ptimes(2,bad)=-1;
  end %if
  data=get(findobj('tag','pickfig'),'userdata');
  dataset=data{1};
  smp=dataset.fh{8};
  t1=str2num(get(findobj('tag','EditT1'),'string'));
  tr1=str2num(get(findobj('tag','EditTr1'),'string'));
  tr2=str2num(get(findobj('tag','EditTr2'),'string'));
  headwd=str2num(get(findobj('tag','EditHead1'),'string'));
  temp=[headwd tr1 tr2];
  tr=find(ptimes(1,:)~=0);
  if ~isempty(tr)
   ptimes(1,tr)=(ptimes(1,tr)-1)*smp+t1;
  end %if
  close(gcbf);
  pickquit;
  set(findobj(gcf,'style','edit'),'string',num2str(headwd))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'tune'
  handle=findobj(gcbf,'Tag','PopTune');
  option=get(handle,'Value'); %1 for peaks, 2 for troughs, 3 for zeros
  dir=str2num(get(findobj('tag','EditDir'),'string'));
  if dir~=1
   if option==1
    option=2;
   elseif option==2
    option=1;
   end %if/elseif
  end %if
  tune3comp(option)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'zoom'
  zoom on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'zoomall'
  limx=get(gca,'xlim');
  limy=get(gca,'ylim');
  G=findobj('Tag','pickfig');
  data=get(G,'userdata');
  axhand=data{5};
  set(axhand,'xlim',limx)
  set(axhand,'ylim',limy)
  zoom off
  set(findobj(gcf,'style','slider'),'enable','on')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'full'
  [rec1,rec2,tr1,tr2,t1,t2,dir]=getstrings;
  data=get(findobj('Tag','pickfig'),'userdata');
  axhand=data{5};
  set(axhand,'xlim',[tr1-1 tr2+1])
  set(axhand,'ylim',[t1 t2])
  set(findobj(gcf,'style','slider'),'enable','off')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'scale'
  global ptimes
  G=findobj(gcbf,'Tag','pickfig');
  data=get(G,'userdata');
  scfact_old=data{4};
  scfact=str2num(get(gcbo,'String'));
  data{4}=scfact;
  set(G,'userdata',data);
  axhand=data{5};
  child=get(axhand,'children');
  tr1=str2num(get(findobj('tag','EditTr1'),'String'));
  for n=1:length(child)
   L=flipud(findobj(child{n},'type','line'));
   P=flipud(findobj(child{n},'type','patch'));
   for i=1:length(ptimes)
    a=get(L(i),'xdata');
    k=i+tr1-1;
    set(L(i),'xdata',(a-k).*scfact./scfact_old+k)
    a=get(P(i),'xdata');
    set(P(i),'xdata',(a-k).*scfact./scfact_old+k)
    if ptimes(n+1,i)~=0
     a=get(ptimes(n+1,i),'xdata');
     set(ptimes(n+1,i),'xdata',(a-k).*scfact./scfact_old+k)
    end %if
   end %for
  end %for

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'menu'
  H=findobj('Name','Picker Menu');
  figure(H)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'pick'
  zoom off;
  set(gcf,'windowbuttondownfcn','picktimes3 down1;');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'clear'
  global ptimes
  global temp
  peaks=find(ptimes(1,:)~=0);
  if ~isempty(peaks)
   delete(ptimes(2:4,peaks))
   ptimes(:,:)=0;
  end %if
  a=ptimes(1,:);
  a(:)=NaN;
  for n=3:5
   set(temp(n),'ydata',a)
  end %for
  set(gcf,'windowbuttondownfcn','')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'kill'
  killint3 killbutton

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'flat'
  set(gcf,'windowbuttondownfcn','')
  global ptimes
  global temp
  data=get(gcf,'userdata');
  axhand=data{5};
  dataset=data{1};
  npts=dataset.fh{7};
  smp=dataset.fh{8};
  tr1=str2num(get(findobj('tag','EditTr1'),'string'));
  buff=50; %buffer time (pts)
  ntr=length(ptimes);

  child=get(axhand,'children');
  for n=1:3
   L{n}=flipud(findobj(child{n},'type','line'));
   P{n}=flipud(findobj(child{n},'type','patch'));
   set(L{n}(1:ntr),'erasemode','normal')
   set(P{n}(1:ntr),'erasemode','normal')
  end %for
  tr=find(ptimes(1,:)~=0);
  if isempty(tr)
   msgbox('No picks to flatten.', 'Warning' ,'warn')
   return;
  end %if
  ydata=get(temp(3),'ydata');

  if ptimes(1,tr(1))<0 %unflat
   set(findobj(gcf,'string','PICK'),'enable','on') %for pick,kill,clear,tune
   set(findobj(gcf,'string','TUNE'),'enable','on')
   set(findobj(gcf,'string','CLEAR'),'enable','on')
   set(findobj(gcf,'string','KILL'),'enable','on')
   set(findobj(gcf,'string','ROTATE'),'enable','on')
   set(findobj(gcf,'string','UNDO'),'enable','on')
   datamat=get(gcbo,'userdata');
   for n=1:3
    for i=tr
     set(L{n}(i),'xdata',datamat{n}.l{i})
     set(P{n}(i),'xdata',datamat{n}.p{i})
     if ptimes(n+1,i)~=0
      ypeak=get(ptimes(n+1,i),'ydata');
      ypeak=ypeak-(ptimes(1,i)+buff+1).*smp;
      set(ptimes(n+1,i),'ydata',ypeak)
     end %if
    end %for
   end %for
   ydata(tr)=ydata(tr)-(ptimes(1,tr)+buff+1).*smp;
  else %flat
   set(findobj(gcf,'string','PICK'),'enable','off') %for pick,kill,clear,tune
   set(findobj(gcf,'string','TUNE'),'enable','off')
   set(findobj(gcf,'string','CLEAR'),'enable','off')
   set(findobj(gcf,'string','KILL'),'enable','off')
   set(findobj(gcf,'string','ROTATE'),'enable','off')
   set(findobj(gcf,'string','UNDO'),'enable','off')
   for n=1:3
    datamat{n}.l=get(L{n}(1:ntr),'xdata');
    datamat{n}.p=get(P{n}(1:ntr),'xdata');
   end %for
   set(gcbo,'userdata',datamat)
   newtr=datamat{1}.l{1};
   row=length(newtr);
   newp=datamat{1}.p{1};
   for n=1:3
    for i=tr
     newtr(:)=i+tr1-1;
     newp(:)=i+tr1-1;
     xdtr=datamat{n}.l{i};
     xdp=datamat{n}.p{i};
     index=ptimes(1,i)-buff;
     newtr(1:row-index+1)=xdtr(index:row);
     newp(2:row-index+1)=xdp(index+1:row);
     set(L{n}(i),'xdata',newtr)
     set(P{n}(i),'xdata',newp)
     if ptimes(n+1,i)~=0
      ypeak=get(ptimes(n+1,i),'ydata');
      ypeak=ypeak-(index-1).*smp;
      set(ptimes(n+1,i),'ydata',ypeak)
     end %if
    end %for i
   end %for n
   ydata(tr)=ydata(tr)-(ptimes(1,tr)-buff-1).*smp;
  end %flat/unflat
  for n=3:5
   set(temp(n),'ydata',ydata)
  end %for
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
  data=get(gcf,'userdata');
  axhand=data{5};
  set(axhand,'xlim',newxlim)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'rotate'
  global ptimes
  data=get(gcf,'userdata');
  dataset=data{1};
  tr=find(ptimes(1,:)~=0);
  trz=find(ptimes(1,:)==0);

%if length(tr)<length(ptimes)
% msgbox('Rotate option does not know how to deal with unpicked traces or dead traces yet','Warning','warn')
% return;
%end %if

  smp=dataset.fh{8};
  headwd=str2num(get(findobj('tag','EditHead1'),'string'));
  t1=str2num(get(findobj('tag','EditT1'),'string'));
  tr1=str2num(get(findobj('tag','EditTr1'),'string'));
  dataset.th{1}(headwd,tr+tr1-1)=(ptimes(1,tr)-1).*smp+t1;
  dataset.th{1}(headwd,trz+tr1-1)=0;
  killflg=get(findobj('String','KILL'),'userdata');
  bad=find(killflg{1}(1,:)~=0);
  dataset.th{1}(6,:)=0;
  dataset.th{1}(6,bad)=-1;
  maxav=data{2};
  pltflg=data{3};
  scfact=get(findobj(gcf,'tag','EditText1'),'string');
  if isempty(scfact)
   scfact=1;
  else
   scfact=str2num(scfact);
  end %if/else
  radhand=flipud(findobj(gcf,'style','radiobutton'));
  val=zeros(1,3);
  for n=1:3
   val(n)=get(radhand(n),'value');
  end %for
  comp=find(val==1);
  if length(comp)~=2
   msgbox('Must choose two components to do rotation.', 'Warning' ,'warn')
   return;
  end %if
  [dataset]=rot3c_eig(dataset,headwd,0.01,comp(1),comp(2));
  c(1:3)='k';
  c(comp)='b';
  data{1}=dataset;
  set(gcf,'userdata',data)
  compplot(dataset,maxav,pltflg,scfact,c);
  picktimes3;
  killint3('firstcall',dataset.th{1});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'radiobutton'
  radhand=flipud(findobj(gcf,'style','radiobutton'));
  val=get(gcbo,'value');
  if val==1
   n=find(radhand~=gcbo);
   m1=get(radhand(n(1)),'value');
   m2=get(radhand(n(2)),'value');
   if (m1+m2)==2
    set(radhand(n(1)),'value',[0]);
   end %if
  end %if

end %switch


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [G]=compplot(dataset,maxav,pltflg,scfact,c)
  %c is colour
  if nargin==4
   c(1:3)='k';
  end %if
  [rec1,rec2,tr1,tr2,t1,t2,dir]=getstrings;
  G=findobj('Tag','pickfig');
  data=get(G,'userdata');
  axhand=data{5};
  if isempty(G)
    pickplot;
    G=findobj('Tag','pickfig');
  end
  figure(G)
  set(axhand,'nextplot','replace');
  if dir~=1 %plot traces backwards by switching tr1 and tr2 values
   a=tr1;
   tr1=tr2;
   tr2=a;
  end %if
  subplot(axhand(1))
  fact=seisplot(dataset.dat{1},t1,t2,tr1,tr2,dataset.fh{8},maxav,pltflg,scfact,c(1));
  hold on
  title('Component 1','fontsize',12,'fontunits','points');
  subplot(axhand(2))
  scfact=1;
  seisplot(dataset.dat{2},t1,t2,tr1,tr2,dataset.fh{8},fact,pltflg,scfact,c(2));
  hold on
  ylabel('');
  title('Component 2','fontsize',12,'fontunits','points');
  subplot(axhand(3))
  seisplot(dataset.dat{3},t1,t2,tr1,tr2,dataset.fh{8},fact,pltflg,scfact,c(3));
  hold on
  ylabel('');
  title('Component 3','fontsize',12,'fontunits','points');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [rec1,rec2,tr1,tr2,t1,t2,dir]=getstrings
 H=findobj('Name','Picker Menu');
 handle=get(H,'userdata');
 rec1=str2num(get(handle(1),'string'));
 rec2=str2num(get(handle(2),'string'));
 tr1=str2num(get(handle(3),'string'));
 tr2=str2num(get(handle(4),'string'));
 t1=str2num(get(handle(5),'string'));
 t2=str2num(get(handle(6),'string'));
 dir=str2num(get(handle(7),'string'));

