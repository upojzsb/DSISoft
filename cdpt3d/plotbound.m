function plotbound(bound,bins)

%plotbound(bound,bins)
%
%this function plots boundary layers on current figure (3D)
%bound is a cell array describing one or more layers
%each layer can be either a 1x5 matrix of x,y,z coordinates of a point
%on the layer followed by strike and dip in degrees
%or else as an n x 3 matrix of x,y,z points on the surface
%bins describes the number of grid points to be plotted
%
%written by K.S. Beaty
%last modified November 5, 1997 

w=pi./180;
%convert strike and dip to radians

colormap(cool);

limx = get(gca, 'XLim'); 
limy = get(gca, 'YLim');

xmax = limx(1,2);
ymax = limy(1,2);
xmin = limx(1,1);
ymin = limy(1,1);

dy = ymax-ymin;
dx = xmax-xmin;

%creating a meshgrid for boundaries
x = [xmin:(xmax-xmin)/bins:xmax];
y = [ymin:(ymax-ymin)/bins:ymax];
[X,Y] = meshgrid(x,y);
C = ones(bins+1,bins+1);

%start loop to plot all boundaries
boundnum=size(bound);
layers=boundnum(1,2);

for i=1:layers
   col=size(bound{i});
   if col(1,2)==5
	strike = bound{i}(1,4).*pi./180;
	dip = bound{i}(1,5).*pi./180;
	zb = bound{i}(1,3);
	yb = bound{i}(1,2);
	xb = bound{i}(1,1);

	z0 = zb - ((xmax-xb)*cos(strike)-(yb-ymin)*sin(strike))*tan(dip);
	z1 = z0 - dy*sin(strike)*tan(dip);
	z2 = z0 + (dx-dy*tan(strike))*cos(strike)*tan(dip);
	z3 = z0 + dx*cos(strike)*tan(dip);

	corners(1, :) = [xmin, ymin, z3];
	corners(2, :) = [xmin, ymax, z2];
	corners(3, :) = [xmax, ymax, z1];
	corners(4, :) = [xmax, ymin, z0];
	%corners(5, :) = corners(1,:);
	points=corners;
   else
	points=bound{i}(:,1:3);
   end; %if/else

	%plot3(points(:,1), points(:,2), points(:,3), 'kx');
	Z=griddata(points(:,1), points(:,2), points(:,3), X, Y, 'linear');
	%mesh(x,y,Z,C);
	H=surf(x,y,Z,C);
	set(H,'facecolor', 'none');
	set(H,'edgecolor','flat');
	C = C+1;		%increment colour matrix for next plane
	planegrid{i}=Z;
end %plotting boundaries loop

hidden off;
