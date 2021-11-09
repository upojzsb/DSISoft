function fig = pickmenu()
% This is the machine-generated representation of a Handle Graphics object
% and its children.  Note that handle values may change when these objects
% are re-created. This may cause problems with any callbacks written to
% depend on the value of the handle at the time the object was saved.
%
% To reopen this object, just type the name of the M-file at the MATLAB
% prompt. The M-file and its associated MAT-file must be on your path.

%$Id: pickmenu.m,v 3.0 2000/06/13 19:23:06 gilles Exp $
%$Log: pickmenu.m,v $
%Revision 3.0  2000/06/13 19:23:06  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:47:42  mah
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

load pickmenu

h0 = figure('Units','centimeters', ...
	'Color',[0.8 0.8 0.8], ...
	'Colormap',mat0, ...
	'MenuBar','none', ...
	'Name','Picker Menu', ...
	'NumberTitle','off', ...
	'Position',mat1, ...
	'Tag','pickmenu');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[2.92625 7.94267 1.61242 0.597193], ...
	'Style','edit', ...
	'Tag','EditRec1');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[1 1 1], ...
	'Callback',mat2, ...
	'ListboxTop',0, ...
	'Position',[2.92625 8.89817 4.06091 0.627053], ...
	'Style','edit', ...
	'Tag','EditText1');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.507614 8.92803 1.22425 0.388175], ...
	'String','Datafile', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[2.92625 6.9573 1.58256 0.627053], ...
	'Style','edit', ...
	'Tag','EditTr1');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[5.37474 6.9573 1.61242 0.627053], ...
	'Style','edit', ...
	'Tag','EditTr2');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[5.37474 7.94267 1.61242 0.597193], ...
	'Style','edit', ...
	'Tag','EditRec2');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[2.92625 4.98656 1.58256 0.597193], ...
	'Style','edit', ...
	'Tag','EditDir');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[5.37474 5.94207 1.61242 0.627053], ...
	'Style','edit', ...
	'Tag','EditT2');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[2.92625 5.94207 1.58256 0.627053], ...
	'Style','edit', ...
	'Tag','EditT1');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.4777543529411765 7.046876705882353 1.791578823529412 0.3881754117647059], ...
	'String','From Trace', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.3881754117647059 5.016420705882353 1.642280588235294 0.3583157647058823], ...
	'String','Direction', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.4478947058823529 8.002385411764706 2.060315647058824 0.4180350588235294], ...
	'String','From Record', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.5374736470588235 6.00178905882353 1.582561294117647 0.3881754117647059], ...
	'String','From Time', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'Callback','pickfb plot;', ...
	'ListboxTop',0, ...
	'Position',[2.98596 0.627053 1.61242 0.537474], ...
	'String','PLOT', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[0.7019609999999999 0.7019609999999999 0.7019609999999999], ...
	'Callback','pickfb quitall;', ...
	'ListboxTop',0, ...
	'Position',[5.37474 0.627053 1.61242 0.567333], ...
	'String','QUIT', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[4.628245294117647 7.972525764705882 0.6569122352941177 0.4180350588235294], ...
	'String','to', ...
	'Style','text', ...
	'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[4.628245294117647 6.987157411764706 0.5374736470588235 0.3881754117647059], ...
	'String','to', ...
	'Style','text', ...
	'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[4.628245294117647 5.971929411764706 0.5374736470588235 0.3583157647058823], ...
	'String','to', ...
	'Style','text', ...
	'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.6270525882352941 2.866526117647059 1.343684117647059 0.4180350588235294], ...
	'String','Scaling', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[0.7019609999999999 0.7019609999999999 0.7019609999999999], ...
	'ListboxTop',0, ...
	'Max',3, ...
	'Min',1, ...
	'Position',[2.29919 2.77695 1.82144 0.627053], ...
	'String',mat3, ...
	'Style','popupmenu', ...
	'Tag','PopupMenu1', ...
	'Value',1);
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[6.21081 2.74709 1.58256 0.597193], ...
	'String','0.2', ...
	'Style','edit', ...
	'Tag','EditWind');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[4.658104941176471 2.776947176470588 1.463122705882353 0.4180350588235294], ...
	'String','Window', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[0.7019609999999999 0.7019609999999999 0.7019609999999999], ...
	'ListboxTop',0, ...
	'Max',2, ...
	'Min',1, ...
	'Position',[2.32905 1.79158 1.82144 0.627053], ...
	'String',mat4, ...
	'Style','popupmenu', ...
	'Tag','PopMaxAve', ...
	'Value',1);
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[4.68796 4.06091 1.58256 0.627053], ...
	'String','15', ...
	'Style','edit', ...
	'Tag','EditHead1');
h1 = uicontrol('Parent',h0, ...
	'Units','centimeters', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.268737 4.15049 4.06091 0.388175], ...
	'String','Pick Times Header Word', ...
	'Style','text', ...
	'Tag','StaticText1');
if nargout > 0, fig = h0; end