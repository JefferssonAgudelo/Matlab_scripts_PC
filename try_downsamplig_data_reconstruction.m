% This is to create a downsampling script for the magnetic
% reconstruction project.

path = '/Volumes/PSC_DiRAC_DATA/DATACB103_1';

cd(path)
S = dir(fullfile(path,'pfd.*.h5'));
N=numel(S); % number of files to use
H=zeros(N);

%--------------------------------------------------------------------------
% Normalization
%B are normalized to the background magnetic field
B0=0.2;
%n is normalise to the proton density n0=1
%--------------------------------------------------------------------------
kb = 1.; mu0 =1.; c=1; q = 1; mime=100; 
mi = 1. * mime; 
me = 1. ; eps0=1.;

jn=6;
in=jn;
%----------------------------------------------------------------------
disp(strcat('Computing step ...',S(in).name))
fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
T_1st = info.Groups(1).Name;
E_1st = info.Groups(17).Name;
B_1st = info.Groups(18).Name;
J_1st = info.Groups(19).Name;
V_1st = info.Groups(25).Name;
n_1st = info.Groups(23).Name;

%--------------------------------------------------------------------------
grid_dt = info.Groups(24).Attributes;
dt=double(grid_dt(15).Value);
time = double(grid_dt(13).Value);

%grid_ng = info.Groups(21).Attributes;
%grid_length = info.Groups(21).Attributes;

Nx= 296; % size of the input data
Ny= 296; 
Nz= 1024; 

Lx=18; Ly=18; Lz=63; 

dx=double(Lx)/double(Nx); % resolusion of the input data
dy=double(Ly)/double(Ny);
dz=double(Lz)/double(Nz); 
%--------------------------------------------------------------------------

% read the data
Bx=h5read(fileID,strcat(B_1st,'/hx/p0/3d'));
By=h5read(fileID,strcat(B_1st,'/hy/p0/3d'));
Bz=h5read(fileID,strcat(B_1st,'/hz/p0/3d'));

% Now extract the subset
%--------------------------------------------------------------------------
Lpx=18; Lpy=18; Lpz=40; 

Nxp=floor(Nx*Lpx/Lx); % number of points to extract the subset
Nyp=floor(Ny*Lpy/Ly);
Nzp=floor(Nz*Lpz/Lz);

Bx = Bx(:,:,1:Nzp);
By = By(:,:,1:Nzp);
Bz = Bz(:,:,1:Nzp);

x_o = linspace(0,Lx,Nx); % 1d-arrays to define the subsed grid
y_o = linspace(0,Ly,Ny);
z_o = linspace(0,Lz,Nz);

[Y0,X0,Z0] = meshgrid(y_o,x_o,z_o); %downsampled grid

% Normalize to the maximum value of |B|
Bmag = sqrt(Bx.^2 + By.^2 + Bz.^2);
Bmag_max = max(max(max(Bmag)));

Bx=Bx./Bmag_max;
By=By./Bmag_max;
Bz=Bz./Bmag_max;
%--------------------------------------------------------------------------

% Downsample the data
%--------------------------------------------------------------------------
nx=18; ny=18; nz=400; % number of cells for the downsampled output 

Bx_d = imresize3(Bx,[nx ny nz]);
By_d = imresize3(By,[nx ny nz]);
Bz_d = imresize3(Bz,[nx ny nz]);

x_d = linspace(0,Lpx,nx); % 1d-arrays to define the downsampled grid
y_d = linspace(0,Lpy,ny);
z_d = linspace(0,Lpz,nz);

dx_d = Lpx/nx;
dy_d = Lpy/ny;
dz_d = Lpz/nx;

[Yd,Xd,Zd] = meshgrid(y_d,x_d,z_d); % downsampled grid
%--------------------------------------------------------------------------


% Plots to check
%--------------------------------------------------------------------------
f1=figure(1);
h1=subplot(2,1,1);
dum_p=squeeze(Bx(:,:,1));%/max(max(abs(inte_Ax_i)));
hc = pcolor(dum_p);
hold on
set(hc,'edgecolor','none')
title('Bx')
colorbar
hold off
h2=subplot(2,1,2);
dum_p=squeeze(Bx_d(:,:,1));%/max(max(abs(inte_Ax_i)));
hc = pcolor(dum_p);
hold on
set(hc,'edgecolor','none')
title('Bxd')
colorbar
hold off
%--------------------------------------------------------------------------

% Now lets safe the data in the right format

%add the path so matlab recognise the existence of xdmfwrite and create the
%h5 file
%--------------------------------------------------------------------------
addpath '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here'
%--------------------------------------------------------------------------
filename_o='B_field_original';
filenameh5_o = 'B_field_original.h5';

filename_d='B_field_downsampled';
filenameh5_d = 'B_field_downsampled.h5';
%--------------------------------------------------------------------------

Bxh5_o = permute(Bx,[2,1,3]);
Byh5_o = permute(By,[2,1,3]);
Bzh5_o = permute(Bz,[2,1,3]);

Bxh5_d = permute(Bx_d,[2,1,3]);
Byh5_d = permute(By_d,[2,1,3]);
Bzh5_d = permute(Bz_d,[2,1,3]);

% Plots to check
%--------------------------------------------------------------------------
f2=figure(2);
h1=subplot(2,1,1);
dum_p=squeeze(Bxh5_o(:,:,1));%/max(max(abs(inte_Ax_i)));
hc = pcolor(dum_p);
hold on
set(hc,'edgecolor','none')
title('Bx')
colorbar
hold off
h2=subplot(2,1,2);
dum_p=squeeze(Bxh5_d(:,:,1));%/max(max(abs(inte_Ax_i)));
hc = pcolor(dum_p);
hold on
set(hc,'edgecolor','none')
title('Bxd')
colorbar
hold off
%--------------------------------------------------------------------------

ssA_o=size(permute(Bx,[2,1,3]));
ssA_d=size(permute(Bx_d,[2,1,3]));

% origin and resolution to store the data
OXYZ_o = [x_o(1);y_o(1);z_o(1)];
DXDYDZ_o =[dx;dy;dz];

% origin and resolution to store the data
OXYZ_d = [x_d(1);y_d(1);z_d(1)];
DXDYDZ_d =[dx_d;dy_d;dz_d];
%--------------------------------------------------------------------------

% create and write the xdmf file
%--------------------------------------------------------------------------
% create
h5create(filenameh5_o,'/Bx',ssA_o)
h5create(filenameh5_o,'/By',ssA_o)
h5create(filenameh5_o,'/Bz',ssA_o)

h5create(filenameh5_d,'/Bx',ssA_d)
h5create(filenameh5_d,'/By',ssA_d)
h5create(filenameh5_d,'/Bz',ssA_d)

% Write the h5 data file
h5write(filenameh5_o, '/Bx', Bxh5_o)
h5write(filenameh5_o, '/By', Byh5_o)
h5write(filenameh5_o, '/Bz', Bzh5_o)

h5write(filenameh5_d, '/Bx', Bxh5_d)
h5write(filenameh5_d, '/By', Byh5_d)
h5write(filenameh5_d, '/Bz', Bzh5_d)
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
xdmfwrite(filenameh5_o,ssA_o,OXYZ_o,DXDYDZ_o,'double');
xdmfwrite(filenameh5_d,ssA_d,OXYZ_d,DXDYDZ_d,'double');
%--------------------------------------------------------------------------