%This is for the localization study
%--------------------------------------------------------------------------
path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_many_Ax_large_L8di_dB01_Omc1_kLd1_local_3';
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
path_s = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


cd(path)

mime =1.;
omega_pe_Omega_ce=5;

S = dir(fullfile(path,'pfd.*.h5'));
N=numel(S); % number of files to use
%H=zeros(N);

% chose the particle file to work on.
i=2;

disp(strcat('Computing step ...',S(in).name))
fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;
%--------------------------------------------------------------------------
grid_dt = info.Groups(20).Attributes;
dt=double(grid_dt(15).Value);
grid_ng = info.Groups(19).Attributes;
dx=grid_ng(10).Value(1);
dy=grid_ng(10).Value(2);
dz=grid_ng(10).Value(3);
grid_length = info.Groups(17).Attributes;
Lx=grid_length(4).Value(1);% - grid_length(3).Value(1);
Ly=grid_length(4).Value(2);% - grid_length(3).Value(2);
Lz=grid_length(4).Value(3);% - grid_length(3).Value(3);
resx=double(Lx)/double(dx);
resy=double(Ly)/double(dy);
resz=double(Lz)/double(dz); res=resy;
threshold=pi/resy;
%--------------------------------------------------------------------------
Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));

sli_x = 1;
Bx = squeeze(Bx(sli_x,:,:));
By = squeeze(By(sli_x,:,:));
Bz = squeeze(Bz(sli_x,:,:));

sss=size(Bx);
size_X=sss;
zll=linspace(-Lz,Lz,size_X(2)); %Jeff flag it works with (1,size_x(2))
yll=linspace(-Ly,Ly,size_X(1));
[ZLL, YLL] = meshgrid(zll,yll);

ykk1 = -5; ykk2 = 5; zkk1=-10; zkk2=10; %  x

% x
cond_kk = (YLL>ykk1).*(YLL<ykk2).*(ZLL>zkk1).*(ZLL<zkk2);
Bx_x = Bx.*cond_kk; Bx_x(Bx_x==0)=NaN;
By_x = By.*cond_kk; By_x(By_x==0)=NaN;
Bz_x = Bz.*cond_kk; Bz_x(Bz_x==0)=NaN;

%----------------------------------------------------------------------

% Now lets compute the averages to get the parallel and perpendicular

% remove the NaNs
Bx_x(isnan(Bx_x)) = []; By_x(isnan(By_x)) = [];  Bz_x(isnan(Bz_x)) = [];
Bx_x_av = mean(Bx_x,'all'); By_x_av = mean(By_x,'all'); Bz_x_av = mean(Bz_x,'all');
B_x_m_av = sqrt(Bx_x_av.^2 + By_x_av.^2 + Bz_x_av.^2);

%----------------------------------------------------------------------
% Define the initial coordinates
xx = [1; 0; 0]; % Example x-coordinate
yy = [0; 1; 0]; % Example y-coordinate
zz = [0; 0; 1]; % Example z-coordinate

% this only uses the in vector and not the out. I need to repeat this
% because the magnetic field vector is different.
% Define the magnetic field vector

B_x = [Bx_x_av; By_x_av; Bz_x_av]; % Example magnetic field vector

% Normalize the magnetic field vector
B_normalized_x = B_x / norm(B_x);

% Calculate the rotation axis
R_x = cross(B_normalized_x, [1; 0; 0]); % Cross product with x-axis

% Calculate the rotation angle
theta_x = acos(dot(B_normalized_x, [1; 0; 0])); % Dot product with x-axis

% Create the rotation matrix
K_x = [0 -R_x(3) R_x(2); R_x(3) 0 -R_x(1); -R_x(2) R_x(1) 0]; % Skew-symmetric matrix
R_matrix_x = eye(3) + sin(theta_x) * K_x + (1 - cos(theta_x)) * K_x^2; % Rodrigues' rotation formula

% Perform the coordinate transformation
transformed_coords_x = R_matrix_x * [xx'; yy'; zz'];

% Extract the transformed coordinates
x_prime_x = transformed_coords_x(1, :)';
y_prime_x = transformed_coords_x(2, :)';
z_prime_x = transformed_coords_x(3, :)';

% Define the vector in the initial reference frame
v_initial_1 = [pxi_sub1, pyi_sub1, pzi_sub1]'; % Example vector in the initial reference frame

% Calculate the inverse of the rotation matrix
%R_inverse = inv(R_matrix_in); % Inverse of the rotation matrix A\b

% Express the vector in the new reference frame
v_new_1 = R_matrix_x \ v_initial_1;

v_new_par_1 = v_new_1(1,:);
v_new_per_1 = sqrt(v_new_1(2,:).^2 + v_new_1(3,:).^2);

    %----------------------------------------------------------------------