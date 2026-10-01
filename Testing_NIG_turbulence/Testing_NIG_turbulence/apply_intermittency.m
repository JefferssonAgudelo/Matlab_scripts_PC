function fx = apply_intermittency(fk, Kmag, kedges, W)
% APPLY_INTERMITTENCY  Decompose a complex spectral vector field into
% logarithmic k-shells, inverse-transform each shell to real space,
% multiply each shell's real-space contribution by sqrt(W_j(x)) (the
% cascade weight for that shell), and sum the shells back together.
%
%   fx = apply_intermittency(fk, Kmag, kedges, W)
%
% fk     : Nx x Ny x Nz x 3 complex Fourier coefficients (e.g. zp_k)
% Kmag   : |k| grid
% kedges : shell boundaries used to build W (must match multiplicative_cascade)
% W      : Nx x Ny x Nz x Nshells cascade weights from multiplicative_cascade
%
% fx     : Nx x Ny x Nz x 3 REAL intermittent field
%
% Why sqrt(W): W multiplies the local ENERGY (variance) of the band, so
% the field amplitude scales as sqrt(W). Because E[W_j] = 1 by
% construction, the shell-integrated power spectrum is preserved on
% average -- you are redistributing energy in space (creating
% intermittent bursts/quiescent patches), not changing E(k).

    Nshells = size(W,4);
    sz = size(Kmag);
    fx = zeros([sz 3]);

    for j = 1:Nshells
        mask = (Kmag >= kedges(j)) & (Kmag < kedges(j+1));
        sqW = sqrt(W(:,:,:,j));
        for c = 1:3
            comp_k = fk(:,:,:,c) .* mask;
            comp_x = ifftn(comp_k, 'symmetric');
            fx(:,:,:,c) = fx(:,:,:,c) + comp_x .* sqW;
        end
    end
end
