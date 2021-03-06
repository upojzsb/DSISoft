%sortrec -> designed to sort traces into records according to component
%(x,y,z,r,or t); according to shot gathers, or in receiver gathers.
%May later be extended to sort into CDP gathers.
%
%function [dataout]=sortrec(datain,sort_flg1,sort_flg2)
%
%sort_flg1 - variable indicating the trace header word containing the values
%to be sorted by.  Traces with the same value in the indicated header word
%will be grouped together.
%
%Official DSI data protocol trace header number significance:
%    2 - field file ID (FFID)
%    3 - CDP number
%    4 - component (1==h1,2==h2, 3==z, 1+n*3==r, 2+n*3==t, 3+n*3==rotated z)
%     n above is number of rotations that component has been subjected to
%    26 - shot ID
%    27 - receiver ID
%
%sort_flg2 - trace header word containing variable to sort traces within record
%by, example wire line depth.  If sort_flg2 is left out or set to zero then
%the traces will not be sorted within the record.
%
%DSI customized VSP processing software
%written by Kristen Beaty October, 1997

%$Id: sortrec.m,v 3.0 2000/06/13 19:22:05 gilles Exp $
%$Log: sortrec.m,v $
%Revision 3.0  2000/06/13 19:22:05  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:36  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:08  kay
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

function [dataout]=sortrec(datain,sort_flg1,sort_flg2)

disp('[dataout]=sortrec(datain,sort_flg1,sort_flg2)');

nrec=datain.fh{12}; %number of records in file
dataout.fh=datain.fh;
tot_trc=datain.fh{1}; %total number of traces within file

%initialize matrice for number of traces per record of a specific value
newtpr=zeros(tot_trc,tot_trc);

for COUNT=1:nrec %loop over records
 n=1; %row counter
 group_id{COUNT}=datain.th{COUNT}(sort_flg1,:); %put sort values into group_id
 %sort each record of group_id in ascending order
 group_id{COUNT}=sort(group_id{COUNT});
 values{COUNT}(n)=group_id{COUNT}(1);
 for i=1:length(group_id{COUNT})
  tempg=group_id{COUNT}(i);
  tempv=values{COUNT}(n);
  if tempg~=tempv
   n=n+1; %increment row counter (i.e. new value in present record)
   values{COUNT}(n)=group_id{COUNT}(i);
  end %if
  newtpr(n,COUNT)=newtpr(n,COUNT)+1;
 end %for i=1:length(group_id{COUNT})
end %loop over records


%find the different values of group_id and put into 'summary'
summary=values{1}(:);

if length(values)>1
 for i=2:nrec %loop over number of cells in values
  for j=1:length(values{i}) %loop over number of points in values cell
   nloops=length(summary);
   diff_flg=0;
   tempv=values{i}(j);
   for k=1:nloops %loop over summary to see if values{i}(j) is in it yet
    if tempv==summary(k)
     diff_flg=diff_flg+1;
    end %if tempv==summary(k)
   end %loop over summary
   if diff_flg==0
    summary(k+1)=values{i}(j); %add values{i}(j) to summary if not there yet
   end %if diff_flg==0
  end %loop over number of points in values cell
 end %loop over number of cells in values
end %if length(values)>1

%find the number of new records, the number of traces
%per record, and the value of the header word for each record

out_nrec=length(summary); %number of records to be in dataout
out_ntpr(out_nrec)=0; %initialize number of traces per record in dataout
summary=sort(summary); %sort summary in asscending order

for k=1:length(summary) %loop over summary
 for i=1:nrec
  for j=1:length(values{i})
   tempv=values{i}(j);
   if tempv==summary(k)
    out_ntpr(k)=out_ntpr(k)+newtpr(j,i);
   end %if
  end %for j=1:length(values{i})
 end %for i=1:nrec
end %loop over summary

%initialize dataout.th and dataout.dat

for COUNT=1:out_nrec %loop over records to initialize dataout
 dataout.th{COUNT}(1:64,1:out_ntpr(COUNT))=0;
 dataout.dat{COUNT}(1:datain.fh{7},1:out_ntpr(COUNT))=0;
 %datain.fh{7}is number of points per trace
end %loop over records to initialize dataout


%now move records around

for i=1:out_nrec %loop over dataout records
 tra=1;
 for COUNT=1:nrec %loop over datain records
  %get indexes of traces for record i found in datain record COUNT
  k=find(datain.th{COUNT}(sort_flg1,:)==summary(i));
  for col=k
   dataout.dat{i}(:,tra)=datain.dat{COUNT}(:,col);
   dataout.th{i}(:,tra)=datain.th{COUNT}(:,col);
   tra=tra+1;
  end %for col=k
 end %loop over datain records
end %loop over dataout records

%sort traces within records
if nargin>2 & sort_flg2~=0
 [dataout]=trcsort(dataout,sort_flg2,out_nrec);
end %if nargin>2 & sort_flg2~=0

%update file and trace headers

for rec=1:out_nrec
 dataout.th{rec}(12,:)=0; %erases previous settings
 dataout.th{rec}(12,1)=out_ntpr(rec); %number of traces within record
 dataout.th{rec}(13,1:out_ntpr(rec))=1:out_ntpr(rec);
   %trace number within record
end %loop over out records

dataout.fh{12}=out_nrec; %number of records in file
dataout.fh{13}=max(out_ntpr); %maximum record fold


%========================================================================
function [out]=trcsort(in, sort_flg2,out_nrec)
%function to sort traces within record by the trace header word indicated
%by sort_flg2

out=in; %initialize out
for COUNT=1:out_nrec %loop over out records
 param=in.th{COUNT}(sort_flg2,:);
 [junk,I]=sort(param);
 for k=1:length(param) %loop over traces in record
  out.dat{COUNT}(:,k)=in.dat{COUNT}(:,I(k));
  out.th{COUNT}(:,k)=in.th{COUNT}(:,I(k));
 end %loop over traces in record
end %loop over out records

%end of function trcsort

