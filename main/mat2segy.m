function mat2segy(datain,filename,cross_wire_file,platform,reel_id_header)

% mat2segy(datain,filename,crosswire,platform,reel_id_header)
%
% This function stores a DSI variable in SEG-Y format.
%
% This module has been written to use a crosswire file to designate
% trace header locations. 
%
% This is the same crosswire file as used for 'segy2mat'.
%
% The crosswire file is and ASCII file consisting of numbers only separted
% into columns using either spaces or Tabs.  MATLAB-style comments can be
% included in the file provided that they begin with a percent character '%'.
% The file should consist of 5 columns: segy byte to start at (byte 1 is
% beginning of a trace header), the format of this element (1 for 'char',
% 2 for 'int16', and 3 for 'int32'), a divisor, a subtractve constant 
% and the DSI trace header word where this value is stored. 
%
% For segy-mat(dsi) the multiplier is applied before the additive constant, 
% so for mat(dsi) -> segy the subtractive constant is applied before the
% divisor.
%
% The SEG-Y format is defined in:
% Barry, K.M., Cavers, D.A., and Kneale, C.W., Recomended Standards for
% Digital Tape Formats, Geophysics, Vol. 40, No. 2 (April 1975), P. 344-352.
%
% This script's output is not standard SEG-Y.  The values are stored as native
% floating point format, rather than IBM floating point format. 
%
%
%INPUT
%datain - seismic data in DSI format
%filename - name of segy file.  Must be enclosed in single quotes.
%cross_wire_file - name of crosswire file.  Must be enclosed in single quotes.
%platform =	'l' for little-endian (PC) files
%		'b' for big-endian (Unix) files
%reel_id_header - string variable containing a description of the file
%	this string will be stored in the reel identification header of
%	the segy file
%
%DSISoft Customized VSP Processing software
%written by K.S. Beaty June, 1998

%$Id: mat2segy.m,v 3.0 2000/06/13 19:20:40 gilles Exp $
%$Log: mat2segy.m,v $
%Revision 3.0  2000/06/13 19:20:40  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:53  mah
%Release 2
%
%Revision 1.4  1999/03/08 14:21:39  kay
%Save data in IEEE floating point.
%
%Revision 1.3  1999/03/03 21:21:22  kay
%Application of multiplier and additive constant wasn't symmetric with usage
%in segy2mat.  Corrected that...
%
%Revision 1.2  1999/03/03 19:15:20  kay
%Load made more portable between versions of matlab.
%Note that number of samples and dt not written to headers properly yet...
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

disp('mat2segy(datain,filename,cross_wire_file,platform,reel_id_header)')

platform=lower(platform);
EBCDICSIZE=3200; %EBCDIC/ASCII header length (bytes)
RHLEN=400; %reel header length (bytes)
THLEN=240; %trace header length (bytes)
filler=0;

% open the files
fid=fopen(filename,'w',platform);
if fid== -1
 error('Unable to open data file');
 return;
end %if
fseek(fid,0,-1);

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

if length(reel_id_header)>EBCDICSIZE
 error('Reel_id_header must contain fewer than ',EBCDICSIZE,' characters.')
end %if

%write reel id header 1
fwrite(fid,reel_id_header,'char');
for i=ftell(fid)+1:EBCDICSIZE
 fwrite(fid,char(32),'char');
end %for
disp('1st reel header written');

%write reel header 2 (file header)
fwrite(fid,filler,'int32');
fwrite(fid,datain.fh{2},'int32'); %line number (3204)
fwrite(fid,datain.fh{3},'int32'); %reel number (3208)
fwrite(fid,datain.fh{13},'int16'); %number of traces per record (3212)
fwrite(fid,filler,'int16');
fwrite(fid,datain.fh{8}*1000000,'int16'); %sampling rate in microseconds (3216)
fwrite(fid,datain.fh{8}*1000000,'int16'); %original sampling rate in microseconds (3218)
npts=datain.fh{7};
fwrite(fid,npts,'int16'); %number of points per trace (3220)
fwrite(fid,npts,'int16'); %number of points per trace (3220)
fwrite(fid,1,'int16'); %use format 1 ('float32') for storing traces (3224)
dformat='float32';
dformatlen=4; %4 bytes
fwrite(fid,zeros(1,14),'int16');
fwrite(fid,1,'int16'); %indicates measurement units are metres (3254)
fwrite(fid,zeros(1,172),'int16');

TRLEN=npts*dformatlen; %number of bytes taken up by each trace (data only)

disp('2nd reel header written');

[y,ind]=sort(crs(:,1));
nrec=datain.fh{12};
tr=0;
for rec=1:nrec
 deadtr=find(datain.th{rec}(6,:)<0);
 datain.th{rec}(6,deadtr)=2; %convert DSI kill flags to segy kill flags
 ntr=datain.th{rec}(12,1);
 for k=1:ntr
  %write trace header
  buff=EBCDICSIZE+RHLEN+THLEN*(k-1+tr)+TRLEN*(k-1+tr);

  %use crosswire file to write out trace headers
  for i=1:size(crs,1)
   c=ind(i); %need to write data in order of ascending byte number
   for byteno=ftell(fid)+1:2:buff+crs(c,1)-1
     fwrite(fid,filler,'int16');
   end %for
   value=(datain.th{rec}(crs(c,5),k)-crs(c,4))/crs(c,3); %(byte buff+crs(c,1)-1)
   fwrite(fid,value,crsformat{c});
  end %for
  buff=buff+THLEN;
  for byteno=ftell(fid)+1:2:buff
    fwrite(fid,filler,'int16');
  end %for

  %write trace data
  fwrite(fid,datain.dat{rec}(:,k),dformat);
 end %loop over traces
 tr=tr+ntr; %number of traces read so far
end %loop over records

fclose(fid);
disp('done writing segy file')
