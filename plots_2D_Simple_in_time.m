path = '/JAAR-DATA/CIRRUS_DATA_desktop/psc_turb_alf_2D_xz_large';

%----------------------------------path = '/home/UNN/pfcy6/DATA_CIRRUS/turb_alf_large_xz_dvdB';-------------------------------------------------------------------------------------

% For the scripts
%-----------------------------------------------------------------------------------------------------------------------
path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';

path_B = '/JAAR-DATA/CIRRUS_DATA_desktop/psc_turb_alf_2D_xz_large/B_field';
path_Jy = '/JAAR-DATA/CIRRUS_DATA_desktop/psc_turb_alf_2D_xz_large/Jy';
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


%--------------------------------------------------------------------------
%B are normalized to the background magnetic field
%B0=0.2;
B0=0.1;
%n is normalise to the proton density n0=1
n0=1;
%Vi normalised to the proton alfven speed V_a=0.1c The alfven speed of
%electrons is Vae=10Vai
%--------------------------------------------------------------------------
nb_n0 =0.1;
kb = 1.; mu0 =1.; c=1; q = 1;

Vai=0.1;
Vae=0.1;%0.2;
Va=0.1;%0.2;

Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);

mime =100.;
mi = mime;
me = 1; eps0=1.;
m = mi + me;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
omega_pe_Omega_ce=5;
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
    %--------------------------------------------------------------------------

    bfield=0;
    %%%
    if (bfield==1)
    Bx=squeeze(h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d')));
    By=squeeze(h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d')));
    Bz=squeeze(h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d')));
    B_mag = sqrt(Bx.^2 + Bz.^2 + (By-B0).^2);

    f3=figure(3);
    hc = pcolor(xl_di,zl_di,B_mag'/B0);
    %hc = pcolor(xl_di,zl_di,(Bz-B0*0)'/B0);
    hold on
    set(hc,'edgecolor','none')
    title('$|B|/B_{0} \ ; \ t = $' +string(round(time,2)) + ...
        '$\omega_{pi}$','FontSize',fs,Interpreter='latex')
    xlabel('$x/d_{i}$','FontSize',fs,Interpreter='latex')
    ylabel('$z/d_{i}$','FontSize',fs,Interpreter='latex')
    axis equal tight;
    colormap(f3,"jet")
    colorbar
    clim([0, 2])
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    hold off
    cd(path_B)
    saveas(f3,strcat(num2str(in),'B_mag.png'));
    else

    Jy=squeeze(h5read(fileID,strcat(EHJ_1st,'/jy_ec/p0/3d')));

    f3=figure(3);
    hc = pcolor(xl_di,zl_di,Jy/B0');
    %hc = pcolor(xl_di,zl_di,(Bz-B0*0)'/B0);
    hold on
    set(hc,'edgecolor','none')
    title('$Jz/J_{0} \ ; \ t = $' +string(round(time,2)) + ...
        '$\omega_{pi}$','FontSize',fs,Interpreter='latex')
    xlabel('$x/d_{i}$','FontSize',fs,Interpreter='latex')
    ylabel('$z/d_{i}$','FontSize',fs,Interpreter='latex')
    axis equal tight;
    colormap(f3,"jet")
    colorbar
    clim([-1, 1])
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    hold off
    cd(path_Jy)
    saveas(f3,strcat(num2str(in),'Jy.png'));
    end
end