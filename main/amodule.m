%function [dataout]=amodule(datain,parameters)
%
%template for designing DSI processing modules
%
%DSIsoft ver 2.0
%DSI customized VSP processing software
%written by Kristen Beaty October, 1997

%$Id: amodule.m,v 3.0 2000/06/13 19:19:40 gilles Exp $
%$Log: amodule.m,v $
%Revision 3.0  2000/06/13 19:19:40  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:05  mah
%Release 2
%
%Revision 1.2  1999/05/19 20:58:45  mah
%*** empty log message ***
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

function [dataout]=amodule(datain,parameters)

disp('[dataout]=amodule(datain,parameters)');

%make necessary changes to file header

for COUNT=1:datain.fh{12}	%loop over records
	%manipulate data
	%make more changes to file header
	%make necessary changes to trace headers
end; %loop over records
