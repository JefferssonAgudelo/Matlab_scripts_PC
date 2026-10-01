function W = multiplicative_cascade(Kmag, kedges, sigma2)
% MULTIPLICATIVE_CASCADE  Build hierarchical, positive, mean-1 cascade
% weight fields W(:,:,:,j) for j = 1..Nshells, following a standard
% log-normal multiplicative cascade (Castaing / Kolmogorov refined
% similarity picture): at each octave the field is multiplied by an
% independent, spatially smooth, mean-1 random factor. The cumulative
% product across octaves is what injects intermittency: after many
% multiplicative steps the local variance itself becomes a random,
% (log-normal-like) quantity, which is precisely the "Gaussian mixed
% with a positive random variance" mechanism that underlies the NIG
% family (NIG = Normal Inverse-Gaussian VARIANCE-MEAN MIXTURE).
%
%   W = multiplicative_cascade(Kmag, kedges, sigma2)
%
% Kmag   : |k| grid, same size as the real-space grid (from kspace_grid)
% kedges : vector of Nshells+1 shell boundaries in k (e.g. logarithmic)
% sigma2 : intermittency strength per octave (variance of the log-weight
%          added at each cascade step). sigma2=0 -> Gaussian, no
%          intermittency. Typical starting point: 0.05 - 0.3; tune this
%          (and Nshells) against the target kurtosis(scale) / NIG
%          parameters you're trying to match from the paper.
%
% W(:,:,:,j) is generated at the RESOLUTION of the FULL real-space grid,
% but the *smoothing length scale* of the random multiplier at octave j
% is tied to the shell's characteristic scale ell_j ~ 2*pi/kedges(j),
% i.e., the cascade weight only varies on scales >= that of shell j --
% enforcing the "local in scale" property of a real cascade.

    Nshells = numel(kedges) - 1;
    sz = size(Kmag);
    W = ones([sz Nshells]);

    logW = zeros(sz);
    for j = 1:Nshells
        ell_j = 2*pi / kedges(j+1); % smoothing length ~ finer edge of shell j

        noise = randn(sz);
        Fnoise = fftn(noise);
        % Gaussian low-pass filter in k-space with width set by ell_j
        Gfilt = exp(-(Kmag.^2) * (ell_j^2) / 2);
        smoothed = real(ifftn(Fnoise .* Gfilt));
        s = std(smoothed(:));
        if s > 0
            smoothed = smoothed / s;
        end

        m = sqrt(sigma2)*smoothed - 0.5*sigma2;  % E[exp(m)] = 1
        logW = logW + m;
        W(:,:,:,j) = exp(logW);
    end
end
