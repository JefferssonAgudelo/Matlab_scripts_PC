%
%-----------------------------------------------------------------------------------------------------------------------
%path = '/Volumes/PSC_DiRAC_DATA/Data_Cirrus/turb_alf_cam_3D';
%path = '/Volumes/PSC_DiRAC_DATA/Data_Cirrus/turb_alf_cam_3D/dvdB';
%path = '/Volumes/PSC_DiRAC_DATA/Data_Cirrus/turb_alf_cam_3D_beta1';

path = '/home/UNN/pfcy6/DATA_CIRRUS/turb_alf_jeff_2D_beta1_test';
%-----------------------------------------------------------------------------------------------------------------------

% For the scripts
%-----------------------------------------------------------------------------------------------------------------------
path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
%-----------------------------------------------------------------------------------------------------------------------

cd(path)
%--------------------------------------------------------------------------

% %load data
% %--------------------------------------------------------------------------
% time1 = load("turb_alf_cam_3D_step_time.txt");
% time2 = load("turb_alf_cam_3D_step_time_2.txt");
% 
% time11 = time1(:,2);
% time22 = time11(end) + time2(:,2);
% 
% f1=figure(1);
% subplot(1,2,1)
% semilogy(time1(:,1),time11/60,'linewidth',2)
% hold on
% semilogy(time2(:,1),time22/60,'linewidth',2)
% xlabel('Step')
% ylabel('Time (min)')
% hold off
% subplot(1,2,2)
% plot(time1(1:end-1,1),(time11(2:end) - time11(1:end-1))/60,'linewidth',2)
% hold on
% plot(time2(1:end-1,1),(time22(2:end) - time22(1:end-1))/60,'linewidth',2)
% xlabel('Step')
% ylabel('Time difference (min)')
% hold off
% %--------------------------------------------------------------------------

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

Vai=0.2;
Vae=0.2;%0.2;
Va=0.2;%0.2;

Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);

mime =100.;
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


