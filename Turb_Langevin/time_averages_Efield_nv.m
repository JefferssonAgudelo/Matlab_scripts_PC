% Computing the time average quantities for the reconnecion electric field.

% This is for the localization study
%--------------------------------------------------------------------------
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_many_Ax_large_L8di_dB01_Omc1_kLd1_local_3';
%--------------------------------------------------------------------------

path_1 = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_short_L1di';


% Factors to change along this file depending on the case
%----------------------------------------------------------------------
% Try smoothing the variables before comuping any further.
% IT IS IMPORTANT TO KEEP THIS IN MIND AT ALL TIMES!!!
%----------------------------------------------------------------------
sigma_g=5; % this is for the smoothing. This gets read of fast frequencies
grad_fact=2;
dab = 1; % this needs to be related to the gyro frequency or something
mime = 1.;
frac=0.8;


%JN=7;
%JN=180;
%JN=25;
%JN=2;
JN=40;
%JN=90;
%----------------------------------------------------------------------

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
%
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

jn=JN;
jjn=4;

j_a = JN - dab;
j_b = JN + dab;
j_a_b = j_b - j_a;

%--------------------------------------------------------------------------
E_in = cell(3,j_a_b);
B_in = cell(3,j_a_b);
J_in = cell(3,j_a_b);
n_in = cell(3,j_a_b);
nv_i_in = cell(3,j_a_b);
nv_e_in = cell(3,j_a_b);
v_in = cell(3,j_a_b);
nPij_i_in = cell(6,j_a_b);
nPij_e_in = cell(6,j_a_b);

ni_vi_x_B_in = cell(3,j_a_b);
ne_ve_x_B_in = cell(3,j_a_b);

nni_vivi_in = cell(6,j_a_b);
nne_veve_in = cell(6,j_a_b);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
for jn=j_a:j_b
    %for jn=1:N
    %----------------------------------------------------------------------
    % % % % % % for the fields % I don't understand why I used it like this
    % % % % % in=jn;
    % % % % % %for the momments
    % % % % % jjn=jn-j_a+1;
    in = jn;
    jjn = jn;
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

    % This are actually n*p and not p along
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
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    p_e{1,1}=(p_e_up{1,1} + p_e_ba{1,1})./1;
    p_e{1,2}=(p_e_up{1,2} + p_e_ba{1,2})./1;
    p_e{1,3}=(p_e_up{1,3} + p_e_ba{1,3})./1;

    p_i{1,1}=(p_i_up{1,1} + p_i_ba{1,1})./1;
    p_i{1,2}=(p_i_up{1,2} + p_i_ba{1,2})./1;
    p_i{1,3}=(p_i_up{1,3} + p_i_ba{1,3})./1;
    %----------------------------------------------------------------------

    %clearvars p_i_up p_e_up p_i_ba p_e_ba
    %----------------------------------------------------------------------

    % computing the velocities in units of c
    %----------------------------------------------------------------------
    nv_e=cell(1,3);
    nv_i=cell(1,3);
    nv_e_ba=cell(1,3);
    nv_i_ba=cell(1,3);
    nv_e_up=cell(1,3);
    nv_i_up=cell(1,3);

    for i=1:3
        nv_e{1,i} = (p_e{1,i} .* c ./ sqrt(c^2 .* me^2 .* n_e{1,1}.^2 + p_e{1,i}.^2))./1; % Do I need to do this normalization by VA2c
        nv_i{1,i} = (p_i{1,i} .* c ./ sqrt(c^2 .* mi^2 .* n_i{1,1}.^2  + p_i{1,i}.^2))./1;
        nv_e_up{1,i} = (p_e_up{1,i} .* c ./ sqrt(c^2 .* me^2 .* n_e_up{1,1}.^2 + p_e_up{1,i}.^2))./1;
        nv_i_up{1,i} = (p_i_up{1,i} .* c ./ sqrt(c^2 .* mi^2 .* n_i_up{1,1}.^2 + p_i_up{1,i}.^2))./1;
        nv_e_ba{1,i} = (p_e_ba{1,i} .* c ./ sqrt(c^2 .* me^2 .* n_e_ba{1,1}.^2 + p_e_ba{1,i}.^2))./1;
        nv_i_ba{1,i} = (p_i_ba{1,i} .* c ./ sqrt(c^2 .* mi^2 .* n_i_ba{1,1}.^2 + p_i_ba{1,i}.^2))./1;
    end


    clearvars p_i p_e p_i_up p_e_up p_i_ba p_e_ba
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    nv_ex = nv_e{1,1}; nv_ex = squeeze(nv_ex(sli_x,:,:));
    nv_ey = nv_e{1,2}; nv_ey = squeeze(nv_ey(sli_x,:,:));
    nv_ez = nv_e{1,3}; nv_ez = squeeze(nv_ez(sli_x,:,:));

    nv_e_upx = nv_e_up{1,1}; nv_e_upx = squeeze(nv_e_upx(sli_x,:,:));
    nv_e_upy = nv_e_up{1,2}; nv_e_upy = squeeze(nv_e_upy(sli_x,:,:));
    nv_e_upz = nv_e_up{1,3}; nv_e_upz = squeeze(nv_e_upz(sli_x,:,:));

    nv_e_bax = nv_e_ba{1,1}; nv_e_bax = squeeze(nv_e_bax(sli_x,:,:));
    nv_e_bay = nv_e_ba{1,2}; nv_e_bay = squeeze(nv_e_bay(sli_x,:,:));
    nv_e_baz = nv_e_ba{1,3}; nv_e_baz = squeeze(nv_e_baz(sli_x,:,:));

    nv_ix = nv_i{1,1}; nv_ix = squeeze(nv_ix(sli_x,:,:));
    nv_iy = nv_i{1,2}; nv_iy = squeeze(nv_iy(sli_x,:,:));
    nv_iz = nv_i{1,3}; nv_iz = squeeze(nv_iz(sli_x,:,:));

    nv_i_upx = nv_i_up{1,1}; nv_i_upx = squeeze(nv_i_upx(sli_x,:,:));
    nv_i_upy = nv_i_up{1,2}; nv_i_upy = squeeze(nv_i_upy(sli_x,:,:));
    nv_i_upz = nv_i_up{1,3}; nv_i_upz = squeeze(nv_i_upz(sli_x,:,:));

    nv_i_bax = nv_i_ba{1,1}; nv_i_bax = squeeze(nv_i_bax(sli_x,:,:));
    nv_i_bay = nv_i_ba{1,2}; nv_i_bay = squeeze(nv_i_bay(sli_x,:,:));
    nv_i_baz = nv_i_ba{1,3}; nv_i_baz = squeeze(nv_i_baz(sli_x,:,:));

    %clearvars v_i_up v_e_up v_i_ba v_e_ba %<----
    %---------------------------------------------------------------------


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
    nPPij_i_ba=cell(3,3);
    nPPij_e_ba=cell(3,3);
    nPPij_i_up=cell(3,3);
    nPPij_e_up=cell(3,3);

    for i=1:3
        for j=1:3
            if(isempty(Pij_i_ba{i,j}) == 1) % This is where if P_ba is zero, this should be changed.
                continue
            end
            nPPij_i_ba{i,j} = Pij_i_ba{i,j}.*n_i_ba{1,1} - mi.*nv_i_ba{1,i}.^2; 
            nPPij_e_ba{i,j} = Pij_e_ba{i,j}.*n_e_ba{1,1} - me.*nv_e_ba{1,i}.^2;
            nPPij_i_up{i,j} = Pij_i_up{i,j}.*n_i_up{1,1} - mi.*nv_i_up{1,i}.^2;
            nPPij_e_up{i,j} = Pij_e_up{i,j}.*n_e_up{1,1} - me.*nv_e_up{1,i}.^2;
        end
    end

    clearvars Pij_e_up Pij_i_up Pij_e_ba Pij_i_ba 

    % This is just to rename the variable
    nPij_i_ba = nPPij_i_ba;
    nPij_e_ba = nPPij_e_ba;
    nPij_i_up = nPPij_i_up;
    nPij_e_up = nPPij_e_up;

    clearvars v_i_up v_e_up v_i_ba v_e_ba %<----
    clearvars Txx_e_ba Txx_e_up Tyy_e_ba Tyy_e_up Tzz_e_ba Tzz_e_up
    clearvars Txy_e_ba Txy_e_up Txz_e_ba Txz_e_up Tyz_e_ba Tyz_e_up
    clearvars Txx_i_ba Txx_i_up Tyy_i_ba Tyy_i_up Tzz_i_ba Tzz_i_up
    clearvars Txy_i_ba Txy_i_up Txz_i_ba Txz_i_up Tyz_i_ba Tyz_i_up
    clearvars nPPij_i nPPij_e

    %----------------------------------------------------------------------
    n_i = n_i{1,1}; n_i = squeeze(n_i(sli_x,:,:));
    n_e = n_e{1,1}; n_e = squeeze(n_e(sli_x,:,:));

    nPij_i_xx =  nPij_i_ba{1,1} +  nPij_i_up{1,1}; nPij_i_xx = squeeze(nPij_i_xx(sli_x,:,:));
    nPij_i_xy =  nPij_i_ba{1,2} +  nPij_i_up{1,2}; nPij_i_xy = squeeze(nPij_i_xy(sli_x,:,:));
    nPij_i_xz =  nPij_i_ba{1,3} +  nPij_i_up{1,3}; nPij_i_xz = squeeze(nPij_i_xz(sli_x,:,:));
    nPij_i_yy =  nPij_i_ba{2,2} +  nPij_i_up{2,2}; nPij_i_yy = squeeze(nPij_i_yy(sli_x,:,:));
    nPij_i_yz =  nPij_i_ba{2,3} +  nPij_i_up{2,3}; nPij_i_yz = squeeze(nPij_i_yz(sli_x,:,:));
    nPij_i_zz =  nPij_i_ba{3,3} +  nPij_i_up{3,3}; nPij_i_zz = squeeze(nPij_i_zz(sli_x,:,:));

    nPij_e_xx =  nPij_e_ba{1,1} +  nPij_e_up{1,1}; nPij_e_xx = squeeze(nPij_e_xx(sli_x,:,:));
    nPij_e_xy =  nPij_e_ba{1,2} +  nPij_e_up{1,2}; nPij_e_xy = squeeze(nPij_e_xy(sli_x,:,:));
    nPij_e_xz =  nPij_e_ba{1,3} +  nPij_e_up{1,3}; nPij_e_xz = squeeze(nPij_e_xz(sli_x,:,:));
    nPij_e_yy =  nPij_e_ba{2,2} +  nPij_e_up{2,2}; nPij_e_yy = squeeze(nPij_e_yy(sli_x,:,:));
    nPij_e_yz =  nPij_e_ba{2,3} +  nPij_e_up{2,3}; nPij_e_yz = squeeze(nPij_e_yz(sli_x,:,:));
    nPij_e_zz =  nPij_e_ba{3,3} +  nPij_e_up{3,3}; nPij_e_zz = squeeze(nPij_e_zz(sli_x,:,:));

    clearvars v_i_up v_e_up v_i_ba v_e_ba v_i v_e
    clearvars Pij_i Pij_e
    clearvars Pij_e_ba Pij_e_up  Pij_i_ba Pij_i_up
    %----------------------------------------------------------------------


    % Save the data for the time average
    %----------------------------------------------------------------------
    inn=(jn - j_a +1); % This has to be properly set to compute this for every time.
    % This fills in the array of values for the window moving with the central
    % value


    % % There is a nan problem
    % %----------------------------------------------------------------------   
    % Ex(isnan(Ex)) = 0;
    % Ey(isnan(Ey)) = 0;
    % Ez(isnan(Ez)) = 0;
    % 
    % Bx(isnan(Bx)) = 0;
    % By(isnan(By)) = 0;
    % Bz(isnan(Bz)) = 0;
    % 
    % Jx(isnan(Jx)) = 0;
    % Jy(isnan(Jy)) = 0;
    % Jz(isnan(Jz)) = 0;
    % 
    % n_e(isnan(n_e)) = 0;    
    % n_i(isnan(n_i)) = 0;
    % 
    % v_ix(isnan(v_ix)) = 0;
    % v_iy(isnan(v_iy)) = 0;
    % v_iz(isnan(v_iz)) = 0;
    % 
    % v_ex(isnan(v_ex)) = 0;
    % v_ey(isnan(v_ey)) = 0;
    % v_ez(isnan(v_ez)) = 0;
    % 
    % Pij_i_xx(isnan(Pij_i_xx)) = 0;
    % Pij_i_xy(isnan(Pij_i_xy)) = 0;
    % Pij_i_xz(isnan(Pij_i_xz)) = 0;
    % Pij_i_yy(isnan(Pij_i_yy)) = 0;
    % Pij_i_yz(isnan(Pij_i_yz)) = 0;
    % Pij_i_zz(isnan(Pij_i_zz)) = 0;
    % 
    % Pij_e_xx(isnan(Pij_e_xx)) = 0;
    % Pij_e_xy(isnan(Pij_e_xy)) = 0;
    % Pij_e_xz(isnan(Pij_e_xz)) = 0;
    % Pij_e_yy(isnan(Pij_e_yy)) = 0;
    % Pij_e_yz(isnan(Pij_e_yz)) = 0;
    % Pij_e_zz(isnan(Pij_e_zz)) = 0;
    % %----------------------------------------------------------------------

    % The composed quiantities
    %----------------------------------------------------------------------
    % velocity MHD
    % v_x(isnan(v_x)) = 0;
    % v_y(isnan(v_y)) = 0;
    % v_z(isnan(v_z)) = 0;
    % n(isnan(n)) = 0;
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    E_in{1,inn} = imgaussfilt(Ex ,sigma_g);
    E_in{2,inn} = imgaussfilt(Ey ,sigma_g);
    E_in{3,inn} = imgaussfilt(Ez ,sigma_g);

    B_in{1,inn} = imgaussfilt(Bx ,sigma_g);
    B_in{2,inn} = imgaussfilt(By ,sigma_g);
    B_in{3,inn} = imgaussfilt(Bz ,sigma_g);

    J_in{1,inn} = imgaussfilt(Jx ,sigma_g);
    J_in{2,inn} = imgaussfilt(Jy ,sigma_g);
    J_in{3,inn} = imgaussfilt(Jz ,sigma_g);

    n_in{1,inn} = imgaussfilt(n_e ,sigma_g);
    n_in{2,inn} = imgaussfilt(n_i ,sigma_g);

    nv_i_in{1,inn} = imgaussfilt(nv_ix ,sigma_g);
    nv_i_in{2,inn} = imgaussfilt(nv_iy ,sigma_g);
    nv_i_in{3,inn} = imgaussfilt(nv_iz ,sigma_g);

    nv_e_in{1,inn} = imgaussfilt(nv_ex ,sigma_g);
    nv_e_in{2,inn} = imgaussfilt(nv_ey ,sigma_g);
    nv_e_in{3,inn} = imgaussfilt(nv_ez ,sigma_g);

    nPij_i_in{1,inn} = imgaussfilt(nPij_i_xx ,sigma_g);
    nPij_i_in{2,inn} = imgaussfilt(nPij_i_xy ,sigma_g);
    nPij_i_in{3,inn} = imgaussfilt(nPij_i_xz ,sigma_g);
    nPij_i_in{4,inn} = imgaussfilt(nPij_i_yy ,sigma_g);
    nPij_i_in{5,inn} = imgaussfilt(nPij_i_yz ,sigma_g);
    nPij_i_in{6,inn} = imgaussfilt(nPij_i_zz ,sigma_g);

    nPij_e_in{1,inn} = imgaussfilt(nPij_e_xx ,sigma_g);
    nPij_e_in{2,inn} = imgaussfilt(nPij_e_xy ,sigma_g);
    nPij_e_in{3,inn} = imgaussfilt(nPij_e_xz ,sigma_g);
    nPij_e_in{4,inn} = imgaussfilt(nPij_e_yy ,sigma_g);
    nPij_e_in{5,inn} = imgaussfilt(nPij_e_yz ,sigma_g);
    nPij_e_in{6,inn} = imgaussfilt(nPij_e_zz ,sigma_g);

    %----------------------------------------------------------------------

    % n_s_u_s_x_B
    %--------------------------------------------------------------------------
    ni_vi_x_B_in{1,inn} = imgaussfilt((nv_iy.* Bz - nv_iz.* By) ,sigma_g);
    ni_vi_x_B_in{2,inn} = imgaussfilt((nv_iz.* Bx - nv_ix.* Bz) ,sigma_g);
    ni_vi_x_B_in{3,inn} = imgaussfilt((nv_ix.* By - nv_iy.* Bx) ,sigma_g);

    ne_ve_x_B_in{1,inn} = imgaussfilt((nv_ey.* Bz - nv_ez.* By) ,sigma_g);
    ne_ve_x_B_in{2,inn} = imgaussfilt((nv_ez.* Bx - nv_ex.* Bz) ,sigma_g);
    ne_ve_x_B_in{3,inn} = imgaussfilt((nv_ex.* By - nv_ey.* Bx) ,sigma_g);
    %--------------------------------------------------------------------------

    %tensor product of the averages (nU)_ave U_ave
    %--------------------------------------------------------------------------
    nni_vivi_in{1,inn} = imgaussfilt((nv_ix .* nv_ix) ,sigma_g);
    nni_vivi_in{2,inn} = imgaussfilt((nv_ix .* nv_iy) ,sigma_g);
    nni_vivi_in{3,inn} = imgaussfilt((nv_ix .* nv_iz) ,sigma_g);
    nni_vivi_in{4,inn} = imgaussfilt((nv_iy .* nv_iy) ,sigma_g);
    nni_vivi_in{5,inn} = imgaussfilt((nv_iy .* nv_iz) ,sigma_g);
    nni_vivi_in{6,inn} = imgaussfilt((nv_iz .* nv_iz) ,sigma_g);

    nne_veve_in{1,inn} = imgaussfilt((nv_ex .* nv_ex) ,sigma_g);
    nne_veve_in{2,inn} = imgaussfilt((nv_ex .* nv_ey) ,sigma_g);
    nne_veve_in{3,inn} = imgaussfilt((nv_ex .* nv_ez) ,sigma_g);
    nne_veve_in{4,inn} = imgaussfilt((nv_ey .* nv_ey) ,sigma_g);
    nne_veve_in{5,inn} = imgaussfilt((nv_ey .* nv_ez) ,sigma_g);
    nne_veve_in{6,inn} = imgaussfilt((nv_ez .* nv_ez) ,sigma_g);
    %----------------------------------------------------------------------


    %----------------------------------------------------------------------
    clearvars Ex Ey Ez Bx By Bz Jx Jy Jz n_i n_e n_i_up n_i_ba n_e_up n_e_ba
    clearvars nv_ix nv_iy nv_iz nv_ex nv_ey nv_ez 
    clearvars nPij_e_xx nPij_e_xy nPij_e_xz nPij_e_yy nPij_e_yz nPij_e_zz
    clearvars nPij_i_xx nPij_i_xy nPij_i_xz nPij_i_yy nPij_i_yz nPij_i_zz
    %----------------------------------------------------------------------

