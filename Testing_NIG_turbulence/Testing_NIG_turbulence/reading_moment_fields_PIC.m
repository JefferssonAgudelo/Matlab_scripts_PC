% This is for the 3D case

%path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/testing_E';
path = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/psc_turbulence_3D_maxwellian_nig/psc_turbulence_3D_maxwellian_nig';

path = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/using_22_nodes/cases_beta1/maxwell_TiTe'
%-----------------------------------------------------------------------------------------------------------------------

% For the scripts
%path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
%path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
%path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
path_color = '/home/UNN/pfcy6/codes/processing_scripts/Matlab_Scripts_Laptop';
%-----------------------------------------------------------------------------------------------------------------------

cd(path)
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
B0=0.5;
%n is normalise to the proton density n0=1
n0=1;
%Vi normalised to the proton alfven speed V_a=0.1c The alfven speed of
%electrons is Vae=10Vai
%--------------------------------------------------------------------------
nb_n0 =0.1;
kb = 1.; mu0 =1.; c=1; q = 1;

Vai=0.08; %<---- this need to be revised
Vae=0.1;%0.2;
Va=0.08;%0.2;

Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);

mime =49.;
mi = mime;
me = 1; eps0=1.;
m = mi + me;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
omega_pi=1;
Omega_e=Vai*sqrt(mime)*omega_pi;
Omega_i=Omega_e / mime;
TOmega_e=1/Omega_e;
TOmega_i=1/Omega_i;
omega_pe_Omega_ce=5;
%--------------------------------------------------------------------------
in=1;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
in=input('select the time stamp: ');

in=1;
fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;
B=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
%--------------------------------------------------------------------------
ss=size(B);
LXs=ss(1); LYs=ss(2); LZs=ss(3);
clearvars B
N_jn=N;
% %--------------------------------------------------------------------
% % Making a plot for B2 as a function of time to see the growth rate of
% the instability
% %--------------------------------------------------------------------

%--------------------------------------------------------------------------
nx1=1;    nx2=LXs;
ny1=1;    ny2=LYs;
nz1=1;    nz2=LZs;

px2 = nx2; py2 = ny2; pz2 = nz2;
start = [nx1 ny1 nz1];
count = [px2 py2 pz2];
%------------------------------------------------------------------

%------------------------------------------------------------------
disp(strcat('Computing step ...',S(in).name))
fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;
grid_dt = info.Groups(20).Attributes;

grid_length = info.Groups(17).Attributes;
Lx=grid_length(4).Value(1) - grid_length(3).Value(1); %(The substraction give the total size of the domain) -Lx0 to Lx0
Ly=grid_length(4).Value(2) - grid_length(3).Value(2);
Lz=grid_length(4).Value(3) - grid_length(3).Value(3);
%------------------------------------------------------------------

%------------------------------------------------------------------
%To make the coordinate transformation
%------------------------------------------------------------------
% Get the fiel name and remove the prt.
stri = S(in).name;
newStri = erase(stri,"pfd.");

% load the field files
Sm = dir(fullfile(path,'pfd_moments.*.h5'));
Nf=numel(Sm); % number of files to use

%The idea is to find the index that corresponds to the file that has
%the same name as in the prt info
Nff = {Sm.name};
Xff = contains(Nff,num2str(newStri));
jjn=find(Xff==1); % this finds the index
%Nff{Xff}
%------------------------------------------------------------------

%------------------------------------------------------------------
disp(strcat('Computing step ...',S2(jjn).name))
fileID2 =  S2(jjn).name; %change the 1 per i
%h5disp(fileID2);
info2 = h5info(fileID2);
moments_1st = info2.Groups(1).Name;
%----------------------------------------------------------------------

%----------------------------------------------------------------------
xl = linspace(-Lx/2,Lx/2,LXs);
yl = linspace(-Ly/2,Ly/2,LYs);
zl = linspace(-Lz/2,Lz/2,LZs);
%----------------------------------------------------------------------

% Here is where the parameter for the scale filtering are defined (the size of the window)
%----------------------------------------------------------------------
%----------------------------------------------------------------------
% define the window for the kernel and convolution

%for ndv =1:10
ndv = 1; % fractiopn of the box size. create a patch for the size of the convolution window
%l_wind_x = LXs/ndv; %size of the window

resx = Lx/LXs;
resy = Ly/LYs;
resz = Lz/LZs;
%----------------------------------------------------------------------