for in=1:N
    fileID =  S(in).name; %change the 1 per i
    %h5disp(fileID);
    info = h5info(fileID);
    EHJ_1st = info.Groups(16).Name;
    %%%
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
        v_e{1,i} = (p_e{1,i} .* c ./ sqrt(c^2 .* me^2 + p_e{1,i}.^2)); % Do I need to do this normalization by VA2c
        v_i{1,i} = (p_i{1,i} .* c ./ sqrt(c^2 .* mi^2 + p_i{1,i}.^2));
    end
    clearvars p_i p_e p_i_up p_e_up
    %----------------------------------------------------------------------


    %----------------------------------------------------------------------
    vx = (me.*n_e0.*v_e{1,1} + mi.*n_i0.*v_i{1,1})./(n_i0); 
    vy = (me.*n_e0.*v_e{1,2} + mi.*n_i0.*v_i{1,2})./(n_i0); 
    vz = (me.*n_e0.*v_e{1,3} + mi.*n_i0.*v_i{1,3})./(n_i0); 
    
    vx_mean_t(1,in) = mean(abs(vx),'all');
    vy_mean_t(1,in) = mean(abs(vy),'all');
    vz_mean_t(1,in) = mean(abs(vz),'all');

    cross_hel = (vx.*Bx + vy.*By + vz.*Bz) ./ (vx.^2 + vy.^2 + vz.^2 + Bx.^2 + By.^2 + Bz.^2); 
    cross_hel_mean_t(1,in) = mean(cross_hel,'all');    

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

    %------------------------------------------------------------------
    
    % Perform the FFT of the function f
    %F_Bx = fftn(imgaussfilt3(Bx,2));
    %F_By = fftn(imgaussfilt3(By,2));
    %F_Bz = fftn(imgaussfilt3(Bz-B0,2));

    F_Bx = fftn(Bx);
    F_By = fftn(By);
    F_Bz = fftn(Bz-B0);

    %F_Bx_shift = fftshift(fftshift(fftshift(F_Bx,1),2),3);
    %F_By_shift = fftshift(fftshift(fftshift(F_By,1),2),3);
    %F_Bz_shift = fftshift(fftshift(fftshift(F_Bz,1),2),3);

    Ns=size(F_Bx);

    grid_length = info.Groups(17).Attributes;
    Lx=grid_length(4).Value(1) - grid_length(3).Value(1); %(This is in de The substraction give the total size of the domain) -Lx0 to Lx0
    Ly=grid_length(4).Value(2) - grid_length(3).Value(2);
    Lz=grid_length(4).Value(3) - grid_length(3).Value(3);

    %kx=((0:Ns(1)-1)-Ns(1)/2).*2*pi/Lx; %Includes negative wavenumbers and as it is k_max = pi/resx
    %ky=((0:Ns(2)-1)-Ns(2)/2).*2*pi/Ly;
    %kz=((0:Ns(3)-1)-Ns(3)/2).*2*pi/Lz;

    kx=((0:Ns(1)-1)).*2*pi/Lx; %Includes negative wavenumbers and as it is k_max = pi/resx
    ky=((0:Ns(2)-1)).*2*pi/Ly;
    kz=((0:Ns(3)-1)).*2*pi/Lz;

    resx = Lx/length(Bx(:,1,1)); %in de
    resy = Ly/length(Bx(1,:,1)); %in de
    resz = Lz/length(Bx(1,1,:)); %in de

    [KX, KY, KZ] = meshgrid(kx, ky, kz);
    KK = KX.^2 + KY.^2 + KZ.^2;

    % compute the vector potencial
    F_Ax = (i * KY .* F_Bz - i * KZ .* F_By) ./ KK;
    F_Ay = (i * KZ .* F_Bx - i * KX .* F_Bz) ./ KK;
    F_Az = (i * KX .* F_By - i * KY .* F_Bx) ./ KK;

    F_Bx2 = (i * KY .* F_Az - i * KZ .* F_Ay);
    F_By2 = (i * KZ .* F_Ax - i * KX .* F_Az);
    F_Bz2 = (i * KX .* F_Ay - i * KY .* F_Ax);

    F_Bx2(isnan(F_Bx2))=0;
    F_By2(isnan(F_By2))=0;
    F_Bz2(isnan(F_Bz2))=0;

    % % F_Bx2_ish = ifftshift(ifftshift(ifftshift(F_Bx2,1),2),3);
    % % F_By2_ish = ifftshift(ifftshift(ifftshift(F_By2,1),2),3);
    % % F_Bz2_ish = ifftshift(ifftshift(ifftshift(F_Bz2,1),2),3);
    % % Bx_3 = ifftn(F_Bx2_ish);
    % % By_3 = ifftn(F_By2_ish);
    % % Bz_3 = ifftn(F_Bz2_ish);


     % Compute the spectrums 
    %--------------------------------------------------------------------------
    threshold=pi/resx;

    % Calculate the radial wavenumber k
    K = sqrt(KX.^2 + KY.^2 + KZ.^2);

    % Define the bins for the radial wavenumber
    dk = 2 * pi / Lx; % Bin width in k-space
    k_max = threshold;%max(K(:)); % Maximum wavenumber
    k_bins = 0:dk:k_max; % Radial wavenumber bins

    % Initialize the omnidirectional spectrum
    E_k_1 = zeros(size(k_bins));
    E_k_2 = zeros(size(k_bins));

    % Calculate the energy spectrum
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
    loglog(k_bins(1:end-1), E_k_1(1:end-1), 'LineWidth', 1.5);
    hold on
    loglog(k_bins(1:end-1), E_k_2(1:end-1), 'LineWidth', 1.5);
    title('1D Omnidirectional Spectrum');
    xlabel('k');
    ylabel('E(k)');
    legend('B_{teo}', 'B_{comp}')
    hold off

    f22=figure(22);
    loglog(k_bins(1:end-1), E_k_1(1:end-1)./E_k_2(1:end-1), 'LineWidth', 1.5);
    hold on
    %loglog(k_bins(1:end-1), E_k_2(1:end-1), 'LineWidth', 1.5);
    title('1D Omnidirectional Spectrum');
    xlabel('k');
    ylabel('E(k)');
    legend('B_{teo}/B_{comp}')
    hold off
    %--------------------------------------------------------------------------

    % This is recovering the magnetic field from the vector potential 
    %--------------------------------------------------------------------------
    Bx_3 = ifftn(F_Bx2);
    By_3 = ifftn(F_By2);
    Bz_3 = ifftn(F_Bz2);
    %------------------------------------------------------------------
    
    % The imaginary part is not zero and should be??
    %------------------------------------------------------------------
    f39=figure(39);
    subplot(2,3,1)
    dum = imag(Bx_3(:,96,:));
    dum = squeeze(dum);
    hc=pcolor(dum);
    set(hc,'edgecolor','none')
    colorbar
    climit=max(max(dum));
    clim([-climit, climit]);

    subplot(2,3,2)
    dum = imag(By_3(:,96,:));
    dum = squeeze(dum);
    hc=pcolor(dum);
    set(hc,'edgecolor','none')
    colorbar
    climit=max(max(dum));
    clim([-climit, climit]);

    subplot(2,3,3)
    dum = imag(Bz_3(:,96,:));
    dum = squeeze(dum);
    hc=pcolor(dum);
    set(hc,'edgecolor','none')
    colorbar
    climit=max(max(dum));
    clim([-climit, climit]);

    subplot(2,3,4)
    dum = squeeze(Bx(:,96,:));
    hc=pcolor(dum);
    set(hc,'edgecolor','none')
    colorbar
    climit=max(max(dum));
    clim([-climit, climit]);

    subplot(2,3,5)
    dum = squeeze(By(:,96,:));
    hc=pcolor(dum);
    set(hc,'edgecolor','none')
    colorbar
    climit=max(max(dum));
    clim([-climit, climit]);

    subplot(2,3,6)
    dum = squeeze(Bz(:,96,:)-B0);
    hc=pcolor(dum);
    set(hc,'edgecolor','none')
    colorbar
    climit=max(max(dum));
    clim([-climit, climit]);
    %------------------------------------------------------------------

    % histograms to check the value between the components
    %--------------------------------------------------------------------------
    f36=figure(36);
    subplot(1,3,1)
    dum = imag(Bx_3)./(Bx);
    %1/median(dum,'all')
    histogram(dum,80)
    subplot(1,3,2)
    dum = imag(By_3)./(Bx);
    histogram(dum,80)
    colorbar
    subplot(2,3,3)
    dum = imag(Bz_3)./(Bz);
    histogram(dum,80)
    %--------------------------------------------------------------------------

    % This is to check that ifft(fft(y)) does not alter the amplitude
    %--------------------------------------------------------------------------
    x = linspace(-1,1,100);
    y = 3 * sin(2*pi.*x + pi/2) + 2 * cos(2*pi.*x + pi/2);
    F_y = fft(y);    y2 = ifft(F_y);

    f4=figure(4)
    subplot(1,3,1)
    plot(x,y)
    subplot(1,3,2)
    plot(F_y)
    subplot(1,3,3)
    plot(x,y2)
    %--------------------------------------------------------------------------

    % shifting this here does not work. It messes up the phases
    %{
    % % %Shift the ffts
    % % F_Bx_shift = fftshift(fftshift(fftshift(F_Bx,1),2),3);
    % % F_By_shift = fftshift(fftshift(fftshift(F_By,1),2),3);
    % % F_Bz_shift = fftshift(fftshift(fftshift(F_Bz,1),2),3);
    % % 
    % % F_Ax_s = -(i * KY .* F_Bz_shift - i * KZ .* F_By_shift) ./ KK;
    % % F_Ay_s = -(i * KZ .* F_Bx_shift - i * KX .* F_Bz_shift) ./ KK;
    % % F_Az_s = -(i * KX .* F_By_shift - i * KY .* F_Bx_shift) ./ KK;

    % % % compute the vector potencial    
    % % 
    % % %Get the amplitudes
    % % F_Bx_shift_amp = sqrt(F_Bx_shift .* conj(F_Bx_shift));
    % % F_By_shift_amp = sqrt(F_Bx_shift .* conj(F_Bx_shift));
    % % F_Bz_shift_amp = sqrt(F_Bx_shift .* conj(F_Bx_shift));
    % % 
    % % % using the amplitude only is not correct
    % % F_Ax = (KY.*F_Bz_shift_amp - KZ.*F_By_shift_amp) ./ KK;
    % % F_Ay = (KZ.*F_Bx_shift_amp - KX.*F_Bz_shift_amp) ./ KK;
    % % F_Az = (KX.*F_By_shift_amp - KY.*F_Bx_shift_amp) ./ KK;
    %}

    % get the imaginary part it is the only that is not zero so far and I dont
    % get why that is the case
    % The real part is returning NaNs

    % this is working to remove the nan but introduces an error in the center
    % of the box
    %--------------------------------------------------------------------------

    % This part is important
    %--------------------------------------------------------------------------
    %F_Ax2 = fillmissing(F_Ax, 'nearest');
    %F_Ay2 = fillmissing(F_Ay, 'nearest');
    %F_Az2 = fillmissing(F_Az, 'nearest');

    % F_Ax2(isnan(F_Ax))=0;
    % F_Ay2(isnan(F_Ay))=0;
    % F_Az2(isnan(F_Az))=0;
    %--------------------------------------------------------------------------


    nval = [192 192 192];
    % Compute the inverse of the potential
    % Ax0 = ifftn(F_Ax2, nval);
    % Ay0 = ifftn(F_Ay2, nval);
    % Az0 = ifftn(F_Az2, nval);

    %--------------------------------------------------------------------------
    Ax0 = ifftn(F_Ax2);
    Ay0 = ifftn(F_Ay2);
    Az0 = ifftn(F_Az2);

    [Ax_y, Ax_x, Ax_z] = gradient(real(Ax0));
    [Ay_y, Ay_x, Ay_z] = gradient(real(Ay0));
    [Az_y, Az_x, Az_z] = gradient(real(Az0));

    grad_fact = 1;
    Bx_2 = (Az_y/(grad_fact.*resy)  - Ay_z/(grad_fact.*resz) );
    By_2 = (Ax_z/(grad_fact.*resz)  - Az_x/(grad_fact.*resx) );
    Bz_2 = (Ay_x/(grad_fact.*resx)  - Ax_y/(grad_fact.*resy) ); %% why this has to be a mines???
    %--------------------------------------------------------------------------


    %--------------------------------------------------------------------------    
    f38=figure(38)
    subplot(1,3,1)
    dum = real(Ax0(:,96,:));
    dum = squeeze(dum);
    hc=pcolor(dum)
    set(hc,'edgecolor','none')
    colorbar
    subplot(1,3,2)
    dum = real(Ay0(:,96,:));
    dum = squeeze(dum);
    hc=pcolor(dum)
    set(hc,'edgecolor','none')
    colorbar
    subplot(1,3,3)
    dum = real(Az0(:,96,:));
    dum = squeeze(dum);
    hc=pcolor(dum)
    set(hc,'edgecolor','none')
    colorbar

    f37=figure(37)
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
    %--------------------------------------------------------------------------

 

    %--------------------------------------------------------------------------
    %{
    % % Ax0_shift = fftshift(fftshift(fftshift(Ax0,1),2),3);
    % % Ay0_shift = fftshift(fftshift(fftshift(Ay0,1),2),3);
    % % Az0_shift = fftshift(fftshift(fftshift(Az0,1),2),3);
    % %
    % % Ax_sh = abs(Ax0_shift);
    % % Ay_sh = abs(Ay0_shift);
    % % Az_sh = abs(Az0_shift);
    % %
    % % [Ax_sh_y, Ax_sh_x, Ax_sh_z] = gradient(Ax_sh);
    % % [Ay_sh_y, Ay_sh_x, Ay_sh_z] = gradient(Ay_sh);
    % % [Az_sh_y, Az_sh_x, Az_sh_z] = gradient(Az_sh);
    % %
    % % Bx_sh_2 = Az_sh_y - Ay_sh_z;

        % % Ax0_s = ifftn(F_Ax2_s, nval);
    % % Ay0_s = ifftn(F_Ay2_s, nval);
    % % Az0_s = ifftn(F_Az2_s, nval);

    % % Ax = abs(Ax0);
    % % Ay = abs(Ay0);
    % % Az = abs(Az0);
    %}
    %--------------------------------------------------------------------------

    % Now this is to compute the magnetic helicity
    %--------------------------------------------------------------------------
    Hm_1 = real(Ax0).*Bx + real(Ay0).*By + real(Az0).*Bz;
    Hm_2 = real(Ax0).*Bx_2 + real(Ay0).*By_2 + real(Az0).*Bz_2;

    HM_1_t(1,in) = sum(Hm_1,'all').*resx*resy*resz;
    HM_2_t(1,in) = sum(Hm_2,'all').*resx*resy*resz;
    %--------------------------------------------------------------------------
