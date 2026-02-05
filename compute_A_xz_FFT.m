% % Load or define the magnetic field components (Bx, Bz) on the xz-plane
% nx = 100; % Number of grid points in x-direction
% nz = 100; % Number of grid points in z-direction
% Lx = 1.0; % Domain size in x-direction
% Lz = 1.0; % Domain size in z-direction
% 
% % Example magnetic field (replace with your data)
% Bx = sin(2 * pi * X / Lx) .* cos(2 * pi * Z / Lz);
% Bz = -cos(2 * pi * X / Lx) .* sin(2 * pi * Z / Lz);

in = 5;

%path = '/home/UNN/pfcy6/DATA_CIRRUS/turb_alf_jeff_2D_beta1_test';
path = '/home/UNN/pfcy6/DATA_CIRRUS/turb_alf_large_xz_dvdB_2';

%-----------------------------------------------------------------------------------------------------------------------

% For the scripts
%-----------------------------------------------------------------------------------------------------------------------
path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/home/UNN/pfcy6/Downloads/matlab_scripts_here';
%-----------------------------------------------------------------------------------------------------------------------

cd(path)
%--------------------------------------------------------------------------

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

disp(strcat('Computing step ...',S(in).name))
fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;
%------------------------------------------------------------------
Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));
%------------------------------------------------------------------
Bx = squeeze(Bx);
By = squeeze(By);
Bz = squeeze(Bz);

Ns=size(Bx);

grid_length = info.Groups(17).Attributes;
Lx=grid_length(4).Value(1) - grid_length(3).Value(1); %(This is in de The substraction give the total size of the domain) -Lx0 to Lx0
Ly=grid_length(4).Value(2) - grid_length(3).Value(2);
Lz=grid_length(4).Value(3) - grid_length(3).Value(3);

nx = Ns(1,1);
nz = Ns(1,2);

% Generate grid
x = linspace(0, Lx, nx);
z = linspace(0, Lz, nz);
[Z, X] = meshgrid(z, x);

% Compute the wavenumbers for FFT
kx = 2 * pi * [0:nx/2 -nx/2+1:-1] / Lx; % Wavenumbers in x
kz = 2 * pi * [0:nz/2 -nz/2+1:-1] / Lz; % Wavenumbers in z
[Kz, Kx] = meshgrid(kz, kx);

% Fourier transform of the magnetic field components
Bx_hat = fft2(Bx);
Bz_hat = fft2(Bz);

% Solve for Ay in Fourier space
% Bx = -i*kz*Ay, Bz = i*kx*Ay
% => Ay_hat = (i*kz*Bx_hat - i*kx*Bz_hat) / (kx^2 + kz^2)
denominator = Kx.^2 + Kz.^2;
denominator(1,1) = 1; % Avoid division by zero at (kx, kz) = (0, 0)
Ay_hat = (1i * Kz .* Bx_hat - 1i * Kx .* Bz_hat) ./ denominator;
Ay_hat(1,1) = 0; % Set the mean value of Ay to zero for consistency

% Inverse Fourier transform to get Ay in real space
Ay = real(ifft2(Ay_hat));

% Reconstruct the magnetic field components from Ay
% Note: Use consistent signs for curl relations
Bx_rec = -ifft2(1i * Kz .* fft2(Ay)); % -d(Ay)/dz
Bz_rec = ifft2(1i * Kx .* fft2(Ay));  % d(Ay)/dx

% Take the real part of the reconstructed fields (to remove numerical noise)
Bx_rec = real(Bx_rec);
Bz_rec = real(Bz_rec);

% Visualization of results
figure;
subplot(2, 2, 1);
imagesc(x, z, Bx'); axis equal tight;
title('Original Bx'); colorbar;

subplot(2, 2, 2);
imagesc(x, z, Bz'); axis equal tight;
title('Original Bz'); colorbar;

subplot(2, 2, 3);
imagesc(x, z, Bx_rec'); axis equal tight;
title('Reconstructed Bx'); colorbar;

subplot(2, 2, 4);
imagesc(x, z, Bz_rec'); axis equal tight;
title('Reconstructed Bz'); colorbar;

% Compute error
error_Bx = max(abs(Bx(:) - Bx_rec(:)));
error_Bz = max(abs(Bz(:) - Bz_rec(:)));

fprintf('Maximum error in Bx: %.3e\n', error_Bx);
fprintf('Maximum error in Bz: %.3e\n', error_Bz);
