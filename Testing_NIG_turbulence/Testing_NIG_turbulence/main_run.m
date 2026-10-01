%% main_run.m
% End-to-end setup of intermittent Alfvenic turbulence for a 3D PIC box.
%
% Pipeline:
%   1) Choose grid / box / spectrum / cross-helicity -> build z+_k, z-_k
%      (Gaussian, random-phase, transverse, div-free Elsasser fields).
%   2) Build a multiplicative cascade of weights across k-octaves.
%   3) Re-inject those weights into the shell-decomposed z+ , z- fields
%      -> intermittent, non-Gaussian z+(x), z-(x) with the SAME power
%      spectrum on average, but scale-dependent PDFs.
%   4) Recombine to physical v(x), b(x): v = (z+ + z-)/2 , b = (z+ - z-)/2
%      (b here is in Alfven-speed units; multiply by sqrt(mu0*rho) or by
%      your code's normalization to get physical Gauss/Tesla units).
%   5) Add the background field B0 and check the results:
%        - power spectrum recovered
%        - PDFs of increments become non-Gaussian / NIG-like at small ell
%        - divergence-free to machine precision
%   6) Export to disk for your PIC initializer.

clear; close all; rng(1); % fix seed for reproducibility while testing

%% --- 1. Grid / box ------------------------------------------------------
Nx = 128; Ny = 128; Nz = 128;
Lx = 2*pi; Ly = 2*pi; Lz = 2*pi;     % adjust to your code's units (e.g. d_i)
dx = Lx/Nx;

B0mag   = 1.0;         % background field strength (code units)
b_rms   = 0.3;         % target fluctuation amplitude relative to B0
sigma_c = 0.0;         % cross helicity: 0 = balanced, +-1 = imbalanced

alpha_spec = 5/3;       % inertial-range spectral slope of E(k)
k0   = 2*pi/Lx * 2;     % outer scale (a couple of box modes)
kmax = 2*pi/Lx * (Nx/3);% keep well below Nyquist to avoid aliasing artifacts
kdiss = 2*pi/Lx * (Nx/4); % soft rolloff toward the "dissipation" end

%% --- 2. Base (Gaussian) Elsasser fields ---------------------------------
[zp_k, zm_k, KX,KY,KZ,Kmag] = gen_alfvenic_elsasser(Nx,Ny,Nz,Lx,Ly,Lz, ...
                                    alpha_spec,k0,kmax,kdiss,sigma_c);

%% --- 3. Multiplicative cascade for intermittency ------------------------
Nshells = max(4, floor(log2(kmax/k0)));
kedges  = k0 * 2.^(0:Nshells);
kedges(end) = max(kedges(end), kmax*1.001); % make sure top shell covers kmax

sigma2_per_octave = 0.15;   % INTERMITTENCY STRENGTH -- tune this against
                             % the paper's measured NIG parameters (bigger
                             % -> heavier tails / higher kurtosis at small
                             % scale). sigma2=0 reproduces the pure
                             % Gaussian case as a sanity check.

W = multiplicative_cascade(Kmag, kedges, sigma2_per_octave);

zp_x = apply_intermittency(zp_k, Kmag, kedges, W);
zm_x = apply_intermittency(zm_k, Kmag, kedges, W);
% NOTE: using the SAME W for zp and zm ties the intermittency of the two
% Elsasser populations together spatially, which keeps v and b
% intermittency correlated (as observed). Use independent cascades for
% zp/zm if you specifically want decorrelated intermittency instead.

%% --- 4. Recombine to physical v, b --------------------------------------
v = (zp_x + zm_x)/2;
b = (zp_x - zm_x)/2;   % Alfven-speed units

% The real-space cascade modulation in apply_intermittency.m multiplies
% each shell by a spatially varying weight, which breaks exact
% solenoidality (div(w*E) = E.grad(w) != 0 even though E is transverse).
% Restore div-free-ness exactly with a final Helmholtz projection:
b = helmholtz_project(b, KX,KY,KZ,Kmag);
v = helmholtz_project(v, KX,KY,KZ,Kmag);

% rescale to the requested rms fluctuation amplitude
b_current_rms = sqrt(mean(b(:).^2));
scale_fac = b_rms*B0mag / b_current_rms;
b = b * scale_fac;
v = v * scale_fac;

B = zeros(Nx,Ny,Nz,3);
B(:,:,:,3) = B0mag;     % background along z
B = B + b;

%% --- 5. Sanity checks -----------------------------------------------------
divB = ifftn( 1i*KX.*fftn(B(:,:,:,1)) + 1i*KY.*fftn(B(:,:,:,2)) + ...
              1i*KZ.*fftn(B(:,:,:,3)), 'symmetric');
fprintf('max |div B| / (k_max*b_rms) = %.3e  (should be ~0)\n', ...
        max(abs(divB(:))) / (kmax*b_rms*B0mag));

fprintf('rms(b) = %.4f (target %.4f),  rms(v) = %.4f\n', ...
        sqrt(mean(b(:).^2)), b_rms*B0mag, sqrt(mean(v(:).^2)));

% Power spectrum check (bx component, shell-averaged)
Bxk = fftn(b(:,:,:,1));
Pk = abs(Bxk).^2;
nbins = 40;
kbins = logspace(log10(k0), log10(kmax), nbins);
Ek = zeros(nbins-1,1); kc = zeros(nbins-1,1);
for i=1:nbins-1
    m = Kmag>=kbins(i) & Kmag<kbins(i+1);
    Ek(i) = sum(Pk(m));
    kc(i) = sqrt(kbins(i)*kbins(i+1));
end
figure('Name','Recovered spectrum');
loglog(kc, Ek, 'o-'); hold on;
loglog(kc, Ek(1)*(kc/kc(1)).^(-alpha_spec), 'k--');
xlabel('k'); ylabel('shell power'); legend('measured', sprintf('k^{-%.2f}',alpha_spec));
title('Spectrum should be preserved by the cascade (on average)');

%% --- 6. Intermittency diagnostics ----------------------------------------
lag_list = [1 2 4 8 16 32 64];
results = diagnostics_increments(b(:,:,:,1), dx, lag_list);

fprintf('\n scale(dx units)   excess kurtosis   NIG alpha   NIG beta   NIG delta\n');
for i=1:numel(results)
    fprintf('  %10d       %10.3f     %9.3f  %9.3f  %9.3f\n', ...
        results(i).lag, results(i).kurtosis, results(i).alpha, ...
        results(i).beta, results(i).delta);
end

%% --- 7. Export for the PIC initializer -----------------------------------
outdir = 'turb_init_out';
if ~exist(outdir,'dir'), mkdir(outdir); end
save(fullfile(outdir,'turbulence_fields.mat'), 'B','v','Nx','Ny','Nz', ...
     'Lx','Ly','Lz','B0mag','b_rms','sigma_c','alpha_spec','sigma2_per_octave');

% also dump raw binaries (double precision, column-major, size Nx*Ny*Nz*3)
% -- adjust dtype / ordering to whatever your PIC code's reader expects
fid = fopen(fullfile(outdir,'B.bin'),'w'); fwrite(fid, B, 'double'); fclose(fid);
fid = fopen(fullfile(outdir,'v.bin'),'w'); fwrite(fid, v, 'double'); fclose(fid);

fprintf('\nDone. Fields + diagnostics written to %s/\n', outdir);
