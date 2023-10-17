% Computing the time average quantities for the reconnecion electric field.

% This is for the localization study
%--------------------------------------------------------------------------
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_many_Ax_large_L8di_dB01_Omc1_kLd1_local_3';
%--------------------------------------------------------------------------


% This is to check the evolution of the energy terms
%--------------------------------------------------------------------------
%path_1 = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large';
%path_1 = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_cpinch_sSR/checkin_energy';
%path_2 = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_cpinch_sSR_lange/checkin_energy';

path_1 = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_many_Ax_large_L8di_dB01_Omc1_kLd1_local_3';

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

% allocate space for the energies
%--------------------------------------------------------------------------
U_em_mean=zeros(1,N_jn); % electromagnetic energy density
U_em_std=zeros(1,N_jn);

time_t_2=zeros(1,N_jn);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%JN=106; % This is the center of the interval for the time average

JN=79;
jn=JN;
jjn=4;

dab = 3; % this needs to be related to the gyro frequency or something
j_a = JN - dab;
j_b = JN + dab;
j_a_b = j_b - j_a;

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

%--------------------------------------------------------------------------
%Ax_y_short_i = zeros(1,N);
%ve_x_short_i = zeros(1,N);


for jn=j_a:j_b
    %for jn=1:N
    %----------------------------------------------------------------------
    % for the fields
    in=jn;
    %for the momments
    jjn=jn-j_a+1;
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
    clearvars J_ba J_up
    %----------------------------------------------------------------------

    % here is where I chose the values for the 1D cuts
    %----------------------------------------------------------------------
    ssz=size(B{1,1});
    sli_x = 1; %floor(4+ssz(1)/2);%1;
    sli_y = 512; %floor(4+ssz(2)/2);%380;
    sli_z = 904; %floor(2+ssz(3)/2);%700;
    %----------------------------------------------------------------------

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

    clearvars p_i p_e p_i_up p_e_up p_i_ba p_e_ba
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

    clearvars v_i_up v_e_up v_i_ba v_e_ba %<----
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
    n_e{1,1}=-1.*n_e{1,1};
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

    Txx_e=(Txx_e_up + Txx_e_ba)./1;
    Tyy_e=(Tyy_e_up + Tyy_e_ba)./1;
    Tzz_e=(Tzz_e_up + Tzz_e_ba)./1;
    Txy_e=(Txy_e_up + Txy_e_ba)./1;
    Txz_e=(Txz_e_up + Txz_e_ba)./1;
    Tyz_e=(Tyz_e_up + Tyz_e_ba)./1;

    clearvars Txx_e_ba Txx_e_up Tyy_e_ba Tyy_e_up Tzz_e_ba Tzz_e_up
    clearvars Txy_e_ba Txy_e_up Txz_e_ba Txz_e_up Tyz_e_ba Tyz_e_up

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

    Txx_i=(Txx_i_up + Txx_i_ba)./1;
    Tyy_i=(Tyy_i_up + Tyy_i_ba)./1;
    Tzz_i=(Tzz_i_up + Tzz_i_ba)./1;
    Txy_i=(Txy_i_up + Txy_i_ba)./1;
    Txz_i=(Txz_i_up + Txz_i_ba)./1;
    Tyz_i=(Tyz_i_up + Tyz_i_ba)./1;

    clearvars Txx_i_ba Txx_i_up Tyy_i_ba Tyy_i_up Tzz_i_ba Tzz_i_up
    clearvars Txy_i_ba Txy_i_up Txz_i_ba Txz_i_up Tyz_i_ba Tyz_i_up
    %----------------------------------------------------------------------
    Pij_i=cell(3,3);
    Pij_e=cell(3,3);
    Pij_i_ba=cell(3,3);
    Pij_e_ba=cell(3,3);
    Pij_i_up=cell(3,3);
    Pij_e_up=cell(3,3);
    %--------------------------------------------------------------------------
    % Make the tensor [3, 3] for the ions
    Pij_i{1,1}=Txx_i; Pij_i{1,2}=Txy_i; Pij_i{1,3}=Txz_i;
    Pij_i{2,1}=Txy_i; Pij_i{2,2}=Tyy_i; Pij_i{2,3}=Tyz_i;
    Pij_i{3,1}=Txz_i; Pij_i{3,2}=Tyz_i; Pij_i{3,3}=Tzz_i;
    clearvars Txx_i Txy_i Txz_i Tyy_i Tyz_i Tzz_i
    % Make the tensor [3, 3] for the electrons
    Pij_e{1,1}=Txx_e; Pij_e{1,2}=Txy_e; Pij_e{1,3}=Txz_e;
    Pij_e{2,1}=Txy_e; Pij_e{2,2}=Tyy_e; Pij_e{2,3}=Tyz_e;
    Pij_e{3,1}=Txz_e; Pij_e{3,2}=Tyz_e; Pij_e{3,3}=Tzz_e;
    clearvars Txx_e Txy_e Txz_e Tyy_e Tyz_e Tzz_e
    %----------------------------------------------------------------------
    % This is to get the central momment pressure.
    %----------------------------------------------------------------------
    PPij_i=cell(3,3);
    PPij_e=cell(3,3);
    for i=1:3
        for j=1:3
            if(isempty(Pij_i{i,j}) == 1)
                continue
            end
            PPij_i{i,j} = Pij_i{i,j} - n_i{1,1}.*mi.*v_i{1,i}.*v_i{1,j};
            PPij_e{i,j} = Pij_e{i,j} - n_e{1,1}.*me.*v_e{1,i}.*v_e{1,j};
        end
    end

    % This is just to rename the variable
    Pij_i = PPij_i;
    Pij_e = PPij_e;

    clearvars PPij_i PPij_e
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    n_i = n_i{1,1}; n_i = squeeze(n_i(sli_x,:,:));
    n_e = n_e{1,1}; n_e = squeeze(n_e(sli_x,:,:));

    Pij_i_xx =  Pij_i{1,1}; Pij_i_xx = squeeze(Pij_i_xx(sli_x,:,:));
    Pij_i_xy =  Pij_i{1,2}; Pij_i_xy = squeeze(Pij_i_xy(sli_x,:,:));
    Pij_i_xz =  Pij_i{1,3}; Pij_i_xz = squeeze(Pij_i_xz(sli_x,:,:));
    Pij_i_yy =  Pij_i{2,2}; Pij_i_yy = squeeze(Pij_i_yy(sli_x,:,:));
    Pij_i_yz =  Pij_i{2,2}; Pij_i_yz = squeeze(Pij_i_yz(sli_x,:,:));
    Pij_i_zz =  Pij_i{2,2}; Pij_i_zz = squeeze(Pij_i_zz(sli_x,:,:));

    Pij_e_xx =  Pij_e{1,1}; Pij_e_xx = squeeze(Pij_e_xx(sli_x,:,:));
    Pij_e_xy =  Pij_e{1,2}; Pij_e_xy = squeeze(Pij_e_xy(sli_x,:,:));
    Pij_e_xz =  Pij_e{1,3}; Pij_e_xz = squeeze(Pij_e_xz(sli_x,:,:));
    Pij_e_yy =  Pij_e{2,2}; Pij_e_yy = squeeze(Pij_e_yy(sli_x,:,:));
    Pij_e_yz =  Pij_e{2,2}; Pij_e_yz = squeeze(Pij_e_yz(sli_x,:,:));
    Pij_e_zz =  Pij_e{2,2}; Pij_e_zz = squeeze(Pij_e_zz(sli_x,:,:));

    clearvars v_i_up v_e_up v_i_ba v_e_ba v_i v_e
    clearvars Pij_i Pij_e
    %clearvars Pij_e_ba Pij_e_up  Pij_i_ba Pij_i_up
    %----------------------------------------------------------------------

    % v
    %----------------------------------------------------------------------
    v_x = (mi .* n_i .* v_ix + me .* n_e .* v_ex)./(mi .* n_i + me .* n_e);
    v_y = (mi .* n_i .* v_iy + me .* n_e .* v_ey)./(mi .* n_i + me .* n_e);
    v_z = (mi .* n_i .* v_iz + me .* n_e .* v_ez)./(mi .* n_i + me .* n_e);

    n = (mi .* n_i + me .* n_e) / (mi + me);
    %----------------------------------------------------------------------

    % Save the data for the time average
    %----------------------------------------------------------------------
    inn=(jn - j_a +1);

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

    Pij_i_in{1,inn} = Pij_i_xx;
    Pij_i_in{2,inn} = Pij_i_xy;
    Pij_i_in{3,inn} = Pij_i_xz;
    Pij_i_in{4,inn} = Pij_i_yy;
    Pij_i_in{5,inn} = Pij_i_yz;
    Pij_i_in{6,inn} = Pij_i_zz;

    Pij_e_in{1,inn} = Pij_e_xx;
    Pij_e_in{2,inn} = Pij_e_xy;
    Pij_e_in{3,inn} = Pij_e_xz;
    Pij_e_in{4,inn} = Pij_e_yy;
    Pij_e_in{5,inn} = Pij_e_yz;
    Pij_e_in{6,inn} = Pij_e_zz;

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
nu_av=j_a_b+1; % this is for the average
%----------------------------------------------------------------------

