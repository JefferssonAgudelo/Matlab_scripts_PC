%-----------------------------------------------------------------------------------------------------------------------
path = '/Volumes/PSC_CORI_DATA/TESTS_2022/Cirrus_folders/6cube';
%-----------------------------------------------------------------------------------------------------------------------

% For the scripts
path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
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
B0=0.2;
%n is normalise to the proton density n0=1
n0=1;
%Vi normalised to the proton alfven speed V_a=0.1c The alfven speed of
%electrons is Vae=10Vai
Vae=0.2;%0.2;
Va=0.2;%0.2;
%--------------------------------------------------------------------------
nb_n0 =0.1;
kb = 1.; mu0 =1.; c=1; q = 1;

Vai=0.2;
Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);

mime =1.;
mi = 1.;
me = 1. / mime; eps0=1.;
m = mi + me;

omega_pi=1;
Omega_e=Vai*sqrt(mime)*omega_pi;
Omega_i=Omega_e / mime;
TOmega_e=1/Omega_e;
TOmega_i=1/Omega_i;
omega_pe_Omega_ce=5;
%--------------------------------------------------------------------------
in=1;
fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;
B=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
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

% time_t_2=zeros(1,N);
% B2_n=zeros(1,N);
% E2_n=zeros(1,N);
% U_EM2_n=zeros(1,N);
% U_k_e_n=zeros(1,in);
% U_k_i_n=zeros(1,in);
% U_th_e_n=zeros(1,in);
% U_th_i_n=zeros(1,in);

in = 1;

%for in=1:floor(N)

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

for ndv =1:10
%ndv = 1; % fractiopn of the box size. create a patch for the size of the convolution window
%l_wind_x = LXs/ndv; %size of the window

resx = Lx/LXs;
%----------------------------------------------------------------------

% Maybe it is better to define this in terms of the real resolution
%----------------------------------------------------------------------
l_wind_x = (ndv/25)*Lx; %size of the window
l_wind_y = l_wind_x;
l_wind_z = l_wind_x;

[XL3d, YL3d, ZL3d] = meshgrid(xl,yl,zl);
%----------------------------------------------------------------------

% Define the gaussian kernel function
%----------------------------------------------------------------------
% First kernel
%----------------------------------------------------------------------
%----------------------------------------------------------------------
C_gs = (1/(2.*pi.*l_wind_x.^2))^(3/2);
G_gs = C_gs.*...
    exp(-(0.5.*(XL3d./l_wind_x).^2)).*...
    exp(-(0.5.*(YL3d./l_wind_y).^2)).*...
    exp(-(0.5.*(ZL3d./l_wind_z).^2));
%----------------------------------------------------------------------
% %second kernel
% %----------------------------------------------------------------------
% C_gs = (1/(2.*pi.*l_wind_x.^2))^(3/2);
% G_gs = C_gs.*...
%     exp(-(0.5.*(XL3d./l_wind_x).^2)).*...
%     exp(-(0.5.*(YL3d./l_wind_y).^2)).*...
%     exp(-(0.5.*(ZL3d./l_wind_z).^2));
%----------------------------------------------------------------------

G_gs_n = G_gs./sum(G_gs(:)); % This is to ensure that the integral of the kernel is one
%G_gs_n = G_gs;

% Perform the FFT of the function g
F_G_gs_n = fftn(G_gs_n);
%----------------------------------------------------------------------
% This is to test
%----------------------------------------------------------------------
B{1,1}=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'),start,count);
Bx_dt=B{1,1};
Bx_filt = Filtering_kernel(Bx_dt,F_G_gs_n);
Bx_pri = Bx_dt - Bx_filt;

i=30;

