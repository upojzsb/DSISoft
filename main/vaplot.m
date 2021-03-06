function vaplot(datain,t1,t2,tr1,tr2,scal,pltflg,scfact,color,headw,trcin,insec,rec,outflg,filename,titletxt)
%
%vaplot(datain,t1,t2,tr1,tr2,scal,pltflg,scfact,color,headw,trcin,insec,rec,outflg,filename,titletxt)
%
%This function creates a PostScript file of one record of a DSISoft variable.  It uses the seisplot.m 
%function for the first 11 input parameters (up to tstart included).  Please refer to seisplot.m for
%the description of these input variables.  Vaplot.m lets you specify the number of traces/inch and 
%inches/second.
%Vaplot.m also suggest the media on which to produce your plots
%
%INPUT VARIABLES
%datain - input data
%t1 - start time of data to be displayed
%t2 - end time of data to be displayed
%tr1 - first trace to be displayed
%tr2 - last trace to be displayed
%scal - 1 for max, 0 for ave
%pltflg - 1 plot only filled peaks, 0 plot wiggle traces and filled peaks,
%2 plots wiggle traces only and 3 or more plots grayscale image
%scfact - scaling factor
%color - trace colour 
%headw - header word to be annotated
%trcin - traces per inch
%insec - inches per second
%rec - record of the DSISoft variable to be ploted
%outflg - format of the output file 0==postscript 1==pcl 2==eps
%filename - path and name of the output Postscript file to be created by vaplot.m
%titletxt - text for plot title
%
%Written by G. Perron January 21st, 1999

%
%$Id: vaplot.m,v 3.0 2000/06/13 19:22:38 gilles Exp $
%$Log: vaplot.m,v $
%Revision 3.0  2000/06/13 19:22:38  gilles
%Release 3
%
%Revision 2.1  2000/06/13 15:57:32  gilles
%*** empty log message ***
%
%Revision 2.0  1999/05/21 18:47:04  mah
%Release 2
%
%Revision 1.6  1999/05/17 17:18:40  mah
%fixed help message
%
%Revision 1.5  1999/05/07 15:05:03  mah
%fixed up help messages
%
%Revision 1.4  1999/02/11 22:05:25  eadam
%Fix problem with annotation of last trace and change margins as well
%as some header word input (i.e. smp and tstart) which are now
%extracted from the file header
%
%Revision 1.3  1999/02/03 20:11:46  perron
%Added new outflg variable to let the user choose
%between PCL and Postscript output format
%(PCL prints much faster)
%
%Revision 1.2  1999/01/21 18:29:16  perron
%Modified help text and annotations
%
%Revision 1.1  1999/01/21 17:15:56  perron
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


%setting string array for xlabels
hwords{1}='Original trace number';
hwords{2}='FFID';
hwords{3}='CDP Number';
hwords{4}='Recording component';
hwords{5}='Angle of rotation (deg)';
hwords{6}='Trace status';
hwords{7}='Trace polarity';
hwords{8}='Original channel number';
hwords{9}='Shot-receiver azimuth (deg)';
hwords{10}='Currently unused';
hwords{11}='Currently unused';
hwords{12}='Number of traces in record';
hwords{13}='Trace number within record';
hwords{14}='Bit mask for picks';
hwords{15}='Pick times 1 (sec)';
hwords{16}='Pick times 2 (sec)';
hwords{17}='Pick times 3 (sec)';
hwords{18}='Pick times 4 (sec)';
hwords{19}='Pick times 5 (sec)';
hwords{20}='Elevation static shift (sec)';
hwords{21}='Refraction shot static (sec)';
hwords{22}='Refraction receiver static (sec)';
hwords{23}='Residual shot static (sec)';
hwords{24}='Refraction receiver static (sec)';
hwords{25}='Trim static (sec)';
hwords{26}='Shot point number';
hwords{27}='Receiver point number';
hwords{28}='Shot-receiver offset (m)';
hwords{29}='Source northing (m)';
hwords{30}='Currently unused';
hwords{31}='Source easting (m)';
hwords{32}='Currently unused';
hwords{33}='Source elevation (m)';
hwords{34}='Currently unused';
hwords{35}='Receiver northing (m)';
hwords{36}='Currently unused';
hwords{37}='Receiver easting (m)';
hwords{38}='Currently unused';
hwords{39}='Receiver elevation (m)';
hwords{40}='Currently unused';
hwords{41}='CDP northing (m)';
hwords{42}='Currently unused';
hwords{43}='CDP easting (m)';
hwords{44}='Currently unused';
hwords{45}='CDP elevation (m)';
hwords{46}='Currently unused';
hwords{47}='CMP northing (m)';
hwords{48}='Currently unused';
hwords{49}='CMP easting (m)';
hwords{50}='Currently unused';
hwords{51}='Datum elevation (m)';
hwords{52}='Replacement velocity (m/s)';
hwords{53}='Source-to-receiver offset (m)';
hwords{54}='Shot depth (m)';
hwords{55}='Uphole time (sec)';
hwords{56}='Wireline depth (m)';
hwords{57}='Total residual shot static (sec)';
hwords{58}='Total residual receiver static (sec)';
hwords{59}='Ray parameter';
hwords{60}='Stack fold';
hwords{61}='Total datum static (sec)';
hwords{62}='Total refraction shot static (sec)';
hwords{63}='Total residual receiver static (sec)';
hwords{64}='Total static (sec)';

