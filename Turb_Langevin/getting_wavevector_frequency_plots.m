path_1 = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large';
%path_1 = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_cpinch_sSR/checkin_energy';
%path_2 = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_cpinch_sSR_lange/checkin_energy';


path_1='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini_L8di_8';

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
ay_a = 496 ;    ay_b = 530 ; dab_y = ay_b - ay_a;
az_a = 488 ;    az_b = 540 ; dab_z = az_b - az_a;

ay_a = 496 ;    ay_b = 595 ; dab_y = ay_b - ay_a;
az_a = 488 ;    az_b = 587 ; dab_z = az_b - az_a;

numIt = 10; 
x=zeros(dab_y +1,dab_z+1,numIt);
y=zeros(dab_y +1,dab_z+1,numIt);
z=zeros(dab_y +1,dab_z+1,numIt);
%y=zeros(ss(2),ss(3),numIt);
%z=zeros(ss(2),ss(3),numIt);

%--------------------------------------------------------------------------
jn=1;

for jn=20:20+numIt
    in=jn;
    %----------------------------------------------------------------------
    disp(strcat('Computing step ...',S(in).name))
    fileID =  S(in).name; %change the 1 per i
    %h5disp(fileID);
    info = h5info(fileID);
    EHJ_1st = info.Groups(16).Name;
    %--------------------------------------------------------------------------
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
    %--------------------------------------------------------------------------

    %--------------------------------------------------------------------------
    str = string(S(in).name);
    newStr = extractBetween(str,"pfd.","_p000000.h5");
    N_steps = str2double(newStr);
    time_t = dt*N_steps;
    time_t_2_Omega=time_t./omega_pe_Omega_ce;
    time_t_2(1,in)=time_t_2_Omega;
    %--------------------------------------------------------------------------

%     %----------------------------------------------------------------------
%     disp(strcat('Computing step ...',S2(in).name))
%     fileID2 =  S2(in).name; %change the 1 per i
%     %h5disp(fileID2);
%     info2 = h5info(fileID2);
%     moments_1st = info2.Groups(1).Name;
%     %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    %B{1,1}=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    %B{1,2}=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
    %B{1,3}=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));

    E{1,1}=h5read(fileID,strcat(EHJ_1st,'/ex_ec/p0/3d'));
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    ssz=size(E{1,1});
    sli_x = 1; %floor(4+ssz(1)/2);%1;
    sli_y = 512; %floor(4+ssz(2)/2);%380;
    sli_z = 904; %floor(2+ssz(3)/2);%700;
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
%     Bx = B{1,1}; Bx = squeeze(Bx(sli_x,:,:));
%     By = B{1,2}; By = squeeze(By(sli_x,:,:));
%     Bz = B{1,3}; Bz = squeeze(Bz(sli_x,:,:));

%     Bx=Bx(ay_a:ay_b,az_a:az_b);
%     By=By(ay_a:ay_b,az_a:az_b);
%     Bz=Bz(ay_a:ay_b,az_a:az_b);

    Ex = E{1,1}; Ex = squeeze(Ex(sli_x,:,:));
    Ex=Ex(ay_a:ay_b,az_a:az_b);

    x(:,:,in)=Ex;
%     y(:,:,in)=By;
%     z(:,:,in)=Bz;
end


% This is another way to do it following the  

% These are the instructions to get the wave plots
%--------------------------------------------------------------------------
% Take a field component, say Bz(x,y,t)
% Perform a 2D FFT to obtain Bz(kx,ky,t)
% For each pair kx ,ky, perform a Iterative Filtering decomposition and 
% calculate average frequency and amplitude of each IMF 
% Interpolate the corresponding power to a k and omega grid and sum up over 
% all found frequencies and powers
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Define the input array Bz(x, y, t) (replace with your actual data)

% xx=linspace(0,2*pi,100);
% yy=linspace(0,2*pi,100);
% [YY,XX]=meshgrid(xx,yy);
% 
% numIt = 10; % Number of iterations for FIF
% 
% Bz=zeros(100,100,numIt);
% for i=1:numIt
%     Bz(:,:,i)=sin(i*XX)+cos(i*2*XX);
% end

