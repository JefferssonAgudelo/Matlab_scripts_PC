%% kw_polarization_diagnostics.m
%
% Companion script to kw_diagram_reconnection.m. Computes three
% polarization/compressibility diagnostics in the SAME local
% mean-field-aligned frame and the SAME (k_perp, omega) binning grid,
% so the results overlay directly on your existing k-omega plot:
%
%   1) Magnetic compressibility   C_B(k_perp,omega) = |Bpar|^2 / |B|^2
%   2) delta-n vs delta-Bpar cross-spectrum: amplitude ratio, phase,
%      and coherence (k_perp,omega)
%   3) Reduced magnetic helicity  sigma_m(k_perp,omega), built from the
%      two FIXED perpendicular components (e1,e2) of the local mean
%      field. This quantity is invariant under rotation of (e1,e2)
%      *for a single plane-wave component* (2*Im(b1 b2*)/(|b1|^2+|b2|^2)
%      is a rotational invariant of the transverse polarization state),
%      so it can be compared directly to the dispersion solver's
%      eigenvector-frame helicity without needing to rotate into each
%      Fourier mode's local k_perp azimuth.
%
% It then reuses the SAME hallMHD_branches() Hall-MHD system as the
% FW/A-KAW overlay curves, but pulls out EIGENVECTORS (not just
% eigenvalues) along those curves, interpolates the measured
% diagnostics at the same (k_perp, omega_branch(k_perp)) points, and
% prints a quantitative data-vs-theory comparison table.
%
% ASSUMPTIONS INHERITED FROM kw_diagram_reconnection.m:
%   - chosen sub-region is locally homogeneous/quiescent (lobe, away
%     from X-line/separatrices)
%   - (bhat, e1, e2) are FIXED directions from the local mean field,
%     not rotating with each Fourier mode's k_perp azimuth
%
% STATE-VECTOR MAPPING IN hallMHD_branches' 8x8 matrix (reverse-engineered
% by hand from the equations -- it is not labeled in the original file):
%   s1=rho'   s2=v_perp,inplane   s3=v_perp,outplane   s4=v_par
%   s5=p'     s6=b_perp,inplane   s7=b_perp,outplane   s8=b_par  <-- compressive B
% This is auto-checked below via div(B)=0 => kp*s6 + kz*s8 ~ 0. If the
% printed residual is not small, DO NOT trust the eigenvector-comparison
% numbers (compressibility/helicity/phase panels of the raw simulation
% data are unaffected either way -- only the theory-comparison table
% depends on this mapping).
%
% -------------------------------------------------------------------

clear; clc; close all;

%% ---------------- USER INPUT (mirror kw_diagram_reconnection.m) --------

cxxFile = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/cases_betae1_betai1/psc_reconnection_harris_2D_yz/psc_reconnection_harris_2D_yz_kap2.cxx'; % <<< EDIT if needed
dataDir = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/cases_betae1_betai1/psc_reconnection_harris_2D_yz';   % <<< EDIT ME

it_range = [];          % [] = all available
y_range_di = [];
z_range_di = [-2, 2];   % <<< EDIT ME: same sub-window you used before

space_decim = 2;

show_dispersion_overlay = true;
theta_FW_deg  = 45;      % <<< match whatever you settled on in the main script
theta_KAW_deg = 40;

EHJ_GROUP_IDX     = 16;
MOMENTS_GROUP_IDX = 1;
GRIDLEN_GROUP_IDX = 17;

kperp_di_max = 20;
omega_Oi_max = 12;

Gamma = 5/3;

%% ---------------- PARSE .cxx, LOCATE FILES (identical to main script) ---

rp = parseReconnectionCxxParams(cxxFile);

S  = dir(fullfile(dataDir, 'pfd.*.h5'));
S2 = dir(fullfile(dataDir, 'pfd_moments.*.h5'));
if isempty(S),  error('No pfd.*.h5 files found in %s', dataDir); end
if isempty(S2), error('No pfd_moments.*.h5 files found in %s', dataDir); end

