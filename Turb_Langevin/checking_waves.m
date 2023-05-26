% For the alfven modes 3D
%--------------------------------------------------------------------------
% Define the parameters of your simulation
grid_size = [100, 100, 100];  % Size of the simulation grid
dx = 0.06;  % Spatial resolution (grid spacing)
dt = 0.06;  % Temporal resolution (time step)

% Number of waves;
nw=15;

% Define the wave parameters for each mode
amplitude = ones(1, nw);  % Wave amplitudes for each mode
kx = 2*pi*rand(1, nw) ./ (dx);  % Wave vectors in x-direction for each mode (randomly generated)
ky = 2*pi*rand(1, nw) ./ (dx);  % Wave vectors in y-direction for each mode (randomly generated)
omega = 2*pi*rand(1, nw) ./ dt;  % Angular frequencies for each mode (randomly generated)
phase = 2*pi*rand(1, nw); % Random phase for each mode

kx0=kx; ky0=ky; omega0=omega;

k0 = sqrt(kx0.^2 + ky0.^2);

% Create a grid of coordinates
x = dx * (-grid_size(2)/2:grid_size(2)/2-1);
y = dx * (-grid_size(1)/2:grid_size(1)/2-1);
z = dx * (-grid_size(1)/2:grid_size(1)/2-1);

[X, Y, Z] = meshgrid(x, y, z);

% Initialize arrays for magnetic field components
Bx = zeros(grid_size);
By = zeros(grid_size);
Bz = zeros(grid_size);

vx = zeros(grid_size);
vy = zeros(grid_size);
vz = zeros(grid_size);

% Superposition of the modes

for i = 1:length(amplitude)
    Bx = Bx + amplitude(i) * cos(kx(i)*X + ky(i)*Y + omega(i)*dt + phase(i)) ;%+ wnoise/nw;
    By = By + amplitude(i) * sin(kx(i)*X + ky(i)*Y + omega(i)*dt + phase(i)) ;%+ wnoise/nw;
    % Compute the velocity field components
    vx = By;
    vy = -Bx;
end


%--------------------------------------------------------------------------


% For the alfven modes and different times to extract the frequencies
%--------------------------------------------------------------------------
% Define the parameters of your simulation
grid_size = [100, 100];  % Size of the simulation grid
dx = 0.06;  % Spatial resolution (grid spacing)
dt = 0.06;  % Temporal resolution (time step)

% Number of waves;
nw=3;

% Define the wave parameters for each mode
amplitude = ones(1, nw);  % Wave amplitudes for each mode
kx = 2*pi*rand(1, nw) ./ (dx);  % Wave vectors in x-direction for each mode (randomly generated)
ky = 2*pi*rand(1, nw) ./ (dx);  % Wave vectors in y-direction for each mode (randomly generated)
omega = 2*pi*rand(1, nw) ./ dt;  % Angular frequencies for each mode (randomly generated)
phase = 2*pi*rand(1, nw); % Random phase for each mode

kx0=kx; ky0=ky; omega0=omega;

k0 = sqrt(kx0.^2 + ky0.^2);

% Create a grid of coordinates
x = dx * (-grid_size(2)/2:grid_size(2)/2-1);
y = dx * (-grid_size(1)/2:grid_size(1)/2-1);
[X, Y] = meshgrid(x, y);

% Initialize arrays for magnetic field components
Bx = zeros(grid_size);
By = zeros(grid_size);

Bx_i = zeros(100,100,100);
By_i = zeros(100,100,100);
Bz_i = zeros(100,100,100);

vx_i = zeros(100,100,100);
vy_i = zeros(100,100,100);

B0=1;
wnoise= rand(1)*B0*X;

% Superposition of the modes
for dt_i = 1:100
    for i = 1:length(amplitude)
        Bx = Bx + amplitude(i) * cos(kx(i)*X + ky(i)*Y - omega(i)*dt_i*dt + phase(i)) ;%+ wnoise/nw;
        By = By + amplitude(i) * sin(kx(i)*X + ky(i)*Y - omega(i)*dt_i*dt + phase(i)) ;%+ wnoise/nw;
        % Compute the velocity field components
        vx = By;
        vy = -Bx;
        %vz = zeros(grid_size);
        % safe the waves for different times
        Bx_i(:,:,dt_i) = Bx;
        By_i(:,:,dt_i) = By;
        vx_i(:,:,dt_i) = vx;
        vy_i(:,:,dt_i) = vy;
    end
