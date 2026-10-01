%% psc_harris_ic_check.m
%
% Reproduces the INITIAL CONDITION of psc_reconnection_harris_2D_yz_single_sheet.cxx
% (single Harris current sheet, 2D in the y-z plane, x is the invariant/
% out-of-plane direction) and produces three diagnostic figures:
%
%   Figure 1 - 2D (y,z) maps of the 3 components of B and the 3 components of J
%   Figure 2 - 1D cuts at y=0 of magnetic pressure, particle pressure, and total pressure
%   Figure 3 - contours of the out-of-plane vector potential (flux function) A_x(y,z)
%
% Just run this whole file in MATLAB (no toolboxes required). Also runs in
% Octave unmodified.
%
% All parameter values are copied 1:1 from setupParameters()/setupGrid() in
% the .cxx file, so this reproduces exactly what PSC sets up at t=0 (mod the
% ny,nz plotting resolution, which is reduced here for speed -- bump it up
% if you want to compare pixel-for-pixel against the real 5992 x 3000 grid).
%
% This version uses the SELF-CONSISTENT current, i.e. Jx = harrisJ(z) +
% perturbationJx(y,z), matching the corrected initializeFields() (curl(B)
% of the TOTAL field, equilibrium + seed perturbation).

clear; close all; clc;

%% 1) Parameters -- copied from setupParameters() / setupGrid() in the .cxx

mass_ratio = 100.0;          % g.mass_ratio
n0 = 1.0;                    % g.n, peak Harris density at sheet center

omegape_Omegace = 3.0;       % g.omegape_Omegace
B0 = 1.0 / omegape_Omegace;  % g.B0  (Omega_ce = B0 in these units)

Bg_over_B0 = 0.0;            % g.Bg_over_B0  (no guide field)
nb_over_n = 0.2;             % g.nb_over_n   (background/lobe density fraction)
Ti0_over_Te0 = 5.0;          % g.Ti0_over_Te0
beta_total = 1.0;            % g.beta_total  (=1 -> exact Harris force balance)
L_over_di = 0.5;             % g.L_over_di

psi0_over_B0L = 0.3;         % g.psi0_over_B0L
pert_width_y_over_di = 3.0;  % g.pert_width_y_over_di
pert_width_z_over_L = 2.0;   % g.pert_width_z_over_L

% --- derived quantities, exactly mirroring setupGrid() ---
d_i = sqrt(mass_ratio / n0);      % g.d_i
L = L_over_di * d_i;              % g.L
z1 = 0.0;                         % g.z1, single sheet at box center

Ly = 60.0 * d_i;                  % outflow direction, periodic
Lz = 30.0 * d_i;                  % inflow direction, conducting/reflecting

Ttot0 = beta_total * B0^2 / (2.0 * n0);
Te0 = Ttot0 / (1.0 + Ti0_over_Te0);
Ti0 = Ttot0 - Te0;

wy = pert_width_y_over_di * d_i;         % Gaussian width in y
wz = pert_width_z_over_L * L;            % Gaussian width in z
psi0 = psi0_over_B0L * B0 * L;           % perturbation amplitude (= peak A_x1)

fprintf('---- derived parameters (compare against the code''s mpi_printf lines) ----\n');
fprintf('d_e = 1, d_i = %.6g\n', d_i);
fprintf('omega_pe/Omega_ce = %.6g -> B0 = %.6g\n', omegape_Omegace, B0);
fprintf('L = %.6g (%.6g d_i), single sheet at z = %.6g\n', L, L_over_di, z1);
fprintf('Ti0 = %.6g, Te0 = %.6g, Ti0+Te0 = %.6g (target %.6g)\n', Ti0, Te0, Ti0+Te0, Ttot0);
fprintf('Ly = %.6g, Lz = %.6g\n', Ly, Lz);
fprintf('perturbation: psi0 = %.6g, wy = %.6g, wz = %.6g\n', psi0, wy, wz);
fprintf('----------------------------------------------------------------------------\n');

%% 2) Grid -- reduced resolution for fast plotting (bump up if needed)
ny = 600; nz = 400;   % plotting resolution; real run used 5992 x 3000

