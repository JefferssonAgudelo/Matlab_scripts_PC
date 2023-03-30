
%--------------------------------------------------------------------------
% This is to get the energy 

cd '/Volumes/PSC_DiRAC_DATA/DATACB104/raw_data'; %This is important because the xdmf files are in that directory
path = '/Volumes/PSC_DiRAC_DATA/DATACB104/raw_data';

% useful parameters used in the simulation
%--------------------------------------------------------------------------
kb = 1.; mu0 =1.; mi_over_me_ =100.; vA_over_c_ = 0.1; B0_ = vA_over_c_;
mi = 1.; me = 1. / mi_over_me_; eps0=1.;
omega_pi=1;
Omega_e=vA_over_c_*sqrt(mi_over_me_)*omega_pi;
Omega_i=Omega_e / mi_over_me_;
TOmega_e=1/Omega_e; 
TOmega_i=1/Omega_i;
dt=0.06;
%------------------------------------------------------------------
%vectors as 1 arrow 3 columns
%mi=1;
mime=100;
%me=mi/mime;
qi=1;
qe=-1;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
S = dir(fullfile(path,'*.h5'));
N=numel(S); % number of files to use <---------------- This is the N 
H=zeros(N);
%in=30;
%i=2;
%--------------------------------------------------------------------------

% To save some variables in a file for all the times. Uncomment this when
% running again the program to generate the data
%--------------------------------------------------------------------------
%
%T_velocities_sub=cell(6,N);
%T_ratios_sub=cell(8,N);
T_energy_terms_sub=cell(8,N);

%}
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
nx1=166;    nx2=333;
ny1=232;    ny2=400;
nz1=1200;   nz2=1367;

px2 = 168; py2 = 168; pz2 = 168;
start = [nx1 ny1 nz1];
count = [px2 py2 pz2];
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
resx=0.06; %0.06081
resy=0.06;
resz=0.06; %0.06152

Lx=px2*resx; k0x=1/Lx;
Ly=px2*resy; k0y=1/Ly;
Lz=px2*resz; k0z=1/Lz;
k00=sqrt(k0x*k0x + k0y*k0y + k0z*k0z);
%--------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

in=19;
% This is tocalculate the ratios and velocities.
% The velocities and all the terms have been normalized
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for in=1:N
%--------------------------------------------------------------------------
disp(strcat('Computing step ...',S(in).name))
%--------------------------------------------------------------------------
%N_steps = 2000;
%time_t = dt*N_steps; %(In terms of 1/omega_pi)
str = string(S(in).name);
newStr = extractBetween(str,"pfd.","_p000000.h5");
N_steps = str2double(newStr);
time_t = dt*N_steps;
%--------------------------------------------------------------------------

fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
T_1st = info.Groups(1).Name;
E_1st = info.Groups(17).Name;
B_1st = info.Groups(18).Name;
J_1st = info.Groups(19).Name;
V_1st = info.Groups(25).Name;
n_1st = info.Groups(23).Name;
%--------------------------------------------------------------------------

% Including the normalization of the quantities before hand 
%--------------------------------------------------------------------------
%c=1;
%VA2c = 1.;
%B0 = 1.;
%E0 = 1.;
%Pi0 = 1.;
%Pe0 = 1.;

c=1;
VA2c = 0.1;
B0 = VA2c;
E0 = B0*VA2c;
Pi0 = mi*VA2c*VA2c;
Pe0 = me*VA2c*VA2c;

%%%% IMPORTANT QUESTION. SHOULD I NORMALISE ELECTRON AND ION ENERGIES TO
%%%% DIFFERENT VALUES BECAUSE OF ITS MASS?????
%--------------------------------------------------------------------------

