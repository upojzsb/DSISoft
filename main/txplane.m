function [t]=txplane(s,r,x,dip,strike,v)

% txplane: function to calculate the traveltime in a medium with constant 
% velocity v, given a source at s=[sx;sy;sz] and receiver at r=[rx;ry;rz], 
% with a reflection from a plane with given dip and strike, passing through
% the point x=[x;y;z].
% INPUT: s = [sx; sy; sz], source position
%        r = [rx; ry; rz], receiver position
%        x = [x; y; z], a point on the plane
%        v = velocity of medium (constant)
%        dip = dip of plane (horizontal -> dip=0 (degrees)
%        strike = strike of plane (clockwise from N in degrees)
% OUTPUT: travel time.
% Note, reflection point position is calculated but not yet returned.
%DSI customized VSP processing software
%by I. Kay (April 1999)
 
%$Id: txplane.m,v 3.0 2000/06/13 19:22:31 gilles Exp $
%$Log: txplane.m,v $
%Revision 3.0  2000/06/13 19:22:31  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:57  mah
%Release 2
%
%Revision 1.2  1999/04/15 19:51:03  kay
%fixed definition of strike...
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

dip=dip*pi/180;
strike=strike*pi/180;
n=[sin(dip)*cos(strike);
   sin(dip)*sin(strike);
   cos(dip)]; 
p=dot(n,x);

rimage = r+2*(p - dot(n,r) )*n;
l=sqrt(dot( (s-rimage), (s-rimage)));
t=l/v;
%cdp=s+ (p-dot(n,s))/(dot(n,rimage)-dot(n,s))*(rimage-s);
