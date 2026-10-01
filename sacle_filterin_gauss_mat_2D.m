% this is for the 2D case only
%-----------------------------------------------------------------------------------------------------------------------

%path = '/Volumes/PSC_DiRAC_DATA/Data_Cirrus/turb_alf_2D'; 
path = '/Volumes/PSC_DiRAC_DATA/Data_Cirrus/turb_alf_2D_2';
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
%B0=0.2;
B0=0.5;
%n is normalise to the proton density n0=1
n0=1;
%Vi normalised to the proton alfven speed V_a=0.1c The alfven speed of
%electrons is Vae=10Vai
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
nb_n0 =0.1;
kb = 1.; mu0 =1.; c=1; q = 1;

Vai=0.2;
Vae=0.2;%0.2;
Va=0.2;%0.2;

Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);

mime = 100.;
mi = 1;
me = 1/mime; eps0=1.;
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
in=input('select the time stamp: ');

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

%in = 1;

%for in=1:floor(N)

%------------------------------------------------------------------
disp(strcat('Computing step ...',S(in).name))
fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;
grid_dt = info.Groups(20).Attributes;

% This is in de
grid_length = info.Groups(17).Attributes;
Lx=grid_length(4).Value(1) - grid_length(3).Value(1); %(The substraction give the total size of the domain) -Lx0 to Lx0
Ly=grid_length(4).Value(2) - grid_length(3).Value(2); % This is in de
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


N_L_2_P_L = input('select the geometric domain % -L to L (1): 0 to L (0) ');
if (N_L_2_P_L ==1)
% This is for the case from -L to L
%----------------------------------------------------------------------
xl = linspace(-Lx/2,Lx/2,LXs);
yl = linspace(-Ly/2,Ly/2,LYs);
zl = linspace(-Lz/2,Lz/2,LZs);
%----------------------------------------------------------------------
else
% This is for the case from 0 to L
%----------------------------------------------------------------------
xl = linspace(0,Lx,LXs);
yl = linspace(0,Ly,LYs);
zl = linspace(0,Lz,LZs);
%----------------------------------------------------------------------
end

% Here is where the parameter for the scale filtering are defined (the size of the window)
%----------------------------------------------------------------------
%----------------------------------------------------------------------
% define the window for the kernel and convolution

%for ndv =1:10
ndv = 1; % fractiopn of the box size. create a patch for the size of the convolution window
%l_wind_x = LXs/ndv; %size of the window

% This resolution is also in de
resx = Lx/LXs;
resy = Ly/LYs;
resz = Lz/LZs;
%----------------------------------------------------------------------

% Maybe it is better to define this in terms of the real resolution
%----------------------------------------------------------------------
%l_wind_x = (ndv/10)*Lx; %size of the window
l_wind_x = 4;
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
G_gs_n = G_gs./sum(G_gs(:)); % This is to ensure that the integral of the kernel is one
%G_gs_n = G_gs;

% Perform the FFT of the function g
F_G_gs_n = fftn(G_gs_n);
%----------------------------------------------------------------------
% This is to test


% % This is the core and bulky part. Do not erare!
% %----------------------------------------------------------------------
% %----------------------------------------------------------------------
%
%----------------------------------------------------------------------
B{1,1}=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'),start,count);
B{1,2}=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'),start,count);
B{1,3}=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'),start,count);
%B_0 = max(max(max(B{1,3})));
%B_0 = mean(B{1,3},'all');
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

% % % n_e0 = permute(n_e0,[2,1,3]);
% % % n_i0 = permute(n_i0,[2,1,3]);

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


