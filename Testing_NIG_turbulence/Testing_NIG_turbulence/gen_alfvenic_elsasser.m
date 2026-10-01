function [zp_k, zm_k, KX,KY,KZ,Kmag] = gen_alfvenic_elsasser(Nx,Ny,Nz,Lx,Ly,Lz,alpha,k0,kmax,kdiss,sigma_c)
% GEN_ALFVENIC_ELSASSER  Build random-phase, solenoidal (div-free),
% transverse (to B0 = z-hat) Fourier fields for the Elsasser variables
% z+ and z-, with a chosen isotropic spectral slope and cross helicity.
%
%   [zp_k, zm_k, KX,KY,KZ,Kmag] = ...
%        gen_alfvenic_elsasser(Nx,Ny,Nz,Lx,Ly,Lz,alpha,k0,kmax,kdiss,sigma_c)
%
% B0 is assumed along +z. If you need B0 along another direction, rotate
% the final real-space fields rigidly afterwards (rotating a divergence-
% free, transverse field preserves both properties).
%
% alpha   : spectral index of E(k) ~ k^-alpha for the *unperturbed* base
%           field (before the intermittency cascade is applied later)
% k0,kmax : inertial range wavenumber bounds
% kdiss   : dissipation-scale rolloff wavenumber (or [])
% sigma_c : cross helicity in [-1,1]; sigma_c=(E+ - E-)/(E+ + E-)
%           sigma_c=+1 -> purely outward propagating (z-=0)
%           sigma_c=-1 -> purely inward propagating (z+=0)
%           sigma_c=0  -> balanced turbulence
%
% Output zp_k, zm_k are Nx x Ny x Nz x 3 complex arrays (Fourier
% coefficients, NOT yet made Hermitian -- use ifftn(...,'symmetric')
% when transforming to real space, which enforces a real result).
%
% This is the STANDARD Elsasser-variable construction used to set up
% balanced/imbalanced Alfvenic turbulence in MHD and PIC codes: since
% z+ and z- are the two independent characteristic fields of the linear
% (shear-)Alfven wave problem, generating them independently with a
% transverse, div-free polarization automatically gives you an ensemble
% of exact linear Alfven-wave packets with the desired v-b correlation.

    [KX,KY,KZ,Kmag] = kspace_grid(Nx,Ny,Nz,Lx,Ly,Lz);
    amp = spectral_amplitude(Kmag, k0, kmax, alpha, kdiss);

    Ep_frac = (1 + sigma_c)/2;
    Em_frac = (1 - sigma_c)/2;

    amp_p = amp * sqrt(2*Ep_frac);
    amp_m = amp * sqrt(2*Em_frac);

    zp_k = transverse_field_zaligned(amp_p, KX, KY, KZ, Kmag);
    zm_k = transverse_field_zaligned(amp_m, KX, KY, KZ, Kmag);
end

% ---------------------------------------------------------------------
function bk = transverse_field_zaligned(amp, KX, KY, KZ, Kmag)
% Vectorized construction of a divergence-free field polarized in the
% plane perpendicular to k, with B0 = z-hat used to fix the polarization
% basis (e1 = k x zhat, e2 = k x e1), and independent complex Gaussian
% weights on each polarization -> statistically isotropic transverse
% turbulence.

    Kperp = sqrt(KX.^2 + KY.^2);
    e1x = zeros(size(KX)); e1y = zeros(size(KX));

    good = Kperp > 0;
    e1x(good) =  KY(good)./Kperp(good);
    e1y(good) = -KX(good)./Kperp(good);
    % k parallel to z (Kperp=0): pick an arbitrary transverse direction
    e1x(~good) = 1; e1y(~good) = 0;
    e1z = zeros(size(KX));

    Kg = Kmag; Kg(Kg==0) = Inf; % avoid 0/0, amp is 0 there anyway

    e2x = -KZ.*e1y ./ Kg;
    e2y =  KZ.*e1x ./ Kg;
    e2z = (KX.*e1y - KY.*e1x) ./ Kg;

    r1 = (randn(size(KX)) + 1i*randn(size(KX)))/sqrt(2);
    r2 = (randn(size(KX)) + 1i*randn(size(KX)))/sqrt(2);

    bk = zeros([size(KX) 3]);
    bk(:,:,:,1) = amp.*(r1.*e1x + r2.*e2x);
    bk(:,:,:,2) = amp.*(r1.*e1y + r2.*e2y);
    bk(:,:,:,3) = amp.*(r1.*e1z + r2.*e2z);
end