% This is over the whole box! (This is outdated and doesn't have the correction for the central moment)
%------------------------------------------------------------------
%{
%Magnetic energy density
B{1,1} =h5read(fileID,strcat(B_1st,'/hx/p0/3d'))./B0; 
B{1,2} =h5read(fileID,strcat(B_1st,'/hy/p0/3d'))./B0; 
B{1,3} =h5read(fileID,strcat(B_1st,'/hz/p0/3d'))./B0; 

energy_B = 0.5.*(B{1,1}.^2 + B{1,2}.^2 + B{1,3}.^2);
clearvars B;

energy_B_in=sum(energy_B,'all');
clearvars energy_B;

T_energy_terms{1,in} = energy_B_in; 

%Electric energy density
E{1,1} =h5read(fileID,strcat(E_1st,'/ex/p0/3d'))./E0; 
E{1,2} =h5read(fileID,strcat(E_1st,'/ey/p0/3d'))./E0; 
E{1,3} =h5read(fileID,strcat(E_1st,'/ez/p0/3d'))./E0; 

energy_E = 0.5.*(E{1,1}.^2 + E{1,2}.^2 + E{1,3}.^2);
clearvars E;

energy_E_in=sum(energy_E,'all');
clearvars energy_E;

T_energy_terms{2,in} = energy_E_in; 

%J{1,1} =h5read(fileID,strcat(J_1st,'/jx/p0/3d'))./VA2c; 
%J{1,2} =h5read(fileID,strcat(J_1st,'/jy/p0/3d'))./VA2c; 
%J{1,3} =h5read(fileID,strcat(J_1st,'/jz/p0/3d'))./VA2c; 

%Kinetic energy density ions
vi{1,1} =h5read(fileID,strcat(V_1st,'/vx_i/p0/3d'))./VA2c; 
vi{1,2} =h5read(fileID,strcat(V_1st,'/vy_i/p0/3d'))./VA2c; 
vi{1,3} =h5read(fileID,strcat(V_1st,'/vz_i/p0/3d'))./VA2c; 
ni{1,1} = h5read(fileID,strcat(n_1st,'/n_i/p0/3d')); 

energy_vi = 0.5.*mi.*(ni{1,1}).*(vi{1,1}.^2 + vi{1,2}.^2 + vi{1,3}.^2);
clearvars vi ni;

energy_vi_in=sum(energy_vi,'all');
clearvars energy_vi;

T_energy_terms{3,in} = energy_vi_in; 

%Kinetic energy density electrons
ve{1,1} =h5read(fileID,strcat(V_1st,'/vx_e/p0/3d'))./VA2c; 
ve{1,2} =h5read(fileID,strcat(V_1st,'/vy_e/p0/3d'))./VA2c; 
ve{1,3} =h5read(fileID,strcat(V_1st,'/vz_e/p0/3d'))./VA2c; 
ne{1,1} = h5read(fileID,strcat(n_1st,'/n_e/p0/3d')); 

energy_ve = 0.5.*me.*(ne{1,1}).*(ve{1,1}.^2 + ve{1,2}.^2 + ve{1,3}.^2);
clearvars ve ne;

energy_ve_in=sum(energy_ve,'all');
clearvars energy_ve;

T_energy_terms{4,in} = energy_ve_in; 


%Thermal energy density ions
Pij_i{1,1} =h5read(fileID,strcat(T_1st,'/Txx_i/p0/3d'))./Pi0; 
%Pij_i{1,2} =h5read(fileID,strcat(T_1st,'/Txy_i/p0/3d'))./Pi0; 
%Pij_i{1,3} =h5read(fileID,strcat(T_1st,'/Txz_i/p0/3d'))./Pi0; 
Pij_i{1,2} =h5read(fileID,strcat(T_1st,'/Tyy_i/p0/3d'))./Pi0; 
%Pij_i{2,3} =h5read(fileID,strcat(T_1st,'/Tyz_i/p0/3d'))./Pi0; 
Pij_i{1,3} =h5read(fileID,strcat(T_1st,'/Tzz_i/p0/3d'))./Pi0; 

energy_Pij_i = 0.5.*(Pij_i{1,1} + Pij_i{1,2} + Pij_i{1,3});
clearvars Pij_i;

energy_Pij_i_in=sum(energy_Pij_i,'all');
clearvars energy_Pij_i;

T_energy_terms{5,in} = energy_Pij_i_in; 

%Kinetic energy density electrons
Pij_e{1,1} =h5read(fileID,strcat(T_1st,'/Txx_e/p0/3d'))./Pe0; 
%Pij_e{1,2} =h5read(fileID,strcat(T_1st,'/Txy_e/p0/3d'))./Pe0; 
%Pij_e{1,3} =h5read(fileID,strcat(T_1st,'/Txz_e/p0/3d'))./Pe0; 
Pij_e{1,2} =h5read(fileID,strcat(T_1st,'/Tyy_e/p0/3d'))./Pe0; 
%Pij_e{2,3} =h5read(fileID,strcat(T_1st,'/Tyz_e/p0/3d'))./Pe0; 
Pij_e{1,3} =h5read(fileID,strcat(T_1st,'/Tzz_e/p0/3d'))./Pe0; 

energy_Pij_e = 0.5.*(Pij_e{1,1} + Pij_e{1,2} + Pij_e{1,3});
clearvars Pij_e;

energy_Pij_e_in=sum(energy_Pij_e,'all');
clearvars energy_Pij_e;

T_energy_terms{6,in} = energy_Pij_e_in; 
%}
%-------------------------------------------------------------------------------------------

% This is over the subdomain!
%------------------------------------------------------------------
%{
%Magnetic energy density
B{1,1} =h5read(fileID,strcat(B_1st,'/hx/p0/3d'),start,count)./B0; 
B{1,2} =h5read(fileID,strcat(B_1st,'/hy/p0/3d'),start,count)./B0; 
B{1,3} =h5read(fileID,strcat(B_1st,'/hz/p0/3d'),start,count)./B0; 

%Electric energy density
E{1,1} =h5read(fileID,strcat(E_1st,'/ex/p0/3d'),start,count)./E0; 
E{1,2} =h5read(fileID,strcat(E_1st,'/ey/p0/3d'),start,count)./E0; 
E{1,3} =h5read(fileID,strcat(E_1st,'/ez/p0/3d'),start,count)./E0; 

energy_B = 0.5.*(B{1,1}.^2 + B{1,2}.^2 + B{1,3}.^2);
energy_B_in=sum(energy_B,'all');
T_energy_terms_sub{1,in} = energy_B_in; 

energy_E = 0.5.*(E{1,1}.^2 + E{1,2}.^2 + E{1,3}.^2);
energy_E_in=sum(energy_E,'all');
T_energy_terms_sub{2,in} = energy_E_in; 

B_mag=sqrt(B{1,1}.*B{1,1} + B{1,2}.*B{1,2} + B{1,3}.*B{1,3});
%E_mag=sqrt(E{1,1}.*E{1,1} + E{1,2}.*E{1,2} + E{1,3}.*E{1,3});
V_exb_x = (E{1,2}.*B{1,3} - E{1,3}.*B{1,2})./(B_mag.^2);
V_exb_y = (E{1,3}.*B{1,1} - E{1,1}.*B{1,3})./(B_mag.^2);
V_exb_z = (E{1,1}.*B{1,2} - E{1,2}.*B{1,1})./(B_mag.^2);

E_2 = (E{1,1}.^2 + E{1,2}.^2 + E{1,3}.^2);
E_2_in=sum(E_2,'all');
T_velocities_sub{1,in}=E_2_in;


clearvars B E energy_B energy_E B_mag 

ni{1,1} = h5read(fileID,strcat(n_1st,'/n_i/p0/3d'),start,count); 
ne{1,1} = h5read(fileID,strcat(n_1st,'/n_e/p0/3d'),start,count); 

energy_V_exb_i = 0.5.*mi.*(ni{1,1}).*(V_exb_x.^2 + V_exb_y.^2 + V_exb_z.^2);
energy_V_exb_i_in=sum(energy_V_exb_i,'all');
T_energy_terms_sub{8,in} = energy_V_exb_i_in;

energy_V_exb_e = 0.5.*me.*(ne{1,1}).*(V_exb_x.^2 + V_exb_y.^2 + V_exb_z.^2);
energy_V_exb_e_in=sum(energy_V_exb_e,'all');
T_energy_terms_sub{7,in} = energy_V_exb_e_in;


% velocity
V_exb_2=(V_exb_x.^2 + V_exb_y.^2 + V_exb_z.^2);
V_exb_2_in=sum(V_exb_2,'all');
T_velocities_sub{2,in}=V_exb_2_in;

clearvars V_exb_x V_exb_y V_exb_z energy_V_exb_e energy_V_exb_i


%Kinetic energy density ions
vi{1,1} =h5read(fileID,strcat(V_1st,'/vx_i/p0/3d'),start,count)./VA2c; 
vi{1,2} =h5read(fileID,strcat(V_1st,'/vy_i/p0/3d'),start,count)./VA2c; 
vi{1,3} =h5read(fileID,strcat(V_1st,'/vz_i/p0/3d'),start,count)./VA2c; 

%velocity
vi_2 = (vi{1,1}.^2 + vi{1,2}.^2 + vi{1,3}.^2);
vi_2_in=sum(vi_2,'all');
T_velocities_sub{3,in}=vi_2_in;


%ratio
E_2_2_nimivi_2 = E_2./(ni{1,1}.*mi.*vi_2);
E_2_2_nimivi_2_in=sum(E_2_2_nimivi_2,'all');
T_ratios_sub{1,in} = E_2_2_nimivi_2_in;

%ratio
V_exb_2_2_vi_2 = V_exb_2./vi_2; 
V_exb_2_2_vi_2_in=sum(V_exb_2_2_vi_2,'all');
T_ratios_sub{2,in} = V_exb_2_2_vi_2_in;

%energy
energy_vi = 0.5.*mi.*(ni{1,1}).*(vi{1,1}.^2 + vi{1,2}.^2 + vi{1,3}.^2);
energy_vi_in=sum(energy_vi,'all');

clearvars energy_vi E_2_2_nimivi_2 V_exb_2_2_vi_2;

T_energy_terms_sub{3,in} = energy_vi_in; 

%Kinetic energy density electrons
ve{1,1} =h5read(fileID,strcat(V_1st,'/vx_e/p0/3d'),start,count)./VA2c; 
ve{1,2} =h5read(fileID,strcat(V_1st,'/vy_e/p0/3d'),start,count)./VA2c;
ve{1,3} =h5read(fileID,strcat(V_1st,'/vz_e/p0/3d'),start,count)./VA2c; 

%velocity
ve_2 = (ve{1,1}.^2 + ve{1,2}.^2 + ve{1,3}.^2);
ve_2_in=sum(ve_2,'all');
T_velocities_sub{4,in}=ve_2_in;

%ratio
E_2_2_nemeve_2 = E_2./(ne{1,1}.*me.*ve_2);
E_2_2_nemeve_2_in=sum(E_2_2_nemeve_2,'all');
T_ratios_sub{3,in} = E_2_2_nemeve_2_in;

%ratio
V_exb_2_2_ve_2 = V_exb_2./ve_2; 
V_exb_2_2_ve_2_in=sum(V_exb_2_2_ve_2,'all');
T_ratios_sub{4,in} = V_exb_2_2_ve_2_in;

%energy
energy_ve = 0.5.*me.*(ne{1,1}).*(ve{1,1}.^2 + ve{1,2}.^2 + ve{1,3}.^2);
energy_ve_in=sum(energy_ve,'all');

clearvars energy_ve E_2_2_nemeve_2 V_exb_2_2_ve_2 E_2;

T_energy_terms_sub{4,in} = energy_ve_in; 

%Thermal energy density ions
Pij_i{1,1} =h5read(fileID,strcat(T_1st,'/Txx_i/p0/3d'),start,count)./Pi0; 
Pij_i{1,2} =h5read(fileID,strcat(T_1st,'/Tyy_i/p0/3d'),start,count)./Pi0; 
Pij_i{1,3} =h5read(fileID,strcat(T_1st,'/Tzz_i/p0/3d'),start,count)./Pi0; 

% This is to get the central momment pressure.
%------------------------------------------------------------------
PPij_i=cell(1,3);
PPij_i{1,1} = Pij_i{1,1} - ni{1,1}.*mi.*vi{1,1}.*vi{1,1};
PPij_i{1,2} = Pij_i{1,2} - ni{1,1}.*mi.*vi{1,2}.*vi{1,2};
PPij_i{1,3} = Pij_i{1,3} - ni{1,1}.*mi.*vi{1,3}.*vi{1,3};
Pij_i = PPij_i;
%------------------------------------------------------------------

%------------------------------------------------------------------
%Thermal velocity ions
vth_i_2 = (2/(3.*mi.*ni{1,1}).*(Pij_i{1,1}+Pij_i{1,2}+Pij_i{1,3}));  

vth_i_2_in=sum(vth_i_2,'all');
T_velocities_sub{5,in}=vth_i_2_in;

%ratio
V_exb_2_2_vth_i_2 = V_exb_2./vth_i_2; 
V_exb_2_2_vth_i_2_in=sum(V_exb_2_2_vth_i_2,'all');
T_ratios_sub{5,in} = V_exb_2_2_vth_i_2_in;

%ratio
vth_i_2_2_vi_2 = vth_i_2./vi_2; 
vth_i_2_2_vi_2_in=sum(vth_i_2_2_vi_2,'all');
T_ratios_sub{6,in} = vth_i_2_2_vi_2_in;

%energy
energy_Pij_i = 0.5.*(Pij_i{1,1} + Pij_i{1,2} + Pij_i{1,3});
energy_Pij_i_in=sum(energy_Pij_i,'all');

T_energy_terms_sub{5,in} = energy_Pij_i_in; 

clearvars Pij_i; clearvars vi ni;
clearvars energy_Pij_i vth_i_2 vi_2 V_exb_2_2_vth_i_2 vth_i_2_2_vi_2;

%Thermal energy density electrons
%------------------------------------------------------------------
Pij_e{1,1} =h5read(fileID,strcat(T_1st,'/Txx_e/p0/3d'),start,count)./Pi0; 
Pij_e{1,2} =h5read(fileID,strcat(T_1st,'/Tyy_e/p0/3d'),start,count)./Pi0; 
Pij_e{1,3} =h5read(fileID,strcat(T_1st,'/Tzz_e/p0/3d'),start,count)./Pi0; 

PPij_e=cell(1,3);
PPij_e{1,1} = Pij_e{1,1} - ne{1,1}.*me.*ve{1,1}.*ve{1,1};
PPij_e{1,2} = Pij_e{1,2} - ne{1,1}.*me.*ve{1,2}.*ve{1,2};
PPij_e{1,3} = Pij_e{1,3} - ne{1,1}.*me.*ve{1,3}.*ve{1,3};
Pij_e = PPij_e;

%Thermal velocity electrons
vth_e_2 = (2/(3.*me.*ne{1,1}).*(Pij_e{1,1}+Pij_e{1,2}+Pij_e{1,3}));  

vth_e_2_in=sum(vth_e_2,'all');
T_velocities_sub{6,in}=vth_e_2_in;

%ratio
V_exb_2_2_vth_e_2 = V_exb_2./vth_e_2; 
V_exb_2_2_vth_e_2_in=sum(V_exb_2_2_vth_e_2,'all');
T_ratios_sub{7,in} = V_exb_2_2_vth_e_2_in;

%ratio
vth_e_2_2_ve_2 = vth_e_2./ve_2; 
vth_e_2_2_ve_2_in=sum(vth_e_2_2_ve_2,'all');
T_ratios_sub{8,in} = vth_e_2_2_ve_2_in;

%energy
energy_Pij_e = 0.5.*(Pij_e{1,1} + Pij_e{1,2} + Pij_e{1,3});
energy_Pij_e_in=sum(energy_Pij_e,'all');

T_energy_terms_sub{6,in} = energy_Pij_e_in; 

clearvars Pij_e; clearvars ve ne;
clearvars energy_Pij_e vth_e_2 ve_2 V_exb_2_2_vth_e_2 vth_e_2_2_ve_2 V_exb_2;
%}
%-------------------------------------------------------------------------------------------

% This is over the whole box reloaded deleting the cross velocities!
%------------------------------------------------------------------
%
% for the whole box
start = [1 1 1];
count = [400 400 1000];

%Magnetic energy density
B{1,1} =h5read(fileID,strcat(B_1st,'/hx/p0/3d'),start,count)./B0; 
B{1,2} =h5read(fileID,strcat(B_1st,'/hy/p0/3d'),start,count)./B0; 
B{1,3} =h5read(fileID,strcat(B_1st,'/hz/p0/3d'),start,count)./B0; 

energy_B = 0.5.*(B{1,1}.^2 + B{1,2}.^2 + B{1,3}.^2);
energy_B_in=sum(energy_B,'all');
T_energy_terms_sub{1,in} = energy_B_in;

clearvars B energy_B 

%Electric energy density
E{1,1} =h5read(fileID,strcat(E_1st,'/ex/p0/3d'),start,count)./E0; 
E{1,2} =h5read(fileID,strcat(E_1st,'/ey/p0/3d'),start,count)./E0; 
E{1,3} =h5read(fileID,strcat(E_1st,'/ez/p0/3d'),start,count)./E0;  

energy_E = 0.5.*(E{1,1}.^2 + E{1,2}.^2 + E{1,3}.^2);
energy_E_in=sum(energy_E,'all');
T_energy_terms_sub{2,in} = energy_E_in; 

clearvars E energy_E  

ni{1,1} = h5read(fileID,strcat(n_1st,'/n_i/p0/3d'),start,count); 

%Kinetic energy density ions
vi{1,1} =h5read(fileID,strcat(V_1st,'/vx_i/p0/3d'),start,count)./VA2c; 
vi{1,2} =h5read(fileID,strcat(V_1st,'/vy_i/p0/3d'),start,count)./VA2c; 
vi{1,3} =h5read(fileID,strcat(V_1st,'/vz_i/p0/3d'),start,count)./VA2c; 

%energy
energy_vi = 0.5.*mi.*(ni{1,1}).*(vi{1,1}.^2 + vi{1,2}.^2 + vi{1,3}.^2);
energy_vi_in=sum(energy_vi,'all');
T_energy_terms_sub{3,in} = energy_vi_in; 

clearvars energy_vi;

ne{1,1} = h5read(fileID,strcat(n_1st,'/n_e/p0/3d'),start,count); 

%Kinetic energy density electrons
ve{1,1} =h5read(fileID,strcat(V_1st,'/vx_e/p0/3d'),start,count)./VA2c; 
ve{1,2} =h5read(fileID,strcat(V_1st,'/vy_e/p0/3d'),start,count)./VA2c;
ve{1,3} =h5read(fileID,strcat(V_1st,'/vz_e/p0/3d'),start,count)./VA2c; 

%energy
energy_ve = 0.5.*me.*(ne{1,1}).*(ve{1,1}.^2 + ve{1,2}.^2 + ve{1,3}.^2);
energy_ve_in=sum(energy_ve,'all');
T_energy_terms_sub{4,in} = energy_ve_in; 

clearvars energy_ve;

%Thermal energy density ions
Pij_i{1,1} =h5read(fileID,strcat(T_1st,'/Txx_i/p0/3d'),start,count)./Pi0; 
Pij_i{1,2} =h5read(fileID,strcat(T_1st,'/Tyy_i/p0/3d'),start,count)./Pi0; 
Pij_i{1,3} =h5read(fileID,strcat(T_1st,'/Tzz_i/p0/3d'),start,count)./Pi0; 

% This is to get the central momment pressure.
%------------------------------------------------------------------
PPij_i=cell(1,3);
PPij_i{1,1} = Pij_i{1,1} - ni{1,1}.*mi.*vi{1,1}.*vi{1,1};
PPij_i{1,2} = Pij_i{1,2} - ni{1,1}.*mi.*vi{1,2}.*vi{1,2};
PPij_i{1,3} = Pij_i{1,3} - ni{1,1}.*mi.*vi{1,3}.*vi{1,3};
Pij_i = PPij_i;
%------------------------------------------------------------------

clearvars PPij_i; clearvars vi ni;

%------------------------------------------------------------------
%energy
energy_Pij_i = 0.5.*(Pij_i{1,1} + Pij_i{1,2} + Pij_i{1,3});
energy_Pij_i_in=sum(energy_Pij_i,'all');
T_energy_terms_sub{5,in} = energy_Pij_i_in; 

clearvars Pij_i; 
clearvars energy_Pij_i;

%Thermal energy density electrons
%------------------------------------------------------------------
Pij_e{1,1} =h5read(fileID,strcat(T_1st,'/Txx_e/p0/3d'),start,count)./Pi0; 
Pij_e{1,2} =h5read(fileID,strcat(T_1st,'/Tyy_e/p0/3d'),start,count)./Pi0; 
Pij_e{1,3} =h5read(fileID,strcat(T_1st,'/Tzz_e/p0/3d'),start,count)./Pi0; 

PPij_e=cell(1,3);
PPij_e{1,1} = Pij_e{1,1} - ne{1,1}.*me.*ve{1,1}.*ve{1,1};
PPij_e{1,2} = Pij_e{1,2} - ne{1,1}.*me.*ve{1,2}.*ve{1,2};
PPij_e{1,3} = Pij_e{1,3} - ne{1,1}.*me.*ve{1,3}.*ve{1,3};
Pij_e = PPij_e;

clearvars PPij_e; clearvars ve ne;

%energy
energy_Pij_e = 0.5.*(Pij_e{1,1} + Pij_e{1,2} + Pij_e{1,3});
energy_Pij_e_in=sum(energy_Pij_e,'all');
T_energy_terms_sub{6,in} = energy_Pij_e_in; 

clearvars Pij_e; 
clearvars energy_Pij_e;
%}

