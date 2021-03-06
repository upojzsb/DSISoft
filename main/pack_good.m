function [dataout]=pack_good(datain,flg)

%function [dataout]=pack_good(datain,flg)
%
%Pack_good is similar to the INSIGHT module with the same name.
%It is designed to remove traces flagged as bad (trace header word 6 has
%been set to a number of less than 0) from the dataset.
%
%datain should be in official DSI data format
%flg=0 or left out -> bad traces removed from dataset
%flg=1 -> bad traces set equal to 1.0e-10 (used to retain trace spacing for
% fk filtering
%
%'kill' can be used to flag bad traces.
%
%DSI customized VSP processing software
%written by Kristen Beaty November, 1997

%$Id: pack_good.m,v 3.0 2000/06/13 19:20:59 gilles Exp $
%$Log: pack_good.m,v $
%Revision 3.0  2000/06/13 19:20:59  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:09  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:06  kay
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

disp('[dataout]=pack_good(datain,flg)');

if nargin==2 & flg==1
 dataout=datain;
 for COUNT=1:datain.fh{12} %loop over records
  bad=find(datain.th{COUNT}(6,:)<0);
  dataout.dat{COUNT}(:,bad)=1.0e-10;
 end %for
return;
end %if

dataout.fh=datain.fh;
dataout.fh{13}=0; %initialize maximum record fold

for COUNT=1:datain.fh{12} %loop over records
 ntpr=datain.th{COUNT}(12,1); %number of traces in present record

 %initialize dataout.dat and dataout.th
 dead=find(datain.th{COUNT}(6,:)<0);
 dataout.fh{1}=dataout.fh{1}-length(dead); %update number of traces in file
 out_ntpr=ntpr-length(dead); %number of traces to be in dataout record
 if out_ntpr>dataout.fh{13}
  dataout.fh{13}=out_ntpr; %setting max record fold
 end %if
 dataout.dat{COUNT}=zeros(size(datain.dat{COUNT},1),out_ntpr);
 dataout.th{COUNT}=zeros(size(datain.th{COUNT},1),out_ntpr);

 %copy good traces to dataout
 k=1;
 for i=1:ntpr
  if datain.th{COUNT}(6,i)>=0
   dataout.th{COUNT}(:,k)=datain.th{COUNT}(:,i);
   dataout.th{COUNT}(13,k)=k; %set trace number within record
   dataout.dat{COUNT}(:,k)=datain.dat{COUNT}(:,i);
   k=k+1;
  end %if
 end %for
 dataout.th{COUNT}(12,1)=out_ntpr; %set th for number of traces this record
end; %loop over records
