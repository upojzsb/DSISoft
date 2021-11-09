%This script can be used to run qc_dsi with
%many input vsp data files. This script isolate 
%all 15 traces from each depth position of the survey and 
%outputs H1 azimuth into header 11 of all data files. 
%You still need to rotate the data after using this script.

%loading each individual VSP profil files and taking subsets
%corresponding to the first breaks time interval

cd ../n43;
load n43sp1c_harm;
load n43sp2e_harm;
load n43sp3n_harm;
load n43sp4s_harm;
load n43sp5w_harm;

max_picked_time=max([n43sp1c_harm.th{1}(15,:) n43sp2e_harm.th{1}(15,:) ...
		    n43sp3n_harm.th{1}(15,:) n43sp4s_harm.th{1}(15,:) ...
		    n43sp5w_harm.th{1}(15,:)]);

% get next hundereth of msec from  picked_time+15 msec 
maxt=ceil((max_picked_time+0.015)*10)/10;

% Taking the subsets
sp1c=subset(n43sp1c_harm,1,272,0,maxt,1,3);
sp2e=subset(n43sp2e_harm,1,272,0,maxt,1,3);
sp3n=subset(n43sp3n_harm,1,272,0,maxt,1,3);
sp4s=subset(n43sp4s_harm,1,272,0,maxt,1,3);
sp5w=subset(n43sp5w_harm,1,272,0,maxt,1,3);

% go back to the qc_dsi directory
cd ../qc_dsi;

%creating a depth vector with the wireline depth information
depthvec=sp1c.th{1}(56,:);

%creating a char array with file names
for i=1:sp1c.fh{13}
   j=depthvec(i);
   eval(['filestr{',num2str(i),'} = ''depth',num2str(j),''';']);
end


%taking subsets corresponding to each depth levels   
for COUNT=1:sp1c.fh{13}
   j=depthvec(COUNT);

   aa=subset(sp1c,COUNT,COUNT,0,maxt,1,3);
   bb=subset(sp2e,COUNT,COUNT,0,maxt,1,3);
   cc=subset(sp3n,COUNT,COUNT,0,maxt,1,3);
   dd=subset(sp4s,COUNT,COUNT,0,maxt,1,3);
   ee=subset(sp5w,COUNT,COUNT,0,maxt,1,3);
   
   %merging traces from each shot point
   m1=merge_files(aa,bb);
   clear aa bb
   m2=merge_files(m1,cc);
   clear m1 cc
   m3=merge_files(m2,dd);
   clear m2 dd
   m_final=merge_files(m3,ee);
   clear m3 ee
   
   temp=sortrec_new(m_final,4,26);
   toto=qc_dsi(temp,15,0.005,0.008,1,2);
   
   h1_azimuth(COUNT)=input('H1 azimuth?');
   depth(COUNT)=j;

  % Put the H1 component azimuth into header 11 
   
   n43sp1c_harm.th{1}(11,COUNT)=h1_azimuth(COUNT);
   n43sp1c_harm.th{2}(11,COUNT)=h1_azimuth(COUNT);
   n43sp1c_harm.th{3}(11,COUNT)=h1_azimuth(COUNT);
 
   n43sp2e_harm.th{1}(11,COUNT)=h1_azimuth(COUNT);
   n43sp2e_harm.th{2}(11,COUNT)=h1_azimuth(COUNT);
   n43sp2e_harm.th{3}(11,COUNT)=h1_azimuth(COUNT);
 
   n43sp3n_harm.th{1}(11,COUNT)=h1_azimuth(COUNT);
   n43sp3n_harm.th{2}(11,COUNT)=h1_azimuth(COUNT);
   n43sp3n_harm.th{3}(11,COUNT)=h1_azimuth(COUNT);
 
   n43sp4s_harm.th{1}(11,COUNT)=h1_azimuth(COUNT);
   n43sp4s_harm.th{2}(11,COUNT)=h1_azimuth(COUNT);
   n43sp4s_harm.th{3}(11,COUNT)=h1_azimuth(COUNT);
 
   n43sp5w_harm.th{1}(11,COUNT)=h1_azimuth(COUNT);
   n43sp5w_harm.th{2}(11,COUNT)=h1_azimuth(COUNT);
   n43sp5w_harm.th{3}(11,COUNT)=h1_azimuth(COUNT);
 
  
  dywap=input('Do you want a ps plot?','s');
  if (dywap=='y')
   figure(1) 
   eval(['print -depsc ', num2str(depth(COUNT)),'.eps']);
  end;

  
  clear temp;
  close all;
  
  
%orting with respect to component and s2r offset
%   eval(['pickdata' num2str(j) '=sortrec_new(m_final,4,26);']);
%saving each file
%   eval(['save ',filestr{COUNT},' pickdata'num2str(j)]);
%clearing the dataset
%   eval(['clear pickdata'num2str(j)]);

end

save h1_azimuth h1_azimuth depth;

cd ../n43;

save n43sp1c_harm n43sp1c_harm;
save n43sp2e_harm n43sp2e_harm;
save n43sp3n_harm n43sp3n_harm;
save n43sp4s_harm n43sp4s_harm;
save n43sp5w_harm n43sp5w_harm;

%clearing all
clear

%%%%%%%%%%%%%%