y = linspace(-0.5*Ly, 0.5*Ly, ny);
z = linspace(-0.5*Lz, 0.5*Lz, nz);
[Y, Z] = meshgrid(y, z);    % size (nz, ny), rows=z, columns=y

%% 3) Harris equilibrium (anonymous functions -- copied 1:1 from the .cxx)

harrisB    = @(zc) B0 .* tanh((zc - z1) ./ L);
harrisJ    = @(zc) -(B0./L) .* sech((zc - z1)./L).^2;
harrisN1   = @(zc) n0 .* sech((zc - z1)./L).^2;
harrisNtot = @(zc) harrisN1(zc) + nb_over_n .* n0;

% out-of-plane vector-potential perturbation A_x1 = psi(y,z)
psi_fun = @(yc, zc) psi0 .* exp( -(yc.^2)./wy^2 - ((zc-z1).^2)./wz^2 );

% By1 = dpsi/dz ,  Bz1 = -dpsi/dy   (X-point branch used in the code)
By1_fun = @(yc, zc) -2.*(zc-z1)./wz^2 .* psi_fun(yc, zc);
Bz1_fun = @(yc, zc)  2.*yc./wy^2      .* psi_fun(yc, zc);

% self-consistent perturbation current: Jx1 = dBz1/dy - dBy1/dz = -Laplacian(psi)
Jx1_fun = @(yc, zc) -( psi_fun(yc,zc).*(-2./wy^2 + 4.*yc.^2./wy^4) ...
                     + psi_fun(yc,zc).*(-2./wz^2 + 4.*(zc-z1).^2./wz^4) );

%% 4) Build the total fields exactly as the (fixed) initializeFields() does

By1 = By1_fun(Y, Z);
Bz1 = Bz1_fun(Y, Z);

Bx = Bg_over_B0 * B0 * ones(size(Y));   % = 0 here, no guide field
By = harrisB(Z) + By1;
Bz = Bz1;

% self-consistent current (matches the FIXED initializeFields():
%   Jx = harrisJ(z) + perturbationJx(y,z);  Jy = Jz = 0 exactly)
Jx = harrisJ(Z) + Jx1_fun(Y, Z);
Jy = zeros(size(Y));   % exact: dBx/dz - dBz/dx, both vanish (Bx=0, no x-dep)
Jz = zeros(size(Y));   % exact: dBy/dx - dBx/dy, both vanish (no x-dep, Bx=0)

% ---- optional cross-check against a purely numerical curl of the total B ----
dy = y(2) - y(1);
dz_ = z(2) - z(1);
[dBz_dy, ~] = gradient(Bz, dy, dz_);
[~, dBy_dz] = gradient(By, dy, dz_);
Jx_curl_numeric = dBz_dy - dBy_dz;
max_abs_diff = max(abs(Jx_curl_numeric(:) - Jx(:)));
fprintf('\nmax |Jx_curl_numeric - Jx_selfconsistent| = %.4e  (should be ~machine precision)\n\n', max_abs_diff);

%% Build a simple blue-white-red diverging colormap (no toolbox needed)
m = 256;
half = floor(m/2);
cmap = [interp1([0 1], [0 0 1; 1 1 1], linspace(0, 1, half)); ...
        interp1([0 1], [1 1 1; 1 0 0], linspace(0, 1, m-half))];

%% Figure 1: 2D (y,z) maps of B and J

figure('Position', [100 100 1400 750]);

B_fields = {Bx, By, Bz};
B_labels = {'B_x', 'B_y', 'B_z'};
J_fields = {Jx, Jy, Jz};
J_labels = {'J_x', 'J_y', 'J_z'};

for k = 1:3
    subplot(2,3,k)
    F = B_fields{k};
    vmax = max(max(abs(F(:))), 1e-12);
    pcolor(y./d_i, z./d_i, F); shading interp;
    colormap(gca, cmap); caxis([-vmax, vmax]); colorbar;
    title(B_labels{k}); xlabel('y / d_i'); ylabel('z / d_i');
    axis tight;
end

for k = 1:3
    subplot(2,3,3+k)
    F = J_fields{k};
    vmax = max(max(abs(F(:))), 1e-12);
    pcolor(y./d_i, z./d_i, F); shading interp;
    colormap(gca, cmap); caxis([-vmax, vmax]); colorbar;
    title(J_labels{k}); xlabel('y / d_i'); ylabel('z / d_i');
    axis tight;
