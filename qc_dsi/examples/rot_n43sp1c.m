% This script rotate the H1 and H2 components
% S2R azimuth (head 9) and H1 Azimuth (head 11) have to be set
% Rotation is preformed level by level
% Angle of rotation (head 5) is assigned to the data
% Run this script from the nw99/qc_dsi directory
%
% Created by G. Bellefleur March 2000
% based on many lines from many scripts written by many authors!

cd ../n43

% Shot point 1c
load n43sp1c_harm;

n43sp1c_rot=n43sp1c_harm;

h1az=n43sp1c_harm.th{1}(11,:); 
s2raz=n43sp1c_harm.th{1}(9,:); 

for i=1:n43sp1c_harm.th{1}(12,1)
  
  % switch s2r to r2s azimuth
     if (s2raz(i) <= 180)
         s2raz(i)=360-(180-s2raz(i));
     else
         s2raz(i)=(s2raz(i)-180);
     end	
     
  % calc angle of rot required
      if s2raz(i)-h1az(i)<=0
         angle(i)=360-(h1az(i)-s2raz(i));
      else
         angle(i)=s2raz(i)-h1az(i);
      end

   % assing angle of rotation to head 5   
   n43sp1c_rot.th{1}(5,i)=angle(i);
   n43sp1c_rot.th{2}(5,i)=angle(i);
   n43sp1c_rot.th{3}(5,i)=angle(i);

   % Rotation Matrix
   s=sin(angle(i)*pi/180);
   c=cos(angle(i)*pi/180);

 % perform rotation
 n43sp1c_rot.dat{1}(:,i)=n43sp1c_harm.dat{1}(:,i)*c + n43sp1c_harm.dat{2}(:,i)*s; %radial
 n43sp1c_rot.dat{2}(:,i)=-1*n43sp1c_harm.dat{1}(:,i)*s + n43sp1c_harm.dat{2}(:,i)*c; %transverse

   
end

save n43sp1c_rot n43sp1c_rot;