if isempty(it_range), it_range = 1:numel(S); end
Nt_used = numel(it_range);

momentsFile = cell(Nt_used,1);
for n = 1:Nt_used
    it = it_range(n);
    stri = S(it).name;
    newStri = erase(stri, 'pfd.');
    Nff = {S2.name};
    match = find(contains(Nff, newStri), 1);
    if isempty(match), error('Could not find a pfd_moments file matching %s', stri); end
    momentsFile{n} = fullfile(dataDir, S2(match).name);
end
pfdFile = fullfile(dataDir, {S(it_range).name});

info1 = h5info(pfdFile{1});
grid_length = info1.Groups(GRIDLEN_GROUP_IDX).Attributes;
Ly = grid_length(4).Value(2) - grid_length(3).Value(2);
Lz = grid_length(4).Value(3) - grid_length(3).Value(3);

dt_code = getGridDt(pfdFile{1});
dt_snapshot_omegape = rp.pfield_out_interval * dt_code;
dt_eff = dt_snapshot_omegape * rp.Omega_i_over_omegape;

EHJ1 = info1.Groups(EHJ_GROUP_IDX).Name;
Bx_full = h5read(pfdFile{1}, strcat(EHJ1, '/hx_fc/p0/3d'));
sz = size(Bx_full); clear Bx_full
LYs = sz(2); LZs = sz(3);

if isempty(y_range_di)
    y_lo_idx = 1; y_hi_idx = LYs;
else
    [y_lo_idx, y_hi_idx] = physRangeToIdx(y_range_di * rp.d_i, Ly, LYs);
end
[z_lo_idx, z_hi_idx] = physRangeToIdx(z_range_di * rp.d_i, Lz, LZs);

yIdx = y_lo_idx:space_decim:y_hi_idx;
zIdx = z_lo_idx:space_decim:z_hi_idx;
Ny = numel(yIdx); Nz = numel(zIdx);

startVec  = [1, y_lo_idx, z_lo_idx];
countVec  = [1, Ny, Nz];
strideVec = [1, space_decim, space_decim];

fprintf('sub-window: y-idx [%d %d], z-idx [%d %d] -> %d x %d grid, %d snapshots\n', ...
    y_lo_idx, y_hi_idx, z_lo_idx, z_hi_idx, Ny, Nz, Nt_used);

%% ---------------- LOAD B AND THE FULL rho_i FIELD (not just its mean) ---

Bx = zeros(Ny,Nz,Nt_used,'single');
By = zeros(Ny,Nz,Nt_used,'single');
Bz = zeros(Ny,Nz,Nt_used,'single');
Ni = zeros(Ny,Nz,Nt_used,'single');   % full ion density field, needed for delta-n

for n = 1:Nt_used
    fileID  = pfdFile{n};
    fileID2 = momentsFile{n};
    infoN = h5info(fileID);
    EHJn  = infoN.Groups(EHJ_GROUP_IDX).Name;

    Bx(:,:,n) = squeeze(h5read(fileID, strcat(EHJn,'/hx_fc/p0/3d'), startVec, countVec, strideVec));
    By(:,:,n) = squeeze(h5read(fileID, strcat(EHJn,'/hy_fc/p0/3d'), startVec, countVec, strideVec));
    Bz(:,:,n) = squeeze(h5read(fileID, strcat(EHJn,'/hz_fc/p0/3d'), startVec, countVec, strideVec));

    infoM = h5info(fileID2);
    moms  = infoM.Groups(MOMENTS_GROUP_IDX).Name;
    rho_i = squeeze(h5read(fileID2, strcat(moms,'/rho_i/p0/3d'), startVec, countVec, strideVec));
    rho_i(rho_i==0) = 1e-20;
    Ni(:,:,n) = rho_i;

    if mod(n,20)==0, fprintf('  loaded %d / %d\n', n, Nt_used); end
end

