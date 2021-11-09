function [matfile]=ita2mat(fhfile,thfile,datfile);
%
%function [matfile]=ita2mat(fhfile,thfile,datfile);
%
%
%This function reads in the 3 output files from the
%ITA poststack module ita2mat and creates a datafile
%in the DSI processing software format.  The record
%structure of the ITA file is preserved in the process.
%
%fhfile = file header file
%thfile = trace header file
%datfile = data file
%
%The file names should be separated by commas
%and between single quotes (as strings)
%
%DSI customized VSP processing software
%written by Gervais Perron Feb. 1998

%$Id: ita2mat.m,v 3.0 2000/06/13 19:20:34 gilles Exp $
%$Log: ita2mat.m,v $
%Revision 3.0  2000/06/13 19:20:34  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:49  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:03  kay
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

disp('function [matfile]=ita2mat(fhfile,thfile,datfile)');

%loading files
eval(['load ',fhfile]);
fhfile=fhfile(1:length(fhfile)-4);
eval(['fhead=',fhfile,';']);

eval(['load ',thfile]);
thfile=thfile(1:length(thfile)-4);
eval(['thead=',thfile,';']);

eval(['load ',datfile]);
datfile=datfile(1:length(datfile)-4);
eval(['data=',datfile,';']);

%creating the file headers
for i=1:length(fhead)
   matfile.fh{i}=fhead(i);
end

%transposing the matrices
thead=thead';
data=data';

%getting the number of records in the file
%and looping to create the trace headers and data
count=1;
for j=1:matfile.fh{12}
   ntr=thead(12,count);
   matfile.th{j}=thead(:,count:(j*ntr));
   matfile.dat{j}=data(:,count:(j*ntr));
   count=count+ntr;
end
