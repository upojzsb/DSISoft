%sortrec_many -> designed to sort traces into records according to sort_flg1
%and then within the record by sort_flg1,sort_flg2, .... sort_flg7
%Not all sort_flgs need to be filled in
%this function is able to sort according to 7 headers if necessary
%
%function [dataout]=sortrec_new(datain,sort_flg1,sort_flg2,sort_flg3,sort_flg4,sort_flg5,sort_flg6,sort_flg7)
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
%sort_flg2, sort_flg3, ... etc ... - trace header word containing variable 
%to sort traces within record by, example wire line depth. If only one
%sort flag is used or all other sort flags are set to zero, then the 
%traces will not be sorted within the record.
%
%Warning: NO checking done for valid trace header words
%
%DSI customized VSP processing software
%Based on module by Marko Mah January 1999
%Written by Marko Mah February 1999

%$Id: sortrec_many.m,v 3.0 2000/06/13 19:22:07 gilles Exp $
%$Log: sortrec_many.m,v $
%Revision 3.0  2000/06/13 19:22:07  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:39  mah
%Release 2
%
%Revision 1.2  1999/02/15 14:07:17  mah
%speeded up code
%
%Revision 1.1  1999/02/01 16:23:27  mah
%Initial revision
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

function [dataout]=sortrec_many(datain,sort_flg1,sort_flg2,sort_flg3,sort_flg4,sort_flg5,sort_flg6,sort_flg7)

disp('[dataout]=sortrec_many(datain,sort_flg1,sort_flg2,sort_flg3,sort_flg4,sort_flg5,sort_flg6,sort_flg7)');

nrec=datain.fh{12}; %number of records in file
dataout.fh=datain.fh;
tot_trc=datain.fh{1}; % total number of traces within file
samples=dataout.fh{7}; % number of samples per trace

% in this program, after the total number of traces is determined,
% the program will read in all trace header first
% then assign an index number to them in the order they are read in
% then the index numbers will be shuffled aroung to see what order
% the traces will be read in.  Once this is done, the traces and 
% the headers will be written out in this order

% initializes the sorting index
index=zeros(tot_trc,nargin+1);

% the first column of the index will store the record the trace comes from
% the second column will store the trace it was in that record
% the third column will store the trace header word specified by the first sort flag
% the fourth column will store the trace header word specified by the second sort flag (if present)
% the fifth column will store the trace header word specified by the third sort flag (if present)
% ... etc .. for the other columns (if present)

% remember one can not assume that all records have the same number of traces

pos=1; % pos is the position in the index


