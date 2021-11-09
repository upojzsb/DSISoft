function [dataout]=agc3c(datain,window,type)

%[dataout]=agc3c(datain,window,type)
%
%This function will do automatic gain control with a running window equation
%on the traces in datain.It preserves the amplitude ratio between each component.
%The size of the sliding window is specified by the parameter 'window' in 
%seconds.
%'type' = 1 use absolute values for normalizing
%'type' = 2 use energy values (x^2) for normalizing
%
%  written by G. Bellefleur March 2000
%  based on agc.m written by Kristen Beaty Dec. 1997

%$Id: agc3c.m,v 3.0 2000/06/13 19:19:36 gilles Exp $
%$Log: agc3c.m,v $
%Revision 3.0  2000/06/13 19:19:36  gilles
%*** empty log message ***
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
  
disp('[dataout]=agc3c(datain,window,type)')

dataout=datain;

tstart=datain.fh{9}; %start time in seconds
int=datain.fh{8}; %sampling interval in seconds
samples=datain.fh{7}; %number of points per trace
nrec=datain.fh{12}; %number of records in datain
w=round(window/int)+1; %convert 'window' from seconds to indexes
pt=round(w/2); %index of point in the centre of the window

% Check if nrec=3
if (nrec==3)


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


 % the following applies the method of agc specified by type
 switch type

  case 1 %absolute values
   % first take the absolute value of the data and divide by w to make it faster
   temp1=abs(datain.dat{1})/w;
   temp2=abs(datain.dat{2})/w;
   temp3=abs(datain.dat{3})/w;
   % first determine the average in the window
   fact=sum([temp1(1:w,:); temp2(1:w,:); temp3(1:w,:)]);
   facteps=fact+eps; %to get rid of divide by zero problem
   % now apply this to the first half of the window
   factgr=meshgrid(facteps,1:pt); %factgr is a grid of the correction factors
   dataout.dat{1}(1:pt,:)=datain.dat{1}(1:pt,:)./factgr;
   dataout.dat{2}(1:pt,:)=datain.dat{2}(1:pt,:)./factgr;
   dataout.dat{3}(1:pt,:)=datain.dat{3}(1:pt,:)./factgr;
   % now apply the agc to the centre portion of the trace using a for loop
   for k=1:samples-w
    % the correction factor fact is being recalculated after each position moved
    fact=fact-temp1(k,:)-temp2(k,:)-temp3(k,:)+temp1(k+w,:)+temp2(k+w,:)+temp3(k+w,:);
    facteps=fact+eps;
    dataout.dat{1}(k+pt,:)=datain.dat{1}(k+pt,:)./facteps;
    dataout.dat{2}(k+pt,:)=datain.dat{2}(k+pt,:)./facteps;
    dataout.dat{3}(k+pt,:)=datain.dat{3}(k+pt,:)./facteps;
   end %for

   % now apply this correction factor to the last half of the window
   i=(k+pt+1):samples; %i are the positions that still need to be corrected
   factgr=meshgrid(facteps,i); %factgr is a grid of the correction factors
   dataout.dat{1}(i,:)=datain.dat{1}(i,:)./factgr;
   dataout.dat{2}(i,:)=datain.dat{2}(i,:)./factgr;
   dataout.dat{3}(i,:)=datain.dat{3}(i,:)./factgr;

  case 2 %squared values
   % first square the data and divide by w to make it faster
   temp1=datain.dat{1}.*datain.dat{1}/w/w;
   temp2=datain.dat{2}.*datain.dat{2}/w/w;
   temp3=datain.dat{3}.*datain.dat{3}/w/w;
   % first determine the average in the window
   fact=sum([temp1(1:w,:); temp2(1:w,:); temp3(1:w,:)]);  
   facteps=sqrt(fact+eps); %get rid of divide by zero problem add eps
   % now apply this to the first half of the window
   factgr=meshgrid(facteps,1:pt); %factgr is a grid of the correction factors
   dataout.dat{1}(1:pt,:)=datain.dat{1}(1:pt,:)./factgr;
   dataout.dat{2}(1:pt,:)=datain.dat{2}(1:pt,:)./factgr;   
   dataout.dat{3}(1:pt,:)=datain.dat{3}(1:pt,:)./factgr;
   % now apply the agc to the centre portion of the trace using a for loop
   for k=1:samples-w
    % the correction factor fact is being recalculated after each position moved
    fact=fact-temp1(k,:)-temp2(k,:)-temp3(k,:)+temp1(k+w,:)+temp2(k+w,:)+temp3(k+w,:);
    facteps=sqrt(fact+eps);
    dataout.dat{1}(k+pt,:)=datain.dat{1}(k+pt,:)./facteps;
    dataout.dat{2}(k+pt,:)=datain.dat{2}(k+pt,:)./facteps;
    dataout.dat{3}(k+pt,:)=datain.dat{3}(k+pt,:)./facteps;
   end %for

   % now apply this correction factor to the last half of the window
   i=(k+pt+1):samples; %i are the positions that still need to be corrected
   factgr=meshgrid(facteps,i); %factgr is a grid of the correction factors
   dataout.dat{1}(i,:)=datain.dat{1}(i,:)./factgr;
   dataout.dat{2}(i,:)=datain.dat{2}(i,:)./factgr;
   dataout.dat{3}(i,:)=datain.dat{3}(i,:)./factgr;

   % the following balances the energy from trace to trace
   % Note : this was added by Mah in agc.m and modified 
   %        for this version of agc3c.m (G.B.)
   temp1=dataout.dat{1}.*dataout.dat{1};
   temp2=dataout.dat{2}.*dataout.dat{2};
   temp3=dataout.dat{3}.*dataout.dat{3};
   fact=sum([temp1; temp2; temp3]);
   fact=sqrt(fact);
   i=find(fact==0);
   fact(i)=1; %avoid divide by zero error for dead traces
   factgr=meshgrid(fact,1:samples);
   dataout.dat{1}=dataout.dat{1}./factgr; %applies the correction
   dataout.dat{2}=dataout.dat{2}./factgr; %applies the correction
   dataout.dat{3}=dataout.dat{3}./factgr; %applies the correction
 
 end %type

 else
  text = sprintf('WARNING! This version of agc3c requires 3 components');
  disp(text);
 end %if  
