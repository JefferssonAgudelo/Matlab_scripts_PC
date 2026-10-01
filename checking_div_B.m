
% This is to compute the Ohms law terms for the PIC simulations 
%-----------------------------------------------------------------------------------------------------------------------
path = '/home/UNN/pfcy6/DATA_CIRRUS/turb_alf_cam_3D';
path = '/home/UNN/pfcy6/DATA_CIRRUS/turb_alf_jeff_2D_beta1_test';
path = '/home/UNN/pfcy6/DATA_CIRRUS/turb_alf_jeff_2D_beta1_test/beta_001_01';

%-----------------------------------------------------------------------------------------------------------------------

% For the scripts

path_s  = '/home/UNN/pfcy6/codes/processing_scripts/Matlab_Scripts_Laptop/Scripts_spectra';
path_s2 = '/home/UNN/pfcy6/codes/processing_scripts/Matlab_Scripts_Laptop/scale_filtering_average';
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

% %------------------------------------------------------------------
% disp(strcat('Computing step ...',S2(jjn).name))
% fileID2 =  S2(jjn).name; %change the 1 per i
% %h5disp(fileID2);
% info2 = h5info(fileID2);
% moments_1st = info2.Groups(1).Name;
% %----------------------------------------------------------------------

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
l_wind_x = 4; %input('Window size:');
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

%B{1,1}=h5read(fileID,strcat(EHJ_1st,'/ex_ec/p0/3d'),start,count);
%B{1,2}=h5read(fileID,strcat(EHJ_1st,'/ey_ec/p0/3d'),start,count);
%B{1,3}=h5read(fileID,strcat(EHJ_1st,'/ez_ec/p0/3d'),start,count);
%----------------------------------------------------------------------


% % Define grid spacings
% Dx = 0.1; % Grid spacing in x-direction
% Dy = 0.1; % Grid spacing in y-direction
% Dz = 0.1; % Grid spacing in z-direction
% 
% % Load or define the magnetic field components Bx, By, Bz
% % Example: Random data for demonstration
% Nx = 100; Ny = 100; Nz = 100;
% Bx = rand(Nx, Ny, Nz);
% By = rand(Nx, Ny, Nz);
% Bz = rand(Nx, Ny, Nz);


%--------------------------------------------------------------------------
Dx = resx; % Grid spacing in x-direction
Dy = resy; % Grid spacing in y-direction
Dz = resz; % Grid spacing in z-direction

Bx = B{1,1};
By = B{1,2};
Bz = B{1,3};

% Compute the divergence
divergence_B= computeDivergence(Bx, By, Bz, Dx, Dy, Dz);

% Compute the divergence using Fourier transforms
divergence_FFTB  = computeDivergenceFFT(Bx, By, Bz, Lx, Ly, Lz);

% Compute the divergence using Fourier transforms 2D
divergence_FFT2DB = computeDivergenceFFT2D(squeeze(Bx(:,1,:)), squeeze(Bz(:,1,:)), Lx, Lz);

divergence_staggered = computeDivergenceYee(Bx, By, Bz, Dx, Dy, Dz);

divergence_naive = computeDivergenceNaive(Bx, By, Bz, Dx, Dy, Dz);

% Visualize or analyze the results
disp('Maximum absolute divergence:');
disp(max(abs(divergence_FFTB(:))));

% Visualize or analyze the results
disp('Maximum absolute divergence:');
disp(max(abs(divergence_B(:))));

% Make a plot of the divergence

