% THIS IS for the relative for the 3 components
%


path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_large_current'; % beta 02
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_large_05_current'; %beta 05
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_extlarge_current'; % beta 02
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_extlarge_05_current'; %beta 05

%-----------------------------------------------------------------------------------------------------------------------

% For the scripts
path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
path_color = '/home/UNN/pfcy6/codes/processing_scripts/Matlab_Scripts_Laptop';

%-----------------------------------------------------------------------------------------------------------------------

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

%--------------------------------------------------------------------------
%B are normalized to the background magnetic field
B0=0.1;
%n is normalise to the proton density n0=1
n0=1;
%Vi normalised to the proton alfven speed V_a=0.1c The alfven speed of
%electrons is Vae=10Vai
%--------------------------------------------------------------------------
mime = input ('mime value ');
nb_n0 =1;
kb = 1.; mu0 =1.; c=1; q = 1;
Vai=0.1;
Vae=0.1;%0.2;
Va=0.1;%0.2;
Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);
%mime =100.;
mi = mime;
me = 1; eps0=1.;
m = mi + me;
%--------------------------------------------------------------------------

absolute = input ('to compute the abs = 1; no absolute = 0   ');
l_wind_x = input('Window size in di:'  );

%--------------------------------------------------------------------------
omega_pe_Omega_ce=10;
omega_pi=1;
Omega_e=Vai*sqrt(mime)*omega_pi;
Omega_i=Omega_e / mime;
TOmega_e=1/Omega_e;
TOmega_i=1/Omega_i;
%--------------------------------------------------------------------------
in=1;
fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;
%%%
Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
By=squeeze(h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d')));
Bz=squeeze(h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d')));
Ns=size(squeeze(Bx));
grid_length = info.Groups(17).Attributes;
Lx=grid_length(4).Value(1) - grid_length(3).Value(1); %(This is in de The substraction give the total size of the domain) -Lx0 to Lx0
Ly=grid_length(4).Value(2) - grid_length(3).Value(2);
Lz=grid_length(4).Value(3) - grid_length(3).Value(3);
nx = Ns(1,1);
nz = Ns(1,2);
% Generate grid
xl = linspace(0, Lx, nx);
zl = linspace(0, Lz, nz);
xl_di = xl/sqrt(mime);
zl_di = zl/sqrt(mime);
[Z, X] = meshgrid(xl_di, zl_di);
B_mag = sqrt(Bx.^2 + Bz.^2 + (By-B0).^2);
Tau_nl = xl_di(end)*B0/(mean(B_mag,"all")*Vai_b);
in=10;
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%in=input('select the time stamp: ');

MHD_E2vxB_mean=zeros(1,N);
MHD_vxB2vxB_mean=zeros(1,N);
MHD_JxB2vxB_mean =zeros(1,N);
MHD_divP2vxB_mean = zeros(1,N);
MHD_divvJall2vxB_mean = zeros(1,N);
MHD_RHS2vxB_mean = zeros(1,N);

SGS_tau_nE_mean2vxB_mean = zeros(1,N);
SGS_tau_vxB_mean2vxB_mean = zeros(1,N);
SGS_tau_JxB_mean2vxB_mean = zeros(1,N);
SGS_tau_Div_mean2vxB_mean = zeros(1,N);
SGS_tau_total_mean2vxB_mean = zeros(1,N);

time_in = zeros(1,N2);

for in=1:N

    fileID =  S(in).name; %change the 1 per i
    %h5disp(fileID);
    info = h5info(fileID);
    EHJ_1st = info.Groups(16).Name;
    B=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    %--------------------------------------------------------------------------
    ss=size(B);
    LXs=ss(1); LYs=ss(2); LZs=ss(3);
    clearvars B
    N_jn=N;
    % %--------------------------------------------------------------------
    % % Making a plot for B2 as a function of time to see the growth rate of
    % the instability
    % %--------------------------------------------------------------------

    %--------------------------------------------------------------------------
    nx1=1;    nx2=LXs;
    ny1=1;    ny2=LYs;
    nz1=1;    nz2=LZs;

    px2 = nx2; py2 = ny2; pz2 = nz2;
    start = [nx1 ny1 nz1];
    count = [px2 py2 pz2];
    %------------------------------------------------------------------

    %------------------------------------------------------------------
    disp(strcat('Computing step ...',S(in).name))
    fileID =  S(in).name; %change the 1 per i
    %h5disp(fileID);
    info = h5info(fileID);
    EHJ_1st = info.Groups(16).Name;
    grid_dt = info.Groups(20).Attributes;

    grid_length = info.Groups(17).Attributes;
    Lx=grid_length(4).Value(1) - grid_length(3).Value(1); %(The substraction give the total size of the domain) -Lx0 to Lx0
    Ly=grid_length(4).Value(2) - grid_length(3).Value(2);
    Lz=grid_length(4).Value(3) - grid_length(3).Value(3);
    %------------------------------------------------------------------

    %------------------------------------------------------------------
    %To make the coordinate transformation
    %------------------------------------------------------------------
    % Get the fiel name and remove the prt.
    stri = S(in).name;
    newStri = erase(stri,"pfd.");

    % load the field files
    Sm = dir(fullfile(path,'pfd_moments.*.h5'));
    Nf=numel(Sm); % number of files to use

    %The idea is to find the index that corresponds to the file that has
    %the same name as in the prt info
    Nff = {Sm.name};
    Xff = contains(Nff,num2str(newStri));
    jjn=find(Xff==1); % this finds the index
    %Nff{Xff}
    %------------------------------------------------------------------

    %------------------------------------------------------------------
    disp(strcat('Computing step ...',S2(jjn).name))
    fileID2 =  S2(jjn).name; %change the 1 per i
    %h5disp(fileID2);
    info2 = h5info(fileID2);
    moments_1st = info2.Groups(1).Name;
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    xl = linspace(-Lx/2,Lx/2,LXs);
    yl = linspace(-Ly/2,Ly/2,LYs);
    zl = linspace(-Lz/2,Lz/2,LZs);
    %----------------------------------------------------------------------

    % Here is where the parameter for the scale filtering are defined (the size of the window)
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    % define the window for the kernel and convolution

    %for ndv =1:10
    ndv = 1; % fractiopn of the box size. create a patch for the size of the convolution window
    %l_wind_x = LXs/ndv; %size of the window

    resx = Lx/LXs;
    resy = Ly/LYs;
    resz = Lz/LZs;
    %----------------------------------------------------------------------

    % Maybe it is better to define this in terms of the real resolution
    %----------------------------------------------------------------------

    %l_wind_x = 5;

    fprintf('\n');

    l_wind_y = l_wind_x;
    l_wind_z = l_wind_x;

    [XL3d, YL3d, ZL3d] = meshgrid(xl,yl,zl);
    %----------------------------------------------------------------------



    % % This is the core and bulky part. Do not erase!
    % %----------------------------------------------------------------------
    % %----------------------------------------------------------------------
    %
    %----------------------------------------------------------------------
    B{1,1}=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'),start,count);
    B{1,2}=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'),start,count);
    B{1,3}=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'),start,count);

    B{1,1} = squeeze(B{1,1});
    B{1,2} = squeeze(B{1,2});
    B{1,3} = squeeze(B{1,3});
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    E{1,1}=h5read(fileID,strcat(EHJ_1st,'/ex_ec/p0/3d'),start,count);
    E{1,2}=h5read(fileID,strcat(EHJ_1st,'/ey_ec/p0/3d'),start,count);
    E{1,3}=h5read(fileID,strcat(EHJ_1st,'/ez_ec/p0/3d'),start,count);

    E{1,1} = squeeze(E{1,1});
    E{1,2} = squeeze(E{1,2});
    E{1,3} = squeeze(E{1,3});
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    J{1,1}=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'),start,count);
    J{1,2}=h5read(fileID,strcat(EHJ_1st,'/jy_ec/p0/3d'),start,count);
    J{1,3}=h5read(fileID,strcat(EHJ_1st,'/jz_ec/p0/3d'),start,count);

    J{1,1} = squeeze(J{1,1});
    J{1,2} = squeeze(J{1,2});
    J{1,3} = squeeze(J{1,3});
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    p_e{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e/p0/3d'),start,count);
    p_e{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e/p0/3d'),start,count);
    p_e{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e/p0/3d'),start,count);

    p_e{1,1} = squeeze(p_e{1,1});
    p_e{1,2} = squeeze(p_e{1,2});
    p_e{1,3} = squeeze(p_e{1,3});

    p_i{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i/p0/3d'),start,count);
    p_i{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i/p0/3d'),start,count);
    p_i{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i/p0/3d'),start,count);

    p_i{1,1} = squeeze(p_i{1,1});
    p_i{1,2} = squeeze(p_i{1,2});
    p_i{1,3} = squeeze(p_i{1,3});
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    n_e0{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_e/p0/3d'),start,count);
    n_i0{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_i/p0/3d'),start,count);

    n_e0 = squeeze(n_e0{1,1});
    n_i0 = squeeze(n_i0{1,1});

    n_e0=-1.*n_e0;
    n_e0(n_e0==0)=1e-20;
    n_i0(n_i0==0)=1e-20;
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    p_e{1,1}=p_e{1,1}./n_e0;
    p_e{1,2}=p_e{1,2}./n_e0;
    p_e{1,3}=p_e{1,3}./n_e0;

    p_i{1,1}=p_i{1,1}./n_i0;
    p_i{1,2}=p_i{1,2}./n_i0;
    p_i{1,3}=p_i{1,3}./n_i0;
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    v_e=cell(1,3);
    v_i=cell(1,3);
    for i=1:3
        v_e{1,i} = (p_e{1,i} .* c ./ sqrt(c^2 .* me^2 + p_e{1,i}.^2)); % Do I need to do this normalization by VA2c
        v_i{1,i} = (p_i{1,i} .* c ./ sqrt(c^2 .* mi^2 + p_i{1,i}.^2));
    end
    clearvars p_i p_e p_i_up p_e_up
    %----------------------------------------------------------------------


    %----------------------------------------------------------------------
    Pij_e{1,1}=h5read(fileID2,strcat(moments_1st,'/txx_e/p0/3d'),start,count);
    Pij_e{2,2}=h5read(fileID2,strcat(moments_1st,'/tyy_e/p0/3d'),start,count);
    Pij_e{3,3}=h5read(fileID2,strcat(moments_1st,'/tzz_e/p0/3d'),start,count);
    Pij_e{1,2}=h5read(fileID2,strcat(moments_1st,'/txy_e/p0/3d'),start,count);
    Pij_e{1,3}=h5read(fileID2,strcat(moments_1st,'/tzx_e/p0/3d'),start,count);
    Pij_e{2,3}=h5read(fileID2,strcat(moments_1st,'/tyz_e/p0/3d'),start,count);

    Pij_e{1,1} = squeeze(Pij_e{1,1});
    Pij_e{2,2} = squeeze(Pij_e{2,2});
    Pij_e{3,3} = squeeze(Pij_e{3,3});
    Pij_e{1,2} = squeeze(Pij_e{1,2});
    Pij_e{1,3} = squeeze(Pij_e{1,3});
    Pij_e{2,3} = squeeze(Pij_e{2,3});

    Pij_e{2,1} = Pij_e{1,2}; Pij_e{3,2} = Pij_e{2,3}; Pij_e{3,1} = Pij_e{1,3};


    %pressure_ion = input('compute pressure terms 1 (true) 0(false) (integer):');

    pressure_ion = 0;

    fprintf('\n');

    if(pressure_ion == 1)
        Pij_i{1,1}=h5read(fileID2,strcat(moments_1st,'/txx_i/p0/3d'),start,count);
        Pij_i{2,2}=h5read(fileID2,strcat(moments_1st,'/tyy_i/p0/3d'),start,count);
        Pij_i{3,3}=h5read(fileID2,strcat(moments_1st,'/tzz_i/p0/3d'),start,count);
        Pij_i{1,2}=h5read(fileID2,strcat(moments_1st,'/txy_i/p0/3d'),start,count);
        Pij_i{1,3}=h5read(fileID2,strcat(moments_1st,'/tzx_i/p0/3d'),start,count);
        Pij_i{2,3}=h5read(fileID2,strcat(moments_1st,'/tyz_i/p0/3d'),start,count);

        Pij_i{1,1} = squeeze(Pij_i{1,1});
        Pij_i{2,2} = squeeze(Pij_i{2,2});
        Pij_i{3,3} = squeeze(Pij_i{3,3});
        Pij_i{1,2} = squeeze(Pij_i{1,2});
        Pij_i{1,3} = squeeze(Pij_i{1,3});
        Pij_i{2,3} = squeeze(Pij_i{2,3});

        Pij_i{2,1} = Pij_i{1,2}; Pij_i{3,2} = Pij_i{2,3}; Pij_i{3,1} = Pij_i{1,3};
    end
    %----------------------------------------------------------------------

    % This is to get the central momment pressure.
    %----------------------------------------------------------------------
    PPij_i=cell(3,3);
    PPij_e=cell(3,3);

    for i=1:3
        for j=1:3
            if(isempty(Pij_e{i,j}) == 1) % This is where if P_ba is zero, this should be changed.
                continue
            end
            if(pressure_ion == 1)
                PPij_i{i,j} = Pij_i{i,j} - 1.*n_i0.*mi.*v_i{1,i}.*v_i{1,j};
            end
            PPij_e{i,j} = Pij_e{i,j} - 1.*n_e0.*me.*v_e{1,i}.*v_e{1,j};
        end
    end

    % remove the variables just to rename them again
    clearvars Pij_i Pij_e

    % This is just to rename the variable
    if(pressure_ion == 1)
        Pij_i = PPij_i;
    end

    Pij_e = PPij_e;

    clearvars PPij_i PPij_e
    %----------------------------------------------------------------------

    %--------------------------------------------------------------------
    % Apply a filter to the very noisy electric field.

    %--------------------------------------------------------------------
    % Apply a filter to the very noisy electric field.
    Lx_di=Lx/sqrt(mime); % Using this thefilter is in terms of di
    Lz_di=Lz/sqrt(mime);

    kx=((0:LXs-1)).*2*pi/Lx_di;%Includes negative wavenumbers and as it is k_max = pi/resx
    kz=((0:LZs-1)).*2*pi/Lz_di; % this is in terms of di

    [Kz, Kx] = meshgrid(kz, kx); % Note the order here Kz goes first
    Dx = Lx_di/nx2; %<<<---- this considers the ks in terms of di (so it is the resolution in terms of de and this has an impact on how the k filter works)

    % % %----------------------------------------------------------------------
    % DEFINE THE Ks JUST ONCE % This is for the filter only
    % % %----------------------------------------------------------------------
    resx = Lx_di/LXs; %in di
    resz = Lz_di/LZs; %in di
    threshold=pi/resx; %in di
    %----------------------------------------------------------------------

    n_e0_dt = n_e0;
    n_i0_dt = n_i0;
    n_0_dt = (n_e0_dt.*me + n_i0_dt.*mi)./(me + mi);

    n_e0_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,n_e0_dt);
    n_i0_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,n_i0_dt);
    n_0_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,n_0_dt);

    clearvars n_e0 n_i0

    v_ex_dt=v_e{1,1};
    v_ey_dt=v_e{1,2};
    v_ez_dt=v_e{1,3};

    v_ex_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,v_ex_dt);
    v_ey_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,v_ey_dt);
    v_ez_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,v_ez_dt);

    v_ix_dt=v_i{1,1};
    v_iy_dt=v_i{1,2};
    v_iz_dt=v_i{1,3};

    v_ix_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,v_ix_dt);
    v_iy_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,v_iy_dt);
    v_iz_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,v_iz_dt);

    clearvars v_i v_e

    v_x_dt = (me.*n_e0_dt.*v_ex_dt + mi.*n_i0_dt.*v_ix_dt)./(me.*n_e0_dt + mi.*n_i0_dt);
    v_y_dt = (me.*n_e0_dt.*v_ey_dt + mi.*n_i0_dt.*v_iy_dt)./(me.*n_e0_dt + mi.*n_i0_dt);
    v_z_dt = (me.*n_e0_dt.*v_ez_dt + mi.*n_i0_dt.*v_iz_dt)./(me.*n_e0_dt + mi.*n_i0_dt);

    if(pressure_ion == 1)
        Pij_ixx_dt=Pij_i{1,1};
        Pij_ixy_dt=Pij_i{1,2};
        Pij_ixz_dt=Pij_i{1,3};
        Pij_iyy_dt=Pij_i{2,2};
        Pij_iyz_dt=Pij_i{2,3};
        Pij_izz_dt=Pij_i{3,3};

        Pij_ixx_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,Pij_ixx_dt);
        Pij_iyy_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,Pij_iyy_dt);
        Pij_izz_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,Pij_izz_dt);
        Pij_ixy_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,Pij_ixy_dt);
        Pij_ixz_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,Pij_ixz_dt);
        Pij_iyz_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,Pij_iyz_dt);

    end

    %Pij_iyx_dt = Pij_ixy_dt; Pij_izx_dt = Pij_ixz_dt; Pij_izy_dt = Pij_iyz_dt;

    Pij_exx_dt=Pij_e{1,1};
    Pij_exy_dt=Pij_e{1,2};
    Pij_exz_dt=Pij_e{1,3};
    Pij_eyy_dt=Pij_e{2,2};
    Pij_eyz_dt=Pij_e{2,3};
    Pij_ezz_dt=Pij_e{3,3};

    Pij_exx_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,Pij_exx_dt);
    Pij_eyy_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,Pij_eyy_dt);
    Pij_ezz_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,Pij_ezz_dt);
    Pij_exy_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,Pij_exy_dt);
    Pij_exz_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,Pij_exz_dt);
    Pij_eyz_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,Pij_eyz_dt);


    %Pij_eyx_dt = Pij_exy_dt; Pij_ezx_dt = Pij_exz_dt; Pij_ezy_dt = Pij_eyz_dt;

    clearvars Pij_i Pij_e
    %----------------------------------------------------------------------

    Bx_dt=B{1,1};
    By_dt=B{1,2};
    Bz_dt=B{1,3};

    Bx_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,Bx_dt);
    By_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,By_dt);
    Bz_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,Bz_dt);

    Ex_dt=E{1,1};
    Ey_dt=E{1,2};
    Ez_dt=E{1,3};

    Ex_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,Ex_dt);
    Ey_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,Ey_dt);
    Ez_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,Ez_dt);
    clearvars Ex_dt0 Ey_dt0 Ez_dt0

    Jx_dt=J{1,1};
    Jy_dt=J{1,2};
    Jz_dt=J{1,3};
    Dx = Lx/nx2;

    Jx_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,Jx_dt);
    Jy_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,Jy_dt);
    Jz_dt = Gauss_filter_2D_xz(2*Dx,Kx,Kz,Jz_dt);

    clearvars B E J

    %----------------------------------------------------------------------
    %select the component % component x=1, y=2, z=3;
    %component = input('select the component % component x=1, y=2, z=3: ');

    %component = 1;
    %----------------------------------------------------------------------

    % Lets compute the generalised ohms terms for total field
    %----------------------------------------------------------------------
    % Computing non-linear terms for the generalised Ohms law
    %----------------------------------------------------------------------


    v_x_B_x_dt = v_y_dt.*Bz_dt - v_z_dt.*By_dt;
    J_x_B_x_dt = Jy_dt.*Bz_dt - Jz_dt.*By_dt;

    v_x_B_y_dt = v_z_dt.*Bx_dt - v_x_dt.*Bz_dt;
    J_x_B_y_dt = Jz_dt.*Bx_dt - Jx_dt.*Bz_dt;

    v_x_B_z_dt = v_x_dt.*By_dt - v_y_dt.*Bx_dt;
    J_x_B_z_dt = Jx_dt.*By_dt - Jy_dt.*Bx_dt;


    v_J_xx_dt = v_x_dt.*Jx_dt;
    v_J_xy_dt = v_x_dt.*Jy_dt;
    v_J_xz_dt = v_x_dt.*Jz_dt;
    v_J_yx_dt = v_y_dt.*Jx_dt;
    v_J_yy_dt = v_y_dt.*Jy_dt;
    v_J_yz_dt = v_y_dt.*Jz_dt;
    v_J_zx_dt = v_z_dt.*Jx_dt;
    v_J_zy_dt = v_z_dt.*Jy_dt;
    v_J_zz_dt = v_z_dt.*Jz_dt;

    J_v_xx_dt = Jx_dt.*v_x_dt;
    J_v_xy_dt = Jx_dt.*v_y_dt;
    J_v_xz_dt = Jx_dt.*v_z_dt;
    J_v_yx_dt = Jy_dt.*v_x_dt;
    J_v_yy_dt = Jy_dt.*v_y_dt;
    J_v_yz_dt = Jy_dt.*v_z_dt;
    J_v_zx_dt = Jz_dt.*v_x_dt;
    J_v_zy_dt = Jz_dt.*v_y_dt;
    J_v_zz_dt = Jz_dt.*v_z_dt;

    J_J_2n_xx_dt = Jx_dt.*Jx_dt./(n_0_dt );
    J_J_2n_xy_dt = Jx_dt.*Jy_dt./(n_0_dt );
    J_J_2n_xz_dt = Jx_dt.*Jz_dt./(n_0_dt );
    J_J_2n_yy_dt = Jy_dt.*Jy_dt./(n_0_dt );
    J_J_2n_yz_dt = Jy_dt.*Jz_dt./(n_0_dt );
    J_J_2n_zz_dt = Jz_dt.*Jz_dt./(n_0_dt );
    %----------------------------------------------------------------------



    % ------------------->>>>>>>>>   <<<<<<<<<<<<<<<-----------------------
    %----------------------------------------------------------------------
    % this is an important part to update also considering that the magnetic
    % field is staggered
    %----------------------------------------------------------------------
    % ------------------->>>>>>>>>   <<<<<<<<<<<<<<<-----------------------

    %----------------------------------------------------------------------
    %Now let lets compute the gradients. For the magnetic field it requires
    % the Yee grid approach and for the other quantities it can be the FFT

    grad_fact = 1; % This always need to be two??
    sigma_g=1;
    %Grad_Pe
    %----------------------------------------------------------------------

    % %--------------------------------------------------------------------------
    % % Compute wavenumbers for Fourier differentiation
    % kx = 2 * pi * [0:nx2/2 -nx2/2+1:-1] / Lx; % Wavenumbers in x
    % kz = 2 * pi * [0:nz2/2 -nz2/2+1:-1] / Lz; % Wavenumbers in z
    % [Kz, Kx] = meshgrid(kz, kx); % Note the order here Kz goes first
    % Dx = Lx/nx2; Dz = Lz/nz2;
    % %--------------------------------------------------------------------------

    %--------------------------------------------------------------------------
    %[dJx_dx, dJx_dz, dJy_dx, dJy_dz, dJz_dx, dJz_dz] = Derivatives_FFT_vector_2Dxz(Dx,Dz,Kx,Kz,Jx_dt,Jy_dt,Jz_dt);
    %--------------------------------------------------------------------------

    %--------------------------------------------------------------------------
    [Pij_exx_dt_x, Pij_exx_dt_z,...
        Pij_eyy_dt_x, Pij_eyy_dt_z,...
        Pij_ezz_dt_x, Pij_ezz_dt_z,...
        Pij_exy_dt_x, Pij_exy_dt_z,...
        Pij_exz_dt_x, Pij_exz_dt_z,...
        Pij_eyz_dt_x, Pij_eyz_dt_z] = Derivatives_FFT_tensor_2Dxz(Dx,Kx,Kz,...
        Pij_exx_dt, Pij_eyy_dt, Pij_ezz_dt,...
        Pij_exy_dt, Pij_exz_dt, Pij_eyz_dt);


    %----------------------------------------------------------------------

    %----------------------------------------------------------------------

    Div_Pe_dt_x = Pij_exx_dt_x + Pij_exz_dt_z;

    Div_Pe_dt_y = Pij_exy_dt_x + Pij_eyz_dt_z;

    Div_Pe_dt_z = Pij_exz_dt_x + Pij_ezz_dt_z;

    clearvars Pij_exx_dt_* Pij_exy_dt_* Pij_exz_dt_* ...
        Pij_eyy_dt_* Pij_eyz_dt_* Pij_ezz_dt_* ...
        %----------------------------------------------------------------------

    if(pressure_ion == 1)
        %----------------------------------------------------------------------
        [Pij_ixx_dt_x, Pij_exx_dt_z,...
            Pij_iyy_dt_x, Pij_iyy_dt_z,...
            Pij_izz_dt_x, Pij_izz_dt_z,...
            Pij_ixy_dt_x, Pij_ixy_dt_z,...
            Pij_ixz_dt_x, Pij_ixz_dt_z,...
            Pij_iyz_dt_x, Pij_iyz_dt_z] = Derivatives_FFT_tensor_2Dxz(Dx,Kx,Kz,...
            Pij_ixx_dt, Pij_iyy_dt, Pij_izz_dt,...
            Pij_ixy_dt, Pij_ixz_dt, Pij_iyz_dt);
        %----------------------------------------------------------------------

        %----------------------------------------------------------------------

        Div_Pi_dt_x = Pij_ixx_dt_x + Pij_ixz_dt_z;

        Div_Pi_dt_y = Pij_ixy_dt_x + Pij_iyz_dt_z;

        Div_Pi_dt_z = Pij_ixz_dt_x + Pij_izz_dt_z;

        clearvars Pij_ixx_dt_* Pij_ixy_dt_* Pij_ixz_dt_* ...
            Pij_iyy_dt_* Pij_iyz_dt_* Pij_izz_dt_* ...
            %----------------------------------------------------------------------
    end

    %----------------------------------------------------------------------
    [v_J_dt_xx_x, v_J_dt_xx_z,...
        v_J_dt_yy_x, v_J_dt_yy_z,...
        v_J_dt_zz_x, v_J_dt_zz_z,...
        v_J_dt_xy_x, v_J_dt_xy_z,...
        v_J_dt_xz_x, v_J_dt_xz_z,...
        v_J_dt_yz_x, v_J_dt_yz_z] = Derivatives_FFT_tensor_2Dxz(Dx,Kx,Kz,...
        v_J_xx_dt, v_J_yy_dt, v_J_zz_dt,...
        v_J_xy_dt, v_J_xz_dt, v_J_yz_dt);


    [~, ~, ~, ~, ~, ~, ...
        v_J_dt_yx_x, v_J_dt_yx_z,...
        v_J_dt_zx_x, v_J_dt_zx_z,...
        v_J_dt_zy_x, v_J_dt_zy_z] = Derivatives_FFT_tensor_2Dxz(Dx,Kx,Kz,...
        v_J_xx_dt, v_J_yy_dt, v_J_zz_dt,...
        v_J_yx_dt, v_J_zx_dt, v_J_zy_dt);

    %----------------------------------------------------------------------

    %----------------------------------------------------------------------

    Div_vJ_dt_x = v_J_dt_xx_x + v_J_dt_zx_z;

    Div_vJ_dt_y = v_J_dt_xy_x + v_J_dt_zy_z;

    Div_vJ_dt_z = v_J_dt_xz_x + v_J_dt_zz_z;


    clearvars v_J_dt_xx_* v_J_dt_xy_* v_J_dt_xz_* ...
        v_J_dt_yx_* v_J_dt_yy_* v_J_dt_yz_* ...
        v_J_dt_zx_* v_J_dt_zy_* v_J_dt_zz_*
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    [J_v_dt_xx_x, J_v_dt_xx_z,...
        J_v_dt_yy_x, J_v_dt_yy_z,...
        J_v_dt_zz_x, J_v_dt_zz_z,...
        J_v_dt_xy_x, J_v_dt_xy_z,...
        J_v_dt_xz_x, J_v_dt_xz_z,...
        J_v_dt_yz_x, J_v_dt_yz_z] = Derivatives_FFT_tensor_2Dxz(Dx,Kx,Kz,...
        J_v_xx_dt, J_v_yy_dt, J_v_zz_dt,...
        J_v_xy_dt, J_v_xz_dt, J_v_yz_dt);


    [~, ~, ~, ~, ~, ~, ...
        J_v_dt_yx_x, J_v_dt_yx_z,...
        J_v_dt_zx_x, J_v_dt_zx_z,...
        J_v_dt_zy_x, J_v_dt_zy_z] = Derivatives_FFT_tensor_2Dxz(Dx,Kx,Kz,...
        J_v_xx_dt, J_v_yy_dt, J_v_zz_dt,...
        J_v_yx_dt, J_v_zx_dt, J_v_zy_dt);

    %----------------------------------------------------------------------

    %----------------------------------------------------------------------

    Div_Jv_dt_x = J_v_dt_xx_x + J_v_dt_zx_z;

    Div_Jv_dt_y = J_v_dt_xy_x + J_v_dt_zy_z;

    Div_Jv_dt_z = J_v_dt_xz_x + J_v_dt_zz_z;


    clearvars J_v_dt_xx_* J_v_dt_xy_* J_v_dt_xz_* ...
        J_v_dt_yx_* J_v_dt_yy_* J_v_dt_yz_* ...
        J_v_dt_zx_* J_v_dt_zy_* J_v_dt_zz_*
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    [J_J_dt_xx_x, J_J_dt_xx_z,...
        J_J_dt_yy_x, J_J_dt_yy_z,...
        J_J_dt_zz_x, J_J_dt_zz_z,...
        J_J_dt_xy_x, J_J_dt_xy_z,...
        J_J_dt_xz_x, J_J_dt_xz_z,...
        J_J_dt_yz_x, J_J_dt_yz_z] = Derivatives_FFT_tensor_2Dxz(Dx,Kx,Kz,...
        J_J_2n_xx_dt, J_J_2n_yy_dt, J_J_2n_zz_dt,...
        J_J_2n_xy_dt, J_J_2n_xz_dt, J_J_2n_yz_dt);

    %----------------------------------------------------------------------

    %----------------------------------------------------------------------

    Div_JJ_dt_x = J_J_dt_xx_x + J_J_dt_xz_z;

    Div_JJ_dt_y = J_J_dt_xy_x + J_J_dt_yz_z;

    Div_JJ_dt_z = J_J_dt_xz_x + J_J_dt_zz_z;


    clearvars J_J_dt_xx_* J_J_dt_xy_* J_J_dt_xz_* ...
        J_J_dt_yx_* J_J_dt_yy_* J_J_dt_yz_* ...
        J_J_dt_zx_* J_J_dt_zy_* J_J_dt_zz_*
    %----------------------------------------------------------------------


    %(<vJ + Jv - JJ/n> - (<v><J> + <J><v> - <J><J>/<n>))/<n>
    % % %----------------------------------------------------------------------
    sub_tau1_xx = v_J_xx_dt + J_v_xx_dt - J_J_2n_xx_dt;
    sub_tau1_xy = v_J_xy_dt + J_v_xy_dt - J_J_2n_xy_dt;
    sub_tau1_xz = v_J_xz_dt + J_v_xz_dt - J_J_2n_xz_dt;
    sub_tau1_yx = v_J_yx_dt + J_v_yx_dt - J_J_2n_xy_dt;
    sub_tau1_yy = v_J_yy_dt + J_v_yy_dt - J_J_2n_yy_dt;
    sub_tau1_yz = v_J_yz_dt + J_v_yz_dt - J_J_2n_yz_dt;
    sub_tau1_zx = v_J_zx_dt + J_v_zx_dt - J_J_2n_xz_dt;
    sub_tau1_zy = v_J_zy_dt + J_v_zy_dt - J_J_2n_yz_dt;
    sub_tau1_zz = v_J_zz_dt + J_v_zz_dt - J_J_2n_zz_dt;
    % % %----------------------------------------------------------------------

    clearvars v_J_* J_v_* J_J_*

    % These four lines are the filtering
    % here l_wind_x is in terms of de as a resolution
    %----------------------------------------------------------------------
    Bx_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Bx_dt);
    By_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,By_dt);
    Bz_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Bz_dt);

    Ex_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Ex_dt);
    Ey_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Ey_dt);
    Ez_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Ez_dt);

    Jx_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Jx_dt);
    Jy_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Jy_dt);
    Jz_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Jz_dt);

    v_ix_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,v_ix_dt);
    v_iy_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,v_iy_dt);
    v_iz_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,v_iz_dt);

    v_ex_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,v_ex_dt);
    v_ey_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,v_ey_dt);
    v_ez_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,v_ez_dt);

    v_x_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,v_x_dt);
    v_y_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,v_y_dt);
    v_z_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,v_z_dt);

    n_e_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,n_e0_dt);
    n_i_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,n_i0_dt);
    n_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,n_0_dt);

    if(pressure_ion == 1)
        Pij_ixx_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Pij_ixx_dt);
        Pij_ixy_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Pij_ixy_dt);
        Pij_ixz_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Pij_ixz_dt);
        Pij_iyy_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Pij_iyy_dt);
        Pij_iyz_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Pij_iyz_dt);
        Pij_izz_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Pij_izz_dt);
    end

    Pij_exx_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Pij_exx_dt);
    Pij_exy_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Pij_exy_dt);
    Pij_exz_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Pij_exz_dt);
    Pij_eyy_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Pij_eyy_dt);
    Pij_eyz_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Pij_eyz_dt);
    Pij_ezz_filt = Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Pij_ezz_dt);
    %----------------------------------------------------------------------

    % Computing non-linear terms for the generalised Ohms law
    %----------------------------------------------------------------------

    v_filt_x_B_filt_x = v_y_filt.*Bz_filt - v_z_filt.*By_filt;
    J_filt_x_B_filt_x = Jy_filt.*Bz_filt - Jz_filt.*By_filt;

    v_filt_x_B_filt_y = v_z_filt.*Bx_filt - v_x_filt.*Bz_filt;
    J_filt_x_B_filt_y = Jz_filt.*Bx_filt - Jx_filt.*Bz_filt;

    v_filt_x_B_filt_z = v_x_filt.*By_filt - v_y_filt.*Bx_filt;
    J_filt_x_B_filt_z = Jx_filt.*By_filt - Jy_filt.*Bx_filt;


    v_filt_J_filt_xx = v_x_filt.*Jx_filt;
    v_filt_J_filt_xy = v_x_filt.*Jy_filt;
    v_filt_J_filt_xz = v_x_filt.*Jz_filt;
    v_filt_J_filt_yx = v_y_filt.*Jx_filt;
    v_filt_J_filt_yy = v_y_filt.*Jy_filt;
    v_filt_J_filt_yz = v_y_filt.*Jz_filt;
    v_filt_J_filt_zx = v_z_filt.*Jx_filt;
    v_filt_J_filt_zy = v_z_filt.*Jy_filt;
    v_filt_J_filt_zz = v_z_filt.*Jz_filt;

    J_filt_v_filt_xx = Jx_filt.*v_x_filt;
    J_filt_v_filt_xy = Jx_filt.*v_y_filt;
    J_filt_v_filt_xz = Jx_filt.*v_z_filt;
    J_filt_v_filt_yx = Jy_filt.*v_x_filt;
    J_filt_v_filt_yy = Jy_filt.*v_y_filt;
    J_filt_v_filt_yz = Jy_filt.*v_z_filt;
    J_filt_v_filt_zx = Jz_filt.*v_x_filt;
    J_filt_v_filt_zy = Jz_filt.*v_y_filt;
    J_filt_v_filt_zz = Jz_filt.*v_z_filt;

    J_filt_J_filt_2n_xx = Jx_filt.*Jx_filt./(n_filt);
    J_filt_J_filt_2n_xy = Jx_filt.*Jy_filt./(n_filt);
    J_filt_J_filt_2n_xz = Jx_filt.*Jz_filt./(n_filt);
    J_filt_J_filt_2n_yy = Jy_filt.*Jy_filt./(n_filt);
    J_filt_J_filt_2n_yz = Jy_filt.*Jz_filt./(n_filt);
    J_filt_J_filt_2n_zz = Jz_filt.*Jz_filt./(n_filt);
    %----------------------------------------------------------------------

    %--------------------------------------------------------------------------
    [Pij_exx_filt_x, Pij_exx_filt_z,...
        Pij_eyy_filt_x, Pij_eyy_filt_z,...
        Pij_ezz_filt_x, Pij_ezz_filt_z,...
        Pij_exy_filt_x, Pij_exy_filt_z,...
        Pij_exz_filt_x, Pij_exz_filt_z,...
        Pij_eyz_filt_x, Pij_eyz_filt_z] = Derivatives_FFT_tensor_2Dxz(Dx,Kx,Kz,...
        Pij_exx_filt, Pij_eyy_filt, Pij_ezz_filt,...
        Pij_exy_filt, Pij_exz_filt, Pij_eyz_filt);
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------

    Div_Pe_filt_x = Pij_exx_filt_x + Pij_exz_filt_z;

    Div_Pe_filt_y = Pij_exy_filt_x + Pij_eyz_filt_z;

    Div_Pe_filt_z = Pij_exz_filt_x + Pij_ezz_filt_z;

    clearvars Pij_exx_filt_* Pij_exy_filt_* Pij_exz_filt_* ...
        Pij_eyy_filt_* Pij_eyz_filt_* Pij_ezz_filt_* ...
        %----------------------------------------------------------------------

    if(pressure_ion == 1)
        %--------------------------------------------------------------------------
        [Pij_ixx_filt_x, Pij_ixx_filt_z,...
            Pij_iyy_filt_x, Pij_iyy_filt_z,...
            Pij_izz_filt_x, Pij_izz_filt_z,...
            Pij_ixy_filt_x, Pij_ixy_filt_z,...
            Pij_ixz_filt_x, Pij_ixz_filt_z,...
            Pij_iyz_filt_x, Pij_iyz_filt_z] = Derivatives_FFT_tensor_2Dxz(Dx,Kx,Kz,...
            Pij_ixx_filt, Pij_iyy_filt, Pij_izz_filt,...
            Pij_ixy_filt, Pij_ixz_filt, Pij_iyz_filt);
        %----------------------------------------------------------------------

        %----------------------------------------------------------------------

        Div_Pi_filt_x = Pij_ixx_filt_x + Pij_ixz_filt_z;

        Div_Pi_filt_y = Pij_ixy_filt_x + Pij_iyz_filt_z;

        Div_Pi_filt_z = Pij_ixz_filt_x + Pij_izz_filt_z;

        clearvars Pij_ixx_filt_* Pij_ixy_filt_* Pij_ixz_filt_* ...
            Pij_iyy_filt_* Pij_iyz_filt_* Pij_izz_filt_* ...
            %----------------------------------------------------------------------
    end


    %----------------------------------------------------------------------
    [v_J_filt_xx_x, v_J_filt_xx_z,...
        v_J_filt_yy_x, v_J_filt_yy_z,...
        v_J_filt_zz_x, v_J_filt_zz_z,...
        v_J_filt_xy_x, v_J_filt_xy_z,...
        v_J_filt_xz_x, v_J_filt_xz_z,...
        v_J_filt_yz_x, v_J_filt_yz_z] = Derivatives_FFT_tensor_2Dxz(Dx,Kx,Kz,...
        v_filt_J_filt_xx, v_filt_J_filt_yy, v_filt_J_filt_zz,...
        v_filt_J_filt_xy, v_filt_J_filt_xz, v_filt_J_filt_xz);

    [~, ~, ~, ~, ~, ~, ...
        v_J_filt_yx_x, v_J_filt_yx_z,...
        v_J_filt_zx_x, v_J_filt_zx_z,...
        v_J_filt_zy_x, v_J_filt_zy_z] = Derivatives_FFT_tensor_2Dxz(Dx,Kx,Kz,...
        v_filt_J_filt_xx, v_filt_J_filt_yy, v_filt_J_filt_zz,...
        v_filt_J_filt_yx, v_filt_J_filt_zx, v_filt_J_filt_zy);

    %----------------------------------------------------------------------

    %----------------------------------------------------------------------

    Div_vJ_filt_x = v_J_filt_xx_x + v_J_filt_zx_z;

    Div_vJ_filt_y = v_J_filt_xy_x + v_J_filt_zy_z;

    Div_vJ_filt_z = v_J_filt_xz_x + v_J_filt_zz_z;


    clearvars v_J_filt_xx_* v_J_filt_xy_* v_J_filt_xz_* ...
        v_J_filt_yx_* v_J_filt_yy_* v_J_filt_yz_* ...
        v_J_filt_zx_* v_J_filt_zy_* v_J_filt_zz_*
    %----------------------------------------------------------------------


    %----------------------------------------------------------------------
    [J_v_filt_xx_x, J_v_filt_xx_z,...
        J_v_filt_yy_x, J_v_filt_yy_z,...
        J_v_filt_zz_x, J_v_filt_zz_z,...
        J_v_filt_xy_x, J_v_filt_xy_z,...
        J_v_filt_xz_x, J_v_filt_xz_z,...
        J_v_filt_yz_x, J_v_filt_yz_z] = Derivatives_FFT_tensor_2Dxz(Dx,Kx,Kz,...
        J_filt_v_filt_xx, J_filt_v_filt_yy, J_filt_v_filt_zz,...
        J_filt_v_filt_xy, J_filt_v_filt_xz, J_filt_v_filt_yz);


    [~, ~, ~, ~, ~, ~, ...
        J_v_filt_yx_x, J_v_filt_yx_z,...
        J_v_filt_zx_x, J_v_filt_zx_z,...
        J_v_filt_zy_x, J_v_filt_zy_z] = Derivatives_FFT_tensor_2Dxz(Dx,Kx,Kz,...
        J_filt_v_filt_xx, J_filt_v_filt_yy, J_filt_v_filt_zz,...
        J_filt_v_filt_yx, J_filt_v_filt_zx, J_filt_v_filt_zy);

    %----------------------------------------------------------------------

    %----------------------------------------------------------------------

    Div_Jv_filt_x = J_v_filt_xx_x + J_v_filt_zx_z;

    Div_Jv_filt_y = J_v_filt_xy_x + J_v_filt_zy_z;

    Div_Jv_filt_z = J_v_filt_xz_x + J_v_filt_zz_z;


    clearvars J_v_filt_xx_* J_v_filt_xy_* J_v_filt_xz_* ...
        J_v_filt_yx_* J_v_filt_yy_* J_v_filt_yz_* ...
        J_v_filt_zx_* J_v_filt_zy_* J_v_filt_zz_*
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    [J_J_filt_xx_x, J_J_filt_xx_z,...
        J_J_filt_yy_x, J_J_filt_yy_z,...
        J_J_filt_zz_x, J_J_filt_zz_z,...
        J_J_filt_xy_x, J_J_filt_xy_z,...
        J_J_filt_xz_x, J_J_filt_xz_z,...
        J_J_filt_yz_x, J_J_filt_yz_z] = Derivatives_FFT_tensor_2Dxz(Dx,Kx,Kz,...
        J_filt_J_filt_2n_xx, J_filt_J_filt_2n_yy, J_filt_J_filt_2n_zz,...
        J_filt_J_filt_2n_xy, J_filt_J_filt_2n_xz, J_filt_J_filt_2n_yz);

    %----------------------------------------------------------------------

    %----------------------------------------------------------------------

    Div_JJ_filt_2n_x = J_J_filt_xx_x + J_J_filt_xz_z;

    Div_JJ_filt_2n_y = J_J_filt_xy_x + J_J_filt_yz_z;

    Div_JJ_filt_2n_z = J_J_filt_xz_x + J_J_filt_zz_z;


    clearvars J_J_filt_xx_* J_J_filt_xy_* J_J_filt_xz_* ...
        J_J_filt_yx_* J_J_filt_yy_* J_J_filt_yz_* ...
        J_J_filt_zx_* J_J_filt_zy_* J_J_filt_zz_*
    %----------------------------------------------------------------------


    %----------------------------------------------------------------------
    clearvars v_filt_J_filt_* J_filt_v_filt_* J_filt_J_filt_*
    %----------------------------------------------------------------------


    %%%  Now let's compute the tensors
    % % %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    [sub_tau1_xx_x, sub_tau1_xx_z,...
        sub_tau1_yy_x, sub_tau1_yy_z,...
        sub_tau1_zz_x, sub_tau1_zz_z,...
        sub_tau1_xy_x, sub_tau1_xy_z,...
        sub_tau1_xz_x, sub_tau1_xz_z,...
        sub_tau1_yz_x, sub_tau1_yz_z] = Derivatives_FFT_tensor_2Dxz(Dx,Kx,Kz,...
        sub_tau1_xx, sub_tau1_yy, sub_tau1_zz,...
        sub_tau1_xy, sub_tau1_xz, sub_tau1_yz);


    [~, ~, ~, ~, ~, ~, ...
        sub_tau1_yx_x, sub_tau1_yx_z,...
        sub_tau1_zx_x, sub_tau1_zx_z,...
        sub_tau1_zy_x, sub_tau1_zy_z] = Derivatives_FFT_tensor_2Dxz(Dx,Kx,Kz,...
        sub_tau1_xx, sub_tau1_yy, sub_tau1_zz,...
        sub_tau1_yx, sub_tau1_zx, sub_tau1_zy);

    %----------------------------------------------------------------------





    %%% Normalization values
    %----------------------------------------------------------------------
    B_mod_dt = sqrt(Bx_dt.^2 + By_dt.^2 + Bz_dt.^2);
    B0 = mean(B_mod_dt,'all');

    clearvars B_mod_dt

    n0 = mean(n_0_dt,'all');
    mu0 = 1;
    v_a = B0./sqrt(mu0 * n0);
    c = v_a;
    me = 1;
    %----------------------------------------------------------------------


    % % % Now let's compute the tensors
    %----------------------------------------------------------------------
    %(<nE> - <n><E>)/<n>
    % % %----------------------------------------------------------------------
    %tau_nE_tau = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*Ex_dt,l_wind_x))./n_filt - Ex_filt);
    tau_nE_tau_x = (B0*c)^(1)*((Gauss_filter_2D_xz(l_wind_x,Kx,Kz,n_0_dt.*Ex_dt))./n_filt - Ex_filt);
    %(<nevxB> - <n><v>x<B>)/<ne>
    % % %----------------------------------------------------------------------
    %tau_v_x_B_tau = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*v_x_B_x_dt,l_wind_x))./n_filt - v_filt_x_B_filt_x);
    tau_v_x_B_tau_x = (B0*c)^(1)*((Gauss_filter_2D_xz(l_wind_x,Kx,Kz,n_0_dt.*v_x_B_x_dt))./n_filt - v_filt_x_B_filt_x);
    %(<nevxB> - <n><J>x<B>)/<ne>
    %----------------------------------------------------------------------
    %tau_J_x_B_tau = (B0*c)^(1)*((imgaussfilt3(J_x_B_x_dt,l_wind_x) - J_filt_x_B_filt_x)./n_filt);
    tau_J_x_B_tau_x = (B0*c)^(1)*((Gauss_filter_2D_xz(l_wind_x,Kx,Kz,J_x_B_x_dt) - J_filt_x_B_filt_x)./n_filt);
    %----------------------------------------------------------------------
    Div_sub_tau1_x = sub_tau1_xx_x  + sub_tau1_zx_z;
    %----------------------------------------------------------------------
    %tau_Div_tau1 = me*c*c*(1.*(imgaussfilt3(Div_sub_tau1,l_wind_x) - (Div_vJ_filt_x + Div_Jv_filt_x - Div_JJ_filt_2n_x))./n_filt);
    tau_Div_tau1_x = me*c*c*(1.*(Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Div_sub_tau1_x) - (Div_vJ_filt_x + Div_Jv_filt_x - Div_JJ_filt_2n_x))./n_filt);
    % % %----------------------------------------------------------------------


    % % %----------------------------------------------------------------------
    %tau_nE_tau = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*Ey_dt,l_wind_x))./n_filt - Ey_filt);
    tau_nE_tau_y = (B0*c)^(1)*((Gauss_filter_2D_xz(l_wind_x,Kx,Kz,n_0_dt.*Ey_dt))./n_filt - Ey_filt);
    % % %----------------------------------------------------------------------
    %tau_v_x_B_tau = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*v_x_B_y_dt,l_wind_x))./n_filt - v_filt_x_B_filt_y);
    tau_v_x_B_tau_y = (B0*c)^(1)*((Gauss_filter_2D_xz(l_wind_x,Kx,Kz,n_0_dt.*v_x_B_y_dt))./n_filt - v_filt_x_B_filt_y);
    % % %----------------------------------------------------------------------
    %tau_J_x_B_tau = (B0*c)^(1)*((imgaussfilt3(J_x_B_y_dt,l_wind_x) - J_filt_x_B_filt_y)./n_filt);
    tau_J_x_B_tau_y = (B0*c)^(1)*((Gauss_filter_2D_xz(l_wind_x,Kx,Kz,J_x_B_y_dt) - J_filt_x_B_filt_y)./n_filt);
    % % %----------------------------------------------------------------------
    Div_sub_tau1_y = sub_tau1_xy_x  + sub_tau1_zy_z;
    % % %----------------------------------------------------------------------
    %tau_Div_tau1 = me*c*c*(1.*(imgaussfilt3(Div_sub_tau1,l_wind_x) - (Div_vJ_filt_y + Div_Jv_filt_y - Div_JJ_filt_2n_y))./n_filt);
    tau_Div_tau1_y = me*c*c*(1.*(Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Div_sub_tau1_y) - (Div_vJ_filt_y + Div_Jv_filt_y - Div_JJ_filt_2n_y))./n_filt);

    % % %----------------------------------------------------------------------
    %tau_nE_tau = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*Ez_dt,l_wind_x))./n_filt - Ez_filt);
    tau_nE_tau_z = (B0*c)^(1)*((Gauss_filter_2D_xz(l_wind_x,Kx,Kz,n_0_dt.*Ez_dt))./n_filt - Ez_filt);
    % % %----------------------------------------------------------------------
    %tau_v_x_B_tau = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*v_x_B_z_dt,l_wind_x))./n_filt - v_filt_x_B_filt_z);
    tau_v_x_B_tau_z = (B0*c)^(1)*((Gauss_filter_2D_xz(l_wind_x,Kx,Kz,n_0_dt.*v_x_B_z_dt))./n_filt - v_filt_x_B_filt_z);
    % % %----------------------------------------------------------------------
    %tau_J_x_B_tau = (B0*c)^(1)*((imgaussfilt3(J_x_B_z_dt,l_wind_x) - J_filt_x_B_filt_z)./n_filt);
    tau_J_x_B_tau_z = (B0*c)^(1)*((Gauss_filter_2D_xz(l_wind_x,Kx,Kz,J_x_B_z_dt) - J_filt_x_B_filt_z)./n_filt);
    % % %----------------------------------------------------------------------
    Div_sub_tau1_z = sub_tau1_xz_x + sub_tau1_zz_z;
    %----------------------------------------------------------------------
    %tau_Div_tau1 = me*c*c*(1.*(imgaussfilt3(Div_sub_tau1,l_wind_x) - (Div_vJ_filt_z + Div_Jv_filt_z - Div_JJ_filt_2n_z))./n_filt);
    tau_Div_tau1_z = me*c*c*(1.*(Gauss_filter_2D_xz(l_wind_x,Kx,Kz,Div_sub_tau1_z) - (Div_vJ_filt_z + Div_Jv_filt_z - Div_JJ_filt_2n_z))./n_filt);
    %----------------------------------------------------------------------


    clearvars sub_*



    %% clear variables to release space
    %----------------------------------------------------------------------
    %clearvars Div* E* J* v_* Pij* sub*
    %----------------------------------------------------------------------

    %%% ----------------------------------------------------------------------
    %ext_fact = sqrt(1/mime);

    % This is to estimate the three term in the Ohm's law. for the plots 111
    % and 222
    %--------------------------------------------------------------------------

    v_x_B_x_dt = v_y_dt.*Bz_dt - v_z_dt.*By_dt;
    J_x_B_x_dt = Jy_dt.*Bz_dt - Jz_dt.*By_dt;
    %Div_Pe_dt_x = Pe_dt_x/(grad_fact.*resx);
    v_x_B_x_filt = v_y_filt.*Bz_filt - v_z_filt.*By_filt;
    J_x_B_x_filt = Jy_filt.*Bz_filt - Jz_filt.*By_filt;
    %Div_Pe_filt_x = Pe_filt_x/(grad_fact.*resx);

    v_x_B_y_dt = v_z_dt.*Bx_dt - v_x_dt.*Bz_dt;
    J_x_B_y_dt = Jz_dt.*Bx_dt - Jx_dt.*Bz_dt;
    %Div_Pe_dt_y = Pe_dt_y/(grad_fact.*resy);
    v_x_B_y_filt = v_z_dt.*Bx_filt - v_x_filt.*Bz_filt;
    J_x_B_y_filt = Jz_dt.*Bx_filt - Jx_filt.*Bz_filt;
    %Div_Pe_filt_y = Pe_filt_y/(grad_fact.*resy);

    v_x_B_z_dt = v_x_dt.*By_dt - v_y_dt.*Bx_dt;
    J_x_B_z_dt = Jx_dt.*By_dt - Jy_dt.*Bx_dt;
    %Div_Pe_dt_z = Pe_dt_z/(grad_fact.*resz);
    v_x_B_z_filt = v_x_filt.*By_filt - v_y_filt.*Bx_filt;
    J_x_B_z_filt = Jx_filt.*By_filt - Jy_filt.*Bx_filt;
    %Div_Pe_filt_z = Pe_filt_z/(grad_fact.*resz);

    clearvars Pe_dt_*
    clearvars Pe_filt_*
    %--------------------------------------------------------------------------

    %----------------------------------------------------------------------
    % terms from the owns law with no signs
    %----------------------------------------------------------------------

    term1_dt_x = B0*v_a*(Ex_dt);
    term2_dt_x = B0*v_a*(v_x_B_x_dt);
    term3_dt_x = B0*v_a*J_x_B_x_dt./n_0_dt;
    term4_dt_x = v_a*v_a*(Div_Pe_dt_x./n_0_dt);
    term5_dt_x = me*v_a*v_a*((Div_vJ_dt_x + Div_Jv_dt_x - Div_JJ_dt_x)./n_0_dt);
    term6_dt_x = - term2_dt_x + term3_dt_x - term4_dt_x + term5_dt_x;
    %----------------------------------------------------------------------
    % This is for the filtered quantities
    %----------------------------------------------------------------------
    term1_filt_x = B0*v_a*(Ex_filt);
    term2_filt_x = B0*v_a*(v_filt_x_B_filt_x);
    term3_filt_x = B0*v_a*J_filt_x_B_filt_x./n_filt;
    term4_filt_x = v_a*v_a*(Div_Pe_filt_x./n_filt);
    term5_filt_x = me*v_a*v_a*((Div_vJ_filt_x + Div_Jv_filt_x - Div_JJ_filt_2n_x)./n_filt);
    term6_filt_x = - term2_filt_x + term3_filt_x - term4_filt_x + term5_filt_x;

    term1_dt_y = B0*v_a*(Ey_dt);
    term2_dt_y = B0*v_a*(v_x_B_y_dt);
    term3_dt_y = B0*v_a*J_x_B_y_dt./n_0_dt;
    term4_dt_y = v_a*v_a*(Div_Pe_dt_y./n_0_dt);
    term5_dt_y = me*v_a*v_a*((Div_vJ_dt_y + Div_Jv_dt_y - Div_JJ_dt_y)./n_0_dt);
    term6_dt_y = - term2_dt_y + term3_dt_y - term4_dt_y + term5_dt_y;
    %----------------------------------------------------------------------
    % This is for the filtered quantities
    %----------------------------------------------------------------------
    term1_filt_y = B0*v_a*(Ey_filt);
    term2_filt_y = B0*v_a*(v_filt_x_B_filt_y);
    term3_filt_y = B0*v_a*J_filt_x_B_filt_y./n_filt;
    term4_filt_y = v_a*v_a*(Div_Pe_filt_y./n_filt);
    term5_filt_y = me*v_a*v_a*((Div_vJ_filt_y + Div_Jv_filt_y - Div_JJ_filt_2n_y)./n_filt);
    term6_filt_y = - term2_filt_y + term3_filt_y - term4_filt_y + term5_filt_y;

    term1_dt_z = B0*v_a*(Ez_dt);
    term2_dt_z = B0*v_a*(v_x_B_z_dt);
    term3_dt_z = B0*v_a*J_x_B_z_dt./n_0_dt;
    term4_dt_z = v_a*v_a*(Div_Pe_dt_z./n_0_dt);
    term5_dt_z = me*v_a*v_a*((Div_vJ_dt_z + Div_Jv_dt_z - Div_JJ_dt_z)./n_0_dt);
    term6_dt_z = - term2_dt_z + term3_dt_z - term4_dt_z + term5_dt_z;
    %----------------------------------------------------------------------
    % This is for the filtered quantities
    %----------------------------------------------------------------------
    term1_filt_z = B0*v_a*(Ez_filt);
    term2_filt_z = B0*v_a*(v_filt_x_B_filt_z);
    term3_filt_z = B0*v_a*J_filt_x_B_filt_z./n_filt;
    term4_filt_z = v_a*v_a*(Div_Pe_filt_z./n_filt);
    term5_filt_z = me*v_a*v_a*((Div_vJ_filt_z + Div_Jv_filt_z - Div_JJ_filt_2n_z)./n_filt);
    term6_filt_z = - term2_filt_z + term3_filt_z - term4_filt_z + term5_filt_z;
    %----------------------------------------------------------------------


    % Pe_scalar_filt = (Pij_exx_filt + Pij_eyy_filt + Pij_ezz_filt)/3;
    % Pi_scalar_filt = (Pij_ixx_filt + Pij_iyy_filt + Pij_izz_filt)/3;
    % P_scalar_filt = Pe_scalar_filt + Pi_scalar_filt;
    %
    % Energy_scalar_filt = 0.5 *(Ex_filt.^2 + Ey_filt.^2 + Ez_filt.^2 + ...
    %     Bx_filt.^2 + By_filt.^2 + Bz_filt.^2);

    tau_total_x = -tau_nE_tau_x -tau_v_x_B_tau_x + tau_J_x_B_tau_x + tau_Div_tau1_x;
    tau_total_y = -tau_nE_tau_y -tau_v_x_B_tau_y + tau_J_x_B_tau_y + tau_Div_tau1_y;
    tau_total_z = -tau_nE_tau_z -tau_v_x_B_tau_z + tau_J_x_B_tau_z + tau_Div_tau1_z;



    % Now this is to compute the total amplitude

    rms_value=1;

    if rms_value==0

        % This is average of th absolute value <sqrt(Ex^2 + Ey^2 + Ez^2)>;
        %----------------------------------------------------------------------
        term1_filt = sqrt(term1_filt_x.^2 + term1_filt_y.^2 + term1_filt_z.^2) ;
        term2_filt = sqrt(term2_filt_x.^2 + term2_filt_y.^2 + term2_filt_z.^2) ;
        term3_filt = sqrt(term3_filt_x.^2 + term3_filt_y.^2 + term3_filt_z.^2) ;
        term4_filt = sqrt(term4_filt_x.^2 + term4_filt_y.^2 + term4_filt_z.^2) ;
        term5_filt = sqrt(term5_filt_x.^2 + term5_filt_y.^2 + term5_filt_z.^2) ;
        term6_filt = sqrt(term6_filt_x.^2 + term6_filt_y.^2 + term6_filt_z.^2) ;

        tau_nE_tau = sqrt(tau_nE_tau_x.^2 + tau_nE_tau_y.^2 + tau_nE_tau_z.^2) ;
        tau_v_x_B_tau = sqrt(tau_v_x_B_tau_x.^2 + tau_v_x_B_tau_y.^2 + tau_v_x_B_tau_z.^2) ;
        tau_J_x_B_tau = sqrt(tau_J_x_B_tau_x.^2 + tau_J_x_B_tau_y.^2 + tau_J_x_B_tau_z.^2) ;
        tau_Div_tau1 = sqrt(tau_Div_tau1_x.^2 + tau_Div_tau1_y.^2 + tau_Div_tau1_z.^2) ;
        tau_total = sqrt(tau_total_x.^2 + tau_total_y.^2 + tau_total_z.^2) ;

        % The idea for the new analysis is to plot the <SGSMhD>rms/<MHD>rms
        % This analysis should be done with the three components not just one

        % The idea of this is to compute relative importance with absolute values
        if absolute==1
            %-----------------------------------------------------------------------
            MHD_E_mean = mean(abs(term1_filt),'all');
            MHD_vxB_mean = mean(abs(term2_filt),'all');
            MHD_JxB_mean = mean(abs(term3_filt),'all');
            MHD_divP_mean = mean(abs(term4_filt),'all');
            MHD_divvJall_mean = mean(abs(term5_filt),'all');
            MHD_RHS_mean = mean(abs(term6_filt),'all');

            SGS_tau_nE_mean = mean(abs(tau_nE_tau),'all');
            SGS_tau_vxB_mean = mean(abs(tau_v_x_B_tau),'all');
            SGS_tau_JxB_mean = mean(abs(tau_J_x_B_tau),'all');
            SGS_tau_Div_mean = mean(abs(tau_Div_tau1),'all');
            SGS_tau_total_mean = mean(abs(tau_total),'all');

            MHD_JxB2vxB_mean(1,in) = MHD_JxB_mean/MHD_vxB_mean;
            MHD_divP2vxB_mean(1,in) = MHD_divP_mean/MHD_vxB_mean;
            MHD_divvJall2vxB_mean(1,in) = MHD_divvJall_mean/MHD_vxB_mean;
            MHD_RHS2vxB_mean(1,in) = MHD_RHS_mean/MHD_vxB_mean;

            SGS_tau_nE_mean2vxB_mean(1,in) = SGS_tau_nE_mean/MHD_vxB_mean;
            SGS_tau_vxB_mean2vxB_mean(1,in) = SGS_tau_vxB_mean/MHD_vxB_mean;
            SGS_tau_JxB_mean2vxB_mean(1,in) = SGS_tau_JxB_mean/MHD_vxB_mean;
            SGS_tau_Div_mean2vxB_mean(1,in) = SGS_tau_Div_mean/MHD_vxB_mean;
            SGS_tau_total_mean2vxB_mean(1,in) = SGS_tau_total_mean/MHD_vxB_mean;

            %-----------------------------------------------------------------------
        elseif absolute==0

            % The idea of this is to compute relative importance with NO absolute values
            %-----------------------------------------------------------------------
            MHD_E_mean = mean((term1_filt),'all');
            MHD_vxB_mean = mean((term2_filt),'all');
            MHD_JxB_mean = mean((term3_filt),'all');
            MHD_divP_mean = mean((term4_filt),'all');
            MHD_divvJall_mean = mean((term5_filt),'all');
            MHD_RHS_mean = mean(abs(term6_filt),'all');

            SGS_tau_nE_mean = mean((tau_nE_tau),'all');
            SGS_tau_vxB_mean = mean((tau_v_x_B_tau),'all');
            SGS_tau_JxB_mean = mean((tau_J_x_B_tau),'all');
            SGS_tau_Div_mean = mean((tau_Div_tau1),'all');
            SGS_tau_total_mean = mean((tau_total),'all');

            MHD_E2vxB_mean(1,in) = MHD_E_mean;
            MHD_vxB2vxB_mean(1,in) = MHD_vxB_mean;
            MHD_JxB2vxB_mean(1,in) = MHD_JxB_mean;
            MHD_divP2vxB_mean(1,in) = MHD_divP_mean;
            MHD_divvJall2vxB_mean(1,in) = MHD_divvJall_mean;
            MHD_RHS2vxB_mean(1,in) = MHD_RHS_mean;

            SGS_tau_nE_mean2vxB_mean(1,in) = SGS_tau_nE_mean;
            SGS_tau_vxB_mean2vxB_mean(1,in) = SGS_tau_vxB_mean;
            SGS_tau_JxB_mean2vxB_mean(1,in) = SGS_tau_JxB_mean;
            SGS_tau_Div_mean2vxB_mean(1,in) = SGS_tau_Div_mean;
            SGS_tau_total_mean2vxB_mean(1,in) = SGS_tau_total_mean;
            %-----------------------------------------------------------------------

        end
        %----------------------------------------------------------------------


    elseif rms_value == 1
        % This is sqrt( <Ex^2 + Ey^2 + Ez^2 >);
        %----------------------------------------------------------------------
        term1_filt = term1_filt_x.^2 + term1_filt_y.^2 + term1_filt_z.^2 ;
        term2_filt = term2_filt_x.^2 + term2_filt_y.^2 + term2_filt_z.^2 ;
        term3_filt = term3_filt_x.^2 + term3_filt_y.^2 + term3_filt_z.^2 ;
        term4_filt = term4_filt_x.^2 + term4_filt_y.^2 + term4_filt_z.^2 ;
        term5_filt = term5_filt_x.^2 + term5_filt_y.^2 + term5_filt_z.^2 ;
        term6_filt = term6_filt_x.^2 + term6_filt_y.^2 + term6_filt_z.^2 ;

        tau_nE_tau = tau_nE_tau_x.^2 + tau_nE_tau_y.^2 + tau_nE_tau_z.^2 ;
        tau_v_x_B_tau = tau_v_x_B_tau_x.^2 + tau_v_x_B_tau_y.^2 + tau_v_x_B_tau_z.^2 ;
        tau_J_x_B_tau = tau_J_x_B_tau_x.^2 + tau_J_x_B_tau_y.^2 + tau_J_x_B_tau_z.^2 ;
        tau_Div_tau1 = tau_Div_tau1_x.^2 + tau_Div_tau1_y.^2 + tau_Div_tau1_z.^2 ;
        tau_total = tau_total_x.^2 + tau_total_y.^2 + tau_total_z.^2 ;

        % The idea for the new analysis is to plot the <SGSMhD>rms/<MHD>rms
        % This analysis should be done with the three components not just one

        % The idea of this is to compute relative importance with absolute values
        if absolute==1
            %-----------------------------------------------------------------------
            MHD_E_mean = sqrt(mean(abs(term1_filt),'all'));
            MHD_vxB_mean = sqrt(mean(abs(term2_filt),'all'));
            MHD_JxB_mean = sqrt(mean(abs(term3_filt),'all'));
            MHD_divP_mean = sqrt(mean(abs(term4_filt),'all'));
            MHD_divvJall_mean = sqrt(mean(abs(term5_filt),'all'));
            MHD_RHS_mean = sqrt(mean(abs(term6_filt),'all'));

            SGS_tau_nE_mean = sqrt(mean(abs(tau_nE_tau),'all'));
            SGS_tau_vxB_mean = sqrt(mean(abs(tau_v_x_B_tau),'all'));
            SGS_tau_JxB_mean = sqrt(mean(abs(tau_J_x_B_tau),'all'));
            SGS_tau_Div_mean = sqrt(mean(abs(tau_Div_tau1),'all'));
            SGS_tau_total_mean = sqrt(mean(abs(tau_total),'all'));

            MHD_JxB2vxB_mean(1,in) = MHD_JxB_mean/MHD_vxB_mean;
            MHD_divP2vxB_mean(1,in) = MHD_divP_mean/MHD_vxB_mean;
            MHD_divvJall2vxB_mean(1,in) = MHD_divvJall_mean/MHD_vxB_mean;
            MHD_RHS2vxB_mean(1,in) = MHD_RHS_mean/MHD_vxB_mean;

            SGS_tau_nE_mean2vxB_mean(1,in) = SGS_tau_nE_mean/MHD_vxB_mean;
            SGS_tau_vxB_mean2vxB_mean(1,in) = SGS_tau_vxB_mean/MHD_vxB_mean;
            SGS_tau_JxB_mean2vxB_mean(1,in) = SGS_tau_JxB_mean/MHD_vxB_mean;
            SGS_tau_Div_mean2vxB_mean(1,in) = SGS_tau_Div_mean/MHD_vxB_mean;
            SGS_tau_total_mean2vxB_mean(1,in) = SGS_tau_total_mean/MHD_vxB_mean;

            %-----------------------------------------------------------------------
        elseif absolute==0

            % The idea of this is to compute relative importance with NO absolute values
            %-----------------------------------------------------------------------
            MHD_E_mean = sqrt(mean((term1_filt),'all'));
            MHD_vxB_mean = sqrt(mean((term2_filt),'all'));
            MHD_JxB_mean = sqrt(mean((term3_filt),'all'));
            MHD_divP_mean = sqrt(mean((term4_filt),'all'));
            MHD_divvJall_mean = sqrt(mean((term5_filt),'all'));
            MHD_RHS_mean = sqrt(mean(abs(term6_filt),'all'));

            SGS_tau_nE_mean = sqrt(mean((tau_nE_tau),'all'));
            SGS_tau_vxB_mean = sqrt(mean((tau_v_x_B_tau),'all'));
            SGS_tau_JxB_mean = sqrt(mean((tau_J_x_B_tau),'all'));
            SGS_tau_Div_mean = sqrt(mean((tau_Div_tau1),'all'));
            SGS_tau_total_mean = sqrt(mean((tau_total),'all'));

            MHD_E2vxB_mean(1,in) = MHD_E_mean;
            MHD_vxB2vxB_mean(1,in) = MHD_vxB_mean;
            MHD_JxB2vxB_mean(1,in) = MHD_JxB_mean;
            MHD_divP2vxB_mean(1,in) = MHD_divP_mean;
            MHD_divvJall2vxB_mean(1,in) = MHD_divvJall_mean;
            MHD_RHS2vxB_mean(1,in) = MHD_RHS_mean;

            SGS_tau_nE_mean2vxB_mean(1,in) = SGS_tau_nE_mean;
            SGS_tau_vxB_mean2vxB_mean(1,in) = SGS_tau_vxB_mean;
            SGS_tau_JxB_mean2vxB_mean(1,in) = SGS_tau_JxB_mean;
            SGS_tau_Div_mean2vxB_mean(1,in) = SGS_tau_Div_mean;
            SGS_tau_total_mean2vxB_mean(1,in) = SGS_tau_total_mean;
            %-----------------------------------------------------------------------

        end

    end

    % Table of relatives values

    % clearvars MHD_E_mean MHD_vxB_mean...
    %     MHD_JxB_mean MHD_divP_mean ...
    % MHD_divvJall_mean SGS_tau_nE_mean ...
    % SGS_tau_vxB_mean SGS_tau_JxB_mean...
    % SGS_tau_Div_mean SGS_tau_total_mean

    disp(in)

