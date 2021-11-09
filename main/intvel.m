function [dataout,depth,vel]=intvel(datain,winsize,rec,method);
%function [dataout,depth,vel]=intvel(datain,winsize,rec,method);
%
%This function computes the interval velocity log from a DSI dataset
%
%datain = dsisoft variable sorted into components (header word 4)
%winsize = length of the window to use for averaging (in number of receiver levels)
%rec = record on which to perform the analysis
%Method == 0 uses a sliding mean window
%Method == 1 uses a regional linear regression
%
%dataout = dsisoft variable updated with velocities in header word 64
%depth = depth vector for the interval velocity log
%vel = actual velocity values (m/s) for each of the depth location specified in depth
%
  
%$Id: intvel.m,v 3.0 2000/06/13 19:20:32 gilles Exp $
%$Log: intvel.m,v $
%Revision 3.0  2000/06/13 19:20:32  gilles
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
  
disp('[dataout,depth,vel]=intvel(datain,winsize,rec,method);');

dataout=datain;

%loop over the receiver until the center of the last window
for i=1:datain.fh{13}-(winsize-1)
   
   %control flow on the method to use
   if method==0
      
      %computing the time difference between end samples of the window
      deltat((i-1)+(round(winsize/2)))=(datain.th{rec}(15,i+(winsize-1))-datain.th{rec}(15,i));
      %computing the average velocity over the window using wireline depth
      vel((i-1)+(round(winsize/2)))=(datain.th{rec}(53,i+(winsize-1))-datain.th{rec}(53,i))/deltat((i-1)+(round(winsize/2)));
      
      %real depth
      %depth((i-1)+(round(winsize/2)))=datain.th{1}(39,(i-1)+(round(winsize/2)));
   
   	%wireline depth vector corresponding to velocity values
	   depth((i-1)+(round(winsize/2)))=datain.th{1}(53,(i-1)+(round(winsize/2)));
   
		%putting the velocities in trace header word 64   
   	dataout.th{rec}(64,(i-1)+(round(winsize/2)))=vel((i-1)+(round(winsize/2)));
   
	elseif method==1
      
      %grabbing the time values corresponding to the window
      deltat=(datain.th{rec}(15,i:i+(winsize-1)));
      %grabbing the wireline depth values corresponding to the window
   	deltad=(datain.th{rec}(53,i:i+(winsize-1)));
      
      %computing the linear regression for depth and time parametersover the window samples 
      reg=polyfit(deltad,deltat,1);
      %velocity = 1/slope of the regression
      vel((i-1)+(round(winsize/2)))=1/reg(1);
      %creating wireline depth vector
      depth((i-1)+(round(winsize/2)))=datain.th{1}(53,(i-1)+(round(winsize/2)));
      %putting the velocities in trace header word 64   
 		dataout.th{rec}(64,(i-1)+(round(winsize/2)))=vel((i-1)+(round(winsize/2)));

   end
   
end

%plotting sequence
plot(vel(round(winsize/2):length(vel)),depth(round(winsize/2):length(depth)),'.-r')
set(gca,'ydir','reverse')
grid on
title('Interval Velocity Profile')
xlabel('Interval Velocity (m/s)')
ylabel('Wireline Depth (m)')