end

%--------------------------------------------------------------------------
Bx=Bx_i; % this comes from the other previous for loop with the data

%--------------------------------------------------------------------------
% Let's visualise the waves
time=(1:100)*dt;
t=1;
for t=1:100
    f1=figure(1);
    imagesc(Bx(:,:,t))
    hold on
    colorbar; caxis([-30 30]);
    colormap('parula')
    title('time='+string(time(t)))
    hold off
end
%--------------------------------------------------------------------------


%Bx1=Bx_i(:,:,19); By1=By_i(:,:,19);  
%--------------------------------------------------------------------------
%Bx=Bx1; By=By1; 
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
Bx=Bx_i(:,:,:);
By=By_i(:,:,:);
Bz=Bz_i(:,:,:);

% Parameters for FFT and Iterative Filtering
fs = 1; % Sampling frequency (modify according to your data)

% Perform 3D FFT on the Bz component
Bx_fft = fftn(Bx);
By_fft = fftn(By);
Bz_fft = fftn(Bz);

%shift the fourier transform
Bx_fft = fftshift(Bx_fft);
By_fft = fftshift(By_fft);
Bz_fft = fftshift(Bz_fft);

Bx_power_spectrum = abs(Bx_fft).^2;
By_power_spectrum = abs(By_fft).^2;
Bz_power_spectrum = abs(Bz_fft).^2;

BT_power_spectrum = Bx_power_spectrum + By_power_spectrum + Bz_power_spectrum;


% Reduce as integrated circles in a single kx ky plane
%--------------------------------------------------------------------------
% Get the size of the Bz_fft array
[nx, ny, nt] = size(Bz_fft);

% Create grids for kx and ky
kx=((0:nx-1)-nx/2).*2*pi/(nx * (1*dx)); %Includes negative wavenumbers
ky=((0:ny-1)-ny/2).*2*pi/(ny * (1*dx));
om=((0:ny-1)-nt/2).*2*pi/(nt * (1*dt));

[Kx, Ky] = meshgrid(kx, ky);

k_max = 2*pi/(dx);
k_per = linspace(0,k_max,100);
n_k_per = length(k_per);

Bz_ps_s= zeros(1,n_k_per);
for i=2:n_k_per
    k_index =(k_per(i-1) < sqrt(Kx.^2  + Ky.^2)) & (sqrt(kx.^2  + ky.^2)< k_per(i));
    Bz_ps_s(1,i) =sum(BT_power_spectrum(:,:,1).*k_index, 'all');
end

f1=figure(1)
plot(k_per,Bz_ps_s)
%--------------------------------------------------------------------------



% Reduce as integrated circles for multiple kx ky planes to make the plot
% with the frequency
%--------------------------------------------------------------------------
% Get the size of the Bz_fft array
[nx, ny, nt] = size(Bz_fft);

% Create grids for kx and ky
kx=((0:nx-1)-nx/2).*2*pi/(nx * (1*dx)); %Includes negative wavenumbers
ky=((0:ny-1)-ny/2).*2*pi/(ny * (1*dx));
om=((0:ny-1)-nt/2).*2*pi/(nt * (1*dt));

[Kx, Ky] = meshgrid(kx, ky);

k_max = 2*pi/(dx);
k_per = linspace(0,k_max,100);
n_k_per = length(k_per);

Bz_ps_2Ds= zeros(n_k_per,100);
for t=1:100
    for i=2:n_k_per
        k_index =(k_per(i-1) < sqrt(Kx.^2  + Ky.^2)) & (sqrt(kx.^2  + ky.^2)< k_per(i));
        Bz_ps_s(1,i) = sum(BT_power_spectrum(:,:,t).*k_index, 'all');
    end
    Bz_ps_2Ds(:,t) = Bz_ps_s;