end

%--------------------------------------------------------------------------
grid_dt = info.Groups(20).Attributes;
dt = double(grid_dt(15).Value); %this is in omega_pe
str = string(S(in).name);
newstr = extractBetween(str,"pfd.","_p000000.h5");
N_steps = str2double(newstr);
time = dt*N_steps/sqrt(mime); % This is in omega pi^-1
time_nl = time/Tau_nl; % This time nonlinear

%--------------------------------------------------------------------------

time_in = linspace(0,time_nl,N2);


legendsgsmhd = {'$<J \times B>/<u \times B>$','$<\nabla \cdot P>/<u \times B>$','$<\nabla \cdot (uJ+Ju-JJ/ne)>/<u \times B>$',...
    '$<RHS>/<u \times B>$','$<\tau_{nE}>/<u \times B>$','$<\tau_{u \times B}>/<ux \times B>$','$<\tau_{J \times B}>/<u \times B>$',...
    '$<\tau_{\nabla\cdot(uJ+Ju-JJ/ne)}>/<u \times B>$','$<\Sigma \tau>/<u \times B>$'};

legendsgsmhd_0 = {'$<|\overline{E}|>$','$<|u \times B|>$','$<|J \times B|/ne>$','$<\nabla \cdot P>$','$<\nabla \cdot (uJ+Ju-JJ/ne)>$','$<RHS>$',...
    '$<\tau_{nE}>$','$<\tau_{u \times B}>$','$<\tau_{J \times B}>$',...
    '$<\tau_{\nabla\cdot(uJ+Ju-JJ/ne)}>$','$<\Sigma \tau>$'};

