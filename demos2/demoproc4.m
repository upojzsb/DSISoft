%Called by demo2 to perform f-k filtering

load june16reject.mat; %loads in the rejection filter for the down going waves
demodata=fkfilt(demodata,june16reject,300,10,1,5,1); %fkfilt the 1st record

state=4;
disp('f-k filtering has been applied to the data.');
disp('Please apply Bandpass Filtering next.');
