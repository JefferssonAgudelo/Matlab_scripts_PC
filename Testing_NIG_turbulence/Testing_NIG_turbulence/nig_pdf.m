function f = nig_pdf(x, alpha, beta, delta, mu)
% NIG_PDF  Normal Inverse Gaussian probability density function.
%
%   f = nig_pdf(x, alpha, beta, delta, mu)
%
% Parameters (standard Barndorff-Nielsen parametrization):
%   alpha : tail heaviness / steepness, alpha > 0
%   beta  : asymmetry, |beta| < alpha
%   delta : scale, delta > 0
%   mu    : location
%
% f(x) = (alpha*delta/pi) * exp( delta*gamma + beta*(x-mu) )
%         * K1( alpha*sqrt(delta^2+(x-mu)^2) ) / sqrt(delta^2+(x-mu)^2)
% with gamma = sqrt(alpha^2 - beta^2), K1 = modified Bessel function of
% the second kind, order 1 (besselk in MATLAB).
%
% As delta/alpha -> ... this family continuously interpolates between
% (approximately) Gaussian core behaviour and exponential/semi-heavy
% tails, which is exactly the behaviour reported for scale-dependent
% PDFs of turbulent increments (Palacios, Perez & Bourouaine 2024,
% MNRAS 531, 24).

    gamma_ = sqrt(alpha.^2 - beta.^2);
    q = sqrt(delta.^2 + (x - mu).^2);
    f = (alpha.*delta ./ pi) .* exp(delta.*gamma_ + beta.*(x - mu)) ...
        .* besselk(1, alpha.*q) ./ q;
end
