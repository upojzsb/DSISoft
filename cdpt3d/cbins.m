function [dataout]=cbins(datain,v,strike,dip,records,width,binsize,depthlim)

%[dataout]=cbins(datain,v,strike,dip,records,width,binsize,depthlim)
%
%G. Perron
%March 1999
%

%finding plotting limits of source receiver geometry
minx=min(min([datain.th{1}(31,:) datain.th{1}(37,:)]))-50;
maxx=max(max([datain.th{1}(31,:) datain.th{1}(37,:)]))+50;

miny=min(min([datain.th{1}(29,:) datain.th{1}(35,:)]))-50;
maxy=max(max([datain.th{1}(29,:) datain.th{1}(35,:)]))+50;

%creating bin vector for depth
minz=min(depthlim);
maxz=max(depthlim);
zbin=[minz:binsize(3):maxz];

%plotting source information
plot(datain.th{1}(31,:),datain.th{1}(29,:),'ob');

hold on

%plotting receiver information
plot(datain.th{1}(37,:),datain.th{1}(35,:),'*r');
axis([minx maxx miny maxy]);
axis('equal');

%mouse input for bin limits
[px,py]=ginput(2);
plot(px,py,'sc');

%theta is the angle between the vertical and the s-r azimuth
theta=atan((px(2)-px(1))/(py(2)-py(1)))*180/pi;

%rotation of the picked points by theta
[pu,pv]=rotcoord(px,py,theta,px(1),py(1));


%creating xbin and ybin vectors
xbin=pu(1)-width:binsize(1):pu(1)+width;

%if statement to check if the 1st picked point is > or < than the 2nd
if pv(1)<pv(2)
   ybin=pv(1):binsize(2):pv(2);
else
   ybin=pv(1):-binsize(2):pv(2);
end

%setting record to work with
R=records;

%setting limits for bins and calling ccdp3d_v2 which calls findref3d.m
limits=[min(xbin) max(xbin) min(ybin) max(ybin) minz maxz];
[dataout,refpoints,t1,nshots]=cdp3d_v2(datain,v,strike,dip,binsize,records,limits);

%setting sampling rate variable
smp=dataout.fh{8};

dataout.fh{5}=theta;
dataout.fh{6}=[px(1) py(1)];



%setting output variable fields needed for slicing the foldmap
dataout.xsc=xbin;
dataout.ysc=ybin;
dataout.zsc=zbin;

%lines to plot bins and bin vectors
[X,Y]=meshgrid(xbin,ybin);

out=find(X==pu(1));
a=X(out)';
b=Y(out)';

out2=find(Y==pv(1));
c=X(out2)';
d=Y(out2)';


[Xu,Yv]=rotcoord(X,Y,-theta,pu(1),pv(1));
[xbinh,ybinh]=rotcoord(a,b,-theta,pu(1),pv(1));

[xbinv,ybinv]=rotcoord(c,d,-theta,pu(1),pv(1));

plot(Xu,Yv,'.m');
plot(xbinh,ybinh,'.k');
plot(xbinv,ybinv,'.k');

hold off

%initialisation of the foldmap
fmap=zeros(length(xbin),length(ybin),length(zbin));
%hits is used to normalise the amplitude of the foldmap
hits=fmap;

for n=1:nshots %loop over shots
   fs=find(refpoints{n}(:,5)==1); %first set of reflection points
   rpts=refpoints{n}(fs,:);
   
   %please put back to -theta after test
   [refu,refv]=rotcoord(rpts(:,1),rpts(:,2),theta,px(1),py(1));
	rpts(:,1)=refu;
   rpts(:,2)=refv;
   
      
   for i=1:size(rpts,1)
      %find bin associated with reflection points
      [z,f1]=min(abs(rpts(i,1)-xbin));
      [z,f2]=min(abs(rpts(i,2)-ybin));
      [z,f3]=min(abs(rpts(i,3)-zbin));
      
      %if statement to exclude out of dimension points
      if (round((rpts(i,4)-t1)/smp+1))>datain.fh{7}
         
      else
         amp=datain.dat{R}(round((rpts(i,4)-t1)/smp+1),n); 
         fmap(f1,f2,f3)=fmap(f1,f2,f3)+amp; %increment bin
         hits(f1,f2,f3)=hits(f1,f2,f3)+1; %increment bin
      end %(if)
   end %for i  
end %loop over n


%set zeros on hits to NaN
for a=1:size(hits,3)
   [i,j,v]=find(hits(:,:,a)==0);
   for b=1:length(i)
      hits(i(b),j(b),a)=NaN;
   end %for b
end %for a

%set dataout.fmap and normalize by number of hits to each bin
dataout.fmap{R}=fmap./hits;
for a=1:size(hits,3)
   [i,j,v]=find(isnan(hits(:,:,a)));
   for b=1:length(i)
      dataout.fmap{R}(i(b),j(b),a)=0;
   end %for b
end %for a


%end of cbins