%echo of function call
disp(' ');
disp('vaplot(datain,t1,t2,tr1,tr2,scal,pltflg,scfact,color,headw,trcin,insec,rec,outflg,filename,titletxt)');
disp(' ');

%call to seisplot
smp=datain.fh{8};
tstart=datain.fh{9}; %start time in second
seisplot(datain.dat{rec},t1,t2,tr1,tr2,smp,scal,pltflg,scfact,color,tstart);

%deleting colorbar from plot
if pltflg>=3
   color_hnd=findobj('Tag','Colorbar')
   delete(color_hnd)
end

%adding title to plot
eval(['title(','titletxt',')']);

%turning off the display of the matlab figure of seisplot
set(gcf,'Visible','off');

%defining the range of traces and time (in sec)
ntrc=abs(tr2-tr1);
timesec=abs(t2-t1);

%getting the dimensions of the axes
ysize=timesec*insec;
xsize=(ntrc+2)/trcin;

if outflg==0
   %display of filename and path
   disp(' ');
   disp('**************************************************')
   disp('Output Postscript file is:')
   eval(['disp(','filename',')'])
elseif outflg==1
   %display of filename and path
   disp(' ');
   disp('**************************************************')
   disp('Output PCL file is:')
   eval(['disp(','filename',')'])
end

%setting media type to C (17X22in)
set(gcf,'PaperType','C');
%setting the dimensions of the plot on paper
set(gcf,'PaperPosition',[0.5 0.5 (xsize+1) (ysize+1)]);
%setting the units of the plot to inches
set(gca,'Units','inches');
%setting the dimensions of the axes to get the trc/in and in/sec specs
set(gca,'Position',[0.5 0.5 xsize ysize]);

%display of plot size
disp('**************************************************')
eval(['disp(''Plot size is:' '   ',num2str(xsize),' X ',num2str(ysize),' inches'')']);
disp('**************************************************')



%setting paper size and orientation and displaying info 
%for different sizes of plots
if			(xsize<=8.5) & (ysize<=11)
   set(gcf,'PaperType','usletter');
   set(gcf,'PaperOrientation','portrait');
   disp('Paper size is: Letter');
   disp('Orientation is: Portrait');
   disp('**************************************************')

elseif	(xsize<=8.5) & (ysize>=11) & (ysize<=14)
   set(gcf,'PaperType','uslegal');
   set(gcf,'PaperOrientation','portrait');
   disp('Paper size is: Legal');
   disp('Orientation is: Portrait');
   disp('**************************************************')

elseif	(xsize>=8.5 & xsize<=11 & ysize<=8.5)
   set(gcf,'PaperType','usletter');
   set(gcf,'PaperOrientation','landscape');
   disp('Paper size is: Letter');
   disp('Orientation is: Landscape');
   disp('**************************************************')

elseif   (xsize>=11 & xsize<=14 & ysize<=8.5)
   set(gcf,'PaperType','uslegal');
   set(gcf,'PaperOrientation','landscape');
   disp('Paper size is: Legal');
   disp('Orientation is: Landscape')
   disp('**************************************************')

else
   disp('Dimensions are exceeding Legal size paper')
   disp('Please use Postertool to print this plot')
   disp('**************************************************')

end
   
%getting X axis Thick Labels which refers to trace number
xtl=get(gca,'XTickLabel');
%converting labels to numbers
num_xtl=str2num(xtl);
%if label refers to trace 0 change it to 1
%and do the same for thick position
if num_xtl(1)==0
   num_xtl(1)=1;
   xmarks=get(gca,'XTick');
   xmarks(1)=1;
   set(gca,'XTick',xmarks);
end
if num_xtl(size(num_xtl,1))>tr2
   num_xtl(size(num_xtl,1))=tr2;
   xmarks=get(gca,'XTick');
   xmarks(size(xmarks,2))=tr2;
   set(gca,'XTick',xmarks);
end
%round labels when needed
wd=round(datain.th{rec}(headw,num_xtl)');
%convert new labels from trace headers(numbers) to strings
str_wd=num2str(wd);
%set the thick labels and the axis label
set(gca,'XTickLabel',str_wd);
xlabel(hwords{headw});

if outflg==0
   %create postscript file and close figure
   eval(['print -dps 'filename''])
   close all
elseif outflg==1
   %create pcl file and close figure
   eval(['print -dljet3 'filename''])
   close all
elseif outflg==2
   % create eps file and close
   eval(['print -deps 'filename''])
   close all
else
   disp('Please verify if your outflg is either 2, 1 or 0');
end
   