% Maybe it is better to define this in terms of the real resolution
%----------------------------------------------------------------------
l_wind_x = input('Window size in di:');
fprintf('\n');

l_wind_y = l_wind_x;
l_wind_z = l_wind_x;

[XL3d, YL3d, ZL3d] = meshgrid(xl,yl,zl);
%----------------------------------------------------------------------



% % This is the core and bulky part. Do not erase!
% %----------------------------------------------------------------------
% %----------------------------------------------------------------------
%
%----------------------------------------------------------------------
B{1,1}=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'),start,count);
B{1,2}=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'),start,count);
B{1,3}=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'),start,count);

B{1,1} = squeeze(B{1,1});
B{1,2} = squeeze(B{1,2});
B{1,3} = squeeze(B{1,3});
%----------------------------------------------------------------------

all = 0;

if(all==1)
%----------------------------------------------------------------------
E{1,1}=h5read(fileID,strcat(EHJ_1st,'/ex_ec/p0/3d'),start,count);
E{1,2}=h5read(fileID,strcat(EHJ_1st,'/ey_ec/p0/3d'),start,count);
E{1,3}=h5read(fileID,strcat(EHJ_1st,'/ez_ec/p0/3d'),start,count);

E{1,1} = squeeze(E{1,1});
E{1,2} = squeeze(E{1,2});
E{1,3} = squeeze(E{1,3});
%----------------------------------------------------------------------

%----------------------------------------------------------------------
J{1,1}=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'),start,count);
J{1,2}=h5read(fileID,strcat(EHJ_1st,'/jy_ec/p0/3d'),start,count);
J{1,3}=h5read(fileID,strcat(EHJ_1st,'/jz_ec/p0/3d'),start,count);

J{1,1} = squeeze(J{1,1});
J{1,2} = squeeze(J{1,2});
J{1,3} = squeeze(J{1,3});
%----------------------------------------------------------------------

