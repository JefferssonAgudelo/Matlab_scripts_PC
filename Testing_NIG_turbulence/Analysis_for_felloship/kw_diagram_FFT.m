%% kw_diagram_FFT.m
%
% k-omega diagram for a 2D (y,z) fully-kinetic PSC/PIC turbulence run,
% in the spirit of Fig. 1 of Papini et al. 2021, ApJL 917, L12.
%
% This version:
%   1) Parses the run's .cxx case file to recover mass_ratio, vA_over_c,
%      and the field-dump cadence (pfield.out_interval), and from these
%      computes the ion-cyclotron frequency Omega_i (in units of the
%      code's omega_pe) using the exact identity  Omega_i = v_A / d_i .
%   2) Loads B and ion/electron bulk-velocity fields from the pfd.*.h5 /
%      pfd_moments.*.h5 snapshots, following the logic of
%      load_magnetic_field_velocity_data.m, for a whole range of
%      snapshots (not just one), assembling a (Ny,Nz,Nt) cube.
%   3) Performs a space-time FFT (2D spatial FFT + windowed temporal FFT),
%      azimuthally averages to P(k_perp,omega), and overlays the FW and
%      A/KAW Hall-MHD dispersion curves (solved numerically, not from a
%      hand-typed formula).
%
% IMPORTANT CAVEATS (read before trusting the output):
%  - This uses a plain space-time FFT in time, not the FT+FIF (Fast
%    Iterative Filtering) approach of Papini et al. It is a baseline,
%    not a reproduction of their exact method (see chat discussion).
%  - The HDF5 group indices below (EHJ_GROUP_IDX, MOMENTS_GROUP_IDX,
%    GRIDLEN_GROUP_IDX) are copied from your load_magnetic_field_velocity_data.m
%    and are almost certainly correct for your files, but HDF5 group
%    ordering can change between PSC versions/writers. If any h5read call
%    below errors out, run h5disp(filename) once and fix the indices.
%  - The isotropic (scalar-pressure) Hall-MHD dispersion relation used
%    here strictly assumes T_perp = T_par for each species. Your .cxx has
%    Ti_perp_over_Ti_par = Te_perp_over_Te_par = 1.0, so this holds for
%    the run as configured; if you ever change those ratios, the simple
%    dispersion curves will no longer be exactly right (a proper
%    bi-Maxwellian/CGL dispersion relation would be needed instead).
%
% -------------------------------------------------------------------

clear; clc; close all;

%% ---------------- USER INPUT ------------------------------------------

cxxFile  = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/using_22_nodes/cases_beta1/maxwell_TiTe/psc_turbulence_2D_maxwellian_3.cxx'; % <<< EDIT if needed
dataDir  = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/using_22_nodes/cases_beta1/maxwell_TiTe'; % <<< EDIT ME

% Which snapshots (indices into the sorted file list) to include.
% Use [] to take all available snapshots.
it_range = [];

% Which field to build the k-omega diagram for:
%   'uperp_i' : ion bulk velocity,  perpendicular components (v_iy,v_iz)
%   'uperp_e' : electron bulk velocity, perpendicular components
%   'Bperp'   : perpendicular magnetic field  (By,Bz)
%   'Bpar'    : parallel magnetic field        (Bx)
field_choice = 'Bperp';

% Spatial downsampling knob (grid is 4488x4480 -> huge in time; start
% coarse). This is applied via a strided HDF5 read (cheap, no need to
% load the full array first).
space_decim = 8;

% HDF5 group indices, copied from load_magnetic_field_velocity_data.m.
% VERIFY THESE with h5disp(fullfile(dataDir,'pfd.<something>.h5')) if
% anything below errors.
EHJ_GROUP_IDX     = 16;   % group holding hx_fc/hy_fc/hz_fc in pfd.*.h5
MOMENTS_GROUP_IDX = 1;    % group holding px_e/py_e/... in pfd_moments.*.h5
GRIDLEN_GROUP_IDX = 17;   % group holding the domain-length attributes

% angles for the dispersion-relation overlay (deg); edit to match your
% own measured mode/mean of theta_Bk, as in Papini et al.
theta_FW_deg  = 84.9;
theta_KAW_deg = 79.3;

% plotting range
kperp_di_max = 20;
omega_Oi_max = 12;