% now to read in the trace headers depending on the number of arguments
switch nargin
 case 2 % for only 1 sort flag
  for COUNT1=1:nrec
   temp=datain.th{COUNT1};% loads in the trace headers for the current record
   [a,ntraces]=size(temp);% determines the number of traces in the record

   for COUNT2=1:ntraces
    % the following reads into index the record numer, trace number, and the header word
    index(pos,:)=[COUNT1,COUNT2,temp(sort_flg1,COUNT2)];
    pos=pos+1;
   end %for COUNT2
  end %for COUNT1

  % the following sorts the index by the header word
  order=sortrows(index,3);

 case 3 % for 2 sort flags
  for COUNT1=1:nrec
   temp=datain.th{COUNT1};% loads in the trace headers for the current record
   [a,ntraces]=size(temp);% determines the number of traces in the record

   for COUNT2=1:ntraces
    % the following reads into index the record numer, trace number, and the header words
    index(pos,:)=[COUNT1,COUNT2,temp(sort_flg1,COUNT2),temp(sort_flg2,COUNT2)];
    pos=pos+1;
   end %for COUNT2
  end %for COUNT1

  % the following sorts the index by the header words
  order=sortrows(index,[3 4]);

 case 4 % for 3 sort flags
  for COUNT1=1:nrec
   temp=datain.th{COUNT1};% loads in the trace headers for the current record
   [a,ntraces]=size(temp);% determines the number of traces in the record

   for COUNT2=1:ntraces
    % the following reads into index the record numer, trace number, and the header words
    index(pos,:)=[COUNT1,COUNT2,temp(sort_flg1,COUNT2),temp(sort_flg2,COUNT2),temp(sort_flg3,COUNT2)];
    pos=pos+1;
   end %for COUNT2
  end %for COUNT1

  % the following sorts the index by the header words
  order=sortrows(index,[3 4 5]);

 case 5 % for 4 sort flags
  for COUNT1=1:nrec
   temp=datain.th{COUNT1};% loads in the trace headers for the current record
   [a,ntraces]=size(temp);% determines the number of traces in the record

   for COUNT2=1:ntraces
    % the following reads into index the record numer, trace number, and the header words
    index(pos,:)=[COUNT1,COUNT2,temp(sort_flg1,COUNT2),temp(sort_flg2,COUNT2),temp(sort_flg3,COUNT2),temp(sort_flg4,COUNT2)];
    pos=pos+1;
   end %for COUNT2
  end %for COUNT1

  % the following sorts the index by the header words
  order=sortrows(index,[3 4 5 6]);

 case 6 % for 5 sort flags
  for COUNT1=1:nrec
   temp=datain.th{COUNT1};% loads in the trace headers for the current record
   [a,ntraces]=size(temp);% determines the number of traces in the record

   for COUNT2=1:ntraces
    % the following reads into index the record numer, trace number, and the header words
    index(pos,:)=[COUNT1,COUNT2,temp(sort_flg1,COUNT2),temp(sort_flg2,COUNT2),temp(sort_flg3,COUNT2),temp(sort_flg4,COUNT2),temp(sort_flg5,COUNT2)];
    pos=pos+1;
   end %for COUNT2
  end %for COUNT1

  % the following sorts the index by the header words
  order=sortrows(index,[3 4 5 6 7]);

 case 7 % for 6 sort flags
  for COUNT1=1:nrec
   temp=datain.th{COUNT1};% loads in the trace headers for the current record
   [a,ntraces]=size(temp);% determines the number of traces in the record

   for COUNT2=1:ntraces
    % the following reads into index the record numer, trace number, and the header words
    index(pos,:)=[COUNT1,COUNT2,temp(sort_flg1,COUNT2),temp(sort_flg2,COUNT2),temp(sort_flg3,COUNT2),temp(sort_flg4,COUNT2),temp(sort_flg5,COUNT2),temp(sort_flg6,COUNT2)];
    pos=pos+1;
   end %for COUNT2
  end %for COUNT1

  % the following sorts the index by the header words
  order=sortrows(index,[3 4 5 6 7 8]);

 case 8 % for 7 sort flags
  for COUNT1=1:nrec
   temp=datain.th{COUNT1};% loads in the trace headers for the current record
   [a,ntraces]=size(temp);% determines the number of traces in the record

   for COUNT2=1:ntraces
    % the following reads into index the record numer, trace number, and the header words
    index(pos,:)=[COUNT1,COUNT2,temp(sort_flg1,COUNT2),temp(sort_flg2,COUNT2),temp(sort_flg3,COUNT2),temp(sort_flg4,COUNT2),temp(sort_flg5,COUNT2),temp(sort_flg6,COUNT2),temp(sort_flg7,COUNT2)];
    pos=pos+1;
   end %for COUNT2
  end %for COUNT1

  % the following sorts the index by the header words
  order=sortrows(index,[3 4 5 6 7 8 9]);

 % if you need more sorting flags, just add more cases and repeat
end %nargin

% the following determines the number of new records and determines the position in the output data set
nrec_new=1;% initializes the number of records to 1
tracenum=1;% initializes the trace number in the new record
curr_rec=order(1,3);% initializes the current record to the first record
output_pos=zeros(tot_trc,2);% initializes the output positions
output_pos(1,:)=[1 1];
maxtrace=1;% maxtrace is the maximum record fold
for COUNT=2:tot_trc
 if order(COUNT,3)~=curr_rec
  curr_rec=order(COUNT,3);
  nrec_new=nrec_new+1;
  tracenum=1;
 else
  tracenum=tracenum+1;
 end %if
 output_pos(COUNT,:)=[nrec_new,tracenum]; % sets the output trace position
 maxtrace=max(maxtrace,tracenum); % determines the maximum record fold
end %for COUNT

% the following updates the number of records in the file header
dataout.fh{12}=nrec_new;

% the following updates the maximum record fold
dataout.fh{13}=maxtrace;

% the following writes out the data by going down the output_pos list and writing it out
for COUNT=1:tot_trc
 % outputs the trace headers
 dataout.th{output_pos(COUNT,1)}(:,output_pos(COUNT,2))=datain.th{order(COUNT,1)}(:,order(COUNT,2));
end %for COUNT

% the trace header words 12 (number of traces in record) and 13 (trace number within record) still have to be fixed up for each record
for COUNT1=1:nrec_new
 temp=dataout.th{COUNT1};
 [a,ntraces]=size(temp);% determines the number of traces in the record
 dataout.th{COUNT1}(12,:)=ntraces;% assigns the number of traces within the record to the trace header
 dataout.dat{COUNT1}=zeros(samples,ntraces); %zeros the output data space in order to speed it up
 for COUNT2=1:ntraces
  dataout.th{COUNT1}(13,COUNT2)=COUNT2;% assigns the trace number within the record to the trace header
 end% for COUNT2
end% for COUNT1

for COUNT=1:tot_trc
 %outputs the traces
 dataout.dat{output_pos(COUNT,1)}(:,output_pos(COUNT,2))=datain.dat{order(COUNT,1)}(:,order(COUNT,2));
end %for COUNT
