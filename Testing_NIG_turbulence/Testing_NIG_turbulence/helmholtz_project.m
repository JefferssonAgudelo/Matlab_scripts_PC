function fproj = helmholtz_project(f, KX, KY, KZ, Kmag)
% HELMHOLTZ_PROJECT  Project a real 3D vector field onto its
% divergence-free (transverse/solenoidal) part:
%
%   fproj = helmholtz_project(f, KX, KY, KZ, Kmag)
%
% f : Nx x Ny x Nz x 3 real array
%
% WHY THIS IS NEEDED: apply_intermittency.m multiplies each k-shell's
% real-space contribution by a spatially varying scalar weight
% sqrt(W_j(x)). For a divergence-free field E (div E = 0), the modulated
% field w(x)*E(x) generally has div(w*E) = w*(div E) + E . grad(w) =
% E . grad(w) != 0 -- multiplying by a spatially varying scalar breaks
% exact solenoidality even though the original band was transverse in k.
% This function removes that small longitudinal/compressible
% contamination by projecting back onto the k-perpendicular subspace:
%
%   F_k -> F_k - khat (khat . F_k)
%
% Call this on b (and v) AFTER apply_intermittency / recombination and
% BEFORE rescaling to your target rms amplitude, since the projection
% removes a (typically small) amount of energy.

    sz = size(f);
    Fk = zeros(sz);
    for c = 1:3
        Fk(:,:,:,c) = fftn(f(:,:,:,c));
    end

    K2 = Kmag.^2;
    K2(K2 == 0) = Inf; % k=0 mode: no projection needed/well-defined

    kdotF = KX.*Fk(:,:,:,1) + KY.*Fk(:,:,:,2) + KZ.*Fk(:,:,:,3);
    fac = kdotF ./ K2;

    Fk(:,:,:,1) = Fk(:,:,:,1) - KX.*fac;
    Fk(:,:,:,2) = Fk(:,:,:,2) - KY.*fac;
    Fk(:,:,:,3) = Fk(:,:,:,3) - KZ.*fac;

    fproj = zeros(sz);
    for c = 1:3
        fproj(:,:,:,c) = ifftn(Fk(:,:,:,c), 'symmetric');
    end
end