legendsgsmhd_1 = {'$<|\overline{E}|>/<|\overline{u} \times \overline{B}|>$',...
    '$<|\overline{u} \times \overline{B}|>/<|\overline{u} \times \overline{B}|>$',...
    '$<|\overline{J} \times \overline{B}|/\overline{n}e>/<|\overline{u} \times \overline{B}|>$'...
    ,'$<|\nabla \cdot \overline{P}|>/<|\overline{u} \times \overline{B}|>$',...
    '$<|\nabla \cdot (\overline{u}\overline{J}+\overline{J}\overline{u}-\overline{J}\overline{J}/\overline{n}e)m_{e}/\overline{n}e^2|>/<|\overline{u} \times \overline{B}|>$',...
    '$<RHS>/<|\overline{u} \times \overline{B}|>$',...
    '$<\tau_{nE}>/<|\overline{u} \times \overline{B}|>$',...
    '$<\tau_{u \times B}>/<|\overline{u} \times \overline{B}|>$',...
    '$<\tau_{J \times B}>/<|\overline{u} \times \overline{B}|>$',...
    '$<\tau_{\nabla\cdot(uJ+Ju-JJ/ne)}>/<|\overline{u} \times \overline{B}|>$',...
    '$<\Sigma \tau>/<|\overline{u} \times \overline{B}|>$'};

