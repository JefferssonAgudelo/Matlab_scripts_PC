clear all
close all

%This is the file that computes the vector potential
% Computing reconnection rates.

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/harris_base_4nd';
%path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/harris_yz_lange_wavelength_all_4nd';

%---------------------------------------------------------------------------------------
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/Harris_yz_base'; %omega=2.5 mime1
%<---- There is an issue with these ones as there are some stripes in the y direction when reconstructing the magnetic field.
%---------------------------------------------------------------------------------------
%path =%'/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/harris_yz_lange_all_working'; %omega=2.5 mime1
%---------------------------------------------------------------------------------------

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/psc_harris_yz_base_ppc_ome2/psc_harris_yz_base_ppc_ome2';

%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/psc_harris_yz_base_ppc_ome2_mime100/psc_harris_yz_base_ppc_ome2_mime100';
%<---- This is one of the best simulations!!! but is has a lot of
%fluctuations. But it's wrong. There are many fluctuations. mime=80,
%omega_2, ppc30
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%path = %'/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_1/psc_harris_yz_base_ppc1000_ome2_mime100/psc_harris_yz_base_ppc1000_ome2_mime100';%<----


%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/psc_harris_yz_base_ppc1000_ome2_mime1/psc_harris_yz_base_ppc1000_ome2_mime1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/psc_harris_yz_lange_all_ppc1000_ome2_mime1/psc_harris_yz_lange_all_ppc1000_ome2_mime1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/psc_harris_yz_lange_all_par_ppc1000_ome2_mime1/psc_harris_yz_lange_all_par_ppc1000_ome2_mime1';


%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/psc_harris_yz_base_ppc1000_ome2_mime1';%<---
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/psc_harris_yz_lange_1_ppc1000_ome2_mime1_L05';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/psc_harris_yz_lange_all_par_ppc1000_ome2_mime1_L05';

%path='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/psc_harris_yz_base_ppc1000_ome2_mime1';
%path='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/psc_harris_yz_lange_1_ppc1000_ome2_mime1_L05';

%path='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/psc_harris_yz_lange_all_par_ppc1000_ome2_mime1_L05';
%%<<-this is a short one
%path='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/psc_harris_yz_lange_all_pert_par_ppc1000_ome2_mime1_L05';
%%%% <---
%


%path='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/psc_harris_yz_base_ppc600_ome2_mime1_3D';
%path='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/psc_harris_yz_lange_all_ppc600_ome2_mime1_3D';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB01_kxky';

%path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB002';% <---
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB005';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB01';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB02';% <---

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB01_kxky_L1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB002_kxky'; % With the out of plane component the vector potential is not longer well define.
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB005_kxky'; % one of the magnetic field components is not recoverd
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB01_kxky';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_all_pert_par_ppc1000_ome5_mime1'; %<---

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_ppc1000_ome5_mime1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_all_par_ppc1000_ome5_mime1';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_lange_1_ppc1000_ome5_mime1_dB002';


%path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_alone';
%path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_alone_2';

% This one is based on the old configuration.


%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/psc_harris_yz_base_ppc1000_ome2_mime1';

%To substract the harris natural fluctuations withput any initial
%perturbation.

%Amp_ky_T_alone=Amp_ky_T_i;
%Amp_kz_T_alone=Amp_kz_T_i;

%path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB002';% <---
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB005';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB01';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB02';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB04';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_1/psc_harris_yz_base_ppc1000_ome2_mime1/psc_harris_yz_base_ppc1000_ome2_mime1';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_ppc1000_ome5_mime1_L1';
%path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB002_L1';% <---
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB005_L1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB01_L1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB02_L1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB05_L1';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB05_L1';

%path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_1/psc_harris_yz_base_ppc1000_ome2_mime1/psc_harris_yz_base_ppc1000_ome2_mime1';
%this has dB=05

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_2_ppc1000_ome5_mime1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_3_ppc1000_ome5_mime1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_4_ppc1000_ome5_mime1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_all_ppc1000_ome5_mime1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_all_par_ppc1000_ome5_mime1';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB01_omega_01';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB01_omega_05';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB01_omega_15';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB01_Bg01';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB01_Bg05';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB01_Bg1';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_3';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large';

%With the guide field and 4di thickness
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_Ax_large';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_alone_large';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_alone_large_2';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_8';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini_L8di_8_dum';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini_L8di_8_du02';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_ome01_cp';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_dummy_2';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_Omc1';

path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/checking_in_laptop_anomalous/psc_harris_yz_Ax_L5di_lange_local_E';

%run the L1 alone without any perturbation to see if it is unstable.

% What about removing the fluctuations from the harris configuration alone.

%-------------------------------------------------------------------------------------------------------------------
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_lange_1_ppc1000_ome5_mime1_dB002';
%<---- There is an issue with these ones as there are some stripes in the y direction when reconstructing the magnetic field.
%-------------------------------------------------------------------------------------------------------------------

% For the scripts
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';

% To save the plots
path_rec_r = strcat(path,'/spectra/rec_r');
path_rec_line = strcat(path,'/spectra/rec_line');

if not(isfolder(path_rec_r))
    mkdir(path_rec_r)
end
if not(isfolder(path_rec_line))
    mkdir(path_rec_line)
end

cd(path)
S = dir(fullfile(path,'pfd.*.h5'));
N=numel(S); % number of files to use
H=zeros(N);
%--------------------------------------------------------------------------
S2 = dir(fullfile(path,'pfd_moments.*.h5'));
N2=numel(S2); % number of files to use
H2=zeros(N2);
in=1;
%--------------------------------------------------------------------------
% Change this accordingly
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Normalization
%B are normalized to the background magnetic field
B0=0.2;
%n is normalise to the proton density n0=1
n0=1;
%Vi normalised to the proton alfven speed V_a=0.1c The alfven speed of
%electrons is Vae=10Vai
Vai=0.2;%0.2;
Vae=0.2;%0.2;
%E = vB, as B0=0.1 and v in units of c, E0= B0*Vai/c
E0=0.2;%0.2; %??
%T=(beta/2)B^2, Thus, as beta=1
T0=0.02;%0.02;
%The current density J0=1?
J0=Vae;

mime =1.; %<----
omega_pe_Omega_ce=5;

MFT0=1; % is this simply one in this normalization

nb_n0 =0.2;

Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);

%Normalising only when making plots
c=1; VA2c = 0.2;
%B0 = VA2c; E0 = B0*VA2c;
%Pi0 = mi*VA2c*VA2c; Pe0 = me*VA2c*VA2c;
%DeltaEpsilon0=VA2c*Pi0;
%DeltaEpsilon0=Pi0;
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% % Normalization
% %B are normalized to the background magnetic field
% B0=0.2;
% %n is normalise to the proton density n0=1
% n0=1;
% %Vi normalised to the proton alfven speed V_a=0.1c The alfven speed of
% %electrons is Vae=10Vai
% Vai=0.2;
% Vae=0.2;
% %E = vB, as B0=0.1 and v in units of c, E0= B0*Vai/c
% E0=0.2; %??
% %T=(beta/2)B^2, Thus, as beta=1
% T0=0.02;
% %The current density J0=1?
% J0=Vai;
%
% MFT0=1; % is this simply one in this normalization

nb_n0 =0.2;

Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);

%Normalising only when making plots
%c=1; VA2c = 0.2;
%B0 = VA2c; E0 = B0*VA2c;
%Pi0 = mi*VA2c*VA2c; Pe0 = me*VA2c*VA2c;
%DeltaEpsilon0=VA2c*Pi0;
%DeltaEpsilon0=Pi0;

%--------------------------------------------------------------------------

kb = 1.;
mu0 =1.;
c=1;
q = 1;
%mime =1.;
mi = 1.;
me = 1. / mime; eps0=1.;
omega_pi=1;
Omega_e=Vai*sqrt(mime)*omega_pi;
Omega_i=Omega_e / mime;
TOmega_e=1/Omega_e;
TOmega_i=1/Omega_i;
jn=2;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
in=1;
%----------------------------------------------------------------------
fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;
B=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
ss=size(B);
LZs=ss(3);
clearvars B

%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
N_jn=N; %This is to store some but not all the time steps

%N=61;N_jn=61; <------------------------------- this is for the 3000

Ex_rec_avg=zeros(1,N_jn);
time_t_2=zeros(1,N_jn);
inte_Ax_i=zeros(LZs,N_jn); %the 304 has to be replaced and defined in a better way
By_y0_i = zeros(LZs,N_jn);

Ax_maxmin_avg=zeros(1,N_jn);
Ax_max_a=zeros(1,jn);
Ax_min_a=zeros(1,jn);
Ax_maxmin=zeros(1,jn);
Ex_maxmin=zeros(1,jn);

%To get the k of the dominant modes
kz_0_i=zeros(N_jn,4);
ky_0_i=zeros(N_jn,4);

Amp_ky_0_i=zeros(N_jn,4);
Amp_kz_0_i=zeros(N_jn,4);

Amp_ky_T_i=zeros(N_jn,4);
Amp_kz_T_i=zeros(N_jn,4);


J_mag_max=zeros(1,N_jn);
jn=61;
%--------------------------------------------------------------------------

