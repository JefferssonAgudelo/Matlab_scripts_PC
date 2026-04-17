% script to make the phase coherence plots 

B_randx = rand(size(Bx_filt));
B_randy = rand(size(Bx_filt));
B_randz = rand(size(Bx_filt));

B2_randx = -1*Ex_filt;
B2_randy = -1*Ey_filt;
B2_randz = -1*Ez_filt;

B2_mag = sqrt(B2_randx.^2 + B2_randy.^2 + B2_randz.^2);
E_mag = sqrt(Ex_filt.^2 + Ey_filt.^2 + Ez_filt.^2);

norma_B2 = mean(B2_mag, "all"); 
norma_E = mean(E_mag, "all"); 

% The amplitude

[phase_diff_E_rand,~] = Phase_difference3D(Ex_filt,Ey_filt,Ez_filt, ...
    B_randx,B_randy,B_randz,Lx,threshold);

[phase_diff_E_rand2,~] = Phase_difference3D(Ex_filt,Ey_filt,Ez_filt, ...
    B2_randx,B2_randy,B2_randz,Lx,threshold);

[phase_diff_E_same,~] = Phase_difference3D(Ex_filt,Ey_filt,Ez_filt, ...
    Ex_filt,Ey_filt,Ez_filt,Lx,threshold);


fs=25; 
%x0=45;y0=54;xx1=1400;yy1=500;
x0=45;y0=54;xx1=900;yy1=500;
f127 =figure(127);
set(gcf,'position',[x0,y0,xx1,yy1])
%-------------------------
subplot(2,1,1)
dump = phase_diff_E_rand;
%dump = phase_diff_E_tau_nE;
semilogx(k_bins,dump,'*',color=My_colors(1,:),LineWidth=2)
hold on
dump = phase_diff_E_same;
semilogx(k_bins,dump,'+',color=My_colors(2,:),LineWidth=2)
%dump = phase_diff_E_tau_J_x_B;
dump = phase_diff_E_rand2;
semilogx(k_bins,dump,'^',color=My_colors(3,:),LineWidth=2)
ax.XTick = [10^0, 10^1];
ax.YTick = [70, 90, 110];
xline(1*pi/(sqrt(12)*0.28),'k--', LineWidth=1.5)

%yline(90,'--')
%ylim([70,110])

xline(10,'--')
xline(1,'--')
xlim([0.3,threshold/2])
hold off





function [E_k, k_bins] = Phase_difference3D_1(uxB_x,uxB_y,uxB_z,...
    tauuxB_x,tauuxB_y,tauuxB_z,Lx,threshold)

% --- Detrend ---
Bx_dt_DT_x = uxB_x - mean(uxB_x,'all');
Bx_dt_DT_y = uxB_y - mean(uxB_y,'all');
Bx_dt_DT_z = uxB_z - mean(uxB_z,'all');

Bx_dt_DT2_x = tauuxB_x - mean(tauuxB_x,'all');
Bx_dt_DT2_y = tauuxB_y - mean(tauuxB_y,'all');
Bx_dt_DT2_z = tauuxB_z - mean(tauuxB_z,'all');

% --- FFT ---
F_B_x = fftn(Bx_dt_DT_x);
F_B_y = fftn(Bx_dt_DT_y);
F_B_z = fftn(Bx_dt_DT_z);

F_B2_x = fftn(Bx_dt_DT2_x);
F_B2_y = fftn(Bx_dt_DT2_y);
F_B2_z = fftn(Bx_dt_DT2_z);

% --- Cross-spectrum ---
fgcon = F_B_x.*conj(F_B2_x) + ...
        F_B_y.*conj(F_B2_y) + ...
        F_B_z.*conj(F_B2_z);

% --- Grid size ---
Ns = size(uxB_x);

% --- Wavenumbers ---
kx = (2*pi/Lx) * [0:(Ns(1)/2-1) -Ns(1)/2:-1];
[KX, KY, KZ] = meshgrid(kx, kx, kx);
K = sqrt(KX.^2 + KY.^2 + KZ.^2);

% Integer shell index
kr = round(K / (2*pi/Lx));

kmax = floor(Ns(1)/2) + 1;

