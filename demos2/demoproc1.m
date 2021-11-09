% called by demo2 to perform electrical noise removal

% the following removes the harmonics from the data
% we will use harmon_new on the data by analyzing the last
% second of data because in general there is no signal present there

demodata=harmon_new(demodata,299,301,0.01,0,0.6); %removes 300Hz
demodata=harmon_new(demodata,538,542,0.01,0,0.6); %removes 540Hz
state=1;
disp('Removed 300Hz and 540Hz harmonics')
disp('Please apply Predictive Deconvolution next.')
