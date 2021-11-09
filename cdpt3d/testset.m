function [matfile]=testset(datain,nsamples);

%function [matfile]=testset(datain,nsamples);
%
% This function takes a representative sample of traces from DATAIN.
% NSAMPLES specifies how many traces are to be taken from datain, it
% should have a value of at least 3.
% The extracted sample traces are equally spaced.
% The code can probably be simplified (but it doesn't have to be!).
% 
% R.Zschuppe, July 1999

ntraces=datain.fh{13};
nrecords=datain.fh{12};

% Initialize File Header:
matfile.fh=datain.fh;
matfile.fh{1}=(nsamples*nrecords); % Number of traces contained in file
matfile.fh{13}=nsamples; % Maximum record fold

for rec=1:nrecords
   
   % Initialize first trace in the dataset:
   matfile.th{rec}(:,1)=datain.th{rec}(:,1); % 
   matfile.th{rec}(12,1)=nsamples;
   matfile.th{rec}(13,1)=1;
   matfile.dat{rec}(:,1)=datain.dat{rec}(:,1);
   
   % Initialize traces in between first and last trace
   for ii=2:(nsamples-1)
      count=(round(ntraces/nsamples))*(ii-1);
      matfile.th{rec}(:,ii)=datain.th{rec}(:,count);
      matfile.th{rec}(12,ii)=nsamples;
      matfile.th{rec}(13,ii)=count;
      matfile.dat{rec}(:,ii)=datain.dat{rec}(:,count);
   end
   
   % Initialize last trace in the dataset:  
   matfile.th{rec}(:,nsamples)=datain.th{rec}(:,ntraces);
   matfile.th{rec}(12,nsamples)=nsamples;  
   matfile.th{rec}(13,nsamples)=nsamples;
   matfile.dat{rec}(:,nsamples)=datain.dat{rec}(:,ntraces);

end


