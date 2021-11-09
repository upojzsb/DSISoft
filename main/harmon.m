function [dataout] = harmon(datain,freq1,freq2,inter)
%  function [dataout] = harmon(datain,freq1,freq2,inter)
%
%  Harmon is a time domain notch filter.  Discrete Fourier
%  Transforms are calculated to estimate noise phase and amplitude.
%  The estimated noise is subtracted from the trace in the time domain.
%
%  Usage:
%
%  	Input:
%		datain  : Input data
%		freq1   : Start scanning at this frequency (Hz)
%		freq2   : Upper frequency limit (Hz)
%		inter   : Frequency step (Hz)
%
%	Output:
%		dataout : Output data
%
%	Example :
%		This is what I use to remove 60 Hz noise
%		filtered = harmon(data,59.88,60.12,0.01);
%
%	Reference:
%	         http://www.cg.NRCan.gc.ca/staff/adam/software/monofreq.html
%
%written by:  Erick ADAM
%  Dec. 1995

%$Id: harmon.m,v 3.0 2000/06/13 19:20:28 gilles Exp $
%$Log: harmon.m,v $
%Revision 3.0  2000/06/13 19:20:28  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:45  mah
%Release 2
%
%Revision 1.2  1999/01/29 16:29:52  adam
%Updated to work with Dsisoft variables and add comments
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

disp('[dataout] = harmon(datain,freq1,freq2,inter)')
deltat=datain.fh{8};      %sampling interval in seconds
freq = freq1:inter:freq2; %Vector of frequencies for DFT
freqs = length(freq);     %Number of frequencies for DFT
samples = datain.fh{7};   %number of points per trace;

%Initialize local variables for speedup
cos_wt = ones(samples,freqs);   % Cosine lookup table
sin_wt = ones(samples,freqs);   % Sine lookup table
dataout = datain;               % Output variable
samp = (0.0 : deltat : (samples-1)*deltat)'; % Time vector

% Optimization : I create a lookup table for Sine and cosine.
for i = 1 : freqs,
	w = 6.283185307 * freq(i); % Convert frequency to radian (w = 2*PI*f)
	cos_wt(:,i)=cos(samp*w);   % Calculate cos(w*t) and store in lookup table
	sin_wt(:,i)=sin(samp*w);   % Calculate sin(w*t) and store in lookup table
end

% Calculate amplitudes from DFT at each frequencies of vector freq
for COUNT=1:datain.fh{12} % Loop over over number of records
	for tr=1:datain.th{COUNT}(12,1)  % loop over traces
 		large= 0.0; % Maximum amplitude (reset to 0 before each scan)
		for j = 1: freqs,  % Loop over frequencies
			trace = datain.dat{COUNT}(:,tr);
			suma = sum(trace .* cos_wt(:,j))* 2.0 /samples;
			sumb = sum(trace .* sin_wt(:,j))* 2.0 /samples;
			amp_max = (suma * suma) + (sumb * sumb); % Amplitude for freq(j)
			if(amp_max > large) % if Amplitude freq(j) is larger than previous ones
				freqi=j;   % record the index of the maximum amplitude  
				large = amp_max; % reset large
				a_max=suma;  % record factor A of the DFT
				b_max=sumb;  % record factor B of the DFT
			end % End if statement
		end % loop over frequency
                % The filter is applied here
	        dataout.dat{COUNT}(:,tr) = datain.dat{COUNT}(:,tr)-((a_max*cos_wt(:,freqi))+(b_max * sin_wt(:,freqi)));
	end % loop over traces
end % loop over records


