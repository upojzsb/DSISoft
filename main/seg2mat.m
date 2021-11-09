function [matfile]=seg2mat(filename);

%function [matfile]=seg2mat(filename)
%
%The funcion converts a SEG-2 formatted file into official DSI format
%The filename must be specified within sigle quotation marks
%The file identified by filename should contain all the SEG-2 to be processed
%each on a separate line
%
%DSI customized VSP processing software
%written by G. Perron 18/12/97

%$Id: seg2mat.m,v 3.0 2000/06/13 19:21:21 gilles Exp $
%$Log: seg2mat.m,v $
%Revision 3.0  2000/06/13 19:21:21  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:29  mah
%Release 2
%
%Revision 1.2  1999/01/14 20:17:01  perron
%mofify lenght of read in string for sampling rate by 1 more character
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

filestr=readascii(filename);

%looping over the list of files
%opening the SEG-2 file
for j=1:length(filestr)
   fid=fopen(filestr{j},'r','l');
   chkseg2=fread(fid,4,'short');

   %checking the file format
   if (dec2hex(chkseg2(1))~='3A55')
      disp('This file is not in SEG-2 format!')
   end

   size_tpsb=chkseg2(3);
   ntrc=chkseg2(4);

   %initializing the matfile trace headers
   matfile.th{j}=zeros(64,ntrc);

   %get the pointers to the top of each trace descriptor block
   fseek(fid,32,-1);
   tdb_tops=fread(fid,ntrc,'int');

   %loop over traces
   for n=1:length(tdb_tops)
      fseek(fid,tdb_tops(n),-1);
      chktdb=fread(fid,2,'short');

      if (dec2hex(chktdb(1))~='4422')
         disp('Unidentified Trace Descriptor Block!')
      end

      size_tdb=chktdb(2);

      %getting the number of samples
      fseek(fid,tdb_tops(n)+8,-1);
      nsmp=fread(fid,1,'int');

      %getting the data format
      fseek(fid,tdb_tops(n)+12,-1);
      dataformat=fread(fid,1,'char');

      %getting the channel number string
      fseek(fid,tdb_tops(n)+32,-1);
      descstr=fread(fid,size_tdb-32,'char')';
      descstr=char(descstr);
      idxch=findstr(descstr,'CHANNEL_NUMBER');

      %getting the sample interval string
      fseek(fid,tdb_tops(n)+32,-1);
      descstr=fread(fid,size_tdb-32,'char')';
      descstr=char(descstr);
      idxsmp=findstr(descstr,'SAMPLE_INTERVAL');

      %getting the channel number and sample interval values
      numchan=descstr(idxch+16:idxch+20);
      smp=descstr(idxsmp+16:idxsmp+22);
      smp=str2num(smp);

      %initializing the sequential trace number, ffid, number of traces and number of channels
      matfile.th{j}(1,n)=n;
      matfile.th{j}(2,n)=str2num(filestr{j}(5:8));
      matfile.th{j}(12,n)=ntrc;
      matfile.th{j}(13,n)=str2num(numchan);

      %reading the data block
      if dataformat==1

         fseek(fid,tdb_tops(n)+size_tdb,-1);
         matfile.dat{j}(:,n)=fread(fid,nsmp,'short');

      elseif dataformat==2

         fseek(fid,tdb_tops(n)+size_tdb,-1);
         matfile.dat{j}(:,n)=fread(fid,nsmp,'int');

      elseif dataformat==4

         fseek(fid,tdb_tops(n)+size_tdb,-1);
         matfile.dat{j}(:,n)=fread(fid,nsmp,'float');

      elseif dataformat==5

         fseek(fid,tdb_tops(n)+size_tdb,-1);
         matfile.dat{j}(:,n)=fread(fid,nsmp,'double');

      end
   end

   %patching for the missing sample
   if length(0:smp:smp*nsmp)~=nsmp
      matfile.dat{j}(nsmp+1,:)=0;
      nsmp=nsmp+1;
      matfile.fh{10}=(nsmp-1)*smp;
   else
      matfile.fh{10}=nsmp*smp;
   end
   %closing the SEG-2 file
   fclose(fid);
end

   %initializing the matfile file headers
   matfile.fh{1}=ntrc*length(filestr);
   matfile.fh{7}=nsmp;
   matfile.fh{8}=smp;
   matfile.fh{9}=0.0;
   matfile.fh{12}=length(filestr);
   matfile.fh{13}=ntrc;
