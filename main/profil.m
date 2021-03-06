function profil(datain)
%profil(datain)
%
%This module displays information about a data variable
%that has been set up in the official DSI data format.
%-similar to 'profile' in Insight
%
%INPUT
%datain - data in DSI format
%
%DSI customized VSP processing software
%written by Gervais Perron

%$Id: profil.m,v 3.0 2000/06/13 19:21:06 gilles Exp $
%$Log: profil.m,v $
%Revision 3.0  2000/06/13 19:21:06  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:16  mah
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

tic;
disp(' ');
disp('****************************************************************');
disp('DSI Customized Vertical Seismic Profile Processing Software');
disp('Program: profil');
disp('Version 1');
disp('designed to work on MATLAB5');
disp(date);
disp('****************************************************************');
disp(' ');
disp(' ');
num_trc=datain.fh{1};	%number of traces in file
smp_int=datain.fh{8};	%sampling interval(s)
s_time=datain.fh{9};	%start time (s)
e_time=datain.fh{10};	%end time (s)
nrec=datain.fh{12};	%number of records in file
f_trc=datain.th{1}(1,1);	%first trace number
nrtl=datain.th{nrec}(12,1);	%number of traces in last record
l_trc=datain.th{nrec}(1,nrtl);	%last trace number

%calculate average values of first and last traces
avgft=mean(abs(datain.dat{1}(:,1)));
avglt=mean(abs(datain.dat{nrec}(:,nrtl)));

%display values on screen

disp('**********************************************************')
%eval(['disp(''data variable			=		',data_var,''')'])
disp(['number of traces in dataset	=		',num2str(num_trc)])
disp(['number of records in dataset	=		',num2str(nrec)])
disp(['sampling interval (s)		=		',num2str(smp_int)])
disp(['start time (s)			=		',num2str(s_time)])
disp(['end time (s)			=		',num2str(e_time)])
disp('**********************************************************')
disp(['first trace #			=		',num2str(f_trc)])
disp(['first trace average abs value	=		',num2str(avgft)])
disp(' ')
disp(['last trace #			=		',num2str(l_trc)])
disp(['last trace average abs value	=		',num2str(avglt)])
disp('**********************************************************')

disp(['elapsed time: ', num2str(toc)]);
disp(' ');