%----------------------------------------------------------------------
for ii=1:j_a_b+1

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
%--------------------------------------------------------------------------

% setting the initial values to zero
%----------------------------------------------------------------------
[del_Ex_1, del_Ey_1, del_Ez_1, del_Bx_1, del_By_1, del_Bz_1, del_Jx_1, del_Jy_1, del_Jz_1] = ...
    deal(DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM);

[del_n_e_1, del_n_i_1, del_n_1,...
    del_vix_1, del_viy_1, del_viz_1, del_vex_1, del_vey_1, del_vez_1, del_vx_1, del_vy_1, del_vz_1] = ...
    deal(DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM);
%----------------------------------------------------------------------
% now the composed quantities
%----------------------------------------------------------------------
[del_n_i_vi_x_1, del_n_i_vi_y_1, del_n_i_vi_z_1,...
    del_n_e_ve_x_1, del_n_e_ve_y_1, del_n_e_ve_z_1,...
    del_n_v_x_1, del_n_v_y_1, del_n_v_z_1] = deal(DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM);
%del_nvxdel_dB
%----------------------------------------------------------------------
[del_nivix_del_dB_x_1, del_nivix_del_dB_y_1, del_nivix_del_dB_z_1,...
    del_nevex_del_dB_x_1, del_nevex_del_dB_y_1, del_nevex_del_dB_z_1,...
    del_nvx_del_dB_x_1, del_nvx_del_dB_y_1, del_nvx_del_dB_z_1] = deal(DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM);
%----------------------------------------------------------------------
[del_n_i_del_Ex_1, del_n_i_del_Ey_1, del_n_i_del_Ez_1,...
    del_n_e_del_Ex_1, del_n_e_del_Ey_1, del_n_e_del_Ez_1,...
    del_n_del_Ex_1, del_n_del_Ey_1, del_n_del_Ez_1] = deal(DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM);
%----------------------------------------------------------------------
% tennsor product of the deltas
%----------------------------------------------------------------------
[del_nivi_del_vi_avg_xx_1, del_nivi_del_vi_avg_xy_1, del_nivi_del_vi_avg_xz_1,...
    del_nivi_del_vi_avg_yy_1, del_nivi_del_vi_avg_yz_1, del_nivi_del_vi_avg_zz_1] = deal(DUM,DUM,DUM,DUM,DUM,DUM);

[del_neve_del_ve_avg_xx_1, del_neve_del_ve_avg_xy_1, del_neve_del_ve_avg_xz_1,...
    del_neve_del_ve_avg_yy_1, del_neve_del_ve_avg_yz_1, del_neve_del_ve_avg_zz_1] = deal(DUM,DUM,DUM,DUM,DUM,DUM);

[del_nv_del_v_avg_xx_1, del_nv_del_v_avg_xy_1, del_nv_del_v_avg_xz_1,...
    del_nv_del_v_avg_yy_1, del_nv_del_v_avg_yz_1, del_nv_del_v_avg_zz_1] = deal(DUM,DUM,DUM,DUM,DUM,DUM);
%----------------------------------------------------------------------

