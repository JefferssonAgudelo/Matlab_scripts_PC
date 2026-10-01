function t = get_sim_time(pfd_file)
% GET_SIM_TIME  Read the actual simulation time from a pfd.<step>.h5 file.
%
%   t = get_sim_time(pfd_file)
%
% Confirmed from your actual HDF5 dump: each pfd file has a top-level
% group named 'psc-uid-<hex>' with plain scalar attributes 'timestep',
% 'time', 'cc', 'dt'. We want 'time' directly (already in whatever time
% units PSC's dimensionless normalization uses -- the same units your
% Omega_i/omega_pi are expressed in).
%
% IMPORTANT: the "<hex>" UID suffix on 'psc-uid-<hex>' is NOT stable --
% it differed between the fields file and moments file at the very same
% timestep in the sample you gave me. So this function re-scans each
% file's top-level groups fresh, rather than trusting a cached group
% path from an earlier discovery step.

    info = h5info(pfd_file);
    t = NaN;

    for i = 1:numel(info.Groups)
        g = info.Groups(i);
        if isempty(g.Attributes), continue; end
        names = {g.Attributes.Name};
        idx = find(strcmpi(names, 'time'), 1);
        if ~isempty(idx)
            t = double(g.Attributes(idx).Value(1));
            return;
        end
    end

    % Fallback: broaden to any attribute name containing 'time' (in case
    % of a naming variant), still top-level only.
    for i = 1:numel(info.Groups)
        g = info.Groups(i);
        if isempty(g.Attributes), continue; end
        names = lower({g.Attributes.Name});
        idx = find(contains(names, 'time'), 1);
        if ~isempty(idx)
            t = double(g.Attributes(idx).Value(1));
            return;
        end
    end

    warning('get_sim_time:notfound', ...
        'No "time" attribute found in top-level groups of %s. Returning NaN -- check h5disp() output.', pfd_file);
end
