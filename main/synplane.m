function [dataout]=synplane(datain,dip,strike,pE,pN,pElev,v,cf)

% [dataout]=synplane(datain,dip,strike,pE,pN,pElev,v,cf)
% Synthetic travel times (no amplitude info) assuming medium with a constant 
% velocity v for the direct arrival and the arrival from a plane with given 
% dip and strike (in degrees), containing the specified point at [pE;pN;pElev].
% Datain is a DSI variable.  The source and receiver positions for each trace 
% in datain are used along with p, dip,
% strike, v and cf to calculate travel time curves.  
% cf is the centre frequency of a Ricker wavelet convolved with the synthetic.
%DSI customized VSP processing software
%by I. Kay (April 1999)
 
%$Id: synplane.m,v 3.0 2000/06/13 19:22:15 gilles Exp $
%$Log: synplane.m,v $
%Revision 3.0  2000/06/13 19:22:15  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:46:46  mah
%Release 2
%
%Revision 1.1  1999/04/15 16:42:18  kay
%Initial revision
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



%make a ricker wavelet
tw=-1/cf:datain.fh{8}:1/cf;
arg=(pi*cf*tw).^2;
w=(1-2.*arg).*exp(-arg);

p=[pE; pN; pElev];
dataout=datain;
nrec=datain.fh{12};
tstart=datain.fh{9};
tend=datain.fh{10};
for irec=1:nrec
   [nsamp,ntr]=size(datain.dat{irec});
   trace_data=zeros(size(datain.dat{irec}));
	for itr=1:ntr  % for each trace
      s=[datain.th{irec}(31,itr);
         datain.th{irec}(29,itr);
         datain.th{irec}(33,itr)];
      r=[datain.th{irec}(37,itr);
         datain.th{irec}(35,itr);
         datain.th{irec}(39,itr)];
      td=txdirect(s,r,v);
      tp=txplane(s,r,p,dip,strike,v);
      if td >= tstart & td <= tend
   		tdsamp= floor( (td-tstart)/datain.fh{8}+1 );
      	trace_data(tdsamp,itr)=1;
      end
      if tp > td & tp <=tend
         tpsamp=floor( (tp-tstart)/datain.fh{8}+1 );
         trace_data(tpsamp,itr)=1;
      end
      s=conv(trace_data(:,itr),w);
  		s=s(floor(length(tw)/2):floor(length(tw)/2)+nsamp-1);
   	trace_data(:,itr)=s;

   end %loop over traces in record
      dataout.dat{irec}=trace_data;
end %loop over records
         
         
