%-----------------------------------------------------------------------------------------------------------------------
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/Cirrus_folders/6cube';
%path = '/Users/jeffersson_agudelo/Downloads/data_desktop';
%path = '/Users/jeffersson_agudelo/Documents/New_psc/second_try_version/build_2/testing_jeff/lin_den'; % this has the problem _UP
%path = '/Users/jeffersson_agudelo/Documents/New_psc/second_try_version/build_2/testing_jeff/psc_turb_alf'; % this has the problem _UP
path = '/Volumes/PSC_DiRAC_DATA/Data_Cirrus/turb_alf_cam_3D_small';
%-----------------------------------------------------------------------------------------------------------------------

% For the scripts
path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
path_color = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';

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
nb_n0 =0.1;
kb = 1.; mu0 =1.; c=1; q = 1;

Vai=0.2;
Vae=0.2;%0.2;
Va=0.2;%0.2;

Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);

mime =100.;
mi = mime;
me = 1; eps0=1.;
m = mi + me;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
omega_pi=1;
Omega_e=Vai*sqrt(mime)*omega_pi;
Omega_i=Omega_e / mime;
TOmega_e=1/Omega_e;
TOmega_i=1/Omega_i;
omega_pe_Omega_ce=5;
%--------------------------------------------------------------------------
in=1;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
in=input('select the time stamp: ');

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
l_wind_x = input('Window size:');
fprintf('\n');

l_wind_y = l_wind_x;
l_wind_z = l_wind_x;

[XL3d, YL3d, ZL3d] = meshgrid(xl,yl,zl);
%----------------------------------------------------------------------

