function [dataout]=mute2(datain,mute_flg,time1)
%
%function [dataout]=mute2(datain,mute_flg,time1)
%
%This function does a top or bottom mute from a constant
%time value.
%Input arguments are:
%
%time1=	 	mute time in seconds
%mute_flg=	mute flag
%	1=	mutes everything above time1
%	2=	mutes everything below time1
%
%DSI customized VSP processing software
%by E. Adam (February 8 1999)

%$Id: mute2.m,v 3.0 2000/06/13 19:20:55 gilles Exp $
%$Log: mute2.m,v $
%Revision 3.0  2000/06/13 19:20:55  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:05  mah
%Release 2
%
%Revision 1.1  1999/02/08 21:09:24  eadam
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

disp('[dataout]=mute2(datain,mute_flg,time1)');

dataout=datain;
m=datain.fh{7};				%number of points per trace
%datain.fh{9} is start time in seconds
%datain.fh{8} is sampling interval in seconds
mut_ind1=round((time1-datain.fh{9})/datain.fh{8})+2; %calculate the sample where muting starts or ends

for COUNT=1:datain.fh{12}		%loop over records

	n=datain.th{COUNT}(12,1);	%number of traces in a record

%if statements to mute specified data
%mut_ind1 is the index corresponding to time1

	if mute_flg==1		%mute all data before time1
	 for i=1:n
	     dataout.dat{COUNT}(1:mut_ind1,i)=0.0;
	  end

	elseif mute_flg==2	%mute data after time1
	  for i=1:n
	    dataout.dat{COUNT}(mut_ind1:m,i)=0.0;
	  end
	end
end %loop over records