% If the detrend is not need it ?
%----------------------------------------------------------------------
%----------------------------------------------------------------------
% This is how the derivatives should B computed. 
% The gradient with % y,x,z 
%It seems the problem is that the plot (PCOLOR) goes in the wrong direction. xl goes
%in the vertical and yl in the horizontal when doing the plot
%--------------------------------------------------------------------------
%{
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
%--------------------------------------------------------------------------
grad_fact=1;
[Bx_dt2_y, Bx_dt2_x, Bx_dt2_z] = gradient(imgaussfilt(Bx_dt ,sigma_g));
[By_dt2_y, By_dt2_x, By_dt2_z] = gradient(imgaussfilt(By_dt ,sigma_g));
[Bz_dt2_y, Bz_dt2_x, Bz_dt2_z] = gradient(imgaussfilt(Bz_dt ,sigma_g));

Div_B_dt2 = Bx_dt2_x/(grad_fact.*resx) + By_dt2_y/(grad_fact.*resy) + Bz_dt2_z/(grad_fact.*resz);

J_x2 = Bz_dt2_y/(grad_fact.*resy) - By_dt2_z/(grad_fact.*resz);
J_y2 = Bx_dt2_z/(grad_fact.*resz) - Bz_dt2_x/(grad_fact.*resx);
J_z2 = By_dt2_x/(grad_fact.*resx) - Bx_dt2_y/(grad_fact.*resy);
%--------------------------------------------------------------------------

%This figure show the agreement between J and curl B
%--------------------------------------------------------------------------
f5=figure(5);
subplot(1,3,1)
dum=Jx_dt;
dump = squeeze(dum(end,:,:));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
title('J_{x}')
subplot(1,3,2)
dum=J_x2;
dump = squeeze(dum(end,:,:));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
title('(\nabla \times B)_{x}')
subplot(1,3,3)
dum=Jx_dt;
dump = squeeze(dum(end,1,:));
plot(zl,dump,'-r');
hold on
dum=J_x2;
dump = squeeze(dum(end,1,:));
y_lim = max(max(max(abs(dump))));
plot(zl,dump,'-b');
ylim([-y_lim y_lim])
title('J_{x}')
%}
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%It seems the problem is that the plot (PCOLOR) goes in the wrong direction. xl goes
%in the vertical and yl in the horizontal when doing the plot
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%{
f2=figure(2);
subplot(3,3,1)
dum = Bx_dt2_x; 
dump = squeeze(dum(:,:,end));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
title('Bx_dt2_x')
colorbar
hold off

subplot(3,3,2)
dum = Bx_dt2_y; 
dump = squeeze(dum(:,:,end));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
title('Bx_dt2_y')
hold off

subplot(3,3,3)
dum = Bx_dt2_z; 
dump = squeeze(dum(:,:,end));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
title('Bx_dt2_z')
hold off

subplot(3,3,4)
dum = By_dt2_x; 
dump = squeeze(dum(:,:,end));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
title('By_dt2_x')
hold off

subplot(3,3,5)
dum = By_dt2_y; 
dump = squeeze(dum(:,:,end));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
title('By_dt2_y')
hold off

subplot(3,3,6)
dum = By_dt2_z; 
dump = squeeze(dum(:,:,end));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
title('By_dt2_z')
hold off

subplot(3,3,7)
dum = Bz_dt2_x; 
dump = squeeze(dum(:,:,end));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
title('Bz_dt2_x')
hold off

subplot(3,3,8)
dum = Bz_dt2_y; 
dump = squeeze(dum(:,:,end));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
title('Bz_dt2_y')
hold off

subplot(3,3,9)
dum = Bz_dt2_z; 
dump = squeeze(dum(:,:,end));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
title('Bz_dt2_z')
hold off
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
f3=figure(3);
subplot(3,3,1)
dum=Jx_dt;
%dum = Bx_dt2_x; 
dump = squeeze(dum(:,:,end));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
xlabel('xl')
ylabel('yl')
title('Jx_teo')

subplot(3,3,2)
dum=Jy_dt;
%dum = Bx_dt2_y; 
dump = squeeze(dum(:,:,end));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
xlabel('xl')
ylabel('yl')
title('Jy_teo')

subplot(3,3,3)
dum=Jz_dt;
%dum = Bx_dt2_z; 
dump = squeeze(dum(:,:,end));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
xlabel('xl')
ylabel('yl')
title('Jz_teo')

subplot(3,3,4)
dum=Jx_dt;
%dum = By_dt2_x; 
dump = squeeze(dum(:,end,:));% norm y
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,zl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
xlabel('xl')
ylabel('zl')
title('Jx_teo')

subplot(3,3,5)
dum=Jy_dt;
%dum = By_dt2_y; 
dump = squeeze(dum(:,end,:));% norm y
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,zl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
xlabel('xl')
ylabel('zl')
title('Jy_teo')

subplot(3,3,6)
dum=Jz_dt;
%dum = By_dt2_z; 
dump = squeeze(dum(:,end,:)); % norm y
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,zl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
xlabel('xl')
ylabel('zl')
title('Jz_teo')

subplot(3,3,7)
dum=Jx_dt;
%dum = Bz_dt2_x; 
dump = squeeze(dum(end,:,:));
y_lim = max(max(max(abs(dump))));
hc=pcolor(yl,zl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
xlabel('yl')
ylabel('zl')
title('Jx_teo')

subplot(3,3,8)
dum=Jy_dt;
%dum = Bz_dt2_y; 
dump = squeeze(dum(end,:,:));
y_lim = max(max(max(abs(dump))));
hc=pcolor(yl,zl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
xlabel('yl')
ylabel('zl')
title('Jy_teo')

subplot(3,3,9)
dum=Jz_dt;
%dum = Bz_dt2_z; 
dump = squeeze(dum(end,:,:));
y_lim = max(max(max(abs(dump))));
hc=pcolor(yl,zl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
xlabel('yl')
ylabel('zl')
title('Jz_teo')
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
f4=figure(4);
dum=Div_B_dt2;
dump = squeeze(dum(:,:,end));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
title('Div_B_dt2')
%--------------------------------------------------------------------------
%}
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

% Making the values 2D

Bx_dt = mean(Bx_dt,3);
By_dt = mean(By_dt,3);
Bz_dt = mean(Bz_dt,3);

Ex_dt = mean(Ex_dt,3);
Ey_dt = mean(Ey_dt,3);
Ez_dt = mean(Ez_dt,3);

Jx_dt = mean(Jx_dt,3);
Jy_dt = mean(Jy_dt,3);
Jz_dt = mean(Jz_dt,3);

v_x_dt = mean(v_x_dt,3);
v_y_dt = mean(v_y_dt,3);
v_z_dt = mean(v_z_dt,3);

Pij_ixx_dt=mean(Pij_ixx_dt,3);
Pij_ixy_dt=mean(Pij_ixy_dt,3);
Pij_ixz_dt=mean(Pij_ixz_dt,3);
Pij_iyy_dt=mean(Pij_iyy_dt,3);
Pij_iyz_dt=mean(Pij_iyz_dt,3);
Pij_izz_dt=mean(Pij_izz_dt,3);

Pij_exx_dt=mean(Pij_exx_dt,3);
Pij_exy_dt=mean(Pij_exy_dt,3);
Pij_exz_dt=mean(Pij_exz_dt,3);
Pij_eyy_dt=mean(Pij_eyy_dt,3);
Pij_eyz_dt=mean(Pij_eyz_dt,3);
Pij_ezz_dt=mean(Pij_ezz_dt,3);

% This is a plot to see if E and vxB are similar. But it seems they are not 
%--------------------------------------------------------------------------
%
v_x_B_x_dt = v_y_dt.*Bz_dt - v_z_dt.*By_dt;
v_x_B_y_dt = v_z_dt.*Bx_dt - v_x_dt.*Bz_dt;
v_x_B_z_dt = v_x_dt.*By_dt - v_y_dt.*Bx_dt;

J_x_B_x_dt = Jy_dt.*Bz_dt - Jz_dt.*By_dt;
J_x_B_y_dt = Jz_dt.*Bx_dt - Jx_dt.*Bz_dt;
J_x_B_z_dt = Jx_dt.*By_dt - Jy_dt.*Bx_dt;

i=1;

%{
f1=figure(1);
subplot(1,3,1)
dum=Ex_dt;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
title('Ex')
hold off

subplot(1,3,2)
dum=v_x_B_x_dt;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
title('vxBx')
hold off

subplot(1,3,3)
dum=Ex_dt;
dump = squeeze(dum(:,50,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'-r');
hold on
dum=v_x_B_x_dt/100;
dump = squeeze(dum(:,50,i));
plot(xl,dump,'-b');
dum=J_x_B_x_dt;
dump = squeeze(dum(:,50,i));
plot(xl,dump,'-g');
dum=-v_x_B_x_dt/100 + J_x_B_x_dt;
dump = squeeze(dum(:,50,i));
plot(xl,dump,'-k');
legend('Ex','vxBx','JxBx', 'RHS')
hold off
%}
%--------------------------------------------------------------------------


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


% It seems that there is a boundary problem with the 2D simulations. 
% Problably this can be deal with later. 


%--------------------------------------------------------------------------
% This part shows that the gradient and the divergence work well when the
% input array is well defined.
% Maybe the problem comes from the fact that the B field is not correctly
% set
% grad_fact = 1 is the correct definition
%--------------------------------------------------------------------------
%{
sigma_g = 1;
[Bx_dt2_y, Bx_dt2_x] = gradient(Bx_dt);%gradient(imgaussfilt(Bx_dt ,sigma_g));
[By_dt2_y, By_dt2_x] = gradient(By_dt);%gradient(imgaussfilt(By_dt ,sigma_g));
[Bz_dt2_y, Bz_dt2_x] = gradient(Bz_dt);%gradient(imgaussfilt(Bz_dt ,sigma_g));

Div_B_dt2 = Bx_dt2_x/(grad_fact.*resx) + By_dt2_y/(grad_fact.*resx);

J_x2 = Bz_dt2_y/(grad_fact.*resx) ;
J_y2 = - Bz_dt2_x/(grad_fact.*resx);
J_z2 = By_dt2_x/(grad_fact.*resx) - Bx_dt2_y/(grad_fact.*resx);

f4=figure(4);
subplot(1,3,1)
%dum = Bx_dt;
dum = Jx_dt;
dump = squeeze(dum(:,:)');
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
title('Jy_{teo}')
hold off
subplot(1,3,2)
dum = J_x2;
%dum = By_dt;
dump = squeeze(dum(:,:)');
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
title('Jy_{2}')
hold off
subplot(1,3,3)
dum=Div_B_dt2;
%dum=Bz_dt;
dump = squeeze(dum(:,:)');
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
title('DivB_{dt}')
hold off
%}
%--------------------------------------------------------------------

%----------------------------------------------------------------------
[Pij_exx_dt_y, Pij_exx_dt_x] = gradient(Pij_exx_dt);
[Pij_eyy_dt_y, Pij_eyy_dt_x] = gradient(Pij_eyy_dt);
[Pij_ezz_dt_y, Pij_ezz_dt_x] = gradient(Pij_ezz_dt);
[Pij_exy_dt_y, Pij_exy_dt_x] = gradient(Pij_exy_dt);
[Pij_exz_dt_y, Pij_exz_dt_x] = gradient(Pij_exz_dt);
[Pij_eyz_dt_y, Pij_eyz_dt_x] = gradient(Pij_eyz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    Div_Pe_dt_x = Pij_exx_dt_x/(grad_fact.*resx) + Pij_exy_dt_y/(grad_fact.*resy) ;
elseif (component == 2)
    Div_Pe_dt_y = Pij_exy_dt_x/(grad_fact.*resx) + Pij_eyy_dt_y/(grad_fact.*resy) ;
elseif (component == 3)
    Div_Pe_dt_z = Pij_exz_dt_x/(grad_fact.*resx) + Pij_eyz_dt_y/(grad_fact.*resy) ;
end
clearvars Pij_exx_dt_* Pij_exy_dt_* Pij_exz_dt_* ...
    Pij_eyy_dt_* Pij_eyz_dt_* Pij_ezz_dt_* ...
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[Pij_ixx_dt_y, Pij_ixx_dt_x] = gradient(Pij_ixx_dt);
[Pij_iyy_dt_y, Pij_iyy_dt_x] = gradient(Pij_iyy_dt);
[Pij_izz_dt_y, Pij_izz_dt_x] = gradient(Pij_izz_dt);
[Pij_ixy_dt_y, Pij_ixy_dt_x] = gradient(Pij_ixy_dt);
[Pij_ixz_dt_y, Pij_ixz_dt_x] = gradient(Pij_ixz_dt);
[Pij_iyz_dt_y, Pij_iyz_dt_x] = gradient(Pij_iyz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    Div_Pi_dt_x = Pij_ixx_dt_x/(grad_fact.*resx) + Pij_ixy_dt_y/(grad_fact.*resy) ;
elseif (component == 2)
    Div_Pi_dt_y = Pij_ixy_dt_x/(grad_fact.*resx) + Pij_iyy_dt_y/(grad_fact.*resy) ;
elseif (component == 3)
    Div_Pi_dt_z = Pij_ixz_dt_x/(grad_fact.*resx) + Pij_iyz_dt_y/(grad_fact.*resy) ;
end
clearvars Pij_ixx_dt_* Pij_ixy_dt_* Pij_ixz_dt_* ...
    Pij_iyy_dt_* Pij_iyz_dt_* Pij_izz_dt_* ...
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[v_J_dt_xx_y, v_J_dt_xx_x] = gradient(v_J_xx_dt);
[v_J_dt_xy_y, v_J_dt_xy_x] = gradient(v_J_xy_dt);
[v_J_dt_xz_y, v_J_dt_xz_x] = gradient(v_J_xz_dt);
[v_J_dt_yx_y, v_J_dt_yx_x] = gradient(v_J_yx_dt);
[v_J_dt_yy_y, v_J_dt_yy_x] = gradient(v_J_yy_dt);
[v_J_dt_yz_y, v_J_dt_yz_x] = gradient(v_J_yz_dt);
[v_J_dt_zx_y, v_J_dt_zx_x] = gradient(v_J_zx_dt);
[v_J_dt_zy_y, v_J_dt_zy_x] = gradient(v_J_zy_dt);
[v_J_dt_zz_y, v_J_dt_zz_x] = gradient(v_J_zz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
Div_vJ_dt_x = v_J_dt_xx_x/(grad_fact.*resx) + v_J_dt_yx_y/(grad_fact.*resy) ;
elseif (component == 2)
Div_vJ_dt_y = v_J_dt_xy_x/(grad_fact.*resx) + v_J_dt_yy_y/(grad_fact.*resy) ;
elseif (component == 3)
Div_vJ_dt_z = v_J_dt_xz_x/(grad_fact.*resx) + v_J_dt_yz_y/(grad_fact.*resy) ;
end

clearvars v_J_dt_xx_* v_J_dt_xy_* v_J_dt_xz_* ...
    v_J_dt_yx_* v_J_dt_yy_* v_J_dt_yz_* ...
    v_J_dt_zx_* v_J_dt_zy_* v_J_dt_zz_* 
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[J_v_dt_xx_y, J_v_dt_xx_x] = gradient(J_v_xx_dt);
[J_v_dt_xy_y, J_v_dt_xy_x] = gradient(J_v_xy_dt);
[J_v_dt_xz_y, J_v_dt_xz_x] = gradient(J_v_xz_dt);
[J_v_dt_yx_y, J_v_dt_yx_x] = gradient(J_v_yx_dt);
[J_v_dt_yy_y, J_v_dt_yy_x] = gradient(J_v_yy_dt);
[J_v_dt_yz_y, J_v_dt_yz_x] = gradient(J_v_yz_dt);
[J_v_dt_zx_y, J_v_dt_zx_x] = gradient(J_v_zx_dt);
[J_v_dt_zy_y, J_v_dt_zy_x] = gradient(J_v_zy_dt);
[J_v_dt_zz_y, J_v_dt_zz_x] = gradient(J_v_zz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
Div_Jv_dt_x = J_v_dt_xx_x/(grad_fact.*resx) + J_v_dt_yx_y/(grad_fact.*resy) ;
elseif (component == 2)
Div_Jv_dt_y = J_v_dt_xy_x/(grad_fact.*resx) + J_v_dt_yy_y/(grad_fact.*resy) ;
elseif (component == 3)
Div_Jv_dt_z = J_v_dt_xz_x/(grad_fact.*resx) + J_v_dt_yz_y/(grad_fact.*resy) ;
end

clearvars J_v_dt_xx_* J_v_dt_xy_* J_v_dt_xz_* ...
    J_v_dt_yx_* J_v_dt_yy_* J_v_dt_yz_* ...
    J_v_dt_zx_* J_v_dt_zy_* J_v_dt_zz_*
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[J_J_dt_xx_y, J_J_dt_xx_x] = gradient(J_J_2n_xx_dt);
[J_J_dt_xy_y, J_J_dt_xy_x] = gradient(J_J_2n_xy_dt);
[J_J_dt_xz_y, J_J_dt_xz_x] = gradient(J_J_2n_xz_dt);
[J_J_dt_yy_y, J_J_dt_yy_x] = gradient(J_J_2n_yy_dt);
[J_J_dt_yz_y, J_J_dt_yz_x] = gradient(J_J_2n_yz_dt);
[J_J_dt_zz_y, J_J_dt_zz_x] = gradient(J_J_2n_zz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
Div_JJ_dt_x = J_J_dt_xx_x/(grad_fact.*resx) + J_J_dt_xy_y/(grad_fact.*resy) ;
elseif (component == 2)
Div_JJ_dt_y = J_J_dt_xy_x/(grad_fact.*resx) + J_J_dt_yy_y/(grad_fact.*resy) ;
elseif (component == 3)
Div_JJ_dt_z = J_J_dt_xz_x/(grad_fact.*resx) + J_J_dt_yz_y/(grad_fact.*resy) ;
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

Pij_ixx_filt = imgaussfilt3(Pij_ixx_dt,l_wind_x);
Pij_ixy_filt = imgaussfilt3(Pij_ixy_dt,l_wind_x);
Pij_ixz_filt = imgaussfilt3(Pij_ixz_dt,l_wind_x);
Pij_iyy_filt = imgaussfilt3(Pij_iyy_dt,l_wind_x);
Pij_iyz_filt = imgaussfilt3(Pij_iyz_dt,l_wind_x);
Pij_izz_filt = imgaussfilt3(Pij_izz_dt,l_wind_x);

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
[Pij_exx_filt_y, Pij_exx_filt_x] = gradient(Pij_exx_filt);
[Pij_eyy_filt_y, Pij_eyy_filt_x] = gradient(Pij_eyy_filt);
[Pij_ezz_filt_y, Pij_ezz_filt_x] = gradient(Pij_ezz_filt);
[Pij_exy_filt_y, Pij_exy_filt_x] = gradient(Pij_exy_filt);
[Pij_exz_filt_y, Pij_exz_filt_x] = gradient(Pij_exz_filt);
[Pij_eyz_filt_y, Pij_eyz_filt_x] = gradient(Pij_eyz_filt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
Div_Pe_filt_x = Pij_exx_filt_x/(grad_fact.*resx) + Pij_exy_filt_y/(grad_fact.*resy) ;
elseif (component == 2)
Div_Pe_filt_y = Pij_exy_filt_x/(grad_fact.*resx) + Pij_eyy_filt_y/(grad_fact.*resy) ;
elseif (component == 3)
Div_Pe_filt_z = Pij_exz_filt_x/(grad_fact.*resx) + Pij_eyz_filt_y/(grad_fact.*resy) ;
end
clearvars Pij_exx_filt_* Pij_exy_filt_* Pij_exz_filt_* ...
    Pij_eyy_filt_* Pij_eyz_filt_* Pij_ezz_filt_* ...
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[Pij_ixx_filt_y, Pij_ixx_filt_x] = gradient(Pij_ixx_filt);
[Pij_iyy_filt_y, Pij_iyy_filt_x] = gradient(Pij_iyy_filt);
[Pij_izz_filt_y, Pij_izz_filt_x] = gradient(Pij_izz_filt);
[Pij_ixy_filt_y, Pij_ixy_filt_x] = gradient(Pij_ixy_filt);
[Pij_ixz_filt_y, Pij_ixz_filt_x] = gradient(Pij_ixz_filt);
[Pij_iyz_filt_y, Pij_iyz_filt_x] = gradient(Pij_iyz_filt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
Div_Pi_filt_x = Pij_ixx_filt_x/(grad_fact.*resx) + Pij_ixy_filt_y/(grad_fact.*resy) ;
elseif (component == 2)
Div_Pi_filt_y = Pij_ixy_filt_x/(grad_fact.*resx) + Pij_iyy_filt_y/(grad_fact.*resy) ;
elseif (component == 3)
Div_Pi_filt_z = Pij_ixz_filt_x/(grad_fact.*resx) + Pij_iyz_filt_y/(grad_fact.*resy) ;
end
clearvars Pij_ixx_filt_* Pij_ixy_filt_* Pij_ixz_filt_* ...
    Pij_iyy_filt_* Pij_iyz_filt_* Pij_izz_filt_* ...
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[v_filt_J_filt_xx_y, v_filt_J_filt_xx_x] = gradient(v_filt_J_filt_xx);
[v_filt_J_filt_xy_y, v_filt_J_filt_xy_x] = gradient(v_filt_J_filt_xy);
[v_filt_J_filt_xz_y, v_filt_J_filt_xz_x] = gradient(v_filt_J_filt_xz);
[v_filt_J_filt_yx_y, v_filt_J_filt_yx_x] = gradient(v_filt_J_filt_yx);
[v_filt_J_filt_yy_y, v_filt_J_filt_yy_x] = gradient(v_filt_J_filt_yy);
[v_filt_J_filt_yz_y, v_filt_J_filt_yz_x] = gradient(v_filt_J_filt_yz);
[v_filt_J_filt_zx_y, v_filt_J_filt_zx_x] = gradient(v_filt_J_filt_zx);
[v_filt_J_filt_zy_y, v_filt_J_filt_zy_x] = gradient(v_filt_J_filt_zy);
[v_filt_J_filt_zz_y, v_filt_J_filt_zz_x] = gradient(v_filt_J_filt_zz);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
Div_vJ_filt_x = v_filt_J_filt_xx_x/(grad_fact.*resx) + v_filt_J_filt_yx_y/(grad_fact.*resy) ;
elseif (component == 2)
Div_vJ_filt_y = v_filt_J_filt_xy_x/(grad_fact.*resx) + v_filt_J_filt_yy_y/(grad_fact.*resy) ;
elseif (component == 3)
Div_vJ_filt_z = v_filt_J_filt_xz_x/(grad_fact.*resx) + v_filt_J_filt_yz_y/(grad_fact.*resy) ;
end

clearvars v_filt_J_filt_xx_* v_filt_J_filt_xy_* v_filt_J_filt_xz_* ...
    v_filt_J_filt_yx_* v_filt_J_filt_yy_* v_filt_J_filt_yz_* ...
    v_filt_J_filt_zx_* v_filt_J_filt_zy_* v_filt_J_filt_zz_* 
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[J_filt_v_filt_xx_y, J_filt_v_filt_xx_x] = gradient(J_filt_v_filt_xx);
[J_filt_v_filt_xy_y, J_filt_v_filt_xy_x] = gradient(J_filt_v_filt_xy);
[J_filt_v_filt_xz_y, J_filt_v_filt_xz_x] = gradient(J_filt_v_filt_xz);
[J_filt_v_filt_yx_y, J_filt_v_filt_yx_x] = gradient(J_filt_v_filt_yx);
[J_filt_v_filt_yy_y, J_filt_v_filt_yy_x] = gradient(J_filt_v_filt_yy);
[J_filt_v_filt_yz_y, J_filt_v_filt_yz_x] = gradient(J_filt_v_filt_yz);
[J_filt_v_filt_zx_y, J_filt_v_filt_zx_x] = gradient(J_filt_v_filt_zx);
[J_filt_v_filt_zy_y, J_filt_v_filt_zy_x] = gradient(J_filt_v_filt_zy);
[J_filt_v_filt_zz_y, J_filt_v_filt_zz_x] = gradient(J_filt_v_filt_zz);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
Div_Jv_filt_x = J_filt_v_filt_xx_x/(grad_fact.*resx) + J_filt_v_filt_yx_y/(grad_fact.*resy) ;
elseif (component == 2)
Div_Jv_filt_y = J_filt_v_filt_xy_x/(grad_fact.*resx) + J_filt_v_filt_yy_y/(grad_fact.*resy) ;
elseif (component == 3)
Div_Jv_filt_z = J_filt_v_filt_xz_x/(grad_fact.*resx) + J_filt_v_filt_yz_y/(grad_fact.*resy) ;
end

clearvars J_filt_v_filt_xx_* J_filt_v_filt_xy_* J_filt_v_filt_xz_* ...
    J_filt_v_filt_yx_* J_filt_v_filt_yy_* J_filt_v_filt_yz_* ...
    J_filt_v_filt_zx_* J_filt_v_filt_zy_* J_filt_v_filt_zz_*
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[J_filt_J_filt_xx_y, J_filt_J_filt_xx_x] = gradient(J_filt_J_filt_2n_xx);
[J_filt_J_filt_xy_y, J_filt_J_filt_xy_x] = gradient(J_filt_J_filt_2n_xy);
[J_filt_J_filt_xz_y, J_filt_J_filt_xz_x] = gradient(J_filt_J_filt_2n_xz);
[J_filt_J_filt_yy_y, J_filt_J_filt_yy_x] = gradient(J_filt_J_filt_2n_yy);
[J_filt_J_filt_yz_y, J_filt_J_filt_yz_x] = gradient(J_filt_J_filt_2n_yz);
[J_filt_J_filt_zz_y, J_filt_J_filt_zz_x] = gradient(J_filt_J_filt_2n_zz);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
Div_JJ_filt_2n_x = J_filt_J_filt_xx_x/(grad_fact.*resx) + J_filt_J_filt_xy_y/(grad_fact.*resy) ;
elseif (component == 2)
Div_JJ_filt_2n_y = J_filt_J_filt_xy_x/(grad_fact.*resx) + J_filt_J_filt_yy_y/(grad_fact.*resy) ;
elseif (component == 3)
Div_JJ_filt_2n_z = J_filt_J_filt_xz_x/(grad_fact.*resx) + J_filt_J_filt_yz_y/(grad_fact.*resy) ;
end

clearvars J_filt_J_filt_xx_* J_filt_J_filt_xy_* J_filt_J_dt_xz_* ...
    J_filt_J_dt_yy_* J_filt_J_dt_yz_* J_filt_J_dt_zz_* 
%----------------------------------------------------------------------

%----------------------------------------------------------------------
clearvars v_filt_J_filt_* J_filt_v_filt_* J_filt_J_filt_*
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[sub_tau1_xx_y, sub_tau1_xx_x] = gradient(sub_tau1_xx);
[sub_tau1_xy_y, sub_tau1_xy_x] = gradient(sub_tau1_xy);
[sub_tau1_xz_y, sub_tau1_xz_x] = gradient(sub_tau1_xz);
[sub_tau1_yx_y, sub_tau1_yx_x] = gradient(sub_tau1_yx);
[sub_tau1_yy_y, sub_tau1_yy_x] = gradient(sub_tau1_yy);
[sub_tau1_yz_y, sub_tau1_yz_x] = gradient(sub_tau1_yz);
[sub_tau1_zx_y, sub_tau1_zx_x] = gradient(sub_tau1_zx);
[sub_tau1_zy_y, sub_tau1_zy_x] = gradient(sub_tau1_zy);
[sub_tau1_zz_y, sub_tau1_zz_x] = gradient(sub_tau1_zz);
%----------------------------------------------------------------------


% % % Now let's compute the tensors
%----------------------------------------------------------------------
if (component == 1)
%(<nE> - <n><E>)/<n>
% % %----------------------------------------------------------------------
tau_nE_tau_x = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*Ex_dt,l_wind_x))./n_filt - Ex_filt);
%(<nevxB> - <n><v>x<B>)/<ne>
% % %----------------------------------------------------------------------
tau_v_x_B_tau_x = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*v_x_B_x_dt,l_wind_x))./n_filt - v_filt_x_B_filt_x);
%(<nevxB> - <n><J>x<B>)/<ne>
%----------------------------------------------------------------------
tau_J_x_B_tau_x = (B0*c)^(1)*((imgaussfilt3(J_x_B_x_dt,l_wind_x) - J_filt_x_B_filt_x)./n_filt);
%----------------------------------------------------------------------
Div_sub_tau1_x = sub_tau1_xx_x/(grad_fact.*resx) + sub_tau1_yx_y/(grad_fact.*resy) ;
%----------------------------------------------------------------------
tau_Div_tau1_x = me*c*c*(me.*(imgaussfilt3(Div_sub_tau1_x,l_wind_x) - (Div_vJ_filt_x + Div_Jv_filt_x - Div_JJ_filt_2n_x))./n_filt);
% % %----------------------------------------------------------------------
elseif (component == 2)
% % %----------------------------------------------------------------------
tau_nE_tau_y = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*Ey_dt,l_wind_x))./n_filt - Ey_filt);
% % %----------------------------------------------------------------------
tau_v_x_B_tau_y = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*v_x_B_y_dt,l_wind_x))./n_filt - v_filt_x_B_filt_y);
% % %----------------------------------------------------------------------
tau_J_x_B_tau_y = (B0*c)^(1)*((imgaussfilt3(J_x_B_y_dt,l_wind_x) - J_filt_x_B_filt_y)./n_filt);
% % %----------------------------------------------------------------------
Div_sub_tau1_y = sub_tau1_xy_x/(grad_fact.*resx) + sub_tau1_yy_y/(grad_fact.*resy) ;
% % %----------------------------------------------------------------------
tau_Div_tau1_y = me*c*c*(me.*(imgaussfilt3(Div_sub_tau1_y,l_wind_x) - (Div_vJ_filt_y + Div_Jv_filt_y - Div_JJ_filt_2n_y))./n_filt);
elseif (component == 3)
% % %----------------------------------------------------------------------
tau_nE_tau_z = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*Ez_dt,l_wind_x))./n_filt - Ez_filt);
% % %----------------------------------------------------------------------
tau_v_x_B_tau_z = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*v_x_B_z_dt,l_wind_x))./n_filt - v_filt_x_B_filt_z);
% % %----------------------------------------------------------------------
tau_J_x_B_tau_z = (B0*c)^(1)*((imgaussfilt3(J_x_B_z_dt,l_wind_x) - J_filt_x_B_filt_z)./n_filt);
% % %----------------------------------------------------------------------
Div_sub_tau1_z = sub_tau1_xz_x/(grad_fact.*resx) + sub_tau1_yz_y/(grad_fact.*resy) ;
%----------------------------------------------------------------------
tau_Div_tau1_z = me*c*c*(me.*(imgaussfilt3(Div_sub_tau1_z,l_wind_x) - (Div_vJ_filt_z + Div_Jv_filt_z - Div_JJ_filt_2n_z))./n_filt);
%----------------------------------------------------------------------
end

