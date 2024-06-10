%This is to create the dispersion relation in 3D !!
% for the case with mime != 1

% For the alfven modes and different times to extract the frequencies
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%aa = 1; % for a single popullation
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/checking_in_laptop_anomalous/Injecting_Ex';
%path = '/Users/jeffersson_agudelo/Documents/New_psc/second_try_version/build_2/testing_jeff/test_delete';
%--------------------------------------------------------------------------

%%--------------------------------------------------------------------------
path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/checking_in_laptop_anomalous/psc_harris_yz_Ax_L5di_lange_local_E';
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_short_L1di';
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_Tba_perpar_short_L4di';
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_short_L4di';
aa = 2; % for two popullations
%%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
%--------------------------------------------------------------------------

cd(path)
%--------------------------------------------------------------------------
S = dir(fullfile(path,'pfd.*.h5'));
N = numel(S); % number of files to use
H = zeros(N);
%--------------------------------------------------------------------------
S2 = dir(fullfile(path,'pfd_moments.*.h5'));
N2 = numel(S2); % number of files to use
H2 = zeros(N2);
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------

%For the fields
bb = 1; % for the fields
%bb = 2; % for the electron density only

if(bb==1)
%--------------------------------------------------------------------------
field = 'ex_ec'; % This has to be the name of the variable as it is saved by the  code.
[fvars_s, OMz, KZAo, OMx, KXAo] = fourier_plots(field,S,N,S2,N2,path,aa,bb);

field = 'ey_ec'; % This has to be the name of the variable as it is saved by the  code.
[fvars_s, OMz, KZAo, OMx, KXAo] = fourier_plots(field,S,N,S2,N2,path,aa,bb);

field = 'ez_ec'; % This has to be the name of the variable as it is saved by the  code.
[fvars_s, OMz, KZAo, OMx, KXAo] = fourier_plots(field,S,N,S2,N2,path,aa,bb);


field = 'hx_fc'; % This has to be the name of the variable as it is saved by the  code.
[fvars_s, OMz, KZAo, OMx, KXAo] = fourier_plots(field,S,N,S2,N2,path,aa,bb);

field = 'hy_fc'; % This has to be the name of the variable as it is saved by the  code.
[fvars_s, OMz, KZAo, OMx, KXAo] = fourier_plots(field,S,N,S2,N2,path,aa,bb);

field = 'hz_fc'; % This has to be the name of the variable as it is saved by the  code.
[fvars_s, OMz, KZAo, OMx, KXAo] = fourier_plots(field,S,N,S2,N2,path,aa,bb);
%--------------------------------------------------------------------------
elseif(bb==2)
% For the density 
%--------------------------------------------------------------------------
field = 'ne'; %
[fvars_s, OMz, KZAo, OMx, KXAo] = fourier_plots(field,S,N,S2,N2,path,aa,bb);
%--------------------------------------------------------------------------
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



% This whole thing is a function!
%--------------------------------------------------------------------------
function [fvars_s, OMz, KZAo, OMx, KXAo] = fourier_plots(field,S,N,S2,N2,path,aa,bb)
%This function computes the fourier spectrum for the fields quantities and
%save plots to be compared with the dispersion relation. It saves Omge_kz,
%Omega_kx and Kx_Kz taking a cut along the y direction so there is no issue
%with the lack of periodicity with the reflective boundary conditions.


%--------------------------------------------------------------------------
% Change this accordingly
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Normalization
%B are normalized to the background magnetic field
B0 = 0.2;
%n is normalise to the proton density n0=1
n0 = 1;
%Vi normalised to the proton alfven speed V_a=0.1c The alfven speed of
%electrons is Vae=10Vai
Vae = 0.2;%0.2;

mime = 25.;
%mime = 1.;

kb = 1.; mu0 = 1.; c = 1; q = 1; me = 1. ; eps0 = 1.;

mi = mime ;

Vai = sqrt(1/mime) * Vae;

%E = vB, as B0=0.1 and v in units of c, E0= B0*Vai/c

E0 = 0.2;

%T=(beta/2)B^2, Thus, as beta=1
T0 = 0.02;%0.02;

%The current density J0=1?
J0 = Vae;

