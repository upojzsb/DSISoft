function [dataout]=rot3c(datain,headw1,tstart,tend,comp1,comp2)

%rot3c - function to rotate horizontal components for borehole data (DSI etc.) 
%into radial and transverse components
%It is done by performing 1 degree increments in rotation and then checking for the best rotation
%
%function [dataout]=rot3c(datain,headw1,tstart,tend,comp1,comp2)
%
%INPUT VARIABLES
%'datain' must be in official DSI data format
%each record must represent a component x, y, or z in that order
%this can be achieved using 'sortrec'
%
% headw1 = header word containing first break picks
% tstart and tend = time interval before and after first breaks in seconds to be analyzed for proper rotation
% comp1 = component to be maximized
% comp2 = component to be minimized
%
% Please note: Software does not check for reasonable parameters or dead traces
%
%DSIsoft ver 2.0
%DSI customized VSP processing software
%
%by G. Perron (Nov 15th, 1996)
%based on rot3c_dirp from S. Guest and D. Eaton+
%Rewritten by Marko Mah February 1999

%$Id: rot3c.m,v 3.0 2000/06/13 19:21:12 gilles Exp $
%$Log: rot3c.m,v $
%Revision 3.0  2000/06/13 19:21:12  gilles
%Release 3
%
%Revision 2.1  2000/06/13 15:51:30  gilles
%*** empty log message ***
%
%Revision 2.0  1999/05/21 18:46:20  mah
%Release 2
%
%Revision 1.7  1999/05/19 21:03:02  mah
%version number
%
%Revision 1.6  1999/03/18 19:47:09  mah
%made it more flexible by changing tint to tstart and tend
%
%Revision 1.5  1999/02/22 22:24:26  mah
%made it more robust
%
%Revision 1.4  1999/02/22 20:38:38  mah
%speed it up
%
%Revision 1.3  1999/02/22 20:12:24  mah
%changed sign convention in rotation to make in line with current practice
%
%Revision 1.2  1999/02/22 19:48:27  mah
%made program more flexible
%
%Revision 1.1  1999/02/22 19:16:20  mah
%Initial revision
%
%
%
%Copyright (C) 1998 Seismology and Electromagnet+ic Section/
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

disp('[dataout]=rot3c(datain,headw1,tstart,tend,comp1,comp2)');

w=pi/180;

trclength=datain.fh{7}; %number of points per trace
smpint=datain.fh{8}; %smpint is the sampling interval
dataout=datain;

%check to make sure data is separated into components

%ntr is the number of traces in each record

for COUNT=3:-1:1 %get number of traces in each component
	ntr(COUNT)=datain.th{COUNT}(12,1);
end %for

if (ntr(1)~=ntr(2)) | (ntr(1)~=ntr(3))
	error('check data format - different number of traces in components');
end%if

if length(datain.dat)~=3
	error('data must have only 3 records - one for each of x, y and z');
end %if

%*************************************************************************
%create a look-up table of sin and cos values
for COUNT=0:360
   cosang(COUNT+1)=cos(COUNT*w);
   sinang(COUNT+1)=sin(COUNT*w);
end %for COUNT

ntr=ntr(1);
angmx(1:ntr)=0; %initialize angmx vector for storing rotation angles

for COUNT1=1:ntr
 samp1=round((datain.th{1}(headw1,COUNT1)-datain.fh{9})/smpint)-round(tstart/smpint)+1; %calulates start of interval to be analyzed
 samp2=round((datain.th{1}(headw1,COUNT1)-datain.fh{9})/smpint)+round(tend/smpint)+1; %calulates end of interval to be analyzed
 
 fbsamp=round(datain.th{1}(headw1,COUNT1)/smpint);
 %this following loops over specified angles and returns the angle within
 %those specified that maximizes the radial component

 cmax=0; %initializing the max. energy of a component

 datawin=samp1:samp2; %the window over which the data is to be analyzed 
 lendatawin=length(datawin); %length of the data window
 xy=[datain.dat{comp1}(datawin,COUNT1), datain.dat{comp2}(datawin,COUNT1)]; %the window of data to be analyzed

 rt=zeros(lendatawin,2);

 for COUNT2=0:90 %checks from 0 to 90 degrees

  %the following applies the rotation matrix and sums over each component
  rt(:,1)=xy(:,1)*cosang(COUNT2+1)+xy(:,2)*sinang(COUNT2+1);
  rt(:,2)=-xy(:,1)*sinang(COUNT2+1)+xy(:,2)*cosang(COUNT2+1);
  c1rms=sum(rt(:,1).*rt(:,1));
  c2rms=sum(rt(:,2).*rt(:,2));

  % the following checks to see if either component is being maximized

  if c1rms > cmax
   angmx(COUNT1)=COUNT2;
   cmax=c1rms;
  end %if

  if c2rms > cmax
   angmx(COUNT1)=COUNT2+90;
   cmax=c2rms;
  end %if

 end %for COUNT2

 %now that one knows that one component is maximized in the range 0 to 180 degrees
 %one now checks if there has been a 180 degree phase shift

 ampmax=zeros(1,2);

 for COUNT2=1:2
  ang=angmx(COUNT1)+(COUNT2-1)*180; %calculates the angle for the current quadrant being checked
  A=[cosang(ang+1),sinang(ang+1);-sinang(ang+1),cosang(ang+1)]; %rotation matrix
  % now to determine where the firstbreak is
%  fbloc=ceil(length(xy)/2);
  fbloc=fbsamp-samp1;
  rt=A*xy(fbloc,:)'; %rotates the first break amplitudes
  ampmax(COUNT2)=rt(1);
 end %for COUNT2

maxloc=find(ampmax==max(ampmax)); %finds the location of the maximum amplitude of component 1
 angmx(COUNT1)=angmx(COUNT1)+(maxloc(1)-1)*180; %sets the angle that maximizes component 1

end %for COUNT1

for COUNT=1:ntr
  sinangmx=sinang(angmx(COUNT)+1);
  cosangmx=cosang(angmx(COUNT)+1);

  for COUNT2=1:trclength
    data1=datain.dat{comp1}(COUNT2,COUNT);
    data2=datain.dat{comp2}(COUNT2,COUNT);
    dataout.dat{comp1}(COUNT2,COUNT)=data1*cosangmx + data2*sinangmx; %radial
    dataout.dat{comp2}(COUNT2,COUNT)=-data1*sinangmx + data2*cosangmx; %transverse
  end %loop over samples
end %for COUNT

%make changes to trace header
dataout.th{comp1}(4,:)=dataout.th{comp1}(4,:)+3;
dataout.th{comp2}(4,:)=dataout.th{comp2}(4,:)+3;
dataout.th{comp1}(5,:)=angmx(:);
dataout.th{comp2}(5,:)=angmx(:);