%time_in = linspace(1,21,Nf);
fs=18;

fs=16; x0=45;y0=54;xx1=1000;yy1=400;
if absolute==1
    f34 = figure(34);
    set(gcf,'position',[x0,y0,xx1,yy1])
    plot(time_in,MHD_JxB2vxB_mean,'og',LineWidth=2)
    hold on
    plot(time_in,MHD_divP2vxB_mean,'om',LineWidth=2)
    plot(time_in,MHD_divvJall2vxB_mean,'oc',LineWidth=2)
    plot(time_in,MHD_RHS2vxB_mean,'-k',LineWidth=2)
    plot(time_in,SGS_tau_nE_mean2vxB_mean,'+r',LineWidth=2)
    plot(time_in,SGS_tau_vxB_mean2vxB_mean,'+b',LineWidth=2)
    plot(time_in,SGS_tau_JxB_mean2vxB_mean,'+g',LineWidth=2)
    plot(time_in,SGS_tau_Div_mean2vxB_mean,'+c',LineWidth=2)
    plot(time_in,SGS_tau_total_mean2vxB_mean,'*k',LineWidth=2)
    legend(legendsgsmhd,'FontSize',fs,'Interpreter','latex','NumColumns',1,'Location','northeastoutside')
    xlabel('$t/t_{nl}$','FontSize',fs,Interpreter='latex')
    hold off

    f35 = figure(35);
    set(gcf,'position',[x0,y0,xx1,yy1])
    semilogy(time_in,MHD_JxB2vxB_mean,'og',LineWidth=2)
    hold on
    semilogy(time_in,MHD_divP2vxB_mean,'om',LineWidth=2)
    semilogy(time_in,MHD_divvJall2vxB_mean,'oc',LineWidth=2)
    semilogy(time_in,MHD_RHS2vxB_mean,'-k',LineWidth=2)
    semilogy(time_in,SGS_tau_nE_mean2vxB_mean,'+r',LineWidth=2)
    semilogy(time_in,SGS_tau_vxB_mean2vxB_mean,'+b',LineWidth=2)
    semilogy(time_in,SGS_tau_JxB_mean2vxB_mean,'+g',LineWidth=2)
    semilogy(time_in,SGS_tau_Div_mean2vxB_mean,'+c',LineWidth=2)
    semilogy(time_in,SGS_tau_total_mean2vxB_mean,'*k',LineWidth=2)
    legend(legendsgsmhd,'FontSize',fs,'Interpreter','latex','NumColumns',1,'Location','northeastoutside')
    xlabel('$t/t_{nl}$','FontSize',fs,Interpreter='latex')
    hold off
