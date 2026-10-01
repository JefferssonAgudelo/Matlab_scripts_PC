%% kw_diagram_reconnection_filtered.m
%
% Same as kw_diagram_reconnection.m, but applies a 2D (y,z) Gaussian
% smoothing filter to every raw loaded field -- Bx,By,Bz, the ion/electron
% momentum components (px,py,pz for whichever species is selected), and
% the density (rho_i or rho_e) -- INDEPENDENTLY AT EACH SNAPSHOT, before
% any velocity computation, mean-field projection, or FFT. This is meant
% to knock down PIC particle-counting/grid noise (small-scale, spatially
% uncorrelated speckle) that otherwise spreads power across the whole
% k-omega plane and masks real structure.
%
% The filter is SPATIAL ONLY by default (gauss_sigma_t_snap = 0): it
% smooths each time snapshot independently, so it cannot smear out real
% wave oscillations in time. An optional temporal Gaussian smoothing
% knob is provided (gauss_sigma_t_snap > 0) if you want it, but use with
% care -- it will suppress genuine high-frequency wave content too.
%
% All physics/pipeline logic (parameter parsing, sub-window selection,
% local mean-field frame, space-time FFT, azimuthal binning, dispersion
% overlay) is otherwise IDENTICAL to kw_diagram_reconnection.m.
%
% -------------------------------------------------------------------

clear; clc; close all;

%% ---------------- USER INPUT ------------------------------------------

%cxxFile = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/cases_betae1_betai1/psc_reconnection_harris_2D_yz/psc_reconnection_harris_2D_yz_kap2.cxx'; % <<< EDIT if needed
%dataDir = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/cases_betae1_betai1/psc_reconnection_harris_2D_yz';   % <<< EDIT ME
%it_range = [];
%y_range_di = [];
%z_range_di = [-2, 2];


cxxFile = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/cases_betae1_betai1/psc_reconnection_harris_2D_yz_single_sheet_kappa/psc_reconnection_harris_2D_yz_kappa.cxx'; % <<< EDIT if needed
dataDir = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/cases_betae1_betai1/psc_reconnection_harris_2D_yz_single_sheet_kappa/';   % <<< EDIT ME
it_range = []; %this is where the selection of the region is made
y_range_di = [];
z_range_di = [2, 6];

field_choice = 'Bperp';   % 'Bperp' | 'Bpar' | 'uperp_i' | 'upar_i' | 'uperp_e' | 'upar_e'

space_decim = 2;

% --------- GAUSSIAN FILTER SETTINGS (NEW) --------------------------------
apply_gauss_filter = true;
gauss_sigma_pix    = 1.5;   % spatial smoothing width, in POST-DECIMATION grid cells (isotropic in y,z)
gauss_sigma_t_snap = 0;     % temporal smoothing width, in snapshots (0 = off; use with care, see header notes)
% ---------------------------------------------------------------------

show_dispersion_overlay = true;
theta_FW_deg  = 45;
theta_KAW_deg = 40;

EHJ_GROUP_IDX     = 16;
MOMENTS_GROUP_IDX = 1;
GRIDLEN_GROUP_IDX = 17;

kperp_di_max = 20;
omega_Oi_max = 12;

%% ---------------- PARSE .cxx FOR SIMULATION PARAMETERS -----------------

rp = parseReconnectionCxxParams(cxxFile);

fprintf('--- Parameters recovered from %s ---\n', cxxFile);
fprintf('  mass_ratio (mi/me)      = %g\n', rp.mass_ratio);
fprintf('  Zi                      = %g\n', rp.Zi);
fprintf('  n (reference/peak dens.)= %g\n', rp.n);
fprintf('  nb_over_n (lobe/n)      = %g\n', rp.nb_over_n);
fprintf('  Ti0_over_Te0            = %g\n', rp.Ti0_over_Te0);
fprintf('  beta_total (ref., peak) = %g\n', rp.beta_total);
fprintf('  L_over_di               = %g\n', rp.L_over_di);
fprintf('  Bg_over_B0 (guide field)= %g\n', rp.Bg_over_B0);
fprintf('  B0                      = %g\n', rp.B0);
fprintf('  pfield.out_interval     = %d steps\n', rp.pfield_out_interval);
fprintf('  d_i (in d_e units)      = %g\n', rp.d_i);
fprintf('  Omega_i / omega_pe      = %g\n', rp.Omega_i_over_omegape);
fprintf('  Ttot0, Te0, Ti0         = %g, %g, %g\n', rp.Ttot0, rp.Te0, rp.Ti0);
fprintf('  beta_lobe (analytic)    = %g\n', rp.beta_lobe_analytic);
if apply_gauss_filter
    fprintf('  Gaussian filter: sigma_space = %.2f pix, sigma_time = %.2f snapshots\n', ...
        gauss_sigma_pix, gauss_sigma_t_snap);
