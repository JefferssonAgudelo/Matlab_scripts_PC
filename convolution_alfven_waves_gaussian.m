
% This is in 1D
%--------------------------------------------------------------------------
% Parameters
N = 2024; % Number of points in the domain (choose a sufficiently large number)
L = 4*2*pi; % Length of the domain (0 to 2*pi)
x = linspace(-L, L, N); % Define the domain

% Define the superposition of 10 Alfven waves with different wave numbers

%k_values = 1:10; % Wave numbers for Alfven waves
%amplitudes = rand(1,10); % Random amplitudes for each wave
%k_values = 2*pi*rand(1,10)/L; % Wave numbers for Alfven waves

k_values = (2*pi/L)*(1:10); % Wave numbers for Alfven waves
amplitudes = k_values.^(-1/3); % Random amplitudes for each wave
phases = rand(1, 10) * 2 * pi; % Random phases for each wave

k_max = pi/(abs(x(2)-x(1)));  
k_lin = linspace(-k_max,k_max,N);

f = zeros(size(x));
for i = 1:length(k_values)
    f = f + amplitudes(i) * sin(k_values(i) * x + phases(i));
end

% Define the kernel function g to filter out high wavenumber fluctuations
% Example: Gaussian filter in the real domain
sigma = 2; % Standard deviation of the Gaussian filter
g = exp(-0.5 * (x/sigma).^2); % Gaussian filter in the real domain
g = g / sum(g(:));

% Perform the FFT of the function f
F_f = fft(f);

% Perform the FFT of the function g
F_g = fft(g);

% Shift
F_f_shift = fftshift(F_f);

% Note, applying the shift twice returns the same function (proved also after the convolution)
F_inv_shift = fftshift(F_f_shift);

F_g_shift = fftshift(F_g);

% Convolve in the frequency domain (element-wise multiplication)
%convolution_result = F_f.*F_g;
convolution_shift = F_f_shift.*F_g_shift;

% Perform the inverse FFT to get the convolved function
convolution_result = ifft(fftshift(convolution_shift));

% Ensure the result is real (the imaginary part should be very small due to numerical errors)
convolution_result = real(convolution_result);

%Get the amplitudes
F_f_shift_amp = F_f_shift .* conj(F_f_shift);
F_g_shift_amp = F_g_shift .* conj(F_g_shift);
convolution_result_amp = convolution_shift .* conj(convolution_shift);

% Optionally, plot the original function f for comparison
f1=figure(1);
subplot(2,3,1);
plot(x, f, 'LineWidth', 1.5);
hold on
title('Superposition of 10 Alfven Waves (Function f)');
xlabel('x');
ylabel('f(x)');
hold off

subplot(2,3,2);
plot(x, g, 'LineWidth', 1.5);
hold on
title('Gaussian Filter');
xlabel('x');
ylabel('Filter g(x)');
hold off

subplot(2,3,3);
plot(x, convolution_result, 'LineWidth', 1.5);
hold on
title('Convolution of f with Gaussian Filter g using Periodic Boundary Conditions');
xlabel('x');
ylabel('Convolution Result');
hold off

subplot(2,3,4);
loglog(k_lin,F_f_shift_amp, 'LineWidth', 1.5);
hold on
title('Power of 10 Alfven Waves (Function f)');
xlabel('k');
ylabel('|F(k)|^2');
xlim([0,10])
ylim([1e-40,1e7])
hold off

subplot(2,3,5);
loglog(k_lin,F_g_shift_amp, 'LineWidth', 1.5);
hold on
title('Power kernel (Function g)');
xlabel('k');
ylabel('|G(k)|^2');
xlim([0,10])
ylim([1e-40,1e7])
hold off

subplot(2,3,6);
loglog(k_lin,convolution_result_amp, 'LineWidth', 1.5);
hold on
title('Power product');
xlabel('k');
ylabel('|F(k)*G(k)|^2');
xlim([0,10])
ylim([1e-40,1e7])
hold off
%--------------------------------------------------------------------------



% This is in 2D
%--------------------------------------------------------------------------
% Parameters
N = 1024; % Number of points in the domain (choose a sufficiently large number)
L = 4 * 2 * pi; % Length of the domain (4 * 2 * pi)
x = linspace(-L, L, N); % Define the domain in x
y = linspace(-L, L, N); % Define the domain in y
[X, Y] = meshgrid(x, y); % Create 2D grid

k_values = (2*pi/L)*(1:15); % Wave numbers for Alfven waves
amplitudes = k_values.^(-1/3); % Random amplitudes for each wave
phases = rand(1, 15) * 2 * pi; % Random phases for each wave

k_max = pi/(abs(x(2)-x(1))); 
k_min=2*pi/L;
k_lin = linspace(-k_max,k_max,N);

f = zeros(size(X));
for i = 1:length(k_values)
    f = f + amplitudes(i) * sin(k_values(i) * X + k_values(i) * Y + phases(i));
end

% Define the kernel function g to filter out high wavenumber fluctuations
% Example: Gaussian filter in the real domain
sigma = 2; % Standard deviation of the Gaussian filter
g = exp(-0.5 * ((X/sigma).^2 + (Y/sigma).^2)); % Gaussian filter in the real domain

% Normalize the kernel function g
g = g / sum(g(:));

% Perform the FFT of the function f
F_f = fft2(f);

