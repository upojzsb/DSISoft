function [str]=readascii(filename)

%function [str]=readascii(filename)
%
%This function reads an ascii file and creates
%a cell array of strings each cell representing
%a line
%
%filename should be ascii and should be called between single quotes
%
%DSI customized VSP processing software
%written by G. Perron, February, 1996

%$Id: readascii.m,v 3.0 2000/06/13 19:21:08 gilles Exp $
%$Log: readascii.m,v $
%Revision 3.0  2000/06/13 19:21:08  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:17  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:07  kay
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

fid=fopen(filename);
i=1;
while feof(fid)==0
   line=fgetl(fid);
   str(i)=cellstr(line);
   i=i+1;
end
fclose(fid);