% to compute the averges of the delta quantities
%----------------------------------------------------------------------
for ii=1:j_a_b+1
    %ii = floor(j_a_b/2) + 1; % the center of the interval

    % get the Extract the instantaneus fields
    %----------------------------------------------------------------------
    Ex_avgt_o = E_in{1,ii};
    Ey_avgt_o = E_in{2,ii};
    Ez_avgt_o = E_in{3,ii};

    Bx_avgt_o = B_in{1,ii};
    By_avgt_o = B_in{2,ii};
    Bz_avgt_o = B_in{3,ii};

    Jx_avgt_o = J_in{1,ii};
    Jy_avgt_o = J_in{2,ii};
    Jz_avgt_o = J_in{3,ii};

    n_e_avgt_o = n_in{1,ii};
    n_i_avgt_o = n_in{2,ii};

    v_ix_avgt_o = v_i_in{1,ii};
    v_iy_avgt_o = v_i_in{2,ii};
    v_iz_avgt_o = v_i_in{3,ii};

    v_ex_avgt_o = v_e_in{1,ii};
    v_ey_avgt_o = v_e_in{2,ii};
    v_ez_avgt_o = v_e_in{3,ii};

    v_x_avgt_o = v_in{1,ii};
    v_y_avgt_o = v_in{2,ii};
    v_z_avgt_o = v_in{3,ii};

    Pij_i_xx_avgt_o = Pij_i_in{1,ii};
    Pij_i_xy_avgt_o = Pij_i_in{2,ii};
    Pij_i_xz_avgt_o = Pij_i_in{3,ii};
    Pij_i_yy_avgt_o = Pij_i_in{4,ii};
    Pij_i_yz_avgt_o = Pij_i_in{5,ii};
    Pij_i_zz_avgt_o = Pij_i_in{6,ii};

    Pij_e_xx_avgt_o = Pij_e_in{1,ii};
    Pij_e_xy_avgt_o = Pij_e_in{2,ii};
    Pij_e_xz_avgt_o = Pij_e_in{3,ii};
    Pij_e_yy_avgt_o = Pij_e_in{4,ii};
    Pij_e_yz_avgt_o = Pij_e_in{5,ii};
    Pij_e_zz_avgt_o = Pij_e_in{6,ii};

    n_avgt_o = n_in{3,ii};

    n_i_vix_avgt_o = n_i_vi_in{1,ii} ;
    n_i_viy_avgt_o = n_i_vi_in{2,ii} ;
    n_i_viz_avgt_o = n_i_vi_in{3,ii} ;

    n_e_vex_avgt_o = n_e_ve_in{1,ii} ;
    n_e_vey_avgt_o = n_e_ve_in{2,ii} ;
    n_e_vez_avgt_o = n_e_ve_in{3,ii} ;

    n_vx_avgt_o = n_v_in{1,ii} ;
    n_vy_avgt_o = n_v_in{2,ii} ;
    n_vz_avgt_o = n_v_in{3,ii} ;
    %----------------------------------------------------------------------

    % Compute the fluctuations, e.g., delta_n_e = n_e_time_i - <n>
    %----------------------------------------------------------------------
    del_Ex = (Ex_avgt_o - Ex_avgt_i./nu_av);
    del_Ey = (Ey_avgt_o - Ey_avgt_i./nu_av);
    del_Ez = (Ez_avgt_o - Ez_avgt_i./nu_av);

    del_Bx = (Bx_avgt_o - Bx_avgt_i./nu_av);
    del_By = (By_avgt_o - By_avgt_i./nu_av);
    del_Bz = (Bz_avgt_o - Bz_avgt_i./nu_av);

    del_Jx = (Jx_avgt_o - Jx_avgt_i./nu_av);
    del_Jy = (Jy_avgt_o - Jy_avgt_i./nu_av);
    del_Jz = (Jz_avgt_o - Jz_avgt_i./nu_av);

    del_n_e = (n_e_avgt_o - n_e_avgt_i./nu_av);
    del_n_i = (n_i_avgt_o - n_i_avgt_i./nu_av);

    del_vix = (v_ix_avgt_o - v_ix_avgt_i./nu_av);
    del_viy = (v_iy_avgt_o - v_iy_avgt_i./nu_av);
    del_viz = (v_iz_avgt_o - v_iz_avgt_i./nu_av);

    del_vex = (v_ex_avgt_o - v_ex_avgt_i./nu_av);
    del_vey = (v_ey_avgt_o - v_ey_avgt_i./nu_av);
    del_vez = (v_ez_avgt_o - v_ez_avgt_i./nu_av);

    del_vx = (v_x_avgt_o - v_x_avgt_i./nu_av);
    del_vy = (v_y_avgt_o - v_y_avgt_i./nu_av);
    del_vz = (v_z_avgt_o - v_z_avgt_i./nu_av);
    %----------------------------------------------------------------------

    % now the composed quantities
    %----------------------------------------------------------------------
    del_n = (n_avgt_o - n_avgt_i./nu_av);

    del_n_i_vi_x = (n_i_vix_avgt_o - n_i_vix_avgt_i./nu_av) ;
    del_n_i_vi_y = (n_i_viy_avgt_o - n_i_viy_avgt_i./nu_av) ;
    del_n_i_vi_z = (n_i_viz_avgt_o - n_i_viz_avgt_i./nu_av) ;

    del_n_e_ve_x = (n_e_vex_avgt_o - n_e_vex_avgt_i./nu_av) ;
    del_n_e_ve_y = (n_e_vey_avgt_o - n_e_vey_avgt_i./nu_av) ;
    del_n_e_ve_z = (n_e_vez_avgt_o - n_e_vez_avgt_i./nu_av) ;

    del_n_v_x = (n_vx_avgt_o - n_vx_avgt_i./nu_av) ;
    del_n_v_y = (n_vy_avgt_o - n_vy_avgt_i./nu_av) ;
    del_n_v_z = (n_vz_avgt_o - n_vz_avgt_i./nu_av) ;

    %del_nvxdel_dB
    %----------------------------------------------------------------------
    del_nivix_del_dB_x = (del_n_i_vi_y .* del_Bz - del_n_i_vi_z .* del_By);
    del_nivix_del_dB_y = (del_n_i_vi_z .* del_Bx - del_n_i_vi_x .* del_Bz);
    del_nivix_del_dB_z = (del_n_i_vi_x .* del_By - del_n_i_vi_y .* del_Bx);

    del_nevex_del_dB_x = (del_n_e_ve_y .* del_Bz - del_n_e_ve_z .* del_By);
    del_nevex_del_dB_y = (del_n_e_ve_z .* del_Bx - del_n_e_ve_x .* del_Bz);
    del_nevex_del_dB_z = (del_n_e_ve_x .* del_By - del_n_e_ve_y .* del_Bx);

    del_nvx_del_dB_x = (del_n_v_y .* del_Bz - del_n_v_z .* del_By);
    del_nvx_del_dB_y = (del_n_v_z .* del_Bx - del_n_v_x .* del_Bz);
    del_nvx_del_dB_z = (del_n_v_x .* del_By - del_n_v_y .* del_Bx);
    %----------------------------------------------------------------------
    %del_n_del_E
    %----------------------------------------------------------------------
    del_n_i_del_Ex = (del_n_i .* del_Ex);
    del_n_i_del_Ey = (del_n_i .* del_Ey);
    del_n_i_del_Ez = (del_n_i .* del_Ez);

    del_n_e_del_Ex = (del_n_e .* del_Ex);
    del_n_e_del_Ey = (del_n_e .* del_Ey);
    del_n_e_del_Ez = (del_n_e .* del_Ez);

    del_n_del_Ex = (del_n .* del_Ex);
    del_n_del_Ey = (del_n .* del_Ey);
    del_n_del_Ez = (del_n .* del_Ez);
    %----------------------------------------------------------------------
    % tennsor product of the deltas
    %----------------------------------------------------------------------
    del_nivi_del_vi_avg_xx = (del_n_i_vi_x .* del_vix);
    del_nivi_del_vi_avg_xy = (del_n_i_vi_x .* del_viy);
    del_nivi_del_vi_avg_xz = (del_n_i_vi_x .* del_viz);
    del_nivi_del_vi_avg_yy = (del_n_i_vi_y .* del_viy);
    del_nivi_del_vi_avg_yz = (del_n_i_vi_y .* del_viz);
    del_nivi_del_vi_avg_zz = (del_n_i_vi_z .* del_viz);

    del_neve_del_ve_avg_xx = (del_n_e_ve_x .* del_vex);
    del_neve_del_ve_avg_xy = (del_n_e_ve_x .* del_vey);
    del_neve_del_ve_avg_xz = (del_n_e_ve_x .* del_vez);
    del_neve_del_ve_avg_yy = (del_n_e_ve_y .* del_vey);
    del_neve_del_ve_avg_yz = (del_n_e_ve_y .* del_vez);
    del_neve_del_ve_avg_zz = (del_n_e_ve_z .* del_vez);

    del_nv_del_v_avg_xx = (del_n_v_x .* del_vx);
    del_nv_del_v_avg_xy = (del_n_v_x .* del_vy);
    del_nv_del_v_avg_xz = (del_n_v_x .* del_vz);
    del_nv_del_v_avg_yy = (del_n_v_y .* del_vy);
    del_nv_del_v_avg_yz = (del_n_v_y .* del_vz);
    del_nv_del_v_avg_zz = (del_n_v_z .* del_vz);
    %----------------------------------------------------------------------


    % make the adding
    %----------------------------------------------------------------------
    del_Ex_0 = del_Ex_1 + del_Ex; del_Ex_1 = del_Ex_0;
    del_Ey_0 = del_Ey_1 + del_Ey; del_Ey_1 = del_Ey_0;
    del_Ez_0 = del_Ez_1 + del_Ez; del_Ez_1 = del_Ez_0;

    del_Bx_0 = del_Bx_1 + del_Bx; del_Bx_1 = del_Bx_0;
    del_By_0 = del_By_1 + del_By; del_By_1 = del_By_0;
    del_Bz_0 = del_Bz_1 + del_Bz; del_Bz_1 = del_Bz_0;

    del_Jx_0 = del_Jx_1 + del_Jx; del_Jx_1 = del_Jx_0;
    del_Jy_0 = del_Jy_1 + del_Jy; del_Jy_1 = del_Jy_0;
    del_Jz_0 = del_Jz_1 + del_Jz; del_Jz_1 = del_Jz_0;

    del_n_e_0 = del_n_e_1 + del_n_e; del_n_e_1 = del_n_e_0;
    del_n_i_0 = del_n_i_1 + del_n_i; del_n_i_1 = del_n_i_0;

    del_vix_0 = del_vix_1 + del_vix; del_vix_1 = del_vix_0;
    del_viy_0 = del_viy_1 + del_viy; del_viy_1 = del_viy_0;
    del_viz_0 = del_viz_1 + del_viz; del_viz_1 = del_viz_0;

    del_vex_0 = del_vex_1 + del_vex; del_vex_1 = del_vex_0;
    del_vey_0 = del_vey_1 + del_vey; del_vey_1 = del_vey_0;
    del_vez_0 = del_vez_1 + del_vez; del_vez_1 = del_vez_0;

    del_vx_0 = del_vx_1 + del_vx; del_vx_1 = del_vx_0;
    del_vy_0 = del_vy_1 + del_vy; del_vy_1 = del_vy_0;
    del_vz_0 = del_vz_1 + del_vz; del_vz_1 = del_vz_0;
    %----------------------------------------------------------------------

    % now the composed quantities
    %----------------------------------------------------------------------
    del_n_0 = del_n_1 + del_n; del_n_1 = del_n_0;

    del_n_i_vi_x_0 = del_n_i_vi_x_1 + del_n_i_vi_x; del_n_i_vi_x_1 = del_n_i_vi_x_0;
    del_n_i_vi_y_0 = del_n_i_vi_y_1 + del_n_i_vi_x; del_n_i_vi_y_1 = del_n_i_vi_y_0;
    del_n_i_vi_z_0 = del_n_i_vi_z_1 + del_n_i_vi_x; del_n_i_vi_z_1 = del_n_i_vi_z_0;

    del_n_e_ve_x_0 = del_n_e_ve_x_1 + del_n_e_ve_x; del_n_e_ve_x_1 = del_n_e_ve_x_0;
    del_n_e_ve_y_0 = del_n_e_ve_y_1 + del_n_e_ve_x; del_n_e_ve_y_1 = del_n_e_ve_y_0;
    del_n_e_ve_z_0 = del_n_e_ve_z_1 + del_n_e_ve_x; del_n_e_ve_z_1 = del_n_e_ve_z_0;

    del_n_v_x_0 = del_n_v_x_1 + del_n_v_x; del_n_v_x_1 = del_n_v_x_0;
    del_n_v_y_0 = del_n_v_y_1 + del_n_v_x; del_n_v_y_1 = del_n_v_y_0;
    del_n_v_z_0 = del_n_v_z_1 + del_n_v_x; del_n_v_z_1 = del_n_v_z_0;
    %----------------------------------------------------------------------

    %del_nvxdel_dB
    %----------------------------------------------------------------------
    del_nivix_del_dB_x_0 = del_nivix_del_dB_x_1 + del_nivix_del_dB_x; del_nivix_del_dB_x_1 = del_nivix_del_dB_x_0;
    del_nivix_del_dB_y_0 = del_nivix_del_dB_y_1 + del_nivix_del_dB_y; del_nivix_del_dB_y_1 = del_nivix_del_dB_y_0;
    del_nivix_del_dB_z_0 = del_nivix_del_dB_z_1 + del_nivix_del_dB_z; del_nivix_del_dB_z_1 = del_nivix_del_dB_z_0;

    del_nevex_del_dB_x_0 = del_nevex_del_dB_x_1 + del_nevex_del_dB_x; del_nevex_del_dB_x_1 = del_nevex_del_dB_x_0;
    del_nevex_del_dB_y_0 = del_nevex_del_dB_y_1 + del_nevex_del_dB_y; del_nevex_del_dB_y_1 = del_nevex_del_dB_y_0;
    del_nevex_del_dB_z_0 = del_nevex_del_dB_z_1 + del_nevex_del_dB_z; del_nevex_del_dB_z_1 = del_nevex_del_dB_z_0;

    del_nvx_del_dB_x_0 = del_nvx_del_dB_x_1 + del_nvx_del_dB_x; del_nvx_del_dB_x_1 = del_nvx_del_dB_x_0;
    del_nvx_del_dB_y_0 = del_nvx_del_dB_y_1 + del_nvx_del_dB_y; del_nvx_del_dB_y_1 = del_nvx_del_dB_y_0;
    del_nvx_del_dB_z_0 = del_nvx_del_dB_z_1 + del_nvx_del_dB_z; del_nvx_del_dB_z_1 = del_nvx_del_dB_z_0;
    %----------------------------------------------------------------------

    %del_n_del_E
    %----------------------------------------------------------------------
    del_n_i_del_Ex_0 = del_n_i_del_Ex_1 + del_n_i_del_Ex; del_n_i_del_Ex_1 = del_n_i_del_Ex_0;
    del_n_i_del_Ey_0 = del_n_i_del_Ey_1 + del_n_i_del_Ey; del_n_i_del_Ey_1 = del_n_i_del_Ey_0;
    del_n_i_del_Ez_0 = del_n_i_del_Ez_1 + del_n_i_del_Ez; del_n_i_del_Ez_1 = del_n_i_del_Ez_0;

    del_n_e_del_Ex_0 = del_n_e_del_Ex_1 + del_n_e_del_Ex; del_n_e_del_Ex_1 = del_n_e_del_Ex_0;
    del_n_e_del_Ey_0 = del_n_e_del_Ey_1 + del_n_e_del_Ey; del_n_e_del_Ey_1 = del_n_e_del_Ey_0;
    del_n_e_del_Ez_0 = del_n_e_del_Ez_1 + del_n_e_del_Ez; del_n_e_del_Ez_1 = del_n_e_del_Ez_0;

    del_n_del_Ex_0 = del_n_del_Ex_1 + del_n_del_Ex; del_n_del_Ex_1 = del_n_del_Ex_0;
    del_n_del_Ey_0 = del_n_del_Ey_1 + del_n_del_Ey; del_n_del_Ey_1 = del_n_del_Ey_0;
    del_n_del_Ez_0 = del_n_del_Ez_1 + del_n_del_Ez; del_n_del_Ez_1 = del_n_del_Ez_0;
    %----------------------------------------------------------------------

    % tennsor product of the deltas
    %----------------------------------------------------------------------
    del_nivi_del_vi_avg_xx_0 = del_nivi_del_vi_avg_xx_1 + del_nivi_del_vi_avg_xx; del_nivi_del_vi_avg_xx_1 = del_nivi_del_vi_avg_xx_0;
    del_nivi_del_vi_avg_xy_0 = del_nivi_del_vi_avg_xy_1 + del_nivi_del_vi_avg_xy; del_nivi_del_vi_avg_xy_1 = del_nivi_del_vi_avg_xy_0;
    del_nivi_del_vi_avg_xz_0 = del_nivi_del_vi_avg_xz_1 + del_nivi_del_vi_avg_xz; del_nivi_del_vi_avg_xz_1 = del_nivi_del_vi_avg_xz_0;
    del_nivi_del_vi_avg_yy_0 = del_nivi_del_vi_avg_yy_1 + del_nivi_del_vi_avg_yy; del_nivi_del_vi_avg_yy_1 = del_nivi_del_vi_avg_yy_0;
    del_nivi_del_vi_avg_yz_0 = del_nivi_del_vi_avg_yz_1 + del_nivi_del_vi_avg_yz; del_nivi_del_vi_avg_yz_1 = del_nivi_del_vi_avg_yz_0;
    del_nivi_del_vi_avg_zz_0 = del_nivi_del_vi_avg_zz_1 + del_nivi_del_vi_avg_zz; del_nivi_del_vi_avg_zz_1 = del_nivi_del_vi_avg_zz_0;

    del_neve_del_ve_avg_xx_0 = del_neve_del_ve_avg_xx_1 + del_neve_del_ve_avg_xx; del_neve_del_ve_avg_xx_1 = del_neve_del_ve_avg_xx_0;
    del_neve_del_ve_avg_xy_0 = del_neve_del_ve_avg_xy_1 + del_neve_del_ve_avg_xy; del_neve_del_ve_avg_xy_1 = del_neve_del_ve_avg_xy_0;
    del_neve_del_ve_avg_xz_0 = del_neve_del_ve_avg_xz_1 + del_neve_del_ve_avg_xz; del_neve_del_ve_avg_xz_1 = del_neve_del_ve_avg_xz_0;
    del_neve_del_ve_avg_yy_0 = del_neve_del_ve_avg_yy_1 + del_neve_del_ve_avg_yy; del_neve_del_ve_avg_yy_1 = del_neve_del_ve_avg_yy_0;
    del_neve_del_ve_avg_yz_0 = del_neve_del_ve_avg_yz_1 + del_neve_del_ve_avg_yz; del_neve_del_ve_avg_yz_1 = del_neve_del_ve_avg_yz_0;
    del_neve_del_ve_avg_zz_0 = del_neve_del_ve_avg_zz_1 + del_neve_del_ve_avg_zz; del_neve_del_ve_avg_zz_1 = del_neve_del_ve_avg_zz_0;

    del_nv_del_v_avg_xx_0 = del_nv_del_v_avg_xx_1 + del_nv_del_v_avg_xx; del_nv_del_v_avg_xx_1 = del_nv_del_v_avg_xx_0;
    del_nv_del_v_avg_xy_0 = del_nv_del_v_avg_xy_1 + del_nv_del_v_avg_xy; del_nv_del_v_avg_xy_1 = del_nv_del_v_avg_xy_0;
    del_nv_del_v_avg_xz_0 = del_nv_del_v_avg_xz_1 + del_nv_del_v_avg_xz; del_nv_del_v_avg_xz_1 = del_nv_del_v_avg_xz_0;
    del_nv_del_v_avg_yy_0 = del_nv_del_v_avg_yy_1 + del_nv_del_v_avg_yy; del_nv_del_v_avg_yy_1 = del_nv_del_v_avg_yy_0;
    del_nv_del_v_avg_yz_0 = del_nv_del_v_avg_yz_1 + del_nv_del_v_avg_yz; del_nv_del_v_avg_yz_1 = del_nv_del_v_avg_yz_0;
    del_nv_del_v_avg_zz_0 = del_nv_del_v_avg_zz_1 + del_nv_del_v_avg_zz; del_nv_del_v_avg_zz_1 = del_nv_del_v_avg_zz_0;
    %----------------------------------------------------------------------