f11=figure(11);
subplot(2,5,ndv)
%dump = squeeze(Bx_filt(i,:,:));
dump = squeeze(Bx_filt(:,:,i));
hc=pcolor(dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
title(num2str(ndv))
%strcat(num2str(i),'Ohms_terms_regular.png')
hold off
% %----------------------------------------------------------------------

end


f2=figure(2);
% %----------------------------------------------------------------------
subplot(1,3,1)
%dump = squeeze(Bx_dt(i,:,:));
dump = squeeze(Bx_dt(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
title('Bx')
colorbar
hold off

subplot(1,3,2)
dump = squeeze(Bx_filt(:,:,i));
hc=pcolor(dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
title('<Bx>')
hold off

subplot(1,3,3)
dump = squeeze(Bx_pri(:,:,i));
hc=pcolor(dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
title('Bx_{pri} ' )
hold off
% %----------------------------------------------------------------------

BBx = Bx_dt;
BBx_f = imgaussfilt3(BBx,30);
f3=figure(3);
% %----------------------------------------------------------------------
subplot(1,2,1)
dump = squeeze(BBx(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
title('Bx')
colorbar
hold off
subplot(1,2,2)
dump = squeeze(BBx_f(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
title('Bx_f')
colorbar
hold off

% % This is the core and bulky part. Do not erare!
% %----------------------------------------------------------------------
% %----------------------------------------------------------------------
%{
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

%--------------------------------------------------------------------
v_ex = v_e{1,1};
v_ey = v_e{1,2};
v_ez = v_e{1,3};

v_ix = v_i{1,1};
v_iy = v_i{1,2};
v_iz = v_i{1,3};
%--------------------------------------------------------------------

%----------------------------------------------------------------------
Pij_e{1,1}=h5read(fileID2,strcat(moments_1st,'/txx_e/p0/3d'),start,count);
Pij_e{2,2}=h5read(fileID2,strcat(moments_1st,'/tyy_e/p0/3d'),start,count);
Pij_e{3,3}=h5read(fileID2,strcat(moments_1st,'/tzz_e/p0/3d'),start,count);
Pij_e{1,2}=h5read(fileID2,strcat(moments_1st,'/txy_e/p0/3d'),start,count);
Pij_e{1,3}=h5read(fileID2,strcat(moments_1st,'/tzx_e/p0/3d'),start,count);
Pij_e{2,3}=h5read(fileID2,strcat(moments_1st,'/tyz_e/p0/3d'),start,count);
Pij_e{2,1} = Pij_e{1,2}; Pij_e{3,2} = Pij_e{2,3}; Pij_e{3,1} = Pij_e{1,3};

Pij_i{1,1}=h5read(fileID2,strcat(moments_1st,'/txx_i/p0/3d'),start,count);
Pij_i{2,2}=h5read(fileID2,strcat(moments_1st,'/tyy_i/p0/3d'),start,count);
Pij_i{3,3}=h5read(fileID2,strcat(moments_1st,'/tzz_i/p0/3d'),start,count);
Pij_i{1,2}=h5read(fileID2,strcat(moments_1st,'/txy_i/p0/3d'),start,count);
Pij_i{1,3}=h5read(fileID2,strcat(moments_1st,'/tzx_i/p0/3d'),start,count);
Pij_i{2,3}=h5read(fileID2,strcat(moments_1st,'/tyz_i/p0/3d'),start,count);
Pij_i{2,1} = Pij_i{1,2}; Pij_i{3,2} = Pij_i{2,3}; Pij_i{3,1} = Pij_i{1,3};
%----------------------------------------------------------------------

% This is to get the central momment pressure.
%----------------------------------------------------------------------
PPij_i=cell(3,3);
PPij_e=cell(3,3);

for i=1:3
    for j=1:3
        if(isempty(Pij_i{i,j}) == 1) % This is where if P_ba is zero, this should be changed.
            continue
        end
        PPij_i{i,j} = Pij_i{i,j} - 1.*n_i0.*mi.*v_i{1,i}.*v_i{1,j};
        PPij_e{i,j} = Pij_e{i,j} - 1.*n_e0.*me.*v_e{1,i}.*v_e{1,j};
    end
end

% remove the variables just to rename them again
clearvars Pij_i Pij_e

% This is just to rename the variable
Pij_i = PPij_i;
Pij_e = PPij_e;

clearvars PPij_i PPij_e
%----------------------------------------------------------------------


% If the detrend is not need it
%----------------------------------------------------------------------
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

v_ix_dt=v_i{1,1};
v_iy_dt=v_i{1,2};
v_iz_dt=v_i{1,3};

v_ex_dt=v_e{1,1};
v_ey_dt=v_e{1,2};
v_ez_dt=v_e{1,3};

clearvars v_i v_e

n_e0_dt = n_e0;
n_i0_dt = n_i0;
n_0_dt = (n_e0_dt.*me + n_i0_dt.*mi)./(me + mi);

clearvars n_e0 n_i0

v_x_dt = (me.*n_e0_dt.*v_ex_dt + mi.*n_i0_dt.*v_ix_dt)./(me.*n_e0_dt + mi.*n_i0_dt);
v_y_dt = (me.*n_e0_dt.*v_ey_dt + mi.*n_i0_dt.*v_iy_dt)./(me.*n_e0_dt + mi.*n_i0_dt);
v_z_dt = (me.*n_e0_dt.*v_ez_dt + mi.*n_i0_dt.*v_iz_dt)./(me.*n_e0_dt + mi.*n_i0_dt);

Pij_ixx_dt=Pij_i{1,1};
Pij_ixy_dt=Pij_i{1,2};
Pij_ixz_dt=Pij_i{1,3};
Pij_iyy_dt=Pij_i{2,2};
Pij_iyz_dt=Pij_i{2,3};
Pij_izz_dt=Pij_i{3,3};

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


% Lets compute the generalised ohms terms for total field
%----------------------------------------------------------------------
% Computing non-linear terms for the generalised Ohms law
%----------------------------------------------------------------------
v_x_B_x_dt = v_y_dt.*Bz_dt - v_z_dt.*By_dt;
v_x_B_y_dt = v_z_dt.*Bx_dt - v_x_dt.*Bz_dt;
v_x_B_z_dt = v_x_dt.*By_dt - v_y_dt.*Bx_dt;

J_x_B_x_dt = Jy_dt.*Bz_dt - Jz_dt.*By_dt;
J_x_B_y_dt = Jz_dt.*Bx_dt - Jx_dt.*Bz_dt;
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
%J_J_2n_yx_dt = Jy_dt.*Jx_dt./(n_0_dt );
J_J_2n_yy_dt = Jy_dt.*Jy_dt./(n_0_dt );
J_J_2n_yz_dt = Jy_dt.*Jz_dt./(n_0_dt );
%J_J_2n_zx_dt = Jz_dt.*Jx_dt./(n_0_dt );
%J_J_2n_zy_dt = Jz_dt.*Jy_dt/(n_0_dt );
J_J_2n_zz_dt = Jz_dt.*Jz_dt./(n_0_dt );
%----------------------------------------------------------------------

%----------------------------------------------------------------------
%Now let lets compute the gradients
grad_fact = 1; % This always need to be two??
%Grad_Pe
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[Pij_exx_dt_x, Pij_exx_dt_y, Pij_exx_dt_z] = gradient(Pij_exx_dt);
[Pij_eyy_dt_x, Pij_eyy_dt_y, Pij_eyy_dt_z] = gradient(Pij_eyy_dt);
[Pij_ezz_dt_x, Pij_ezz_dt_y, Pij_ezz_dt_z] = gradient(Pij_ezz_dt);
[Pij_exy_dt_x, Pij_exy_dt_y, Pij_exy_dt_z] = gradient(Pij_exy_dt);
[Pij_exz_dt_x, Pij_exz_dt_y, Pij_exz_dt_z] = gradient(Pij_exz_dt);
[Pij_eyz_dt_x, Pij_eyz_dt_y, Pij_eyz_dt_z] = gradient(Pij_eyz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
Div_Pe_dt_x = Pij_exx_dt_x/(grad_fact.*resx) + Pij_exy_dt_y/(grad_fact.*resx) + Pij_exz_dt_z/(grad_fact.*resx);
Div_Pe_dt_y = Pij_exy_dt_x/(grad_fact.*resx) + Pij_eyy_dt_y/(grad_fact.*resx) + Pij_eyz_dt_z/(grad_fact.*resx);
Div_Pe_dt_z = Pij_exz_dt_x/(grad_fact.*resx) + Pij_eyz_dt_y/(grad_fact.*resx) + Pij_ezz_dt_z/(grad_fact.*resx);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[Pij_ixx_dt_x, Pij_ixx_dt_y, Pij_ixx_dt_z] = gradient(Pij_ixx_dt);
[Pij_iyy_dt_x, Pij_iyy_dt_y, Pij_iyy_dt_z] = gradient(Pij_iyy_dt);
[Pij_izz_dt_x, Pij_izz_dt_y, Pij_izz_dt_z] = gradient(Pij_izz_dt);
[Pij_ixy_dt_x, Pij_ixy_dt_y, Pij_ixy_dt_z] = gradient(Pij_ixy_dt);
[Pij_ixz_dt_x, Pij_ixz_dt_y, Pij_ixz_dt_z] = gradient(Pij_ixz_dt);
[Pij_iyz_dt_x, Pij_iyz_dt_y, Pij_iyz_dt_z] = gradient(Pij_iyz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
Div_Pi_dt_x = Pij_ixx_dt_x/(grad_fact.*resx) + Pij_ixy_dt_y/(grad_fact.*resx) + Pij_ixz_dt_z/(grad_fact.*resx);
Div_Pi_dt_y = Pij_ixy_dt_x/(grad_fact.*resx) + Pij_iyy_dt_y/(grad_fact.*resx) + Pij_iyz_dt_z/(grad_fact.*resx);
Div_Pi_dt_z = Pij_ixz_dt_x/(grad_fact.*resx) + Pij_iyz_dt_y/(grad_fact.*resx) + Pij_izz_dt_z/(grad_fact.*resx);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[v_J_dt_xx_x, v_J_dt_xx_y, v_J_dt_xx_z] = gradient(v_J_xx_dt);
[v_J_dt_xy_x, v_J_dt_xy_y, v_J_dt_xy_z] = gradient(v_J_xy_dt);
[v_J_dt_xz_x, v_J_dt_xz_y, v_J_dt_xz_z] = gradient(v_J_xz_dt);
[v_J_dt_yx_x, v_J_dt_yx_y, v_J_dt_yx_z] = gradient(v_J_yx_dt);
[v_J_dt_yy_x, v_J_dt_yy_y, v_J_dt_yy_z] = gradient(v_J_yy_dt);
[v_J_dt_yz_x, v_J_dt_yz_y, v_J_dt_yz_z] = gradient(v_J_yz_dt);
[v_J_dt_zx_x, v_J_dt_zx_y, v_J_dt_zx_z] = gradient(v_J_zx_dt);
[v_J_dt_zy_x, v_J_dt_zy_y, v_J_dt_zy_z] = gradient(v_J_zy_dt);
[v_J_dt_zz_x, v_J_dt_zz_y, v_J_dt_zz_z] = gradient(v_J_zz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
Div_vJ_dt_x = v_J_dt_xx_x/(grad_fact.*resx) + v_J_dt_yx_y/(grad_fact.*resx) + v_J_dt_zx_z/(grad_fact.*resx);
Div_vJ_dt_y = v_J_dt_xy_x/(grad_fact.*resx) + v_J_dt_yy_y/(grad_fact.*resx) + v_J_dt_zy_z/(grad_fact.*resx);
Div_vJ_dt_z = v_J_dt_xz_x/(grad_fact.*resx) + v_J_dt_yz_y/(grad_fact.*resx) + v_J_dt_zz_z/(grad_fact.*resx);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[J_v_xx_x, J_v_xx_y, J_v_xx_z] = gradient(J_v_xx_dt);
[J_v_xy_x, J_v_xy_y, J_v_xy_z] = gradient(J_v_xy_dt);
[J_v_xz_x, J_v_xz_y, J_v_xz_z] = gradient(J_v_xz_dt);
[J_v_yx_x, J_v_yx_y, J_v_yx_z] = gradient(J_v_yx_dt);
[J_v_yy_x, J_v_yy_y, J_v_yy_z] = gradient(J_v_yy_dt);
[J_v_yz_x, J_v_yz_y, J_v_yz_z] = gradient(J_v_yz_dt);
[J_v_zx_x, J_v_zx_y, J_v_zx_z] = gradient(J_v_zx_dt);
[J_v_zy_x, J_v_zy_y, J_v_zy_z] = gradient(J_v_zy_dt);
[J_v_zz_x, J_v_zz_y, J_v_zz_z] = gradient(J_v_zz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
Div_Jv_dt_x = J_v_xx_x/(grad_fact.*resx) + J_v_yx_y/(grad_fact.*resx) + J_v_zx_z/(grad_fact.*resx);
Div_Jv_dt_y = J_v_xy_x/(grad_fact.*resx) + J_v_yy_y/(grad_fact.*resx) + J_v_zy_z/(grad_fact.*resx);
Div_Jv_dt_z = J_v_xz_x/(grad_fact.*resx) + J_v_yz_y/(grad_fact.*resx) + J_v_zz_z/(grad_fact.*resx);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[J_J_xx_x, J_J_xx_y, J_J_xx_z] = gradient(J_J_2n_xx_dt);
[J_J_xy_x, J_J_xy_y, J_J_xy_z] = gradient(J_J_2n_xy_dt);
[J_J_xz_x, J_J_xz_y, J_J_xz_z] = gradient(J_J_2n_xz_dt);
%[J_J_yx_x, J_J_yx_y, J_J_yx_z] = gradient(J_J_2n_yx_dt);
[J_J_yy_x, J_J_yy_y, J_J_yy_z] = gradient(J_J_2n_yy_dt);
[J_J_yz_x, J_J_yz_y, J_J_yz_z] = gradient(J_J_2n_yz_dt);
%[J_J_zx_x, J_J_zx_y, J_J_zx_z] = gradient(J_J_2n_zx_dt);
%[J_J_zy_x, J_J_zy_y, J_J_zy_z] = gradient(J_J_2n_zy_dt);
[J_J_zz_x, J_J_zz_y, J_J_zz_z] = gradient(J_J_2n_zz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
Div_JJ_dt_x = J_J_xx_x/(grad_fact.*resx) + J_J_xy_y/(grad_fact.*resx) + J_J_xz_z/(grad_fact.*resx);
Div_JJ_dt_y = J_J_xy_x/(grad_fact.*resx) + J_J_yy_y/(grad_fact.*resx) + J_J_yz_z/(grad_fact.*resx);
Div_JJ_dt_z = J_J_xz_x/(grad_fact.*resx) + J_J_yz_y/(grad_fact.*resx) + J_J_zz_z/(grad_fact.*resx);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
LHD_x_dt = Ex_dt + v_x_B_x_dt;
RHD_x_dt = (J_x_B_x_dt) - (Div_Pe_dt_x./n_0_dt) + (Div_vJ_dt_x + Div_Jv_dt_x - Div_JJ_dt_x)./n_0_dt;
%----------------------------------------------------------------------



%----------------------------------------------------------------------
% I need to discusse this with julia
% Detrend the variable to keep only the fluctuating part
%----------------------------------------------------------------------
%{
    %----------------------------------------------------------------------
    Bx_dt=B{1,1}-mean(mean(mean((B{1,1})))); 
    By_dt=B{1,2}-mean(mean(mean((B{1,2})))); 
    Bz_dt=B{1,3}-mean(mean(mean((B{1,3}))));

    Ex_dt=E{1,1}-mean(mean(mean((E{1,1})))); 
    Ey_dt=E{1,2}-mean(mean(mean((E{1,2})))); 
    Ez_dt=E{1,3}-mean(mean(mean((E{1,3}))));

    Jx_dt=B{1,1}-mean(mean(mean((J{1,1})))); 
    Jy_dt=B{1,2}-mean(mean(mean((J{1,2})))); 
    Jz_dt=B{1,3}-mean(mean(mean((J{1,3}))));
    clearvars B E J

    v_ix_dt=v_i{1,1}-mean(mean(mean((v_i{1,1})))); 
    v_iy_dt=v_i{1,2}-mean(mean(mean((v_i{1,2})))); 
    v_iz_dt=v_i{1,3}-mean(mean(mean((v_i{1,3}))));

    v_ex_dt=B{1,1}-mean(mean(mean((v_e{1,1})))); 
    v_ey_dt=B{1,2}-mean(mean(mean((v_e{1,2})))); 
    v_ez_dt=B{1,3}-mean(mean(mean((v_e{1,3}))));

    clearvars v_i v_e

    n_e0_dt = n_e0 - mean(mean(mean((n_e0))));
    n_i0_dt = n_i0 - mean(mean(mean((n_i0))));

    clearvars n_e0 n_i0

    Pij_ixx_dt=Pij_i{1,1}-mean(mean(mean((Pij_i{1,1}))));
    Pij_ixy_dt=Pij_i{1,2}-mean(mean(mean((Pij_i{1,2}))));
    Pij_ixz_dt=Pij_i{1,3}-mean(mean(mean((Pij_i{1,3})))); 
    Pij_iyy_dt=Pij_i{2,2}-mean(mean(mean((Pij_i{2,2}))));    
    Pij_iyz_dt=Pij_i{2,3}-mean(mean(mean((Pij_i{2,3}))));
    Pij_izz_dt=Pij_i{3,3}-mean(mean(mean((Pij_i{3,3}))));

    Pij_iyx_dt = Pij_ixy_dt; Pij_izx_dt = Pij_ixz_dt; Pij_izy_dt = Pij_iyz_dt;

    Pij_exx_dt=Pij_e{1,1}-mean(mean(mean((Pij_e{1,1}))));
    Pij_exy_dt=Pij_e{1,2}-mean(mean(mean((Pij_e{1,2}))));
    Pij_exz_dt=Pij_e{1,3}-mean(mean(mean((Pij_e{1,3})))); 
    Pij_eyy_dt=Pij_e{2,2}-mean(mean(mean((Pij_e{2,2}))));    
    Pij_eyz_dt=Pij_e{2,3}-mean(mean(mean((Pij_e{2,3}))));
    Pij_ezz_dt=Pij_e{3,3}-mean(mean(mean((Pij_e{3,3}))));

    Pij_eyx_dt = Pij_exy_dt; Pij_ezx_dt = Pij_exz_dt; Pij_ezy_dt = Pij_eyz_dt;

    clearvars Pij_i Pij_e
    %----------------------------------------------------------------------
%}
%----------------------------------------------------------------------

% % Make a plot to see the variable
% %----------------------------------------------------------------------
% y_lim = max(max(max(abs(Bx))));
%
% f1=figure(1);
% for i=1:168
%     hc=pcolor(squeeze(Bx(:,:,i)));
%     hold on
%     set(hc,'edgecolor','none')
%     clim([-y_lim y_lim]);
%     colorbar
%     hold off
%     pause(0.3)
% end
% %----------------------------------------------------------------------

% important note about the convolution and FFT
%----------------------------------------------------------------------
%The FFT imposes a periodic boundary condition, whereas conv assumes zeros outside the input domain.

%---------------------------------------------------------------------

% Proceed with the scale filtering
%----------------------------------------------------------------------
%Compute the fft    %Compute the averages using a kernel
%----------------------------------------------------------------------

% These four lines are the filtering
%----------------------------------------------------------------------
Bx_filt = Filtering_kernel(Bx_dt,F_G_gs_n);
By_filt = Filtering_kernel(By_dt,F_G_gs_n);
Bz_filt = Filtering_kernel(Bz_dt,F_G_gs_n);

Ex_filt = Filtering_kernel(Ex_dt,F_G_gs_n);
Ey_filt = Filtering_kernel(Ey_dt,F_G_gs_n);
Ez_filt = Filtering_kernel(Ez_dt,F_G_gs_n);

Jx_filt = Filtering_kernel(Jx_dt,F_G_gs_n);
Jy_filt = Filtering_kernel(Jy_dt,F_G_gs_n);
Jz_filt = Filtering_kernel(Jz_dt,F_G_gs_n);

v_ix_filt = Filtering_kernel(v_ix_dt,F_G_gs_n);
v_iy_filt = Filtering_kernel(v_iy_dt,F_G_gs_n);
v_iz_filt = Filtering_kernel(v_iz_dt,F_G_gs_n);

v_ex_filt = Filtering_kernel(v_ex_dt,F_G_gs_n);
v_ey_filt = Filtering_kernel(v_ey_dt,F_G_gs_n);
v_ez_filt = Filtering_kernel(v_ez_dt,F_G_gs_n);

v_x_filt = Filtering_kernel(v_x_dt,F_G_gs_n);
v_y_filt = Filtering_kernel(v_y_dt,F_G_gs_n);
v_z_filt = Filtering_kernel(v_z_dt,F_G_gs_n);

n_e_filt = Filtering_kernel(n_e0_dt,F_G_gs_n);
n_i_filt = Filtering_kernel(n_i0_dt,F_G_gs_n);
n_filt = Filtering_kernel(n_0_dt,F_G_gs_n);

Pij_ixx_filt = Filtering_kernel(Pij_ixx_dt,F_G_gs_n);
Pij_ixy_filt = Filtering_kernel(Pij_ixy_dt,F_G_gs_n);
Pij_ixz_filt = Filtering_kernel(Pij_ixz_dt,F_G_gs_n);
Pij_iyy_filt = Filtering_kernel(Pij_iyy_dt,F_G_gs_n);
Pij_iyz_filt = Filtering_kernel(Pij_iyz_dt,F_G_gs_n);
Pij_izz_filt = Filtering_kernel(Pij_izz_dt,F_G_gs_n);

Pij_exx_filt = Filtering_kernel(Pij_exx_dt,F_G_gs_n);
Pij_exy_filt = Filtering_kernel(Pij_exy_dt,F_G_gs_n);
Pij_exz_filt = Filtering_kernel(Pij_exz_dt,F_G_gs_n);
Pij_eyy_filt = Filtering_kernel(Pij_eyy_dt,F_G_gs_n);
Pij_eyz_filt = Filtering_kernel(Pij_eyz_dt,F_G_gs_n);
Pij_ezz_filt = Filtering_kernel(Pij_ezz_dt,F_G_gs_n);
%----------------------------------------------------------------------

% Computing non-linear terms for the generalised Ohms law
%----------------------------------------------------------------------
v_filt_x_B_filt_x = v_y_filt.*Bz_filt - v_z_filt.*By_filt;
v_filt_x_B_filt_y = v_z_filt.*Bx_filt - v_x_filt.*Bz_filt;
v_filt_x_B_filt_z = v_x_filt.*By_filt - v_y_filt.*Bx_filt;

J_filt_x_B_filt_x = Jy_filt.*Bz_filt - Jz_filt.*By_filt;
J_filt_x_B_filt_y = Jz_filt.*Bx_filt - Jx_filt.*Bz_filt;
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
%J_filt_J_filt_2n_yx = Jy_filt.*Jx_filt./(n_filt);
J_filt_J_filt_2n_yy = Jy_filt.*Jy_filt./(n_filt);
J_filt_J_filt_2n_yz = Jy_filt.*Jz_filt./(n_filt);
%J_filt_J_filt_2n_zx = Jz_filt.*Jx_filt./(n_filt);
%J_filt_J_filt_2n_zy = Jz_filt.*Jy_filt./(n_filt);
J_filt_J_filt_2n_zz = Jz_filt.*Jz_filt./(n_filt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
%Now let lets compute the gradients
grad_fact = 1; % This always need to be two??
%Grad_Pe
%----------------------------------------------------------------------

% % %This is to check tha the derivative is properly computed
% % %----------------------------------------------------------------------
% % dump_1 = sin(XL3d);
% % dump_2 = cos(XL3d);
% % [dump_1_x, dump_1_y, dump_1_z] = gradient(dump_1);
% % Div_dump_1 = dump_1_x/(grad_fact.*resx) + dump_1_y/(grad_fact.*resx) + dump_1_z/(grad_fact.*resx);
% % %----------------------------------------------------------------------
% % i=60;
% % f3=figure(3);
% % subplot(1,3,1)
% % dum = dump_1;
% % y_lim = max(max(max(dum)));
% % hc=pcolor(squeeze(dum(:,:,i)));
% % hold on
% % set(hc,'edgecolor','none')
% % clim([-y_lim y_lim]);
% % colorbar
% % title('sin')
% % hold off
% % subplot(1,3,2)
% % dum = dump_2;
% % y_lim = max(max(max(dum)));
% % hc=pcolor(squeeze(dum(:,:,i)));
% % hold on
% % set(hc,'edgecolor','none')
% % clim([-y_lim y_lim]);
% % colorbar
% % title('cos_t')
% % hold off
% % subplot(1,3,3)
% % dum = dump_1_x/(grad_fact.*resx);
% % y_lim = max(max(max(dum)));
% % hc=pcolor(squeeze(dum(:,:,i)));
% % hold on
% % set(hc,'edgecolor','none')
% % clim([-y_lim y_lim]);
% % colorbar
% % title('cos_c')
% % hold off
% % %----------------------------------------------------------------------

%----------------------------------------------------------------------
[Pij_exx_filt_x, Pij_exx_filt_y, Pij_exx_filt_z] = gradient(Pij_exx_filt);
[Pij_eyy_filt_x, Pij_eyy_filt_y, Pij_eyy_filt_z] = gradient(Pij_eyy_filt);
[Pij_ezz_filt_x, Pij_ezz_filt_y, Pij_ezz_filt_z] = gradient(Pij_ezz_filt);
[Pij_exy_filt_x, Pij_exy_filt_y, Pij_exy_filt_z] = gradient(Pij_exy_filt);
[Pij_exz_filt_x, Pij_exz_filt_y, Pij_exz_filt_z] = gradient(Pij_exz_filt);
[Pij_eyz_filt_x, Pij_eyz_filt_y, Pij_eyz_filt_z] = gradient(Pij_eyz_filt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
Div_Pe_filt_x = Pij_exx_filt_x/(grad_fact.*resx) + Pij_exy_filt_y/(grad_fact.*resx) + Pij_exz_filt_z/(grad_fact.*resx);
Div_Pe_filt_y = Pij_exy_filt_x/(grad_fact.*resx) + Pij_eyy_filt_y/(grad_fact.*resx) + Pij_eyz_filt_z/(grad_fact.*resx);
Div_Pe_filt_z = Pij_exz_filt_x/(grad_fact.*resx) + Pij_eyz_filt_y/(grad_fact.*resx) + Pij_ezz_filt_z/(grad_fact.*resx);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[Pij_ixx_filt_x, Pij_ixx_filt_y, Pij_ixx_filt_z] = gradient(Pij_ixx_filt);
[Pij_iyy_filt_x, Pij_iyy_filt_y, Pij_iyy_filt_z] = gradient(Pij_iyy_filt);
[Pij_izz_filt_x, Pij_izz_filt_y, Pij_izz_filt_z] = gradient(Pij_izz_filt);
[Pij_ixy_filt_x, Pij_ixy_filt_y, Pij_ixy_filt_z] = gradient(Pij_ixy_filt);
[Pij_ixz_filt_x, Pij_ixz_filt_y, Pij_ixz_filt_z] = gradient(Pij_ixz_filt);
[Pij_iyz_filt_x, Pij_iyz_filt_y, Pij_iyz_filt_z] = gradient(Pij_iyz_filt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
Div_Pi_filt_x = Pij_ixx_filt_x/(grad_fact.*resx) + Pij_ixy_filt_y/(grad_fact.*resx) + Pij_ixz_filt_z/(grad_fact.*resx);
Div_Pi_filt_y = Pij_ixy_filt_x/(grad_fact.*resx) + Pij_iyy_filt_y/(grad_fact.*resx) + Pij_iyz_filt_z/(grad_fact.*resx);
Div_Pi_filt_z = Pij_ixz_filt_x/(grad_fact.*resx) + Pij_iyz_filt_y/(grad_fact.*resx) + Pij_izz_filt_z/(grad_fact.*resx);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[v_filt_J_filt_xx_x, v_filt_J_filt_xx_y, v_filt_J_filt_xx_z] = gradient(v_filt_J_filt_xx);
[v_filt_J_filt_xy_x, v_filt_J_filt_xy_y, v_filt_J_filt_xy_z] = gradient(v_filt_J_filt_xy);
[v_filt_J_filt_xz_x, v_filt_J_filt_xz_y, v_filt_J_filt_xz_z] = gradient(v_filt_J_filt_xz);
[v_filt_J_filt_yx_x, v_filt_J_filt_yx_y, v_filt_J_filt_yx_z] = gradient(v_filt_J_filt_yx);
[v_filt_J_filt_yy_x, v_filt_J_filt_yy_y, v_filt_J_filt_yy_z] = gradient(v_filt_J_filt_yy);
[v_filt_J_filt_yz_x, v_filt_J_filt_yz_y, v_filt_J_filt_yz_z] = gradient(v_filt_J_filt_yz);
[v_filt_J_filt_zx_x, v_filt_J_filt_zx_y, v_filt_J_filt_zx_z] = gradient(v_filt_J_filt_zx);
[v_filt_J_filt_zy_x, v_filt_J_filt_zy_y, v_filt_J_filt_zy_z] = gradient(v_filt_J_filt_zy);
[v_filt_J_filt_zz_x, v_filt_J_filt_zz_y, v_filt_J_filt_zz_z] = gradient(v_filt_J_filt_zz);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
Div_vJ_filt_x = v_filt_J_filt_xx_x/(grad_fact.*resx) + v_filt_J_filt_yx_y/(grad_fact.*resx) + v_filt_J_filt_zx_z/(grad_fact.*resx);
Div_vJ_filt_y = v_filt_J_filt_xy_x/(grad_fact.*resx) + v_filt_J_filt_yy_y/(grad_fact.*resx) + v_filt_J_filt_zy_z/(grad_fact.*resx);
Div_vJ_filt_z = v_filt_J_filt_xz_x/(grad_fact.*resx) + v_filt_J_filt_yz_y/(grad_fact.*resx) + v_filt_J_filt_zz_z/(grad_fact.*resx);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[J_filt_v_filt_xx_x, J_filt_v_filt_xx_y, J_filt_v_filt_xx_z] = gradient(J_filt_v_filt_xx);
[J_filt_v_filt_xy_x, J_filt_v_filt_xy_y, J_filt_v_filt_xy_z] = gradient(J_filt_v_filt_xy);
[J_filt_v_filt_xz_x, J_filt_v_filt_xz_y, J_filt_v_filt_xz_z] = gradient(J_filt_v_filt_xz);
[J_filt_v_filt_yx_x, J_filt_v_filt_yx_y, J_filt_v_filt_yx_z] = gradient(J_filt_v_filt_yx);
[J_filt_v_filt_yy_x, J_filt_v_filt_yy_y, J_filt_v_filt_yy_z] = gradient(J_filt_v_filt_yy);
[J_filt_v_filt_yz_x, J_filt_v_filt_yz_y, J_filt_v_filt_yz_z] = gradient(J_filt_v_filt_yz);
[J_filt_v_filt_zx_x, J_filt_v_filt_zx_y, J_filt_v_filt_zx_z] = gradient(J_filt_v_filt_zx);
[J_filt_v_filt_zy_x, J_filt_v_filt_zy_y, J_filt_v_filt_zy_z] = gradient(J_filt_v_filt_zy);
[J_filt_v_filt_zz_x, J_filt_v_filt_zz_y, J_filt_v_filt_zz_z] = gradient(J_filt_v_filt_zz);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
Div_Jv_filt_x = J_filt_v_filt_xx_x/(grad_fact.*resx) + J_filt_v_filt_yx_y/(grad_fact.*resx) + J_filt_v_filt_zx_z/(grad_fact.*resx);
Div_Jv_filt_y = J_filt_v_filt_xy_x/(grad_fact.*resx) + J_filt_v_filt_yy_y/(grad_fact.*resx) + J_filt_v_filt_zy_z/(grad_fact.*resx);
Div_Jv_filt_z = J_filt_v_filt_xz_x/(grad_fact.*resx) + J_filt_v_filt_yz_y/(grad_fact.*resx) + J_filt_v_filt_zz_z/(grad_fact.*resx);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[J_filt_J_filt_xx_x, J_filt_J_filt_xx_y, J_filt_J_filt_xx_z] = gradient(J_filt_J_filt_2n_xx);
[J_filt_J_filt_xy_x, J_filt_J_filt_xy_y, J_filt_J_filt_xy_z] = gradient(J_filt_J_filt_2n_xy);
[J_filt_J_filt_xz_x, J_filt_J_filt_xz_y, J_filt_J_filt_xz_z] = gradient(J_filt_J_filt_2n_xz);
%[J_filt_J_filt_yx_x, J_filt_J_filt_yx_y, J_filt_J_filt_yx_z] = gradient(J_filt_J_filt_2n_yx);
[J_filt_J_filt_yy_x, J_filt_J_filt_yy_y, J_filt_J_filt_yy_z] = gradient(J_filt_J_filt_2n_yy);
[J_filt_J_filt_yz_x, J_filt_J_filt_yz_y, J_filt_J_filt_yz_z] = gradient(J_filt_J_filt_2n_yz);
%[J_filt_J_filt_zx_x, J_filt_J_filt_zx_y, J_filt_J_filt_zx_z] = gradient(J_filt_J_filt_2n_zx);
%[J_filt_J_filt_zy_x, J_filt_J_filt_zy_y, J_filt_J_filt_zy_z] = gradient(J_filt_J_filt_2n_zy);
[J_filt_J_filt_zz_x, J_filt_J_filt_zz_y, J_filt_J_filt_zz_z] = gradient(J_filt_J_filt_2n_zz);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
Div_JJ_filt_x = J_filt_J_filt_xx_x/(grad_fact.*resx) + J_filt_J_filt_xy_y/(grad_fact.*resx) + J_filt_J_filt_xz_z/(grad_fact.*resx);
Div_JJ_filt_y = J_filt_J_filt_xy_x/(grad_fact.*resx) + J_filt_J_filt_yy_y/(grad_fact.*resx) + J_filt_J_filt_yz_z/(grad_fact.*resx);
Div_JJ_filt_z = J_filt_J_filt_xz_x/(grad_fact.*resx) + J_filt_J_filt_yz_y/(grad_fact.*resx) + J_filt_J_filt_zz_z/(grad_fact.*resx);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
LHD_x = Ex_filt + v_filt_x_B_filt_x;
RHD_x = (J_filt_x_B_filt_x) - (Div_Pe_filt_x./n_filt) + (Div_vJ_filt_x + Div_Jv_filt_x - Div_JJ_filt_x)./n_filt;
%----------------------------------------------------------------------



% % % Now let's compute the tensors
% % %----------------------------------------------------------------------

%(<nevxB> - <n><J>x<B>)/<ne>
% % %----------------------------------------------------------------------
v_x_B_tau_x = (Filtering_kernel(n_0_dt.*v_x_B_x_dt,F_G_gs_n))./n_filt - v_filt_x_B_filt_x;
v_x_B_tau_y = (Filtering_kernel(n_0_dt.*v_x_B_y_dt,F_G_gs_n))./n_filt - v_filt_x_B_filt_y;
v_x_B_tau_z = (Filtering_kernel(n_0_dt.*v_x_B_z_dt,F_G_gs_n))./n_filt - v_filt_x_B_filt_z;
% % %----------------------------------------------------------------------

%(<nevxB> - <n><J>x<B>)/<ne>
% % %----------------------------------------------------------------------
nE_tau_x = (Filtering_kernel(n_0_dt.*Ex_dt,F_G_gs_n))./n_filt - Ex_filt;
nE_tau_y = (Filtering_kernel(n_0_dt.*Ey_dt,F_G_gs_n))./n_filt - Ey_filt;
nE_tau_z = (Filtering_kernel(n_0_dt.*Ez_dt,F_G_gs_n))./n_filt - Ez_filt;
% % %----------------------------------------------------------------------

%----------------------------------------------------------------------
J_x_B_tau_x = (Filtering_kernel(J_x_B_x_dt,F_G_gs_n) - J_filt_x_B_filt_x)./n_filt;
J_x_B_tau_y = (Filtering_kernel(J_x_B_y_dt,F_G_gs_n) - J_filt_x_B_filt_y)./n_filt;
J_x_B_tau_z = (Filtering_kernel(J_x_B_z_dt,F_G_gs_n) - J_filt_x_B_filt_z)./n_filt;
% % %----------------------------------------------------------------------

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
%----------------------------------------------------------------------
[sub_tau1_xx_x, sub_tau1_xx_y, sub_tau1_xx_z] = gradient(sub_tau1_xx);
[sub_tau1_xy_x, sub_tau1_xy_y, sub_tau1_xy_z] = gradient(sub_tau1_xy);
[sub_tau1_xz_x, sub_tau1_xz_y, sub_tau1_xz_z] = gradient(sub_tau1_xz);
[sub_tau1_yx_x, sub_tau1_yx_y, sub_tau1_yx_z] = gradient(sub_tau1_yx);
[sub_tau1_yy_x, sub_tau1_yy_y, sub_tau1_yy_z] = gradient(sub_tau1_yy);
[sub_tau1_yz_x, sub_tau1_yz_y, sub_tau1_yz_z] = gradient(sub_tau1_yz);
[sub_tau1_zx_x, sub_tau1_zx_y, sub_tau1_zx_z] = gradient(sub_tau1_zx);
[sub_tau1_zy_x, sub_tau1_zy_y, sub_tau1_zy_z] = gradient(sub_tau1_zy);
[sub_tau1_zz_x, sub_tau1_zz_y, sub_tau1_zz_z] = gradient(sub_tau1_zz);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
Div_sub_tau1_x = sub_tau1_xx_x/(grad_fact.*resx) + sub_tau1_yx_y/(grad_fact.*resx) + sub_tau1_zx_z/(grad_fact.*resx);
Div_sub_tau1_y = sub_tau1_xy_x/(grad_fact.*resx) + sub_tau1_yy_y/(grad_fact.*resx) + sub_tau1_zy_z/(grad_fact.*resx);
Div_sub_tau1_z = sub_tau1_xz_x/(grad_fact.*resx) + sub_tau1_yz_y/(grad_fact.*resx) + sub_tau1_zz_z/(grad_fact.*resx);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
Div_tau1_x = me.*(Filtering_kernel(Div_sub_tau1_x,F_G_gs_n) - (Div_vJ_filt_x + Div_Jv_filt_x - Div_JJ_filt_x))./n_filt;
Div_tau1_y = me.*(Filtering_kernel(Div_sub_tau1_y,F_G_gs_n) - (Div_vJ_filt_y + Div_Jv_filt_y - Div_JJ_filt_y))./n_filt;
Div_tau1_z = me.*(Filtering_kernel(Div_sub_tau1_z,F_G_gs_n) - (Div_vJ_filt_z + Div_Jv_filt_z - Div_JJ_filt_z))./n_filt;
%----------------------------------------------------------------------


% These are the plot
%----------------------------------------------------------------------
fs=20;
i=30;j=30;
f9=figure(9);
%----------------------------------------------------------------------
subplot(3,2,1)
dum = Ex_dt;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
ylim([-y_lim, y_lim]);
title('E_x')
hold off
%----------------------------------------------------------------------
subplot(3,2,2)
dum = v_x_B_x_dt;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
ylim([-y_lim, y_lim]);
title('vxB_x')
hold off
%----------------------------------------------------------------------
subplot(3,2,3)
dum = Ey_dt;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
ylim([-y_lim, y_lim]);
title('E_y')
hold off
%----------------------------------------------------------------------
subplot(3,2,4)
dum = v_x_B_y_dt;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
ylim([-y_lim, y_lim]);
title('vxB_y')
hold off
%----------------------------------------------------------------------
subplot(3,2,5)
dum = Ez_dt;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
ylim([-y_lim, y_lim]);
title('E_z')
hold off
%----------------------------------------------------------------------
subplot(3,2,6)
dum = v_x_B_z_dt;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
ylim([-y_lim, y_lim]);
title('vxB_z')
hold off
%----------------------------------------------------------------------


% This is for the 1D case
%----------------------------------------------------------------------
i=30;j=30;
%----------------------------------------------------------------------
f10=figure(10);
subplot(2,5,1)
dum = LHD_x_dt;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
ylim([-y_lim, y_lim]);
title('LHS')
hold off

subplot(2,5,2)
dum = RHD_x_dt;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
ylim([-y_lim, y_lim]);
title('RHS')
hold off

subplot(2,5,3)
dum = J_x_B_x_dt;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
ylim([-y_lim, y_lim]);
title('JxB')
hold off

subplot(2,5,4)
dum = Div_Pe_dt_x./n_0_dt;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
ylim([-y_lim, y_lim]);
title('divPe/n')
hold off

subplot(2,5,5)
dum = (Div_vJ_dt_x + Div_Jv_dt_x - Div_JJ_dt_x)./n_0_dt;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
ylim([-y_lim, y_lim]);
title('div(vJ+Jv-JJ/n)')
hold off
%----------------------------------------------------------------------

%i=30;
%----------------------------------------------------------------------
%f10=figure(10);
subplot(2,5,6)
dum = LHD_x_dt;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
title('LHS')
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
hold off

subplot(2,5,7)
dum = RHD_x_dt;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
title('RHS')
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
hold off

subplot(2,5,8)
dum = J_x_B_x_dt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
title('JxB')
hold off

subplot(2,5,9)
dum = Div_Pe_dt_x./n_0_dt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
title('divPe/n')
hold off

subplot(2,5,10)
dum = (Div_vJ_dt_x + Div_Jv_dt_x - Div_JJ_dt_x)./n_0_dt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
title('div(vJ+Jv-JJ/n)')
hold off
sgtitle('$$ regular $$','Interpreter','latex','FontSize',fs)
%----------------------------------------------------------------------


%----------------------------------------------------------------------
%i=30;j=30;
%----------------------------------------------------------------------
f11=figure(11);
subplot(2,5,1)
dum = LHD_x;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
ylim([-y_lim, y_lim]);
title('LHS F')
hold off

subplot(2,5,2)
dum = RHD_x;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
ylim([-y_lim, y_lim]);
title('RHS F')
hold off

subplot(2,5,3)
dum = J_filt_x_B_filt_x;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
ylim([-y_lim, y_lim]);
title('JxB F')
hold off

subplot(2,5,4)
dum = Div_Pe_filt_x./n_filt;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
ylim([-y_lim, y_lim]);
title('divPe/n F')
hold off

subplot(2,5,5)
dum = (Div_vJ_filt_x + Div_Jv_filt_x - Div_JJ_filt_x)./n_filt;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
ylim([-y_lim, y_lim]);
title('div(vJ+Jv-JJ/n F)')
hold off
%----------------------------------------------------------------------
%f11=figure(11);
subplot(2,5,6)
dum = LHD_x;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
title('LHS F')
xline(xl(1,j),'--k','LineWidth',1.5)
colorbar
hold off

subplot(2,5,7)
dum = RHD_x;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
title('RHS F')
xline(xl(1,j),'--k','LineWidth',1.5)
colorbar
hold off

subplot(2,5,8)
dum = J_filt_x_B_filt_x;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
title('JxB F')
hold off

subplot(2,5,9)
dum = Div_Pe_filt_x./n_filt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
title('divPe/n F')
hold off

subplot(2,5,10)
dum = (Div_vJ_filt_x + Div_Jv_filt_x - Div_JJ_filt_x)./n_filt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
title('div(vJ+Jv-JJ/n F)')
hold off
sgtitle('$$ filtered $$','Interpreter','latex','FontSize',fs)
%----------------------------------------------------------------------


% This is the plot of the tensors
%----------------------------------------------------------------------
%i=30;j=30;
%----------------------------------------------------------------------
f12=figure(12);
subplot(2,4,1)
dum = -v_x_B_tau_x;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
ylim([-y_lim, y_lim]);
title('-tau(vxB)_x')
hold off

subplot(2,4,2)
dum = -nE_tau_x;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
ylim([-y_lim, y_lim]);
title('tau(nE)_x')
hold off

subplot(2,4,3)
dum = J_x_B_tau_x;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
ylim([-y_lim, y_lim]);
title('tau(JxB)_x')
hold off

subplot(2,4,4)
dum = Div_tau1_x;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
ylim([-y_lim, y_lim]);
title('tau(vJ+Jv-JJ))')
hold off
%----------------------------------------------------------------------
subplot(2,4,5)
dum = -v_x_B_tau_x;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
title('-tau(vxB)_x')
xline(xl(1,j),'--k','LineWidth',1.5)
colorbar
hold off

subplot(2,4,6)
dum = -nE_tau_x;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
title('tau(nE)_x')
xline(xl(1,j),'--k','LineWidth',1.5)
colorbar
hold off

subplot(2,4,7)
dum = J_x_B_tau_x;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
title('tau(JxB)_x')
hold off

subplot(2,4,8)
dum = Div_tau1_x;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
title('tau(vJ+Jv-JJ))')
hold off
% % %----------------------------------------------------------------------

cd(path)
saveas(f10,strcat(num2str(i),'Ohms_terms_regular.png'));
saveas(f11,strcat(num2str(i),'Ohms_terms_filterd.png'));
saveas(f12,strcat(num2str(i),'Ohms_terms_taus.png'));
% %----------------------------------------------------------------------
%}
% %----------------------------------------------------------------------
% %----------------------------------------------------------------------





% % % % % compute the fluctuating quantities (prime quantities)
% % % % %----------------------------------------------------------------------
%{
    % % % % %---------------------------------------------------------------------- 
    % % % % Bx_pri = Bx_dt - Bx_filt;
    % % % % By_pri = By_dt - By_filt;
    % % % % Bz_pri = Bz_dt - Bz_filt;    
    % % % % 
    % % % % Ex_pri = Ex_dt - Ex_filt;
    % % % % Ey_pri = Ey_dt - Ey_filt;
    % % % % Ez_pri = Ez_dt - Ez_filt;    
    % % % % 
    % % % % Jx_pri = Jx_dt - Jx_filt;
    % % % % Jy_pri = Jy_dt - Jy_filt;
    % % % % Jz_pri = Jz_dt - Jz_filt; 
    % % % % 
    % % % % % v_ix_pri = v_ix_dt - v_ix_filt;
    % % % % % v_iy_pri = v_iy_dt - v_iy_filt;
    % % % % % v_iz_pri = v_iz_dt - v_iz_filt;
    % % % % % 
    % % % % % v_ex_pri = v_ex_dt - v_ex_filt;
    % % % % % v_ey_pri = v_ey_dt - v_ey_filt;
    % % % % % v_ez_pri = v_ez_dt - v_ez_filt;    
    % % % % 
    % % % % v_x_pri = v_x_dt - v_x_filt;
    % % % % v_y_pri = v_y_dt - v_y_filt;
    % % % % v_z_pri = v_z_dt - v_z_filt;
    % % % % 
    % % % % n_e_pri = n_e0_dt - n_e_filt;
    % % % % n_i_pri = n_i0_dt - n_i_filt; 
    % % % % 
    % % % % Pij_exx_pri = Pij_exx_dt - Pij_exx_filt;
    % % % % Pij_exy_pri = Pij_exy_dt - Pij_exy_filt;
    % % % % Pij_exz_pri = Pij_exz_dt - Pij_exz_filt;
    % % % % Pij_eyy_pri = Pij_eyy_dt - Pij_eyy_filt;
    % % % % Pij_eyz_pri = Pij_eyz_dt - Pij_eyz_filt;
    % % % % Pij_ezz_pri = Pij_ezz_dt - Pij_ezz_filt;
    % % % % 
    % % % % Pij_ixx_pri = Pij_ixx_dt - Pij_ixx_filt;
    % % % % Pij_ixy_pri = Pij_ixy_dt - Pij_ixy_filt;
    % % % % Pij_ixz_pri = Pij_ixz_dt - Pij_ixz_filt;
    % % % % Pij_iyy_pri = Pij_iyy_dt - Pij_iyy_filt;
    % % % % Pij_iyz_pri = Pij_iyz_dt - Pij_iyz_filt;
    % % % % Pij_izz_pri = Pij_izz_dt - Pij_izz_filt;
    % % % % %----------------------------------------------------------------------  
    % % % % 
    % % % % 
    % % % % 
    % % % % % Double terms multifluid
    % % % % %----------------------------------------------------------------------
    % % % % BB_xx_dt = Bx_dt .* Bx_dt;
    % % % % BB_xy_dt = Bx_dt .* By_dt;
    % % % % BB_xz_dt = Bx_dt .* Bz_dt;
    % % % % BB_yy_dt = By_dt .* By_dt;
    % % % % BB_yz_dt = By_dt .* Bz_dt;
    % % % % BB_zz_dt = Bz_dt .* Bz_dt;
    % % % % 
    % % % % vivi_xx_dt = v_ix_dt .* v_ix_dt;
    % % % % vivi_xy_dt = v_ix_dt .* v_iy_dt;
    % % % % vivi_xz_dt = v_ix_dt .* v_iz_dt;
    % % % % vivi_yy_dt = v_iy_dt .* v_iy_dt;
    % % % % vivi_yz_dt = v_iy_dt .* v_iz_dt;
    % % % % vivi_zz_dt = v_iz_dt .* v_iz_dt;
    % % % % 
    % % % % veve_xx_dt = v_ex_dt .* v_ex_dt;
    % % % % veve_xy_dt = v_ex_dt .* v_ey_dt;
    % % % % veve_xz_dt = v_ex_dt .* v_ez_dt;
    % % % % veve_yy_dt = v_ey_dt .* v_ey_dt;
    % % % % veve_yz_dt = v_ey_dt .* v_ez_dt;
    % % % % veve_zz_dt = v_ez_dt .* v_ez_dt;
    % % % % %----------------------------------------------------------------------
    % % % % 
    % % % % % Filtering Double terms
    % % % % %----------------------------------------------------------------------
    % % % % BB_xx_filt = Filtering_kernel(BB_xx_dt,F_G_gs_n);
    % % % % BB_xy_filt = Filtering_kernel(BB_xy_dt,F_G_gs_n);
    % % % % BB_xz_filt = Filtering_kernel(BB_xz_dt,F_G_gs_n);
    % % % % BB_yy_filt = Filtering_kernel(BB_yy_dt,F_G_gs_n);
    % % % % BB_yz_filt = Filtering_kernel(BB_yz_dt,F_G_gs_n);
    % % % % BB_zz_filt = Filtering_kernel(BB_zz_dt,F_G_gs_n);
    % % % % 
    % % % % vivi_xx_filt = Filtering_kernel(vivi_xx_dt,F_G_gs_n);
    % % % % vivi_xy_filt = Filtering_kernel(vivi_xy_dt,F_G_gs_n);
    % % % % vivi_xz_filt = Filtering_kernel(vivi_xz_dt,F_G_gs_n);
    % % % % vivi_yy_filt = Filtering_kernel(vivi_yy_dt,F_G_gs_n);
    % % % % vivi_yz_filt = Filtering_kernel(vivi_yz_dt,F_G_gs_n);
    % % % % vivi_zz_filt = Filtering_kernel(vivi_zz_dt,F_G_gs_n);
    % % % % 
    % % % % veve_xx_filt = Filtering_kernel(veve_xx_dt,F_G_gs_n);
    % % % % veve_xy_filt = Filtering_kernel(veve_xy_dt,F_G_gs_n);
    % % % % veve_xz_filt = Filtering_kernel(veve_xz_dt,F_G_gs_n);
    % % % % veve_yy_filt = Filtering_kernel(veve_yy_dt,F_G_gs_n);
    % % % % veve_yz_filt = Filtering_kernel(veve_yz_dt,F_G_gs_n);
    % % % % veve_zz_filt = Filtering_kernel(veve_zz_dt,F_G_gs_n);
    % % % % %----------------------------------------------------------------------
    % % 
    % % % % % Define the Reynolds and Maxwell stress tensors
    % % % % %----------------------------------------------------------------------  
    % % % % %tau_vv = <vv> - <v><v>
    % % % % 
    % % % % tau_BB_xx = BB_xx_filt - Bx_filt.*Bx_filt; 
    % % % % tau_BB_xy = BB_xy_filt - Bx_filt.*By_filt;
    % % % % tau_BB_xz = BB_xz_filt - Bx_filt.*Bz_filt; 
    % % % % tau_BB_yy = BB_yy_filt - By_filt.*By_filt;
    % % % % tau_BB_yz = BB_yz_filt - By_filt.*Bz_filt; 
    % % % % tau_BB_zz = BB_zz_filt - Bz_filt.*Bz_filt; 
    % % % % 
    % % % % tau_veve_xx = veve_xx_filt - v_ex_filt.*v_ex_filt; 
    % % % % tau_veve_xy = veve_xy_filt - v_ex_filt.*v_ey_filt;
    % % % % tau_veve_xz = veve_xz_filt - v_ex_filt.*v_ez_filt; 
    % % % % tau_veve_yy = veve_yy_filt - v_ey_filt.*v_ey_filt;
    % % % % tau_veve_yz = veve_yz_filt - v_ey_filt.*v_ez_filt; 
    % % % % tau_veve_zz = veve_zz_filt - v_ez_filt.*v_ez_filt; 
    % % % % 
    % % % % tau_vivi_xx = vivi_xx_filt - v_ix_filt.*v_ix_filt; 
    % % % % tau_vivi_xy = vivi_xy_filt - v_ix_filt.*v_iy_filt;
    % % % % tau_vivi_xz = vivi_xz_filt - v_ix_filt.*v_iz_filt; 
    % % % % tau_vivi_yy = vivi_yy_filt - v_iy_filt.*v_iy_filt;
    % % % % tau_vivi_yz = vivi_yz_filt - v_iy_filt.*v_iz_filt; 
    % % % % tau_vivi_zz = vivi_zz_filt - v_iz_filt.*v_iz_filt;    
%}
% % % % %----------------------------------------------------------------------


% % Let's have a look a the quantities
% % Bx_dt is the unfilterd, B_filt is the filtered, B_pri is the
% % unresolved
% % %----------------------------------------------------------------------
% i=30;
% f1=figure(1);
% subplot(2,3,1)
% dump = squeeze(Bx_dt(:,:,i));
% y_lim = max(max(max(abs(dump))));
% hc=pcolor(dump);
% hold on
% set(hc,'edgecolor','none')
% clim([-y_lim y_lim]);
% title('Bx')
% colorbar
% hold off
%
% subplot(2,3,2)
% dump = squeeze(Bx_filt(:,:,i));
% hc=pcolor(dump);
% %y_lim = max(max(max(abs(dump))));
% hold on
% set(hc,'edgecolor','none')
% clim([-y_lim y_lim]);
% colorbar
% title('<Bx>')
% hold off
%
% subplot(2,3,3)
% dump = squeeze(Bx_pri(:,:,i));
% hc=pcolor(dump);
% %y_lim = max(max(max(abs(dump))));
% hold on
% set(hc,'edgecolor','none')
% clim([-y_lim y_lim]);
% colorbar
% title('Bx_{pri} ' )
% hold off
%
% subplot(2,3,4)
% dump = squeeze(v_ex_dt(:,:,i));
% y_lim = max(max(max(abs(dump))));
% hc=pcolor(dump);
% hold on
% set(hc,'edgecolor','none')
% clim([-y_lim y_lim]);
% title('vex')
% colorbar
% hold off
%
% subplot(2,3,5)
% dump = squeeze(v_ex_filt(:,:,i));
% hc=pcolor(dump);
% %y_lim = max(max(max(abs(dump))));
% hold on
% set(hc,'edgecolor','none')
% clim([-y_lim y_lim]);
% colorbar
% title('<vex>')
% hold off
%
% subplot(2,3,6)
% dump = squeeze(v_ex_pri(:,:,i));
% hc=pcolor(dump);
% %y_lim = max(max(max(abs(dump))));
% hold on
% set(hc,'edgecolor','none')
% clim([-y_lim y_lim]);
% colorbar
% title('vex_{pri}' )
% hold off
%
% % %----------------------------------------------------------------------



%----------------------------------------------------------------------
% This is to get the spectra
%----------------------------------------------------------------------
% [P2D_Bx,~]=Power_of_fFiltering_kernel(Bx_dt,Lx,Ly,Lz);
% [P2D_G_gs_n,~]= Power_of_filtering_kernel(G_gs_n,Lx,Ly,Lz);
% [P2D_convolution,kpar,kper,kz] = Power_of_filtering_kernel(convolution_result,Lx,Ly,Lz);
% [KPAR,KPER] = meshgrid(kpar,kper);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
% Plots the field to see how it looks with the filter
% y_lim = max(max(max(abs(Bx_dt))));
% %----------------------------------------------------------------------
% i=84;
% f3=figure(3);
% subplot(2,3,1)
% hc=pcolor(squeeze(Bx_dt(:,:,i)));
% hold on
% set(hc,'edgecolor','none')
% clim([-y_lim y_lim]);
% title('Bx')
% colorbar
% hold off
%
% subplot(2,3,2)
% hc=pcolor(squeeze(G_gs(:,:,i)));
% hold on
% set(hc,'edgecolor','none')
% %clim([-y_lim y_lim]);
% colorbar
% title('G')
% hold off
%
% subplot(2,3,3)
% y_lim_cv = max(max(max(abs(convolution_result(:,:,i)))));
% hc=pcolor(squeeze(convolution_result(:,:,i)));
% hold on
% set(hc,'edgecolor','none')
% clim([-y_lim_cv y_lim_cv]);
% colorbar
% title('Bx filtered')
% hold off
% %----------------------------------------------------------------------


% %This is to make the plots for the spectra
% %----------------------------------------------------------------------
% caxis_max = max(max(log(P2D_Bx)));
% caxis_min = min(min(log(P2D_Bx)));
%
% subplot(2,3,4);
% hc=pcolor(KPAR',KPER',log(P2D_Bx));
% hold on
% set(hc,'edgecolor','none')
% %set(gca, 'YScale', 'log', 'XScale', 'log')
% hold on
% colorbar
% title('log(P2D Bx)');
% xlabel('kpar'); ylabel('kper');
% %xlim([k_min,k_max])
% %ylim([k_min,k_max])
% clim([caxis_min, caxis_max])
% hold off
%
% subplot(2,3,5);
% hc=pcolor(KPAR',KPER',log(P2D_G_gs_n));
% hold on
% set(hc,'edgecolor','none')
% %set(gca, 'YScale', 'log', 'XScale', 'log')
% hold on
% colorbar
% title('log(P2D G)');
% xlabel('kpar'); ylabel('kper');
% %xlim([k_min,k_max])
% %ylim([k_min,k_max])
% clim([caxis_min, caxis_max])
% hold off
%
% subplot(2,3,6);
% hc=pcolor(KPAR',KPER',log(P2D_convolution));
% hold on
% set(hc,'edgecolor','none')
% %set(gca, 'YScale', 'log', 'XScale', 'log')
% hold on
% colorbar
% title('log(P2D Bx filtered)');
% xlabel('kpar'); ylabel('kper');
% %xlim([k_min,k_max])
% %ylim([k_min,k_max])
% clim([caxis_min, caxis_max])
% hold off
% %----------------------------------------------------------------------






% Defining the functions to use in this script
%----------------------------------------------------------------------

% Funtion to make the filtering
%----------------------------------------------------------------------
function [convolution_result]=Filtering_kernel(var,F_G_gs_n)
%----------------------------------------------------------------------
% The inputs are the variable, the fourier transform of the kernel and
% the output is the filted signal
% These four lines are the filtering

%----------------------------------------------------------------------
% Perform the FFT of the function f
F_var = fftn(var);
F_var = fftshift(fftshift(fftshift(F_var,1),2),3);

% Convolve in the frequency domain (element-wise multiplication)
F_G_gs_n = fftshift(fftshift(fftshift(F_G_gs_n,1),2),3);
F_convolution = F_var .* F_G_gs_n;
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
% Perform the FFT of the function f
F_Bx = fftn(Bx);

%Shift the ffts
F_Bx_shift = fftshift(fftshift(fftshift(F_Bx,1),2),3);
%F_Bx_shift = F_Bx; 

%Get the amplitudes
F_f_shift_amp = F_Bx_shift .* conj(F_Bx_shift);

%F_G_gs_n_shift = fftshift(fftshift(fftshift(F_G_gs_n,1),2),3);
%F_g_shift_amp = F_G_gs_n_shift .* conj(F_G_gs_n_shift);
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
%----------------------------------------------------------------------
end