% % This is the core and bulky part. Do not erare!
% %----------------------------------------------------------------------
% %----------------------------------------------------------------------
%
%----------------------------------------------------------------------
B{1,1}=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'),start,count);
B{1,2}=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'),start,count);
B{1,3}=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'),start,count);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
E{1,1}=h5read(fileID,strcat(EHJ_1st,'/ex_ec/p0/3d'),start,count);
E{1,2}=h5read(fileID,strcat(EHJ_1st,'/ey_ec/p0/3d'),start,count);
E{1,3}=h5read(fileID,strcat(EHJ_1st,'/ez_ec/p0/3d'),start,count);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
J{1,1}=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'),start,count);
J{1,2}=h5read(fileID,strcat(EHJ_1st,'/jy_ec/p0/3d'),start,count);
J{1,3}=h5read(fileID,strcat(EHJ_1st,'/jz_ec/p0/3d'),start,count);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
p_e{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e/p0/3d'),start,count);
p_e{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e/p0/3d'),start,count);
p_e{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e/p0/3d'),start,count);

p_i{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i/p0/3d'),start,count);
p_i{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i/p0/3d'),start,count);
p_i{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i/p0/3d'),start,count);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
n_e0=h5read(fileID2,strcat(moments_1st,'/rho_e/p0/3d'),start,count);
n_i0=h5read(fileID2,strcat(moments_1st,'/rho_i/p0/3d'),start,count);

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
Pij_e{2,1} = Pij_e{1,2}; Pij_e{3,2} = Pij_e{2,3}; Pij_e{3,1} = Pij_e{1,3};

pressure_ion = input('compute pressure terms 1 (true) 0(false) (integer):');
fprintf('\n');

if(pressure_ion == 1)
    Pij_i{1,1}=h5read(fileID2,strcat(moments_1st,'/txx_i/p0/3d'),start,count);
    Pij_i{2,2}=h5read(fileID2,strcat(moments_1st,'/tyy_i/p0/3d'),start,count);
    Pij_i{3,3}=h5read(fileID2,strcat(moments_1st,'/tzz_i/p0/3d'),start,count);
    Pij_i{1,2}=h5read(fileID2,strcat(moments_1st,'/txy_i/p0/3d'),start,count);
    Pij_i{1,3}=h5read(fileID2,strcat(moments_1st,'/tzx_i/p0/3d'),start,count);
    Pij_i{2,3}=h5read(fileID2,strcat(moments_1st,'/tyz_i/p0/3d'),start,count);
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
n_e0_dt = n_e0;
n_i0_dt = n_i0;
n_0_dt = (n_e0_dt.*me + n_i0_dt.*mi)./(me + mi);

clearvars n_e0 n_i0

v_ex_dt=v_e{1,1};
v_ey_dt=v_e{1,2};
v_ez_dt=v_e{1,3};

v_ix_dt=v_i{1,1};
v_iy_dt=v_i{1,2};
v_iz_dt=v_i{1,3};

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
end

%Pij_iyx_dt = Pij_ixy_dt; Pij_izx_dt = Pij_ixz_dt; Pij_izy_dt = Pij_iyz_dt;

Pij_exx_dt=Pij_e{1,1};
Pij_exy_dt=Pij_e{1,2};
Pij_exz_dt=Pij_e{1,3};
Pij_eyy_dt=Pij_e{2,2};
Pij_eyz_dt=Pij_e{2,3};
Pij_ezz_dt=Pij_e{3,3};

%Pij_eyx_dt = Pij_exy_dt; Pij_ezx_dt = Pij_exz_dt; Pij_ezy_dt = Pij_eyz_dt;

clearvars Pij_i Pij_e
%----------------------------------------------------------------------

Bx_dt=B{1,1};
By_dt=B{1,2};
Bz_dt=B{1,3};

Ex_dt=E{1,1};
Ey_dt=E{1,2};
Ez_dt=E{1,3};

Jx_dt=J{1,1};
Jy_dt=J{1,2};
Jz_dt=J{1,3};
clearvars B E J

%----------------------------------------------------------------------
%select the component % component x=1, y=2, z=3;
component = input('select the component % component x=1, y=2, z=3: ');
%----------------------------------------------------------------------

% Lets compute the generalised ohms terms for total field
%----------------------------------------------------------------------
% Computing non-linear terms for the generalised Ohms law
%----------------------------------------------------------------------

if (component == 1)
    v_x_B_x_dt = v_y_dt.*Bz_dt - v_z_dt.*By_dt;
    J_x_B_x_dt = Jy_dt.*Bz_dt - Jz_dt.*By_dt;
elseif (component == 2)
    v_x_B_y_dt = v_z_dt.*Bx_dt - v_x_dt.*Bz_dt;
    J_x_B_y_dt = Jz_dt.*Bx_dt - Jx_dt.*Bz_dt;
elseif (component == 3)
    v_x_B_z_dt = v_x_dt.*By_dt - v_y_dt.*Bx_dt;
    J_x_B_z_dt = Jx_dt.*By_dt - Jy_dt.*Bx_dt;
end

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

%----------------------------------------------------------------------
%Now let lets compute the gradients
grad_fact = 1; % This always need to be two??
sigma_g=1;
%Grad_Pe
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[Pij_exx_dt_y, Pij_exx_dt_x, Pij_exx_dt_z] = gradient(Pij_exx_dt);
[Pij_eyy_dt_y, Pij_eyy_dt_x, Pij_eyy_dt_z] = gradient(Pij_eyy_dt);
[Pij_ezz_dt_y, Pij_ezz_dt_x, Pij_ezz_dt_z] = gradient(Pij_ezz_dt);
[Pij_exy_dt_y, Pij_exy_dt_x, Pij_exy_dt_z] = gradient(Pij_exy_dt);
[Pij_exz_dt_y, Pij_exz_dt_x, Pij_exz_dt_z] = gradient(Pij_exz_dt);
[Pij_eyz_dt_y, Pij_eyz_dt_x, Pij_eyz_dt_z] = gradient(Pij_eyz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    Div_Pe_dt_x = Pij_exx_dt_x/(grad_fact.*resx) + Pij_exy_dt_y/(grad_fact.*resy) + Pij_exz_dt_z/(grad_fact.*resz);
elseif (component == 2)
    Div_Pe_dt_y = Pij_exy_dt_x/(grad_fact.*resx) + Pij_eyy_dt_y/(grad_fact.*resy) + Pij_eyz_dt_z/(grad_fact.*resz);
elseif (component == 3)
    Div_Pe_dt_z = Pij_exz_dt_x/(grad_fact.*resx) + Pij_eyz_dt_y/(grad_fact.*resy) + Pij_ezz_dt_z/(grad_fact.*resz);
end
clearvars Pij_exx_dt_* Pij_exy_dt_* Pij_exz_dt_* ...
    Pij_eyy_dt_* Pij_eyz_dt_* Pij_ezz_dt_* ...
    %----------------------------------------------------------------------

if(pressure_ion == 1)
    %----------------------------------------------------------------------
    [Pij_ixx_dt_y, Pij_ixx_dt_x, Pij_ixx_dt_z] = gradient(Pij_ixx_dt);
    [Pij_iyy_dt_y, Pij_iyy_dt_x, Pij_iyy_dt_z] = gradient(Pij_iyy_dt);
    [Pij_izz_dt_y, Pij_izz_dt_x, Pij_izz_dt_z] = gradient(Pij_izz_dt);
    [Pij_ixy_dt_y, Pij_ixy_dt_x, Pij_ixy_dt_z] = gradient(Pij_ixy_dt);
    [Pij_ixz_dt_y, Pij_ixz_dt_x, Pij_ixz_dt_z] = gradient(Pij_ixz_dt);
    [Pij_iyz_dt_y, Pij_iyz_dt_x, Pij_iyz_dt_z] = gradient(Pij_iyz_dt);
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    if (component == 1)
        Div_Pi_dt_x = Pij_ixx_dt_x/(grad_fact.*resx) + Pij_ixy_dt_y/(grad_fact.*resy) + Pij_ixz_dt_z/(grad_fact.*resz);
    elseif (component == 2)
        Div_Pi_dt_y = Pij_ixy_dt_x/(grad_fact.*resx) + Pij_iyy_dt_y/(grad_fact.*resy) + Pij_iyz_dt_z/(grad_fact.*resz);
    elseif (component == 3)
        Div_Pi_dt_z = Pij_ixz_dt_x/(grad_fact.*resx) + Pij_iyz_dt_y/(grad_fact.*resy) + Pij_izz_dt_z/(grad_fact.*resz);
    end
    clearvars Pij_ixx_dt_* Pij_ixy_dt_* Pij_ixz_dt_* ...
        Pij_iyy_dt_* Pij_iyz_dt_* Pij_izz_dt_* ...
        %----------------------------------------------------------------------
end

%----------------------------------------------------------------------
[v_J_dt_xx_y, v_J_dt_xx_x, v_J_dt_xx_z] = gradient(v_J_xx_dt);
[v_J_dt_xy_y, v_J_dt_xy_x, v_J_dt_xy_z] = gradient(v_J_xy_dt);
[v_J_dt_xz_y, v_J_dt_xz_x, v_J_dt_xz_z] = gradient(v_J_xz_dt);
[v_J_dt_yx_y, v_J_dt_yx_x, v_J_dt_yx_z] = gradient(v_J_yx_dt);
[v_J_dt_yy_y, v_J_dt_yy_x, v_J_dt_yy_z] = gradient(v_J_yy_dt);
[v_J_dt_yz_y, v_J_dt_yz_x, v_J_dt_yz_z] = gradient(v_J_yz_dt);
[v_J_dt_zx_y, v_J_dt_zx_x, v_J_dt_zx_z] = gradient(v_J_zx_dt);
[v_J_dt_zy_y, v_J_dt_zy_x, v_J_dt_zy_z] = gradient(v_J_zy_dt);
[v_J_dt_zz_y, v_J_dt_zz_x, v_J_dt_zz_z] = gradient(v_J_zz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    Div_vJ_dt_x = v_J_dt_xx_x/(grad_fact.*resx) + v_J_dt_yx_y/(grad_fact.*resy) + v_J_dt_zx_z/(grad_fact.*resz);
elseif (component == 2)
    Div_vJ_dt_y = v_J_dt_xy_x/(grad_fact.*resx) + v_J_dt_yy_y/(grad_fact.*resy) + v_J_dt_zy_z/(grad_fact.*resz);
elseif (component == 3)
    Div_vJ_dt_z = v_J_dt_xz_x/(grad_fact.*resx) + v_J_dt_yz_y/(grad_fact.*resy) + v_J_dt_zz_z/(grad_fact.*resz);
end

clearvars v_J_dt_xx_* v_J_dt_xy_* v_J_dt_xz_* ...
    v_J_dt_yx_* v_J_dt_yy_* v_J_dt_yz_* ...
    v_J_dt_zx_* v_J_dt_zy_* v_J_dt_zz_*
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[J_v_dt_xx_y, J_v_dt_xx_x, J_v_dt_xx_z] = gradient(J_v_xx_dt);
[J_v_dt_xy_y, J_v_dt_xy_x, J_v_dt_xy_z] = gradient(J_v_xy_dt);
[J_v_dt_xz_y, J_v_dt_xz_x, J_v_dt_xz_z] = gradient(J_v_xz_dt);
[J_v_dt_yx_y, J_v_dt_yx_x, J_v_dt_yx_z] = gradient(J_v_yx_dt);
[J_v_dt_yy_y, J_v_dt_yy_x, J_v_dt_yy_z] = gradient(J_v_yy_dt);
[J_v_dt_yz_y, J_v_dt_yz_x, J_v_dt_yz_z] = gradient(J_v_yz_dt);
[J_v_dt_zx_y, J_v_dt_zx_x, J_v_dt_zx_z] = gradient(J_v_zx_dt);
[J_v_dt_zy_y, J_v_dt_zy_x, J_v_dt_zy_z] = gradient(J_v_zy_dt);
[J_v_dt_zz_y, J_v_dt_zz_x, J_v_dt_zz_z] = gradient(J_v_zz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    Div_Jv_dt_x = J_v_dt_xx_x/(grad_fact.*resx) + J_v_dt_yx_y/(grad_fact.*resy) + J_v_dt_zx_z/(grad_fact.*resz);
elseif (component == 2)
    Div_Jv_dt_y = J_v_dt_xy_x/(grad_fact.*resx) + J_v_dt_yy_y/(grad_fact.*resy) + J_v_dt_zy_z/(grad_fact.*resz);
elseif (component == 3)
    Div_Jv_dt_z = J_v_dt_xz_x/(grad_fact.*resx) + J_v_dt_yz_y/(grad_fact.*resy) + J_v_dt_zz_z/(grad_fact.*resz);
end

clearvars J_v_dt_xx_* J_v_dt_xy_* J_v_dt_xz_* ...
    J_v_dt_yx_* J_v_dt_yy_* J_v_dt_yz_* ...
    J_v_dt_zx_* J_v_dt_zy_* J_v_dt_zz_*
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[J_J_dt_xx_y, J_J_dt_xx_x, J_J_dt_xx_z] = gradient(J_J_2n_xx_dt);
[J_J_dt_xy_y, J_J_dt_xy_x, J_J_dt_xy_z] = gradient(J_J_2n_xy_dt);
[J_J_dt_xz_y, J_J_dt_xz_x, J_J_dt_xz_z] = gradient(J_J_2n_xz_dt);
[J_J_dt_yy_y, J_J_dt_yy_x, J_J_dt_yy_z] = gradient(J_J_2n_yy_dt);
[J_J_dt_yz_y, J_J_dt_yz_x, J_J_dt_yz_z] = gradient(J_J_2n_yz_dt);
[J_J_dt_zz_y, J_J_dt_zz_x, J_J_dt_zz_z] = gradient(J_J_2n_zz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    Div_JJ_dt_x = J_J_dt_xx_x/(grad_fact.*resx) + J_J_dt_xy_y/(grad_fact.*resy) + J_J_dt_xz_z/(grad_fact.*resz);
elseif (component == 2)
    Div_JJ_dt_y = J_J_dt_xy_x/(grad_fact.*resx) + J_J_dt_yy_y/(grad_fact.*resy) + J_J_dt_yz_z/(grad_fact.*resz);
elseif (component == 3)
    Div_JJ_dt_z = J_J_dt_xz_x/(grad_fact.*resx) + J_J_dt_yz_y/(grad_fact.*resy) + J_J_dt_zz_z/(grad_fact.*resz);
end

clearvars J_J_dt_xx_* J_J_dt_xy_* J_J_dt_xz_* ...
    J_J_dt_yy_* J_J_dt_yz_* J_J_dt_zz_*
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
%----------------------------------------------------------------------
Bx_filt = imgaussfilt3(Bx_dt,l_wind_x);
By_filt = imgaussfilt3(By_dt,l_wind_x);
Bz_filt = imgaussfilt3(Bz_dt,l_wind_x);

Ex_filt = imgaussfilt3(Ex_dt,l_wind_x);
Ey_filt = imgaussfilt3(Ey_dt,l_wind_x);
Ez_filt = imgaussfilt3(Ez_dt,l_wind_x);

Jx_filt = imgaussfilt3(Jx_dt,l_wind_x);
Jy_filt = imgaussfilt3(Jy_dt,l_wind_x);
Jz_filt = imgaussfilt3(Jz_dt,l_wind_x);

v_ix_filt = imgaussfilt3(v_ix_dt,l_wind_x);
v_iy_filt = imgaussfilt3(v_iy_dt,l_wind_x);
v_iz_filt = imgaussfilt3(v_iz_dt,l_wind_x);

v_ex_filt = imgaussfilt3(v_ex_dt,l_wind_x);
v_ey_filt = imgaussfilt3(v_ey_dt,l_wind_x);
v_ez_filt = imgaussfilt3(v_ez_dt,l_wind_x);

v_x_filt = imgaussfilt3(v_x_dt,l_wind_x);
v_y_filt = imgaussfilt3(v_y_dt,l_wind_x);
v_z_filt = imgaussfilt3(v_z_dt,l_wind_x);

n_e_filt = imgaussfilt3(n_e0_dt,l_wind_x);
n_i_filt = imgaussfilt3(n_i0_dt,l_wind_x);
n_filt = imgaussfilt3(n_0_dt,l_wind_x);

if(pressure_ion == 1)
    Pij_ixx_filt = imgaussfilt3(Pij_ixx_dt,l_wind_x);
    Pij_ixy_filt = imgaussfilt3(Pij_ixy_dt,l_wind_x);
    Pij_ixz_filt = imgaussfilt3(Pij_ixz_dt,l_wind_x);
    Pij_iyy_filt = imgaussfilt3(Pij_iyy_dt,l_wind_x);
    Pij_iyz_filt = imgaussfilt3(Pij_iyz_dt,l_wind_x);
    Pij_izz_filt = imgaussfilt3(Pij_izz_dt,l_wind_x);
end

Pij_exx_filt = imgaussfilt3(Pij_exx_dt,l_wind_x);
Pij_exy_filt = imgaussfilt3(Pij_exy_dt,l_wind_x);
Pij_exz_filt = imgaussfilt3(Pij_exz_dt,l_wind_x);
Pij_eyy_filt = imgaussfilt3(Pij_eyy_dt,l_wind_x);
Pij_eyz_filt = imgaussfilt3(Pij_eyz_dt,l_wind_x);
Pij_ezz_filt = imgaussfilt3(Pij_ezz_dt,l_wind_x);
%----------------------------------------------------------------------

% Computing non-linear terms for the generalised Ohms law
%----------------------------------------------------------------------
if (component == 1)
    v_filt_x_B_filt_x = v_y_filt.*Bz_filt - v_z_filt.*By_filt;
    J_filt_x_B_filt_x = Jy_filt.*Bz_filt - Jz_filt.*By_filt;
elseif (component == 2)
    v_filt_x_B_filt_y = v_z_filt.*Bx_filt - v_x_filt.*Bz_filt;
    J_filt_x_B_filt_y = Jz_filt.*Bx_filt - Jx_filt.*Bz_filt;
elseif (component == 3)
    v_filt_x_B_filt_z = v_x_filt.*By_filt - v_y_filt.*Bx_filt;
    J_filt_x_B_filt_z = Jx_filt.*By_filt - Jy_filt.*Bx_filt;
end

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


%----------------------------------------------------------------------
[Pij_exx_filt_y, Pij_exx_filt_x, Pij_exx_filt_z] = gradient(Pij_exx_filt);
[Pij_eyy_filt_y, Pij_eyy_filt_x, Pij_eyy_filt_z] = gradient(Pij_eyy_filt);
[Pij_ezz_filt_y, Pij_ezz_filt_x, Pij_ezz_filt_z] = gradient(Pij_ezz_filt);
[Pij_exy_filt_y, Pij_exy_filt_x, Pij_exy_filt_z] = gradient(Pij_exy_filt);
[Pij_exz_filt_y, Pij_exz_filt_x, Pij_exz_filt_z] = gradient(Pij_exz_filt);
[Pij_eyz_filt_y, Pij_eyz_filt_x, Pij_eyz_filt_z] = gradient(Pij_eyz_filt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    Div_Pe_filt_x = Pij_exx_filt_x/(grad_fact.*resx) + Pij_exy_filt_y/(grad_fact.*resy) + Pij_exz_filt_z/(grad_fact.*resz);
elseif (component == 2)
    Div_Pe_filt_y = Pij_exy_filt_x/(grad_fact.*resx) + Pij_eyy_filt_y/(grad_fact.*resy) + Pij_eyz_filt_z/(grad_fact.*resz);
elseif (component == 3)
    Div_Pe_filt_z = Pij_exz_filt_x/(grad_fact.*resx) + Pij_eyz_filt_y/(grad_fact.*resy) + Pij_ezz_filt_z/(grad_fact.*resz);
end
clearvars Pij_exx_filt_* Pij_exy_filt_* Pij_exz_filt_* ...
    Pij_eyy_filt_* Pij_eyz_filt_* Pij_ezz_filt_* ...
    %----------------------------------------------------------------------

if(pressure_ion == 1)
    %----------------------------------------------------------------------
    [Pij_ixx_filt_y, Pij_ixx_filt_x, Pij_ixx_filt_z] = gradient(Pij_ixx_filt);
    [Pij_iyy_filt_y, Pij_iyy_filt_x, Pij_iyy_filt_z] = gradient(Pij_iyy_filt);
    [Pij_izz_filt_y, Pij_izz_filt_x, Pij_izz_filt_z] = gradient(Pij_izz_filt);
    [Pij_ixy_filt_y, Pij_ixy_filt_x, Pij_ixy_filt_z] = gradient(Pij_ixy_filt);
    [Pij_ixz_filt_y, Pij_ixz_filt_x, Pij_ixz_filt_z] = gradient(Pij_ixz_filt);
    [Pij_iyz_filt_y, Pij_iyz_filt_x, Pij_iyz_filt_z] = gradient(Pij_iyz_filt);
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    if (component == 1)
        Div_Pi_filt_x = Pij_ixx_filt_x/(grad_fact.*resx) + Pij_ixy_filt_y/(grad_fact.*resy) + Pij_ixz_filt_z/(grad_fact.*resz);
    elseif (component == 2)
        Div_Pi_filt_y = Pij_ixy_filt_x/(grad_fact.*resx) + Pij_iyy_filt_y/(grad_fact.*resy) + Pij_iyz_filt_z/(grad_fact.*resz);
    elseif (component == 3)
        Div_Pi_filt_z = Pij_ixz_filt_x/(grad_fact.*resx) + Pij_iyz_filt_y/(grad_fact.*resy) + Pij_izz_filt_z/(grad_fact.*resz);
    end
    clearvars Pij_ixx_filt_* Pij_ixy_filt_* Pij_ixz_filt_* ...
        Pij_iyy_filt_* Pij_iyz_filt_* Pij_izz_filt_* ...
        %----------------------------------------------------------------------
end

%----------------------------------------------------------------------
[v_filt_J_filt_xx_y, v_filt_J_filt_xx_x, v_filt_J_filt_xx_z] = gradient(v_filt_J_filt_xx);
[v_filt_J_filt_xy_y, v_filt_J_filt_xy_x, v_filt_J_filt_xy_z] = gradient(v_filt_J_filt_xy);
[v_filt_J_filt_xz_y, v_filt_J_filt_xz_x, v_filt_J_filt_xz_z] = gradient(v_filt_J_filt_xz);
[v_filt_J_filt_yx_y, v_filt_J_filt_yx_x, v_filt_J_filt_yx_z] = gradient(v_filt_J_filt_yx);
[v_filt_J_filt_yy_y, v_filt_J_filt_yy_x, v_filt_J_filt_yy_z] = gradient(v_filt_J_filt_yy);
[v_filt_J_filt_yz_y, v_filt_J_filt_yz_x, v_filt_J_filt_yz_z] = gradient(v_filt_J_filt_yz);
[v_filt_J_filt_zx_y, v_filt_J_filt_zx_x, v_filt_J_filt_zx_z] = gradient(v_filt_J_filt_zx);
[v_filt_J_filt_zy_y, v_filt_J_filt_zy_x, v_filt_J_filt_zy_z] = gradient(v_filt_J_filt_zy);
[v_filt_J_filt_zz_y, v_filt_J_filt_zz_x, v_filt_J_filt_zz_z] = gradient(v_filt_J_filt_zz);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    Div_vJ_filt_x = v_filt_J_filt_xx_x/(grad_fact.*resx) + v_filt_J_filt_yx_y/(grad_fact.*resy) + v_filt_J_filt_zx_z/(grad_fact.*resz);
elseif (component == 2)
    Div_vJ_filt_y = v_filt_J_filt_xy_x/(grad_fact.*resx) + v_filt_J_filt_yy_y/(grad_fact.*resy) + v_filt_J_filt_zy_z/(grad_fact.*resz);
elseif (component == 3)
    Div_vJ_filt_z = v_filt_J_filt_xz_x/(grad_fact.*resx) + v_filt_J_filt_yz_y/(grad_fact.*resy) + v_filt_J_filt_zz_z/(grad_fact.*resz);
end

clearvars v_filt_J_filt_xx_* v_filt_J_filt_xy_* v_filt_J_filt_xz_* ...
    v_filt_J_filt_yx_* v_filt_J_filt_yy_* v_filt_J_filt_yz_* ...
    v_filt_J_filt_zx_* v_filt_J_filt_zy_* v_filt_J_filt_zz_*
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[J_filt_v_filt_xx_y, J_filt_v_filt_xx_x, J_filt_v_filt_xx_z] = gradient(J_filt_v_filt_xx);
[J_filt_v_filt_xy_y, J_filt_v_filt_xy_x, J_filt_v_filt_xy_z] = gradient(J_filt_v_filt_xy);
[J_filt_v_filt_xz_y, J_filt_v_filt_xz_x, J_filt_v_filt_xz_z] = gradient(J_filt_v_filt_xz);
[J_filt_v_filt_yx_y, J_filt_v_filt_yx_x, J_filt_v_filt_yx_z] = gradient(J_filt_v_filt_yx);
[J_filt_v_filt_yy_y, J_filt_v_filt_yy_x, J_filt_v_filt_yy_z] = gradient(J_filt_v_filt_yy);
[J_filt_v_filt_yz_y, J_filt_v_filt_yz_x, J_filt_v_filt_yz_z] = gradient(J_filt_v_filt_yz);
[J_filt_v_filt_zx_y, J_filt_v_filt_zx_x, J_filt_v_filt_zx_z] = gradient(J_filt_v_filt_zx);
[J_filt_v_filt_zy_y, J_filt_v_filt_zy_x, J_filt_v_filt_zy_z] = gradient(J_filt_v_filt_zy);
[J_filt_v_filt_zz_y, J_filt_v_filt_zz_x, J_filt_v_filt_zz_z] = gradient(J_filt_v_filt_zz);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    Div_Jv_filt_x = J_filt_v_filt_xx_x/(grad_fact.*resx) + J_filt_v_filt_yx_y/(grad_fact.*resy) + J_filt_v_filt_zx_z/(grad_fact.*resz);
elseif (component == 2)
    Div_Jv_filt_y = J_filt_v_filt_xy_x/(grad_fact.*resx) + J_filt_v_filt_yy_y/(grad_fact.*resy) + J_filt_v_filt_zy_z/(grad_fact.*resz);
elseif (component == 3)
    Div_Jv_filt_z = J_filt_v_filt_xz_x/(grad_fact.*resx) + J_filt_v_filt_yz_y/(grad_fact.*resy) + J_filt_v_filt_zz_z/(grad_fact.*resz);
end

clearvars J_filt_v_filt_xx_* J_filt_v_filt_xy_* J_filt_v_filt_xz_* ...
    J_filt_v_filt_yx_* J_filt_v_filt_yy_* J_filt_v_filt_yz_* ...
    J_filt_v_filt_zx_* J_filt_v_filt_zy_* J_filt_v_filt_zz_*
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[J_filt_J_filt_xx_y, J_filt_J_filt_xx_x, J_filt_J_filt_xx_z] = gradient(J_filt_J_filt_2n_xx);
[J_filt_J_filt_xy_y, J_filt_J_filt_xy_x, J_filt_J_filt_xy_z] = gradient(J_filt_J_filt_2n_xy);
[J_filt_J_filt_xz_y, J_filt_J_filt_xz_x, J_filt_J_filt_xz_z] = gradient(J_filt_J_filt_2n_xz);
[J_filt_J_filt_yy_y, J_filt_J_filt_yy_x, J_filt_J_filt_yy_z] = gradient(J_filt_J_filt_2n_yy);
[J_filt_J_filt_yz_y, J_filt_J_filt_yz_x, J_filt_J_filt_yz_z] = gradient(J_filt_J_filt_2n_yz);
[J_filt_J_filt_zz_y, J_filt_J_filt_zz_x, J_filt_J_filt_zz_z] = gradient(J_filt_J_filt_2n_zz);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    Div_JJ_filt_2n_x = J_filt_J_filt_xx_x/(grad_fact.*resx) + J_filt_J_filt_xy_y/(grad_fact.*resy) + J_filt_J_filt_xz_z/(grad_fact.*resz);
elseif (component == 2)
    Div_JJ_filt_2n_y = J_filt_J_filt_xy_x/(grad_fact.*resx) + J_filt_J_filt_yy_y/(grad_fact.*resy) + J_filt_J_filt_yz_z/(grad_fact.*resz);
elseif (component == 3)
    Div_JJ_filt_2n_z = J_filt_J_filt_xz_x/(grad_fact.*resx) + J_filt_J_filt_yz_y/(grad_fact.*resy) + J_filt_J_filt_zz_z/(grad_fact.*resz);
end

clearvars J_filt_J_filt_xx_* J_filt_J_filt_xy_* J_filt_J_dt_xz_* ...
    J_filt_J_dt_yy_* J_filt_J_dt_yz_* J_filt_J_dt_zz_*
%----------------------------------------------------------------------

%----------------------------------------------------------------------
clearvars v_filt_J_filt_* J_filt_v_filt_* J_filt_J_filt_*
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

%%%  Now let's compute the tensors
% % %----------------------------------------------------------------------
%----------------------------------------------------------------------
[sub_tau1_xx_y, sub_tau1_xx_x, sub_tau1_xx_z] = gradient(sub_tau1_xx);
[sub_tau1_xy_y, sub_tau1_xy_x, sub_tau1_xy_z] = gradient(sub_tau1_xy);
[sub_tau1_xz_y, sub_tau1_xz_x, sub_tau1_xz_z] = gradient(sub_tau1_xz);
[sub_tau1_yx_y, sub_tau1_yx_x, sub_tau1_yx_z] = gradient(sub_tau1_yx);
[sub_tau1_yy_y, sub_tau1_yy_x, sub_tau1_yy_z] = gradient(sub_tau1_yy);
[sub_tau1_yz_y, sub_tau1_yz_x, sub_tau1_yz_z] = gradient(sub_tau1_yz);
[sub_tau1_zx_y, sub_tau1_zx_x, sub_tau1_zx_z] = gradient(sub_tau1_zx);
[sub_tau1_zy_y, sub_tau1_zy_x, sub_tau1_zy_z] = gradient(sub_tau1_zy);
[sub_tau1_zz_y, sub_tau1_zz_x, sub_tau1_zz_z] = gradient(sub_tau1_zz);
%----------------------------------------------------------------------


% % % Now let's compute the tensors
%----------------------------------------------------------------------
if (component == 1)
    %(<nE> - <n><E>)/<n>
    % % %----------------------------------------------------------------------
    tau_nE_tau = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*Ex_dt,l_wind_x))./n_filt - Ex_filt);
    %(<nevxB> - <n><v>x<B>)/<ne>
    % % %----------------------------------------------------------------------
    tau_v_x_B_tau = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*v_x_B_x_dt,l_wind_x))./n_filt - v_filt_x_B_filt_x);
    %(<nevxB> - <n><J>x<B>)/<ne>
    %----------------------------------------------------------------------
    tau_J_x_B_tau = (B0*c)^(1)*((imgaussfilt3(J_x_B_x_dt,l_wind_x) - J_filt_x_B_filt_x)./n_filt);
    %----------------------------------------------------------------------
    Div_sub_tau1 = sub_tau1_xx_x/(grad_fact.*resx) + sub_tau1_yx_y/(grad_fact.*resy) + sub_tau1_zx_z/(grad_fact.*resz);
    %----------------------------------------------------------------------
    tau_Div_tau1 = me*c*c*(1.*(imgaussfilt3(Div_sub_tau1,l_wind_x) - (Div_vJ_filt_x + Div_Jv_filt_x - Div_JJ_filt_2n_x))./n_filt);
    % % %----------------------------------------------------------------------
elseif (component == 2)
    % % %----------------------------------------------------------------------
    tau_nE_tau = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*Ey_dt,l_wind_x))./n_filt - Ey_filt);
    % % %----------------------------------------------------------------------
    tau_v_x_B_tau = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*v_x_B_y_dt,l_wind_x))./n_filt - v_filt_x_B_filt_y);
    % % %----------------------------------------------------------------------
    tau_J_x_B_tau = (B0*c)^(1)*((imgaussfilt3(J_x_B_y_dt,l_wind_x) - J_filt_x_B_filt_y)./n_filt);
    % % %----------------------------------------------------------------------
    Div_sub_tau1 = sub_tau1_xy_x/(grad_fact.*resx) + sub_tau1_yy_y/(grad_fact.*resy) + sub_tau1_zy_z/(grad_fact.*resz);
    % % %----------------------------------------------------------------------
    tau_Div_tau1 = me*c*c*(1.*(imgaussfilt3(Div_sub_tau1,l_wind_x) - (Div_vJ_filt_y + Div_Jv_filt_y - Div_JJ_filt_2n_y))./n_filt);