end

%--------------------------------------------------------------------------
clearvars Pij_e_ba Pij_e_up Pij_e_in
clearvars Pij_i_ba Pij_i_up Pij_i_in
clearvars E_in B_in J_in n_in v_i_in v_e_in v_in
clearvars n_in n_i_vi_in n_e_ve_in n_v_in 
clearvars vixB_in vexB_in vxB_in

clearvars *_o
clearvars *_0
%--------------------------------------------------------------------------

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
%----------------------------------------------------------------------

% For the fluctuations
%----------------------------------------------------------------------
del_Ex = del_Ex_1./nu_av;
del_Ey = del_Ey_1./nu_av;
del_Ez = del_Ez_1./nu_av;

del_Bx = del_Bx_1./nu_av;
del_By = del_By_1./nu_av;
del_Bz = del_Bz_1./nu_av;

del_Jx = del_Jx_1./nu_av;
del_Jy = del_Jy_1./nu_av;
del_Jz = del_Jz_1./nu_av;

del_n_e = del_n_e_1./nu_av;
del_n_i = del_n_i_1./nu_av;

del_vix = del_vix_1./nu_av;
del_viy = del_viy_1./nu_av;
del_viz = del_viz_1./nu_av;

del_vex = del_vex_1./nu_av;
del_vey = del_vey_1./nu_av;
del_vez = del_vez_1./nu_av;

