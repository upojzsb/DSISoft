function fkpoly(action)

%fkpoly
%
%Interactive module used to pick a polygone for fk filtering.  The option is now
%available to view results of filtering using user selected polygon within the
%module.  For processing data, polygon is usually picked in the program then
%passed to the 'fkfilt' processing module from a processing script.
%
%INPUT
%input parameters should be specified in the menu of this module.
%Data should be in DSI format.
%Max. Freq. is the maximum frequency to be examined in the data
%dx is the spacing between traces
%the 'polygone' input parameter is optional.  It allows visualization of
%polygones that have been saved previously
%
%OUTPUT
%x,y coordinates of the corners of filter polygone; give name at prompt
%
%There are buttons on the display screen for zoom, full (zooming out),
%menu (brings menu screen to the front), quit (exits program, prompts for
%name of variable in which to save picked polygon), pick (initiates picking
%of a new polygone.  Pick with left mouse button, use right button to close
%polygon) and clear (clears existing polygon from screen).  There are four
%radio buttons that control the display.  'FK' displays the fk spectrum and
%allows picking, 'unfiltered' displays the unfiltered data, 'pass' displays
%the data with a pass filter applied and 'reject' does the same except the
%contents of the polygone is rejected.
%
%note - requires files fkfig3, fkquit, fkmenu, pickfk, and fkfilt
%
%
%DSI customized VSP processing software
%developed by G. Perron and K.S. Beaty

%$Id: fkpoly.m,v 3.0 2000/06/13 19:19:28 gilles Exp $
%$Log: fkpoly.m,v $
%Revision 3.0  2000/06/13 19:19:28  gilles
%Release 3
%
%Revision 2.1  2000/06/13 19:08:12  gilles
%fix return with Matlab 5
%
%Revision 2.0  1999/05/21 18:44:52  mah
%Release 2
%
%Revision 1.2  1999/05/19 17:06:16  perron
%*** empty log message ***
%
%Revision 1.1  1999/01/06 19:08:49  kay
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

if nargin==0
   fkmenu;
   return
end %if

switch action
case 'getdataset'
   dataset=get(gcbo,'userdata');
   set(findobj(gcf,'Tag','EditRec1'),'String','1')
   rec2=dataset.fh{12};
   set(findobj(gcf,'Tag','EditRec2'),'String',num2str(rec2))
   int=dataset.fh{8};
   fn=1/(2*int); %Nyquist frequency
   m=dataset.fh{7}; %number of points per trace
   freq=round(fn-fn*2/(2^nextpow2(m))); %highest frequency to be plotted
   set(findobj(gcf,'Tag','EditFreq'),'String',num2str(freq))
   dx=dataset.th{1}(56,2)-dataset.th{1}(56,1); %distance between traces
   set(findobj(gcf,'Tag','EditDx'),'String',num2str(dx))

case 'plot'
   clear global fktemp
   H=findobj('Name','F-K Filter Menu');
   datain=get(findobj(H,'Tag','EditText1'),'userdata');
   rec=str2num(get(findobj(H,'Tag','EditRec1'),'String'));
   freq=str2num(get(findobj(H,'Tag','EditFreq'),'String'));
   dx=get(findobj(H,'Tag','EditDx'),'String');
   polycoord=get(findobj(H,'Tag','EditPolyname'),'Userdata');
   if isempty(dx)
      msgbox('Check all fields and try again.','Warning','warn');
      return
   end %if
   dx=str2num(dx);
   if rec>datain.fh{12}
      msgbox(['This dataset only has ',num2str(datain.fh{12}),' records.  Try again.','Warning','warn']);
      return
   end %if

  int=datain.fh{8}; %sampling interval (s)
  datain=datain.dat{rec};

  %----------finding nextpow2-------------
  [m,n]=size(datain);
  m2=2^nextpow2(m);
  n2=2^nextpow2(n);
  fkdata=fft2(datain,m2,n2);
  fkdata=fftshift(fkdata);
  kn=1/(2*dx); %Nyquist wavenumber
  fn=1/(2*int); %Nyquist frequency
  a.x=[-kn+kn*2/n2:kn*2/n2:kn];
  a.y=[0:2*fn/m2:freq];

  %-------------picking polygon-------------
  G=findobj('Name','Pick fk-polygon');
  if isempty(G)
   fkfig3;
  else
   figure(G);
  end %if
  %imagesc(x,y,abs(fkdata(m2/2-length(y):m2/2+1,:)))
  a.z=abs(fkdata(m2/2+1:m2/2+length(a.y),:));
  imagesc(a.x,a.y,a.z)
  set(gca,'ydir','normal')
  xlabel('Wavenumber (m^-^1)')
  ylabel('Frequency (Hz)')

  set(gcf,'userdata',a)

  if ~isempty(polycoord)
     global fktemp
     hold on
     fktemp=line(polycoord(:,1),polycoord(:,2),'erasemode','normal');
     set(fktemp,'color','r','linewidth',[2])
     hold off
  end %if