elseif (component == 3)
    % % %----------------------------------------------------------------------
    tau_nE_tau = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*Ez_dt,l_wind_x))./n_filt - Ez_filt);
    % % %----------------------------------------------------------------------
    tau_v_x_B_tau = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*v_x_B_z_dt,l_wind_x))./n_filt - v_filt_x_B_filt_z);
    % % %----------------------------------------------------------------------
    tau_J_x_B_tau = (B0*c)^(1)*((imgaussfilt3(J_x_B_z_dt,l_wind_x) - J_filt_x_B_filt_z)./n_filt);
    % % %----------------------------------------------------------------------
    Div_sub_tau1 = sub_tau1_xz_x/(grad_fact.*resx) + sub_tau1_yz_y/(grad_fact.*resy) + sub_tau1_zz_z/(grad_fact.*resz);
    %----------------------------------------------------------------------
    tau_Div_tau1 = me*c*c*(1.*(imgaussfilt3(Div_sub_tau1,l_wind_x) - (Div_vJ_filt_z + Div_Jv_filt_z - Div_JJ_filt_2n_z))./n_filt);
    %----------------------------------------------------------------------
end

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
if (component == 1)
v_x_B_x_dt = v_y_dt.*Bz_dt - v_z_dt.*By_dt;
J_x_B_x_dt = Jy_dt.*Bz_dt - Jz_dt.*By_dt;
%Div_Pe_dt_x = Pe_dt_x/(grad_fact.*resx);
v_x_B_x_filt = v_y_filt.*Bz_filt - v_z_filt.*By_filt;
J_x_B_x_filt = Jy_filt.*Bz_filt - Jz_filt.*By_filt;
%Div_Pe_filt_x = Pe_filt_x/(grad_fact.*resx);
elseif (component == 2)
v_x_B_y_dt = v_z_dt.*Bx_dt - v_x_dt.*Bz_dt;
J_x_B_y_dt = Jz_dt.*Bx_dt - Jx_dt.*Bz_dt;
%Div_Pe_dt_y = Pe_dt_y/(grad_fact.*resy);
v_x_B_y_filt = v_z_dt.*Bx_filt - v_x_filt.*Bz_filt;
J_x_B_y_filt = Jz_dt.*Bx_filt - Jx_filt.*Bz_filt;
%Div_Pe_filt_y = Pe_filt_y/(grad_fact.*resy);
elseif (component == 3)
v_x_B_z_dt = v_x_dt.*By_dt - v_y_dt.*Bx_dt;
J_x_B_z_dt = Jx_dt.*By_dt - Jy_dt.*Bx_dt;
%Div_Pe_dt_z = Pe_dt_z/(grad_fact.*resz);
v_x_B_z_filt = v_x_filt.*By_filt - v_y_filt.*Bx_filt;
J_x_B_z_filt = Jx_filt.*By_filt - Jy_filt.*Bx_filt;
%Div_Pe_filt_z = Pe_filt_z/(grad_fact.*resz);
end
clearvars Pe_dt_*
clearvars Pe_filt_*
%--------------------------------------------------------------------------

%----------------------------------------------------------------------
% terms from the owns law with no signs
%----------------------------------------------------------------------
if (component == 1)
term1_dt = B0*v_a*(Ex_dt);
term2_dt = B0*v_a*(v_x_B_x_dt);
term3_dt = B0*v_a*J_x_B_x_dt./n_0_dt;
term4_dt = v_a*v_a*(Div_Pe_dt_x./n_0_dt); 
term5_dt = me*v_a*v_a*((Div_vJ_dt_x + Div_Jv_dt_x - Div_JJ_dt_x)./n_0_dt);
%----------------------------------------------------------------------
% This is for the filtered quantities
%----------------------------------------------------------------------
term1_filt = B0*v_a*(Ex_filt);
term2_filt = B0*v_a*(v_filt_x_B_filt_x);
term3_filt = B0*v_a*J_filt_x_B_filt_x./n_filt;
term4_filt = v_a*v_a*(Div_Pe_filt_x./n_filt);
term5_filt = me*v_a*v_a*((Div_vJ_filt_x + Div_Jv_filt_x - Div_JJ_filt_2n_x)./n_filt);
elseif (component == 2)
term1_dt = B0*v_a*(Ey_dt);
term2_dt = B0*v_a*(v_x_B_y_dt);
term3_dt = B0*v_a*J_x_B_y_dt./n_0_dt;
term4_dt = v_a*v_a*(Div_Pe_dt_y./n_0_dt); 
term5_dt = me*v_a*v_a*((Div_vJ_dt_y + Div_Jv_dt_y - Div_JJ_dt_y)./n_0_dt);
%----------------------------------------------------------------------
% This is for the filtered quantities
%----------------------------------------------------------------------
term1_filt = B0*v_a*(Ey_filt);
term2_filt = B0*v_a*(v_filt_x_B_filt_y);
term3_filt = B0*v_a*J_filt_x_B_filt_y./n_filt;
term4_filt = v_a*v_a*(Div_Pe_filt_y./n_filt);
term5_filt = me*v_a*v_a*((Div_vJ_filt_y + Div_Jv_filt_y - Div_JJ_filt_2n_y)./n_filt);
elseif (component ==3)
term1_dt = B0*v_a*(Ez_dt);
term2_dt = B0*v_a*(v_x_B_z_dt);
term3_dt = B0*v_a*J_x_B_z_dt./n_0_dt;
term4_dt = v_a*v_a*(Div_Pe_dt_z./n_0_dt); 
term5_dt = me*v_a*v_a*((Div_vJ_dt_z + Div_Jv_dt_z - Div_JJ_dt_z)./n_0_dt);
%----------------------------------------------------------------------
% This is for the filtered quantities
%----------------------------------------------------------------------
term1_filt = B0*v_a*(Ez_filt);
term2_filt = B0*v_a*(v_filt_x_B_filt_z);
term3_filt = B0*v_a*J_filt_x_B_filt_z./n_filt;
term4_filt = v_a*v_a*(Div_Pe_filt_z./n_filt);
term5_filt = me*v_a*v_a*((Div_vJ_filt_z + Div_Jv_filt_z - Div_JJ_filt_2n_z)./n_filt);
end 
%----------------------------------------------------------------------


%%
% This is to compute the voritcity 
%
[v_x_dt_y, v_x_dt_x, v_x_dt_z] = gradient(v_x_dt);
[v_y_dt_y, v_y_dt_x, v_y_dt_z] = gradient(v_y_dt);
[v_z_dt_y, v_z_dt_x, v_z_dt_z] = gradient(v_z_dt);

 vort_x_dt = (v_z_dt_y - v_y_dt_z)./(grad_fact.*resx);
 vort_y_dt = (v_x_dt_z - v_z_dt_x)./(grad_fact.*resy);
 vort_z_dt = (v_y_dt_x - v_x_dt_y)./(grad_fact.*resz);
 
[v_x_filt_y, v_x_filt_x, v_x_filt_z] = gradient(v_x_filt);
[v_y_filt_y, v_y_filt_x, v_y_filt_z] = gradient(v_y_filt);
[v_z_filt_y, v_z_filt_x, v_z_filt_z] = gradient(v_z_filt);

 vort_x_filt = (v_z_filt_y - v_y_filt_z)./(grad_fact.*resx);
 vort_y_filt = (v_x_filt_z - v_z_filt_x)./(grad_fact.*resy);
 vort_z_filt = (v_y_filt_x - v_x_filt_y)./(grad_fact.*resz);

% This is to get the unresolved terms to compute the turbulent energy, the
% turbulent cross helicity and the turbulent helicity
%----------------------------------------------------------------------
% H = <-u' . w' + b' . j' >; 
% K = <u'^2 + b'^2>; 
% KR = <u'^2 - b'^2>; 
% W = <u' . b'>;
%----------------------------------------------------------------------

