function pick_fk(action)

%pick_fk
%
%works with 'fkpoly' for picking polygons for fk filtering.
%
%DSI Customised VSP Processing Software
%written by K.S. Beaty

%$Id: pick_fk.m,v 3.0 2000/06/13 19:19:34 gilles Exp $
%$Log: pick_fk.m,v $
%Revision 3.0  2000/06/13 19:19:34  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:44:59  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:08:50  kay
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

global fktemp
if nargin==0
 if exist('fktemp','var')
  delete(fktemp)
 end %if
 hold on
 set(gcf,'windowbuttondownfcn','pick_fk down1;')
 set(gcf,'pointer','fullcross')
 return
end %if
switch action
 case 'down1'
  pt=get(gca,'currentpoint');
  xd=zeros(1,20);
  xd(:)=NaN;
  yd=xd;
  xd(1:2)=pt(1,1);
  yd(1:2)=pt(1,2);
  fktemp=line('xdata',xd,'ydata',yd,'erasemode','xor');
  set(fktemp,'color','r','linewidth',[2])
  but=get(gcf,'selectiontype');
  if ~strcmp(but,'normal')
   msgbox('Please pick with left button on mouse.','Warning','warn')
   return
  end %if
  set(gcf,'windowbuttonmotionfcn','pick_fk motion;')
  set(gcf,'windowbuttondownfcn','pick_fk down2;')

 case 'down2'
  pt=get(gca,'currentpoint');
  xd=get(fktemp,'xdata');
  yd=get(fktemp,'ydata');
  but=get(gcf,'selectiontype');
  n=length(find(~isnan(xd)));
  switch but
   case 'normal'
    xd(n+1)=pt(1,1);
    yd(n+1)=pt(1,2);
    set(fktemp,'xdata',xd)
    set(fktemp,'ydata',yd)
   case {'alt' ,'extend'}
    set(gcf,'windowbuttonmotionfcn','')
    xd(n+1)=xd(1);
    yd(n+1)=yd(1);
    set(fktemp,'xdata',xd)
    set(fktemp,'ydata',yd)
    global poly
    poly(1:n+1,2)=yd(1:n+1)';
    poly(1:n+1,1)=xd(1:n+1)';
    hold off
    set(fktemp,'erasemode','normal')
    set(gcf,'windowbuttondownfcn','')
  end %switch but

 case 'motion'
  xd=get(fktemp,'xdata');
  yd=get(fktemp,'ydata');
  pt=get(gca,'currentpoint');
  n=length(find(~isnan(xd)));
  xd(n)=pt(1,1);
  yd(n)=pt(1,2);
  set(fktemp,'xdata',xd)
  set(fktemp,'ydata',yd)
end %switch action
