% This is for 2D in the xz
%-----------------------------------------------------------------------------------------------------------------------
%path = '/home/UNN/pfcy6/DATA_CIRRUS/turb_alf_jeff_2D_beta1_test';
%path = '/home/UNN/pfcy6/DATA_CIRRUS/turb_alf_large_xz_dvdB';
%path = '/home/UNN/pfcy6/DATA_CIRRUS/turb_alf_large_xz_dB';

%path = '/Volumes/PSC_DiRAC_DATA/Data_Cirrus/test_beta05_2D';
%path = '/Volumes/PSC_DiRAC_DATA/Data_Cirrus/test_beta05_2D_amp';

%path = '/Volumes/PSC_DiRAC_DATA/Data_Cirrus/psc_turb_alf_2D_xz_be02';
%path = '/Volumes/PSC_DiRAC_DATA/Data_Cirrus/psc_turb_alf_2D_xz_be05';
%path = '/Volumes/PSC_DiRAC_DATA/Data_Cirrus/psc_turb_alf_2D_xz_be02_amp4';
%path = '/Volumes/PSC_DiRAC_DATA/Data_Cirrus/psc_turb_alf_2D_xz_be02_mime49'; %<--
%there is and error here and I don't know wh

%path = '/Volumes/PSC_DiRAC_DATA/Data_Cirrus/psc_turb_alf_2D_xz_be05_mime49';
%path = '/Volumes/PSC_DiRAC_DATA/Data_Cirrus/psc_turb_alf_2D_xz_be02_amp4_mime49';
%path = '/Volumes/PSC_DiRAC_DATA/Data_Cirrus/psc_turb_alf_2D_xz_be02_amp4_mime49_samedx';
%path = '/Volumes/PSC_DiRAC_DATA/Data_Cirrus/psc_turb_alf_2D_xz_be05_amp4_mime49_samedx';



%path = '/JAAR-DATA/CIRRUS_DATA_desktop/psc_turb_alf_2D_xz_large';
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/psc_turb_alf_2D_xz_be02';
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/psc_turb_alf_2D_xz_be05';
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/psc_turb_alf_2D_xz_be02_amp4_mime49_samedx';
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/psc_turb_alf_2D_xz_be05_amp4_mime49_samedx';

%path = '/JAAR-DATA/CIRRUS_DATA_desktop/psc_turb_alf_cam_3D_mime49_highp';


%path = '/JAAR-DATA/CIRRUS_DATA_desktop/psc_turb_alf_2D_xz_be02_current';

%path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_large_current';
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_large_current_dB';

%NEED TO FIX THE COMPRESSIBILITY TO ACCOUNT FOR THE GEOMETRY


%path = '/Volumes/PSC_DiRAC_DATA/Data_Cirrus/turb_alf_jeff_2D_beta1_test/test_dvdB';

%path = '/Volumes/PSC_DiRAC_DATA/Data_Cirrus/3D_simulations/psc_turb_alf_cam_3D_mime49';

%path = '/Volumes/PSC_DiRAC_DATA/Data_Cirrus/turb_alf_cam_3D_small';

%path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_large_01_current'; % beta 01
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_large_02_current';
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_large_05_current';
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_large_02_current_ppc3000';
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_large_2_current'; % beta 2
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_large_02_dB02_current';

%path = '~/codes/PSC/psc-main/build_noGPU/Testing_no_GPU/psc_turb_alf_2D_xz_large_current';
%path = '~/codes/PSC/psc-main/build_noGPU/Testing_no_GPU/psc_turb_alf_2D_xz_large_current_kappa'; %kD
path = '~/codes/PSC/psc-main/build_noGPU/Testing_no_GPU/psc_turb_alf_2D_xz_large_current_kappa_reject';

%path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_extlarge_02_current'; % beta 02
%path = '/JAAR-DATA/CIRRUS_DATA_desktop/considering_current/psc_turb_alf_2D_xz_extlarge_05_current'; % beta 02
%----------------------------------path = '/home/UNN/pfcy6/DATA_CIRRUS/turb_alf_large_xz_dvdB';-------------------------------------------------------------------------------------

% For the scripts
%-----------------------------------------------------------------------------------------------------------------------
%path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
%path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
%path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
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
% to compute the normalised cross helicity 

clearvars Bx By Bz B_2_mag B_mag 

cross_hel_mean_t = zeros(1,N);
vx_mean_t= zeros(1,N);
vy_mean_t= zeros(1,N);
vz_mean_t= zeros(1,N);
Te_mean_t= zeros(1,N);

