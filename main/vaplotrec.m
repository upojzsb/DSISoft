function vaplotrec(datain,t1,t2,tr1,tr2,scal,pltflg,scfact,color,headw,trcin,insec,filename)
%
%vaplotrec(datain,t1,t2,tr1,tr2,scal,pltflg,scfact,color,headw,trcin,insec,filename)
%
%This function creates a PostScript file of one file of a DSISoft variable 
%and all the records in file.  It uses the seisplot.m function for the first
%11 input parameters (up to tstart included).  Please refer to seisplot.m 
%for the description of these input variables.  vaplotrec.m lets you specify
%the number of traces/inch and inches/second.  vaplotrec.m also suggest the
%media on which to produce your plots
%This program very similiar to vaplot.m but plots all records at once
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
%filename - path and name of the output Postscript file to be created by vaplotrec.m
%
%Based on program written by G. Perron January 1999
%Written by Marko Mah February 1999

%
%$Id: vaplotrec.m,v 3.0 2000/06/13 19:22:41 gilles Exp $
%$Log: vaplotrec.m,v $
%Revision 3.0  2000/06/13 19:22:41  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:47:06  mah
%Release 2
%
%Revision 1.5  1999/05/17 17:19:33  mah
%fixed help message
%
%Revision 1.4  1999/05/07 15:10:38  mah
%fixed up help messages
%
%Revision 1.3  1999/02/11 22:07:01  eadam
%Fix problem with annotation of last trace and change margins
%
%Revision 1.2  1999/02/09 19:53:53  eadam
%Added option to output PCL files and changed margin for legal and letter size paper
%
%Revision 1.1  1999/02/04 20:47:20  mah
%Initial revision
%
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
disp('vaplotrec(datain,t1,t2,tr1,tr2,scal,pltflg,scfact,color,tstart,headw,trcin,insec,filename)');
disp(' ');

tstart=datain.fh{9}; %starting time of trace
smp=datain.fh{8}; %sampling rate in secs
nrec=datain.fh{12}; %number of records in the file
ysizepaper=0; % set the paper size in the y direction to zero
xsizepaper=0; % set the paper size in the x direction to zero
ystart=0.5; %sets the starting point to 0.5
yend=0; %sets the ending of the paper
xend=0; %sets the ending of the paper

figure;
%setting media type to C (17X22in)
set(gcf,'PaperType','C');
%turning off the display of the matlab figure of seisplot
set(gcf,'Visible','off');

for COUNT=nrec:-1:1
 axes

 %call to seisplot.  The amplitude scaling factor is obtained from record nrec.
 %The other two records are plotted with the same scaling factor.
 if COUNT == nrec
    [scaling_factor]=seisplot(datain.dat{COUNT},t1,t2,tr1,tr2,smp,scal,pltflg,scfact,color,tstart);
 else
    seisplot(datain.dat{COUNT},t1,t2,tr1,tr2,smp,scaling_factor,pltflg,1.0,color,tstart);
 end

 %deleting colorbar from plot
 if pltflg>=3
    color_hnd=findobj('Tag','Colorbar')
    delete(color_hnd)
 end

 %ask for title of current record
 messa='What is the title you want for record ';
 messb=num2str(COUNT);
 messc='? ';
 mess=[messa messb messc];
 titletxt=input(mess,'s');

 %adding title to plot
 eval(['title(','titletxt',')']);

 %defining the range of traces and time (in sec)
 ntrc=abs(tr2-tr1);
 timesec=abs(t2-t1);

 %getting the dimensions of the axes
 ysize=timesec*insec;
 xsize=(ntrc+2)/trcin;

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
 wd=round(datain.th{COUNT}(headw,num_xtl)');
 %convert new labels from trace headers(numbers) to strings
 str_wd=num2str(wd);
 %set the thick labels and the axis label
 set(gca,'XTickLabel',str_wd);
 xlabel(hwords{headw});

 %setting the units of the plot to inches
 set(gca,'Units','inches');
 %setting the dimensions of the axes to get the trc/in and in/sec specs
 set(gca,'Position',[0.5 ystart xsize ysize]);

 xend=max(xend,xsize+1.5);
 yend=ystart+ysize+1;

 ystart=ystart+ysize+1; %sets up ystart for the next plot

end %for COUNT

%display of filename and path
disp(' ');
disp('**************************************************')
disp('Output Postscript file is:')
eval(['disp(','filename',')'])


%setting the dimensions of the plot on paper
set(gcf,'PaperPosition',[0.5 0.5 xend yend]);

%display of plot size
disp('**************************************************')
eval(['disp(''Plot size is:' '   ',num2str(xend),' X ',num2str(yend),' inches'')']);
disp('**************************************************')
pcl_choice = 1;

%setting paper size and orientation and displaying info 
%for different sizes of plots
if (xend<=8.5) & (yend<=11)
   set(gcf,'PaperType','usletter');
   set(gcf,'PaperOrientation','portrait');
   disp('Paper size is: Letter');
   disp('Orientation is: Portrait');
   disp('**************************************************')

elseif (xend<=8.5) & (yend>=11) & (yend<=14)
   set(gcf,'PaperType','uslegal');
   set(gcf,'PaperOrientation','portrait');
   disp('Paper size is: Legal');
   disp('Orientation is: Portrait');
   disp('**************************************************')

elseif (xend>=8.5 & xend<=11 & yend<=8.5)
   set(gcf,'PaperType','usletter');
   set(gcf,'PaperOrientation','landscape');
   disp('Paper size is: Letter');
   disp('Orientation is: Landscape');
   disp('**************************************************')

elseif (xend>=11 & xend<=14 & yend<=8.5)
   set(gcf,'PaperType','uslegal');
   set(gcf,'PaperOrientation','landscape');
   disp('Paper size is: Legal');
   disp('Orientation is: Landscape')
   disp('**************************************************')

else
   disp('Dimensions are exceeding Legal size paper')
   disp('Please use Postertool to print this plot')
   disp('**************************************************')
   pcl_choice = 0;

end
if pcl_choice == 1
   %ask for pcl output
   mess='Would you like to output a PCL file (y=pcl,n=ps)? ';
   user_pcl_choice=input(mess,'s');
   if  user_pcl_choice == 'y' |  user_pcl_choice == 'Y'
      messa='The PCL file name is currently ';
      messb=filename ;
      messc=', would you like to change this name? (y or n) ';
      mess=[messa messb messc];
      newname_choice=input(mess,'s');
      if  newname_choice == 'y' |  newname_choice == 'Y'
         mess='Please enter the new name:';
         filename=input(mess,'s');
      end
      % create PCL file and close figure
      eval(['print -dljet3 'filename''])
      close all
   
   else
      %create postscript file and close figure
      eval(['print -dps 'filename''])
      close all
   end   %response from user
else
   %create postscript file and close figure
   eval(['print -dps 'filename''])
   close all
end   %response from user