% Perform the FFT of the function g
F_g = fft2(g);

% Convolve in the frequency domain (element-wise multiplication)
F_convolution = F_f .* F_g;

% Perform the inverse FFT to get the convolved function
convolution_result = ifft2(F_convolution);

% Ensure the result is real (the imaginary part should be very small due to numerical errors)
convolution_result = real(convolution_result);

% For the spectrum
F_f_shift = fftshift(fftshift(F_f,1),2);
F_g_shift = fftshift(fftshift(F_g,1),2);
F_convolution_shift = fftshift(fftshift(F_convolution,1),2);

F_f_shift_amp = F_f_shift .* conj(F_f_shift);
F_g_shift_amp = F_g_shift .* conj(F_g_shift);
convolution_result_amp = F_convolution_shift .* conj(F_convolution_shift);

caxis_max = max(max(log(F_f_shift_amp)));
caxis_min = min(min(log(F_f_shift_amp)));


% Optionally, plot the original function f for comparison
f2=figure(2);
subplot(2,3,1);
imagesc(x, y, f);
axis xy;
colorbar;
title('Superposition of 10 Alfven Waves (Function f)');
xlabel('x');
ylabel('y');

subplot(2,3,2);
imagesc(x, y, g);
axis xy;
colorbar;
title('Gaussian Filter');
xlabel('x');
ylabel('y');

subplot(2,3,3);
imagesc(x, y, convolution_result);
axis xy;
colorbar;
title('Convolution of f with Gaussian Filter g using Periodic Boundary Conditions');
xlabel('x');
ylabel('y');

subplot(2,3,4);
imagesc(k_lin,k_lin,log(F_f_shift_amp));
set(gca, 'YScale', 'log', 'XScale', 'log')
hold on
colorbar
title('Power of 10 Alfven Waves (Function f)');
xlabel('k'); ylabel('k');
xlim([k_min,k_max])
ylim([k_min,k_max])
clim([caxis_min, caxis_max])
hold off

subplot(2,3,5);
imagesc(k_lin,k_lin,log(F_g_shift_amp));
set(gca, 'YScale', 'log', 'XScale', 'log')
hold on
colorbar
title('Power kernel (Function g)');
xlabel('k'); ylabel('k');
xlim([k_min,k_max])
ylim([k_min,k_max])
clim([caxis_min, caxis_max])
hold off

subplot(2,3,6);
imagesc(k_lin,k_lin,log(convolution_result_amp));
set(gca, 'YScale', 'log', 'XScale', 'log')
hold on
colorbar
title('Power product');
xlabel('k'); ylabel('k');
xlim([k_min,k_max])
ylim([k_min,k_max])
clim([caxis_min, caxis_max])
hold off
%--------------------------------------------------------------------------




% This is in 3D
%--------------------------------------------------------------------------
% Parameters
N = 168; % Number of points in the domain (choose a sufficiently large number)
L = 2 * pi; % Length of the domain (4 * 2 * pi)
x = linspace(-L, L, N); % Define the domain in x
y = linspace(-L, L, N); % Define the domain in y
z = linspace(-L, L, N); % Define the domain in z
[X, Y, Z] = meshgrid(x, y, z); % Create 2D grid

% Define the superposition of 10 Alfven waves with different wave numbers
%k_values = 1:10; % Wave numbers for Alfven waves
%amplitudes = rand(1, 10); % Random amplitudes for each wave
k_values = (2*pi/L)*(1:10); % Wave numbers for Alfven waves
amplitudes = k_values.^(-1/3); % Random amplitudes for each wave
phases = rand(1, 10) * 2 * pi; % Random phases for each wave

f = zeros(size(X));
for i = 1:length(k_values)
    f = f + amplitudes(i) * sin(k_values(i) * X + k_values(i) * Y + k_values(i) * Z + phases(i));
end

% Define the kernel function g to filter out high wavenumber fluctuations
% Example: Gaussian filter in the real domain
sigma = 2; % Standard deviation of the Gaussian filter
g = exp(-0.5 * ((X/sigma).^2 + (Y/sigma).^2 + (Z/sigma).^2)); % Gaussian filter in the real domain

% Normalize the kernel function g
g = g / sum(g(:));

% Perform the FFT of the function f
F_f = fftn(f);

% Perform the FFT of the function g
F_g = fftn(g);

% Convolve in the frequency domain (element-wise multiplication)
F_convolution = F_f .* F_g;

% Perform the inverse FFT to get the convolved function
convolution_result = ifftn(F_convolution);

% Ensure the result is real (the imaginary part should be very small due to numerical errors)
convolution_result = real(convolution_result);

% Optionally, plot the original function f for comparison
f12=figure(12);
subplot(3,1,1);
f2D = f(:,:,i);
imagesc(x, y, f2D);
axis xy;
colorbar;
title('Superposition of 10 Alfven Waves (Function f)');
xlabel('x');
ylabel('y');

subplot(3,1,2);
g2D = g(:,:,1);
imagesc(x, y, g2D);
axis xy;
colorbar;
title('Gaussian Filter');
xlabel('x');
ylabel('y');

subplot(3,1,3);
C2D = convolution_result(:,:,1);
imagesc(x, y, C2D);
axis xy;
colorbar;
title('Convolution of f with Gaussian Filter g using Periodic Boundary Conditions');
xlabel('x');
ylabel('y');
%--------------------------------------------------------------------------

