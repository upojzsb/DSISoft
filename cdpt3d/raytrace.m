function [matfile]=raytrace(datain,dip,strike,pE,pN,pElev)

% [matfile]=raytrace(datain,dip,strike,pE,pN,pElev)
%
% This function creates a 3D plot containing source, receiver, and 
% calculated CDP points with ray traceing.  It assumes a constant 
% medium and a plane with a given strike and dip (in degrees).  
% The plane intersects the borehole at [pE;pN;pElev]
%
% DATAIN is a sample set of an actual dataset.  This is best created
% using the TESTSET function, which creates an evenly spaced sample set.
% DIP - dip of plane 
% STRIKE - strike of the plane
% [pE;pN;pElev] - point on the plane (where it intersects the borehole)
%
% This function has been adapted from I.Kay's SYNPLANE function, which
% creates synthetic data and also assumes a plane reflector.
%
% DSI customized VSP processing software
% R.Zschuppe, July 1999


% variable and constant initialization:
matfile=datain;
count=0; 

point=[pE; pN; pElev]; % point on the plane where it intersects the borehole
ntraces=matfile.fh{13}; % number of traces

dip=dip*pi/180; %convert to radians
strike=strike*pi/180;

for itr=1:ntraces  % for each trace
   s=[matfile.th{1}(31,itr); %source coordinates
      matfile.th{1}(29,itr);
      matfile.th{1}(33,itr)];
   r=[matfile.th{1}(37,itr); %receiver coordinates
      matfile.th{1}(35,itr);
      matfile.th{1}(39,itr)];
   n=[sin(dip)*cos(strike);
      sin(dip)*sin(strike);
      cos(dip)]; 
   
   p=dot(n,point);
   rimage = r+2*(p - dot(n,r) )*n; % receiver image point coordinates
   cdp=s+(p-dot(n,s))/(dot(n,rimage)-dot(n,s))*(rimage-s); % point on the reflection plane where the wave intercepts it
   
   for jj=(count+1):(count+3) % saves source, receiver, and cdp coordinates for plotting
      sx(jj)=s(1);
      sy(jj)=s(2);
      sz(jj)=s(3);
      rx(jj)=r(1);
      ry(jj)=r(2);
      rz(jj)=r(3);
      cdpx(jj)=cdp(1);
      cdpy(jj)=cdp(2);
      cdpz(jj)=cdp(3);
   end
   count=count+3;
      
   ii=1;
   xx(ii)=s(1);     % organize s,r,cdp for plotting
   xx(ii+1)=cdp(1);
   xx(ii+2)=r(1);
   yy(ii)=s(2);
   yy(ii+1)=cdp(2);
   yy(ii+2)=r(2);
   zz(ii)=s(3);
   zz(ii+1)=cdp(3);
   zz(ii+2)=r(3);  
   
   hold on % hold plot for subsequent use
   axis tight % axis bounded by furthest points
   axis equal 
   a=plot3(xx,yy,zz,'b-'); % plot blue lines for rays
   
end % loop over traces in record

rotate3d on;
axis equal;

b=plot3(rx,ry,rz,'k+-'); % plot receivers and borehole
c=plot3(cdpx,cdpy,cdpz,'r*'); % plot cdp points

d=plot3(sx,sy,sz,'mo'); %plot source
xlabel('EASTING (mine coord)');
ylabel('NORTHING (mine coord)');
zlabel('ELEVATION [m]');

legend([d,b,c,a],'Source','Borehole','CDP Point','Ray Trace'); % legend
dip=dip*180/pi;
title(['SELBAIE Model: 'num2str(dip),' degree dip'])
view([-37.5,30])
