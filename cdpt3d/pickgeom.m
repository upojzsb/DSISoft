function [pts]=pickgeom(datain,npts,dist)

%finding plotting limits of source receiver geometry +50 meters on each side
minx=min(min([datain.th{1}(31,:) datain.th{1}(37,:)]))-dist;
maxx=max(max([datain.th{1}(31,:) datain.th{1}(37,:)]))+dist;

miny=min(min([datain.th{1}(29,:) datain.th{1}(35,:)]))-dist;
maxy=max(max([datain.th{1}(29,:) datain.th{1}(35,:)]))+dist;

%plotting source information
plot(datain.th{1}(31,:),datain.th{1}(29,:),'ob');

hold on

%plotting receiver information
plot(datain.th{1}(37,:),datain.th{1}(35,:),'*r');
axis([minx maxx miny maxy]);
axis('equal');

%mouse input for along S-R azimuth bin limits
[px,py]=ginput(npts);
pts=[px py];
plot(px,py,'+k');

