

% This is to compute the Ohms law terms for the PIC simulations 
%-----------------------------------------------------------------------------------------------------------------------
%path = '/home/UNN/pfcy6/DATA_CIRRUS/turb_alf_cam_3D';
path = '/home/UNN/pfcy6/DATA_CIRRUS/turb_alf_jeff_2D_beta1_test';
%path = '/home/UNN/pfcy6/DATA_CIRRUS/turb_alf_jeff_2D_beta1_test/beta_001_01';
%path = '/media/pfcy6/PSC_DiRAC_DATA/Data_Cirrus/turb_alf_2D_dBdv';
path = '/home/UNN/pfcy6/DATA_CIRRUS/turb_alf_large_xz_dvdB';
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

E{1,1}=h5read(fileID,strcat(EHJ_1st,'/ex_ec/p0/3d'),start,count);
E{1,2}=h5read(fileID,strcat(EHJ_1st,'/ey_ec/p0/3d'),start,count);
E{1,3}=h5read(fileID,strcat(EHJ_1st,'/ez_ec/p0/3d'),start,count);
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

Ex = E{1,1};
Ey = E{1,2};
Ez = E{1,3};

% Define grid spacings
%Dx = 0.1; Dy = 0.1; Dz = 0.1;

% Run the function interactively
derivatives = computeYeeGridDerivativesSelective(Dx, Dy, Dz);

% Example: Display a specific derivative
disp('Derivative of Bx with respect to x:');
%disp(derivatives.vectors.dBx_dx);

aa_B=derivatives.vectors.dBx_dx + derivatives.vectors.dBy_dy + derivatives.vectors.dBz_dz;
aaa_B=squeeze(aa_B(:,1,:));
%aaa_B=squeeze(aa_B(:,:,1));

aa_E=derivatives.vectors.dEx_dx + derivatives.vectors.dEy_dy + derivatives.vectors.dEz_dz;
aaa_E=squeeze(aa_E(:,1,:));
%aaa_E=squeeze(aa_E(:,:,1));

