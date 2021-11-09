% Called by demo2 to load data

load demodata.mat
demodata=subset(demodata,1,103,0,1,1,1);
disp('demodata loaded')
disp('Please apply Electrical Noise Removal next.')
state=0;
