function aspec(action)
%function aspec
%
%Interactive module for displaying amplitude and phase versus frequency.
%
%DSIsoft version 2.0
%Customized VSP processing software
%
%written by G. Perron and K.S. Beaty January, 1998

%$Id: aspec.m,v 3.0 2000/06/13 19:17:48 gilles Exp $
%$Log: aspec.m,v $
%Revision 3.0  2000/06/13 19:17:48  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:40:42  mah
%Release 2
%
%Revision 1.4  1999/05/19 20:59:36  mah
%version number
%
%Revision 1.3  1999/01/15 15:23:14  perron
%Modified calls to seisplot to include new variable tstart
%
%Revision 1.2  1999/01/11 18:57:06  kay
%Fixed typo in Id.
%
%Revision 1.1  1999/01/06 19:06:59  kay
%Initial revision

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
 aspecplot
 return
end %if

switch action
case 'getdataset'
 datasetname=get(gcbo,'String');
 dataset=get(gcbo,'userdata');
 set(findobj(gcbf,'Tag','EditRec1'),'String','1');
 rec1=1;
 rec2=dataset.fh{12};
 set(findobj(gcbf,'Tag','EditRec2'),'String',num2str(rec2));
 tr1=1;
 set(findobj(gcbf,'Tag','EditTr1'),'String','1');
 tr2=dataset.th{1}(12,1);
 set(findobj(gcbf,'Tag','EditTr2'),'String',num2str(tr2));
 t1=dataset.fh{9};
 set(findobj(gcbf,'Tag','EditT1'),'String',num2str(t1));
 t2=dataset.fh{10};
 set(findobj(gcbf,'Tag','EditT2'),'String',num2str(t2));
 dir=1;
 set(findobj(gcbf,'Tag','EditDir'),'String','1');
 f1=0;
 set(findobj(gcbf,'Tag','EditF1'),'String',num2str(f1));
 f2=1/(2*dataset.fh{8}); %Nyquist frequency
 set(findobj(gcbf,'Tag','EditF2'),'String',num2str(f2));

case 'plot'
 h=findobj(gcf,'tag','EditText1');
 G=findobj('name','AspecPlot');
 if isempty(G)
  aspecp;
  a.axseis=findobj(gcf,'Tag','AxesSeis');
  a.axf=findobj(gcf,'Tag','Axes2');
  a.axp=findobj(gcf,'Tag','Axes3');
 else
  figure(G)
  a=get(G,'userdata');
 end %if/else
 set(gcf,'Pointer','watch');
 a.rec1=str2num(get(findobj(gcbf,'Tag','EditRec1'),'String'));
 a.rec2=str2num(get(findobj(gcbf,'Tag','EditRec2'),'String'));
 a.t1=str2num(get(findobj(gcbf,'Tag','EditT1'),'String'));
 a.t2=str2num(get(findobj(gcbf,'Tag','EditT2'),'String'));
 a.tr1=str2num(get(findobj(gcbf,'Tag','EditTr1'),'String'));
 a.tr2=str2num(get(findobj(gcbf,'Tag','EditTr2'),'String'));
 dir=str2num(get(findobj(gcbf,'Tag','EditDir'),'String'));
 if dir~=1
  temp=a.tr1;
  a.tr1=a.tr2;
  a.tr2=temp;
 end %if
 a.f1=str2num(get(findobj(gcbf,'Tag','EditF1'),'String'));
 a.f2=str2num(get(findobj(gcbf,'Tag','EditF2'),'String'));
 datasetname=get(h,'string');
 a.dataset=get(h,'userdata');
 a.scfact=1.5;
 a.maxav=1;
 a.pltflg=0;
 a.rec=a.rec1;
 a.smp=a.dataset.fh{8};
 a.c='k';
 set(gcf,'CurrentAxes',a.axseis);
 seisplot(a.dataset.dat{a.rec},a.t1,a.t2,a.tr1,a.tr2,a.smp,a.maxav,a.pltflg,a.scfact,a.c,a.dataset.fh{9});
 aspecomputem(a.dataset,a.tr1,a.tr2,a.t1,a.t2,a.rec,1);
 set(gcf,'Pointer','fullcross')
 set([a.axf;a.axp],'xlim',[a.f1 a.f2])
 set(gcf,'userdata',a)
 set(findobj(gcf,'tag','StaticText1'),'string',['Now showing record: ',num2str(a.rec)])
 set(findobj(gcf,'tag','TitleText'),'string',['Variable: ',datasetname],'fontsize',12)
 subplot(a.axp)
 b=axis;
 set(get(gca,'xlabel'),'userdata',b)
 subplot(a.axf)
 b=axis;
 set(get(gca,'xlabel'),'userdata',b)

