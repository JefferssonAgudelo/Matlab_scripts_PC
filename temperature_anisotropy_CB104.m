% This is to get the temperature anisotropy 

cd '/media/pfcy6/PSC_DiRAC_DATA/DATACB104/raw_data';
path = '/media/pfcy6/PSC_DiRAC_DATA/DATACB104/raw_data';

% useful parameters used in the simulation
%--------------------------------------------------------------------------
kb = 1.; mu0 =1.; mi_over_me_ =100.; vA_over_c_ = 0.1; B0_ = vA_over_c_;
mi = 1.; me = 1. / mi_over_me_; eps0=1.;
omega_pi=1;
Omega_e=vA_over_c_*sqrt(mi_over_me_)*omega_pi;
Omega_i=Omega_e / mi_over_me_;
TOmega_e=1/Omega_e; 
TOmega_i=1/Omega_i;
dt=0.06;
%------------------------------------------------------------------
%vectors as 1 arrow 3 columns
%mi=1;
mime=100;
%me=mi/mime;
qi=1;
qe=-1;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
S = dir(fullfile(path,'*.h5'));
N=numel(S); % number of files to use <---------------- This is the N 
H=zeros(N);
%in=30;
%i=2;
%--------------------------------------------------------------------------

% To save some variables in a file for all the times. Uncomment this when
% running again the program to generate the data
%--------------------------------------------------------------------------
%
%T_energy_terms=cell(6,N);
%T_energy_terms_sub=cell(6,N);

%}
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
nx1=166;    nx2=333;
ny1=232;    ny2=400;
nz1=1200;   nz2=1367;

%px2 = 400; py2 = 400; pz2 = 168; For the no reference change
px2 = 168; py2 = 168; pz2 = 168;
start = [nx1 ny1 nz1];
count = [px2 py2 pz2];
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
resx=0.06; %0.06081
resy=0.06;
resz=0.06; %0.06152

Lx=px2*resx; k0x=1/Lx;
Ly=px2*resy; k0y=1/Ly;
Lz=px2*resz; k0z=1/Lz;
k00=sqrt(k0x*k0x + k0y*k0y + k0z*k0z);
%--------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


in=19;


%for in=1:N
%--------------------------------------------------------------------------
disp(strcat('Computing step ...',S(in).name))
%--------------------------------------------------------------------------
%N_steps = 2000;
%time_t = dt*N_steps; %(In terms of 1/omega_pi)
str = string(S(in).name);
newStr = extractBetween(str,"pfd.","_p000000.h5");
N_steps = str2double(newStr);
time_t = dt*N_steps;
%--------------------------------------------------------------------------

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

% Including the normalization of the quantities before hand 
%--------------------------------------------------------------------------
c=1;
VA2c = 1.;%0.1;
B0 = 1.;%VA2c;
E0 = 1.;%B0*VA2c;
Pi0 = 1.;%mi*VA2c*VA2c;
Pe0 = 1.;%me*VA2c*VA2c;
%--------------------------------------------------------------------------

% This is over the subdomain!
%------------------------------------------------------------------
%
%Magnetic energy density
B{1,1} =h5read(fileID,strcat(B_1st,'/hx/p0/3d'),start,count)./B0; %Bx=Bx(nx1:nx2,ny1:ny2,nz1:nz2);
B{1,2} =h5read(fileID,strcat(B_1st,'/hy/p0/3d'),start,count)./B0; %By=By(nx1:nx2,ny1:ny2,nz1:nz2);
B{1,3} =h5read(fileID,strcat(B_1st,'/hz/p0/3d'),start,count)./B0; %Bz=Bz(nx1:nx2,ny1:ny2,nz1:nz2);

%To compute the rotation matrix cellwise 
%----------------------------------------------------------------------
% Define the initial coordinates
xx = [1; 0; 0]; % Example x-coordinate
yy = [0; 1; 0]; % Example y-coordinate
zz = [0; 0; 1]; % Example z-coordinate

% Define the magnetic field vector
%B_in = [B{1,1}; B{1,2}; B{1,3}]; % Example magnetic field vector
B_norm = sqrt( B{1,1}.^2 + B{1,2}.^2 + B{1,3}.^2 ) ; %cell by cell 