end
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% Initial diagnostic plot 
%--------------------------------------------------------------------------
%
% magnetic components <|Bx|>, <|By|>, <|Bz|>,  
f1=figure(1)
subplot(3,2,1)
plot(Bx_mean_t(1:end),'r', LineWidth=2)
hold on
plot(By_mean_t(1:end),'g', LineWidth=2)
plot(Bz_mean_t(1:end),'b', LineWidth=2)
plot(B_mag_mean_t(1:end),'k', LineWidth=2)
legend('|dBx|','|dBy|','|dBz|','|dB|')
ylabel('|dB|')
hold off

% |dB|/B0
subplot(3,2,2)
plot(B_mag_mean_t(1:end)/0.1,'k', LineWidth=2)
ylabel('|dB|/B0')
%xlabel('time')

% |dBz2|/|dB2|
subplot(3,2,3)
plot(Bz_2_mean_t(1:end)./B_2_mag_mean_t(1:end),'k', LineWidth=2)
ylabel('|dBz|^2/|dB|^2')
%xlabel('time')

% velocity components <|vx|>, <|vy|>, <|vz|>,  
subplot(3,2,4)
plot(vx_mean_t(1:end),'r', LineWidth=2)
hold on
plot(vy_mean_t(1:end),'g', LineWidth=2)
plot(vz_mean_t(1:end),'b', LineWidth=2)
legend('|dv_x|','|dv_y|','|dv_z|')
ylabel('|dv|')
hold off

