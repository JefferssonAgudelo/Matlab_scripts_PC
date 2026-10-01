%% kw_realspace_islands_check.m
%
% Companion script to kw_diagram_reconnection.m /
% kw_polarization_diagnostics.m. Purely a visual/real-space check --
% no spectral processing -- to see directly whether there is a chain of
% blob-like (plasmoid/island) structures along y in your sub-window,
% spaced ~2 d_i apart, as suggested by the k-omega comb at
% k_perp d_i ~ 3, 6, 9, 13 ...
%
% Produces:
%   FIGURE 1: 2D real-space (y,z) snapshots of density and B_par, at a
%             handful of representative times, with dashed guide lines
%             every 2 d_i (LOCAL, measured d_i) along y so you can just
%             count/measure blob spacing by eye.
%   FIGURE 2: y-t "keogram" (fixed z, all times) of density and B_par
%             fluctuations, y in LOCAL d_i units, t in Omega_i^-1. A
%             chain of near-vertical, evenly-spaced stripes = a
%             quasi-static structure at fixed y locations (consistent
%             with bound islands/flux ropes). Diagonal streaks would
%             indicate propagating features instead.
%
% NOTE ON THE z-WINDOW UNIT ISSUE discussed previously: z_range_di below
% is converted using rp.d_i (the REFERENCE/peak-density d_i), exactly as
% in the original scripts, for direct consistency with those. The
% console printout below also reports the window extent in the
% LOCAL (measured) d_i, so you can see the true physical size/placement
% of the window you're actually looking at.
%
% -------------------------------------------------------------------

clear; clc; close all;

%% ---------------- USER INPUT --------------------------------------------

cxxFile = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/cases_betae1_betai1/psc_reconnection_harris_2D_yz/psc_reconnection_harris_2D_yz_kap2.cxx'; % <<< EDIT if needed
dataDir = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/cases_betae1_betai1/psc_reconnection_harris_2D_yz';   % <<< EDIT ME

it_range = [];          % [] = all available
y_range_di = [];        % [] = full y-extent
z_range_di = [-2, 2];   % <<< same sub-window as before, for direct comparison

space_decim = 1;        % keep full resolution here; this is a light script

n_snapshots_fig1 = 4;   % how many time snapshots to show in the 2D panel
guide_spacing_di = 2;   % expected island spacing to overlay as guide lines

EHJ_GROUP_IDX     = 16;
MOMENTS_GROUP_IDX = 1;
GRIDLEN_GROUP_IDX = 17;

%% ---------------- PARSE .cxx, LOCATE FILES (identical to companion scripts) ---

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
dt_eff = dt_snapshot_omegape * rp.Omega_i_over_omegape;   % Omega_i^-1 units

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

fprintf('sub-window (nominal, using reference d_i=%.4g d_e): y-idx [%d %d], z-idx [%d %d] -> %d x %d grid, %d snapshots\n', ...
    rp.d_i, y_lo_idx, y_hi_idx, z_lo_idx, z_hi_idx, Ny, Nz, Nt_used);

%% ---------------- LOAD Bx,By,Bz AND FULL rho_i FIELD --------------------

Bx = zeros(Ny,Nz,Nt_used,'single');
By = zeros(Ny,Nz,Nt_used,'single');
Bz = zeros(Ny,Nz,Nt_used,'single');
Ni = zeros(Ny,Nz,Nt_used,'single');

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
d_i_local  = sqrt(rp.mass_ratio/n_local);

%% ---------------- LOCAL MEAN-FIELD FRAME & Bpar PROJECTION --------------

Bbar = [mean(Bx(:)), mean(By(:)), mean(Bz(:))];
bhat = Bbar / norm(Bbar);
Bpar = bhat(1)*Bx + bhat(2)*By + bhat(3)*Bz;
clear Bx By Bz

dn = Ni - mean(Ni(:));           % density fluctuation (global mean removed)
dBpar = Bpar - mean(Bpar(:));    % Bpar fluctuation (global mean removed)

%% ---------------- PHYSICAL AXES (LOCAL d_i units) -----------------------