clearvars sub_t*

% Normalization values
%----------------------------------------------------------------------
B_mod_dt = sqrt(Bx_dt.^2 + By_dt.^2 + Bz_dt.^2);
B0 = mean(B_mod_dt,'all');
n0 = mean(n_0_dt,'all');
mu0 = 1;
v_a = B0./sqrt(mu0 * n0);
c = v_a;
me = 1/100;
%----------------------------------------------------------------------


%ext_fact = sqrt(1/mime);
if (component == 1)
% For the x component
%----------------------------------------------------------------------
% terms from the owns law with no signs
%----------------------------------------------------------------------
term1_dt_x = B0*c*(Ex_dt);
term2_dt_x = B0*c*(v_x_B_x_dt);
term3_dt_x = B0*c*J_x_B_x_dt./n_0_dt;
term4_dt_x = n0*c*c*(Div_Pe_dt_x./n_0_dt);
term5_dt_x = me*c*c*((Div_vJ_dt_x + Div_Jv_dt_x - Div_JJ_dt_x)./n_0_dt);
%term4_dt_x = ext_fact*(mi*omega_pi*c)*(Div_Pe_dt_x./n_0_dt);
%term5_dt_x = B0*(mi*omega_pi*c/mime)*((Div_vJ_dt_x + Div_Jv_dt_x - Div_JJ_dt_x)./n_0_dt);
%----------------------------------------------------------------------
LHD_dt_x = term1_dt_x + term2_dt_x;
RHD_dt_x = term3_dt_x - term4_dt_x + term5_dt_x;
%----------------------------------------------------------------------