% Normalised cross helicity
subplot(3,2,5)
plot(cross_hel_mean_t(1:end),'k', LineWidth=2)
ylabel('v.B/(v^2 + B^2)')
xlabel('time')

subplot(3,2,6)
semilogy(abs(HM_1_t(1:end)),'r', LineWidth=2)
hold on
semilogy(abs(HM_2_t(1:end)),'b', LineWidth=2)
ylabel('Hm')
xlabel('time')
legend('|\int A \cdot B dV|','|\int A \cdot \nabla \times A dV|')
hold off
%--------------------------------------------------------------------------
cd(path)
saveas(f1,strcat(num2str(i),'initial_diagnostic.png'));
%--------------------------------------------------------------------------

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



% To compute beta and the temperature anisotropies 
%--------------------------------------------------------------------------
beta_i_par_mean_t= zeros(1,N);
beta_e_par_mean_t= zeros(1,N);
beta_i_per_mean_t= zeros(1,N);
beta_e_per_mean_t= zeros(1,N);
T_per_2_T_par_i_mean_t= zeros(1,N);
T_per_2_T_par_e_mean_t= zeros(1,N);
in=1;
for in=1:N
    in=1
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
        v_e{1,i} = (p_e{1,i} .* c ./ sqrt(c^2 .* me^2 + p_e{1,i}.^2)); % Do I need to do this normalization by VA2c
        v_i{1,i} = (p_i{1,i} .* c ./ sqrt(c^2 .* mi^2 + p_i{1,i}.^2));
    end
    clearvars p_i p_e p_i_up p_e_up
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    Pij_e{1,1}=h5read(fileID2,strcat(moments_1st,'/txx_e/p0/3d'));
    Pij_e{2,2}=h5read(fileID2,strcat(moments_1st,'/tyy_e/p0/3d'));
    Pij_e{3,3}=h5read(fileID2,strcat(moments_1st,'/tzz_e/p0/3d'));
    Pij_e{1,2}=h5read(fileID2,strcat(moments_1st,'/txy_e/p0/3d'));
    Pij_e{1,3}=h5read(fileID2,strcat(moments_1st,'/tzx_e/p0/3d'));
    Pij_e{2,3}=h5read(fileID2,strcat(moments_1st,'/tyz_e/p0/3d'));
    Pij_e{2,1} = Pij_e{1,2}; Pij_e{3,2} = Pij_e{2,3}; Pij_e{3,1} = Pij_e{1,3};

    Pij_i{1,1}=h5read(fileID2,strcat(moments_1st,'/txx_i/p0/3d'));
    Pij_i{2,2}=h5read(fileID2,strcat(moments_1st,'/tyy_i/p0/3d'));
    Pij_i{3,3}=h5read(fileID2,strcat(moments_1st,'/tzz_i/p0/3d'));
    Pij_i{1,2}=h5read(fileID2,strcat(moments_1st,'/txy_i/p0/3d'));
    Pij_i{1,3}=h5read(fileID2,strcat(moments_1st,'/tzx_i/p0/3d'));
    Pij_i{2,3}=h5read(fileID2,strcat(moments_1st,'/tyz_i/p0/3d'));
    Pij_i{2,1} = Pij_i{1,2}; Pij_i{3,2} = Pij_i{2,3}; Pij_i{3,1} = Pij_i{1,3};
    %----------------------------------------------------------------------

    % Add this line to all the other analysis with the pressure to correct
    % for the mass
    %----------------------------------------------------------------------
    for i=1:3
        for j=1:3
            Pij_i{i,j} = mi.*Pij_i{i,j};
            Pij_e{i,j} = me.*Pij_e{i,j};
        end
    end
    %----------------------------------------------------------------------

    % This is to get the central momment pressure.
    %----------------------------------------------------------------------
    PPij_i=cell(3,3);
    PPij_e=cell(3,3);

    for i=1:3
        for j=1:3
            if(isempty(Pij_i{i,j}) == 1) % This is where if P_ba is zero, this should be changed.
                continue
            end
            PPij_i{i,j} = Pij_i{i,j} - 1.*n_i0.*mi.*v_i{1,i}.*v_i{1,j};
            PPij_e{i,j} = Pij_e{i,j} - 1.*n_e0.*me.*v_e{1,i}.*v_e{1,j};
        end
    end

    B_2_mag = Bx.^2 + By.^2 + Bz.^2;

    %--------------------------------------------------------------------------
    % checking the distributions
    %--------------------------------------------------------------------------
    f1=figure(1)
        subplot(2,2,1)
    histogram(2*(Pij_i{1,1}+Pij_i{2,2}+Pij_i{3,3})./(3.*B_2_mag)) 
    title('\beta_{i}'); hold on; xline(10,'-r', LineWidth=2); hold off
        subplot(2,2,2)
    histogram(2*(Pij_e{1,1}+Pij_e{2,2}+Pij_e{3,3})./(3.*B_2_mag)) 
    title('\beta_{e}'); hold on; xline(1,'-r', LineWidth=2); hold off
        subplot(2,2,3)
    histogram(2*(PPij_i{1,1}+PPij_i{2,2}+PPij_i{3,3})./(3.*B_2_mag)) 
        title('\beta_{i,th}'); hold on; xline(10,'-r', LineWidth=2); hold off
        subplot(2,2,4)
    histogram(2*(PPij_e{1,1}+PPij_e{2,2}+PPij_e{3,3})./(3.*B_2_mag)) 
        title('\beta_{e,th}'); hold on; xline(1,'-r', LineWidth=2); hold off

    %--------------------------------------------------------------------------
    %--------------------------------------------------------------------------

    % remove the variables just to rename them again
    clearvars Pij_i Pij_e

    % This is just to rename the variable
    Pij_i = PPij_i;
    Pij_e = PPij_e;

    clearvars PPij_i PPij_e
    %----------------------------------------------------------------------


    % This is for the coordinate transformation to compute the parallel and
    % perpendicular temperatures
    %----------------------------------------------------------------------
    B_2_mag = Bx.^2 + By.^2 + Bz.^2;
    B_mag = sqrt(Bx.^2 + By.^2 + Bz.^2);
    B_2_mag_mean_t(1,in) = mean(B_2_mag,'all');

    b_n{1,1} = Bx./B_mag; 
    b_n{1,2} = By./B_mag; 
    b_n{1,3} = Bz./B_mag;

    bb_n=cell(3,3);
    for i=1:3
        for j=1:3           
            bb_n{i,j} = b_n{1,i}.*b_n{1,j};            
        end
    end

    dum_0 = zeros(size(Bx));
    dum_1 = zeros(size(Bx));

    for i=1:3
        for j=1:3
            Tij_par_i = (Pij_i{i,j}./n_i0).*bb_n{i,j} + dum_0;
            dum_0 = Tij_par_i;

            Tij_par_e = (Pij_e{i,j}./n_e0).*bb_n{i,j} + dum_1;
            dum_1 = Tij_par_e;
        end
    end

    Tij_per_i_v = cell(3,3);
    Tij_per_e_v = cell(3,3);

    for i=1:3
        for j=1:3
            if(i==j)
            Tij_per_i_v{i,j} = (Pij_i{i,j}./n_i0).*(1 - bb_n{i,j})/2 ;
            Tij_per_e_v{i,j} = (Pij_e{i,j}./n_e0).*(1 - bb_n{i,j})/2 ;
            else
            Tij_per_i_v{i,j} = (Pij_i{i,j}./n_i0).*(0 - bb_n{i,j})/2 ;
            Tij_per_e_v{i,j} = (Pij_e{i,j}./n_e0).*(0 - bb_n{i,j})/2 ;            
            end
        end
    end

    dum_0 = zeros(size(Bx));
    dum_1 = zeros(size(Bx));

    for i=1:3
        for j=1:3
            Tij_per_i = Tij_per_i_v{i,j} + dum_0;
            dum_0 = Tij_per_i;
            Tij_per_e = Tij_per_e_v{i,j} + dum_1;
            dum_1 = Tij_per_e;
        end
    end
    %----------------------------------------------------------------------

    %Now compute the value of each beta
    %----------------------------------------------------------------------
    beta_i_par = 2.* Tij_par_i.* n_i0 ./ B_2_mag;
    beta_e_par = 2.* Tij_par_e.* n_i0 ./ B_2_mag;

    beta_i_per = 2.* Tij_per_i.* n_i0 ./ B_2_mag;
    beta_e_per = 2.* Tij_per_e.* n_i0 ./ B_2_mag;

    T_per_2_T_par_i = Tij_per_i ./ Tij_par_i;
    T_per_2_T_par_e = Tij_per_e ./ Tij_par_e;    

    beta_i_par_mean_t(1,in) = mean(beta_i_par,'all');
    beta_e_par_mean_t(1,in) = mean(beta_e_par,'all'); 
    beta_i_per_mean_t(1,in) = mean(beta_i_per,'all');
    beta_e_per_mean_t(1,in) = mean(beta_e_per,'all');    
    T_per_2_T_par_i_mean_t(1,in) = mean(T_per_2_T_par_i,'all');
    T_per_2_T_par_e_mean_t(1,in) = mean(T_per_2_T_par_e,'all');    
    %----------------------------------------------------------------------

    % make a scatter plot 
    %----------------------------------------------------------------------

    % This is the plot T_perp/T_par  beta_par also per and for i and e
    %{
    %----------------------------------------------------------------------   
    [N_TY_i,Xedges_i,Yedges_i] = histcounts2(beta_i_par,T_per_2_T_par_i);
    [N_TY_e,Xedges_e,Yedges_e] = histcounts2(beta_e_par,T_per_2_T_par_e);    
    %---------------------------------------------------------------------- 
    fs=18;  x0=45;  y0=54;  xx1=1000;    yy1=300;
    no_le=1;
    %----------------------------------------------------------------------
    f14=figure(14);
    %set(gcf,'position',[x0,y0,xx1,yy1])
    subplot(2,2,1)
    dum1 = beta_i_par; dum2 = T_per_2_T_par_i;    
    [Ni,Xedgesi,Yedgesi] = histcounts2(dum1,dum2);
    Ni=Ni(1:end,1:end)';    Xedges2i=Xedgesi(2:end)'; Yedges2i=Yedgesi(2:end)';
    %[Ci,Di]=meshgrid(Xedges2i,Yedges2i);
    Ni(Ni<=no_le)=NaN;
    %Ni_3_0 = Ni; dumnn= (Ni - Ni_3_0)./Di;
    dumnn = Ni ;%./Di; dumnn_2 = sign(dumnn).*log(abs(dumnn));
    hc=pcolor(Xedges2i,Yedges2i,dumnn);
    %hc=contourf(Xedges2i,Yedges2i,dumnn_2,'LineStyle','none');
    hold on
    set(hc,'edgecolor','none');
    set(gca,'ColorScale','log','FontSize',fs)
    set(gca,'XScale','log','YScale','log','FontSize',fs)
    colormap(jet);
    clim([1 1e4]); 
    hcb=colorbar; hcb.Location = 'eastoutside'; 
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.XLabel.String = '$\beta_{\parallel,i}/c$'; %ax.XTick = xspace_par;
    ax.YLabel.String = '$T_{\perp,i}/T_{\parallel,i}$'; %ax.YTick = yspace_per;
    %xline(0,'--k'); yline(0,'--k');
    xlim([1e-2,2e1 ]); ylim([0.6, 3]); 
    %title('R1','Interpreter','latex','FontSize',fs');
    pbaspect([1 1 1])
    hold off
    %----------------------------------------------------------------------
    subplot(2,2,2)
    dum1 = beta_e_par; dum2 = T_per_2_T_par_e;    
    [Ni,Xedgesi,Yedgesi] = histcounts2(dum1,dum2);
    Ni=Ni(1:end,1:end)';    Xedges2i=Xedgesi(2:end)'; Yedges2i=Yedgesi(2:end)';
    %[Ci,Di]=meshgrid(Xedges2i,Yedges2i);
    Ni(Ni<=no_le)=NaN;
    %Ni_3_0 = Ni; dumnn= (Ni - Ni_3_0)./Di;
    dumnn = Ni ;%./Di; dumnn_2 = sign(dumnn).*log(abs(dumnn));
    hc=pcolor(Xedges2i,Yedges2i,dumnn);
    %hc=contourf(Xedges2i,Yedges2i,dumnn_2,'LineStyle','none');
    hold on
    set(hc,'edgecolor','none');
    set(gca,'ColorScale','log','FontSize',fs)
    set(gca,'XScale','log','YScale','log','FontSize',fs)
    colormap(jet);
    clim([1 1e4]); 
    hcb=colorbar; hcb.Location = 'eastoutside'; 
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.XLabel.String = '$\beta_{\parallel,e}/c$'; %ax.XTick = xspace_par;
    ax.YLabel.String = '$T_{\perp,e}/T_{\parallel,e}$'; %ax.YTick = yspace_per;
    %xline(0,'--k'); yline(0,'--k');
    xlim([1e-2,2e1 ]); ylim([0.6, 3]); 
    %title('R1','Interpreter','latex','FontSize',fs');
    pbaspect([1 1 1])
    hold off
    %----------------------------------------------------------------------
    subplot(2,2,3)
    dum1 = beta_i_per; dum2 = T_per_2_T_par_i;    
    [Ni,Xedgesi,Yedgesi] = histcounts2(dum1,dum2);
    Ni=Ni(1:end,1:end)';    Xedges2i=Xedgesi(2:end)'; Yedges2i=Yedgesi(2:end)';
    %[Ci,Di]=meshgrid(Xedges2i,Yedges2i);
    Ni(Ni<=no_le)=NaN;
    %Ni_3_0 = Ni; dumnn= (Ni - Ni_3_0)./Di;
    dumnn = Ni ;%./Di; dumnn_2 = sign(dumnn).*log(abs(dumnn));
    hc=pcolor(Xedges2i,Yedges2i,dumnn);
    %hc=contourf(Xedges2i,Yedges2i,dumnn_2,'LineStyle','none');
    hold on
    set(hc,'edgecolor','none');
    set(gca,'ColorScale','log','FontSize',fs)
    set(gca,'XScale','log','YScale','log','FontSize',fs)
    colormap(jet);
    clim([1 1e4]); 
    hcb=colorbar; hcb.Location = 'eastoutside'; 
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.XLabel.String = '$\beta_{\perp,i}/c$'; %ax.XTick = xspace_par;
    ax.YLabel.String = '$T_{\perp,i}/T_{\parallel,i}$'; %ax.YTick = yspace_per;
    %xline(0,'--k'); yline(0,'--k');
    xlim([1e-2,2e1 ]); ylim([0.6, 3]); 
    %title('R1','Interpreter','latex','FontSize',fs');
    pbaspect([1 1 1])
    hold off
    %----------------------------------------------------------------------
    subplot(2,2,4)
    dum1 = beta_e_per; dum2 = T_per_2_T_par_e;    
    [Ni,Xedgesi,Yedgesi] = histcounts2(dum1,dum2);
    Ni=Ni(1:end,1:end)';    Xedges2i=Xedgesi(2:end)'; Yedges2i=Yedgesi(2:end)';
    %[Ci,Di]=meshgrid(Xedges2i,Yedges2i);
    Ni(Ni<=no_le)=NaN;
    %Ni_3_0 = Ni; dumnn= (Ni - Ni_3_0)./Di;
    dumnn = Ni ;%./Di; dumnn_2 = sign(dumnn).*log(abs(dumnn));
    hc=pcolor(Xedges2i,Yedges2i,dumnn);
    %hc=contourf(Xedges2i,Yedges2i,dumnn_2,'LineStyle','none');
    hold on
    set(hc,'edgecolor','none');
    set(gca,'ColorScale','log','FontSize',fs)
    set(gca,'XScale','log','YScale','log','FontSize',fs)
    colormap(jet);
    clim([1 1e4]); 
    hcb=colorbar; hcb.Location = 'eastoutside'; 
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.XLabel.String = '$\beta_{\perp,e}/c$'; %ax.XTick = xspace_par;
    ax.YLabel.String = '$T_{\perp,e}/T_{\parallel,e}$'; %ax.YTick = yspace_per;
    %xline(0,'--k'); yline(0,'--k');
    xlim([1e-2,2e1 ]); ylim([0.6, 3]); 
    %title('R1','Interpreter','latex','FontSize',fs');
    pbaspect([1 1 1])
    hold off
    %}
    %----------------------------------------------------------------------

end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
fs=20;
f12=figure(12)
subplot(2,1,1)
plot(beta_i_par_mean_t(1:end),'r', LineWidth=2)
hold on
plot(beta_i_per_mean_t(1:end),'--r', LineWidth=2)
plot(beta_e_par_mean_t(1:end),'b', LineWidth=2)
plot(beta_e_per_mean_t(1:end),'--b', LineWidth=2)
legend('$\beta_{\parallel,i}$', ...
       '$\beta_{\perp,i}$', ...    
        '$\beta_{\parallel,e}$',...
        '$\beta_{\perp,e}$','Interpreter','latex','FontSize',fs');
%xlabel('time')
hold off
subplot(2,1,2)
plot(T_per_2_T_par_i_mean_t(1:end),'r', LineWidth=2)
hold on
plot(T_per_2_T_par_e_mean_t(1:end),'b', LineWidth=2)
legend('$T_{\perp,i} / T_{\parallel}$','$T_{\perp,e}/T_{\parallel}$','Interpreter','latex','FontSize',fs');
xlabel('time')
hold off
%--------------------------------------------------------------------------
cd(path)
saveas(f12,strcat(num2str(i),'betas_temperatures.png'));

% These plots are to check that the vector potencial agrees with the
% magnetic field.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%
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
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% electric current 
%--------------------------------------------------------------------------
%{
%--------------------------------------------------------------------------
Jx_mean_t = zeros(1,N);
Jy_mean_t = zeros(1,N);
Jz_mean_t = zeros(1,N);
Jx_2_mean_t = zeros(1,N);
Jy_2_mean_t = zeros(1,N);
Jz_2_mean_t = zeros(1,N);

J_mag_mean_t = zeros(1,N);
J_2_mag_mean_t = zeros(1,N);

for in=1:N
    fileID =  S(in).name; %change the 1 per i
    %h5disp(fileID);
    info = h5info(fileID);
    EHJ_1st = info.Groups(16).Name;
    %%%
    Jx=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'));
    Jy=h5read(fileID,strcat(EHJ_1st,'/jy_ec/p0/3d'));
    Jz=h5read(fileID,strcat(EHJ_1st,'/jz_ec/p0/3d'));

    J_mag = sqrt(Jx.^2 + Jy.^2 + Jz.^2);
    J_2_mag = sqrt(Jx.^2 + Jy.^2 + Jz.^2);
    
    J_mag_mean_t(1,in)= mean(J_mag,'all');
    J_2_mag_mean_t(1,in)= mean(J_2_mag,'all');

    Jx_mean_t(1,in) = mean(abs(Jx),'all');
    Jy_mean_t(1,in) = mean(abs(Jy),'all');
    Jz_mean_t(1,in) = mean(abs(Jz),'all');

    Jx_2_mean_t(1,in) = mean(Jx.^2,'all');
    Jy_2_mean_t(1,in) = mean(Jy.^2,'all');
    Jz_2_mean_t(1,in) = mean(Jz.^2,'all');


    J_mag_mean_t(1,in) = J_mag_mean;
    disp(in)

end
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
f2=figure(2)
plot(Jx_mean_t(1:end),'r', LineWidth=2)
hold on
plot(Jy_mean_t(1:end),'g', LineWidth=2)
plot(Jz_mean_t(1:end),'b', LineWidth=2)
plot(J_mag_mean_t(1:end),'k', LineWidth=2)
hold off
%--------------------------------------------------------------------------
%}
%--------------------------------------------------------------------------

%}
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