%% ---------------- PARSE .cxx FOR SIMULATION PARAMETERS -----------------

cxxp = parseCxxParams(cxxFile);

fprintf('--- Parameters recovered from %s ---\n', cxxFile);
fprintf('  mass_ratio (mi/me)      = %g\n', cxxp.mass_ratio);
fprintf('  vA_over_c               = %g\n', cxxp.vA_over_c);
fprintf('  n (background density)  = %g\n', cxxp.n);
fprintf('  Zi                      = %g\n', cxxp.Zi);
fprintf('  beta_i_par              = %g\n', cxxp.beta_i_par);
fprintf('  beta_e_par              = %g\n', cxxp.beta_e_par);
fprintf('  pfield.out_interval     = %d steps\n', cxxp.pfield_out_interval);
fprintf('  d_i (in d_e units)      = %g\n', cxxp.d_i);
fprintf('  Omega_i / omega_pe      = %g\n', cxxp.Omega_i_over_omegape);

beta_total = cxxp.beta_i_par + cxxp.beta_e_par;   % isotropic case (ratios=1 here)
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

% match each pfd file to its corresponding pfd_moments file, exactly as
% in load_magnetic_field_velocity_data.m (matching on the timestamp
% substring in the filename)
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

%% ---------------- GRID METADATA: Ly, Lz, dt, cadence in Omega_i^-1 -----

info1 = h5info(pfdFile{1});
grid_length = info1.Groups(GRIDLEN_GROUP_IDX).Attributes;
Ly = grid_length(4).Value(2) - grid_length(3).Value(2);
Lz = grid_length(4).Value(3) - grid_length(3).Value(3);

dt_code = getGridDt(pfdFile{1});   % physical PIC timestep, units of 1/omega_pe

dt_snapshot_omegape = cxxp.pfield_out_interval * dt_code;      % time between dumps, 1/omega_pe units
dt_eff = dt_snapshot_omegape * cxxp.Omega_i_over_omegape;      % same, in units of Omega_i^-1

fprintf('  Ly, Lz (d_e units)      = %g, %g\n', Ly, Lz);
fprintf('  dt (code, 1/omega_pe)   = %g\n', dt_code);
fprintf('  snapshot cadence        = %g Omega_i^-1\n', dt_eff);
fprintf('  total time span         = %g Omega_i^-1  (%d snapshots)\n', dt_eff*(Nt_used-1), Nt_used);

%% ---------------- LOAD FIELD CUBE --------------------------------------

% figure out the true (decimated) grid size from the first file
EHJ1 = info1.Groups(EHJ_GROUP_IDX).Name;
Bx_full = h5read(pfdFile{1}, strcat(EHJ1, '/hx_fc/p0/3d'));
sz = size(Bx_full); clear Bx_full
LYs = sz(2); LZs = sz(3);          % sz(1) is the trivial x-dimension (=1)

yIdx = 1:space_decim:LYs; zIdx = 1:space_decim:LZs;
Ny = numel(yIdx); Nz = numel(zIdx);
strideVec = [1, space_decim, space_decim];
startVec  = [1, 1, 1];
countVec  = [1, Ny, Nz];

isVector = ~strcmp(field_choice, 'Bpar');

fprintf('Allocating cube: %d x %d x %d (single precision)\n', Ny, Nz, Nt_used);
F1 = zeros(Ny, Nz, Nt_used, 'single');
if isVector, F2 = zeros(Ny, Nz, Nt_used, 'single'); end

mi = cxxp.mass_ratio * cxxp.Zi;   % ion mass in code units (me = 1)
me = 1;
c_code = 1;                       % PSC dimensionless normalization: c = 1

