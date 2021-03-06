function [dataout]=stack(datain)

%function [dataout]=stack2(datain)
%
%DSISoft function that stacks the output dataset
%from slicefmap and updates header word 43 (CDP Easting)
%and 41 (CDP Northing) with information from the bin in the 
%center of the stack axis
%
%Input - datain (output from slicefmap)
%Output - dataout a DSISoft variable that can be open
%in dispseis
%
%DSISoft Version 2.0
%Customized VSP Processing Software
%written by G. Perron May, 1999


%function call echo
disp('function [dataout]=stack(datain)');

%creating file hearder for dataout
dataout.fh{1}=datain.fh{12};
dataout.fh{7}=datain.fh{7};
dataout.fh{8}=datain.fh{8};
dataout.fh{9}=datain.fh{9};
dataout.fh{10}=datain.fh{10};
dataout.fh{12}=1;
dataout.fh{13}=datain.fh{12};

%initializing trace headers for dataout
dataout.th{1}=zeros(64,dataout.fh{13});
dataout.th{1}(13,:)=1:dataout.fh{1};
dataout.th{1}(12,:)=dataout.fh{1};

%stacking by looping over records
for i=1:datain.fh{12}
   dataout.dat{1}(:,i)=sum(datain.dat{i}')';
end

%updating CDP locations by looping over records
for j=1:datain.fh{12}
   dataout.th{1}(43,j)=datain.th{j}(43,round(datain.fh{13}/2));
   dataout.th{1}(41,j)=datain.th{j}(41,round(datain.fh{13}/2));
end

%end of stack