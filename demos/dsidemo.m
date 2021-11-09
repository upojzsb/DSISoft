function fig = dsidemo()
% This is the machine-generated representation of a Handle Graphics object
% and its children.  Note that handle values may change when these objects
% are re-created. This may cause problems with any callbacks written to
% depend on the value of the handle at the time the object was saved.
%
% To reopen this object, just type the name of the M-file at the MATLAB
% prompt. The M-file and its associated MAT-file must be on your path.

%$Id: dsidemo.m,v 3.0 2000/06/13 19:18:11 gilles Exp $
%$Log: dsidemo.m,v $
%Revision 3.0  2000/06/13 19:18:11  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:41:31  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:07:58  kay
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

load dsidemo

h0 = figure('Units','normalized', ...
	'Color',[0.8 0.8 0.8], ...
	'Colormap',mat0, ...
	'HandleVisibility','off', ...
	'Name','DSISoft Demo', ...
	'NumberTitle','off', ...
	'Position',[0.822048611111111 0.26 0.1605902777777778 0.6488888888888888], ...
	'Tag','Fig1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontSize',14, ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[0.04864864864864865 0.8784246575342465 0.8864864864864865 0.07191780821917808], ...
	'String','DSISoft Version 1.0 Demo', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.701960784313725 0.701960784313725 0.701960784313725], ...
	'Callback','demoproc', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[0.1297297297297297 0.6763698630136986 0.7243243243243244 0.0702054794520548], ...
	'String','Process Dataset', ...
	'Tag','Pushbutton2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'Callback','eval(get(gcbo,''string''));', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',mat1, ...
	'String','plothd', ...
	'Tag','Pushbutton2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'Callback','eval(get(gcbo,''string''));', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',mat2, ...
	'String','pickfb', ...
	'Tag','Pushbutton2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'Callback','eval(get(gcbo,''string''));', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',mat3, ...
	'String','pick1comp', ...
	'Tag','Pushbutton2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'Callback','eval(get(gcbo,''string''));', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',mat4, ...
	'String','fkpoly', ...
	'Tag','Pushbutton2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'Callback','eval(get(gcbo,''string''));', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',mat5, ...
	'String','dispseis', ...
	'Tag','Pushbutton2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.701960784313725 0.701960784313725 0.701960784313725], ...
	'Callback','eval(get(gcbo,''string''));', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',mat6, ...
	'String','aspec', ...
	'Tag','Pushbutton2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.701960784313725 0.701960784313725 0.701960784313725], ...
	'Callback','close(''all'',''hidden'');clear', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[0.2810810810810811 0.04623287671232876 0.4216216216216216 0.06678082191780821], ...
	'String','QUIT', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.701960784313725 0.701960784313725 0.701960784313725], ...
	'Callback','load nm_bal;disp(''load nm_bal'');', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[0.1297297297297297 0.7671232876712328 0.7243243243243244 0.0702054794520548], ...
	'String','Load Dataset', ...
	'Tag','Pushbutton2');
if nargout > 0, fig = h0; end
