%% psc_time_evolution_plots.m
%
% Loops over the PSC field-dump files (pfd.*.h5) in a run directory, builds
% the same 3-panel diagnostics used for the initial-condition check (B & J
% maps, pressure cuts, out-of-plane flux function) but from the ACTUAL
% simulation output at each dump, and saves one PNG per figure per time
% step into an output folder.
%
% All physical parameters (mass ratio, B0, domain size, Alfven speed,
% omega_pe/Omega_ce, temperatures, etc.) are parsed DIRECTLY from the .cxx
% source file that sits alongside the data -- no manually-copied numbers.
%
% COLOR/AXIS LIMITS ARE FIXED ACROSS TIME via config constants (B_x_clim,
% B_y_clim, ..., pressure_ylim) that you set directly -- no scanning pass,
% so frames are directly comparable and this runs at the same speed as
% before. Adjust the numbers in the CONFIG block if a run under/overflows
% them (Figure 1 will just look saturated/washed out, not error out).
%
% Data layout: the xdmf declares each HDF5 dataset as (z, y, x) with x
% trivial, BUT MATLAB's h5read returns dimensions in REVERSE order
% relative to that declaration (row-major/C storage vs MATLAB's
% column-major convention) -- confirmed empirically. read_psc_fields.m /
% read_psc_moments_pressure.m transpose back to a (nz, ny) convention.
%
%   field group:   /<hash>/hx_fc/p0/3d , hy_fc, hz_fc, jx_ec, jy_ec, jz_ec
%   moments group: /<hash>/rho_e/p0/3d, rho_i, px_e/py_e/pz_e (and _i),
%     txx_e/tyy_e/tzz_e (and _i)
%
%     IMPORTANT: rho_e is stored charge-density-like (sign-flipped
%     relative to number density) -- flipped back inside the helper.
%     txx/tyy/tzz are NOT the temperature -- they are the RAW second
%     velocity moment (n*m*<v_i v_j>, still containing the bulk-flow
%     term). The true (rest-frame) pressure tensor needs a Reynolds
%     decomposition: P_ij = T_ij_raw - n*m*v_i*v_j, with v obtained
%     relativistically from the momentum density -- see
%     read_psc_moments_pressure.m for the full derivation.
%
% Requires (same folder): get_cxx_param.m, find_group_with_subgroup.m,
% read_psc_fields.m, read_psc_moments_pressure.m
%
% Only base MATLAB is required otherwise (h5read/h5info, regexp).

clear; close all; clc;

%% ==================== USER CONFIG -- edit this block ====================

path = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/cases_betae1_betai1/psc_reconnection_harris_2D_yz_sigle_sheet3';
%path = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/cases_betae1_betai1/psc_reconnection_harris_2D_yz_sigle_sheet_kappa';
%path = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/cases_betae1_betai1/psc_reconnection_harris_2D_yz_sigle_sheet2';
%path = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/cases_betae1_betai1/psc_reconnection_harris_2D_yz_sigle_sheet';
%path = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/cases_betae1_betai1/turbulence_2D_maxwell_betaei1_maxwell';

pathscript = '/home/UNN/pfcy6/codes/processing_scripts/Matlab_Scripts_PC0/maxwell_kappa_reconnection_analysis';

cxx_candidates = dir(fullfile(path, '*.cxx'));
if numel(cxx_candidates) == 1
    cxxfile = fullfile(path, cxx_candidates(1).name);
elseif numel(cxx_candidates) > 1
    error(['Multiple .cxx files found in %s -- set cxxfile explicitly:\n%s'], ...
          path, strjoin({cxx_candidates.name}, ', '));
else
    error('No .cxx file found in %s -- set cxxfile explicitly.', path);
end

outdir = fullfile(path, 'evolution_frames');
if ~exist(outdir, 'dir'); mkdir(outdir); end

% plotting decimation: the real grid is ~5992 x 3000 -- plotting every
% point at every time step is slow and memory-heavy, so subsample for the
% figures (does NOT affect the physics, only the plotted resolution)
decimate = 4;   % keep every 4th point in each direction; set to 1 for full-res

% If auto-detection of the per-step HDF5 group (via find_group_with_subgroup)
% doesn't match your PSC build, set these directly instead -- e.g.
%   field_group_override   = '/jeh-uid-0x18baef0';
%   moments_group_override = '/all_1st_cc-uid-0x18b5b60';
% Leave empty ('') to keep auto-detection.
field_group_override   = '';
moments_group_override = '';