end

[K_per, Om] = meshgrid(k_per, om)

f2=figure(2)
%hc=pcolor(Kxo, Om, Bz_ps_2Ds)
hc=pcolor(K_per, Om, log(Bz_ps_2Ds))
hold on
set(hc,'edgecolor','none');
colorbar
hold off
%--------------------------------------------------------------------------


% this is for the case where it is not shifted
%kx = 2 * pi * (-nx/2:nx/2-1) / (nx * (1*dx));
%ky = 2 * pi * (-ny/2:ny/2-1) / (ny * (1*dx));

% Get the size of the Bz_fft array
[nx, ny, nt] = size(Bz_fft);

% Create grids for kx and ky
kx=((0:nx-1)-nx/2).*2*pi/(nx * (1*dx)); %Includes negative wavenumbers
ky=((0:ny-1)-ny/2).*2*pi/(ny * (1*dx));
om=((0:ny-1)-nt/2).*2*pi/(nt * (1*dt));

k = sqrt(kx.^2 + ky.^2);

[Kxy, Ky] = meshgrid(kx, ky);
[Kxo, Om] = meshgrid(kx, om);

%--------------------------------------------------------------------------
% Let's visualise the power spectrum time evolution
t=1;
for t=1:100
    f2=figure(2);
    %hc=pcolor(Kx,Ky,log(Bz_power_spectrum(:,:,t)));
    hc=pcolor(Kxy,Ky,log(squeeze(Bz_power_spectrum(:,:,t))));
    hc=pcolor(Kxo,Om,log(squeeze(Bz_power_spectrum(:,t,:))));
    hold on
    set(hc,'edgecolor','none');
    colorbar; caxis([-15 15]);
    colormap('parula')
    %xlim([0 Kx(end,end)]);
    %ylim([0 Kx(end,end)]);
    hold off
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
t=1;
for t=1:100
    f2=figure(2); 
    dum = log(squeeze(Bz_power_spectrum(t,5,:)));
     TF = islocalmax(dum); % find the local maxima
     kx_TF = om.*TF'; 
     vtf = nonzeros(kx_TF);
    %plot(kx,dum);
    plot(om,dum);
    hold on
    %hc=pcolor(Kxo,Om,log(squeeze(Bz_power_spectrum(:,1,:))));
    %xlim([0 Kx(end,end)]);
    %ylim([0 Kx(end,end)]);
    title(string(vtf))
    hold off
end

%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Initialize arrays to store results
amplitudes = zeros(nx, ny);
frequencies_o = zeros(nx, ny); %this will include the k and omegas
frequencies_g = zeros(nx, ny);

% Interpolate the amplitudes and frequencies to a wavenumber and temporal frequency grid
numGridPoints = 100; % Number of points in the grid. This works only with 100 because the way...
k_max = max(k);

freq_max = 1/(dt); % Maximum temporal frequency
omega_max = 2*pi*freq_max;%max(max(max(frequencies)));

wavenumbers = linspace(0, k_max, numGridPoints);
omegas = linspace(0, omega_max, numGridPoints);
%--------------------------------------------------------------------------


% %--------------------------------------------------------------------------
% % This shows that the time evolution of each point of Bz have the same 
% % time frequency information 
% i=10;j=20;
% for i=1:50
%     for j=1:50
%         f5=figure(5);
%         dum=squeeze(Bz_fft(i,j,:));
%         dum=fft(dum);
%         dum=abs(dum).^2;
%         plot(omegas,log(dum),LineWidth=2)
%         hold on
%         title('time='+string(time(t)))
%         ylim([-8 12])
%         hold off
%     end
% end
% %--------------------------------------------------------------------------

% %--------------------------------------------------------------------------
% % This shows that each kx and ky have a different time evolution. Also,
% % their the time fft of each pair kx and ky can give different frequencies
% % and power intensities. 
% i=10;j=20;
% for i=1:50
%     for j=1:50
%         f5=figure(5);
%         dum=squeeze(Bz_power_spectrum(i,j,:));
%         dum=fft(dum);
%         dum=abs(dum).^2;
%         plot(omegas,log(dum),LineWidth=2)
%         hold on
%         title('time='+string(time(t)))
%         ylim([-8 20])
%         hold off
%     end
% end
% %--------------------------------------------------------------------------

