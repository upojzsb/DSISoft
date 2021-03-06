function [xyzfile]=dad2xyz_new(dadfile,conv_flg,plot_flg)

% [xyzfile]=dad2xyz_new(dadfile,conv_flg,plot_flg)
%
% this program converts depth, azimuth, dip to x,y,z
% x is easting
% y is northing
% z is depth i.e. positive down
% dad file should be formated as follows
% [easting of collar, northing of collar, collar shift]
% [depth, azimuth(degrees), dip(degrees)];
% [ ... etc ...];
% remember collar shift is collar elevation - datum elevation
% conv_flg is 0 for metres
% conv_flg is 1 for feet
% plot_flg is 1 for a plot of the borehole path

%$Id: dad2xyz_new.m,v 3.0 2000/06/13 19:20:01 gilles Exp $
%$Log: dad2xyz_new.m,v $
%Revision 3.0  2000/06/13 19:20:01  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:25  mah
%Release 2
%
%Revision 1.2  1999/05/17 15:06:37  mah
%fixed up help message
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
 
disp('[xyzfile]=dad2xyz_new(dadfile,conv_flg,plot_flg)')

[dadfilelength,a]=size(dadfile);

%first line of input file = collar coordinates

easting = dadfile(1,1); % sets the easting
northing = dadfile(1,2); % sets the northing
shift = -dadfile(1,3); % sets the shift

xyzfile=[0, 0, 0]; % initializes the output variable

% the following loop converts the wireline depth, azimuth, dip to x,y,z
% uses the dip and azimuth from the previous level for the current level
for COUNT=2:dadfilelength-1
 deltadepth=dadfile(COUNT+1,1)-dadfile(COUNT,1); %calculates the change in wireline depth
 dip=-dadfile(COUNT,3)*pi/180; %calculates the dip 
 deltaz=deltadepth*sin(dip); %calculate the change in z
 r=deltadepth*cos(dip); % calculates the radius

 theta=dadfile(COUNT,2)*pi/180; %calculates theta
 deltax=r*sin(theta); %calculates the change in x
 deltay=r*cos(theta); %calculates the change in y

 % current x = previous x + change in x
 % same for y and z

 x=xyzfile(COUNT-1,1)+deltax; %calculates the x for the current level
 y=xyzfile(COUNT-1,2)+deltay; %calculates the y for the current level
 z=xyzfile(COUNT-1,3)+deltaz; %calculates the y for the current level

 xyzfile(COUNT,1:3)=[x,y,z]; %outputs the x,y,z to the output variable
end %for COUNT

% the following shifts x,y,z by the easting, northing and shift respectively
 xyzfile(:,1)=xyzfile(:,1)+easting;
 xyzfile(:,2)=xyzfile(:,2)+northing;
 xyzfile(:,3)=xyzfile(:,3)+shift;


% convert z column from feet to metres and add shift
if conv_flg==1
   xyzfile(:,3) = (xyzfile(:,3)-shift)*0.3048+shift;
end

% plot borehole trace in three dimensions
if plot_flg==1
   plot3(xyzfile(:, 1), xyzfile(:, 2), xyzfile(:, 3));
   set(gca, 'zdir', 'reverse');
   set(gca, 'box', 'on');
   title('Borehole Trace');
end
