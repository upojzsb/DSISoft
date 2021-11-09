function [refpoints]=cdp3d(datain,v,strike,dip)

%[dataout]=cdp3d(datain,v,strike,dip)
%
%three dimensional CDP (common depth point) transform
%finds reflection points in 3 dimensions using rotations and ray 
%tracing method
%creates a 3 dimensional grid of bins, sums trace energy 
%corresponding in the bin  corresponding to its reflection point for 
%a given strike and dip of the geology, normalizes by the number of 
%traces contributing energy to each bin
%uses functions 'refpoints3d'
%
%use 'solve3d' for a picture of ray paths and reflection points
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
%v - velocity of the waves (m/s)
%strike  - strike angle in degrees from North (or mine grid North)
%dip  - dip angle to the right, by convention, also in degrees
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
%written by K.S. Beaty July, 1998
%last modified May, 1999
%by G. Perron
%Significantly modified May 2000
%by G. Bellefleur  
  
%$Id: cdp3d.m,v 3.4 2000/06/20 17:30:55 perron Exp $
%$Log: cdp3d.m,v $
%Revision 3.4  2000/06/20 17:30:55  perron
%fix ntr = datain.fh{13}
%
%Revision 3.3  2000/06/15 15:45:20  gilles
%Test to remove bad rx points
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

  
%disp('[dataout]=cdp3d(datain,v,strike,dip)')

tt=datain.fh{9}:datain.fh{8}:datain.fh{10}; %travel time vector
shot=[datain.th{1}(31,:)' datain.th{1}(29,:)' datain.th{1}(33,:)']; %shot x,y,z
rec=[datain.th{1}(37,:)' datain.th{1}(35,:)' datain.th{1}(39,:)'];  %receiver x,y,z

ntr=datain.fh{13};


for ii=1:ntr

   off(ii)=sqrt((shot(ii,1)-rec(ii,1))^2+(shot(ii,2)-rec(ii,2))^2+(shot(ii,3)-rec(ii,3))^2);
%  some trouble near the fb so we add +20 (to be fixed!)
   tt_fbsamp=ceil(off(ii)/(v*datain.fh{8}))+20;
   refpoints{ii}(1:tt_fbsamp,1)=0;
   refpoints{ii}(1:tt_fbsamp,2)=0;
   refpoints{ii}(1:tt_fbsamp,3)=0;
   refpoints{ii}(1:tt_fbsamp,4)=0; 
   refpoints{ii}(1:tt_fbsamp,5)=0;
   ii

   %find the reflection points in 3D 
   [cdps]=refpoints3d(shot(ii,:)',rec(ii,:)',tt(tt_fbsamp:length(tt)-1),dip,strike,v);
   
   refpoints{ii}(tt_fbsamp:length(tt)-1,1)=cdps(1,:);
   refpoints{ii}(tt_fbsamp:length(tt)-1,2)=cdps(2,:);
   refpoints{ii}(tt_fbsamp:length(tt)-1,3)=cdps(3,:);
   refpoints{ii}(tt_fbsamp:length(tt)-1,4)=tt(tt_fbsamp:length(tt)-1);
   refpoints{ii}(tt_fbsamp:length(tt)-1,5)=1.0;
   
% test to exclude cdp higher than sp

   test=refpoints{ii}(:,3)-shot(ii,3);
   ind=find(test<0);
   refpoints{ii}(ind,5)=0;
      
   ind1=find(imag(refpoints{ii}(:,1))~=0);
   ind2=find(imag(refpoints{ii}(:,2))~=0);
   ind3=find(imag(refpoints{ii}(:,3))~=0);
 
   refpoints{ii}(ind1,5)=0;
   refpoints{ii}(ind2,5)=0;
   refpoints{ii}(ind3,5)=0;
   
   clear ind ind1 ind2 ind3;
%   figure(1)
%   hold on
%   ind=find(refpoints{ii}(:,5)==1);
%   plot3(refpoints{ii}(ind,1),refpoints{ii}(ind,2),refpoints{ii}(ind,3),'.');
%   plot(refpoints{ii}(ind,1),refpoints{ii}(ind,2),'r.');
%   clear ind
end;

%   plot3(shot(1,1),shot(1,2),shot(1,3),'bv');
%   plot3(rec(:,1),rec(:,2),rec(:,3),'*k');
%   box on;
%   set(gca,'zdir','reverse');
%   rotate3d;

 
%end of function cdp3d