% --- k bins (for plotting) ---
dk = 2*pi/Lx;
k_bins = (0:kmax-1) * dk;

% --- Output ---
E_k = zeros(kmax,1);

% --- Amplitude-weighted phase averaging ---
for k = 1:kmax
    mask = (kr == (k-1));  % note shift because MATLAB indexing starts at 1
    
    if any(mask(:))
        C = fgcon(mask);
        
        % Amplitude weights
        W = abs(C);
        
        % Avoid division by zero
        if sum(W) > 0
            % Weighted complex average
            C_mean = sum(C .* W) / sum(W);
            
            % Extract phase in degrees
            E_k(k) = rad2deg(angle(C_mean));
        else
            E_k(k) = NaN;
        end
    else
        E_k(k) = NaN;
    end
end

end











function [E_k,k_bins]=Phase_difference3D(uxB_x,uxB_y,uxB_z,tauuxB_x,tauuxB_y,tauuxB_z,Lx,threshold)
% Detrend the variable
Bx_dt_DT_x = uxB_x - mean(uxB_x,'all');
Bx_dt_DT_y = uxB_y - mean(uxB_y,'all');
Bx_dt_DT_z = uxB_z - mean(uxB_z,'all');

Bx_dt_DT2_x = tauuxB_x - mean(tauuxB_x,'all');
Bx_dt_DT2_y = tauuxB_y - mean(tauuxB_y,'all');
Bx_dt_DT2_z = tauuxB_z - mean(tauuxB_z,'all');

% Perform the FFT of the 3D field B
F_B_x = fftn(Bx_dt_DT_x);
F_B_y = fftn(Bx_dt_DT_y);
F_B_z = fftn(Bx_dt_DT_z);

F_B2_x = fftn(Bx_dt_DT2_x);
F_B2_y = fftn(Bx_dt_DT2_y);
F_B2_z = fftn(Bx_dt_DT2_z);

fgcon = F_B_x.*conj(F_B2_x) + F_B_y.*conj(F_B2_y) + F_B_z.*conj(F_B2_z);

%%% --- Phase differences in Fourier space ---
phi1 = atan2(imag(fgcon), real(fgcon));
phi1 = rad2deg(phi1);

Ns=size(uxB_x);
% Compute the wavenumbers
kx = (2*pi/Lx) * [0:(Ns(1)/2-1) -Ns(1)/2:-1];
ky = kx;
kz = kx;
[KX, KY, KZ] = meshgrid(kx, ky, kz);
% Calculate the radial wavenumber k
K = sqrt(KX.^2 + KY.^2 + KZ.^2);

%% --- Omnidirectional averaging (simple linear mean of abs phase) ---
%kx = fftshift(-N/2:N/2-1);
%[KY,KX,KZ] = meshgrid(kx,kx,kx);
kr = round(sqrt(KX.^2 + KY.^2 + KZ.^2));
kmax = floor(Ns(1)/2)+1;
spec_phi1 = zeros(kmax,1);

% Define the bins for the radial wavenumber
dk = 2 * pi / Lx; % Bin width in k-space
k_max = threshold;%max(K(:)); % Maximum wavenumber
k_bins = 0:dk:k_max; % Radial wavenumber bins
% Initialize the omnidirectional spectrum

for k = 1:kmax
    mask = (kr == k);
    if any(mask(:))
        % use mean of absolute phase difference magnitude
        spec_phi1(k) = mean(abs(phi1(mask)));

        %C = fgcon(mask);
        %spec_phi1(k) = rad2deg(angle(mean(C)));

        % C = fgcon(mask);
        % W = abs(C);
        % 
        % if sum(W) > 0
        %     C_mean = sum(C .* W) / sum(W);
        %     spec_phi1(k) = abs(rad2deg(angle(C_mean)));
        % else
        %     spec_phi1(k) = NaN;
        % end

        %C = fgcon(mask);
        % Mean phase
        %spec_phi1(k) = rad2deg(angle(mean(C)));
        % Coherence (KEY quantity)
        %spec_phi1(k) = abs(mean(C)) / mean(abs(C));
    end
end

E_k = spec_phi1;

end
