function [matfile]=bison2mat(filelist);

%function [matfile]=bison2mat(filelist)
%
%This function converts a BISON formatted file into official DSI format.
%
%INPUT
%filelist - Name of an ASCII file containing either a single collumn listing
%the names of the BISON files to be read into DSI format or else two columns
%where the first contains the file names and the second contains an number
%to be added to all of the channel numbers in that file (ex. for a survey
%where two recorders of 24 channels each were used for each shot, the
%channel numbers for one of the recorders could be incremented by 24 so that
%the data can easily be sorted by channel number.  The name of the list file
%must be specified within sigle quotation marks.  The channel number is
%stored in trace header word 1.
%
%OUTPUT
%matfile - data in DSI format
%
%DSI customized VSP processing software
%written by E.ADAM based on a C program provided by J. McGaughey

%$Id: bison2mat.m,v 3.0 2000/06/13 19:19:53 gilles Exp $
%$Log: bison2mat.m,v $
%Revision 3.0  2000/06/13 19:19:53  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:16  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:02  kay
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

disp('[matfile]=bison2mat(filelist)')

filestr=readascii(filelist);

%looping over the list of files
%opening the BISON file
for j=1:length(filestr)
   temp=sscanf(filestr{j},'%s %d',[1,inf]);
   if strcmp(class(temp),'char')
    datafile=filestr{j};
    channel_inc=0; %default is no channel increment
   else
    datafile=char(temp(1:length(temp)-1));
    channel_inc=temp(length(temp));
   end %if/else
   fid=fopen(datafile,'r','l');
   % Verify that this is a BISON FORMAT file
   fseek(fid,117,-1);
   chkbison=fgets(fid,7);
   disp(['File format = ',chkbison]);
   if (chkbison~='BISON-2');
      disp('This file is not in BISON format!');
   end

   %get the FFID from the filename
   ffid = char(filestr(j));
   ffid = str2num(ffid(4:8));

   % here I calculate the length of the header
   fseek(fid,0,-1);
   c = 0;
   i= 0;
   while c ~= 3,
      c = fscanf(fid,'%c',1);
      i = i+1;
      if (c == 3)
            c = fscanf(fid,'%c',1);
            i = i+1;
      end
   end
   header_length = i;
   disp(['Header bytes read = ',num2str(i),' bytes']);

   % Here I extract useful information from the header
   fseek(fid,145,-1);
   data_format=fgets(fid,1);
   disp(['Data Format = ',data_format]);

   fseek(fid,218,-1);
   channels=str2num(fgets(fid,4));
   disp(['Number of channels = ',num2str(channels)]);

   fseek(fid,238,-1);
   samples=str2num(fgets(fid,6));
   disp(['Number of samples = ',num2str(samples)]);

   fseek(fid,246,-1);
   sample_rate=str2num(fgets(fid,4))/1000;
   disp(['Sample rate = ',num2str(sample_rate)]);

   %Allocate matfile matrices (to speed up code)
   matfile.th{j}=zeros(64,channels);
   matfile.dat{j}=zeros(samples,channels);

   % Extract the data
   for c = 1:channels,
      offset=((samples/4)*10)*c+header_length;
      fseek(fid,offset,-1);
      for s = 1:(samples/4),
         buff = fread(fid,4,'int16');
         m1=buff(1);
         m2=buff(2);
         m3=buff(3);
         m4=buff(4);
         exps = fread(fid,1,'uint16');
         e1=bitand(bitshift(exps,-12),15);
         e2=bitand(bitshift(exps,-8),15);
         e3=bitand(bitshift(exps,-4),15);
         e4=bitand(exps,15);
         f1=m1*2^(15-e1);
         f2=m2*2^(15-e2);
         f3=m3*2^(15-e3);
         f4=m4*2^(15-e4);
         signalf((s-1)*4+1)=f1;
         signalf((s-1)*4+2)=f2;
         signalf((s-1)*4+3)=f3;
         signalf((s-1)*4+4)=f4;
      end

%      disp(['Extracting channel = ',num2str(c)])

      %initializing the sequential trace number, ffid, number of traces and number of channels
      matfile.th{j}(1,c)=c+channel_inc;
      matfile.th{j}(2,c)=ffid;
      matfile.th{j}(12,c)=channels;
      matfile.th{j}(13,c)=c;

      %writing the data block
      matfile.dat{j}(:,c)=signalf;

   end
     %patching for the missing sample
   if length(0:sample_rate:sample_rate*samples)~= samples
      matfile.dat{j}(samples+1,:)=0;
      samples=samples+1;
      matfile.fh{10}=(samples-1)*sample_rate;
   else
      matfile.fh{10}=samples*sample_rate;
   end

   %closing the BISON file
   fclose(fid);
end

   %initializing the matfile file headers
   matfile.fh{13}=channels;
   matfile.fh{1}=channels*length(filestr);
   matfile.fh{7}=samples;
   matfile.fh{8}=sample_rate;
   matfile.fh{9}=0.0;
   matfile.fh{10}=sample_rate*(samples-1);
   matfile.fh{12}=length(filestr);