del_vx = del_vx_1./nu_av;
del_vy = del_vy_1./nu_av;
del_vz = del_vz_1./nu_av;
%----------------------------------------------------------------------

% now the composed quantities
%----------------------------------------------------------------------
del_n = del_n_1./nu_av;

del_n_i_vi_x = del_n_i_vi_x_1./nu_av ;
del_n_i_vi_y = del_n_i_vi_y_1./nu_av ;
del_n_i_vi_z = del_n_i_vi_z_1./nu_av ;

del_n_e_ve_x = del_n_e_ve_x_1./nu_av ;
del_n_e_ve_y = del_n_e_ve_y_1./nu_av ;
del_n_e_ve_z = del_n_e_ve_z_1./nu_av ;

del_n_v_x = del_n_v_x_1./nu_av ;
del_n_v_y = del_n_v_y_1./nu_av ;
del_n_v_z = del_n_v_z_1./nu_av ;

%del_nvxdel_dB
%----------------------------------------------------------------------
del_nivix_del_dB_x = del_nivix_del_dB_x_1./nu_av ;
del_nivix_del_dB_y = del_nivix_del_dB_y_1./nu_av ;
del_nivix_del_dB_z = del_nivix_del_dB_z_1./nu_av ;

del_nevex_del_dB_x = del_nevex_del_dB_x_1./nu_av ;
del_nevex_del_dB_y = del_nevex_del_dB_y_1./nu_av ;
del_nevex_del_dB_z = del_nevex_del_dB_z_1./nu_av ;

del_nvx_del_dB_x = del_nvx_del_dB_x_1./nu_av ;
del_nvx_del_dB_y = del_nvx_del_dB_y_1./nu_av ;
del_nvx_del_dB_z = del_nvx_del_dB_z_1./nu_av ;
%----------------------------------------------------------------------
del_n_i_del_Ex = del_n_i_del_Ex_1./nu_av;
del_n_i_del_Ey = del_n_i_del_Ey_1./nu_av;
del_n_i_del_Ez = del_n_i_del_Ez_1./nu_av;

del_n_e_del_Ex = del_n_e_del_Ex_1./nu_av;
del_n_e_del_Ey = del_n_e_del_Ey_1./nu_av;
del_n_e_del_Ez = del_n_e_del_Ez_1./nu_av;

del_n_del_Ex = del_n_del_Ex_1./nu_av;
del_n_del_Ey = del_n_del_Ey_1./nu_av;
del_n_del_Ez = del_n_del_Ez_1./nu_av;
%----------------------------------------------------------------------

% tennsor product of the deltas
%----------------------------------------------------------------------
del_nivi_del_vi_avg_xx = del_nivi_del_vi_avg_xx_1./nu_av ;
del_nivi_del_vi_avg_xy = del_nivi_del_vi_avg_xy_1./nu_av ;
del_nivi_del_vi_avg_xz = del_nivi_del_vi_avg_xz_1./nu_av ;
del_nivi_del_vi_avg_yy = del_nivi_del_vi_avg_yy_1./nu_av ;
del_nivi_del_vi_avg_yz = del_nivi_del_vi_avg_yz_1./nu_av ;
del_nivi_del_vi_avg_zz = del_nivi_del_vi_avg_zz_1./nu_av ;

del_neve_del_ve_avg_xx = del_neve_del_ve_avg_xx_1./nu_av ;
del_neve_del_ve_avg_xy = del_neve_del_ve_avg_xy_1./nu_av ;
del_neve_del_ve_avg_xz = del_neve_del_ve_avg_xz_1./nu_av ;
del_neve_del_ve_avg_yy = del_neve_del_ve_avg_yy_1./nu_av ;
del_neve_del_ve_avg_yz = del_neve_del_ve_avg_yz_1./nu_av ;
del_neve_del_ve_avg_zz = del_neve_del_ve_avg_zz_1./nu_av ;

