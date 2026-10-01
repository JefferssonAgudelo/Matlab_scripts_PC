function results = diagnostics_increments(field3d, dx, lag_list, max_samples)
% DIAGNOSTICS_INCREMENTS  Check whether a real-space field has developed
% scale-dependent, non-Gaussian (NIG-like) increment statistics.
%
%   results = diagnostics_increments(field3d, dx, lag_list, max_samples)
%
% field3d    : Nx x Ny x Nz real array (one component, e.g. bx or z+_x)
% dx         : grid spacing (for reporting physical scale ell = lag*dx)
% lag_list   : vector of integer lags (in grid points) along x, periodic
% max_samples: subsample size for the NIG MLE fit (fits are done on a
%              random subsample for speed; the kurtosis/histogram use
%              the full increment field)
%
% results(k).lag, .ell, .kurtosis, .alpha, .beta, .delta, .mu, .increments

    if nargin < 4, max_samples = 2e5; end

    results = struct('lag',{},'ell',{},'kurtosis',{},'alpha',{}, ...
                      'beta',{},'delta',{},'mu',{});

    figure('Name','Increment PDFs vs scale');
    hold on;
    cmap = lines(numel(lag_list));

    for i = 1:numel(lag_list)
        L = lag_list(i);
        d = field3d - circshift(field3d, L, 1);
        d = d(:);
        d = d - mean(d);
        d = d / std(d);   % normalize each scale to unit variance for
                           % overlay comparison (standard in these studies)

        k4 = mean(d.^4) - 3; % excess kurtosis

        idx = randperm(numel(d), min(max_samples, numel(d)));
        [alpha, beta, delta, mu] = fit_nig(d(idx));

        [counts, edges] = histcounts(d, 100, 'Normalization','pdf');
        centers = 0.5*(edges(1:end-1)+edges(2:end));
        semilogy(centers, counts, 'o', 'Color', cmap(i,:), ...
                 'DisplayName', sprintf('lag = %d dx', L));

        xx = linspace(min(d), max(d), 400);
        semilogy(xx, nig_pdf(xx, alpha, beta, delta, mu), '-', ...
                  'Color', cmap(i,:), 'HandleVisibility','off');

        results(i).lag = L;
        results(i).ell = L*dx;
        results(i).kurtosis = k4;
        results(i).alpha = alpha;
        results(i).beta = beta;
        results(i).delta = delta;
        results(i).mu = mu;
    end

    xlabel('normalized increment (delta f) / sigma  [at fixed scale]');
    ylabel('PDF (log scale)');
    set(gca,'YScale','log');
    legend show;
    title('Points = measured PDF, lines = NIG fit');

    figure('Name','Excess kurtosis vs scale');
    ells = [results.ell];
    kurts = [results.kurtosis];
    semilogx(ells, kurts, 'o-','LineWidth',1.5);
    xlabel('scale (grid units)'); ylabel('excess kurtosis');
    title('Should be ~0 at large scale (Gaussian), growing at small scale');
    grid on;
end
