function d = read_moments_diagnostics(moments_file, layout, params)
% READ_MOMENTS_DIAGNOSTICS  Anisotropy + energy moments for one timestep.
%
% Follows exactly the derivation in your original script:
%   1. v_s = p_s * c / sqrt(c^2*m_s^2 + p_s^2)      (relativistic velocity
%      from momentum-density/number-density, per component, per species)
%   2. P_ij = T_ij - n*m*v_i*v_j                     (Reynolds decomposition:
%      subtract the bulk-flow term from the raw 2nd moment to get the
%      true, rest-frame pressure tensor)
%
% GEOMETRY (agreed): B0 is along x, turbulence is in the yz plane, so:
%   T_par  = P_xx / n            (parallel to B0)
%   T_perp = (P_yy + P_zz)/2 / n  (perpendicular, averaged over y,z)
% Anisotropy reported as domain-mean(T_perp) / domain-mean(T_par) for
% each species (see note in the header of compute_diagnostics.m if you'd
% rather use sum(P)/sum(n) weighting instead).
%
% ENERGY (agreed definition: magnetic + bulk kinetic + thermal):
%   E_kin_s = 0.5 * sum(n_s * m_s * |v_s|^2) * dV
%   E_th_s  = 0.5 * sum(trace(P_s)) * dV        (Pxx+Pyy+Pzz, Reynolds-
%                                                 decomposed pressure)
% (E_B is computed separately in read_field_diagnostics.m and summed in
% compute_diagnostics.m.)
%
% c=1, q=1, eps0=1 normalization, matching your setup (mi=mass_ratio*Zi,
% me=1, both from params = parse_cxx_params output).

    %mg = layout.moments_group;
    info = h5info(moments_file);
    mg = find_group_with_subgroup(info.Groups, 'rho_i');


    c = 1;
    mi = params.mi;
    me = params.me;

    if isfield(layout,'dV') && ~isempty(layout.dV)
        dV = layout.dV;
    else
        dV = 1;
    end

    % ---- densities --------------------------------------------------------
    rho_e = squeeze(h5read(moments_file, strcat(mg, '/rho_e/p0/3d')));
    rho_i = squeeze(h5read(moments_file, strcat(mg, '/rho_i/p0/3d')));

    % Your original script negates rho_e (stored with a sign convention
    % flip) and guards against exact zeros before dividing.
    n_e0 = -1 .* rho_e;
    n_i0 = rho_i;
    n_e0(n_e0 == 0) = 1e-20;
    n_i0(n_i0 == 0) = 1e-20;

    % ---- momentum density -> velocity --------------------------------------
    p_e = read_vec(moments_file, mg, {'px_e','py_e','pz_e'});
    p_i = read_vec(moments_file, mg, {'px_i','py_i','pz_i'});

    for k = 1:3
        p_e{k} = p_e{k} ./ n_e0;
        p_i{k} = p_i{k} ./ n_i0;
    end

    v_e = cell(1,3); v_i = cell(1,3);
    for k = 1:3
        v_e{k} = p_e{k} .* c ./ sqrt(c^2*me^2 + p_e{k}.^2);
        v_i{k} = p_i{k} .* c ./ sqrt(c^2*mi^2 + p_i{k}.^2);
    end

    % ---- raw 2nd moment (pressure-like) tensor -----------------------------
    Tij_e = read_sym_tensor(moments_file, mg, 'e');
    Tij_i = read_sym_tensor(moments_file, mg, 'i');

    % ---- Reynolds decomposition: P_ij = T_ij - n*m*v_i*v_j -----------------
    Pij_e = cell(3,3); Pij_i = cell(3,3);
    for i = 1:3
        for j = 1:3
            Pij_e{i,j} = Tij_e{i,j} - n_e0 .* me .* v_e{i} .* v_e{j};
            Pij_i{i,j} = Tij_i{i,j} - n_i0 .* mi .* v_i{i} .* v_i{j};
        end
    end

    % ---- temperature anisotropy (domain-mean of local T, then ratio) -----
    Tpar_e_local  = Pij_e{1,1} ./ n_e0;
    Tperp_e_local = 0.5 * (Pij_e{2,2} + Pij_e{3,3}) ./ n_e0;
    Tpar_i_local  = Pij_i{1,1} ./ n_i0;
    Tperp_i_local = 0.5 * (Pij_i{2,2} + Pij_i{3,3}) ./ n_i0;

    d.Tpar_e  = mean(Tpar_e_local(:));
    d.Tperp_e = mean(Tperp_e_local(:));
    d.Tpar_i  = mean(Tpar_i_local(:));
    d.Tperp_i = mean(Tperp_i_local(:));
    d.aniso_e = d.Tperp_e / d.Tpar_e;
    d.aniso_i = d.Tperp_i / d.Tpar_i;

    % ---- kinetic + thermal energy (volume-integrated) ----------------------
    v2_e = v_e{1}.^2 + v_e{2}.^2 + v_e{3}.^2;
    v2_i = v_i{1}.^2 + v_i{2}.^2 + v_i{3}.^2;
    d.E_kin_e = 0.5 * sum(n_e0(:) .* me .* v2_e(:)) * dV;
    d.E_kin_i = 0.5 * sum(n_i0(:) .* mi .* v2_i(:)) * dV;

    trP_e = Pij_e{1,1} + Pij_e{2,2} + Pij_e{3,3};
    trP_i = Pij_i{1,1} + Pij_i{2,2} + Pij_i{3,3};
    d.E_th_e = 0.5 * sum(trP_e(:)) * dV;
    d.E_th_i = 0.5 * sum(trP_i(:)) * dV;
end

% =========================================================================
function v = read_vec(file, group, names)
    v = cell(1,3);
    for k = 1:3
        v{k} = squeeze(h5read(file, strcat(group, '/', names{k}, '/p0/3d')));
    end
end

function T = read_sym_tensor(file, group, suffix)
% Reads txx,tyy,tzz,txy,tzx,tyz for species suffix ('e' or 'i') and
% assembles the symmetric 3x3 tensor cell array (matching your original
% script's naming: tzx is the (1,3)/(3,1) component).
    T = cell(3,3);
    T{1,1} = squeeze(h5read(file, strcat(group, '/txx_', suffix, '/p0/3d')));
    T{2,2} = squeeze(h5read(file, strcat(group, '/tyy_', suffix, '/p0/3d')));
    T{3,3} = squeeze(h5read(file, strcat(group, '/tzz_', suffix, '/p0/3d')));
    T{1,2} = squeeze(h5read(file, strcat(group, '/txy_', suffix, '/p0/3d')));
    T{1,3} = squeeze(h5read(file, strcat(group, '/tzx_', suffix, '/p0/3d')));
    T{2,3} = squeeze(h5read(file, strcat(group, '/tyz_', suffix, '/p0/3d')));
    T{2,1} = T{1,2};
    T{3,2} = T{2,3};
    T{3,1} = T{1,3};
end
