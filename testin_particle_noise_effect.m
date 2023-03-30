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

%px2 = 400; py2 = 400; pz2 = 168; For the no reference change
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
T_energy_terms_sub_1=T_energy_terms_sub;

%This is what is next
T_energy_terms_sub_2=T_energy_terms_sub;
%------------------------------------------------------------------
cd '/Volumes/PSC_DiRAC_DATA/Energy_Budget_things'

save('T_energy_terms_sub_12.mat','T_energy_terms_sub_1','T_energy_terms_sub_2')
%--------------------------------------------------------------------------
% To load the data in the subbox
%--------------------------------------------------------------------------
cd '/Volumes/PSC_DiRAC_DATA/Energy_Budget_things'
load('T_energy_terms_sub_12.mat')
%--------------------------------------------------------------------------





% It is important to check the normalization 

% These are the data of the enerdy density integrated over the full box 
load('/Volumes/PSC_DiRAC_DATA/Energy_Budget_things/energy_densities_time.mat')


% These are the data of the enerdy density integrated over the subdomain box 
load('/Volumes/PSC_DiRAC_DATA/Energy_Budget_things/energy_densities_time_sub.mat')


% These are the data of the enerdy density integrated over the subdomain box 
load('/Volumes/PSC_DiRAC_DATA/Energy_Budget_things/energy_velocities_ratios_sub.mat')

