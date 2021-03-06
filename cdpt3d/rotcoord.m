function [u,v]=rotcoord(x,y,angle,pivx,pivy)
%
%function [u,v]=rotcoord(x,y,angle,pivx,pivy)
%
%[u,v]=rotcoord(x,y,angle,pivx,pivy)
%[u,v]=rotcoord(x,y,angle)
%
%this function will rotate coordinate system by a given angle (in degrees) 
%around a pivot and return values for the point in the new co-ordinate system
%
%INPUT
%x - x coordinate of point in original system or a vector of x coordinates
%y - y coordinate corresponding to the same point in the roginal system
%    y is a vector of points corresponding to x if x is a vector
%angle - angle of rotation in degrees
%pivx - x coordinate of pivot point (or vector of points, one for each x)
%pivy - y coordinate of pivot point (or vector of points, one for each y)
%
%pivx and pivy are both zero if not specified
%
%OUTPUT
%u - new x coordinate(s) after rotation
%v - new y coordinate(s) after rotation
%
%DSISoft Version 1.0
%Customized VSP Processing Software
%written by K.S. Beaty July 1998
%last modified July 21, 1998

w=pi./180;
if nargin==3 %set default to rotate around origin
 pivx=0;
 pivy=0;
end %if

if angle~=0 & angle~=360 
 u=(x(:)-pivx(:)).*cos(angle.*w)-(y(:)-pivy(:)).*sin(angle.*w)+pivx(:); %rotation of x
 v=(x(:)-pivx(:)).*sin(angle.*w)+(y(:)-pivy(:)).*cos(angle.*w)+pivy(:); %rotation of y
else %rotation not necessary
 u=x;
 v=y;
end %if/else