n_local    = mean(Ni(:));
beta_local = 2*n_local*(rp.Ti0+rp.Te0)/rp.B0^2;
d_i_local  = sqrt(rp.mass_ratio/n_local);
fprintf('local n = %g, beta_local = %g, d_i_local = %g d_e\n', n_local, beta_local, d_i_local);

%% ---------------- LOCAL MEAN-FIELD FRAME & PROJECTION -------------------

Bbar = [mean(Bx(:)), mean(By(:)), mean(Bz(:))];
bhat = Bbar / norm(Bbar);
[e1, e2] = perpBasis(bhat);
fprintf('local bhat = [%.3f %.3f %.3f], e1 = [%.3f %.3f %.3f], e2 = [%.3f %.3f %.3f]\n', ...
    bhat, e1, e2);

Bpar   = bhat(1)*Bx + bhat(2)*By + bhat(3)*Bz;
Bperp1 = e1(1)*Bx   + e1(2)*By   + e1(3)*Bz;
Bperp2 = e2(1)*Bx   + e2(2)*By   + e2(3)*Bz;
clear Bx By Bz

dn = Ni - mean(Ni(:));   % density fluctuation, space+time mean removed
clear Ni

%% ---------------- SPACE-TIME FFT (identical convention to main script) --

dy = Ly/LYs * space_decim;
dz = Lz/LZs * space_decim;

ky = 2*pi*[0:floor(Ny/2)-1, -ceil(Ny/2):-1] / (Ny*dy);
kz = 2*pi*[0:floor(Nz/2)-1, -ceil(Nz/2):-1] / (Nz*dz);
[KY, KZ] = ndgrid(ky, kz);
Kperp = sqrt(KY.^2 + KZ.^2) * d_i_local;

r = 0.3;
w = tukeywin(Nt_used, r);
w = reshape(w, 1, 1, Nt_used);

omega = 2*pi*( -floor(Nt_used/2):(ceil(Nt_used/2)-1) )/(Nt_used*dt_eff);

fprintf('FFT: Bpar, Bperp1, Bperp2, dn ...\n');
FKpar = fftshift(fft(fft2(Bpar) .* w, [], 3), 3);   clear Bpar
FK1   = fftshift(fft(fft2(Bperp1).* w, [], 3), 3);   clear Bperp1
FK2   = fftshift(fft(fft2(Bperp2).* w, [], 3), 3);   clear Bperp2
FKn   = fftshift(fft(fft2(dn)    .* w, [], 3), 3);   clear dn

%% ---------------- PER-MODE (POINTWISE) QUANTITIES -----------------------

Pb_par   = abs(FKpar).^2;
Pb_perp1 = abs(FK1).^2;
Pb_perp2 = abs(FK2).^2;
Pb_tot   = Pb_par + Pb_perp1 + Pb_perp2;

Hnum = 2*imag(FK1 .* conj(FK2));   % helicity numerator, kept raw for power-weighted binning
Xnb  = FKn .* conj(FKpar);         % delta-n / delta-Bpar cross-spectrum, complex, pointwise
Pn   = abs(FKn).^2;

clear FK1 FK2

%% ---------------- BIN ONTO (k_perp, omega): POWER-WEIGHTED --------------

fprintf('Binning onto (k_perp, omega) grid...\n');
Nk_bins = round(Ny/2);
kperp_edges = linspace(0, max(Kperp(:)), Nk_bins+1);
kperp_centers = 0.5*(kperp_edges(1:end-1) + kperp_edges(2:end));
kbin = discretize(Kperp(:), kperp_edges);
valid  = ~isnan(kbin);
kbin_v = kbin(valid);

Cb_binned    = nan(Nk_bins, Nt_used, 'single');   % magnetic compressibility
sigma_binned = nan(Nk_bins, Nt_used, 'single');   % reduced magnetic helicity, [-1,1]
ratio_binned = nan(Nk_bins, Nt_used, 'single');   % rms(delta-n)/rms(delta-Bpar) per bin
phase_binned = nan(Nk_bins, Nt_used, 'single');   % phase(delta-n * conj(delta-Bpar)), radians
coh_binned   = nan(Nk_bins, Nt_used, 'single');   % delta-n / delta-Bpar coherence, [0,1]