%------------------------------------------------------------------
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------
%This is what is for the first half
%T_energy_terms_sub_1=T_energy_terms_sub;

%This is what is next
%T_energy_terms_sub_2=T_energy_terms_sub;
%------------------------------------------------------------------
%cd '/Volumes/PSC_DiRAC_DATA/Energy_Budget_things'
%save('T_energy_terms_sub_12.mat','T_energy_terms_sub_1','T_energy_terms_sub_2')
%--------------------------------------------------------------------------
% To load the data in the subbox
%--------------------------------------------------------------------------
cd '/Volumes/PSC_DiRAC_DATA/Energy_Budget_things'
load('T_energy_terms_sub_12.mat')
%--------------------------------------------------------------------------
energy_B_in_12_a = (cell2mat(T_energy_terms_sub_1(1,:)) + cell2mat(T_energy_terms_sub_2(1,:)))/2;
energy_E_in_12_a = (cell2mat(T_energy_terms_sub_1(2,:)) + cell2mat(T_energy_terms_sub_2(2,:)))/2;
energy_vi_in_12_a =  (cell2mat(T_energy_terms_sub_1(3,:)) + cell2mat(T_energy_terms_sub_2(3,:)))/2;
energy_ve_in_12_a =  (cell2mat(T_energy_terms_sub_1(4,:)) + cell2mat(T_energy_terms_sub_2(4,:)))/2;
energy_Pij_i_in_12_a =  (cell2mat(T_energy_terms_sub_1(5,:)) + cell2mat(T_energy_terms_sub_2(5,:)))/2;
energy_Pij_e_in_12_a =  (cell2mat(T_energy_terms_sub_1(6,:)) + cell2mat(T_energy_terms_sub_2(6,:)))/2;
%--------------------------------------------------------------------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script is to compute the dissipation terms averages on sub-boxes. 
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
cd '/Volumes/PSC_DiRAC_DATA/DATACB104/raw_data'; %This is important because the xdmf files are in that directory
path = '/Volumes/PSC_DiRAC_DATA/DATACB104/raw_data';

% useful parameters used in the simulation
%--------------------------------------------------------------------------
kb = 1.; mu0 =1.; mi_over_me_ =100.; vA_over_c_ = 0.1; B0_ = vA_over_c_;
mi = 1.; me = 1. / mi_over_me_; eps0=1.;
omega_pi=1;
Omega_e=vA_over_c_*sqrt(mi_over_me_)*omega_pi;
Omega_i=Omega_e / mi_over_me_;
TOmega_e=1/Omega_e;
TOmega_i=1/Omega_i;
dt=0.06;
%------------------------------------------------------------------
%vectors as 1 arrow 3 columns
%mi=1;
mime=100;
%me=mi/mime;
qi=1;
qe=-1;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
S = dir(fullfile(path,'*.h5'));
N=numel(S); % number of files to use <---------------- This is the N
H=zeros(N);
M=40;
%in=30;
%i=2;
%--------------------------------------------------------------------------

% To save some variables in a file for all the times. Uncomment this when
% running again the program to generate the data
%--------------------------------------------------------------------------
%
Mx=4; My=4; Mz=20;
kin_energy_terms_ic=cell(4,Mx,My,Mz,N);
kin_energy_terms_ec=cell(4,Mx,My,Mz,N);
Int_energy_terms_ic=cell(7,Mx,My,Mz,N);
Int_energy_terms_ec=cell(7,Mx,My,Mz,N);
%T_energy_terms_sub=cell(8,N);
Dissipation_terms=cell(4,Mx,My,Mz,N);
%}
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
px1 = 1; py1 = 1; pz1 = 1;
px2 = 100; py2 = 100; pz2=100; 
start = [px1 py1 pz1];
count = [px2 py2 pz2];
%--------------------------------------------------------------------------

resx=0.06; %0.06081
resy=0.06;
resz=0.06; %0.06152