% Fixed color/axis limits across all time steps, so frames are directly
% comparable (a fixed feature looks the same size/color everywhere rather
% than being rescaled per frame). Adjust these based on your run's known
% field strengths -- e.g. B_y_clim ~ a few times B0, J_x_clim ~ B0/L, etc.
% caxis for B_x/B_y/B_z and J_x/J_y/J_z is set to [-clim, clim].
B_x_clim = 0.1;
B_y_clim = 0.5;
B_z_clim = 0.05;
J_x_clim = 0.1;
J_y_clim = 0.02;
J_z_clim = 0.02;

% ylim for Figure 2's pressure cuts
pressure_ylim = [0, 0.1];

%% ============== read physical parameters straight from the .cxx =========

txt = fileread(cxxfile);

mass_ratio           = get_cxx_param(txt, 'g\.mass_ratio');
Zi                    = get_cxx_param(txt, 'g\.Zi');
me                    = get_cxx_param(txt, 'g\.me');
n0                    = get_cxx_param(txt, 'g\.n(?![a-zA-Z_])');
omegape_Omegace       = get_cxx_param(txt, 'g\.omegape_Omegace');
Bg_over_B0            = get_cxx_param(txt, 'g\.Bg_over_B0');
nb_over_n             = get_cxx_param(txt, 'g\.nb_over_n');
Ti0_over_Te0          = get_cxx_param(txt, 'g\.Ti0_over_Te0');
beta_total            = get_cxx_param(txt, 'g\.beta_total');
L_over_di             = get_cxx_param(txt, 'g\.L_over_di');
psi0_over_B0L         = get_cxx_param(txt, 'g\.psi0_over_B0L');
pert_width_y_over_di  = get_cxx_param(txt, 'g\.pert_width_y_over_di');
pert_width_z_over_L   = get_cxx_param(txt, 'g\.pert_width_z_over_L');

Ly_factor = get_cxx_param(txt, 'Ly\s*=\s*([-+0-9.eEdD]+)\s*\*\s*g\.d_i', true);
Lz_factor = get_cxx_param(txt, 'Lz\s*=\s*([-+0-9.eEdD]+)\s*\*\s*g\.d_i', true);

gdims_tok = regexp(txt, 'Int3\s+gdims\s*=\s*\{\s*([-+0-9]+)\s*,\s*([-+0-9]+)\s*,\s*([-+0-9]+)\s*\}', 'tokens', 'once');
if ~isempty(gdims_tok)
    nx_cxx = str2double(gdims_tok{1});
    ny_cxx = str2double(gdims_tok{2});
    nz_cxx = str2double(gdims_tok{3});
else
    warning('Could not find "Int3 gdims = {...}" in %s -- skipping resolution sanity check.', cxxfile);
    ny_cxx = []; nz_cxx = [];
end

mi = mass_ratio * Zi;
d_i = sqrt(mass_ratio / n0);
L = L_over_di * d_i;
Ly = Ly_factor * d_i;
Lz = Lz_factor * d_i;
B0 = 1.0 / omegape_Omegace;


Ttot0 = beta_total * B0^2 / (2.0 * n0);
Te0 = Ttot0 / (1.0 + Ti0_over_Te0);
Ti0 = Ttot0 - Te0;

wy = pert_width_y_over_di * d_i;
wz = pert_width_z_over_L * L;
psi0 = psi0_over_B0L * B0 * L;

vA = B0 / sqrt(mi * n0);

fprintf('==== parameters parsed from %s ====\n', cxxfile);
fprintf('mass_ratio (mi/me) = %.6g,  Zi = %.6g,  me = %.6g,  mi = %.6g\n', mass_ratio, Zi, me, mi);
fprintf('n0 = %.6g,  d_i = %.6g,  L = %.6g (%.6g d_i)\n', n0, d_i, L, L_over_di);
fprintf('omega_pe/Omega_ce = %.6g  ->  B0 = %.6g\n', omegape_Omegace, B0);
fprintf('Alfven speed v_A/c = %.6g\n', vA);
fprintf('Ti0_over_Te0 = %.6g,  beta_total = %.6g  ->  Te0 = %.6g, Ti0 = %.6g\n', ...
        Ti0_over_Te0, beta_total, Te0, Ti0);
