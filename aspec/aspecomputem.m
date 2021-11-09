function [freq,db]=aspecomputem(datain,tr1,tr2,t1,t2,rec,pltflg)
%
%ASPEC draws the amplitude spectrum and the phase of a seismic record
%
%
%function [db]=aspec(data,data_dhm,win2,pltflg)
%
%INPUT VARIABLES
%data=		seismic data
%smp=		time sampling interval in sec
%win2=		vector containing the time and the trace window of the data to be analysed
%		format [trace1 trace2 time1 time2]
%pltflg= 	plotting parameter
%	1= amplitude in dB
%	2= amplitude
%	3= log10 of the amplitude
%
%OUTPUT VARIABLES
%db=	amplitude spectrum
%by G. Perron (3 Dec, 1996)

%$Id: aspecomputem.m,v 3.0 2000/06/13 19:17:50 gilles Exp $
%$Log: aspecomputem.m,v $
%Revision 3.0  2000/06/13 19:17:50  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:40:43  mah
%Release 2
%
%Revision 1.2  1999/03/18 16:12:18  mah
%fixed the bug of where mean would not work properly if only one trace is input
%
%Revision 1.1  1999/01/06 19:06:59  kay
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

smp=datain.fh{8};
t1=round((t1-datain.fh{9})./smp+1);
t2=round((t2-datain.fh{9})./smp+1);
tr=[tr1 tr2];
tr1=min(tr);
tr2=max(tr);

n=(t2-t1)+1;
rads=(180/pi);
rn2=round(n/2);

Y=zeros((t2-t1)+1,(tr2-tr1)+1);

  for i=tr1:tr2
    Y(:,i-tr1+1) = fft(datain.dat{rec}(t1:t2,i));
  end

avrg=mean(Y')';

%the following is added because mean does not work properly if one trace is input
[a,b]=size(avrg);
if a==1 & b==1
 avrg=Y;
end; %if

phase=atan(imag(avrg)./real(avrg));
phase=phase(1:rn2).*rads;

amp = abs(avrg(1:rn2));
db=20*log10(abs(amp));
nyquist = 1/(2*smp);
freq = (1:rn2)/rn2*nyquist;

if pltflg==1
   dbaxes=findobj(gcf,'Tag','Axes2');
   set(gcf,'CurrentAxes',dbaxes)

   plot(freq,db,'-b')
   xlabel('Frequency Hz')
   ylabel('Amplitude dB')
   title('Amplitude Spectrum')
   grid

elseif pltflg==2
   dbaxes=findobj(gcf,'Tag','Axes2');
   set(gcf,'CurrentAxes',dbaxes)

   plot(freq,amp/100,'-r')
   xlabel('Frequency Hz')
   ylabel('Amplitude')
   title('Amplitude Spectrum')
   grid

else
   dbaxes=findobj(gcf,'Tag','Axes2');
   set(gcf,'CurrentAxes',dbaxes)

   plot(freq,log10(amp),'-g')
   xlabel('Frequency Hz')
   ylabel('Amplitude')
   title('Amplitude Spectrum')
   grid
end

phaxes=findobj(gcf,'Tag','Axes3');
set(gcf,'CurrentAxes',phaxes)

plot(freq,phase,'-g')
xlabel('Frequency Hz')
ylabel('Phase degree')
title('Phase Spectrum')
grid on

