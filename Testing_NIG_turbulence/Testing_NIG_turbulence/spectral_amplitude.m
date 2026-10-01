function amp = spectral_amplitude(Kmag, k0, kmax, alpha, kdiss)
% SPECTRAL_AMPLITUDE  Fourier-amplitude envelope giving an isotropic
% energy spectrum E(k) ~ k^{-alpha} in the inertial range.
%
%   amp = spectral_amplitude(Kmag, k0, kmax, alpha, kdiss)
%
% Kmag  : array of |k| values (from kspace_grid)
% k0    : outer-scale wavenumber (energy injection scale), amp=0 below it
% kmax  : largest wavenumber to populate (resolution / anti-aliasing limit)
% alpha : spectral slope of E(k) (e.g. 5/3 Kolmogorov, 3/2 IK, 2 for k^-2 etc)
% kdiss : (optional) dissipation wavenumber for a smooth spectral break /
%         exponential rolloff, mimicking the end of the inertial range.
%         Pass [] or omit for a pure power law cut sharply at kmax.
%
% NOTE on normalization: energy spectral density (per unit volume) is
% E(k) ~ 4*pi*k^2*|b_k|^2 for an isotropic field, so to get E(k) ~ k^-alpha
% one needs |b_k| ~ k^-(alpha/2+1). This function returns |b_k|, i.e. the
% amplitude PER FOURIER MODE (not shell-integrated), so the exponent used
% below is -(alpha/2 + 1) -- this is the quantity you multiply the random
% complex coefficient by.

    if nargin < 5
        kdiss = [];
    end

    amp = zeros(size(Kmag));
    mask = (Kmag >= k0) & (Kmag <= kmax);
    amp(mask) = Kmag(mask).^( -(alpha/2 + 1) );

    % normalize so that amp(k0)=1 (arbitrary convenient reference; rescale
    % the whole field afterwards to hit a target rms fluctuation level)
    amp = amp / max(amp(:));

    if ~isempty(kdiss)
        amp = amp .* exp(-(Kmag/kdiss).^2);
    end

    amp(Kmag == 0) = 0;
end
