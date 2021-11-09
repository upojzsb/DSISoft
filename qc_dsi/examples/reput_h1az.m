% re-Put h1- azimuth into header 11 from h1_azimuth.mat file
% data files are in nw99/n43 dir

load h1_azimuth.mat;

cd ../n43

% Shot point 1c
load n43sp1c_harm;

n43sp1c_harm.th{1}(11,:)=h1_azimuth; 
n43sp1c_harm.th{2}(11,:)=h1_azimuth;
n43sp1c_harm.th{3}(11,:)=h1_azimuth;
save n43sp1c_harm n43sp1c_harm;

%Shot point 2e
load n43sp2e_harm;

n43sp2e_harm.th{1}(11,:)=h1_azimuth;
n43sp2e_harm.th{2}(11,:)=h1_azimuth;
n43sp2e_harm.th{3}(11,:)=h1_azimuth;
save n43sp2e_harm n43sp2e_harm;

%shot point 3n
load n43sp3n_harm;

n43sp3n_harm.th{1}(11,:)=h1_azimuth;
n43sp3n_harm.th{2}(11,:)=h1_azimuth;
n43sp3n_harm.th{3}(11,:)=h1_azimuth;
save n43sp3n_harm n43sp3n_harm;

%Shot point 4s
load n43sp4s_harm;

n43sp4s_harm.th{1}(11,:)=h1_azimuth;
n43sp4s_harm.th{2}(11,:)=h1_azimuth;
n43sp4s_harm.th{3}(11,:)=h1_azimuth;
save n43sp4s_harm n43sp4s_harm;

%Shot point 5w
load n43sp5w_harm;

n43sp5w_harm.th{1}(11,:)=h1_azimuth;
n43sp5w_harm.th{2}(11,:)=h1_azimuth;
n43sp5w_harm.th{3}(11,:)=h1_azimuth;
save n43sp5w_harm n43sp5w_harm;
