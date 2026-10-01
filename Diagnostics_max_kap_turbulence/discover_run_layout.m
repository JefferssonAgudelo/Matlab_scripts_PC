function layout = discover_run_layout(run_path)
% DISCOVER_RUN_LAYOUT  Build a file list + HDF5 group map for one PSC run.
%
%   layout = discover_run_layout('/path/to/run_dir')
%
% Based on inspecting an actual pfd/pfd_moments HDF5 pair:
%   - Field data lives under a group named 'jeh-uid-<hex>', with
%     component subgroups hx_fc, hy_fc, hz_fc, jx_ec, jy_ec, jz_ec,
%     ex_ec, ey_ec, ez_ec (each holding dataset p0/3d).
%   - Moments live under 'all_1st_cc-uid-<hex>', with subgroups
%     rho_e, jx_e..pz_e, txx_e..tzx_e, rho_i, jx_i..pz_i, txx_i..tzx_i.
%   - The trailing "-uid-0x....." hex differs between files (confirmed:
%     different hex for the fields vs moments file at the SAME
%     timestep), so we search by subgroup NAME, never by hardcoding the
%     group path.
%   - Domain bounds are attributes 'lo_code'/'hi_code' (equivalently
%     'l'/'h') on a group named 'mrc_crds-uid-<hex>'.
%   - Time is a scalar attribute 'time' on a group named 'psc-uid-<hex>'.
%     Since that hex also changes per file, get_sim_time.m re-discovers
%     it fresh for every file rather than trusting a cached path.
%
% OUTPUT (layout struct)
%   .run_path, .pfd_files, .moments_files, .steps  (paired file lists)
%   .field_group, .moments_group   (paths, discovered from file 1)
%   .Lx, .Ly, .Lz         (domain size, from lo_code/hi_code on file 1)
%   .LXs, .LYs, .LZs      (grid shape [x y z], from dataset metadata,
%                          not by reading+squeezing the actual array)
%   .dV                   (cell volume = (Lx/LXs)*(Ly/LYs)*(Lz/LZs))
%
% NOTE: field_group/moments_group are cached from file 1 for speed. If a
% later file in the same run used a differently-named subgroup structure
% (shouldn't happen within one run, but flagging just in case), read
% functions will error clearly rather than silently mis-reading.

    S = dir(fullfile(run_path, 'pfd.*.h5'));
    if isempty(S)
        error('discover_run_layout:nofiles', 'No pfd.*.h5 files found in %s', run_path);
    end
    Sm = dir(fullfile(run_path, 'pfd_moments.*.h5'));

    steps = nan(numel(S),1);
    for i = 1:numel(S)
        tok = regexp(S(i).name, '\.(\d+)', 'tokens', 'once');
        if ~isempty(tok), steps(i) = str2double(tok{1}); end
    end
    [steps, order] = sort(steps);
    S = S(order);
    pfd_files = fullfile(run_path, {S.name});

    moments_steps = nan(numel(Sm),1);
    for i = 1:numel(Sm)
        tok = regexp(Sm(i).name, '\.(\d+)', 'tokens', 'once');
        if ~isempty(tok), moments_steps(i) = str2double(tok{1}); end
    end

    moments_files = cell(size(pfd_files));
    for i = 1:numel(steps)
        idx = find(moments_steps == steps(i), 1);
        if isempty(idx)
            moments_files{i} = '';
            warning('discover_run_layout:nomatch', ...
                'No pfd_moments file matches step %d (%s)', steps(i), S(i).name);
        else
            moments_files{i} = fullfile(run_path, Sm(idx).name);
        end
    end

    layout.run_path = run_path;
    layout.pfd_files = pfd_files;
    layout.moments_files = moments_files;
    layout.steps = steps;

    % --- discover field group by subgroup name 'hx_fc' --------------------
    info = h5info(pfd_files{1});
    layout.field_group = find_group_with_subgroup(info.Groups, 'hx_fc');
    if isempty(layout.field_group)
        warning('discover_run_layout:nofieldgroup', ...
            'Could not find a group containing subgroup "hx_fc" in %s.', pfd_files{1});
    end

    % --- exact array shape from dataset metadata (no data read) ----------
    layout.LXs = []; layout.LYs = []; layout.LZs = [];
    if ~isempty(layout.field_group)
        dset_info = h5info(pfd_files{1}, strcat(layout.field_group, '/hx_fc/p0/3d'));
        sz = dset_info.Dataspace.Size;
        if numel(sz) < 3, sz(end+1:3) = 1; end
        layout.LXs = sz(1); layout.LYs = sz(2); layout.LZs = sz(3);
    end

    % --- domain bounds from lo_code/hi_code (fallback l/h) ----------------
    [lo, hi] = find_domain_bounds(info.Groups);
    if isempty(lo)
        warning('discover_run_layout:nogridgroup', ...
            'Could not find domain bounds (lo_code/hi_code or l/h) in %s.', pfd_files{1});
        layout.Lx = []; layout.Ly = []; layout.Lz = [];
    else
        layout.Lx = hi(1) - lo(1);
        layout.Ly = hi(2) - lo(2);
        layout.Lz = hi(3) - lo(3);
    end

    if ~isempty(layout.Lx) && ~isempty(layout.LXs)
        layout.dV = (layout.Lx/layout.LXs) * (layout.Ly/layout.LYs) * (layout.Lz/layout.LZs);
    else
        layout.dV = [];
    end

    % --- moments group by subgroup name 'rho_i' ----------------------------
    layout.moments_group = '';
    firstmom_idx = find(~cellfun(@isempty, layout.moments_files), 1);
    if ~isempty(firstmom_idx)
        firstmom = layout.moments_files{firstmom_idx};
        info2 = h5info(firstmom);
        layout.moments_group = find_group_with_subgroup(info2.Groups, 'rho_i');
        if isempty(layout.moments_group)
            warning('discover_run_layout:nomomgroup', ...
                'Could not find a group containing subgroup "rho_i" in %s.', firstmom);
        end
    end
end

% =========================================================================
function grp_name = find_group_with_subgroup(groups, target_name)
% Recursively search for a group that has a direct child subgroup whose
% last path component equals target_name (e.g. 'hx_fc'). Returns the
% PARENT group's full HDF5 path, or '' if not found.
    grp_name = '';
    for i = 1:numel(groups)
        g = groups(i);
        if isfield(g, 'Groups') && ~isempty(g.Groups)
            child_names = arrayfun(@(s) last_component(s.Name), g.Groups, 'UniformOutput', false);
            if any(strcmp(child_names, target_name))
                grp_name = g.Name;
                return;
            end
            grp_name = find_group_with_subgroup(g.Groups, target_name);
            if ~isempty(grp_name), return; end
        end
    end
end

function c = last_component(fullpath)
    parts = strsplit(fullpath, '/');
    c = parts{end};
end

function [lo, hi] = find_domain_bounds(groups)
    lo = []; hi = [];
    for i = 1:numel(groups)
        g = groups(i);
        if isfield(g,'Attributes') && ~isempty(g.Attributes)
            names = {g.Attributes.Name};
            ilo = find(strcmpi(names,'lo_code'), 1);
            ihi = find(strcmpi(names,'hi_code'), 1);
            if isempty(ilo), ilo = find(strcmpi(names,'l'), 1); end
            if isempty(ihi), ihi = find(strcmpi(names,'h'), 1); end
            if ~isempty(ilo) && ~isempty(ihi)
                lo = double(g.Attributes(ilo).Value);
                hi = double(g.Attributes(ihi).Value);
                return;
            end
        end
        if isfield(g,'Groups') && ~isempty(g.Groups)
            [lo, hi] = find_domain_bounds(g.Groups);
            if ~isempty(lo), return; end
        end
    end
end
