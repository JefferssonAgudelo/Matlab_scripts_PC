function freqs = compute_frequencies(params)
% COMPUTE_FREQUENCIES  Derive Omega_i, Omega_e, omega_pi from cxx params.
%
% CONVENTION (reused from your original script, substituting the new
% .cxx's vA_over_c/mass_ratio for the old script's Vai/mime):
%
%     omega_pi  = 1                                   (chosen time unit)
%     Omega_e   = vA_over_c * sqrt(mass_ratio) * omega_pi
%     Omega_i   = Omega_e / mass_ratio
%
% PLEASE VERIFY: your new .cxx computes B0 = vA_over_c directly (rather
% than the old script's independent Vai/Vae/Va inputs), so this
% substitution assumes vA_over_c plays the same normalization role Vai
% did before. If your PSC dimensionless normalization defines omega_pi
% differently (e.g. via g.n, g.omegape_Omegae), tell me and I'll adjust
% this one function -- everything downstream just calls
% compute_frequencies(params) and uses .omega_pi/.Omega_i/.Omega_e.

    freqs.omega_pi = 1;
    freqs.Omega_e = params.vA_over_c * sqrt(params.mass_ratio) * freqs.omega_pi;
    freqs.Omega_i = freqs.Omega_e / params.mass_ratio;
    freqs.TOmega_i = 1 / freqs.Omega_i;
    freqs.TOmega_e = 1 / freqs.Omega_e;
end
