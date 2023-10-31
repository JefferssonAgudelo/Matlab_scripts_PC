%Pressure balance at one time
%clear all 
%close all

%path_1 = '/Users/jeffersson_agudelo/Documents/New_psc/second_try_version/build_2/testing_jeff/psc_test_temp';
%path_1 = '/Users/jeffersson_agudelo/Documents/New_psc/second_try_version/build_2/testing_jeff/psc_harris_yz_base_2_alone_large';
%path_1 = '/Users/jeffersson_agudelo/Documents/New_psc/second_try_version/build_2/testing_jeff/psc_harris_yz_base_2_alone_large2';

%path_1 = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_alone_large';

%path_1 = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_many_Ax_large_L8di_dB01_Omc1_kLd1_local_3';

%path_1 = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_many_Ax_large_L8di_dB01_Omc1_kLd1_local_3_conf3';

%path_1 = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_many_Ax_large_L10di/';
%path_1 = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_many_Ax_large_L10di_CP/';
%path_1 = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_many_Ax_large_L10di_lange_local/';

%path_1 = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_Tba_perpar_short_L1di';
%path_1 = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_short_L1di';
%path_1 = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_short_L1di';

path_1 = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_many_Ax_large_L4di_lange_local/';

%Maybe I can reduce the

%--------------------------------------------------------------------------
path=path_1;
%--------------------------------------------------------------------------
% To save the plots
cd(path)
%--------------------------------------------------------------------------
S = dir(fullfile(path,'pfd.*.h5'));
N=numel(S); % number of files to use
H=zeros(N);
%--------------------------------------------------------------------------
S2 = dir(fullfile(path,'pfd_moments.*.h5'));
N2=numel(S2); % number of files to use
H2=zeros(N2);
%%N=1;N2=1;
%N=N2;
%--------------------------------------------------------------------------
%in=10;
%--------------------------------------------------------------------------
% Change this accordingly
%--------------------------------------------------------------------------
% This file still requires to check the normalization
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
mime =1.;
omega_pe_Omega_ce=5;
MFT0=1; % is this simply one in this normalization
nb_n0 =0.1;
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
nb_n0 =0.1;
Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);
%Normalising only when making plots
%c=1; VA2c = 0.2;
%B0 = VA2c; E0 = B0*VA2c;
%Pi0 = mi*VA2c*VA2c; Pe0 = me*VA2c*VA2c;
%DeltaEpsilon0=VA2c*Pi0;
%DeltaEpsilon0=Pi0;
%--------------------------------------------------------------------------
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
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
in=1;
fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;
B=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
ss=size(B);
LZs=ss(3);
clearvars B
N_jn=N; %This is to store some but not all the time steps
%--------------------------------------------------------------------------

j_a_b = N_jn;

%--------------------------------------------------------------------------
E_in = cell(3,j_a_b);
B_in = cell(3,j_a_b);
J_in = cell(3,j_a_b);
n_in = cell(3,j_a_b);
v_i_in = cell(3,j_a_b);
v_e_in = cell(3,j_a_b);
v_in = cell(3,j_a_b);
Pij_i_in = cell(6,j_a_b);
Pij_e_in = cell(6,j_a_b);

n_i_vi_in = cell(3,j_a_b);
n_e_ve_in = cell(3,j_a_b);
n_v_in = cell(3,j_a_b);
%--------------------------------------------------------------------------

