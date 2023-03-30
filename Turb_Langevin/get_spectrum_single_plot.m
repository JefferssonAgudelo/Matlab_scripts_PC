%#-----------------------------------------------------------------------
% This is to compute the diagnostics of the turbulence
%#----------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%path = '/Volumes/PSC_DiRAC_DATA/TESTS_2022/New_V_tests/Turb_langevin/res100';
%path = '/Volumes/PSC_DiRAC_DATA/TESTS_2022/New_V_tests/Turb_alfven/res100';

%path = '/Volumes/PSC_DiRAC_DATA/TESTS_2022/New_V_tests/Turb_langevin/big_box';
%path = '/Volumes/PSC_DiRAC_DATA/TESTS_2022/New_V_tests/Turb_harris_langevin/harris_langevin_nopert';
%path = '/Volumes/PSC_DiRAC_DATA/TESTS_2022/New_V_tests/Turb_harris_langevin/harris_langevin_nopert_0708';

%path = '/Volumes/PSC_DiRAC_DATA/TESTS_2022/New_V_tests/Harris_yz_lange_pert_large';
%path = '/Volumes/PSC_DiRAC_DATA/TESTS_2022/New_V_tests/Harris_yz_base_large';

%path = '/Volumes/PSC_DiRAC_DATA/TESTS_2022/New_V_tests/second_set_simulations';

%path = '/Volumes/PSC_DiRAC_DATA/TESTS_2022/New_V_tests/Harris_yz_lange_no_pert_large_wavelength';


%path = '/Users/jeffersson_agudelo/Downloads/processed_plots_from_cori/data_wave_all';
%path = '/Users/jeffersson_agudelo/Downloads/processed_plots_from_cori/data_wave_2';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/base_pert_lange_2nd';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/base_pert_lange_3nd';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/harris_base_4nd';
%path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/harris_yz_lange_wavelength_all_4nd';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/Harris_yz_base';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/harris_yz_lange_all_working';

%path='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/psc_harris_yz_base_ppc1000_ome2_mime1';
%path='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/psc_harris_yz_lange_1_ppc1000_ome2_mime1_L05';

%path='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/psc_harris_yz_lange_all_par_ppc1000_ome2_mime1_L05';
%path='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/psc_harris_yz_lange_all_pert_par_ppc1000_ome2_mime1_L05';

%path='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/psc_harris_yz_base_ppc600_ome2_mime1_3D';
%path='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/psc_harris_yz_lange_all_ppc600_ome2_mime1_3D';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB01_kxky';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_lange_1_ppc1000_ome5_mime1_dB002';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB002';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB02';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB01_kxky';

%path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc100_ome5_mime1_dB002';% <---
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc100_ome5_mime1_dB005';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc100_ome5_mime1_dB01';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/psc_harris_yz_base_ppc1000_ome2_mime1';

path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_alone';
%path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_alone_2';

%path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB002';% <---
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB005';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB01';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB02';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB04';

%path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB002_L1';% <---
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB005_L1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB01_L1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB02_L1';
%path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_1/psc_harris_yz_base_ppc1000_ome2_mime1/psc_harris_yz_base_ppc1000_ome2_mime1';
%this has dB=05

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_2_ppc1000_ome5_mime1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_3_ppc1000_ome5_mime1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_4_ppc1000_ome5_mime1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_all_ppc1000_ome5_mime1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_all_par_ppc1000_ome5_mime1';

% For the scripts
path_s= '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';

% To save the plots
path_B = strcat(path,'/spectra/unnormalised/Magnetic_field/P2D');
path_M = strcat(path,'/spectra/unnormalised/Momentum/P2D');
path_1D = strcat(path,'/spectra/unnormalised/P1D_per');
path_tp = strcat(path,'/spectra/unnormalised/time_plots');

if not(isfolder(path_B))
    mkdir(path_B)
end
if not(isfolder(path_M))
    mkdir(path_M)
end
if not(isfolder(path_1D))
    mkdir(path_1D)
end
if not(isfolder(path_tp))
    mkdir(path_tp)    
