function [y]=meanfilt(x,n)

%[y]=meanfilt(x,n)
%
%one dimensional mean filter based on MATLAB's MEDFILT1
%called by 'fkfilt' and GUI module 'fkpoly'
%
%INPUT
%x = vector to be mean filtered
%n = number of points to use in mean filter
%   odd n => y(k) is the mean of x( k-(n-1)/2 : k+(n-1)/2 )
%   even n => y(k) is the mean of x( k-n/2 : k+n/2-1 )
%
%OUTPUT
%y = mean filtered vector
%
%Customized VSP Processing Software
%written by K.S. Beaty July 1998

%$Id: meanfilt.m,v 3.0 2000/06/13 19:20:42 gilles Exp $
%$Log: meanfilt.m,v $
%Revision 3.0  2000/06/13 19:20:42  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:45:55  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:09:05  kay
%Initial revision
%
%
%Copyright (C) 1998 Seismology and Electromagnetic Section/
%Continental Geosciences Division/Geological Survey of Canada
%
%This library is free software; you can redistribute it and/or
%modify it under the terms of the GNU Library General Public
%License as published by the Free Software Foundation; either
%version 2 of the License, or (at your option) any later version.
%
%This library is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%Library General Public License for more details.
%
%You should have received a copy of the GNU Library General Public
%License along with this library; if not, write to the
%Free Software Foundation, Inc., 59 Temple Place - Suite 330,
%Boston, MA  02111-1307, USA.
%
%DSI Consortium
%Continental Geosciences Division
%Geological Survey of Canada
%615 Booth St.
%Ottawa, Ontario
%K1A 0E9
%
%email: dsi@cg.nrcan.gc.ca

xlen=length(x);
if rem(n,2)~=1   %n even
    m=n/2;
else
    m=(n-1)/2; %n odd
end %if/else
X = [zeros(1,m) x(:)' zeros(1,m)];
y = zeros(1,xlen);

indr=(0:n-1)';
indc=1:xlen;
ind=indc(ones(1,n),1:xlen)+indr(:,ones(1,xlen));
xx=reshape(X(ind),n,xlen);
y(1:xlen)=mean(xx);

if size(x,2)==1  %if x is a column vector, transpose
    y=y.';
end %if

