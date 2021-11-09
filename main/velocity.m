function dataout=velocity(datain,pltflg);
%dataout=velocity(datain);
%
%This function computes the average P-wave velocity of a DSI profile
%It does it by linear regression and by averaging direct 
%source-to-receiver distance/first break times
%
%Input variables:
%datain is a dsisoft variable sorted in 3-components (header word 4)
%pltflg is a plotting flag
%if pltflg = 1 there will be a graphic output
%if pltflg IS NOT 1 (else) that there will not be a graphical output
%
%Output variable:
%dataout is the updated dsisoft variable with the average velocity in header word 60

%$Id: velocity.m,v 3.0 2000/06/13 19:22:42 gilles Exp $
%$Log: velocity.m,v $
%Revision 3.0  2000/06/13 19:22:42  gilles
%*** empty log message ***
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
  
disp('dataout=velocity(datain);');

dataout=datain;
lasttrc=datain.fh{13};

%x positions
x1=datain.th{1}(31,:);
x2=datain.th{1}(37,:);

%y positions
y1=datain.th{1}(29,:);
y2=datain.th{1}(35,:);

%z positions
z1=datain.th{1}(33,:);
z2=datain.th{1}(39,:);

%travel time for each shot-receiver pair
tt=datain.th{1}(15,:);


%finding the mean velocity by linear regression
polyret=polyfit(dataout.th{1}(53,:),tt,1);
%velocity is the slope of the linear regression
vel=1/polyret(1);

%true shot-receiver offset
dataout.th{1}(53,:)=(sqrt((x2-x1).^2+(y2-y1).^2+(z2-z1).^2));
dataout.th{2}(53,:)=(sqrt((x2-x1).^2+(y2-y1).^2+(z2-z1).^2));
dataout.th{3}(53,:)=(sqrt((x2-x1).^2+(y2-y1).^2+(z2-z1).^2));

%p-wave velocities computed by dividing distances (offsets) by travel times
pvels=dataout.th{1}(53,:)./(tt-polyret(2));

%finding de mean velocity
meanvel=mean(pvels);


%vel=((dataout.th{1}(15,lasttrc)-dataout.th{1}(15,1))+polyret(2))/(dataout.th{1}(53,lasttrc)-dataout.th{1}(53,1));
%vel=1/vel

%if plotflag is 1 than produce figures
if pltflg==1
   
   %plot mean velocities
   figure(1)
   %plot(dataout.th{1}(53,:),pvels,'*-b')
   [ax,h1,h2]=plotyy(dataout.th{1}(53,:),pvels,dataout.th{1}(53,:),dataout.th{1}(15,:));
   hold on
   axes(ax(1));
   a=(dataout.th{1}(53,lasttrc))
   b=polyret(1)*(dataout.th{1}(53,lasttrc))+polyret(2)
   disp('allo')
   plot([0 a],[polyret(2) b],'-k')
	disp('allo')

   hax1=findobj(ax(1),'Type','line');
   set(hax1,'marker','.');
   
   
   plot(dataout.th{1}(53,:),ones(1,lasttrc).*meanvel,':r')
   
      
   xlabel('Source-Receiver Offset (m)')
   ylabel('P-Wave velocity (m/s)')
   axes(ax(2))
   hax2=findobj(ax(2),'Type','line');
   set(hax2,'marker','.');
   ylabel('First Break Pick Times (s)')
   eval(['title(''Average P-wave velocity: ',num2str(meanvel),' (m/s)'')'])
   grid
   hold off
   
   figure(2)
   plot(dataout.th{1}(53,:),tt,'.b')
   
   hold on
   a=(dataout.th{1}(53,lasttrc));
   b=polyret(1)*(dataout.th{1}(53,lasttrc))+polyret(2);
   
   plot([0 a],[polyret(2) b],'r')

   xlabel('Source-Receiver Offset(m)')
   ylabel('Time (s)')
   eval(['title(''Interpolated velocity: ',num2str(vel),' (m/s)'')']);
   eval(['gtext(''Shot Static: ',num2str(polyret(2)),' (s)'')']);

   grid on
   hold off
   
end

%assigning mean velocity to trace header 60
dataout.th{1}(60,:)=vel;
dataout.th{2}(60,:)=vel;
dataout.th{3}(60,:)=vel;