for it = 1:Nt_used
    par_s = Pb_par(:,:,it);   par_s = par_s(valid);
    tot_s = Pb_tot(:,:,it);   tot_s = tot_s(valid);
    p1_s  = Pb_perp1(:,:,it); p1_s  = p1_s(valid);
    p2_s  = Pb_perp2(:,:,it); p2_s  = p2_s(valid);
    hnum_s = Hnum(:,:,it);    hnum_s = hnum_s(valid);
    n_s   = Pn(:,:,it);       n_s   = n_s(valid);
    x_s   = Xnb(:,:,it);      x_s   = x_s(valid);

    sum_par  = accumarray(kbin_v, par_s,  [Nk_bins,1]);
    sum_tot  = accumarray(kbin_v, tot_s,  [Nk_bins,1]);
    sum_p1   = accumarray(kbin_v, p1_s,   [Nk_bins,1]);
    sum_p2   = accumarray(kbin_v, p2_s,   [Nk_bins,1]);
    sum_hnum = accumarray(kbin_v, hnum_s, [Nk_bins,1]);
    sum_n    = accumarray(kbin_v, n_s,    [Nk_bins,1]);
    sum_xre  = accumarray(kbin_v, real(x_s), [Nk_bins,1]);
    sum_xim  = accumarray(kbin_v, imag(x_s), [Nk_bins,1]);
    sum_x    = sum_xre + 1i*sum_xim;

    Cb_binned(:,it)    = sum_par ./ max(sum_tot, eps);
    sigma_binned(:,it) = sum_hnum ./ max(sum_p1 + sum_p2, eps);
    ratio_binned(:,it) = sqrt( sum_n ./ max(sum_par, eps) );
    phase_binned(:,it) = angle(sum_x);
    coh_binned(:,it)   = abs(sum_x) ./ sqrt(max(sum_n .* sum_par, eps));
end

clear Pb_par Pb_perp1 Pb_perp2 Pb_tot Hnum Xnb Pn FKpar FKn

%% ---------------- DISPERSION OVERLAY: CURVES + EIGENVECTOR COMPARISON ---

if show_dispersion_overlay
    kperp_grid = linspace(1e-3, kperp_di_max, 400);
    omega_FW  = nan(size(kperp_grid));
    omega_KAW = nan(size(kperp_grid));
    Cb_FW  = nan(size(kperp_grid));  Cb_KAW  = nan(size(kperp_grid));
    sig_FW = nan(size(kperp_grid));  sig_KAW = nan(size(kperp_grid));
    ph_FW  = nan(size(kperp_grid));  ph_KAW  = nan(size(kperp_grid));

    kpar_over_kperp_FW  = 1/tand(theta_FW_deg);
    kpar_over_kperp_KAW = 1/tand(theta_KAW_deg);

    % one-time sanity check of the assumed state-vector mapping (div B=0)
    check_eigenvector_indices(1.0, 1.0/tand(theta_FW_deg), beta_local, Gamma);

    for ik = 1:numel(kperp_grid)
        kp_ = kperp_grid(ik);

        [om1, V1] = hallMHD_eig(kp_, kp_*kpar_over_kperp_FW,  beta_local, Gamma);
        [om2, V2] = hallMHD_eig(kp_, kp_*kpar_over_kperp_KAW, beta_local, Gamma);

        if numel(om1) >= 1 && ~isempty(V1)
            omega_FW(ik) = om1(1);
            v = V1(:,1);
            Cb_FW(ik)  = abs(v(8))^2 / (abs(v(6))^2+abs(v(7))^2+abs(v(8))^2 + eps);
            sig_FW(ik) = 2*imag(v(6)*conj(v(7))) / (abs(v(6))^2+abs(v(7))^2 + eps);
            ph_FW(ik)  = angle(v(1)*conj(v(8)));
        end
        if numel(om2) >= 2 && size(V2,2) >= 2
            omega_KAW(ik) = om2(2);
            v = V2(:,2);
            Cb_KAW(ik)  = abs(v(8))^2 / (abs(v(6))^2+abs(v(7))^2+abs(v(8))^2 + eps);
            sig_KAW(ik) = 2*imag(v(6)*conj(v(7))) / (abs(v(6))^2+abs(v(7))^2 + eps);
            ph_KAW(ik)  = angle(v(1)*conj(v(8)));
        end
    end
