function dispseis(action)

%dispseis
%
%GUI interface program for displaying seismic data in DSI format.
%DISPSEIS calls up a menu for loading a dataset and selecting plotting
%parameters.  There are options for plotting with energy balancing or agc
%scaling.  Display options include wtva, va, wt, and grayscale.  Polarity
%reversal and zoom are available and mouse position can be tracked by
%pressing down the mouse button within the plot window.
%
%DISPSEIS can also be used to display seismic attributes data.  Seismic
%attribute (SA) data is stored in a DSI format variable with file header
%word 4 set to 1 as a flag.  There are normally either 3 (single
%component) or 9 (for 3 component data) records in a SA variable.
%Each component of the initial dataset has 3 records set aside for
%instantaneous amplitude, frequency, and phase information in that order.
%
%DSI customised processing software
%written by K.S. Beaty January, 1998

%$Id: dispseis.m,v 3.0 2000/06/13 19:19:11 gilles Exp $
%$Log: dispseis.m,v $
%Revision 3.0  2000/06/13 19:19:11  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:43:56  mah
%Release 2
%
%Revision 1.3  1999/01/26 17:20:55  mah
%num2str was truncating the value for t2 as a string.  The string when read back
%in then was the wrong value, the array size was calculated incorrectly and all hell
%broke loose.
%
%Revision 1.2  1999/01/14 21:19:27  perron
%Modifying calls to seisplot and seisatrplot to include new tstart variable
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

if ~nargin
 dispmenu
 return;
end %if