%----------------------------------------------------------------------
term1_filt_x = B0*c*(Ex_filt);
term2_filt_x = B0*c*(v_filt_x_B_filt_x);
term3_filt_x = B0*c*J_filt_x_B_filt_x./n_filt;
term4_filt_x = n0*c*c*(Div_Pe_filt_x./n_filt);
term5_filt_x = me*c*c*((Div_vJ_filt_x + Div_Jv_filt_x - Div_JJ_filt_2n_x)./n_filt);
%term4_filt_x = ext_fact*(mi*omega_pi*c)*(Div_Pe_filt_x./n_filt);
%term5_filt_x = B0*(mi*omega_pi*c/mime)*((Div_vJ_filt_x + Div_Jv_filt_x - Div_JJ_filt_2n_x)./n_filt);
%----------------------------------------------------------------------
LHD_filt_x = term1_filt_x + term2_filt_x;
RHD_filt_x = term3_filt_x - term4_filt_x + term5_filt_x;
%----------------------------------------------------------------------

elseif (component == 2)
% For the y component
%----------------------------------------------------------------------
%
% terms from the owns law with no signs
%----------------------------------------------------------------------
term1_dt_x = B0*c*(Ey_dt);
term2_dt_x = B0*c*(v_x_B_y_dt);
term3_dt_x = B0*c*J_x_B_y_dt./n_0_dt;
term4_dt_x = n0*c*c*(Div_Pe_dt_y./n_0_dt);
term5_dt_x = me*c*c*((Div_vJ_dt_y + Div_Jv_dt_y - Div_JJ_dt_y)./n_0_dt);
%----------------------------------------------------------------------
LHD_dt_x = term1_dt_x + term2_dt_x;
RHD_dt_x = term3_dt_x - term4_dt_x + term5_dt_x;
%----------------------------------------------------------------------