elseif absolute==0

    f34 = figure(34);
    set(gcf,'position',[x0,y0,xx1,yy1])
    dummy = (MHD_E2vxB_mean./MHD_vxB2vxB_mean);
    plot(time_in,dummy,'or',LineWidth=2)
    hold on

    dummy = (MHD_vxB2vxB_mean)./MHD_vxB2vxB_mean;
    plot(time_in,dummy,'ob',LineWidth=2)

    dummy = (MHD_JxB2vxB_mean)./MHD_vxB2vxB_mean;
    plot(time_in,dummy,'og',LineWidth=2)

    dummy = (MHD_divP2vxB_mean)./MHD_vxB2vxB_mean;
    plot(time_in,dummy,'om',LineWidth=2)

    dummy = (MHD_divvJall2vxB_mean)./MHD_vxB2vxB_mean;
    plot(time_in,dummy,'oc',LineWidth=2)

    dummy = (MHD_RHS2vxB_mean)./MHD_vxB2vxB_mean;
    plot(time_in,dummy,'-k',LineWidth=2)

    dummy = (SGS_tau_nE_mean2vxB_mean)./MHD_vxB2vxB_mean;
    plot(time_in,dummy,'+r',LineWidth=2)

    dummy = (SGS_tau_vxB_mean2vxB_mean)./MHD_vxB2vxB_mean;
    plot(time_in,dummy,'+b',LineWidth=2)

    dummy = (SGS_tau_JxB_mean2vxB_mean)./MHD_vxB2vxB_mean;
    plot(time_in,dummy,'+g',LineWidth=2)

    dummy = (SGS_tau_Div_mean2vxB_mean)./MHD_vxB2vxB_mean;
    plot(time_in,dummy,'+c',LineWidth=2)

    dummy = (SGS_tau_total_mean2vxB_mean)./MHD_vxB2vxB_mean;
    plot(time_in,dummy,'*k',LineWidth=2)

    legend(legendsgsmhd_1,'FontSize',fs,'Interpreter','latex','NumColumns',1,'Location','northeastoutside')
    xlabel('$t/t_{nl}$','FontSize',fs,Interpreter='latex')
    %ylabel('$log (1 - |<.>|)$','FontSize',fs,Interpreter='latex')
    %ylim([-5e-6, 5e-6])
    hold off


    f35 = figure(35);
    set(gcf,'position',[x0,y0,xx1,yy1])
    dummy = (MHD_E2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'or',LineWidth=2)
    hold on

    dummy = (MHD_vxB2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'ob',LineWidth=2)

    dummy = (MHD_JxB2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'og',LineWidth=2)

    dummy = (MHD_divP2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'om',LineWidth=2)

    dummy = (MHD_divvJall2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'oc',LineWidth=2)

    dummy = (MHD_RHS2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'-k',LineWidth=2)

    dummy = (SGS_tau_nE_mean2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'+r',LineWidth=2)

    dummy = (SGS_tau_vxB_mean2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'+b',LineWidth=2)

    dummy = (SGS_tau_JxB_mean2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'+g',LineWidth=2)

    dummy = (SGS_tau_Div_mean2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'+c',LineWidth=2)

    dummy = (SGS_tau_total_mean2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'*k',LineWidth=2)

    legend(legendsgsmhd_0,'FontSize',fs,'Interpreter','latex','NumColumns',1,'Location','northeastoutside')
    xlabel('$t/t_{nl}$','FontSize',fs,Interpreter='latex')
    ylabel('$sgn(|<.>|) * log (|<.>|)$','FontSize',fs,Interpreter='latex')
    %ylim([-10, 10])
    hold off


    f37 = figure(37);
    set(gcf,'position',[x0,y0,xx1,yy1])
    semilogy(time_in,MHD_JxB2vxB_mean./MHD_vxB2vxB_mean,'og',LineWidth=2)
    hold on
    semilogy(time_in,MHD_divP2vxB_mean./MHD_vxB2vxB_mean,'om',LineWidth=2)
    semilogy(time_in,MHD_divvJall2vxB_mean./MHD_vxB2vxB_mean,'oc',LineWidth=2)
    semilogy(time_in,MHD_RHS2vxB_mean./MHD_vxB2vxB_mean,'-k',LineWidth=2)
    semilogy(time_in,SGS_tau_nE_mean2vxB_mean./MHD_vxB2vxB_mean,'+r',LineWidth=2)
    semilogy(time_in,SGS_tau_vxB_mean2vxB_mean./MHD_vxB2vxB_mean,'+b',LineWidth=2)
    semilogy(time_in,SGS_tau_JxB_mean2vxB_mean./MHD_vxB2vxB_mean,'+g',LineWidth=2)
    semilogy(time_in,SGS_tau_Div_mean2vxB_mean./MHD_vxB2vxB_mean,'+c',LineWidth=2)
    semilogy(time_in,SGS_tau_total_mean2vxB_mean./MHD_vxB2vxB_mean,'*k',LineWidth=2)
    legend(legendsgsmhd,'FontSize',fs,'Interpreter','latex','NumColumns',1,'Location','northeastoutside')
    xlabel('$t/t_{nl}$','FontSize',fs,Interpreter='latex')
    hold off

