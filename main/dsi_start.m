%DSI_start -> should be called at the beginning of DSI processing script file
%-has no input or output parameters
%-displays some information about the software package
%-starts a timer to time the processing sequence
%
%DSI customized VSP processing software
%written by Kristen Beaty October, 1997

%$Id: dsi_start.m,v 3.0 2000/06/13 19:20:07 gilles Exp $
%$Log: dsi_start.m,v $
%Revision 3.0  2000/06/13 19:20:07  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:30  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:02  kay
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

function dsi_start
global START_TIME;
START_TIME=clock;
disp('****************************************************************');
disp('DSI Customized Vertical Seismic Profile Processing Software');
disp('Version 1');
disp('designed to work on MATLAB5');
disp('');
disp('Copyright (C) 1998 Seismology and Electromagnetic Section/');
disp('Continental Geosciences Division/Geological Survey of Canada');
disp('Free software licensed under the GNU Library General Public License');
disp(date);
disp('****************************************************************');