for n = 1:Nt_used
    fileID  = pfdFile{n};
    fileID2 = momentsFile{n};
    infoN = h5info(fileID);
    EHJn  = infoN.Groups(EHJ_GROUP_IDX).Name;

    switch field_choice
        case 'Bpar'
            a = squeeze(h5read(fileID, strcat(EHJn,'/hx_fc/p0/3d'), startVec, countVec, strideVec));
            F1(:,:,n) = a;

        case 'Bperp'
            a = squeeze(h5read(fileID, strcat(EHJn,'/hy_fc/p0/3d'), startVec, countVec, strideVec));
            b = squeeze(h5read(fileID, strcat(EHJn,'/hz_fc/p0/3d'), startVec, countVec, strideVec));
            F1(:,:,n) = a; F2(:,:,n) = b;

        case {'uperp_i','uperp_e'}
            infoM = h5info(fileID2);
            moms  = infoM.Groups(MOMENTS_GROUP_IDX).Name;
            if strcmp(field_choice,'uperp_i')
                py = squeeze(h5read(fileID2, strcat(moms,'/py_i/p0/3d'), startVec, countVec, strideVec));
                pz = squeeze(h5read(fileID2, strcat(moms,'/pz_i/p0/3d'), startVec, countVec, strideVec));
                rho = squeeze(h5read(fileID2, strcat(moms,'/rho_i/p0/3d'), startVec, countVec, strideVec));
                m_sp = mi;
            else
                py = squeeze(h5read(fileID2, strcat(moms,'/py_e/p0/3d'), startVec, countVec, strideVec));
                pz = squeeze(h5read(fileID2, strcat(moms,'/pz_e/p0/3d'), startVec, countVec, strideVec));
                rho = -squeeze(h5read(fileID2, strcat(moms,'/rho_e/p0/3d'), startVec, countVec, strideVec));
                m_sp = me;
            end
            rho(rho==0) = 1e-20;
            py = py ./ rho; pz = pz ./ rho;   % momentum per particle
            % relativistic velocity from momentum (as in load_magnetic_field_velocity_data.m)
            vy = py .* c_code ./ sqrt(c_code^2*m_sp^2 + py.^2);
            vz = pz .* c_code ./ sqrt(c_code^2*m_sp^2 + pz.^2);
            F1(:,:,n) = vy; F2(:,:,n) = vz;
    end

    if mod(n,20)==0, fprintf('  loaded %d / %d\n', n, Nt_used); end
end

%% ---------------- SPACE-TIME FFT ---------------------------------------

dy = Ly/LYs * space_decim;
dz = Lz/LZs * space_decim;

ky = 2*pi*[0:floor(Ny/2)-1, -ceil(Ny/2):-1] / (Ny*dy);   % rad/d_e
kz = 2*pi*[0:floor(Nz/2)-1, -ceil(Nz/2):-1] / (Nz*dz);
[KY, KZ] = ndgrid(ky, kz);
Kperp = sqrt(KY.^2 + KZ.^2) * cxxp.d_i;
% Kperp is k_perp*d_i (dimensionless): KY,KZ are in units of 1/d_e, and
% cxxp.d_i is in units of d_e, so the product is the standard
% normalized perpendicular wavenumber used in Fig. 1 of Papini et al.

r = 0.3;   % Tukey taper fraction, to suppress edge leakage in time
w = tukeywin(Nt_used, r);
w = reshape(w, 1, 1, Nt_used);

omega = 2*pi*( -floor(Nt_used/2):(ceil(Nt_used/2)-1) )/(Nt_used*dt_eff);  % in units of Omega_i

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

%% ---------------- DISPERSION RELATION OVERLAY --------------------------

kperp_grid = linspace(1e-3, kperp_di_max, 400);

omega_FW  = nan(size(kperp_grid));
kpar_over_kperp_FW = 1/tand(theta_FW_deg);
for ik = 1:numel(kperp_grid)
    kp_ = kperp_grid(ik); kz_ = kp_ * kpar_over_kperp_FW;
    branches = hallMHD_branches(kp_, kz_, beta_total, Gamma);
    omega_FW(ik) = branches(1);
end

omega_KAW = nan(size(kperp_grid));
kpar_over_kperp_KAW = 1/tand(theta_KAW_deg);
for ik = 1:numel(kperp_grid)
    kp_ = kperp_grid(ik); kz_ = kp_ * kpar_over_kperp_KAW;
    branches = hallMHD_branches(kp_, kz_, beta_total, Gamma);
    omega_KAW(ik) = branches(2);
end

%% ---------------- PLOT --------------------------------------------------