end


cd(path)

if absolute==1
    saveas(f34,strcat(num2str(i),'relatives_terms_time_abs.png'));
    saveas(f35,strcat(num2str(i),'relatives_terms_time_abs_log.png'));
elseif absolute==0
    saveas(f34,strcat(num2str(i),'relatives_terms_time.png'));
    saveas(f35,strcat(num2str(i),'relatives_terms_time_log.png'));
    saveas(f36,strcat(num2str(i),'relatives_terms_time_abs.png'));
end
%T = table([1;5],[2;6],[3;7],[4;8],[],'VariableNames',{'JxB','divP','C','D'},'RowName',{'MHD','SGS/MHD'});


%-----------------------------------------------------------------------

%MAKE THIS A SCRIPT FOR THE THREE COMPONENTS




%-----------------------------------------------------------------------
% Checking the filter effect on the spectrum
%{
% %-----------------------------------------------------------------------
% Apply a low-pass Gaussian filter to remove high frequencies
%----------------------------
B{1,1}=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'),start,count);
B{1,2}=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'),start,count);
B{1,3}=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'),start,count);

Bx_dt = squeeze(B{1,1});
By_dt = squeeze(B{1,2});
Bz_dt = squeeze(B{1,3});
%----------------------------

%----------------------------
Lx_di=Lx/sqrt(mime); % Using this thefilter is in terms of di 
Lz_di=Lz/sqrt(mime);
resx = Lx_di/length(Bx(:,1)); %in di
resz = Lz_di/length(Bx(1,:)); %in di
threshold=pi/resx; %in di

kx=((0:length(Bx(:,1))-1)).*2*pi/Lx_di;%Includes negative wavenumbers and as it is k_max = pi/resx
kz=((0:length(Bx(1,:))-1)).*2*pi/Lz_di; % this is in terms of di

%kx = 2 * pi * [0:nx2/2 -nx2/2+1:-1] / Lx_di; % Wavenumbers in x
%kz = 2 * pi * [0:nz2/2 -nz2/2+1:-1] / Lz_di; 

[KX, KZ] = meshgrid(kx, kz);

dk = 2 * pi / Lx_di; % Bin width in k-space
% Calculate the radial wavenumber k
K = sqrt(KX.^2 + KZ.^2);
k_max = threshold;%max(K(:)); % Maximum wavenumber
k_bins = 0:dk:k_max; % Radial wavenumber bins

l_wind_x=resx;% this is in de now
sigma = 1*l_wind_x; % Adjust as needed for filtering strength

filter = exp(-(Kx.^2 + Kz.^2) * 0.5 * sigma^2);
% Fourier transforms of vector-field components

Bx_hat = fft2(Bx_dt) ;
By_hat = fft2(By_dt) ;
Bz_hat = fft2(Bz_dt) ;

Bx_filt = real(ifft2(Bx_hat .* filter));
By_filt = real(ifft2(By_hat .* filter));
Bz_filt = real(ifft2(Bz_hat .* filter));

% Initialize the omnidirectional spectrum
E_k_1 = zeros(size(k_bins));
E_k_2 = zeros(size(k_bins));

% Calculate the energy spectrum
F_Bx = Bx_hat;
F_By = By_hat;
F_Bz = Bz_hat;

F_Bx2 = fft2(Bx_filt);
F_By2 = fft2(By_filt);
F_Bz2 = fft2(Bz_filt);

energy_1 = abs(F_Bx).^2 + abs(F_By).^2 + abs(F_Bz).^2;
energy_2 = abs(F_Bx2).^2 + abs(F_By2).^2 + abs(F_Bz2).^2;

% Bin the energy into the radial wavenumber bins
for i = 1:length(k_bins)-1
    k_min = k_bins(i);
    k_max = k_bins(i+1);
    % Find the indices of the Fourier modes that fall within the current bin
    indices = (K >= k_min) & (K < k_max);
    % Sum the energy of these modes
    E_k_1(i) = sum(energy_1(indices));
    E_k_2(i) = sum(energy_2(indices));
end

% Normalize the spectrum by the bin width
E_k_1 = E_k_1 / dk;
E_k_2 = E_k_2 / dk;
%----------------------------
% Plot the omnidirectional spectrum
%------------------------------------------------------------------
f21=figure(21);
CM = jet(N);
loglog(k_bins(1:end-1), E_k_1(1:end-1), 'r','LineWidth', 1.5);
hold on
loglog(k_bins(1:end-1), E_k_2(1:end-1), 'c','LineWidth', 1.5); % this is the filt
title('1D Omnidirectional Spectrum');
xlabel('kdi');
ylabel('E(k)');
legend('Bmag','Bfilt')
ylim([10^2, 10^12])
xlim([3*10^(-1), 10^2])
%------------------------------------------------------------------
%}
%-----------------------------------------------------------------------