%--------------------------------------------------------------------------
omegas_TF_i=zeros(numGridPoints,numGridPoints); 
power2_i=zeros(numGridPoints,numGridPoints); 

omegas_TF_j=zeros(numGridPoints,numGridPoints); 
power2_j=zeros(numGridPoints,numGridPoints); 

i=10;j=20;
for i=1:numGridPoints
    for j=1:numGridPoints
        %if(j<=i)

%         numIterations=1;
%         % Apply Iterative Filtering
%         for k = 1:numIterations
%             % Perform the inverse 2D FFT
%             Bz_ifft = ifft2(Bz_fft);
% 
%             % Remove high-frequency noise
%             Bz_ifft(i, j, :) = 0;
% 
%             % Perform the 2D FFT
%             Bz_fft = fft2(Bz_ifft);
%         end
%         %shift the fourier transform
%         Bz_fft = fftshift(Bz_fft);
%         Bz_power_spectrum = abs(Bz_fft).^2;

        % compute the the fft in time of the amplitude for each kx ky pair
        dum=squeeze(Bz_power_spectrum(i,j,:)); % 100,1
        %dum=squeeze(Bz(i,j,:)); % 100,1
        dum=fft(dum);
        dum=fftshift(dum);
        dum=abs(dum).^2;

        TF = islocalmax(dum); % find the local maxima
        omegas_TF = omegas'.*TF; % find the frequency of the local maxima
        power2 = dum.*TF; % get the value of the local maxima


        % safe the time frequencies for each kx ky pair
        omegas_TF_j(:,j) =  omegas_TF;
        power2_j(:,j) =  power2;
        %             disp(i)
        %             disp(j)
        %end
    end
    omegas_TF_i =  mean(omegas_TF_j,2); % compute the average over j
    power2_i(:,i) =  mean(power2_j,2);
end


[K_grid, Omega_grid] = meshgrid(wavenumbers, omegas);

%--------------------------------------------------------------------------
f6=figure(6);
hc=pcolor(K_grid,omegas,log(power2_i));
hold on
set(hc,'edgecolor','none');
colorbar
xlabel('k')
ylabel('\omega')
hold off
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------













%--------------------------------------------------------------------------


% Perform Iterative Filtering for each pair (kx, ky)
i=10;j=10;

for i = 1:nx
    for j = 1:ny
        % Extract the complex value at current (kx, ky) pair
        Bz_k = squeeze(Bz_fft(i, j, :));
        amplitude = abs(Bz_k);

        % Empirical mode decomposition
        q = amplitude;
        [imf,~,~] = emd(q,Interpolation="pchip");

        IMF_ft = fft(imf); % get the frequency

        L=length(imf);
        Y = fft(imf(:,2));
        P2 = abs(Y/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);

        ff = fs*(0:(L/2))/L;
        f4=figure(4)
        plot(ff,P1) 
        title("Single-Sided Amplitude Spectrum of X(t)")
        xlabel("f (Hz)")
        ylabel("|P1(f)|")
        
        % I need to get teh index
        ind = ff(P1==max(P1))

        imf_mean = mean(imf); % average amplitude
        omega_f_mean = mean(abs(real(omega_f))); %real frequency
        gamma_f_mean = mean(abs(imag(omega_f))); %imaginary frequency

        


        % does it makes sense to compute a weigthed power average with the
        % frequencies?
        


        % the idea is to get the a condition to store the data in the
        % appropiated 

        

        % Store the results
        amplitudes(i, j) = imf_mean;
        frequencies_o(i, j) = omega_f_mean;
        frequencies_g(i, j) = gamma_f_mean;
    end
end

%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
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
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% Smooth the power grid using Gaussian filtering
sigma = 2; % Standard deviation of the Gaussian filter
power_grid_smoothed = imgaussfilt(power_grid, sigma);

