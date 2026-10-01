function diag = compute_diagnostics(run_path, cxx_path)
% COMPUTE_DIAGNOSTICS  Full diagnostics time series for one PSC run.
%
%   diag = compute_diagnostics('/path/to/run_dir', '/path/to/setup.cxx')
%
% OUTPUT (diag struct, one entry per timestep, sorted by time):
%   .t          raw simulation time (code units, from get_sim_time.m)
%   .t_Oi       t * Omega_i          (ion gyroperiod units)
%   .t_opi      t * omega_pi         (ion plasma-frequency units)
%   .Jrms       RMS current density
%   .Bip_rms    RMS in-plane |B| = sqrt(By^2+Bz^2)
%   .Btot_rms   RMS total |B|
%   .aniso_i, .aniso_e     T_perp/T_par for ions/electrons
%   .Etot, .E_B, .E_kin_i, .E_kin_e, .E_th_i, .E_th_e
%   .params     parsed cxx params struct
%   .freqs      Omega_i/Omega_e/omega_pi struct
%   .layout     discovered HDF5 layout struct
%
% This is deliberately a plain struct-of-arrays (not a table) so it's
% trivial to save with `save(...,'-v7.3')` and reload for comparison
% across runs in compare_runs.m.

    if nargin < 2 || isempty(cxx_path)
        cxx_list = dir(fullfile(run_path, '*.cxx'));
        if isempty(cxx_list)
            error('compute_diagnostics:nocxx', 'No .cxx file found in %s', run_path);
        elseif numel(cxx_list) > 1
            error('compute_diagnostics:multicxx', ...
                'Found %d .cxx files in %s -- pass cxx_path explicitly:\n%s', ...
                numel(cxx_list), run_path, strjoin({cxx_list.name}, ', '));
        end
        cxx_path = fullfile(run_path, cxx_list(1).name);
    end

    fprintf('Parsing cxx parameters from %s ...\n', cxx_path);
    params = parse_cxx_params(cxx_path);
    freqs = compute_frequencies(params);
    fprintf('  mass_ratio=%.3g  B0=%.3g  Omega_i=%.4g  omega_pi=%.4g\n', ...
        params.mass_ratio, params.B0, freqs.Omega_i, freqs.omega_pi);

    fprintf('Discovering HDF5 layout in %s ...\n', run_path);
    layout = discover_run_layout(run_path);
    fprintf('  field_group   = %s\n', layout.field_group);
    fprintf('  moments_group = %s\n', layout.moments_group);
    fprintf('  Lx=%.4g Ly=%.4g Lz=%.4g  grid=[%d %d %d]  dV=%.6g\n', ...
        layout.Lx, layout.Ly, layout.Lz, layout.LXs, layout.LYs, layout.LZs, layout.dV);

    N = numel(layout.pfd_files)-1;
    t         = nan(N,1);
    Jrms      = nan(N,1);
    Bip_rms   = nan(N,1);
    Btot_rms  = nan(N,1);
    aniso_i   = nan(N,1);
    aniso_e   = nan(N,1);
    E_B       = nan(N,1);
    E_kin_i   = nan(N,1);
    E_kin_e   = nan(N,1);
    E_th_i    = nan(N,1);
    E_th_e    = nan(N,1);

    for k = 1:N
        pfd_file = layout.pfd_files{k};
        mom_file = layout.moments_files{k};

        H5.garbage_collect();   % <-- add this: clears stale HDF5 file IDs
                                %     that otherwise accumulate over many
                                %     h5info/h5read calls and eventually
                                %     break h5info() with "not a file id"

        fprintf('[%d/%d] %s\n', k, N, pfd_file);

        t(k) = get_sim_time(pfd_file);

        fd = read_field_diagnostics(pfd_file, layout);
        Jrms(k)     = fd.Jrms;
        Bip_rms(k)  = fd.Bip_rms;
        Btot_rms(k) = fd.Btot_rms;
        E_B(k)      = fd.E_B;

        if isempty(mom_file)
            warning('compute_diagnostics:nomoments', ...
                'No moments file for step %d -- anisotropy/kinetic/thermal energy set to NaN.', layout.steps(k));
            continue;
        end

        md = read_moments_diagnostics(mom_file, layout, params);
        aniso_i(k) = md.aniso_i;
        aniso_e(k) = md.aniso_e;
        E_kin_i(k) = md.E_kin_i;
        E_kin_e(k) = md.E_kin_e;
        E_th_i(k)  = md.E_th_i;
        E_th_e(k)  = md.E_th_e;
    end

    [t, order] = sort(t);

    diag.t         = t;
    diag.t_Oi      = t * freqs.Omega_i;
    diag.t_opi     = t * freqs.omega_pi;
    diag.Jrms      = Jrms(order);
    diag.Bip_rms   = Bip_rms(order);
    diag.Btot_rms  = Btot_rms(order);
    diag.aniso_i   = aniso_i(order);
    diag.aniso_e   = aniso_e(order);
    diag.E_B       = E_B(order);
    diag.E_kin_i   = E_kin_i(order);
    diag.E_kin_e   = E_kin_e(order);
    diag.E_th_i    = E_th_i(order);
    diag.E_th_e    = E_th_e(order);
    diag.Etot      = diag.E_B + diag.E_kin_i + diag.E_kin_e + diag.E_th_i + diag.E_th_e;

    diag.params = params;
    diag.freqs  = freqs;
    diag.layout = layout;
    diag.run_path = run_path;
end