%%
%%%
% Defining the functions to use in this script
%----------------------------------------------------------------------


% This is to apply the filter in K space instead the real space
%----------------------------------------------------------------------
function[Jx_filt] = Gauss_filter_2D_xz(Dx,Kx,Kz,Jx_dt)
% Apply a low-pass Gaussian filter to remove high frequencies
sigma = 1*Dx; % Adjust as needed for filtering strength
filter = exp(-(Kx.^2 + Kz.^2) * 0.5 * sigma^2);
% Fourier transforms of vector-field components
Jx_hat = fft2(Jx_dt) .* filter;
Jx_filt = real(ifft2(Jx_hat));
end
%----------------------------------------------------------------------


% Functions for the derivatives using the FFT2D
%----------------------------------------------------------------------
function[dJx_dx, dJx_dz, dJy_dx, dJy_dz, dJz_dx, dJz_dz] = Derivatives_FFT_vector_2Dxz(Dx,Kx,Kz,Jx_dt,Jy_dt,Jz_dt)

% Apply a low-pass Gaussian filter to remove high frequencies

sigma = 2*Dx; % Adjust as needed for filtering strength
filter = exp(-(Kx.^2 + Kz.^2) * 0.5 * sigma^2);

% Fourier transforms of vector-field components
Jx_hat = fft2(Jx_dt) .* filter;
Jy_hat = fft2(Jy_dt) .* filter;
Jz_hat = fft2(Jz_dt) .* filter;