else
    fprintf('  Gaussian filter: OFF\n');
end

Gamma = 5/3;

%% ---------------- LOCATE & MATCH HDF5 FILES ----------------------------

S  = dir(fullfile(dataDir, 'pfd.*.h5'));
S2 = dir(fullfile(dataDir, 'pfd_moments.*.h5'));
if isempty(S),  error('No pfd.*.h5 files found in %s', dataDir); end
if isempty(S2), error('No pfd_moments.*.h5 files found in %s', dataDir); end

if isempty(it_range)
    it_range = 1:numel(S);
end
Nt_used = numel(it_range);

momentsFile = cell(Nt_used,1);
for n = 1:Nt_used
    it = it_range(n);
    stri = S(it).name;
    newStri = erase(stri, 'pfd.');
    Nff = {S2.name};
    match = find(contains(Nff, newStri), 1);
    if isempty(match)
        error('Could not find a pfd_moments file matching %s', stri);
    end
    momentsFile{n} = fullfile(dataDir, S2(match).name);
end
pfdFile = fullfile(dataDir, {S(it_range).name});

%% ---------------- GRID METADATA -----------------------------------------

info1 = h5info(pfdFile{1});
grid_length = info1.Groups(GRIDLEN_GROUP_IDX).Attributes;
Ly = grid_length(4).Value(2) - grid_length(3).Value(2);
Lz = grid_length(4).Value(3) - grid_length(3).Value(3);

dt_code = getGridDt(pfdFile{1});
dt_snapshot_omegape = rp.pfield_out_interval * dt_code;
dt_eff = dt_snapshot_omegape * rp.Omega_i_over_omegape;

fprintf('  Ly, Lz (d_e units)      = %g, %g\n', Ly, Lz);
fprintf('  snapshot cadence        = %g Omega_i^-1\n', dt_eff);
fprintf('  total time span         = %g Omega_i^-1  (%d snapshots)\n', dt_eff*(Nt_used-1), Nt_used);

%% ---------------- SPATIAL SUB-WINDOW: PHYSICAL -> GRID INDICES ---------

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

fprintf('  sub-window: y-idx [%d %d], z-idx [%d %d]  ->  %d x %d grid\n', ...
    y_lo_idx, y_hi_idx, z_lo_idx, z_hi_idx, Ny, Nz);

%% ---------------- LOAD RAW FIELDS OVER THE SUB-WINDOW & TIME RANGE -----

needVel = ismember(field_choice, {'uperp_i','upar_i','uperp_e','upar_e'});
species = '';
if needVel
    if contains(field_choice, '_i'), species = 'i'; else, species = 'e'; end
end

fprintf('Allocating cubes: %d x %d x %d (single precision)\n', Ny, Nz, Nt_used);
Bx = zeros(Ny,Nz,Nt_used,'single');
By = zeros(Ny,Nz,Nt_used,'single');
Bz = zeros(Ny,Nz,Nt_used,'single');
rho_i_mean = zeros(Nt_used,1);
if needVel
    % store RAW momentum + density (per species), filter these, THEN
    % compute the relativistic velocity from the filtered quantities.
    Px = zeros(Ny,Nz,Nt_used,'single');
    Py = zeros(Ny,Nz,Nt_used,'single');
    Pz = zeros(Ny,Nz,Nt_used,'single');
    Rho_sp = zeros(Ny,Nz,Nt_used,'single');