% terms from the owns law with no signs
%----------------------------------------------------------------------
term1_filt_x = B0*c*(Ey_filt);
term2_filt_x = B0*c*(v_filt_x_B_filt_y);
term3_filt_x = B0*c*J_filt_x_B_filt_y./n_filt;
term4_filt_x = n0*c*c*(Div_Pe_filt_y./n_filt);
term5_filt_x = me*c*c*((Div_vJ_filt_y + Div_Jv_filt_y - Div_JJ_filt_2n_y)./n_filt);
%----------------------------------------------------------------------
LHD_filt_x = term1_filt_x + term2_filt_x;
RHD_filt_x = term3_filt_x - term4_filt_x + term5_filt_x;
%----------------------------------------------------------------------
%}
%----------------------------------------------------------------------
elseif (component == 3)
% For the z component
%----------------------------------------------------------------------
%
% terms from the owns law with no signs
%----------------------------------------------------------------------
term1_dt_x = B0*c*(Ez_dt);
term2_dt_x = B0*c*(v_x_B_z_dt);
term3_dt_x = B0*c*J_x_B_z_dt./n_0_dt;
term4_dt_x = n0*c*c*(Div_Pe_dt_z./n_0_dt);
term5_dt_x = me*c*c*((Div_vJ_dt_z + Div_Jv_dt_z - Div_JJ_dt_z)./n_0_dt);
%----------------------------------------------------------------------
LHD_dt_x = term1_dt_x + term2_dt_x;
RHD_dt_x = term3_dt_x - term4_dt_x + term5_dt_x;
%----------------------------------------------------------------------