end

cd(path)
S = dir(fullfile(path,'pfd.*.h5'));
N=numel(S); % number of files to use
H=zeros(N);
% %--------------------------------------------------------------------------
% S2 = dir(fullfile(path,'pfd_moments.*.h5'));
% N2=numel(S2); % number of files to use
% H2=zeros(N2);
% in=8;
% %--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Change this accordingly
%--------------------------------------------------------------------------

% For the old runs
%--------------------------------------------------------------------------
% Normalization
% %B are normalized to the background magnetic field
% B0=0.4;
% %n is normalise to the proton density n0=1
% n0=1;
% %Vi normalised to the proton alfven speed V_a=0.1c The alfven speed of
% %electrons is Vae=10Vai
% Vai=0.4;
% Vae=0.4;
% %E = vB, as B0=0.1 and v in units of c, E0= B0*Vai/c
% E0=0.4; %??
% %T=(beta/2)B^2, Thus, as beta=1
% T0=0.04;
% %The current density J0=1?
% J0=Vai;
% 
% MFT0=1; % is this simply one in this normalization
% 
% %Normalising only when making plots
% c=1; VA2c = 0.1;
% %B0 = VA2c; E0 = B0*VA2c;
% %Pi0 = mi*VA2c*VA2c; Pe0 = me*VA2c*VA2c;
% %DeltaEpsilon0=VA2c*Pi0;
% %DeltaEpsilon0=Pi0;
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% Normalization
%B are normalized to the background magnetic field
B0=1.0;%0.2;
%n is normalise to the proton density n0=1
n0=1;
%Vi normalised to the proton alfven speed V_a=0.1c The alfven speed of
%electrons is Vae=10Vai
Vai=1;%0.2;
Vae=1;%0.2;
%E = vB, as B0=0.1 and v in units of c, E0= B0*Vai/c
E0=1;%0.2; %??
%T=(beta/2)B^2, Thus, as beta=1
T0=1;%0.02;
%The current density J0=1?
J0=1;%Vai;

MFT0=1; % is this simply one in this normalization

nb_n0 =0.1;

Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);

%Normalising only when making plots
c=1; VA2c = 1;%0.2;
%B0 = VA2c; E0 = B0*VA2c;
%Pi0 = mi*VA2c*VA2c; Pe0 = me*VA2c*VA2c;
%DeltaEpsilon0=VA2c*Pi0;
%DeltaEpsilon0=Pi0;

%--------------------------------------------------------------------------

kb = 1.; 
mu0 =1.; 
c=1; 
q = 1;

mime =1.; 
omega_pe_Omega_ce=5;

mi = 1.; 
me = 1. / mime; eps0=1.;
omega_pi=1;
Omega_e=Vai*sqrt(mime)*omega_pi;
Omega_i=Omega_e / mime;
TOmega_e=1/Omega_e; 
TOmega_i=1/Omega_i;
jn=6;


N_jn=N; %This is to store some but not all the time steps
Ex_rec_avg=zeros(1,N_jn);
epoch_a=zeros(1,N_jn);

spectraB_all = cell(1,N_jn);
spectraE_all = cell(1,N_jn);
%spectraPei = cell(1,N_jn);
%--------------------------------------------------------------------------


% Run this to get the spectra profiles
%--------------------------------------------------------------------------
%in_i=40;
for in_i=1:N   
    
    in=in_i;

    %in=2*in_i;
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
    Lx=grid_length(4).Value(1) - grid_length(3).Value(1);
    Ly=grid_length(4).Value(2) - grid_length(3).Value(2);
    Lz=grid_length(4).Value(3) - grid_length(3).Value(3);
 
    resx=double(Lx)/double(dx);    
    resy=double(Ly)/double(dy);    
    resz=double(Lz)/double(dz); res=resy;
    
    threshold=pi/resy; 
    %--------------------------------------------------------------------------
    