Lx=px2*resx; k0x=1/Lx;
Ly=px2*resy; k0y=1/Ly;
Lz=px2*resz; k0z=1/Lz;
k00=sqrt(k0x*k0x + k0y*k0y + k0z*k0z);
%--------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%This is the block which computes the energy averages for the sub box. 10/05/2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the whole core of the analysis and the data generation !!
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
for in=1:N-1
    for jnz=1:19
        for jny=1:3
            for jnx=1:3
                %--------------------------------------------------------------------------
                disp(strcat('Computing step ...',S(in).name))
                disp(jnz)
                %--------------------------------------------------------------------------
                %N_steps = 2000;
                %time_t = dt*N_steps; %(In terms of 1/omega_pi)
                str = string(S(in).name);
                newStr = extractBetween(str,"pfd.","_p000000.h5");
                N_steps = str2double(newStr);
                time_t = dt*N_steps;
                %--------------------------------------------------------------------------
                
                fileID =  S(in).name; %change the 1 per i
                %h5disp(fileID);
                info = h5info(fileID);
                T_1st = info.Groups(1).Name;
                E_1st = info.Groups(17).Name;
                B_1st = info.Groups(18).Name;
                %J_1st = info.Groups(19).Name;
                V_1st = info.Groups(25).Name;
                n_1st = info.Groups(23).Name;
                %--------------------------------------------------------------------------
                
                % Including the normalization of the quantities before hand
                %--------------------------------------------------------------------------
                c=1;
                VA2c = 1.;%0.1;
                B0 = 1.;%VA2c;
                E0 = 1.;%B0*VA2c;
                Pi0 = 1.;%mi*VA2c*VA2c;
                Pe0 = 1.;%me*VA2c*VA2c;
                %--------------------------------------------------------------------------
                
                %------------------------------------------------------------------
                B{1,1} =h5read(fileID,strcat(B_1st,'/hx/p0/3d'),start,count)./B0;
                B{1,2} =h5read(fileID,strcat(B_1st,'/hy/p0/3d'),start,count)./B0;
                B{1,3} =h5read(fileID,strcat(B_1st,'/hz/p0/3d'),start,count)./B0;
                E{1,1} =h5read(fileID,strcat(E_1st,'/ex/p0/3d'),start,count)./E0;
                E{1,2} =h5read(fileID,strcat(E_1st,'/ey/p0/3d'),start,count)./E0;
                E{1,3} =h5read(fileID,strcat(E_1st,'/ez/p0/3d'),start,count)./E0;
                %J{1,1} =h5read(fileID,strcat(J_1st,'/jx/p0/3d'),start,count)./VA2c; %Jx=Jx(nx1:nx2,ny1:ny2,nz1:nz2);
                %J{1,2} =h5read(fileID,strcat(J_1st,'/jy/p0/3d'),start,count)./VA2c; %Jy=Jy(nx1:nx2,ny1:ny2,nz1:nz2);
                %J{1,3} =h5read(fileID,strcat(J_1st,'/jz/p0/3d'),start,count)./VA2c; %Jz=Jz(nx1:nx2,ny1:ny2,nz1:nz2);
                
                
                vi{1,1} =h5read(fileID,strcat(V_1st,'/vx_i/p0/3d'),start,count)./VA2c;
                vi{1,2} =h5read(fileID,strcat(V_1st,'/vy_i/p0/3d'),start,count)./VA2c;
                vi{1,3} =h5read(fileID,strcat(V_1st,'/vz_i/p0/3d'),start,count)./VA2c;
                
                ve{1,1} =h5read(fileID,strcat(V_1st,'/vx_e/p0/3d'),start,count)./VA2c;
                ve{1,2} =h5read(fileID,strcat(V_1st,'/vy_e/p0/3d'),start,count)./VA2c;
                ve{1,3} =h5read(fileID,strcat(V_1st,'/vz_e/p0/3d'),start,count)./VA2c;
                
                ni{1,1} = h5read(fileID,strcat(n_1st,'/n_i/p0/3d'),start,count);
                
                ne{1,1} = h5read(fileID,strcat(n_1st,'/n_e/p0/3d'),start,count);
                
                Pij_i{1,1} =h5read(fileID,strcat(T_1st,'/Txx_i/p0/3d'),start,count)./Pi0;
                Pij_i{1,2} =h5read(fileID,strcat(T_1st,'/Txy_i/p0/3d'),start,count)./Pi0;
                Pij_i{1,3} =h5read(fileID,strcat(T_1st,'/Txz_i/p0/3d'),start,count)./Pi0;
                Pij_i{2,2} =h5read(fileID,strcat(T_1st,'/Tyy_i/p0/3d'),start,count)./Pi0;
                Pij_i{2,3} =h5read(fileID,strcat(T_1st,'/Tyz_i/p0/3d'),start,count)./Pi0;
                Pij_i{3,3} =h5read(fileID,strcat(T_1st,'/Tzz_i/p0/3d'),start,count)./Pi0;
                
                Pij_e{1,1} =h5read(fileID,strcat(T_1st,'/Txx_e/p0/3d'),start,count)./Pe0;
                Pij_e{1,2} =h5read(fileID,strcat(T_1st,'/Txy_e/p0/3d'),start,count)./Pe0;
                Pij_e{1,3} =h5read(fileID,strcat(T_1st,'/Txz_e/p0/3d'),start,count)./Pe0;
                Pij_e{2,2} =h5read(fileID,strcat(T_1st,'/Tyy_e/p0/3d'),start,count)./Pe0;
                Pij_e{2,3} =h5read(fileID,strcat(T_1st,'/Tyz_e/p0/3d'),start,count)./Pe0;
                Pij_e{3,3} =h5read(fileID,strcat(T_1st,'/Tzz_e/p0/3d'),start,count)./Pe0;
                %-------------------------------------------------------------------------------------------
                
                
                %--------------------------------------------------------------------------
                
                % Now lets compute the quantities in the new reference frame  (rh,a,p)
                %--------------------------------------------------------------------------
                cd '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
                %--------------------------------------------------------------------------
                
                % This is to get the central momment pressure.
                %------------------------------------------------------------------
                PPij_i=cell(3,3);
                PPij_e=cell(3,3);
                for i=1:3
                    for j=1:3
                        if(isempty(Pij_i{i,j}) == 1)
                            continue
                        end
                        PPij_i{i,j} = Pij_i{i,j} - ni{1,1}.*mi.*vi{1,i}.*vi{1,j};
                        PPij_e{i,j} = Pij_e{i,j} - ne{1,1}.*me.*ve{1,i}.*ve{1,j};
                    end
                end
                
                % This is just to rename the variable
                Pij_i = PPij_i;
                Pij_e = PPij_e;
                %------------------------------------------------------------------
                
                
                %In the new reference frame the (rh,a,p) calculate the energy terms
                %--------------------------------------------------------------------------
                % This is to unlock. These are the lines to calculate the energy terms
                %{\
                % Get again the densities right
                %ni=nic1{1,1};
                %ne=nec1{1,1};
                % Kinetic energy densities
                %------------------------------------------------------------------
                Ki = 0.5.*ni{1,1}.* mi.*(vi{1,1}.*vi{1,1} + vi{1,2}.*vi{1,2} + vi{1,3}.*vi{1,3});
                Ke = 0.5.*ne{1,1}.* me.*(ve{1,1}.*ve{1,1} + ve{1,2}.*ve{1,2} + ve{1,3}.*vi{1,3});
                %------------------------------------------------------------------
                
                % Internal energy densities from Fadanelli et al, 2020
                %------------------------------------------------------------------
                Ui = 0.5.*(Pij_i{1,1} + Pij_i{2,2} + Pij_i{3,3});
                Ue = 0.5.*(Pij_e{1,1} + Pij_e{2,2} + Pij_e{3,3});
                %------------------------------------------------------------------
                
                %For the partial time derivative
                %------------------------------------------------------------------
                %{
Ki_1 = Ki;
Ke_1 = Ke;
Ui_1 = Ui;
Ue_1 = Ue;
%clearvars -except Ki_0 Ke_0 Ui_0 Ue_0
partialKi = (Ki_1 - Ki_0)/6;
partialKe = (Ke_1 - Ke_0)/6;
partialUi = (Ui_1 - Ui_0)/6;
partialUe = (Ue_1 - Ue_0)/6;
                %}
                %------------------------------------------------------------------
                
                %Derivates%
                %------------------------------------------------------------------
                %Grad_B
                [Bx_x,Bx_y,Bx_z] = gradient(B{1,1});
                [By_x,By_y,By_z] = gradient(B{1,2});
                [Bz_x,Bz_y,Bz_z] = gradient(B{1,3});
                grad_B{1,1} = Bx_x/resx; grad_B{1,2} = By_x/resx; grad_B{1,3} = Bz_x/resx;
                grad_B{2,1} = Bx_y/resy; grad_B{2,2} = By_y/resy; grad_B{2,3} = Bz_y/resy;
                grad_B{3,1} = Bx_z/resz; grad_B{3,2} = By_z/resz; grad_B{3,3} = Bz_z/resz;
                
                clearvars Bx_x Bx_y Bx_z By_x By_y By_z Bz_x Bz_y Bz_z
                Div_B=grad_B{1,1} + grad_B{2,2} + grad_B{3,3};
                
                %Grad_vi
                [vix_x,vix_y,vix_z] = gradient(vi{1,1});
                [viy_x,viy_y,viy_z] = gradient(vi{1,2});
                [viz_x,viz_y,viz_z] = gradient(vi{1,3});
                grad_vi{1,1} = vix_x/resx; grad_vi{1,2} = viy_x/resx; grad_vi{1,3} = viz_x/resx;
                grad_vi{2,1} = vix_y/resy; grad_vi{2,2} = viy_y/resy; grad_vi{2,3} = viz_y/resy;
                grad_vi{3,1} = vix_z/resz; grad_vi{3,2} = viy_z/resz; grad_vi{3,3} = viz_z/resz;
                
                clearvars vix_x vix_y vix_z viy_x viy_y viy_z viz_x viz_y viz_z
                Div_vi=grad_vi{1,1} + grad_vi{2,2} + grad_vi{3,3};
                
                %Grad_ve
                [vex_x,vex_y,vex_z] = gradient(ve{1,1});
                [vey_x,vey_y,vey_z] = gradient(ve{1,2});
                [vez_x,vez_y,vez_z] = gradient(ve{1,3});
                grad_ve{1,1} = vex_x/resx; grad_ve{1,2} = vey_x/resx; grad_ve{1,3} = vez_x/resx;
                grad_ve{2,1} = vex_y/resy; grad_ve{2,2} = vey_y/resy; grad_ve{2,3} = vez_y/resy;
                grad_ve{3,1} = vex_z/resz; grad_ve{3,2} = vey_z/resz; grad_ve{3,3} = vez_z/resz;
                
                clearvars vex_x vex_y vex_z vey_x vey_y vey_z vez_x vez_y vez_z
                Div_ve=grad_ve{1,1} + grad_ve{2,2} + grad_ve{3,3};
                
                %Grad_Pi
                [Pxxi_x, Pxxi_y, Pxxi_z] = gradient(Pij_i{1,1});
                [Pyyi_x, Pyyi_y, Pyyi_z] = gradient(Pij_i{2,2});
                [Pzzi_x, Pzzi_y, Pzzi_z] = gradient(Pij_i{3,3});
                [Pxyi_x, Pxyi_y, Pxyi_z] = gradient(Pij_i{1,2});
                [Pxzi_x, Pxzi_y, Pxzi_z] = gradient(Pij_i{1,3});
                [Pyzi_x, Pyzi_y, Pyzi_z] = gradient(Pij_i{2,3});
                Div_Pi_t{1,1} = Pxxi_x/resx + Pxyi_y/resy + Pxzi_z/resz;
                Div_Pi_t{1,2} = Pxyi_x/resx + Pyyi_y/resy + Pyzi_z/resz;
                Div_Pi_t{1,3} = Pxzi_x/resx + Pyzi_y/resy + Pzzi_z/resz;
                clearvars Pxxi_y Pxxi_z Pyyi_x Pyyi_z Pzzi_x Pzzi_z Pxyi_z Pxzi_y Pyzi_x
                clearvars Pxxi_x Pxyi_x Pxyi_y Pyyi_y Pyzi_y Pyzi_z Pxzi_x Pxzi_z Pzzi_z
                
                %Grad_Pe
                [Pxxe_x, Pxxe_y, Pxxe_z] = gradient(Pij_e{1,1});
                [Pyye_x, Pyye_y, Pyye_z] = gradient(Pij_e{2,2});
                [Pzze_x, Pzze_y, Pzze_z] = gradient(Pij_e{3,3});
                [Pxye_x, Pxye_y, Pxye_z] = gradient(Pij_e{1,2});
                [Pxze_x, Pxze_y, Pxze_z] = gradient(Pij_e{1,3});
                [Pyze_x, Pyze_y, Pyze_z] = gradient(Pij_e{2,3});
                Div_Pe_t{1,1} = Pxxe_x/resx + Pxye_y/resy + Pxze_z/resz;
                Div_Pe_t{1,2} = Pxye_x/resx + Pyye_y/resy + Pyze_z/resz;
                Div_Pe_t{1,3} = Pxze_x/resx + Pyze_y/resy + Pzze_z/resz;
                clearvars Pxxe_y Pxxe_z Pyye_x Pyye_z Pzze_x Pzze_z Pxye_z Pxze_y Pyze_x
                clearvars Pxxe_x Pxye_x Pxye_y Pyye_y Pyze_y Pyze_z Pxze_x Pxze_z Pzze_z
                
                %Grad_Ki
                [Ki_x,Ki_y,Ki_z] = gradient(Ki);
                grad_Ki{1,1} = Ki_x/resx;
                grad_Ki{1,2} = Ki_y/resy;
                grad_Ki{1,3} = Ki_z/resz;
                clearvars Ki_x Ki_y Ki_z
                
                %Grad_Ki
                [Ke_x,Ke_y,Ke_z] = gradient(Ke);
                grad_Ke{1,1} = Ke_x/resx;
                grad_Ke{1,2} = Ke_y/resy;
                grad_Ke{1,3} = Ke_z/resz;
                clearvars Ke_x Ke_y Ke_z
                
                %Grad_Ui
                [Ui_x,Ui_y,Ui_z] = gradient(Ui);
                grad_Ui{1,1} = Ui_x/resx;
                grad_Ui{1,2} = Ui_y/resy;
                grad_Ui{1,3} = Ui_z/resz;
                clearvars Ui_x Ui_y Ui_z
                
                %Grad_Ue
                [Ue_x,Ue_y,Ue_z] = gradient(Ue);
                grad_Ue{1,1} = Ue_x/resx;
                grad_Ue{1,2} = Ue_y/resy;
                grad_Ue{1,3} = Ue_z/resz;
                clearvars Ue_x Ue_y Ue_z
                %------------------------------------------------------------------
                
                % Dyadic products
                %------------------------------------------------------------------
                %vivi and %veve
                vivi=cell(3,3);
                veve=cell(3,3);
                for i=1:3
                    for j=1:3
                        vivi{i,j} = vi{1,i}.*vi{1,j};
                        veve{i,j} = ve{1,i}.*ve{1,j};
                    end
                end
                
                %Pivi
                Pit_vi{1,1} = Pij_i{1,1}.*vi{1,1} + Pij_i{1,2}.*vi{1,2} + Pij_i{1,3}.*vi{1,3};
                Pit_vi{1,2} = Pij_i{1,2}.*vi{1,1} + Pij_i{2,2}.*vi{1,2} + Pij_i{2,3}.*vi{1,3};
                Pit_vi{1,3} = Pij_i{1,3}.*vi{1,1} + Pij_i{2,3}.*vi{1,2} + Pij_i{3,3}.*vi{1,3};
                
                %Peve
                Pet_ve{1,1} = Pij_e{1,1}.*ve{1,1} + Pij_e{1,2}.*ve{1,2} + Pij_e{1,3}.*ve{1,3};
                Pet_ve{1,2} = Pij_e{1,2}.*ve{1,1} + Pij_e{2,2}.*ve{1,2} + Pij_e{2,3}.*ve{1,3};
                Pet_ve{1,3} = Pij_e{1,3}.*ve{1,1} + Pij_e{2,3}.*ve{1,2} + Pij_e{3,3}.*ve{1,3};
                %------------------------------------------------------------------
                
                
                % Scalar products
                %------------------------------------------------------------------
                % Pit_grad_vi. this the the same double dot procut
                Pit_grad_vi = Pij_i{1,1}.*grad_vi{1,1} + Pij_i{1,2}.*grad_vi{1,2} + Pij_i{1,3}.*grad_vi{1,3} +...
                    Pij_i{1,2}.*grad_vi{2,1} + Pij_i{2,2}.*grad_vi{2,2} + Pij_i{2,3}.*grad_vi{2,3} +...
                    Pij_i{1,3}.*grad_vi{3,1} + Pij_i{2,3}.*grad_vi{3,2} + Pij_i{3,3}.*grad_vi{3,3};
                
                % Pet_grad_ve
                Pet_grad_ve = Pij_e{1,1}.*grad_ve{1,1} + Pij_e{1,2}.*grad_ve{1,2} + Pij_e{1,3}.*grad_ve{1,3} +...
                    Pij_e{1,2}.*grad_ve{2,1} + Pij_e{2,2}.*grad_ve{2,2} + Pij_e{2,3}.*grad_ve{2,3} +...
                    Pij_e{1,3}.*grad_ve{3,1} + Pij_e{2,3}.*grad_ve{3,2} + Pij_e{3,3}.*grad_ve{3,3};
                
                %--------------------------------------------------------------------------
                % Diagonal
                % Pit_grad_vi_ii
                Pit_grad_vi_ii = Pij_i{1,1}.*grad_vi{1,1} + Pij_i{2,2}.*grad_vi{2,2} + Pij_i{3,3}.*grad_vi{3,3};
                
                % Pet_grad_ve_ii
                Pet_grad_ve_ii = Pij_e{1,1}.*grad_ve{1,1} + Pij_e{2,2}.*grad_ve{2,2} + Pij_e{3,3}.*grad_ve{3,3};
                
                % Off diagonal
                % Pit_grad_vi_ij
                Pit_grad_vi_ij = Pij_i{1,2}.*grad_vi{1,2} + Pij_i{1,3}.*grad_vi{1,3} + Pij_i{1,2}.*grad_vi{2,1} +...
                    Pij_i{2,3}.*grad_vi{2,3} + Pij_i{1,3}.*grad_vi{3,1} + Pij_i{2,3}.*grad_vi{3,2};
                
                % Pet_grad_ve_ij
                Pet_grad_ve_ij =  Pij_e{1,2}.*grad_ve{1,2} + Pij_e{1,3}.*grad_ve{1,3} + Pij_e{1,2}.*grad_ve{2,1} +...
                    Pij_e{2,3}.*grad_ve{2,3} + Pij_e{1,3}.*grad_ve{3,1} + Pij_e{2,3}.*grad_ve{3,2};
                %--------------------------------------------------------------------------
                
                % vi_Div_Pit
                vi_Div_Pit = vi{1,1}.*Div_Pi_t{1,1} + vi{1,2}.*Div_Pi_t{1,2} + vi{1,3}.*Div_Pi_t{1,3};
                
                % ve_Div_Pet
                ve_Div_Pet = ve{1,1}.*Div_Pe_t{1,1} + ve{1,2}.*Div_Pe_t{1,2} + ve{1,3}.*Div_Pe_t{1,3};
                
                %--------------------------------------------------------------------------
                % Div_Pi_dot_vi
                Div_Pis_dot_vi = Pit_grad_vi + vi_Div_Pit;
                % Div_Pe_dot_e
                Div_Pes_dot_ve = Pet_grad_ve + ve_Div_Pet;
                %--------------------------------------------------------------------------
                
                % Ki_Div_vi
                Ki_Div_vi = Ki.*Div_vi;
                
                % Ke_Div_ve
                Ke_Div_ve = Ke.*Div_ve;
                
                % Ui_Div_vi
                Ui_Div_vi = Ui.*Div_vi;
                
                % Ke_Div_ve
                Ue_Div_ve = Ue.*Div_ve;
                
                %qi_ni_vi_E
                qi_ni_vi_E = qi.*ni{1,1}.*(vi{1,1}.*E{1,1} + vi{1,2}.*E{1,2} + vi{1,3}.*E{1,3});
                
                %qe_ne_ve_E
                qe_ne_ve_E = qe.*ne{1,1}.*(ve{1,1}.*E{1,1} + ve{1,2}.*E{1,2} + ve{1,1}.*E{1,3});
                
                %vi_grad_Ki
                vi_grad_Ki = vi{1,1}.*grad_Ki{1,1} + vi{1,2}.*grad_Ki{1,2} + vi{1,3}.*grad_Ki{1,3};
                
                %ve_grad_Ke
                ve_grad_Ke = ve{1,1}.*grad_Ke{1,1} + ve{1,2}.*grad_Ke{1,2} + ve{1,3}.*grad_Ke{1,3};
                
                %vi_grad_Ui
                vi_grad_Ui = vi{1,1}.*grad_Ui{1,1} + vi{1,2}.*grad_Ui{1,2} + vi{1,3}.*grad_Ui{1,3};
                
                %ve_grad_Ue
                ve_grad_Ue = ve{1,1}.*grad_Ue{1,1} + ve{1,2}.*grad_Ue{1,2} + ve{1,3}.*grad_Ue{1,3};
                %------------------------------------------------------------------
                
                
                %------------------------------------------------------------------
                % From the definition in the code I think Tij is actually Pij as
                % Pij = m * int f(vi - ui)(vj - uj) dv^3 and not int( fvivj )dv^3 which is
                % PPij = Pij + nmuiuj
                % (HERE PPij is for the total energy and Pij is the thermal, the other way aroaund from the notes)
                
                % The internal energy can be compute using (1/2)Pij_i/ni?
                %------------------------------------------------------------------
                PPij_i=cell(3,3);
                PPij_e=cell(3,3);
                for i=1:3
                    for j=1:3
                        if(isempty(Pij_i{i,j}) == 1)
                            continue
                        end
                        PPij_i{i,j} = Pij_i{i,j} + ni{1,1}.*mi.*vi{1,i}.*vi{1,j};
                        PPij_e{i,j} = Pij_e{i,j} + ne{1,1}.*me.*ve{1,i}.*ve{1,j};
                    end
                end
                %------------------------------------------------------------------
                
                
                % Calculating the temperatures
                %------------------------------------------------------------------
                Tij_i=cell(3,3);
                Tij_e=cell(3,3);
                for i=1:3
                    for j=1:3
                        if(isempty(Pij_i{i,j}) == 1)
                            continue
                        end
                        Tij_i{i,j} =Pij_i{i,j}./(3.*ni{1,1});
                        Tij_e{i,j} =Pij_e{i,j}./(3.*ne{1,1});
                    end
                end
                %------------------------------------------------------------------
                
                
                %Lets compute the averages to see what is what
                %------------------------------------------------------------------
                ni_bar=mean(ni{1,1},'all');
                ne_bar=mean(ne{1,1},'all');
                
                PPij_i_bar=zeros(3);
                PPij_e_bar=zeros(3);
                Tij_i_bar=zeros(3);
                Tij_e_bar=zeros(3);
                for i=1:3
                    for j=1:3
                        PPij_i_bar(i,j)=mean(PPij_i{i,j}, 'all');
                        PPij_e_bar(i,j)=mean(PPij_e{i,j}, 'all');
                        Tij_i_bar(i,j)=mean(Tij_i{i,j}, 'all');
                        Tij_e_bar(i,j)=mean(Tij_e{i,j}, 'all');
                    end
                end
                
                Pij_i_bar=zeros(3);
                Pij_e_bar=zeros(3);
                for i=1:3
                    for j=1:3
                        Pij_i_bar(i,j)=mean(Pij_i{i,j}, 'all');
                        Pij_e_bar(i,j)=mean(Pij_e{i,j}, 'all');
                    end
                end
                %------------------------------------------------------------------
                
                
                % To calculate the grad of the heat flux vector wang et al, 2015
                %------------------------------------------------------------------
                vth_i = sqrt((Tij_i{1,1} + Tij_i{2,2} + Tij_i{3,3})./(3*mi));
                vth_e = sqrt((Tij_e{1,1} + Tij_e{2,2} + Tij_e{3,3})./(3*me));
                
                %(HERE PPij is for the total energy and Qij is the (v-u)..., the other way aroaund from the notes)
                %dkQijk_i{1,1} = vth_i.*k00.*( Pij_i{1,1} - Pij_i_bar(1,1) - ((ni - ni_bar).*Tij_i_bar(1,1)));
                dk_Qijk_i=cell(3,3);
                dk_Qijk_e=cell(3,3);
                for i=1:3
                    for j=1:3
                        if(isempty(PPij_i{i,j}) == 1)
                            continue
                        end
                        dk_Qijk_i{i,j} = vth_i.*k00.*( Pij_i{i,j} - Pij_i_bar(i,j) - ((i == j).*(ni{1,1} - ni_bar).*Tij_i_bar(i,j)));
                        dk_Qijk_e{i,j} = vth_e.*k00.*( Pij_e{i,j} - Pij_e_bar(i,j) - ((i == j).*(ne{1,1} - ne_bar).*Tij_e_bar(i,j)));
                    end
                end
                
                dk_Qijk_i2=cell(3,3);
                dk_Qijk_e2=cell(3,3);
                for i=1:3
                    for j=1:3
                        if(isempty(PPij_i{i,j}) == 1)
                            continue
                        end
                        dk_Qijk_i2{i,j} = -(vth_i./k00).*del2( Pij_i{i,j} - Pij_i_bar(i,j));
                        dk_Qijk_e2{i,j} = -(vth_e./k00).*del2( Pij_e{i,j} - Pij_e_bar(i,j));
                    end
                end
                
                % This is to smooth the second derivative thing
                %-------------------------------------------------------------------------
                filtvec3=[3,3,3];
                dk_Qijk_i3=cell(3,3);
                dk_Qijk_e3=cell(3,3);
                Pij_ifil=cell(3,3);
                Pij_efil=cell(3,3);
                for i=1:3
                    for j=1:3
                        if(isempty(PPij_i{i,j}) == 1)
                            continue
                        end
                        Pij_ifil{i,j} = medfilt3(Pij_i{i,j},filtvec3);
                        Pij_efil{i,j} = medfilt3(Pij_e{i,j},filtvec3);
                        dk_Qijk_i3{i,j} = -(vth_i./k00).*del2( Pij_ifil{i,j} - Pij_i_bar(i,j));
                        dk_Qijk_e3{i,j} = -(vth_e./k00).*del2( Pij_efil{i,j} - Pij_e_bar(i,j));
                    end
                end
                %-----------------------------------------------------------------------------
                
                
                %------------------------------------------------------------------
                % Now lets compute the time changes of the energy quantities
                %------------------------------------------------------------------
                
                % These are the divvergence of h
                %------------------------------------------------------------------
                dkQiik_05_i{1,1} = (dk_Qijk_i{1,1} + dk_Qijk_i{2,2} + dk_Qijk_i{3,3})/2;
                dkQiik_05_e{1,1} = (dk_Qijk_e{1,1} + dk_Qijk_e{2,2} + dk_Qijk_e{3,3})/2;
                
                dkQiik_05_i2{1,1} = (dk_Qijk_i2{1,1} + dk_Qijk_i2{2,2} + dk_Qijk_i2{3,3})/2;
                dkQiik_05_e2{1,1} = (dk_Qijk_e2{1,1} + dk_Qijk_e2{2,2} + dk_Qijk_e2{3,3})/2;
                %------------------------------------------------------------------
                
                Xi_k_i_in_dum = vi_grad_Ki + vi_Div_Pit +...
                    Ki_Div_vi - qi_ni_vi_E;
                
                Xi_k_e_in_dum = ve_grad_Ke + ve_Div_Pet +...
                    Ke_Div_ve - qe_ne_ve_E;
                
                Xi_th_i_in_dum =  vi_grad_Ui + dkQiik_05_i{1,1} +...
                    Pit_grad_vi + Ui_Div_vi;
                
                Xi_th_e_in_dum = ve_grad_Ue + dkQiik_05_e{1,1} +...
                    Pet_grad_ve + Ue_Div_ve;
                %--------------------------------------------------------------------------
                %}
                
                %To get just the average terms at different time steps
                %--------------------------------------------------------------------------
                
                %Kinetic Energy terms ions
                %--------------------------------------------------------------------------
                % To get the size of the domain
                ss1=size(vi_grad_Ki);
                ss2=ss1(1)*ss1(2)*ss1(3); %in the case of three dimensions
                
                vi_grad_Ki_in_a = sum(vi_grad_Ki,'all')./ss2;
                vi_Div_Pit_in_a = sum(vi_Div_Pit,'all')./ss2;
                Ki_Div_vi_in_a = sum(Ki_Div_vi,'all')./ss2;
                qi_ni_vi_E_in_a = sum(qi_ni_vi_E,'all')./ss2;
                Xi_k_i_in_a = sum(Xi_k_i_in_dum,'all')./ss2;
                %dtKi_in_Gp_2_in_a = sum(dtKi_in_Gp_2,'all')./ss2;
                %--------------------------------------------------------------------------
                
                %Kinetic Energy terms electrons
                %--------------------------------------------------------------------------
                ve_grad_Ke_in_a = sum(ve_grad_Ke,'all')./ss2;
                ve_Div_Pet_in_a = sum(ve_Div_Pet,'all')./ss2;
                Ke_Div_ve_in_a = sum(Ke_Div_ve,'all')./ss2;
                qe_ne_ve_E_in_a = sum(qe_ne_ve_E,'all')./ss2;
                Xi_k_e_in_a = sum(Xi_k_e_in_dum,'all')./ss2;
                %dtKe_in_Gp_2_in_a = sum(dtKe_in_Gp_2,'all')./ss2;
                %--------------------------------------------------------------------------
                
                % Internal energy terms ions
                %--------------------------------------------------------------------------
                vi_grad_Ui_in_a = sum(vi_grad_Ui,'all')./ss2;
                dk_Qijk_i_in_a = sum(dk_Qijk_i{1,1},'all')./ss2;
                dkQiik_05_i_in_a = sum(dkQiik_05_i{1,1},'all')./ss2;
                Pit_grad_vi_in_a = sum(Pit_grad_vi,'all')./ss2;
                Pit_grad_vi_ii_in_a = sum(Pit_grad_vi_ii,'all')./ss2;
                Pit_grad_vi_ij_in_a = sum(Pit_grad_vi_ij,'all')./ss2;
                Ui_Div_vi_in_a = sum(Ui_Div_vi,'all')./ss2;
                %dtUi_in_Gp_2_in_a = sum(dtUi_in_Gp_2,'all')./ss2;
                Xi_th_i_in_a = sum(Xi_th_i_in_dum,'all')./ss2;
                %--------------------------------------------------------------------------
                
                % Internal energy terms electrons
                %--------------------------------------------------------------------------
                ve_grad_Ue_in_a = sum(ve_grad_Ue,'all')./ss2;
                dk_Qijk_e_in_a = sum(dk_Qijk_e{1,1},'all')./ss2;
                dkQiik_05_e_in_a = sum(dkQiik_05_e{1,1},'all')./ss2;
                Pet_grad_ve_in_a = sum(Pet_grad_ve,'all')./ss2;
                Pet_grad_ve_ii_in_a = sum(Pet_grad_ve_ii,'all')./ss2;
                Pet_grad_ve_ij_in_a = sum(Pet_grad_ve_ij,'all')./ss2;
                Ue_Div_ve_in_a = sum(Ue_Div_ve,'all')./ss2;
                %dtUe_in_Gp_2_in_a = sum(dtUe_in_Gp_2,'all')./ss2;
                Xi_th_e_in_a = sum(Xi_th_e_in_dum,'all')./ss2;
                %--------------------------------------------------------------------------
                
                %
                %Kinetic Energy
                kin_energy_terms_ic{1,jnx,jny,jnz,in} = vi_grad_Ki_in_a;
                kin_energy_terms_ic{2,jnx,jny,jnz,in} = vi_Div_Pit_in_a;
                kin_energy_terms_ic{3,jnx,jny,jnz,in} = Ki_Div_vi_in_a;
                kin_energy_terms_ic{4,jnx,jny,jnz,in} = qi_ni_vi_E_in_a;
                
                kin_energy_terms_ec{1,jnx,jny,jnz,in} = ve_grad_Ke_in_a;
                kin_energy_terms_ec{2,jnx,jny,jnz,in} = ve_Div_Pet_in_a;
                kin_energy_terms_ec{3,jnx,jny,jnz,in} = Ke_Div_ve_in_a;
                kin_energy_terms_ec{4,jnx,jny,jnz,in} = qe_ne_ve_E_in_a;
                
                % Internal energy terms
                Int_energy_terms_ic{1,jnx,jny,jnz,in} = vi_grad_Ui_in_a;
                Int_energy_terms_ic{2,jnx,jny,jnz,in} = dk_Qijk_i_in_a;
                Int_energy_terms_ic{3,jnx,jny,jnz,in} = dkQiik_05_i_in_a;
                Int_energy_terms_ic{4,jnx,jny,jnz,in} = Pit_grad_vi_in_a;
                Int_energy_terms_ic{5,jnx,jny,jnz,in} = Pit_grad_vi_ii_in_a;
                Int_energy_terms_ic{6,jnx,jny,jnz,in} = Pit_grad_vi_ij_in_a;
                Int_energy_terms_ic{7,jnx,jny,jnz,in} = Ui_Div_vi_in_a;
                
                Int_energy_terms_ec{1,jnx,jny,jnz,in} = ve_grad_Ue_in_a;
                Int_energy_terms_ec{2,jnx,jny,jnz,in} = dk_Qijk_e_in_a;
                Int_energy_terms_ec{3,jnx,jny,jnz,in} = dkQiik_05_e_in_a;
                Int_energy_terms_ec{4,jnx,jny,jnz,in} = Pet_grad_ve_in_a;
                Int_energy_terms_ec{5,jnx,jny,jnz,in} = Pet_grad_ve_ii_in_a;
                Int_energy_terms_ec{6,jnx,jny,jnz,in} = Pet_grad_ve_ij_in_a;
                Int_energy_terms_ec{7,jnx,jny,jnz,in} = Ue_Div_ve_in_a;
                
                Dissipation_terms{1,jnx,jny,jnz,in}=Xi_k_i_in_a;
                Dissipation_terms{2,jnx,jny,jnz,in}=Xi_k_e_in_a;
                Dissipation_terms{3,jnx,jny,jnz,in}=Xi_th_i_in_a;
                Dissipation_terms{4,jnx,jny,jnz,in}=Xi_th_e_in_a;
                %--------------------------------------------------------------------------
                %--------------------------------------------------------------------------
                
                cd '/Volumes/PSC_DiRAC_DATA/DATACB104/raw_data';
                
                %--------------------------------------------------------------------------
                
                clearvars -except in jnx jny jnz... 
                    S N H Mx My Mz path ...
                    px1 py1 pz1 px2 py2 pz2 ...
                    kin_energy_terms_ic kin_energy_terms_ec ...
                    Int_energy_terms_ic Int_energy_terms_ec...
                    Dissipation_terms;
                %--------------------------------------------------------------------------
                
                %--------------------------------------------------------------------------
                cd '/Volumes/PSC_DiRAC_DATA/DATACB104/raw_data';
                path = '/Volumes/PSC_DiRAC_DATA/DATACB104/raw_data';
                %--------------------------------------------------------------------------
                
                % useful parameters used in the simulation
                %--------------------------------------------------------------------------
                kb = 1.; mu0 =1.; mi_over_me_ =100.; vA_over_c_ = 0.1; B0_ = vA_over_c_;
                mi = 1.; me = 1. / mi_over_me_; eps0=1.;
                omega_pi=1;
                Omega_e=vA_over_c_*sqrt(mi_over_me_)*omega_pi;
                Omega_i=Omega_e / mi_over_me_;
                TOmega_e=1/Omega_e;
                TOmega_i=1/Omega_i;
                dt=0.06;
                mime=100;
                %me=mi/mime;
                qi=1;
                qe=-1;
                %--------------------------------------------------------------------------
                               
                %--------------------------------------------------------------------------
                resx=0.06;  resy=0.06;  resz=0.06;
                
                px1 = px2 + (jnx-1)*px2;                
                
                start = [px1 py1 pz1];
                count = [px2 py2 pz2];
                                
                Lx=px2*resx; k0x=1/Lx;
                Ly=py2*resy; k0y=1/Ly;
                Lz=pz2*resz; k0z=1/Lz;
                k00=sqrt(k0x*k0x + k0y*k0y + k0z*k0z);
                                
                %disp('Start')
                %disp(start)
                %disp('count')
                %disp(count)                
                %--------------------------------------------------------------------------     
            end
            px1 = 1;
            py1 = py2 + (jny-1)*py2;                
        end
        px1 = 1; 
        py1 = 1; 
        pz1 = py2 + (jnz-1)*pz2;      
    end
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
cd '/Volumes/PSC_DiRAC_DATA/Energy_Budget_things'

