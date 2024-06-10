% To read the fields file and to get the energy densities

% This is for the localization study
%--------------------------------------------------------------------------
path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_many_Ax_large_L8di_dB01_Omc1_kLd1_local_3';
%--------------------------------------------------------------------------

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

% Change this accordingly
%--------------------------------------------------------------------------
% This file still requires to check the normalization
%--------------------------------------------------------------------------
% Normalization
%B are normalized to the background magnetic field
B0 = 0.2;
%n is normalise to the proton density n0=1
n0 = 1;
Vai = 0.2;
Vae = 0.2;
E0 = 0.2;
T0 = 0.02;
J0 = Vae;
omega_pe_Omega_ce=5;
nb_n0 = 0.1;
Vai_b = Vai/sqrt(nb_n0);
Vae_b = Vae/sqrt(nb_n0);
VA2c = 0.2;
%--------------------------------------------------------------------------

%Normalising only when making plots
%--------------------------------------------------------------------------
kb = 1.;
mu0 =1.;
c=1;
q = 1;
mime = 1.;
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

% Select the central
JN=40;

% This is to select 
%--------------------------------------------------------------------------
dab = 1; % this needs to be related to the gyro frequency or something
%--------------------------------------------------------------------------

% This is to select a
%--------------------------------------------------------------------------
j_a = JN - dab;
j_b = JN + dab;
j_a_b = j_b - j_a;
%----------------------------------------------------------------------