omega_pe_Omega_ce = 5;

nb_n0 = 0.1;

Vai_b = Vai/sqrt(nb_n0);

Vae_b = Vae/sqrt(nb_n0);

%Normalising only when making plots
VA2c = 0.2;

omega_pe = 1;

omega_pi = 1 / sqrt(mime);

Omega_e = 1 / omega_pe_Omega_ce;

Omega_i = Omega_e / mime;

TOmega_e = 1/Omega_e;

TOmega_i = 1/Omega_i;

step_sep = 50 ; % can I get this from a file? This reuqerieres to read from the slurm output file.
   
beta_0 = 0.2;
    
de = 1;

rho_e = sqrt(beta_0)*de;

i=1 ; 

disp(strcat('Computing step ...',S(i).name))
fileID =  S(i).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;
%--------------------------------------------------------------------------
grid_dt = info.Groups(20).Attributes;
dt = double(grid_dt(15).Value);
grid_ng = info.Groups(19).Attributes;
dx = grid_ng(10).Value(1);
dy = grid_ng(10).Value(2);
dz = grid_ng(10).Value(3);
grid_length = info.Groups(17).Attributes;

Lx = grid_length(4).Value(1) - grid_length(3).Value(1); %THIS IS IN di !!!
Ly = grid_length(4).Value(2) - grid_length(3).Value(2);
Lz = grid_length(4).Value(3) - grid_length(3).Value(3);

resx = double(Lx)/double(dx); % THIS IS IN de 
resy = double(Ly)/double(dy);
resz = double(Lz)/double(dz); 
res = max(resx,min(resy,resz));

threshold = pi/res;

ome_sam = 1/(step_sep * dt);   

ome_lh = sqrt( Omega_i^2 + ((omega_pi^2 * Omega_e^2) / (Omega_e^2 + omega_pe^2)  ) );

%ome_lh2 = 1 / sqrt( ( 1 / (Omega_i*Omega_e) ) + ( 1 / (omega_pi^2) ));
%This is not givin the same result
%ome_lh3 = sqrt(Omega_i * Omega_e);

k_max = pi / resx;
k_rhoe = 2*pi / rho_e;

ome_sam2_2_ome_lh = ome_sam / ome_lh;
kmax_2_krhoe = k_max / k_rhoe;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
out_sam_rate = step_sep;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
B = h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));

ss = size(B);

LZs = ss(3);

grid_size = [ss(1), ss(2), ss(3), N]; % y,z,t

clearvars B

N_jn=N-1; %This is to store some but not all the time steps

time_t_2=zeros(1,N_jn);

var0 = zeros(grid_size);


for dt_i=1:N-1
    field2 = strcat('/',field,'/p0/3d');
    %dt_i=1;

    if (bb==1)
        %----------------------------------------------------------------------
        disp(strcat('Computing step ...',S(dt_i).name))
        fileID =  S(dt_i).name; %change the 1 per i
        %h5disp(fileID);
        info = h5info(fileID);
        EHJ_1st = info.Groups(16).Name;
        %----------------------------------------------------------------------

        %----------------------------------------------------------------------
        str = string(S(dt_i).name);
        newStr = extractBetween(str,"pfd.","_p000000.h5");
        N_steps = str2double(newStr);
        time_t = dt*N_steps;
        time_t_2_Omega=time_t./omega_pe_Omega_ce;
        time_t_2(1,dt_i)=time_t_2_Omega;
        %----------------------------------------------------------------------

        %----------------------------------------------------------------------
        var=h5read(fileID,strcat(EHJ_1st,field2));
        max_dum = 1.;max(max(max(var)));
        var0(:,:,:,dt_i) = var(:,:,:)/max_dum;
        %var0(:,:,dt_i) = squeeze(var(1,:,:));
        %----------------------------------------------------------------------

    elseif(bb==2)
        %----------------------------------------------------------------------
        disp(strcat('Computing step ...',S2(dt_i).name))
        fileID2 =  S2(dt_i).name; %change the 1 per i
        %h5disp(fileID2);
        info2 = h5info(fileID2);
        moments_1st = info2.Groups(1).Name;
        %----------------------------------------------------------------------

        %----------------------------------------------------------------------
        str = string(S2(dt_i).name);
        newStr = extractBetween(str,"pfd_moments.","_p000000.h5");
        N_steps = str2double(newStr);
        time_t = dt*N_steps;
        time_t_2_Omega=time_t./omega_pe_Omega_ce;
        time_t_2(1,dt_i)=time_t_2_Omega;
        %----------------------------------------------------------------------

        if (aa==1) % with one popullation
            n_e=h5read(fileID2,strcat(moments_1st,'/rho_e_UP/p0/3d'));
            n_e=-1.*n_e;
        elseif(aa==2) % with two popullations
            n_e_up=h5read(fileID2,strcat(moments_1st,'/rho_e_UP/p0/3d'));
            n_e_ba=h5read(fileID2,strcat(moments_1st,'/rho_e_BA/p0/3d'));
            n_e = n_e_up + n_e_ba;
        end
        %----------------------------------------------------------------------
        var = n_e;
        max_dum = 1.;%max(max(max(var)));
        var0(:,:,:,dt_i) = var(:,:,:)/max_dum;
    end