case 'menu'
   H=findobj('Name','F-K Filter Menu');
   figure(H)

case 'quitall'
   nfig=findobj('type','figure');
   if length(nfig)==1
      close all
      return
   end %if
   close(findobj(nfig,'Name','Pick fk-polygon'))
   fkpoly quit;

case 'quit'
   global fktemp
  polyname=get(findobj(findobj('name','F-K Filter Menu'), 'tag','EditPolyname'),'string');
  close(gcbf)
  fkquit
  set(findobj(gcf,'tag','EditText1'),'String',polyname)
  clear global fktemp

case 'pick'
   rads=findobj(gcf,'style','radiobutton');
   set(rads,'userdata','')
   pick_fk;

case 'clear'
   global fktemp
   delete(fktemp)
   clear global fktemp
   set(gcf,'windowbuttonmotionfcn','')

case {'FK','unfiltered','pass','reject'}
   set(gcf,'pointer','watch')
   rads=findobj(gcf,'style','radiobutton');
   set(rads,'value',0)
   set(gcbo,'value',1)
   a=get(gcf,'userdata');
   global fktemp
   if ~isnan(fktemp)
      a.xpoly=get(fktemp,'xdata');
      a.ypoly=get(fktemp,'ydata');
      set(gcf,'userdata',a)
   end %if
   if strcmp(action,'FK')
      imagesc(a.x,a.y,a.z)
      xlabel('Wavenumber (m^-^1)')
      ylabel('Frequency (Hz)')
      set(gca,'ydir','normal')
      hold on
      fktemp=line(a.xpoly,a.ypoly,'erasemode','normal');
      set(fktemp,'color','r','linewidth',[2])
      hold off
      set(findobj(gcf,'string','Pick'),'enable','on')
      set(findobj(gcf,'string','Clear'),'enable','on')
   else
     if isempty(fktemp)
         msgbox('Pick a polygon before attempting to filter','Warning','warn')
         fkpoly FK;
         set(gcf,'pointer','fullcross')
         return;
      end %if no polygon has been picked
      fktemp=NaN;
      H=findobj('Name','F-K Filter Menu');
      data=get(findobj(H,'Tag','EditText1'),'userdata');
      c='k';
      rec=str2num(get(findobj(H,'Tag','EditRec1'),'String'));
      if ~strcmp(action,'unfiltered')
         temp=get(gcbo,'userdata');
         c='b';
         if isempty(temp) %ie filtering has not yet been performed
            taper=10;
            freq=str2num(get(findobj(H,'Tag','EditFreq'),'String'));
            dx=str2num(get(findobj(H,'Tag','EditDx'),'String'));
            poly=[a.xpoly' a.ypoly'];
            if strcmp(action,'pass')
               filtflg=0;
            else
               filtflg=1;
            end %if pass
            data=fkfilt(data,poly,freq,taper,filtflg,dx,rec);
disp('allo')
            set(gcbo,'userdata',data)
         else
            data=temp;
         end %if isempty(temp)
      end %if not unfiltered
      set(findobj(gcf,'string','Pick'),'enable','off')
      set(findobj(gcf,'string','Clear'),'enable','off')
        seisplot(data.dat{rec},data.fh{9},data.fh{10},1,data.th{rec}(12,1),data.fh{8},1,0,1.5,c,data.fh{9});

   end %if
   set(gcf,'pointer','fullcross')
end %switch
