function [dataout]=subset(datain,tr1,tr2,t1,t2,r1,r2)
%function [dataout]=subset(datain,tr1,tr2,t1,t2,r1,r2)
%
%subset -> creates a new variable containing only the traces specified
%-tr1, tr2 are the first and last traces of the desired subset
%-t1, t2 are the first and last times of the desired subset in seconds
%-r1 and r2 are the first and last records of the desired subset
%-similar to GETR in Insight
%
%[dataout]=subset(datain,tr1,tr2,t1,t2,r1,r2)
%
%DSI customized VSP processing software
%written by Kristen Beaty October, 1997

%$Id: subset.m,v 3.0 2000/06/13 19:22:13 gilles Exp $
%$Log: subset.m,v $
%Revision 3.0  2000/06/13 19:22:13  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:44  mah
%Release 2
%
%Revision 1.2  1999/05/17 17:17:18  mah
%fixed help message
%
%Revision 1.1  1999/01/06 19:09:09  kay
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


disp('[dataout]=subset(datain,tr1,tr2,t1,t2,r1,r2)');

%check for errors
if tr1>tr2 | t1>t2 | r1>r2
     disp('check parameters for subset and try again');
     error('tr1, t1 and r1 should be smaller than tr2, t2 and r2 respectively');
end; %if

%find indexes corresponding to t1 and t2
startt=round((t1-datain.fh{9})/datain.fh{8}+1);	%index of t1
endt=round((t2-datain.fh{9})/datain.fh{8}+1);	%index of t2
%datain.fh{8} is the sampling interval in seconds
%datain.fh{9} is the trace start time in seconds

dt=endt-startt+1;
dtr=tr2-tr1+1;

%make some changes to file header
dataout.fh=datain.fh;				%copy file header
dataout.fh{1}=dtr.*(r2-r1+1); %number of trace in dataset
dataout.fh{7}=dt;		%number of points/trace
dataout.fh{9}=t1;			%trace start time (ms)
dataout.fh{10}=t2;		%trace end time (ms)
dataout.fh{12}=r2-r1+1;				%number of records
dataout.fh{13}=dtr;				%max record fold

for COUNT =r1:r2	%loop over records
        orec=COUNT-r1+1;

%put selected subset into dataout
	dataout.dat{orec}=datain.dat{COUNT}(startt:endt,tr1:tr2);
	dataout.th{orec}=datain.th{COUNT}(:,tr1:tr2);

%make necessary changes to trace headers
	dataout.th{orec}(12,1)=dtr;		%number of traces in record
	for i=1:dtr
		dataout.th{orec}(13,i)=i;	%trace number within record
	end; %for
end; %loop over records