end

%clearvars var

%--------------------------------------------------------------------------

% for the analysis taking a 1D cut to deal with the periodicity
%--------------------------------------------------------------------------
% This is for the cut along z

x_sli = Lx/(4*resx);
y_sli = Ly/(4*resy);
z_sli = Lz/(4*resz);

% take the 1d cut along z so the signal is periodic and get a 2D plane
var1 = squeeze(var0(:,y_sli,:,:));

% take the hamming window so for each pixel the time signal is periodic
sizes = size(var0);
vart_m = zeros(sizes(1),sizes(3),sizes(4));
Len_HamW = sizes(4);

for i = 1:sizes(1)
    for j = 1:sizes(3)
        vart_m(i,j,:) = squeeze(var1(i,j,:)).*hamming(Len_HamW,'periodic');
    end
end

% Computing the fourier transform in 3D
fvars = abs(fftn(vart_m))*sqrt(sizes(1)*sizes(3)*sizes(4));

%Shift ft to centre wavenumber in 3D
fvars_s = fftshift(fvars);

% create the arrays
%--------------------------------------------------------------------------
% make the wave number array
kz_max = 2*pi/(2*resz);
kz_min = 2*pi/Lz;
kz_array = linspace(-kz_max,kz_max,2*kz_max/kz_min);

kx_max = 2*pi/(2*resx);
kx_min = 2*pi/Lx;
kx_array = linspace(-kx_max,kx_max,2*kx_max/kx_min);

% make the omega frequency array
rest = dt * out_sam_rate / omega_pe_Omega_ce; %if I want to plot in terms of the ciclotron frequency
Lt = sizes(4) * rest; % this 100 is to consider the output samplin rate

om_max = 2*pi/(2*rest);
om_min = 2*pi/Lt;
om_array = linspace(-om_max,om_max,2*om_max/om_min);
%--------------------------------------------------------------------------

%fvars_s is the fourier transform of te quantity and the result is in kx, kz and Om

% This is ready to be used to produce plots of different quantities.
% Make the plots
%--------------------------------------------------------------------------

% k vs w plots.
%I need to include here the dispersion relation curve
%--------------------------------------------------------------------------
[OMz, KZAo] = meshgrid(om_array,kz_array); % This is for kz and Ome kz
[OMx, KXAo] = meshgrid(om_array,kx_array); % This is for kz and Ome kx

% lets integrate over kx to get a more accurate picture
P2Dz = squeeze(mean(fvars_s,1)); %taking the average over x
P2Dx = squeeze(mean(fvars_s,2)); %taking the average over z
P2D0 = max(max(max(fvars_s)));
P2D0_min = 10 * min(min(min(fvars_s/P2D0)));

fs=18;
x0=45;y0=54;xx1=800;yy1=300;