%     %----------------------------------------------------------------------
%     disp(strcat('Computing step ...',S2(in).name))    
%     fileID2 =  S2(in).name; %change the 1 per i
%     %h5disp(fileID2);
%     info2 = h5info(fileID2);
%     moments_1st = info2.Groups(1).Name;
%     %----------------------------------------------------------------------
    
    %----------------------------------------------------------------------
    % 'rho_e_UP' 'jx_e_UP' 'jy_e_UP' 'jz_e_UP' 'px_e_UP' 'py_e_UP'
    % 'pz_e_UP' 'txx_e_UP' 'tyy_e_UP' 'tzz_e_UP' 'txy_e_UP' 'tyz_e_UP'
    % 'tzx_e_UP' 'rho_i_UP' 'jx_i_UP' 'jy_i_UP' 'jz_i_UP' 'px_i_UP'
    % 'py_i_UP' 'pz_i_UP' 'txx_i_UP' 'tyy_i_UP' 'tzz_i_UP' 'txy_i_UP'
    % 'tyz_i_UP' 'tzx_i_UP'
    %----------------------------------------------------------------------
        
    Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
    Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));

    Ex=h5read(fileID,strcat(EHJ_1st,'/ex_ec/p0/3d'));
    Ey=h5read(fileID,strcat(EHJ_1st,'/ey_ec/p0/3d'));
    Ez=h5read(fileID,strcat(EHJ_1st,'/ez_ec/p0/3d'));
    
    
