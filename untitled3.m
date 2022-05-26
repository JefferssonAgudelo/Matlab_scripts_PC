% Example 1
load mri
D = squeeze(D);
%DD=1./D;
vtkwrite('mri.vtk', 'structured_points', 'mri1', D)
%vtkwrite('mri.vtk', 'structured_points', 'mri2', DD)% This doen't work

load wind
[cu,cv,cw] = curl(x, y, z, u, v, w);
div = divergence(x, y, z, u, v, w);
vtkwrite('wind.vtk', 'structured_grid', x, y, z, ...
'vectors', 'vector_field', u, v, w, 'vectors', 'vorticity', cu, cv, cw, 'scalars', 'divergence', div);


r(:,:,1)  = [1 0 2 1 1; 2 0 3 1 1; 3 0 4 1 1;  4 0 1 1 -1; ...
    5 0 -1 1 1; 1 1 3 1 -1; 2 1 2 1 1; 3 1 5 0 -1; 4 1 4 1 -1; 5 1 1 0 -1]; 
r(:,:,2) = [1 0 2 1 -1; 2 0 3 1 1; 3 0 1 1 -1; 4 0 1 1 -1; ...
    5 0 -1 1 1; 1 1 1 1 -1; 2 1 2 1 1; 3 1 4 1 1;  4 1 5 1 1;  5 1 3 0 1];

f1=figure(1)
pcolor(r(:,:,1))