% compute the fluctuating quantities (prime quantities)
%----------------------------------------------------------------------
% This has to be donein alfven units
%----------------------------------------------------------------------
%Ex_pri = Ex_dt - Ex_filt;
%Ey_pri = Ey_dt - Ey_filt;
%Ez_pri = Ez_dt - Ez_filt;
%n_0_pri = n_0_dt - n_filt;

% Using local density
%Bx_pri = Bx_dt./n_0_dt - Bx_filt./n_filt;
%By_pri = By_dt./n_0_dt - By_filt./n_filt;
%Bz_pri = Bz_dt./n_0_dt - Bz_filt./n_filt;

% Using a constant dencity for the alfven units
Bx_pri = Bx_dt - Bx_filt;
Jx_pri = Jx_dt - Jx_filt;
v_x_pri = v_x_dt - v_x_filt;
vort_x_pri = vort_x_dt - vort_x_filt;

By_pri = By_dt - By_filt;
Jy_pri = Jy_dt - Jy_filt;
v_y_pri = v_y_dt - v_y_filt;
vort_y_pri = vort_y_dt - vort_y_filt;

Bz_pri = Bz_dt - Bz_filt;
Jz_pri = Jz_dt - Jz_filt;
v_z_pri = v_z_dt - v_z_filt;
vort_z_pri = vort_z_dt - vort_z_filt;

WW = v_x_pri.*Bx_pri + v_y_pri.*By_pri + v_z_pri.*Bz_pri;
HH = -(v_x_pri.*vort_x_pri + v_y_pri.*vort_y_pri + v_z_pri.*vort_z_pri)...
    + (Bx_pri.*Jx_pri + By_pri.*Jy_pri +Bz_pri.*Jz_pri);
KK = 0.5.*(v_x_pri.^2 + v_y_pri.^2 + v_z_pri.^2 ...
    + Bx_pri.^2 + By_pri.^2 + Bz_pri.^2  );
KK_R = 0.5.*(v_x_pri.^2 + v_y_pri.^2 + v_z_pri.^2 ...
    - Bx_pri.^2 - By_pri.^2 - Bz_pri.^2  );


if (component == 1)
    clearvars *_y *_z
elseif (component == 2)
    clearvars *_x *_z
elseif (component == 3)
    clearvars *_x *_y
end

W_filt = imgaussfilt3(WW,l_wind_x);
H_filt = imgaussfilt3(HH,l_wind_x);
K_filt = imgaussfilt3(KK,l_wind_x);
KR_filt = imgaussfilt3(KK_R,l_wind_x);

% Products for the model constants 
%tau_uxB = Cbeta * tau_nl * K * J

if (component == 1)
K_filt_J_filt_x = K_filt.*Jx_filt ;
H_filt_B_filt_x = H_filt.*Bx_filt ;
W_filt_ome_filt_x = W_filt.*vort_x_filt ;
elseif (component == 2)
K_filt_J_filt_y = K_filt.*Jy_filt ;
H_filt_B_filt_y = H_filt.*By_filt ;
W_filt_ome_filt_y = W_filt.*vort_y_filt ;
elseif (component == 3)
K_filt_J_filt_z = K_filt.*Jz_filt ;
H_filt_B_filt_z = H_filt.*Bz_filt ;
W_filt_ome_filt_z = W_filt.*vort_z_filt ;
end

if (component == 1)
KK_filt_J_filt_x = K_filt.*K_filt.*Jx_filt ;
HK_filt_B_filt_x = K_filt.*H_filt.*Bx_filt ;
WK_filt_ome_filt_x = K_filt.*W_filt.*vort_x_filt ;
elseif (component == 2)
KK_filt_J_filt_y = K_filt.*K_filt.*Jy_filt ;
HK_filt_B_filt_y = K_filt.*H_filt.*By_filt ;
WK_filt_ome_filt_y = K_filt.*W_filt.*vort_y_filt ;
elseif (component == 3)
KK_filt_J_filt_z = K_filt.*K_filt.*Jz_filt ;
HK_filt_B_filt_z = K_filt.*H_filt.*Bz_filt ;
WK_filt_ome_filt_z = K_filt.*W_filt.*vort_z_filt ;
end

% Computing the means in the entire simulation domain so the later
% multiplication is normalised better

K_filt_J_filt_x_mean = mean(abs(K_filt_J_filt_x),'all'); % important the abs
KK_filt_J_filt_x_mean = mean(abs(KK_filt_J_filt_x),'all'); 

H_filt_B_filt_x_mean = mean(abs(H_filt_B_filt_x),'all'); 
KH_filt_B_filt_x_mean = mean(abs(HK_filt_B_filt_x),'all'); 

W_filt_ome_filt_x_mean = mean(abs(W_filt_ome_filt_x),'all'); 
KW_filt_ome_filt_x_mean = mean(abs(WK_filt_ome_filt_x),'all'); 


%}
%----------------------------------------------------------------------


%%
% Now actually computing point by point thing <<-----
%--------------------------------------------------------------------------
%
%down_sample_rate = 200;
down_sample_rate = input('input for the downsample rate for the correlation plots must be integer and the matrix must be divisible: ');

% The tau_vxB has been divided already by the density.

if (component == 1)
    J_scatter_x = downsample(Jx_filt(:),down_sample_rate);
    B_scatter_x = downsample(Bx_filt(:),down_sample_rate);
    vort_scatter_x = downsample(vort_x_filt(:),down_sample_rate);

    KJ_scatter_x = downsample(K_filt_J_filt_x(:),down_sample_rate)/K_filt_J_filt_x_mean;
    HB_scatter_x = downsample(H_filt_B_filt_x(:),down_sample_rate)/H_filt_B_filt_x_mean;
    Wvort_scatter_x = downsample(W_filt_ome_filt_x(:),down_sample_rate)/W_filt_ome_filt_x_mean;

    KKJ_scatter_x = downsample(KK_filt_J_filt_x(:),down_sample_rate)/KK_filt_J_filt_x_mean;
    KHB_scatter_x = downsample(HK_filt_B_filt_x(:),down_sample_rate)/KH_filt_B_filt_x_mean;
    KWvort_scatter_x = downsample(WK_filt_ome_filt_x(:),down_sample_rate)/KW_filt_ome_filt_x_mean;

    var_tau1_x = downsample(tau_v_x_B_tau(:),down_sample_rate)/mean(abs(tau_v_x_B_tau),'all');
    var_tau2_x = downsample(tau_nE_tau(:),down_sample_rate)/mean(abs(tau_nE_tau),'all');
    var_tau3_x = downsample(tau_J_x_B_tau(:),down_sample_rate)/mean(abs(tau_J_x_B_tau),'all');
    var_tau4_x = downsample(tau_Div_tau1(:),down_sample_rate)/mean(abs(tau_Div_tau1),'all');

elseif (component == 2)
    J_scatter_x = downsample(Jy_filt(:),down_sample_rate);
    B_scatter_x = downsample(By_filt(:),down_sample_rate);
    vort_scatter_x = downsample(vort_x_filt(:),down_sample_rate);

    KJ_scatter_x = downsample(K_filt_J_filt_y(:),down_sample_rate)/K_filt_J_filt_x_mean;
    HB_scatter_x = downsample(H_filt_B_filt_y(:),down_sample_rate)/H_filt_B_filt_x_mean;
    Wvort_scatter_x = downsample(W_filt_ome_filt_y(:),down_sample_rate)/W_filt_ome_filt_x_mean;

    KKJ_scatter_x = downsample(KK_filt_J_filt_y(:),down_sample_rate)/KK_filt_J_filt_x_mean;
    KHB_scatter_x = downsample(HK_filt_B_filt_y(:),down_sample_rate)/KH_filt_B_filt_x_mean;
    KWvort_scatter_x = downsample(WK_filt_ome_filt_y(:),down_sample_rate)/KW_filt_ome_filt_x_mean;

    var_tau1_x = downsample(tau_v_x_B_tau(:),down_sample_rate)/mean(abs(tau_v_x_B_tau),'all');
    var_tau2_x = downsample(tau_nE_tau(:),down_sample_rate)/mean(abs(tau_nE_tau),'all');
    var_tau3_x = downsample(tau_J_x_B_tau(:),down_sample_rate)/mean(abs(tau_J_x_B_tau),'all');
    var_tau4_x = downsample(tau_Div_tau1(:),down_sample_rate)/mean(abs(tau_Div_tau1),'all');

elseif (component == 3)
    J_scatter_x = downsample(Jz_filt(:),down_sample_rate);
    B_scatter_x = downsample(Bz_filt(:),down_sample_rate);
    vort_scatter_x = downsample(vort_x_filt(:),down_sample_rate);

    KJ_scatter_x = downsample(K_filt_J_filt_z(:),down_sample_rate)/K_filt_J_filt_x_mean;
    HB_scatter_x = downsample(H_filt_B_filt_z(:),down_sample_rate)/H_filt_B_filt_x_mean;
    Wvort_scatter_x = downsample(W_filt_ome_filt_z(:),down_sample_rate)/W_filt_ome_filt_x_mean;

    KKJ_scatter_x = downsample(KK_filt_J_filt_z(:),down_sample_rate)/KK_filt_J_filt_x_mean;
    KHB_scatter_x = downsample(HK_filt_B_filt_z(:),down_sample_rate)/KH_filt_B_filt_x_mean;
    KWvort_scatter_x = downsample(WK_filt_ome_filt_z(:),down_sample_rate)/KW_filt_ome_filt_x_mean;   

    var_tau1_x = downsample(tau_v_x_B_tau(:),down_sample_rate)/mean(abs(tau_v_x_B_tau),'all');
    var_tau2_x = downsample(tau_nE_tau(:),down_sample_rate)/mean(abs(tau_nE_tau),'all');
    var_tau3_x = downsample(tau_J_x_B_tau(:),down_sample_rate)/mean(abs(tau_J_x_B_tau),'all');
    var_tau4_x = downsample(tau_Div_tau1(:),down_sample_rate)/mean(abs(tau_Div_tau1),'all');
end
%--------------------------------------------------------------------------
%%
%}
%%% This is for the spectrum
%{
%----------------------------------------------------------------------
fs=20;
threshold = pi/resx;
%----------------------------------------------------------------------

%----------------------------------------------------------------------
% This is to get the 1D omni spectra
%----------------------------------------------------------------------
%if (component == 1)
    [E_k_tau_v_x_B_tau,~]=Omni1DSpectra(tau_v_x_B_tau,Lx,threshold);
    [E_k_tau_nE_tau,~]=Omni1DSpectra(tau_nE_tau,Lx,threshold);
    [E_k_tau_J_x_B_tau,~]=Omni1DSpectra(tau_J_x_B_tau,Lx,threshold);
    [E_k_tau_Div_tau1,~]=Omni1DSpectra(tau_Div_tau1,Lx,threshold);
% % elseif (component == 2)
% %     [E_k_tau_v_x_B_tau_x,~]=Omni1DSpectra(tau_v_x_B_tau_y,Lx,threshold);
% %     [E_k_tau_nE_tau_x,~]=Omni1DSpectra(tau_nE_tau_y,Lx,threshold);
% %     [E_k_tau_J_x_B_tau_x,~]=Omni1DSpectra(tau_J_x_B_tau_y,Lx,threshold);
% %     [E_k_tau_Div_tau1_x,~]=Omni1DSpectra(tau_Div_tau1_y,Lx,threshold);
% % elseif (component == 3)
% %     [E_k_tau_v_x_B_tau_x,~]=Omni1DSpectra(tau_v_x_B_tau_z,Lx,threshold);
% %     [E_k_tau_nE_tau_x,~]=Omni1DSpectra(tau_nE_tau_z,Lx,threshold);
% %     [E_k_tau_J_x_B_tau_x,~]=Omni1DSpectra(tau_J_x_B_tau_z,Lx,threshold);
% %     [E_k_tau_Div_tau1_x,~]=Omni1DSpectra(tau_Div_tau1_z,Lx,threshold);
% % end

[E_k_term1_dt,~]=Omni1DSpectra(term1_dt,Lx,threshold);
[E_k_term2_dt,~]=Omni1DSpectra(term2_dt,Lx,threshold);
[E_k_term3_dt,~]=Omni1DSpectra(term3_dt,Lx,threshold);
[E_k_term4_dt,~]=Omni1DSpectra(term4_dt,Lx,threshold);
[E_k_term5_dt,~]=Omni1DSpectra(term5_dt,Lx,threshold);

term2to5_dt = -term2_dt +term3_dt -term4_dt + term5_dt;
term2to5_filt = -term2_filt +term3_filt -term4_filt + term5_filt;

[E_k_term2to5_dt,~]=Omni1DSpectra(term2to5_dt,Lx,threshold);
[E_k_term2to5_filt,~]=Omni1DSpectra(term2to5_filt,Lx,threshold);

[E_k_term1_filt,~]=Omni1DSpectra(term1_filt,Lx,threshold);
[E_k_term2_filt,~]=Omni1DSpectra(term2_filt,Lx,threshold);
[E_k_term3_filt,~]=Omni1DSpectra(term3_filt,Lx,threshold);
[E_k_term4_filt,~]=Omni1DSpectra(term4_filt,Lx,threshold);
[E_k_term5_filt,k_bins]=Omni1DSpectra(term5_filt,Lx,threshold);
%----------------------------------------------------------------------

% % %----------------------------------------------------------------------
% % % This is to get the 2D spectra of the different terms withouth filtering
% % %----------------------------------------------------------------------
% % [P2D_term1_dt,~]=Power_of_filtering_kernel(term1_dt,Lx,Ly,Lz);
% % [P2D_term2_dt,~]=Power_of_filtering_kernel(term2_dt,Lx,Ly,Lz);
% % [P2D_term3_dt,~]=Power_of_filtering_kernel(term3_dt,Lx,Ly,Lz);
% % [P2D_term4_dt,~]=Power_of_filtering_kernel(term4_dt,Lx,Ly,Lz);
% % [P2D_term5_dt,~]=Power_of_filtering_kernel(term5_dt,Lx,Ly,Lz);
% % %----------------------------------------------------------------------
% % 
% % %----------------------------------------------------------------------
% % % This is to get the 2D spectra of the different terms withouth filtering
% % %----------------------------------------------------------------------
% % [P2D_term1_filt,~]=Power_of_filtering_kernel(term1_filt,Lx,Ly,Lz);
% % [P2D_term2_filt,~]=Power_of_filtering_kernel(term2_filt,Lx,Ly,Lz);
% % [P2D_term3_filt,~]=Power_of_filtering_kernel(term3_filt,Lx,Ly,Lz);
% % [P2D_term4_filt,~]=Power_of_filtering_kernel(term4_filt,Lx,Ly,Lz);
% % [P2D_term5_filt,kpar,kper,kz]=Power_of_filtering_kernel(term5_filt,Lx,Ly,Lz);
% % %----------------------------------------------------------------------
% % [KPAR,KPER] = meshgrid(kpar,kper);
% % %----------------------------------------------------------------------
% % 
% % % This is to get the perpendicular reduced spectrum
% % %----------------------------------------------------------------------
% % [P1Dper_term1_dt,P1Dpar_term1_dt]=Compute1DSpectra(P2D_term1_dt,kper,threshold);
% % [P1Dper_term2_dt,P1Dpar_term2_dt]=Compute1DSpectra(P2D_term2_dt,kper,threshold);
% % [P1Dper_term3_dt,P1Dpar_term3_dt]=Compute1DSpectra(P2D_term3_dt,kper,threshold);
% % [P1Dper_term4_dt,P1Dpar_term4_dt]=Compute1DSpectra(P2D_term4_dt,kper,threshold);
% % [P1Dper_term5_dt,P1Dpar_term5_dt]=Compute1DSpectra(P2D_term5_dt,kper,threshold);
% % 
% % [P1Dper_term1_filt,P1Dpar_term1_filt]=Compute1DSpectra(P2D_term1_filt,kper,threshold);
% % [P1Dper_term2_filt,P1Dpar_term2_filt]=Compute1DSpectra(P2D_term2_filt,kper,threshold);
% % [P1Dper_term3_filt,P1Dpar_term3_filt]=Compute1DSpectra(P2D_term3_filt,kper,threshold);
% % [P1Dper_term4_filt,P1Dpar_term4_filt]=Compute1DSpectra(P2D_term4_filt,kper,threshold);
% % [P1Dper_term5_filt,P1Dpar_term5_filt]=Compute1DSpectra(P2D_term5_filt,kper,threshold);
% % %----------------------------------------------------------------------
%}


