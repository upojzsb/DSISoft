function [dataout]=segy2mat(filename,cross_wire_file,platform)

%[dataout]=segy2mat(filename,cross_wire_file,platform)
%
%This function reads data stored in segy format, the oil industry standard
%for seismic data exchange, and converts it into a MATLAB variable in DSI
%format.  This module has been written to use a crosswire file to deliniate
%trace header locations as there are many variations on the segy format.
%The crosswire file is and ASCII file consisting of numbers only separted
%into columns using either spaces or Tabs.  MATLAB-style comments can be
%included in the file provided that they begin with a percent character '%'.
%The file should consist of 5 columns: segy byte to start at (byte 1 is
%beginning of a trace header), the format of this element (1 for 'char',
%2 for 'int16', and 3 for 'int32'), a multiplier, a value to add to the
%element, and the trace header word to store this value in the DSI variable.
%
%See the following paper for a description of the standard segy format:
%Barry, K.M., Cavers, D.A., and Kneale, C.W., Recomended Standards for
%Digital Tape Formats, Geophysics, Vol. 40, No. 2 (April 1975), P. 344-352.
%
%INPUT
%filename - name of segy file.  Must be enclosed in single quotes.
%cross_wire_file - name of crosswire file.  Must be enclosed in single quotes.
%platform =	'l' for little-endian (PC) files
%		'b' for big-endian (Unix) files
%
%OUTPUT
%dataout - data in DSI format
%
%DSISoft Customized VSP Processing software
%written by K.S. Beaty June, 1998

%$Id: segy2mat.m,v 2.0 1999/05/21 18:46:30 mah Exp $
%$Log: segy2mat.m,v $
%Revision 2.0  1999/05/21 18:46:30  mah
%Release 2
%
%Revision 1.4  1999/01/25 18:58:31  kay
%Ignore EBCDIC header
%more portable loading of crosswire file
%
%Revision 1.3  1999/01/12 16:17:34  kay
%Fixed a couple of typos...
%
%Revision 1.2  1999/01/11 19:14:55  kay
%added support of ibm->ieee formats.
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

disp('[dataout]=segy2mat(filename,cross_wire_file,platform)')

platform=lower(platform);
EBCDICSIZE=3200; %EBCDIC/ASCII header length (bytes)
RHLEN=400; %reel header length (bytes)
THLEN=240; %trace header length (bytes)

% open the files
fid=fopen(filename,'r',platform);
if fid== -1
 error('Unable to open data file');
 return;
end %if
fseek(fid,0,1);
endoffile=ftell(fid);

%crs=load(cross_wire_file);
eval (['load ',cross_wire_file]);
eval (['crs=',cross_wire_file(1:length(cross_wire_file)-4),';']);
eval (['clear ', cross_wire_file(1:length(cross_wire_file)-4)]);

for c=1:size(crs,1)
 if crs(c,2)==1
  crsformat{c}='char';
 elseif crs(c,2)==2
  crsformat{c}='int16';
 else
  crsformat{c}='int32';
 end %if
end %for

fseek(fid,0,-1);
%read reel id header 1
reel_id_header1=fread(fid,EBCDICSIZE,'char');
%ind=find(reel_id_header1~=32);
%line_name=char(reel_id_header1(1:max(ind)))';
%disp('1st reel header read');
%disp(line_name);

%read reel header 2 (file header)
%initialize dataout file header
dataout.fh{13}=0; %max record fold

fseek(fid,3204,-1);
dataout.fh{2}=fread(fid,1,'int32'); %line number
fseek(fid,3208,-1);
dataout.fh{3}=fread(fid,1,'int32'); %reel number
fseek(fid,3212,-1);
ntr=fread(fid,1,'int16'); %number of traces per record
fseek(fid,3216,-1);
smp=fread(fid,1,'int16')/1000000; %sampling rate in  seconds
dataout.fh{8}=smp;
dataout.fh{9}=0; %start time (s)
fseek(fid,3220,-1);
npts=fread(fid,1,'int16'); %number of points per trace
dataout.fh{7}=npts; %number of points per trace
dataout.fh{10}=dataout.fh{9}+(npts-1)*smp; %end time (s)
fseek(fid,3224,-1);
format=fread(fid,1,'int16');
if format==1 
	dformat='float32';
	dformatlen=4;
elseif format ==2
 dformat='int32';
 dformatlen=4; %4 bytes
elseif format==3
 dformat='int16';
 dformatlen=2; %2 bytes
else
 error(['Don"t know how to deal with data format ',num2str(format)]);
end %if/else
fseek(fid,3254,-1);
units=fread(fid,1,'int16');
if units==2 %measurements in feet instead of metres
 units=0.3048; %conversion factor (m/ft)
else
 units=1; %metres
end %if

TRLEN=npts*dformatlen; %number of bytes taken up by each trace (data only)

%disp('2nd reel header read');
if ntr==0
 ntr=1;
end %if
rec=1;
tr=0;
while ~(ftell(fid)==endoffile)
 dataout.th{rec}=zeros(64,ntr); %initialize trace headers
 dataout.dat{rec}=zeros(npts,ntr); %initialize data matrix
 for k=1:ntr
	%read trace header
	buff=EBCDICSIZE+RHLEN+THLEN*(k-1+tr)+TRLEN*(k-1+tr);
	%use crosswire file to read in trace headers
	for c=1:size(crs,1)
      fseek(fid,buff+crs(c,1)-1,-1);
      dataout.th{rec}(crs(c,5),k)=fread(fid,1,crsformat{c})*crs(c,3)+crs(c,4);
   end %for

  	%read trace data
  	buff=buff+THLEN;
  	fseek(fid,buff,-1);
  	if (format==1)
	  ibm1=fread(fid,npts,'uint');
	  data=ibm2ieee(ibm1);
	  count=npts;
  	else
  		[data,count]=fread(fid,npts,dformat);
  		if count~=npts
   			error(['Trouble reading data for trace ',num2str(k),' of record ',num2str(rec),'.'])
  		end %if
  	end %if
 	dataout.dat{rec}(:,k)=data.*units;
 end %loop over traces
 dataout.th{rec}(12,1)=ntr; %number of traces this record
 dataout.th{rec}(13,:)=1:ntr; %trace sequential number
 deadtr=find(dataout.th{rec}(6,:)==2);
 dataout.th{rec}(6,deadtr)=-1; %convert segy kill flags to DSI kill flags
 tr=tr+ntr; %number of traces read so far
 rec=rec+1;
end %while
dataout.fh{12}=rec-1; %number of records read
dataout.fh{1}=tr; %total number of traces in file
dataout.fh{13}=ntr; %max record fold

fclose(fid);
disp('done reading file')
