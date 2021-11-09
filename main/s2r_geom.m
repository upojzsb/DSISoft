function dataout=s2r_geom(datain)

%function dataout=s2r_geom(datain)
%
%This program computes the shot-to-receiver azimuth angle
%and puts the corresponding angle (in degrees) in header word 9
%It also computes the shot-to-receiver offset (m) and puts the results
%in header word 53
%
%This function implies that header words 29,31,33,35,37,39
%are set before being used
%
%DSIsoft ver 2.0
%DSI customized VSP processing software
%
%written by Gervais Perron January 25th, 1999


%$Id: s2r_geom.m,v 3.0 2000/06/13 19:21:19 gilles Exp $
%$Log: s2r_geom.m,v $
%Revision 3.0  2000/06/13 19:21:19  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:27  mah
%Release 2
%
%Revision 1.4  1999/05/19 21:06:28  mah
%end of file problem
%
%Revision 1.3  1999/05/19 21:05:13  mah
%end of file problem
%
%Revision 1.2  1999/05/19 21:04:03  mah
%version number
%
%Revision 1.1  1999/01/25 19:32:07  perron
%Initial revision
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
disp('function dataout=s2r_geom(datain);')

%initializing output variable
dataout=datain;

%looping over records in datain
for i=1:datain.fh{12}
   %looping over traces in datain
   for j=1:datain.th{i}(12,1)
      
      %computing distances between shots and receivers for each dimension
      diffn=datain.th{i}(35,j)-datain.th{i}(29,j);
      diffe=datain.th{i}(37,j)-datain.th{i}(31,j);
      diffz=datain.th{i}(39,j)-datain.th{i}(33,j);
      
      %computing shot-to-receiver offset
      dataout.th{i}(53,j)=sqrt(diffe.^2+diffn.^2+diffz.^2);
      
      %if statements for computing shot to receiver azimuth
      %depending on the different quadrants
      
      %quadrant 1 (north-east)
      if diffn>=0 & diffe>=0
         a=atan(diffn/diffe);
         azdeg(j)=90-(a*180/pi);
      %quadrant 2 (south-east)
      elseif diffn<=0 & diffe>=0
         a=atan(diffn/diffe);
         azdeg(j)=90+abs(a*180/pi);
      %quadrant 3 (south-west)
      elseif diffn<=0 & diffe<=0
         a=atan(diffn/diffe);
         azdeg(j)=180+90-(a*180/pi);
      %quadrant 4 (north-west)
      elseif diffn>=0 & diffe<=0
         a=atan(diffn/diffe);
         azdeg(j)=180+90+abs(a*180/pi);
      end
   end
   %assigning shot to receiver azimuth in trace headers
   dataout.th{i}(9,:)=azdeg;
end