%%%
% MAKING PLOTS
%-----------------------------------------------------------------------

%----------------------------------------------------------------------
% plot of the component x of the electric field
%----------------------------------------------------------------------
%
fs=20; x0=45;y0=54;xx1=1200;yy1=500;

%if(pressure_on == 1)
legends_x = {'$E$', '$-u \times B$','$\frac{J \times B}{ne}$',...
    '$-\frac{\nabla \cdot P_{e}}{ne}$','$\frac{m_{e}\nabla \cdot (uJ + Ju - JJ/ne)}{ne^{2}}$',...
    '$RHS$'};
% else
%     legends_x = {'$E$', '$u \times B$','$\frac{J \times B}{ne}$',...
%         '$\frac{m_{e}\nabla \cdot (uJ + Ju - JJ/ne)}{ne^{2}}$',...
%         '$RHS$'};
% end

i=50; j=50;

f1=figure(1)
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(1,2,1)
dum = term1_dt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-r',LineWidth=1.5)
hold on
dum = -term2_dt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-b',LineWidth=1.5)
dum = term3_dt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-g',LineWidth=1.5)
dum = -term4_dt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-m',LineWidth=1.5)
dum = term5_dt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-c',LineWidth=1.5)
dum = -term2_dt + term3_dt -term4_dt + term5_dt;
%dum = term2to5_dt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'--k',LineWidth=1.5)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_e$';
ax.YLabel.String = '$E$';
legend(legends_x ,'Interpreter','latex','NumColumns',1,'Location','southwest')
title('Unfilterd','Interpreter','latex')
xlim([min(xl),max(xl)])
hold off

subplot(1,2,2)
dum = term1_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-r',LineWidth=1.5)
hold on
dum = -term2_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-b',LineWidth=1.5)
dum = term3_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-g',LineWidth=1.5)
dum = -term4_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-m',LineWidth=1.5)
dum = term5_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-c',LineWidth=1.5)
dum = -term2_filt + term3_filt -term4_filt + term5_filt;
%dum = term2to5_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'--k',LineWidth=1.5)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_e$';
ax.YLabel.String = '$E$';
legend(legends_x ,'Interpreter','latex','NumColumns',1,'Location','southwest')
title('Filterd','Interpreter','latex')
xlim([min(xl),max(xl)])
hold off
%}
%----------------------------------------------------------------------

% This is the BWR
path_color = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';

cd(path_color)
% This is the plot of the tensors
%----------------------------------------------------------------------
%
i=50;j=50;
fs=20; x0=45;y0=54;xx1=1200;yy1=500;
%----------------------------------------------------------------------
f12=figure(12);
set(gcf,'position',[x0,y0,1.0*xx1,1.0*yy1])
ax1=subplot(2,4,1);
dum = -tau_nE_tau/(10^(0));
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$y/d_i$';
ylim([-y_lim, y_lim]);
%xlim([-15.2 15.2]);
title('$-\tau_{nE} $','Interpreter','latex')
hold off

ax2=subplot(2,4,2);
dum = -tau_v_x_B_tau/(10^(0));
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$y/d_i$';
ylim([-y_lim, y_lim]);
title('$-\tau_{nu \times B} $','Interpreter','latex')
%xlim([-15.2 15.2]);
hold off

ax3=subplot(2,4,3);
dum = tau_J_x_B_tau/(10^(0));
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$y/d_i$';
ylim([-y_lim, y_lim]);
title('$\tau_{J \times B} $','Interpreter','latex')
%xlim([-15.2 15.2]);
hold off

ax4=subplot(2,4,4);
dum = tau_Div_tau1/(10^(-2));
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$y/d_i$';
ylim([-y_lim, y_lim]);
title('$ \tau_{\nabla \cdot (uJ+Ju-JJ/ne)} \times 10^2$','Interpreter','latex')
%xlim([-15.2 15.2]);
hold off
%----------------------------------------------------------------------

ax5=subplot(2,4,5);
dum = -tau_nE_tau/(10^(0));
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
xline(xl(1,j),'--k','LineWidth',1.5)
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(ax5,BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
%title('$\tau(nE)/n$','Interpreter','latex')
%xlim([-15.2 15.2]);
%ylim([-15.2 15.2]);
pbaspect([1 1 1])
hold off

ax6 = subplot(2,4,6);
dum = -tau_v_x_B_tau/(10^(0));
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
xline(xl(1,j),'--k','LineWidth',1.5)
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(ax6,BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
%title('$\tau(vxB)/n$','Interpreter','latex')
%xlim([-15.2 15.2]);
%ylim([-15.2 15.2]);
pbaspect([1 1 1])
hold off

ax7 = subplot(2,4,7);
dum = tau_J_x_B_tau/(10^(0));
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
xline(xl(1,j),'--k','LineWidth',1.5)
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(ax7,BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
%title('$\tau(JxB)/n$','Interpreter','latex')
%xlim([-15.2 15.2]);
%ylim([-15.2 15.2]);
pbaspect([1 1 1])
hold off

ax8 = subplot(2,4,8);
dum = tau_Div_tau1/(10^(-2));
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
xline(xl(1,j),'--k','LineWidth',1.5)
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(ax8,BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
%title('$m_{e} \nabla cdot \tau(vJ+Jv-JJ/nq))/n$','Interpreter','latex')
%xlim([-15.2 15.2]);
%ylim([-15.2 15.2]);
pbaspect([1 1 1])
hold off
%}
% %------------------------------------------------------------------------

i=50;j=50;
fs=20; x0=45;y0=54;xx1=1400;yy1=500;

%W H K filt and some taus in 1D
%----------------------------------------------------------------------
%{
f102=figure(102);
%set(gcf,'position',[x0,y0,xx1,yy1])
%subplot(1,2,1)
dum = W_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-r',LineWidth=1.5)
hold on
dum = H_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-b',LineWidth=1.5)
dum = K_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-k',LineWidth=1.5)
dum = KR_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-c',LineWidth=1.5)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_e$';
%ax.YLabel.String = '$E$';
legend('$W$','$H$', ...
    '$K$',...
    '$KR$',...
    'Interpreter','latex','NumColumns',1,'Location','southwest')
%title('Unfilterd','Interpreter','latex')
xlim([min(xl),max(xl)])
hold off

% taus 1D;
f101=figure(101)
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(1,2,2)
dum = -tau_nE_tau;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'--r',LineWidth=1.5)
hold on
dum = -tau_v_x_B_tau;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'--b',LineWidth=1.5)
dum = tau_J_x_B_tau;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'--g',LineWidth=1.5)
dum = tau_Div_tau1;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'--c',LineWidth=1.5)
set(gca,'FontSize',fs)

dum = -tau_nE_tau -tau_v_x_B_tau + tau_J_x_B_tau + tau_Div_tau1;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'--k',LineWidth=1.5)
set(gca,'FontSize',fs)

ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_e$';
%ax.YLabel.String = '$E$';
legend('$-\tau_{nE}$','$-\tau_{nu \times B}$', ...
    '$\tau_{J \times B}$',...
    '$\tau_{\nabla \cdot (uJ+Ju-JJ/ne)}$',...
    '$\Sigma \tau$',...
    'Interpreter','latex','NumColumns',1,'Location','southwest')
%title('Unfilterd','Interpreter','latex')
xlim([min(xl),max(xl)])
hold off

subplot(1,2,1)
dum = term1_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-r',LineWidth=1.5)
hold on
dum = -term2_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-b',LineWidth=1.5)
dum = term3_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-g',LineWidth=1.5)
dum = -term4_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-m',LineWidth=1.5)
dum = term5_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-c',LineWidth=1.5)

dum = -tau_nE_tau;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'--r',LineWidth=1.5)
dum = -tau_v_x_B_tau;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'--b',LineWidth=1.5)
dum = tau_J_x_B_tau;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'--g',LineWidth=1.5)
dum = tau_Div_tau1;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'--c',LineWidth=1.5)
set(gca,'FontSize',fs)

dum = -tau_nE_tau -tau_v_x_B_tau + tau_J_x_B_tau + tau_Div_tau1;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'--k',LineWidth=1.5)
set(gca,'FontSize',fs)

ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_e$';
ax.YLabel.String = '$\overline{E}_{x}$';
legend( '$\overline{E}$', '$-\overline{u} \times \overline{B}$',...
    '$\frac{\overline{J} \times \overline{B}}{\overline{n}e}$',...
    '$-\frac{\nabla \cdot \overline{P}_{e}}{\overline{n}e}$', ...
    '$\frac{m_{e}\nabla \cdot (\overline{u}\overline{J} + \overline{J}\overline{u} - \overline{J}\overline{J}/ne)}{\overline{n}e^{2}}$',...
    '$-\tau_{nE}$','$-\tau_{nu \times B}$', ...
    '$\tau_{J \times B}$',...
    '$\tau_{\nabla \cdot(uJ+Ju-JJ/ne)}$',...
    '$\Sigma \tau$',...
    'Interpreter','latex','NumColumns',2,'Location','southwest')
xlim([min(xl),max(xl)])
hold off
%}
%----------------------------------------------------------------------