switch action
 case 'getdataset'
  %the callback for 'Datafile' section of menu contains the line
  %of code 'set(gcbo,'userdata',eval(get(gcbo,'string')))'
  %followed by 'dispseis getdataset'
  dataset=get(gcbo,'userdata');
  H=findobj(gcbf,'Name','Display Menu');
  set(findobj(H,'Tag','EditRec1'),'String','1');
  rec1=1;
  rec2=dataset.fh{12};
  set(findobj(H,'Tag','EditRec2'),'String',num2str(rec2));
  tr1=1;
  set(findobj(H,'Tag','EditTr1'),'String','1');
  tr2=dataset.th{1}(12,1);
  set(findobj(H,'Tag','EditTr2'),'String',num2str(tr2));
  t1=dataset.fh{9};
  set(findobj(H,'Tag','EditT1'),'String',num2str(t1));
  t2=dataset.fh{10};
  set(findobj(H,'Tag','EditT2'),'String',num2str(t2,10));
  a.dir=1;
  set(findobj(H,'Tag','EditDir'),'String','1');
  if isempty(dataset.fh{4})
   dataset.fh{4}=0; %seismic data flag
   set(gcbo,'userdata',dataset)
  end %if
  if dataset.fh{4}==1 %flag for seismic attributes data
   set(findobj(gcf,'tag','PopMaxAve'),'enable','off')
   set(findobj(gcf,'tag','PopupMenu1'),'enable','off')
  else
   set(findobj(gcf,'tag','PopMaxAve'),'enable','on')
   set(findobj(gcf,'tag','PopupMenu1'),'enable','on')
  end %if/else

 case 'plot'
  H=findobj('Name','Display Menu');
  a.rec1=str2num(get(findobj(H,'Tag','EditRec1'),'String'));
  a.rec=a.rec1;
  a.rec2=str2num(get(findobj(H,'Tag','EditRec2'),'String'));
  a.tr1=str2num(get(findobj(H,'Tag','EditTr1'),'String'));
  a.tr2=str2num(get(findobj(H,'Tag','EditTr2'),'String'));
  a.t1=str2num(get(findobj(H,'Tag','EditT1'),'String'));
  a.t2=str2num(get(findobj(H,'Tag','EditT2'),'String'));
  dir=str2num(get(findobj(H,'Tag','EditDir'),'String'));
  if dir~=1 %switch tr1 and tr2 so that traces plot in other direction
   temp=a.tr1;
   a.tr1=a.tr2;
   a.tr2=temp;
  end %if
  handle=findobj(gcbf,'Tag','EditText1');
  dataset=get(handle,'userdata');
  datasetname=get(handle,'string');
  a.tstart=dataset.fh{9}; %start time in seconds
  a.maxav=abs(2-get(findobj(gcbf,'Tag','PopMaxAve'),'Value'));
  a.pltflg=0;
  a.scfact=1;
  G=findobj('Name','Display');
  if isempty(G),
   displayl
   G=findobj('Name','Display');
  else
   figure(G)
   a.scfact=str2num(get(findobj('tag','EditScfact'),'string'));
  end %if/else
  hdd=findobj(G,'Tag','StaticText1');
  set(hdd,'String',['Now showing record: ',num2str(a.rec)]);
  set(findobj(G,'tag','TitleText'),'string',datasetname)
  value=get(findobj(H,'tag','PopupMenu1'),'Value');
  window=str2num(get(findobj(H,'Tag','EditWind'),'String'));
  switch value
   case 2
    dataset=agc(dataset,window,1);
   case 3
    dataset=ener(dataset,0,window);
  end %switch value
  a.smp=dataset.fh{8};
  a.dataset=dataset;
  a.c='k';
  set(findobj(G,'tag','PopupMenu1'),'value',1)

  if dataset.fh{4}~=1 %treat as seismic data
   seisplot(dataset.dat{a.rec},a.t1,a.t2,a.tr1,a.tr2,a.smp,a.maxav,a.pltflg,a.scfact,a.c,a.tstart);
   set(findobj(G,'tag','Pushdark'),'enable','off');
   set(findobj(G,'tag','Pushbright'),'enable','off');
   newstr={'wtva';'va';'wt';'grayscale'};
   set(findobj(G,'tag','EditScfact'),'enable','on')
   set(findobj(G,'string','POLARITY'),'enable','on')
  else %treat as seismic attribute (SA) data
   a.cmap='gray';
   seisatrplot(dataset.dat{a.rec},a.rec,a.t1,a.t2,a.tr1,a.tr2,a.smp,a.cmap);
   set(findobj(G,'tag','Pushdark'),'enable','on');
   set(findobj(G,'tag','Pushbright'),'enable','on');
   newstr={'gray';'hsv';'jet'};
   set(findobj(G,'tag','EditScfact'),'enable','off')
   set(findobj(G,'string','POLARITY'),'enable','off')
  end %if
  set(findobj(G,'Tag','PopupMenu1'),'String',newstr)
  dispcrss on; %turn on pointer tracking
  set(G,'userdata',a) %put all necessary data and parameters in G's userdata

 case 'zoom'
  zoom on

 case 'full'
  zoom out
  zoom off

 case 'displayoption'
  a=get(gcf,'userdata');
  a.pltflg=get(gcbo,'Value')-1;
  if ~a.dataset.fh{4}==1 %seismic data
   if a.pltflg==3,
    set(findobj(gcbf,'tag','Pushdark'),'enable','on');
    set(findobj(gcbf,'tag','Pushbright'),'enable','on');
   else,
    set(findobj(gcbf,'tag','Pushdark'),'enable','off');
    set(findobj(gcbf,'tag','Pushbright'),'enable','off');
   end %if/else
  else %seismic attributes data
   str=get(gcbo,'string');
   a.cmap=str{a.pltflg+1};
  end %if/else
  set(gcf,'userdata',a)
  updateplot(a)

 case 'scale'
  a=get(gcf,'userdata');
  a.scfact=str2num(get(gcbo,'String'));
  set(gcf,'userdata',a)
  updateplot(a)

 case 'skip'
  a=get(gcf,'userdata');
  rec=str2num(get(gcbo,'String'));
  if rec<a.rec1 | rec>a.rec2
   msgbox('Not a valid record number.','Warning','warn');
   set(gcbo,'string','')
   return;
  elseif isempty(rec)
   return;
  end %if
  a.rec=rec;
  set(gcf,'userdata',a)
  updateplot(a)
  hdd=findobj(gcbf, 'Tag', 'StaticText1');
  set(hdd, 'String' ,['Now showing record: ',num2str(rec),'']);

 case 'next'
  a=get(gcf,'userdata');
  if a.rec<a.rec2,
   a.rec=a.rec+1;
   set(gcf,'userdata',a)
   updateplot(a)
   hdd=findobj(gcbf,'Tag','StaticText1');
   set(hdd,'String',['Now showing record: ',num2str(a.rec),'']);
  else,
   msgbox('You have reach the EOF','Warning','warn')
  end %if/else

 case 'previous'
  a=get(gcf,'userdata');
  if a.rec>a.rec1,
   a.rec=a.rec-1;
   set(gcf,'userdata',a)
   updateplot(a)
   hdd=findobj(gcbf,'Tag','StaticText1');
   set(hdd,'String',['Now showing record: ',num2str(a.rec),'']);
  else,
   msgbox('You have reach the BOF', 'Warning' ,'warn') ;
  end %if/else

 case 'menu'
  H=findobj('Name','Display Menu');
  figure(H)

 case 'quit'
  close(gcbf)

 case 'quitall'
  close all;

 case 'polarity'
  a=get(gcf,'userdata');
  a.scfact=-a.scfact;
  if a.scfact<0,
   a.c='b';
  else,
   a.c='k';
  end %if/else
  set(gcf,'userdata',a)
  updateplot(a)
end %switch

function updateplot(a)
  if ~a.dataset.fh{4}==1 %seismic data
   seisplot(a.dataset.dat{a.rec},a.t1,a.t2,a.tr1,a.tr2,a.smp,a.maxav,a.pltflg,a.scfact,a.c,a.tstart);
  else %SA data
   seisatrplot(a.dataset.dat{a.rec},a.rec,a.t1,a.t2,a.tr1,a.tr2,a.smp,a.cmap,a.tstart);
  end %if