end

%Consolidate the averages in time

% setting the initial values to zero
%----------------------------------------------------------------------
DUM = 0.*E_in{1,1};

[Ex_avgt_i, Ey_avgt_i, Ez_avgt_i,...
    Bx_avgt_i, By_avgt_i, Bz_avgt_i,...
    Jx_avgt_i, Jy_avgt_i, Jz_avgt_i] = deal(DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM);

[n_e_avgt_i, n_i_avgt_i] = deal(DUM,DUM);

[nv_ix_avgt_i, nv_iy_avgt_i, nv_iz_avgt_i,...
    nv_ex_avgt_i, nv_ey_avgt_i, nv_ez_avgt_i,...
    ] = deal(DUM,DUM,DUM,DUM,DUM,DUM);

[nPij_i_xx_avgt_i, nPij_i_xy_avgt_i, nPij_i_xz_avgt_i,...
    nPij_i_yy_avgt_i, nPij_i_yz_avgt_i, nPij_i_zz_avgt_i] = deal(DUM,DUM,DUM,DUM,DUM,DUM);

[nPij_e_xx_avgt_i, nPij_e_xy_avgt_i, nPij_e_xz_avgt_i,...
    nPij_e_yy_avgt_i, nPij_e_yz_avgt_i, nPij_e_zz_avgt_i] = deal(DUM,DUM,DUM,DUM,DUM,DUM);


[ni_vi_x_Bx_avgt_i, ni_vi_x_By_avgt_i, ni_vi_x_Bz_avgt_i,...
    ne_ve_x_Bx_avgt_i, ne_ve_x_By_avgt_i, ne_ve_x_Bz_avgt_i,...
    ] = deal(DUM,DUM,DUM,DUM,DUM,DUM);