%     % This has to be fixed because it is only the popullation in or out of the harris
% 
%     p_e_up{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e_UP/p0/3d')); 
%     p_e_up{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e_UP/p0/3d'));
%     p_e_up{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e_UP/p0/3d'));
%     
%     p_i_up{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i_UP/p0/3d'));
%     p_i_up{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i_UP/p0/3d'));
%     p_i_up{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i_UP/p0/3d'));
% 
%     p_e_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e_UP/p0/3d')); %remember to change this one
%     p_e_ba{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e_UP/p0/3d'));
%     p_e_ba{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e_UP/p0/3d'));
%     
%     p_i_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i_UP/p0/3d'));
%     p_i_ba{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i_UP/p0/3d'));
%     p_i_ba{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i_UP/p0/3d'));
% 
%     p_e{1,1}=(p_e_up{1,1}+p_e_ba{1,1})./2; 
%     p_e{1,2}=(p_e_up{1,2}+p_e_ba{1,2})./2; 
%     p_e{1,3}=(p_e_up{1,3}+p_e_ba{1,3})./2; 
% 
%     p_i{1,1}=(p_i_up{1,1}+p_i_ba{1,1})./2; 
%     p_i{1,2}=(p_i_up{1,2}+p_i_ba{1,2})./2; 
%     p_i{1,3}=(p_i_up{1,3}+p_i_ba{1,3})./2;
% 
%     v_e=cell(1,3);
%     v_i=cell(1,3);
%     for i=1:3
%         v_e{1,i} = p_e{1,i} * c ./ sqrt(c^2 * me^2 + p_e{1,i}.^2);
%         v_i{1,i} = p_i{1,i} * c ./ sqrt(c^2 * mi^2 + p_i{1,i}.^2);
%     end
% 
%     px_e=v_e{1,1};
%     py_e=v_e{1,2};
%     pz_e=v_e{1,3};
%     px_i=v_i{1,1};
%     py_i=v_i{1,2};
%     pz_i=v_i{1,3};
 
    %----------------------------------------------------------------------  
    cd(path_s)
    spectraB_i=CalcSpectra_CB_local(Bx,By,Bz,resx,resy,resz,threshold); % 
    spectraE_i=CalcSpectra_CB_local(Ex,Ey,Ez,resx,resy,resz,threshold);
    %spectraPe_i=CalcSpectra_CB_local(px_e,py_e,pz_e,resx,resy,resz,threshold);
    %spectraJ=CalcSpectra_CB(Jx,Jy,Jz,res,threshold);
    spectraB_all{1,in}=spectraB_i;
    spectraE_all{1,in}=spectraE_i;
    %----------------------------------------------------------------------
    str = string(S(in).name);
    %S = dir(fullfile(path,'pfd.*.h5'));
    newStr = extractBetween(str,"pfd.","_p000000.h5");
    %newStr = extractBetween(str,"pfd_moments.","_p000000.h5");
    N_steps = str2double(newStr);
    time_t = dt*N_steps;    

    epoch_a(1,in) = time_t/omega_pe_Omega_ce;
    cd(path);

%     %----------------------------------------------------------------------      
%     cd(path_M)
%     saveas(f2,strcat(num2str(time_t),'P1DB_spectrum_per.png'));
%     cd(path_1D)    
%     saveas(f3,strcat(num2str(time_t),'P1DB_spectrum_per.png'));
%     %saveas(f3,strcat(num2str(time_t),'1DB_spectrum_par.png'));
%     cd(path); 
%     %----------------------------------------------------------------------
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% This is to make the plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------------------------------------------------
width=1300;%size_X(2);
height=500;%size_X(1);
fs=18; x0=0;y0=0;
clist = colormap(hsv(4));
barticks=[1,epoch_a(1,floor(2*N/4)),epoch_a(1,floor(3*N/4)),epoch_a(1,floor(4*N/4))];
barticks = round(barticks,1);
%--------------------------------------------------------------------------
f3=figure(3);
set(gcf,'position',[x0,y0,0.8*width,0.7*height])
%--------------------------------------------------------------------------
h1=subplot(1,2,1); % Magnetic spectra per
jn=1;
spectraB = spectraB_all{1,2}; P1D_perB=(spectraB.P1Dper);     
loglog(spectraB.kper,P1D_perB./max(P1D_perB),'color',clist(jn,:),'LineWidth',2)
hold on
for jn=2:4
    in= floor(jn*epoch_a(1,end)/4);
    spectraB = spectraB_all{1,in}; P1D_perB=(spectraB.P1Dper);   
    loglog(spectraB.kper,P1D_perB./max(P1D_perB),'color',clist(jn,:),'LineWidth',2)    
end
set(gca,'FontSize',fs,'TickLabelInterpreter','latex')
x2=log10([1 40]);     y2=x2.*(-2.8)-1;
xlim([0.1 threshold]);
ylim([10^(-8) 10^(0)]);
y1=get(gca,'ylim');
loglog(10.^x2,10.^y2,'--k','LineWidth',2)
txt5 = '$$ k_{\perp}^{-2.8}$$';
text(4 , 10e-3,txt5,'Interpreter','latex','FontSize',fs);
xlabel('$k_\perp d_i$','Interpreter','latex','FontSize',fs)
ylabel('$P^{B}_{1D_\perp}$','Interpreter','latex','FontSize',fs)
hcb=colorbar; colormap(h1,clist); hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
hcb.Ticks = linspace(0.1,0.9,4); 
hcb.TickLabels = barticks;
hcb.Title.Interpreter = 'latex';
hcb.Title.String = '$\Omega_{ce}^{-1}$';
hold off
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
h2=subplot(1,2,2); % Magnetic spectra par
jn=1;
spectraB = spectraB_all{1,2}; 
P1D_parB=(spectraB.P1Dpar);      
loglog(spectraB.kpar,P1D_parB./max(P1D_parB),'color',clist(jn,:),'LineWidth',2)
hold on
for jn=2:4
    in= floor(jn*epoch_a(1,end)/4);
    spectraB = spectraB_all{1,in};     P1D_parB=(spectraB.P1Dpar);    
    loglog(spectraB.kpar,P1D_parB./max(P1D_parB),'color',clist(jn,:),'LineWidth',2)    
end
set(gca,'FontSize',fs,'TickLabelInterpreter','latex')
x2=log10([1 40]);     y2=x2.*(-2.8)-1;
xlim([0.1 threshold]);
ylim([10^(-8) 10^(0)]);
y1=get(gca,'ylim');
loglog(10.^x2,10.^y2,'--k','LineWidth',2)
txt5 = '$$ k_{\perp}^{-2.8}$$';
text(4 , 10e-3,txt5,'Interpreter','latex','FontSize',fs);
xlabel('$k_{\|} d_i$','Interpreter','latex','FontSize',fs)
ylabel('$P^{B}_{1D_\|}$','Interpreter','latex','FontSize',fs)
hcb=colorbar; colormap(h2,clist); hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
hcb.Ticks = linspace(0.1,0.9,4); 
hcb.TickLabels = barticks;
hcb.Title.Interpreter = 'latex';
hcb.Title.String = '$\Omega_{ce}^{-1}$';
hold off
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
f4=figure(4);
set(gcf,'position',[x0,y0,0.8*width,0.7*height])
%--------------------------------------------------------------------------
h1=subplot(1,2,1); % Electric field spectra per
jn=1;
spectraE = spectraE_all{1,2}; P1D_perE=(spectraE.P1Dper);     
loglog(spectraE.kper,P1D_perE./max(P1D_perE),'color',clist(jn,:),'LineWidth',2)
hold on
for jn=2:4
    in= floor(jn*epoch_a(1,end)/4);
    spectraE = spectraE_all{1,in}; P1D_perE=(spectraE.P1Dper);   
    loglog(spectraE.kper,P1D_perE./max(P1D_perE),'color',clist(jn,:),'LineWidth',2)    
end
set(gca,'FontSize',fs,'TickLabelInterpreter','latex')
x2=log10([1 40]);     y2=x2.*(-2.8)-1;
xlim([0.1 threshold]);
ylim([10^(-8) 10^(0)]);
y1=get(gca,'ylim');
loglog(10.^x2,10.^y2,'--k','LineWidth',2)
txt5 = '$$ k_{\perp}^{-2.8}$$';
text(4 , 10e-3,txt5,'Interpreter','latex','FontSize',fs);
xlabel('$k_\perp d_i$','Interpreter','latex','FontSize',fs)
ylabel('$P^{E}_{1D_\perp}$','Interpreter','latex','FontSize',fs)
hcb=colorbar; colormap(h1,clist); hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
hcb.Ticks = linspace(0.1,0.9,4); 
hcb.TickLabels = barticks;
hcb.Title.Interpreter = 'latex';
hcb.Title.String = '$\Omega_{ce}^{-1}$';
hold off
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
h2=subplot(1,2,2); % Electric field spectra par
jn=1;
spectraE = spectraE_all{1,2}; 
P1D_parE=(spectraE.P1Dpar);      
loglog(spectraE.kpar,P1D_parE./max(P1D_parE),'color',clist(jn,:),'LineWidth',2)
hold on
for jn=2:4
    in= floor(jn*epoch_a(1,end)/4);
    spectraE = spectraE_all{1,in};     P1D_parE=(spectraE.P1Dpar);    
    loglog(spectraE.kpar,P1D_parE./max(P1D_parE),'color',clist(jn,:),'LineWidth',2)    
end
set(gca,'FontSize',fs,'TickLabelInterpreter','latex')
x2=log10([1 40]);     y2=x2.*(-2.8)-1;
xlim([0.1 threshold]);
ylim([10^(-8) 10^(0)]);
y1=get(gca,'ylim');
loglog(10.^x2,10.^y2,'--k','LineWidth',2)
txt5 = '$$ k_{\perp}^{-2.8}$$';
text(4 , 10e-3,txt5,'Interpreter','latex','FontSize',fs);
xlabel('$k_{\|} d_i$','Interpreter','latex','FontSize',fs)
ylabel('$P^{E}_{1D_\|}$','Interpreter','latex','FontSize',fs)
hcb=colorbar; colormap(h2,clist); hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
hcb.Ticks = linspace(0.1,0.9,4); 
hcb.TickLabels = barticks;
hcb.Title.Interpreter = 'latex';
hcb.Title.String = '$\Omega_{ce}^{-1}$';
hold off
%--------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(path_tp)
saveas(f3,'B_field_spectra_time_yz_harris_all_par_pert.png');
saveas(f4,'E_field_spectra_time_yz_harris_all_par_pert.png');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