save('powerdensity_and_dissipation_totalbox.mat',...
    'kin_energy_terms_ic','kin_energy_terms_ec',...
    'Int_energy_terms_ic','Int_energy_terms_ec','Dissipation_terms')
%--------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% To load the data in cells for the power density terms in time sub boxes
%--------------------------------------------------------------------------
cd '/Volumes/PSC_DiRAC_DATA/Energy_Budget_things'
load('powerdensity_and_dissipation_totalbox.mat')
%--------------------------------------------------------------------------

% This is to calculate the final average in time of the power density terms
% in time
%--------------------------------------------------------------------------
% usesless for loop
%--------------------------------------------------------------------------
%Kinetic Energy
%{
vi_grad_Ki_in_a = squeeze(kin_energy_terms_ic(1,:,:,:,:)) ;
vi_grad_Ki_in_a_data = squeeze(vi_grad_Ki_in_a(:,:,:,1));
vi_grad_Ki_in_a_T=0;
for i=1:4
    for j=1:4
        for k=1:20
            cond=~isempty(cell2mat(vi_grad_Ki_in_a_data(i,j,k)));
            if(cond)
                 vi_grad_Ki_in_a_T = vi_grad_Ki_in_a_T + cell2mat(vi_grad_Ki_in_a_data(i,j,k));
            else
                continue
            end
        end
    end
end
%}
%--------------------------------------------------------------------------
N=40;