%----------------------------------------------------------------------
p_e{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e/p0/3d'),start,count);
p_e{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e/p0/3d'),start,count);
p_e{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e/p0/3d'),start,count);

p_e{1,1} = squeeze(p_e{1,1});
p_e{1,2} = squeeze(p_e{1,2});
p_e{1,3} = squeeze(p_e{1,3});

p_i{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i/p0/3d'),start,count);
p_i{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i/p0/3d'),start,count);
p_i{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i/p0/3d'),start,count);

p_i{1,1} = squeeze(p_i{1,1});
p_i{1,2} = squeeze(p_i{1,2});
p_i{1,3} = squeeze(p_i{1,3});
%----------------------------------------------------------------------

%----------------------------------------------------------------------
n_e0{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_e/p0/3d'),start,count);
n_i0{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_i/p0/3d'),start,count);

n_e0 = squeeze(n_e0{1,1});
n_i0 = squeeze(n_i0{1,1});

n_e0=-1.*n_e0;
n_e0(n_e0==0)=1e-20;
n_i0(n_i0==0)=1e-20;
%----------------------------------------------------------------------

%----------------------------------------------------------------------
p_e{1,1}=p_e{1,1}./n_e0;
p_e{1,2}=p_e{1,2}./n_e0;
p_e{1,3}=p_e{1,3}./n_e0;

p_i{1,1}=p_i{1,1}./n_i0;
p_i{1,2}=p_i{1,2}./n_i0;
p_i{1,3}=p_i{1,3}./n_i0;
%----------------------------------------------------------------------

%----------------------------------------------------------------------
v_e=cell(1,3);
v_i=cell(1,3);
for i=1:3
    v_e{1,i} = (p_e{1,i} .* c ./ sqrt(c^2 .* me^2 + p_e{1,i}.^2)); % Do I need to do this normalization by VA2c
    v_i{1,i} = (p_i{1,i} .* c ./ sqrt(c^2 .* mi^2 + p_i{1,i}.^2));
end
clearvars p_i p_e p_i_up p_e_up
%----------------------------------------------------------------------


%----------------------------------------------------------------------
Pij_e{1,1}=h5read(fileID2,strcat(moments_1st,'/txx_e/p0/3d'),start,count);
Pij_e{2,2}=h5read(fileID2,strcat(moments_1st,'/tyy_e/p0/3d'),start,count);
Pij_e{3,3}=h5read(fileID2,strcat(moments_1st,'/tzz_e/p0/3d'),start,count);
Pij_e{1,2}=h5read(fileID2,strcat(moments_1st,'/txy_e/p0/3d'),start,count);
Pij_e{1,3}=h5read(fileID2,strcat(moments_1st,'/tzx_e/p0/3d'),start,count);
Pij_e{2,3}=h5read(fileID2,strcat(moments_1st,'/tyz_e/p0/3d'),start,count);

Pij_e{1,1} = squeeze(Pij_e{1,1});
Pij_e{2,2} = squeeze(Pij_e{2,2});
Pij_e{3,3} = squeeze(Pij_e{3,3});
Pij_e{1,2} = squeeze(Pij_e{1,2});
Pij_e{1,3} = squeeze(Pij_e{1,3});
Pij_e{2,3} = squeeze(Pij_e{2,3});

Pij_e{2,1} = Pij_e{1,2}; Pij_e{3,2} = Pij_e{2,3}; Pij_e{3,1} = Pij_e{1,3};


pressure_ion = input('compute pressure terms 1 (true) 0(false) (integer):');
fprintf('\n');

if(pressure_ion == 1)
    Pij_i{1,1}=h5read(fileID2,strcat(moments_1st,'/txx_i/p0/3d'),start,count);
    Pij_i{2,2}=h5read(fileID2,strcat(moments_1st,'/tyy_i/p0/3d'),start,count);
    Pij_i{3,3}=h5read(fileID2,strcat(moments_1st,'/tzz_i/p0/3d'),start,count);
    Pij_i{1,2}=h5read(fileID2,strcat(moments_1st,'/txy_i/p0/3d'),start,count);
    Pij_i{1,3}=h5read(fileID2,strcat(moments_1st,'/tzx_i/p0/3d'),start,count);
    Pij_i{2,3}=h5read(fileID2,strcat(moments_1st,'/tyz_i/p0/3d'),start,count);

    Pij_i{1,1} = squeeze(Pij_i{1,1});
    Pij_i{2,2} = squeeze(Pij_i{2,2});
    Pij_i{3,3} = squeeze(Pij_i{3,3});
    Pij_i{1,2} = squeeze(Pij_i{1,2});
    Pij_i{1,3} = squeeze(Pij_i{1,3});
    Pij_i{2,3} = squeeze(Pij_i{2,3});

    Pij_i{2,1} = Pij_i{1,2}; Pij_i{3,2} = Pij_i{2,3}; Pij_i{3,1} = Pij_i{1,3};
end
%----------------------------------------------------------------------

% This is to get the central momment pressure.
%----------------------------------------------------------------------
PPij_i=cell(3,3);
PPij_e=cell(3,3);

for i=1:3
    for j=1:3
        if(isempty(Pij_e{i,j}) == 1) % This is where if P_ba is zero, this should be changed.
            continue
        end
        if(pressure_ion == 1)
            PPij_i{i,j} = Pij_i{i,j} - 1.*n_i0.*mi.*v_i{1,i}.*v_i{1,j};
        end
        PPij_e{i,j} = Pij_e{i,j} - 1.*n_e0.*me.*v_e{1,i}.*v_e{1,j};
    end
end

% remove the variables just to rename them again
clearvars Pij_i Pij_e

% This is just to rename the variable
if(pressure_ion == 1)
    Pij_i = PPij_i;
end

Pij_e = PPij_e;

clearvars PPij_i PPij_e
%----------------------------------------------------------------------
end


%--------------------------------------------------------------------------
cd('/home/UNN/pfcy6/Downloads/Testing_NIG_turbulence/Testing_NIG_turbulence');

%--------------------------------------------------------------------------
Bx = double(B{1,1});
By = double(B{1,2});
Bz = double(B{1,3});

%% --- 6. Intermittency diagnostics ----------------------------------------
lag_list = [1 2 4 8 16 32 64];
results = diagnostics_increments(Bx, resx, lag_list);

fprintf('\n scale(dx units)   excess kurtosis   NIG alpha   NIG beta   NIG delta\n');
for i=1:numel(results)
    fprintf('  %10d       %10.3f     %9.3f  %9.3f  %9.3f\n', ...
        results(i).lag, results(i).kurtosis, results(i).alpha, ...
        results(i).beta, results(i).delta);
end

%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
Nx = nx2; Ny = ny2; Nz = nz2;
%% --- 1. Grid / box ------------------------------------------------------
Lx = 2*pi; Ly = 2*pi; Lz = 2*pi;     % adjust to your code's units (e.g. d_i)
dx = Lx/Nx;

B0mag   = 1.0;         % background field strength (code units)
b_rms   = 0.3;         % target fluctuation amplitude relative to B0
sigma_c = 0.0;         % cross helicity: 0 = balanced, +-1 = imbalanced

alpha_spec = 5/3;       % inertial-range spectral slope of E(k)
k0   = 2*pi/Lx * 2;     % outer scale (a couple of box modes)
kmax = 2*pi/Lx * (Nx/3);% keep well below Nyquist to avoid aliasing artifacts
kdiss = 2*pi/Lx * (Nx/4); % soft rolloff toward the "dissipation" end

%% --- 2. Base (Gaussian) Elsasser fields ---------------------------------
[zp_k, zm_k, KX,KY,KZ,Kmag] = gen_alfvenic_elsasser(Nx,Ny,Nz,Lx,Ly,Lz, ...
                                    alpha_spec,k0,kmax,kdiss,sigma_c);
%--------------------------------------------------------------------------
%% --- 5. Sanity checks -----------------------------------------------------
divB = ifftn( 1i*KX.*fftn(Bx(:,:,:)) + 1i*KY.*fftn(By(:,:,:)) + ...
              1i*KZ.*fftn(Bz(:,:,:)), 'symmetric');
fprintf('max |div B| / (k_max*b_rms) = %.3e  (should be ~0)\n', ...
        max(abs(divB(:))) / (kmax*b_rms*B0mag));

% Power spectrum check (bx component, shell-averaged)
Bxk = fftn(By(:,:,:));
Pk = abs(Bxk).^2;
nbins = 40;
kbins = logspace(log10(k0), log10(kmax), nbins);
Ek = zeros(nbins-1,1); kc = zeros(nbins-1,1);
for i=1:nbins-1
    m = Kmag>=kbins(i) & Kmag<kbins(i+1);
    Ek(i) = sum(Pk(m));
    kc(i) = sqrt(kbins(i)*kbins(i+1));
end
figure('Name','Recovered spectrum');
loglog(kc, Ek, 'o-'); hold on;
loglog(kc, Ek(1)*(kc/kc(1)).^(-alpha_spec), 'k--');
xlabel('k'); ylabel('shell power'); legend('measured', sprintf('k^{-%.2f}',alpha_spec));
title('Spectrum should be preserved by the cascade (on average)');
%--------------------------------------------------------------------------

fs=18;
% Some plots
cd(path_color)
f3=figure(3);
subplot(1,4,1)
dum = Bx(50,:,:); dump = squeeze(dum);
y_lim = max(max(max(abs(dump))));
hc=pcolor(yl,zl,dump');
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
set(hc,'edgecolor','none')
clim([-y_lim y_lim]); xlabel('$x/d_{i}$');ylabel('$y/d_{i}$')
%xline(xl(1,j),'--k','LineWidth',1.5)
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
title('Bx')
hold off
subplot(1,4,2)
dum = By(50,:,:); dump = squeeze(dum);
y_lim = max(max(max(abs(dump))));
hc=pcolor(yl,zl,dump');
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
set(hc,'edgecolor','none')
clim([-y_lim y_lim]); xlabel('$x/d_{i}$');ylabel('$y/d_{i}$')
%xline(xl(1,j),'--k','LineWidth',1.5)
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
title('By')
hold off
subplot(1,4,3)
dum = Bz(50,:,:); dump = squeeze(dum);
y_lim = max(max(max(abs(dump))));
hc=pcolor(yl,zl,dump');
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
set(hc,'edgecolor','none')
clim([-y_lim y_lim]); xlabel('$x/d_{i}$');ylabel('$y/d_{i}$')
%xline(xl(1,j),'--k','LineWidth',1.5)
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
title('Bz')
hold off
subplot(1,4,4)
dum = sqrt(Bx(50,:,:).^2 + By(50,:,:).^2 + Bz(50,:,:).^2); dump = squeeze(dum);
y_lim = max(max(max(abs(dump))));
hc=pcolor(yl,zl,dump');
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
set(hc,'edgecolor','none')
clim([0 y_lim]); xlabel('$x/d_{i}$');ylabel('$y/d_{i}$')
%xline(xl(1,j),'--k','LineWidth',1.5)
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
title('|B|')
hold off