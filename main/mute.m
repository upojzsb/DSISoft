function [dataout]=mute(datain,mute_flg,headw1,headw2)
%
%function [dataout]=mute(datain,mute_flg,headw1,headw2)
%
%The mute let's you do a top, bottom and horizon mutes
%The mute function returns a muted data matrix
%Input arguments are:
%
%headw1=	header word containing the mute times in seconds
%headw2=	header word containing the mute times in seconds
%mute_flg=	mute flag
%	1=	mutes everything above headw1
%	2=	mutes everything below headw1
%	3=	mutes everything above headw1 and everything below headw2
%	4=	mutes everything between headw1 and headw2
%
%DSI customized VSP processing software
%by G. Perron (15 Nov, 1996)

%$Id: mute.m,v 3.0 2000/06/13 19:20:53 gilles Exp $
%$Log: mute.m,v $
%Revision 3.0  2000/06/13 19:20:53  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:03  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:06  kay
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

disp('[dataout]=mute(datain,mute_flg,headw1,headw2)');

if nargin==3
  headw2=headw1;
end

dataout=datain;
m=datain.fh{7};				%number of points per trace
a=0;					%multiplier for muting data

for COUNT=1:datain.fh{12}		%loop over records

	n=datain.th{COUNT}(12,1);	%number of traces in a record

%if statements to mute specified data
%mut_ind1 and mut_ind2 are the indexes (-1) corresponding to times in headw1 and headw2
%datain.th{COUNT}(headw1,i) is mute time 1
%datain.fh{9} is start time in seconds
%datain.fh{8} is sampling interval in seconds

	if mute_flg==1		%mute all data before time in headw1
	 for i=1:n
	   if datain.th{COUNT}(headw1,i)~=0
	     mut_ind1=round((datain.th{COUNT}(headw1,i)-datain.fh{9})/datain.fh{8});
	     dataout.dat{COUNT}(1:mut_ind1,i)=datain.dat{COUNT}(1:mut_ind1,i).*a;
	   end
	  end

	elseif mute_flg==2	%mute data after time in headw1
	  for i=1:n
	   if datain.th{COUNT}(headw1,i)~=0
	    mut_ind1=round((datain.th{COUNT}(headw1,i)-datain.fh{9})/datain.fh{8})+2;
	    dataout.dat{COUNT}(mut_ind1:m,i)=datain.dat{COUNT}(mut_ind1:m,i).*a;
	   end
	  end

	elseif mute_flg==3	%mute data before headw1 and after headw2
	 for i=1:n
	   if (datain.th{COUNT}(headw1,i)~=0 & datain.th{COUNT}(headw2,i)~=0)
	    mut_ind1=round((datain.th{COUNT}(headw1,i)-datain.fh{9})/datain.fh{8});
	    mut_ind2=round((datain.th{COUNT}(headw2,i)-datain.fh{9})/datain.fh{8})+2;
	    dataout.dat{COUNT}(1:mut_ind1,i)=datain.dat{COUNT}(1:mut_ind1,i).*a;
	    dataout.dat{COUNT}(mut_ind2:m,i)=datain.dat{COUNT}(mut_ind2:m,i).*a;
	   end
	  end

	else			%mute data between headw1 and headw2
	  for i=1:n
	   if (datain.th{COUNT}(headw1,i)~=0 & datain.th{COUNT}(headw2,i)~=0)
	    mut_ind1=round((datain.th{COUNT}(headw1,i)-datain.fh{9})/datain.fh{8})+2;
	    mut_ind2=round((datain.th{COUNT}(headw2,i)-datain.fh{9})/datain.fh{8});
    dataout.dat{COUNT}(mut_ind1:mut_ind2,i)=datain.dat{COUNT}(mut_ind1:mut_ind2,i).*a;
	   end
	  end
	end
end %loop over records