vi_grad_Ki_in_a_T = zeros(1,40);
vi_Div_Pit_in_a_T = zeros(1,40);
Ki_Div_vi_in_a_T = zeros(1,40);
qi_ni_vi_E_in_a_T = zeros(1,40);

ve_grad_Ke_in_a_T = zeros(1,40);
ve_Div_Pet_in_a_T = zeros(1,40);
Ke_Div_ve_in_a_T = zeros(1,40);
qe_ne_ve_E_in_a_T = zeros(1,40);

% Internal energy terms
vi_grad_Ui_in_a_T = zeros(1,40);
dk_Qijk_i_in_a_T = zeros(1,40);
dkQiik_05_i_in_a_T = zeros(1,40);
Pit_grad_vi_in_a_T = zeros(1,40);
Pit_grad_vi_ii_in_a_T = zeros(1,40);
Pit_grad_vi_ij_in_a_T = zeros(1,40);
Ui_Div_vi_in_a_T = zeros(1,40);

ve_grad_Ue_in_a_T = zeros(1,40);
dk_Qijk_e_in_a_T = zeros(1,40);
dkQiik_05_e_in_a_T = zeros(1,40);
Pet_grad_ve_in_a_T = zeros(1,40);
Pet_grad_ve_ii_in_a_T = zeros(1,40);
Pet_grad_ve_ij_in_a_T = zeros(1,40);
Ue_Div_ve_in_a_T = zeros(1,40);

Xi_k_i_in_a_T = zeros(1,40);
Xi_k_e_in_a_T = zeros(1,40);
Xi_th_i_in_a_T = zeros(1,40);
Xi_th_e_in_a_T = zeros(1,40);


for in=1:N
    %--------------------------------------------------------------------------
    %Kinetic Energy
    %--------------------------------------------------------------------------
    vi_grad_Ki_in_a_data = squeeze(kin_energy_terms_ic(1,:,:,:,in));
    vi_Div_Pit_in_a_data = squeeze(kin_energy_terms_ic(2,:,:,:,in));
    Ki_Div_vi_in_a_data = squeeze(kin_energy_terms_ic(3,:,:,:,in));
    qi_ni_vi_E_in_a_data = squeeze(kin_energy_terms_ic(4,:,:,:,in));
    
    vi_grad_Ki_in_a_T(in) = sum([vi_grad_Ki_in_a_data{:}])/(3*3*19);
    vi_Div_Pit_in_a_T(in) = sum([vi_Div_Pit_in_a_data{:}])/(3*3*19);
    Ki_Div_vi_in_a_T(in) = sum([Ki_Div_vi_in_a_data{:}])/(3*3*19);
    qi_ni_vi_E_in_a_T(in) = sum([qi_ni_vi_E_in_a_data{:}])/(3*3*19);
    
    ve_grad_Ke_in_a_data = squeeze(kin_energy_terms_ec(1,:,:,:,in));
    ve_Div_Pet_in_a_data = squeeze(kin_energy_terms_ec(2,:,:,:,in));
    Ke_Div_ve_in_a_data = squeeze(kin_energy_terms_ec(3,:,:,:,in));
    qe_ne_ve_E_in_a_data = squeeze(kin_energy_terms_ec(4,:,:,:,in));
    
    ve_grad_Ke_in_a_T(in) = sum([ve_grad_Ke_in_a_data{:}])/(3*3*19);
    ve_Div_Pet_in_a_T(in) = sum([ve_Div_Pet_in_a_data{:}])/(3*3*19);
    Ke_Div_ve_in_a_T(in) = sum([Ke_Div_ve_in_a_data{:}])/(3*3*19);
    qe_ne_ve_E_in_a_T(in) = sum([qe_ne_ve_E_in_a_data{:}])/(3*3*19);
    %--------------------------------------------------------------------------
    
    % Internal energy terms
    %--------------------------------------------------------------------------
    vi_grad_Ui_in_a_data = squeeze(Int_energy_terms_ic(1,:,:,:,in));
    dk_Qijk_i_in_a_data = squeeze(Int_energy_terms_ic(2,:,:,:,in));
    dkQiik_05_i_in_a_data = squeeze(Int_energy_terms_ic(3,:,:,:,in));
    Pit_grad_vi_in_a_data = squeeze(Int_energy_terms_ic(4,:,:,:,in));
    Pit_grad_vi_ii_in_a_data = squeeze(Int_energy_terms_ic(5,:,:,:,in));
    Pit_grad_vi_ij_in_a_data = squeeze(Int_energy_terms_ic(6,:,:,:,in));
    Ui_Div_vi_in_a_data = squeeze(Int_energy_terms_ic(7,:,:,:,in));
    
    vi_grad_Ui_in_a_T(in) = sum([vi_grad_Ui_in_a_data{:}])/(3*3*19);
    dk_Qijk_i_in_a_T(in) = sum([dk_Qijk_i_in_a_data{:}])/(3*3*19);
    dkQiik_05_i_in_a_T(in) = sum([dkQiik_05_i_in_a_data{:}])/(3*3*19);
    Pit_grad_vi_in_a_T(in) = sum([Pit_grad_vi_in_a_data{:}])/(3*3*19);
    Pit_grad_vi_ii_in_a_T(in) = sum([Pit_grad_vi_ii_in_a_data{:}])/(3*3*19);
    Pit_grad_vi_ij_in_a_T(in) = sum([Pit_grad_vi_ij_in_a_data{:}])/(3*3*19);
    Ui_Div_vi_in_a_T(in) = sum([Ui_Div_vi_in_a_data{:}])/(3*3*19);
    
    ve_grad_Ue_in_a_data = squeeze(Int_energy_terms_ec(1,:,:,:,in));
    dk_Qijk_e_in_a_data = squeeze(Int_energy_terms_ec(2,:,:,:,in));
    dkQiik_05_e_in_a_data = squeeze(Int_energy_terms_ec(3,:,:,:,in));
    Pet_grad_ve_in_a_data = squeeze(Int_energy_terms_ec(4,:,:,:,in));
    Pet_grad_ve_ii_in_a_data = squeeze(Int_energy_terms_ec(5,:,:,:,in));
    Pet_grad_ve_ij_in_a_data = squeeze(Int_energy_terms_ec(6,:,:,:,in));
    Ue_Div_ve_in_a_data = squeeze(Int_energy_terms_ec(7,:,:,:,1));
    
    ve_grad_Ue_in_a_T(in)=sum([ve_grad_Ue_in_a_data{:}])/(3*3*19);
    dk_Qijk_e_in_a_T(in)=sum([dk_Qijk_e_in_a_data{:}])/(3*3*19);
    dkQiik_05_e_in_a_T(in)=sum([dkQiik_05_e_in_a_data{:}])/(3*3*19);
    Pet_grad_ve_in_a_T(in)=sum([Pet_grad_ve_in_a_data{:}])/(3*3*19);
    Pet_grad_ve_ii_in_a_T(in)=sum([Pet_grad_ve_ii_in_a_data{:}])/(3*3*19);
    Pet_grad_ve_ij_in_a_T(in)=sum([Pet_grad_ve_ij_in_a_data{:}])/(3*3*19);
    Ue_Div_ve_in_a_T(in)=sum([Ue_Div_ve_in_a_data{:}])/(3*3*19);
    %--------------------------------------------------------------------------
    
    %dissipation terms
    %--------------------------------------------------------------------------
    Xi_k_i_in_a_data = squeeze(Dissipation_terms(1,:,:,:,in));
    Xi_k_e_in_a_data = squeeze(Dissipation_terms(2,:,:,:,in));
    Xi_th_i_in_a_data = squeeze(Dissipation_terms(3,:,:,:,in));
    Xi_th_e_in_a_data = squeeze(Dissipation_terms(4,:,:,:,in));
    
    Xi_k_i_in_a_T(in)=sum([Xi_k_i_in_a_data{:}])/(3*3*19);
    Xi_k_e_in_a_T(in)=sum([Xi_k_e_in_a_data{:}])/(3*3*19);
    Xi_th_i_in_a_T(in)=sum([Xi_th_i_in_a_data{:}])/(3*3*19);
    Xi_th_e_in_a_T(in)=sum([Xi_th_e_in_a_data{:}])/(3*3*19);
    %--------------------------------------------------------------------------