f1=figure(1);
subplot(1,4,1)
hc = pcolor(squeeze(Bx(:,1,:))');
set(hc,'edgecolor','none')
colorbar
title('Bx')
subplot(1,4,2)
hc = pcolor(squeeze(By(:,1,:))');
set(hc,'edgecolor','none')
colorbar
title('By')
subplot(1,4,3)
hc = pcolor(squeeze(Bz(:,1,:))');
set(hc,'edgecolor','none')
colorbar
title('Bz')
subplot(1,4,4)
hc = pcolor(squeeze(divergence_staggered(:,1,:))');
set(hc,'edgecolor','none')
colorbar
title('Div B')

f2=figure(2);
subplot(2,2,1)
hc = pcolor(squeeze(divergence_B(:,1,:))');
set(hc,'edgecolor','none')
colorbar
title('div B CD')
subplot(2,2,2)
hc = pcolor(squeeze(divergence_FFT2DB(:,:))');
set(hc,'edgecolor','none')
colorbar
title('div B FFT2D')
subplot(2,2,3)
hc = pcolor(squeeze(divergence_staggered(:,1,:))');
set(hc,'edgecolor','none')
colorbar
title('div B Yee-grid')
subplot(2,2,4)
hc = pcolor(squeeze(divergence_naive(:,1,:))');
set(hc,'edgecolor','none')
colorbar
title('div B CD2')
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------

% %--------------------------------------------------------------------------
% % Parameters
% Lx = 2 * pi; % Length in the x-direction
% Ly = 2 * pi; % Length in the y-direction
% Lz = 2 * pi; % Length in the z-direction
% Nx = 64; % Number of grid points in x
% Ny = 64; % Number of grid points in y
% Nz = 64; % Number of grid points in z
% 
% % Define grid spacings
% Dx = Lx / Nx;
% Dy = Ly / Ny;
% Dz = Lz / Nz;
% 
% % Define staggered Yee grid
% x = (0:Nx-1) * Dx; % Grid for Bx
% y = (0:Ny-1) * Dy; % Grid for By
% z = (0:Nz-1) * Dz; % Grid for Bz
% x_centered = x + Dx / 2; % Midpoints in x
% y_centered = y + Dy / 2; % Midpoints in y
% z_centered = z + Dz / 2; % Midpoints in z
% 
% % Construct a divergence-free magnetic field on the staggered Yee grid
% [X, Y, Z] = ndgrid(x, y_centered, z_centered); % Staggered for Bx
% Bx = cos(Y) .* sin(Z); % Bx component
% 
% [X, Y, Z] = ndgrid(x_centered, y, z_centered); % Staggered for By
% By = cos(Z) .* sin(X); % By component
% 
% [X, Y, Z] = ndgrid(x_centered, y_centered, z); % Staggered for Bz
% Bz = cos(X) .* sin(Y); % Bz component
% 
% % Compute divergence on the Yee grid (staggered)
% divergence_staggered = computeDivergenceYee(Bx, By, Bz, Dx, Dy, Dz);
% 
% % Compute divergence ignoring the Yee grid staggering
% divergence_naive = computeDivergenceNaive(Bx, By, Bz, Dx, Dy, Dz);
% 
% % Display maximum absolute divergence for comparison
% disp('Maximum absolute divergence on staggered grid (Yee):');
% disp(max(abs(divergence_staggered(:)))); % Should be zero
% disp('Maximum absolute divergence on naive grid:');
% disp(max(abs(divergence_naive(:)))); % Should not be zero
% 
% f3=figure(3);
% subplot(2,2,1)
% hc = pcolor(squeeze(divergence_naive(:,1,:))');
% set(hc,'edgecolor','none')
% colorbar
% subplot(2,2,2)
% hc = pcolor(squeeze(divergence_staggered(:,1,:))');
% set(hc,'edgecolor','none')
% colorbar
% %--------------------------------------------------------------------------


% Functions for divergence computation
function divergence = computeDivergenceYee(Bx, By, Bz, Dx, Dy, Dz)
    % Compute divergence using the staggered Yee grid
    [Nx, Ny, Nz] = size(Bx);
    
    % Derivatives using staggered differences
    dBx_dx = (Bx(2:Nx, :, :) - Bx(1:Nx-1, :, :)) / Dx;
    dBy_dy = (By(:, 2:Ny, :) - By(:, 1:Ny-1, :)) / Dy;
    dBz_dz = (Bz(:, :, 2:Nz) - Bz(:, :, 1:Nz-1)) / Dz;
    
    % Extend to match original array sizes
    dBx_dx = padarray(dBx_dx, [1, 0, 0], 'post');
    dBy_dy = padarray(dBy_dy, [0, 1, 0], 'post');
    dBz_dz = padarray(dBz_dz, [0, 0, 1], 'post');
    
    % Compute divergence
    divergence = dBx_dx + dBy_dy + dBz_dz;
end

function divergence = computeDivergenceNaive(Bx, By, Bz, Dx, Dy, Dz)
    % Compute divergence ignoring the Yee grid staggering
    [Nx, Ny, Nz] = size(Bx);
    
    % Derivatives using central differences
    dBx_dx = zeros(size(Bx));
    dBy_dy = zeros(size(By));
    dBz_dz = zeros(size(By));
    
    dBx_dx(2:Nx-1, :, :) = (Bx(3:Nx, :, :) - Bx(1:Nx-2, :, :)) / (2 * Dx);
    dBy_dy(:, 2:Ny-1, :) = (By(:, 3:Ny, :) - By(:, 1:Ny-2, :)) / (2 * Dy); 
    dBz_dz(:, :, 2:Nz-1) = (Bz(:, :, 3:Nz) - Bz(:, :, 1:Nz-2)) / (2 * Dz);
    
    % Compute divergence
    divergence = dBx_dx + dBy_dy + dBz_dz;
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------

% Assuming Bx, By, Bz are 3D arrays representing the magnetic field components.
% Dx, Dy, Dz are the grid spacings in the x, y, and z directions.

function divergence_B = computeDivergence(Bx, By, Bz, Dx, Dy, Dz)
    % Get the size of the grid
    [Nx, Ny, Nz] = size(Bx);

    % Compute the partial derivatives using central differences
    % For Bx: staggered along x-direction, derivative is computed at the midpoints
    dBx_dx = zeros(size(Bx));
    dBx_dx(2:Nx, :, :) = (Bx(2:Nx, :, :) - Bx(1:Nx-1, :, :)) / Dx;

    % For By: staggered along y-direction
    dBy_dy = zeros(size(By));
    dBy_dy(:, 2:Ny, :) = (By(:, 2:Ny, :) - By(:, 1:Ny-1, :)) / Dy;

    % For Bz: staggered along z-direction
    dBz_dz = zeros(size(Bz));
    dBz_dz(:, :, 2:Nz) = (Bz(:, :, 2:Nz) - Bz(:, :, 1:Nz-1)) / Dz;

    % Compute the divergence: ∇·B = dBx/dx + dBy/dy + dBz/dz
    divergence_B = dBx_dx + dBy_dy + dBz_dz;
end


%Function using the FFT
function divergence_FFTB = computeDivergenceFFT(Bx, By, Bz, Lx, Ly, Lz)
    % Inputs:
    % Bx, By, Bz: Magnetic field components (3D arrays)
    % Lx, Ly, Lz: Physical lengths of the simulation domain in x, y, z
    
    % Get the size of the grid
    [Nx, Ny, Nz] = size(Bx);
    
    % Compute wave numbers in each direction
    kx = (2 * pi / Lx) * [0:(Nx/2-1), -Nx/2:-1]; % Wave numbers in x
    ky = (2 * pi / Ly) * [0:(Ny/2-1), -Ny/2:-1]; % Wave numbers in y
    kz = (2 * pi / Lz) * [0:(Nz/2-1), -Nz/2:-1]; % Wave numbers in z
    
    % Create 3D wave number grids
    [KX, KY, KZ] = ndgrid(kx, ky, kz);
    
    % Compute the Fourier transforms of the magnetic field components
    Bx_hat = fftn(Bx);
    By_hat = fftn(By);
    Bz_hat = fftn(Bz);
    
    % Compute the divergence in Fourier space: ∇·B = i(kx*Bx + ky*By + kz*Bz)
    divergence_hat = 1i * (KX .* Bx_hat + KY .* By_hat + KZ .* Bz_hat);
    
    % Transform back to real space
    divergence_FFTB = real(ifftn(divergence_hat));
    
end


function divergence_B = computeDivergenceFFT2D(Bx, By, Lx, Ly)
    % Inputs:
    % Bx, By: Magnetic field components (2D arrays)
    % Lx, Ly: Physical lengths of the simulation domain in x and y directions
    
    % Get the size of the grid
    [Nx, Ny] = size(Bx);
    
    % Compute wave numbers in each direction
    kx = (2 * pi / Lx) * [0:(Nx/2-1), -Nx/2:-1]; % Wave numbers in x
    ky = (2 * pi / Ly) * [0:(Ny/2-1), -Ny/2:-1]; % Wave numbers in y
    
    % Create 2D wave number grids
    [KX, KY] = ndgrid(kx, ky);
    
    % Compute the Fourier transforms of the magnetic field components
    Bx_hat = fftn(Bx);
    By_hat = fftn(By);
    
    % Compute the divergence in Fourier space: ∇·B = i(kx*Bx + ky*By)
    divergence_hat = 1i * (KX .* Bx_hat + KY .* By_hat);
    
    % Transform back to real space
    divergence_B = real(ifftn(divergence_hat));
end

























%--------------------------------------------------------------------------
%{
%This is to check the divergence in the 2D xz case

Lx = 10*pi;
Ly = 10*pi;
Lz = 10*pi;

beta_i_par_ = 1;

k_x = 2. * pi / Lx;
k_y = 2. * pi / Ly;
k_z = 2. * pi / Lz;
rho_i = sqrt(beta_i_par_)*1.;
sp = 1./3.;
p = 1;
crit_fact = 0.1;

m_per=1;
m_par=1;
Nk = 8;

mn_per = 1. * m_per;
mn_par = 1. * m_par;

kk = {2. * k_x , 0. * k_y , 0. * k_z ;
 3. * k_x , 0. * k_y , 0. * k_z ;
 4. * k_x , 0. * k_y , 0. * k_z ;
 0. * k_x , 0. * k_y , 2. * k_z ;
 0. * k_x , 0. * k_y , 3. * k_z ;
 0. * k_x , 0. * k_y , 4. * k_z ;
 -2. * k_x , 0. * k_y , 0. * k_z ;
 -3. * k_x , 0. * k_y , 0. * k_z ;
 0. * k_x , 0. * k_y , -2. * k_z ;
 0. * k_x , 0. * k_y , -3. * k_z };

 phase={0.280*2.*pi, 0.388*2.*pi, 0.385*2.*pi, 0.908*2.*pi,...
         0.984*2.*pi, 0.515*2.*pi, 0.863*2.*pi, 0.606*2.*pi,...
         0.014*2.*pi, 0.988*2.*pi};

phi={1.*pi/2., 2.*pi/2., 1.*pi/2., 2.*pi/2., 3.*pi/2., 4.*pi/2., 3.*pi/2., 4.*pi/2.,1.*pi/2., 2.*pi/2};

% define cells
k_a_per = cell{i,1};
k_a_par = cell{i,1};
Amp = cell{i,1};
dB_ax = cell{i,1};
dB_ay = dB_ax;
dB_az = dB_ax;

for i=1:10
    k_a_per{i,1} = sqrt(sqr(kk{i,1}) + sqr(k{i,3}));
    k_a_par{i,1} = kk{i,2};

    Amp{i,1} = g.B0 * crit_fact *pow((k_a_per{i,1}), -sp);

    dB_ax{i,1} =  1.0 * cos ( kk{i,1} * xx + kk{i,2} * yy + kk{i,3} * zz + phase{1,i} ) * sin(phi{1,i}) ;
    dB_ay{i,1} =  1.0 * cos ( kk{i,1} * xx + kk{i,2} * yy + kk{i,3} * zz + phase{1,i} ) * cos(phi{1,i}) ;
    dB_az{i,1} =  1.0 * cos ( kk{i,1}* xx + kk{i,2} * yy + kk{i,3} * zz + phase{1,i} ) * cos(phi{1,i}) ;

    dv_ax = dB_ax;
    dv_ay = dB_ay;
    dv_az = dB_az;
end

      dB_axT = dB_ax{3,1} + dB_ax{4,1} + dB_ax[6] + dB_ax[7];
      dB_ayT = 0.; // dB_ay[0] + dB_ay[1] + dB_ay[2] + dB_ay[3] ;
      dB_azT = dB_ay[0] + dB_ay[1] + dB_ay[2] + dB_ay[3];

      dv_axT = dv_ax[4] + dv_ax[5] + dv_ax[6] + dv_ax[7];
      dv_ayT = 0.; // dv_ay[0] + dv_ay[1] + dv_ay[2] + dv_ay[3];
      dv_azT = dv_ay[0] + dv_ay[1] + dv_ay[2] + dv_ay[3];
%}
