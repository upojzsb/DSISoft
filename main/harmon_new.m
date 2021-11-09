function [dataout] = harmon_new(datain,freq1,freq2,inter,t1,t2)
%  function [dataout] = harmon_new(datain,freq1,freq2,inter,t1,t2)
%
%  Harmon is a time domain notch filter.  Discrete Fourier
%  Transforms are calculated to estimate noise phase and amplitude.
%  The estimated noise is subtracted from the trace in the time domain.
%  It has been rewritten to analyze a window of data from t1 to t2
%  and then to apply it to the whole trace
%
%  Usage:
%
%  	Input:
%		datain  : Input data
%		freq1   : Start scanning at this frequency (Hz)
%		freq2   : Upper frequency limit (Hz)
%		inter   : Frequency step (Hz) such that ((freq2-freq1)/inter) is
%                          a multiple of 10
%               t1      : Start time of window (seconds)
%               t2      : End time of window (seconds)
%
%	Output:
%		dataout : Output data
%
%	Example :
%		This is what I use to remove 60 Hz noise
%		filtered = harmon_new(data,59.88,60.12,0.01,0,0.5);
%
%	Reference:
%	         http://www.cg.NRCan.gc.ca/staff/adam/software/monofreq.html
%
% Warning: Program does not check for reasonable parameters
%
%written by:  Erick ADAM
%Dec. 1995
%Rewritten by Marko Mah February 1999


%$Id: harmon_new.m,v 3.0 2000/06/13 19:20:30 gilles Exp $
%$Log: harmon_new.m,v $
%Revision 3.0  2000/06/13 19:20:30  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:46  mah
%Release 2
%
%Revision 1.10  1999/02/10 20:47:00  mah
%fixing up bugs previous programmer(s) put in
%
%Revision 1.9  1999/02/10 20:11:36  perron
%*** empty log message ***
%
%Revision 1.8  1999/02/10 20:07:19  perron
%modifying if statement at line 119
%
%Revision 1.7  1999/02/10 20:04:11  perron
%Modifying if statement at line 119
%
%Revision 1.6  1999/02/10 19:52:34  perron
%Modifying help text
%
%Revision 1.5  1999/02/10 16:15:19  eadam
%Optimisation by iterative windowing fro finding the maximum
%
%Revision 1.4  1999/02/10 13:50:49  mah
%fixed bug
%
%Revision 1.3  1999/02/02 15:55:12  mah
%corrected amplitude of correction
%
%Revision 1.2  1999/02/02 15:07:07  mah
%fixed a bug
%
%Revision 1.1  1999/02/02 14:20:47  mah
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

disp('[dataout] = harmon_new(datain,freq1,freq2,inter,t1,t2)')
deltat=datain.fh{8};      %sampling interval in seconds
freq = freq1:inter:freq2; %Vector of frequencies for DFT
freqlen = length(freq);     %Number of frequencies for DFT 
samples = datain.fh{7};   %number of points per trace;
% the following converts t1 and t2 to points
t1pt=round(t1/deltat)+1;
t2pt=round(t2/deltat)+1;

%Initialize local variables for speedup
cos_wt = ones(samples,freqlen);   % Cosine lookup table
sin_wt = ones(samples,freqlen);   % Sine lookup table
dataout = datain;               % Output variable
samp = (0.0 : deltat : (samples-1)*deltat)'; % Time vector

% Optimization : I create a lookup table for Sine and cosine.
for i = 1 : freqlen,
	w = 6.283185307 * freq(i); % Convert frequency to radian (w = 2*PI*f)
	cos_wt(:,i)=cos(samp*w);   % Calculate cos(w*t) and store in lookup table
	sin_wt(:,i)=sin(samp*w);   % Calculate sin(w*t) and store in lookup table
end

%step = 10; 

% Calculate amplitudes from DFT at each frequencies of vector freq
for COUNT=1:datain.fh{12} % Loop over over number of records
 for tr=1:datain.th{COUNT}(12,1)  % loop over traces
  step = floor(freqlen/10);   % Speedup to calculate DFT for every 10th frequencies 
  large= 0.0; % Maximum amplitude (reset to 0 before each scan)
  trace = datain.dat{COUNT}(t1pt:t2pt,tr);
  start_freq = 1;         % start at the first frequency
  end_freq = freqlen;     % End at the last frequency 

  if step >= 1 	  % loop until every frequency is read

   for j = start_freq:step:end_freq,  % Loop over frequency range 
    suma = sum(trace.*cos_wt(t1pt:t2pt,j))* 2.0 /samples;
    sumb = sum(trace.*sin_wt(t1pt:t2pt,j))* 2.0 /samples;
    amp_max = (suma*suma)+(sumb*sumb); %Amplitude for freq(j)

    if amp_max > large %if Amplitude freq(j) is larger than previous ones
     freqi=j; %record the index of the maximum amplitude  
     large = amp_max; % reset large
     a_max=suma;  %record factor A of the DFT
     b_max=sumb;  %record factor B of the DFT
    end % End if statement

   end % loop over frequency

   start_freq = (freqi-2)*step; % New frequency range as a function of the maximum amplitude
   end_freq = (freqi-2)*step;
   step = floor(step/10);  % reduce the step by a factor of 10
  end % End if statement
 % the following corrects a_max and b_max because a smaller window was used to calculate them
 a_max=a_max*samples/(t2pt-t1pt+1);
 b_max=b_max*samples/(t2pt-t1pt+1);
 % The filter is applied here
 dataout.dat{COUNT}(:,tr) = datain.dat{COUNT}(:,tr)-((a_max*cos_wt(:,freqi))+(b_max * sin_wt(:,freqi)));
 end % loop over traces
end % loop over records