end

mi = rp.mass_ratio * rp.Zi;
me = 1;
c_code = 1;

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
    rho_i_mean(n) = mean(rho_i(:));

    if needVel
        if strcmp(species,'i')
            Px(:,:,n) = squeeze(h5read(fileID2, strcat(moms,'/px_i/p0/3d'), startVec, countVec, strideVec));
            Py(:,:,n) = squeeze(h5read(fileID2, strcat(moms,'/py_i/p0/3d'), startVec, countVec, strideVec));
            Pz(:,:,n) = squeeze(h5read(fileID2, strcat(moms,'/pz_i/p0/3d'), startVec, countVec, strideVec));
            Rho_sp(:,:,n) = rho_i;
        else
            Px(:,:,n) = squeeze(h5read(fileID2, strcat(moms,'/px_e/p0/3d'), startVec, countVec, strideVec));
            Py(:,:,n) = squeeze(h5read(fileID2, strcat(moms,'/py_e/p0/3d'), startVec, countVec, strideVec));
            Pz(:,:,n) = squeeze(h5read(fileID2, strcat(moms,'/pz_e/p0/3d'), startVec, countVec, strideVec));
            rho_e = -squeeze(h5read(fileID2, strcat(moms,'/rho_e/p0/3d'), startVec, countVec, strideVec));
            rho_e(rho_e==0) = 1e-20;
            Rho_sp(:,:,n) = rho_e;
        end
    end

    if mod(n,20)==0, fprintf('  loaded %d / %d\n', n, Nt_used); end
end

%% ---------------- GAUSSIAN FILTER: APPLIED TO ALL RAW FIELDS -----------

if apply_gauss_filter
    fprintf('Applying Gaussian filter (sigma_space=%.2f pix, sigma_time=%.2f snap) to Bx,By,Bz%s...\n', ...
        gauss_sigma_pix, gauss_sigma_t_snap, ternary_str(needVel, ', px,py,pz,rho', ''));
    sigmas = [gauss_sigma_pix, gauss_sigma_pix, gauss_sigma_t_snap];
    Bx = gaussianSmoothND(Bx, sigmas);
    By = gaussianSmoothND(By, sigmas);
    Bz = gaussianSmoothND(Bz, sigmas);
    if needVel
        Px = gaussianSmoothND(Px, sigmas);
        Py = gaussianSmoothND(Py, sigmas);
        Pz = gaussianSmoothND(Pz, sigmas);
        Rho_sp = gaussianSmoothND(Rho_sp, sigmas);
    end
end

%% ---------------- VELOCITY FROM (FILTERED) MOMENTUM + DENSITY ----------

if needVel
    if strcmp(species,'i'), m_sp = mi; else, m_sp = me; end
    vx = Px./Rho_sp; vy = Py./Rho_sp; vz = Pz./Rho_sp;
    Ux = vx.*c_code./sqrt(c_code^2*m_sp^2 + vx.^2);
    Uy = vy.*c_code./sqrt(c_code^2*m_sp^2 + vy.^2);
    Uz = vz.*c_code./sqrt(c_code^2*m_sp^2 + vz.^2);
    clear Px Py Pz Rho_sp vx vy vz
end

n_local = mean(rho_i_mean);
beta_local = 2*n_local*(rp.Ti0+rp.Te0)/rp.B0^2;
d_i_local  = sqrt(rp.mass_ratio/n_local);
fprintf('  measured local n (from rho_i)   = %g\n', n_local);
fprintf('  local beta (measured)           = %g\n', beta_local);
fprintf('  local d_i  (measured)           = %g d_e\n', d_i_local);

%% ---------------- LOCAL MEAN-FIELD FRAME & PROJECTION -------------------

Bbar = [mean(Bx(:)), mean(By(:)), mean(Bz(:))];
bhat = Bbar / norm(Bbar);
fprintf('  local mean field direction (x,y,z) = [%.3f %.3f %.3f], |B| = %.4g\n', ...
    bhat(1), bhat(2), bhat(3), norm(Bbar));

[e1, e2] = perpBasis(bhat);