% terms from the owns law with no signs
%----------------------------------------------------------------------
term1_filt_x = B0*c*(Ez_filt);
term2_filt_x = B0*c*(v_filt_x_B_filt_z);
term3_filt_x = B0*c*J_filt_x_B_filt_z./n_filt;
term4_filt_x = n0*c*c*(Div_Pe_filt_z./n_filt);
term5_filt_x = me*c*c*((Div_vJ_filt_z + Div_Jv_filt_z - Div_JJ_filt_2n_z)./n_filt);
%----------------------------------------------------------------------
LHD_filt_x = term1_filt_x + term2_filt_x;
RHD_filt_x = term3_filt_x - term4_filt_x + term5_filt_x;
%----------------------------------------------------------------------
%}
end
%----------------------------------------------------------------------


%----------------------------------------------------------------------
% plot of the component x of the electric field
%----------------------------------------------------------------------
%
fs=20; x0=45;y0=54;xx1=1200;yy1=500;

legends_x = {'$E$', '$v \times B$','$\frac{J \times B}{ne}$',...
    '$\frac{\nabla \cdot P_{e}}{ne}$','$\frac{m_{e}\nabla \cdot (vJ + Jv - JJ/ne)}{ne^{2}}$',...
    '$RHS$'};

i=50; j=50;

