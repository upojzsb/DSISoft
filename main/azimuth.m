function dataout=azimuth(datain)

%function dataout=azimuth(datain)
%
%This program computes the receiver-to-shot azimuth angle
%and puts the corresponding angle (in degrees) in header word 9
%
%DSI customized VSP processing software
%written by Gervais Perron March 4th, 1998

%$Id: azimuth.m,v 3.0 2000/06/13 19:19:47 gilles Exp $
%$Log: azimuth.m,v $
%Revision 3.0  2000/06/13 19:19:47  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:10  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:01  kay
%Initial revision
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

disp('function dataout=azimuth(datain);')

dataout=datain;
for i=1:datain.fh{12}
   for j=1:datain.th{i}(12,1)

      diffn=datain.th{i}(29,j)-datain.th{i}(35,j);
      diffe=datain.th{i}(31,j)-datain.th{i}(37,j);
      dataout.th{i}(53,j)=sqrt(diffn.^2+diffe.^2);

      if diffn>=0 & diffe>=0
         a=atan(diffn/diffe);
         azdeg(j)=90-(a*180/pi);
         azrad(j)=azdeg(j)*pi/180;
      elseif diffn<=0 & diffe>=0
         a=atan(diffn/diffe);
         azdeg(j)=90+abs(a*180/pi);
         azrad(j)=azdeg(j)*pi/180;
      elseif diffn<=0 & diffe<=0
         a=atan(diffn/diffe);
         azdeg(j)=180+90-(a*180/pi);
         azrad(j)=azdeg(j)*pi/180;
      elseif diffn>=0 & diffe<=0
         a=atan(diffn/diffe);
         azdeg(j)=180+90+abs(a*180/pi);
         azrad(j)=azdeg(j)*pi/180;
      end
   end
   dataout.th{i}(9,:)=azdeg;
   dataout.th{i}(64,:)=azrad;
end




