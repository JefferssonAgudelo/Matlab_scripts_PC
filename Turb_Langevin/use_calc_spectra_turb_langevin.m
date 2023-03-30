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

path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_lange_1_ppc1000_ome5_mime1_dB002'; 

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
%--------------------------------------------------------------------------
S2 = dir(fullfile(path,'pfd_moments.*.h5'));
N2=numel(S2); % number of files to use
H2=zeros(N2);
in=8;
%--------------------------------------------------------------------------

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
%--------------------------------------------------------------------------

% This has to be changed according to the resolution of each simulation
%----------------------------------------------------------------------

% ngrid=32; threshold=16;    dt=0.085022;  Lx=2*pi; Ly=2*pi; Lz=2*pi;% for ngrid 32
%ngrid=100; threshold=16;    dt=0.027207; Lx=2*pi; Ly=2*pi; Lz=2*pi; 
%ngrid=100; threshold=16;    dt=0.081621; Lx=3*2*pi; Ly=3*2*pi; Lz=3*2*pi; %big box

%--------------------------------------------------------------------------
in_i=40;

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
    resz=double(Lz)/double(dz); res=resx;
    
    threshold=pi/resy; 
    %--------------------------------------------------------------------------
    
    %----------------------------------------------------------------------
    disp(strcat('Computing step ...',S2(in).name))    
    fileID2 =  S2(in).name; %change the 1 per i
    %h5disp(fileID2);
    info2 = h5info(fileID2);
    moments_1st = info2.Groups(1).Name;
    %----------------------------------------------------------------------
    
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
    
    %Ex=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'));
    %Ey=h5read(fileID,strcat(EHJ_1st,'/jy_ec/p0/3d'));
    %Ez=h5read(fileID,strcat(EHJ_1st,'/jz_ec/p0/3d'));
    
    %Jx=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'));
    %Jy=h5read(fileID,strcat(EHJ_1st,'/jy_ec/p0/3d'));
    %Jz=h5read(fileID,strcat(EHJ_1st,'/jz_ec/p0/3d'));
    
