function [dataout]=cdpt3d(datain,v,strike,dip,width,binsize,depthlim)

%[dataout]=cbins(datain,v,strike,dip,width,binsize,depthlim)
%
%%three dimensional CDP (common depth point) transform
%finds reflection points in 3 dimensions using rotations and ray 
%tracing method
%
%A plot displays the survey geometry and the surface projection of 
%the reflection points.  2 points (CDP line) have to be picked by the user
%that corresponds to the starting and ending points of the bins.  
%
%creates a 3 dimensional grid of bins, sums trace energy 
%corresponding in the bin  corresponding to its reflection point for 
%a given strike and dip of the geology, normalizes by the number of 
%traces contributing energy to each bin
%uses functions 'rotcoord' and 'findref3d
%use 'solve3d_v2'
%use 'slicefmap' to extract 2D vertical or horizontal slices from the 
%3D volume these slices can then be displayed using 'dispseis' 
%(DSISoft) or else 'pcolor' or 'imagesc' (MATLAB).
%
%INPUT
%datain - dataset in DSI format
%     shot and receiver locations and travel time information are 
%     taken from the headers
%     trace headers 31, 29 and 33 are shot easting, northing and 
%     elevation respectively (x,y,z)
%     trace headers 37, 35, and 39 are receiver easting, northing, 
%     and elevation respectively
%     travel time startime:samplingrate:endtime (file headers 9, 8 
%     and 10 respectively)
%v - background velocity of the p-waves (m/s)
%strike  - strike angle in degrees from North (or mine grid North, +clockwise)
%dip  - dip angle to the left, by convention, also in degrees
%width - width on each side of the picked point perpendicular to the CDP line
%binsize - vector of bin widths in metres for fold map in x, y, and z 
%     directions.  should be set equal to sampling rate times velocity
%depthlim - spatial limits of fold map in depth [zmin zmax]
%
%OUTPUT
%dataout - the results of performing a 3D CDP transform on the input data
%    format is a modified DSI variable.  File and trace headers still 
%    exist but the .dat section has been replaced with a .fmap extension 
%    which contains a cell array (records) of 3 dimensional arrays.  
%    This is the results of the 3D CDP transform.  There are also .xsc, 
%    .ysc, and .zsc extensions, each containing vectors describing 
%    the coordinates of the centre of each of the bins.
%
%Customized VSP Processing Software
%written by K.S. Beaty July, 1998
%last modified May, 1999
%by G. Perron
%last modified by G. Bellefleur, May, 2000

%$Id: cdpt3d.m,v 3.2 2000/06/20 17:39:23 gilles Exp $
%$Log: cdpt3d.m,v $
%Revision 3.2  2000/06/20 17:39:23  gilles
%Fix Figure display
%
%Revision 3.1  2000/06/13 20:06:44  gilles
%Updated function calls
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

%echo of function call
disp('[dataout]=cdpt3d(datain,v,strike,dip,binsize,depthlim)')

[refpoints]=cdp3d(datain,v,strike,dip);

%echo of function call
disp('[refpoints]=cdp3d(datain,v,strike,dip)');

%setting sampling rate variable
smp=datain.fh{8};
t1=datain.fh{9};
nshots=datain.th{1}(12,1);
dataout=datain;
dataout=rmfield(dataout,'dat');

%creating bin vector for depth
minz=min(depthlim);
maxz=max(depthlim);
zbin=[minz:binsize(3):maxz];

%plotting refpoints
for i=1:nshots
   hold on
   a=find(refpoints{i}(:,5)==1);
   plot(refpoints{i}(a,1),refpoints{i}(a,2),'.r');
   %plot3(refpoints{i}(:,1),refpoints{i}(:,2),refpoints{i}(:,3),'.r');

end

%plotting source information
plot(datain.th{1}(31,:),datain.th{1}(29,:),'ob');

%plotting receiver information
plot(datain.th{1}(37,:),datain.th{1}(35,:),'*k');