end

cd '/Volumes/PSC_DiRAC_DATA/DATACB104/raw_data'; %This is important because the xdmf files are in that directory
path = '/Volumes/PSC_DiRAC_DATA/DATACB104/raw_data';

% useful parameters used in the simulation
%--------------------------------------------------------------------------
kb = 1.; mu0 =1.; mi_over_me_ =100.; vA_over_c_ = 0.1; B0_ = vA_over_c_;
mi = 1.; me = 1. / mi_over_me_; eps0=1.;
omega_pi=1;
Omega_e=vA_over_c_*sqrt(mi_over_me_)*omega_pi;
Omega_i=Omega_e / mi_over_me_;
TOmega_e=1/Omega_e; 
TOmega_i=1/Omega_i;
dt=0.06;
%------------------------------------------------------------------
mime=100;
qi=1;
qe=-1;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
S = dir(fullfile(path,'*.h5'));
N=numel(S); % number of files to use <---------------- This is the N 
H=zeros(N);
%--------------------------------------------------------------------------
nx1=166;    nx2=333;
ny1=232;    ny2=400;
nz1=1200;   nz2=1367;

px2 = 168; py2 = 168; pz2 = 168;
start = [nx1 ny1 nz1]; count = [px2 py2 pz2];
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
resx=0.06; %0.06081
resy=0.06;
resz=0.06; %0.06152

Lx=px2*resx; k0x=1/Lx;
Ly=px2*resy; k0y=1/Ly;
Lz=px2*resz; k0z=1/Lz;
k00=sqrt(k0x*k0x + k0y*k0y + k0z*k0z);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
time_line=zeros(1,N);
dt = 0.06;
for in=2:N-1
str = string(S(in).name);
newStr = extractBetween(str,"pfd.","_p000000.h5");
N_steps = str2double(newStr); time_t = dt*N_steps;
time_line(1,in) = time_t; 
end
%--------------------------------------------------------------------------

%Make the plots
%--------------------------------------------------------------------------
cd '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here'
load('colorblind_colormap.mat');

time = time_line;

c=1; VA2c = 0.1; B0 = VA2c; E0 = B0*VA2c;
Pi0 = mi*VA2c*VA2c; Pe0 = me*VA2c*VA2c;
% energies

lw = 3;
fs=25;
%--------------------------------------------------------------------------
f1 = figure(1);
plot(time(1:end-1),real(Xi_k_e_in_a_T(1:end-1))/Pi0,'Color',colorblind(2,:), 'LineWidth', lw)
hold on
plot(time(1:end-1),real(Xi_k_i_in_a_T(1:end-1))/Pi0,'Color',colorblind(6,:), 'LineWidth', lw)
plot(time(1:end-1),real(Xi_th_e_in_a_T(1:end-1))/Pi0,'Color',colorblind(7,:), 'LineWidth', lw)
plot(time(1:end-1),real(Xi_th_i_in_a_T(1:end-1))/Pi0,'Color',colorblind(5,:), 'LineWidth', lw)
legend('$\Xi^{k}_{e}$','$\Xi^{k}_{i}$','$\Xi^{th}_{e}$',...
    '$\Xi^{th}_{i}$','Interpreter','latex','FontSize',fs)
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('$\frac{\langle \Xi \rangle}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs)
xlim([24,456])
%ylim([-1.9, 1.9])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off

f2 = figure(2);
semilogy(time(1:end-1),abs(Xi_k_e_in_a_T(1:end-1))/Pi0,'Color',colorblind(2,:), 'LineWidth', lw)
hold on
semilogy(time(1:end-1),abs(Xi_k_i_in_a_T(1:end-1))/Pi0,'Color',colorblind(6,:), 'LineWidth', lw)
semilogy(time(1:end-1),abs(Xi_th_e_in_a_T(1:end-1))/Pi0,'Color',colorblind(7,:), 'LineWidth', lw)
semilogy(time(1:end-1),abs(Xi_th_i_in_a_T(1:end-1))/Pi0,'Color',colorblind(5,:), 'LineWidth', lw)
legend('$\Xi^{k}_{e}$','$\Xi^{k}_{i}$','$\Xi^{th}_{e}$',...
    '$\Xi^{th}_{i}$','Interpreter','latex','FontSize',fs)
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('$\frac{\langle \Xi \rangle}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs)
xlim([24,456])
%ylim([-1.9, 1.9])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off
%--------------------------------------------------------------------------


% To keep going it requieres to load the enery averages
%--------------------------------------------------------------------------
% To load the data in the subbox
%--------------------------------------------------------------------------
cd '/Volumes/PSC_DiRAC_DATA/Energy_Budget_things'
load('T_energy_terms_sub_12.mat')
fctr1=400*400*2016;
%--------------------------------------------------------------------------
energy_B_in_12_a = (cell2mat(T_energy_terms_sub_1(1,:)) + cell2mat(T_energy_terms_sub_2(1,:)))/(2*fctr1);
energy_E_in_12_a = (cell2mat(T_energy_terms_sub_1(2,:)) + cell2mat(T_energy_terms_sub_2(2,:)))/(2*fctr1);
energy_vi_in_12_a =  (cell2mat(T_energy_terms_sub_1(3,:)) + cell2mat(T_energy_terms_sub_2(3,:)))/(2*fctr1);
energy_ve_in_12_a =  (cell2mat(T_energy_terms_sub_1(4,:)) + cell2mat(T_energy_terms_sub_2(4,:)))/(2*fctr1);
energy_Pij_i_in_12_a =  (cell2mat(T_energy_terms_sub_1(5,:)) + cell2mat(T_energy_terms_sub_2(5,:)))/(2*fctr1);
energy_Pij_e_in_12_a =  (cell2mat(T_energy_terms_sub_1(6,:)) + cell2mat(T_energy_terms_sub_2(6,:)))/(2*fctr1);
ene_total_a = energy_B_in_12_a + energy_E_in_12_a + ...
             energy_vi_in_12_a + energy_ve_in_12_a + ...
             energy_Pij_i_in_12_a + energy_Pij_e_in_12_a;
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
fctr = 3*3*19;

time=time_line;

%--------------------------------------------------------------------------
%Total energies
%--------------------------------------------------------------------------
f21 = figure(21);
delta_ene = abs(energy_ve_in_12_a(2:end-1)); 
semilogy(time(2:end-1),(delta_ene/Pi0),'--','Color',colorblind(2,:), 'LineWidth', lw)
hold on
delta_ene = abs(energy_vi_in_12_a(2:end-1)); 
semilogy(time(2:end-1),(delta_ene./Pi0),'--','Color',colorblind(6,:), 'LineWidth', lw)
delta_ene = abs(energy_Pij_e_in_12_a(2:end-1)); 
semilogy(time(2:end-1),(delta_ene./Pi0),'--','Color',colorblind(7,:), 'LineWidth', lw)
delta_ene = abs(energy_Pij_i_in_12_a(2:end-1)); 
semilogy(time(2:end-1),(delta_ene./Pi0),'--','Color',colorblind(5,:), 'LineWidth', lw)

semilogy(time(2:end-1),abs(Xi_k_e_in_a_T(1:end-2))./Pi0,'-+','Color',colorblind(2,:), 'LineWidth', lw)
semilogy(time(2:end-1),abs(Xi_k_i_in_a_T(1:end-2))./Pi0,'-+','Color',colorblind(6,:), 'LineWidth', lw)
semilogy(time(2:end-1),abs(Xi_th_e_in_a_T(1:end-2))./Pi0,'-+','Color',colorblind(7,:), 'LineWidth', lw)
semilogy(time(2:end-1),abs(Xi_th_i_in_a_T(1:end-2))./Pi0,'-+','Color',colorblind(5,:), 'LineWidth', lw)

%delta_ene = abs(ene_total_a(2:end-1) - ene_total_a(1:end-2))./(time(2:end-1) -time(1:end-2)); 
%semilogy(time(2:end-1),(delta_ene./(ene_total_a(1:end-2))),'--','Color',colorblind(8,:), 'LineWidth', lw)
legend(...
    '${\varepsilon^{k}_{e}}$',...
    '${\varepsilon^{k}_{i}}$',...
    '${\varepsilon^{th}_{e}}$',...
    '${\varepsilon^{th}_{i}}$',...'${\varepsilon^{em}}$',...
    '$\Xi^{k}_{e}$',...
    '$\Xi^{k}_{i}$',...
    '$\Xi^{th}_{e}$',...
    '$\Xi^{th}_{i}$',...
    'Interpreter','latex','FontSize',fs,'NumColumns',2)%,...
    %'${\Delta\varepsilon^{T}_{e}}$',...
    %'${\varepsilon^{T}}$','Interpreter','latex','FontSize',fs)%...
    %'$\varepsilon^{E\times B}_{i}$','$\varepsilon^{E\times B}_{e}$'
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('$\frac{|\Delta \langle \varepsilon \rangle|}{\Delta t \langle \varepsilon^{T} \rangle},\frac{|\langle \Xi \rangle|}{\langle \varepsilon^{T} \rangle}$','Interpreter','latex','FontSize',fs)
xlim([18,456])
%ylim([-0.5, 1.1])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%Power densities 2
%--------------------------------------------------------------------------
f214552 = figure(214552);
delta_ene = abs(energy_ve_in_12_a(2:end-1) - energy_ve_in_12_a(1:end-2)./(time(2:end-1) -time(1:end-2))); 
semilogy(time(2:end-1),(delta_ene./(ene_total_a(1:end-2))),'--','Color',colorblind(2,:), 'LineWidth', lw)
hold on
delta_ene = abs(energy_vi_in_12_a(2:end-1) - energy_vi_in_12_a(1:end-2)./(time(2:end-1) -time(1:end-2))); 
semilogy(time(2:end-1),(delta_ene./(ene_total_a(1:end-2))),'--','Color',colorblind(6,:), 'LineWidth', lw)
delta_ene = abs(energy_Pij_e_in_12_a(2:end-1) - energy_Pij_e_in_12_a(1:end-2)./(time(2:end-1) -time(1:end-2))); 
semilogy(time(2:end-1),(delta_ene./(ene_total_a(1:end-2))),'--','Color',colorblind(7,:), 'LineWidth', lw)
delta_ene = abs(energy_Pij_i_in_12_a(2:end-1) - energy_Pij_i_in_12_a(1:end-2)./(time(2:end-1) -time(1:end-2))); 
semilogy(time(2:end-1),(delta_ene./(ene_total_a(1:end-2))),'--','Color',colorblind(5,:), 'LineWidth', lw)

semilogy(time(2:end-1),abs(Xi_k_e_in_a_T(1:end-2))./(ene_total_a(1:end-2)),'-+','Color',colorblind(2,:), 'LineWidth', lw)
semilogy(time(2:end-1),abs(Xi_k_i_in_a_T(1:end-2))./(ene_total_a(1:end-2)),'-+','Color',colorblind(6,:), 'LineWidth', lw)
semilogy(time(2:end-1),abs(Xi_th_e_in_a_T(1:end-2))./(ene_total_a(1:end-2)),'-+','Color',colorblind(7,:), 'LineWidth', lw)
semilogy(time(2:end-1),abs(Xi_th_i_in_a_T(1:end-2))./(ene_total_a(1:end-2)),'-+','Color',colorblind(5,:), 'LineWidth', lw)

delta_ene = abs(ene_total_a(2:end-1) - ene_total_a(1:end-2))./(time(2:end-1) -time(1:end-2)); 
semilogy(time(2:end-1),(delta_ene./(ene_total_a(1:end-2))),'--','Color',colorblind(8,:), 'LineWidth', lw)
legend(...
    '${\Delta\varepsilon^{k}_{e}}$',...
    '${\Delta\varepsilon^{k}_{i}}$',...
    '${\Delta\varepsilon^{th}_{e}}$',...
    '${\Delta\varepsilon^{th}_{i}}$',...'${\varepsilon^{em}}$',...
    '$\Xi^{k}_{e}$',...
    '$\Xi^{k}_{i}$',...
    '$\Xi^{th}_{e}$',...
    '$\Xi^{th}_{i}$',...
    '${\Delta\varepsilon^{T}_{full}}$',...
    'Interpreter','latex','FontSize',fs,'NumColumns',3)%,...
    %'${\varepsilon^{T}}$','Interpreter','latex','FontSize',fs)%...
    %'$\varepsilon^{E\times B}_{i}$','$\varepsilon^{E\times B}_{e}$'
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('$\frac{|\Delta \langle \varepsilon \rangle|}{\Delta t \langle \varepsilon^{T} \rangle},\frac{|\langle \Xi \rangle|}{\langle \varepsilon^{T} \rangle}$','Interpreter','latex','FontSize',fs)
xlim([18,456])
%ylim([-0.5, 1.1])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%Power densities 22
%--------------------------------------------------------------------------
f2145522 = figure(2145522);
delta_ene = abs(energy_ve_in_12_a(2:end-1) - energy_ve_in_12_a(1:end-2)./(time(2:end-1) -time(1:end-2))); 
semilogy(time(2:end-1),(delta_ene./(ene_total_a(1:end-2))),'--','Color',colorblind(2,:), 'LineWidth', lw)
hold on
delta_ene = abs(energy_vi_in_12_a(2:end-1) - energy_vi_in_12_a(1:end-2)./(time(2:end-1) -time(1:end-2))); 
semilogy(time(2:end-1),(delta_ene./(ene_total_a(1:end-2))),'--','Color',colorblind(6,:), 'LineWidth', lw)
delta_ene = abs(energy_Pij_e_in_12_a(2:end-1) - energy_Pij_e_in_12_a(1:end-2)./(time(2:end-1) -time(1:end-2))); 
semilogy(time(2:end-1),(delta_ene./(ene_total_a(1:end-2))),'--','Color',colorblind(7,:), 'LineWidth', lw)
delta_ene = abs(energy_Pij_i_in_12_a(2:end-1) - energy_Pij_i_in_12_a(1:end-2)./(time(2:end-1) -time(1:end-2))); 
semilogy(time(2:end-1),(delta_ene./(ene_total_a(1:end-2))),'--','Color',colorblind(5,:), 'LineWidth', lw)