dy = Ly/LYs; dz = Lz/LZs;   % NOTE: physical grid spacing, independent of space_decim
y_de = -Ly/2 + (yIdx-1)*dy;
z_de = -Lz/2 + (zIdx-1)*dz;
y_di = y_de / d_i_local;
z_di = z_de / d_i_local;

t_Oci = (it_range - it_range(1)) * dt_eff;   % Omega_i^-1, relative to first loaded snapshot

Ly_local_di = (y_di(end)-y_di(1));
Nz_local_di = (z_di(end)-z_di(1));
fprintf('\n--- TRUE local-unit window (using measured local d_i = %.4g d_e) ---\n', d_i_local);
fprintf('  y window: [%.3f, %.3f] local d_i   (width %.2f local d_i)\n', y_di(1), y_di(end), Ly_local_di);
fprintf('  z window: [%.3f, %.3f] local d_i   (width %.2f local d_i)\n', z_di(1), z_di(end), Nz_local_di);
fprintf('  time span: %.2f Omega_i^-1 (%d snapshots, cadence %.3f Omega_i^-1)\n', t_Oci(end), Nt_used, dt_eff);
fprintf('  If islands are spaced ~%.1f local d_i apart, expect ~%.0f of them across the y window.\n\n', ...
    guide_spacing_di, Ly_local_di/guide_spacing_di);

%% ---------------- FIGURE 1: 2D REAL-SPACE SNAPSHOTS ----------------------

snap_idx = round(linspace(1, Nt_used, n_snapshots_fig1));
y_guides = (floor(y_di(1)/guide_spacing_di):ceil(y_di(end)/guide_spacing_di)) * guide_spacing_di;

figure('Color','w','Position',[60 60 1500 560]);
for c = 1:n_snapshots_fig1
    it = snap_idx(c);

    subplot(2, n_snapshots_fig1, c);
    pcolor(y_di, z_di, dn(:,:,it).'); shading interp; set(gca,'YDir','normal');
    hold on;
    for g = y_guides, xline(g, 'w:', 'LineWidth', 0.6); end
    xlabel('y / d_i (local)'); if c==1, ylabel('z / d_i (local)   \delta n'); end
    title(sprintf('t = %.2f \\Omega_i^{-1}', t_Oci(it)));
    colorbar; colormap(gca, turbo); axis tight;

    subplot(2, n_snapshots_fig1, n_snapshots_fig1 + c);
    pcolor(y_di, z_di, dBpar(:,:,it).'); shading interp; set(gca,'YDir','normal');
    hold on;
    for g = y_guides, xline(g, 'w:', 'LineWidth', 0.6); end
    xlabel('y / d_i (local)'); if c==1, ylabel('z / d_i (local)   \delta B_{||}'); end
    colorbar; colormap(gca, turbo); axis tight;
end
sgtitle('Real-space snapshots: dotted lines every 2 local d_i along y -- count/measure blob spacing directly');

%% ---------------- FIGURE 2: y-t KEOGRAM AT FIXED z -----------------------

iz_mid = round(Nz/2);   % middle of the loaded z sub-window (~ z=0, box center)

figure('Color','w','Position',[60 650 1150 480]);
subplot(1,2,1);
pcolor(t_Oci, y_di, squeeze(dn(:,iz_mid,:))); shading interp; set(gca,'YDir','normal');
hold on;
for g = y_guides, yline(g, 'w:', 'LineWidth', 0.6); end
xlabel('t  [\Omega_i^{-1}]'); ylabel('y / d_i (local)');
title(sprintf('\\delta n  at fixed z = %.2f d_i', z_di(iz_mid)));
colorbar; colormap(gca, turbo);

subplot(1,2,2);
pcolor(t_Oci, y_di, squeeze(dBpar(:,iz_mid,:))); shading interp; set(gca,'YDir','normal');
hold on;
for g = y_guides, yline(g, 'w:', 'LineWidth', 0.6); end
xlabel('t  [\Omega_i^{-1}]'); ylabel('y / d_i (local)');
title(sprintf('\\delta B_{||}  at fixed z = %.2f d_i', z_di(iz_mid)));
colorbar; colormap(gca, turbo);

sgtitle('y-t keogram: vertical evenly-spaced stripes = quasi-static structures at fixed y (islands); diagonal streaks = propagating features');

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
