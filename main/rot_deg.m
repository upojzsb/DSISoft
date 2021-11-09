function dataout=rot_deg(datain,rotang,rec1,rec2)

%function dataout=rot_deg(datain,rotang)
%
%This function rotates two gathers by a fixed rotation angle
%
%rotang=rotation angle in degrees
%rec=record number in file to be rotated
%
%DSI customized VSP processing software
%written by Gervais Perron March, 1998

%$Id: rot_deg.m,v 3.0 2000/06/13 19:21:17 gilles Exp $
%$Log: rot_deg.m,v $
%Revision 3.0  2000/06/13 19:21:17  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:25  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:07  kay
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

disp('function dataout=rot_deg(datain,rotang,rec)');

dataout=datain;
s=sin(rotang*pi/180);
c=cos(rotang*pi/180);
rotmat=[c s;-s c];

for i=1:datain.th{rec1}(12,1)
   rotdata=(rotmat'*[datain.dat{1}(:,i) datain.dat{2}(:,i)]')';
   dataout.dat{rec1}(:,i)=rotdata(:,1); %rotated h1 component
   dataout.dat{rec2}(:,i)=rotdata(:,2); %rotated h2 component
end





