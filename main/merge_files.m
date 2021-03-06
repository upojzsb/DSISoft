function [dataout]=merge_files(datain1,datain2)

%[dataout]=merge_files(datain1,datain2)
%
%Function to merge multiple DSI variables into a single DSI variable.
%
%INPUT
%DSI variables in order that they should be merged.  Record structure in
%each varible will be preserved and total number of records in the new
%variable will be the sum of records in all specified input files.
%
%OUTPUT
%dataout - DSI variable that is the result of merging all specified input
%	variables
%
%DSISoft Customized VSP Processing Software
%written by K.S. Beaty

%$Id: merge_files.m,v 3.0 2000/06/13 19:20:48 gilles Exp $
%$Log: merge_files.m,v $
%Revision 3.0  2000/06/13 19:20:48  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:00  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:05  kay
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

disp('[dataout]=merge_files(datain1,datain2)')

%check to make sure that files have same number of points, sampling rate
if ~datain1.fh{7}==datain2.fh{7} | ~datain1.fh{8}==datain2.fh{8}
 error('Sampling rate and number of points per trace must be the same.')
end %if

dataout.fh=datain1.fh;
dataout.fh{1}=datain1.fh{1}+datain2.fh{1}; %total number of traces in file
dataout.fh{12}=datain1.fh{12}+datain2.fh{12}; %number of records in file
dataout.fh{13}=max([datain1.fh{13},datain2.fh{13}]); %max record fold
nrec1=datain1.fh{12};
nrec2=datain2.fh{12};

for rec=1:nrec1
 dataout.th{rec}=datain1.th{rec};
 dataout.dat{rec}=datain1.dat{rec};
end %loop over records file 1
for rec=1:nrec2
 dataout.th{rec+nrec1}=datain2.th{rec};
 dataout.dat{rec+nrec1}=datain2.dat{rec};
end %loop over records file 2

