function [dataout]=tube_time(datain,hdr1,hdr2,v);
%
%function [dataout]=tube_time(datain,hdr1,hdr2,v);
%
%This function removes all tube wave occurences on a DSI profil
%by means of median filtering.  The function introduces travel times for typical
%upgoing and downgoing tube waves.  It uses those travel times to flat and filter the data
%
%Input variables:
%datain = dsisoft variable in 3-component
%hdr1 = header word to put the upgoing travel times
%hdr2 = header word to put the downgoing travel times
%v = estimated tube wave velocity
%
%Output variable:
%dataout = dsisoft variable with tube waves filtered out
%
%Written by G. Perron, May 2000  

%$Id: tube_time.m,v 3.0 2000/06/13 19:22:27 gilles Exp $
%$Log: tube_time.m,v $
%Revision 3.0  2000/06/13 19:22:27  gilles
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
  
  
tzero=datain.th{1}(15,1);

datain.th{1}(hdr1,1)=datain.th{1}(15,1);
for i=2:datain.fh{13}
   tzero=datain.th{1}(hdr1,i-1);
   tdist=sqrt((datain.th{1}(35,i)-datain.th{1}(35,i-1)).^2+(datain.th{1}(37,i)-datain.th{1}(37,i-1)).^2+(datain.th{1}(39,i)-datain.th{1}(39,i-1)).^2);
   datain.th{1}(hdr1,i)=tzero+(tdist/v);
end

datain.th{2}(hdr1,:)=datain.th{1}(hdr1,:);
datain.th{3}(hdr1,:)=datain.th{1}(hdr1,:);



tzero=datain.th{1}(15,datain.fh{13});

datain.th{1}(hdr2,datain.fh{13})=datain.th{1}(15,datain.fh{13});
for i=datain.fh{13}-1:-1:1
   tzero=datain.th{1}(hdr2,i+1);
   tdist=sqrt((datain.th{1}(35,i)-datain.th{1}(35,i+1)).^2+(datain.th{1}(37,i)-datain.th{1}(37,i+1)).^2+(datain.th{1}(39,i)-datain.th{1}(39,i+1)).^2);
   datain.th{1}(hdr2,i)=tzero+(tdist/v);
end

datain.th{2}(hdr2,:)=datain.th{1}(hdr2,:);
datain.th{3}(hdr2,:)=datain.th{1}(hdr2,:);

dataout=datain;
