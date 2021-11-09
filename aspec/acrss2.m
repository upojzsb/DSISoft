function acrss2(axf,axp,action)

%acrss2(axf,axp,action)
%Works with ASPEC but could work with any figure containing plots of
%both frequency and phase spectums on separate axes.
%Use by typing 'acrss2(axf,axp,'begin')'.
%
%INPUT
%axf => handle of axes containing single frequency spectrum.
%axp => handle of axes containing single phase spectrum
%
%DSI customized processing software
%written by K. S. Beaty March, 1998

%$Id: acrss2.m,v 3.0 2000/06/13 19:17:45 gilles Exp $
%$Log: acrss2.m,v $
%Revision 3.0  2000/06/13 19:17:45  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:40:40  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:06:59  kay
%Initial revision
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

global crsshand

switch action
 case 'begin'
  wbdf=sprintf('acrss2(%24.20f,%24.20f,''track'')',axf,axp);
  set(gcf,'windowbuttondownfcn',wbdf);
  box=uicontrol('Style','edit','Units','Normalized',...
		'Position',[.01 .01 .5 .045],...
		'String',' ',...
		'Tag','CrossHairText',...
		'BackGroundColor',[0 .7 .7]);
  limx=get(axp,'xlim');
  limyp=get(axp,'ylim');
  limyf=get(axf,'ylim');
  subplot(axf)
  hold on
  crsshand(6)=plot([NaN],[NaN],'ro','erasemode','xor');
  crsshand(4)=line(limx,[NaN NaN],'color','r','erasemode','xor');
  crsshand(3)=line([NaN NaN],limyf,'color','r','erasemode','xor');
  hold off
  subplot(axp)
  hold on
  crsshand(2)=line(limx,[NaN NaN],'color','r','erasemode','xor');
  crsshand(1)=line([NaN NaN],limyp,'color','r','erasemode','xor');
  crsshand(5)=plot([NaN],[NaN],'ro','erasemode','xor');
  hold off

 case 'track'
  acrss2(axf,axp,'motion')
  wbmf=sprintf('acrss2(%24.20f,%24.20f,''motion'')',axf,axp);
  set(gcf,'windowbuttonmotionfcn',wbmf)
  wbuf=sprintf('acrss2(%24.20f,%24.20f,''up'')',axf,axp);
  set(gcf,'windowbuttonupfcn',wbuf)

 case 'motion'
  box=findobj(gcf,'Tag','CrossHairText');
  if gca~=axf & gca~=axp
   return
  end %if
  pt=get(gca,'currentpoint');
  f=pt(1,1);
  fspec=flipud(get(axf,'children'));
  pspec=flipud(get(axp,'children'));
  xf=get(fspec(1),'xdata');
  yf=get(fspec(1),'ydata');
  xp=get(pspec(1),'xdata');
  yp=get(pspec(1),'ydata');
  amp=interp1(xf,yf,f);
  p=interp1(xp,yp,f);
  boxstr=['Frequency: ',num2str(f), '  Amplitude: ',num2str(amp),' Phase: ',num2str(p)];
  set(box,'String',boxstr);
  set(crsshand([1 3]),'xdata',[f f])
  set(crsshand(2),'ydata',[p p])
  set(crsshand(4),'ydata',[amp amp])
  set(crsshand([5 6]),'xdata',f)
  set(crsshand(5),'ydata',p)
  set(crsshand(6),'ydata',amp)

 case 'up'
  set(gcf,'windowbuttonmotionfcn','')
  set(gcf,'windowbuttonupfcn','')

 case 'done'
  box=findobj(gcf,'Tag','CrossHairText');
  delete(box)
  set(gcf,'windowbuttondownfcn','')
  delete(crsshand)
  clear global crsshand

end %switch
