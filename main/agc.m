function [dataout]=agc(datain,window,type)

%[dataout]=agc(datain,window,type)
%
%This function will do automatic gain control with a running window equation
%on the traces in datain.
%The size of the sliding window is specified by the parameter 'window' in 
%seconds.
%'type' = 1 use absolute values for normalizing
%'type' = 2 use energy values (x^2) for normalizing
%
%written by Kristen Beaty Dec. 1997

%$Id: agc.m,v 3.0 2000/06/13 19:19:36 gilles Exp $
%$Log: agc.m,v $
%Revision 3.0  2000/06/13 19:19:36  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:02  mah
%Release 2
%
%Revision 1.5  1999/02/04 15:24:39  mah
%fixed problem with energy agc i.e. option 2
%
%Revision 1.4  1999/02/04 14:23:12  mah
%fixed bug
%
%Revision 1.3  1999/01/11 17:16:58  mah
%added comments through out program
%put in error checking for type
%fixed up type 2 method including energy balancing
%optimized program for speed
%fixed up redundancy near end of trace
%,
%
%Revision 1.2  1999/01/08 15:24:46  adam
%Add reset to trace length for large window and fixed boundary error
%
%Revision 1.1  1999/01/06 19:09:00  kay
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

disp('[dataout]=agc(datain,window,type)')

dataout=datain;

tstart=datain.fh{9}; %start time in seconds
int=datain.fh{8}; %sampling interval in seconds
samples=datain.fh{7}; %number of points per trace
nrec=datain.fh{12}; %number of records in datain
w=round(window/int)+1; %convert 'window' from seconds to indexes
pt=round(w/2); %index of point in the centre of the window

% the following checks to see if the window chosen is too large
if w>=samples %error check
   w = samples-1;
   pt=round(w/2);
   ntime = (samples - 1)*int;
   text = sprintf('WARNING! Window has been reset to %8.5f s',ntime);
   disp(text)
end %if

% the following checks to see if the either type 1 or 2 has been chosen

if((type ~=1) & (type ~=2))
   type=1;
   text = sprintf('WARNING! Type has been reset to 1');
   disp(text)
end %if

% the following for loop applies the agc to each record
for COUNT=1:nrec
 % the following applies the method of agc specified by type
 switch type

  case 1 %absolute values
   % first take the absolute value of the data and divide by w to make it faster
   temp=abs(datain.dat{COUNT})/w;
   % first determine the average in the window
   fact=sum(temp(1:w,:));
   facteps=fact+eps; %to get rid of divide by zero problem
   % now apply this to the first half of the window
   factgr=meshgrid(facteps,1:pt); %factgr is a grid of the correction factors
   dataout.dat{COUNT}(1:pt,:)=datain.dat{COUNT}(1:pt,:)./factgr;
   % now apply the agc to the centre portion of the trace using a for loop
   for k=1:samples-w
    % the correction factor fact is being recalculated after each position moved
    fact=fact-temp(k,:)+temp(k+w,:);
    facteps=fact+eps;
    dataout.dat{COUNT}(k+pt,:)=datain.dat{COUNT}(k+pt,:)./facteps;
   end %for

   % now apply this correction factor to the last half of the window
   i=(k+pt+1):samples; %i are the positions that still need to be corrected
   factgr=meshgrid(facteps,i); %factgr is a grid of the correction factors
   dataout.dat{COUNT}(i,:)=datain.dat{COUNT}(i,:)./factgr;

  case 2 %squared values
   % first square the data and divide by w to make it faster
   temp=datain.dat{COUNT}.*datain.dat{COUNT}/w/w;
   % first determine the average in the window
   fact=sum(temp(1:w,:));
   facteps=sqrt(fact+eps); %get rid of divide by zero problem add eps
   % now apply this to the first half of the window
   factgr=meshgrid(facteps,1:pt); %factgr is a grid of the correction factors
   dataout.dat{COUNT}(1:pt,:)=datain.dat{COUNT}(1:pt,:)./factgr;
   % now apply the agc to the centre portion of the trace using a for loop
   for k=1:samples-w
    % the correction factor fact is being recalculated after each position moved
    fact=fact-temp(k,:)+temp(k+w,:);
    facteps=sqrt(fact+eps);
    dataout.dat{COUNT}(k+pt,:)=datain.dat{COUNT}(k+pt,:)./facteps;
   end %for

   % now apply this correction factor to the last half of the window
   i=(k+pt+1):samples; %i are the positions that still need to be corrected
   factgr=meshgrid(facteps,i); %factgr is a grid of the correction factors
   dataout.dat{COUNT}(i,:)=datain.dat{COUNT}(i,:)./factgr;

   % the following balances the energy from trace to trace
   temp=dataout.dat{COUNT}.*dataout.dat{COUNT};
   fact=sum(temp);
   fact=sqrt(fact);
   i=find(fact==0);
   fact(i)=1; %avoid divide by zero error for dead traces
   factgr=meshgrid(fact,1:samples);
   dataout.dat{COUNT}=dataout.dat{COUNT}./factgr; %applies the correction
  end %type

end %loop over records
