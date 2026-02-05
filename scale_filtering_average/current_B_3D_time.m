% Just magnetic field and current

path = '/JAAR-DATA/CIRRUS_DATA_desktop/turb_alf_jeff_3D';

%path = '/Volumes/PSC_DiRAC_DATA/Data_Cirrus/turb_alf_cam_3D_small';
%----------------------------------path = '/home/UNN/pfcy6/DATA_CIRRUS/turb_alf_large_xz_dvdB';-------------------------------------------------------------------------------------

% For the scripts
%-----------------------------------------------------------------------------------------------------------------------
path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
%-----------------------------------------------------------------------------------------------------------------------

cd(path)
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
S = dir(fullfile(path,'pfd.*.h5'));
N=numel(S); % number of files to use
H=zeros(N);
%--------------------------------------------------------------------------
S2 = dir(fullfile(path,'pfd_moments.*.h5'));
N2=numel(S2); % number of files to use
H2=zeros(N2);
%--------------------------------------------------------------------------


in=1;

%--------------------------------------------------------------------------
mime = input ('mime value');
%B are normalized to the background magnetic field
%B0=0.2;
B0=0.1;
%n is normalise to the proton density n0=1
n0=1;
%Vi normalised to the proton alfven speed V_a=0.1c The alfven speed of
%electrons is Vae=10Vai
%--------------------------------------------------------------------------
nb_n0 =1;
kb = 1.; mu0 =1.; c=1; q = 1;
Vai=0.1;
Vae=0.1;%0.2;
Va=0.1;%0.2;
Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);
%mime =100.;
mi = mime;
me = 1; eps0=1.;
m = mi + me;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
omega_pe_Omega_ce=10;
omega_pi=1;
Omega_e=Vai*sqrt(mime)*omega_pi;
Omega_i=Omega_e / mime;
TOmega_e=1/Omega_e;
TOmega_i=1/Omega_i;
%--------------------------------------------------------------------------
in=1;
fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;
%%%
Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
By=squeeze(h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d')));
Bz=squeeze(h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d')));
Ns=size(squeeze(Bx));
grid_length = info.Groups(17).Attributes;
Lx=grid_length(4).Value(1) - grid_length(3).Value(1); %(This is in de The substraction give the total size of the domain) -Lx0 to Lx0
Ly=grid_length(4).Value(2) - grid_length(3).Value(2);
Lz=grid_length(4).Value(3) - grid_length(3).Value(3);
nx = Ns(1,1);
nz = Ns(1,2);
% Generate grid
xl = linspace(0, Lx, nx);
zl = linspace(0, Lz, nz);
xl_di = xl/sqrt(mime);
zl_di = zl/sqrt(mime);
[Z, X] = meshgrid(xl_di, zl_di);
B_mag = sqrt(Bx.^2 + Bz.^2 + (By-B0).^2);
Tau_nl = xl_di(end)*B0/(mean(B_mag,"all")*Vai_b);


d2D=input('Is it 2D (yes=1, no=0): ');
d3D=input('Is it 3D (yes=1, no=0): ');

%d2D = 1;
%d3D = 0;

B01 = 1;

% this hole block is to check the initial conditions and a brief time evolution 
% 
%--------------------------------------------------------------------------
% magnetic field 
%--------------------------------------------------------------------------
Bx_mean_t = zeros(1,N);
By_mean_t = zeros(1,N);
Bz_mean_t = zeros(1,N);
Bx_2_mean_t = zeros(1,N);
By_2_mean_t = zeros(1,N);
Bz_2_mean_t = zeros(1,N);

B_mag_mean_t = zeros(1,N);
B_2_mag_mean_t = zeros(1,N);
J_2_mag_mean_t = zeros(1,N);


for in=1:N
    fileID =  S(in).name; %change the 1 per i
    %h5disp(fileID);
    info = h5info(fileID);
    EHJ_1st = info.Groups(16).Name;
    %%%
    if (d2D == 1)

    Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
    Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));

    Bx = squeeze(Bx(:,1,:));
    By = squeeze(By(:,1,:));
    Bz = squeeze(Bz(:,1,:));

    %2D xz
    B_mag = sqrt(Bx.^2 + Bz.^2 + (By-B0).^2);
    B_2_mag = Bx.^2 + Bz.^2 + (By-B0).^2;

    B_mag_mean_t(1,in) = mean(B_mag,'all');
    B_2_mag_mean_t(1,in) = mean(B_2_mag,'all');

    Bx_mean_t(1,in) = mean(abs(Bx),'all');
    Bz_mean_t(1,in) = mean(abs(Bz),'all');
    By_mean_t(1,in) = mean(abs(By-B0),'all');

    Bx_2_mean_t(1,in) = mean(Bx.^2,'all');
    Bz_2_mean_t(1,in) = mean(Bz.^2,'all');
    By_2_mean_t(1,in) = mean((By-B0).^2,'all');
    
    elseif (d3D == 1)

    %3D
    Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
    Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));

    B_mag = sqrt(Bx.^2 + By.^2 + (Bz-B0).^2);
    B_2_mag = Bx.^2 + By.^2 + (Bz-B0).^2;

    B_mag_mean_t(1,in) = mean(B_mag,'all');
    B_2_mag_mean_t(1,in) = mean(B_2_mag,'all');

    Bx_mean_t(1,in) = mean(abs(Bx),'all');
    By_mean_t(1,in) = mean(abs(By),'all');
    Bz_mean_t(1,in) = mean(abs(Bz-B0),'all');

    Bx_2_mean_t(1,in) = mean(Bx.^2,'all');
    By_2_mean_t(1,in) = mean(By.^2,'all');
    Bz_2_mean_t(1,in) = mean((Bz-B0).^2,'all');
    end


    Jx=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'));
    Jy=h5read(fileID,strcat(EHJ_1st,'/jy_ec/p0/3d'));
    Jz=h5read(fileID,strcat(EHJ_1st,'/jz_ec/p0/3d'));

    J_2_mag = Jx.^2 + Jz.^2 + Jy.^2;
    J_2_mag_mean_t(1,in) = mean(J_2_mag,'all');


    disp(in)