end

%% ---------------- PLOTS ---------------------------------------------------

plotArgs = {kperp_centers, omega};

figure('Color','w','Position',[80 80 1150 480]);
subplot(1,2,1);
pcolor(kperp_centers, omega, Cb_binned.'); shading interp; set(gca,'YDir','normal');
xlim([0 kperp_di_max]); ylim([0 omega_Oi_max]); caxis([0 1]);
xlabel('k_\perp d_i  (local)'); ylabel('\omega / \Omega_i');
cb = colorbar; ylabel(cb,'C_B = |B_{||}|^2 / |B|^2');
colormap(gca, turbo); title('Magnetic compressibility'); hold on;
if show_dispersion_overlay
    plot(kperp_grid, omega_FW,  'w--','LineWidth',1.6);
    plot(kperp_grid, omega_KAW, 'w-', 'LineWidth',1.6);
end

subplot(1,2,2);
pcolor(kperp_centers, omega, sigma_binned.'); shading interp; set(gca,'YDir','normal');
xlim([0 kperp_di_max]); ylim([0 omega_Oi_max]); caxis([-1 1]);
xlabel('k_\perp d_i  (local)'); ylabel('\omega / \Omega_i');
cb = colorbar; ylabel(cb,'\sigma_m  (reduced magnetic helicity)');
colormap(gca, redblue_cmap()); title('Reduced magnetic helicity (RH/LH)'); hold on;
if show_dispersion_overlay
    plot(kperp_grid, omega_FW,  'k--','LineWidth',1.6);
    plot(kperp_grid, omega_KAW, 'k-', 'LineWidth',1.6);
end

figure('Color','w','Position',[80 600 1550 460]);
subplot(1,3,1);
pcolor(kperp_centers, omega, log10(ratio_binned.'+eps)); shading interp; set(gca,'YDir','normal');
xlim([0 kperp_di_max]); ylim([0 omega_Oi_max]);
xlabel('k_\perp d_i'); ylabel('\omega / \Omega_i');
cb = colorbar; ylabel(cb,'log_{10} [ rms(\delta n)/rms(\delta B_{||}) ]');
colormap(gca, turbo); title('\delta n - \delta B_{||}  amplitude ratio'); hold on;
if show_dispersion_overlay
    plot(kperp_grid, omega_FW,  'w--','LineWidth',1.4);
    plot(kperp_grid, omega_KAW, 'w-', 'LineWidth',1.4);
end

subplot(1,3,2);
pcolor(kperp_centers, omega, phase_binned.'*180/pi); shading interp; set(gca,'YDir','normal');
xlim([0 kperp_di_max]); ylim([0 omega_Oi_max]); caxis([-180 180]);
xlabel('k_\perp d_i'); ylabel('\omega / \Omega_i');
cb = colorbar; ylabel(cb,'phase(\delta n, \delta B_{||})  [deg]');
colormap(gca, redblue_cmap()); title('\delta n - \delta B_{||}  phase'); hold on;
if show_dispersion_overlay
    plot(kperp_grid, omega_FW,  'k--','LineWidth',1.4);
    plot(kperp_grid, omega_KAW, 'k-', 'LineWidth',1.4);
end

subplot(1,3,3);
pcolor(kperp_centers, omega, coh_binned.'); shading interp; set(gca,'YDir','normal');
xlim([0 kperp_di_max]); ylim([0 omega_Oi_max]); caxis([0 1]);
xlabel('k_\perp d_i'); ylabel('\omega / \Omega_i');
cb = colorbar; ylabel(cb,'coherence');
colormap(gca, turbo); title('\delta n - \delta B_{||}  coherence'); hold on;
if show_dispersion_overlay
    plot(kperp_grid, omega_FW,  'w--','LineWidth',1.4);
    plot(kperp_grid, omega_KAW, 'w-', 'LineWidth',1.4);
end

%% ---------------- QUANTITATIVE DATA-VS-THEORY COMPARISON TABLE ---------

if show_dispersion_overlay
    fprintf('\n=== Data vs. Hall-MHD eigenvector prediction along the overlay curves ===\n');
    fprintf('(interpolating the measured, time-averaged diagnostic maps at (k_perp, omega_branch(k_perp)))\n\n');

    sample_k = linspace(1, min(kperp_di_max*0.9, kperp_di_max-1), 6);

    fprintf('--- FW branch (theta=%.1f deg) ---\n', theta_FW_deg);
    fprintf('%8s %10s %14s %14s %14s %14s\n', 'k_perp','omega_th','Cb_data','Cb_theory','sigma_data','sigma_theory');

    % griddedInterpolant requires the grid vectors and the value array to
    % share the same class -- Cb_binned/sigma_binned were preallocated as
    % 'single' while kperp_centers/omega are 'double', so cast once here.
    kperp_centers_d = double(kperp_centers);
    omega_d         = double(omega);
    Cb_binned_d     = double(Cb_binned);
    sigma_binned_d  = double(sigma_binned);
    Fc = griddedInterpolant({kperp_centers_d, omega_d}, Cb_binned_d,    'linear','none');
    Fs = griddedInterpolant({kperp_centers_d, omega_d}, sigma_binned_d, 'linear','none');

    for kk = sample_k
        om_th = interp1(kperp_grid, omega_FW, kk);
        Cb_th = interp1(kperp_grid, Cb_FW, kk);
        sig_th = interp1(kperp_grid, sig_FW, kk);
        Cb_data  = Fc(kk, om_th);
        sig_data = Fs(kk, om_th);
        fprintf('%8.2f %10.2f %14.3f %14.3f %14.3f %14.3f\n', kk, om_th, Cb_data, Cb_th, sig_data, sig_th);
    end

    fprintf('\n--- A/KAW branch (theta=%.1f deg) ---\n', theta_KAW_deg);
    fprintf('%8s %10s %14s %14s %14s %14s\n', 'k_perp','omega_th','Cb_data','Cb_theory','sigma_data','sigma_theory');
    for kk = sample_k
        om_th = interp1(kperp_grid, omega_KAW, kk);
        Cb_th = interp1(kperp_grid, Cb_KAW, kk);
        sig_th = interp1(kperp_grid, sig_KAW, kk);
        Cb_data  = Fc(kk, om_th);
        sig_data = Fs(kk, om_th);
        fprintf('%8.2f %10.2f %14.3f %14.3f %14.3f %14.3f\n', kk, om_th, Cb_data, Cb_th, sig_data, sig_th);
    end

    fprintf(['\nNote: the phase(delta n, delta B_par) THEORY values are computed in the toy\n' ...
             'solver''s own (rho0=1,B0=1) units, so only the PHASE (deg, unit-independent)\n' ...
             'is directly comparable to the data -- not the delta-n/delta-Bpar AMPLITUDE ratio,\n' ...
             'which depends on the real density normalization not present in the linear solver.\n']);
end

%% ==================== LOCAL FUNCTIONS ===================================

function p = parseReconnectionCxxParams(cxxFile)
    txt = fileread(cxxFile);
    p.mass_ratio = getNum(txt, 'g\.mass_ratio\s*=\s*([0-9.eE+-]+)\s*;');
    p.Zi         = getNum(txt, 'g\.Zi\s*=\s*([0-9.eE+-]+)\s*;');
    p.n          = getNum(txt, 'g\.n\s*=\s*([0-9.eE+-]+)\s*;');
    p.nb_over_n  = getNum(txt, 'g\.nb_over_n\s*=\s*([0-9.eE+-]+)\s*;');
    p.Ti0_over_Te0 = getNum(txt, 'g\.Ti0_over_Te0\s*=\s*([0-9.eE+-]+)\s*;');
    p.beta_total = getNum(txt, 'g\.beta_total\s*=\s*([0-9.eE+-]+)\s*;');
    p.L_over_di  = getNum(txt, 'g\.L_over_di\s*=\s*([0-9.eE+-]+)\s*;');
    p.Bg_over_B0 = getNum(txt, 'g\.Bg_over_B0\s*=\s*([0-9.eE+-]+)\s*;');
    p.B0         = getNum(txt, 'g\.B0\s*=\s*([0-9.eE+-]+)\s*;');
    p.pfield_out_interval = getNum(txt, 'outf_item_params\.pfield\.out_interval\s*=\s*(-?[0-9]+)\s*;');

    req = {'mass_ratio','B0','pfield_out_interval','n','nb_over_n','Ti0_over_Te0','beta_total','L_over_di'};
    for i = 1:numel(req)
        if isnan(p.(req{i}))
            error('Could not find %s in %s -- check the variable name/regex.', req{i}, cxxFile);
        end
    end
    if isnan(p.Zi), p.Zi = 1.0; end
    if isnan(p.Bg_over_B0), p.Bg_over_B0 = 0.0; end

    p.d_i = sqrt(p.mass_ratio / p.n);
    p.Omega_i_over_omegape = p.B0 / (p.mass_ratio * p.Zi);

    p.Ttot0 = p.beta_total * p.B0^2 / (2*p.n);
    p.Te0   = p.Ttot0 / (1 + p.Ti0_over_Te0);
    p.Ti0   = p.Ttot0 - p.Te0;
    p.beta_lobe_analytic = p.beta_total * p.nb_over_n;

    Lz_analytic = 2*pi*4*p.d_i;
    p.z1_di = -0.25*Lz_analytic/p.d_i;
    p.z2_di =  0.25*Lz_analytic/p.d_i;
end

function val = getNum(txt, pattern)
    tok = regexp(txt, pattern, 'tokens', 'once');
    if isempty(tok), val = NaN; else, val = str2double(tok{1}); end
end

function [lo_idx, hi_idx] = physRangeToIdx(range_de, L, N)
    lo = range_de(1); hi = range_de(2);
    lo_idx = max(1, round( (lo - (-L/2)) / (L/N) ) + 1);
    hi_idx = min(N, round( (hi - (-L/2)) / (L/N) ) + 1);
    if hi_idx <= lo_idx
        error('Requested physical range [%g %g] collapses to an empty index range.', lo, hi);
    end
end

function [e1, e2] = perpBasis(bhat)
    if abs(bhat(3)) < 0.9, ref = [0 0 1]; else, ref = [1 0 0]; end
    e1 = cross(ref, bhat); e1 = e1/norm(e1);
    e2 = cross(bhat, e1);  e2 = e2/norm(e2);
end

function dt_code = getGridDt(fileID)
    info = h5info(fileID);
    dt_code = NaN;
    for ig = 1:numel(info.Groups)
        atts = info.Groups(ig).Attributes;
        for ia = 1:numel(atts)
            if strcmpi(atts(ia).Name, 'dt')
                dt_code = double(atts(ia).Value);
                return;
            end
        end
    end
    if isnan(dt_code)
        error('Could not auto-find a "dt" attribute in %s. Run h5disp() to locate it.', fileID);
    end
end

function A = hallMHD_matrix(kperp, kpar, beta, Gamma)
% Same linearized ideal Hall-MHD system as in kw_diagram_reconnection.m.
% State vector (see header notes for derivation):
%   s1=rho' s2=v_perp,inplane s3=v_perp,outplane s4=v_par
%   s5=p'   s6=b_perp,inplane s7=b_perp,outplane s8=b_par
    B0 = 1; rho0 = 1;
    cs2 = Gamma*beta/2;
    T0  = cs2/Gamma;
    diL = 1;
    kp = kperp; kz = kpar;
    i_ = 1i;

    A = zeros(8,8);
    A(1,2) = -rho0*i_*kp;               A(1,4) = -rho0*i_*kz;
    A(2,1) = -i_*kp*T0/rho0;            A(2,5) = -i_*kp;
    A(2,6) =  i_*B0*kz/rho0;            A(2,8) = -i_*B0*kp/rho0;
    A(3,7) =  i_*B0*kz/rho0;
    A(4,1) = -i_*kz*T0/rho0;            A(4,5) = -i_*kz;
    A(5,2) = -(Gamma-1)*T0*i_*kp;       A(5,4) = -(Gamma-1)*T0*i_*kz;
    A(6,2) =  i_*B0*kz;                 A(6,7) = -diL*B0*kz^2/rho0;
    A(7,3) =  i_*B0*kz;                 A(7,6) =  diL*B0*kz^2/rho0;
    A(7,8) = -diL*B0*kz*kp/rho0;
    A(8,2) = -i_*B0*kp;                 A(8,7) =  diL*B0*kz*kp/rho0;
end

function omega3 = hallMHD_branches(kperp, kpar, beta, Gamma)
% Eigenvalues only (identical behaviour to kw_diagram_reconnection.m).
    A = hallMHD_matrix(kperp, kpar, beta, Gamma);
    lam = eig(A);
    om  = real(1i*lam);
    om  = sort(om(om > 1e-8), 'descend');
    if numel(om) < 3
        omega3 = [NaN NaN NaN];
    else
        omega3 = om(1:3).';
    end
end

function [om_sorted, V_sorted] = hallMHD_eig(kperp, kpar, beta, Gamma)
% Same eigenproblem, but also returns the eigenVECTORS, sorted the same
% way as hallMHD_branches sorts its eigenvalues (descending omega>0),
% so that column j of V_sorted is the eigenvector for om_sorted(j).
    A = hallMHD_matrix(kperp, kpar, beta, Gamma); % here is the minus k_par
    [V, D] = eig(A);
    lam = diag(D);
    om  = real(1i*lam);
    keep = om > 1e-8;
    om_k = om(keep); V_k = V(:,keep);
    [om_sorted, idx] = sort(om_k, 'descend');
    V_sorted = V_k(:, idx);
end

function check_eigenvector_indices(kperp, kpar, beta, Gamma)
% One-time sanity check that s6="b_perp,inplane" and s8="b_par" as
% assumed: div(B)=0 for this 2D (kperp,0,kpar) geometry requires
% kperp*b6 + kpar*b8 = 0 for every eigenvector. If the printed residual
% is not << 1, the state-vector mapping used elsewhere in this script
% (for Cb, sigma, phase theory curves) is WRONG for your matrix and
% those eigenvector-comparison numbers should not be trusted (the raw
% simulation diagnostics are computed independently and are unaffected).
    [om, V] = hallMHD_eig(kperp, kpar, beta, Gamma);
    fprintf('\n[sanity check] div(B)=0 residual for assumed indices (s6=b_perp,inplane, s8=b_par):\n');
    for j = 1:numel(om)
        v = V(:,j);
        resid = abs(kperp*v(6) + kpar*v(8));
        scale = max(abs(kperp*v(6)), abs(kpar*v(8))) + eps;
        fprintf('  mode %d: omega=%.4f   |kp*b6+kz*b8| / scale = %.3e  %s\n', ...
            j, om(j), resid/scale, ternary(resid/scale < 1e-6, '(OK)', '<-- CHECK INDEX MAPPING'));
    end
    fprintf('\n');
end

function out = ternary(cond, a, b)
    if cond, out = a; else, out = b; end
end

function cmap = redblue_cmap()
    n = 128;
    r = [linspace(0,1,n), ones(1,n)];
    g = [linspace(0,1,n), linspace(1,0,n)];
    b = [ones(1,n), linspace(1,0,n)];
    cmap = [r(:) g(:) b(:)];
end