fprintf('nb_over_n = %.6g,  Bg_over_B0 = %.6g\n', nb_over_n, Bg_over_B0);
fprintf('Ly = %.6g (%.6g d_i),  Lz = %.6g (%.6g d_i)\n', Ly, Ly_factor, Lz, Lz_factor);
fprintf('perturbation: psi0 = %.6g, wy = %.6g, wz = %.6g\n', psi0, wy, wz);
if ~isempty(ny_cxx)
    fprintf('.cxx grid (for sanity check): ny = %d, nz = %d\n', ny_cxx, nz_cxx);
end
fprintf('=====================================================\n\n');

%% ==========================================================================

cd(path)
S  = dir(fullfile(path, 'pfd.*.h5'));
S2 = dir(fullfile(path, 'pfd_moments.*.h5'));

get_step = @(name) str2double(regexp(name, '(?<=\.)\d+(?=_)', 'match', 'once'));

steps = arrayfun(@(s) get_step(s.name), S);
[steps, order] = sort(steps);
S = S(order);
N = numel(S);

moments_lookup = containers.Map('KeyType', 'double', 'ValueType', 'char');
for k = 1:numel(S2)
    moments_lookup(get_step(S2(k).name)) = S2(k).name;
end

%fname = fullfile(path, S(1).name);
%info = h5info(fname);
%field_group_override = info.Groups(16).Name;

%mfname = fullfile(path, S2(1).name);
%minfo = h5info(fname);
%moments_group_override = minfo.Groups(16).Name;



fprintf('found %d field files, steps %d to %d\n', N, steps(1), steps(end));

%% ================= build and save the figures ============================
fprintf('\n');

% blue-white-red diverging colormap (no toolbox needed)
m = 256; half = floor(m/2);
cmap = [interp1([0 1], [0 0 1; 1 1 1], linspace(0, 1, half)); ...
        interp1([0 1], [1 1 1; 1 0 0], linspace(0, 1, m-half))];