%--------------------------------------------------------------------------
% get the data in a table to use that syntaxis 
%T_energy_terms_table = cell2table(T_energy_terms');
%--------------------------------------------------------------------------
% get the data in a array to use that syntaxis 
T_energy_terms_table_sub = cell2mat(T_energy_terms_sub');
ene_BE_sub = T_energy_terms_table_sub(:,1) + T_energy_terms_table_sub(:,2); %electromagnetic energy
ene_kin_i_sub = T_energy_terms_table_sub(:,3);
ene_kin_e_sub = T_energy_terms_table_sub(:,4);
ene_the_i_sub = T_energy_terms_table_sub(:,5);
ene_the_e_sub = T_energy_terms_table_sub(:,6);

ene_Vexb_e_sub = T_energy_terms_table_sub(:,7);
ene_Vexb_i_sub = T_energy_terms_table_sub(:,8);
ene_E_sub = T_energy_terms_table_sub(:,1);

ene_total_sub = ene_BE_sub +...
    ene_kin_i_sub + ene_kin_e_sub +...
    ene_the_i_sub + ene_the_e_sub;

T_velocities_table_sub = cell2mat(T_velocities_sub');
E_2_sub = T_velocities_table_sub(:,1);
V_exb_2_sub = T_velocities_table_sub(:,2);
vi_2_sub = T_velocities_table_sub(:,3);
ve_2_sub = T_velocities_table_sub(:,4);
vth_i_2_sub = T_velocities_table_sub(:,5);
vth_e_2_sub = T_velocities_table_sub(:,6);

T_ratios_table_sub = cell2mat(T_ratios_sub');
E_2_2_nimivi_2_sub = T_ratios_table_sub(:,1);
V_exb_2_2_vi_2_sub = T_ratios_table_sub(:,2);
E_2_2_nemeve_2_sub = T_ratios_table_sub(:,3);
V_exb_2_2_ve_2_sub = T_ratios_table_sub(:,4);
V_exb_2_2_vth_i_2_sub = T_ratios_table_sub(:,5);
vth_i_2_2_vi_2_sub = T_ratios_table_sub(:,6);
V_exb_2_2_vth_e_2_sub = T_ratios_table_sub(:,7);
vth_e_2_2_ve_2_sub = T_ratios_table_sub(:,8);
%--------------------------------------------------------------------------

%
cd '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here'
load('colorblind_colormap.mat');
%--------------------------------------------------------------------------

%Create the time array
time_line=zeros(1,N);
dt = 0.06;
for in=2:N-1
str = string(S(in).name);
newStr = extractBetween(str,"pfd.","_p000000.h5");
N_steps = str2double(newStr); time_t = dt*N_steps;
time_line(1,in) = time_t; 
end

time = time_line';

c=1;
VA2c = 0.1; B0 = VA2c; E0 = B0*VA2c;
Pi0 = mi*VA2c*VA2c; Pe0 = me*VA2c*VA2c;
% energies
VA2c1=400*400*2016*Pi0;
VA2c2=168*168*168*Pi0;

sub_box=168*168*168;
%--------------------------------------------------------------------------
%

% Energie densities
%--------------------------------------------------------------------------
lw = 3;
fs=25;
f214 = figure(214);
semilogy(time(1:end-1),ene_BE_sub(1:end-1)/sub_box,'--','Color',colorblind(1,:), 'LineWidth', lw)
hold on
semilogy(time(1:end-1),ene_kin_i_sub(1:end-1)/sub_box,'--','Color',colorblind(2,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_kin_e_sub(1:end-1)/sub_box,'--','Color',colorblind(6,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_the_i_sub(1:end-1)/sub_box,'--','Color',colorblind(7,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_the_e_sub(1:end-1)/sub_box,'--','Color',colorblind(5,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_total_sub(1:end-1)/sub_box,'--','Color',colorblind(8,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_Vexb_i_sub(1:end-1)/sub_box,'--','Color',colorblind(9,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_Vexb_e_sub(1:end-1)/sub_box,'--','Color',colorblind(10,:), 'LineWidth', lw)
legend('$\varepsilon^{em}$',...
    '$\varepsilon^{k}_{i}$','$\varepsilon^{k}_{e}$',...
    '$\varepsilon^{th}_{i}$','$\varepsilon^{th}_{e}$',...
    '$\varepsilon^{T}$',...
    '$\varepsilon^{E\times B}_{i}$','$\varepsilon^{E\times B}_{e}$','Interpreter','latex','FontSize',fs)
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('$\frac{\langle \varepsilon \rangle}{\varepsilon_{0}}$','Interpreter','latex','FontSize',fs)
xlim([18,456])
%ylim([-1.9, 1.9])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off
%--------------------------------------------------------------------------

%Power densities
%--------------------------------------------------------------------------
f21455 = figure(21455);
plot(time(2:end-1),(ene_BE_sub(1:end-2)./(time(2:end-1)-time(1:end-2)))/sub_box,'--','Color',colorblind(1,:), 'LineWidth', lw)
hold on
plot(time(2:end-1),(ene_kin_i_sub(1:end-2)./(time(2:end-1)-time(1:end-2)))/sub_box,'--','Color',colorblind(2,:), 'LineWidth', lw)
plot(time(2:end-1),(ene_kin_e_sub(1:end-2)./(time(2:end-1)-time(1:end-2)))/sub_box,'--','Color',colorblind(6,:), 'LineWidth', lw)
plot(time(2:end-1),(ene_the_i_sub(1:end-2)./(time(2:end-1)-time(1:end-2)))/sub_box,'--','Color',colorblind(7,:), 'LineWidth', lw)
plot(time(2:end-1),(ene_the_e_sub(1:end-2)./(time(2:end-1)-time(1:end-2)))/sub_box,'--','Color',colorblind(5,:), 'LineWidth', lw)
plot(time(2:end-1),(ene_total_sub(1:end-2)./(time(2:end-1)-time(1:end-2)))/sub_box,'--','Color',colorblind(8,:), 'LineWidth', lw)
%semilogy(time(2:end-1),(ene_Vexb_i_sub(2:end-1)./(time(2:end-1)-time(1:end-2)))/sub_box,'Color',colorblind(9,:), 'LineWidth', lw)
%semilogy(time(2:end-1),(ene_Vexb_e_sub(2:end-1)./(time(2:end-1)-time(1:end-2)))/sub_box,'Color',colorblind(10,:), 'LineWidth', lw)
legend('${\varepsilon^{em}}$',...
    '${\varepsilon^{k}_{i}}$',...
    '${\varepsilon^{k}_{e}}$',...
    '${\varepsilon^{th}_{i}}$',...
    '${\varepsilon^{th}_{e}}$',...
    '${\varepsilon^{T}}$','Interpreter','latex','FontSize',fs)%...
    %'$\varepsilon^{E\times B}_{i}$','$\varepsilon^{E\times B}_{e}$'
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('$\frac{\langle \varepsilon \rangle}{\Delta\varepsilon_{0}\Delta t}$','Interpreter','latex','FontSize',fs)
xlim([18,456])
%ylim([-1.9, 1.9])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off
%--------------------------------------------------------------------------

%Power densities 2
%--------------------------------------------------------------------------
f21455 = figure(21455);
semilogy(time(2:end-1),(sign(ene_kin_e_sub(1:end-2)).*ene_kin_e_sub(1:end-2)./(ene_total_sub(1:end-2))),'--','Color',colorblind(2,:), 'LineWidth', lw)
hold on
semilogy(time(2:end-1),(sign(ene_kin_i_sub(1:end-2)).*ene_kin_i_sub(1:end-2)./(ene_total_sub(1:end-2))),'--','Color',colorblind(6,:), 'LineWidth', lw)
semilogy(time(2:end-1),(sign(ene_the_e_sub(1:end-2)).*ene_the_e_sub(1:end-2)./(ene_total_sub(1:end-2))),'--','Color',colorblind(7,:), 'LineWidth', lw)
semilogy(time(2:end-1),(sign(ene_the_i_sub(1:end-2)).*ene_the_i_sub(1:end-2)./(ene_total_sub(1:end-2))),'--','Color',colorblind(5,:), 'LineWidth', lw)
semilogy(time(2:end-1),(sign(ene_BE_sub(1:end-2)).*ene_BE_sub(1:end-2)./(ene_total_sub(1:end-2))),'--','Color',colorblind(1,:), 'LineWidth', lw)
semilogy(time(2:end-1),sub_box.*sign(real(Xi_k_e_in_3dbox(1:end-2))).*real(Xi_k_e_in_3dbox(1:end-2))./(ene_total_sub(1:end-2)'.*Pi0),'Color',colorblind(2,:), 'LineWidth', lw)
semilogy(time(2:end-1),sub_box.*sign(real(Xi_k_i_in_3dbox(1:end-2))).*real(Xi_k_i_in_3dbox(1:end-2))./(ene_total_sub(1:end-2)'.*Pi0),'Color',colorblind(6,:), 'LineWidth', lw)
semilogy(time(2:end-1),sub_box.*sign(real(Xi_th_e_in_3dbox(1:end-2))).*real(Xi_th_e_in_3dbox(1:end-2))./(ene_total_sub(1:end-2)'.*Pi0),'Color',colorblind(7,:), 'LineWidth', lw)
semilogy(time(2:end-1),sub_box.*sign(real(Xi_th_i_in_3dbox(1:end-2))).*real(Xi_th_i_in_3dbox(1:end-2))./(ene_total_sub(1:end-2)'.*Pi0),'Color',colorblind(5,:), 'LineWidth', lw)
%plot(time(2:end-1),(ene_total_sub(1:end-2)./6)/sub_box,'--','Color',colorblind(8,:), 'LineWidth', lw)
%semilogy(time(2:end-1),(ene_Vexb_i_sub(2:end-1)./(time(2:end-1)-time(1:end-2)))/sub_box,'Color',colorblind(9,:), 'LineWidth', lw)
%semilogy(time(2:end-1),(ene_Vexb_e_sub(2:end-1)./(time(2:end-1)-time(1:end-2)))/sub_box,'Color',colorblind(10,:), 'LineWidth', lw)
legend( '${\varepsilon^{k}_{e}}$',...
    '${\varepsilon^{k}_{i}}$',...
    '${\varepsilon^{th}_{e}}$',...
    '${\varepsilon^{th}_{i}}$',...
    '${\varepsilon^{em}}$',...
    '$\Xi^{k}_{e}$',...
    '$\Xi^{k}_{i}$',...
    '$\Xi^{th}_{e}$',...
    '$\Xi^{th}_{i}$','Interpreter','latex','FontSize',fs,'NumColumns',2)%,...
    %'${\varepsilon^{T}}$','Interpreter','latex','FontSize',fs)%...
    %'$\varepsilon^{E\times B}_{i}$','$\varepsilon^{E\times B}_{e}$'
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('$\frac{\langle \varepsilon \rangle}{\Delta t \varepsilon^{T}},\frac{\langle \Xi \rangle}{\varepsilon^{T}}$','Interpreter','latex','FontSize',fs)
xlim([18,456])
%ylim([-0.5, 1.1])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off


f5556 = figure(556);
plot(time(1:end-1),real(Xi_k_e_in_3dbox(1:end-1))/Pi0,'Color',colorblind(1,:), 'LineWidth', lw)
hold on
plot(time(1:end-1),real(Xi_k_i_in_3dbox(1:end-1))/Pi0,'Color',colorblind(2,:), 'LineWidth', lw)
plot(time(1:end-1),real(Xi_th_e_in_3dbox(1:end-1))/Pi0,'Color',colorblind(6,:), 'LineWidth', lw)
plot(time(1:end-1),real(Xi_th_i_in_3dbox(1:end-1))/Pi0,'Color',colorblind(7,:), 'LineWidth', lw)
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


%--------------------------------------------------------------------------
f2131 = figure(2131);
plot(time(1:end-1),ene_BE_sub(1:end-1)/sub_box,'--','Color',colorblind(1,:), 'LineWidth', lw)
hold on
plot(time(1:end-1),ene_kin_i_sub(1:end-1)/sub_box,'--','Color',colorblind(2,:), 'LineWidth', lw)
plot(time(1:end-1),ene_kin_e_sub(1:end-1)/sub_box,'--','Color',colorblind(6,:), 'LineWidth', lw)
plot(time(1:end-1),ene_the_i_sub(1:end-1)/sub_box,'--','Color',colorblind(7,:), 'LineWidth', lw)
plot(time(1:end-1),ene_the_e_sub(1:end-1)/sub_box,'--','Color',colorblind(5,:), 'LineWidth', lw)
plot(time(1:end-1),ene_total_sub(1:end-1)/sub_box,'--','Color',colorblind(8,:), 'LineWidth', lw)
%plot(time(1:end-1),ene_Vexb_i_sub(1:end-1)/sub_box,'Color',colorblind(9,:), 'LineWidth', lw)
%plot(time(1:end-1),ene_Vexb_e_sub(1:end-1)/sub_box,'Color',colorblind(10,:), 'LineWidth', lw)
legend('$\varepsilon^{em}$',...
    '$\varepsilon^{k}_{i}$','$\varepsilon^{k}_{e}$',...
    '$\varepsilon^{th}_{i}$','$\varepsilon^{th}_{e}$',...
    '$\varepsilon^{T}$','Interpreter','latex','FontSize',fs)%,...
    %'$\varepsilon^{E\times B}_{i}$','$\varepsilon^{E\times B}_{e}$',...
    %'Interpreter','latex','FontSize',fs)
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('$\frac{\langle \varepsilon \rangle}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs)
xlim([18,456])
%ylim([-1.9, 1.9])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off



%ratios
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
f2132 = figure(2132);
plot(time(1:end-1),E_2_2_nimivi_2_sub(1:end-1)/sub_box,'--','Color',colorblind(1,:), 'LineWidth', lw)
hold on
plot(time(1:end-1),V_exb_2_2_vi_2_sub(1:end-1)/sub_box,'--','Color',colorblind(2,:), 'LineWidth', lw)
plot(time(1:end-1),E_2_2_nemeve_2_sub(1:end-1)/sub_box,'--','Color',colorblind(6,:), 'LineWidth', lw)
plot(time(1:end-1),V_exb_2_2_ve_2_sub(1:end-1)/sub_box,'--','Color',colorblind(7,:), 'LineWidth', lw)
plot(time(1:end-1),V_exb_2_2_vth_i_2_sub(1:end-1)/sub_box,'--','Color',colorblind(5,:), 'LineWidth', lw)
plot(time(1:end-1),vth_i_2_2_vi_2_sub(1:end-1)/sub_box,'--','Color',colorblind(8,:), 'LineWidth', lw)
plot(time(1:end-1),V_exb_2_2_vth_e_2_sub(1:end-1)/sub_box,'--','Color',colorblind(9,:), 'LineWidth', lw)
plot(time(1:end-1),vth_e_2_2_ve_2_sub(1:end-1)/sub_box,'--','Color',colorblind(10,:), 'LineWidth', lw)
legend('$\varepsilon^{E}/\varepsilon^{k}_{i}$',...
    '$v_{E \times B}^{2}/v^{2}_{i}$',...
    '$\varepsilon^{E}/\varepsilon^{k}_{e}$',...
    '$v_{E \times B}^{2}/v^{2}_{e}$',...
    '$v_{E \times B}^{2}/v^{2}_{th,i}$',...
    '$v^{2}_{th,i}/v^{2}_{i}$',...
    '$v_{E \times B}^{2}/v^{2}_{th,e}$',...
    '$v^{2}_{th,e}/v^{2}_{e}$',...
    'Interpreter','latex','FontSize',fs)
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
%ylabel('$\frac{\langle \varepsilon \rangle}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs)
xlim([18,456])
%ylim([-1.9, 1.9])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off
%--------------------------------------------------------------------------

%ratios
%--------------------------------------------------------------------------
f21322 = figure(21322);
semilogy(time(1:end-1),E_2_2_nimivi_2_sub(1:end-1)/sub_box,'--','Color',colorblind(1,:), 'LineWidth', lw)
hold on
semilogy(time(1:end-1),V_exb_2_2_vi_2_sub(1:end-1)/sub_box,'--','Color',colorblind(2,:), 'LineWidth', lw)
semilogy(time(1:end-1),E_2_2_nemeve_2_sub(1:end-1)/sub_box,'--','Color',colorblind(6,:), 'LineWidth', lw)
semilogy(time(1:end-1),V_exb_2_2_ve_2_sub(1:end-1)/sub_box,'--','Color',colorblind(7,:), 'LineWidth', lw)
semilogy(time(1:end-1),V_exb_2_2_vth_i_2_sub(1:end-1)/sub_box,'--','Color',colorblind(5,:), 'LineWidth', lw)
semilogy(time(1:end-1),vth_i_2_2_vi_2_sub(1:end-1)/sub_box,'--','Color',colorblind(8,:), 'LineWidth', lw)
semilogy(time(1:end-1),V_exb_2_2_vth_e_2_sub(1:end-1)/sub_box,'--','Color',colorblind(9,:), 'LineWidth', lw)
semilogy(time(1:end-1),vth_e_2_2_ve_2_sub(1:end-1)/sub_box,'--','Color',colorblind(10,:), 'LineWidth', lw)
legend('$\varepsilon^{E}/\varepsilon^{k}_{i}$',...
    '$v_{E \times B}^{2}/u^{2}_{i}$',...
    '$\varepsilon^{E}/\varepsilon^{k}_{e}$',...
    '$v_{E \times B}^{2}/u^{2}_{e}$',...
    '$v_{E \times B}^{2}/v^{2}_{th,i}$',...
    '$v^{2}_{th,i}/u^{2}_{i}$',...
    '$v_{E \times B}^{2}/v^{2}_{th,e}$',...
    '$v^{2}_{th,e}/u^{2}_{e}$',...
    'Interpreter','latex','FontSize',fs)
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
%ylabel('$\frac{\langle \varepsilon \rangle}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs)
xlim([18,456])
%ylim([-1.9, 1.9])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off
%--------------------------------------------------------------------------


%ratios only electrons
%--------------------------------------------------------------------------
f21321 = figure(21321);
semilogy(time(1:end-1),(E_2_2_nemeve_2_sub(1:end-1))/sub_box,'--','Color',colorblind(6,:), 'LineWidth', lw)
hold on
semilogy(time(1:end-1),(ene_E_sub(1:end-1)./ene_the_e_sub(1:end-1))/sub_box,'--','Color',colorblind(1,:), 'LineWidth', lw)
semilogy(time(1:end-1),sqrt(V_exb_2_2_ve_2_sub(1:end-1))/sub_box,'--','Color',colorblind(7,:), 'LineWidth', lw)
semilogy(time(1:end-1),sqrt(V_exb_2_2_vth_e_2_sub(1:end-1))/sub_box,'--','Color',colorblind(9,:), 'LineWidth', lw)
semilogy(time(1:end-1),sqrt(1./vth_e_2_2_ve_2_sub(1:end-1))/sub_box,'--','Color',colorblind(10,:), 'LineWidth', lw)
legend('$\varepsilon^{E}/\varepsilon^{k}_{e}$',...
    '$\varepsilon^{E}/\varepsilon^{th}_{e}$',...
    '$|v_{E \times B}/u_{e}|$',...
    '$|v_{E \times B}/v_{th,e}|$',...
    '$|u_{e}/v_{th,e}|$',...
    'Interpreter','latex','FontSize',fs)
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
%ylabel('$\frac{\langle \varepsilon \rangle}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs)
xlim([18,456])
%ylim([-1.9, 1.9])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off
%--------------------------------------------------------------------------

%ratios only ions
%--------------------------------------------------------------------------
f213212 = figure(213212);
semilogy(time(1:end-1),(E_2_2_nimivi_2_sub(1:end-1))/sub_box,'--','Color',colorblind(6,:), 'LineWidth', lw)
hold on
semilogy(time(1:end-1),(ene_E_sub(1:end-1)./ene_the_i_sub(1:end-1))/sub_box,'--','Color',colorblind(1,:), 'LineWidth', lw)
semilogy(time(1:end-1),sqrt(V_exb_2_2_vi_2_sub(1:end-1))/sub_box,'--','Color',colorblind(7,:), 'LineWidth', lw)
semilogy(time(1:end-1),sqrt(V_exb_2_2_vth_i_2_sub(1:end-1))/sub_box,'--','Color',colorblind(9,:), 'LineWidth', lw)
semilogy(time(1:end-1),sqrt(1./vth_i_2_2_vi_2_sub(1:end-1))/sub_box,'--','Color',colorblind(10,:), 'LineWidth', lw)
legend('$\varepsilon^{E}/\varepsilon^{k}_{i}$',...
    '$\varepsilon^{E}/\varepsilon^{th}_{i}$',...
    '$|v_{E \times B}/u_{i}|$',...
    '$|v_{E \times B}/v_{th,i}|$',...
    '$|u_{i}/v_{th,i}|$',...
    'Interpreter','latex','FontSize',fs)
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
%ylabel('$\frac{\langle \varepsilon \rangle}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs)
xlim([18,456])
%ylim([-1.9, 1.9])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off
%--------------------------------------------------------------------------



%velocities
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
f21323 = figure(21323);
semilogy(time(1:end-1),E_2_sub(1:end-1)/sub_box,'--','Color',colorblind(1,:), 'LineWidth', lw)
hold on
semilogy(time(1:end-1),V_exb_2_sub(1:end-1)/sub_box,'--','Color',colorblind(2,:), 'LineWidth', lw)
semilogy(time(1:end-1),vi_2_sub(1:end-1)/sub_box,'--','Color',colorblind(6,:), 'LineWidth', lw)
semilogy(time(1:end-1),ve_2_sub(1:end-1)/sub_box,'--','Color',colorblind(7,:), 'LineWidth', lw)
semilogy(time(1:end-1),vth_i_2_sub(1:end-1)/sub_box,'--','Color',colorblind(5,:), 'LineWidth', lw)
semilogy(time(1:end-1),vth_e_2_sub(1:end-1)/sub_box,'--','Color',colorblind(8,:), 'LineWidth', lw)
legend('$E^{2}$',...
    '$v^{2}_{E \times B}$',...
    '$u^{2}_{i}$',...
    '$u^{2}_{e}$',...
    '$v^{2}_{th,i}$',...
    '$v^{2}_{th,e}$',...
    'Interpreter','latex','FontSize',fs)
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('$\frac{\langle v^{2} \rangle}{v_{0}}$','Interpreter','latex','FontSize',fs)
xlim([18,456])
%ylim([-1.9, 1.9])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off
%--------------------------------------------------------------------------


%energy exb and kinetic e and thermal e 
%--------------------------------------------------------------------------
f21411 = figure(21411);
semilogy(time(1:end-1),ene_kin_e_sub(1:end-1)/sub_box,'--','Color',colorblind(1,:), 'LineWidth', lw)
hold on
semilogy(time(1:end-1),ene_the_e_sub(1:end-1)/sub_box,'--','Color',colorblind(6,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_Vexb_e_sub(1:end-1)/sub_box,'--','Color',colorblind(5,:), 'LineWidth', lw)
legend('$\varepsilon^{k}_{e}$',...
    '$\varepsilon^{th}_{e}$',...
    '$\varepsilon^{E\times B}_{e}$',...
    'Interpreter','latex','FontSize',fs)
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('$\frac{\langle \varepsilon \rangle}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs)
xlim([18,456])
%ylim([-1.9, 1.9])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off
%--------------------------------------------------------------------------


% It is important to run this part in order to get the time plots for xi
% this is to compare with the other things
%--------------------------------------------------------------------------
cd '/Volumes/PSC_DiRAC_DATA/Energy_Budget_things'
load('variabletimefile_WithRF_2022_time.mat')

Xi_k_i_in=zeros(1,N-1);
Xi_k_e_in=zeros(1,N-1);
Xi_th_i_in=zeros(1,N-1);
Xi_th_e_in=zeros(1,N-1);


%in=2
% This computes the energy averages in the sub plane only
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
for in=2:N-1
%Kinetic Energy temrs ions    
%--------------------------------------------------------------------------
vi_grad_Ki_Gp = kin_energy_terms_ic{1,in} ;
% To get the size of the domain
ss1=size(vi_grad_Ki_Gp);
ss2=ss1(1)*ss1(2);
%ss2=ss1(1)*ss1(2)*ss1(3); in the case of three dimensions
vi_grad_Ki_in_a = sum(vi_grad_Ki_Gp{1,1},'all')./ss2;

vi_Div_Pit_Gp = kin_energy_terms_ic{2,in} ;
vi_Div_Pit_in_a = sum(vi_Div_Pit_Gp{1,1},'all')./ss2;

Ki_Div_vi_Gp = kin_energy_terms_ic{3,in} ;
Ki_Div_vi_in_a = sum(Ki_Div_vi_Gp{1,1},'all')./ss2;

qi_ni_vi_E_Gp = kin_energy_terms_ic{4,in} ;
qi_ni_vi_E_in_a = sum(qi_ni_vi_E_Gp{1,1},'all')./ss2;

dtKi_in_Gp_2 = dt_energydensities_ic{1,in} ;
dtKi_in_Gp_2_in_a = sum(dtKi_in_Gp_2,'all')./ss2;

Xi_k_i_in(1,in)=dtKi_in_Gp_2_in_a + vi_grad_Ki_in_a + vi_Div_Pit_in_a +...
            Ki_Div_vi_in_a - qi_ni_vi_E_in_a;
        
        
%--------------------------------------------------------------------------

%Kinetic Energy temrs ions
%--------------------------------------------------------------------------
ve_grad_Ke_Gp = kin_energy_terms_ec{1,in} ;
ve_grad_Ke_in_a = sum(ve_grad_Ke_Gp{1,1},'all')./ss2;

ve_Div_Pet_Gp = kin_energy_terms_ec{2,in} ;
ve_Div_Pet_in_a = sum(ve_Div_Pet_Gp{1,1},'all')./ss2;

Ke_Div_ve_Gp = kin_energy_terms_ec{3,in} ;
Ke_Div_ve_in_a = sum(Ke_Div_ve_Gp{1,1},'all')./ss2;

qe_ne_ve_E_Gp = kin_energy_terms_ec{4,in} ;
qe_ne_ve_E_in_a = sum(qe_ne_ve_E_Gp{1,1},'all')./ss2;

dtKe_in_Gp_2 = dt_energydensities_ic{2,in} ;
dtKe_in_Gp_2_in_a = sum(dtKe_in_Gp_2,'all')./ss2;

Xi_k_e_in(1,in)=dtKe_in_Gp_2_in_a + ve_grad_Ke_in_a + ve_Div_Pet_in_a +...
            Ke_Div_ve_in_a - qe_ne_ve_E_in_a;
%--------------------------------------------------------------------------


% Internal energy terms ions
%--------------------------------------------------------------------------
vi_grad_Ui_Gp = Int_energy_terms_ic{1,in} ;
vi_grad_Ui_in_a = sum(vi_grad_Ui_Gp{1,1},'all')./ss2;

dk_Qijk_i_Gp = Int_energy_terms_ic{2,in} ;
dk_Qijk_i_in_a = sum(dk_Qijk_i_Gp{1,1},'all')./ss2;

dkQiik_05_i_Gp = Int_energy_terms_ic{3,in} ;
dkQiik_05_i_in_a = sum(dkQiik_05_i_Gp{1,1},'all')./ss2;

Pit_grad_vi_Gp = Int_energy_terms_ic{4,in} ;
Pit_grad_vi_in_a = sum(Pit_grad_vi_Gp{1,1},'all')./ss2;

Pit_grad_vi_ii_Gp = Int_energy_terms_ic{5,in} ;
Pit_grad_vi_ii_in_a = sum(Pit_grad_vi_ii_Gp{1,1},'all')./ss2;

Pit_grad_vi_ij_Gp = Int_energy_terms_ic{6,in} ;
Pit_grad_vi_ij_in_a = sum(Pit_grad_vi_ij_Gp{1,1},'all')./ss2;

Ui_Div_vi_Gp = Int_energy_terms_ic{7,in} ; 
Ui_Div_vi_in_a = sum(Ui_Div_vi_Gp{1,1},'all')./ss2;

dtUi_in_Gp_2 = dt_energydensities_ic{3,in} ;
dtUi_in_Gp_2_in_a = sum(dtUi_in_Gp_2,'all')./ss2;

Xi_th_i_in(1,in) = dtUi_in_Gp_2_in_a + vi_grad_Ui_in_a + dkQiik_05_i_in_a +...
            Pit_grad_vi_in_a + Ui_Div_vi_in_a;
%--------------------------------------------------------------------------

% Internal energy terms electrons
%--------------------------------------------------------------------------
ve_grad_Ue_Gp = Int_energy_terms_ec{1,in} ;
ve_grad_Ue_in_a = sum(ve_grad_Ue_Gp{1,1},'all')./ss2;

dk_Qijk_e_Gp = Int_energy_terms_ec{2,in} ;
dk_Qijk_e_in_a = sum(dk_Qijk_e_Gp{1,1},'all')./ss2;

dkQiik_05_e_Gp = Int_energy_terms_ec{3,in} ;
dkQiik_05_e_in_a = sum(dkQiik_05_e_Gp{1,1},'all')./ss2;

Pet_grad_ve_Gp =Int_energy_terms_ec{4,in} ;
Pet_grad_ve_in_a = sum(Pet_grad_ve_Gp{1,1},'all')./ss2;

Pet_grad_ve_ii_Gp = Int_energy_terms_ec{5,in} ;
Pet_grad_ve_ii_in_a = sum(Pet_grad_ve_ii_Gp{1,1},'all')./ss2;

Pet_grad_ve_ij_Gp = Int_energy_terms_ec{6,in} ;
Pet_grad_ve_ij_in_a = sum(Pet_grad_ve_ij_Gp{1,1},'all')./ss2;

Ue_Div_ve_Gp = Int_energy_terms_ec{7,in} ; 
Ue_Div_ve_in_a = sum(Ue_Div_ve_Gp{1,1},'all')./ss2;

dtUe_in_Gp_2 = dt_energydensities_ic{4,in} ;
dtUe_in_Gp_2_in_a = sum(dtUe_in_Gp_2,'all')./ss2;

Xi_th_e_in(1,in) = dtUe_in_Gp_2_in_a + ve_grad_Ue_in_a + dkQiik_05_e_in_a +...
    Pet_grad_ve_in_a + Ue_Div_ve_in_a;
%--------------------------------------------------------------------------
% other things as the dissipation proxies and the time derivative of the
% electromagnetic energy
%--------------------------------------------------------------------------
%{ 
%--------------------------------------------------------------------------
% time derivative for the poynting theorem
%--------------------------------------------------------------------------
dtE_em_in_Gp_2 = dt_energydensities_ic{5,in} ;
dtE_em_in_Gp_2_in_a = sum(dtE_em_in_Gp_2,'all')./ss2;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Div_Pi_dot_vi
Div_Pis_dot_vi_Gp{1,1} = Pit_grad_vi_Gp{1,1} + vi_Div_Pit_Gp{1,1};
Div_Pis_dot_vi_in_a = sum(Div_Pis_dot_vi_Gp{1,1},'all')./ss2;

% Div_Pe_dot_e
Div_Pes_dot_ve_Gp{1,1} = Pet_grad_ve_Gp{1,1} + ve_Div_Pet_Gp{1,1};
Div_Pes_dot_ve_in_a = sum(Div_Pes_dot_ve_Gp{1,1},'all')./ss2;
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Parameter proxies 
Zernitani_i_Gp = Param_proxiesc{1,in} ;
Zernitani_i_in_a = sum(Zernitani_i_Gp{1,1},'all')./ss2;

Zernitani_e_Gp = Param_proxiesc{2,in} ;
Zernitani_e_in_a = sum(Zernitani_e_Gp{1,1},'all')./ss2;

p_theta_i_Gp = Param_proxiesc{3,in} ;
p_theta_i_in_a = sum(p_theta_i_Gp{1,1},'all')./ss2;

p_theta_e_Gp = Param_proxiesc{4,in} ;
p_theta_e_in_a = sum(p_theta_e_Gp{1,1},'all')./ss2;

PiD_i_Gp = Param_proxiesc{5,in} ;
PiD_i_in_a = sum(PiD_i_Gp{1,1},'all')./ss2;

PiD_e_Gp = Param_proxiesc{6,in} ;
PiD_e_in_a = sum(PiD_e_Gp{1,1},'all')./ss2;
%}
%--------------------------------------------------------------------------
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


% plot of the power densities averaged over the plane 
cd '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here'
load('colorblind_colormap.mat');
%--------------------------------------------------------------------------

%Create the time array
time_line=zeros(1,N);
dt = 0.06;
for in=2:N-1
str = string(S(in).name);
newStr = extractBetween(str,"pfd.","_p000000.h5");
N_steps = str2double(newStr); time_t = dt*N_steps;
time_line(1,in) = time_t; 
end

time = time_line';

c=1;
VA2c = 0.1;
B0 = VA2c;
E0 = B0*VA2c;
Pi0 = mi*VA2c*VA2c;
Pe0 = me*VA2c*VA2c;
% energies
VA2c1=400*400*2016*Pi0;
VA2c2=168*168*168*Pi0;   
sub_box=168*168*168;
%--------------------------------------------------------------------------
lw = 3;
fs=25;
%--------------------------------------------------------------------------
Xi_k_i_in_3dbox=Xi_k_i_in;
Xi_k_e_in_3dbox=Xi_k_e_in;
Xi_th_i_in_3dbox=Xi_th_i_in;
Xi_th_e_in_3dbox=Xi_th_e_in;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
f5556 = figure(556);
plot(time(1:end-1),real(Xi_k_e_in_3dbox(1:end-1))/Pi0,'Color',colorblind(1,:), 'LineWidth', lw)
hold on
plot(time(1:end-1),real(Xi_k_i_in_3dbox(1:end-1))/Pi0,'Color',colorblind(2,:), 'LineWidth', lw)
plot(time(1:end-1),real(Xi_th_e_in_3dbox(1:end-1))/Pi0,'Color',colorblind(6,:), 'LineWidth', lw)
plot(time(1:end-1),real(Xi_th_i_in_3dbox(1:end-1))/Pi0,'Color',colorblind(7,:), 'LineWidth', lw)
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

%--------------------------------------------------------------------------
f555 = figure(555);
plot(time(2:end-1),Xi_k_e_in(2:end),'Color',colorblind(1,:), 'LineWidth', lw)
hold on
plot(time(2:end-1),Xi_k_i_in(2:end),'Color',colorblind(2,:), 'LineWidth', lw)
plot(time(2:end-1),Xi_th_e_in(2:end),'Color',colorblind(6,:), 'LineWidth', lw)
plot(time(2:end-1),Xi_th_i_in(2:end),'Color',colorblind(7,:), 'LineWidth', lw)
legend('$Xi^{k}_{e}$','$Xi^{k}_{i}$','$Xi^{th}_{e}$',...
    '$Xi^{th}_{i}$','Interpreter','latex','FontSize',fs)
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('$\frac{\langle \varepsilon \rangle}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs)
xlim([0,456])
%ylim([-1.9, 1.9])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
f215 = figure(215);
semilogy(time(1:end-1),ene_BE(1:end-1)./VA2c1,'Color',colorblind(1,:), 'LineWidth', lw)
hold on
semilogy(time(1:end-1),ene_kin_i(1:end-1)/VA2c1,'Color',colorblind(2,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_kin_e(1:end-1)/VA2c1,'Color',colorblind(6,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_the_i(1:end-1)/VA2c1,'Color',colorblind(7,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_the_e(1:end-1)/VA2c1,'Color',colorblind(5,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_total(1:end-1)/VA2c1,'Color',colorblind(8,:), 'LineWidth', lw)
legend('$\varepsilon^{em}$','$\varepsilon^{k}_{i}$','$\varepsilon^{k}_{e}$',...
    '$\varepsilon^{th}_{i}$','$\varepsilon^{th}_{e}$','$\varepsilon^{T}$','Interpreter','latex','FontSize',fs)
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('$\frac{\langle \varepsilon \rangle}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs)
xlim([18,456])
%ylim([-1.9, 1.9])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off
%--------------------------------------------------------------------------




%--------------------------------------------------------------------------
% This includes both, total and sub-domain integrated
%--------------------------------------------------------------------------
load('/Volumes/PSC_DiRAC_DATA/Energy_Budget_things/Energy_table_sub_Energy_full.mat')
%T_energy_terms_table, T_energy_terms_table_sub


cd '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here'
load('colorblind_colormap.mat');

c=1;
VA2c = 0.1; B0 = VA2c; E0 = B0*VA2c;
Pi0 = mi*VA2c*VA2c; Pe0 = me*VA2c*VA2c;
% energies
VA2c1=400*400*2016*Pi0;
VA2c2=168*168*168*Pi0;
sub_box=168*168*168;
% This is to check that both (sub and full) are in the correct names
%--------------------------------------------------------------------------
f666=figure(666)
semilogy(T_energy_terms_table_sub(:,1)/VA2c2,'r') % this is the sub_box
hold on
semilogy(T_energy_terms_table(:,1)/VA2c1,'b')
hold off
%--------------------------------------------------------------------------

% This uses a different calculations
%--------------------------------------------------------------------------
% get the data in a array to use that syntaxis 
ene_BE = T_energy_terms_table(:,1) + T_energy_terms_table(:,2); %electromagnetic energy
ene_kin_i =T_energy_terms_table(:,3);
ene_kin_e =T_energy_terms_table(:,4);
ene_the_i =T_energy_terms_table(:,5)-ene_kin_i;
ene_the_e =T_energy_terms_table(:,6)-ene_kin_e;
ene_total = ene_BE + ene_kin_i + ene_kin_e + ene_the_i + ene_the_e;

ene_BE_sub = T_energy_terms_table_sub(:,1) + T_energy_terms_table_sub(:,2); %electromagnetic energy
ene_kin_i_sub =T_energy_terms_table_sub(:,3);
ene_kin_e_sub =T_energy_terms_table_sub(:,4);
ene_the_i_sub =T_energy_terms_table_sub(:,5)-ene_kin_i_sub;
ene_the_e_sub =T_energy_terms_table_sub(:,6)-ene_kin_e_sub;
ene_total_sub = ene_BE_sub + ene_kin_i_sub + ene_kin_e_sub + ene_the_i_sub + ene_the_e_sub;
%--------------------------------------------------------------------------

% Get the plot of the energies in the full box and the sub box
%--------------------------------------------------------------------------
f21581 = figure(21581);
semilogy(time(2:end-1),ene_kin_e(1:end-2)/VA2c1,'Color',colorblind(2,:), 'LineWidth', lw)
hold on
semilogy(time(2:end-1),ene_kin_i(1:end-2)/VA2c1,'Color',colorblind(6,:), 'LineWidth', lw)
semilogy(time(2:end-1),ene_the_e(1:end-2)/VA2c1,'Color',colorblind(7,:), 'LineWidth', lw)
semilogy(time(2:end-1),ene_the_i(1:end-2)/VA2c1,'Color',colorblind(5,:), 'LineWidth', lw)
semilogy(time(2:end-1),ene_BE(1:end-2)/VA2c1,'Color',colorblind(1,:), 'LineWidth', lw)
semilogy(time(2:end-1),ene_total(1:end-2)/VA2c1,'Color',colorblind(8,:), 'LineWidth', lw)

semilogy(time(2:end-1),ene_kin_e_sub(1:end-2)/VA2c2,'--','Color',colorblind(2,:), 'LineWidth', lw)
semilogy(time(2:end-1),ene_kin_i_sub(1:end-2)/VA2c2,'--','Color',colorblind(6,:), 'LineWidth', lw)
semilogy(time(2:end-1),ene_the_e_sub(1:end-2)/VA2c2,'--','Color',colorblind(7,:), 'LineWidth', lw)
semilogy(time(2:end-1),ene_the_i_sub(1:end-2)/VA2c2,'--','Color',colorblind(5,:), 'LineWidth', lw)
semilogy(time(2:end-1),ene_BE_sub(1:end-2)/VA2c2,'--','Color',colorblind(1,:), 'LineWidth', lw)
semilogy(time(2:end-1),ene_total_sub(1:end-2)/VA2c2,'--','Color',colorblind(8,:), 'LineWidth', lw)

legend(...
    '$\varepsilon^{k}_{e,full}$',...    
    '$\varepsilon^{k}_{i,full}$',...
    '$\varepsilon^{th}_{e,full}$',...
    '$\varepsilon^{th}_{i,full}$',...
    '$\varepsilon^{em}_{full}$',...
    '$\varepsilon^{T}_{full}$',...
    '$\varepsilon^{k}_{e,sub}$',...    
    '$\varepsilon^{k}_{i,sub}$',...
    '$\varepsilon^{th}_{e,sub}$',...
    '$\varepsilon^{th}_{i,sub}$',...
    '$\varepsilon^{em}_{sub}$',...
    '$\varepsilon^{T}_{sub}$',...
        ...
    'Interpreter','latex','FontSize',fs,'NumColumns',2)
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('${\langle \varepsilon \rangle}/{\varepsilon_{0}}$','Interpreter','latex','FontSize',fs)
xlim([18,456])
%ylim([-1.9, 1.9])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off
%--------------------------------------------------------------------------


% This part loads the plots of the deltas of the energies
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
f33 = figure(33);
delta_ene = abs(ene_total(2:end-1) - ene_total(1:end-2)./(time(2:end-1) -time(1:end-2))); 
plot(time(2:end-1),(delta_ene./(ene_total(1:end-2))),'-','Color',colorblind(2,:), 'LineWidth', lw)
hold on
%delta_ene = (1/VA2c1).*abs(ene_total(2:end-1) - ene_total(1:end-2)./(time(2:end-1) -time(1:end-2))); 
%plot(time(2:end-1),(delta_ene./(ene_total(1:end-2))),'-','Color',colorblind(2,:), 'LineWidth', lw)
delta_ene = abs(ene_total_sub(2:end-1) - ene_total_sub(1:end-2)./(time(2:end-1) -time(1:end-2))); 
plot(time(2:end-1),(delta_ene./(ene_total_sub(1:end-2))),'--','Color',colorblind(6,:), 'LineWidth', lw)
hold off

f44 = figure(44);
delta_ene = abs(ene_total(2:end-1)-ene_total(1:end-2))./VA2c1;
semilogy(time(2:end-1),delta_ene./(time(2:end-1) -time(1:end-2)),'k')
hold on
delta_ene = abs(ene_total(2:end-1)-ene_total(1:end-2))./ene_total(1:end-2);
semilogy(time(2:end-1),delta_ene,'b')
semilogy(time(2:end-1),ene_total(1:end-2)./VA2c1,'r')
delta_ene = abs(ene_total(2:end-1) - ene_total(1:end-2))./(time(2:end-1) -time(1:end-2)); 
semilogy(time(2:end-1),(delta_ene./(ene_total(1:end-2))),'-','Color',colorblind(8,:), 'LineWidth', lw)
delta_ene = abs(ene_total_sub(2:end-1) - ene_total_sub(1:end-2))./(time(2:end-1) -time(1:end-2)); 
semilogy(time(2:end-1),(delta_ene./(ene_total_sub(1:end-2))),'--','Color',colorblind(8,:), 'LineWidth', lw)
hold off

%semilogy(time(2:end-1),(delta_ene./(ene_total(1:end-2))),'-','Color',colorblind(8,:), 'LineWidth', lw)
%delta_ene = (1/1).*abs(ene_total_sub(2:end-1) - ene_total_sub(1:end-2)./(time(2:end-1) -time(1:end-2))); 
%semilogy(time(2:end-1),(delta_ene./(ene_total_sub(1:end-2))),'--','Color',colorblind(8,:), 'LineWidth', lw)


%--------------------------------------------------------------------------

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

%delta_ene = abs(ene_total(2:end-1) - ene_total(1:end-2)./(time(2:end-1) -time(1:end-2))); 
%semilogy(time(2:end-1),(delta_ene./(ene_total(1:end-2))),'-','Color',colorblind(8,:), 'LineWidth', lw)
%delta_ene = abs(ene_total_sub(2:end-1) - ene_total_sub(1:end-2)./(time(2:end-1) -time(1:end-2))); 
%semilogy(time(2:end-1),(delta_ene./(ene_total_sub(1:end-2))),'--','Color',colorblind(8,:), 'LineWidth', lw)

delta_ene = abs(ene_total(2:end-1) - ene_total(1:end-2))./(time(2:end-1) -time(1:end-2)); 
semilogy(time(2:end-1),(delta_ene./(ene_total(1:end-2))),'-','Color',colorblind(8,:), 'LineWidth', lw)
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
    '${\Delta\varepsilon^{T}_{full}}$',...
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

%--------------------------------------------------------------------------
%Power densities 3
%--------------------------------------------------------------------------
f2145523 = figure(2145523);
delta_ene = abs(ene_kin_e_sub(2:end-1) - ene_kin_e_sub(1:end-2)./(time(2:end-1) -time(1:end-2))); 
plot(time(2:end-1),(delta_ene./(ene_total_sub(1:end-2))),'-*','Color',colorblind(2,:), 'LineWidth', lw)
hold on
delta_ene = abs(ene_kin_i_sub(2:end-1) - ene_kin_i_sub(1:end-2)./(time(2:end-1) -time(1:end-2))); 
plot(time(2:end-1),(delta_ene./(ene_total_sub(1:end-2))),'-*','Color',colorblind(6,:), 'LineWidth', lw)
delta_ene = abs(ene_the_e_sub(2:end-1) - ene_the_e_sub(1:end-2)./(time(2:end-1) -time(1:end-2))); 
plot(time(2:end-1),(delta_ene./(ene_total_sub(1:end-2))),'-*','Color',colorblind(7,:), 'LineWidth', lw)
delta_ene = abs(ene_the_i_sub(2:end-1) - ene_the_i_sub(1:end-2)./(time(2:end-1) -time(1:end-2))); 
plot(time(2:end-1),(delta_ene./(ene_total_sub(1:end-2))),'-*','Color',colorblind(5,:), 'LineWidth', lw)

%semilogy(time(2:end-1),sub_box.*abs(Xi_k_e_in_3dbox(1:end-2))./(ene_total_sub(1:end-2)'),'-+','Color',colorblind(2,:), 'LineWidth', lw)
%semilogy(time(2:end-1),sub_box.*abs(Xi_k_i_in_3dbox(1:end-2))./(ene_total_sub(1:end-2)'),'-+','Color',colorblind(6,:), 'LineWidth', lw)
%semilogy(time(2:end-1),sub_box.*abs(Xi_th_e_in_3dbox(1:end-2))./(ene_total_sub(1:end-2)'),'-+','Color',colorblind(7,:), 'LineWidth', lw)
%semilogy(time(2:end-1),sub_box.*abs(Xi_th_i_in_3dbox(1:end-2))./(ene_total_sub(1:end-2)'),'-+','Color',colorblind(5,:), 'LineWidth', lw)
plot(time(2:end-1),ene_kin_e_sub(1:end-2)/VA2c2,'--','Color',colorblind(2,:), 'LineWidth', lw)
plot(time(2:end-1),ene_kin_i_sub(1:end-2)/VA2c2,'--','Color',colorblind(6,:), 'LineWidth', lw)
plot(time(2:end-1),ene_the_e_sub(1:end-2)/VA2c2,'--','Color',colorblind(7,:), 'LineWidth', lw)
plot(time(2:end-1),ene_the_i_sub(1:end-2)/VA2c2,'--','Color',colorblind(5,:), 'LineWidth', lw)

legend(...
    '${\Delta\varepsilon^{k}_{e}}$',...
    '${\Delta\varepsilon^{k}_{i}}$',...
    '${\Delta\varepsilon^{th}_{e}}$',...
    '${\Delta\varepsilon^{th}_{i}}$',...'${\varepsilon^{em}}$',...
    '$\varepsilon^{k}_{e}$',...
    '$\varepsilon^{k}_{i}$',...
    '$\varepsilon^{th}_{e}$',...
    '$\varepsilon^{th}_{i}$',...
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

%Power densities 2
%--------------------------------------------------------------------------
f21455 = figure(21455);
semilogy(time(2:end-1),(sign(ene_kin_e_sub(1:end-2)).*ene_kin_e_sub(1:end-2)./(ene_total_sub(1:end-2))),'--','Color',colorblind(2,:), 'LineWidth', lw)
hold on
semilogy(time(2:end-1),(sign(ene_kin_i_sub(1:end-2)).*ene_kin_i_sub(1:end-2)./(ene_total_sub(1:end-2))),'--','Color',colorblind(6,:), 'LineWidth', lw)
semilogy(time(2:end-1),(sign(ene_the_e_sub(1:end-2)).*ene_the_e_sub(1:end-2)./(ene_total_sub(1:end-2))),'--','Color',colorblind(7,:), 'LineWidth', lw)
semilogy(time(2:end-1),(sign(ene_the_i_sub(1:end-2)).*ene_the_i_sub(1:end-2)./(ene_total_sub(1:end-2))),'--','Color',colorblind(5,:), 'LineWidth', lw)
%semilogy(time(2:end-1),(sign(ene_BE_sub(1:end-2)).*ene_BE_sub(1:end-2)./(6*ene_total_sub(1:end-2))),'--','Color',colorblind(1,:), 'LineWidth', lw)

semilogy(time(2:end-1),sub_box.*sign(real(Xi_k_e_in_3dbox(1:end-2))).*real(Xi_k_e_in_3dbox(1:end-2))./(ene_total_sub(1:end-2)'),'-+','Color',colorblind(2,:), 'LineWidth', lw)
semilogy(time(2:end-1),sub_box.*sign(real(Xi_k_i_in_3dbox(1:end-2))).*real(Xi_k_i_in_3dbox(1:end-2))./(ene_total_sub(1:end-2)'),'-+','Color',colorblind(6,:), 'LineWidth', lw)
semilogy(time(2:end-1),sub_box.*sign(real(Xi_th_e_in_3dbox(1:end-2))).*real(Xi_th_e_in_3dbox(1:end-2))./(ene_total_sub(1:end-2)'),'-+','Color',colorblind(7,:), 'LineWidth', lw)
semilogy(time(2:end-1),sub_box.*sign(real(Xi_th_i_in_3dbox(1:end-2))).*real(Xi_th_i_in_3dbox(1:end-2))./(ene_total_sub(1:end-2)'),'-+','Color',colorblind(5,:), 'LineWidth', lw)
%plot(time(2:end-1),(ene_total_sub(1:end-2)./6)/sub_box,'--','Color',colorblind(8,:), 'LineWidth', lw)
%semilogy(time(2:end-1),(ene_Vexb_i_sub(2:end-1)./(time(2:end-1)-time(1:end-2)))/sub_box,'Color',colorblind(9,:), 'LineWidth', lw)
%semilogy(time(2:end-1),(ene_Vexb_e_sub(2:end-1)./(time(2:end-1)-time(1:end-2)))/sub_box,'Color',colorblind(10,:), 'LineWidth', lw)
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
    %'${\varepsilon^{T}}$','Interpreter','latex','FontSize',fs)%...
    %'$\varepsilon^{E\times B}_{i}$','$\varepsilon^{E\times B}_{e}$'
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('$\frac{\langle \varepsilon \rangle}{\Delta t \langle \varepsilon^{T} \rangle},\frac{\langle \Xi \rangle}{\langle \varepsilon^{T} \rangle}$','Interpreter','latex','FontSize',fs)
xlim([18,456])
%ylim([-0.5, 1.1])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off
%--------------------------------------------------------------------------

%}
%--------------------------------------------------------------------------
cd '/Volumes/PSC_DiRAC_DATA/Energy_Budget_things'
saveas(f21581,strcat('energy_full_sub_'+ string(N_steps) +'.png'));
saveas(f214552,strcat('energy_sub_3d_xi_sub_3d__4'+ string(N_steps) +'.png'));

f4=figure(4)
saveas(f4,strcat('velocity_ratios'+ string(N_steps) +'.png'));

cd '/Volumes/PSC_DiRAC_DATA/Energy_Budget_things'
saveas(f21455,strcat('energy_sub_3d_xi_sub_3d_'+ string(N_steps) +'.png'));
saveas(f214,strcat('all_energies_time'+ string(N_steps) +'.png'));
saveas(f215,strcat('energy_time_semilogy'+ string(N_steps) +'.png'));
saveas(f2141,strcat('energy_time_full_sub_2_'+ string(N_steps) +'.png'));
saveas(f2151,strcat('energy_time_full_sub_semilogy_2_'+ string(N_steps) +'.png'));
cd '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here'