function [datatot]=qc_dsi(datain,headw1,tstart,tend,comp1,comp2)
%
% Please note: Software does not check for reasonable parameters or dead traces
%
%
%by G. Perron (Nov 15th, 1996)
%
%based on rot3c_dirp from S. Guest and D. Eaton+

%$Id: qc_dsi.m,v 3.0 2000/06/13 19:17:59 gilles Exp $
%$Log: qc_dsi.m,v $
%Revision 3.0  2000/06/13 19:17:59  gilles
%*** empty log message ***
%  
%
%Copyright (C) 1998 Seismology and Electromagnet+ic Section/
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

datarot=rot3c(datain,headw1,tstart,tend,comp1,comp2);

disp('angle rot:');
datarot.th{1}(5,:)
disp('S2R azimuth:');
datarot.th{1}(9,:)

for i=1:datarot.fh{13}
     if (datarot.th{1}(9,i) <= 180)
        datarot.th{1}(9,i)=360-(180-datarot.th{1}(9,i));
        datarot.th{2}(9,i)=datarot.th{1}(9,i);
        datarot.th{3}(9,i)=datarot.th{1}(9,i);
     else
        datarot.th{1}(9,i)=(datarot.th{1}(9,i)-180);
        datarot.th{2}(9,i)=datarot.th{1}(9,i);
        datarot.th{3}(9,i)=datarot.th{1}(9,i);
      end	
  
      if datarot.th{1}(9,i)-datarot.th{1}(5,i)<=0
        h1pos(i)=(360-datarot.th{1}(5,i))+datarot.th{1}(9,i);
      else
        h1pos(i)=datarot.th{1}(9,i)-datarot.th{1}(5,i);
   end
end


sroff=datarot.th{1}(53,:);
%sroff=sqrt(((datarot.th{1}(29,:)-datarot.th{1}(35,:)).^2) + ((datarot.th{1}(31,:)-datarot.th{1}(37,:)).^2));
sraz=datain.th{1}(9,:);
relev=datarot.th{1}(39,:);

seisdata=datain;

disp('[dataout]=qc_dsi(datain,headw1,tstart,tend,comp1,comp2)');

w=pi/180;

trclength=datain.fh{7}; %number of points per trace
smpint=datain.fh{8}; %smpint is the sampling interval
%dataout=datain;

%check to make sure data is separated into components

%ntr is the number of traces in each record

for COUNT=3:-1:1 %get number of traces in each component
	ntr(COUNT)=datain.th{COUNT}(12,1);
end %for

if (ntr(1)~=ntr(2)) | (ntr(1)~=ntr(3))
	error('check data format - different number of traces in components');
end%if

if length(datain.dat)~=3
	error('data must have only 3 records - one for each of x, y and z');
end %if

%*************************************************************************
%create a look-up table of sin and cos values
for COUNT=0:360
   cosang(COUNT+1)=cos(COUNT*w);
   sinang(COUNT+1)=sin(COUNT*w);
end %for COUNT

ntr=ntr(1);
angmx(1:ntr)=0; %initialize angmx vector for storing rotation angles


sheet=qcsheet;
%hold on
hr=findobj(sheet,'Tag','rotations');
ha=findobj(sheet,'Tag','amplitudes');
hs{1}=findobj(sheet,'Tag','seis1');
hs{2}=findobj(sheet,'Tag','seis2');
hs{3}=findobj(sheet,'Tag','seis3');
hs{4}=findobj(sheet,'Tag','seis4');
hs{5}=findobj(sheet,'Tag','seis5');
hpol=findobj(sheet,'Tag','Polar1');


a={'-r','-g','-b','-m','-k','-c'};
b={'*r','*g','*b','*m','*k','*c'};
c={'-*r','-*g','-*b','-*m','-*k','-*c'};