%--------------------------------------------------------------------------
E_in = cell(3,j_a_b);
B_in = cell(3,j_a_b);
J_in = cell(3,j_a_b);
n_in = cell(2,j_a_b);
v_i_in = cell(3,j_a_b);
v_e_in = cell(3,j_a_b);
Pij_i_in = cell(6,j_a_b);
Pij_e_in = cell(6,j_a_b);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
U_kinetic_ion = cell(1,j_a_b);
U_kinetic_ele = cell(1,j_a_b);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
for jn=j_a:j_b
    %for jn=1:N
    %----------------------------------------------------------------------
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

    % This is considering the two populations for each species
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
    %----------------------------------------------------------------------

    % densities
    %----------------------------------------------------------------------
    n_e_up0=h5read(fileID2,strcat(moments_1st,'/rho_e_UP/p0/3d'));
    n_i_up0=h5read(fileID2,strcat(moments_1st,'/rho_i_UP/p0/3d'));
    n_e_ba0=h5read(fileID2,strcat(moments_1st,'/rho_e_BA/p0/3d'));
    n_i_ba0=h5read(fileID2,strcat(moments_1st,'/rho_i_BA/p0/3d'));
    n_e_up0=-1.*n_e_up0;
    n_e_ba0=-1.*n_e_ba0;

    n_e0=(n_e_up0 + n_e_ba0)./1;
    n_i0=(n_i_up0 + n_i_ba0)./1;
    %----------------------------------------------------------------------

    % This is to remove the zeros that will create Nans when computing v=nv/n 
    %----------------------------------------------------------------------    
    n_e0(n_e0==0)=1e-20;
    n_i0(n_i0==0)=1e-20;
    n_e_up0(n_e_up0==0)=1e-20;
    n_i_up0(n_i_up0==0)=1e-20;
    n_e_ba0(n_e_ba0==0)=1e-20;
    n_i_ba0(n_i_ba0==0)=1e-20;    
    %----------------------------------------------------------------------    

    %----------------------------------------------------------------------        
    n_e{1,1} = n_e0;
    n_i{1,1} = n_i0;
    n_e_up{1,1} = n_e_up0;
    n_i_up{1,1} = n_i_up0;
    n_e_ba{1,1} = n_e_ba0;
    n_i_ba{1,1} = n_i_ba0;
    %----------------------------------------------------------------------

    clearvars n_i_ba0 n_i_up0 n_e_ba0 n_e_up0 n_i0 n_e0

    % p correction so it is not nv anymore but just v
    %----------------------------------------------------------------------
    p_e_up{1,1}=p_e_up{1,1}./n_e_up{1,1};
    p_e_up{1,2}=p_e_up{1,2}./n_e_up{1,1};
    p_e_up{1,3}=p_e_up{1,3}./n_e_up{1,1};

    p_i_up{1,1}=p_i_up{1,1}./n_i_up{1,1};
    p_i_up{1,2}=p_i_up{1,2}./n_i_up{1,1};
    p_i_up{1,3}=p_i_up{1,3}./n_i_up{1,1};

    p_e_ba{1,1}=p_e_ba{1,1}./n_e_ba{1,1};
    p_e_ba{1,2}=p_e_ba{1,2}./n_e_ba{1,1};
    p_e_ba{1,3}=p_e_ba{1,3}./n_e_ba{1,1};

    p_i_ba{1,1}=p_i_ba{1,1}./n_i_ba{1,1};
    p_i_ba{1,2}=p_i_ba{1,2}./n_i_ba{1,1};
    p_i_ba{1,3}=p_i_ba{1,3}./n_i_ba{1,1};
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    p_e{1,1}=(p_e_up{1,1} + p_e_ba{1,1})./1;
    p_e{1,2}=(p_e_up{1,2} + p_e_ba{1,2})./1;
    p_e{1,3}=(p_e_up{1,3} + p_e_ba{1,3})./1;

    p_i{1,1}=(p_i_up{1,1} + p_i_ba{1,1})./1;
    p_i{1,2}=(p_i_up{1,2} + p_i_ba{1,2})./1;
    p_i{1,3}=(p_i_up{1,3} + p_i_ba{1,3})./1;
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
        v_e{1,i} = (p_e{1,i} .* c ./ sqrt(c^2 .* me^2 + p_e{1,i}.^2))./1; % Do I need to do this normalization by VA2c
        v_i{1,i} = (p_i{1,i} .* c ./ sqrt(c^2 .* mi^2 + p_i{1,i}.^2))./1;
        v_e_up{1,i} = (p_e_up{1,i} .* c ./ sqrt(c^2 .* me^2 + p_e_up{1,i}.^2))./1;
        v_i_up{1,i} = (p_i_up{1,i} .* c ./ sqrt(c^2 .* mi^2 + p_i_up{1,i}.^2))./1;
        v_e_ba{1,i} = (p_e_ba{1,i} .* c ./ sqrt(c^2 .* me^2 + p_e_ba{1,i}.^2))./1;
        v_i_ba{1,i} = (p_i_ba{1,i} .* c ./ sqrt(c^2 .* mi^2 + p_i_ba{1,i}.^2))./1;
    end

    clearvars p_i p_e p_i_up p_e_up p_i_ba p_e_ba
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
    PPij_i_ba=cell(3,3);
    PPij_e_ba=cell(3,3);
    PPij_i_up=cell(3,3);
    PPij_e_up=cell(3,3);

    for i=1:3
        for j=1:3
            if(isempty(Pij_i_ba{i,j}) == 1) % This is where if P_ba is zero, this should be changed.
                continue
            end
            PPij_i_ba{i,j} = Pij_i_ba{i,j} - 1.*n_i_ba{1,1}.*mi.*v_i_ba{1,i}.*v_i_ba{1,j}; 
            PPij_e_ba{i,j} = Pij_e_ba{i,j} - 1.*n_e_ba{1,1}.*me.*v_e_ba{1,i}.*v_e_ba{1,j};
            PPij_i_up{i,j} = Pij_i_up{i,j} - 1.*n_i_up{1,1}.*mi.*v_i_up{1,i}.*v_i_up{1,j};
            PPij_e_up{i,j} = Pij_e_up{i,j} - 1.*n_e_up{1,1}.*me.*v_e_up{1,i}.*v_e_up{1,j};
        end
    end

    % This is just to rename the variable
    Pij_i_ba = PPij_i_ba;
    Pij_e_ba = PPij_e_ba;
    Pij_i_up = PPij_i_up;
    Pij_e_up = PPij_e_up;

    clearvars Txx_e_ba Txx_e_up Tyy_e_ba Tyy_e_up Tzz_e_ba Tzz_e_up
    clearvars Txy_e_ba Txy_e_up Txz_e_ba Txz_e_up Tyz_e_ba Tyz_e_up
    clearvars Txx_i_ba Txx_i_up Tyy_i_ba Tyy_i_up Tzz_i_ba Tzz_i_up
    clearvars Txy_i_ba Txy_i_up Txz_i_ba Txz_i_up Tyz_i_ba Tyz_i_up
    clearvars PPij_i PPij_e
    %----------------------------------------------------------------------

    % This is to select a 2D slice only
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
    %---------------------------------------------------------------------

    clearvars E B J
    %---------------------------------------------------------------------

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
    %---------------------------------------------------------------------

    %clearvars v_i_up v_e_up v_i_ba v_e_ba %<----
    %---------------------------------------------------------------------
    n_i = n_i{1,1}; n_i = squeeze(n_i(sli_x,:,:));
    n_e = n_e{1,1}; n_e = squeeze(n_e(sli_x,:,:));

    Pij_i_xx =  Pij_i_ba{1,1} +  Pij_i_up{1,1}; Pij_i_xx = squeeze(Pij_i_xx(sli_x,:,:));
    Pij_i_xy =  Pij_i_ba{1,2} +  Pij_i_up{1,2}; Pij_i_xy = squeeze(Pij_i_xy(sli_x,:,:));
    Pij_i_xz =  Pij_i_ba{1,3} +  Pij_i_up{1,3}; Pij_i_xz = squeeze(Pij_i_xz(sli_x,:,:));
    Pij_i_yy =  Pij_i_ba{2,2} +  Pij_i_up{2,2}; Pij_i_yy = squeeze(Pij_i_yy(sli_x,:,:));
    Pij_i_yz =  Pij_i_ba{2,3} +  Pij_i_up{2,3}; Pij_i_yz = squeeze(Pij_i_yz(sli_x,:,:));
    Pij_i_zz =  Pij_i_ba{3,3} +  Pij_i_up{3,3}; Pij_i_zz = squeeze(Pij_i_zz(sli_x,:,:));

    Pij_e_xx =  Pij_e_ba{1,1} +  Pij_e_up{1,1}; Pij_e_xx = squeeze(Pij_e_xx(sli_x,:,:));
    Pij_e_xy =  Pij_e_ba{1,2} +  Pij_e_up{1,2}; Pij_e_xy = squeeze(Pij_e_xy(sli_x,:,:));
    Pij_e_xz =  Pij_e_ba{1,3} +  Pij_e_up{1,3}; Pij_e_xz = squeeze(Pij_e_xz(sli_x,:,:));
    Pij_e_yy =  Pij_e_ba{2,2} +  Pij_e_up{2,2}; Pij_e_yy = squeeze(Pij_e_yy(sli_x,:,:));
    Pij_e_yz =  Pij_e_ba{2,3} +  Pij_e_up{2,3}; Pij_e_yz = squeeze(Pij_e_yz(sli_x,:,:));
    Pij_e_zz =  Pij_e_ba{3,3} +  Pij_e_up{3,3}; Pij_e_zz = squeeze(Pij_e_zz(sli_x,:,:));

    clearvars v_i_up v_e_up v_i_ba v_e_ba v_i v_e
    clearvars Pij_i Pij_e
    clearvars Pij_e_ba Pij_e_up  Pij_i_ba Pij_i_up
    clearvars PPij_e_ba PPij_e_up PPij_i_ba PPij_i_up
    %----------------------------------------------------------------------


    % Save the data for the time average
    %----------------------------------------------------------------------
    inn=(jn - j_a +1); % This has to be properly set to compute this for every time.
    % This fills in the array of values for the window moving with the central
    % value
    
    %----------------------------------------------------------------------    
    sigma_g=10; % this is for the smoothing.
    %----------------------------------------------------------------------

    % This is to smooth out the noise
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

    v_i_in{1,inn} = imgaussfilt(v_ix ,sigma_g);
    v_i_in{2,inn} = imgaussfilt(v_iy ,sigma_g);
    v_i_in{3,inn} = imgaussfilt(v_iz ,sigma_g);

    v_e_in{1,inn} = imgaussfilt(v_ex ,sigma_g);
    v_e_in{2,inn} = imgaussfilt(v_ey ,sigma_g);
    v_e_in{3,inn} = imgaussfilt(v_ez ,sigma_g);

    Pij_i_in{1,inn} = imgaussfilt(Pij_i_xx ,sigma_g);
    Pij_i_in{2,inn} = imgaussfilt(Pij_i_xy ,sigma_g);
    Pij_i_in{3,inn} = imgaussfilt(Pij_i_xz ,sigma_g);
    Pij_i_in{4,inn} = imgaussfilt(Pij_i_yy ,sigma_g);
    Pij_i_in{5,inn} = imgaussfilt(Pij_i_yz ,sigma_g);
    Pij_i_in{6,inn} = imgaussfilt(Pij_i_zz ,sigma_g);

    Pij_e_in{1,inn} = imgaussfilt(Pij_e_xx ,sigma_g);
    Pij_e_in{2,inn} = imgaussfilt(Pij_e_xy ,sigma_g);
    Pij_e_in{3,inn} = imgaussfilt(Pij_e_xz ,sigma_g);
    Pij_e_in{4,inn} = imgaussfilt(Pij_e_yy ,sigma_g);
    Pij_e_in{5,inn} = imgaussfilt(Pij_e_yz ,sigma_g);
    Pij_e_in{6,inn} = imgaussfilt(Pij_e_zz ,sigma_g);
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    clearvars Ex Ey Ez Bx By Bz Jx Jy Jz n_i n_e n_i_up n_i_ba n_e_up n_e_ba
    clearvars v_ix v_iy v_iz v_ex v_ey v_ez
    clearvars v_i_bax v_i_bay v_i_baz v_e_bax v_e_bay v_e_baz
    clearvars v_i_upx v_i_upy v_i_upz v_e_upx v_e_upy v_e_upz
    clearvars Pij_e_xx Pij_e_xy Pij_e_xz Pij_e_yy Pij_e_yz Pij_e_zz
    clearvars Pij_i_xx Pij_i_xy Pij_i_xz Pij_i_yy Pij_i_yz Pij_i_zz
    %----------------------------------------------------------------------

    % compute the kineti energy density

    U_kinetic_ion{1,inn} = 0.5 .* mi .* n_in{2,inn} .* (v_i_in{1,inn}.^2 + v_i_in{2,inn}.^2 + v_i_in{3,inn}.^2);
    U_kinetic_ele{1,inn} = 0.5 .* me .* n_in{1,inn} .* (v_e_in{1,inn}.^2 + v_e_in{2,inn}.^2 + v_e_in{3,inn}.^2);

end


%Make a few plots
%--------------------------------------------------------------------------
fs=18;
%--------------------------------------------------------------------------

sss=size(B_in{1,1});
size_X=sss;
zll=linspace(-Lz,Lz,size_X(2)); %Jeff flag it works with (1,size_x(2))
yll=linspace(-Ly,Ly,size_X(1));
[ZLL, YLL] = meshgrid(zll,yll);

%--------------------------------------------------------------------------
f1=figure(1);
h1=subplot(1,1,1);
dump = U_kinetic_ion{1,inn};
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
%xline(zll(sli_z),'--k','LineWidth',lw);
ax.FontSize=fs;
lgnd=legend([h1],'$U_{k,i}$','Interpreter','latex','FontSize',fs);
hold off