for in=1:N
    disp(strcat('Computing step ...',S(in).name))
    fileID =  S(in).name; %change the 1 per i
    %h5disp(fileID);
    info = h5info(fileID);
    EHJ_1st = info.Groups(16).Name;
    %------------------------------------------------------------------
    Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
    Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));

    % Bx = squeeze(Bx(:,1,:));
    % By = squeeze(By(:,1,:));
    % Bz = squeeze(Bz(:,1,:));
    % 
    %------------------------------------------------------------------

    %------------------------------------------------------------------
    disp(strcat('Computing step ...',S2(in).name))
    fileID2 =  S2(in).name; %change the 1 per i
    %h5disp(fileID2);
    info2 = h5info(fileID2);
    moments_1st = info2.Groups(1).Name;
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    p_e{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e/p0/3d'));
    p_e{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e/p0/3d'));
    p_e{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e/p0/3d'));

    p_i{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i/p0/3d'));
    p_i{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i/p0/3d'));
    p_i{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i/p0/3d'));
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    n_e0=h5read(fileID2,strcat(moments_1st,'/rho_e/p0/3d'));
    n_i0=h5read(fileID2,strcat(moments_1st,'/rho_i/p0/3d'));

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
        %v_e{1,i} = (p_e{1,i} .* c ./ sqrt(c^2 .* me^2 + p_e{1,i}.^2)); % Do I need to do this normalization by VA2c
        %v_i{1,i} = (p_i{1,i} .* c ./ sqrt(c^2 .* mi^2 + p_i{1,i}.^2));
        v_e{1,i} = p_e{1,i} ; % Do I think there is an issue with this opperation above
        v_i{1,i} = p_i{1,i} ;
    end
    %clearvars p_i p_e p_i_up p_e_up
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    Pij_e{1,1}=h5read(fileID2,strcat(moments_1st,'/txx_e/p0/3d'));
    Pij_e{2,2}=h5read(fileID2,strcat(moments_1st,'/tyy_e/p0/3d'));
    Pij_e{3,3}=h5read(fileID2,strcat(moments_1st,'/tzz_e/p0/3d'));
    Pij_e{1,2}=h5read(fileID2,strcat(moments_1st,'/txy_e/p0/3d'));
    Pij_e{1,3}=h5read(fileID2,strcat(moments_1st,'/tzx_e/p0/3d'));
    Pij_e{2,3}=h5read(fileID2,strcat(moments_1st,'/tyz_e/p0/3d'));

    Pij_e{1,1} = squeeze(Pij_e{1,1});
    Pij_e{2,2} = squeeze(Pij_e{2,2});
    Pij_e{3,3} = squeeze(Pij_e{3,3});
    Pij_e{1,2} = squeeze(Pij_e{1,2});
    Pij_e{1,3} = squeeze(Pij_e{1,3});
    Pij_e{2,3} = squeeze(Pij_e{2,3});

    Pij_e{2,1} = Pij_e{1,2}; Pij_e{3,2} = Pij_e{2,3}; Pij_e{3,1} = Pij_e{1,3};
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
            PPij_e{i,j} = Pij_e{i,j} - 1.*n_e0.*me.*v_e{1,i}.*v_e{1,j};
        end
    end

    % remove the variables just to rename them again
    clearvars Pij_e

    Te = (PPij_e{1,1} + PPij_e{2,2} + PPij_e{3,3})./(3*n_e0);
    Te_mean_t(1,in) = mean(Te,'all');
    %----------------------------------------------------------------------


    %----------------------------------------------------------------------
    vx = (1/B01)*(me.*n_e0.*v_e{1,1} + mi.*n_i0.*v_i{1,1})./(n_i0*(mi + me)); 
    vy = (1/B01)*(me.*n_e0.*v_e{1,2} + mi.*n_i0.*v_i{1,2})./(n_i0*(mi + me)); 
    vz = (1/B01)*(me.*n_e0.*v_e{1,3} + mi.*n_i0.*v_i{1,3})./(n_i0*(mi + me)); 

    % vx = squeeze(vx(:,1,:));
    % vy = squeeze(vy(:,1,:));
    % vz = squeeze(vz(:,1,:));
    % 
    vx_mean_t(1,in) = mean(abs(vx),'all');
    vy_mean_t(1,in) = mean(abs(vy),'all');
    vz_mean_t(1,in) = mean(abs(vz),'all');

    cross_hel = (vx.*Bx + vy.*By + vz.*Bz) ./ (vx.^2 + vy.^2 + vz.^2 + Bx.^2 + By.^2 + Bz.^2); 
    cross_hel_mean_t(1,in) = mean(cross_hel,'all');    

    % temporary
    clearvars Bx By Bz

    % % vex_mean_t(1,in) = (1/B01)*mean(abs(v_e{1,1}),'all');
    % % vey_mean_t(1,in) = (1/B01)*mean(abs(v_e{1,2}),'all');
    % % vez_mean_t(1,in) = (1/B01)*mean(abs(v_e{1,3}),'all');
    % % vix_mean_t(1,in) = (1/B01)*mean(abs(v_i{1,1}),'all');
    % % viy_mean_t(1,in) = (1/B01)*mean(abs(v_i{1,2}),'all');
    % % viz_mean_t(1,in) = (1/B01)*mean(abs(v_i{1,3}),'all');
    % % 
    % % clearvars v_e v_i
    % % 
    % % pex_mean_t(1,in) = (1/B01)*mean(abs(p_e{1,1}),'all');
    % % pey_mean_t(1,in) = (1/B01)*mean(abs(p_e{1,2}),'all');
    % % pez_mean_t(1,in) = (1/B01)*mean(abs(p_e{1,3}),'all');
    % % pix_mean_t(1,in) = (1/B01)*mean(abs(p_i{1,1}),'all');
    % % piy_mean_t(1,in) = (1/B01)*mean(abs(p_i{1,2}),'all');
    % % piz_mean_t(1,in) = (1/B01)*mean(abs(p_i{1,3}),'all');

    clearvars p_e p_i

  
end
%--------------------------------------------------------------------------



% this is just for the density fluctuations
%--------------------------------------------------------------------------
n_e0_mean_t= zeros(1,N);
n_i0_mean_t= zeros(1,N);
for in=1:N
 
    %------------------------------------------------------------------
    disp(strcat('Computing step ...',S2(in).name))
    fileID2 =  S2(in).name; %change the 1 per i
    %h5disp(fileID2);
    info2 = h5info(fileID2);
    moments_1st = info2.Groups(1).Name;
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    n_e0=h5read(fileID2,strcat(moments_1st,'/rho_e/p0/3d'));
    n_i0=h5read(fileID2,strcat(moments_1st,'/rho_i/p0/3d'));

    n_e0=-1.*n_e0;
    n_e0(n_e0==0)=1e-20;
    n_i0(n_i0==0)=1e-20;
    %----------------------------------------------------------------------
    n_e0_mean_t(1,in) = mean(n_e0-1,'all');
    n_i0_mean_t(1,in) = mean(n_i0-1,'all');
end
%--------------------------------------------------------------------------



% To compute the magnetic helicity
%--------------------------------------------------------------------------
HM_1_t= zeros(1,N);
HM_2_t= zeros(1,N);
%--------------------------------------------------------------------------
for in=1:N
    %in=9;
    disp(strcat('Computing step ...',S(in).name))
    fileID =  S(in).name; %change the 1 per i
    %h5disp(fileID);
    info = h5info(fileID);
    EHJ_1st = info.Groups(16).Name;
    %------------------------------------------------------------------
    Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
    Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));
    %------------------------------------------------------------------

    Bx = squeeze(Bx(:,1,:));
    By = squeeze(By(:,1,:));
    Bz = squeeze(Bz(:,1,:));

    Ns=size(Bx);

    grid_length = info.Groups(17).Attributes;
    Lx=grid_length(4).Value(1) - grid_length(3).Value(1); %(This is in de The substraction give the total size of the domain) -Lx0 to Lx0
    %Ly=grid_length(4).Value(2) - grid_length(3).Value(2);
    Lz=grid_length(4).Value(3) - grid_length(3).Value(3);

    nx = Ns(1,1);
    nz = Ns(1,2);

    % Generate grid
    x = linspace(0, Lx, nx);
    z = linspace(0, Lz, nz);
    [Z, X] = meshgrid(z, x);

    % Compute the wavenumbers for FFT
    kx = 2 * pi * [0:nx/2 -nx/2+1:-1] / (Lx/sqrt(mime)); % Wavenumbers in x
    kz = 2 * pi * [0:nz/2 -nz/2+1:-1] / (Lz/sqrt(mime)); % Wavenumbers in z
    [Kz, Kx] = meshgrid(kz, kx);

    % Fourier transform of the magnetic field components
    Bx_hat = fft2(Bx);
    By_hat = fft2(By);
    Bz_hat = fft2(Bz);

    % Solve for Ay in Fourier space
    % Bx = -i*kz*Ay, Bz = i*kx*Ay
    % => Ay_hat = (i*kz*Bx_hat - i*kx*Bz_hat) / (kx^2 + kz^2)
    denominator = Kx.^2 + Kz.^2;
    denominator(1,1) = 1; % Avoid division by zero at (kx, kz) = (0, 0)

    Ay_hat = (1i * Kz .* Bx_hat - 1i * Kx .* Bz_hat) ./ denominator; %<<----
    Ay_hat(1,1) = 0; % Set the mean value of Ay to zero for consistency

    Ax_hat =  - 1i * Kz .* By_hat ./ denominator;
    Ax_hat(1,1) = 0; % Set the mean value of Ay to zero for consistency

    Az_hat = 1i * Kx .* By_hat ./ denominator;
    Az_hat(1,1) = 0; % Set the mean value of Ay to zero for consistency

    % Inverse Fourier transform to get Ay in real space
    Ay = real(ifft2(Ay_hat));
    Ax = real(ifft2(Ax_hat));
    Az = real(ifft2(Az_hat));

    % Reconstruct the magnetic field components from Ay
    % Note: Use consistent signs for curl relations
    Bx_rec = -ifft2(1i * Kz .* fft2(Ay)); % -d(Ay)/dz
    Bz_rec = ifft2(1i * Kx .* fft2(Ay));  % d(Ay)/dx
    By_rec = ifft2(1i * Kz .* fft2(Ax) - 1i * Kx .* fft2(Az));

    % Take the real part of the reconstructed fields (to remove numerical noise)
    Bx_rec = real(Bx_rec);
    Bz_rec = real(Bz_rec);
    By_rec = real(By_rec);
    %--------------------------------------------------------------------------

   %  % Visualization of results
   %  %--------------------------------------------------------------------------
   %  figure;
   %  subplot(2, 2, 1);
   %  imagesc(x, z, Bx'); axis equal tight;
   %  title('Original Bx'); colorbar;
   % 
   %  subplot(2, 2, 2);
   %  imagesc(x, z, Bz'); axis equal tight;
   %  title('Original Bz'); colorbar;
   % 
   %  subplot(2, 2, 3);
   %  imagesc(x, z, Bx_rec'); axis equal tight;
   %  title('Reconstructed Bx'); colorbar;
   % 
   %  subplot(2, 2, 4);
   %  imagesc(x, z, Bz_rec'); axis equal tight;
   %  title('Reconstructed Bz'); colorbar;
   % 
   %  % Compute error
   %  error_Bx = max(abs(Bx(:) - Bx_rec(:)));
   %  error_Bz = max(abs(Bz(:) - Bz_rec(:)));
   % 
   %  fprintf('Maximum error in Bx: %.3e\n', error_Bx);
   %  fprintf('Maximum error in Bz: %.3e\n', error_Bz);
   % %--------------------------------------------------------------------------



     % Compute the spectrums 
    %--------------------------------------------------------------------------
       % Define the bins for the radial wavenumber
    Lx_di=Lx/sqrt(mime);
    Lz_di=Lz/sqrt(mime);
    kx=((0:Ns(1)-1)).*2*pi/Lx_di; %Includes negative wavenumbers and as it is k_max = pi/resx
    kz=((0:Ns(2)-1)).*2*pi/Lz_di;
    resx = Lx_di/length(Bx(:,1)); %in de
    resz = Lz_di/length(Bx(1,:)); %in de
    dk = 2 * pi / Lx_di; % Bin width in k-space

    threshold=pi/resx;

    [KX, KZ] = meshgrid(kx, kz);

    % Calculate the radial wavenumber k
    K = sqrt(KX.^2 + KZ.^2);

    k_max = threshold;%max(K(:)); % Maximum wavenumber
    k_bins = 0:dk:k_max; % Radial wavenumber bins

    % Initialize the omnidirectional spectrum
    E_k_1 = zeros(size(k_bins));
    E_k_2 = zeros(size(k_bins));

    % Calculate the energy spectrum
    F_Bx = Bx_hat;
    F_By = By_hat;
    F_Bz = Bz_hat;

    F_Bx2 = fft2(Bx.^2);
    F_By2 = fft2(By.^2);
    F_Bz2 = fft2(Bz.^2);

    energy_1 = abs(F_Bx).^2 + abs(F_By).^2 + abs(F_Bz).^2;
    energy_2 = abs(F_Bx2).^2 + abs(F_By2).^2 + abs(F_Bz2).^2;

    % Bin the energy into the radial wavenumber bins
    for i = 1:length(k_bins)-1
        k_min = k_bins(i);
        k_max = k_bins(i+1);
        % Find the indices of the Fourier modes that fall within the current bin
        indices = (K >= k_min) & (K < k_max);
        % Sum the energy of these modes
        E_k_1(i) = sum(energy_1(indices));
        E_k_2(i) = sum(energy_2(indices));        
    end

    % Normalize the spectrum by the bin width
    E_k_1 = E_k_1 / dk;
    E_k_2 = E_k_2 / dk;

    % Plot the omnidirectional spectrum
    %------------------------------------------------------------------    
    f21=figure(21);
    CM = jet(N); 
    loglog(k_bins(1:end-1), E_k_1(1:end-1), 'color',CM(in,:),'LineWidth', 1.5);
    hold on
    %loglog(k_bins(1:end-1), E_k_2(1:end-1), 'LineWidth', 1.5);
    title('1D Omnidirectional Spectrum');
    xlabel('k');
    ylabel('E(k)');
    legend('time')
    ylim([10^2, 10^12])
    xlim([3*10^(-1), 10^2])
    %------------------------------------------------------------------ 

    %hold off

    % f22=figure(22);
    % loglog(k_bins(1:end-1), E_k_1(1:end-1)./E_k_2(1:end-1), 'LineWidth', 1.5);
    % hold on
    % %loglog(k_bins(1:end-1), E_k_2(1:end-1), 'LineWidth', 1.5);
    % title('1D Omnidirectional Spectrum');
    % xlabel('k');
    % ylabel('E(k)');
    % legend('B_{teo}/B_{comp}')
    % hold off
    %--------------------------------------------------------------------------

    % Now this is to compute the magnetic helicity
    %--------------------------------------------------------------------------

    % Compute the magnetic helicity H = int(A . B) dV
    % In 2D: A = Ay (y-component), B = (Bx, 0, Bz)
    H = sum(sum(Ay .* (Bx + Bz))) * resx * resz;
    H2 = sum(sum(Ay .* (Bx_rec + Bz_rec))) * resx * resz;

    HM_1_t(1,in) = H;
    HM_2_t(1,in) = H2;


    %--------------------------------------------------------------------------
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




stopp

Te_maxwell = Te_mean_t;
J_maxwell = J_2_mag_mean_t;

Te_kappa = Te_mean_t;

Te_kappa_reject = Te_mean_t;
J_kappa_reject = J_2_mag_mean_t;


f11=figure(11);
subplot(2,1,1)
plot(time_nl_ar,Te_maxwell(1:end)/max(Te_maxwell(1))^1,'r', LineWidth=2)
hold on
%plot(time_nl_ar,Te_kappa(1:end)/max(Te_kappa(1))^0,'b', LineWidth=2)
plot(time_nl_ar,Te_kappa_reject(1:end)/max(Te_kappa_reject(1))^1,'b', LineWidth=2)
legend('$f_M$','$f_{\kappa}$','Location','southeastoutside','FontSize',fs,Interpreter='latex')
ylabel('$Te/Te_{0}$','FontSize',fs,Interpreter='latex')
xlabel('$t/t_{nl}$','FontSize',fs,Interpreter='latex')
xline(0.17,'--')
%xlim([0,1*time_nl])
hold off
subplot(2,1,2)
plot(time_nl_ar,J_maxwell(1:end)/max(Te_maxwell(1))^0,'r', LineWidth=2)
hold on
%plot(time_nl_ar,Te_kappa(1:end)/max(Te_kappa(1))^0,'b', LineWidth=2)
plot(time_nl_ar,J_kappa_reject(1:end)/max(Te_kappa_reject(1))^0,'b', LineWidth=2)
legend('$f_M$','$f_{\kappa}$','Location','southeastoutside','FontSize',fs,Interpreter='latex')
ylabel('$Jrms$','FontSize',fs,Interpreter='latex')
xlabel('$t/t_{nl}$','FontSize',fs,Interpreter='latex')
xline(0.17,'--')
%xlim([0,1*time_nl])
hold off

f12=figure(12);
plot(time_nl_ar(2:end),(Te_maxwell(2:end) - Te_maxwell(1:end-1))/max(Te_maxwell(2:end)),'r', LineWidth=2)
hold on%
plot(time_nl_ar(2:end),(Te_kappa(2:end) - Te_kappa(1:end-1))/max(Te_kappa(2:end)),'b', LineWidth=2)
%plot(time_nl_ar(2:end),(Te_kappa_reject(2:end) - Te_kappa_reject(1:end-1))/max(Te_kappa_reject(2:end)),'b', LineWidth=2)
ylabel('$\Delta Te/ Te_{max}$','FontSize',fs,Interpreter='latex')
xlabel('$t/t_{nl}$','FontSize',fs,Interpreter='latex')
xline(0.4,'--')
legend('$f_M$','$f_{\kappa}$','$v_{\perp}/c$','Location','southeastoutside','FontSize',fs,Interpreter='latex')
%xlim([0,1*time_nl])
hold off



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


% |dBz2|/|dB2|
subplot(3,2,3)
plot(time_nl_ar,By_2_mean_t(1:end)./B_2_mag_mean_t(1:end),'k', LineWidth=2)
ylabel('$|dB_y|^2/|dB|^2$','FontSize',fs,Interpreter='latex')
xlabel('$t/t_{nl}$','FontSize',fs,Interpreter='latex')
xlim([0,1*time_nl])
%xlabel('time')

% velocity components <|vx|>, <|vy|>, <|vz|>,  
subplot(3,2,4)
plot(time_nl_ar,vx_mean_t(1:end),'r', LineWidth=2)
hold on
plot(time_nl_ar,vy_mean_t(1:end),'g', LineWidth=2)
plot(time_nl_ar,vz_mean_t(1:end),'b', LineWidth=2)
legend('$|dv_x|$','$|dv_y|$','$|dv_z|$', 'Location','southeastoutside','FontSize',fs,Interpreter='latex')
ylabel('$|dv|$','FontSize',fs,Interpreter='latex')
xlabel('$t/t_{nl}$','FontSize',fs,Interpreter='latex')
xlim([0,1*time_nl])
hold off

% Normalised cross helicity
subplot(3,2,5)
plot(time_nl_ar,cross_hel_mean_t(1:end),'k', LineWidth=2)
ylabel('$v.B/(v^2 + B^2)$','FontSize',fs,Interpreter='latex')
xlabel('$t/t_{nl}$','FontSize',fs,Interpreter='latex')
xlim([0,1*time_nl])

subplot(3,2,6)
semilogy(time_nl_ar,abs(HM_1_t(1:end)),'r', LineWidth=2)
hold on
semilogy(time_nl_ar,abs(HM_2_t(1:end)),'b', LineWidth=2)
ylabel('Hm','FontSize',fs,Interpreter='latex')
xlabel('$t/t_{nl}$','FontSize',fs,Interpreter='latex')
legend('$|\int A \cdot B dV|$','$|\int A \cdot \nabla \times A dV|$', 'Location','southeastoutside','FontSize',fs,Interpreter='latex')
xlim([0,1*time_nl])
hold off
%--------------------------------------------------------------------------

cd(path)
saveas(f1,strcat(num2str(i),'initial_diagnostic.png'));
saveas(f21,strcat(num2str(i),'omni_spectrum_time.png'));

%--------------------------------------------------------------------------

% peak time
time_peak0 = time_nl_ar .* (J_2_mag_mean_t ==max(J_2_mag_mean_t)); 
time_peak = max(time_peak0)
time_peak_i = find(time_peak0 > 0)
% % %--------------------------------------------------------------------------
% % f11=figure(11)
% % subplot(2,1,1)
% % plot(Bz_mean_t(1:end)./Bx_mean_t(1:end),'r', LineWidth=2)
% % hold on
% % plot(Bz_mean_t(1:end)./By_mean_t(1:end),'g', LineWidth=2)
% % legend('|dBz|/|dBx|','|dBz|/|dBy|')
% % %xlabel('time')
% % hold off
% % subplot(2,1,2)
% % semilogy(abs(n_e0_mean_t(1:end)),'b', LineWidth=2)
% % hold on
% % semilogy(abs(n_i0_mean_t(1:end)),'r', LineWidth=2)
% % legend('|dne|','|dni|')
% % %xlabel('time')
% % hold off
% % %--------------------------------------------------------------------------



% % % % To compute beta and the temperature anisotropies 
% % % %--------------------------------------------------------------------------
% % % %
% % % 
% % % beta_i_par_mean_t= zeros(1,N);
% % % beta_e_par_mean_t= zeros(1,N);
% % % beta_i_per_mean_t= zeros(1,N);
% % % beta_e_per_mean_t= zeros(1,N);
% % % T_per_2_T_par_i_mean_t= zeros(1,N);
% % % T_per_2_T_par_e_mean_t= zeros(1,N);
% % % 
% % % in=1;
% % % for in=1:N
% % %     %in=1
% % %     disp(strcat('Computing step ...',S(in).name))
% % %     fileID =  S(in).name; %change the 1 per i
% % %     %h5disp(fileID);
% % %     info = h5info(fileID);
% % %     EHJ_1st = info.Groups(16).Name;
% % %     %------------------------------------------------------------------
% % %     Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
% % %     By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
% % %     Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));
% % % 
% % %     %------------------------------------------------------------------
% % % 
% % %     %------------------------------------------------------------------
% % %     disp(strcat('Computing step ...',S2(in).name))
% % %     fileID2 =  S2(in).name; %change the 1 per i
% % %     %h5disp(fileID2);
% % %     info2 = h5info(fileID2);
% % %     moments_1st = info2.Groups(1).Name;
% % %     %----------------------------------------------------------------------
% % % 
% % %     %----------------------------------------------------------------------
% % %     p_e{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e/p0/3d'));
% % %     p_e{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e/p0/3d'));
% % %     p_e{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e/p0/3d'));
% % % 
% % %     p_i{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i/p0/3d'));
% % %     p_i{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i/p0/3d'));
% % %     p_i{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i/p0/3d'));
% % %     %----------------------------------------------------------------------
% % % 
% % %     %----------------------------------------------------------------------
% % %     n_e0=h5read(fileID2,strcat(moments_1st,'/rho_e/p0/3d'));
% % %     n_i0=h5read(fileID2,strcat(moments_1st,'/rho_i/p0/3d'));
% % % 
% % %     n_e0=-1.*n_e0;
% % %     n_e0(n_e0==0)=1e-20;
% % %     n_i0(n_i0==0)=1e-20;
% % %     %----------------------------------------------------------------------
% % % 
% % %     %----------------------------------------------------------------------
% % %     p_e{1,1}=p_e{1,1}./n_e0;
% % %     p_e{1,2}=p_e{1,2}./n_e0;
% % %     p_e{1,3}=p_e{1,3}./n_e0;
% % % 
% % %     p_i{1,1}=p_i{1,1}./n_i0;
% % %     p_i{1,2}=p_i{1,2}./n_i0;
% % %     p_i{1,3}=p_i{1,3}./n_i0;
% % %     %----------------------------------------------------------------------
% % % 
% % %     %----------------------------------------------------------------------
% % %     v_e=cell(1,3);
% % %     v_i=cell(1,3);
% % %     for i=1:3
% % %         v_e{1,i} = (p_e{1,i} .* c ./ sqrt(c^2 .* me^2 + p_e{1,i}.^2)); % Do I need to do this normalization by VA2c
% % %         v_i{1,i} = (p_i{1,i} .* c ./ sqrt(c^2 .* mi^2 + p_i{1,i}.^2));
% % %     end
% % %     clearvars p_i p_e p_i_up p_e_up
% % %     %----------------------------------------------------------------------
% % % 
% % %     %----------------------------------------------------------------------
% % %     Pij_e{1,1}=h5read(fileID2,strcat(moments_1st,'/txx_e/p0/3d'));
% % %     Pij_e{2,2}=h5read(fileID2,strcat(moments_1st,'/tyy_e/p0/3d'));
% % %     Pij_e{3,3}=h5read(fileID2,strcat(moments_1st,'/tzz_e/p0/3d'));
% % %     Pij_e{1,2}=h5read(fileID2,strcat(moments_1st,'/txy_e/p0/3d'));
% % %     Pij_e{1,3}=h5read(fileID2,strcat(moments_1st,'/tzx_e/p0/3d'));
% % %     Pij_e{2,3}=h5read(fileID2,strcat(moments_1st,'/tyz_e/p0/3d'));
% % %     Pij_e{2,1} = Pij_e{1,2}; Pij_e{3,2} = Pij_e{2,3}; Pij_e{3,1} = Pij_e{1,3};
% % % 
% % %     Pij_i{1,1}=h5read(fileID2,strcat(moments_1st,'/txx_i/p0/3d'));
% % %     Pij_i{2,2}=h5read(fileID2,strcat(moments_1st,'/tyy_i/p0/3d'));
% % %     Pij_i{3,3}=h5read(fileID2,strcat(moments_1st,'/tzz_i/p0/3d'));
% % %     Pij_i{1,2}=h5read(fileID2,strcat(moments_1st,'/txy_i/p0/3d'));
% % %     Pij_i{1,3}=h5read(fileID2,strcat(moments_1st,'/tzx_i/p0/3d'));
% % %     Pij_i{2,3}=h5read(fileID2,strcat(moments_1st,'/tyz_i/p0/3d'));
% % %     Pij_i{2,1} = Pij_i{1,2}; Pij_i{3,2} = Pij_i{2,3}; Pij_i{3,1} = Pij_i{1,3};
% % %     %----------------------------------------------------------------------
% % % 
% % %     % Add this line to all the other analysis with the pressure to correct
% % %     % for the mass
% % %     %----------------------------------------------------------------------
% % %     for i=1:3
% % %         for j=1:3
% % %             Pij_i{i,j} = mi.*Pij_i{i,j};
% % %             Pij_e{i,j} = me.*Pij_e{i,j};
% % %         end
% % %     end
% % %     %----------------------------------------------------------------------
% % % 
% % %     % This is to get the central momment pressure.
% % %     %----------------------------------------------------------------------
% % %     PPij_i=cell(3,3);
% % %     PPij_e=cell(3,3);
% % % 
% % %     for i=1:3
% % %         for j=1:3
% % %             if(isempty(Pij_i{i,j}) == 1) % This is where if P_ba is zero, this should be changed.
% % %                 continue
% % %             end
% % %             PPij_i{i,j} = Pij_i{i,j} - 1.*n_i0.*mi.*v_i{1,i}.*v_i{1,j};
% % %             PPij_e{i,j} = Pij_e{i,j} - 1.*n_e0.*me.*v_e{1,i}.*v_e{1,j};
% % %         end
% % %     end
% % % 
% % %     B_2_mag = Bx.^2 + By.^2 + Bz.^2;
% % % 
% % %     % % %--------------------------------------------------------------------------
% % %     % % % checking the distributions of betas
% % %     % % %--------------------------------------------------------------------------
% % %     % % f11=figure(11);
% % %     % %     subplot(2,2,1)
% % %     % % histogram(2*(Pij_i{1,1}+Pij_i{2,2}+Pij_i{3,3})./(3.*B_2_mag),[0,150]) 
% % %     % % title('\beta_{i}'); hold on; xline(10,'-r', LineWidth=2); hold off
% % %     % %     subplot(2,2,2)
% % %     % % histogram(2*(Pij_e{1,1}+Pij_e{2,2}+Pij_e{3,3})./(3.*B_2_mag),[0,150]) 
% % %     % % title('\beta_{e}'); hold on; xline(1,'-r', LineWidth=2); hold off
% % %     % %     subplot(2,2,3)
% % %     % % histogram(2*(PPij_i{1,1}+PPij_i{2,2}+PPij_i{3,3})./(3.*B_2_mag),[0,150]) 
% % %     % %     title('\beta_{i,th}'); hold on; xline(10,'-r', LineWidth=2); hold off
% % %     % %     subplot(2,2,4)
% % %     % % histogram(2*(PPij_e{1,1}+PPij_e{2,2}+PPij_e{3,3})./(3.*B_2_mag),[0,150]) 
% % %     % %     title('\beta_{e,th}'); hold on; xline(1,'-r', LineWidth=2); hold off
% % %     % % 
% % %     % % %--------------------------------------------------------------------------
% % %     % % %--------------------------------------------------------------------------
% % % 
% % %     % remove the variables just to rename them again
% % %     clearvars Pij_i Pij_e
% % % 
% % %     % This is just to rename the variable
% % %     Pij_i = PPij_i;
% % %     Pij_e = PPij_e;
% % % 
% % %     clearvars PPij_i PPij_e
% % %     %----------------------------------------------------------------------
% % % 
% % % 
% % %     % This is for the coordinate transformation to compute the parallel and
% % %     % perpendicular temperatures
% % %     %----------------------------------------------------------------------
% % %     B_2_mag = Bx.^2 + By.^2 + Bz.^2;
% % %     B_mag = sqrt(Bx.^2 + By.^2 + Bz.^2);
% % %     B_2_mag_mean_t(1,in) = mean(B_2_mag,'all');
% % % 
% % %     b_n{1,1} = Bx./B_mag; 
% % %     b_n{1,2} = By./B_mag; 
% % %     b_n{1,3} = Bz./B_mag;
% % % 
% % %     bb_n=cell(3,3);
% % %     for i=1:3
% % %         for j=1:3           
% % %             bb_n{i,j} = b_n{1,i}.*b_n{1,j};            
% % %         end
% % %     end
% % % 
% % %     dum_0 = zeros(size(Bx));
% % %     dum_1 = zeros(size(Bx));
% % % 
% % %     for i=1:3
% % %         for j=1:3
% % %             Tij_par_i = (Pij_i{i,j}./n_i0).*bb_n{i,j} + dum_0;
% % %             dum_0 = Tij_par_i;
% % % 
% % %             Tij_par_e = (Pij_e{i,j}./n_e0).*bb_n{i,j} + dum_1;
% % %             dum_1 = Tij_par_e;
% % %         end
% % %     end
% % % 
% % %     Tij_per_i_v = cell(3,3);
% % %     Tij_per_e_v = cell(3,3);
% % % 
% % %     for i=1:3
% % %         for j=1:3
% % %             if(i==j)
% % %             Tij_per_i_v{i,j} = (Pij_i{i,j}./n_i0).*(1 - bb_n{i,j})/2 ;
% % %             Tij_per_e_v{i,j} = (Pij_e{i,j}./n_e0).*(1 - bb_n{i,j})/2 ;
% % %             else
% % %             Tij_per_i_v{i,j} = (Pij_i{i,j}./n_i0).*(0 - bb_n{i,j})/2 ;
% % %             Tij_per_e_v{i,j} = (Pij_e{i,j}./n_e0).*(0 - bb_n{i,j})/2 ;            
% % %             end
% % %         end
% % %     end
% % % 
% % %     dum_0 = zeros(size(Bx));
% % %     dum_1 = zeros(size(Bx));
% % % 
% % %     for i=1:3
% % %         for j=1:3
% % %             Tij_per_i = Tij_per_i_v{i,j} + dum_0;
% % %             dum_0 = Tij_per_i;
% % %             Tij_per_e = Tij_per_e_v{i,j} + dum_1;
% % %             dum_1 = Tij_per_e;
% % %         end
% % %     end
% % %     %----------------------------------------------------------------------
% % % 
% % %     %Now compute the value of each beta
% % %     %----------------------------------------------------------------------
% % %     beta_i_par = 2.* Tij_par_i.* n_i0 ./ B_2_mag;
% % %     beta_e_par = 2.* Tij_par_e.* n_i0 ./ B_2_mag;
% % % 
% % %     beta_i_per = 2.* Tij_per_i.* n_i0 ./ B_2_mag;
% % %     beta_e_per = 2.* Tij_per_e.* n_i0 ./ B_2_mag;
% % % 
% % %     T_per_2_T_par_i = Tij_per_i ./ Tij_par_i;
% % %     T_per_2_T_par_e = Tij_per_e ./ Tij_par_e;    
% % % 
% % %     beta_i_par_mean_t(1,in) = mean(beta_i_par,'all');
% % %     beta_e_par_mean_t(1,in) = mean(beta_e_par,'all'); 
% % %     beta_i_per_mean_t(1,in) = mean(beta_i_per,'all');
% % %     beta_e_per_mean_t(1,in) = mean(beta_e_per,'all');    
% % %     T_per_2_T_par_i_mean_t(1,in) = mean(T_per_2_T_par_i,'all');
% % %     T_per_2_T_par_e_mean_t(1,in) = mean(T_per_2_T_par_e,'all');    
% % %     %----------------------------------------------------------------------
% % % 
% % %     % make a scatter plot 
% % %     %----------------------------------------------------------------------
% % % 
% % %     % This is the plot T_perp/T_par  beta_par also per and for i and e
% % %     %{
% % %     %----------------------------------------------------------------------   
% % %     [N_TY_i,Xedges_i,Yedges_i] = histcounts2(beta_i_par,T_per_2_T_par_i);
% % %     [N_TY_e,Xedges_e,Yedges_e] = histcounts2(beta_e_par,T_per_2_T_par_e);    
% % %     %---------------------------------------------------------------------- 
% % %     fs=18;  x0=45;  y0=54;  xx1=1000;    yy1=300;
% % %     no_le=1;
% % %     %----------------------------------------------------------------------
% % %     f14=figure(14);
% % %     %set(gcf,'position',[x0,y0,xx1,yy1])
% % %     subplot(2,2,1)
% % %     dum1 = beta_i_par; dum2 = T_per_2_T_par_i;    
% % %     [Ni,Xedgesi,Yedgesi] = histcounts2(dum1,dum2);
% % %     Ni=Ni(1:end,1:end)';    Xedges2i=Xedgesi(2:end)'; Yedges2i=Yedgesi(2:end)';
% % %     %[Ci,Di]=meshgrid(Xedges2i,Yedges2i);
% % %     Ni(Ni<=no_le)=NaN;
% % %     %Ni_3_0 = Ni; dumnn= (Ni - Ni_3_0)./Di;
% % %     dumnn = Ni ;%./Di; dumnn_2 = sign(dumnn).*log(abs(dumnn));
% % %     hc=pcolor(Xedges2i,Yedges2i,dumnn);
% % %     %hc=contourf(Xedges2i,Yedges2i,dumnn_2,'LineStyle','none');
% % %     hold on
% % %     set(hc,'edgecolor','none');
% % %     set(gca,'ColorScale','log','FontSize',fs)
% % %     set(gca,'XScale','log','YScale','log','FontSize',fs)
% % %     colormap(jet);
% % %     clim([1 1e4]); 
% % %     hcb=colorbar; hcb.Location = 'eastoutside'; 
% % %     hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
% % %     ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% % %     ax.XLabel.String = '$\beta_{\parallel,i}/c$'; %ax.XTick = xspace_par;
% % %     ax.YLabel.String = '$T_{\perp,i}/T_{\parallel,i}$'; %ax.YTick = yspace_per;
% % %     %xline(0,'--k'); yline(0,'--k');
% % %     xlim([1e-2,2e1 ]); ylim([0.6, 3]); 
% % %     %title('R1','Interpreter','latex','FontSize',fs');
% % %     pbaspect([1 1 1])
% % %     hold off
% % %     %----------------------------------------------------------------------
% % %     subplot(2,2,2)
% % %     dum1 = beta_e_par; dum2 = T_per_2_T_par_e;    
% % %     [Ni,Xedgesi,Yedgesi] = histcounts2(dum1,dum2);
% % %     Ni=Ni(1:end,1:end)';    Xedges2i=Xedgesi(2:end)'; Yedges2i=Yedgesi(2:end)';
% % %     %[Ci,Di]=meshgrid(Xedges2i,Yedges2i);
% % %     Ni(Ni<=no_le)=NaN;
% % %     %Ni_3_0 = Ni; dumnn= (Ni - Ni_3_0)./Di;
% % %     dumnn = Ni ;%./Di; dumnn_2 = sign(dumnn).*log(abs(dumnn));
% % %     hc=pcolor(Xedges2i,Yedges2i,dumnn);
% % %     %hc=contourf(Xedges2i,Yedges2i,dumnn_2,'LineStyle','none');
% % %     hold on
% % %     set(hc,'edgecolor','none');
% % %     set(gca,'ColorScale','log','FontSize',fs)
% % %     set(gca,'XScale','log','YScale','log','FontSize',fs)
% % %     colormap(jet);
% % %     clim([1 1e4]); 
% % %     hcb=colorbar; hcb.Location = 'eastoutside'; 
% % %     hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
% % %     ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% % %     ax.XLabel.String = '$\beta_{\parallel,e}/c$'; %ax.XTick = xspace_par;
% % %     ax.YLabel.String = '$T_{\perp,e}/T_{\parallel,e}$'; %ax.YTick = yspace_per;
% % %     %xline(0,'--k'); yline(0,'--k');
% % %     xlim([1e-2,2e1 ]); ylim([0.6, 3]); 
% % %     %title('R1','Interpreter','latex','FontSize',fs');
% % %     pbaspect([1 1 1])
% % %     hold off
% % %     %----------------------------------------------------------------------
% % %     subplot(2,2,3)
% % %     dum1 = beta_i_per; dum2 = T_per_2_T_par_i;    
% % %     [Ni,Xedgesi,Yedgesi] = histcounts2(dum1,dum2);
% % %     Ni=Ni(1:end,1:end)';    Xedges2i=Xedgesi(2:end)'; Yedges2i=Yedgesi(2:end)';
% % %     %[Ci,Di]=meshgrid(Xedges2i,Yedges2i);
% % %     Ni(Ni<=no_le)=NaN;
% % %     %Ni_3_0 = Ni; dumnn= (Ni - Ni_3_0)./Di;
% % %     dumnn = Ni ;%./Di; dumnn_2 = sign(dumnn).*log(abs(dumnn));
% % %     hc=pcolor(Xedges2i,Yedges2i,dumnn);
% % %     %hc=contourf(Xedges2i,Yedges2i,dumnn_2,'LineStyle','none');
% % %     hold on
% % %     set(hc,'edgecolor','none');
% % %     set(gca,'ColorScale','log','FontSize',fs)
% % %     set(gca,'XScale','log','YScale','log','FontSize',fs)
% % %     colormap(jet);
% % %     clim([1 1e4]); 
% % %     hcb=colorbar; hcb.Location = 'eastoutside'; 
% % %     hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
% % %     ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% % %     ax.XLabel.String = '$\beta_{\perp,i}/c$'; %ax.XTick = xspace_par;
% % %     ax.YLabel.String = '$T_{\perp,i}/T_{\parallel,i}$'; %ax.YTick = yspace_per;
% % %     %xline(0,'--k'); yline(0,'--k');
% % %     xlim([1e-2,2e1 ]); ylim([0.6, 3]); 
% % %     %title('R1','Interpreter','latex','FontSize',fs');
% % %     pbaspect([1 1 1])
% % %     hold off
% % %     %----------------------------------------------------------------------
% % %     subplot(2,2,4)
% % %     dum1 = beta_e_per; dum2 = T_per_2_T_par_e;    
% % %     [Ni,Xedgesi,Yedgesi] = histcounts2(dum1,dum2);
% % %     Ni=Ni(1:end,1:end)';    Xedges2i=Xedgesi(2:end)'; Yedges2i=Yedgesi(2:end)';
% % %     %[Ci,Di]=meshgrid(Xedges2i,Yedges2i);
% % %     Ni(Ni<=no_le)=NaN;
% % %     %Ni_3_0 = Ni; dumnn= (Ni - Ni_3_0)./Di;
% % %     dumnn = Ni ;%./Di; dumnn_2 = sign(dumnn).*log(abs(dumnn));
% % %     hc=pcolor(Xedges2i,Yedges2i,dumnn);
% % %     %hc=contourf(Xedges2i,Yedges2i,dumnn_2,'LineStyle','none');
% % %     hold on
% % %     set(hc,'edgecolor','none');
% % %     set(gca,'ColorScale','log','FontSize',fs)
% % %     set(gca,'XScale','log','YScale','log','FontSize',fs)
% % %     colormap(jet);
% % %     clim([1 1e4]); 
% % %     hcb=colorbar; hcb.Location = 'eastoutside'; 
% % %     hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
% % %     ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% % %     ax.XLabel.String = '$\beta_{\perp,e}/c$'; %ax.XTick = xspace_par;
% % %     ax.YLabel.String = '$T_{\perp,e}/T_{\parallel,e}$'; %ax.YTick = yspace_per;
% % %     %xline(0,'--k'); yline(0,'--k');
% % %     xlim([1e-2,2e1 ]); ylim([0.6, 3]); 
% % %     %title('R1','Interpreter','latex','FontSize',fs');
% % %     pbaspect([1 1 1])
% % %     hold off
% % %     %}
% % %     %----------------------------------------------------------------------
% % % 
% % % end
% % % %--------------------------------------------------------------------------
% % % 
% % % %--------------------------------------------------------------------------
% % % fs=20; 
% % % f12=figure(12)
% % % subplot(2,1,1)
% % % plot(beta_i_par_mean_t(1:end),'r', LineWidth=2)
% % % hold on
% % % plot(beta_i_per_mean_t(1:end),'--r', LineWidth=2)
% % % plot(beta_e_par_mean_t(1:end),'b', LineWidth=2)
% % % plot(beta_e_per_mean_t(1:end),'--b', LineWidth=2)
% % % legend('$\beta_{\parallel,i}$', ...
% % %        '$\beta_{\perp,i}$', ...    
% % %         '$\beta_{\parallel,e}$',...
% % %         '$\beta_{\perp,e}$','Interpreter','latex','FontSize',fs');
% % % %xlabel('time')
% % % hold off
% % % subplot(2,1,2)
% % % plot(T_per_2_T_par_i_mean_t(1:end),'r', LineWidth=2)
% % % hold on
% % % plot(T_per_2_T_par_e_mean_t(1:end),'b', LineWidth=2)
% % % legend('$T_{\perp,i} / T_{\parallel}$','$T_{\perp,e}/T_{\parallel}$','Interpreter','latex','FontSize',fs');
% % % xlabel('time')
% % % hold off
% % % %--------------------------------------------------------------------------
% % % cd(path)
% % % saveas(f12,strcat(num2str(i),'betas_temperatures.png'));
% % % saveas(f21,strcat(num2str(i),'spectrum_B.png'));

% These plots are to check that the vector potencial agrees with the
% magnetic field.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%{
f34=figure(34)
subplot(2,3,1)
dum = real(Ax0(:,96,:));
dum = squeeze(dum);
hc=pcolor(dum)
set(hc,'edgecolor','none')
colorbar
subplot(2,3,2)
dum = real(Ay0(:,96,:));
dum = squeeze(dum);
hc=pcolor(dum)
set(hc,'edgecolor','none')
colorbar
subplot(2,3,3)
dum = real(Az0(:,96,:));
dum = squeeze(dum);
hc=pcolor(dum)
set(hc,'edgecolor','none')
colorbar
subplot(2,3,4)
dum = imag(Ax0(:,96,:));
dum = squeeze(dum);
hc=pcolor(dum)
set(hc,'edgecolor','none')
colorbar
subplot(2,3,5)
dum = imag(Ay0(:,96,:));
dum = squeeze(dum);
hc=pcolor(dum)
set(hc,'edgecolor','none')
colorbar
subplot(2,3,6)
dum = imag(Az0(:,96,:));
dum = squeeze(dum);
hc=pcolor(dum)
set(hc,'edgecolor','none')
colorbar


f35=figure(35)
subplot(2,3,1)
dum = real(Bx_2(:,96,:));
dum = squeeze(dum);
hc=pcolor(dum)
set(hc,'edgecolor','none')
colorbar
subplot(2,3,2)
dum = real(By_2(:,96,:));
dum = squeeze(dum);
hc=pcolor(dum)
set(hc,'edgecolor','none')
colorbar
subplot(2,3,3)
dum = real(Bz_2(:,96,:));
dum = squeeze(dum);
hc=pcolor(dum)
set(hc,'edgecolor','none')
colorbar
subplot(2,3,4)
dum = squeeze(Bx(:,96,:));
hc=pcolor(dum)
set(hc,'edgecolor','none')
colorbar
subplot(2,3,5)
dum = squeeze(By(:,96,:));
hc=pcolor(dum)
set(hc,'edgecolor','none')
colorbar
subplot(2,3,6)
dum = squeeze(Bz(:,96,:));
hc=pcolor(dum)
set(hc,'edgecolor','none')
colorbar
%}