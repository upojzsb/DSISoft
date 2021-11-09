function [matdata]=asc2mat(datain,ntr,nsmp,smpr,st,et)
%
%[matdata]=asc2mat(datain,ntr,nsmp,smpr,st,et)
%
%This function converts an ascii matrix with rows representing samples
%and columns representing traces to a DSI formatted datafile
%
%ntr=number of traces
%nsmp=number of samples
%smpr=sampling rate (in seconds)
%st=start time (seconds)
%et=end time (seconds)
%
%DSI customized VSP processing software
%written by Gervais Perron Feb. 1998

%$Id: asc2mat.m,v 3.0 2000/06/13 19:19:43 gilles Exp $
%$Log: asc2mat.m,v $
%Revision 3.0  2000/06/13 19:19:43  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:07  mah
%Release 2
%
%Revision 1.2  1999/05/17 13:55:57  mah
%fixed up help message
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

disp('[matdata]=asc2mat(datain,ntr,nsmp,smpr,st,et)');
matdata.dat{1}=datain;
matdata.th{1}=zeros(64,ntr);
matdata.th{1}(1,:)=[1:ntr];
matdata.th{1}(12,:)=ones(1,ntr).*ntr;
matdata.th{1}(13,:)=matdata.th{1}(1,:);

matdata.fh{1}=ntr;
matdata.fh{7}=nsmp;
matdata.fh{8}=smpr;
matdata.fh{9}=st;
matdata.fh{10}=et;
matdata.fh{12}=1;
matdata.fh{13}=ntr;