del_nv_del_v_avg_xx = del_nv_del_v_avg_xx_1./nu_av ;
del_nv_del_v_avg_xy = del_nv_del_v_avg_xy_1./nu_av ;
del_nv_del_v_avg_xz = del_nv_del_v_avg_xz_1./nu_av ;
del_nv_del_v_avg_yy = del_nv_del_v_avg_yy_1./nu_av ;
del_nv_del_v_avg_yz = del_nv_del_v_avg_yz_1./nu_av ;
del_nv_del_v_avg_zz = del_nv_del_v_avg_zz_1./nu_av ;
%----------------------------------------------------------------------

%----------------------------------------------------------------------
clearvars *_1
%----------------------------------------------------------------------

% U_ave times B_ave
%--------------------------------------------------------------------------
vixB_avgt_x_i = (v_iy_avgt_i.*Bz_avgt_i - v_iz_avgt_i.*By_avgt_i);
vixB_avgt_y_i = (v_iz_avgt_i.*Bx_avgt_i - v_ix_avgt_i.*Bz_avgt_i);
vixB_avgt_z_i = (v_ix_avgt_i.*By_avgt_i - v_iy_avgt_i.*Bx_avgt_i);

vexB_avgt_x_i = (v_ey_avgt_i.*Bz_avgt_i - v_ez_avgt_i.*By_avgt_i);
vexB_avgt_y_i = (v_ez_avgt_i.*Bx_avgt_i - v_ex_avgt_i.*Bz_avgt_i);
vexB_avgt_z_i = (v_ex_avgt_i.*By_avgt_i - v_ey_avgt_i.*Bx_avgt_i);

vxB_avgt_x_i = (v_y_avgt_i.*Bz_avgt_i - v_z_avgt_i.*By_avgt_i);
vxB_avgt_y_i = (v_z_avgt_i.*Bx_avgt_i - v_x_avgt_i.*Bz_avgt_i);
vxB_avgt_z_i = (v_x_avgt_i.*By_avgt_i - v_y_avgt_i.*Bx_avgt_i);
%--------------------------------------------------------------------------

%tensor product of the averages (nU)_ave U_ave
%--------------------------------------------------------------------------
nivi_vi_avg_xx_i = (n_i_vix_avgt_i .* v_ix_avgt_i);
nivi_vi_avg_xy_i = (n_i_vix_avgt_i .* v_iy_avgt_i);
nivi_vi_avg_xz_i = (n_i_vix_avgt_i .* v_iz_avgt_i);
nivi_vi_avg_yy_i = (n_i_viy_avgt_i .* v_iy_avgt_i);
nivi_vi_avg_yz_i = (n_i_viy_avgt_i .* v_iz_avgt_i);
nivi_vi_avg_zz_i = (n_i_viz_avgt_i .* v_iz_avgt_i);

neve_ve_avg_xx_i = (n_e_vex_avgt_i .* v_ex_avgt_i);
neve_ve_avg_xy_i = (n_e_vex_avgt_i .* v_ey_avgt_i);
neve_ve_avg_xz_i = (n_e_vex_avgt_i .* v_ez_avgt_i);
neve_ve_avg_yy_i = (n_e_vey_avgt_i .* v_ey_avgt_i);
neve_ve_avg_yz_i = (n_e_vey_avgt_i .* v_ez_avgt_i);
neve_ve_avg_zz_i = (n_e_vez_avgt_i .* v_ez_avgt_i);

nv_v_avg_xx_i = (n_vx_avgt_i .* v_x_avgt_i);
nv_v_avg_xy_i = (n_vx_avgt_i .* v_y_avgt_i);
nv_v_avg_xz_i = (n_vx_avgt_i .* v_z_avgt_i);
nv_v_avg_yy_i = (n_vy_avgt_i .* v_y_avgt_i);
nv_v_avg_yz_i = (n_vy_avgt_i .* v_z_avgt_i);
nv_v_avg_zz_i = (n_vz_avgt_i .* v_z_avgt_i);
%----------------------------------------------------------------------

% % this should be zero
% %Product of the averages (del_n)_ave (del_E)_ave
% %--------------------------------------------------------------------------
% del_n_i_del_Ex = (del_n_i .* del_Ex);
% del_n_i_del_Ey = (del_n_i .* del_Ey);
% del_n_i_del_Ez = (del_n_i .* del_Ez);
% 
% del_n_e_del_Ex = (del_n_e .* del_Ex);
% del_n_e_del_Ey = (del_n_e .* del_Ey);
% del_n_e_del_Ez = (del_n_e .* del_Ez);
% 
% del_n_del_Ex = (del_n .* del_Ex);
% del_n_del_Ey = (del_n .* del_Ey);
% del_n_del_Ez = (del_n .* del_Ez);
% %----------------------------------------------------------------------

% compute the gradients and divergence of the vectors ans tensors.
%Grad_B
%----------------------------------------------------------------------
[By_avgt_i_z,By_avgt_i_y] = gradient(By_avgt_i);
[Bz_avgt_i_z,Bz_avgt_i_y] = gradient(Bz_avgt_i);

By_avgt_i_z = By_avgt_i_z/resz;   By_avgt_i_y = By_avgt_i_y/resy;
Bz_avgt_i_z = Bz_avgt_i_z/resz;   Bz_avgt_i_y = Bz_avgt_i_y/resy;
%----------------------------------------------------------------------

%Grad_Pi
%----------------------------------------------------------------------
[Pij_i_xx_avgt_i_z, Pij_i_xx_avgt_i_y] = gradient(Pij_i_xx_avgt_i);
[Pij_i_yy_avgt_i_z, Pij_i_yy_avgt_i_y] = gradient(Pij_i_yy_avgt_i);
[Pij_i_zz_avgt_i_z, Pij_i_zz_avgt_i_y] = gradient(Pij_i_zz_avgt_i);
[Pij_i_xy_avgt_i_z, Pij_i_xy_avgt_i_y] = gradient(Pij_i_xy_avgt_i);
[Pij_i_xz_avgt_i_z, Pij_i_xz_avgt_i_y] = gradient(Pij_i_xz_avgt_i);
[Pij_i_yz_avgt_i_z, Pij_i_yz_avgt_i_y] = gradient(Pij_i_yz_avgt_i);
%----------------------------------------------------------------------
%----------------------------------------------------------------------
Div_Pi_avgt_i_x = Pij_i_xy_avgt_i_y/resy + Pij_i_xz_avgt_i_z/resz;
Div_Pi_avgt_i_y = Pij_i_yy_avgt_i_y/resy + Pij_i_yz_avgt_i_z/resz;
Div_Pi_avgt_i_z = Pij_i_yz_avgt_i_y/resy + Pij_i_zz_avgt_i_z/resz;
%----------------------------------------------------------------------

%Grad_Pe
%----------------------------------------------------------------------
[Pij_e_xx_avgt_i_z, Pij_e_xx_avgt_i_y] = gradient(Pij_e_xx_avgt_i);
[Pij_e_yy_avgt_i_z, Pij_e_yy_avgt_i_y] = gradient(Pij_e_yy_avgt_i);
[Pij_e_zz_avgt_i_z, Pij_e_zz_avgt_i_y] = gradient(Pij_e_zz_avgt_i);
[Pij_e_xy_avgt_i_z, Pij_e_xy_avgt_i_y] = gradient(Pij_e_xy_avgt_i);
[Pij_e_xz_avgt_i_z, Pij_e_xz_avgt_i_y] = gradient(Pij_e_xz_avgt_i);
[Pij_e_yz_avgt_i_z, Pij_e_yz_avgt_i_y] = gradient(Pij_e_yz_avgt_i);
%----------------------------------------------------------------------
%----------------------------------------------------------------------
Div_Pe_x_avgt_i = Pij_e_xy_avgt_i_y/resy + Pij_e_xz_avgt_i_z/resz;
Div_Pe_y_avgt_i = Pij_e_yy_avgt_i_y/resy + Pij_e_yz_avgt_i_z/resz;
Div_Pe_z_avgt_i = Pij_e_yz_avgt_i_y/resy + Pij_e_zz_avgt_i_z/resz;
%----------------------------------------------------------------------