% These are the Plots showing the filter and unfilterd terms in the ohms
% law
%----------------------------------------------------------------------
%{
%----------------------------------------------------------------------
% This is for the unfiltered case
fs=20; x0=45;y0=54;xx1=1400;yy1=500;
%----------------------------------------------------------------------
i=50;j=50;
%----------------------------------------------------------------------
f10=figure(10);
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(2,5,1)
%dum = LHD_x_dt;
dum = term1_dt;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$y/d_i$';
ylim([-y_lim, y_lim]);
%title('LHS')
title('$E$','Interpreter','latex')
hold off

subplot(2,5,2)
dum = -term2_dt;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$y/d_i$';
ylim([-y_lim, y_lim]);
%title('RHS')
title('$-u \times B$','Interpreter','latex')
hold off

subplot(2,5,3)
dum = term3_dt;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$y/d_i$';
ylim([-y_lim, y_lim]);
title('$J \times B/nq$','Interpreter','latex')
hold off

subplot(2,5,4)
dum = -term4_dt;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$y/d_i$';
%if(pressure_on==1)
    ylim([-y_lim, y_lim]);
%end
title('$-\nabla \cdot P_{e}/ne$','Interpreter','latex')
hold off

subplot(2,5,5)
dum = term5_dt;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$y/d_i$';
ylim([-y_lim, y_lim]);
title('$\nabla \cdot (uJ+Ju-JJ/ne)m_{e}/ne^{2}$','Interpreter','latex')
hold off
%----------------------------------------------------------------------


%%%

%i=30;
%----------------------------------------------------------------------
%f10=figure(10);
subplot(2,5,6)
%dum = LHD_dt;
dum = term1_dt;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
%title('LHS')
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
xline(xl(1,j),'--k','LineWidth',1.5)
%title('$E_{x}$','Interpreter','latex')
pbaspect([1 1 1])
hold off

subplot(2,5,7)
%dum = RHD_x_dt;
dum = -term2_dt;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
%title('RHS')
%title('$-u \times B$','Interpreter','latex')
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
xline(xl(1,j),'--k','LineWidth',1.5)
pbaspect([1 1 1])
hold off

subplot(2,5,8)
dum = term3_dt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
xline(xl(1,j),'--k','LineWidth',1.5)
%title('$J \times B/nq$','Interpreter','latex')
pbaspect([1 1 1])
hold off

subplot(2,5,9)
dum = -term4_dt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
%if(pressure_on==1)
    clim([-y_lim y_lim]);
%end
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
xline(xl(1,j),'--k','LineWidth',1.5)
%title('$-\nabla \cdot P_{e}/nq$','Interpreter','latex')
pbaspect([1 1 1])
hold off

subplot(2,5,10)
dum = term5_dt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
xline(xl(1,j),'--k','LineWidth',1.5)
%title('$\nabla \cdot (uJ+Ju-JJ/qn)(m_{e}/q^{2}n)$','Interpreter','latex')
pbaspect([1 1 1])
hold off
sgtitle('$$ Unfiltered $$','Interpreter','latex','FontSize',fs)
%----------------------------------------------------------------------

%%%

%----------------------------------------------------------------------
%i=30;j=30;
%----------------------------------------------------------------------
f11=figure(11);
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(2,5,1)
%dum = LHD_filt_x;
dum = term1_filt;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.YAxis.Exponent = 0;
ylim([-y_lim, y_lim]);
%title('LHS')
title('$E$',Interpreter='latex')
hold off

subplot(2,5,2)
%dum = RHD_filt_x;
dum = -term2_filt;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.YAxis.Exponent = 0;
ylim([-y_lim, y_lim]);
%title('RHS')
title('$-u \times B$',Interpreter='latex')
hold off

subplot(2,5,3)
dum = term3_filt;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.YAxis.Exponent = 0;
ylim([-y_lim, y_lim]);
title('$J \times B/ne$',Interpreter='latex')
hold off

subplot(2,5,4)
dum = -term4_filt;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.YAxis.Exponent = 0;
%if(pressure_on==1)
    ylim([-y_lim, y_lim]);
%end
title('$-\nabla \cdot P_{e}/ne $',Interpreter='latex')
hold off

subplot(2,5,5)
dum = term5_filt;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.YAxis.Exponent = 0;
ylim([-y_lim, y_lim]);
title('$\nabla \cdot (uJ+Ju-JJ/ne)m_{e}/ne^{2}$',Interpreter='latex')
hold off
%--------------------------------------------------------------------------
%f11=figure(11);
subplot(2,5,6)
%dum = LHD_filt_x;
dum = term1_filt;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
%title('LHS')
%title('$E$',Interpreter='latex')
xlabel('$x/d_{i}$')
ylabel('$y/d_{i}$')
pbaspect([1 1 1])
xline(xl(1,j),'--k','LineWidth',1.5)
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
hold off

subplot(2,5,7)
%dum = RHD_filt_x;
dum = -term2_filt;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
%title('RHS')
%title('$-u \times B$',Interpreter='latex')
xline(xl(1,j),'--k','LineWidth',1.5)
xlabel('$x/d_{i}$')
ylabel('$y/d_{i}$')
pbaspect([1 1 1])
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
hold off

subplot(2,5,8)
dum = term3_filt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
xline(xl(1,j),'--k','LineWidth',1.5)
%title('$J \times B/ ne$',Interpreter='latex')
xlabel('$x/d_{i}$')
ylabel('$y/d_{i}$')
pbaspect([1 1 1])
hold off

subplot(2,5,9)
dum = -term4_filt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
set(hc,'edgecolor','none')
%if(pressure_on == 1)
    clim([-y_lim y_lim]);
%end
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
xline(xl(1,j),'--k','LineWidth',1.5)
%title('$- \nabla \cdot P_{e}/ne $',Interpreter='latex')
xlabel('$x/d_{i}$')
ylabel('$y/d_{i}$')
pbaspect([1 1 1])
hold off

subplot(2,5,10)
dum = term5_filt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
xline(xl(1,j),'--k','LineWidth',1.5)
%title('$\nabla \cdot (uJ+Ju-JJ/en)m_{e}/ne^{2}$',Interpreter='latex')
xlabel('$x/d_{i}$')
ylabel('$y/d_{i}$')
pbaspect([1 1 1])
hold off
sgtitle('$$ Filtered $$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------
%}
%----------------------------------------------------------------------

%%

% W H K filt 1D
%-----------------------------------------------------------------------
%{
%-----------------------------------------------------------------------
%
i=50;j=50;
fs=20; x0=45;y0=54;xx1=1200;yy1=500;
%----------------------------------------------------------------------
f123=figure(123);
set(gcf,'position',[x0,y0,1.0*xx1,1.0*yy1])
ax1=subplot(2,4,1);
dum = W_filt;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$y/d_i$';
ylim([-y_lim, y_lim]);
%xlim([-15.2 15.2]);
title('$W $','Interpreter','latex')
hold off

ax2=subplot(2,4,2);
dum = H_filt;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$y/d_i$';
ylim([-y_lim, y_lim]);
title('$H $','Interpreter','latex')
%xlim([-15.2 15.2]);
hold off

ax3=subplot(2,4,3);
dum = K_filt;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$y/d_i$';
ylim([-y_lim, y_lim]);
title('$K $','Interpreter','latex')
%xlim([-15.2 15.2]);
hold off

ax4=subplot(2,4,4);
dum = KR_filt;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$y/d_i$';
ylim([-y_lim, y_lim]);
title('$KR$','Interpreter','latex')
%xlim([-15.2 15.2]);
hold off
%----------------------------------------------------------------------

ax5=subplot(2,4,5);
dum = W_filt;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
xline(xl(1,j),'--k','LineWidth',1.5)
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(ax5,BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
%title('$\tau(nE)/n$','Interpreter','latex')
%xlim([-15.2 15.2]);
%ylim([-15.2 15.2]);
pbaspect([1 1 1])
hold off

ax6 = subplot(2,4,6);
dum = H_filt;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
xline(xl(1,j),'--k','LineWidth',1.5)
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(ax6,BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
%title('$\tau(vxB)/n$','Interpreter','latex')
%xlim([-15.2 15.2]);
%ylim([-15.2 15.2]);
pbaspect([1 1 1])
hold off

ax7 = subplot(2,4,7);
dum = K_filt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
xline(xl(1,j),'--k','LineWidth',1.5)
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(ax7,BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
%title('$\tau(JxB)/n$','Interpreter','latex')
%xlim([-15.2 15.2]);
%ylim([-15.2 15.2]);
pbaspect([1 1 1])
hold off

ax8 = subplot(2,4,8);
dum = KR_filt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
xline(xl(1,j),'--k','LineWidth',1.5)
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(ax8,BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
%title('$m_{e} \nabla cdot \tau(vJ+Jv-JJ/nq))/n$','Interpreter','latex')
%xlim([-15.2 15.2]);
%ylim([-15.2 15.2]);
pbaspect([1 1 1])
hold off
%-----------------------------------------------------------------------
%}
%-----------------------------------------------------------------------



%%
%--------------------------------------------------------------------------
% These are the plots for the dependence of the taus with the different
% terms
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% This is to put the histograms on the side
%-----------------------------------------------------------------------
%figure
%plot(var2_x,var_tau1_x,'.')
%s = scatterhistogram(J_scatter_x,var_tau1_x,'NumBins',nbins,'MarkerStyle','.');
%s.YLabel = '\tau_{nu \times B}';
%s.MarkerSize = 0.5;
%s.HistogramDisplayStyle = 'bar';
%-----------------------------------------------------------------------

%meany = accumarray(loc(:),yy(:))./accumarray(loc(:),1);
%-----------------------------------------------------------------------

nbins = 80;
legend('data','linear','mean','median')
fs=20; x0=45;y0=54;xx1=1000;yy1=900;

% This is to play

% This is testing the three different fits 
%-----------------------------------------------------------------------
%
f153=figure(153);
set(gcf,'position',[x0,y0,xx1,yy1])
%-----------------------------------------------------------------------
subplot(3,3,1)
xx=J_scatter_x;
yy=var_tau1_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
%plot(xmid,meany,'c','LineWidth',2);
%plot(xmid,mediany,'m','LineWidth',2);
%plot(xx,yfit_meany,'c--','LineWidth',2);
%plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nu \times B}$','Interpreter','latex')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
%xlabel('$KJ$')
hold off
%-----------------------------------------------------------------------
subplot(3,3,2)
xx=B_scatter_x;
yy=var_tau1_x - yfit;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit2 = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany2 = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany2 = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit2,'k','LineWidth',2);
%plot(xx,yfit_meany2,'c--','LineWidth',2);
%plot(xx,yfit_mediany2,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nu \times B} - f_{J}$','Interpreter','latex')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
%xlabel('$HB$')
hold off
%-----------------------------------------------------------------------
subplot(3,3,3)
xx=vort_scatter_x;
yy=var_tau1_x - yfit -  yfit2;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit3 = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany3 = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany3 = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit3,'k','LineWidth',2);
%plot(xx,yfit_meany3,'c--','LineWidth',2);
%plot(xx,yfit_mediany3,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nu \times B} - f_{J} - f_{B}$','Interpreter','latex')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
%xlabel('$W \Omega$')
hold off
%--------------------------------------------------------------------------
%-----------------------------------------------------------------------
subplot(3,3,4)
xx=J_scatter_x;
yy=var_tau1_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
%plot(xx,yfit,'k','LineWidth',2);
plot(xmid,meany,'xr','LineWidth',2);
plot(xx,yfit_meany,'k--','LineWidth',2);
%plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nu \times B}$','Interpreter','latex')
bb = sprintf('avg,b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
%xlabel('$KJ$')
hold off
%-----------------------------------------------------------------------
subplot(3,3,5)
xx=B_scatter_x;
yy=var_tau1_x - yfit_meany;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit2 = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany2 = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany2 = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
%plot(xx,yfit2,'k','LineWidth',2);
plot(xmid,meany,'xr','LineWidth',2);
plot(xx,yfit_meany2,'k--','LineWidth',2);
%plot(xx,yfit_mediany2,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nu \times B} - f_{J}$','Interpreter','latex')
bb = sprintf('avg,b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
%xlabel('$HB$')
hold off
%-----------------------------------------------------------------------
subplot(3,3,6)
xx=vort_scatter_x;
yy=var_tau1_x - yfit_meany -  yfit_meany2;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit3 = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany3 = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany3 = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
%plot(xx,yfit3,'k','LineWidth',2);
plot(xx,yfit_meany3,'k--','LineWidth',2);
plot(xmid,meany,'xr','LineWidth',2);
%plot(xx,yfit_mediany3,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nu \times B} - f_{J} - f_{B}$','Interpreter','latex')
bb = sprintf('avg,b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
%xlabel('$W \Omega$')
hold off
%--------------------------------------------------------------------------
%-----------------------------------------------------------------------
subplot(3,3,7)
xx=J_scatter_x;
yy=var_tau1_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
%plot(xx,yfit,'k','LineWidth',2);
%plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'k--','LineWidth',2);
plot(xmid,mediany,'xr','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nu \times B}$','Interpreter','latex')
bb = sprintf('mdn,b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
xlabel('$J$')
hold off
%-----------------------------------------------------------------------
subplot(3,3,8)
xx=B_scatter_x;
yy=var_tau1_x - yfit_mediany;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit2 = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany2 = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany2 = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
%plot(xx,yfit2,'k','LineWidth',2);
%plot(xx,yfit_meany2,'c--','LineWidth',2);
plot(xx,yfit_mediany2,'k--','LineWidth',2);
plot(xmid,mediany,'xr','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nu \times B} - f_{J}$','Interpreter','latex')
bb = sprintf('mdn,b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
xlabel('$B$')
hold off
%-----------------------------------------------------------------------
subplot(3,3,9)
xx=vort_scatter_x;
yy=var_tau1_x - yfit_mediany -  yfit_mediany2;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit3 = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany3 = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany3 = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
%plot(xx,yfit3,'k','LineWidth',2);
%plot(xx,yfit_meany3,'c--','LineWidth',2);
plot(xx,yfit_mediany3,'k--','LineWidth',2);
plot(xmid,mediany,'xr','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nu \times B} - f_{J} - f_{B}$','Interpreter','latex')
bb = sprintf('mdn,b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
xlabel('$\Omega$')
hold off
%--------------------------------------------------------------------------






f154=figure(154);
set(gcf,'position',[x0,y0,xx1,yy1])
%-----------------------------------------------------------------------
subplot(3,3,1)
xx=KJ_scatter_x;
yy=var_tau1_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
%plot(xmid,meany,'c','LineWidth',2);
%plot(xmid,mediany,'m','LineWidth',2);
%plot(xx,yfit_meany,'c--','LineWidth',2);
%plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nu \times B}$','Interpreter','latex')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
%xlabel('$KJ$')
hold off
%-----------------------------------------------------------------------
subplot(3,3,2)
xx=HB_scatter_x;
yy=var_tau1_x - yfit;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit2 = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany2 = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany2 = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit2,'k','LineWidth',2);
%plot(xx,yfit_meany2,'c--','LineWidth',2);
%plot(xx,yfit_mediany2,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nu \times B} - f_{KJ}$','Interpreter','latex')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
%xlabel('$HB$')
hold off
%-----------------------------------------------------------------------
subplot(3,3,3)
xx=Wvort_scatter_x;
yy=var_tau1_x - yfit -  yfit2;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit3 = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany3 = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany3 = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit3,'k','LineWidth',2);
%plot(xx,yfit_meany3,'c--','LineWidth',2);
%plot(xx,yfit_mediany3,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nu \times B} - f_{KJ} - f_{HB}$','Interpreter','latex')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
%xlabel('$W \Omega$')
hold off
%--------------------------------------------------------------------------
%-----------------------------------------------------------------------
subplot(3,3,4)
xx=KJ_scatter_x;
yy=var_tau1_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
%plot(xx,yfit,'k','LineWidth',2);
plot(xmid,meany,'xr','LineWidth',2);
plot(xx,yfit_meany,'k--','LineWidth',2);
%plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nu \times B}$','Interpreter','latex')
bb = sprintf('avg,b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
%xlabel('$KJ$')
hold off
%-----------------------------------------------------------------------
subplot(3,3,5)
xx=HB_scatter_x;
yy=var_tau1_x - yfit_meany;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit2 = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany2 = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany2 = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
%plot(xx,yfit2,'k','LineWidth',2);
plot(xmid,meany,'xr','LineWidth',2);
plot(xx,yfit_meany2,'k--','LineWidth',2);
%plot(xx,yfit_mediany2,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nu \times B} - f_{KJ}$','Interpreter','latex')
bb = sprintf('avg,b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
%xlabel('$HB$')
hold off
%-----------------------------------------------------------------------
subplot(3,3,6)
xx=Wvort_scatter_x;
yy=var_tau1_x - yfit_meany -  yfit_meany2;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit3 = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany3 = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany3 = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
%plot(xx,yfit3,'k','LineWidth',2);
plot(xx,yfit_meany3,'k--','LineWidth',2);
plot(xmid,meany,'xr','LineWidth',2);
%plot(xx,yfit_mediany3,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nu \times B} - f_{KJ} - f_{HB}$','Interpreter','latex')
bb = sprintf('avg,b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
%xlabel('$W \Omega$')
hold off
%--------------------------------------------------------------------------
%-----------------------------------------------------------------------
subplot(3,3,7)
xx=KJ_scatter_x;
yy=var_tau1_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
%plot(xx,yfit,'k','LineWidth',2);
%plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'k--','LineWidth',2);
plot(xmid,mediany,'xr','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nu \times B}$','Interpreter','latex')
bb = sprintf('mdn,b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
xlabel('$KJ$')
hold off
%-----------------------------------------------------------------------
subplot(3,3,8)
xx=HB_scatter_x;
yy=var_tau1_x - yfit_mediany;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit2 = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany2 = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany2 = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
%plot(xx,yfit2,'k','LineWidth',2);
%plot(xx,yfit_meany2,'c--','LineWidth',2);
plot(xx,yfit_mediany2,'k--','LineWidth',2);
plot(xmid,mediany,'xr','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nu \times B} - f_{KJ}$','Interpreter','latex')
bb = sprintf('mdn,b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
xlabel('$HB$')
hold off
%-----------------------------------------------------------------------
subplot(3,3,9)
xx=Wvort_scatter_x;
yy=var_tau1_x - yfit_mediany -  yfit_mediany2;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit3 = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany3 = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany3 = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
%plot(xx,yfit3,'k','LineWidth',2);
%plot(xx,yfit_meany3,'c--','LineWidth',2);
plot(xx,yfit_mediany3,'k--','LineWidth',2);
plot(xmid,mediany,'xr','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nu \times B} - f_{KJ} - f_{HB}$','Interpreter','latex')
bb = sprintf('mdn,b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
xlabel('$W \Omega$')
hold off
%--------------------------------------------------------------------------

%}
%--------------------------------------------------------------------------


% This here is to test the multivariable regression 
%--------------------------------------------------------------------------
% Given data arrays
x1 = KJ_scatter_x; % Replace with your x1 data
x2 = HB_scatter_x; % Replace with your x2 data
x3 = Wvort_scatter_x; % Replace with your x3 data
Y = var_tau1_x;  % Replace with your Y data

% Ensure the input arrays are column vectors
x1 = x1(:);
x2 = x2(:);
x3 = x3(:);
Y = Y(:);

% Create the design matrix
X = [ones(size(x1)), x1, x2, x3];

% Compute the coefficients using the normal equation
% beta = (X'X)^(-1) X'Y
beta = (X' * X) \ (X' * Y);

% Display the coefficients
fprintf('Coefficients:\n');
fprintf('Beta_0 (Intercept): %.4f\n', beta(1));
fprintf('Beta_1 (x1): %.4f\n', beta(2));
fprintf('Beta_2 (x2): %.4f\n', beta(3));
fprintf('Beta_3 (x3): %.4f\n', beta(4));

% Compute the predicted values
Y_pred = X * beta;

% Compute the residuals
residuals = Y - Y_pred;

% % Display residuals
% fprintf('Residuals:\n');
% disp(residuals);

% Optional: Plot actual vs predicted
fs=15;
figure;
set(gcf,'position',[x0,y0,xx1,yy1/3])
%scatter(1:length(Y), Y, 'filled', 'r');
%--------------------------------------------------------------------------
subplot(1,3,1)
scatter(x1, Y, '.r');
hold on;
scatter(x2, Y, '.b');
scatter(x3, Y, '.c');
legend('KJ', 'HB', 'W \Omega');
xlabel('x Value');
%title('Actual vs Predicted Values');
bb = sprintf('betas = %.2g %.2g %.2g', beta(2), beta(3), beta(4));
title(bb,'Interpreter','Latex')
ylabel('$\tau_{nu \times B}$','Interpreter','latex')
%ylabel('$KJ, HB, W \Omega$')set(gca,'FontSize',fs)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
hold off;
%--------------------------------------------------------------------------
subplot(1,3,2)
scatter(x1, Y_pred, '.r');
hold on;
scatter(x2, Y_pred, '.b');
scatter(x3, Y_pred, '.c');
legend('KJ', 'HB', 'W \Omega');
xlabel('x Value');
%title('Actual vs Predicted Values');
bb = sprintf('betas = %.2g %.2g %.2g', beta(2), beta(3), beta(4));
title(bb,'Interpreter','Latex')
ylabel('$Fitted \ \tau_{nu \times B}$','Interpreter','latex')
%ylabel('$KJ, HB, W \Omega$')set(gca,'FontSize',fs)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
hold off;
%--------------------------------------------------------------------------
subplot(1,3,3)
scatter(1:length(Y), Y, '.r');
hold on
scatter(1:length(Y_pred), Y_pred, '.b');
legend('Actual','Predicted');
%title('Actual vs Predicted Values');
bb = sprintf('betas = %.2g %.2g %.2g', beta(2), beta(3), beta(4));
title(bb,'Interpreter','Latex')
ylabel('$\tau_{nu \times B}$','Interpreter','latex')
xlabel('Data Point Index');
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%--------------------------------------------------------------------------



% Dependence with taus and J B Om
%--------------------------------------------------------------------------
%{
fs=20; x0=45;y0=54;xx1=1000;yy1=900;
f155=figure(155);
set(gcf,'position',[x0,y0,xx1,yy1])
%--------------------------------------------------------------------------
subplot(4,3,1)
%--------------------------------------------------------------------------
xx=J_scatter_x;
yy=var_tau1_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
%plot(xmid,meany,'c','LineWidth',2);
%plot(xmid,mediany,'m','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nu \times B}$')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,2)
%--------------------------------------------------------------------------
xx=B_scatter_x;
yy=var_tau1_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,3)
%--------------------------------------------------------------------------
%plot(Wvort_scatter_x,var_tau1_x,'.')
xx=vort_scatter_x;
yy=var_tau1_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
bb = sprintf('b = %.2g ', P(1)); 
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,4)
%--------------------------------------------------------------------------
xx=J_scatter_x;
yy=var_tau2_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nE}$')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,5)
%--------------------------------------------------------------------------
xx=B_scatter_x;
yy=var_tau2_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,6)
%--------------------------------------------------------------------------
%plot(Wvort_scatter_x,var_tau2_x,'.')
xx=vort_scatter_x;
yy=var_tau2_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,7)
%--------------------------------------------------------------------------
xx=J_scatter_x;
yy=var_tau3_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{J \times B}$')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,8)
%--------------------------------------------------------------------------
%plot(HB_scatter_x,var_tau3_x,'.')
xx=B_scatter_x;
yy=var_tau3_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,9)
%--------------------------------------------------------------------------
%plot(Wvort_scatter_x,var_tau3_x,'.')
xx=vort_scatter_x;
yy=var_tau3_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,10)
%--------------------------------------------------------------------------
%plot(KJ_scatter_x,var_tau4_x,'.')
xx=J_scatter_x;
yy=var_tau4_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{\nabla \cdot(uJ+Ju - JJ/n)}$')
xlabel('$J$')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,11)
%--------------------------------------------------------------------------
%plot(HB_scatter_x,var_tau4_x,'.')
xx=B_scatter_x;
yy=var_tau4_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
xlabel('$B$')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,12)
%--------------------------------------------------------------------------
%plot(Wvort_scatter_x,var_tau4_x,'.')
xx=vort_scatter_x;
yy=var_tau4_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
xlabel('$\Omega$')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%-----------------------------------------------------------------------
%}
%-----------------------------------------------------------------------
%cd(f_path)
%saveas(f155,strcat(num2str(component),'taus_dependence.png'));
%-----------------------------------------------------------------------


