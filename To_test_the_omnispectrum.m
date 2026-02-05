% Grid size
Nx = 64; Ny = 64; Nz = 64;
Lx = 2*pi; Ly = 2*pi; Lz = 2*pi;
x = linspace(0, Lx, Nx+1); x(end) = [];
y = linspace(0, Ly, Ny+1); y(end) = [];
z = linspace(0, Lz, Nz+1); z(end) = [];
[X, Y, Z] = ndgrid(x, y, z);

% Define synthetic field: superposition of waves
Bx_dt = cos(3*X + 2*Y + Z) + 0.5*cos(5*X - 4*Z) + 0.8*cos(7*Y);

% Compute omnidirectional spectrum
threshold = 20; % max k to analyze
[E_k, k_bins] = Omni1DSpectra(Bx_dt, Lx, Ly, Lz, threshold);

% Plot result
figure;
loglog(k_bins(1:end-1), E_k(1:end-1), 'o-');
xlabel('k'); ylabel('E(k)');
title('Omnidirectional Spectrum Test');




% assume n, E are 64^3 arrays, Lx=Ly=Lz=2*pi
[kc, gamma] = OmniCoherence(n, E, 2*pi, 2*pi, 2*pi, []);
loglog(kc, gamma); ylim([0 1.05]);
xlabel('k'); ylabel('Coherence \gamma(k)');
title('Omnidirectional coherence between n and E');



function [k_centers, coh] = OmniCoherence(n, E, Lx, Ly, Lz, kmax)
% OmniCoherence  Omnidirectional coherence between 3D fields n and E
%
% Inputs:
%   n, E    : 3D real arrays (same size)
%   Lx,Ly,Lz: domain lengths (same units as coordinate space)
%   kmax    : maximum k to include (optional). If [], uses Nyquist.
%
% Outputs:
%   k_centers : bin center values (length Nbins-1)
%   coh       : coherence gamma(k) (same length as k_centers)
%
% Notes:
%   - Uses shell sums (no extra normalization needed for ratio).
%   - If you want gamma^2, square the returned coh.

if nargin<6 || isempty(kmax)
    % use min Nyquist
    Nx = size(n,1); Ny = size(n,2); Nz = size(n,3);
    dkx = 2*pi/Lx; dky = 2*pi/Ly; dkz = 2*pi/Lz;
    kmax = min([pi/dkx, pi/dky, pi/dkz]); % conservative
end

Ns = size(n);
% Fourier transforms
Ntot = prod(Ns);
N1=Ns(1); N2=Ns(2); N3=Ns(3);

N = Ns;
% construct k vectors (consistent with fftn ordering)
kx = (2*pi/Lx) * [0:(N1/2-1) -N1/2:-1];
ky = (2*pi/Ly) * [0:(N2/2-1) -N2/2:-1];
kz = (2*pi/Lz) * [0:(N3/2-1) -N3/2:-1];
[KX, KY, KZ] = ndgrid(kx, ky, kz);
K = sqrt(KX.^2 + KY.^2 + KZ.^2);

Nn = fftn(n);
NE = fftn(E);

% cross-spectrum (complex) and autos
cross_spec_3D = Nn .* conj(NE);     % note: complex
nn_spec_3D    = abs(Nn).^2;
EE_spec_3D    = abs(NE).^2;

% radial bins
dk = 2*pi / max([Lx,Ly,Lz]);   % choose bin width (can be tuned)
k_bins = 0:dk:kmax;
Nbins = length(k_bins)-1;
S_ne = zeros(1,Nbins);
S_nn = zeros(1,Nbins);
S_EE = zeros(1,Nbins);
k_centers = zeros(1,Nbins);

for i=1:Nbins
    kmin = k_bins(i);
    kmaxb = k_bins(i+1);
    mask = (K >= kmin) & (K < kmaxb);
    if ~any(mask,'all')
        S_ne(i) = 0;
        S_nn(i) = 0;
        S_EE(i) = 0;
    else
        S_ne(i) = sum(cross_spec_3D(mask),'all');   % complex sum
        S_nn(i) = sum(nn_spec_3D(mask),'all');
        S_EE(i) = sum(EE_spec_3D(mask),'all');
    end
    k_centers(i) = 0.5*(kmin + kmaxb);
end

% coherence (magnitude)
coh = zeros(size(S_ne));
idx = (S_nn>0) & (S_EE>0);
coh(idx) = abs(S_ne(idx)) ./ sqrt( S_nn(idx) .* S_EE(idx) );

% ensure numerical bounds [0,1]
coh = min(max(real(coh),0),1);

end






function [E_k, k_bins] = Omni1DSpectra(Bx_dt, Lx, Ly, Lz, threshold)

% Remove mean
Bx_dt_DT = Bx_dt - mean(Bx_dt, 'all');

% FFT of the 3D field
F_B = fftn(Bx_dt_DT);
Ns = size(Bx_dt);

% Wavenumber grids
kx = (2*pi/Lx) * [0:(Ns(1)/2-1) -Ns(1)/2:-1];
ky = (2*pi/Ly) * [0:(Ns(2)/2-1) -Ns(2)/2:-1];
kz = (2*pi/Lz) * [0:(Ns(3)/2-1) -Ns(3)/2:-1];
[KX, KY, KZ] = ndgrid(kx, ky, kz);

% Radial wavenumber
K = sqrt(KX.^2 + KY.^2 + KZ.^2);

% Energy spectrum (Parseval normalization)
energy = abs(F_B).^2 / prod(Ns);

% Radial bins
dk = 2 * pi / Lx;  % works if cubic box, otherwise choose min spacing
k_bins = 0:dk:threshold;

% Omnidirectional spectrum
E_k = zeros(size(k_bins));
for i = 1:length(k_bins)-1
    k_min = k_bins(i);
    k_max = k_bins(i+1);
    indices = (K >= k_min) & (K < k_max);
    E_k(i) = sum(energy(indices));
end

% Normalize by bin width
E_k = E_k / dk;

end