% Display the smoothed power grid
figure;
subplot(1,2,1)
%imagesc(wavenumbers, omegas, power_grid_smoothed);
hc=pcolor(wavenumbers, omegas, log(power_grid));
hold on
set(hc,'edgecolor','none');
colorbar;
xlabel('Wavenumber');
ylabel('Omega');
title('Power Grid');
hold off
subplot(1,2,2)
hc=pcolor(wavenumbers, omegas, log(power_grid_smoothed));
hold on
set(hc,'edgecolor','none');
colorbar;
xlabel('Wavenumber');
ylabel('Omega');
title('Smoothed Power Grid');
hold off

figure
histogram(omega./(2*pi),10)
%--------------------------------------------------------------------------







load("sinusoidalSignalExampleData.mat","X","fs")
[imf,residual,info] = emd(X,Interpolation="pchip");
[hs,f,t] = hht(imf,fs);

f1=figure(1)
plot(t)





% For the alfven modes
%--------------------------------------------------------------------------
% Define the parameters of your simulation
grid_size = [100, 100];  % Size of the simulation grid
dx = 1;  % Spatial resolution (grid spacing)
dt = 0.1;  % Temporal resolution (time step)

% Define the wave parameters for each mode
amplitude = ones(1, 20);  % Wave amplitudes for each mode
kx = 2*pi*rand(1, 20) ./ dx;  % Wave vectors in x-direction for each mode (randomly generated)
ky = 2*pi*rand(1, 20) ./ dx;  % Wave vectors in y-direction for each mode (randomly generated)
omega = 2*pi*rand(1, 20) ./ dt;  % Angular frequencies for each mode (randomly generated)

% Create a grid of coordinates
x = dx * (-grid_size(2)/2:grid_size(2)/2-1);
y = dx * (-grid_size(1)/2:grid_size(1)/2-1);
[X, Y] = meshgrid(x, y);

% Initialize arrays for magnetic field components
Bx = zeros(grid_size);
By = zeros(grid_size);
Bz = zeros(grid_size);

% Superposition of the modes
for i = 1:length(amplitude)
    phase = rand * 2 * pi;  % Random phase for each mode
    Bx = Bx + amplitude(i) * cos(kx(i)*X + ky(i)*Y - omega(i)*dt + phase);
    By = By + amplitude(i) * sin(kx(i)*X + ky(i)*Y - omega(i)*dt + phase);
end

% Compute the velocity field components
vx = By;
vy = -Bx;
vz = zeros(grid_size);

Bx1=Bx; By1=By; Bz1=Bz; 

% Plot the magnetic field components
figure;
subplot(2, 2, 1);
imagesc(x, y, Bx);
colorbar;
xlabel('x');
ylabel('y');
title('Bx');
subplot(2, 2, 2);
imagesc(x, y, By);
colorbar;
xlabel('x');
ylabel('y');
title('By');
subplot(2, 2, 3);
imagesc(x, y, Bz);
colorbar;
xlabel('x');
ylabel('y');
title('Bz');
subplot(2, 2, 4);
quiver(X, Y, Bx, By);
xlabel('x');
ylabel('y');
title('Magnetic Field Vector');

% Plot the velocity field components
figure;
subplot(2, 2, 1);
imagesc(x, y, vx);
colorbar;
xlabel('x');
ylabel('y');
title('vx');
subplot(2, 2, 2);
imagesc(x, y, vy);
colorbar;
xlabel('x');
ylabel('y');
title('vy');
subplot(2, 2, 3);
imagesc(x, y, vz);
colorbar;
xlabel('x');
ylabel('y');
title('vz');
subplot(2, 2, 4);
quiver(X, Y, vx, vy);
xlabel('x');
ylabel('y');
title('Velocity Field Vector');


% Compute the phase velocity for each mode
v = omega ./ sqrt(kx.^2 + ky.^2);

f1=figure(1);
plot(v)
title('phase velocity')


% Display the phase velocity
disp(['Phase velocity: ', num2str(v), ' m/s']);
%--------------------------------------------------------------------------




% for another way to produce the whistler
%--------------------------------------------------------------------------
% Define the parameters of your simulation
grid_size = [100, 100];  % Size of the simulation grid
dx = 1;  % Spatial resolution (grid spacing)
dt = 0.1;  % Temporal resolution (time step)