for i = N-1:N

    fname = fullfile(path, S(i).name);
    step = steps(i);
    fprintf('[%d/%d] step %d : %s\n', i, N, step, S(i).name);
    
    try
        cd(pathscript);
        [Bx, By, Bz, Jx, Jy, Jz] = read_psc_fields(fname, field_group_override);
        cd(path);
    catch ME
        warning('failed to read %s: %s -- skipping', S(i).name, ME.message);
        continue
    end

    [nz_data, ny_data] = size(Bx);
    if ~isempty(ny_cxx) && (ny_data ~= ny_cxx || nz_data ~= nz_cxx)
        warning(['Array size [%d,%d] from %s does not match gdims from the ' ...
                 '.cxx [%d,%d] -- domain/resolution may have changed, or ' ...
                 'the (z,y) ordering assumption is wrong for this file.'], ...
                 nz_data, ny_data, S(i).name, nz_cxx, ny_cxx);
    end

    y = linspace(-Ly/2, Ly/2, ny_data);
    z = linspace(-Lz/2, Lz/2, nz_data);

    P_particle_full = [];
    if isKey(moments_lookup, step)
        try
            mfname = fullfile(path, moments_lookup(step));
            cd(pathscript);
            P_particle_full = read_psc_moments_pressure(mfname, moments_group_override, me, mi);
            cd(path);
        catch ME
            warning('could not read moments for step %d: %s', step, ME.message);
            P_particle_full = [];
        end
    end

    %% ---- Figure 1: 2D (y,z) maps of B and J (decimated, FIXED caxis) ----
    idx_y = 1:decimate:ny_data;
    idx_z = 1:decimate:nz_data;
    yp = y(idx_y); zp = z(idx_z);

    fig1 = figure('Visible', 'off', 'Position', [100 100 1400 750]);
    B_fields = {Bx(idx_z,idx_y), By(idx_z,idx_y), Bz(idx_z,idx_y)};
    B_labels = {'B_x', 'B_y', 'B_z'};
    B_clims  = {B_x_clim, B_y_clim, B_z_clim};
    J_fields = {Jx(idx_z,idx_y), Jy(idx_z,idx_y), Jz(idx_z,idx_y)};
    J_labels = {'J_x', 'J_y', 'J_z'};
    J_clims  = {J_x_clim, J_y_clim, J_z_clim};

    for k = 1:3
        subplot(2,3,k)
        imagesc(yp./d_i, zp./d_i, B_fields{k}); set(gca, 'YDir', 'normal');
        colormap(gca, cmap); caxis([-B_clims{k}, B_clims{k}]); colorbar;
        title(B_labels{k}); xlabel('y / d_i'); ylabel('z / d_i');
    end
    for k = 1:3
        subplot(2,3,3+k)
        imagesc(yp./d_i, zp./d_i, J_fields{k}); set(gca, 'YDir', 'normal');
        colormap(gca, cmap); caxis([-J_clims{k}, J_clims{k}]); colorbar;
        title(J_labels{k}); xlabel('y / d_i'); ylabel('z / d_i');
    end
    sgtitle(sprintf('step %d', step));
    saveas(fig1, fullfile(outdir, sprintf('fig1_fields_step%09d.png', step)));
    close(fig1);

    %% ---- Figure 2: 1D cuts at y=0 of pressure (FIXED ylim) ----
    % 0.013 for the maxwell with 1000 ppc 

    [~, iy0] = min(abs(y));
    P_B = 0.5 .* (Bx(:,iy0).^2 + By(:,iy0).^2 + Bz(:,iy0).^2);

    fig2 = figure('Visible', 'off', 'Position', [100 100 700 500]);
    plot(z./d_i, P_B, 'LineWidth', 1.5, 'Color', [0 0.447 0.741]); hold on;
    legend_entries = {'P_B'};
    if ~isempty(P_particle_full)
        P_particle_cut = P_particle_full(:, iy0);
        P_total = P_B + P_particle_cut*0.013;
        plot(z./d_i, P_particle_cut*0.013, 'LineWidth', 1.5, 'Color', [0.850 0.325 0.098]);
        plot(z./d_i, P_total, 'LineWidth', 2, 'Color', [0.466 0.674 0.188]);
        legend_entries = [legend_entries, {'P_{particle}', 'P_{total}'}];
    end
    plot([z(1) z(end)]./d_i, [0.5*B0^2*(1.0+nb_over_n) 0.5*B0^2*(1.0+nb_over_n)], ':', 'Color', [0.5 0.5 0.5]);
    legend_entries = [legend_entries, {'expected flat P_{total} at t=0'}];
    xlabel('z / d_i'); ylabel('pressure (code units)');
    title(sprintf('Pressure at y=0, step %d', step));
    legend(legend_entries, 'Location', 'best');
    ylim(pressure_ylim);
    grid on;
    saveas(fig2, fullfile(outdir, sprintf('fig2_pressure_step%09d.png', step)));
    close(fig2);

    %% ---- Figure 3: out-of-plane flux function, reconstructed from B ----
    z_ref_idx = 1;
    dz_ = z(2) - z(1);
    dy_ = y(2) - y(1);
    Ax_of_yref = -cumtrapz(Bz(z_ref_idx, :)) .* dy_;
    Ax = cumtrapz(By, 1) .* dz_ + repmat(Ax_of_yref, nz_data, 1);

    fig3 = figure('Visible', 'off', 'Position', [100 100 700 500]);
    contourf(y(idx_y)./d_i, z(idx_z)./d_i, Ax(idx_z,idx_y), 40, ...
             'LineColor', 'k', 'LineWidth', 0.3);
    colormap(gca, parula); colorbar;
    xlabel('y / d_i'); ylabel('z / d_i');
    title(sprintf('Reconstructed flux function A_x(y,z), step %d', step));
    saveas(fig3, fullfile(outdir, sprintf('fig3_flux_step%09d.png', step)));
    close(fig3);

end

fprintf('\nDone. Frames saved in: %s\n', outdir);

%% ==================== optional: assemble a movie from the frames ========
% frame_files = dir(fullfile(outdir, 'fig1_fields_step*.png'));
% [~, order] = sort({frame_files.name});
% frame_files = frame_files(order);
% v = VideoWriter(fullfile(outdir, 'fig1_fields_evolution.mp4'), 'MPEG-4');
% v.FrameRate = 6;
% open(v);
% for k = 1:numel(frame_files)
%     img = imread(fullfile(outdir, frame_files(k).name));
%     writeVideo(v, img);
% end
% close(v);
