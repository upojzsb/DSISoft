function mat2asc(datain,rec,datfile,thfile,fhfile)

%mat2asc(datain,rec,datfile,thfile,fhfile)
%mat2asc(datain,rec,datfile,thfile)
%mat2asc(datain,rec,datfile)
%
%This function saves a DSI variable as three separate ascii files.
%One file is for the file header, one for the trace headers, and
%one for the seismic traces.  Only one record is saved.
%
%INPUT
%datain - data in DSI format
%rec - record number to write out to file
%datfile, thfile and fhfile - file names for storing data, trace headers,
%and file header respectivly.  All file names must be enclosed in single
%quotes.  Files will be saved in your current directory unless a path is
%specified with the filenames.
%
%DSI customized VSP processing software
%written by K.S. Beaty June 1998

%$Id: mat2asc.m,v 3.0 2000/06/13 19:20:38 gilles Exp $
%$Log: mat2asc.m,v $
%Revision 3.0  2000/06/13 19:20:38  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:52  mah
%Release 2
%
%Revision 1.2  1999/03/29 17:08:37  eadam
%Added fclose statements for datfile and thfile.,
%
%Revision 1.1  1999/01/06 19:09:04  kay
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

disp('mat2asc(datain,rec,datfile,thfile,fhfile)');

msg1='\nThe file "';
msg2='" exists already.  Overwrite this file? y for yes, n for no.\n';
%save data
if exist(datfile)==2 %if file exists already
 yn=input([msg1,datfile,msg2],'s');
 if ~strcmp(yn,'y')
  return;
 end %if
end %if

format=' %12f';
matformat=format;
for i=1:datain.th{rec}(12,1)-1 %loop over traces
 matformat=[matformat,format];
end %loop over traces
matformat=[matformat,'\n'];

datfid=fopen(datfile,'w');
if datfid==-1
 error(['Could not open file ',datfile,'.'])
end %if
fprintf(datfid,matformat,datain.dat{rec}');
fclose(datfid);

if nargin==3
 return
end %if

%save trace headers
if exist(thfile)==2 %if file exists already
 yn=input([msg1,thfile,msg2],'s');
 if ~strcmp(yn,'y')
  return;
 end %if
end %if

thfid=fopen(thfile,'w');
if thfid==-1
 error(['Could not open file ',thfile,'.'])
end %if
%th=datain.th{rec}';
fprintf(thfid,matformat,datain.th{rec}');
fclose(thfid);

if nargin==4
 return
end %if

%save file header
if exist(fhfile)==2 %if file exists already
 yn=input([msg1,fhfile,msg2],'s');
 if ~strcmp(yn,'y')
  return;
 end %if
end %if

for i=length(datain.fh):-1:1
 fhmat(i,1)=datain.fh{i};
end %convert file header to matrix
fhmat(1,1)=datain.th{rec}(12,1); %change number of traces in file
fhmat(13,1)=fhmat(1,1); %max record fold
fhmat(12,1)=1; %number of records in file

eval(['save ',fhfile,' fhmat -ascii'])
