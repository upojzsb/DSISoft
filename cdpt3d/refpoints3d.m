function [cdp]= refpoints3d(s,r,t,dip,strike,v)
  
% refpoints3d: function to calculate the coord of 
% reflection points on a plane reflector. The event was recorded
% at time t. We assume a medium with constant velocity v, given
% a source at s=[sx;sy;sz] and receiver at r=[rx;ry;rz], 
% with a reflection from a plane with given dip and strike
%  
% INPUT: s = [sx; sy; sz], source position
%        r = [rx; ry; rz], receiver position
%        t = time at which the relctions is observed
%            t can be a vector  
%        v = velocity of medium (constant)
%        dip = dip of plane (horizontal -> dip=0 (degrees)
%              dip is on the right hand side of strike direction 
%        strike = strike of plane (clockwise from N in degrees)
%  
% OUTPUT: cdp=[cdpx; cdpy; cdpz].
% 
% DSI customized VSP processing software
% by G Bellefleur (May 2000)
% Some lines modified from txplane.m by Ian Kay

%$Id: refpoints3d.m,v 3.0 2000/06/13 19:18:04 gilles Exp $
%$Log: refpoints3d.m,v $
%Revision 3.0  2000/06/13 19:18:04  gilles
%*** empty log message ***
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

  disp('[dataout]= refpoints3d(s,r,t,dip,strike,v)')
  
  dipaz=(strike+90)*pi/180;
% calculation are made with angle from the vertical  
  dip=(90-dip)*pi/180;
  strike=strike*pi/180;

% Vector between the Receiver and the Source
% and length of this vector

  vec_sr=r-s;
  l_sr=sqrt(dot(s-r,s-r));

% Calculate vector along dip direction

  dx  = sin(dipaz)*sin(dip);
  dy  = cos(dipaz)*sin(dip);       
  dz = cos(dip);
  ampd = sqrt(dx*dx+dy*dy+dz*dz);
  
% Calculate vector along strike direction

  sx  = sin(strike);
  sy  = cos(strike);
  sz  = 0.0;          
  amps = sqrt(sx*sx+sy*sy+sz*sz);   
      
% Calculate normal (unit vector) to plane 
% from cross product: dip ^ strike

  a = dy*sz - dz*sy;
  b = dz*sx - dx*sz;
  c = dx*sy - dy*sx;
  ampn = sqrt(a*a+b*b+c*c);
  n=[a/ampn; b/ampn; c/ampn];

%n=[sin(dip)*cos(strike);sin(dip)*sin(strike);cos(dip)]; 
  
  
% Angle between vec_sr and n (n is a unit vector)
theta=acos(dot(n,vec_sr)/l_sr)*180/pi;

% total length of the travel path
l=t*v; 
  
% Some basic triangle properties
% 
%   a       b       c
% ----- = ----- = -----
% sin A   sin B   sin C

% first get C (c_ang)
% we have a (l), A (theta), and c (l_sr)

c_ang=asin(l_sr*sin(theta*pi/180)./l)*180/pi;

% get B (b_ang)
b_ang=180-(c_ang+theta);

% Finally get b the distance between the source 
% and its image
b= sin(b_ang*pi/180).*l/sin(theta*pi/180);

% x is an arbitrary point on the reflector
% located at b/2 dist unit from S along a path define
% by n 
% (x=s+n*b/2;)
x1=s(1)+(1*n(1)*b/2);
x2=s(2)+(1*n(2)*b/2);
x3=s(3)+(1*n(3)*b/2);
x=[x1;x2;x3];

% Projection of the vector x (O => x) on n
% p=dot(n,x);
nn(1,1:length(b))=n(1);
nn(2,1:length(b))=n(2);
nn(3,1:length(b))=n(3);
p=dot(nn,x);

% determine the coord of the receiver image
% rimage = r+2*n*(p - dot(n,r) );
rimage1 = r(1)+2*n(1).*(p - dot(n,r) );
rimage2 = r(2)+2*n(2).*(p - dot(n,r) );
rimage3 = r(3)+2*n(3).*(p - dot(n,r) );
rimage=[rimage1;rimage2;rimage3];

% determine the coord of the reflection points
% cdp=s+(p-dot(n,s))/(dot(n,rimage)-dot(n,s))*(rimage-s);
cdp1=s(1)+(p-dot(n,s))./(dot(nn,rimage)-dot(n,s)).*(rimage(1,:)-s(1));
cdp2=s(2)+(p-dot(n,s))./(dot(nn,rimage)-dot(n,s)).*(rimage(2,:)-s(2));
cdp3=s(3)+(p-dot(n,s))./(dot(nn,rimage)-dot(n,s)).*(rimage(3,:)-s(3));
cdp=[cdp1;cdp2;cdp3];

% Another way to get coord of cdp
% This part is not vectorized 
% get coord of image of source
% b unit from s along n
% is=s+n*b;

% get distance from Is to plane in the Receiver direction
% d_is2p=(b/2)/cos(c_ang*pi/180);

%get image source-receiver vector
% is_r=r-is;

%d_is_r=sqrt(is_r(1)^2+is_r(2)^2+is_r(3)^2);
%is_r(1)=is_r(1)/d_is_r;
%is_r(2)=is_r(2)/d_is_r;
%is_r(3)=is_r(3)/d_is_r;
%ncdp=is+is_r*d_is2p;