% Normalize the magnetic field vector
B_norm_in_x = B{1,1} ./ B_norm;
B_norm_in_y = B{1,2} ./ B_norm;
B_norm_in_z = B{1,3} ./ B_norm;

% Calculate the rotation axis. cross product B_norm with x-axis
R_1 = zeros(size(B{1,1}));
R_2 = B_norm_in_z;
R_3 = -B_norm_in_y;

% Calculate the rotation angle
theta_in = acos(B_norm_in_x); % Dot product with x-axis

% Create the rotation matrix
%K_in = [0 -R_3 R_2; R_3 0 -R_1; -R_2 R_1 0]; % Skew-symmetric matrix

I_in = cell(3,3);
K_in = cell(3,3);
KK_in = cell(3,3);
R_matrix_in = cell(3,3);

I_in{1,1} = ones(size(R_1));
I_in{1,2} = zeros(size(R_1));
I_in{1,3} = zeros(size(R_1));

I_in{2,1} = zeros(size(R_1));
I_in{2,2} = ones(size(R_1));
I_in{2,3} = zeros(size(R_1));

I_in{3,1} = zeros(size(R_1));
I_in{3,2} = zeros(size(R_1));
I_in{3,3} = ones(size(R_1));

K_in{1,1} = zeros(size(R_1));
K_in{1,2} = -R_3;
K_in{1,3} = R_2;

K_in{2,1} = R_3;
K_in{2,2} = zeros(size(R_1));
K_in{2,3} = -R_1;

K_in{3,1} = -R_2;
K_in{3,2} = R_1;
K_in{3,3} = zeros(size(R_1));

KK_in{1,1} = -(R_3.^2 + R_2.^2);
KK_in{1,2} = R_2.*R_1;
KK_in{1,3} = R_3.*R_1;

KK_in{2,1} = KK_in{1,2};
KK_in{2,2} = -(R_1.^2 + R_3.^2);
KK_in{2,3}  = R_3.*R_3;

KK_in{3,1} = KK_in{1,3};
KK_in{3,2} = KK_in{2,3};
KK_in{3,3} = -(R_1.^2 + R_2.^2);

for i=1:3
    for j=1:3
        %R_matrix_in = eye(3) + sin(theta_in) * K_in + (1 - cos(theta_in)) * K_in^2; % Rodrigues' rotation formula
        R_matrix_in{i,j} = I_in{i,j} + sin(theta_in) .* K_in{1,j} + (1 - cos(theta_in)) .* KK_in{i,j}; % Rodrigues' rotation formula
    end
end

%compute the inverse 
% Calculate the determinant of R
detR_matrix_in = R_matrix_in{1,1}.*(R_matrix_in{2,2}.*R_matrix_in{3,3} - R_matrix_in{2,3}.*R_matrix_in{3,2}) ...
- R_matrix_in{1,2}.*(R_matrix_in{2,1}.*R_matrix_in{3,3} - R_matrix_in{2,3}.*R_matrix_in{3,1}) ...
+ R_matrix_in{1,3}.*(R_matrix_in{2,1}.*R_matrix_in{3,2} - R_matrix_in{2,2}.*R_matrix_in{3,1});

Cof = cell(3,3);
% Compute the cofactor matrix
Cof{1,1} = R_matrix_in{2,2}.*R_matrix_in{3,3} - R_matrix_in{2,3}.*R_matrix_in{3,2};
Cof{1,2} = -(R_matrix_in{2,1}.*R_matrix_in{3,3} - R_matrix_in{2,3}.*R_matrix_in{3,1});
Cof{1,3} = R_matrix_in{2,1}.*R_matrix_in{3,2} - R_matrix_in{2,2}.*R_matrix_in{3,1};
Cof{2,1} = -(R_matrix_in{1,2}.*R_matrix_in{3,3} - R_matrix_in{1,3}.*R_matrix_in{3,2});
Cof{2,2} = R_matrix_in{1,1}.*R_matrix_in{3,3} - R_matrix_in{1,3}.*R_matrix_in{3,1};
Cof{2,3} = -(R_matrix_in{1,1}.*R_matrix_in{3,2} - R_matrix_in{1,2}.*R_matrix_in{3,1});
Cof{3,1} = R_matrix_in{1,2}.*R_matrix_in{2,3} - R_matrix_in{1,3}.*R_matrix_in{2,2};
Cof{3,2} = -(R_matrix_in{1,1}.*R_matrix_in{2,3} - R_matrix_in{1,3}.*R_matrix_in{2,1});
Cof{3,3} = R_matrix_in{1,1}.*R_matrix_in{2,2} - R_matrix_in{1,2}.*R_matrix_in{2,1};

