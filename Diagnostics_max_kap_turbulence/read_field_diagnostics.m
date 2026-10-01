function d = read_field_diagnostics(pfd_file, layout)
% READ_FIELD_DIAGNOSTICS  RMS current and B-field magnitudes for one step.
%
% Geometry assumption (per your setup): the simulation is 2D in the yz
% plane, background field B0 is along x. So:
%   B_inplane = sqrt(By^2 + Bz^2)     -- the fluctuating/turbulent field
%   B_total   = sqrt(Bx^2 + By^2 + Bz^2)
%   J_rms     = sqrt(mean(Jx^2+Jy^2+Jz^2))   over the whole domain
%
% OUTPUT d: struct with scalar fields Jrms, Bip_rms, Btot_rms, plus the
% domain-mean of |B_total| (Btot_mean) in case you want mean instead of
% rms for the field magnitude panel.

    %fg = layout.field_group;
    info = h5info(pfd_file);
    fg = find_group_with_subgroup(info.Groups, 'hx_fc');

    Bx = squeeze(h5read(pfd_file, strcat(fg, '/hx_fc/p0/3d')));
    By = squeeze(h5read(pfd_file, strcat(fg, '/hy_fc/p0/3d')));
    Bz = squeeze(h5read(pfd_file, strcat(fg, '/hz_fc/p0/3d')));

    Jx = try_read(pfd_file, strcat(fg, '/jx_ec/p0/3d'));
    Jy = try_read(pfd_file, strcat(fg, '/jy_ec/p0/3d'));
    Jz = try_read(pfd_file, strcat(fg, '/jz_ec/p0/3d'));

    Bip2  = By.^2 + Bz.^2;
    Btot2 = Bx.^2 + By.^2 + Bz.^2;

    d.Bip_rms  = sqrt(mean(Bip2(:)));
    d.Btot_rms = sqrt(mean(Btot2(:)));
    d.Btot_mean = mean(sqrt(Btot2(:)));

    if ~isempty(Jx)
        J2 = Jx.^2 + Jy.^2 + Jz.^2;
        d.Jrms = sqrt(mean(J2(:)));
    else
        d.Jrms = NaN;
    end

    % Volume-integrated field energy, E_B = (1/2) * sum(B^2) * dV
    % (dV = cell volume from layout; falls back to 1 -- i.e. an
    % unnormalized sum -- if layout.dV wasn't discovered).
    if isfield(layout,'dV') && ~isempty(layout.dV)
        dV = layout.dV;
    else
        dV = 1;
    end
    d.E_B = 0.5 * sum(Btot2(:)) * dV;
    d.gridN  = numel(Bx);
end

function out = try_read(file, dset)
    try
        out = squeeze(h5read(file, dset));
    catch
        out = [];
    end
end