for jn=1:N
    %in=2 + floor(N*(jn-1)/10);
    in=jn;
    %----------------------------------------------------------------------
    disp(strcat('Computing step ...',S(in).name))
    fileID =  S(in).name; %change the 1 per i
    %h5disp(fileID);
    info = h5info(fileID);
    EHJ_1st = info.Groups(16).Name;

    %--------------------------------------------------------------------------
    grid_dt = info.Groups(20).Attributes;
    dt=double(grid_dt(15).Value);

    grid_ng = info.Groups(19).Attributes;
    dx=grid_ng(10).Value(1);
    dy=grid_ng(10).Value(2);
    dz=grid_ng(10).Value(3);

    grid_length = info.Groups(17).Attributes;
    Lx=grid_length(4).Value(1);% - grid_length(3).Value(1);
    Ly=grid_length(4).Value(2);% - grid_length(3).Value(2);
    Lz=grid_length(4).Value(3);% - grid_length(3).Value(3);

    resx=double(Lx)/double(dx);
    resy=double(Ly)/double(dy);
    resz=double(Lz)/double(dz); res=resy;

    threshold=pi/resy;
    %--------------------------------------------------------------------------

    %----------------------------------------------------------------------
    %     %disp(strcat('Computing step ...',S2(in).name))
    %     fileID2 =  S2(in).name; %change the 1 per i
    %     %h5disp(fileID2);
    %     info2 = h5info(fileID2);
    %     moments_1st = info2.Groups(1).Name;
    %     %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    % 'rho_e_UP' 'jx_e_UP' 'jy_e_UP' 'jz_e_UP' 'px_e_UP' 'py_e_UP'
    % 'pz_e_UP' 'txx_e_UP' 'tyy_e_UP' 'tzz_e_UP' 'txy_e_UP' 'tyz_e_UP'
    % 'tzx_e_UP' 'rho_i_UP' 'jx_i_UP' 'jy_i_UP' 'jz_i_UP' 'px_i_UP'
    % 'py_i_UP' 'pz_i_UP' 'txx_i_UP' 'tyy_i_UP' 'tzz_i_UP' 'txy_i_UP'
    % 'tyz_i_UP' 'tzx_i_UP'
    %----------------------------------------------------------------------

    B{1,1}=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    B{1,2}=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
    B{1,3}=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));

    E{1,1}=h5read(fileID,strcat(EHJ_1st,'/ex_ec/p0/3d'));
    E{1,2}=h5read(fileID,strcat(EHJ_1st,'/ey_ec/p0/3d'));
    E{1,3}=h5read(fileID,strcat(EHJ_1st,'/ez_ec/p0/3d'));

    J{1,1}=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'));
    J{1,2}=h5read(fileID,strcat(EHJ_1st,'/jy_ec/p0/3d'));
    J{1,3}=h5read(fileID,strcat(EHJ_1st,'/jz_ec/p0/3d'));

    %From 3D to 2D (x,y,z) to (y,z)
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------

    % computing magnetic flux velocity
    %----------------------------------------------------------------------
    Bp=sqrt(B{1,2}.^2 + B{1,3}.^2);

    by=B{1,2}./Bp;
    bz=B{1,3}./Bp;

    % Is this still well defined like this in the 3D case?
    MFT_y = - (c.*E{1,1}./Bp).*bz ;
    MFT_z =  (E{1,1}./Bp).*by ;
    MFTm=sqrt(MFT_z.^2 + MFT_y.^2);


    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    % slice in x
    ssz=size(Bp);
    sli_x = 1;
    sli_y = floor(4+ssz(2)/2);%380;
    sli_z = floor(2+ssz(3)/2);%700;
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    MFT_y=squeeze(MFT_y(sli_x,:,:));
    MFT_z=squeeze(MFT_z(sli_x,:,:));

    Bp=squeeze(Bp(sli_x,:,:));

    % Computing the divergence
    %----------------------------------------------------------------------
    %     [MFT_y_y, MFT_y_z] = gradient(MFT_y);
    %     [MFT_z_y, MFT_z_z] = gradient(MFT_z);
    %     Div_MFT = MFT_y_y/resy + MFT_z_z/resz;
    %
    %     MFTm_1d_ay=squeeze(Div_MFT(:,sli_z));
    %     MFTm_1d_az=squeeze(Div_MFT(sli_y,:))';
    %
    %     Div_MFT_1d_ay=squeeze(Div_MFT(:,sli_z));
    %     Div_MFT_1d_az=squeeze(Div_MFT(sli_y,:))';
    %----------------------------------------------------------------------


    % computing the electric field terms
    %----------------------------------------------------------------------
    Ex = E{1,1}; Ex = squeeze(Ex(sli_x,:,:));
    Ey = E{1,2}; Ey = squeeze(Ey(sli_x,:,:));
    Ez = E{1,3}; Ez = squeeze(Ez(sli_x,:,:));

    Bx = B{1,1}; Bx = squeeze(Bx(sli_x,:,:));
    By = B{1,2}; By = squeeze(By(sli_x,:,:));
    Bz = B{1,3}; Bz = squeeze(Bz(sli_x,:,:));

    Jx = J{1,1}; Jx = squeeze(Jx(sli_x,:,:));
    Jy = J{1,2}; Jy = squeeze(Jy(sli_x,:,:));
    Jz = J{1,3}; Jz = squeeze(Jz(sli_x,:,:));
    %----------------------------------------------------------------------


    % Defining the function to compute the reconnection rate
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %    %---------------------------------------------------------------------
    %     %example to prove tjhat it works and it does.
    %     By_ej=cos(1*ZLL.*2*pi/Lz); Atest=sin(1*ZLL.*2*pi/Lz);
    %
    %     %Computing Ax integrating;
    %    %---------------------------------------------------------------------
    %     dx = resy; dy = resz;
    %     Iapprox = zeros(size(By));
    %     Iapprox_i=0;
    %     for i=1:ny-1
    %         for j=1:nz-1
    %             Iapprox_i = Iapprox_i + dx*dy*By_ej(i,j);
    %             Iapprox(i,j)=Iapprox_i;
    %         end
    %     end
    %
    %     f55=figure(55);
    %     subplot(1,2,1)
    %     hc=pcolor(Atest);
    %     set(hc,'edgecolor','none')
    %     colorbar
    %     subplot(1,2,2)
    %     hc=pcolor(Iapprox);
    %     set(hc,'edgecolor','none')
    %     colorbar
    %     %----------------------------------------------------------------------

    %--------------------------------------------------------------------------
    sss=size(Bx);
    size_X=sss;
    zll=linspace(-Lz,Lz,size_X(2)); %Jeff flag it works with (1,size_x(2))
    yll=linspace(-Ly,Ly,size_X(1));
    [ZLL, YLL] = meshgrid(zll,yll);


    %----------------------------------------------------------------------
    ny=sss(2);
    nz=sss(1);
    dz = resz; dy = resy;
    %----------------------------------------------------------------------

    %Computing Ax integrating; %This is the one that works better so far
    %----------------------------------------------------------------------
    Iapprox_j = zeros(size(By(1,:)));
    Iapprox_j(1,1)=dy*By(1,1); %<----- there is a problem here its a single and not double value

    for j=2:ny
        Iapprox_j(1,j) = Iapprox_j(1,j-1) + dy*By(1,j);
    end
    Iapprox_i = zeros(size(By));
    Iapprox_i(1,:)=Iapprox_j;
    for i=2:nz
        Iapprox_i(i,:) = Iapprox_i(i-1,:) - dz*Bz(i,:);
    end

    Ax=-Iapprox_i; %
    %     %----------------------------------------------------------------------
    %     f3=figure(3)
    %     plot(yll./0.5,-Ax(:,1),'k')
    %     hold on
    %     plot(yll./0.5,-Ax(:,75),'b')
    %     plot(yll./0.5,-Ax(:,150),'r')
    %     hold off
    %
    %     %----------------------------------------------------------------------
    %     %----------------------------------------------------------------------
    %     cd(path_s2)
    %     f55=figure(55);
    %     h1=subplot(1,1,1);
    %     hc=pcolor(Ax);
    %     set(hc,'edgecolor','none')
    %     colorbar; colormap(h1,jet)
    %     %caxis([-1,1]);
    %     title('Ax');
    %
    %     %Check the derivatives to see how beutifully it works
    %     %----------------------------------------------------------------------
    %     A2=zeros(size(Ax));
    %     A1=zeros(size(Ax));
    %
    %     % dyAx
    %     A2(:,1:end-1)=Ax(:,2:end);
    %     A2(:,end)=Ax(:,1); % to get the periodic thing correct
    %     A1(:,1:end-1)=Ax(:,1:end-1);
    %     A1(:,end)=Ax(:,end);
    %     A21_y=(A2 - A1)./resy;
    %
    %     A2=zeros(size(Ax));
    %     A1=zeros(size(Ax));
    %
    %     A2(1:end-1,:)=Ax(2:end,:);
    %     A2(end,:)=Ax(1,:); % to get the periodic thing correct
    %     A1(1:end-1,:)=Ax(1:end-1,:);
    %     A1(end,:)=Ax(end,:);
    %     A21_z=(A2 - A1)/resz;
    %     %----------------------------------------------------------------------
    %
    %     f56=figure(56);
    %     h1=subplot(2,2,1);
    %     dum_p=By ;hc=pcolor(dum_p);
    %     set(hc,'edgecolor','none')
    %     title('By')
    %     colorbar; colormap(h1,BWR);%caxis([-max(max(abs(dum_p))),max(max(abs(dum_p)))]);
    %     h2=subplot(2,2,2);
    %     dum_p=-A21_y ;hc=pcolor(dum_p);
    %     set(hc,'edgecolor','none')
    %     title('-dyAx')
    %     colorbar; colormap(h2,BWR);%caxis([-max(max(abs(dum_p))),max(max(abs(dum_p)))]);
    %     h3=subplot(2,2,3);
    %     dum_p=Bz ;hc=pcolor(dum_p);
    %     set(hc,'edgecolor','none')
    %     title('Bz')
    %     colorbar;colormap(h3,BWR);%caxis([-max(max(abs(dum_p))),max(max(abs(dum_p)))]);
    %     h4=subplot(2,2,4);
    %     %hc=pcolor(A21_x);
    %     dum_p=A21_z ;hc=pcolor(dum_p);
    %     set(hc,'edgecolor','none')
    %     title('dzAx')
    %     colorbar;colormap(h4,BWR);%caxis([-max(max(abs(dum_p))),max(max(abs(dum_p)))]);
    %     %mean(abs(By-(-A21_y)),'all')
    %     %mean(abs(Bx-(A21_x)),'all')
    %     %----------------------------------------------------------------------
    %     %clearvars Iapprox_i Iapprox_j Ax A21_z A21_y
    %     %----------------------------------------------------------------------


    % Integrate to do stack plots on time
    %----------------------------------------------------------------------
    %inte_Ax_i(:,jn) = sum(Ax,1)/length(Ax(:,1)); % this is to compute the average over the y direction
    inte_Ax_i(:,jn) = Ax(length(yll)/2,:); %The value of the Ax at (quasi) the neutral line.
    By_y0_i(:,jn) = By(length(yll)/2,:);
    %----------------------------------------------------------------------

    abs_Ax=abs(Ax(length(yll)/2,:)); % get the Ax values on the neutral line
    %     f22=figure(22);
    %     plot(zll,abs_Ax)
    %     xlim([zll(1),zll(end)])
    %     ylim([-1,1])
    %----------------------------------------------------------------------
    % Get the local maxima and minima
    Ax_max=max(max(abs_Ax));
    Ax_min=min(min(abs_Ax));
    Ax_maxmin_i = Ax_max - Ax_min;

    cond_max=(abs_Ax==Ax_max);
    cond_min=(abs_Ax==Ax_min);

    clearvars Ex_maxmin_i
    if(Ax_max~=Ax_min)
        %get the position of the first min.
        ind_max=(abs_Ax==Ax_min);
        zll_2=zll.*ind_max;
        aa=sum(ind_max~=0);
        Ex_maxmin_i=sum(Ex(length(yll)/2).*ind_max)/aa; %average of the values of the electric field
    else
        Ex_maxmin_i=nan;
    end

    %----------------------------------------------------------------------
    %store the value to compute the time derivative
    Ax_maxmin(1,in)=Ax_maxmin_i;
    Ex_maxmin(1,in)=Ex_maxmin_i;
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    %str = string(S2(in).name);
    %newStr = extractBetween(str,"pfd_moments.","_p000000.h5");
    str = string(S(in).name);
    newStr = extractBetween(str,"pfd.","_p000000.h5");
    N_steps = str2double(newStr);
    time_t = dt*N_steps;
    time_t_2(1,in)=time_t;


    yticks_mine=[floor(-Ly*0.9) floor(-Ly/2) 0 floor(Ly/2) floor(Ly*0.9)];
    zticks_mine=[floor(-Lz*0.9) floor(-Lz/2) 0 floor(Lz/2) floor(Lz*0.9)];
    %----------------------------------------------------------------------


    % Extract the modes to get the growth rate of each mode
    %----------------------------------------------------------------------
    threshold=pi/resy;
    var=Ax;

    % to test the algorithm
    %     var=1.*sin(2*pi*YLL./Ly) + 1.*sin(2*pi*ZLL./Lz) ;%+ 1.*sin(2*pi*YLL./Ly) + 1.*sin(2*pi*ZLL./Lz);
    %     f87=figure(87)
    %     pcolor(ZLL,YLL,var)

    N=size(var);
    var=var-mean(mean(mean((var)))); %Detrend mean
    FF_Ax = abs(fftn(var)).*sqrt(N(1)*N(2)); % it this normalization necessary?
    S_FF_Ax = fftshift(FF_Ax);

    kz=((0:N(2)-1)-N(2)/2).*2*pi/Lz; %Includes negative wavenumbers
    ky=((0:N(1)-1)-N(1)/2).*2*pi/Ly;
    %kz=((0:N(3)-1)-N(3)/2).*2*pi/Lz;

    % get the real and imaginary parts
    zz=real(S_FF_Ax);
    yy=imag(S_FF_Ax);

    % get the amplitude and phase
    Amp=sqrt(zz.^2)./(N(1)*N(2));
    %Amp=sqrt(yy.^2)./(N(1)*N(2)); % this returns nothing
    %Amp=(zz.^2 + yy.^2)./(N(1)*N(2));
    phase=atan(yy./zz)./(N(1)*N(2));

    %size1=size(Amp);
    %Amp=Amp./(size1(1)*size1(2));
    %size1=size(phase);
    %phase=phase./(size1(1)*size1(2));

    % Get the step in kz and ky
    dky=ky(end)-ky(end-1);
    dkz=kz(end)-kz(end-1);

    % To get the values on a single quadrant and removing the zero k
    %----------------------------------------------------------------------
    Na2_y =length(Amp(:,1))/2 + 1;
    Na2_z =length(Amp(1,:))/2 + 1;

    %     Amp=Amp(Na2_y:end,Na2_z:end);
    %     phase=phase(Na2_y:end,Na2_z:end);
    %     ky=ky(1,Na2_y:end);
    %     kz=kz(1,Na2_z:end);

    [KZ,KY]=meshgrid(kz,ky);
    % Removing first the values above the threshold.
    Amp= Amp.*((KY<threshold)).*((KZ<threshold));
    phase= phase.*((KY<threshold)).*((KZ<threshold));

    Amp_y = sum(Amp,1)*dky; %integral over y
    Amp_z = sum(Amp,2)*dkz; %integral over z

    %This block gives mixed values for the modes as, at each time the modes
    %do not extrictly corresponds to the first 4 harmonics.
    %----------------------------------------------------------------------
    % Get the positions of a given frequency by sorting to get the values
    % for the values ingrated over y so they depends on z
    [sorted_Amp_y, sortedInds_Amp_y] = sort(Amp_y(:),'descend');
    top4_z = sortedInds_Amp_y(1:4); % position of the maxima
    top4_Amp_y =sorted_Amp_y(1:4); % value of the maxima
    kz_0 = kz(top4_z);

    % for the values ingrated over z so they depends on y
    [sorted_Amp_z, sortedInds_Amp_z] = sort(Amp_z(:),'descend');
    top4_y = sortedInds_Amp_z(1:4); % position of the maxima
    top4_Amp_z =sorted_Amp_z(1:4); % value of the maxima
    ky_0 = ky(top4_y);

    %saving the values of the given kz and ky
    kz_0_i(in,:)=kz_0;
    ky_0_i(in,:)=ky_0;
    Amp_kz_0_i(in,:) = top4_Amp_y; % squared amplitud associated to the mode in kz
    Amp_ky_0_i(in,:) = top4_Amp_z; % squared amplitud associated to the mode in ky
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    % Get the position and value of the first k
    kz0_1 = 2*1*2*pi/Lz;    kz0_2 = 2*2*2*pi/Lz; % the extra 2 in front its to account for the negative positive interval
    kz0_3 = 2*3*2*pi/Lz;    kz0_4 = 2*4*2*pi/Lz;

    ky0_1 = 2*1*2*pi/Ly;    ky0_2 = 2*2*2*pi/Ly;
    ky0_3 = 2*3*2*pi/Ly;    ky0_4 = 2*4*2*pi/Ly;

    % Get the value for the first four modes in kz
    cond_1=(kz==kz0_1);
    Amp_y_1 = Amp_y.*cond_1;
    Amp_y_1 = sum(Amp_y_1)/sum(cond_1);

    cond_2=(kz==kz0_2);
    Amp_y_2 = Amp_y.*cond_2;
    Amp_y_2 = sum(Amp_y_2)/sum(cond_2);

    cond_3=(kz==kz0_3);
    Amp_y_3 = Amp_y.*cond_3;
    Amp_y_3 = sum(Amp_y_3)/sum(cond_3);

    cond_4=(kz==kz0_4);
    Amp_y_4 = Amp_y.*cond_4;
    Amp_y_4 = sum(Amp_y_4)/sum(cond_4);

    % Get the value for the first four modes in ky
    cond_1=(ky==ky0_1)';
    Amp_z_1 = Amp_z.*cond_1;
    Amp_z_1 = sum(Amp_z_1)/sum(cond_1);

    cond_2=(ky==ky0_2)';
    Amp_z_2 = Amp_z.*cond_2;
    Amp_z_2 = sum(Amp_z_2)/sum(cond_2);

    cond_3=(ky==ky0_3)';
    Amp_z_3 = Amp_z.*cond_3;
    Amp_z_3 = sum(Amp_z_3)/sum(cond_3);

    cond_4=(ky==ky0_4)';
    Amp_z_4 = Amp_z.*cond_4;
    Amp_z_4 = sum(Amp_z_4)/sum(cond_4);

    % Store the values
    Amp_ky_T_i(in,:) = [Amp_y_1; Amp_y_2; Amp_y_3; Amp_y_4];
    Amp_kz_T_i(in,:) = [Amp_z_1; Amp_z_2; Amp_z_3; Amp_z_4];
    %   %----------------------------------------------------------------------


    %----------------------------------------------------------------------
    %     %----------------------------------------------------------------------
    %     % Apply the condition of along Bz=0;
    %     A_cond=zeros(length(yll),length(zll));
    %     for kn=1:length(zll)
    %         bz_min = min(abs(Bz(:,kn)));
    %         A_cond(:,kn)=(Bz(:,kn)==bz_min);
    %     end
    %
    % %     epsi_1=0.001; %threshold
    % %     A1=(Bz<epsi_1); % find the regions where Bz=0
    % %     A_cond=A1;
    %
    %     Ax_y_bz0=A_cond.*Ax; % find the value of the reconnecting electric field
    %     %----------------------------------------------------------------------
    %
    %     %----------------------------------------------------------------------
    %     % Get the maximum and the minimum
    %     Ax_max=max(max(Ax_y_bz0));
    %     Ax_min=min(min(Ax_y_bz0));
    %     Ax_maxmin = Ax_max - Ax_min;
    %     Ax_maxmin_avg_i=Ax_maxmin;
    %
    %     Ax_max_a(1,jn)=Ax_max;
    %     Ax_min_a(1,jn)=Ax_min;
    % %     A_cond_n= A_cond(A_cond~=0);
    % %     Ax_maxmin_avera= sum((Ax_maxmin),'all')./ length(A_cond_n);
    % %     Ax_maxmin_avg_i=Ax_maxmin_avera/Vae_b;
    %
    %     %store the value to compute the time derivative
    %     Ax_maxmin_avg(1,in)=Ax_maxmin_avg_i;
    %     %----------------------------------------------------------------------
    %
    %     J_mag=sqrt(Jx.^2 + Jy.^2 + Jz.^2);
    %     J_mag_max_i=max(max(J_mag));
    %     J_mag_max(1,jn)=J_mag_max_i;
    %     %--------------------------------------------------------------------------
    %
    %
    %To see the contours of the vector potential and the value of the
    %reconneting electric field.
    x0=0;y0=0;
    width=1000;%size_X(2);
    height=350;%size_X(1);
    cd(path_s2) % just the vector potential
    %     %----------------------------------------------------------------------
    %     fs=18;
    %     f57=figure(57);
    %     set(gcf,'position',[x0,y0,0.9*width,height])
    %     h1=subplot(1,1,1);
    %     dum_p=-Ax; % there was a -Ax here
    %     lim_yp=max(max(max(abs(dum_p))));
    %     dum_p=dum_p/B0;%lim_yp;
    %     [C,h]=contourf(ZLL,YLL,dum_p,'LevelStep',0.5);
    %     set(h,'LineColor','black','LineWidth',1)
    %     colorbar
    %     %colormap(h1,flipud(jet));
    %     colormap(h1,jet);
    %     %set(hc1,'edgecolor','none')
    %     hcb=colorbar; hcb.Location = 'eastoutside';
    %     hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    %     %caxis([0 1]); % lange_all
    %     %hcb.Ruler.Exponent = -1;
    %     ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    %     ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    %     ax.YLabel.String = '$y / d_{i}$'; ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    %     ax.XLabel.String = '$z / d_{i}$';
    %     ax.XTick = [-30, -20,-10,10,20,30];
    %     ax.XLabel.Position = [0, -10];
    %     xlim([zll(1) zll(end)]); ylim([yll(1) yll(end)]);
    %     lgnd=legend([h1],'$\frac{A_{x}}{d_{i}B_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    %     %set(lgnd,'color','none');
    %     hold off
    %     %----------------------------------------------------------------------
    %     sgtitle('$$t = \ $$'+string(round((time_t/omega_pe_Omega_ce),2)) + ...
    %         '$$ \ \Omega_{ce}^{-1}$$','Interpreter','latex','FontSize',fs)
    %     %----------------------------------------------------------------------
    %     cd(path_rec_line)
    %     saveas(f57,strcat(num2str(time_t),'Ax_contour.png'));
    %     %----------------------------------------------------------------------

    %      %To see the contours of the vector potential and the value of the
    %      %reconneting electric field.
    %     cd(path_s2)
    %     %----------------------------------------------------------------------
    %     fs=18;
    %     f57=figure(57);
    %     h1=subplot(2,1,1);
    %     %hc=pcolor(ZLL,YLL,Ex);
    %     %set(hc,'edgecolor','none')
    %     %hold on
    %     dum_p=-Ax; % there was a -Ax here
    %     lim_yp=max(max(max(abs(dum_p))));
    %     dum_p=dum_p/lim_yp;
    %     [C,h]=contourf(ZLL,YLL,dum_p,'LevelStep',0.1);
    %     set(h,'LineColor','black','LineWidth',1)
    %     colorbar
    %     %colormap(h1,flipud(jet));
    %     colormap(h1,jet);
    %     %set(hc1,'edgecolor','none')
    %     hcb=colorbar; hcb.Location = 'eastoutside';
    %     hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    %     %hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ;
    % %     if lim_yp~=0
    % %     %caxis([0 lim_yp]);
    % %     caxis([0 7]);
    % %     end
    %     %caxis([0 7]); % this changes according to each case
    %     caxis([0 1]); % lange_all
    %     %hcb.Ruler.Exponent = -1;
    %     ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    %     ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    %     ax.YLabel.String = '$y / d_{i}$'; ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    %     ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    %     xlim([zll(1) zll(end)]); ylim([yll(1) yll(end)]);
    %     lgnd=legend([h1],'$\frac{A_{x}}{A_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    %     %set(lgnd,'color','none');
    %     hold off
    %     %----------------------------------------------------------------------
    %     h2=subplot(2,1,2);
    %     dum_p=Ex/E0;
    %     hc2 = pcolor(ZLL,YLL,dum_p);
    %     hold on
    %     set(hc2,'edgecolor','none')
    %     colorbar
    %     lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR);
    %     hcb=colorbar; hcb.Location = 'eastoutside';
    %     hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    %     %hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ;
    %     %if lim_yp~=0
    %     %caxis([-lim_yp lim_yp]);
    %     %end
    %     caxis([-0.7 0.7]);
    %     %hcb.Ruler.Exponent = -1;
    %     ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    %     ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    %     ax.YLabel.String = '$y / d_{i}$'; ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    %     ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    %     xlim([zll(1) zll(end)]); ylim([yll(1) yll(end)]);
    %     lgnd=legend([h2],'$\frac{E_{x}}{E_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    %     %set(lgnd,'color','none');
    %     hold off
    %     sgtitle('$$t = \ $$'+string(round((time_t/omega_pe_Omega_ce),2)) + ...
    %         '$$ \ \Omega_{ce}^{-1}$$','Interpreter','latex','FontSize',fs)
    %
    %     %----------------------------------------------------------------------
    %     cd(path_rec_line)
    %     saveas(f57,strcat(num2str(time_t),'Ax_Ex.png'));
    %     %----------------------------------------------------------------------
    %     %----------------------------------------------------------------------
    %     %----------------------------------------------------------------------

    cd(path)
end

% Making the plots for the modes
time_t_2_Omega=time_t_2./omega_pe_Omega_ce;
lambs_perp=Ly./(2*pi./ky_0_i(:,:));
lambs_par=Lz./(2*pi./kz_0_i(:,:));

width=1300;%size_X(2);
height=500;%size_X(1);
fs=18; x0=0;y0=0;
%--------------------------------------------------------------------------

% Include in this plots the substraction of Amp_ky_T_alone and Amp_kz_T_alone
%--------------------------------------------------------------------------
f86=figure(86);
set(gcf,'position',[x0,y0,500.0,500.0])
subplot(1,1,1)
semilogy(time_t_2_Omega,Amp_ky_T_i(:,1),'k','LineWidth',2)
hold on
semilogy(time_t_2_Omega,Amp_ky_T_i(:,2),'b','LineWidth',2)
semilogy(time_t_2_Omega,Amp_ky_T_i(:,3),'r','LineWidth',2)
semilogy(time_t_2_Omega,Amp_ky_T_i(:,4),'c','LineWidth',2)
set(gca,'FontSize',fs)
ax = gca;
ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
xlim([time_t_2_Omega(1) time_t_2_Omega(end)]);
ylim([0.5*10^(-2) ,10^(2)]);
xlabel('$t (\Omega_{ce}^{-1}) $','Interpreter','latex','FontSize',fs)
ylabel('$|A_{\lambda_{m}}|^{2}$','Interpreter','latex','FontSize',fs)
legend({'$\lambda_{1}$','$\lambda_{2}$','$\lambda_{3}$','$\lambda_{4}$' },...
    'Interpreter','latex','FontSize',fs,...
    'Location','northeast','NumColumns',4)
%title('$$y/d_{i}=$$'+string(yll(1,sli_y)),'Interpreter','latex','FontSize',fs)
hold off
% %--------------------------------------------------------------------------
cd(path_rec_line)
saveas(f86,'modes_growth_one_002_long.png');
% %--------------------------------------------------------------------------

% %--------------------------------------------------------------------------
% Now including the maximum growth rate per mode according to Loureiro and
% Boldyrev 2018

% this requires to know at least the average B_perp at a given scale to
% compute the alfven speed

B_perp_1=1; %dummy value. This should depend on ky0_1 some how. Maybe trough an average
lambda_1 = 2*pi / ky0_1;
gamma_max_1 = (B_perp_1./sqrt(4*pi*me*n0)) * (1/lambda_1)^3;

% this is an upper bond to contrast against the value that I get from the
% linear fit.

% This needs to be modified to the growth rate reflects what is happening
% in the stack plot. There is some evidence on the amplitude that is
% injected but it has to be better interpreted.

% %--------------------------------------------------------------------------

nxx=10;
nyy=N_jn-2*nxx;
xx=time_t_2_Omega(1,nxx:nyy);
yy1=log(Amp_ky_T_i(nxx:nyy,1));
yy2=log(Amp_ky_T_i(nxx:nyy,2));
yy3=log(Amp_ky_T_i(nxx:nyy,3));
yy4=log(Amp_ky_T_i(nxx:nyy,4));

[p1,SS1] = polyfit(xx,yy1,1);
[p2,SS2] = polyfit(xx,yy2,1);
[p3,SS3] = polyfit(xx,yy3,1);
[p4,SS4] = polyfit(xx,yy4,1);

[fit_1,delta_1] = polyval(p1,xx,SS1);
[fit_2,delta_2] = polyval(p2,xx,SS2);
[fit_3,delta_3] = polyval(p3,xx,SS3);
[fit_4,delta_4] = polyval(p4,xx,SS4);

f44=figure(44);
plot(xx,yy1,'ok',xx,fit_1,'--k','LineWidth',2)
hold on
plot(xx,yy2,'ob',xx,fit_2,'--b','LineWidth',2)
plot(xx,yy3,'or',xx,fit_3,'--r','LineWidth',2)
plot(xx,yy4,'oc',xx,fit_4,'--c','LineWidth',2)
hold off
%legend('data','linear fit')

delta_1m=mean(delta_1);
delta_2m=mean(delta_2);
delta_3m=mean(delta_3);
delta_4m=mean(delta_4);

pp=[p1;p2;p3;p4]/2;
deltass=[delta_1m;delta_2m;delta_3m;delta_4m]/2;

f45=figure(45);
plot(xx,yy1,'ok','LineWidth',2)
hold on
plot(xx,fit_1+2*delta_1,'--b','LineWidth',2)
plot(xx,fit_1-2*delta_1,'--b','LineWidth',2)
hold off

grotwh_rate = horzcat(pp(:,1),deltass)

% % Include in this plots the substraction of Amp_ky_T_alone and Amp_kz_T_alone
% %--------------------------------------------------------------------------
% f86=figure(86);
% set(gcf,'position',[x0,y0,0.8*width,0.7*height])
% subplot(1,2,1)
% semilogy(time_t_2_Omega,Amp_ky_T_i(:,1),'k','LineWidth',2)
% hold on
% semilogy(time_t_2_Omega,Amp_ky_T_i(:,2),'b','LineWidth',2)
% semilogy(time_t_2_Omega,Amp_ky_T_i(:,3),'r','LineWidth',2)
% semilogy(time_t_2_Omega,Amp_ky_T_i(:,4),'c','LineWidth',2)
% set(gca,'FontSize',fs)
% ax = gca;
% ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
% ax.YLabel.Interpreter='latex';
% ax.FontSize=fs;
% xlim([time_t_2_Omega(1) time_t_2_Omega(end)]);
% ylim([0.5*10^(-2) ,10^(2)]);
% xlabel('$t (\Omega_{ce}^{-1}) $','Interpreter','latex','FontSize',fs)
% ylabel('$|A_{\lambda_{m},\perp}|^{2}$','Interpreter','latex','FontSize',fs)
% legend({'$\lambda_{1}$','$\lambda_{2}$','$\lambda_{3}$','$\lambda_{4}$' },...
%     'Interpreter','latex','FontSize',fs,...
%     'Location','northeast','NumColumns',4)
% %title('$$y/d_{i}=$$'+string(yll(1,sli_y)),'Interpreter','latex','FontSize',fs)
% hold off
% % %--------------------------------------------------------------------------
% subplot(1,2,2)
% semilogy(time_t_2_Omega,Amp_kz_T_i(:,1),'k','LineWidth',2)
% hold on
% semilogy(time_t_2_Omega,Amp_kz_T_i(:,2),'b','LineWidth',2)
% semilogy(time_t_2_Omega,Amp_kz_T_i(:,3),'r','LineWidth',2)
% semilogy(time_t_2_Omega,Amp_kz_T_i(:,4),'c','LineWidth',2)
% set(gca,'FontSize',fs)
% ax = gca;
% ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
% ax.YLabel.Interpreter='latex';
% ax.FontSize=fs;
% xlim([time_t_2_Omega(1) time_t_2_Omega(end)]);
% ylim([0.5*10^(-2) ,10^(2)]);
% xlabel('$t (\Omega_{ce}^{-1}) $','Interpreter','latex','FontSize',fs)
% ylabel('$|A_{\lambda_{m},\|}|^{2}$','Interpreter','latex','FontSize',fs)
% legend({'$\lambda_{1}$','$\lambda_{2}$','$\lambda_{3}$','$\lambda_{4}$' },...
%     'Interpreter','latex','FontSize',fs,...
%     'Location','northeast','NumColumns',4)
% %title('$$y/d_{i}=$$'+string(yll(1,sli_y)),'Interpreter','latex','FontSize',fs)
% hold off
%--------------------------------------------------------------------------

% % Include in this plots the substraction of Amp_ky_T_alone and Amp_kz_T_alone
% %--------------------------------------------------------------------------
% f87=figure(87);
% set(gcf,'position',[x0,y0,0.8*width,0.7*height])
% subplot(1,2,1)
% semilogy(time_t_2_Omega,Amp_ky_T_i(:,1) - Amp_ky_T_alone(:,1),'k','LineWidth',2)
% hold on
% semilogy(time_t_2_Omega,Amp_ky_T_i(:,2) - Amp_ky_T_alone(:,2),'b','LineWidth',2)
% semilogy(time_t_2_Omega,Amp_ky_T_i(:,3) - Amp_ky_T_alone(:,3),'r','LineWidth',2)
% semilogy(time_t_2_Omega,Amp_ky_T_i(:,4) - Amp_ky_T_alone(:,4),'c','LineWidth',2)
% set(gca,'FontSize',fs)
% ax = gca;
% ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
% ax.YLabel.Interpreter='latex';
% ax.FontSize=fs;
% xlim([time_t_2_Omega(1) time_t_2_Omega(end)]);
% ylim([0.5*10^(-2) ,10^(2)]);
% xlabel('$t (\Omega_{ce}^{-1}) $','Interpreter','latex','FontSize',fs)
% ylabel('$|A_{\lambda_{m},\perp}|^{2}$','Interpreter','latex','FontSize',fs)
% legend({'$\lambda_{1}$','$\lambda_{2}$','$\lambda_{3}$','$\lambda_{4}$' },...
%     'Interpreter','latex','FontSize',fs,...
%     'Location','northeast','NumColumns',4)
% %title('$$y/d_{i}=$$'+string(yll(1,sli_y)),'Interpreter','latex','FontSize',fs)
% hold off
% % %--------------------------------------------------------------------------
% subplot(1,2,2)
% semilogy(time_t_2_Omega,Amp_kz_T_i(:,1) - Amp_kz_T_alone(:,1),'k','LineWidth',2)
% hold on
% semilogy(time_t_2_Omega,Amp_kz_T_i(:,2) - Amp_kz_T_alone(:,2),'b','LineWidth',2)
% semilogy(time_t_2_Omega,Amp_kz_T_i(:,3) - Amp_kz_T_alone(:,3),'r','LineWidth',2)
% semilogy(time_t_2_Omega,Amp_kz_T_i(:,4) - Amp_kz_T_alone(:,4),'c','LineWidth',2)
% set(gca,'FontSize',fs)
% ax = gca;
% ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
% ax.YLabel.Interpreter='latex';
% ax.FontSize=fs;
% xlim([time_t_2_Omega(1) time_t_2_Omega(end)]);
% ylim([0.5*10^(-2) ,10^(2)]);
% xlabel('$t (\Omega_{ce}^{-1}) $','Interpreter','latex','FontSize',fs)
% ylabel('$|A_{\lambda_{m},\|}|^{2}$','Interpreter','latex','FontSize',fs)
% legend({'$\lambda_{1}$','$\lambda_{2}$','$\lambda_{3}$','$\lambda_{4}$' },...
%     'Interpreter','latex','FontSize',fs,...
%     'Location','northeast','NumColumns',4)
% %title('$$y/d_{i}=$$'+string(yll(1,sli_y)),'Interpreter','latex','FontSize',fs)
% hold off
% %--------------------------------------------------------------------------


% % These plots over here are for different modes. The modes with the maxim
% % values are not necessarely the same from time to time.
% %--------------------------------------------------------------------------
% clist = colormap(hsv(5));
% barticks=[1,2,3,4,5];
% % This requiers to give the color according to the value of each point
% %--------------------------------------------------------------------------
% f88=figure(88);
% set(gcf,'position',[x0,y0,0.8*width,0.7*height])
% h1=subplot(1,2,1);
% plot(time_t_2_Omega,lambs_perp(:,1),'*','color',clist(1,:),'LineWidth',2)
% hold on
% plot(time_t_2_Omega,lambs_perp(:,2),'*','color',clist(2,:),'LineWidth',2)
% plot(time_t_2_Omega,lambs_perp(:,3),'*','color',clist(3,:),'LineWidth',2)
% plot(time_t_2_Omega,lambs_perp(:,4),'*','color',clist(4,:),'LineWidth',2)
% set(gca,'FontSize',fs)
% ax = gca;
% ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
% ax.YLabel.Interpreter='latex';
% ax.FontSize=fs;
% xlim([time_t_2_Omega(1) time_t_2_Omega(end)]);
% ylim([0 ,5]);
% xlabel('$t (\Omega_{ce}^{-1}) $','Interpreter','latex','FontSize',fs)
% ylabel('$\lambda_\perp$','Interpreter','latex','FontSize',fs)
% hcb=colorbar; colormap(h1,clist); hcb.Location = 'eastoutside';
% hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
% hcb.Ticks = linspace(0.1,0.9,4);
% hcb.TickLabels = barticks;
% hcb.Title.Interpreter = 'latex';
% hcb.Title.String = '$\lambda_{m}$';
% %legend({'$\lambda_{1}$','$\lambda_{2}$','$\lambda_{3}$','$\lambda_{4}$' },...
% %    'Interpreter','latex','FontSize',fs,...
% %    'Location','northeast','NumColumns',4)
% %title('$$y/d_{i}=$$'+string(yll(1,sli_y)),'Interpreter','latex','FontSize',fs)
% hold off
% % %--------------------------------------------------------------------------
% subplot(1,2,2)
% plot(time_t_2_Omega,lambs_par(:,1),'*k','LineWidth',2)
% hold on
% plot(time_t_2_Omega,lambs_par(:,2),'*b','LineWidth',2)
% plot(time_t_2_Omega,lambs_par(:,3),'*r','LineWidth',2)
% plot(time_t_2_Omega,lambs_par(:,4),'*c','LineWidth',2)
% set(gca,'FontSize',fs)
% ax = gca;
% ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
% ax.YLabel.Interpreter='latex';
% ax.FontSize=fs;
% xlim([time_t_2_Omega(1) time_t_2_Omega(end)]);
% ylim([0 ,5]);
% xlabel('$t (\Omega_{ce}^{-1}) $','Interpreter','latex','FontSize',fs)
% ylabel('$\lambda_{\|}$','Interpreter','latex','FontSize',fs)
% legend({'$\lambda_{1}$','$\lambda_{2}$','$\lambda_{3}$','$\lambda_{4}$' },...
%     'Interpreter','latex','FontSize',fs,...
%     'Location','northeast','NumColumns',4)
% %title('$$y/d_{i}=$$'+string(yll(1,sli_y)),'Interpreter','latex','FontSize',fs)
% hold off
% %--------------------------------------------------------------------------

% Save the plots
%--------------------------------------------------------------------------
%cd(path_rec_line)
%saveas(f86,'modes_growth.png');
%saveas(f87,'max_four_modes.png');
%--------------------------------------------------------------------------

%making the stack plot Ax
%--------------------------------------------------------------------------
fs=18; % here I am actually plotting -Ax because I changed its sign to get the magnetic field components
[ZLT,OMT]=meshgrid(zll,time_t_2_Omega);
cd(path_s2)
f34=figure(34)
%set(gcf,'position',[x0,y0,0.9*width,height]) % there is a problem with the
%size of the font when using this
h1=subplot(1,1,1);
dum_p=-inte_Ax_i'/B0;%/max(max(abs(inte_Ax_i)));
hc = pcolor(ZLT,OMT,dum_p);
hold on
set(hc,'edgecolor','none')
%colorbar; colormap(h1,flipud(turbo))
colorbar; colormap(h1,turbo)
lim_yp=max(max(max(abs(dum_p))));
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
ax.YLabel.String = '$t / \Omega_{e}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
xlim([zll(1) zll(end)]); ylim([time_t_2_Omega(1) time_t_2_Omega(end)]);
lgnd=legend([h1],'$\frac{A_{x}}{d_{i}B_{0}} $','Interpreter','latex','FontSize',1.3*fs);
hold off
cd(path_rec_line)
saveas(f34,strcat(num2str(time_t),'Ax_stack_long.png'));
%--------------------------------------------------------------------------

%making the stack plot By
%--------------------------------------------------------------------------
fs=18; % here I am actually plotting -Ax because I changed its sign to get the magnetic field components
[ZLT,OMT]=meshgrid(zll,time_t_2_Omega);
cd(path_s2)
f35=figure(35)
%set(gcf,'position',[x0,y0,0.9*width,height]) % there is a problem with the
%size of the font when using this
h1=subplot(1,1,1);
dum_p=By_y0_i'/B0;%/max(max(abs(inte_Ax_i)));
hc = pcolor(ZLT,OMT,dum_p);
hold on
set(hc,'edgecolor','none')
%colorbar; colormap(h1,flipud(turbo))
colorbar; colormap(h1,turbo)
lim_yp=max(max(max(abs(dum_p))));
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
ax.YLabel.String = '$t / \Omega_{e}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
xlim([zll(1) zll(end)]); ylim([time_t_2_Omega(1) time_t_2_Omega(end)]);
lgnd=legend([h1],'$\frac{B_{y}}{B_{0}} $','Interpreter','latex','FontSize',1.3*fs);
hold off
cd(path_rec_line)
%saveas(f35,strcat(num2str(time_t),'By_stack_long.png'));
% %--------------------------------------------------------------------------
%
%
% %--------------------------------------------------------------------------
% %Ex_max_min_nonan = rmmissing(Ex_maxmin);
% Ex_max_min_nonan = Ex_maxmin(~isnan(Ex_maxmin));
%
% %clearvars Ex_max_min_nonan
% %ind = ~isnan(Columns);
% %Columns=Columns(ind);
%
% % The smoothing works but the answer its funny. Continue here. Jeff (21/11/22)
% % Remove the fluctuations to get a monotonic trend
% time_t_2_Omega=time_t_2./omega_pe_Omega_ce;
% %--------------------------------------------------------------------------
% f99=figure(99);
% plot(time_t_2_Omega,Ax_maxmin,'k','LineWidth',2)
% hold on
% Ax_maxmin_filt = smoothdata(Ax_maxmin,'gaussian',20);
% plot(time_t_2_Omega,Ax_maxmin_filt,'b','LineWidth',2)
% set(gca,'FontSize',fs)
% ax = gca;
% ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
% %yyaxis right
% ax.YLabel.Interpreter='latex';
% ax.FontSize=fs;
% xlim([time_t_2_Omega(1) time_t_2_Omega(end)]);
% %ylimit=[abs(Ex_1d2/E0),abs(Ex_p_1d2/E0),abs(vixBx_1d2/E0),abs(ve_dot_gradve_x_1d2/E0)];
% %ylimit=max(max(max(ylimit)));
% %if ylimit~=0
% %    ylim([-szlim*ylimit szlim*ylimit]);
% %end
% xlabel('$t (\Omega_{ce}^{-1}) $','Interpreter','latex','FontSize',fs)
% ylabel('$A_{x}$','Interpreter','latex','FontSize',fs)
% legend({'$A_{x}$','$A_{x,smooth}$' },'Interpreter','latex','FontSize',fs,...
%     'Location','northwest','NumColumns',4)
% %title('$$y/d_{i}=$$'+string(yll(1,sli_y)),'Interpreter','latex','FontSize',fs)
% hold off
% %--------------------------------------------------------------------------
% % Compute the time derivative
% Ax_maxmin_21=(Ax_maxmin_filt(1,2:end) - Ax_maxmin_filt(1,1:end-1));
% time_t_2_21=time_t_2(1,2:end) - time_t_2(1,1:end-1);
% % express the time in terms of Omega_ce
% %--------------------------------------------------------------------------
% dt_Omega=dt/omega_pe_Omega_ce;
% time_t_2_Omega=time_t_2./omega_pe_Omega_ce;
% time_t_2_21_Omega=time_t_2_21./omega_pe_Omega_ce;
% %--------------------------------------------------------------------------
% f199=figure(199);
% dum_p=(Ax_maxmin_21./time_t_2_21_Omega)/Vae;
% plot(time_t_2_Omega(1,2:end),dum_p,'k','LineWidth',2)
% hold on
% set(gca,'FontSize',fs)
% ax = gca;
% ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
% %yyaxis right
% ax.YLabel.Interpreter='latex';
% ax.FontSize=fs;
% xlim([time_t_2_Omega(1) time_t_2_Omega(end)]);
% ylimit=max(max(max(dum_p)));
% if ylimit~=0
%     ylim([0 ylimit]);
% end
% xlabel('$t (\Omega_{ce}^{-1}) $','Interpreter','latex','FontSize',fs)
% ylabel('${dA_{x}}/{dt}{V_{ae}}$','Interpreter','latex','FontSize',fs)
% %legend({'$A_{x}$','$A_{x,smooth}$' },'Interpreter','latex','FontSize',fs,...
% %    'Location','northwest','NumColumns',4)
% %title('$$y/d_{i}=$$'+string(yll(1,sli_y)),'Interpreter','latex','FontSize',fs)
% hold off
% %--------------------------------------------------------------------------
% cd(path_rec_line)
% saveas(f99,strcat(num2str(time_t),'Ax_time.png'));
% saveas(f199,strcat(num2str(time_t),'dAdt_time.png'));
% %--------------------------------------------------------------------------



% % Compute the time derivative
% Ax_maxmin_avg21=(Ax_maxmin_avg(1,2:end) - Ax_maxmin_avg(1,1:end-1));
% time_t_2_21=time_t_2(1,2:end) - time_t_2(1,1:end-1);
% E_rec=(1)*Ax_maxmin_avg21./(Vae*time_t_2_21);
%
% % express the time in terms of Omega_ce
% %--------------------------------------------------------------------------
% dt_Omega=dt/omega_pe_Omega_ce;
% time_t_2_Omega=time_t_2./omega_pe_Omega_ce;
% %--------------------------------------------------------------------------


% % Where is window defined? The window must be defined with the average?
% %--------------------------------------------------------------------------
% fs=18;
% f7=figure(7);
% %dt_plot=time_t_2;
% dt_plot=time_t_2_Omega;
% plot(dt_plot(1,2:end),E_rec,'-k','LineWidth',2)
% %plot(dt_plot(1,1:window),E_rec_av_Ome,'-k','LineWidth',2)
% hold on
% set(gca,'FontSize',20)
% ax = gca;
% ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% ax.FontSize=fs;
% xlim([dt_plot(1) dt_plot(end)]);
% %ylim([10^(1) 10^(10)]);
% %xlabel('$$t (\omega_{pe}^{-1}) $$','Interpreter','latex','FontSize',fs)
% xlabel('$$t (\Omega_{ce}^{-1}) $$','Interpreter','latex','FontSize',fs)
% ylabel('$$E_{x}/B_{0}v_{A,B}$$','Interpreter','latex','FontSize',fs)
% %legend({'$|B|$','$|p_{ei}|$',},'Interpreter','latex','FontSize',fs)
% hold off
%
% f6=figure(6);
% dt_plot=time_t_2_Omega;
% %plot(time_t_2(1,:),J_mag_max(1,:),'-k','LineWidth',2)
% plot(dt_plot(1,:),J_mag_max(1,:),'-k','LineWidth',2)
% hold on
%     set(gca,'FontSize',20)
%     ax = gca;
%     ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%     ax.FontSize=fs;
% %xlim([time_t_2(1) time_t_2(end)]);
% %xlabel('$$t (\omega_{pe}^{-1}) $$','Interpreter','latex','FontSize',fs)
% xlabel('$$t (\Omega_{ce}^{-1}) $$','Interpreter','latex','FontSize',fs)
% ylabel('$$|J_{max}|$$','Interpreter','latex','FontSize',fs)
% %legend({'$|B|$','$|p_{ei}|$',},'Interpreter','latex','FontSize',fs)
% hold off
%
% cd(path_rec_line)
% saveas(f7,strcat(num2str(time_t),'reconnection_line.png'));
% saveas(f6,strcat(num2str(time_t),'Jmax_line.png'));
% cd(path_s2)
% %--------------------------------------------------------------------------
%
%
%
% % This is To see if an average will make things work
% %--------------------------------------------------------------------------
% Nav_t=floor(0.25/dt_Omega);
% % Do the average in time 1 or 2 Omega_ce
% L_Nav_t=floor(length(time_t_2)/Nav_t);
%
% E_rec_av_Ome=zeros(1,L_Nav_t);
% dtt=0;
% for it=1:L_Nav_t
%     E_rec_av_Ome(1,it) = sum(E_rec(1,1+dtt:Nav_t))/Nav_t;
%     dtt= dtt + Nav_t;
% end
% %--------------------------------------------------------------------------
%
% % this is to check how this is not working, the max-min is not always
% % increasing.
%
% % The maximum of the vector potential increases and then it decreases and
% % then back up again
% %--------------------------------------------------------------------------
% f67=figure(67)
% subplot(4,1,1)
% semilogy(time_t_2_Omega,Ax_max_a,'r')%./(Vae_b*time_t_2_Omega)
% xlim([time_t_2_Omega(1) time_t_2_Omega(end)])
% subplot(4,1,2)
% plot(Ax_min_a,'b')
% xlim([time_t_2_Omega(1) time_t_2_Omega(end)])
% subplot(4,1,3)
% Ax_maxmin_3 = Ax_max_a - Ax_min_a; % the difference max min
% Ax_maxmin_a21=(Ax_maxmin_3(1,2:end) - Ax_maxmin_3(1,1:end-1))./(dt_Omega); % time diference
% plot(time_t_2_Omega(1,8:38),Ax_maxmin_a21(1,8:38),'*k')
% hold on
% plot(time_t_2_Omega(1,49:69),Ax_maxmin_a21(1,49:69),'*k')
% xlim([time_t_2_Omega(1) time_t_2_Omega(end)])
% hold off
%
% Nav_t=floor(0.25/dt_Omega);L_Nav_t=floor(length(time_t_2)/Nav_t);
% Ax_maxmin_a21_Ome=zeros(1,L_Nav_t);
% dtt=0;
% for it=1:L_Nav_t
%     Ax_maxmin_a21_Ome(1,it) = sum(Ax_maxmin_a21(1,1+dtt:Nav_t))/Nav_t;
%     dtt= dtt + Nav_t;
% end
% subplot(4,1,4)
% plot(Ax_maxmin_a21_Ome,'*k')
% %--------------------------------------------------------------------------
%
% %--------------------------------------------------------------------------
% Nav_t=floor(0.25/dt_Omega); % why this 0.25
% % Do the average in time 1 or 2 Omega_ce
% L_Nav_t=floor(length(time_t_2)/Nav_t);
%
% E_rec_av_Ome=zeros(1,L_Nav_t);
% dtt=0;
% for it=1:L_Nav_t
%     E_rec_av_Ome(1,it) = sum(E_rec(1,1+dtt:Nav_t))/Nav_t;
%     dtt= dtt + Nav_t;
% end
%
% f67=figure(67)
% subplot(4,1,1)
% %semilogy(time_t_2,Ax_max_a,'r')
% plot(time_t_2,time_t_2_Omega)
% %--------------------------------------------------------------------------

%     % Compute the out of the plane vector potential
%     %----------------------------------------------------------------------
%     % get ax integrating over y
%     dx = resy; dy = resz;
%     ny=sss(1);
%     nz=sss(2);
%     Iapprox = zeros(size(By));
%     Iapprox_i=0;
%     %integral over y
%     for i=1:ny-1
%             Iapprox_i = Iapprox_i + dy*Bz(i,:);
%             Iapprox(i,:)=Iapprox_i;
%     end
%
%     Ax_y=Iapprox; %<------- This is the correct Ax
%     Ax_y=-Ax_y;
%     %----------------------------------------------------------------------

%     %----------------------------------------------------------------------
%         % Check the derivatives to see how beutifully it works
%     A2=Ax_y(:,2:end);
%     A1=Ax_y(:,1:end-1);
%     A21_y=(A2 - A1)/resz;
%
%     A2=Ax_y(2:end,:);
%     A1=Ax_y(1:end-1,:);
%     A21_z=-(A2 - A1)/resy;
%     %----------------------------------------------------------------------
%     f56=figure(56);
%     subplot(2,2,1)
%     hc=pcolor(By);
%     set(hc,'edgecolor','none')
%     title('By')
%     colorbar
%     subplot(2,2,2)
%     hc=pcolor(A21_y);
%     set(hc,'edgecolor','none')
%     title('-dzAx')
%     colorbar
%     subplot(2,2,3)
%     hc=pcolor(Bz);
%     set(hc,'edgecolor','none')
%     title('Bz')
%     colorbar
%     subplot(2,2,4)
%     hc=pcolor(A21_z);
%     set(hc,'edgecolor','none')
%     title('dyAx')
%     colorbar
%     %----------------------------------------------------------------------
%
%     %----------------------------------------------------------------------
%     f57=figure(57);
%     subplot(2,2,1)
%     [C,h]=contourf(Ax_y,'LevelStep',0.2);
%     set(h,'LineColor','black','LineWidth',1)
%     %hc=pcolor(-Ax_y);
%     %set(hc,'edgecolor','none')
%     title('Ax_y')
%     colorbar
%     subplot(2,2,2)
%     hc=pcolor(Ax_y_bz0);
%     set(hc,'edgecolor','none')
%     title('cond*Ax_y')
%     colorbar
%     %----------------------------------------------------------------------

%     % Solving the poisson equation.. this is not quite working yet
%     %----------------------------------------------------------------------
%     % Compute Curl of magnetic field
%     sss=size(Bx);
%     ny=sss(1);
%     nz=sss(2);
%     curlB=zeros(sss);
%     for j=2:ny-1
%         for k=2:nz-1
%             curlB(j,k)=(Bz(j+1,k)-Bz(j-1,k))/2*resy - (By(j,k+1)-By(j,k-1))/2*resz;
%         end
%     end
%     % To get the cells in the last rows and columns
%     curlB(1,:) = curlB(2,:);
%     curlB(ny,:) = curlB(ny-1,:);
%     curlB(:,1) = curlB(:,nz-1);
%     curlB(:,nz) = curlB(:,2);
%
%     %----------------------------------------------------------------------
%     % solve the poisson equation
%     curlB_hat = fft(-curlB);
%
%     for k=1:nz
%         for j=1:ny
%             factor=(-1i*2*pi*resz*k/Lz)^2 + (-1i*2*pi*resy*j/Ly)^2;
%         end
%     end
%
%     phipq=curlB_hat./factor;
%
%     % Computing the out of plane vector potential;
%     Ax=ifft(phipq);
%----------------------------------------------------------------------



% This one doesnt work!!! why?
% get ax integrating over z
%----------------------------------------------------------------------
%     Iapprox = zeros(size(By));
%     Iapprox_i=0;
%     %integral over z
%     for j=1:nz-1
%             Iapprox_i = Iapprox_i + dz*Bz(:,j);
%             Iapprox(:,j)=Iapprox_i;
%     end
%     Ax_z=Iapprox;
%----------------------------------------------------------------------

%    %----------------------------------------------------------------------


%     %Computing phi_m integrating;
%     %----------------------------------------------------------------------
%     dy = resy; dz = resz;
%     Iapprox = zeros(size(By));
%     Iapprox_i=0;
%     for i=1:ny-1
%         for j=1:nz-1
%             Iapprox_i = Iapprox_i + dy*dz*Bx(i,j);
%             Iapprox(i,j)=Iapprox_i;
%         end
%     end
%
%     phi_m=Iapprox;
%     %----------------------------------------------------------------------


%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % to make the mesh to solve the equation
%
%     % Coordinates
%     lowerLeft  = [-Lz ,-Ly];
%     lowerRight = [Lz , -Ly];
%     upperRight = [Lz , Ly];
%     upperLeft =  [-Lz , Ly];
%
%     % Geometry matrix
%     S = [3,4 lowerLeft(1), lowerRight(1), upperRight(1), upperLeft(1), ...
%         lowerLeft(2), lowerRight(2), upperRight(2), upperLeft(2)];
%     gdm = S';
%     % Names
%     ns = 'S';
%     % Set formula
%     sf = 'S';
%     % Invoke decsg
%     g = decsg(gdm,ns,sf');
%     % Import g into model using geometryFromEdges.
%     model = createpde();
%     geometryFromEdges(model,g);
%     pdegplot(model,'EdgeLabels','on');
%
%     applyBoundaryCondition(model,"neumann","edge",[1,3],"g",0,"q",0);
%
%
%     %f = [1;2];
%     %a = 0;
%     %c = [1;3;5];
%
%     location.y=yll;
%     location.z=zll;
%     state.u=curlB;
%
%     fcoeff = fcoeffunction(location,state);
%
%
%     %specifyCoefficients(model,"f",@fcoeffunction)
%     specifyCoefficients(model,"m",0,"d",0,"c",1,"a",0,"f",@fcoeffunction);
%
%     generateMesh(model,"Hmax",0.25);
%     results = solvepde(model);
%
%     pdeplot(model,"XYData",results.NodalSolution)
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% For the reconnection rate (This doesn't work as I thought)
%----------------------------------------------------------------------
%     %
%     epsi_1=0.005; %threshold
%     epsi_2=0.005;
%     A1=abs(Bz)<epsi_1; % find the regions where Bz=0
%     A2=abs(By)<epsi_2; % find the regions where By=0
%     A_cond=A1.*A2;
%     Ex_rec=A_cond.*Ex; % find the value of the reconnecting electric field
%
%     A_cond_n= A_cond(A_cond~=0);
%     Ex_rec_avera= sum((Ex_rec),'all')./ length(A_cond_n);
%     Ex_rec_avg_i=Ex_rec_avera/Vae_b;
%
%     Ex_rec_avg(1,in)=Ex_rec_avg_i;
%----------------------------------------------------------------------

%----------------------------------------------------------------------
%This might be very useful but it is unnecesary at the moment
%----------------------------------------------------------------------
%     % This returns an identifier saying that the cells belong to the same cluster
%     L = bwlabeln(Ex_rec);
%     clus_ident= L(L~=0);
%     number_cluster = unique(clus_ident);
%
%     counts=zeros(1,length(number_cluster));
%     Ex_avg=zeros(1,length(number_cluster));
%     for i = 1:length(number_cluster)
%         counts(1,i) = sum(L==number_cluster(i),"all"); % number of times each unique value is repeated
%         Ex_avg_i = Ex_rec.*sum(L==number_cluster(i));
%         Ex_avg(1,i) = sum(Ex_avg_i,"all")./counts(1,i);
%     end
%----------------------------------------------------------------------

%     % For magnetic field lines
%     vby = By;
%     wbz = Bz;
%
%     % For the MFT vectors
%     vMFTy = MFT_y;
%     wMFTz = MFT_z;
%
%     bm_pla=sqrt(vby.*vby + wbz.*wbz);

%--------------------------------------------------------------------------



%     cd(path_s2)
%     % This is to call the script that will make and save the latests plots
%     %--------------------------------------------------------------------------
%
%
%     dCp=25; colorFVBl=[0 0 0 0.2]; %sv=3; asf=3; fs=18; lw=1.5;
%     fs=20;
%
%     % Plots
%     %---------------------------------------------------------------------
%
%     %---------------------
%     map_r = [1.0 1.0 1.0
%     1.0 0.9 0.9
%     1.0 0.8 0.8
%     1.0 0.7 0.7
%     1.0 0.6 0.6
%     1.0 0.5 0.5
%     1.0 0.4 0.4
%     1.0 0.3 0.3
%     1.0 0.2 0.2
%     1.0 0.1 0.1
%     1.0 0 0
%     0.8 0 0];
%     %---------------------
%
%
%     x0=0;y0=0;
%     %x0=-1759;y0=258;
%     asf=1;
%     sv=10; %this one is for the vectors
%     lwv=1.0; ypc_i=127; xpc_i = 93;
%     colorFVBl=[0 0 0 0.5];
%
%
%     width=1300;%size_X(2);
%     height=500;%size_X(1);
%     fs=20;
%
%
%     yticks_mine=[floor(-Ly*0.9) floor(-Ly/2) 0 floor(Ly/2) floor(Ly*0.9)];
%     zticks_mine=[floor(-Lz*0.9) floor(-Lz/2) 0 floor(Lz/2) floor(Lz*0.9)];
%     %----------------------------------------------------------------------



%    fs=18;
%     cd(path_s2)
%     f61=figure(61);
%     hc=pcolor(ZLL,YLL,Ex_rec);
%     hold on
%     ylimit=max(max(Ex_rec));
%     if ylimit~=0
%     caxis([-ylimit ylimit]);
%     end
%     %caxis([0 y_lim])
%     set(hc,'edgecolor','none')
%     colormap(BWR);
%     hcb=colorbar; hcb.Location = 'eastoutside';
%     hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%     set(gca,'FontSize',20)
%     ax = gca;
%     ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%     ax.FontSize=fs;
%     xlabel('$t (\omega_{pe}^{-1}) $','Interpreter','latex','FontSize',fs)
%     ylabel('$E_{x}/B_{0}v_{A,B}$','Interpreter','latex','FontSize',fs)
%     title('$$t = \ $$'+string(round(time_t,2)) + ...
%         '$$ \ \omega_{pe}^{-1}$$','Interpreter','latex','FontSize',fs)
%     hold off
%     %To save the plot
%     cd(path_rec_r)
%     saveas(f61,strcat(num2str(time_t),'reconnection_r.png'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
% This is trying to compute the double integral. This doesnt work yet
%----------------------------------------------------------------------
%     for i=1:nz% This has the problem of the singular same point
%         for j=1:ny
%             Ax_y = trapz(Jx ./ sqrt( (ZLL-ZLL(i,j))^.2 + (YLL-YLL(i,j))^.2 ) ) ;
%             Ax_yz = trapz(Ax_y);
%         end
%     end

%     dum_p=0;
%     Ax_yzz=zeros(size(By));
%     Ax_y=zeros(1,ny);
%     for i=1:152 % loop over x
%         for j=1:152 %loop over y
%             for ip=1:152 %integration over x
%                 for jp=1:152 %integration over y
%                     if(i~=ip || j~=jp) % condition to avoid zero division
%                         Ax_y(1,jp) = dum_p + (Jx(ip,jp) ./ sqrt( (ZLL(i,j)-ZLL(ip,jp))^.2 + (YLL(i,j)-YLL(ip,jp))^.2 ) )*resy ;
%                         dum_p = Ax_y(1,jp);
%                     elseif(i==ip && j==jp)
%                         continue
%                     end
%                 end
%                 %Az_yx = dum_p2 + Az_y(1,jp)*resx;
%                 %dump_2 = Az_yx;
%                 Ax_yz = sum(Ax_y)*resz;
%             end
%             Ax_yzz(i,j)= Ax_yz;
%         end
%     end
%
%     fun = @(x,y) 1./( sqrt(x + y) .* (1 + x + y).^2 );
%     ymax = @(x) 1 - x;
%     q = integral2(fun,0,1,0,ymax)
%
%
%     f43=figure(43);
%     h1=subplot(1,1,1)
%     hc=pcolor(ZLL,YLL,real(Ax_yzz));
%     set(hc,'edgecolor','none')
%     colormap(h1,jet)
%     title('Ax_yzz')
%     colorbar
%
%     Az_y=Az_yzz;
%
%     Byt=By';
%     Qy_x = trapz(Byt);
%     [QQ_x,QQ_y] = meshgrid(Qy_x,Qy_y);
%     f44=figure(44);
%     h1=subplot(1,2,1)
%     hc=pcolor(QQ_x);
%     set(hc,'edgecolor','none')
%     title('QQ_x')
%     h2=subplot(1,2,2)
%     hc=pcolor(QQ_y);
%     set(hc,'edgecolor','none')
%     title('QQ_y')
%     %--------------------------------------------------------------------
%     %--------------------------------------------------------------------
%     %--------------------------------------------------------------------

%Defining functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function f = fcoeffunction(location,state)
%Nr = 1; % Number of equations
%nr = length(location.z); % Number of columns
f = state.u;%zeros(Nr,nr); % Allocate f
end

function [P1Dper,P1Dpar]=Compute1DSpectra(P2D,kper,threshold)
%Calculate parallel and perpendicular 1D sepctra from the 2D spectrum.
[c,index]=min(abs(kper-threshold)); %Cut spectrum above a threshold k
Pthres=P2D(2,index);
mask2D=P2D>Pthres;
fieldMASKED=P2D.*mask2D;
P1Dper=sum(fieldMASKED,1); %Sum over parallel k
P1Dpar=sum(fieldMASKED,2); %Sum over perpendicular k
end