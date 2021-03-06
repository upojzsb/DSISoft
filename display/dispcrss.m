function dispcrss(action)

%function dispcrss
%-called by 'dispseis' as a callback function under 'plot' callback
%-used to display mouse position on GUI
%
%The command 'dispcrss on' turns on pointer tracking.
%
%DSI customized processing software
%written by K.S. Beaty

%$Id: dispcrss.m,v 3.0 2000/06/13 19:19:02 gilles Exp $
%$Log: dispcrss.m,v $
%Revision 3.0  2000/06/13 19:19:02  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:43:32  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:08:34  kay
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

switch action
 case 'on'
  set(gcf,'windowbuttondownfcn','dispcrss down;')
  set(gcf,'windowbuttonupfcn','set(gcf,''windowbuttonmotionfcn'','''');')
  set(gcf,'pointer','fullcross');

 case 'down'
  dispcrss track;
  set(gcf,'windowbuttonmotionfcn','dispcrss track;');

 case 'track'
  xhrposition=get(gca,'currentpoint');
  xhrposition=xhrposition(1,1:2);
  xhrposition(1,1)=round(xhrposition(1,1));
  handle=findobj(gcf,'Tag','crosshairbox');
  set(handle,'String',['trace: ',num2str(xhrposition(1,1)), '  time: ',num2str(xhrposition(1,2))]);

end %switch