ledg=num2str(datain.th{1}(26,:)');

seisdata=sortrec_new(seisdata,13);
datarot=sortrec_new(datarot,13); 
datatot=seisdata;

for i=1:datatot.fh{12}
   datatot.dat{i}(:,4:6)=datarot.dat{i}(:,:);
   datatot.th{i}(:,4:6)=datarot.th{i}(:,:);
   datatot.th{i}(12,:)=datatot.th{i}(12,:)+3;
end

datatot.fh{1}=datatot.fh{1}*2;
datatot.fh{13}=datatot.fh{13}+3;


for COUNT1=1:ntr
 samp1=round((datain.th{1}(headw1,COUNT1)-datain.fh{9})/smpint)-round(tstart/smpint)+1; %calulates start of interval to be analyzed
 samp2=round((datain.th{1}(headw1,COUNT1)-datain.fh{9})/smpint)+round(tend/smpint)+1; %calulates end of interval to be analyzed

 %this following loops over specified angles and returns the angle within
 %those specified that maximizes the radial component

 cmax=0; %initializing the max. energy of a component

 datawin=samp1:samp2; %the window over which the data is to be analyzed 
 lendatawin=length(datawin); %length of the data window
 xy=[datain.dat{comp1}(datawin,COUNT1), datain.dat{comp2}(datawin,COUNT1)]; %the window of data to be analyzed
 z=datain.dat{3}(datawin,COUNT1);
 
 tr1=1;
 tr2=6;
 t1=(samp1*seisdata.fh{8});
 t2=(samp2*seisdata.fh{8});
 smp=seisdata.fh{8};
 datarotin=subset(datatot,tr1,tr2,t1,t2,COUNT1,COUNT1);
  

 vert=sum(z.*z);
 horiz1=sum(xy(:,1).*xy(:,1));
 horiz2=sum(xy(:,2).*xy(:,2));
 horiztot=horiz1+horiz2;
 ratio(COUNT1)=sroff(COUNT1)/relev(COUNT1);
 ratio_obs(COUNT1)=horiztot/vert;
 allamps=[horiz1 horiz2 vert horiztot];

 rt=zeros(lendatawin,2);
 
 axes(hs{COUNT1});
 hold on
 plot(datarotin.th{1}(15,:),'.r');

 seisplot2(datarotin.dat{1},t1,t2,1,6,smp,1,0,1,a{COUNT1},t1);

 for COUNT2=0:359 %checks from 0 to 90 degrees

  %the following applies the rotation matrix and sums over each component
  rt(:,1)=xy(:,1)*cosang(COUNT2+1)+xy(:,2)*sinang(COUNT2+1);
  rt(:,2)=-xy(:,1)*sinang(COUNT2+1)+xy(:,2)*cosang(COUNT2+1);
  c1rms=sum(rt(:,1).*rt(:,1));
  c1rms2(COUNT2+1)=c1rms;
  c2rms=sum(rt(:,2).*rt(:,2));
  c2rms2(COUNT2+1)=c2rms;
  ang(COUNT2+1)=COUNT2;


end %for COUNT2

ang=datain.th{1}(9,COUNT1)-ang;

for i=1:length(ang)
if ang(i) <= 0
   ang(i)=360+ang(i);
end
end
l=find(c1rms2==max(c1rms2));
w=[ang' c1rms2'];
w=sortrows(w,1);


axes(hr)
hold on
semilogy(w(:,1),w(:,2),a{COUNT1});
xlabel('Azimuth of H2')
ylabel('RMS Amplitude')
box on
grid on 


axes(ha)
hold on
semilogy(allamps,c{COUNT1})
hold on
xlabel('H1 H2 Z Htot')
ylabel('RMS Amplitude')
box on
grid on 


end %for COUNT1
axes(hr)
legend(ledg(1),ledg(2),ledg(3),ledg(4),ledg(5));
%legend(ledg)
%hold off

h1pos
compinfo=[h1pos' round(sroff)' [1 2 3 4 5]' round(sraz)'];
cinfosort=sortrows(compinfo,2);
fcisort=flipud(cinfosort);

for i=1:datarot.fh{12}
   axes(hpol);
   newplot;
   fcisort(i,1)=fcisort(i,1).*pi/180;
   [x,y]=pol2cart(fcisort(i,1),fcisort(i,2));
   theta=fcisort(i,4)*(pi/180)+pi;
   rho=fcisort(i,2);

   compass(x,y,a{fcisort(i,3)});
   hold on
   polar(theta,rho,b{fcisort(i,3)});
   hold on
end
set(gca,'view',[90 -90]);
h=num2str(datain.th{1}(56,1));
suptitle(['Level ',h])

%hratio=figure(2);
%plot(ratio,'-*r')
%hold on
%plot(ratio_obs,'-*b')
%xlabel('Trace Number')
%ylabel('HSUM/VERT')
%grid on
%legend(gca,'Theorical Amplitude Ratio','Observed Amplitude Ratio');