% Define the wave parameters
amplitude = 1;  % Wave amplitude
kx = 2*pi/10;  % Wave vector in x-direction
ky = 2*pi/5;   % Wave vector in y-direction
omega0 = 2*pi/20;  % Center angular frequency
kappa = 0.1;  % Dispersion parameter

% Create a grid of coordinates
x = dx * (-grid_size(2)/2:grid_size(2)/2-1);
y = dx * (-grid_size(1)/2:grid_size(1)/2-1);
[X, Y] = meshgrid(x, y);

% Compute the angular frequency as a function of wave vector magnitude
k_mag = sqrt(kx^2 + ky^2);
omega = omega0 + kappa * k_mag^2;

% Compute the magnetic field components
Bx = amplitude * sin(kx*X + ky*Y - omega*dt);
By = zeros(grid_size);
Bz = amplitude * cos(kx*X + ky*Y - omega*dt);

Bx3=Bx; By3=By; Bz3=Bz;

% Plot the magnetic field components
figure;
subplot(2, 2, 1);
imagesc(x, y, Bx);
colorbar;
xlabel('x');
ylabel('y');
title('Bx');
subplot(2, 2, 2);
imagesc(x, y, By);
colorbar;
xlabel('x');
ylabel('y');
title('By');
subplot(2, 2, 3);
imagesc(x, y, Bz);
colorbar;
xlabel('x');
ylabel('y');
title('Bz');
subplot(2, 2, 4);
quiver(X, Y, Bx, Bz);
xlabel('x');
ylabel('y');
title('Magnetic Field Vector');

% Compute the phase velocity
v = omega / k_mag;

% Display the phase velocity
disp(['Phase velocity: ', num2str(v), ' m/s']);
%--------------------------------------------------------------------------



% Superposition of three different waves whislter modes
%--------------------------------------------------------------------------
% Define the parameters of your simulation
grid_size = [100, 100];  % Size of the simulation grid
dx = 1;  % Spatial resolution (grid spacing)
dt = 0.1;  % Temporal resolution (time step)

% Define the wave parameters for each mode
amplitude = ones(1, 20);  % Wave amplitudes for each mode
kx = 2*pi*rand(1, 20) ./ dx;  % Wave vectors in x-direction for each mode (randomly generated)
ky = 2*pi*rand(1, 20) ./ dx;  % Wave vectors in y-direction for each mode (randomly generated)
omega = 2*pi*rand(1, 20) ./ dt;  % Angular frequencies for each mode (randomly generated)

% Create a grid of coordinates
x = dx * (-grid_size(2)/2:grid_size(2)/2-1);
y = dx * (-grid_size(1)/2:grid_size(1)/2-1);
[X, Y] = meshgrid(x, y);

% Initialize arrays for magnetic field components, velocity components, and electric field components
Bx = zeros(grid_size);
By = zeros(grid_size);
Bz = zeros(grid_size);
vx = zeros(grid_size);
vy = zeros(grid_size);
vz = zeros(grid_size);

% Superposition of the modes
for i = 1:length(amplitude)
    phase = rand * 2 * pi;  % Random phase for each mode
    Bx = Bx + amplitude(i) * cos(kx(i)*X + ky(i)*Y - omega(i)*dt + phase);
    By = By + amplitude(i) * sin(kx(i)*X + ky(i)*Y - omega(i)*dt + phase);
    Bz = Bz + zeros(grid_size);
    vx = vx + By;
    vy = vy - Bx;
    vz = vz + zeros(grid_size);
end

Bx4=Bx; By4=By; Bz4=Bz;

% Plot the magnetic field components
figure;
subplot(2, 2, 1);
imagesc(x, y, Bx);
colorbar;
xlabel('x');
ylabel('y');
title('Bx');
subplot(2, 2, 2);
imagesc(x, y, By);
colorbar;
xlabel('x');
ylabel('y');
title('By');
subplot(2, 2, 3);
imagesc(x, y, Bz);
colorbar;
xlabel('x');
ylabel('y');
title('Bz');
subplot(2, 2, 4);
quiver(X, Y, Bx, By);
xlabel('x');
ylabel('y');
title('Magnetic Field Vector');