%axes manipulation
axlim=axis;
axis([axlim(1)-50 axlim(2)+50 axlim(3)-50 axlim(4)+50]);
axis('equal');

%mouse input for along S-R azimuth bin limits
figure(1)
[px,py]=ginput(2);
plot(px,py,'sc');

%theta is the angle between the vertical and the s-r azimuth
theta=atan((px(2)-px(1))/(py(2)-py(1)))*180/pi;

%rotation of the picked points by theta with 1st point as pivot
[pu,pv]=rotcoord(px,py,theta,px(1),py(1));

%creating xbin and ybin vectors
xbin=pu(1)-width:binsize(1):pu(1)+width;

%if statement to check if the 1st picked point is > or < than the 2nd
if pv(1)<pv(2)
   ybin=pv(1):binsize(2):pv(2);
else
   ybin=pv(1):-binsize(2):pv(2);
end


%fixing fh5 and fh6 for later use in slicefmap to handle along S-R bin alignment
dataout.fh{5}=theta;
dataout.fh{6}=[px(1) py(1)];

%setting output variable fields needed for slicing the foldmap
dataout.xsc=xbin;
dataout.ysc=ybin;
dataout.zsc=zbin;

%__________________________________________________
%plotting part of the code to show the bin position
%lines to plot bins and bin vectors
[X,Y]=meshgrid(xbin,ybin);

out=find(X==pu(1));
a=X(out)';
b=Y(out)';

out2=find(Y==pv(1));
c=X(out2)';
d=Y(out2)';


[Xu,Yv]=rotcoord(X,Y,-theta,pu(1),pv(1));
[xbinh,ybinh]=rotcoord(a,b,-theta,pu(1),pv(1));

[xbinv,ybinv]=rotcoord(c,d,-theta,pu(1),pv(1));

plot(Xu,Yv,'.m');
plot(xbinh,ybinh,'.k');
plot(xbinv,ybinv,'.k');

hold off
%_______________________________________________

%initialisation of the foldmap
fmap=zeros(length(xbin),length(ybin),length(zbin));
%hits is used to normalise the amplitude of the foldmap
hits=fmap;

%looping over shot-receiver pairs
for n=1:nshots %loop over shots
   fs=find(refpoints{n}(:,5)==1 & isreal(refpoints{n}(:,1))); %first set of reflection points
   rpts=refpoints{n}(fs,:); %isolate refpoints corresponding to this trace
   
   %rotation of the refpoints to fit in bins
   if ~isempty(rpts)
   [refu,refv]=rotcoord(rpts(:,1),rpts(:,2),theta,px(1),py(1));
	rpts(:,1)=refu;
   rpts(:,2)=refv;
   
   %start binning process   
   for i=1:size(rpts,1) %loop over refpoints
      %find bin associated with reflection points
      [z,f1]=min(abs(rpts(i,1)-xbin));
      [z,f2]=min(abs(rpts(i,2)-ybin));
      [z,f3]=min(abs(rpts(i,3)-zbin));
      
      %if statement to exclude out of dimension points
      if (round((rpts(i,4)-t1)/smp+1))>datain.fh{7}
         
      else
         amp=datain.dat{1}(round((rpts(i,4)-t1)/smp+1),n); 
         fmap(f1,f2,f3)=fmap(f1,f2,f3)+amp; %increment bin
         hits(f1,f2,f3)=hits(f1,f2,f3)+1; %increment bin
      end %(if)
   end %for i  
   end
end %loop over n


%set zeros on hits to NaN
for a=1:size(hits,3)
   [i,j,v]=find(hits(:,:,a)==0);
   for b=1:length(i)
      hits(i(b),j(b),a)=NaN;
   end %for b
end %for a

%set dataout.fmap and normalize by number of hits to each bin
dataout.fmap{1}=fmap./hits;
for a=1:size(hits,3)
   [i,j,v]=find(isnan(hits(:,:,a)));
   for b=1:length(i)
      dataout.fmap{1}(i(b),j(b),a)=0;
   end %for b
end %for a

%end of cdpt3d
