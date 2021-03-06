%matlab script for processing normetal VSP data

dsi_start

load nm_bal %spectrally balanced data

%take spectral balanced file and use median filter to subtract pwave
nm_flat=flat(nm_bal,0.12,15);
nm_flat=ener(nm_flat,0.10,0.14);
nm_flat=trim(nm_flat,0.10,0.14,0.01);
nm_flat=trim(nm_flat,0.10,0.14,0.01);
nm_flat=trim(nm_flat,0.10,0.14,0.01);
nm_medi=medi_filt(nm_flat,13);

nm_sub=subr(nm_medi,nm_flat);
nm_unflat=unflat(nm_sub,0.12,15);
nm_unflat=mute(nm_unflat,1,15); %mute everything before first breaks

load norpoly.mat %polygon for fk filtering
nm_fk=nm_unflat;
for rec=1:3
 nm_fk=fkfilt(nm_fk,norpoly,225,10,0,5,rec); %pass all downgoing
end %for

nm_final=subr(nm_fk,nm_unflat); %subtract downgoing
nm_final=ener(nm_final,0.1,0.5);

dsi_end

%$Id: demoproc.m,v 3.0 2000/06/13 19:18:09 gilles Exp $
%$Log: demoproc.m,v $
%Revision 3.0  2000/06/13 19:18:09  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:41:30  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:07:57  kay
%Initial revision
%
%
