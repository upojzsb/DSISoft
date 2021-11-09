%matlab script for processing normetal VSP data

dsi_start

%load normetal

%data=ener(normetal,0.12,0.5);
%nm_bal=equa(data,30.0,225.0,10.0,5,0.5);
%nm_bal=pack_good(nm_bal,1);

%take spectral balanced file and use median filter to subtract pwave
nm_flat=flat(nm_bal,0.12,15);
%nm_flat=ener(nm_flat,0.10,0.14);
nm_flat=pack_good(nm_flat,1);
%nm_flat=trim(nm_flat,0.10,0.14,0.01);
%nm_flat=trim(nm_flat,0.10,0.14,0.01);
%nm_flat=trim(nm_flat,0.10,0.14,0.01);
nm_medi=medi_filt(nm_flat,13);

nm_sub=subr(nm_medi,nm_flat);
nm_unflat=unflat(nm_sub,0.12,15);
nm_unflat=mute(nm_unflat,1,15); %mute everything before first breaks

load /net/logan/seis/beaty/DSI/demos/norpoly.mat
nm_fk=nm_unflat;
for rec=1:3
 nm_fk=fkfilt(nm_fk,norpoly,225,10,0,5,rec); %pass all downgoing
end %for

nm_final=subr(nm_fk,nm_unflat); %subtract downgoing
%nm_final=pack_good(nm_final,0); %take out dead traces
nm_final=ener(nm_final,0.1,0.5);

dsi_end 
who
%end of script


%$Id: process.m,v 3.0 2000/06/13 19:18:30 gilles Exp $ 
%$Log: process.m,v $
%Revision 3.0  2000/06/13 19:18:30  gilles
%Release 3
%
%Revision 2.0  1999/05/21 18:41:44  mah
%Release 2
%
%Revision 1.1  1999/01/06 19:08:03  kay
%Initial revision
%
%