% This is for KJ, HB, WOMe
%--------------------------------------------------------------------------
f166=figure(166);
%--------------------------------------------------------------------------
set(gcf,'position',[x0,y0,xx1,yy1])
%--------------------------------------------------------------------------
subplot(4,3,1)
%--------------------------------------------------------------------------
xx=KJ_scatter_x;
yy=var_tau1_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nu \times B}$')

% This is for the cut
%aa_exp = floor(log10(P(2)));
%aa1 = round(P(2)*(10^abs(aa_exp)),int32(10^abs(aa_exp)));
%aa = sprintf('a = %.2g x10^%g', aa1,aa_exp); 
% This is for the slope
%signo = sign(P(1)); % This is the sign of the slope
%bb_exp = real(floor(log10(abs(P(1)))));
%bb1 = round(P(1)*(10^abs(bb_exp)),int32(10^abs(bb_exp)));
%bb = sprintf('b = %.2ge%g', bb1,bb_exp); 

bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,2)
%--------------------------------------------------------------------------
xx=HB_scatter_x;
yy=var_tau1_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,3)
%--------------------------------------------------------------------------
%plot(Wvort_scatter_x,var_tau1_x,'.')
xx=Wvort_scatter_x;
yy=var_tau1_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
bb = sprintf('b = %.2g ', P(1)); 
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,4)
%--------------------------------------------------------------------------
xx=KJ_scatter_x;
yy=var_tau2_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nE}$')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,5)
%--------------------------------------------------------------------------
xx=HB_scatter_x;
yy=var_tau2_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,6)
%--------------------------------------------------------------------------
%plot(Wvort_scatter_x,var_tau2_x,'.')
xx=Wvort_scatter_x;
yy=var_tau2_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,7)
%--------------------------------------------------------------------------
xx=KJ_scatter_x;
yy=var_tau3_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{J \times B}$')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,8)
%--------------------------------------------------------------------------
%plot(HB_scatter_x,var_tau3_x,'.')
xx=HB_scatter_x;
yy=var_tau3_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,9)
%--------------------------------------------------------------------------
%plot(Wvort_scatter_x,var_tau3_x,'.')
xx=Wvort_scatter_x;
yy=var_tau3_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,10)
%--------------------------------------------------------------------------
%plot(KJ_scatter_x,var_tau4_x,'.')
xx=KJ_scatter_x;
yy=var_tau4_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{\nabla \cdot(uJ+Ju - JJ/n)}$')
xlabel('$K J$')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,11)
%--------------------------------------------------------------------------
%plot(HB_scatter_x,var_tau4_x,'.')
xx=HB_scatter_x;
yy=var_tau4_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
xlabel('$H B$')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,12)
%--------------------------------------------------------------------------
%plot(Wvort_scatter_x,var_tau4_x,'.')
xx=Wvort_scatter_x;
yy=var_tau4_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
xlabel('$W \Omega$')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%-----------------------------------------------------------------------




% This is for KKJ, KHB, KWOMe
%--------------------------------------------------------------------------
f177=figure(177)
set(gcf,'position',[x0,y0,xx1,yy1])
%--------------------------------------------------------------------------
subplot(4,3,1)
%--------------------------------------------------------------------------
xx=KKJ_scatter_x;
yy=var_tau1_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nu \times B}$')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,2)
%--------------------------------------------------------------------------
xx=KHB_scatter_x;
yy=var_tau1_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,3)
%--------------------------------------------------------------------------
%plot(Wvort_scatter_x,var_tau1_x,'.')
xx=KWvort_scatter_x;
yy=var_tau1_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
bb = sprintf('b = %.2g ', P(1)); 
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,4)
%--------------------------------------------------------------------------
xx=KKJ_scatter_x;
yy=var_tau2_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nE}$')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,5)
%--------------------------------------------------------------------------
xx=KHB_scatter_x;
yy=var_tau2_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,6)
%--------------------------------------------------------------------------
xx=KWvort_scatter_x;
yy=var_tau2_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,7)
%--------------------------------------------------------------------------
xx=KKJ_scatter_x;
yy=var_tau3_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{J \times B}$')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,8)
%--------------------------------------------------------------------------
%plot(HB_scatter_x,var_tau3_x,'.')
xx=KHB_scatter_x;
yy=var_tau3_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,9)
%--------------------------------------------------------------------------
xx=KWvort_scatter_x;
yy=var_tau3_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,10)
%--------------------------------------------------------------------------
xx=KKJ_scatter_x;
yy=var_tau4_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{\nabla \cdot(uJ+Ju - JJ/n)}$')
xlabel('$KK J$')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,11)
%--------------------------------------------------------------------------
xx=KHB_scatter_x;
yy=var_tau4_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
xlabel('$KHB$')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%--------------------------------------------------------------------------
subplot(4,3,12)
%--------------------------------------------------------------------------
xx=KWvort_scatter_x;
yy=var_tau4_x;
[~,edges,loc] = histcounts(xx,nbins);
meany = accumarray(loc(:),yy(:),[],@mean);
mediany = accumarray(loc(:),yy(:),[],@median);
xmid = 0.5*(edges(1:end-1)+edges(2:end));
P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
scatter(xx,yy,'.')
hold on;
plot(xx,yfit,'k','LineWidth',2);
plot(xx,yfit_meany,'c--','LineWidth',2);
plot(xx,yfit_mediany,'m--','LineWidth',2);
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
xlabel('$KW \Omega$')
bb = sprintf('b = %.2g ', P(1));
title(bb,'Interpreter','Latex')
hold off
clearvars xx yy
%-----------------------------------------------------------------------

%}

%clearvars var*
%clearvars LHD* RHD*


