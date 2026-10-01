function [KX,KY,KZ,Kmag,kx,ky,kz] = kspace_grid(Nx,Ny,Nz,Lx,Ly,Lz)
% KSPACE_GRID  Build a 3D FFT wavenumber grid consistent with MATLAB's
% fftn/ifftn ordering: [0, 1, ..., N/2-1, -N/2, ..., -1] * 2*pi/L
%
%   [KX,KY,KZ,Kmag,kx,ky,kz] = kspace_grid(Nx,Ny,Nz,Lx,Ly,Lz)
%
% Nx,Ny,Nz : grid points per direction (even numbers recommended)
% Lx,Ly,Lz : physical box size per direction
%
% KX,KY,KZ : Nx x Ny x Nz arrays of wavenumber components (ndgrid layout)
% Kmag     : |k|
% kx,ky,kz : 1D wavenumber vectors

    kx = (2*pi/Lx) * [0:(Nx/2-1), -Nx/2:-1];
    ky = (2*pi/Ly) * [0:(Ny/2-1), -Ny/2:-1];
    kz = (2*pi/Lz) * [0:(Nz/2-1), -Nz/2:-1];

    [KX, KY, KZ] = ndgrid(kx, ky, kz);
    Kmag = sqrt(KX.^2 + KY.^2 + KZ.^2);
end
