%Called by demo2 to perform median filtering

%energy balance the data
demodata=ener(demodata,0,1)

%pad it with about a second of zeros at the end
demodata=pad(demodata,0.5);
 
%flatten the data on first breaks
demodata=flat2(demodata,0.25,15);
 
%median filter the data
out2=medi_filt(demodata,13)
 
demodata=subr(out2,demodata) %subtract the median filtered data from the original data
 
demodata=unflat2(demodata,0.25,15); %unflatten the data
temp=demodata.th{1}(15,:);
temp=temp+0.005;
demodata.th{1}(16,:)=temp;
 
%demodata=mute(demodata,1,16); %mute out the first 5ms after the first breaks
 
%demodata=tred(demodata,-3732,0.25); %flatten on the shear wave
%out2=medi_filt(demodata,23)
%demodata=subr(out2,demodata); %remove the shear wave
%demodata=tred(demodata,3732,-0.25); %unflatten from the shear wave

%demodata=mute(demodata,1,16); %remute out the first 5ms after the first breaks
 
demodata=subset(demodata,1,103,0,1,1,1);

clear out2;
clear temp;

state=3;
disp('Median filtering has been applied.');
disp('Please apply f-k Filtering next.');