Bpar   = bhat(1)*Bx + bhat(2)*By + bhat(3)*Bz;
Bperp1 = e1(1)*Bx   + e1(2)*By   + e1(3)*Bz;
Bperp2 = e2(1)*Bx   + e2(2)*By   + e2(3)*Bz;
clear Bx By Bz

if needVel
    Upar   = bhat(1)*Ux + bhat(2)*Uy + bhat(3)*Uz;
    Uperp1 = e1(1)*Ux   + e1(2)*Uy   + e1(3)*Uz;
    Uperp2 = e2(1)*Ux   + e2(2)*Uy   + e2(3)*Uz;
    clear Ux Uy Uz
end

switch field_choice
    case 'Bperp',   F1 = Bperp1; F2 = Bperp2; isVector = true;
    case 'Bpar',    F1 = Bpar;                isVector = false;
    case 'uperp_i', F1 = Uperp1; F2 = Uperp2; isVector = true;
    case 'upar_i',  F1 = Upar;                isVector = false;
    case 'uperp_e', F1 = Uperp1; F2 = Uperp2; isVector = true;
    case 'upar_e',  F1 = Upar;                isVector = false;
end
clear Bpar Bperp1 Bperp2

%% ---------------- SPACE-TIME FFT ---------------------------------------

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

fprintf('Computing 2D spatial FFT for each time slice...\n');
FK1 = fft2(F1);
if isVector, FK2 = fft2(F2); end
clear F1 F2

fprintf('Applying time window and FFT in time...\n');
FK1 = FK1 .* w;
FKW1 = fftshift(fft(FK1, [], 3), 3);
if isVector
    FK2 = FK2 .* w;
    FKW2 = fftshift(fft(FK2, [], 3), 3);
end
clear FK1 FK2

P = abs(FKW1).^2;
if isVector, P = P + abs(FKW2).^2; end
clear FKW1 FKW2
P = P / (Ny*Nz*Nt_used)^2 * dt_eff * dy*dz;

%% ---------------- AZIMUTHAL AVERAGE TO P(k_perp, omega) ----------------

fprintf('Binning onto (k_perp, omega) grid...\n');
Nk_bins = round(Ny/2);
kperp_edges = linspace(0, max(Kperp(:)), Nk_bins+1);
kperp_centers = 0.5*(kperp_edges(1:end-1) + kperp_edges(2:end));
kbin = discretize(Kperp(:), kperp_edges);

Pkw = zeros(Nk_bins, Nt_used, 'single');
counts = accumarray(kbin(~isnan(kbin)), 1, [Nk_bins,1]);
for it = 1:Nt_used
    slice = P(:,:,it); slice = slice(:);
    valid = ~isnan(kbin);
    s = accumarray(kbin(valid), slice(valid), [Nk_bins,1]);
    Pkw(:,it) = s ./ max(counts,1);
end
clear P

%% ---------------- OPTIONAL DISPERSION RELATION OVERLAY ------------------

if show_dispersion_overlay
    kperp_grid = linspace(1e-3, kperp_di_max, 400);
    omega_FW  = nan(size(kperp_grid));
    omega_KAW = nan(size(kperp_grid));
    kpar_over_kperp_FW  = 1/tand(theta_FW_deg);
    kpar_over_kperp_KAW = 1/tand(theta_KAW_deg);
    for ik = 1:numel(kperp_grid)
        kp_ = kperp_grid(ik);
        b1 = hallMHD_branches(kp_, kp_*kpar_over_kperp_FW,  beta_local, Gamma);
        b2 = hallMHD_branches(kp_, kp_*kpar_over_kperp_KAW, beta_local, Gamma);
        omega_FW(ik)  = b1(1);
        omega_KAW(ik) = b2(2);
    end
end

%% ---------------- PLOT --------------------------------------------------