% Plot the velocity field components
figure;
subplot(2, 2, 1);
imagesc(x, y, vx);
colorbar;
xlabel('x');
ylabel('y');
title('vx');
subplot(2, 2, 2);
imagesc(x, y, vy);
colorbar;
xlabel('x');
ylabel('y');
title('vy');
subplot(2, 2, 3);
imagesc(x, y, vz);
colorbar;
xlabel('x');
ylabel('y');
title('vz');
subplot(2, 2, 4);
quiver(X, Y, vx, vy);
xlabel('x');
ylabel('y');
title('Velocity Field Vector');
%--------------------------------------------------------------------------


% superposition of 4 magnetosonic modes
%--------------------------------------------------------------------------
% Define the parameters of your simulation
grid_size = [100, 100];  % Size of the simulation grid
dx = 1;  % Spatial resolution (grid spacing)
dt = 0.1;  % Temporal resolution (time step)

% Define the wave parameters for each mode
amplitude = [1, 0.8, 0.5, 0.3];  % Wave amplitudes for each mode
kx = [2*pi/10, 2*pi/15, 2*pi/20, 2*pi/25];  % Wave vectors in x-direction for each mode
ky = [2*pi/5, 2*pi/8, 2*pi/12, 2*pi/16];   % Wave vectors in y-direction for each mode
omega = [2*pi/20, 2*pi/25, 2*pi/30, 2*pi/35];  % Angular frequencies for each mode

% Create a grid of coordinates
x = dx * (-grid_size(2)/2:grid_size(2)/2-1);
y = dx * (-grid_size(1)/2:grid_size(1)/2-1);
[X, Y] = meshgrid(x, y);

% Initialize arrays for magnetic field components, velocity components, and density
Bx = zeros(grid_size);
By = zeros(grid_size);
Bz = zeros(grid_size);
vx = zeros(grid_size);
vy = zeros(grid_size);
vz = zeros(grid_size);
density = zeros(grid_size);

% Superposition of the modes
for i = 1:length(amplitude)
    Bx = Bx + amplitude(i) * cos(kx(i)*X + ky(i)*Y - omega(i)*dt);
    By = By + amplitude(i) * sin(kx(i)*X + ky(i)*Y - omega(i)*dt);
    Bz = Bz + zeros(grid_size);
    vx = vx + amplitude(i) * sin(kx(i)*X + ky(i)*Y - omega(i)*dt);
    vy = vy + amplitude(i) * cos(kx(i)*X + ky(i)*Y - omega(i)*dt);
    vz = vz + zeros(grid_size);
    density = density + amplitude(i) * cos(kx(i)*X + ky(i)*Y - omega(i)*dt);
end

Bx5=Bx; By5=By; Bz5=Bz;

% Plot the magnetic field components
figure;
subplot(2, 2, 1);
imagesc(x, y, Bx);
colorbar;
xlabel('x');
ylabel('y');
title('Bx');
subplot(2, 2, 2);
imagesc(x, y, By);
colorbar;
xlabel('x');
ylabel('y');
title('By');
subplot(2, 2, 3);
imagesc(x, y, Bz);
colorbar;
xlabel('x');
ylabel('y');
title('Bz');
subplot(2, 2, 4);
quiver(X, Y, Bx, By);
xlabel('x');
ylabel('y');
title('Magnetic Field Vector');

% Plot the velocity field components
figure;
subplot(2, 2, 1);
imagesc(x, y, vx);
colorbar;
xlabel('x');
ylabel('y');
title('vx');
subplot(2, 2, 2);
imagesc(x, y, vy);
colorbar;
xlabel('x');
ylabel('y');
title('vy');
subplot(2, 2, 3);
imagesc(x, y, vz);
colorbar;
xlabel('x');
ylabel('y');
title('vz');
subplot(2, 2, 4);
quiver(X, Y, vx, vy);
xlabel('x');
ylabel('y');
title('Velocity Field Vector');

