function plothd(action)

%plothd
%
%Interactive module for plotting the contents of trace headers of DSI variables.
%
%DSI customized processing software
%written by G. Perron February, 1998

%$Id: plothd.m,v 3.0 2000/06/13 19:23:28 gilles Exp $
%$Log: plothd.m,v $
%Revision 3.0  2000/06/13 19:23:28  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:48:08  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:42  kay
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

global rec1 rec2
if ~nargin
 dispph;
 return;
end %if

 switch action
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'getdataset'
  dataset=get(gcbo,'userdata');
  H=findobj(gcbf,'Name','Plot headers Menu');
  handleH(1)=findobj(H,'Tag','EditRec1');
  set(handleH(1),'String','1');
  rec1=1;
  handleH(2)=findobj(H,'Tag','EditRec2');
  rec2=dataset.fh{12};
  set(handleH(2),'String',num2str(rec2));
  set(H,'userdata',handleH);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

case 'next'
   H=findobj(gcbf,'name','Plot headers Menu');
   G=findobj('Tag','Fig1');
   data=get(findobj(H,'tag','EditText1'),'userdata');
   if isempty(G)
      plothead;
      G=findobj('Tag','Fig1');
   else
      figure(G)
   end %if
   rec1=str2num(get(findobj(H,'Tag','EditRec1'),'string'));
   hdd=findobj(G,'Tag','StaticText2');
   set(hdd,'String',['Now showing record: ',num2str(rec1),'']);
   set(G,'userdata',data);
   plothd 'plot2d'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'grid'
   value=get(gcbo,'Value');
   if value==1,
      grid on
   elseif value==0,
      grid off
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'hold'
   value=get(gcbo,'Value');
   if value==1,
      hold on
   elseif value==0,
      hold off
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'rot3d'
h2d3d=get(findobj(gcbf,'Tag','PopupMenu1'),'Value');
if h2d3d==1
   value=get(gcbo,'Value');
   if value==1,
      rotate3d on
   elseif value==0,
      rotate3d off
      view(2)
   end
elseif h2d3d==2
   value=get(gcbo,'Value');
   if value==1,
      rotate3d on
   elseif value==0,
      rotate3d off
      view(3)
   end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'reverse'
h2d3d=get(findobj(gcbf,'Tag','PopupMenu1'),'Value');
if h2d3d==1
   value=get(gcbo,'Value');
   if value==1,
      set(gca,'YDir','reverse');
   elseif value==0,
      set(gca,'YDir','normal');
   end
elseif h2d3d==2
   value=get(gcbo,'Value');
   if value==1,
      set(gca,'ZDir','reverse');
   elseif value==0,
      set(gca,'ZDir','normal');
   end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'plot'
   G=findobj(gcbf,'tag','Fig1');
   data=get(G,'userdata');
   h1=findobj(gcbf,'tag','PopupMenu1');
   h2=findobj(gcbf,'tag','PopupMenu2');
   h3=findobj(gcbf,'tag','PopupMenu3');
   h4=findobj(gcbf,'tag','PopupMenu4');
   h5=findobj(gcbf,'tag','PopupMenu5');
   h6=findobj(gcbf,'tag','PopupMenu6');
   d1=findobj(gcbf,'tag','Listbox1');
   d2=findobj(gcbf,'tag','Listbox2');
   d3=findobj(gcbf,'tag','Listbox3');
   vd1=get(d1,'Value');
   strd1=get(d1,'String');
   vd2=get(d2,'Value');
   strd2=get(d2,'String');
   vd3=get(d3,'Value');
   strd3=get(d3,'String');
   vp2=get(h2,'Value');
   pstr=get(h2,'String');
   vp3=get(h3,'Value');
   pstr3=get(h3,'String');
   vcol=get(h4,'Value');
   col=get(h4,'String');
   vlin=get(h5,'Value');
   lin=get(h5,'String');
   vsy=get(h6,'Value');
   sy=get(h6,'String');
   plt(1)=col{vcol};
   plt(2)=lin{vlin};
   plt(3)=sy{vsy};

   if get(h1,'Value')==1,
      eval([pstr{vp2},'(data.th{rec1}(vd1,:),data.th{rec1}(vd2,:),plt)']);
      eval(['xlabel(strd1{vd1})']);
      eval(['ylabel(strd2{vd2})']);
   else
      eval([pstr3{vp3},'(data.th{rec1}(vd1,:),data.th{rec1}(vd2,:),data.th{rec1}(vd3,:),plt)']);
      eval(['xlabel(strd1{vd1})']);
      eval(['ylabel(strd2{vd2})']);
      eval(['zlabel(strd3{vd3})']);
   end
   if get(findobj(gcf,'string','reverse Y-ZDir'),'value')==1
      set(gca,'ydir','reverse')
      set(gca,'zdir','reverse')
   end %if
   if get(findobj(gcf,'string','grid on'),'value')==1
      grid on
   end %if

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

case 'plot2d'
   h2=findobj(gcbf,'tag','PopupMenu2');
   h3=findobj(gcbf,'tag','PopupMenu3');
   d3=findobj(gcbf,'tag','Listbox3');
   val=get(gcbo,'Value');
   if val==1,
     set(h2,'enable','on');
     set(h3,'enable','off');
     set(d3,'enable','off');
   elseif val==2,
     set(h2,'enable','off');
     set(h3,'enable','on');
     set(d3,'enable','on');
   end
   set(findobj(gcf,'string','hold on'),'value',0)
   hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'ff'
   if rec1<rec2,
      rec1=rec1+1;
      hdd=findobj(gcbf,'Tag','StaticText2');
     set(hdd,'String',['Now showing record: ',num2str(rec1),'']);
   else,
     msgbox('You have reach the EOF','Warning','warn')
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'rev'
   if rec1>1,
      rec1=rec1-1;
      hdd=findobj(gcbf, 'Tag', 'StaticText2');
      set(hdd, 'String', ['Now showing record: ',num2str(rec1),'']);
   else,
      msgbox('You have reach the BOF', 'Warning' ,'warn') ;
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 case 'quitall'
  close all
  clear global

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'quit'
  close(gcbf);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'zoom'
  zoom on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'full'
    zoom out
    zoom off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 case 'menu'
  H=findobj('Name','Plot headers Menu');
  figure(H)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end %switch
