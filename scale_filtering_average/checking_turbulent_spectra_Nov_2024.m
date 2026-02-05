% Parameters
N = 256;             % Size of the 3D grid (N x N x N)
L = 3*2*pi;            % Physical length scale of the domain
k0 = 2 * pi / L;    % Smallest wave number

% Generate wave number grid
kx = (-N/2:N/2-1) * k0;
ky = (-N/2:N/2-1) * k0;
kz = (-N/2:N/2-1) * k0;
[KX, KY, KZ] = meshgrid(kx, ky, kz);

% Compute the magnitude of the wave vector
K = sqrt(KX.^2 + KY.^2 + KZ.^2);
K(N/2+1, N/2+1, N/2+1) = 1e-10; % Avoid division by zero at K=0

% Target power spectrum (Kolmogorov -5/3 law)
power_spectrum = K.^(-5/3);

% Generate random phases
random_phase = exp(1i * 2 * pi * rand(N, N, N));

% Create the Fourier transform of B with the desired power spectrum
B_hat = sqrt(power_spectrum) .* random_phase;

% Apply inverse Fourier transform to get B in spatial domain
B = real(ifftn(ifftshift(B_hat)));
% Apply the filtering
%B_filt1 = imgaussfilt3(B,1); % This is in number of pixels
%B_filt2 = imgaussfilt3(B,4);
%B_filt3 = imgaussfilt3(B,10);

% checking different filters
l_wind = 5;
B_filt1 = imgaussfilt3(B,l_wind); % this is way faster gaussian
B_filt2 = medfilt3(B,[l_wind l_wind l_wind]); % this is slow median
B_filt3 = imboxfilt3(B,[l_wind l_wind l_wind]); % this is quick average


% Visualize one slice of the turbulent field B
f111=figure(111);
subplot(2,2,1)
imagesc(squeeze(B(:, :, N/2)));
colorbar;
title('Unfiltered field B');
xlabel('x');ylabel('y');
subplot(2,2,2)
imagesc(squeeze(B_filt1(:, :, N/2)));
colorbar;
title('Filtered field B gaussian');
xlabel('x'); ylabel('y');
subplot(2,2,3)
imagesc(squeeze(B_filt2(:, :, N/2)));
colorbar;
title('Filtered field B median');
xlabel('x'); ylabel('y');
subplot(2,2,4)
imagesc(squeeze(B_filt3(:, :, N/2)));
colorbar;
title('Filtered field B average');
xlabel('x'); ylabel('y');


% Plot the power spectrum of B to verify
B_hat_mag = abs(fftshift(fftn(B))).^2;
B_filt1_hat_mag = abs(fftshift(fftn(B_filt1))).^2;
B_filt2_hat_mag = abs(fftshift(fftn(B_filt2))).^2;
B_filt3_hat_mag = abs(fftshift(fftn(B_filt3))).^2;

k_mag = sqrt(KX.^2 + KY.^2 + KZ.^2);

%k_bins = unique(k_mag(:));
threshold=pi/(L/N);
k_max = threshold;%max(K(:)); % Maximum wavenumber
k_bins = 0:k0:k_max; % Radial wavenumber bins

P_k = zeros(size(k_bins));

P_filt1_k = zeros(size(k_bins));
P_filt2_k = zeros(size(k_bins));
P_filt3_k = zeros(size(k_bins));

for i = 1:length(k_bins)
    P_k(i) = mean(B_hat_mag(k_mag == k_bins(i)));
    P_filt1_k(i) = mean(B_filt1_hat_mag(k_mag == k_bins(i)));
    P_filt2_k(i) = mean(B_filt2_hat_mag(k_mag == k_bins(i)));
    P_filt3_k(i) = mean(B_filt3_hat_mag(k_mag == k_bins(i)));
end

res = L/N;
sigma = 10*sqrt(3)*res;  

fs=20;
f23=figure(23);
loglog(k_bins, P_k,'k',LineWidth=2);
hold on
loglog(k_bins, P_filt1_k,'--r',LineWidth=2);
loglog(k_bins, P_filt2_k,'--g',LineWidth=2);
loglog(k_bins, P_filt3_k,'--b',LineWidth=2);
%xline(2*pi/1,'--r',LineWidth=1.5);xline(2*pi/4,'--g',LineWidth=1.5);xline(2*pi/10,'--b',LineWidth=1.5);
xline(2*pi/sigma,'--k',LineWidth=1.5);
title('Filtering at key scales','Interpreter','latex');
xlabel('Wavenumber $k/d_{i}$');
ylabel('Power');
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = [1e0 1e1 1e2]; %ax.YTick = [];
%legend('Unfiltered','$\sigma = 0.1$', '$\sigma = 1$','$\sigma = 5$','Interpreter','latex','NumColumns',1,'Location','southwest')
%legend('Unfiltered','$\sigma = 1d_{i}$', '$\sigma = 4d_{i}$','$\sigma = 10d_{i}$','Interpreter','latex','NumColumns',1,'Location','southwest')
legend('Unfiltered','$gaussian$', '$median$','$average$','Interpreter','latex','NumColumns',1,'Location','southwest')
ylim([1e-10, 1e2])
xlim([1e-1, 1e2])
hold off










% Checking the review paper details
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{


n0=1;
x=linspace(0,40,256);
y=linspace(0,40,80);
[X,Y]=meshgrid(y,x);

x0 = 20;
y0 = 13;
y1 = 27;
sigm=1;

n= exp(-((X-x0).^2 + (Y-y0).^2)/sigm.^2) + exp(-((X-x0).^2 + (Y-y1).^2)/sigm.^2) ;

f1=figure(1);
hc = pcolor(x,y,n2');
set(hc,'edgecolor','none')
hold on
yline(25,'--r',LineWidth=2)
yline(15,'--r',LineWidth=2)
xline(18,'--r',LineWidth=2)
xline(22,'--r',LineWidth=2)
colorbar
hold off

f2=figure(2)
plot(x,exp(-((x-x0)/sigm).^2))

%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