figure('Color','w','Position',[100 100 650 550]);
pcolor(kperp_centers, omega, log10(Pkw.'+eps)); shading interp;
set(gca,'YDir','normal');
xlim([0 kperp_di_max]); ylim([0 omega_Oi_max]);
xlabel('k_\perp d_i'); ylabel('\omega / \Omega_i');
cb = colorbar; ylabel(cb, 'log_{10} P(k_\perp,\omega)');
colormap(turbo); hold on;

plot(kperp_grid, omega_FW,  'w--', 'LineWidth', 1.8, ...
    'DisplayName', sprintf('FW (\\theta=%.1f%s)', theta_FW_deg, char(176)));
plot(kperp_grid, omega_KAW, 'w-',  'LineWidth', 1.8, ...
    'DisplayName', sprintf('A/KAW (\\theta=%.1f%s)', theta_KAW_deg, char(176)));
legend('Location','southeast','TextColor','w','Color','none');
title(sprintf('k\\omega-diagram: %s  (\\Omega_i from run: %.4g \\omega_{pe})', ...
    field_choice, cxxp.Omega_i_over_omegape));


%% ==================== LOCAL FUNCTIONS ===================================
% (must appear after all script code, per MATLAB script-function rules)

function p = parseCxxParams(cxxFile)
% Extract simulation parameters directly from the .cxx case file, so the
% analysis always uses the actual parameters of the run being processed
% rather than values hardcoded (and possibly stale) in a loader script.

    txt = fileread(cxxFile);

    p.mass_ratio = getNum(txt, 'g\.mass_ratio\s*=\s*([0-9.eE+-]+)\s*;');
    p.vA_over_c  = getNum(txt, 'g\.vA_over_c\s*=\s*([0-9.eE+-]+)\s*;');
    p.n          = getNum(txt, 'g\.n\s*=\s*([0-9.eE+-]+)\s*;');
    p.Zi         = getNum(txt, 'g\.Zi\s*=\s*([0-9.eE+-]+)\s*;');
    p.beta_i_par = getNum(txt, 'g\.beta_i_par\s*=\s*([0-9.eE+-]+)\s*;');
    p.beta_e_par = getNum(txt, 'g\.beta_e_par\s*=\s*([0-9.eE+-]+)\s*;');
    p.pfield_out_interval = getNum(txt, ...
        'outf_item_params\.pfield\.out_interval\s*=\s*(-?[0-9]+)\s*;');

    if isnan(p.n)
        warning('g.n not found in .cxx; defaulting to n=1.0');
        p.n = 1.0;
    end
    if isnan(p.Zi)
        p.Zi = 1.0;
    end
    req = {'mass_ratio','vA_over_c','pfield_out_interval'};
    for i = 1:numel(req)
        if isnan(p.(req{i}))
            error('Could not find %s in %s -- check the variable name/regex.', req{i}, cxxFile);
        end
    end

    % d_i in units of d_e = c/omega_pe (exactly as computed in the .cxx)
    p.d_i = sqrt(p.mass_ratio / p.n);

    % Fundamental identity Omega_i = v_A / d_i (any consistent unit
    % system); with c=1 and lengths in d_e (PSC dimensionless norm.),
    % this gives Omega_i directly in units of omega_pe:
    p.Omega_i_over_omegape = p.vA_over_c / p.d_i;
end

function val = getNum(txt, pattern)
    tok = regexp(txt, pattern, 'tokens', 'once');
    if isempty(tok)
        val = NaN;
    else
        val = str2double(tok{1});
    end
end

function dt_code = getGridDt(fileID)
% Search all group attributes in the HDF5 file for one named "dt"
% (case-insensitive). This is more robust than assuming a fixed group
% index, since this attribute wasn't fully wired up in the original
% loader script.
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
               'Run h5disp(''%s'') to locate the timestep attribute manually,\n' ...
               'then set dt_code directly instead of calling getGridDt().'], fileID, fileID);
    end
end

function omega3 = hallMHD_branches(kperp, kpar, beta, Gamma)
% Linearized ideal Hall-MHD dispersion relation (scalar/isotropic
% pressure), derived from the standard two-fluid Hall-MHD equations and
% solved as a linear eigenvalue problem dX/dt = A*X with
% X = [rho1,ux,uy,uz,T1,bx,by,bz] in code units where c_A = Omega_i =
% d_i = 1 (i.e. normalized to the *ion* scales, as in Papini et al.).
% Returns the three positive-frequency branches sorted by |omega|:
% [FW, A/KAW, S/IC] (fast/whistler, Alfven/kinetic Alfven, slow/ion-
% cyclotron). Valid for k*d_i >~ 1 (sub-ion scales); near k->0 branch
% ordering can swap depending on theta and beta.

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
