function [dataout]=slicefmap(datain,rec,flag)

%[dataout]=slicefmap(datain,rec,flag)
%
%This is a function that will slice up a fold map created by performing 
%a 3D CDP transform on DSI data.  Use 'dispseis' (DSISoft) or else 
%'pcolor' or 'imagesc' (MATLAB) to view the results.
%
%INPUT 
%datain - the results of performing a 3D CDP transform on the input data
%    format is a modified DSI variable.  File and trace headers still 
%    exist but the .dat section has been replaced with a .fmap 
%    extension which contains a cell array (records) of 3 dimensional 
%    arrays.  This is the results of the 3D CDP transform.  There are 
%    also .xsc, .ysc, and .zsc extensions, each containing vectors 
%    describing the coordinates of the centre of each of the bins.
%rec - record to work on
%flag - 1 for inline (x) slices
%     2 for crossline (y) slices
%     3 for time slices
%
%OUTPUT
%dataout - typical DSI variable except very few trace header words will be kept
%     start time, end time, and sampling rate will be stored as depth 
%     rather than time
%     each slice will be stored in a separate record
%     CDP Northing, Easting and Elevation (trace headers 41, 43, 45) will 
%     be stored where applicable, as will the CDP northing, easting and 
%     elevation bin numbers (trace headers 42, 44, 46)
%
%
%DSISoft Version 1.0
%Customized VSP Processing Software
%written by K.S. Beaty July, 1998
%last modified July 21, 1998

disp('[dataout]=slicefmap(datain,rec,flag)')

dataout.fh{13}=0;
dataout.fh{8}=datain.zsc(2)-datain.zsc(1); %sampling rate (m)
dataout.fh{9}=datain.zsc(1); %start time (m)
dataout.fh{10}=datain.fh{10}; %end time (m)

switch flag
 case 1 %inline (x)
  npts=length(datain.zsc);
  ntr=length(datain.ysc);
  nrec=length(datain.xsc);
  smp=datain.zsc(2)-datain.zsc(1); %sampling rate (m)
  t1=datain.zsc(1); %start time (m)
  t2=datain.zsc(length(datain.zsc)); %end time (m)
  for i=1:nrec
   slice=zeros(ntr,npts);
   slice(:,:)=datain.fmap{rec}(i,ntr:-1:1,:);
   dataout.dat{i}(:,:)=slice';
   dataout.th{i}=zeros(64,ntr);
   dataout.th{i}(41,:)=flipud(datain.ysc(:)); %CDP Northing 
   dataout.th{i}(42,:)=ntr:-1:1; %CDP Northing bin number
   dataout.th{i}(43,:)=datain.xsc(i); %CDP Easting 
   dataout.th{i}(44,:)=i; %CDP Easting bin number
  end %for

 case 2 %crossline (y)
  npts=length(datain.zsc);
  ntr=length(datain.xsc);
  nrec=length(datain.ysc);
  smp=datain.zsc(2)-datain.zsc(1); %sampling rate (m)
  t1=datain.zsc(1); %start time (m)
  t2=datain.zsc(length(datain.zsc)); %end time (m)
  for i=1:nrec
   slice=zeros(ntr,npts);
   slice(:,:)=datain.fmap{rec}(:,i,:);
   dataout.dat{i}(:,:)=slice';
   dataout.th{i}=zeros(64,ntr);
   dataout.th{i}(41,:)=datain.ysc(i); %CDP Northing 
   dataout.th{i}(42,:)=i; %CDP Northing bin number
   dataout.th{i}(43,:)=datain.xsc; %CDP Easting 
   dataout.th{i}(44,:)=1:ntr; %CDP Easting bin number
   [dataout.th{i}(43,:),dataout.th{i}(41,:)]=rotcoord(dataout.th{i}(43,:),dataout.th{i}(41,:),-datain.fh{5},datain.fh{6}(1,1),datain.fh{6}(1,2));
  end %for

 case 3 %time slice (z)
  npts=length(datain.ysc);
  ntr=length(datain.xsc);
  nrec=length(datain.zsc);
  smp=datain.ysc(2)-datain.ysc(1); %sampling rate (m)
  t1=datain.ysc(1); %start time (m)
  t2=datain.ysc(length(datain.ysc)); %end time (m)
  for i=1:nrec
   slice=zeros(ntr,npts);
   slice(:,:)=datain.fmap{rec}(:,:,i);
   dataout.dat{i}(:,:)=slice';
   dataout.th{i}=zeros(64,ntr);
   dataout.th{i}(45,:)=datain.zsc(i); %CDP Elevation 
   dataout.th{i}(46,:)=i; %CDP Elevation bin number
   dataout.th{i}(43,:)=datain.xsc; %CDP Easting 
   dataout.th{i}(44,:)=1:ntr; %CDP Easting bin number
  end %for
end %switch

for i=1:nrec
 dataout.th{i}(12,1)=ntr; %number of traces
 dataout.th{i}([1 2 13],:)=repmat(1:ntr,3,1); %trace sequential number
 dataout.th{i}(3,:)=i; %CDP number
 dataout.th{i}(4,:)=datain.th{rec}(4,1); %recording component
end %for

dataout.fh{8}=smp; %sampling rate (m)
dataout.fh{9}=t1; %start time (m)
dataout.fh{10}=t2; %end time (m)
dataout.fh{12}=nrec; %number of records
dataout.fh{7}=npts; %number of points
dataout.fh{1}=ntr*nrec; %total number of traces
dataout.fh{13}=ntr; %maximum record fold