% Compute derivatives in Fourier space
dJx_dz_hat = 1i * Kz .* Jx_hat;
dJz_dx_hat = 1i * Kx .* Jz_hat;

dJy_dx_hat = 1i * Kx .* Jy_hat;
dJy_dz_hat = 1i * Kz .* Jy_hat;

dJx_dx_hat = 1i * Kx .* Jx_hat;
dJz_dz_hat = 1i * Kz .* Jz_hat;

dJx_dx = real(ifft2(dJx_dx_hat));
dJx_dz = real(ifft2(dJx_dz_hat));
dJy_dx = real(ifft2(dJy_dx_hat));
dJy_dz = real(ifft2(dJy_dz_hat));
dJz_dx = real(ifft2(dJz_dx_hat));
dJz_dz = real(ifft2(dJz_dz_hat));
end
%----------------------------------------------------------------------

%----------------------------------------------------------------------
function[dPij_exx_dx, dPij_exx_dz,...
    dPij_eyy_dx, dPij_eyy_dz,...
    dPij_ezz_dx, dPij_ezz_dz,...
    dPij_exy_dx, dPij_exy_dz,...
    dPij_exz_dx, dPij_exz_dz,...
    dPij_eyz_dx, dPij_eyz_dz] = Derivatives_FFT_tensor_2Dxz(Dx,Kx,Kz,...
    Pij_exx_dt, Pij_eyy_dt, Pij_ezz_dt,...
    Pij_exy_dt, Pij_exz_dt, Pij_eyz_dt)

sigma = 2*Dx; % Adjust as needed for filtering strength
filter = exp(-(Kx.^2 + Kz.^2) * 0.5 * sigma^2);

% Fourier transforms of B-field components
Pij_exx_hat = fft2(Pij_exx_dt) .* filter;
Pij_eyy_hat = fft2(Pij_eyy_dt) .* filter;
Pij_ezz_hat = fft2(Pij_ezz_dt) .* filter;
Pij_exy_hat = fft2(Pij_exy_dt) .* filter;
Pij_exz_hat = fft2(Pij_exz_dt) .* filter;
Pij_eyz_hat = fft2(Pij_eyz_dt) .* filter;


% Compute derivatives in Fourier space
dPij_exx_dx_hat = 1i * Kx .* Pij_exx_hat;
dPij_exx_dz_hat = 1i * Kz .* Pij_exx_hat;

dPij_eyy_dx_hat = 1i * Kx .* Pij_eyy_hat;
dPij_eyy_dz_hat = 1i * Kz .* Pij_eyy_hat;

dPij_ezz_dx_hat = 1i * Kx .* Pij_ezz_hat;
dPij_ezz_dz_hat = 1i * Kz .* Pij_ezz_hat;

dPij_exy_dx_hat = 1i * Kx .* Pij_exy_hat;
dPij_exy_dz_hat = 1i * Kz .* Pij_exy_hat;

dPij_exz_dx_hat = 1i * Kx .* Pij_exz_hat;
dPij_exz_dz_hat = 1i * Kz .* Pij_exz_hat;

dPij_eyz_dx_hat = 1i * Kx .* Pij_eyz_hat;
dPij_eyz_dz_hat = 1i * Kz .* Pij_eyz_hat;


dPij_exx_dx = real(ifft2(dPij_exx_dx_hat));
dPij_exx_dz = real(ifft2(dPij_exx_dz_hat));

dPij_eyy_dx = real(ifft2(dPij_eyy_dx_hat));
dPij_eyy_dz = real(ifft2(dPij_eyy_dz_hat));

dPij_ezz_dx = real(ifft2(dPij_ezz_dx_hat));
dPij_ezz_dz = real(ifft2(dPij_ezz_dz_hat));

dPij_exy_dx = real(ifft2(dPij_exy_dx_hat));
dPij_exy_dz = real(ifft2(dPij_exy_dz_hat));

dPij_exz_dx = real(ifft2(dPij_exz_dx_hat));
dPij_exz_dz = real(ifft2(dPij_exz_dz_hat));

dPij_eyz_dx = real(ifft2(dPij_eyz_dx_hat));
dPij_eyz_dz = real(ifft2(dPij_eyz_dz_hat));
end
%----------------------------------------------------------------------



% Funtion to make the filtering
%----------------------------------------------------------------------
function [convolution_result]=Filtering_kernel(var,l_wind_x)
%----------------------------------------------------------------------
% The inputs are the variable, the fourier transform of the kernel and
% the output is the filted signal
% These four lines are the filtering

%----------------------------------------------------------------------
% Perform the FFT of the function f
F_var = fftn(var);
F_var = fftshift(fftshift(fftshift(F_var,1),2),3);

% Convolve in the frequency domain (element-wise multiplication)
l_wind_x = fftshift(fftshift(fftshift(l_wind_x,1),2),3);
F_convolution = F_var .* l_wind_x;
F_convolution = fftshift(fftshift(fftshift(F_convolution,1),2),3);

% Perform the inverse FFT to get the convolved function
convolution_result = ifftn(F_convolution);

% Ensure the result is real (the imaginary part should be very small due to numerical errors)
convolution_result = real(convolution_result);
%----------------------------------------------------------------------
end

%----------------------------------------------------------------------


% This is better as a function to make the filter and the associated
% spectrum easier to compute.
function [P2D,kpar,kper,kz]=Power_of_filtering_kernel(Bx,Lx,Ly,Lz)
%----------------------------------------------------------------------
Bx_dt_DT = Bx - mean(Bx,'all');

% Perform the FFT of the 3D field B
F_Bx = fftn(Bx_dt_DT);

%Shift the ffts
F_Bx_shift = fftshift(fftshift(fftshift(F_Bx,1),2),3);
%F_Bx_shift = F_Bx;

%Get the amplitudes
F_f_shift_amp = F_Bx_shift .* conj(F_Bx_shift);

%l_wind_x_shift = fftshift(fftshift(fftshift(l_wind_x,1),2),3);
%F_g_shift_amp = l_wind_x_shift .* conj(l_wind_x_shift);
%convolution_shift = fftshift(fftshift(fftshift(F_convolution,1),2),3);
%convolution_result_amp = convolution_shift .* conj(convolution_shift);

ff=F_f_shift_amp;
Ns=size(ff);

kx=((0:Ns(1)-1)-Ns(1)/2).*2*pi/Lx; %Includes negative wavenumbers
ky=((0:Ns(2)-1)-Ns(2)/2).*2*pi/Ly;
kz=((0:Ns(3)-1)-Ns(3)/2).*2*pi/Lz;

kp = zeros(Ns(1),Ns(2));
kp2 = zeros(1,Ns(3));
for j=1:Ns(2)
    for i=1:Ns(1)
        %--------------------------------------------------------------------------
        kp(i,j)=sqrt(ky(j).^2 + kx(i).^2); %Calculate kperp array with negative wavenumbers
        %--------------------------------------------------------------------------
        %kp(i,j)=sqrt(ky(j).^2); %This is for the case of the 2D harris
        %configuration
        %--------------------------------------------------------------------------
    end
end
for k=1:size(ff,3)
    kp2(k)=abs(kz(k)); %Calculate kpar vector with negative wavenumbers
end

%Calculate kpar and kperp for 2D spectrum:
dkpar=kz(2)-kz(1);
nkpar=fix(max(max(kz))/dkpar)+1;
kpar=(0:nkpar-1).*dkpar;

dkper=ky(2)-ky(1);
nkper=fix(max(max(kp))/dkper)+1;
kper=(0:nkper-1).*dkper;

%Use linear interpolation to intergrate in concentric circles of k_perp:

%Initialise arrays:
Ptemp=zeros(size(ff,3),nkper); %old kper vs. new kper
P2D=zeros(nkpar,nkper); %kpar vs. kper

Nkper=zeros(size(ff,3),nkper);

i1=fix(kp/dkper); %Index linking kp with each kper value. Index of the cells
i2=i1+1; % indexes of next cells
i3=fix(kp2/dkpar); %Index linking kp2 with each kpar value

k2=kp/dkper-i1; % this is calculating basically the residuo. kp is a matrix
k1=1-k2;

for k= 1:size(ff,3) %For each value of kpar, integrate over rings of kper
    P1=k1.*ff(:,:,k); %For interpolation
    P2=k2.*ff(:,:,k);
    for j=1:size(ff,2) %Cycle through every grid point in x-y plane
        for i=1:size(ff,1)
            if(i2(i,j) < nkper)
                %Use linear interpolation to sum up power to surrounding
                %rings of kper:
                Ptemp(k,i2(i,j)+1)=Ptemp(k,i2(i,j)+1)+P2(i,j); %Interpolate power to next ring
                Ptemp(k,i1(i,j)+1)=Ptemp(k,i1(i,j)+1)+P1(i,j); %Interpolate power to previous ring

                %Update number of points interpolated for each ring:
                Nkper(i2(i,j)+1)=Nkper(i2(i,j)+1)+k2(i,j);
                Nkper(i1(i,j)+1)=Nkper(i1(i,j)+1)+k1(i,j);
            end
        end
    end
    if i3(k)<nkpar
        P2D(i3(k)+1,:)=P2D(i3(k)+1,:)+Ptemp(k,:); %Fill array with kper values for each kpar
    end
end
end
%----------------------------------------------------------------------

%----------------------------------------------------------------------
function [P1Dper,P1Dpar]=Compute1DSpectra(P2D,kper,threshold)
%Calculate parallel and perpendicular 1D sepctra from the 2D spectrum.
[c1,index1]=min(abs(kper-threshold)); %Cut spectrum above a threshold k

[c,index]=min(abs(kper-threshold)); %Cut spectrum above a threshold k
Pthres=P2D(2,index);
mask2D=P2D>Pthres;
fieldMASKED=P2D.*mask2D;
P1Dper=sum(fieldMASKED,1); %Sum over parallel k
P1Dpar=sum(fieldMASKED,2); %Sum over perpendicular k
end
%----------------------------------------------------------------------


%----------------------------------------------------------------------
function [E_k,k_bins]=Omni1DSpectra(Bx_dt,Lx,threshold)

% Detrend the variable

Bx_dt_DT = Bx_dt - mean(Bx_dt,'all');

% Perform the FFT of the 3D field B
F_B = fftn(Bx_dt_DT);
Ns=size(Bx_dt);

% Compute the wavenumbers
kx = (2*pi/Lx) * [0:(Ns(1)/2-1) -Ns(1)/2:-1];
ky = kx;
kz = kx;
[KX, KY, KZ] = meshgrid(kx, ky, kz);

% Calculate the radial wavenumber k
K = sqrt(KX.^2 + KY.^2 + KZ.^2);

% Calculate the energy spectrum
energy = abs(F_B).^2;

% Define the bins for the radial wavenumber
dk = 2 * pi / Lx; % Bin width in k-space
k_max = threshold;%max(K(:)); % Maximum wavenumber
k_bins = 0:dk:k_max; % Radial wavenumber bins

% Initialize the omnidirectional spectrum
E_k = zeros(size(k_bins));

% Bin the energy into the radial wavenumber bins
for i = 1:length(k_bins)-1
    k_min = k_bins(i);
    k_max = k_bins(i+1);
    % Find the indices of the Fourier modes that fall within the current bin
    indices = (K >= k_min) & (K < k_max);
    % Sum the energy of these modes
    E_k(i) = sum(energy(indices));
end

% Normalize the spectrum by the bin width
E_k = E_k / dk;

% % Plot the omnidirectional spectrum
% figure;
% loglog(k_bins(1:end-1), E_k(1:end-1), 'LineWidth', 1.5);
% title('1D Omnidirectional Spectrum');
% xlabel('k');
% ylabel('E(k)');
end