%Bz = randn(100, 100, 10); % Example input Bz component
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
Bz=x; % this comes from the other previous for loop with the data
%--------------------------------------------------------------------------

% Parameters for FFT and Iterative Filtering
fs = 1; % Sampling frequency (modify according to your data)
numIterations = 5; % Number of iterations for Iterative Filtering

% Perform 2D FFT on the Bz component
Bz_fft = fft2(Bz);

f2=figure(2)
hc=pcolor(real(Bz_fft(:,:,20)))
hold on
set(hc,'edgecolor','none');
colorbar
hold off

% Get the size of the Bz_fft array
[nx, ny, nt] = size(Bz_fft);

% Create grids for kx and ky
kx = 2 * pi * (-nx/2:nx/2-1) / (nx * fs);
ky = 2 * pi * (-ny/2:ny/2-1) / (ny * fs);
[Kx, Ky] = meshgrid(kx, ky);

% Initialize arrays to store results
amplitudes = zeros(nx, ny, nt);
frequencies = zeros(nx, ny, nt);

% Perform Iterative Filtering for each pair (kx, ky)
for t = 1:nt
    for i = 1:nx
        for j = 1:ny
            % Extract the complex value at current (kx, ky) pair
            Bz_k = Bz_fft(i, j, t);
            
            % Apply Iterative Filtering
            for k = 1:numIterations
                % Perform the inverse 2D FFT
                Bz_ifft = ifft2(Bz_fft);
                
                % Remove high-frequency noise
                Bz_ifft(i, j, t) = 0;
                
                % Perform the 2D FFT
                Bz_fft = fft2(Bz_ifft);
            end
            
            % Calculate amplitude and frequency
            amplitude = abs(Bz_fft(i, j, t));
            %frequency = sqrt(Kx(i, j)^2 + Ky(i, j)^2); 

            %--------------------------------------------------------------
            %frequency = abs(Bz_ifft(i, j, t));
            %--------------------------------------------------------------
            % Calculate the temporal frequency from the filtered time-domain signal
            time_step = 1 / fs; % Time step between consecutive samples
            time = (0:nt-1) * time_step; % Time values
            filtered_signal = squeeze(Bz_ifft(i, j, :)); % Extract the filtered signal at (i, j)

            % Perform FFT on the filtered signal
            filtered_signal_fft = fft(filtered_signal);

            % Calculate the frequencies corresponding to the FFT bins
            frequencies = (0:nt-1) / (nt * time_step); % Temporal frequencies

            % Find the index of the maximum amplitude in the FFT
            [~, max_amplitude_index] = max(abs(filtered_signal_fft));

            % Retrieve the corresponding temporal frequency
            frequency = frequencies(max_amplitude_index);
            
            % Store the results
            amplitudes(i, j, t) = amplitude;
            frequencies(i, j, t) = frequency;
        end
    end
end

% Interpolate the amplitudes and frequencies to a wavenumber and temporal frequency grid
numGridPoints = 100; % Number of points in the grid. This works only with 100 because the way...
k_max = max(kx);

freq_max = fs/2; % Maximum temporal frequency
omega_max = freq_max;%max(max(max(frequencies)));

wavenumbers = linspace(0, k_max, numGridPoints);
temporal_frequencies = linspace(0, freq_max, numGridPoints);
omegas = linspace(0, omega_max, numGridPoints);
[Kx_grid, Omega_grid] = meshgrid(wavenumbers, omegas);

%[Kx_grid, Freq_grid] = meshgrid(wavenumbers, temporal_frequencies);



% Sum up the corresponding powers over all found frequencies
power_grid = zeros(numGridPoints, numGridPoints);
for t = 1:nt
    for i = 1:nx
        for j = 1:ny
            k_index = find(abs(kx - Kx(i, j)) < k_max/numGridPoints/2);
            omega_index = find(abs(omegas - frequencies(i, j, t)) < omega_max/numGridPoints/2);
            
            if ~isempty(k_index) && ~isempty(omega_index)
                power_grid(omega_index, k_index) = power_grid(omega_index, k_index) + amplitudes(i, j, t)^2;
            end
        end
    end
end


