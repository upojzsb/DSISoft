function [fmap,out]=solve3dv2(shot,rec,tt,v,strike,dip,plot_flg,bins,bound)

%[fmap,out]=solve3dv2(shot,rec,tt,v,strike,dip,plot_flg,bins,bound)
%
%identical to 'solve3D' except that calculation of reflection points is done
%by function 'findref3d'
%similar to 'refdip' (written by G. Perron) but works in 3 dimensions
%calculates reflection points in 3 dimensions and plots them
%uses function 'rotcoord'
%
%INPUT
%shot and rec  - are x,y,z matrices of position
%     shot 1 corresponds to rec 1, shot 2 to rec 2, etc.
%tt - is a vector of travel times (s)
%v - velocity of the waves (m/s)
%strike  - strike angle in degrees from North (or mine grid North)
%dip  - dip angle to the left, by convention, also in degrees
%plot_flg = 1 plots ray paths for reflections, = 2 plots fold map, otherwise
%     only the points are shown
%bins - a vector of number of bins in fold map in x, y, and z directions
%bound - a flag telling whether to plot layers corresponding to the reflection points
%
%OUTPUT
%fmap - a 3 dimensional array that is a fold map (shows how many reflection points fall into each bin)
%out - a cell array, where each cell corresponds to a shot-receiver pair, containing the reflection point coordinates
%
%DSISoft Version 1.0
%Customized VSP Processing Software
%written by K.S. Beaty November, 1997
%last modified July 24, 1998 (vectorized)


plot3(shot(:,1),shot(:,2),shot(:,3),'bo');
hold on;
plot3(rec(:,1),rec(:,2),rec(:,3),'bx');
[refpoints]=findref3d(shot,rec,tt,v,strike,dip);
nshot=size(shot,1);

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

for n=1:nshot
  %plot reflections that are below surface (z==0) unless a fold map is wanted
  if plot_flg~=2 
   xref=refpoints{n};
   plot3(xref(:,1),xref(:,2),xref(:,3), '.k'); %plot reflection points    
   if plot_flg==1
    for i=1:size(xref,1)
     ray=[shot(n,:);xref(i,1:3);rec(n,:)];
     plot3(ray(:,1),ray(:,2),ray(:,3),'m'); %plot rays
    end %for
   end %if
  end %if plot_flg~=2
  out{n}=xref; %save reflection points (x-y space) in cell array, one cell per shot-rec pair

%=============================================================================
end %loop over shots

%set limits
maxrz=max(rec(:,3));
minsz=min(shot(:,3));
zmax=(v*max(tt)-(maxrz-minsz))./2+maxrz;
limz=[minsz, zmax];
width=v*max(tt);
xcent=(mean(shot(:,1))+mean(rec(:,1)))/2;
limx=[xcent-width./2, xcent+width./2];
ycent=(mean(shot(:,2))+mean(rec(:,2)))/2;
limy=[ycent-width./2, ycent+width./2];
if plot_flg==2
 clf; %clear figure if foldmap is to be plotted
end %if
set(gca,'zlim',limz);
set(gca,'xlim',limx);
set(gca,'ylim',limy);

%---------------------------------------------------------------------------

if nargin==9 & plot_flg~=2 %plot boundary layers (optional) if not a fold map
 clear bound;
 set1=find(out{n}(:,5)==1);
 for n=1:nshot
  for i=1:length(set1) %plot only for first set of points
   bound{set1(i)}(1,1:3)=out{n}(set1(i),1:3);
   bound{set1(i)}(1,4)=strike;
   bound{set1(i)}(1,5)=dip;
  end %for
  plotbound(bound,10); %add boundaries to plot
 end %for
end %plot boundary layers

%---------------------------------------------------------------------------

%make fold map
if plot_flg==2 %make fold map
 zbins=(limz(1,2)-limz(1,1))/bins(3);
 xbins=ceil(width/bins(1));
 ybins=ceil(width/bins(2));
 
 fmap=zeros(xbins,ybins,zbins); %initialize foldmap

 for n=1:nshot %loop over shots
  %find bin associated with xref(k,:)
  f1=ceil(((xbins*bins(1)./2)+out{n}(:,1)-xcent)./bins(1));
  f2=ceil(((ybins*bins(2)./2)+out{n}(:,2)-ycent)./bins(2));
  f3=ceil(out{n}(:,3)./bins(3)); %assumes shot is at surface (z=0)
  for i=1:size(out{n},1)
   fmap(f1(i),f2(i),f3(i))=fmap(f1(i),f2(i),f3(i))+1; %increment bin
  end %for i  
 end %loop over shots
 disp('use imagesc or pcolor to display slices of fmap in 2D');

% imagesc(fmap,'YData', limy, 'Xdata', limx);
 mycolor=flipud(pink);
 colormap(mycolor);
 colorbar;
end %if ==2 make fold map

%---------------------------------------------------------------------------

%annotate plot
set(gca,'zdir','reverse');
xlabel('X - East/West (m)');
ylabel('Y - North/South (m)');
zlabel('Depth (m)');
if plot_flg==2
 title('Fold Map');
else 
 title('Ray Paths and Reflection Points');
end %if
grid on;
box on;
%axis equal;
hold off;

%end of function solve3D