%Grad_nivi_vi
%----------------------------------------------------------------------
[nivi_vi_avg_xx_i_z, nivi_vi_avg_xx_i_y] = gradient(nivi_vi_avg_xx_i);
[nivi_vi_avg_xy_i_z, nivi_vi_avg_xy_i_y] = gradient(nivi_vi_avg_xy_i);
[nivi_vi_avg_xz_i_z, nivi_vi_avg_xz_i_y] = gradient(nivi_vi_avg_xz_i);
[nivi_vi_avg_yy_i_z, nivi_vi_avg_yy_i_y] = gradient(nivi_vi_avg_yy_i);
[nivi_vi_avg_yz_i_z, nivi_vi_avg_yz_i_y] = gradient(nivi_vi_avg_yz_i);
[nivi_vi_avg_zz_i_z, nivi_vi_avg_zz_i_y] = gradient(nivi_vi_avg_zz_i);
%----------------------------------------------------------------------
%----------------------------------------------------------------------
Div_nivi_vi_avg_i_x = (nivi_vi_avg_xy_i_y/resy + nivi_vi_avg_xz_i_z/resz);
Div_nivi_vi_avg_i_y = (nivi_vi_avg_yy_i_y/resy + nivi_vi_avg_yz_i_z/resz);
Div_nivi_vi_avg_i_z = (nivi_vi_avg_yz_i_y/resy + nivi_vi_avg_zz_i_z/resz);
%----------------------------------------------------------------------

%Grad_neve_ve
%----------------------------------------------------------------------
[neve_ve_avg_xx_i_z, neve_ve_avg_xx_i_y] = gradient(neve_ve_avg_xx_i);
[neve_ve_avg_xy_i_z, neve_ve_avg_xy_i_y] = gradient(neve_ve_avg_xy_i);
[neve_ve_avg_xz_i_z, neve_ve_avg_xz_i_y] = gradient(neve_ve_avg_xz_i);
[neve_ve_avg_yy_i_z, neve_ve_avg_yy_i_y] = gradient(neve_ve_avg_yy_i);
[neve_ve_avg_yz_i_z, neve_ve_avg_yz_i_y] = gradient(neve_ve_avg_yz_i);
[neve_ve_avg_zz_i_z, neve_ve_avg_zz_i_y] = gradient(neve_ve_avg_zz_i);
%----------------------------------------------------------------------
%----------------------------------------------------------------------
Div_neve_ve_avg_i_x = (neve_ve_avg_xy_i_y/resy + neve_ve_avg_xz_i_z/resz);
Div_neve_ve_avg_i_y = (neve_ve_avg_yy_i_y/resy + neve_ve_avg_yz_i_z/resz);
Div_neve_ve_avg_i_z = (neve_ve_avg_yz_i_y/resy + neve_ve_avg_zz_i_z/resz);
%----------------------------------------------------------------------

%Grad_nv_v
%----------------------------------------------------------------------
[nv_v_avg_xx_i_z, nv_v_avg_xx_i_y] = gradient(nv_v_avg_xx_i);
[nv_v_avg_xy_i_z, nv_v_avg_xy_i_y] = gradient(nv_v_avg_xy_i);
[nv_v_avg_xz_i_z, nv_v_avg_xz_i_y] = gradient(nv_v_avg_xz_i);
[nv_v_avg_yy_i_z, nv_v_avg_yy_i_y] = gradient(nv_v_avg_yy_i);
[nv_v_avg_yz_i_z, nv_v_avg_yz_i_y] = gradient(nv_v_avg_yz_i);
[nv_v_avg_zz_i_z, nv_v_avg_zz_i_y] = gradient(nv_v_avg_zz_i);
%----------------------------------------------------------------------
%----------------------------------------------------------------------
Div_nv_v_avg_i_x = (nv_v_avg_xy_i_y/resy + nv_v_avg_xz_i_z/resz);
Div_nv_v_avg_i_y = (nv_v_avg_yy_i_y/resy + nv_v_avg_yz_i_z/resz);
Div_nv_v_avg_i_z = (nv_v_avg_yz_i_y/resy + nv_v_avg_zz_i_z/resz);
%----------------------------------------------------------------------

%Grad_del_nivi_del_vi
%----------------------------------------------------------------------
[del_nivi_del_vi_avg_xx_z, del_nivi_del_vi_avg_xx_y] = gradient(del_nivi_del_vi_avg_xx);
[del_nivi_del_vi_avg_xy_z, del_nivi_del_vi_avg_xy_y] = gradient(del_nivi_del_vi_avg_xy);
[del_nivi_del_vi_avg_xz_z, del_nivi_del_vi_avg_xz_y] = gradient(del_nivi_del_vi_avg_xz);
[del_nivi_del_vi_avg_yy_z, del_nivi_del_vi_avg_yy_y] = gradient(del_nivi_del_vi_avg_yy);
[del_nivi_del_vi_avg_yz_z, del_nivi_del_vi_avg_yz_y] = gradient(del_nivi_del_vi_avg_yz);
[del_nivi_del_vi_avg_zz_z, del_nivi_del_vi_avg_zz_y] = gradient(del_nivi_del_vi_avg_zz);
%----------------------------------------------------------------------
%----------------------------------------------------------------------
Div_del_nivi_del_vi_avg_x = (del_nivi_del_vi_avg_xy_y/resy + del_nivi_del_vi_avg_xz_z/resz);
Div_del_nivi_del_vi_avg_y = (del_nivi_del_vi_avg_yy_y/resy + del_nivi_del_vi_avg_yz_z/resz);
Div_del_nivi_del_vi_avg_z = (del_nivi_del_vi_avg_yz_y/resy + del_nivi_del_vi_avg_zz_z/resz);
%----------------------------------------------------------------------

%Grad_del_neve_del_ve
%----------------------------------------------------------------------
[del_neve_del_ve_avg_xx_z, del_neve_del_ve_avg_xx_y] = gradient(del_neve_del_ve_avg_xx);
[del_neve_del_ve_avg_xy_z, del_neve_del_ve_avg_xy_y] = gradient(del_neve_del_ve_avg_xy);
[del_neve_del_ve_avg_xz_z, del_neve_del_ve_avg_xz_y] = gradient(del_neve_del_ve_avg_xz);
[del_neve_del_ve_avg_yy_z, del_neve_del_ve_avg_yy_y] = gradient(del_neve_del_ve_avg_yy);
[del_neve_del_ve_avg_yz_z, del_neve_del_ve_avg_yz_y] = gradient(del_neve_del_ve_avg_yz);
[del_neve_del_ve_avg_zz_z, del_neve_del_ve_avg_zz_y] = gradient(del_neve_del_ve_avg_zz);
%----------------------------------------------------------------------
%----------------------------------------------------------------------
Div_del_neve_del_ve_avg_x = (del_neve_del_ve_avg_xy_y/resy + del_neve_del_ve_avg_xz_z/resz);
Div_del_neve_del_ve_avg_y = (del_neve_del_ve_avg_yy_y/resy + del_neve_del_ve_avg_yz_z/resz);
Div_del_neve_del_ve_avg_z = (del_neve_del_ve_avg_yz_y/resy + del_neve_del_ve_avg_zz_z/resz);
%----------------------------------------------------------------------