%%
% This are the plots for the spectra
%{
fs=20; x0=45;y0=54;xx1=1200;yy1=500;
%--------------------------------------------------------------------------
f21=figure(21);
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(1,3,1)
%----------------------------------------------------------------------
loglog(k_bins(1:end-1), E_k_term1_dt(1:end-1),'r-','LineWidth',2)
hold on
loglog(k_bins(1:end-1), E_k_term2_dt(1:end-1),'b-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_term3_dt(1:end-1),'g-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_term4_dt(1:end-1),'m-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_term5_dt(1:end-1),'c-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_term2to5_dt(1:end-1),'k--','LineWidth',2)
set(gca,'FontSize',fs)
%set(gca,'XScale','lin','YScale','log','FontSize',fs)
y1=get(gca,'ylim');
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$k d_i$';
ax.YLabel.String = '$P_{1D} \ unfiltered$';
legend(legends_x ,'Interpreter','latex','NumColumns',1,'Location','southwest')
xlim([k_bins(2) threshold]);
ylim([10^(-8) 10^(15)]);
%----------------------------------------------------------------------
hold off
%----------------------------------------------------------------------
subplot(1,3,2)
%----------------------------------------------------------------------
loglog(k_bins(1:end-1), E_k_term1_filt(1:end-1),'r-','LineWidth',2)
hold on
loglog(k_bins(1:end-1), E_k_term2_filt(1:end-1),'b-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_term3_filt(1:end-1),'g-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_term4_filt(1:end-1),'m-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_term5_filt(1:end-1),'c-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_term2to5_filt(1:end-1),'k--','LineWidth',2)
set(gca,'FontSize',fs)
%set(gca,'XScale','lin','YScale','log','FontSize',fs)
y1=get(gca,'ylim');
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$k d_i$';
ax.YLabel.String = '$P_{1D} \ filtered$';
legend(legends_x ,'Interpreter','latex','NumColumns',1,'Location','southwest')
xlim([k_bins(2) threshold]);
ylim([10^(-8) 10^(15)]);
%----------------------------------------------------------------------
hold off
%----------------------------------------------------------------------
subplot(1,3,3)
%----------------------------------------------------------------------
loglog(k_bins(1:end-1), E_k_tau_nE_tau(1:end-1),'r-','LineWidth',2)
hold on
loglog(k_bins(1:end-1), E_k_tau_v_x_B_tau(1:end-1),'b-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_tau_J_x_B_tau(1:end-1),'g-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_tau_Div_tau1(1:end-1),'c-','LineWidth',2)
set(gca,'FontSize',fs)
%set(gca,'XScale','lin','YScale','log','FontSize',fs)
y1=get(gca,'ylim');
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$k d_i$';
ax.YLabel.String = '$P_{1D}$';
legend('$\tau_{nE}$',...
    '$\tau_{vxb}$',...
    '$\tau_{Jxb}$',...
    '$\tau_{\nabla \cdot(uJ+Ju -JJ/en)}$',...
    'Interpreter','latex','NumColumns',1,'Location','southwest')
xlim([k_bins(2) threshold]);
ylim([10^(-8) 10^(15)]);
%----------------------------------------------------------------------
hold off
%----------------------------------------------------------------------



% This was to check the first three ohms law terms and their normalization.
% They match like this.
%-------------------------------------------------------------------------
%v_mod_dt = sqrt(v_x_dt.^2 + v_y_dt.^2 + v_z_dt.^2);
%mean(v_mod_dt,'all')
%E_mod_dt = sqrt(Ex_dt.^2 + Ey_dt.^2 + Ez_dt.^2);
%mean(E_mod_dt,'all')
%--------------------------------------------------------------------------

% This is to estimate the three term in the Ohm's law. for the plots 111
% and 222
%--------------------------------------------------------------------------
[Pe_dt_y, Pe_dt_x, Pe_dt_z] = gradient(Pe_dt);
[Pe_filt_y, Pe_filt_x, Pe_filt_z] = gradient(Pe_filt);

v_x_B_x_dt = v_y_dt.*Bz_dt - v_z_dt.*By_dt;
J_x_B_x_dt = Jy_dt.*Bz_dt - Jz_dt.*By_dt;

v_x_B_y_dt = v_z_dt.*Bx_dt - v_x_dt.*Bz_dt;
J_x_B_y_dt = Jz_dt.*Bx_dt - Jx_dt.*Bz_dt;

v_x_B_z_dt = v_x_dt.*By_dt - v_y_dt.*Bx_dt;
J_x_B_z_dt = Jx_dt.*By_dt - Jy_dt.*Bx_dt;

Div_Pe_dt_x = Pe_dt_x/(grad_fact.*resx);
Div_Pe_dt_y = Pe_dt_y/(grad_fact.*resy);
Div_Pe_dt_z = Pe_dt_z/(grad_fact.*resz);

v_x_B_x_filt = v_y_filt.*Bz_filt - v_z_filt.*By_filt;
J_x_B_x_filt = Jy_filt.*Bz_filt - Jz_filt.*By_filt;

v_x_B_y_filt = v_z_dt.*Bx_filt - v_x_filt.*Bz_filt;
J_x_B_y_filt = Jz_dt.*Bx_filt - Jx_filt.*Bz_filt;

v_x_B_z_filt = v_x_filt.*By_filt - v_y_filt.*Bx_filt;
J_x_B_z_filt = Jx_filt.*By_filt - Jy_filt.*Bx_filt;

Div_Pe_filt_x = Pe_filt_x/(grad_fact.*resx);
Div_Pe_filt_y = Pe_filt_y/(grad_fact.*resy);
Div_Pe_filt_z = Pe_filt_z/(grad_fact.*resz);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
fs=20; x0=45;y0=54;xx1=1200;yy1=500; i=50; j=50;
%--------------------------------------------------------------------------
f111=figure(111)
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(1,3,1)
dum = Ex_dt.*v_a.*B0; dump1 = squeeze(dum(:,i,j));
plot(xl,dump1,'-r',LineWidth=1.5)
hold on
dum = -v_x_B_x_dt.*v_a.*B0; dump2 = squeeze(dum(:,i,j));
plot(xl,dump2,'-b',LineWidth=1.5)
dum = J_x_B_x_dt.*v_a.*B0.*n0./n_0_dt; dump3 = squeeze(dum(:,i,j));
plot(xl,dump3,'-g',LineWidth=1.5)
dum = -v_a*v_a*(Div_Pe_dt_x./n_0_dt); dump4 = squeeze(dum(:,i,j));
plot(xl,dump4,'-m',LineWidth=1.5)
dump5 = dump2 + dump3 + dump4;
plot(xl,dump5,'--k',LineWidth=1.5)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$E$';
legend('$E_{x}$','$-u \times B_{x}$','$J \times B_{x}/ne$',...
    '$(-\nabla \cdot P_{e}/ne)_{x}$','$(RHS)_{x}$',...
    'Interpreter','latex','NumColumns',1,'Location','northout')
hold off

subplot(1,3,2)
dum = Ey_dt.*v_a.*B0; dump1 = squeeze(dum(:,i,j));
plot(xl,dump1,'-r',LineWidth=1.5)
hold on
dum = -v_x_B_y_dt.*v_a.*B0; dump2 = squeeze(dum(:,i,j));
plot(xl,dump2,'-b',LineWidth=1.5)
dum = J_x_B_y_dt.*v_a.*B0.*n0./n_0_dt; dump3 = squeeze(dum(:,i,j));
plot(xl,dump3,'-g',LineWidth=1.5)
dum = -v_a*v_a*(Div_Pe_dt_y./n_0_dt); dump4 = squeeze(dum(:,i,j));
plot(xl,dump4,'-m',LineWidth=1.5)
dump5 = dump2 + dump3 + dump4;
plot(xl,dump5,'--k',LineWidth=1.5)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$E$';
legend('$E_{y}$','$-u \times B_{y}$','$J \times B_{y}/ne$',...
    '$(-\nabla \cdot P_{e}/ne)_{y}$','$(RHS)_{y}$',...
    'Interpreter','latex','NumColumns',1,'Location','northout')
hold off

subplot(1,3,3)
dum = Ez_dt.*v_a.*B0; dump1 = squeeze(dum(:,i,j));
plot(xl,dump1,'-r',LineWidth=1.5)
hold on
dum = -v_x_B_z_dt.*v_a.*B0; dump2 = squeeze(dum(:,i,j));
plot(xl,dump2,'-b',LineWidth=1.5)
dum = J_x_B_z_dt.*v_a.*B0.*n0./n_0_dt; dump3 = squeeze(dum(:,i,j));
plot(xl,dump3,'-g',LineWidth=1.5)
dum = -v_a*v_a*(Div_Pe_dt_z./n_0_dt); dump4 = squeeze(dum(:,i,j));
plot(xl,dump4,'-m',LineWidth=1.5)
dump5 = dump2 + dump3 + dump4;
plot(xl,dump5,'--k',LineWidth=1.5)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$E$';
legend('$E_{z}$','$-u \times B_{z}$','$J \times B_{z}/ne$',...
    '$(-\nabla \cdot P_{e}/ne)_{z}$','$(RHS)_{z}$',...
    'Interpreter','latex','NumColumns',1,'Location','northout')
hold off
sgtitle('$$ Unfiltered $$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
f222=figure(222)
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(1,3,1)
dum = Ex_filt.*v_a.*B0; dump1 = squeeze(dum(:,i,j));
plot(xl,dump1,'-r',LineWidth=1.5)
hold on
dum = -v_x_B_x_filt.*v_a.*B0; dump2 = squeeze(dum(:,i,j));
plot(xl,dump2,'-b',LineWidth=1.5)
dum = J_x_B_x_filt.*v_a.*B0.*n0./n_filt; dump3 = squeeze(dum(:,i,j));
plot(xl,dump3,'-g',LineWidth=1.5)
dum = -v_a*v_a*(Div_Pe_filt_x./n_filt); dump4 = squeeze(dum(:,i,j));
plot(xl,dump4,'-m',LineWidth=1.5)
dump5 = dump2 + dump3 + dump4;
plot(xl,dump5,'--k',LineWidth=1.5)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$E$';
legend('$E_{x}$','$-u \times B_{x}$','$J \times B_{x}/ne$',...
    '$(-\nabla \cdot P_{e}/ne)_{x}$','$(RHS)_{x}$',...
    'Interpreter','latex','NumColumns',1,'Location','northout')
hold off

subplot(1,3,2)
dum = Ey_filt.*v_a.*B0; dump1 = squeeze(dum(:,i,j));
plot(xl,dump1,'-r',LineWidth=1.5)
hold on
dum = -v_x_B_y_filt.*v_a.*B0; dump2 = squeeze(dum(:,i,j));
plot(xl,dump2,'-b',LineWidth=1.5)
dum = J_x_B_y_filt.*v_a.*B0.*n0./n_filt; dump3 = squeeze(dum(:,i,j));
plot(xl,dump3,'-g',LineWidth=1.5)
dum = -v_a*v_a*(Div_Pe_filt_y./n_filt); dump4 = squeeze(dum(:,i,j));
plot(xl,dump4,'-m',LineWidth=1.5)
dump5 = dump2 + dump3 + dump4;
plot(xl,dump5,'--k',LineWidth=1.5)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$E$';
legend('$E_{y}$','$-u \times B_{y}$','$J \times B_{y}/ne$',...
    '$(-\nabla \cdot P_{e}/ne)_{y}$','$(RHS)_{y}$',...
    'Interpreter','latex','NumColumns',1,'Location','northout')
hold off

subplot(1,3,3)
dum = Ez_filt.*v_a.*B0; dump1 = squeeze(dum(:,i,j));
plot(xl,dump1,'-r',LineWidth=1.5)
hold on
dum = -v_x_B_z_filt.*v_a.*B0; dump2 = squeeze(dum(:,i,j));
plot(xl,dump2,'-b',LineWidth=1.5)
dum = J_x_B_z_filt.*v_a.*B0.*n0./n_filt; dump3 = squeeze(dum(:,i,j));
plot(xl,dump3,'-g',LineWidth=1.5)
dum = -v_a*v_a*(Div_Pe_filt_z./n_filt); dump4 = squeeze(dum(:,i,j));
plot(xl,dump4,'-m',LineWidth=1.5)
dump5 = dump2 + dump3 + dump4;
plot(xl,dump5,'--k',LineWidth=1.5)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$E$';
legend('$E_{z}$','$-u \times B_{z}$','$J \times B_{z}/ne$',...
    '$(-\nabla \cdot P_{e}/ne)_{z}$','$(RHS)_{z}$',...
    'Interpreter','latex','NumColumns',1,'Location','northout')
hold off
sgtitle('$$ Filtered $$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------

%cd(f_path)
%saveas(f111,strcat(num2str(i),'Ohms_terms_1D_EvxBJxB2n.png'));
%--------------------------------------------------------------------------



%% %safe the plots
%cd(f_path)
%saveas(f21,strcat(num2str(component),'Omni_spectra_E.png'));
%}


%{
cd(f_path)
saveas(f1,strcat(num2str(component),'Ohms_terms_1D_together_10.png'));
saveas(f10,strcat(num2str(component),'Ohms_terms_regular_10.png'));
saveas(f11,strcat(num2str(component),'Ohms_terms_filterd_10.png'));

saveas(f111,strcat(num2str(component),'Ohms_terms_1D_EvxBJxB2ndivPe_10.png'));
saveas(f222,strcat(num2str(component),'Ohms_terms_1D_EvxBJxB2ndivPe_fil_10.png'));

saveas(f12,strcat(num2str(component),'Ohms_terms_taus_10.png'));
saveas(f101,strcat(num2str(component),'Ohms_terms_plus_taus_10.png'));
saveas(f102,strcat(num2str(component),'WHKKR_1D_10.png'));

saveas(f21,strcat(num2str(component),'Ohms_terms_power_omni_1D_10.png'));

saveas(f155,strcat(num2str(component),'taus_dependence_10.png'));
saveas(f166,strcat(num2str(component),'taus_dependence_2_10.png'));
saveas(f177,strcat(num2str(component),'taus_dependence_3_10.png'));

saveas(f123,strcat(num2str(component),'WHKKR_10.png'));

%saveas(f13,strcat(num2str(i),'Ohms_terms_power_2D_10.png')); %This needs the legends to be corrected 

%saveas(f22,strcat(num2str(i),'Ohms_terms_power_1D_per.png'));
saveas(f12,strcat(num2str(i),'Ohms_terms_taus_10.png'));
%saveas(f8,strcat(num2str(i),'Ohms_Ex_RHS.png'));
% %-
%}
% Just to check the normalization





%%
%%%
% Defining the functions to use in this script
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