% Aiming to get the 2D frequency and wavenumber plots to see the type of
% waves and fluctuations that are presnt in the simulations 

% %--------------------------------------------------------------------------
% %--------------------------------------------------------------------------
path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1';

path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';

%-----------------------------------------------------------------------------------------------------------------------
% For the scripts
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
%-----------------------------------------------------------------------------------------------------------------------

% Normalization parameters
%--------------------------------------------------------------------------
B0=0.2;
n0=1;
Vai=0.2;%0.2;
Vae=0.2;%0.2;
E0=0.2;%0.2; %??
T0=0.02;%0.02;
J0=Vae;

mime =1.;
omega_pe_Omega_ce=5;

MFT0=1; % is this simply one in this normalization
c=1; VA2c = 0.2;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
cd(path)
S = dir(fullfile(path,'pfd.*.h5'));
N=numel(S); % number of files to use
H=zeros(N);
in=6;

%for in=1:N
%----------------------------------------------------------------------
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

dt=double(grid_dt(15).Value);
str = string(S(in).name);
newStr = extractBetween(str,"pfd.","_p000000.h5");
N_steps = str2double(newStr);
time_t = dt*N_steps;
time_t_2_Omega = time_t./omega_pe_Omega_ce;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));

sli_x=1;

Bx = squeeze(Bx(sli_x,:,:));
By = squeeze(By(sli_x,:,:));
Bz = squeeze(Bz(sli_x,:,:));

sss=size(Bx);
size_X=sss;
zll=linspace(-Lz,Lz,size_X(2));
yll=linspace(-Ly,Ly,size_X(1));

%[ZLL, YLL] = meshgrid(zll,yll);

ly=length(yll);
Ly_2_0 = ly/2;
Ly_2_1 = Ly_2_0 + 1*Ly_2_0/4;

[ZLL,YLL] = meshgrid(zll,yll);
dummy_f = YLL;
YLL_1 = dummy_f(Ly_2_0:Ly_2_1,:);
dummy_f = ZLL;
ZLL_1 = dummy_f(Ly_2_0:Ly_2_1,:);

% Divide the top part of the harris into 4 sectors
%----------------------------------------------------------------------
dummy_f = Bx;
Bx_1 = dummy_f(Ly_2_0:Ly_2_1,:); % from the x-line to the top
dummy_f = By;
By_1 = dummy_f(Ly_2_0:Ly_2_1,:); % from the x-line to the top
dummy_f = Bz;
Bz_1 = dummy_f(Ly_2_0:Ly_2_1,:); % from the x-line to the top
%----------------------------------------------------------------------

clearvars Bx By Bz


% Compute the FFT of the fields Bx_1, By_1; Bz_1;
%----------------------------------------------------------------------


%----------------------------------------------------------------------