% Smooth the power grid using Gaussian filtering
sigma = 2; % Standard deviation of the Gaussian filter
power_grid_smoothed = imgaussfilt(power_grid, sigma);

% Display the smoothed power grid
figure;
%imagesc(wavenumbers, omegas, power_grid_smoothed);
hc=pcolor(wavenumbers, omegas, log(power_grid_smoothed));
hold on
set(hc,'edgecolor','none');
colorbar;
xlabel('Wavenumber');
ylabel('Omega');
title('Smoothed Power Grid');
hold off

% Find the peak frequency and wavenumber
[max_power, ind] = max(power_grid_smoothed(:));
[max_omega_index, max_k_index] = ind2sub(size(power_grid_smoothed), ind);
peak_frequency = omegas(max_omega_index);
peak_wavenumber = wavenumbers(max_k_index);

% Display the peak frequency and wavenumber
fprintf('Peak Frequency: %.4f\n', peak_frequency);
fprintf('Peak Wavenumber: %.4f\n', peak_wavenumber);
%--------------------------------------------------------------------------




% This is the part that for the example only 
%--------------------------------------------------------------------------
% % Define the three input arrays (replace with your actual data)
% % Assuming the input arrays are named 'x', 'y', and 'z'
% x = sin(2*pi*randn(100, 100, 10)); % Example input x-component
% y = cos(2*pi*randn(100, 100, 10)); % Example input y-component
% z = sin(pi*randn(100, 100, 10)); % Example input z-component

xx=linspace(0,2*pi,100);
yy=linspace(0,2*pi,100);
[YY,XX]=meshgrid(xx,yy);


numIterations = 20; % Number of iterations for FIF

x=zeros(100,100,numIterations);
y=zeros(100,100,numIterations);
z=zeros(100,100,numIterations);
for i=1:numIterations
    x(:,:,i)=sin(i*XX)+cos(i*4*XX);
    y(:,:,i)=sin(i*XX)+cos(i*2*XX);
    z(:,:,i)=sin(i*XX)+cos(i*2*XX);
end

% Parameters for STFT and FIF
windowSize = 64; % Size of the window for STFT and FIF
overlap = 0.5; % Overlap between consecutive windows (e.g., 50%)
fs = 1; % Sampling frequency (modify according to your data)
%numIterations = 20; % Number of iterations for FIF

% Calculate the number of columns in the output matrix
numColumns = floor((size(x, 2)-windowSize)/(windowSize*(1-overlap))) + 1;

% Preallocate the output matrices
wave_vectors = zeros(windowSize/2+1, numColumns*size(x, 3));
time_frequencies = zeros(windowSize/2+1, numColumns*size(x, 3));

% Perform STFT and FIF on each component and store the results
index = 1; % Index to keep track of the current column in the output matrices

for t = 1:size(x, 3)
    for i = 1:windowSize*(1-overlap):size(x, 2)-windowSize+1
        % Extract the current window from each component
        x_window = x(:, i:i+windowSize-1, t);
        y_window = y(:, i:i+windowSize-1, t);
        z_window = z(:, i:i+windowSize-1, t);

        % Perform the 2D Fourier Transform on the current window of each component
        X = fft2(x_window);
        Y = fft2(y_window);
        Z = fft2(z_window);

        % Calculate the magnitudes and angles of the wave vectors
        magnitudes = abs(sqrt(X.*conj(X) + Y.*conj(Y) + Z.*conj(Z)));
        angles = angle(X + Y + Z);

        % Apply Fast Iterative Filtering (FIF) to refine the wave vectors
        for k = 1:numIterations
            % Reconstruct the complex-valued wave vectors
            wave_vectors_complex = magnitudes .* exp(1i * angles);

            % Perform the inverse 2D Fourier Transform
            wave_vectors_ifft = ifft2(wave_vectors_complex);

            % Remove high-frequency noise using FIF
            wave_vectors_ifft(windowSize/2+2:end, :) = 0; % Set high-frequency components to zero

            % Perform the 2D Fourier Transform
            wave_vectors_complex = fft2(wave_vectors_ifft);

            % Update the magnitudes and angles of the wave vectors
            magnitudes = abs(wave_vectors_complex);
            angles = angle(wave_vectors_complex);
        end

        % Store the refined wave vectors in the output matrices
        wave_vectors(:, index) = magnitudes(1:windowSize/2+1);
        time_frequencies(:, index) = fs*(0:windowSize/2)'./windowSize;

        % Increment the index
        index = index + 1;
    end