case 'quitall'
 close all;

case 'skip'
 a=get(gcf,'userdata');
 a.rec=str2num(get(gcbo,'String'));
 if a.rec<a.rec1 | a.rec>a.rec2
  msgbox('Not a valid record number.','Warning','warn');
  return
 end %if
 set(gcf,'userdata',a)
 subplot(a.axseis)
 seisplot(a.dataset.dat{a.rec},a.t1,a.t2,a.tr1,a.tr2,a.smp,a.maxav,a.pltflg,a.scfact,a.c,a.dataset.fh{9});
 hdd=findobj(gcbf, 'Tag', 'StaticText1');
 set(hdd, 'String' ,['Now showing record: ',num2str(a.rec)]);
 aspecomputem(a.dataset,a.tr1,a.tr2,a.t1,a.t2,a.rec,1);

case 'scale'
 a=get(gcf,'userdata');
 a.scfact=str2num(get(gcbo,'String'));
 set(gcf,'userdata',a)
 subplot(a.axseis)
 seisplot(a.dataset.dat{a.rec},a.t1,a.t2,a.tr1,a.tr2,a.smp,a.maxav,a.pltflg,a.scfact,a.c,a.dataset.fh{9});

case 'zoom'
 zoom on
 set(gcf,'windowbuttonupfcn','aspec zoomoff')

case 'zoomoff'
 ones;
 zoom off
 a=get(gcf,'userdata');
 limx=get(gca,'xlim');
 if gca==a.axp
  ax=a.axf;
 elseif gca==a.axf
  ax=a.axp;
 else
  return
 end %if
 set(gcf,'currentaxes',ax)
% zoom off
 ylim=get(ax,'ylim');
% set(ax,'ylim',ylim)
 set(gcf,'windowbuttonupfcn','')

case 'full'
 a=get(gcf,'userdata');
 subplot(a.axseis)
 lim=[a.tr1-1 a.tr2+1 a.t1 a.t2];
 axis(lim)
 subplot(a.axf)
 lim=get(get(gca,'xlabel'),'userdata');
 axis(lim)
 subplot(a.axp)
 lim=get(get(gca,'xlabel'),'userdata');
 axis(lim)

case 'next'
 set(gcbf,'Pointer','watch');
 a=get(gcf,'userdata');
 if a.rec<a.rec2,
  a.rec=a.rec+1;
  set(gcf,'userdata',a);
  subplot(a.axseis)
  seisplot(a.dataset.dat{a.rec},a.t1,a.t2,a.tr1,a.tr2,a.smp,a.maxav,a.pltflg,a.scfact,a.c,a.dataset.fh{9});
  hdd=findobj(gcbf,'Tag','StaticText1');
  set(hdd,'String',['Now showing record: ',num2str(a.rec)]);
  aspecomputem(a.dataset,a.tr1,a.tr2,a.t1,a.t2,a.rec,1);
 else,
  msgbox('You have reach the EOF','Warning','warn')
 end
 set(gcbf,'Pointer','fullcross');

case 'previous'
set(gcbf,'Pointer','watch');
 a=get(gcf,'userdata');
 if a.rec>a.rec1,
  a.rec=a.rec-1;
  set(gcf,'userdata',a);
  subplot(a.axseis)
  seisplot(a.dataset.dat{a.rec},a.t1,a.t2,a.tr1,a.tr2,a.smp,a.maxav,a.pltflg,a.scfact,a.c,a.t1);
  hdd=findobj(gcbf,'Tag','StaticText1');
  set(hdd,'String',['Now showing record: ',num2str(a.rec)]);
  aspecomputem(a.dataset,a.tr1,a.tr2,a.t1,a.t2,a.rec,1);
 else,
  msgbox('You have reach the BOF','Warning','warn')
 end
 set(gcbf,'Pointer','fullcross');

case 'polarity'
 a=get(gcf,'userdata');
 set(gcf,'CurrentAxes',a.axseis);
 a.scfact=a.scfact*(-1);
 if a.scfact<0
  a.c='b';
 else
  a.c='k';
 end %if/else
 set(gcf,'userdata',a)
 seisplot(a.dataset.dat{a.rec},a.t1,a.t2,a.tr1,a.tr2,a.smp,a.maxav,a.pltflg,a.scfact,a.c,a.dataset.fh{9});

case 'quit'
 close(gcbf)

case 'menu'
 figure(findobj('Name','Aspecplot Menu'))

case 'crosshair'
 a=get(gcf,'userdata');
 v=get(gcbo,'value');
 if v==1
  acrss2(a.axf,a.axp,'begin')
 else
  acrss2(a.axf,a.axp,'done')
 end %if/else
end %switch
