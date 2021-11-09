function [dataout]=handrot(datain,headw1,comp1,comp2)

%handrot - function to rotate horizontal components for borehole data (DSI etc.) into
%radial and transverse components according to an angle contained in a trace header word
%
%function [dataout]=handrot(datain,headw1,comp1,comp2)
%
%INPUT VARIABLES
%'datain' must be in official DSI data format
%each record must represent a component x, y, or z in that order
%this can be achieved using 'sortrec'
%
% headw1 = header word containing the rotation angle in degrees
% comp1 = component to be maximized
% comp2 = component to be minimized
%
% Please note: Software does not check for reasonable parameters or dead traces
%
%DSIsoft ver 2.0
%DSI customized VSP processing software
%
%Written by Marko Mah March 1999

%$Id: handrot.m,v 3.0 2000/06/13 19:20:20 gilles Exp $
%$Log: handrot.m,v $
%Revision 3.0  2000/06/13 19:20:20  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:38  mah
%Release 2
%
%Revision 1.2  1999/05/19 21:02:10  mah
%version number
%
%Revision 1.1  1999/03/17 19:20:40  mah
%Initial revision
%
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

disp('[dataout]=handrot(datain,headw1,comp1,comp2)');

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

for COUNT1=1:ntr
  sinangmx=sin((datain.th{1}(headw1,COUNT1))*w);
  cosangmx=cos((datain.th{1}(headw1,COUNT1))*w);

  for COUNT2=1:trclength
    data1=datain.dat{comp1}(COUNT2,COUNT1);
    data2=datain.dat{comp2}(COUNT2,COUNT1);
    dataout.dat{comp1}(COUNT2,COUNT1)=data1*cosangmx + data2*sinangmx; %radial
    dataout.dat{comp2}(COUNT2,COUNT1)=-data1*sinangmx + data2*cosangmx; %transverse
  end %loop over samples
end %for COUNT1

%make changes to trace header
dataout.th{comp1}(4,:)=4;
dataout.th{comp2}(4,:)=5;