end
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
in=N;    
grid_dt = info.Groups(20).Attributes;
    dt = double(grid_dt(15).Value); %this is in omega_pe
    str = string(S(in).name);
    newstr = extractBetween(str,"pfd.","_p000000.h5");
    N_steps = str2double(newstr);
    time = dt*N_steps/sqrt(mime); % This is in omega pi^-1
    time_nl = time/Tau_nl; % This time nonlinear

    %--------------------------------------------------------------------------

time_nl_ar = linspace(0,time_nl,N);
%--------------------------------------------------------------------------
% Initial diagnostic plot 
%--------------------------------------------------------------------------
%
% magnetic components <|Bx|>, <|By|>, <|Bz|>,  
fs=18; x0=45;y0=54;xx1=1000;yy1=900;

f1=figure(1);
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(3,2,1)
plot(time_nl_ar,Bx_mean_t(1:end),'r', LineWidth=2)
hold on
plot(time_nl_ar,By_mean_t(1:end),'g', LineWidth=2)
plot(time_nl_ar,Bz_mean_t(1:end),'b', LineWidth=2)
plot(time_nl_ar,B_mag_mean_t(1:end),'k', LineWidth=2)
legend('$|dB_x|$','$|dB_y|$','$|dB_z|$','$|dB|$','Location','southeastoutside','FontSize',fs,Interpreter='latex')
ylabel('$|dB|$','FontSize',fs,Interpreter='latex')
xlabel('$t/t_{nl}$','FontSize',fs,Interpreter='latex')
xlim([0,1*time_nl])
hold off

% |dB|/B0
subplot(3,2,2)
plot(time_nl_ar,B_mag_mean_t(1:end)/0.1,'k', LineWidth=2)
hold on
plot(time_nl_ar,J_2_mag_mean_t(1:end)/max(J_2_mag_mean_t),'r', LineWidth=2)
legend('$|dB|/B0$','$J^{2}/J^{2}_{max}$','Location','southeastoutside','FontSize',fs,Interpreter='latex')
xlabel('$t/t_{nl}$','FontSize',fs,Interpreter='latex')
xlim([0,1*time_nl])
hold off
