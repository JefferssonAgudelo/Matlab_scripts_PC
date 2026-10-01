function [alpha, beta, delta, mu, nll] = fit_nig(x)
% FIT_NIG  Maximum-likelihood fit of a Normal Inverse Gaussian
% distribution to a data sample (e.g. field increments at a fixed scale).
%
%   [alpha, beta, delta, mu, nll] = fit_nig(x)
%
% Uses an unconstrained reparametrization so fminsearch can be used
% without worrying about the NIG parameter constraints (alpha>0,
% |beta|<alpha, delta>0):
%   alpha = exp(p1)
%   beta  = alpha*tanh(p2)     (automatically satisfies |beta|<alpha)
%   delta = exp(p3)
%   mu    = p4
%
% Initial guess is obtained from a rough moment matching for the
% symmetric case (beta=0), for which variance = delta/alpha.

    x = x(:);
    x = x(isfinite(x));
    mu0 = mean(x);
    s0  = std(x);
    if s0 == 0, s0 = 1; end

    alpha0 = 2/s0;
    delta0 = s0^2 * alpha0;

    p0 = [log(alpha0), 0, log(delta0), mu0];

    opts = optimset('Display','off','MaxFunEvals',10000,'MaxIter',10000, ...
                     'TolX',1e-8,'TolFun',1e-8);
    p = fminsearch(@(p) neg_log_lik(p, x), p0, opts);

    alpha = exp(p(1));
    beta  = alpha*tanh(p(2));
    delta = exp(p(3));
    mu    = p(4);
    nll   = neg_log_lik(p, x);
end

function nll = neg_log_lik(p, x)
    alpha = exp(p(1));
    beta  = alpha*tanh(p(2));
    delta = exp(p(3));
    mu    = p(4);

    f = nig_pdf(x, alpha, beta, delta, mu);
    f = max(f, realmin);
    nll = -sum(log(f));
end