figure('Color','w','Position',[100 100 650 550]);
pcolor(kperp_centers, omega, log10(Pkw.'+eps)); shading interp;
set(gca,'YDir','normal');
xlim([0 kperp_di_max]); ylim([0 omega_Oi_max]);
xlabel('k_\perp d_i  (local)'); ylabel('\omega / \Omega_i');
cb = colorbar; ylabel(cb, 'log_{10} P(k_\perp,\omega)');
colormap(turbo); hold on;

if show_dispersion_overlay
    plot(kperp_grid, omega_FW,  'w--', 'LineWidth', 1.8, ...
        'DisplayName', sprintf('FW (\\theta=%.1f%s)', theta_FW_deg, char(176)));
    plot(kperp_grid, omega_KAW, 'w-',  'LineWidth', 1.8, ...
        'DisplayName', sprintf('A/KAW (\\theta=%.1f%s)', theta_KAW_deg, char(176)));
    legend('Location','southeast','TextColor','w','Color','none');
end

filt_str = '';
if apply_gauss_filter, filt_str = sprintf('  [Gauss \\sigma=%.1f pix]', gauss_sigma_pix); end
title(sprintf('k\\omega: %s   [y:%s, z:%s d_i]   \\beta_{local}=%.2f%s', ...
    field_choice, mat2str(y_range_di), mat2str(z_range_di), beta_local, filt_str), ...
    'Interpreter','tex');


%% ==================== LOCAL FUNCTIONS ===================================

function s = ternary_str(cond, a, b)
    if cond, s = a; else, s = b; end
end

function out = gaussianSmoothND(A, sigmas)
% Separable Gaussian smoothing along each dimension of A independently.
% sigmas(d) = smoothing width (in grid units of that dimension) for
% dimension d; sigmas(d) <= 0 skips that dimension entirely (no-op).
% Uses replicate (edge-clamped) boundary handling, no toolbox required.
    out = A;
    for d = 1:numel(sigmas)
        if sigmas(d) > 0
            out = smoothAlongDim(out, d, sigmas(d));
        end
    end
end

function out = smoothAlongDim(A, dim, sigma)
    half = ceil(3*sigma);
    if half < 1, out = A; return; end
    x = -half:half;
    g = exp(-(x.^2)/(2*sigma^2));
    g = g / sum(g);

    n = size(A, dim);
    idx = (1-half):(n+half);
    idx = min(max(idx, 1), n);

    S.type = '()';
    S.subs = repmat({':'}, 1, ndims(A));
    S.subs{dim} = idx;
    Apad = subsref(A, S);

    sz = ones(1, ndims(A)); sz(dim) = numel(g);
    gk = reshape(g, sz);

    out = convn(Apad, gk, 'valid');
end

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
    p.pfield_out_interval = getNum(txt, ...
        'outf_item_params\.pfield\.out_interval\s*=\s*(-?[0-9]+)\s*;');

    req = {'mass_ratio','B0','pfield_out_interval','n','nb_over_n', ...
           'Ti0_over_Te0','beta_total','L_over_di'};
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
end

function val = getNum(txt, pattern)
    tok = regexp(txt, pattern, 'tokens', 'once');
    if isempty(tok)
        val = NaN;
    else
        val = str2double(tok{1});
    end
end

function [lo_idx, hi_idx] = physRangeToIdx(range_de, L, N)
    lo = range_de(1); hi = range_de(2);
    lo_idx = max(1, round( (lo - (-L/2)) / (L/N) ) + 1);
    hi_idx = min(N, round( (hi - (-L/2)) / (L/N) ) + 1);
    if hi_idx <= lo_idx
        error('Requested physical range [%g %g] collapses to an empty index range; check units/box size.', lo, hi);
    end
end

function [e1, e2] = perpBasis(bhat)
    if abs(bhat(3)) < 0.9
        ref = [0 0 1];
    else
        ref = [1 0 0];
    end
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
        error(['Could not auto-find a "dt" attribute in %s.\n' ...
               'Run h5disp(''%s'') to locate the timestep attribute manually.'], fileID, fileID);
    end
end

function omega3 = hallMHD_branches(kperp, kpar, beta, Gamma)
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

    lam = eig(A);
    om  = real(1i*lam);
    om  = sort(om(om > 1e-8), 'descend');
    if numel(om) < 3
        omega3 = [NaN NaN NaN];
    else
        omega3 = om(1:3).';
    end
end