f1=figure(1);
%set(gcf,'Visible', 'off');
set(gcf,'position',[x0,y0,xx1,yy1])
%--------------------------------------------------------------------------
%hc = pcolor(KZAo,OMz,P2D./P2D0);
subplot(1,2,1)
[C,hc]=contourf(KZAo,OMz,P2Dz./P2D0);
lim = caxis; %caxis([P2D0_min 1]);
hold on
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex'; hcb.TickLabelInterpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
set(hc,'edgecolor','none')
colormap(jet)
set(gca,'XScale','lin','YScale','lin','FontSize',fs)
set(gca,'ColorScale','log')
ylim([om_min,om_max])
%xlim([kz_min,kz_max])
xlabel('$k_z d_e$','Interpreter','latex','FontSize',fs)
ylabel('$\omega/\Omega_{ce}$','Interpreter','latex','FontSize',fs)
%title('$P_{\mathbf{E}_{x}}(k_{z},\omega)$','Interpreter','latex','FontSize',fs)
title('$P(k_{z},\omega)$','Interpreter','latex','FontSize',fs)
xline(1,'--k',LineWidth=1.5)
yline(ome_lh/Omega_e,'--k',LineWidth=1.5)
axis square
hold off
%--------------------------------------------------------------------------
subplot(1,2,2)
[C,hc]=contourf(KXAo,OMx,P2Dx./P2D0);
lim = caxis; %caxis([P2D0_min 1]);
hold on
hcb2=colorbar; hcb2.Location = 'eastoutside';
hcb2.Label.FontSize=fs; hcb2.Label.Interpreter = 'latex'; hcb2.TickLabelInterpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
set(hc,'edgecolor','none')
colormap(jet)
set(gca,'XScale','lin','YScale','lin','FontSize',fs)
set(gca,'ColorScale','log')
ylim([om_min,om_max])
%xlim([kz_min,kz_max])
xlabel('$k_x d_e$','Interpreter','latex','FontSize',fs)
ylabel('$\omega/\Omega_{ce}$','Interpreter','latex','FontSize',fs)
title('$P(k_{x},\omega)$','Interpreter','latex','FontSize',fs)
%title('$P_{\mathbf{E}_{x}}(k_{x},\omega)$','Interpreter','latex','FontSize',fs)
xline(1,'--k',LineWidth=1.5)
yline(ome_lh/Omega_e,'--k',LineWidth=1.5)
axis square
hold off
%--------------------------------------------------------------------------


% This is for the time

% I need to include here the dispersion relation curve
%--------------------------------------------------------------------------
[KXA, KZA] = meshgrid(kz_array,kx_array);
% This has to be computed for a given time step. How to know which time
% step to choose?
%--------------------------------------------------------------------------
f2=figure(2)
%--------------------------------------------------------------------------
for it=1:4
    subplot(2,2,it)
    t = floor(it*(sizes(4)-1)/4);
    dump=squeeze(fvars_s(:,:,t));
    [C,hc]=contourf(KXA,KZA,dump/P2D0);
    lim = caxis; %caxis([P2D0_min 1]);
    %caxis([0.01 1]);
    hold on
    set(hc,'edgecolor','none')
    colormap(jet)
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex'; hcb.TickLabelInterpreter = 'latex';
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    set(gca,'XScale','lin','YScale','lin','FontSize',18)
    set(gca,'ColorScale','log')
    ylim([0,kx_max/2]);
    xlim([0,kz_max/2]);
    xlabel('$k_z d_e$','Interpreter','latex')
    ylabel('$k_x d_e$','Interpreter','latex')
    %title('$P_{\mathbf{E}_{x}}(k_{x},k_{z})$','Interpreter','latex')
    xline(1,'--k',LineWidth=1.5)
    yline(1,'--k',LineWidth=1.5)
    hold off
    axis square
    title('$$P(k_{x},k_{z}) \ t = \ $$'+string(round(time_t_2(t),2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
    %--------------------------------------------------------------------------
end

% %--------------------------------------------------------------------------
% sgtitle('$$t = \ $$'+string(round(time_t_2(t),2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs) %This is in Omega
% %--------------------------------------------------------------------------

% Save the plots
%--------------------------------------------------------------------------
cd(path)
%--------------------------------------------------------------------------
saveas(f1,strcat(num2str(1),field,'kz_omega_kx_omega.png'));
saveas(f2,strcat(num2str(1),field,'kz_kx.png'));
%--------------------------------------------------------------------------
end