f12=figure(12);
subplot(1,2,1)
hc = pcolor(aaa_B');
set(hc,'edgecolor','none')
title('divB')
colorbar
clim([-0.01, 0.01])
subplot(1,2,2)
hc = pcolor(aaa_E');
set(hc,'edgecolor','none')
title('divE')
colorbar


function derivatives = computeYeeGridDerivativesSelective(Dx, Dy, Dz)
    % Function to compute Yee grid derivatives selectively.
    % Asks user which fields to compute and maintains consistent dimensions using padding.
    %
    % Inputs:
    %   - Dx, Dy, Dz: Grid spacings in the x, y, and z directions
    %
    % Output:
    %   - derivatives: Struct containing computed derivatives for scalars, vectors, and tensors

    %% Initialize output
    derivatives = struct('scalars', struct(), 'vectors', struct(), 'tensors', struct());

    %% Ask user for scalar derivatives (e.g., densities)
    computeScalars = input('Do you want to compute derivatives for scalars (e.g., densities)? (y/n): ', 's');
    if strcmpi(computeScalars, 'y')
        ni = evalin('base', input('Provide ion density variable name (e.g., ni): ', 's'));
        ne = evalin('base', input('Provide electron density variable name (e.g., ne): ', 's'));

        derivatives.scalars.dni_dx = (ni(2:end, :, :) - ni(1:end-1, :, :)) / Dx;
        derivatives.scalars.dni_dy = (ni(:, 2:end, :) - ni(:, 1:end-1, :)) / Dy;
        derivatives.scalars.dni_dz = (ni(:, :, 2:end) - ni(:, :, 1:end-1)) / Dz;

        derivatives.scalars.dne_dx = (ne(2:end, :, :) - ne(1:end-1, :, :)) / Dx;
        derivatives.scalars.dne_dy = (ne(:, 2:end, :) - ne(:, 1:end-1, :)) / Dy;
        derivatives.scalars.dne_dz = (ne(:, :, 2:end) - ne(:, :, 1:end-1)) / Dz;

        % Padding to maintain consistent size
        derivatives.scalars.dni_dx = padarray(derivatives.scalars.dni_dx, [1, 0, 0], 'post');
        derivatives.scalars.dni_dy = padarray(derivatives.scalars.dni_dy, [0, 1, 0], 'post');
        derivatives.scalars.dni_dz = padarray(derivatives.scalars.dni_dz, [0, 0, 1], 'post');

        derivatives.scalars.dne_dx = padarray(derivatives.scalars.dne_dx, [1, 0, 0], 'post');
        derivatives.scalars.dne_dy = padarray(derivatives.scalars.dne_dy, [0, 1, 0], 'post');
        derivatives.scalars.dne_dz = padarray(derivatives.scalars.dne_dz, [0, 0, 1], 'post');
    end

    %% Ask user for vector derivatives (e.g., E, B, J, vi, ve)
    computeVectors = input('Do you want to compute derivatives for vector fields? (y/n): ', 's');
    if strcmpi(computeVectors, 'y')
        % Ask specifically which vector fields to compute
        includeElectric = input('Do you want to compute derivatives for the electric field (E)? (y/n): ', 's');
        includeMagnetic = input('Do you want to compute derivatives for the magnetic field (B)? (y/n): ', 's');
        includeCurrent = input('Do you want to compute derivatives for the current density (J)? (y/n): ', 's');
        includeIonVelocity = input('Do you want to compute derivatives for the ion velocity (vi)? (y/n): ', 's');
        includeElectronVelocity = input('Do you want to compute derivatives for the electron velocity (ve)? (y/n): ', 's');

        % Electric field
        if strcmpi(includeElectric, 'y')
            Ex = evalin('base', input('Provide electric field Ex variable name: ', 's'));
            Ey = evalin('base', input('Provide electric field Ey variable name: ', 's'));
            Ez = evalin('base', input('Provide electric field Ez variable name: ', 's'));

            % Compute derivatives and pad for correct dimension size
            derivatives.vectors.dEx_dx = (Ex(2:end, :, :) - Ex(1:end-1, :, :)) / Dx;
            derivatives.vectors.dEx_dy = (Ex(:, 2:end, :) - Ex(:, 1:end-1, :)) / Dy;
            derivatives.vectors.dEx_dz = (Ex(:, :, 2:end) - Ex(:, :, 1:end-1)) / Dz;

            derivatives.vectors.dEy_dx = (Ey(2:end, :, :) - Ey(1:end-1, :, :)) / Dx;
            derivatives.vectors.dEy_dy = (Ey(:, 2:end, :) - Ey(:, 1:end-1, :)) / Dy;
            derivatives.vectors.dEy_dz = (Ey(:, :, 2:end) - Ey(:, :, 1:end-1)) / Dz;

            derivatives.vectors.dEz_dx = (Ez(2:end, :, :) - Ez(1:end-1, :, :)) / Dx;
            derivatives.vectors.dEz_dy = (Ez(:, 2:end, :) - Ez(:, 1:end-1, :)) / Dy;
            derivatives.vectors.dEz_dz = (Ez(:, :, 2:end) - Ez(:, :, 1:end-1)) / Dz;

            % Padding to match dimensions
            derivatives.vectors.dEx_dx = padarray(derivatives.vectors.dEx_dx, [1, 0, 0], 'post');
            derivatives.vectors.dEx_dy = padarray(derivatives.vectors.dEx_dy, [0, 1, 0], 'post');
            derivatives.vectors.dEx_dz = padarray(derivatives.vectors.dEx_dz, [0, 0, 1], 'post');

            derivatives.vectors.dEy_dx = padarray(derivatives.vectors.dEy_dx, [1, 0, 0], 'post');
            derivatives.vectors.dEy_dy = padarray(derivatives.vectors.dEy_dy, [0, 1, 0], 'post');
            derivatives.vectors.dEy_dz = padarray(derivatives.vectors.dEy_dz, [0, 0, 1], 'post');

            derivatives.vectors.dEz_dx = padarray(derivatives.vectors.dEz_dx, [1, 0, 0], 'post');
            derivatives.vectors.dEz_dy = padarray(derivatives.vectors.dEz_dy, [0, 1, 0], 'post');
            derivatives.vectors.dEz_dz = padarray(derivatives.vectors.dEz_dz, [0, 0, 1], 'post');
        end

        % Magnetic field
        if strcmpi(includeMagnetic, 'y')
            Bx = evalin('base', input('Provide magnetic field Bx variable name: ', 's'));
            By = evalin('base', input('Provide magnetic field By variable name: ', 's'));
            Bz = evalin('base', input('Provide magnetic field Bz variable name: ', 's'));

            % Compute derivatives and pad for correct dimension size
            derivatives.vectors.dBx_dx = (Bx(2:end, :, :) - Bx(1:end-1, :, :)) / Dx;
            derivatives.vectors.dBx_dy = (Bx(:, 2:end, :) - Bx(:, 1:end-1, :)) / Dy;
            derivatives.vectors.dBx_dz = (Bx(:, :, 2:end) - Bx(:, :, 1:end-1)) / Dz;

            derivatives.vectors.dBy_dx = (By(2:end, :, :) - By(1:end-1, :, :)) / Dx;
            derivatives.vectors.dBy_dy = (By(:, 2:end, :) - By(:, 1:end-1, :)) / Dy;
            derivatives.vectors.dBy_dz = (By(:, :, 2:end) - By(:, :, 1:end-1)) / Dz;

            derivatives.vectors.dBz_dx = (Bz(2:end, :, :) - Bz(1:end-1, :, :)) / Dx;
            derivatives.vectors.dBz_dy = (Bz(:, 2:end, :) - Bz(:, 1:end-1, :)) / Dy;
            derivatives.vectors.dBz_dz = (Bz(:, :, 2:end) - Bz(:, :, 1:end-1)) / Dz;

            % Padding to match dimensions
            derivatives.vectors.dBx_dx = padarray(derivatives.vectors.dBx_dx, [1, 0, 0], 'post');
            derivatives.vectors.dBx_dy = padarray(derivatives.vectors.dBx_dy, [0, 1, 0], 'post');
            derivatives.vectors.dBx_dz = padarray(derivatives.vectors.dBx_dz, [0, 0, 1], 'post');

            derivatives.vectors.dBy_dx = padarray(derivatives.vectors.dBy_dx, [1, 0, 0], 'post');
            derivatives.vectors.dBy_dy = padarray(derivatives.vectors.dBy_dy, [0, 1, 0], 'post');
            derivatives.vectors.dBy_dz = padarray(derivatives.vectors.dBy_dz, [0, 0, 1], 'post');

            derivatives.vectors.dBz_dx = padarray(derivatives.vectors.dBz_dx, [1, 0, 0], 'post');
            derivatives.vectors.dBz_dy = padarray(derivatives.vectors.dBz_dy, [0, 1, 0], 'post');
            derivatives.vectors.dBz_dz = padarray(derivatives.vectors.dBz_dz, [0, 0, 1], 'post');
        end

        % Current density (J)
        if strcmpi(includeCurrent, 'y')
            % Add code for current density (J) here if needed
        end

        % Ion and electron velocity fields
        if strcmpi(includeIonVelocity, 'y')
            % Add code for ion velocity derivatives here if needed
        end
        if strcmpi(includeElectronVelocity, 'y')
            % Add code for electron velocity derivatives here if needed
        end
    end

    %% Ask user for tensor derivatives (e.g., Pi, Pe)
    computeTensors = input('Do you want to compute derivatives for tensors? (y/n): ', 's');
    if strcmpi(computeTensors, 'y')
        % Add code for tensors (Pi, Pe) derivatives here
    end
end


