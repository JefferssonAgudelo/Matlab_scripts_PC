%path = '/JAAR-DATA/CIRRUS_DATA_desktop/psc_turb_alf_2D_xz_large';
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/psc_turb_alf_2D_xz_be05';
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/psc_turb_alf_2D_xz_be02';
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/psc_turb_alf_2D_xz_be02_amp4_mime49_samedx';
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/psc_turb_alf_2D_xz_be05_amp4_mime49_samedx';
%----------------------------------path = '/home/UNN/pfcy6/DATA_CIRRUS/turb_alf_large_xz_dvdB';-------------------------------------------------------------------------------------

%path = '/JAAR-DATA/CIRRUS_DATA_desktop/psc_turb_alf_2D_xz_be02_current';

%path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_large_01_current'; % beta 01
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_large_02_current'; % beta 02
%path ='/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_large_05_current'; %beta 1
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_large_02_current_ppc3000';
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_large_2_current'; % beta 2
path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_large_02_dB02_current';

%path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_extlarge_02_current'; % beta 02
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_extlarge_05_current'; %beta 05


% For the scripts
%-----------------------------------------------------------------------------------------------------------------------
path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/home/UNN/pfcy6/codes/processing_scri    pts/Matlab_Scripts_Laptop';

path_B = strcat(path, '/B_field');
path_Jy = strcat(path, '/Jy');

if not(isfolder(path_B))
    mkdir(path_B)
end
if not(isfolder(path_Jy))
    mkdir(path_Jy)
end
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

bfield=input('B field (yes=1, no=0): ');

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

% this hole block is to check the initial conditions and a brief time evolution 
% 
%--------------------------------------------------------------------------
% magnetic field 
%--------------------------------------------------------------------------
Bx_mean_t = zeros(1,N);

fs=18;
for in=1:N
    cd(path)
    fileID =  S(in).name; %change the 1 per i
    %h5disp(fileID);
    info = h5info(fileID);
    EHJ_1st = info.Groups(16).Name;


    %--------------------------------------------------------------------------
    grid_dt = info.Groups(20).Attributes;
    dt = double(grid_dt(15).Value); %this is in omega_pe
    str = string(S(in).name);
    newstr = extractBetween(str,"pfd.","_p000000.h5");
    N_steps = str2double(newstr);
    time = dt*N_steps/sqrt(mime); % This is in omega pi^-1
    time_nl = time/Tau_nl; % This time nonlinear

    %--------------------------------------------------------------------------

    %bfield=0;
    %%%
    if (bfield==1)
    Bx=squeeze(h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d')));
    By=squeeze(h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d')));
    Bz=squeeze(h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d')));
    %B_mag = sqrt(Bx.^2 + Bz.^2 + (By-B0).^2);
    B_mag = sqrt(Bx.^2 + Bz.^2 );

    f3=figure(3);
    hc = pcolor(xl_di,zl_di,B_mag'/B0);
    %hc = pcolor(xl_di,zl_di,(Bz-B0*0)'/B0);
    hold on
    set(hc,'edgecolor','none')
    title('$|B_\perp|/B_{0} \ ; \ t = $' +string(round(time_nl,2)) + ...
        '$\tau_{nl}$','FontSize',fs,Interpreter='latex')
    xlabel('$x/d_{i}$','FontSize',fs,Interpreter='latex')
    ylabel('$z/d_{i}$','FontSize',fs,Interpreter='latex')
    axis equal tight;
    colormap(f3,"jet")
    colorbar
    clim([0, 2])
    %clim([0, 4])
    %clim([0, 7]) %amp 4
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    hold off
    cd(path_B)
    saveas(f3,strcat(num2str(in),'B_mag.png'));
    else

    Jy=squeeze(h5read(fileID,strcat(EHJ_1st,'/jy_ec/p0/3d')));

    j=50;
    cd(path_s2)
    f3=figure(3);
    hc = pcolor(xl_di,zl_di,Jy/B0');
    %hc = pcolor(xl_di,zl_di,(Bz-B0*0)'/B0);
    hold on
    set(hc,'edgecolor','none')
    title('$Jy/J_{0} \ ; \ t = $' +string(round(time_nl,2)) + ...
        '$\tau_{nl}$','FontSize',fs,Interpreter='latex')
    xlabel('$x/d_{i}$','FontSize',fs,Interpreter='latex')
    ylabel('$z/d_{i}$','FontSize',fs,Interpreter='latex')
    axis equal tight;
    colormap(f3,BWR)
    colorbar
    clim([-1, 1])
    %clim([-3, 3]) % amp 4
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    colormap(BWR)
    %xline(xl(1,j),'--k','LineWidth',1.5)
    hold off
    cd(path_Jy)
    saveas(f3,strcat(num2str(in),'Jy_line.png'));
    end
end