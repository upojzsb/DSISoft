function [dataout]=stack2(datain)
dataout.fh{1}=datain.fh{12};
dataout.fh{7}=datain.fh{7};
dataout.fh{8}=datain.fh{8};
dataout.fh{9}=datain.fh{9};
dataout.fh{10}=datain.fh{10};
dataout.fh{12}=1;
dataout.fh{13}=datain.fh{12};

dataout.th{1}=zeros(64,dataout.fh{13});
dataout.th{1}(13,:)=1:dataout.fh{1};
dataout.th{1}(12,:)=dataout.fh{1};

for i=1:datain.fh{12}
   dataout.dat{1}(:,i)=sum(datain.dat{i}')';
end

for j=1:datain.fh{12}
   dataout.th{1}(43,j)=datain.th{j}(43,round(datain.fh{13}/2));
   dataout.th{1}(41,j)=datain.th{j}(41,round(datain.fh{13}/2));
end
