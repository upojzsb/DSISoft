%sortrec_new_k -> designed to sort traces into records according to component
%(x,y,z,r,or t); according to shot gathers, or in receiver gathers.
%May later be extended to sort into CDP gathers.
%
%[dataout]=sortrec_new_k(datain,sort_vec)
%
%sort_vec = a vector of trace header numbers to be used for sorting
%    first entry used to sort traces into records by, subsequent 
%    entries are used to sort traces within records with decreasing order
%    of importance, much like an alphebetization scheme
%    sort_vec can be a single number if sorting within records is not desired
%
%Official DSI data protocol trace header number significance:
%    2 - field file ID (FFID)
%    3 - CDP number
%    4 - component (1==h1,2==h2, 3==z, 1+n*3==r, 2+n*3==t, 3+n*3==rotated z)
%     n above is number of rotations that component has been subjected to
%    26 - shot ID
%    27 - receiver ID
%
%
%Warning: NO checking done for valid trace header words
%
%DSI customized VSP processing software
%Based on program by Kristen Beaty October, 1997
%Rewritten by Marko Mah January 1999
%Rewritten again by Kristen Beaty May 1999

%$Id: sortrec_new_k.m,v 3.0 2000/06/13 19:22:09 gilles Exp $
%$Log: sortrec_new_k.m,v $
%Revision 3.0  2000/06/13 19:22:09  gilles
%Release 3
%
%Revision 2.1  1999/06/18 18:07:04  mah
%submitted by me for Kristen Beaty
%
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

function [dataout]=sortrec_new_k(datain,sort_vec)

disp('[dataout]=sortrec_new_k(datain,sort_vec)');

nrec=datain.fh{12}; %number of records in file
dataout.fh=datain.fh;
tot_trc=datain.fh{1}; % total number of traces within file
nsmp=dataout.fh{7}; % number of samples per trace
nsort=length(sort_vec);

index=zeros(tot_trc,2+nsort);

pos=1; % pos is the position in the index
for rec=1:nrec
 temp=datain.th{rec}; %loads in trace headers for current record
 [a,ntr]=size(temp); %number of traces in record
 tr=1:ntr;
 index(pos:pos+ntr-1,:)=[repmat(rec,1,ntr);tr;temp(sort_vec,tr)]';
 pos=pos+ntr;
end %loop over records
order=sortrows(index,[3:nsort+2]);

nrec_new=1; %initializes the number of records to 1
tracenum=1; %initializes the trace number in the new record
curr_rec=order(1,3); %initializes the current record to the first record
output_pos=zeros(tot_trc,2); %initializes the output positions
output_pos(1,:)=[1 1];
maxtrace=1; %maxtrace is the maximum record fold
for COUNT=2:tot_trc
 if order(COUNT,3)~=curr_rec
  curr_rec=order(COUNT,3);
  nrec_new=nrec_new+1;
  tracenum=1;
 else
  tracenum=tracenum+1;
 end %if
 output_pos(COUNT,:)=[nrec_new,tracenum]; %sets output trace position
 maxtrace=max(maxtrace,tracenum); %determines maximum record fold
end %for COUNT

dataout.fh{12}=nrec_new; %number of records
dataout.fh{13}=maxtrace; %max record fold

for COUNT=1:tot_trc
 dataout.th{output_pos(COUNT,1)}(:,output_pos(COUNT,2))=datain.th{order(COUNT,1)}(:,order(COUNT,2));
end %for COUNT

for COUNT1=1:nrec_new
 temp=dataout.th{COUNT1};
 [a,ntr]=size(temp);% determines number of traces in record
 dataout.th{COUNT1}(12,:)=ntr; %number of traces within record
 dataout.dat{COUNT1}=zeros(nsmp,ntr); %zeros the output data space
 dataout.th{COUNT1}(13,1:ntr)=1:ntr; %trace number within the record
end% for COUNT1

for COUNT=1:tot_trc 
 dataout.dat{output_pos(COUNT,1)}(:,output_pos(COUNT,2))=datain.dat{order(COUNT,1)}(:,order(COUNT,2));
end %for COUNT


