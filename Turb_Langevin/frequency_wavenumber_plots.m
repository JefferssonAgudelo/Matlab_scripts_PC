% Aiming to get the 2D frequency and wavenumber plots to see the type of
% waves and fluctuations that are presnt in the simulations 

% %--------------------------------------------------------------------------
% %--------------------------------------------------------------------------
path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1';

path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';

%-----------------------------------------------------------------------------------------------------------------------
% For the scripts
path_s_T  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Turb_Langevin';
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
Dx=grid_ng(10).Value(1);
Dy=grid_ng(10).Value(2);
Dz=grid_ng(10).Value(3);

grid_length = info.Groups(17).Attributes;
Lx0=grid_length(4).Value(1);% - grid_length(3).Value(1);
Ly0=grid_length(4).Value(2);% - grid_length(3).Value(2);
Lz0=grid_length(4).Value(3);% - grid_length(3).Value(3);

resx=double(Lx0)/double(Dx);
resy=double(Ly0)/double(Dy);
resz=double(Lz0)/double(Dz); res=resy;

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
zll=linspace(-Lz0,Lz0,size_X(2));
yll=linspace(-Ly0,Ly0,size_X(1));

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
%--------------------------------------------------------------------------
[ff_x,ky,kz] = Four3D(Bx_1,Ly0,Lz0);
[ff_y,ky,kz] = Four3D(By_1,Ly0,Lz0);
[ff_z,ky,kz] = Four3D(Bz_1,Ly0,Lz0);

ff=ff_x.^2+ff_y.^2+ff_z.^2;

N=size(Bx_1);
P3D=ff./(N(1)*N(2)); 

dy=resy;
dz=resz;

kp=ky;

%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
[kp2J, kpJ]=meshgrid(kz,ky);

P2D2=P3D/max(max(P3D));
fs=18;
%----------------------------------------------------------------------
f1=figure(1);
[C,h]=contourf(kz,ky,log10(P2D2),'LevelStep',0.2);
set(h,'LineColor','none')
lim = caxis;
caxis([-8 0]);
colormap(jet)
colorbar
set(gca,'XScale','log','YScale','log','FontSize',fs)
xlabel('$k_\| d_i$','Interpreter','latex')
ylabel('$k_\perp d_i$','Interpreter','latex')
hold on
ylim([2*pi/Ly threshold])
xlim([2*pi/Lz threshold])
xticks([0.1 1 10]); yticks([0.1 1 10])
xticklabels({'10^{-1}','10^{0}','10^{1}'}); yticklabels({'10^{-1}','10^{0}','10^{1}'})
yline(10,'--k','LineWidth',1);
xline(1,'--k','LineWidth',1);
title('$\log_{10}{P^{\mathbf{B}}_{2D}} \ ; \ t = \ $'+string(round((time_t/omega_pe_Omega_ce),2)) + ...
    '$$ \ \Omega_{ce}^{-1}$$','Interpreter','latex','FontSize',fs)
hold off

    

%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
function [ft,ky,kz]=Four3D(var,Ly,Lz)
    %Calculates 3D spatial Fourier transfrom of variable 'var', shifted so
    %that the centre is the zero k. xx/yy/zz are Lx, Ly and Lz.
    
    var=var-mean(mean(mean((var)))); %Detrend mean

    N=size(var); %N=[Nx,Ny,Nz]

    f=abs(fftn(var))*sqrt(N(1)*N(2)); %Take abs value and normalise
    %^Should it be fftn instead of ifftn?
    
    ft=fftshift(f); %Shift ft to centre wavenumber
    
    %Includes negative wavenumbers
    ky=((0:N(1)-1)-N(1)/2).*2*pi/Ly;
    kz=((0:N(2)-1)-N(2)/2).*2*pi/Lz;

end