f1=figure(1)
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(1,2,1)
dum = term1_dt_x;
dump = squeeze(dum(:,i));
plot(xl,dump,'-r',LineWidth=1.5)
hold on
dum = -term2_dt_x;
dump = squeeze(dum(:,i));
plot(xl,dump,'-b',LineWidth=1.5)
dum = term3_dt_x;
dump = squeeze(dum(:,i));
plot(xl,dump,'-g',LineWidth=1.5)
dum = -term4_dt_x;
dump = squeeze(dum(:,i));
plot(xl,dump,'-m',LineWidth=1.5)
dum = term5_dt_x;
dump = squeeze(dum(:,i));
plot(xl,dump,'-c',LineWidth=1.5)
dum = -term2_dt_x + term3_dt_x -term4_dt_x + term5_dt_x;
dump = squeeze(dum(:,i));
plot(xl,dump,'--k',LineWidth=1.5)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_e$';
ax.YLabel.String = '$E$';
legend(legends_x ,'Interpreter','latex','NumColumns',1,'Location','southwest')
title('Unfilterd','Interpreter','latex')
%xlim([-15.2,15.2])
hold off

subplot(1,2,2)
dum = term1_filt_x;
dump = squeeze(dum(:,i));
plot(xl,dump,'-r',LineWidth=1.5)
hold on
dum = -term2_filt_x;
dump = squeeze(dum(:,i));
plot(xl,dump,'-b',LineWidth=1.5)
dum = term3_filt_x;
dump = squeeze(dum(:,i));
plot(xl,dump,'-g',LineWidth=1.5)
dum = -term4_filt_x;
dump = squeeze(dum(:,i));
plot(xl,dump,'-m',LineWidth=1.5)
dum = term5_filt_x;
dump = squeeze(dum(:,i));
plot(xl,dump,'-c',LineWidth=1.5)
dum = -term2_filt_x + term3_filt_x -term4_filt_x + term5_filt_x;
dump = squeeze(dum(:,i));
plot(xl,dump,'--k',LineWidth=1.5)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_e$';
ax.YLabel.String = '$E$';
legend(legends_x ,'Interpreter','latex','NumColumns',1,'Location','southwest')
title('Filterd','Interpreter','latex')
%xlim([-15.2,15.2])
hold off
%}
%----------------------------------------------------------------------