%Grad_del_nv_del_v
%----------------------------------------------------------------------
[del_nv_del_v_avg_xx_z, del_nv_del_v_avg_xx_y] = gradient(del_nv_del_v_avg_xx);
[del_nv_del_v_avg_xy_z, del_nv_del_v_avg_xy_y] = gradient(del_nv_del_v_avg_xy);
[del_nv_del_v_avg_xz_z, del_nv_del_v_avg_xz_y] = gradient(del_nv_del_v_avg_xz);
[del_nv_del_v_avg_yy_z, del_nv_del_v_avg_yy_y] = gradient(del_nv_del_v_avg_yy);
[del_nv_del_v_avg_yz_z, del_nv_del_v_avg_yz_y] = gradient(del_nv_del_v_avg_yz);
[del_nv_del_v_avg_zz_z, del_nv_del_v_avg_zz_y] = gradient(del_nv_del_v_avg_zz);
%----------------------------------------------------------------------
%----------------------------------------------------------------------
Div_del_nv_del_v_avg_x = (del_nv_del_v_avg_xy_y/resy + del_nv_del_v_avg_xz_z/resz);
Div_del_nv_del_v_avg_y = (del_nv_del_v_avg_yy_y/resy + del_nv_del_v_avg_yz_z/resz);
Div_del_nv_del_v_avg_z = (del_nv_del_v_avg_yz_y/resy + del_nv_del_v_avg_zz_z/resz);
%----------------------------------------------------------------------

% How to compute the derivative of m ave(nu)? what should be the interval 
% % computing the time derivative of J
% %----------------------------------------------------------------------
% dJxdt_avgt_i = DUM;
% dJydt_avgt_i = DUM;
% dJzdt_avgt_i = DUM;
% %----------------------------------------------------------------------
% for ii=1:j_a_b
%     dJxdt_s = J_in{1,ii+1} - J_in{1,ii};
%     dJxdt_avgt_o = dJxdt_avgt_i + dJxdt_s; dJxdt_avgt_i = dJxdt_avgt_o;
% 
%     dJydt_s = J_in{2,ii+1} - J_in{2,ii};
%     dJydt_avgt_o = dJydt_avgt_i + dJydt_s; dJydt_avgt_i = dJydt_avgt_o;
% 
%     dJzdt_s = J_in{3,ii+1} - J_in{3,ii};
%     dJzdt_avgt_o = dJzdt_avgt_i + dJzdt_s; dJzdt_avgt_i = dJzdt_avgt_o;
% end
% clearvars *_o
% %----------------------------------------------------------------------


%----------------------------------------------------------------------
% So far everything is working. The del_* and *_i are all time averaged quantities. 
%----------------------------------------------------------------------


% compute the different terms from Drift A Le with the averages
%----------------------------------------------------------------------
%en(E+uxB) = part_d(mnu)/partt + m Div(nu u) + Div(P) - edndE - e (dnuxB) + m div(d(nu) du)
%----------------------------------------------------------------------

% Making the Plots for electrons
%----------------------------------------------------------------------
%xlim_a = 1; xlim_b = ssz(1,3);
%ylim_a = 1; ylim_b = ssz(1,2);

sss=size(Bx_avgt_i);
size_X=sss;
zll=linspace(-Lz,Lz,size_X(2)); %Jeff flag it works with (1,size_x(2))
yll=linspace(-Ly,Ly,size_X(1));
[ZLL, YLL] = meshgrid(zll,yll);

yticks_mine=[floor(-Ly*0.9) floor(-Ly/2) 0 floor(Ly/2) floor(Ly*0.9)];
zticks_mine=[floor(-Lz*0.9) floor(-Lz/2) 0 floor(Lz/2) floor(Lz*0.9)];

xlim_a = zll(704); xlim_b = zll(1104);
ylim_a = yll(454); ylim_b = yll(571);

xlim_a = -4; xlim_b = 4;
ylim_a = -4; ylim_b = 4;

lw=2;

% % This is to show that the gradients are correct! <----
% %------------------------------------------------------------------------
% f1=figure(1)
% subplot(1,3,1)
% dump = sin(0.1*YLL);
% hc=pcolor(ZLL,YLL,dump);
% hold on
% set(hc,'edgecolor','none')
% colorbar; title('sin'); %xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
% xlabel('z/d_i'); ylabel('y/d_i');
% xline(zll(sli_z),'--k','LineWidth',lw);
% hold off
% subplot(1,3,2)
% dump = cos(0.1*YLL);
% hc=pcolor(ZLL,YLL,dump);
% hold on
% set(hc,'edgecolor','none')
% colorbar; title('cos_t'); %xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
% xlabel('z/d_i'); ylabel('y/d_i');
% xline(zll(sli_z),'--k','LineWidth',lw);
% hold off
% [coss_z, coss_y] = gradient(sin(0.1*YLL));  
% subplot(1,3,3)
% dump = coss_y;
% hc=pcolor(ZLL,YLL,dump);
% hold on
% set(hc,'edgecolor','none')
% colorbar; title('cos_co'); %xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
% xlabel('z/d_i'); ylabel('y/d_i');
% xline(zll(sli_z),'--k','LineWidth',lw);
% hold off
% %------------------------------------------------------------------------

% In this plot I still need to include the time derivative.
sli_y = 512; %floor(4+ssz(2)/2);%380;
sli_z = 1024; %floor(2+ssz(3)/2);%700;

fs=18;
%--------------------------------------------------------------------------
f1=figure(1);
dum_1 = n_e_avgt_i .*(Ex_avgt_i(:,sli_z) + vexB_avgt_x_i(:,sli_z)); 
plot(yll,dum_1(:,sli_z),'k','LineWidth',lw);
hold on
dum_2 = Div_neve_ve_avg_i_x;
plot(yll,dum_2(:,sli_z),'r','LineWidth',lw);
dum_3 = Div_Pe_x_avgt_i; 
plot(yll,dum_3(:,sli_z),'b','LineWidth',lw);
dum_4 = -del_n_e_del_Ex; 
plot(yll,dum_4(:,sli_z),'m','LineWidth',lw);
dum_5 = -del_nevex_del_dB_x; 
plot(yll,dum_5(:,sli_z),'c','LineWidth',lw);
dum_6 = Div_del_neve_del_ve_avg_x ; 
plot(yll,dum_6(:,sli_z),'g','LineWidth',lw);
xlim([ylim_a, ylim_b]); xlabel('y/d_i')
legend({'$en_{e}(E_{x} + (v_{e}\times B)_{x}$',...
        '$(m\nabla \cdot (n_{e}v_{e}v_{e})_{x}$',...
        '$(\nabla \cdot P_{e})_{x}$',...
        '$-e(\delta n_{e} \delta E)_{x}$',...
        '$-e(\delta n_{e}v_{e} \times \delta B)_{x}$',...
        '$m(\nabla \cdot (\delta n_{e}v_{e} \delta v_{e}))_{x}$',...
        },'Interpreter','latex','FontSize',fs,...
        'Location','southwest','NumColumns',2)
hold off
%--------------------------------------------------------------------------



f2=figure(2)
 subplot(1,2,1)
 plot(yll,Ex_avgt_i(:,sli_z),'b','LineWidth',lw);
 %xlim([ylim_a, ylim_b]); 
 xlabel('y/d_i')
 subplot(1,2,2)
dump = Ex_avgt_i;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
colorbar; title('J_x'); 
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
xlabel('z/d_i'); ylabel('y/d_i');
xline(zll(sli_z),'--k','LineWidth',lw);
hold off