% Compute the adjugate matrix (transpose of the cofactor matrix)
adjR = Cof';

clearvars Cof

% Compute the inverse matrix
%R_inv = (1 / detR_matrix_in) * adjR;
R_matrix_in_inv =cell(3,3);

for i=1:3
    for j=1:3
        R_matrix_in_inv{i,j} =  (1 ./ detR_matrix_in) .* adjR{i,j};
    end
end

% Perform the coordinate transformation ???
%%transformed_coords_in = R_matrix_in * [xx'; yy'; zz'];

% Extract the transformed coordinates
%%x_prime_in = transformed_coords_in(1, :)';
%%y_prime_in = transformed_coords_in(2, :)';
%%z_prime_in = transformed_coords_in(3, :)';

% Express the vector in the new reference frame
Bx_Rot = R_matrix_in_inv{1,1}.*B{1,1} + R_matrix_in_inv{1,2}.*B{1,2} + R_matrix_in_inv{1,3}.*B{1,3} ;
By_Rot = R_matrix_in_inv{2,1}.*B{1,1} + R_matrix_in_inv{2,2}.*B{1,2} + R_matrix_in_inv{2,3}.*B{1,3} ;
Bz_Rot = R_matrix_in_inv{3,1}.*B{1,1} + R_matrix_in_inv{3,2}.*B{1,2} + R_matrix_in_inv{3,3}.*B{1,3} ;

f10 = figure(10);
%subplot(2,2,1)
%dum = By_Rot;
dum = B{1,2};
dump = dum(:,:,2);
dum_max = max(max(abs(dump)));
hc = pcolor(dump);
set(hc,'edgecolor','none')
%clim([-dum_max, dum_max]);
caxis_limits = clim;
colorbar

[N,edges] = histcounts(Bz_Rot,80);
f11 = figure(11);
scatter(edges(1,2:end), N(1,:))

min(N)

% I don't know if the rotation is working or not. The rotated B field is
% zero everywhere. why??? is that correct???



%Clear everything about the calculation of the rotation matrix but the toration to release space
clearvars K_in KK_in I_in R_1 R_2 R_3 B_nor* theta*;

% Now computing the electron temperature
%--------------------------------------------------------------------------
%Kinetic energy density electrons
ve{1,1} =h5read(fileID,strcat(V_1st,'/vx_e/p0/3d'),start,count)./VA2c; %vex=vex(nx1:nx2,ny1:ny2,nz1:nz2);
ve{1,2} =h5read(fileID,strcat(V_1st,'/vy_e/p0/3d'),start,count)./VA2c; %vey=vey(nx1:nx2,ny1:ny2,nz1:nz2);
ve{1,3} =h5read(fileID,strcat(V_1st,'/vz_e/p0/3d'),start,count)./VA2c; %vez=vez(nx1:nx2,ny1:ny2,nz1:nz2);
ne{1,1} = h5read(fileID,strcat(n_1st,'/n_e/p0/3d'),start,count); %ne=ne(nx1:nx2,ny1:ny2,nz1:nz2);

%Kinetic energy density electrons
Pij_e{1,1} =h5read(fileID,strcat(T_1st,'/Txx_e/p0/3d'),start,count)./Pe0; %Pxxe=Pxxe(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_e{1,2} =h5read(fileID,strcat(T_1st,'/Txy_e/p0/3d'),start,count)./Pe0; %Pxye=Pxye(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_e{1,3} =h5read(fileID,strcat(T_1st,'/Txz_e/p0/3d'),start,count)./Pe0; %Pxze=Pxze(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_e{2,2} =h5read(fileID,strcat(T_1st,'/Tyy_e/p0/3d'),start,count)./Pe0; %Pyye=Pyye(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_e{2,3} =h5read(fileID,strcat(T_1st,'/Tyz_e/p0/3d'),start,count)./Pe0; %Pyze=Pyze(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_e{3,3} =h5read(fileID,strcat(T_1st,'/Tzz_e/p0/3d'),start,count)./Pe0; %Pzze=Pzze(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_e{2,1} = Pij_e{1,2};
Pij_e{3,1} = Pij_e{1,3};
Pij_e{3,2} = Pij_e{2,3};

PPij_e=cell(3,3);

for i=1:3
    for j=1:3
        PPij_e{i,j} = Pij_e{i,j} - 1.*ne{1,1}.*mi.*ve{1,i}.*ve{1,j};
    end
end

%clearvars Pij_e;
%Pij_e = PPij_e;

clearvars ve

% Now compute the transformation of the tensor

Pij_e_Rot = cell(3,3);
PPij_e_Rot = cell(3,3);

for i=1:3
    for j=1:3
        Pij_e_Rot{i,j} = R_matrix_in{i,j} .*Pij_e{i,j} .* R_matrix_in_inv{i,j};
        PPij_e_Rot{i,j} = R_matrix_in{i,j} .*PPij_e{i,j} .* R_matrix_in_inv{i,j};
    end
end


f1 = figure(1);

subplot(2,2,1)

dum = Pij_e{2,2};
dump = dum(:,:,2);
dum_max = max(max(abs(dump)));
hc = pcolor(dump);
set(hc,'edgecolor','none')
clim([-dum_max, dum_max]);
caxis_limits = clim;
colorbar

subplot(2,2,2)
dum = PPij_e{2,2};
dump = dum(:,:,2);
%dum_max = max(max(abs(dump)));
hc = pcolor(dump);
set(hc,'edgecolor','none')
clim([-dum_max, dum_max]);
caxis_limits = clim;
colorbar

subplot(2,2,3)
dum = Pij_e_Rot{2,2};
dump = dum(:,:,2);
%dum_max = max(max(abs(dump)));
hc = pcolor(dump);
set(hc,'edgecolor','none')
caxis_limits = clim;
clim([-dum_max, dum_max]);
colorbar

subplot(2,2,4)
dum = PPij_e_Rot{2,2};
dump = dum(:,:,2);
%dum_max = max(max(abs(dump)));
hc = pcolor(dump);
set(hc,'edgecolor','none')
caxis_limits = clim;
clim([-dum_max, dum_max]);
colorbar




f2 = figure(2);

subplot(2,2,1)

dum = Pij_e{1,1} + Pij_e{2,2} + Pij_e{3,3};
dump = dum(:,:,2);
dum_max = max(max(abs(dump)));
hc = pcolor(dump);
set(hc,'edgecolor','none')
clim([-dum_max, dum_max]);
caxis_limits = clim;
colorbar

subplot(2,2,2)
dum = PPij_e{1,1} + PPij_e{2,2} + PPij_e{3,3};
dump = dum(:,:,2);
%dum_max = max(max(abs(dump)));
hc = pcolor(dump);
set(hc,'edgecolor','none')
clim([-dum_max, dum_max]);
caxis_limits = clim;
colorbar

subplot(2,2,3)
dum = Pij_e_Rot{1,1} + Pij_e_Rot{2,2} + Pij_e_Rot{3,3};
dump = dum(:,:,2);
%dum_max = max(max(abs(dump)));
hc = pcolor(dump);
set(hc,'edgecolor','none')
caxis_limits = clim;
clim([-dum_max, dum_max]);
colorbar

subplot(2,2,4)
dum = PPij_e_Rot{1,1} + PPij_e_Rot{2,2} + PPij_e_Rot{3,3};
dump = dum(:,:,2);
%dum_max = max(max(abs(dump)));
hc = pcolor(dump);
set(hc,'edgecolor','none')
caxis_limits = clim;
clim([-dum_max, dum_max]);
colorbar
%--------------------------------------------------------------------------









%Kinetic energy density ions
vi{1,1} =h5read(fileID,strcat(V_1st,'/vx_i/p0/3d'),start,count)./VA2c; %vix=vix(nx1:nx2,ny1:ny2,nz1:nz2);
vi{1,2} =h5read(fileID,strcat(V_1st,'/vy_i/p0/3d'),start,count)./VA2c; %viy=viy(nx1:nx2,ny1:ny2,nz1:nz2);
vi{1,3} =h5read(fileID,strcat(V_1st,'/vz_i/p0/3d'),start,count)./VA2c; %viz=viz(nx1:nx2,ny1:ny2,nz1:nz2);
ni{1,1} = h5read(fileID,strcat(n_1st,'/n_i/p0/3d'),start,count); %ni=ni(nx1:nx2,ny1:ny2,nz1:nz2);

%Thermal energy density ions
Pij_i{1,1} =h5read(fileID,strcat(T_1st,'/Txx_i/p0/3d'),start,count)./Pi0; %Pxxi=Pxxi(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_i{1,2} =h5read(fileID,strcat(T_1st,'/Txy_i/p0/3d'),start,count)./Pi0; %Pxyi=Pxyi(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_i{1,3} =h5read(fileID,strcat(T_1st,'/Txz_i/p0/3d'),start,count)./Pi0; %Pxzi=Pxzi(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_i{2,2} =h5read(fileID,strcat(T_1st,'/Tyy_i/p0/3d'),start,count)./Pi0; %Pyyi=Pyyi(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_i{2,3} =h5read(fileID,strcat(T_1st,'/Tyz_i/p0/3d'),start,count)./Pi0; %Pyzi=Pyzi(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_i{3,3} =h5read(fileID,strcat(T_1st,'/Tzz_i/p0/3d'),start,count)./Pi0; %Pzzi=Pzzi(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_i{2,1} = Pij_i{1,2};
Pij_i{3,1} = Pij_i{1,3};
Pij_i{3,2} = Pij_i{2,3};

PPij_i=cell(3,3);

for i=1:3
    for j=1:3
        PPij_i{i,j} = Pij_i{i,j} - 1.*ni{1,1}.*mi.*vi{1,i}.*vi{1,j};
    end
end




%
% %Kinetic energy density ions
% vi{1,1} =h5read(fileID,strcat(V_1st,'/vx_i/p0/3d'))./VA2c; %vix=vix(nx1:nx2,ny1:ny2,nz1:nz2);
% vi{1,2} =h5read(fileID,strcat(V_1st,'/vy_i/p0/3d'))./VA2c; %viy=viy(nx1:nx2,ny1:ny2,nz1:nz2);
% vi{1,3} =h5read(fileID,strcat(V_1st,'/vz_i/p0/3d'))./VA2c; %viz=viz(nx1:nx2,ny1:ny2,nz1:nz2);
% ni{1,1} = h5read(fileID,strcat(n_1st,'/n_i/p0/3d')); %ni=ni(nx1:nx2,ny1:ny2,nz1:nz2);
% 
% %Thermal energy density ions
% Pij_i{1,1} =h5read(fileID,strcat(T_1st,'/Txx_i/p0/3d'))./Pi0; %Pxxi=Pxxi(nx1:nx2,ny1:ny2,nz1:nz2);
% Pij_i{1,2} =h5read(fileID,strcat(T_1st,'/Txy_i/p0/3d'))./Pi0; %Pxyi=Pxyi(nx1:nx2,ny1:ny2,nz1:nz2);
% Pij_i{1,3} =h5read(fileID,strcat(T_1st,'/Txz_i/p0/3d'))./Pi0; %Pxzi=Pxzi(nx1:nx2,ny1:ny2,nz1:nz2);
% Pij_i{2,2} =h5read(fileID,strcat(T_1st,'/Tyy_i/p0/3d'))./Pi0; %Pyyi=Pyyi(nx1:nx2,ny1:ny2,nz1:nz2);
% Pij_i{2,3} =h5read(fileID,strcat(T_1st,'/Tyz_i/p0/3d'))./Pi0; %Pyzi=Pyzi(nx1:nx2,ny1:ny2,nz1:nz2);
% Pij_i{3,3} =h5read(fileID,strcat(T_1st,'/Tzz_i/p0/3d'))./Pi0; %Pzzi=Pzzi(nx1:nx2,ny1:ny2,nz1:nz2);
% 
% PPij_i=cell(3,3);
% 
% for i=1:3
%     for j=1:3
%         PPij_i{i,j} = Pij_i{i,j} - 1.*ni{1,1}.*mi.*vi{1,i}.*vi{1,j};
%     end
% end

% This is just to rename the variable
% Pij_i = PPij_i;

%
% %Kinetic energy density electrons
% ve{1,1} =h5read(fileID,strcat(V_1st,'/vx_e/p0/3d'))./VA2c; %vex=vex(nx1:nx2,ny1:ny2,nz1:nz2);
% ve{1,2} =h5read(fileID,strcat(V_1st,'/vy_e/p0/3d'))./VA2c; %vey=vey(nx1:nx2,ny1:ny2,nz1:nz2);
% ve{1,3} =h5read(fileID,strcat(V_1st,'/vz_e/p0/3d'))./VA2c; %vez=vez(nx1:nx2,ny1:ny2,nz1:nz2);
% ne{1,1} = h5read(fileID,strcat(n_1st,'/n_e/p0/3d')); %ne=ne(nx1:nx2,ny1:ny2,nz1:nz2);
% 
% %Kinetic energy density electrons
% Pij_e{1,1} =h5read(fileID,strcat(T_1st,'/Txx_e/p0/3d'))./Pe0; %Pxxe=Pxxe(nx1:nx2,ny1:ny2,nz1:nz2);
% Pij_e{1,2} =h5read(fileID,strcat(T_1st,'/Txy_e/p0/3d'))./Pe0; %Pxye=Pxye(nx1:nx2,ny1:ny2,nz1:nz2);
% Pij_e{1,3} =h5read(fileID,strcat(T_1st,'/Txz_e/p0/3d'))./Pe0; %Pxze=Pxze(nx1:nx2,ny1:ny2,nz1:nz2);
% Pij_e{2,2} =h5read(fileID,strcat(T_1st,'/Tyy_e/p0/3d'))./Pe0; %Pyye=Pyye(nx1:nx2,ny1:ny2,nz1:nz2);
% Pij_e{2,3} =h5read(fileID,strcat(T_1st,'/Tyz_e/p0/3d'))./Pe0; %Pyze=Pyze(nx1:nx2,ny1:ny2,nz1:nz2);
% Pij_e{3,3} =h5read(fileID,strcat(T_1st,'/Tzz_e/p0/3d'))./Pe0; %Pzze=Pzze(nx1:nx2,ny1:ny2,nz1:nz2);
%}
%-------------------------------------------------------------------------------------------





%}
%-------------------------------------------------------------------------------------------


%------------------------------------------------------------------
end

% These are the data of the enerdy density integrated over the full box 
load('/Volumes/PSC_DiRAC_DATA/Energy_Budget_things/energy_densities_time.mat')


% These are the data of the enerdy density integrated over the subdomain box 
load('/Volumes/PSC_DiRAC_DATA/Energy_Budget_things/energy_densities_time_sub.mat')

%--------------------------------------------------------------------------
% get the data in a table to use that syntaxis 
%T_energy_terms_table = cell2table(T_energy_terms');
%--------------------------------------------------------------------------
% get the data in a array to use that syntaxis 
T_energy_terms_table = cell2mat(T_energy_terms');
ene_BE = T_energy_terms_table(:,1) + T_energy_terms_table(:,2); %electromagnetic energy
ene_kin_i =T_energy_terms_table(:,3);
ene_kin_e =T_energy_terms_table(:,4);
ene_the_i =T_energy_terms_table(:,5)-ene_kin_i;
ene_the_e =T_energy_terms_table(:,6)-ene_kin_e;
ene_total = ene_BE + ene_kin_i + ene_kin_e + ene_the_i + ene_the_e;

T_energy_terms_table_sub = cell2mat(T_energy_terms_sub');
ene_BE_sub = T_energy_terms_table_sub(:,1) + T_energy_terms_table_sub(:,2); %electromagnetic energy
ene_kin_i_sub =T_energy_terms_table_sub(:,3);
ene_kin_e_sub =T_energy_terms_table_sub(:,4);
ene_the_i_sub =T_energy_terms_table_sub(:,5)-ene_kin_i_sub;
ene_the_e_sub =T_energy_terms_table_sub(:,6)-ene_kin_e_sub;
ene_total_sub = ene_BE_sub + ene_kin_i_sub + ene_kin_e_sub + ene_the_i_sub + ene_the_e_sub;
%--------------------------------------------------------------------------

%
cd '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here'
load('colorblind_colormap.mat');
%--------------------------------------------------------------------------

%Create the time array
time_line=zeros(1,N);
dt = 0.06;
for in=2:N-1
str = string(S(in).name);
newStr = extractBetween(str,"pfd.","_p000000.h5");
N_steps = str2double(newStr); time_t = dt*N_steps;
time_line(1,in) = time_t; 
end

time = time_line';

c=1;
VA2c = 0.1;
B0 = VA2c;
E0 = B0*VA2c;
Pi0 = mi*VA2c*VA2c;
Pe0 = me*VA2c*VA2c;
% energies
VA2c1=400*400*2016*Pi0;
VA2c2=168*168*168*Pi0;
%--------------------------------------------------------------------------
%
lw = 3;
fs=25;
f214 = figure(214);
plot(time(1:end-1),ene_BE(1:end-1)./VA2c1,'Color',colorblind(1,:), 'LineWidth', lw)
hold on
plot(time(1:end-1),ene_kin_i(1:end-1)/VA2c1,'Color',colorblind(2,:), 'LineWidth', lw)
plot(time(1:end-1),ene_kin_e(1:end-1)/VA2c1,'Color',colorblind(6,:), 'LineWidth', lw)
plot(time(1:end-1),ene_the_i(1:end-1)/VA2c1,'Color',colorblind(7,:), 'LineWidth', lw)
plot(time(1:end-1),ene_the_e(1:end-1)/VA2c1,'Color',colorblind(5,:), 'LineWidth', lw)
plot(time(1:end-1),ene_total(1:end-1)/VA2c1,'Color',colorblind(8,:), 'LineWidth', lw)
legend('$\varepsilon^{em}$','$\varepsilon^{k}_{i}$','$\varepsilon^{k}_{e}$',...
    '$\varepsilon^{th}_{i}$','$\varepsilon^{th}_{e}$','$\varepsilon^{T}$','Interpreter','latex','FontSize',fs)
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('$\frac{\langle \varepsilon \rangle}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs)
xlim([24,456])
%ylim([-1.9, 1.9])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off


f215 = figure(215);
semilogy(time(1:end-1),ene_BE(1:end-1)./VA2c1,'Color',colorblind(1,:), 'LineWidth', lw)
hold on
semilogy(time(1:end-1),ene_kin_i(1:end-1)/VA2c1,'Color',colorblind(2,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_kin_e(1:end-1)/VA2c1,'Color',colorblind(6,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_the_i(1:end-1)/VA2c1,'Color',colorblind(7,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_the_e(1:end-1)/VA2c1,'Color',colorblind(5,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_total(1:end-1)/VA2c1,'Color',colorblind(8,:), 'LineWidth', lw)
legend('$\varepsilon^{em}$','$\varepsilon^{k}_{i}$','$\varepsilon^{k}_{e}$',...
    '$\varepsilon^{th}_{i}$','$\varepsilon^{th}_{e}$','$\varepsilon^{T}$','Interpreter','latex','FontSize',fs)
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('$\frac{\langle \varepsilon \rangle}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs)
xlim([24,456])
%ylim([-1.9, 1.9])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off


% This includes both, total and sub-domain integrated
%--------------------------------------------------------------------------

f2141 = figure(2141);
plot(time(1:end-1),ene_BE(1:end-1)./VA2c1,'Color',colorblind(1,:), 'LineWidth', lw)
hold on
plot(time(1:end-1),ene_kin_i(1:end-1)/VA2c1,'Color',colorblind(2,:), 'LineWidth', lw)
plot(time(1:end-1),ene_kin_e(1:end-1)/VA2c1,'Color',colorblind(6,:), 'LineWidth', lw)
plot(time(1:end-1),ene_the_i(1:end-1)/VA2c1,'Color',colorblind(7,:), 'LineWidth', lw)
plot(time(1:end-1),ene_the_e(1:end-1)/VA2c1,'Color',colorblind(5,:), 'LineWidth', lw)
plot(time(1:end-1),ene_total(1:end-1)/VA2c1,'Color',colorblind(8,:), 'LineWidth', lw)

plot(time(1:end-1),ene_BE_sub(1:end-1)./VA2c2,'--','Color',colorblind(1,:), 'LineWidth', lw)
plot(time(1:end-1),ene_kin_i_sub(1:end-1)/VA2c2,'--','Color',colorblind(2,:), 'LineWidth', lw)
plot(time(1:end-1),ene_kin_e_sub(1:end-1)/VA2c2,'--','Color',colorblind(6,:), 'LineWidth', lw)
plot(time(1:end-1),ene_the_i_sub(1:end-1)/VA2c2,'--','Color',colorblind(7,:), 'LineWidth', lw)
plot(time(1:end-1),ene_the_e_sub(1:end-1)/VA2c2,'--','Color',colorblind(5,:), 'LineWidth', lw)
plot(time(1:end-1),ene_total_sub(1:end-1)/VA2c2,'--','Color',colorblind(8,:), 'LineWidth', lw)
legend('$\varepsilon^{em}$','$\varepsilon^{k}_{i}$','$\varepsilon^{k}_{e}$',...
    '$\varepsilon^{th}_{i}$','$\varepsilon^{th}_{e}$','$\varepsilon^{T}$','Interpreter','latex','FontSize',fs)
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('$\frac{\langle \varepsilon \rangle}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs)
xlim([24,456])
%ylim([-1.9, 1.9])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off

f2151 = figure(2151);
semilogy(time(1:end-1),ene_BE(1:end-1)./VA2c1,'Color',colorblind(1,:), 'LineWidth', lw)
hold on
semilogy(time(1:end-1),ene_kin_i(1:end-1)/VA2c1,'Color',colorblind(2,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_kin_e(1:end-1)/VA2c1,'Color',colorblind(6,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_the_i(1:end-1)/VA2c1,'Color',colorblind(7,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_the_e(1:end-1)/VA2c1,'Color',colorblind(5,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_total(1:end-1)/VA2c1,'Color',colorblind(8,:), 'LineWidth', lw)

semilogy(time(1:end-1),ene_BE_sub(1:end-1)./VA2c2,'--','Color',colorblind(1,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_kin_i_sub(1:end-1)/VA2c2,'--','Color',colorblind(2,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_kin_e_sub(1:end-1)/VA2c2,'--','Color',colorblind(6,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_the_i_sub(1:end-1)/VA2c2,'--','Color',colorblind(7,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_the_e_sub(1:end-1)/VA2c2,'--','Color',colorblind(5,:), 'LineWidth', lw)
semilogy(time(1:end-1),ene_total_sub(1:end-1)/VA2c2,'--','Color',colorblind(8,:), 'LineWidth', lw)
legend('$\varepsilon^{em}$','$\varepsilon^{k}_{i}$','$\varepsilon^{k}_{e}$',...
    '$\varepsilon^{th}_{i}$','$\varepsilon^{th}_{e}$','$\varepsilon^{T}$','Interpreter','latex','FontSize',fs)
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('$\frac{\langle \varepsilon \rangle}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs)
xlim([24,456])
%ylim([-1.9, 1.9])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off
%--------------------------------------------------------------------------

%}
%--------------------------------------------------------------------------

cd '/Volumes/PSC_DiRAC_DATA/Energy_Budget_things'
saveas(f214,strcat('energy_time'+ string(N_steps) +'.png'));
saveas(f215,strcat('energy_time_semilogy'+ string(N_steps) +'.png'));
saveas(f2141,strcat('energy_time_full_sub_2_'+ string(N_steps) +'.png'));
saveas(f2151,strcat('energy_time_full_sub_semilogy_2_'+ string(N_steps) +'.png'));
cd '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here'