% Plot the density
figure;
imagesc(x, y, density);
colorbar;
xlabel('x');
ylabel('y');
title('Density');
%--------------------------------------------------------------------------


% Make a superposition of the different modes
Bx=Bx1 + Bx3 + Bx4 + Bx5; 
By=By1 + By3 + By4 + By5; 
Bz=Bz1 + Bz3 + Bz4 + Bz5; 


Bx=Bx1; 
By=By1; 
%--------------------------------------------------------------------------
% Load the magnetic field data from your simulation
% Assuming you have the magnetic field components Bx, By, Bz stored in separate variables

% Define the parameters of your simulation
grid_size = size(Bx);  % Size of the simulation grid
dx = 1;  % Spatial resolution (grid spacing)
dt = 1;  % Temporal resolution (time step)

% Perform the Fourier transform on the magnetic field components
Bx_fft = fft2(Bx);
By_fft = fft2(By);
%Bz_fft = fft2(Bz);

% Compute the power spectrum in wave-frequency and wave vector space
Bx_power_spectrum = abs(Bx_fft).^2;
By_power_spectrum = abs(By_fft).^2;
%Bz_power_spectrum = abs(Bz_fft).^2;
%total_power_spectrum = Bx_power_spectrum + By_power_spectrum + Bz_power_spectrum;
total_power_spectrum = Bx_power_spectrum;

% Define the wave vector grid
kx = (2*pi/(dx*grid_size(2))) * (-grid_size(2)/2:grid_size(2)/2-1);
ky = (2*pi/(dx*grid_size(1))) * (-grid_size(1)/2:grid_size(1)/2-1);
[Kx, Ky] = meshgrid(kx, ky);

% This doesn't catch the frequencies  
% Define the frequency grid
freq = fftshift(1 / (dt * grid_size(2))) * (-grid_size(2)/2:grid_size(2)/2-1);


% Plot the power spectrum in wave-frequency and wave vector space
figure;
%--------------------------------------------------------------------------
subplot(1,2,1)
%imagesc(kx, freq, log10(total_power_spectrum));
hc=pcolor(kx, freq, log10(total_power_spectrum));
hold on
set(hc,'edgecolor','none');
colorbar;
xlabel('Wave vector (k)');
ylabel('Frequency (Hz)');
title('Power Spectrum');
%xlim([0 max(ky)]);
%ylim([0 max(freq)])
%--------------------------------------------------------------------------
subplot(1,2,2)
hc=pcolor(Kx, Ky, log10(total_power_spectrum));
hold on
set(hc,'edgecolor','none');
colorbar;
xlabel('Wave vector (kx)');
ylabel('Wave vector (ky)');
title('Power Spectrum');
%xlim([0 max(ky)]);
%ylim([0 max(freq)])
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------

% Define the angles for which you want to plot the dispersion relation
angle1 = 30;  % Angle in degrees
angle2 = 60;  % Angle in degrees

% Convert angles to radians
theta1 = deg2rad(angle1);
theta2 = deg2rad(angle2);

% Compute the wave vector magnitude for the given angles
k_mag1 = Kx * cos(theta1) + Ky * sin(theta1);
k_mag2 = Kx * cos(theta2) + Ky * sin(theta2);

% Compute the frequency for the given angles using the dispersion relation
freq1 = k_mag1 * v;  % Replace 'v' with the phase velocity for the given mode
freq2 = k_mag2 * v;  % Replace 'v' with the phase velocity for the given mode

% Plot the dispersion relation for the first angle
figure;
plot(k_mag1(:), freq1(:), 'r.');
xlabel('Wave vector magnitude (|k|)');
ylabel('Frequency (Hz)');
title(['Dispersion Relation (Angle = ', num2str(angle1), ' degrees)']);

% Plot the dispersion relation for the second angle
figure;
plot(k_mag2(:), freq2(:), 'b.');
xlabel('Wave vector magnitude (|k|)');
ylabel('Frequency (Hz)');
title(['Dispersion Relation (Angle = ', num2str(angle2), ' degrees)']);
%--------------------------------------------------------------------------
