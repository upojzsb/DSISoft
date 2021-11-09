function [t]=txdirect(s,r,v)

% txdirect: function to calculate the traveltime in a medium with constant 
% velocity v, given a source at s=[sx;sy;sz] and receiver at r=[rx;ry,rz].
% INPUT: s, r, v
% OUTPUT: travel time.
%DSI customized VSP processing software
%by I. Kay (April 1999)
 
%$Id: txdirect.m,v 3.0 2000/06/13 19:22:28 gilles Exp $
%$Log: txdirect.m,v $
%Revision 3.0  2000/06/13 19:22:28  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:56  mah
%Release 2
%
%Revision 1.1  1999/04/15 16:42:18  kay
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


l=sqrt(dot ( (s-r),(s-r) ) );
t=l/v;
