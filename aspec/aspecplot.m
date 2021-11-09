function fig = aspecplot()
% This is the machine-generated representation of a Handle Graphics object
% and its children.  Note that handle values may change when these objects
% are re-created. This may cause problems with any callbacks written to
% depend on the value of the handle at the time the object was saved.
%
% To reopen this object, just type the name of the M-file at the MATLAB
% prompt. The M-file and its associated MAT-file must be on your path.

%$Id: aspecplot.m,v 3.0 2000/06/13 19:17:56 gilles Exp $
%$Log: aspecplot.m,v $
%Revision 3.0  2000/06/13 19:17:56  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:40:54  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:06:59  kay
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

load aspecplot

h0 = figure('Color',[0.8 0.8 0.8], ...
	'Colormap',mat0, ...
	'MenuBar','none', ...
	'Name','Aspecplot Menu', ...
	'NumberTitle','off', ...
	'Position',[34 28 259 281], ...
	'Tag','Fig1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.370656 0.704626 0.200772 0.0747331], ...
	'Style','edit', ...
	'Tag','EditRec1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','set(gcbo,''userdata'',eval(get(gcbo,''string'')));aspec getdataset', ...
	'ListboxTop',0, ...
	'Position',[0.370656 0.825722 0.513514 0.08185050000000001], ...
	'Style','edit', ...
	'Tag','EditText1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.100386 0.825722 0.158301 0.0533808], ...
	'String','Datafile', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.370656 0.58363 0.200772 0.07829179999999999], ...
	'Style','edit', ...
	'Tag','EditTr1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.6833979999999999 0.58363 0.204633 0.07829179999999999], ...
	'Style','edit', ...
	'Tag','EditTr2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.6833979999999999 0.704626 0.204633 0.0747331], ...
	'Style','edit', ...
	'Tag','EditRec2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.370656 0.338078 0.200772 0.07829179999999999], ...
	'Style','edit', ...
	'Tag','EditDir');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.6833979999999999 0.459075 0.204633 0.08185050000000001], ...
	'Style','edit', ...
	'Tag','EditT2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.374517 0.459075 0.200772 0.08185050000000001], ...
	'Style','edit', ...
	'Tag','EditT1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.0888031 0.5886710000000001 0.227799 0.0498221], ...
	'String','From Trace', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.0617761 0.345196 0.227799 0.0533808], ...
	'String','Direction', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.0617761 0.7089760000000001 0.262548 0.0533808], ...
	'String','From Record', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.0810811 0.466192 0.204633 0.0462633], ...
	'String','From Time', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.7019609999999999 0.7019609999999999 0.7019609999999999], ...
	'Callback','aspec plot', ...
	'ListboxTop',0, ...
	'Position',[0.367102 0.0431911 0.204327 0.0719851], ...
	'String','PLOT', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'Callback','aspec quitall', ...
	'ListboxTop',0, ...
	'Position',[0.675982 0.0431911 0.204327 0.0719851], ...
	'String','QUIT', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.5752895752895753 0.7117437722419928 0.08494208494208494 0.04626334519572953], ...
	'String','to', ...
	'Style','text', ...
	'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.5752895752895753 0.5907473309608541 0.08494208494208494 0.0498220640569395], ...
	'String','to', ...
	'Style','text', ...
	'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.5830115830115831 0.4661921708185053 0.07722007722007722 0.04626334519572953], ...
	'String','to', ...
	'Style','text', ...
	'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[0.015444 0.22119 0.351351 0.0498221], ...
	'String','From Frequency', ...
	'Style','text', ...
	'Tag','StaticText10');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.6833979999999999 0.220641 0.196911 0.07829179999999999], ...
	'Style','edit', ...
	'Tag','EditF2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[0.370656 0.217082 0.200772 0.07829179999999999], ...
	'Style','edit', ...
	'Tag','EditF1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',mat1, ...
	'String','to', ...
	'Style','text', ...
	'Tag','StaticText2');
if nargout > 0, fig = h0; end