semilogy(time(2:end-1),abs(Xi_k_e_in_a_T(1:end-2))./(ene_total_a(1:end-2)),'-+','Color',colorblind(2,:), 'LineWidth', lw)
semilogy(time(2:end-1),abs(Xi_k_i_in_a_T(1:end-2))./(ene_total_a(1:end-2)),'-+','Color',colorblind(6,:), 'LineWidth', lw)
semilogy(time(2:end-1),abs(Xi_th_e_in_a_T(1:end-2))./(ene_total_a(1:end-2)),'-+','Color',colorblind(7,:), 'LineWidth', lw)
semilogy(time(2:end-1),abs(Xi_th_i_in_a_T(1:end-2))./(ene_total_a(1:end-2)),'-+','Color',colorblind(5,:), 'LineWidth', lw)

%delta_ene = abs(ene_total_a(2:end-1) - ene_total_a(1:end-2))./(time(2:end-1) -time(1:end-2)); 
%semilogy(time(2:end-1),(delta_ene./(ene_total_a(1:end-2))),'--','Color',colorblind(8,:), 'LineWidth', lw)
legend(...
    '${\Delta\varepsilon^{k}_{e}}$',...
    '${\Delta\varepsilon^{k}_{i}}$',...
    '${\Delta\varepsilon^{th}_{e}}$',...
    '${\Delta\varepsilon^{th}_{i}}$',...'${\varepsilon^{em}}$',...
    '$\Xi^{k}_{e}$',...
    '$\Xi^{k}_{i}$',...
    '$\Xi^{th}_{e}$',...
    '$\Xi^{th}_{i}$',...
    'Interpreter','latex','FontSize',fs,'NumColumns',2)%,...
    %'${\varepsilon^{T}}$','Interpreter','latex','FontSize',fs)%...
    %'$\varepsilon^{E\times B}_{i}$','$\varepsilon^{E\times B}_{e}$'
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('$\frac{|\Delta \langle \varepsilon \rangle|}{\Delta t \langle \varepsilon^{T} \rangle},\frac{|\langle \Xi \rangle|}{\langle \varepsilon^{T} \rangle}$','Interpreter','latex','FontSize',fs)
xlim([18,456])
%ylim([-0.5, 1.1])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off
%--------------------------------------------------------------------------

cd '/Volumes/PSC_DiRAC_DATA/Energy_Budget_things'
saveas(f2145522,strcat('d_energy_xi_full_single'+ string(N_steps) +'.png'));
saveas(f214552,strcat('d_energy_xi_full'+ string(N_steps) +'.png'));
%--------------------------------------------------------------------------


% clear work space first
% This part loads the plots of the deltas sub box
%--------------------------------------------------------------------------
load('/Volumes/PSC_DiRAC_DATA/Energy_Budget_things/energies_xi_3d_subbox_last_08052022.mat')
load('/Volumes/PSC_DiRAC_DATA/Energy_Budget_things/Energy_table_sub_Energy_full.mat') 
% I need to keep both because there is something overwriting the energy_table_sub_box
%--------------------------------------------------------------------------
% get the plot of the power densities
%--------------------------------------------------------------------------
cd '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here'
load('colorblind_colormap.mat');



%--------------------------------------------------------------------------
%Power densities 2
%--------------------------------------------------------------------------
f214552 = figure(214552);
delta_ene = abs(ene_kin_e_sub(2:end-1) - ene_kin_e_sub(1:end-2)./(time(2:end-1) -time(1:end-2))); 
semilogy(time(2:end-1),(delta_ene./(ene_total_sub(1:end-2))),'--','Color',colorblind(2,:), 'LineWidth', lw)
hold on
delta_ene = abs(ene_kin_i_sub(2:end-1) - ene_kin_i_sub(1:end-2)./(time(2:end-1) -time(1:end-2))); 
semilogy(time(2:end-1),(delta_ene./(ene_total_sub(1:end-2))),'--','Color',colorblind(6,:), 'LineWidth', lw)
delta_ene = abs(ene_the_e_sub(2:end-1) - ene_the_e_sub(1:end-2)./(time(2:end-1) -time(1:end-2))); 
semilogy(time(2:end-1),(delta_ene./(ene_total_sub(1:end-2))),'--','Color',colorblind(7,:), 'LineWidth', lw)
delta_ene = abs(ene_the_i_sub(2:end-1) - ene_the_i_sub(1:end-2)./(time(2:end-1) -time(1:end-2))); 
semilogy(time(2:end-1),(delta_ene./(ene_total_sub(1:end-2))),'--','Color',colorblind(5,:), 'LineWidth', lw)

semilogy(time(2:end-1),sub_box.*abs(Xi_k_e_in_3dbox(1:end-2))./(ene_total_sub(1:end-2)'),'-+','Color',colorblind(2,:), 'LineWidth', lw)
semilogy(time(2:end-1),sub_box.*abs(Xi_k_i_in_3dbox(1:end-2))./(ene_total_sub(1:end-2)'),'-+','Color',colorblind(6,:), 'LineWidth', lw)
semilogy(time(2:end-1),sub_box.*abs(Xi_th_e_in_3dbox(1:end-2))./(ene_total_sub(1:end-2)'),'-+','Color',colorblind(7,:), 'LineWidth', lw)
semilogy(time(2:end-1),sub_box.*abs(Xi_th_i_in_3dbox(1:end-2))./(ene_total_sub(1:end-2)'),'-+','Color',colorblind(5,:), 'LineWidth', lw)

%delta_ene = abs(ene_total(2:end-1) - ene_total(1:end-2))./(time(2:end-1) -time(1:end-2)); 
%semilogy(time(2:end-1),(delta_ene./(ene_total(1:end-2))),'-','Color',colorblind(8,:), 'LineWidth', lw)
delta_ene = abs(ene_total_sub(2:end-1) - ene_total_sub(1:end-2))./(time(2:end-1) -time(1:end-2)); 
semilogy(time(2:end-1),(delta_ene./(ene_total_sub(1:end-2))),'--','Color',colorblind(8,:), 'LineWidth', lw)
legend(...
    '${\Delta\varepsilon^{k}_{e}}$',...
    '${\Delta\varepsilon^{k}_{i}}$',...
    '${\Delta\varepsilon^{th}_{e}}$',...
    '${\Delta\varepsilon^{th}_{i}}$',...'${\varepsilon^{em}}$',...
    '$\Xi^{k}_{e}$',...
    '$\Xi^{k}_{i}$',...
    '$\Xi^{th}_{e}$',...
    '$\Xi^{th}_{i}$',...
    '${\Delta\varepsilon^{T}_{sub}}$',...
    'Interpreter','latex','FontSize',fs,'NumColumns',3)%,...
    %'${\varepsilon^{T}}$','Interpreter','latex','FontSize',fs)%...
    %'$\varepsilon^{E\times B}_{i}$','$\varepsilon^{E\times B}_{e}$'
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('$\frac{|\Delta \langle \varepsilon \rangle|}{\Delta t \langle \varepsilon^{T} \rangle},\frac{|\langle \Xi \rangle|}{\langle \varepsilon^{T} \rangle}$','Interpreter','latex','FontSize',fs)
xlim([18,456])
%ylim([-0.5, 1.1])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off
%--------------------------------------------------------------------------

f2145522 = figure(2145522);
delta_ene = abs(ene_kin_e_sub(2:end-1) - ene_kin_e_sub(1:end-2)./(time(2:end-1) -time(1:end-2))); 
semilogy(time(2:end-1),(delta_ene./(ene_total_sub(1:end-2))),'--','Color',colorblind(2,:), 'LineWidth', lw)
hold on
delta_ene = abs(ene_kin_i_sub(2:end-1) - ene_kin_i_sub(1:end-2)./(time(2:end-1) -time(1:end-2))); 
semilogy(time(2:end-1),(delta_ene./(ene_total_sub(1:end-2))),'--','Color',colorblind(6,:), 'LineWidth', lw)
delta_ene = abs(ene_the_e_sub(2:end-1) - ene_the_e_sub(1:end-2)./(time(2:end-1) -time(1:end-2))); 
semilogy(time(2:end-1),(delta_ene./(ene_total_sub(1:end-2))),'--','Color',colorblind(7,:), 'LineWidth', lw)
delta_ene = abs(ene_the_i_sub(2:end-1) - ene_the_i_sub(1:end-2)./(time(2:end-1) -time(1:end-2))); 
semilogy(time(2:end-1),(delta_ene./(ene_total_sub(1:end-2))),'--','Color',colorblind(5,:), 'LineWidth', lw)

semilogy(time(2:end-1),sub_box.*abs(Xi_k_e_in_3dbox(1:end-2))./(ene_total_sub(1:end-2)'),'-+','Color',colorblind(2,:), 'LineWidth', lw)
semilogy(time(2:end-1),sub_box.*abs(Xi_k_i_in_3dbox(1:end-2))./(ene_total_sub(1:end-2)'),'-+','Color',colorblind(6,:), 'LineWidth', lw)
semilogy(time(2:end-1),sub_box.*abs(Xi_th_e_in_3dbox(1:end-2))./(ene_total_sub(1:end-2)'),'-+','Color',colorblind(7,:), 'LineWidth', lw)
semilogy(time(2:end-1),sub_box.*abs(Xi_th_i_in_3dbox(1:end-2))./(ene_total_sub(1:end-2)'),'-+','Color',colorblind(5,:), 'LineWidth', lw)

legend(...
    '${\Delta\varepsilon^{k}_{e}}$',...
    '${\Delta\varepsilon^{k}_{i}}$',...
    '${\Delta\varepsilon^{th}_{e}}$',...
    '${\Delta\varepsilon^{th}_{i}}$',...'${\varepsilon^{em}}$',...
    '$\Xi^{k}_{e}$',...
    '$\Xi^{k}_{i}$',...
    '$\Xi^{th}_{e}$',...
    '$\Xi^{th}_{i}$',...
    'Interpreter','latex','FontSize',fs,'NumColumns',2)%,...
    %'${\varepsilon^{T}}$','Interpreter','latex','FontSize',fs)%...
    %'$\varepsilon^{E\times B}_{i}$','$\varepsilon^{E\times B}_{e}$'
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('$\frac{|\Delta \langle \varepsilon \rangle|}{\Delta t \langle \varepsilon^{T} \rangle},\frac{|\langle \Xi \rangle|}{\langle \varepsilon^{T} \rangle}$','Interpreter','latex','FontSize',fs)
xlim([18,456])
%ylim([-0.5, 1.1])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off
%--------------------------------------------------------------------------

% I keep the same plot number to have the same size
cd '/Volumes/PSC_DiRAC_DATA/Energy_Budget_things'
saveas(f2145522,strcat('d_energy_xi_sub_single'+ string(N_steps) +'.png'));
saveas(f214552,strcat('d_energy_xi_sub'+ string(N_steps) +'.png'));