end

sgtitle('Initial condition: magnetic field and current density in the (y,z) plane');
saveas(gcf, 'figure1_fields_2D.png');

%% Figure 2: 1D cuts at y=0 of magnetic / particle / total pressure

[~, iy0] = min(abs(y));   % index closest to y=0

Bx_cut = Bx(:, iy0);
By_cut = By(:, iy0);
Bz_cut = Bz(:, iy0);
P_B = 0.5 .* (Bx_cut.^2 + By_cut.^2 + Bz_cut.^2);

n_cut = harrisNtot(z(:));
P_particle = n_cut .* (Te0 + Ti0);   % isotropic scalar pressure, T uniform in z

P_total = P_B + P_particle;

% equilibrium-only reference (no perturbation at all) -- should be exactly flat
P_B_eq = 0.5 .* harrisB(z(:)).^2;
P_total_eq = P_B_eq + P_particle;

figure('Position', [100 100 700 500]);
plot(z./d_i, P_B, 'Color', [0 0.447 0.741], 'LineWidth', 1.5); hold on;
plot(z./d_i, P_particle, 'Color', [0.850 0.325 0.098], 'LineWidth', 1.5);
plot(z./d_i, P_total, 'Color', [0.466 0.674 0.188], 'LineWidth', 2);
plot(z./d_i, P_total_eq, 'k--', 'LineWidth', 1);
yline(0.5*B0^2*(1.0+nb_over_n), ':', 'Color', [0.5 0.5 0.5]);
xlabel('z / d_i'); ylabel('pressure (code units)');
title('Pressure balance at y=0');
legend('P_B (incl. perturbation)', 'P_{particle} = n(T_e+T_i)', ...
       'P_{total} (incl. perturbation)', 'P_{total} (equilibrium only)', ...
       'expected flat value B_0^2/2 (1+n_b/n)', 'Location', 'best');
grid on;
saveas(gcf, 'figure2_pressure_cuts.png');

%% Figure 3: contours of the out-of-plane vector potential (flux function)

% equilibrium flux function: dA_x0/dz = harrisB(z)  ->  A_x0(z) = B0*L*ln(cosh(z/L))
Ax0 = B0 .* L .* log(cosh((z(:) - z1) ./ L));
Ax1 = psi_fun(Y, Z);
Ax_total = repmat(Ax0, 1, ny) + Ax1;

figure('Position', [100 100 1300 500]);

% --- left panel: full domain, global levels ---
subplot(1,2,1)
contourf(y./d_i, z./d_i, Ax_total, 60, 'LineColor', 'k', 'LineWidth', 0.4);
colormap(gca, parula); colorbar;
xlabel('y / d_i'); ylabel('z / d_i'); title('full domain');

% --- right panel: zoom on the X-point, with LOCAL contour levels ---
% (the background trough varies by ~B0*L*ln(cosh) over the whole domain,
%  which is >> psi0, so re-using the global levels hides the local X-point
%  topology entirely -- use levels based on the zoomed sub-region instead)
y_zoom = [-4*wy, 4*wy];
z_zoom = [-5*wz, 5*wz];
iy_zoom = (y >= y_zoom(1)) & (y <= y_zoom(2));
iz_zoom = (z >= z_zoom(1)) & (z <= z_zoom(2));
sub = Ax_total(iz_zoom, iy_zoom);
levels_zoom = linspace(min(sub(:)), max(sub(:)), 40);

subplot(1,2,2)
contourf(y./d_i, z./d_i, Ax_total, levels_zoom, 'LineColor', 'k', 'LineWidth', 0.5);
colormap(gca, parula); colorbar;
xlim(y_zoom./d_i); ylim(z_zoom./d_i);
xlabel('y / d_i'); ylabel('z / d_i'); title('zoom on X-point region (local contour levels)');

sgtitle('Out-of-plane vector potential / flux function (field-line contours)');
saveas(gcf, 'figure3_flux_contours.png');

fprintf('Saved: figure1_fields_2D.png, figure2_pressure_cuts.png, figure3_flux_contours.png\n');