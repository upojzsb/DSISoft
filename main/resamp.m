function [dataout]=resamp(datain,smp_rate)
%This function resamples a DSI variable dataset 
%to a user specified sampling rate.  The ratio
%of the new sampling over the old must be an integer
%
%function [dataout]=resamp(datain,smp_rate)
%
%Input variables
%datain - DSI variable dataset to be resampled
%smp_rate - new user specified sampling rate in seconds
%
%Written by G. Perron February 2nd 1999
%Using the Signal Processing Toolbox

%$Id: resamp.m,v 3.0 2000/06/13 19:21:10 gilles Exp $
%$Log: resamp.m,v $
%Revision 3.0  2000/06/13 19:21:10  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:19  mah
%Release 2
%
%Revision 1.2  1999/05/21 15:06:44  mah
%eof problem
%
%Revision 1.1  1999/02/02 15:31:25  perron
%Initial revision
%

%function call echo
disp('[dataout]=resamp(datain,smp_rate)');
%getting the old sampling rate
old_rate=datain.fh{8};
%checking if the ratio of the two sampling rates is an integer
check=mod(smp_rate,old_rate);
%if the ratio is an integer
if check ==0
   %get the ration and setting variables p and q for resample.m
   q=smp_rate/old_rate;
   p=1;
   %initializing the output variable
   dataout=datain;
   %looping over records of data
   for i=1:datain.fh{12}
      dataout.dat{i}=resample(datain.dat{i},p,q);
   end
   %getting the number of samples per trace
   [a,b]=size(dataout.dat{1});
   
   %setting the number of samples per trace and the new sampling rate
   dataout.fh{7}=a;
   dataout.fh{8}=smp_rate;
%if the ratio is not an integer
else
   disp('The ratio of the new and the old sampling rates is NOT an integer');
end

