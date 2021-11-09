%Called by demo2 to perform bandpass filtering

demodata=hannband(demodata,25,75,200,250)
demodata=mute(demodata,1,15)
demodata=agc(demodata,0.075,2);

state=5;
disp('Bandpass filtering has been applied to the data.');
disp('Processing is finished.');