%     px_e=h5read(fileID2,strcat(moments_1st,'/px_e/p0/3d'));
%     py_e=h5read(fileID2,strcat(moments_1st,'/py_e/p0/3d'));
%     pz_e=h5read(fileID2,strcat(moments_1st,'/pz_e/p0/3d'));
%     
%     px_i=h5read(fileID2,strcat(moments_1st,'/px_i/p0/3d'));
%     py_i=h5read(fileID2,strcat(moments_1st,'/py_i/p0/3d'));
%     pz_i=h5read(fileID2,strcat(moments_1st,'/pz_i/p0/3d'));
    
    % This has to be fixed because it is only the popullation in or out of the harris

    p_e_up{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e_UP/p0/3d')); 
    p_e_up{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e_UP/p0/3d'));
    p_e_up{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e_UP/p0/3d'));
    
    p_i_up{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i_UP/p0/3d'));
    p_i_up{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i_UP/p0/3d'));
    p_i_up{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i_UP/p0/3d'));

    p_e_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e_UP/p0/3d')); %remember to change this one
    p_e_ba{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e_UP/p0/3d'));
    p_e_ba{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e_UP/p0/3d'));
    
    p_i_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i_UP/p0/3d'));
    p_i_ba{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i_UP/p0/3d'));
    p_i_ba{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i_UP/p0/3d'));

    p_e{1,1}=(p_e_up{1,1}+p_e_ba{1,1})./1; 
    p_e{1,2}=(p_e_up{1,2}+p_e_ba{1,2})./1; 
    p_e{1,3}=(p_e_up{1,3}+p_e_ba{1,3})./1; 

    p_i{1,1}=(p_i_up{1,1}+p_i_ba{1,1})./1; 
    p_i{1,2}=(p_i_up{1,2}+p_i_ba{1,2})./1; 
    p_i{1,3}=(p_i_up{1,3}+p_i_ba{1,3})./1;

    v_e=cell(1,3);
    v_i=cell(1,3);
    for i=1:3
        v_e{1,i} = p_e{1,i} * c ./ sqrt(c^2 * me^2 + p_e{1,i}.^2);
        v_i{1,i} = p_i{1,i} * c ./ sqrt(c^2 * mi^2 + p_i{1,i}.^2);
    end

    px_e=v_e{1,1};
    py_e=v_e{1,2};
    pz_e=v_e{1,3};
    px_i=v_i{1,1};
    py_i=v_i{1,2};
    pz_i=v_i{1,3};
 
    %----------------------------------------------------------------------  
    cd(path_s)
    spectraB=CalcSpectra_CB_local(Bx,By,Bz,resx,resy,resz,threshold); % the local goes with the assymetry
    spectraPe=CalcSpectra_CB_local(px_e,py_e,pz_e,resx,resy,resz,threshold);
    
    %spectraB=CalcSpectra_CB(Bx,By,Bz,res,threshold); % the local goes with the assymetry
    %spectraE=CalcSpectra_CB(Ex,Ey,Ez,res,threshold);
    %spectraJ=CalcSpectra_CB(Jx,Jy,Jz,res,threshold);
    %spectraPe=CalcSpectra_CB(px_e,py_e,pz_e,res,threshold);
    %spectraPi=CalcSpectra_CB(px_i,py_i,pz_i,res,threshold);
    %----------------------------------------------------------------------
    str = string(S2(in).name);
    newStr = extractBetween(str,"pfd_moments.","_p000000.h5");
    N_steps = str2double(newStr);
    time_t = dt*N_steps;    
    %----------------------------------------------------------------------     

    %----------------------------------------------------------------------           
    % Making plots
    %----------------------------------------------------------------------
    fs=18;
    %----------------------------------------------------------------------
    [kp2J, kpJ]=meshgrid(spectraB.kpar,spectraB.kper);
    P2D=spectraB.P2D/max(max(spectraB.P2D));
    %P2D=spectraB.P2D;
    %----------------------------------------------------------------------    
    f1=figure(1);
    [C,h]=contourf(spectraB.kpar,spectraB.kper,log10(P2D'),'LevelStep',0.2);
    set(h,'LineColor','none')
    lim = caxis; 
    caxis([-8 0]); % normalised to the Max
    %caxis([0 10]); % Without normalisation 
    colormap(jet)
    colorbar
    set(gca,'XScale','log','YScale','log','FontSize',fs)
    xlabel('$k_\| d_i$','Interpreter','latex')
    ylabel('$k_\perp d_i$','Interpreter','latex')
    %x2=log10([0.21 1]); y2=x2 + 1.05;
    %x3=log10([0.06 0.2]); y3=(3/2)*x3 + 1.4;
    hold on
    %loglog(10.^x3,10.^y3,'--k','LineWidth',2)
    ylim([2*pi/Ly threshold])
    xlim([2*pi/Lz threshold])
    xticks([0.1 1 10]); yticks([0.1 1 10])
    xticklabels({'10^{-1}','10^{0}','10^{1}'}); yticklabels({'10^{-1}','10^{0}','10^{1}'})
    %txt = '$k_{\perp} \sim k_{\parallel}^{3/2}$';
    %txt2 = '$k_{\perp} \sim k_{\parallel}$';
    %text(0.1,0.4,txt,'Interpreter','latex','FontSize',fs)
    yline(10,'--k','LineWidth',1);
    xline(1,'--k','LineWidth',1);
    title('$\log_{10}{P^{\mathbf{B}}_{2D}} \ ; \ t = \ $'+string(round((time_t/omega_pe_Omega_ce),2)) + ...
        '$$ \ \Omega_{ce}^{-1}$$','Interpreter','latex','FontSize',fs)
    hold off
    %----------------------------------------------------------------------
    
    %----------------------------------------------------------------------    
    [kp2J, kpJ]=meshgrid(spectraPe.kpar,spectraPe.kper);
    P2D=spectraB.P2D/max(max(spectraB.P2D));
    %P2D=spectraPe.P2D;
    f2=figure(2);
    [C,h]=contourf(spectraPe.kpar,spectraPe.kper,log10(P2D'),'LevelStep',0.1);
    set(h,'LineColor','none')
    lim = caxis; 
    caxis([-8 0]); % normalised to the Max
    %caxis([4 10]); % Without normalisation 
    colormap(jet)
    colorbar
    set(gca,'XScale','log','YScale','log','FontSize',fs)
    xlabel('$k_\| d_i$','Interpreter','latex')
    ylabel('$k_\perp d_i$','Interpreter','latex')
    %x2=log10([0.21 1]); y2=x2 + 1.05;
    %x3=log10([0.06 0.2]); y3=(3/2)*x3 + 1.4;
    hold on
    %loglog(10.^x3,10.^y3,'--k','LineWidth',2)
    ylim([2*pi/Ly threshold])
    xlim([2*pi/Lz threshold])
    xticks([0.1 1 10]); yticks([0.1 1 10])
    xticklabels({'10^{-1}','10^{0}','10^{1}'}); yticklabels({'10^{-1}','10^{0}','10^{1}'})
    %txt = '$k_{\perp} \sim k_{\parallel}^{3/2}$';
    %txt2 = '$k_{\perp} \sim k_{\parallel}$';
    %text(0.1,0.4,txt,'Interpreter','latex','FontSize',fs)
    yline(10,'--k','LineWidth',1);
    xline(1,'--k','LineWidth',1);
    title('$\log_{10}{P^{\mathbf{P}}_{e,2D}} \ ; \ t = \ $'+string(round((time_t/omega_pe_Omega_ce),2)) + ...
        '$$ \ \Omega_{ce}^{-1}$$','Interpreter','latex','FontSize',fs)
    hold off
    %----------------------------------------------------------------------    

    %----------------------------------------------------------------------    
    %P1D_perB=(spectraB.P1Dper)./(max(spectraB.P1Dper));
    P1D_perB=(spectraB.P1Dper);
    P1D_perPe=(spectraPe.P1Dper); 
    %P1D_perPi=(spectraPi.P1Dper);    
    %----------------------------------------------------------------------        
    f3=figure(3);
    loglog(spectraB.kper,P1D_perB./max(P1D_perB),'-k','LineWidth',2)
    hold on
    loglog(spectraPe.kper,P1D_perPe./max(P1D_perB),'-b','LineWidth',2)
    %loglog(spectraPi.kper,P1D_perPi,'-r','LineWidth',2)
    set(gca,'FontSize',20)
    x2=log10([1 40]);     y2=x2.*(-2.8)-1; 
    xlim([0.1 threshold]); 
    ylim([10^(-8) 10^(0)]);
    loglog(10.^x2,10.^y2,'--k')
    %ylim([10^(3) 10^(13)]);
    y1=get(gca,'ylim');
    loglog(10.^x2,10.^y2,'--b','LineWidth',2)
    txt5 = '$$ k_{\perp}^{-2.8}$$';
    text(4 , 10e-3,txt5,'Interpreter','latex','FontSize',fs);  
    xlabel('$k_\perp d_i$','Interpreter','latex','FontSize',fs)
    ylabel('$P^{\psi}_{1D_\perp}$','Interpreter','latex','FontSize',fs)
    legend({'$\mathbf{B}$','$\mathbf{v}_{e}$'},'Interpreter','latex','FontSize',fs)
    title('$t = \ $'+string(round((time_t/omega_pe_Omega_ce),2)) + ...
        '$$ \ \Omega_{ce}^{-1}$$','Interpreter','latex','FontSize',fs)
    hold off  
    %----------------------------------------------------------------------    
%     %P1D_parB=(spectraB.P1Dpar)/(max(spectraB.P1Dpar)); 
%     P1D_parB=(spectraB.P1Dpar);
%     f3=figure(3);
%     loglog(spectraB.kpar,P1D_parB,'-k','LineWidth',2)
%     hold on
%     set(gca,'FontSize',20)
%     x2=log10([1 14]);     y2=x2.*(-3); 
%     xlim([0.1 threshold]); ylim([10^(-6) 10^(0)]);
%     loglog(10.^x2,10.^y2,'--b','LineWidth',2)
%     txt5 = '$$ k_{\perp}^{-3}$$';
%     text(4.5 , 10e-2,txt5,'Interpreter','latex','FontSize',fs);  
%     xlim([1 14]); ylim([10^(-6) 10^(0)]);
%     y1=get(gca,'ylim');
%     xlabel('$k_\| d_i$','Interpreter','latex','FontSize',fs)
%     ylabel('$P^{\psi}_{1D_\|}$','Interpreter','latex','FontSize',fs)
%     legend({'$\mathbf{B}$'},'Interpreter','latex','FontSize',fs)
%     title('$t = \ $'+string(round(time_t,2)) + ...
%         '$$ \ \omega_{pe}^{-1}$$','Interpreter','latex','FontSize',fs)
%     hold off 
    %----------------------------------------------------------------------
    
    cd(path_B)
    saveas(f1,strcat(num2str(time_t),'P2DB_spectrum.png'));
    cd(path_M)
    saveas(f2,strcat(num2str(time_t),'P1DB_spectrum_per.png'));
    cd(path_1D)    
    saveas(f3,strcat(num2str(time_t),'P1DB_spectrum_per.png'));
    %saveas(f3,strcat(num2str(time_t),'1DB_spectrum_par.png'));
    cd(path); 
    %----------------------------------------------------------------------
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% This is to calculate and plot rms and energy 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(path);
%--------------------------------------------------------------------------
S = dir(fullfile(path,'pfd.*.h5'));
N=numel(S); % number of files to use
H=zeros(N);
%--------------------------------------------------------------------------
S2 = dir(fullfile(path,'pfd_moments.*.h5'));
N2=numel(S2); % number of files to use
H2=zeros(N2);
%--------------------------------------------------------------------------
B_rms_a=zeros(1,N);
J_rms_a=zeros(1,N);
energy_b_a=zeros(1,N);
B_std_a=zeros(1,N);
J_std_a=zeros(1,N);
epoch_a=zeros(1,N);
%--------------------------------------------------------------------------
Pe_rms_a=zeros(1,N);
Pe_std_a=zeros(1,N);
Pi_rms_a=zeros(1,N);
Pi_std_a=zeros(1,N);
energy_Pei_a=zeros(1,N);
energy_Pe_a=zeros(1,N);
%--------------------------------------------------------------------------
for in=1:N%210 %N
    %----------------------------------------------------------------------
    disp(strcat('Computing step ...',S(in).name))    
    fileID =  S(in).name; %change the 1 per i
    %h5disp(fileID);
    info = h5info(fileID);
    EHJ_1st = info.Groups(16).Name;
    %----------------------------------------------------------------------
    disp(strcat('Computing step ...',S2(in).name))    
    fileID2 =  S2(in).name; %change the 1 per i
    %h5disp(fileID2);
    info2 = h5info(fileID2);
    moments_1st = info2.Groups(1).Name;
    %----------------------------------------------------------------------
         
    Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
    Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));
        
    Jx=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'));
    Jy=h5read(fileID,strcat(EHJ_1st,'/jy_ec/p0/3d'));
    Jz=h5read(fileID,strcat(EHJ_1st,'/jz_ec/p0/3d'));
    
%     px_e=h5read(fileID2,strcat(moments_1st,'/px_e/p0/3d'));
%     py_e=h5read(fileID2,strcat(moments_1st,'/py_e/p0/3d'));
%     pz_e=h5read(fileID2,strcat(moments_1st,'/pz_e/p0/3d'));
%     
%     px_i=h5read(fileID2,strcat(moments_1st,'/px_i/p0/3d'));
%     py_i=h5read(fileID2,strcat(moments_1st,'/py_i/p0/3d'));
%     pz_i=h5read(fileID2,strcat(moments_1st,'/pz_i/p0/3d'));
    
    p_e_up{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e_UP/p0/3d')); 
    p_e_up{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e_UP/p0/3d'));
    p_e_up{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e_UP/p0/3d'));
    
    p_i_up{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i_UP/p0/3d'));
    p_i_up{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i_UP/p0/3d'));
    p_i_up{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i_UP/p0/3d'));

    p_e_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e_UP/p0/3d')); %remember to change this to BA 
    p_e_ba{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e_UP/p0/3d'));
    p_e_ba{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e_UP/p0/3d'));
    
    p_i_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i_UP/p0/3d'));
    p_i_ba{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i_UP/p0/3d'));
    p_i_ba{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i_UP/p0/3d'));

    p_e{1,1}=(p_e_up{1,1}+p_e_ba{1,1})./2; 
    p_e{1,2}=(p_e_up{1,2}+p_e_ba{1,2})./2; 
    p_e{1,3}=(p_e_up{1,3}+p_e_ba{1,3})./2; 

    p_i{1,1}=(p_i_up{1,1}+p_i_ba{1,1})./2; 
    p_i{1,2}=(p_i_up{1,2}+p_i_ba{1,2})./2; 
    p_i{1,3}=(p_i_up{1,3}+p_i_ba{1,3})./2;

    v_e=cell(1,3);
    v_i=cell(1,3);
    for i=1:3
        v_e{1,i} = p_e{1,i} * c ./ sqrt(c^2 * me^2 + p_e{1,i}.^2);
        v_i{1,i} = p_i{1,i} * c ./ sqrt(c^2 * mi^2 + p_i{1,i}.^2);
    end

    px_e=v_e{1,1};
    py_e=v_e{1,2};
    pz_e=v_e{1,3};
    px_i=v_i{1,1};
    py_i=v_i{1,2};
    pz_i=v_i{1,3};
    %----------------------------------------------------------------------
    str = string(S(in).name);
    newStr = extractBetween(str,"pfd.","_p000000.h5");
    N_steps = str2double(newStr);
    time_t = dt*N_steps;    
    %----------------------------------------------------------------------
    
    % Calculating rms
    %----------------------------------------------------------------------    
    B_mag = sqrt(Bx.^2 + By.^2 + Bz.^2);
    B_mean = mean(B_mag,'all');
    
    J_mag = sqrt(Jx.^2 + Jy.^2 + Jz.^2);
    J_mean = mean(J_mag,'all');

    Pe_mag = sqrt(px_e.^2 + py_e.^2 + pz_e.^2);
    Pe_mean = mean(Pe_mag,'all');
    
    Pi_mag = sqrt(px_i.^2 + py_i.^2 + pz_i.^2);
    Pi_mean = mean(Pi_mag,'all');
    
    B_rms2 = rms(B_mag,"all");
    J_rms2 = rms(J_mag,"all");
    Pe_rms2 = rms(Pe_mag,"all");
    Pi_rms2 = rms(Pi_mag,"all");
    
    B2_mean = mean(B_mag.^2,'all');
    Pe2_mean = mean(Pe_mag.^2,'all');
    Pi2_mean = mean(Pi_mag.^2,'all');   
    
%     B_rms=sqrt(B2_mean - B_mean.^2);
%     J2_mean = mean(J_mag.^2,'all');
%     J_rms=sqrt(J2_mean - J_mean.^2);

    ener_b = (0.5)*B2_mean^2;
    ener_Pei = (0.5)*Pe2_mean^2 + (0.5)*Pi2_mean^2;
    
    A=B_mag;
    NN=size(A);
    NV=NN(1)*NN(2)*NN(3);
    B_mag1 = reshape(B_mag,[1,NV]);
    J_mag1 = reshape(J_mag,[1,NV]);
    Pe_mag1 = reshape(Pe_mag,[1,NV]);
    Pi_mag1 = reshape(Pi_mag,[1,NV]);    
    
    B_std = std(B_mag1);
    J_std = std(J_mag1);
    Pe_std = std(Pe_mag1);
    Pi_std = std(Pi_mag1);
    
    B_rms_a(1,in)=B_rms2;
    J_rms_a(1,in)=J_rms2;
    Pe_rms_a(1,in)=Pe_rms2;
    Pi_rms_a(1,in)=Pi_rms2;
    
    energy_b_a(1,in)=ener_b;
    energy_Pei_a(1,in)=ener_Pei;
    
    B_std_a(1,in)=B_std;
    J_std_a(1,in)=J_std;
    Pe_std_a(1,in)=Pe_std;
    Pi_std_a(1,in)=Pi_std; 
    
    
    epoch_a(1,in) = time_t;
end
%--------------------------------------------------------------------------
% Make the plots
%--------------------------------------------------------------------------
fs=18;
%rms
%--------------------------------------------------------------------------
f4=figure(4);
plot(epoch_a(1:end)./omega_pe_Omega_ce,B_rms_a(1:end),'-k','LineWidth',2)
hold on
plot(epoch_a(1:end)./omega_pe_Omega_ce,J_rms_a(1:end),'-b','LineWidth',2)
plot(epoch_a(1:end)./omega_pe_Omega_ce,Pe_rms_a(1:end),'-r','LineWidth',2)
plot(epoch_a(1:end)./omega_pe_Omega_ce,Pi_rms_a(1:end),'-c','LineWidth',2)
set(gca,'FontSize',20)
%xlim([0 800]);
%ylim([10^(1) 10^(10)]);
xlabel('$t (\Omega_{ce}^{-1}) $','Interpreter','latex','FontSize',fs)
ylabel('$\psi^{rms}$','Interpreter','latex','FontSize',fs)
legend({'$|B|$','$|J|$','$|v_{e}|$','$|v_{i}|$'},'Interpreter','latex','FontSize',fs)
%title('$\psi^{rms} = \sqrt{\langle \psi^{2} \rangle - \langle \psi \rangle^{2}}$','Interpreter','latex','FontSize',fs)
hold off
%--------------------------------------------------------------------------

%std 
%--------------------------------------------------------------------------
f5=figure(5);
plot(epoch_a(1:end)./omega_pe_Omega_ce,B_std_a(1:end),'-k','LineWidth',2)
hold on
plot(epoch_a(1:end)./omega_pe_Omega_ce,J_std_a(1:end),'-b','LineWidth',2)
plot(epoch_a(1:end)./omega_pe_Omega_ce,Pe_std_a(1:end),'-r','LineWidth',2)
plot(epoch_a(1:end)./omega_pe_Omega_ce,Pi_std_a(1:end),'-c','LineWidth',2)
set(gca,'FontSize',20)
%xlim([0 800]);
%ylim([10^(1) 10^(10)]);
xlabel('$t (\Omega_{ce}^{-1}) $','Interpreter','latex','FontSize',fs)
ylabel('$\psi^{std}$','Interpreter','latex','FontSize',fs)
legend({'$|B|$','$|J|$','$|v_{e}|$','$|v_{i}|$'},'Interpreter','latex','FontSize',fs)
title('$\psi^{std} = \sqrt{\langle \psi^{2} \rangle - \langle \psi \rangle^{2}}$','Interpreter','latex','FontSize',fs)
hold off
%--------------------------------------------------------------------------

%B energy 
%--------------------------------------------------------------------------
f6=figure(6);
semilogy(epoch_a(1:end)./omega_pe_Omega_ce,energy_b_a(1:end),'-k','LineWidth',2)
hold on
semilogy(epoch_a(1:end)./omega_pe_Omega_ce,energy_Pei_a(1:end),'-b','LineWidth',2)
set(gca,'FontSize',20)
%xlim([0 800]);
%ylim([10^(1) 10^(10)]);
xlabel('$t (\Omega_{ce}^{-1}) $','Interpreter','latex','FontSize',fs)
ylabel('$\langle \varepsilon \rangle$','Interpreter','latex','FontSize',fs)
legend({'$|B|$','$|v_{ei}|$',},'Interpreter','latex','FontSize',fs)
hold off
%title('$\psi^{std} = \sqrt{\langle \psi^{2} \rangle - \langle \psi \rangle^{2}}$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------

%----------------------------------------------------------------------
cd(path_tp)
%-------------------------------------------------------------------------
saveas(f4,'time_BJpepi_rms.png');
saveas(f5,'time_BJpepi_std.png');
saveas(f6,'time_Bpepi_energy.png');
cd(path);
%----------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%