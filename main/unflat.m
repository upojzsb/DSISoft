function [dataout]=unflat(datain,flt_time,headw1)
%
%function [dataout]=unflat(datain,flt_time,headw1)
%
%The funcion unflat an the times in a header number to a desired time
%
%The flat function a seismic matrix with the flattened data
%Input arguments are:
%datain=	input data in official DSI format
%flt_time=	time at which to flat data in seconds
%headw1=	header word containing the picked times of the horizon
%
%DSI customized VSP processing software
%written by G. Perron

%$Id: unflat.m,v 3.0 2000/06/13 19:22:35 gilles Exp $
%$Log: unflat.m,v $
%Revision 3.0  2000/06/13 19:22:35  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:47:01  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:10  kay
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

disp('[dataout]=flat(datain,flt_time,headw1)');

n=datain.fh{7};				%number of points per trace
dataout=datain;

%time_num=find(datain.time==flt_time);
time_num=round(flt_time./datain.fh{8});
for COUNT=1:datain.fh{12}	%loop over records
	m=datain.th{COUNT}(12,1);	%number of traces in a record
	dataout.dat{COUNT}=zeros(n,m);

	trc_num=round(datain.th{COUNT}(headw1,:)/datain.fh{8})+1;

	diff_num=trc_num-time_num;

	for i=1:m

	  if diff_num(i) > 0
	    dataout.dat{COUNT}(diff_num(i):n,i)=datain.dat{COUNT}(1:n-diff_num(i)+1,i);

	  elseif diff_num(i) < 0 %needs to be fixed
 dataout.dat{COUNT}(diff_num(i)*(-1):n,i)=datain.dat{COUNT}(1:n-(diff_num(i)*(-1)-1),i);

	  elseif diff_num(i) == 0
	    dataout.dat{COUNT}(:,i)=datain.dat{COUNT}(:,i);
	  end
	end
end %loop over records