[nni_vivi_xx_avgt_i, nni_vivi_xy_avgt_i, nni_vivi_xz_avgt_i, nni_vivi_yy_avgt_i, nni_vivi_yz_avgt_i, nni_vivi_zz_avgt_i, ...
    nne_veve_xx_avgt_i, nne_veve_xy_avgt_i, nne_veve_xz_avgt_i, nne_veve_yy_avgt_i, nne_veve_yz_avgt_i, nne_veve_zz_avgt_i, ...
    ] = ...
    deal(DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
nu_av=j_a_b+1; % this is for the average
%----------------------------------------------------------------------

% Compute the sums for the averages
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

    nv_ix_avgt_o = nv_i_in{1,ii} + nv_ix_avgt_i ; nv_ix_avgt_i = nv_ix_avgt_o;
    nv_iy_avgt_o = nv_i_in{2,ii} + nv_iy_avgt_i ; nv_iy_avgt_i = nv_iy_avgt_o;
    nv_iz_avgt_o = nv_i_in{3,ii} + nv_iz_avgt_i ; nv_iz_avgt_i = nv_iz_avgt_o;

    nv_ex_avgt_o = nv_e_in{1,ii} + nv_ex_avgt_i ; nv_ex_avgt_i = nv_ex_avgt_o;
    nv_ey_avgt_o = nv_e_in{2,ii} + nv_ey_avgt_i ; nv_ey_avgt_i = nv_ey_avgt_o;
    nv_ez_avgt_o = nv_e_in{3,ii} + nv_ez_avgt_i ; nv_ez_avgt_i = nv_ez_avgt_o;

    nPij_i_xx_avgt_o = nPij_i_in{1,ii} + nPij_i_xx_avgt_i ; nPij_i_xx_avgt_i = nPij_i_xx_avgt_o;
    nPij_i_xy_avgt_o = nPij_i_in{2,ii} + nPij_i_xy_avgt_i ; nPij_i_xy_avgt_i = nPij_i_xy_avgt_o;
    nPij_i_xz_avgt_o = nPij_i_in{3,ii} + nPij_i_xz_avgt_i ; nPij_i_xz_avgt_i = nPij_i_xz_avgt_o;
    nPij_i_yy_avgt_o = nPij_i_in{4,ii} + nPij_i_yy_avgt_i ; nPij_i_yy_avgt_i = nPij_i_yy_avgt_o;
    nPij_i_yz_avgt_o = nPij_i_in{5,ii} + nPij_i_yz_avgt_i ; nPij_i_yz_avgt_i = nPij_i_yz_avgt_o;
    nPij_i_zz_avgt_o = nPij_i_in{6,ii} + nPij_i_zz_avgt_i ; nPij_i_zz_avgt_i = nPij_i_zz_avgt_o;

    nPij_e_xx_avgt_o = nPij_e_in{1,ii} + nPij_e_xx_avgt_i ; nPij_e_xx_avgt_i = nPij_e_xx_avgt_o;
    nPij_e_xy_avgt_o = nPij_e_in{2,ii} + nPij_e_xy_avgt_i ; nPij_e_xy_avgt_i = nPij_e_xy_avgt_o;
    nPij_e_xz_avgt_o = nPij_e_in{3,ii} + nPij_e_xz_avgt_i ; nPij_e_xz_avgt_i = nPij_e_xz_avgt_o;
    nPij_e_yy_avgt_o = nPij_e_in{4,ii} + nPij_e_yy_avgt_i ; nPij_e_yy_avgt_i = nPij_e_yy_avgt_o;
    nPij_e_yz_avgt_o = nPij_e_in{5,ii} + nPij_e_yz_avgt_i ; nPij_e_yz_avgt_i = nPij_e_yz_avgt_o;
    nPij_e_zz_avgt_o = nPij_e_in{6,ii} + nPij_e_zz_avgt_i ; nPij_e_zz_avgt_i = nPij_e_zz_avgt_o;

    ni_vi_x_Bx_avgt_o = ni_vi_x_B_in{1,ii} + ni_vi_x_Bx_avgt_i ; ni_vi_x_Bx_avgt_i = ni_vi_x_Bx_avgt_o;
    ni_vi_x_By_avgt_o = ni_vi_x_B_in{2,ii} + ni_vi_x_By_avgt_i ; ni_vi_x_By_avgt_i = ni_vi_x_By_avgt_o;    
    ni_vi_x_Bz_avgt_o = ni_vi_x_B_in{3,ii} + ni_vi_x_Bz_avgt_i ; ni_vi_x_Bz_avgt_i = ni_vi_x_Bz_avgt_o;

    ne_ve_x_Bx_avgt_o = ne_ve_x_B_in{1,ii} + ne_ve_x_Bx_avgt_i ; ne_ve_x_Bx_avgt_i = ne_ve_x_Bx_avgt_o;
    ne_ve_x_By_avgt_o = ne_ve_x_B_in{2,ii} + ne_ve_x_By_avgt_i ; ne_ve_x_By_avgt_i = ne_ve_x_By_avgt_o;    
    ne_ve_x_Bz_avgt_o = ne_ve_x_B_in{3,ii} + ne_ve_x_Bz_avgt_i ; ne_ve_x_Bz_avgt_i = ne_ve_x_Bz_avgt_o;


    nni_vivi_xx_avgt_o = nni_vivi_in{1,ii} + nni_vivi_xx_avgt_i ; nni_vivi_xx_avgt_i = nni_vivi_xx_avgt_o;
    nni_vivi_xy_avgt_o = nni_vivi_in{2,ii} + nni_vivi_xy_avgt_i ; nni_vivi_xy_avgt_i = nni_vivi_xy_avgt_o;
    nni_vivi_xz_avgt_o = nni_vivi_in{3,ii} + nni_vivi_xz_avgt_i ; nni_vivi_xz_avgt_i = nni_vivi_xz_avgt_o;
    nni_vivi_yy_avgt_o = nni_vivi_in{4,ii} + nni_vivi_yy_avgt_i ; nni_vivi_yy_avgt_i = nni_vivi_yy_avgt_o;    
    nni_vivi_yz_avgt_o = nni_vivi_in{5,ii} + nni_vivi_yz_avgt_i ; nni_vivi_yz_avgt_i = nni_vivi_yz_avgt_o;
    nni_vivi_zz_avgt_o = nni_vivi_in{6,ii} + nni_vivi_zz_avgt_i ; nni_vivi_zz_avgt_i = nni_vivi_zz_avgt_o;

    nne_veve_xx_avgt_o = nne_veve_in{1,ii} + nne_veve_xx_avgt_i ; nne_veve_xx_avgt_i = nne_veve_xx_avgt_o;
    nne_veve_xy_avgt_o = nne_veve_in{2,ii} + nne_veve_xy_avgt_i ; nne_veve_xy_avgt_i = nne_veve_xy_avgt_o;
    nne_veve_xz_avgt_o = nne_veve_in{3,ii} + nne_veve_xz_avgt_i ; nne_veve_xz_avgt_i = nne_veve_xz_avgt_o;
    nne_veve_yy_avgt_o = nne_veve_in{4,ii} + nne_veve_yy_avgt_i ; nne_veve_yy_avgt_i = nne_veve_yy_avgt_o;    
    nne_veve_yz_avgt_o = nne_veve_in{5,ii} + nne_veve_yz_avgt_i ; nne_veve_yz_avgt_i = nne_veve_yz_avgt_o;
    nne_veve_zz_avgt_o = nne_veve_in{6,ii} + nne_veve_zz_avgt_i ; nne_veve_zz_avgt_i = nne_veve_zz_avgt_o;   

end


clearvars *_o
%--------------------------------------------------------------------------

% setting the initial values to zero
%----------------------------------------------------------------------
[del_Ex_1, del_Ey_1, del_Ez_1] = ...
    deal(DUM,DUM,DUM);

[del_n_e_1, del_n_i_1] = ...
    deal(DUM,DUM); 
%----------------------------------------------------------------------
[del_n_i_del_Ex_1, del_n_i_del_Ey_1, del_n_i_del_Ez_1,...
    del_n_e_del_Ex_1, del_n_e_del_Ey_1, del_n_e_del_Ez_1,...
    ] = deal(DUM,DUM,DUM,DUM,DUM,DUM);
%----------------------------------------------------------------------


% to compute the averages of the delta quantities
%----------------------------------------------------------------------
for ii=1:j_a_b+1
    %ii = floor(j_a_b/2) + 1; % the center of the interval

    % Extract the instantaneus fields
    %----------------------------------------------------------------------
    Ex_avgt_o = E_in{1,ii};
    Ey_avgt_o = E_in{2,ii};
    Ez_avgt_o = E_in{3,ii};
    n_e_avgt_o = n_in{1,ii};
    n_i_avgt_o = n_in{2,ii};

    %----------------------------------------------------------------------

    % Compute the fluctuations, e.g., delta_n_e = n_e_time_i - <n>
    %----------------------------------------------------------------------
    del_Ex = (Ex_avgt_o - Ex_avgt_i./nu_av);
    del_Ey = (Ey_avgt_o - Ey_avgt_i./nu_av);
    del_Ez = (Ez_avgt_o - Ez_avgt_i./nu_av);

    del_n_e = (n_e_avgt_o - n_e_avgt_i./nu_av);
    del_n_i = (n_i_avgt_o - n_i_avgt_i./nu_av);
    %----------------------------------------------------------------------
    
    %del_n_del_E
    %----------------------------------------------------------------------
    del_n_i_del_Ex = (del_n_i .* del_Ex);
    del_n_i_del_Ey = (del_n_i .* del_Ey);
    del_n_i_del_Ez = (del_n_i .* del_Ez);

    del_n_e_del_Ex = (del_n_e .* del_Ex);
    del_n_e_del_Ey = (del_n_e .* del_Ey);
    del_n_e_del_Ez = (del_n_e .* del_Ez);

    %----------------------------------------------------------------------
    
    % make the adding
    %----------------------------------------------------------------------
    del_Ex_0 = del_Ex_1 + del_Ex; del_Ex_1 = del_Ex_0;
    del_Ey_0 = del_Ey_1 + del_Ey; del_Ey_1 = del_Ey_0;
    del_Ez_0 = del_Ez_1 + del_Ez; del_Ez_1 = del_Ez_0;

    del_n_e_0 = del_n_e_1 + del_n_e; del_n_e_1 = del_n_e_0;
    del_n_i_0 = del_n_i_1 + del_n_i; del_n_i_1 = del_n_i_0;
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------

    %del_n_del_E
    %----------------------------------------------------------------------
    del_n_i_del_Ex_0 = del_n_i_del_Ex_1 + del_n_i_del_Ex; del_n_i_del_Ex_1 = del_n_i_del_Ex_0;
    del_n_i_del_Ey_0 = del_n_i_del_Ey_1 + del_n_i_del_Ey; del_n_i_del_Ey_1 = del_n_i_del_Ey_0;
    del_n_i_del_Ez_0 = del_n_i_del_Ez_1 + del_n_i_del_Ez; del_n_i_del_Ez_1 = del_n_i_del_Ez_0;

    del_n_e_del_Ex_0 = del_n_e_del_Ex_1 + del_n_e_del_Ex; del_n_e_del_Ex_1 = del_n_e_del_Ex_0;
    del_n_e_del_Ey_0 = del_n_e_del_Ey_1 + del_n_e_del_Ey; del_n_e_del_Ey_1 = del_n_e_del_Ey_0;
    del_n_e_del_Ez_0 = del_n_e_del_Ez_1 + del_n_e_del_Ez; del_n_e_del_Ez_1 = del_n_e_del_Ez_0;

    %----------------------------------------------------------------------
end

%--------------------------------------------------------------------------
clearvars nPij_e_ba nPij_e_up nPij_e_in
clearvars nPij_i_ba nPij_i_up nPij_i_in
clearvars nPPij_e_ba nPPij_e_up nPPij_e_in
clearvars nPPij_i_ba nPPij_i_up nPPij_i_in

clearvars E_in B_in J_in n_in v_i_in v_e_in v_in
clearvars nv_i_in nv_e_in  
%clearvars vixB_in vexB_in vxB_in

clearvars nv_e_ba nv_e_up nv_i_ba nv_i_up nv_e nv_i

clearvars nni_vivi_in nne_veve_in ni_vi_x_B_in ne_ve_x_B_in

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

n_e_avgt_i = n_e_avgt_i./nu_av;
n_i_avgt_i = n_i_avgt_i./nu_av;

nv_ix_avgt_i = nv_ix_avgt_i./nu_av;
nv_iy_avgt_i = nv_iy_avgt_i./nu_av;
nv_iz_avgt_i = nv_iz_avgt_i./nu_av;

nv_ex_avgt_i = nv_ex_avgt_i./nu_av;
nv_ey_avgt_i = nv_ey_avgt_i./nu_av;
nv_ez_avgt_i = nv_ez_avgt_i./nu_av;

nPij_i_xx_avgt_i = nPij_i_xx_avgt_i./nu_av;
nPij_i_xy_avgt_i = nPij_i_xy_avgt_i./nu_av;
nPij_i_xz_avgt_i = nPij_i_xz_avgt_i./nu_av;
nPij_i_yy_avgt_i = nPij_i_yy_avgt_i./nu_av;
nPij_i_yz_avgt_i = nPij_i_yz_avgt_i./nu_av;
nPij_i_zz_avgt_i = nPij_i_zz_avgt_i./nu_av;

nPij_e_xx_avgt_i = nPij_e_xx_avgt_i./nu_av;
nPij_e_xy_avgt_i = nPij_e_xy_avgt_i./nu_av;
nPij_e_xz_avgt_i = nPij_e_xz_avgt_i./nu_av;
nPij_e_yy_avgt_i = nPij_e_yy_avgt_i./nu_av;
nPij_e_yz_avgt_i = nPij_e_yz_avgt_i./nu_av;
nPij_e_zz_avgt_i = nPij_e_zz_avgt_i./nu_av;


% Composed quentities
nv_ix_avgt_i = nv_ix_avgt_i./nu_av; % there is an isue here with the name of the variable
nv_iy_avgt_i = nv_iy_avgt_i./nu_av;
nv_iz_avgt_i = nv_iz_avgt_i./nu_av;

nv_ex_avgt_i = nv_ex_avgt_i./nu_av;
nv_ey_avgt_i = nv_ey_avgt_i./nu_av;
nv_ez_avgt_i = nv_ez_avgt_i./nu_av;

ni_vi_x_Bx_avgt_i = ni_vi_x_Bx_avgt_i./nu_av;
ni_vi_x_By_avgt_i = ni_vi_x_By_avgt_i./nu_av;
ni_vi_x_Bz_avgt_i = ni_vi_x_Bz_avgt_i./nu_av;

ne_ve_x_Bx_avgt_i = ne_ve_x_Bx_avgt_i./nu_av;
ne_ve_x_By_avgt_i = ne_ve_x_By_avgt_i./nu_av;
ne_ve_x_Bz_avgt_i = ne_ve_x_Bz_avgt_i./nu_av;

nni_vivi_xx_avgt_i = nni_vivi_xx_avgt_i./nu_av;  
nni_vivi_xy_avgt_i = nni_vivi_xy_avgt_i./nu_av;
nni_vivi_xz_avgt_i = nni_vivi_xz_avgt_i./nu_av;
nni_vivi_yy_avgt_i = nni_vivi_yy_avgt_i./nu_av;
nni_vivi_yz_avgt_i = nni_vivi_yz_avgt_i./nu_av;
nni_vivi_zz_avgt_i = nni_vivi_zz_avgt_i./nu_av;

nne_veve_xx_avgt_i = nne_veve_xx_avgt_i./nu_av;
nne_veve_xy_avgt_i = nne_veve_xy_avgt_i./nu_av;
nne_veve_xz_avgt_i = nne_veve_xz_avgt_i./nu_av;
nne_veve_yy_avgt_i = nne_veve_yy_avgt_i./nu_av;
nne_veve_yz_avgt_i = nne_veve_yz_avgt_i./nu_av;
nne_veve_zz_avgt_i = nne_veve_zz_avgt_i./nu_av;

%----------------------------------------------------------------------

% For the fluctuations
%----------------------------------------------------------------------
del_Ex = del_Ex_1./nu_av;
del_Ey = del_Ey_1./nu_av;
del_Ez = del_Ez_1./nu_av;

del_n_e = del_n_e_1./nu_av;
del_n_i = del_n_i_1./nu_av;

%----------------------------------------------------------------------
del_n_i_del_Ex = del_n_i_del_Ex_1./nu_av;
del_n_i_del_Ey = del_n_i_del_Ey_1./nu_av;
del_n_i_del_Ez = del_n_i_del_Ez_1./nu_av;

del_n_e_del_Ex = del_n_e_del_Ex_1./nu_av;
del_n_e_del_Ey = del_n_e_del_Ey_1./nu_av;
del_n_e_del_Ez = del_n_e_del_Ez_1./nu_av;
%----------------------------------------------------------------------

%----------------------------------------------------------------------
clearvars *_1
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


% This is important and correct. Do not erase.
%------------------------------------------------------------------------
% This is to show that the gradients are correct! <----
%------------------------------------------------------------------------
% Consider the simple case. f=YLL.^2, then f' = 2.*YLL.
% When taking [f_z, f_y] = grad(f), f_y./(2.resy) is the correct
% normalization.

% % %Additionally, the simulation domain goes -Ly to Ly. Thus, resy = 2Ly/Ny
% % %where Ny is the number of grid points. The same is true for Lz
% % %--------------------------------------------------------------------------
% % %--------------------------------------------------------------------------
% % f151=figure(151)
% % subplot(1,3,1)
% % dump = sin(0.1*YLL);
% % dump = YLL.^2; 
% % hc=pcolor(ZLL,YLL,dump);
% % hold on
% % set(hc,'edgecolor','none')
% % colorbar; title('y=x*x'); %xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
% % xlabel('z/d_i'); ylabel('y/d_i');
% % xline(zll(sli_z),'--k','LineWidth',lw);
% % hold off
% % subplot(1,3,2)
% % dump = cos(0.1*YLL).*0.1;
% % dump = 2.*YLL; 
% % hc=pcolor(ZLL,YLL,dump);
% % hold on
% % set(hc,'edgecolor','none')
% % colorbar; title('y=2x_t'); %xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
% % xlabel('z/d_i'); ylabel('y/d_i');
% % xline(zll(sli_z),'--k','LineWidth',lw);
% % hold off
% % [coss_z, coss_y] = gradient(sin(0.1*YLL));  
% % [coss_z, coss_y] = gradient(YLL.^2);  
% % subplot(1,3,3)
% % dump = coss_y./(grad_fact.*resy);
% % hc=pcolor(ZLL,YLL,dump);
% % hold on
% % set(hc,'edgecolor','none')
% % colorbar; title('y=x_c'); %xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
% % xlabel('z/d_i'); ylabel('y/d_i');
% % xline(zll(sli_z),'--k','LineWidth',lw);
% % hold off
% % 
% % max(max(abs(2.*YLL.*resy)))
% % max(max(abs(coss_y./2)))
% % %------------------------------------------------------------------------


% compute the gradients and divergence of the vectors ans tensors.
%Grad_B
%----------------------------------------------------------------------
[By_avgt_i_z,By_avgt_i_y] = gradient(By_avgt_i);
[Bz_avgt_i_z,Bz_avgt_i_y] = gradient(Bz_avgt_i);

%grad_fact = 4;

By_avgt_i_z = By_avgt_i_z/(grad_fact.*resz);   By_avgt_i_y = By_avgt_i_y/(grad_fact.*resy);
Bz_avgt_i_z = Bz_avgt_i_z/(grad_fact.*resz);   Bz_avgt_i_y = Bz_avgt_i_y/(grad_fact.*resy);
%----------------------------------------------------------------------


%%%%Here I go
% Here it is important to remember that the derivative of nP is different
% from de derivtive for P alone

%Grad_Pi
%----------------------------------------------------------------------
[Pij_i_xx_avgt_i_z, Pij_i_xx_avgt_i_y] = gradient(nPij_i_xx_avgt_i./n_i_avgt_i);
[Pij_i_yy_avgt_i_z, Pij_i_yy_avgt_i_y] = gradient(nPij_i_yy_avgt_i./n_i_avgt_i);
[Pij_i_zz_avgt_i_z, Pij_i_zz_avgt_i_y] = gradient(nPij_i_zz_avgt_i./n_i_avgt_i);
[Pij_i_xy_avgt_i_z, Pij_i_xy_avgt_i_y] = gradient(nPij_i_xy_avgt_i./n_i_avgt_i);
[Pij_i_xz_avgt_i_z, Pij_i_xz_avgt_i_y] = gradient(nPij_i_xz_avgt_i./n_i_avgt_i);
[Pij_i_yz_avgt_i_z, Pij_i_yz_avgt_i_y] = gradient(nPij_i_yz_avgt_i./n_i_avgt_i);
%----------------------------------------------------------------------
%----------------------------------------------------------------------
Div_Pi_x_avgt_i = Pij_i_xy_avgt_i_y/(grad_fact.*resy) + Pij_i_xz_avgt_i_z/(grad_fact.*resz);
Div_Pi_y_avgt_i = Pij_i_yy_avgt_i_y/(grad_fact.*resy) + Pij_i_yz_avgt_i_z/(grad_fact.*resz);
Div_Pi_z_avgt_i = Pij_i_yz_avgt_i_y/(grad_fact.*resy) + Pij_i_zz_avgt_i_z/(grad_fact.*resz);
%----------------------------------------------------------------------

%Grad_Pe
%----------------------------------------------------------------------
[Pij_e_xx_avgt_i_z, Pij_e_xx_avgt_i_y] = gradient(nPij_e_xx_avgt_i./n_e_avgt_i);
[Pij_e_yy_avgt_i_z, Pij_e_yy_avgt_i_y] = gradient(nPij_e_yy_avgt_i./n_e_avgt_i);
[Pij_e_zz_avgt_i_z, Pij_e_zz_avgt_i_y] = gradient(nPij_e_zz_avgt_i./n_e_avgt_i);
[Pij_e_xy_avgt_i_z, Pij_e_xy_avgt_i_y] = gradient(nPij_e_xy_avgt_i./n_e_avgt_i);
[Pij_e_xz_avgt_i_z, Pij_e_xz_avgt_i_y] = gradient(nPij_e_xz_avgt_i./n_e_avgt_i);
[Pij_e_yz_avgt_i_z, Pij_e_yz_avgt_i_y] = gradient(nPij_e_yz_avgt_i./n_e_avgt_i);
%----------------------------------------------------------------------
%----------------------------------------------------------------------
Div_Pe_x_avgt_i = Pij_e_xy_avgt_i_y/(grad_fact.*resy) + Pij_e_xz_avgt_i_z/(grad_fact.*resz);
Div_Pe_y_avgt_i = Pij_e_yy_avgt_i_y/(grad_fact.*resy) + Pij_e_yz_avgt_i_z/(grad_fact.*resz);
Div_Pe_z_avgt_i = Pij_e_yz_avgt_i_y/(grad_fact.*resy) + Pij_e_zz_avgt_i_z/(grad_fact.*resz);
%----------------------------------------------------------------------

% The grad of the average of the product ni_vivi_xx_avgt_i
%Grad_ni_vivi_avg
%----------------------------------------------------------------------
[ni_vivi_xx_avgt_i_z, ni_vivi_xx_avgt_i_y] = gradient(nni_vivi_xx_avgt_i./n_i_avgt_i);
[ni_vivi_xy_avgt_i_z, ni_vivi_xy_avgt_i_y] = gradient(nni_vivi_xy_avgt_i./n_i_avgt_i);
[ni_vivi_xz_avgt_i_z, ni_vivi_xz_avgt_i_y] = gradient(nni_vivi_xz_avgt_i./n_i_avgt_i);
[ni_vivi_yy_avgt_i_z, ni_vivi_yy_avgt_i_y] = gradient(nni_vivi_yy_avgt_i./n_i_avgt_i);
[ni_vivi_yz_avgt_i_z, ni_vivi_yz_avgt_i_y] = gradient(nni_vivi_yz_avgt_i./n_i_avgt_i);
[ni_vivi_zz_avgt_i_z, ni_vivi_zz_avgt_i_y] = gradient(nni_vivi_zz_avgt_i./n_i_avgt_i);
%----------------------------------------------------------------------
%----------------------------------------------------------------------

Div_ni_vivi_avg_i_x = (ni_vivi_xy_avgt_i_y/(grad_fact.*resy) + ni_vivi_xz_avgt_i_z/(grad_fact.*resz));
Div_ni_vivi_avg_i_y = (ni_vivi_yy_avgt_i_y/(grad_fact.*resy) + ni_vivi_yz_avgt_i_z/(grad_fact.*resz));
Div_ni_vivi_avg_i_z = (ni_vivi_yz_avgt_i_y/(grad_fact.*resy) + ni_vivi_zz_avgt_i_z/(grad_fact.*resz));
%----------------------------------------------------------------------

%Grad_ne_veve_avg
%----------------------------------------------------------------------
[ne_veve_xx_avgt_i_z, ne_veve_xx_avgt_i_y] = gradient(nne_veve_xx_avgt_i./n_e_avgt_i);
[ne_veve_xy_avgt_i_z, ne_veve_xy_avgt_i_y] = gradient(nne_veve_xy_avgt_i./n_e_avgt_i);
[ne_veve_xz_avgt_i_z, ne_veve_xz_avgt_i_y] = gradient(nne_veve_xz_avgt_i./n_e_avgt_i);
[ne_veve_yy_avgt_i_z, ne_veve_yy_avgt_i_y] = gradient(nne_veve_yy_avgt_i./n_e_avgt_i);
[ne_veve_yz_avgt_i_z, ne_veve_yz_avgt_i_y] = gradient(nne_veve_yz_avgt_i./n_e_avgt_i);
[ne_veve_zz_avgt_i_z, ne_veve_zz_avgt_i_y] = gradient(nne_veve_zz_avgt_i./n_e_avgt_i);
%----------------------------------------------------------------------
%----------------------------------------------------------------------
Div_ne_veve_avg_i_x = (ne_veve_xy_avgt_i_y/(grad_fact.*resy) + ne_veve_xz_avgt_i_z/(grad_fact.*resz));
Div_ne_veve_avg_i_y = (ne_veve_yy_avgt_i_y/(grad_fact.*resy) + ne_veve_yz_avgt_i_z/(grad_fact.*resz));
Div_ne_veve_avg_i_z = (ne_veve_yz_avgt_i_y/(grad_fact.*resy) + ne_veve_zz_avgt_i_z/(grad_fact.*resz));
%----------------------------------------------------------------------


% The grad of the product of the averages ni_av_vivi_avg_xx_i
%----------------------------------------------------------------------
ni_av_vivi_avg_xx_i = nv_ix_avgt_i .* nv_ix_avgt_i./n_i_avgt_i;
ni_av_vivi_avg_xy_i = nv_ix_avgt_i .* nv_iy_avgt_i./n_i_avgt_i;
ni_av_vivi_avg_xz_i = nv_ix_avgt_i .* nv_iz_avgt_i./n_i_avgt_i;
ni_av_vivi_avg_yy_i = nv_iy_avgt_i .* nv_iy_avgt_i./n_i_avgt_i;
ni_av_vivi_avg_yz_i = nv_iy_avgt_i .* nv_iz_avgt_i./n_i_avgt_i;
ni_av_vivi_avg_zz_i = nv_iz_avgt_i .* nv_iz_avgt_i./n_i_avgt_i;

ne_av_veve_avg_xx_i = nv_ex_avgt_i .* nv_ex_avgt_i./n_e_avgt_i;
ne_av_veve_avg_xy_i = nv_ex_avgt_i .* nv_ey_avgt_i./n_e_avgt_i;
ne_av_veve_avg_xz_i = nv_ex_avgt_i .* nv_ez_avgt_i./n_e_avgt_i;
ne_av_veve_avg_yy_i = nv_ey_avgt_i .* nv_ey_avgt_i./n_e_avgt_i;
ne_av_veve_avg_yz_i = nv_ey_avgt_i .* nv_ez_avgt_i./n_e_avgt_i;
ne_av_veve_avg_zz_i = nv_ez_avgt_i .* nv_ez_avgt_i./n_e_avgt_i;
%----------------------------------------------------------------------

%Grad_ni_av_vivi_av
%----------------------------------------------------------------------
[ni_av_vivi_avg_xx_i_z, ni_av_vivi_avg_xx_i_y] = gradient(ni_av_vivi_avg_xx_i);
[ni_av_vivi_avg_xy_i_z, ni_av_vivi_avg_xy_i_y] = gradient(ni_av_vivi_avg_xy_i);
[ni_av_vivi_avg_xz_i_z, ni_av_vivi_avg_xz_i_y] = gradient(ni_av_vivi_avg_xz_i);
[ni_av_vivi_avg_yy_i_z, ni_av_vivi_avg_yy_i_y] = gradient(ni_av_vivi_avg_yy_i);
[ni_av_vivi_avg_yz_i_z, ni_av_vivi_avg_yz_i_y] = gradient(ni_av_vivi_avg_yz_i);
[ni_av_vivi_avg_zz_i_z, ni_av_vivi_avg_zz_i_y] = gradient(ni_av_vivi_avg_zz_i);
%----------------------------------------------------------------------
%----------------------------------------------------------------------
Div_ni_av_vivi_avg_i_x = (ni_av_vivi_avg_xy_i_y/(grad_fact.*resy) + ni_av_vivi_avg_xz_i_z/(grad_fact.*resz));
Div_ni_av_vivi_avg_i_y = (ni_av_vivi_avg_yy_i_y/(grad_fact.*resy) + ni_av_vivi_avg_yz_i_z/(grad_fact.*resz));
Div_ni_av_vivi_avg_i_z = (ni_av_vivi_avg_yz_i_y/(grad_fact.*resy) + ni_av_vivi_avg_zz_i_z/(grad_fact.*resz));
%----------------------------------------------------------------------

%Grad_ne_av_veve_av
%----------------------------------------------------------------------
[ne_av_veve_avg_xx_i_z, ne_av_veve_avg_xx_i_y] = gradient(ne_av_veve_avg_xx_i);
[ne_av_veve_avg_xy_i_z, ne_av_veve_avg_xy_i_y] = gradient(ne_av_veve_avg_xy_i);
[ne_av_veve_avg_xz_i_z, ne_av_veve_avg_xz_i_y] = gradient(ne_av_veve_avg_xz_i);
[ne_av_veve_avg_yy_i_z, ne_av_veve_avg_yy_i_y] = gradient(ne_av_veve_avg_yy_i);
[ne_av_veve_avg_yz_i_z, ne_av_veve_avg_yz_i_y] = gradient(ne_av_veve_avg_yz_i);
[ne_av_veve_avg_zz_i_z, ne_av_veve_avg_zz_i_y] = gradient(ne_av_veve_avg_zz_i);
%----------------------------------------------------------------------
%----------------------------------------------------------------------
Div_ne_av_veve_avg_i_x = (ne_av_veve_avg_xy_i_y/(grad_fact.*resy) + ne_av_veve_avg_xz_i_z/(grad_fact.*resz));
Div_ne_av_veve_avg_i_y = (ne_av_veve_avg_yy_i_y/(grad_fact.*resy) + ne_av_veve_avg_yz_i_z/(grad_fact.*resz));
Div_ne_av_veve_avg_i_z = (ne_av_veve_avg_yz_i_y/(grad_fact.*resy) + ne_av_veve_avg_zz_i_z/(grad_fact.*resz));
%----------------------------------------------------------------------

%----------------------------------------------------------------------
% So far everything is working. The del_* and *_i are all time averaged quantities.!!! 
%----------------------------------------------------------------------

clearvars v_i_bax v_i_bay v_i_baz v_i_upx v_i_upy v_i_upz
clearvars v_e_bax v_e_bay v_e_baz v_e_upx v_e_upy v_e_upz


clearvars n_v_x_B_in n_vv_in ne_ve_x_B_in ne_veve_in ni_vi_x_B_in ni_vivi_in
clearvars PPij_i_ba PPij_i_up PPij_e_ba PPij_e_up         

% This is because the electric field seems to be normalised to B0; 
%----------------------------------------------------------------------
% Ex_avgt_i=Ex_avgt_i.*B0;
% Ey_avgt_i=Ey_avgt_i.*B0;
% Ez_avgt_i=Ez_avgt_i.*B0;
% 
% Ex_avgt_i=Ex_avgt_i./B0;
% Ey_avgt_i=Ey_avgt_i./B0;
% Ez_avgt_i=Ez_avgt_i./B0;
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

%xlim_a = zll(704); xlim_b = zll(1104);
%ylim_a = yll(454); ylim_b = yll(571);





% compute the electric field terms
%----------------------------------------------------------------------

% <E> + <ve>x<B> = -nabla . P_{e}/e<ne> - (me/e<ne>) nabla . (<ne><ve><ve>) + D + T + I

% D = - <dne E> / <ne> 

% T = - <nevexB>/<ne> + <ve>x<B>

% I = - (me/e<ne>) (nabla . <neveve> - nabla . (<ne><ve><ve>)) 
%----------------------------------------------------------------------

%----------------------------------------------------------------------
V_ish=1;% WHY IS IT THAT I HAVE TO DIVIDE BY B0????
%V_ish=1;


%----------------------------------------------------------------------

% Lets make this by components for electrons
%----------------------------------------------------------------------

ve_av_x_B_av_x = (nv_ey_avgt_i .* Bz_avgt_i - nv_ez_avgt_i .* By_avgt_i)./n_e_avgt_i;
LH_x_e = Ex_avgt_i + ve_av_x_B_av_x;
RH_x_1_e = -(1./n_e_avgt_i) .* Div_Pe_x_avgt_i;
RH_x_2_e = - (me./n_e_avgt_i) .* Div_ne_av_veve_avg_i_x./(1); 
D_x_e = - del_n_e_del_Ex ./ n_e_avgt_i;
T_x_e = - ne_ve_x_Bx_avgt_i./(n_e_avgt_i.*1) + ve_av_x_B_av_x./1;
I_x_e = - (me./n_e_avgt_i) .* (Div_ne_veve_avg_i_x  - Div_ne_av_veve_avg_i_x)./(1) ;   
RH_x_e = RH_x_1_e + RH_x_2_e + D_x_e + T_x_e + I_x_e;   

ve_av_x_B_av_y = (nv_ez_avgt_i .* Bx_avgt_i - nv_ex_avgt_i .* Bz_avgt_i)./n_e_avgt_i;
LH_y_e = Ey_avgt_i + ve_av_x_B_av_y./1;
RH_y_1_e = -(1./n_e_avgt_i) .* Div_Pe_y_avgt_i;
RH_y_2_e = - (me./n_e_avgt_i) .* Div_ne_av_veve_avg_i_y./(1); 
D_y_e = - del_n_e_del_Ey ./ n_e_avgt_i;
T_y_e = - ne_ve_x_By_avgt_i./(n_e_avgt_i.*1) + (ve_av_x_B_av_y.*1);
I_y_e = - (me./n_e_avgt_i) .* (Div_ne_veve_avg_i_y  - Div_ne_av_veve_avg_i_y)./(1) ;   
RH_y_e = RH_y_1_e + RH_y_2_e + D_y_e + T_y_e + I_y_e; 

ve_av_x_B_av_z = (nv_ex_avgt_i .* By_avgt_i - nv_ey_avgt_i .* Bx_avgt_i)./n_e_avgt_i;
LH_z_e = Ez_avgt_i + ve_av_x_B_av_z./1;
RH_z_1_e = -(1./n_e_avgt_i) .* Div_Pe_z_avgt_i;
RH_z_2_e = - (me./n_e_avgt_i) .* Div_ne_av_veve_avg_i_z./(1); 
D_z_e = - del_n_e_del_Ez ./ n_e_avgt_i;
T_z_e = - ne_ve_x_Bz_avgt_i./(n_e_avgt_i.*1) + ve_av_x_B_av_z./1;
I_z_e = - (me./n_e_avgt_i) .* (Div_ne_veve_avg_i_z  - Div_ne_av_veve_avg_i_z)./(1) ;   
RH_z_e = RH_z_1_e + RH_z_2_e + D_z_e + T_z_e + I_z_e; 
%----------------------------------------------------------------------


% Making the plots
%--------------------------------------------------------------------------
normi_f = B0*VA2c;
%normi_f = B0*Vae_b;
xlim_a = -16; xlim_b = 16;
ylim_a = -16; ylim_b = 16;
lw=2;

% In this plot I still need to include the time derivative.
sli_y = 512; %floor(4+ssz(2)/2);%380;
sli_z = 1024; %floor(2+ssz(3)/2);%700;
sli_y = 512; sli_z = 904; 

sli_y = 512; sli_z = 500; 

sli_y = 512; sli_z = 452; 

%sli_y = 80;  sli_z = 160;
%sli_y = 512; sli_z = 700; 
%sli_y = 180; sli_z = 300; 
%--------------------------------------------------------------------------

% This is the plot of the ohms law. 
%--------------------------------------------------------------------------
fs=18;
%--------------------------------------------------------------------------
f1=figure(1);
subplot(3,1,1)
dum_1 = (Ex_avgt_i)./normi_f;
plot(yll,dum_1(:,sli_z),'k','LineWidth',lw);
hold on
dum_2 = -ve_av_x_B_av_x./(normi_f);
plot(yll,dum_2(:,sli_z),'--k','LineWidth',lw);
dum_6 = RH_x_1_e./normi_f ; 
plot(yll,dum_6(:,sli_z),'r','LineWidth',lw);
dum_6 = RH_x_2_e./normi_f ; 
plot(yll,dum_6(:,sli_z),'b','LineWidth',lw);
dum_3 = D_x_e./normi_f; 
plot(yll,dum_3(:,sli_z),'m','LineWidth',lw);
dum_4 = T_x_e./normi_f; 
plot(yll,dum_4(:,sli_z),'c','LineWidth',lw);
dum_5 = I_x_e./normi_f; 
plot(yll,dum_5(:,sli_z),'--c','LineWidth',lw);
dum_6 = (LH_x_e - RH_x_e)./normi_f; 
plot(yll,dum_6(:,sli_z),'--g','LineWidth',lw);
xlim([ylim_a, ylim_b]); 
xlabel('y/d_i')
legend({'$\langle E_{x} \rangle $',...
        '$(-\langle v_{e} \rangle \times \langle B \rangle)_{x}$',...
        '$-(\nabla \cdot \langle P_{e} \rangle)_{x}/e\langle n_{e} \rangle$',...
        '$-(m_{e}\nabla \cdot (\langle n_{e} \rangle \langle v_{e} \rangle \langle v_{e} \rangle)_{x}/e\langle n_{e} \rangle$',...
        '$D_{e,x}$',...
        '$T_{e,x}$',...
        '$I_{e,x}$',...
        '$LH_{e,x} - RH_{e,x}$',...
        },'Interpreter','latex','FontSize',fs,...
        'Location','southeast','NumColumns',1)
hold off

subplot(3,1,2)
dum_1 = (Ey_avgt_i)./normi_f; 
plot(yll,dum_1(:,sli_z),'k','LineWidth',lw);
hold on
dum_2 = -(ve_av_x_B_av_y)./(normi_f.*1);
plot(yll,dum_2(:,sli_z),'--k','LineWidth',lw);
dum_6 = RH_y_1_e./normi_f ; 
plot(yll,dum_6(:,sli_z),'r','LineWidth',lw);
dum_6 = RH_y_2_e./normi_f ; 
plot(yll,dum_6(:,sli_z),'b','LineWidth',lw);
dum_3 = D_y_e./normi_f; 
plot(yll,dum_3(:,sli_z),'m','LineWidth',lw);
dum_4 = T_y_e./normi_f; 
plot(yll,dum_4(:,sli_z),'c','LineWidth',lw);
dum_5 = I_y_e./normi_f; 
plot(yll,dum_5(:,sli_z),'--c','LineWidth',lw);
dum_6 = (LH_y_e - RH_y_e)./normi_f; 
plot(yll,dum_6(:,sli_z),'--g','LineWidth',lw);
xlim([ylim_a, ylim_b]); 
xlabel('y/d_i')
legend({'$\langle E_{y} \rangle $',...
        '$-(\langle v_{e} \rangle \times \langle B \rangle)_{y}$',...
        '$-(\nabla \cdot \langle P_{e} \rangle)_{y}/e\langle n_{e} \rangle$',...
        '$-(m_{e}\nabla \cdot (\langle n_{e} \rangle \langle v_{e} \rangle \langle v_{e} \rangle)_{y}/e\langle n_{e} \rangle$',...
        '$D_{e,y}$',...
        '$T_{e,y}$',...
        '$I_{e,y}$',...
        '$LH_{e,y} - RH_{e,y}$',...
        },'Interpreter','latex','FontSize',fs,...
        'Location','southeast','NumColumns',1)
hold off

subplot(3,1,3)
dum_1 = (Ez_avgt_i)./normi_f; 
plot(yll,dum_1(:,sli_z),'k','LineWidth',lw);
hold on
dum_2 = -(ve_av_x_B_av_z)./(normi_f.*1);
plot(yll,dum_2(:,sli_z),'--k','LineWidth',lw);
dum_6 = RH_z_1_e./normi_f ; 
plot(yll,dum_6(:,sli_z),'r','LineWidth',lw);
dum_6 = RH_z_2_e./normi_f ; 
plot(yll,dum_6(:,sli_z),'b','LineWidth',lw);
dum_3 = D_z_e./normi_f; 
plot(yll,dum_3(:,sli_z),'m','LineWidth',lw);
dum_4 = T_z_e./normi_f; 
plot(yll,dum_4(:,sli_z),'c','LineWidth',lw);
dum_5 = I_z_e./normi_f; 
plot(yll,dum_5(:,sli_z),'--c','LineWidth',lw);
dum_6 = (LH_z_e - RH_z_e)./normi_f; 
plot(yll,dum_6(:,sli_z),'--g','LineWidth',lw);
%xlim([ylim_a, ylim_b]); 
xlabel('y/d_i')
legend({'$\langle E_{z} \rangle$',...
        '$-(\langle v_{e} \rangle \times \langle B \rangle)_{z}$',...
        '$-(\nabla \cdot \langle P_{e} \rangle)_{z}/e\langle n_{e} \rangle$',...
        '$-(m_{e}\nabla \cdot (\langle n_{e} \rangle \langle v_{e} \rangle \langle v_{e} \rangle)_{z}/e\langle n_{e} \rangle$',...
        '$D_{e,z}$',...
        '$T_{e,z}$',...
        '$I_{e,z}$',...
        '$LH_{e,z} - RH_{e,z}$',...
        },'Interpreter','latex','FontSize',fs,...
        'Location','southeast','NumColumns',1)
hold off
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
f2=figure(2);
% lets look at the normal momentum equation for the electrons
%--------------------------------------------------------------------------
%E+vexB = - (me/neq)*(d\dt(neve)) - (me/neq)*(nabla .(neveve)) - (1/neq)*(nabla .(Pe))
%--------------------------------------------------------------------------
ve_av_x_B_av_x = (v_ey_avgt_i .* Bz_avgt_i - v_ez_avgt_i .* By_avgt_i)/V_ish;
LH_x_e = Ex_avgt_i + ve_av_x_B_av_x./1;
RH_x_1_e = -(1./n_e_avgt_i) .* Div_Pe_x_avgt_i;
%RH_x_1_e = -Div_Pe_x_avgt_i;
RH_x_2_e = - (me./n_e_avgt_i) .* Div_ne_av_veve_avg_i_x./(1); 
RH_x_e = RH_x_1_e + RH_x_2_e;   
%--------------------------------------------------------------------------
subplot(2,1,1)
dum_1 = (Ex_avgt_i)./normi_f;
plot(yll,dum_1(:,sli_z),'k','LineWidth',lw);
hold on
dum_2 = -ve_av_x_B_av_x./(normi_f);
plot(yll,dum_2(:,sli_z),'--k','LineWidth',lw);
dum_6 = RH_x_1_e./normi_f ; 
plot(yll,dum_6(:,sli_z),'r','LineWidth',lw);
dum_6 = RH_x_2_e./normi_f ; 
plot(yll,dum_6(:,sli_z),'b','LineWidth',lw);
dum_6 = (LH_x_e - RH_x_e)./normi_f; 
plot(yll,dum_6(:,sli_z),'--g','LineWidth',lw);
xlim([ylim_a, ylim_b]); 
xlabel('y/d_i')
legend({'$\langle E_{x} \rangle $',...
        '$(-\langle v_{e} \rangle \times \langle B \rangle)_{x}$',...
        '$-(\nabla \cdot \langle P_{e} \rangle)_{x}/e\langle n_{e} \rangle$',...
        '$-(m_{e}\nabla \cdot (\langle n_{e} \rangle \langle v_{e} \rangle \langle v_{e} \rangle)_{x}/e\langle n_{e} \rangle$',...
        '$LH_{e,x} - RH_{e,x}$',...
        },'Interpreter','latex','FontSize',fs,...
        'Location','southeast','NumColumns',1)
hold off
%--------------------------------------------------------------------------
% compute the electric field terms
%----------------------------------------------------------------------
% <E> + <ve>x<B> = -nabla . P_{e}/e<ne> - (me/e<ne>) nabla . (<ne><ve><ve>) + D + T + I
% D = - <dne E> / <ne> 
% T = - <nevexB>/<ne> + <ve>x<B>
% I = - (me/e<ne>) (nabla . <neveve> - nabla . (<ne><ve><ve>)) 
%----------------------------------------------------------------------
ve_av_x_B_av_x = (v_ey_avgt_i .* Bz_avgt_i - v_ez_avgt_i .* By_avgt_i)/V_ish;
LH_x_e = Ex_avgt_i + ve_av_x_B_av_x./1;
RH_x_1_e = -(1./n_e_avgt_i) .* Div_Pe_x_avgt_i;
RH_x_1_e = -(1.) .* Div_Pe_x_avgt_i;
%RH_x_2_e = - (me./n_e_avgt_i) .* Div_ne_av_veve_avg_i_x./(1); 
D_x_e = - del_n_del_Ex ./ n_e_avgt_i;
T_x_e = - ne_ve_x_Bx_avgt_i./(n_e_avgt_i.*1) + ve_av_x_B_av_x./1;
I_x_e = - (me./n_e_avgt_i) .* (Div_ne_veve_avg_i_x  - Div_ne_av_veve_avg_i_x)./(1) ;   
RH_x_e = RH_x_1_e + RH_x_2_e + D_x_e + T_x_e + I_x_e;  
%----------------------------------------------------------------------
subplot(2,1,2)
dum_1 = (Ex_avgt_i)./normi_f;
plot(yll,dum_1(:,sli_z),'k','LineWidth',lw);
hold on
dum_2 = -ve_av_x_B_av_x./(1.*normi_f);
plot(yll,dum_2(:,sli_z),'--k','LineWidth',lw);
dum_6 = RH_x_1_e./normi_f ; 
plot(yll,dum_6(:,sli_z),'r','LineWidth',lw);
dum_6 = RH_x_2_e./normi_f ; 
plot(yll,dum_6(:,sli_z),'b','LineWidth',lw);
dum_3 = D_x_e./normi_f; 
plot(yll,dum_3(:,sli_z),'m','LineWidth',lw);
dum_4 = T_x_e./normi_f; 
plot(yll,dum_4(:,sli_z),'c','LineWidth',lw);
dum_5 = I_x_e./normi_f; 
plot(yll,dum_5(:,sli_z),'--c','LineWidth',lw);
dum_6 = (LH_x_e - RH_x_e)./normi_f; 
plot(yll,dum_6(:,sli_z),'--g','LineWidth',lw);
xlim([ylim_a, ylim_b]); 
xlabel('y/d_i')
legend({'$\langle E_{x} \rangle $',...
        '$(-\langle v_{e} \rangle \times \langle B \rangle)_{x}$',...
        '$-(\nabla \cdot \langle P_{e} \rangle)_{x}/e\langle n_{e} \rangle$',...
        '$-(m_{e}\nabla \cdot (\langle n_{e} \rangle \langle v_{e} \rangle \langle v_{e} \rangle)_{x}/e\langle n_{e} \rangle$',...
        '$D_{e,x}$',...
        '$T_{e,x}$',...
        '$I_{e,x}$',...
        '$LH_{e,x} - RH_{e,x}$',...
        },'Interpreter','latex','FontSize',fs,...
        'Location','southeast','NumColumns',1)
hold off
%----------------------------------------------------------------------




f32=figure(32)
dum_1 = (Div_ne_veve_avg_i_x)./(normi_f.*n_e_avgt_i);
plot(yll,dum_1(:,sli_z),'r','LineWidth',lw);
hold on
dum_2 = Div_ne_av_veve_avg_i_x./(normi_f.*n_e_avgt_i); %div of the averages
plot(yll,dum_2(:,sli_z),'b','LineWidth',lw);
xlim([ylim_a, ylim_b]); 
xlabel('y/d_i')
legend({'$(\nabla \cdot (\langle n_{e} \rangle \langle v_{e} \rangle \langle v_{e} \rangle)_{x}/e\langle n_{e} \rangle$',...
        '$-(\nabla \cdot (\langle n_{e} \rangle \langle v_{e} \rangle \langle v_{e} \rangle)_{x}/e\langle n_{e} \rangle$',...
        },'Interpreter','latex','FontSize',fs,...
        'Location','southeast','NumColumns',1)
hold off


% These plots are to show that the pressure terms are one order of magnitud
% larger than neveve
f31=figure(31)
subplot(6,1,1)
dum_1 = (ne_veve_xx_avgt_i)./normi_f;
plot(yll,dum_1(:,sli_z),'b','LineWidth',lw);
hold on
dum_2 = ne_av_veve_avg_xx_i./(1.*normi_f); %div of the averages
plot(yll,dum_2(:,sli_z),'k','LineWidth',lw);
dum_1 = (Pij_e_xx_avgt_i)./normi_f;
plot(yll,dum_1(:,sli_z),'r','LineWidth',lw);
xlim([ylim_a, ylim_b]); 
xlabel('y/d_i')
title('xx <> <><>')
hold off

subplot(6,1,2)
dum_1 = (ne_veve_yy_avgt_i)./normi_f;
plot(yll,dum_1(:,sli_z),'b','LineWidth',lw);
hold on
dum_2 = ne_av_veve_avg_yy_i./(1.*normi_f); %div of the averages
plot(yll,dum_2(:,sli_z),'k','LineWidth',lw);
dum_1 = (Pij_e_yy_avgt_i)./normi_f;
plot(yll,dum_1(:,sli_z),'r','LineWidth',lw);
xlim([ylim_a, ylim_b]); 
xlabel('y/d_i')
title('yy')
hold off

subplot(6,1,3)
dum_1 = (ne_veve_zz_avgt_i)./normi_f;
plot(yll,dum_1(:,sli_z),'b','LineWidth',lw);
hold on
dum_2 = ne_av_veve_avg_zz_i./(1.*normi_f); %div of the averages
plot(yll,dum_2(:,sli_z),'k','LineWidth',lw);
dum_1 = (Pij_e_zz_avgt_i)./normi_f;
plot(yll,dum_1(:,sli_z),'r','LineWidth',lw);
xlim([ylim_a, ylim_b]); 
xlabel('y/d_i')
title('zz')
hold off

subplot(6,1,4)
dum_1 = (ne_veve_xy_avgt_i)./normi_f;
plot(yll,dum_1(:,sli_z),'b','LineWidth',lw);
hold on
dum_2 = ne_av_veve_avg_xy_i./(1.*normi_f); %div of the averages
plot(yll,dum_2(:,sli_z),'k','LineWidth',lw);
dum_1 = (Pij_e_xy_avgt_i)./normi_f;
plot(yll,dum_1(:,sli_z),'r','LineWidth',lw);
xlim([ylim_a, ylim_b]); 
xlabel('y/d_i')
title('xy')
hold off

subplot(6,1,5)
dum_1 = (ne_veve_xz_avgt_i)./normi_f;
plot(yll,dum_1(:,sli_z),'b','LineWidth',lw);
hold on
dum_2 = ne_av_veve_avg_xz_i./(1.*normi_f); %div of the averages
plot(yll,dum_2(:,sli_z),'k','LineWidth',lw);
dum_1 = (Pij_e_xz_avgt_i)./normi_f;
plot(yll,dum_1(:,sli_z),'r','LineWidth',lw);
xlim([ylim_a, ylim_b]); 
xlabel('y/d_i')
title('xz')
hold off

subplot(6,1,6)
dum_1 = (ne_veve_yz_avgt_i)./normi_f;
plot(yll,dum_1(:,sli_z),'b','LineWidth',lw);
hold on
dum_2 = ne_av_veve_avg_yz_i./(1.*normi_f); %div of the averages
plot(yll,dum_2(:,sli_z),'k','LineWidth',lw);
dum_1 = (Pij_e_yz_avgt_i)./normi_f;
plot(yll,dum_1(:,sli_z),'r','LineWidth',lw);
xlim([ylim_a, ylim_b]); 
xlabel('y/d_i')
title('yz')
hold off


f45=figure(45)
dum_1 = (Div_Pe_x_avgt_i.*n_e_avgt_i)./(normi_f);
plot(yll,dum_1(:,sli_z),'r','LineWidth',lw);
hold on
dum_1 = (Div_ne_veve_avg_i_x)./(normi_f.*n_e_avgt_i);
plot(yll,dum_1(:,sli_z),'b','LineWidth',lw);
dum_1 =  Div_ne_av_veve_avg_i_x./(normi_f.*n_e_avgt_i);
plot(yll,dum_1(:,sli_z),'k','LineWidth',lw);
xlim([ylim_a, ylim_b]); 
xlabel('y/d_i')
title('yz')
hold off



% This is the log of the density and of the Ex to see if there are
% fluctuations
%--------------------------------------------------------------------------
f3=figure(3)
subplot(2,1,1)
dump = (n_e_avgt_i) ;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
colorbar; title('log(ne)');
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
xlabel('z/d_i'); ylabel('y/d_i');
xline(zll(sli_z),'--k','LineWidth',lw);
hold off
subplot(2,1,2)
dump = log(abs(Ex_avgt_i)) ;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
colorbar; title('log(|Ex|)');
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
xlabel('z/d_i'); ylabel('y/d_i');
xline(zll(sli_z),'--k','LineWidth',lw);
hold off
%--------------------------------------------------------------------------


path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
cd(path_s2)

% This is to see the components of E, B and vxB to see why it is not
% balancing.
%--------------------------------------------------------------------------
% E, B, vxB, 1D cut
%--------------------------------------------------------------------------
f4=figure(4)
h1=subplot(3,3,1);
dump = v_ex_avgt_i ;
dump = n_e_avgt_i ;
plot(yll,dump(:,sli_z),'k','LineWidth',lw);
hold on
caxlim=max(max(abs(dump))).*frac;
%ylim([-caxlim, caxlim]);
xlabel('y/d_i');
title('vex');
hold off
h1=subplot(3,3,2);
dump = v_ey_avgt_i ;
plot(yll,dump(:,sli_z),'k','LineWidth',lw);
hold on
caxlim=max(max(abs(dump))).*frac;
%ylim([-caxlim, caxlim]);
xlabel('y/d_i');
title('vey');
hold off
h1=subplot(3,3,3);
dump = v_ez_avgt_i ;
plot(yll,dump(:,sli_z),'k','LineWidth',lw);
hold on
caxlim=max(max(abs(dump))).*frac;
%ylim([-caxlim, caxlim]);
xlabel('y/d_i');
title('vez');
hold off

h1=subplot(3,3,4);
dump = Bx_avgt_i ;
plot(yll,dump(:,sli_z),'k','LineWidth',lw);
hold on
caxlim=max(max(abs(dump))).*frac;
%ylim([-caxlim, caxlim]);
xlabel('y/d_i');
title('Bx');
hold off
h1=subplot(3,3,5);
dump = By_avgt_i ;
plot(yll,dump(:,sli_z),'k','LineWidth',lw);
hold on
caxlim=max(max(abs(dump))).*frac;
%ylim([-caxlim, caxlim]);
xlabel('y/d_i');
title('By');
hold off
h1=subplot(3,3,6);
dump = Bz_avgt_i ;
plot(yll,dump(:,sli_z),'k','LineWidth',lw);
hold on
caxlim=max(max(abs(dump))).*frac;
%ylim([-caxlim, caxlim]);
xlabel('y/d_i');
title('Bz');
hold off

h1=subplot(3,3,7);
dump = (v_ey_avgt_i.*Bz_avgt_i - v_ez_avgt_i.*By_avgt_i)/V_ish;
plot(yll,dump(:,sli_z),'k','LineWidth',lw);
hold on
dump2=Ex_avgt_i;
plot(yll,dump2(:,sli_z),'r','LineWidth',lw);
caxlim=max(max(abs(dump))).*frac;
caxlim = 0.008;
%ylim([-caxlim, caxlim]);
xlabel('y/d_i');
title('vexB_x');
hold off
h1=subplot(3,3,8);
dump = (v_ez_avgt_i.*Bx_avgt_i - v_ex_avgt_i.*Bz_avgt_i)/V_ish;
plot(yll,dump(:,sli_z),'k','LineWidth',lw);
hold on
dump2=Ey_avgt_i;
plot(yll,dump2(:,sli_z),'r','LineWidth',lw);
caxlim=max(max(abs(dump))).*frac;
caxlim = 0.002;
%ylim([-caxlim, caxlim]);
xlabel('y/d_i');
title('vexB_y');
hold off
h1=subplot(3,3,9);
dump = (v_ex_avgt_i.*By_avgt_i - v_ey_avgt_i.*Bx_avgt_i)/V_ish;
plot(yll,dump(:,sli_z),'k','LineWidth',lw);
hold on
dump2=Ez_avgt_i;
plot(yll,dump2(:,sli_z),'r','LineWidth',lw);
caxlim=max(max(abs(dump))).*frac;
caxlim = 0.002;
%ylim([-caxlim, caxlim]);
xlabel('y/d_i');
title('vexB_z');
hold off
%camroll(-90)
%--------------------------------------------------------------------------


% E, B, vxB, 2D
%--------------------------------------------------------------------------
f5=figure(5)
h1=subplot(3,3,1);
dump = v_ex_avgt_i ;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
colorbar; colormap(h1,BWR); caxlim=max(max(abs(dump))).*frac;
caxis([-caxlim, caxlim]);
title('vex');
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
xlabel('z/d_i'); ylabel('y/d_i');
xline(zll(sli_z),'--k','LineWidth',lw);
hold off
h1=subplot(3,3,2);
dump = v_ey_avgt_i ;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
colorbar; colormap(h1,BWR); caxlim=max(max(abs(dump))).*frac;
caxis([-caxlim, caxlim]);
title('vey');
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
xlabel('z/d_i'); ylabel('y/d_i');
xline(zll(sli_z),'--k','LineWidth',lw);
hold off
h1=subplot(3,3,3);
dump = v_ez_avgt_i ;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
colorbar; colormap(h1,BWR); caxlim=max(max(abs(dump))).*frac;
caxis([-caxlim, caxlim]);
title('vez');
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
xlabel('z/d_i'); ylabel('y/d_i');
xline(zll(sli_z),'--k','LineWidth',lw);
hold off

h1=subplot(3,3,4);
dump = Bx_avgt_i ;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
colorbar; title('Bx');
colormap(h1,BWR); caxlim=max(max(abs(dump))).*frac;
caxis([-caxlim, caxlim]);
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
xlabel('z/d_i'); ylabel('y/d_i');
xline(zll(sli_z),'--k','LineWidth',lw);
hold off
h1=subplot(3,3,5);
dump = By_avgt_i ;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
colorbar; title('By');
colormap(h1,BWR); caxlim=max(max(abs(dump))).*frac;
caxis([-caxlim, caxlim]);
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
xlabel('z/d_i'); ylabel('y/d_i');
xline(zll(sli_z),'--k','LineWidth',lw);
hold off
h1=subplot(3,3,6);
dump = Bz_avgt_i ;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
colorbar; title('Bz');
colormap(h1,BWR); caxlim=max(max(abs(dump))).*frac;
caxis([-caxlim, caxlim]);
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
xlabel('z/d_i'); ylabel('y/d_i');
xline(zll(sli_z),'--k','LineWidth',lw);
hold off

h1=subplot(3,3,7);
dump = (v_ey_avgt_i.*Bz_avgt_i - v_ez_avgt_i.*By_avgt_i)/V_ish;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
colorbar; title('vexB_x');
colormap(h1,BWR); caxlim=max(max(abs(dump))).*frac;
caxis([-caxlim, caxlim]);
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
xlabel('z/d_i'); ylabel('y/d_i');
xline(zll(sli_z),'--k','LineWidth',lw);
hold off
h1=subplot(3,3,8);
dump = (v_ez_avgt_i.*Bx_avgt_i - v_ex_avgt_i.*Bz_avgt_i)/V_ish;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
colorbar; title('vexB_y');
colormap(h1,BWR); caxlim=max(max(abs(dump))).*frac;
caxis([-caxlim, caxlim]);
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
xlabel('z/d_i'); ylabel('y/d_i');
xline(zll(sli_z),'--k','LineWidth',lw);
hold off
h1=subplot(3,3,9);
dump = (v_ex_avgt_i.*By_avgt_i - v_ey_avgt_i.*Bz_avgt_i)/V_ish;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
colorbar; title('vexB_z');
colormap(h1,BWR); caxlim=max(max(abs(dump))).*frac;
caxis([-caxlim, caxlim]);
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
xlabel('z/d_i'); ylabel('y/d_i');
xline(zll(sli_z),'--k','LineWidth',lw);
hold off
%camroll(-90)
%--------------------------------------------------------------------------




% Checking the pressure balance again in this file.
%--------------------------------------------------------------------------
% For the initial time, using only one time and no average the pressure
% balance is true
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

% % for the last ouput (single) 
% %--------------------------------------------------------------------------
% p_e_s_2 = (Pij_e_ba_xx + Pij_e_ba_yy + Pij_e_ba_zz)/3 + (Pij_e_up_xx + Pij_e_up_yy + Pij_e_up_zz)/3; 
% p_i_s_2 = (Pij_i_ba_xx + Pij_i_ba_yy + Pij_i_ba_zz)/3 + (Pij_i_up_xx + Pij_i_up_yy + Pij_i_up_zz)/3; 
% %p_i_s = p_i_s/1;
% p_m = 0.5 .*(Bx_avgt_i.^2 + By_avgt_i.^2 + Bz_avgt_i.^2 );
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

%--------------------------------------------------------------------------


% % here is where I chose the values for the 1D cuts
% %----------------------------------------------------------------------
%DUM = 0.*E_in{1,1};
ssz=size(DUM);
%----------------------------------------------------------------------
xlim_a = -4; xlim_b = 4;
ylim_a = -4; ylim_b = 4;
%-------------------------
%-------------------------
elim=0.3;
jlim0 = -0.1;
jlim1 = 0.1;
%-------------------------
%--------------------------------------------------------------------------
x0=45;y0=54;xx1=810;yy1=710;

f6=figure(6);
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
f7=figure(7);
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
%ylim([-0.01, 0.05]);
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



f9=figure(9);
%set(gcf,'Visible', 'off');
set(gcf,'position',[x0,y0,xx1,yy1])
%------------------------------------
dum_1 = (Pij_e_zz_avgt_i + Pij_i_zz_avgt_i).*n_e_avgt_i +  (0.5 .*(Bx_avgt_i.^2 + By_avgt_i.^2 + Bz_avgt_i.^2 ));
plot(yll,dum_1(:,sli_z),'b','LineWidth',lw);


%--------------------------------------------------------------------------
cd(path)
saveas(f1,strcat('Ohms_x_terms_components' + string(JN) +'.png'));
saveas(f2,strcat('Ohms_x_terms_two_ways' + string(JN) +'.png'));

saveas(f3,strcat('log_E_log_E' + string(JN) +'.png'));

saveas(f4,strcat('ve_B_vexB_x_y_z_1D' + string(JN) +'.png'));
saveas(f5,strcat('ve_B_vexB_x_y_z_2D' + string(JN) +'.png'));

saveas(f6,strcat('pressure_balance' + string(JN) +'.png'));
saveas(f7,strcat('pressure_components' + string(JN) +'.png'));
%--------------------------------------------------------------------------