for jn=1:N
    %----------------------------------------------------------------------
    % for the fields
    %jn=N;
    in=jn;
    jjn=jn;

    %for the momments
    %jjn=jn-j_a+1;
    %----------------------------------------------------------------------
    %for jn=2:floor(N/10)
    %    in=(jn-1)*jn;
    % %     in=2 + floor(N*(jn-1)/10);
    %----------------------------------------------------------------------
    disp(strcat('Computing step ...',S(in).name))
    fileID =  S(in).name; %change the 1 per i
    %h5disp(fileID);
    info = h5info(fileID);
    EHJ_1st = info.Groups(16).Name;
    %----------------------------------------------------------------------
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
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    str = string(S(in).name);
    newStr = extractBetween(str,"pfd.","_p000000.h5");
    N_steps = str2double(newStr);
    time_t = dt*N_steps;
    time_t_2_Omega=time_t./omega_pe_Omega_ce;
    time_t_2(1,in)=time_t_2_Omega;
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    disp(strcat('Computing step ...',S2(jjn).name))
    fileID2 =  S2(jjn).name; %change the 1 per i
    %h5disp(fileID2);
    info2 = h5info(fileID2);
    moments_1st = info2.Groups(1).Name;
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    B{1,1}=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    B{1,2}=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
    B{1,3}=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));

    E{1,1}=h5read(fileID,strcat(EHJ_1st,'/ex_ec/p0/3d'));
    E{1,2}=h5read(fileID,strcat(EHJ_1st,'/ey_ec/p0/3d'));
    E{1,3}=h5read(fileID,strcat(EHJ_1st,'/ez_ec/p0/3d'));

    % This needs to be changed including the background
    J_up{1,1}=h5read(fileID2,strcat(moments_1st,'/jx_e_UP/p0/3d'));
    J_up{1,2}=h5read(fileID2,strcat(moments_1st,'/jy_e_UP/p0/3d'));
    J_up{1,3}=h5read(fileID2,strcat(moments_1st,'/jz_e_UP/p0/3d'));
    J_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/jx_e_BA/p0/3d'));
    J_ba{1,2}=h5read(fileID2,strcat(moments_1st,'/jy_e_BA/p0/3d'));
    J_ba{1,3}=h5read(fileID2,strcat(moments_1st,'/jz_e_BA/p0/3d'));
    J{1,1}=(J_up{1,1}+J_ba{1,1})./1;
    J{1,2}=(J_up{1,2}+J_ba{1,2})./1;
    J{1,3}=(J_up{1,3}+J_ba{1,3})./1;
    %clearvars J_ba J_up
    %----------------------------------------------------------------------

    ssz=size(B{1,1});
    sli_x = 1; %floor(4+ssz(1)/2);%1;

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

    clearvars E B J
    %---------------------------------------------------------------------

    % Loading the data for the bulk speed of the particles
    %----------------------------------------------------------------------
    p_e_up{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e_UP/p0/3d'));
    p_e_up{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e_UP/p0/3d'));
    p_e_up{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e_UP/p0/3d'));

    p_i_up{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i_UP/p0/3d'));
    p_i_up{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i_UP/p0/3d'));
    p_i_up{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i_UP/p0/3d'));

    p_e_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e_BA/p0/3d'));
    p_e_ba{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e_BA/p0/3d'));
    p_e_ba{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e_BA/p0/3d'));

    p_i_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i_BA/p0/3d'));
    p_i_ba{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i_BA/p0/3d'));
    p_i_ba{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i_BA/p0/3d'));

    p_e{1,1}=(p_e_up{1,1}+p_e_ba{1,1})./1;
    p_e{1,2}=(p_e_up{1,2}+p_e_ba{1,2})./1;
    p_e{1,3}=(p_e_up{1,3}+p_e_ba{1,3})./1;

    p_i{1,1}=(p_i_up{1,1}+p_i_ba{1,1})./1;
    p_i{1,2}=(p_i_up{1,2}+p_i_ba{1,2})./1;
    p_i{1,3}=(p_i_up{1,3}+p_i_ba{1,3})./1;

    %clearvars p_i_up p_e_up p_i_ba p_e_ba
    %----------------------------------------------------------------------

    % computing the velocities in units of c
    %----------------------------------------------------------------------
    v_e=cell(1,3);
    v_i=cell(1,3);
    v_e_ba=cell(1,3);
    v_i_ba=cell(1,3);
    v_e_up=cell(1,3);
    v_i_up=cell(1,3);

    for i=1:3
        v_e{1,i} = p_e{1,i} * c ./ sqrt(c^2 * me^2 + p_e{1,i}.^2);
        v_i{1,i} = p_i{1,i} * c ./ sqrt(c^2 * mi^2 + p_i{1,i}.^2);
        v_e_up{1,i} = p_e_up{1,i} * c ./ sqrt(c^2 * me^2 + p_e_up{1,i}.^2);
        v_i_up{1,i} = p_i_up{1,i} * c ./ sqrt(c^2 * mi^2 + p_i_up{1,i}.^2);
        v_e_ba{1,i} = p_e_ba{1,i} * c ./ sqrt(c^2 * me^2 + p_e_ba{1,i}.^2);
        v_i_ba{1,i} = p_i_ba{1,i} * c ./ sqrt(c^2 * mi^2 + p_i_ba{1,i}.^2);
    end

    %clearvars p_i p_e p_i_up p_e_up p_i_ba p_e_ba
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    v_ex = v_e{1,1}; v_ex = squeeze(v_ex(sli_x,:,:));
    v_ey = v_e{1,2}; v_ey = squeeze(v_ey(sli_x,:,:));
    v_ez = v_e{1,3}; v_ez = squeeze(v_ez(sli_x,:,:));

    v_e_upx = v_e_up{1,1}; v_e_upx = squeeze(v_e_upx(sli_x,:,:));
    v_e_upy = v_e_up{1,2}; v_e_upy = squeeze(v_e_upy(sli_x,:,:));
    v_e_upz = v_e_up{1,3}; v_e_upz = squeeze(v_e_upz(sli_x,:,:));

    v_e_bax = v_e_ba{1,1}; v_e_bax = squeeze(v_e_bax(sli_x,:,:));
    v_e_bay = v_e_ba{1,2}; v_e_bay = squeeze(v_e_bay(sli_x,:,:));
    v_e_baz = v_e_ba{1,3}; v_e_baz = squeeze(v_e_baz(sli_x,:,:));

    v_ix = v_i{1,1}; v_ix = squeeze(v_ix(sli_x,:,:));
    v_iy = v_i{1,2}; v_iy = squeeze(v_iy(sli_x,:,:));
    v_iz = v_i{1,3}; v_iz = squeeze(v_iz(sli_x,:,:));

    v_i_upx = v_i_up{1,1}; v_i_upx = squeeze(v_i_upx(sli_x,:,:));
    v_i_upy = v_i_up{1,2}; v_i_upy = squeeze(v_i_upy(sli_x,:,:));
    v_i_upz = v_i_up{1,3}; v_i_upz = squeeze(v_i_upz(sli_x,:,:));

    v_i_bax = v_i_ba{1,1}; v_i_bax = squeeze(v_i_bax(sli_x,:,:));
    v_i_bay = v_i_ba{1,2}; v_i_bay = squeeze(v_i_bay(sli_x,:,:));
    v_i_baz = v_i_ba{1,3}; v_i_baz = squeeze(v_i_baz(sli_x,:,:));

    %clearvars v_i_up v_e_up v_i_ba v_e_ba %<----
    %---------------------------------------------------------------------

    % densities
    %----------------------------------------------------------------------
    n_e_up{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_e_UP/p0/3d'));
    n_i_up{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_i_UP/p0/3d'));
    n_e_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_e_BA/p0/3d'));
    n_i_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_i_BA/p0/3d'));
    n_e_up{1,1}=-1.*n_e_up{1,1};
    n_e_ba{1,1}=-1.*n_e_ba{1,1};

    n_e{1,1}=(n_e_up{1,1} + n_e_ba{1,1})./1;
    n_i{1,1}=(n_i_up{1,1} + n_i_ba{1,1})./1;
    n_e{1,1}=1.*n_e{1,1}; %there was a minus here.
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    Txx_e_up=h5read(fileID2,strcat(moments_1st,'/txx_e_UP/p0/3d'));
    Tyy_e_up=h5read(fileID2,strcat(moments_1st,'/tyy_e_UP/p0/3d'));
    Tzz_e_up=h5read(fileID2,strcat(moments_1st,'/tzz_e_UP/p0/3d'));
    Txy_e_up=h5read(fileID2,strcat(moments_1st,'/txy_e_UP/p0/3d'));
    Txz_e_up=h5read(fileID2,strcat(moments_1st,'/tzx_e_UP/p0/3d'));
    Tyz_e_up=h5read(fileID2,strcat(moments_1st,'/tyz_e_UP/p0/3d'));

    Txx_e_ba=h5read(fileID2,strcat(moments_1st,'/txx_e_BA/p0/3d'));
    Tyy_e_ba=h5read(fileID2,strcat(moments_1st,'/tyy_e_BA/p0/3d'));
    Tzz_e_ba=h5read(fileID2,strcat(moments_1st,'/tzz_e_BA/p0/3d'));
    Txy_e_ba=h5read(fileID2,strcat(moments_1st,'/txy_e_BA/p0/3d'));
    Txz_e_ba=h5read(fileID2,strcat(moments_1st,'/tzx_e_BA/p0/3d'));
    Tyz_e_ba=h5read(fileID2,strcat(moments_1st,'/tyz_e_BA/p0/3d'));


    %clearvars Txx_e_ba Txx_e_up Tyy_e_ba Tyy_e_up Tzz_e_ba Tzz_e_up
    %clearvars Txy_e_ba Txy_e_up Txz_e_ba Txz_e_up Tyz_e_ba Tyz_e_up

    Txx_i_up=h5read(fileID2,strcat(moments_1st,'/txx_i_UP/p0/3d'));
    Tyy_i_up=h5read(fileID2,strcat(moments_1st,'/tyy_i_UP/p0/3d'));
    Tzz_i_up=h5read(fileID2,strcat(moments_1st,'/tzz_i_UP/p0/3d'));
    Txy_i_up=h5read(fileID2,strcat(moments_1st,'/txy_i_UP/p0/3d'));
    Txz_i_up=h5read(fileID2,strcat(moments_1st,'/tzx_i_UP/p0/3d'));
    Tyz_i_up=h5read(fileID2,strcat(moments_1st,'/tyz_i_UP/p0/3d'));

    Txx_i_ba=h5read(fileID2,strcat(moments_1st,'/txx_i_BA/p0/3d'));
    Tyy_i_ba=h5read(fileID2,strcat(moments_1st,'/tyy_i_BA/p0/3d'));
    Tzz_i_ba=h5read(fileID2,strcat(moments_1st,'/tzz_i_BA/p0/3d'));
    Txy_i_ba=h5read(fileID2,strcat(moments_1st,'/txy_i_BA/p0/3d'));
    Txz_i_ba=h5read(fileID2,strcat(moments_1st,'/tzx_i_BA/p0/3d'));
    Tyz_i_ba=h5read(fileID2,strcat(moments_1st,'/tyz_i_BA/p0/3d'));

    %clearvars Txx_i_ba Txx_i_up Tyy_i_ba Tyy_i_up Tzz_i_ba Tzz_i_up
    %clearvars Txy_i_ba Txy_i_up Txz_i_ba Txz_i_up Tyz_i_ba Tyz_i_up
    %----------------------------------------------------------------------
    Pij_i_ba=cell(3,3);
    Pij_e_ba=cell(3,3);
    Pij_i_up=cell(3,3);
    Pij_e_up=cell(3,3);
    % % %----------------------------------------------------------------------
    % Make the tensor [3, 3] for the ions
    Pij_i_ba{1,1}=Txx_i_ba; Pij_i_ba{1,2}=Txy_i_ba; Pij_i_ba{1,3}=Txz_i_ba;
    Pij_i_ba{2,1}=Txy_i_ba; Pij_i_ba{2,2}=Tyy_i_ba; Pij_i_ba{2,3}=Tyz_i_ba;
    Pij_i_ba{3,1}=Txz_i_ba; Pij_i_ba{3,2}=Tyz_i_ba; Pij_i_ba{3,3}=Tzz_i_ba;
    %clearvars Txx_i_ba Txy_i_ba Txz_i_ba Tyy_i_ba Tyz_i_ba Tzz_i_ba
    % Make the tensor [3, 3] for the electrons
    Pij_e_ba{1,1}=Txx_e_ba; Pij_e_ba{1,2}=Txy_e_ba; Pij_e_ba{1,3}=Txz_e_ba;
    Pij_e_ba{2,1}=Txy_e_ba; Pij_e_ba{2,2}=Tyy_e_ba; Pij_e_ba{2,3}=Tyz_e_ba;
    Pij_e_ba{3,1}=Txz_e_ba; Pij_e_ba{3,2}=Tyz_e_ba; Pij_e_ba{3,3}=Tzz_e_ba;
    %clearvars Txx_e_ba Txy_e_ba Txz_e_ba Tyy_e_ba Tyz_e_ba Tzz_e_ba
    %----------------------------------------------------------------------
    % Make the tensor [3, 3] for the ions
    Pij_i_up{1,1}=Txx_i_up; Pij_i_up{1,2}=Txy_i_up; Pij_i_up{1,3}=Txz_i_up;
    Pij_i_up{2,1}=Txy_i_up; Pij_i_up{2,2}=Tyy_i_up; Pij_i_up{2,3}=Tyz_i_up;
    Pij_i_up{3,1}=Txz_i_up; Pij_i_up{3,2}=Tyz_i_up; Pij_i_up{3,3}=Tzz_i_up;
    %clearvars Txx_i_up Txy_i_up Txz_i_up Tyy_i_up Tyz_i_up Tzz_i_up
    % Make the tensor [3, 3] for the electrons
    Pij_e_up{1,1}=Txx_e_up; Pij_e_up{1,2}=Txy_e_up; Pij_e_up{1,3}=Txz_e_up;
    Pij_e_up{2,1}=Txy_e_up; Pij_e_up{2,2}=Tyy_e_up; Pij_e_up{2,3}=Tyz_e_up;
    Pij_e_up{3,1}=Txz_e_up; Pij_e_up{3,2}=Tyz_e_up; Pij_e_up{3,3}=Tzz_e_up;
    %clearvars Txx_e_up Txy_e_up Txz_e_up Tyy_e_up Tyz_e_up Tzz_e_up
    %----------------------------------------------------------------------

    % This is to get the central momment pressure.
    %----------------------------------------------------------------------
    % % PPij_i=cell(3,3);
    % % PPij_e=cell(3,3);
    PPij_i_ba=cell(3,3);
    PPij_e_ba=cell(3,3);
    PPij_i_up=cell(3,3);
    PPij_e_up=cell(3,3);
    for i=1:3
        for j=1:3
            if(isempty(Pij_i_ba{i,j}) == 1) % This is where if P_ba is zero, this should be changed.
                continue
            end
            % % PPij_i{i,j} = Pij_i{i,j} - n_i{1,1}.*mi.*v_i{1,i}.*v_i{1,j};
            % % PPij_e{i,j} = Pij_e{i,j} - n_e{1,1}.*me.*v_e{1,i}.*v_e{1,j};
            PPij_i_ba{i,j} = Pij_i_ba{i,j} - n_i_ba{1,1}.*mi.*v_i_ba{1,i}.*v_i_ba{1,j};
            PPij_e_ba{i,j} = Pij_e_ba{i,j} - n_e_ba{1,1}.*me.*v_e_ba{1,i}.*v_e_ba{1,j};
            PPij_i_up{i,j} = Pij_i_up{i,j} - n_i_up{1,1}.*mi.*v_i_up{1,i}.*v_i_up{1,j};
            PPij_e_up{i,j} = Pij_e_up{i,j} - n_e_up{1,1}.*me.*v_e_up{1,i}.*v_e_up{1,j};
        end
    end

    % This is just to rename the variable
    % % Pij_i = PPij_i;
    % % Pij_e = PPij_e;
    Pij_i_ba = PPij_i_ba;
    Pij_e_ba = PPij_e_ba;
    Pij_i_up = PPij_i_up;
    Pij_e_up = PPij_e_up;

%    clearvars PPij_i PPij_e  
%     clearvars PPij_e_ba PPij_e_up PPij_i_ba PPij_i_up
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    n_i = n_i{1,1}; n_i = squeeze(n_i(sli_x,:,:));
    n_e = n_e{1,1}; n_e = squeeze(n_e(sli_x,:,:));
    n_i_ba = n_i_ba{1,1}; n_i_ba = squeeze(n_i_ba(sli_x,:,:));
    n_e_ba = n_e_ba{1,1}; n_e_ba = squeeze(n_e_ba(sli_x,:,:));
    n_i_up = n_i_up{1,1}; n_i_up = squeeze(n_i_up(sli_x,:,:));
    n_e_up = n_e_up{1,1}; n_e_up = squeeze(n_e_up(sli_x,:,:));

    Pij_i_ba_xx =  Pij_i_ba{1,1}; Pij_i_ba_xx = squeeze(Pij_i_ba_xx(sli_x,:,:));
    Pij_i_ba_xy =  Pij_i_ba{1,2}; Pij_i_ba_xy = squeeze(Pij_i_ba_xy(sli_x,:,:));
    Pij_i_ba_xz =  Pij_i_ba{1,3}; Pij_i_ba_xz = squeeze(Pij_i_ba_xz(sli_x,:,:));
    Pij_i_ba_yy =  Pij_i_ba{2,2}; Pij_i_ba_yy = squeeze(Pij_i_ba_yy(sli_x,:,:));
    Pij_i_ba_yz =  Pij_i_ba{2,2}; Pij_i_ba_yz = squeeze(Pij_i_ba_yz(sli_x,:,:));    
    Pij_i_ba_zz =  Pij_i_ba{2,2}; Pij_i_ba_zz = squeeze(Pij_i_ba_zz(sli_x,:,:));    

    Pij_i_up_xx =  Pij_i_up{1,1}; Pij_i_up_xx = squeeze(Pij_i_up_xx(sli_x,:,:));
    Pij_i_up_xy =  Pij_i_up{1,2}; Pij_i_up_xy = squeeze(Pij_i_up_xy(sli_x,:,:));
    Pij_i_up_xz =  Pij_i_up{1,3}; Pij_i_up_xz = squeeze(Pij_i_up_xz(sli_x,:,:));
    Pij_i_up_yy =  Pij_i_up{2,2}; Pij_i_up_yy = squeeze(Pij_i_up_yy(sli_x,:,:));
    Pij_i_up_yz =  Pij_i_up{2,2}; Pij_i_up_yz = squeeze(Pij_i_up_yz(sli_x,:,:));    
    Pij_i_up_zz =  Pij_i_up{2,2}; Pij_i_up_zz = squeeze(Pij_i_up_zz(sli_x,:,:));

    Pij_e_ba_xx =  Pij_e_ba{1,1}; Pij_e_ba_xx = squeeze(Pij_e_ba_xx(sli_x,:,:));
    Pij_e_ba_xy =  Pij_e_ba{1,2}; Pij_e_ba_xy = squeeze(Pij_e_ba_xy(sli_x,:,:));
    Pij_e_ba_xz =  Pij_e_ba{1,3}; Pij_e_ba_xz = squeeze(Pij_e_ba_xz(sli_x,:,:));
    Pij_e_ba_yy =  Pij_e_ba{2,2}; Pij_e_ba_yy = squeeze(Pij_e_ba_yy(sli_x,:,:));
    Pij_e_ba_yz =  Pij_e_ba{2,2}; Pij_e_ba_yz = squeeze(Pij_e_ba_yz(sli_x,:,:));    
    Pij_e_ba_zz =  Pij_e_ba{2,2}; Pij_e_ba_zz = squeeze(Pij_e_ba_zz(sli_x,:,:));    

    Pij_e_up_xx =  Pij_e_up{1,1}; Pij_e_up_xx = squeeze(Pij_e_up_xx(sli_x,:,:));
    Pij_e_up_xy =  Pij_e_up{1,2}; Pij_e_up_xy = squeeze(Pij_e_up_xy(sli_x,:,:));
    Pij_e_up_xz =  Pij_e_up{1,3}; Pij_e_up_xz = squeeze(Pij_e_up_xz(sli_x,:,:));
    Pij_e_up_yy =  Pij_e_up{2,2}; Pij_e_up_yy = squeeze(Pij_e_up_yy(sli_x,:,:));
    Pij_e_up_yz =  Pij_e_up{2,2}; Pij_e_up_yz = squeeze(Pij_e_up_yz(sli_x,:,:));    
    Pij_e_up_zz =  Pij_e_up{2,2}; Pij_e_up_zz = squeeze(Pij_e_up_zz(sli_x,:,:));

    %----------------------------------------------------------------------

    % so far everything works

    %clearvars n_e_up n_i_up n_i n_e n_e_ba n_i_ba
    %clearvars n_i_up n_e_up n_i_ba n_e_ba n_i n_e

    % clearvars v_i_up v_e_up v_i_ba v_e_ba v_i v_e
    % clearvars Pij_i Pij_e 
    %clearvars Pij_e_ba Pij_e_up  Pij_i_ba Pij_i_up
    %----------------------------------------------------------------------

    % v
    %---------------------------------------------------------------------- 
    % v_x = (n_i .* v_ix + n_e .* v_ex)./(n_i+n_e);
    % v_y = (n_i .* v_iy + n_e .* v_ey)./(n_i+n_e);
    % v_z = (n_i .* v_iz + n_e .* v_ez)./(n_i+n_e);

%     v_x_ba = (n_i_ba .* v_i_bax + n_e_ba .* v_e_bax)./(n_i_ba+n_e_ba);
%     v_y_ba = (n_i_ba .* v_i_bay + n_e_ba .* v_e_bay)./(n_i_ba+n_e_ba);
%     v_z_ba = (n_i_ba .* v_i_baz + n_e_ba .* v_e_baz)./(n_i_ba+n_e_ba);
% 
%     v_x_up = (n_i_up .* v_i_upx + n_e_up .* v_e_upx)./(n_i_up+n_e_up);
%     v_y_up = (n_i_up .* v_i_upy + n_e_up .* v_e_upy)./(n_i_up+n_e_up);
%     v_z_up = (n_i_up .* v_i_upz + n_e_up .* v_e_upz)./(n_i_up+n_e_up);
    %---------------------------------------------------------------------- 

    % v
    %----------------------------------------------------------------------
    v_x = (mi .* n_i .* v_ix + me .* n_e .* v_ex)./(mi .* n_i + me .* n_e);
    v_y = (mi .* n_i .* v_iy + me .* n_e .* v_ey)./(mi .* n_i + me .* n_e);
    v_z = (mi .* n_i .* v_iz + me .* n_e .* v_ez)./(mi .* n_i + me .* n_e);

    n = (mi .* n_i + me .* n_e) / (mi + me);
    %----------------------------------------------------------------------

    %Components of the pressure
    %----------------------------------------------------------------------
    DUM = 0.*Ex;
    ssz=size(DUM);
    sli_x = 1; %floor(4+ssz(1)/2);%1;
    %sli_y = 180;%90; %floor(4+ssz(2)/2);%380;
    %sli_z = 360; %floor(2+ssz(3)/2);%700;
    sli_y = 512;%90; %floor(4+ssz(2)/2);%380;
    sli_z = 1024; %floor(2+ssz(3)/2);%700;
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------    
    sss=size(DUM);
    size_X=sss;
    zll=linspace(-Lz,Lz,size_X(2)); %Jeff flag it works with (1,size_x(2))
    yll=linspace(-Ly,Ly,size_X(1));
    [ZLL, YLL] = meshgrid(zll,yll);

    yticks_mine=[floor(-Ly*0.9) floor(-Ly/2) 0 floor(Ly/2) floor(Ly*0.9)];
    zticks_mine=[floor(-Lz*0.9) floor(-Lz/2) 0 floor(Lz/2) floor(Lz*0.9)];

    xlim_a = -4; xlim_b = 4;
    ylim_a = -4; ylim_b = 4;

    % % % These plots are to show that the pressure is being calculated
    % % %----------------------------------------------------------------------
    
    % % % properly.
    % % 
    % % % The output Txx is in reality Pxx = int fvv dv.
    % % % The transformation of vx = px c / sqrt((mc)^2 + px^2) works to remove the
    % % % relativistic values. I guess the code most handle this internally.
    % % % The step Pxx = Txx - nmvxvx is working properly as well 
    % % %----------------------------------------------------------------------
    % % lw=2; fs=18;
    % % f12=figure(12);
    % % %------------------------------------
    % % dum_1 = n_e_ba;
    % % plot(zll,dum_1(sli_y,:),'b','LineWidth',lw);
    % % hold on
    % % dum_2 = n_i_ba;
    % % plot(zll,dum_2(sli_y,:),'r','LineWidth',lw);
    % % dum_3 = n_e_up;
    % % plot(zll,dum_3(sli_y,:),'--b','LineWidth',lw);
    % % dum_4 = n_i_up;
    % % plot(zll,dum_4(sli_y,:),'--r','LineWidth',lw);    
    % % %xlim([zlim_a, zlim_b]);
    % % %ylim([-elim, elim]);
    % % xlabel('$z/d_i$','Interpreter','latex','FontSize',fs);
    % % ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    % % ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    % % legend({'$n_{e,ba}$',...
    % %     '$n_{i,ba}$',...
    % %     '$n_{e,up}$',...
    % %     '$n_{i,up}$',...
    % %     },'Interpreter','latex','FontSize',fs,...
    % %     'Location','northwest','NumColumns',2)
    % % sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
    % % hold off
    % % %----------------------------------------------------------------------
    % % 
    % % f13=figure(13);
    % % %----------------------------------------------------------------------
    % % dum_1 = squeeze(Txx_e_ba(1,:,:));
    % % plot(zll,dum_1(sli_y,:),'b','LineWidth',lw);
    % % hold on
    % % dum_2 = squeeze(Txx_i_ba(1,:,:));
    % % plot(zll,dum_2(sli_y,:),'r','LineWidth',lw);
    % % dum_3 = squeeze(Txx_e_up(1,:,:));
    % % plot(zll,dum_3(sli_y,:),'--b','LineWidth',lw);
    % % dum_4 = squeeze(Txx_i_up(1,:,:));
    % % plot(zll,dum_4(sli_y,:),'--r','LineWidth',lw);    
    % % %xlim([zlim_a, zlim_b]);
    % % %ylim([-elim, elim]);
    % % xlabel('$z/d_i$','Interpreter','latex','FontSize',fs);
    % % ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    % % ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    % % legend({'$T_{xx,e,ba}$',...
    % %     '$T_{xx,i,ba}$',...
    % %     '$T_{xx,e,up}$',...
    % %     '$T_{xx,i,up}$',...
    % %     },'Interpreter','latex','FontSize',fs,...
    % %     'Location','northwest','NumColumns',2)
    % % sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
    % % hold off
    % % %----------------------------------------------------------------------
    % % 
    % % f14=figure(14);
    % % %----------------------------------------------------------------------
    % % dum_1 = Pij_e_ba{1,1}; dum_1=squeeze(dum_1(1,:,:));
    % % plot(zll,dum_1(sli_y,:),'b','LineWidth',lw);
    % % hold on
    % % dum_2 = Pij_i_ba{1,1}; dum_2=squeeze(dum_2(1,:,:));
    % % plot(zll,dum_2(sli_y,:),'r','LineWidth',lw);
    % % dum_3 = Pij_e_up{1,1}; dum_3=squeeze(dum_3(1,:,:));
    % % plot(zll,dum_3(sli_y,:),'--b','LineWidth',lw);
    % % dum_4 = Pij_i_up{1,1}; dum_4=squeeze(dum_4(1,:,:));
    % % plot(zll,dum_4(sli_y,:),'--r','LineWidth',lw);    
    % % %xlim([zlim_a, zlim_b]);
    % % %ylim([-elim, elim]);
    % % xlabel('$z/d_i$','Interpreter','latex','FontSize',fs);
    % % ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    % % ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    % % legend({'$P_{xx,e,ba}$',...
    % %     '$P_{xx,i,ba}$',...
    % %     '$P_{xx,e,up}$',...
    % %     '$P_{xx,i,up}$',...
    % %     },'Interpreter','latex','FontSize',fs,...
    % %     'Location','northwest','NumColumns',2)
    % % sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
    % % hold off
    % % %----------------------------------------------------------------------
    % % 
    % % f15=figure(15);
    % % %----------------------------------------------------------------------
    % % dum_1 = v_e_ba{1,1}; dum_1=squeeze(dum_1(1,:,:));
    % % plot(zll,dum_1(sli_y,:),'b','LineWidth',lw);
    % % hold on
    % % dum_2 = v_i_ba{1,1}; dum_2=squeeze(dum_2(1,:,:));
    % % plot(zll,dum_2(sli_y,:),'r','LineWidth',lw);
    % % dum_3 = v_e_up{1,1}; dum_3=squeeze(dum_3(1,:,:));
    % % plot(zll,dum_3(sli_y,:),'--b','LineWidth',lw);
    % % dum_4 = v_i_up{1,1}; dum_4=squeeze(dum_4(1,:,:));
    % % plot(zll,dum_4(sli_y,:),'--r','LineWidth',lw);    
    % % %xlim([zlim_a, zlim_b]);
    % % %ylim([-elim, elim]);
    % % xlabel('$z/d_i$','Interpreter','latex','FontSize',fs);
    % % ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    % % ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    % % legend({'$v_{x,e,ba}$',...
    % %     '$v_{x,i,ba}$',...
    % %     '$v_{x,e,up}$',...
    % %     '$v_{x,i,up}$',...
    % %     },'Interpreter','latex','FontSize',fs,...
    % %     'Location','northwest','NumColumns',2)
    % % sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
    % % hold off
    % % %----------------------------------------------------------------------
    % % %----------------------------------------------------------------------

    % Save the data for the time average
    %----------------------------------------------------------------------
    inn=jjn;

    E_in{1,inn} = Ex;
    E_in{2,inn} = Ey;
    E_in{3,inn} = Ez;

    B_in{1,inn} = Bx;
    B_in{2,inn} = By;
    B_in{3,inn} = Bz;

    J_in{1,inn} = Jx;
    J_in{2,inn} = Jy;
    J_in{3,inn} = Jz;

    n_in{1,inn} = n_e;
    n_in{2,inn} = n_i;

    v_i_in{1,inn} = v_ix;
    v_i_in{2,inn} = v_iy;
    v_i_in{3,inn} = v_iz;

    v_e_in{1,inn} = v_ex;
    v_e_in{2,inn} = v_ey;
    v_e_in{3,inn} = v_ez;

    Pij_i_in{1,inn} = Pij_i_ba_xx + Pij_i_up_xx;
    Pij_i_in{2,inn} = Pij_i_ba_xy + Pij_i_up_xy;
    Pij_i_in{3,inn} = Pij_i_ba_xz + Pij_i_up_xz;
    Pij_i_in{4,inn} = Pij_i_ba_yy + Pij_i_up_yy;
    Pij_i_in{5,inn} = Pij_i_ba_yz + Pij_i_up_yz;
    Pij_i_in{6,inn} = Pij_i_ba_zz + Pij_i_up_zz;

    Pij_e_in{1,inn} = Pij_e_ba_xx + Pij_e_up_xx;
    Pij_e_in{2,inn} = Pij_e_ba_xy + Pij_e_up_xy;
    Pij_e_in{3,inn} = Pij_e_ba_xz + Pij_e_up_xz;
    Pij_e_in{4,inn} = Pij_e_ba_yy + Pij_e_up_yy;
    Pij_e_in{5,inn} = Pij_e_ba_yz + Pij_e_up_yz;
    Pij_e_in{6,inn} = Pij_e_ba_zz + Pij_e_up_zz;

    % The composed quiantities
    %----------------------------------------------------------------------
    v_in{1,inn} = v_x;
    v_in{2,inn} = v_y;
    v_in{3,inn} = v_z;

    n_in{3,inn} = n;

    n_i_vi_in{1,inn} = n_i.*v_ix;
    n_i_vi_in{2,inn} = n_i.*v_iy;
    n_i_vi_in{3,inn} = n_i.*v_iz;

    n_e_ve_in{1,inn} = n_e.*v_ex;
    n_e_ve_in{2,inn} = n_e.*v_ey;
    n_e_ve_in{3,inn} = n_e.*v_ez;

    n_v_in{1,inn} = n.*v_x;
    n_v_in{2,inn} = n.*v_y;
    n_v_in{3,inn} = n.*v_z;
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    clearvars Ex Ey Ez Bx By Bz Jx Jy Jz n_i n_e n_i_up n_i_ba n_e_up n_e_ba
    clearvars v_ix v_iy v_iz v_ex v_ey v_ez v_x v_y v_z
    clearvars Pij_e_xx Pij_e_xy Pij_e_xz Pij_e_yy Pij_e_yz Pij_e_zz
    clearvars Pij_i_xx Pij_i_xy Pij_i_xz Pij_i_yy Pij_i_yz Pij_i_zz
    %----------------------------------------------------------------------

end


%--------------------------------------------------------------------------
%Consolidate the averages in time
%----------------------------------------------------------------------
DUM = 0.*E_in{1,1};

[Ex_avgt_i, Ey_avgt_i, Ez_avgt_i,...
    Bx_avgt_i, By_avgt_i, Bz_avgt_i,...
    Jx_avgt_i, Jy_avgt_i, Jz_avgt_i] = deal(DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM);

[n_e_avgt_i, n_i_avgt_i, n_avgt_i] = deal(DUM,DUM,DUM);

[v_ix_avgt_i, v_iy_avgt_i, v_iz_avgt_i,...
    v_ex_avgt_i, v_ey_avgt_i, v_ez_avgt_i,...
    v_x_avgt_i, v_y_avgt_i, v_z_avgt_i] = deal(DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM);

[Pij_i_xx_avgt_i, Pij_i_xy_avgt_i, Pij_i_xz_avgt_i,...
    Pij_i_yy_avgt_i, Pij_i_yz_avgt_i, Pij_i_zz_avgt_i] = deal(DUM,DUM,DUM,DUM,DUM,DUM);

[Pij_e_xx_avgt_i, Pij_e_xy_avgt_i, Pij_e_xz_avgt_i,...
    Pij_e_yy_avgt_i, Pij_e_yz_avgt_i, Pij_e_zz_avgt_i] = deal(DUM,DUM,DUM,DUM,DUM,DUM);

[n_i_vix_avgt_i, n_i_viy_avgt_i, n_i_viz_avgt_i,...
    n_e_vex_avgt_i, n_e_vey_avgt_i, n_e_vez_avgt_i,...
    n_vx_avgt_i, n_vy_avgt_i, n_vz_avgt_i] = deal(DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM);

% [vixBx_avgt_i,cvixBy_avgt_i, vixBz_avgt_i,...
%     vexBx_avgt_i, vexBy_avgt_i, vexBz_avgt_i,...
%     vxBx_avgt_i, vxBy_avgt_i, vxBz_avgt_i] = deal(DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
nu_av=1;
%nu_av=N; % this is for the average
%nu_av=3; % this is for the average
%----------------------------------------------------------------------

%----------------------------------------------------------------------
for ii=1:N
    Ex_avgt_o = Ex_avgt_i + E_in{1,ii}; Ex_avgt_i = Ex_avgt_o;
    Ey_avgt_o = Ey_avgt_i + E_in{2,ii}; Ey_avgt_i = Ey_avgt_o;
    Ez_avgt_o = Ez_avgt_i + E_in{3,ii}; Ez_avgt_i = Ez_avgt_o;

    Bx_avgt_o = Bx_avgt_i + B_in{1,ii}; Bx_avgt_i = Bx_avgt_o;
    By_avgt_o = By_avgt_i + B_in{2,ii}; By_avgt_i = By_avgt_o;
    Bz_avgt_o = Bz_avgt_i + B_in{3,ii}; Bz_avgt_i = Bz_avgt_o;

    Jx_avgt_o = Jx_avgt_i + J_in{1,ii}; Jx_avgt_i = Jx_avgt_o;
    Jy_avgt_o = Jy_avgt_i + J_in{2,ii}; Jy_avgt_i = Jy_avgt_o;
    Jz_avgt_o = Jz_avgt_i + J_in{3,ii}; Jz_avgt_i = Jz_avgt_o;

    n_e_avgt_o = n_e_avgt_i + n_in{1,ii}; n_e_avgt_i = n_e_avgt_o;
    n_i_avgt_o = n_i_avgt_i + n_in{2,ii} ; n_i_avgt_i = n_i_avgt_o;

    v_ix_avgt_o = v_i_in{1,ii} + v_ix_avgt_i ; v_ix_avgt_i = v_ix_avgt_o;
    v_iy_avgt_o = v_i_in{2,ii} + v_iy_avgt_i ; v_iy_avgt_i = v_iy_avgt_o;
    v_iz_avgt_o = v_i_in{3,ii} + v_iz_avgt_i ; v_iz_avgt_i = v_iz_avgt_o;

    v_ex_avgt_o = v_e_in{1,ii} + v_ex_avgt_i ; v_ex_avgt_i = v_ex_avgt_o;
    v_ey_avgt_o = v_e_in{2,ii} + v_ey_avgt_i ; v_ey_avgt_i = v_ey_avgt_o;
    v_ez_avgt_o = v_e_in{3,ii} + v_ez_avgt_i ; v_ez_avgt_i = v_ez_avgt_o;

    v_x_avgt_o = v_in{1,ii} + v_x_avgt_i ; v_x_avgt_i = v_x_avgt_o;
    v_y_avgt_o = v_in{2,ii} + v_y_avgt_i ; v_y_avgt_i = v_y_avgt_o;
    v_z_avgt_o = v_in{3,ii} + v_z_avgt_i ; v_z_avgt_i = v_z_avgt_o;

    Pij_i_xx_avgt_o = Pij_i_in{1,ii} + Pij_i_xx_avgt_i ; Pij_i_xx_avgt_i = Pij_i_xx_avgt_o;
    Pij_i_xy_avgt_o = Pij_i_in{2,ii} + Pij_i_xy_avgt_i ; Pij_i_xy_avgt_i = Pij_i_xy_avgt_o;
    Pij_i_xz_avgt_o = Pij_i_in{3,ii} + Pij_i_xz_avgt_i ; Pij_i_xz_avgt_i = Pij_i_xz_avgt_o;
    Pij_i_yy_avgt_o = Pij_i_in{4,ii} + Pij_i_yy_avgt_i ; Pij_i_yy_avgt_i = Pij_i_yy_avgt_o;
    Pij_i_yz_avgt_o = Pij_i_in{5,ii} + Pij_i_yz_avgt_i ; Pij_i_yz_avgt_i = Pij_i_yz_avgt_o;
    Pij_i_zz_avgt_o = Pij_i_in{6,ii} + Pij_i_zz_avgt_i ; Pij_i_zz_avgt_i = Pij_i_zz_avgt_o;

    Pij_e_xx_avgt_o = Pij_e_in{1,ii} + Pij_e_xx_avgt_i ; Pij_e_xx_avgt_i = Pij_e_xx_avgt_o;
    Pij_e_xy_avgt_o = Pij_e_in{2,ii} + Pij_e_xy_avgt_i ; Pij_e_xy_avgt_i = Pij_e_xy_avgt_o;
    Pij_e_xz_avgt_o = Pij_e_in{3,ii} + Pij_e_xz_avgt_i ; Pij_e_xz_avgt_i = Pij_e_xz_avgt_o;
    Pij_e_yy_avgt_o = Pij_e_in{4,ii} + Pij_e_yy_avgt_i ; Pij_e_yy_avgt_i = Pij_e_yy_avgt_o;
    Pij_e_yz_avgt_o = Pij_e_in{5,ii} + Pij_e_yz_avgt_i ; Pij_e_yz_avgt_i = Pij_e_yz_avgt_o;
    Pij_e_zz_avgt_o = Pij_e_in{6,ii} + Pij_e_zz_avgt_i ; Pij_e_zz_avgt_i = Pij_e_zz_avgt_o;

    n_avgt_o = n_avgt_i + n_in{3,ii}; n_avgt_i = n_avgt_o;

    n_i_vix_avgt_o = n_i_vi_in{1,ii} + n_i_vix_avgt_i ; n_i_vix_avgt_i = n_i_vix_avgt_o;
    n_i_viy_avgt_o = n_i_vi_in{2,ii} + n_i_viy_avgt_i ; n_i_viy_avgt_i = n_i_viy_avgt_o;
    n_i_viz_avgt_o = n_i_vi_in{3,ii} + n_i_viz_avgt_i ; n_i_viz_avgt_i = n_i_viz_avgt_o;

    n_e_vex_avgt_o = n_e_ve_in{1,ii} + n_e_vex_avgt_i ; n_e_vex_avgt_i = n_e_vex_avgt_o;
    n_e_vey_avgt_o = n_e_ve_in{2,ii} + n_e_vey_avgt_i ; n_e_vey_avgt_i = n_e_vey_avgt_o;
    n_e_vez_avgt_o = n_e_ve_in{3,ii} + n_e_vez_avgt_i ; n_e_vez_avgt_i = n_e_vez_avgt_o;

    n_vx_avgt_o = n_v_in{1,ii} + n_vx_avgt_i ; n_vx_avgt_i = n_vx_avgt_o;
    n_vy_avgt_o = n_v_in{2,ii} + n_vy_avgt_i ; n_vy_avgt_i = n_vy_avgt_o;
    n_vz_avgt_o = n_v_in{3,ii} + n_vz_avgt_i ; n_vz_avgt_i = n_vz_avgt_o;

end

clearvars *_o

% saving only the averages.
%----------------------------------------------------------------------
Ex_avgt_i = Ex_avgt_i./nu_av;
Ey_avgt_i = Ey_avgt_i./nu_av;
Ez_avgt_i = Ez_avgt_i./nu_av;

Bx_avgt_i = Bx_avgt_i./nu_av;
By_avgt_i = By_avgt_i./nu_av;
Bz_avgt_i = Bz_avgt_i./nu_av;

Jx_avgt_i = Jx_avgt_i./nu_av;
Jy_avgt_i = Jy_avgt_i./nu_av;
Jz_avgt_i = Jz_avgt_i./nu_av;

n_e_avgt_i = n_e_avgt_i./nu_av;
n_i_avgt_i = n_i_avgt_i./nu_av;

v_ix_avgt_i = v_ix_avgt_i./nu_av;
v_iy_avgt_i = v_iy_avgt_i./nu_av;
v_iz_avgt_i = v_iz_avgt_i./nu_av;

v_ex_avgt_i = v_ex_avgt_i./nu_av;
v_ey_avgt_i = v_ey_avgt_i./nu_av;
v_ez_avgt_i = v_ez_avgt_i./nu_av;

v_x_avgt_i = v_x_avgt_i./nu_av;
v_y_avgt_i = v_y_avgt_i./nu_av;
v_z_avgt_i = v_z_avgt_i./nu_av;

Pij_i_xx_avgt_i = Pij_i_xx_avgt_i./nu_av;
Pij_i_xy_avgt_i = Pij_i_xy_avgt_i./nu_av;
Pij_i_xz_avgt_i = Pij_i_xz_avgt_i./nu_av;
Pij_i_yy_avgt_i = Pij_i_yy_avgt_i./nu_av;
Pij_i_yz_avgt_i = Pij_i_yz_avgt_i./nu_av;
Pij_i_zz_avgt_i = Pij_i_zz_avgt_i./nu_av;

Pij_e_xx_avgt_i = Pij_e_xx_avgt_i./nu_av;
Pij_e_xy_avgt_i = Pij_e_xy_avgt_i./nu_av;
Pij_e_xz_avgt_i = Pij_e_xz_avgt_i./nu_av;
Pij_e_yy_avgt_i = Pij_e_yy_avgt_i./nu_av;
Pij_e_yz_avgt_i = Pij_e_yz_avgt_i./nu_av;
Pij_e_zz_avgt_i = Pij_e_zz_avgt_i./nu_av;

n_avgt_i = n_avgt_i./nu_av;

n_i_vix_avgt_i = n_i_vix_avgt_i./nu_av;
n_i_viy_avgt_i = n_i_viy_avgt_i./nu_av;
n_i_viz_avgt_i = n_i_viz_avgt_i./nu_av;

n_e_vex_avgt_i = n_e_vex_avgt_i./nu_av;
n_e_vey_avgt_i = n_e_vey_avgt_i./nu_av;
n_e_vez_avgt_i = n_e_vez_avgt_i./nu_av;

n_vx_avgt_i = n_vx_avgt_i./nu_av;
n_vy_avgt_i = n_vy_avgt_i./nu_av;
n_vz_avgt_i = n_vz_avgt_i./nu_av;
%--------------------------------------------------------------------------

% for the averages
%--------------------------------------------------------------------------
p_e_s = (Pij_e_xx_avgt_i + Pij_e_yy_avgt_i + Pij_e_zz_avgt_i)/3; 
%p_e_s = p_e_s/1;
p_i_s = (Pij_i_xx_avgt_i + Pij_i_yy_avgt_i + Pij_i_zz_avgt_i)/3;
%p_i_s = p_i_s/1;
p_m = 0.5 .*(Bx_avgt_i.^2 + By_avgt_i.^2 + Bz_avgt_i.^2 );
%p_m = p_m;
Pt = p_m + p_i_s + p_e_s;
%--------------------------------------------------------------------------

% % for a single file
% %--------------------------------------------------------------------------
% p_e_s = (Pij_e_xx + Pij_e_yy + Pij_e_zz)/3; 
% p_e_s = p_e_s/1;
% p_i_s = (Pij_i_xx + Pij_i_yy + Pij_i_zz)/3;
% p_i_s = p_i_s/1;
% p_m = 0.5 .*(Bx.^2 + By.^2 + Bz.^2 );
% %p_m = p_m;
% Pt = p_m + p_i_s + p_e_s;
% %--------------------------------------------------------------------------


%--------------------------------------------------------------------------
sss=size(DUM);
size_X=sss;
zll=linspace(-Lz,Lz,size_X(2)); %Jeff flag it works with (1,size_x(2))
yll=linspace(-Ly,Ly,size_X(1));
[ZLL, YLL] = meshgrid(zll,yll);

yticks_mine=[floor(-Ly*0.9) floor(-Ly/2) 0 floor(Ly/2) floor(Ly*0.9)];
zticks_mine=[floor(-Lz*0.9) floor(-Lz/2) 0 floor(Lz/2) floor(Lz*0.9)];

%sli_x = 1; %floor(4+ssz(1)/2);%1;
%sli_y = 90; %floor(4+ssz(2)/2);%380;
%sli_z = 360; %floor(2+ssz(3)/2);%700;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
[Bx_avgt_i_z,Bx_avgt_i_y] = gradient(Bx_avgt_i);
[By_avgt_i_z,By_avgt_i_y] = gradient(By_avgt_i);
[Bz_avgt_i_z,Bz_avgt_i_y] = gradient(Bz_avgt_i);

Bx_avgt_i_z = Bx_avgt_i_z/(2.*resz);   Bx_avgt_i_y = Bx_avgt_i_y/(2.*resy);
By_avgt_i_z = By_avgt_i_z/(2.*resz);   By_avgt_i_y = By_avgt_i_y/(2.*resy);
Bz_avgt_i_z = Bz_avgt_i_z/(2.*resz);   Bz_avgt_i_y = Bz_avgt_i_y/(2.*resy);

By_a_z = diff(By_avgt_i,1,2);
Bz_a_y = diff(Bz_avgt_i,1,1);
%Jx_hand2 = Bz_a_y - By_a_z ;

Jx_hand = Bz_avgt_i_y - By_avgt_i_z;
Jy_hand = Bx_avgt_i_z;
Jz_hand =  - Bx_avgt_i_y;

divB = By_avgt_i_y + Bz_avgt_i_z;

f29 = figure(29);
%dump=Bz_avgt_i;
dump=Jx_avgt_i;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
hold off

f30 = figure(30);
plot(yll,divB(:,sli_z),'b')
%plot(yll,Bz_avgt_i_z(:,sli_z),'b')
legend('divB')
hold off


f33 = figure(33);
dum = J_ba{1,1} + J_up{1,1};
dum = squeeze(dum(1,:,:));
plot(yll,dum(:,sli_z),'b')
hold on
plot(yll,Jx_hand(:,sli_z)/(1),'r')
legend('jx','jxhand')
hold off

% There is a problem with the normalization. What is that normalization? 
f31 = figure(31);
plot(yll,Jx_avgt_i(:,sli_z)/max(Jx_avgt_i(:,sli_z)),'b')
hold on
plot(yll,Jx_hand(:,sli_z)/max(Jx_hand(:,sli_z)),'r')
legend('jx','jxhand')
hold off

f33 = figure(33);
plot(yll,Jx_avgt_i(:,sli_z),'b')
hold on
plot(yll,Jx_hand(:,sli_z)/(2),'r')
legend('jx','jxhand')
hold off

f33 = figure(33);
plot(zll,Jx_avgt_i(sli_y,:),'b')
hold on
plot(zll,Jx_hand(sli_y,:)/(1),'r')
legend('jx','jxhand')
hold off
%--------------------------------------------------------------------------


% % here is where I chose the values for the 1D cuts
% %----------------------------------------------------------------------
% ssz=size(B{1,1});
% sli_x = 1; %floor(4+ssz(1)/2);%1;
% sli_y = 512; %floor(4+ssz(2)/2);%380;
% sli_z = 1024; %floor(2+ssz(3)/2);%700;
% %----------------------------------------------------------------------
% 
% % xlim_a = zll(704); xlim_b = zll(1104);
% % ylim_a = yll(454); ylim_b = yll(571);
% 
% 
% % here is where I chose the values for the 1D cuts
% %----------------------------------------------------------------------
%DUM = 0.*E_in{1,1};
ssz=size(DUM);
%sli_x = 1; %floor(4+ssz(1)/2);%1;
%sli_y = 90; %floor(4+ssz(2)/2);%380;
%sli_z = 180; %floor(2+ssz(3)/2);%700;
%----------------------------------------------------------------------
xlim_a = zll(160); xlim_b = zll(200);
ylim_a = yll(20); ylim_b = yll(160);

xlim_a = -4; xlim_b = 4;
ylim_a = -4; ylim_b = 4;
%-------------------------
lw=2;
%-------------------------
%-------------------------
elim=0.3;
jlim0 = -0.1;
jlim1 = 0.1;
%-------------------------
fs=18;
%--------------------------------------------------------------------------
x0=45;y0=54;xx1=810;yy1=710;

% % for the last ouput (single) 
% %--------------------------------------------------------------------------
% p_e_s_2 = (Pij_e_ba_xx + Pij_e_ba_yy + Pij_e_ba_zz)/3 + (Pij_e_up_xx + Pij_e_up_yy + Pij_e_up_zz)/3; 
% p_i_s_2 = (Pij_i_ba_xx + Pij_i_ba_yy + Pij_i_ba_zz)/3 + (Pij_i_up_xx + Pij_i_up_yy + Pij_i_up_zz)/3; 
% %p_i_s = p_i_s/1;
% p_m = 0.5 .*(Bx_avgt_i.^2 + By_avgt_i.^2 + Bz_avgt_i.^2 );
% %p_m = p_m;
% Pt = p_m + p_i_s + p_e_s;
% %--------------------------------------------------------------------------


f1=figure(1);
%set(gcf,'Visible', 'off');
set(gcf,'position',[x0,y0,xx1,yy1])
%------------------------------------
dum_1 = p_e_s;
plot(yll,dum_1(:,sli_z),'b','LineWidth',lw);
hold on
dum_2 = p_i_s;
plot(yll,dum_2(:,sli_z),'r','LineWidth',lw);
dum_3 = p_m ;
plot(yll,dum_3(:,sli_z),'m','LineWidth',lw);
dum_4 = Pt;
plot(yll,dum_4(:,sli_z),'k','LineWidth',lw);
%xlim([ylim_a, ylim_b]);
%ylim([-0.01, 0.05]);
xlabel('$y/d_i$','Interpreter','latex','FontSize',fs);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
legend({'$p_{e}$',...
    '$p_{i}$',...
    '$p_{m}$',...
    '$p_{T}$',...
     },'Interpreter','latex','FontSize',fs,...
    'Location','northwest','NumColumns',2)
sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
hold off
%--------------------------------------------------------------------------


% Components of the pressure
f2=figure(2);
%set(gcf,'Visible', 'off');
set(gcf,'position',[x0,y0,xx1,yy1])
%------------------------------------
dum_1 = Pij_e_xx_avgt_i;
plot(yll,dum_1(:,sli_z),'b','LineWidth',lw);
hold on
dum_2 = Pij_e_yy_avgt_i;
plot(yll,dum_2(:,sli_z),'r','LineWidth',lw);
dum_3 = Pij_e_zz_avgt_i;
plot(yll,dum_3(:,sli_z),'m','LineWidth',lw);
dum_4 = Pij_e_xy_avgt_i;
plot(yll,dum_4(:,sli_z),'--k','LineWidth',lw);
dum_5 = Pij_e_xz_avgt_i;
plot(yll,dum_5(:,sli_z),'--c','LineWidth',lw);
dum_6 = Pij_e_yz_avgt_i;
plot(yll,dum_6(:,sli_z),'--g','LineWidth',lw);
%xlim([ylim_a, ylim_b]);
ylim([-0.01, 0.05]);
xlabel('$y/d_i$','Interpreter','latex','FontSize',fs);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
legend({'$P_{e,xx}$',...
    '$P_{e,yy}$',...
    '$P_{e,zz}$',...
    '$P_{e,xy}$',...
    '$P_{e,xz}$',...
    '$P_{e,yz}$',...
     },'Interpreter','latex','FontSize',fs,...
    'Location','northwest','NumColumns',2)
sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
hold off
%--------------------------------------------------------------------------

% Components of the pressure
%--------------------------------------------------------------------------
f3=figure(3);
%set(gcf,'Visible', 'off');
set(gcf,'position',[x0,y0,xx1,yy1])
%------------------------------------
dum_1 = Pij_i_xx_avgt_i;
plot(yll,dum_1(:,sli_z),'b','LineWidth',lw);
hold on
dum_2 = Pij_i_yy_avgt_i;
plot(yll,dum_2(:,sli_z),'r','LineWidth',lw);
dum_3 = Pij_i_zz_avgt_i;
plot(yll,dum_3(:,sli_z),'m','LineWidth',lw);
dum_4 = Pij_i_xy_avgt_i;
plot(yll,dum_4(:,sli_z),'--k','LineWidth',lw);
dum_5 = Pij_i_xz_avgt_i;
plot(yll,dum_5(:,sli_z),'--c','LineWidth',lw);
dum_6 = Pij_i_yz_avgt_i;
plot(yll,dum_6(:,sli_z),'--g','LineWidth',lw);
%xlim([ylim_a, ylim_b]);
ylim([-0.01, 0.05]);
xlabel('$y/d_i$','Interpreter','latex','FontSize',fs);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
legend({'$P_{i,xx}$',...
    '$P_{i,yy}$',...
    '$P_{i,zz}$',...
    '$P_{i,xy}$',...
    '$P_{i,xz}$',...
    '$P_{i,yz}$',...
     },'Interpreter','latex','FontSize',fs,...
    'Location','northwest','NumColumns',2)
sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
hold off
%--------------------------------------------------------------------------


% Components of the pressure
f4=figure(4);
%set(gcf,'Visible', 'off');
set(gcf,'position',[x0,y0,xx1,yy1])
%------------------------------------
dum_1 = Pij_e_ba_xx;
plot(yll,dum_1(:,sli_z),'b','LineWidth',lw);
hold on
dum_2 = Pij_e_ba_yy;
plot(yll,dum_2(:,sli_z),'r','LineWidth',lw);
dum_3 = Pij_e_ba_zz;
plot(yll,dum_3(:,sli_z),'m','LineWidth',lw);
dum_4 = Pij_e_ba_xy;
plot(yll,dum_4(:,sli_z),'--k','LineWidth',lw);
dum_5 = Pij_e_ba_xz;
plot(yll,dum_5(:,sli_z),'--c','LineWidth',lw);
dum_6 = Pij_e_ba_yz;
plot(yll,dum_6(:,sli_z),'--g','LineWidth',lw);
%xlim([ylim_a, ylim_b]);
ylim([-0.01, 0.05]);
xlabel('$y/d_i$','Interpreter','latex','FontSize',fs);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
legend({'$P_{eba,xx}$',...
    '$P_{eba,yy}$',...
    '$P_{eba,zz}$',...
    '$P_{eba,xy}$',...
    '$P_{eba,xz}$',...
    '$P_{eba,yz}$',...
     },'Interpreter','latex','FontSize',fs,...
    'Location','northwest','NumColumns',2)
sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
hold off
%--------------------------------------------------------------------------


% Components of the pressure
%--------------------------------------------------------------------------
f5=figure(5);
%set(gcf,'Visible', 'off');
set(gcf,'position',[x0,y0,xx1,yy1])
%------------------------------------
dum_1 = Pij_i_ba_xx;
plot(yll,dum_1(:,sli_z),'b','LineWidth',lw);
hold on
dum_2 = Pij_i_ba_yy;
plot(yll,dum_2(:,sli_z),'r','LineWidth',lw);
dum_3 = Pij_i_ba_zz;
plot(yll,dum_3(:,sli_z),'m','LineWidth',lw);
dum_4 = Pij_i_ba_xy;
plot(yll,dum_4(:,sli_z),'--k','LineWidth',lw);
dum_5 = Pij_i_ba_xz;
plot(yll,dum_5(:,sli_z),'--c','LineWidth',lw);
dum_6 = Pij_i_ba_yz;
plot(yll,dum_6(:,sli_z),'--g','LineWidth',lw);
%xlim([ylim_a, ylim_b]);
ylim([-0.01, 0.05]);
xlabel('$y/d_i$','Interpreter','latex','FontSize',fs);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
legend({'$P_{iba,xx}$',...
    '$P_{iba,yy}$',...
    '$P_{iba,zz}$',...
    '$P_{iba,xy}$',...
    '$P_{iba,xz}$',...
    '$P_{iba,yz}$',...
     },'Interpreter','latex','FontSize',fs,...
    'Location','northwest','NumColumns',2)
sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
hold off
%--------------------------------------------------------------------------


% Components of the pressure
f6=figure(6);
%set(gcf,'Visible', 'off');
set(gcf,'position',[x0,y0,xx1,yy1])
%------------------------------------
dum_1 = Pij_e_up_xx;
plot(yll,dum_1(:,sli_z),'b','LineWidth',lw);
hold on
dum_2 = Pij_e_up_yy;
plot(yll,dum_2(:,sli_z),'r','LineWidth',lw);
dum_3 = Pij_e_up_zz;
plot(yll,dum_3(:,sli_z),'m','LineWidth',lw);
dum_4 = Pij_e_up_xy;
plot(yll,dum_4(:,sli_z),'--k','LineWidth',lw);
dum_5 = Pij_e_up_xz;
plot(yll,dum_5(:,sli_z),'--c','LineWidth',lw);
dum_6 = Pij_e_up_yz;
plot(yll,dum_6(:,sli_z),'--g','LineWidth',lw);
%xlim([ylim_a, ylim_b]);
ylim([-0.01, 0.05]);
xlabel('$y/d_i$','Interpreter','latex','FontSize',fs);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
legend({'$P_{eup,xx}$',...
    '$P_{eup,yy}$',...
    '$P_{eup,zz}$',...
    '$P_{eup,xy}$',...
    '$P_{eup,xz}$',...
    '$P_{eup,yz}$',...
     },'Interpreter','latex','FontSize',fs,...
    'Location','northwest','NumColumns',2)
sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
hold off
%--------------------------------------------------------------------------


% Components of the pressure
%--------------------------------------------------------------------------
f7=figure(7);
%set(gcf,'Visible', 'off');
set(gcf,'position',[x0,y0,xx1,yy1])
%------------------------------------
dum_1 = Pij_i_up_xx;
plot(yll,dum_1(:,sli_z),'b','LineWidth',lw);
hold on
dum_2 = Pij_i_up_yy;
plot(yll,dum_2(:,sli_z),'r','LineWidth',lw);
dum_3 = Pij_i_up_zz;
plot(yll,dum_3(:,sli_z),'m','LineWidth',lw);
dum_4 = Pij_i_up_xy;
plot(yll,dum_4(:,sli_z),'--k','LineWidth',lw);
dum_5 = Pij_i_up_xz;
plot(yll,dum_5(:,sli_z),'--c','LineWidth',lw);
dum_6 = Pij_i_up_yz;
plot(yll,dum_6(:,sli_z),'--g','LineWidth',lw);
%xlim([ylim_a, ylim_b]);
ylim([-0.01, 0.05]);
xlabel('$y/d_i$','Interpreter','latex','FontSize',fs);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
legend({'$P_{iup,xx}$',...
    '$P_{iup,yy}$',...
    '$P_{iup,zz}$',...
    '$P_{iup,xy}$',...
    '$P_{iup,xz}$',...
    '$P_{iup,yz}$',...
     },'Interpreter','latex','FontSize',fs,...
    'Location','northwest','NumColumns',2)
sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
hold off
%--------------------------------------------------------------------------





% % % This is to show that the gradients are correct! <----
% % %------------------------------------------------------------------------
% % alf=1;
% % resy0=alf*resy;
% % f1=figure(1)
% % subplot(1,4,1)
% % dump = sin(alf.*YLL);
% % hc=pcolor(ZLL,YLL,dump);
% % hold on
% % set(hc,'edgecolor','none')
% % colorbar; title('sin'); %xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
% % xlabel('z/d_i'); ylabel('y/d_i');
% % xline(zll(sli_z),'--k','LineWidth',lw);
% % caxis([-0.8 0.8]);
% % hold off
% % subplot(1,4,2)
% % dump = cos(alf.*YLL);
% % hc=pcolor(ZLL,YLL,dump);
% % hold on
% % set(hc,'edgecolor','none')
% % colorbar; title('cos_t'); %xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
% % xlabel('z/d_i'); ylabel('y/d_i');
% % xline(zll(sli_z),'--k','LineWidth',lw);
% % caxis([-0.8 0.8]);
% % hold off
% % [coss_z, coss_y] = gradient(sin(alf.*YLL));
% % subplot(1,4,3)
% % dump = 1.*coss_y./(2*resy0);
% % hc=pcolor(ZLL,YLL,dump);
% % hold on
% % set(hc,'edgecolor','none')
% % colorbar; title('cos_co'); %xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
% % xlabel('z/d_i'); ylabel('y/d_i');
% % xline(zll(sli_z),'--k','LineWidth',lw);
% % caxis([-0.8 0.8]);
% % hold off
% % subplot(1,4,4)
% % dump = (cos(alf.*YLL)./(1.*coss_y/(2*resy0)));
% % %dump = (cos(0.1*YLL)-cos(0.1*YLL));
% % %dump2 = dump.*(dump==0);
% % hc=pcolor(ZLL,YLL,dump);
% % hold on
% % set(hc,'edgecolor','none')
% % colorbar; title('cost/coshand'); %xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
% % xlabel('z/d_i'); ylabel('y/d_i');
% % xline(zll(sli_z),'--k','LineWidth',lw);
% % %caxis([-0.8 0.8]);
% % hold off
% % %------------------------------------------------------------------------
% % 
% % 
% % 
% % 
% % 
% % % % In this plot I still need to include the time derivative.
% % % sli_y = 512; %floor(4+ssz(2)/2);%380;
% % % sli_z = 1024; %floor(2+ssz(3)/2);%700;
% % % %sli_z = 512; %floor(2+ssz(3)/2);%700;
% % % %Change thhese to adjust the y axis
% % % %-------------------------
% % % elim=0.3;
% % % jlim0 = -0.1;
% % % jlim1 = 0.1;
% % % %-------------------------
% % % fs=18;
% % % %--------------------------------------------------------------------------
% % % x0=45;y0=54;xx1=810;yy1=710;
% % % f1=figure(1);
% % % %set(gcf,'Visible', 'off');
% % % set(gcf,'position',[x0,y0,xx1,yy1])
% % % %------------------------------------
% % % subplot(3,2,[1,2,3,4])
% % % dum_1 = n_e_avgt_i .*(Ex_avgt_i(:,sli_z) + vexB_avgt_x_i(:,sli_z));
% % % plot(yll,dum_1(:,sli_z),'k','LineWidth',lw);
% % % hold on
% % % dum_2 = Div_neve_ve_avg_i_x;
% % % plot(yll,dum_2(:,sli_z),'r','LineWidth',lw);
% % % dum_3 = Div_Pe_x_avgt_i;
% % % plot(yll,dum_3(:,sli_z),'b','LineWidth',lw);
% % % dum_4 = -del_n_e_del_Ex;
% % % plot(yll,dum_4(:,sli_z),'m','LineWidth',lw);
% % % dum_5 = -del_nevex_del_dB_x;
% % % plot(yll,dum_5(:,sli_z),'c','LineWidth',lw);
% % % dum_6 = Div_del_neve_del_ve_avg_x ;
% % % plot(yll,dum_6(:,sli_z),'g','LineWidth',lw);
% % % xlim([ylim_a, ylim_b]);
% % % ylim([-elim, elim]);
% % % xlabel('$y/d_i$','Interpreter','latex','FontSize',fs);
% % % ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% % % ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
% % % legend({'$en_{e}(E_{x} + (v_{e}\times B)_{x}$',...
% % %     '$(m\nabla \cdot (n_{e}v_{e}v_{e})_{x}$',...
% % %     '$(\nabla \cdot P_{e})_{x}$',...
% % %     '$-e(\delta n_{e} \delta E)_{x}$',...
% % %     '$-e(\delta n_{e}v_{e} \times \delta B)_{x}$',...
% % %     '$m(\nabla \cdot (\delta n_{e}v_{e} \delta v_{e}))_{x}$',...
% % %     },'Interpreter','latex','FontSize',fs,...
% % %     'Location','northwest','NumColumns',2)
% % % %sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
% % % hold off
% % % %--------------------------------------------------------------------------
% % % subplot(3,2,5)
% % % plot(yll,Jx_avgt_i(:,sli_z),'b','LineWidth',lw);
% % % xlim([ylim_a, ylim_b]);
% % % ylim([jlim0, jlim1]);
% % % ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% % % ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
% % % xlabel('$y/d_i$','Interpreter','latex','FontSize',fs);
% % % title('$J_x$','Interpreter','latex','FontSize',fs);
% % % subplot(3,2,6)
% % % dump = Jx_avgt_i;
% % % hc=pcolor(ZLL,YLL,dump);
% % % hold on
% % % set(hc,'edgecolor','none')
% % % xlim_a2 = zll(sli_z) - abs(xlim_a);
% % % xlim_b2 = zll(sli_z) + abs(xlim_a);
% % % xlim([xlim_a2, xlim_b2]);
% % % ylim([ylim_a, ylim_b]);
% % % xlabel('$z/d_i$','Interpreter','latex','FontSize',fs);
% % % ylabel('$y/d_i$','Interpreter','latex','FontSize',fs);
% % % ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% % % ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
% % % title('$J_x$','Interpreter','latex','FontSize',fs);
% % % hcb=colorbar; hcb.Location = 'eastoutside';
% % % hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
% % % xline(zll(sli_z),'--k','LineWidth',lw);
% % % pbaspect([1 1 1])
% % % caxis([jlim0,jlim1]);
% % % hold off
% % % sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
% % % %--------------------------------------------------------------------------
% % % 
% % % sli_z = 512; 
% % % sli_z = 1024-32; 
% % % %sli_z = 1024-200; 
% % % fs=18;
% % % %--------------------------------------------------------------------------
% % % x0=45;y0=54;xx1=810;yy1=710;
% % % f2=figure(2);
% % % %set(gcf,'Visible', 'off');
% % % set(gcf,'position',[x0,y0,xx1,yy1])
% % % %------------------------------------
% % % subplot(3,2,[1,2,3,4])
% % % dum_1 = n_e_avgt_i .*(Ex_avgt_i(:,sli_z) + vexB_avgt_x_i(:,sli_z));
% % % plot(yll,dum_1(:,sli_z),'k','LineWidth',lw);
% % % hold on
% % % dum_2 = Div_neve_ve_avg_i_x;
% % % plot(yll,dum_2(:,sli_z),'r','LineWidth',lw);
% % % dum_3 = Div_Pe_x_avgt_i;
% % % plot(yll,dum_3(:,sli_z),'b','LineWidth',lw);
% % % dum_4 = -del_n_e_del_Ex;
% % % plot(yll,dum_4(:,sli_z),'m','LineWidth',lw);
% % % dum_5 = -del_nevex_del_dB_x;
% % % plot(yll,dum_5(:,sli_z),'c','LineWidth',lw);
% % % dum_6 = Div_del_neve_del_ve_avg_x ;
% % % plot(yll,dum_6(:,sli_z),'g','LineWidth',lw);
% % % xlim([ylim_a, ylim_b]);
% % % %ylim([-0.02, 0.02]); elim=0.01;
% % % ylim([-elim, elim]);
% % % xlabel('$y/d_i$','Interpreter','latex','FontSize',fs);
% % % ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% % % ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
% % % legend({'$en_{e}(E_{x} + (v_{e}\times B)_{x}$',...
% % %     '$(m\nabla \cdot (n_{e}v_{e}v_{e})_{x}$',...
% % %     '$(\nabla \cdot P_{e})_{x}$',...
% % %     '$-e(\delta n_{e} \delta E)_{x}$',...
% % %     '$-e(\delta n_{e}v_{e} \times \delta B)_{x}$',...
% % %     '$m(\nabla \cdot (\delta n_{e}v_{e} \delta v_{e}))_{x}$',...
% % %     },'Interpreter','latex','FontSize',fs,...
% % %     'Location','northwest','NumColumns',2)
% % % %sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
% % % hold off
% % % %--------------------------------------------------------------------------
% % % subplot(3,2,5)
% % % plot(yll,Jx_avgt_i(:,sli_z),'b','LineWidth',lw);
% % % xlim([ylim_a, ylim_b]);
% % % %ylim([0, 0.06]);
% % % ylim([jlim0, jlim1]);
% % % ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% % % ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
% % % xlabel('$y/d_i$','Interpreter','latex','FontSize',fs);
% % % title('$J_x$','Interpreter','latex','FontSize',fs);
% % % subplot(3,2,6)
% % % dump = Jx_avgt_i;
% % % hc=pcolor(ZLL,YLL,dump);
% % % hold on
% % % set(hc,'edgecolor','none')
% % % xlim_a2 = zll(sli_z) - abs(xlim_a);
% % % xlim_b2 = zll(sli_z) + abs(xlim_a);
% % % xlim([xlim_a2, xlim_b2]);
% % % ylim([ylim_a, ylim_b]);
% % % xlabel('$z/d_i$','Interpreter','latex','FontSize',fs);
% % % ylabel('$y/d_i$','Interpreter','latex','FontSize',fs);
% % % ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% % % ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
% % % title('$J_x$','Interpreter','latex','FontSize',fs);
% % % hcb=colorbar; hcb.Location = 'eastoutside';
% % % hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
% % % xline(zll(sli_z),'--k','LineWidth',lw);
% % % pbaspect([1 1 1])
% % % %caxis([0,0.06]);
% % % caxis([jlim0,jlim1]);
% % % 
% % % hold off
% % % sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
% % % %--------------------------------------------------------------------------
% % % 
% % % 
% % % f3=figure(3)
% % % dump = Jx_avgt_i;
% % % hc=pcolor(ZLL,YLL,dump);
% % % hold on
% % % set(hc,'edgecolor','none')
% % % colorbar
% % % caxis([jlim0,jlim1]);
% % % xline(zll(sli_z),'--k','LineWidth',lw);
% % % hold off
% % % 
cd(path)
saveas(f1,strcat('Pressure_balance' + string(N) +'.png'));
% % % saveas(f2,strcat('E_components_Jx_1D_cut_off1' + string(JNn) +'.png'));
% % % saveas(f3,strcat('current2D_off1' + string(JNn) +'.png'));
% % % %saveas(f1,strcat('E_components_off' + string(JNn) +'.png'));
% % % %saveas(f2,strcat('Jx_1D_cut_off' + string(JNn) +'.png'));

