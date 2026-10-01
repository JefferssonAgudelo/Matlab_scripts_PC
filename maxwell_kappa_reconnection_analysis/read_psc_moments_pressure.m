function P_particle_full = read_psc_moments_pressure(mfname, moments_group_override, me, mi)
% READ_PSC_MOMENTS_PRESSURE  Read PSC moments for one step and return the
% Reynolds-decomposed scalar (isotropic) particle pressure field P(y,z),
% correctly oriented as (nz, ny).
%
%   P_particle_full = read_psc_moments_pressure(mfname, moments_group_override, me, mi)
%
% moments_group_override: if non-empty, used directly as the per-step
% HDF5 group path; if empty, auto-detected via find_group_with_subgroup
% (searching for the 'rho_i' subgroup).
%
% See the comments in psc_time_evolution_plots.m for the physics: rho_e
% is sign-flipped (charge-density-like), and txx/tyy/tzz are the RAW
% second velocity moment (still containing the bulk-flow term), so the
% true pressure needs P_ij = T_ij_raw - n*m*v_i*v_j, with v obtained
% relativistically from the momentum density.

    if ~isempty(moments_group_override)
        grp = moments_group_override;
    else
        minfo = h5info(mfname);
        grp = find_group_with_subgroup(minfo.Groups, 'rho_i');
        if isempty(grp)
            error('read_psc_moments_pressure: could not locate the "rho_i" group inside %s -- set moments_group_override instead.', mfname);
        end
    end

    rho_e = squeeze(h5read(mfname, strcat(grp, '/rho_e/p0/3d'))).';
    rho_i = squeeze(h5read(mfname, strcat(grp, '/rho_i/p0/3d'))).';
    n_e0 = -1 .* rho_e;   % sign-flip: stored charge-density-like
    n_i0 = rho_i;
    n_e0(n_e0 == 0) = 1e-20;
    n_i0(n_i0 == 0) = 1e-20;

    px_e = squeeze(h5read(mfname, strcat(grp, '/px_e/p0/3d'))).' ./ n_e0;
    py_e = squeeze(h5read(mfname, strcat(grp, '/py_e/p0/3d'))).' ./ n_e0;
    pz_e = squeeze(h5read(mfname, strcat(grp, '/pz_e/p0/3d'))).' ./ n_e0;
    px_i = squeeze(h5read(mfname, strcat(grp, '/px_i/p0/3d'))).' ./ n_i0;
    py_i = squeeze(h5read(mfname, strcat(grp, '/py_i/p0/3d'))).' ./ n_i0;
    pz_i = squeeze(h5read(mfname, strcat(grp, '/pz_i/p0/3d'))).' ./ n_i0;

    c_ = 1;
    vx_e = px_e.*c_ ./ sqrt(c_^2*me^2 + px_e.^2);
    vy_e = py_e.*c_ ./ sqrt(c_^2*me^2 + py_e.^2);
    vz_e = pz_e.*c_ ./ sqrt(c_^2*me^2 + pz_e.^2);
    vx_i = px_i.*c_ ./ sqrt(c_^2*mi^2 + px_i.^2);
    vy_i = py_i.*c_ ./ sqrt(c_^2*mi^2 + py_i.^2);
    vz_i = pz_i.*c_ ./ sqrt(c_^2*mi^2 + pz_i.^2);

    % vx_e = px_e.*c_ ;% this leads to negative Pressures
    % vy_e = py_e.*c_ ;
    % vz_e = pz_e.*c_ ;
    % vx_i = px_i.*c_ ;
    % vy_i = py_i.*c_ ;
    % vz_i = pz_i.*c_ ;

    Txx_e = squeeze(h5read(mfname, strcat(grp, '/txx_e/p0/3d'))).';
    Tyy_e = squeeze(h5read(mfname, strcat(grp, '/tyy_e/p0/3d'))).';
    Tzz_e = squeeze(h5read(mfname, strcat(grp, '/tzz_e/p0/3d'))).';
    Txx_i = squeeze(h5read(mfname, strcat(grp, '/txx_i/p0/3d'))).';
    Tyy_i = squeeze(h5read(mfname, strcat(grp, '/tyy_i/p0/3d'))).';
    Tzz_i = squeeze(h5read(mfname, strcat(grp, '/tzz_i/p0/3d'))).';

    Pxx_e = Txx_e - n_e0.*me.*vx_e.^2;
    Pyy_e = Tyy_e - n_e0.*me.*vy_e.^2;
    Pzz_e = Tzz_e - n_e0.*me.*vz_e.^2;
    Pxx_i = Txx_i - n_i0.*mi.*vx_i.^2;
    Pyy_i = Tyy_i - n_i0.*mi.*vy_i.^2;
    Pzz_i = Tzz_i - n_i0.*mi.*vz_i.^2;

    P_particle_full = (Pxx_e + Pyy_e + Pzz_e)/3 + (Pxx_i + Pyy_i + Pzz_i)/3;
end