end

% Create a 2D histogram plot of frequency

% Compute the frequency and wavenumber ranges
frequency_range = linspace(0, fs/2, windowSize/2+1);
wavenumber_range = linspace(0, 2*pi, size(wave_vectors, 2));

% Create a 2D histogram plot of frequency vs. wavenumber
f2=figure(2);
pcolor(frequency_range, wavenumber_range, wave_vectors');
%imagesc(wavenumber_range, frequency_range, wave_vectors);
colorbar;
ylabel('Wavenumber');
xlabel('Frequency');
title('2D Histogram Plot of Wavenumber vs Frequency');

%--------------------------------------------------------------------------




%--------------------------------------------------------------------------
% Parameters for STFT and FIF
windowSize = 64; % Size of the window for STFT and FIF
overlap = 0.5; % Overlap between consecutive windows (e.g., 50%)
fs = 1; % Sampling frequency (modify according to your data)
numIterations = 10; % Number of iterations for FIF

% Calculate the number of columns in the output matrix
numColumns = floor((size(x, 2)-windowSize)/(windowSize*(1-overlap))) + 1;

% Preallocate the output matrices
wave_vectors = zeros(windowSize/2+1, numColumns*size(x, 3));
time_frequencies = zeros(windowSize/2+1, numColumns*size(x, 3));

% Perform STFT and FIF on each component and store the results
index = 1; % Index to keep track of the current column in the output matrices

for t = 1:size(x, 3)
    for i = 1:windowSize*(1-overlap):size(x, 2)-windowSize+1
        % Extract the current window from each component
        x_window = x(:, i:i+windowSize-1, t);
        y_window = y(:, i:i+windowSize-1, t);
        z_window = z(:, i:i+windowSize-1, t);

        % Perform the 2D Fourier Transform on the current window of each component
        X = fft2(x_window);
        Y = fft2(y_window);
        Z = fft2(z_window);

        % Calculate the magnitudes and angles of the wave vectors
        magnitudes = abs(sqrt(X.*conj(X) + Y.*conj(Y) + Z.*conj(Z)));
        angles = angle(X + Y + Z);

        % Apply Fast Iterative Filtering (FIF) to refine the wave vectors
        for k = 1:numIterations
            % Reconstruct the complex-valued wave vectors
            wave_vectors_complex = magnitudes .* exp(1i * angles);

            % Perform the inverse 2D Fourier Transform
            wave_vectors_ifft = ifft2(wave_vectors_complex);

            % Remove high-frequency noise using FIF
            wave_vectors_ifft(windowSize/2+2:end, :) = 0; % Set high-frequency components to zero

            % Perform the 2D Fourier Transform
            wave_vectors_complex = fft2(wave_vectors_ifft);

            % Update the magnitudes and angles of the wave vectors
            magnitudes = abs(wave_vectors_complex);
            angles = angle(wave_vectors_complex);
        end

        % Store the refined wave vectors in the output matrices
        wave_vectors(:, index) = magnitudes(1:windowSize/2+1);
        time_frequencies(:, index) = fs*(0:windowSize/2)'./windowSize;

        % Increment the index
        index = index + 1;
    end
end


% Create a 2D histogram plot of frequency

% Compute the frequency and wavenumber ranges
frequency_range = linspace(0, fs/2, windowSize/2+1);
wavenumber_range = linspace(0, 2*pi, size(wave_vectors, 2));

% Create a 2D histogram plot of frequency vs. wavenumber
f1=figure(1);
hc=pcolor(frequency_range, wavenumber_range, wave_vectors');
%hc=pcolor(frequency_range, wavenumber_range, time_frequencies');
hold on
set(hc,'edgecolor','none');
%imagesc(wavenumber_range, frequency_range, wave_vectors);
colorbar;
ylabel('Wavenumber');
xlabel('Frequency');
title('2D Histogram Plot of Wavenumber vs Frequency');
hold off

%--------------------------------------------------------------------------

