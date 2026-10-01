% Just to run the spectra

fs=20;
threshold = pi/resx;
Bx_pri = Bx_dt -Bx_filt;
%----------------------------------------------------------------------


% This is to get the 1D omni spectra
%----------------------------------------------------------------------
[E_k_B_x,~]=Omni1DSpectra(Bx_dt,Lx,threshold);
%[E_k_B_y,~]=Omni1DSpectra(By_dt,Lx,threshold);
%[E_k_B_z,~]=Omni1DSpectra(Bz_dt,Lx,threshold);

[E_k_B_x_filt,~]=Omni1DSpectra(Bx_filt,Lx,threshold);
%[E_k_B_y_filt,~]=Omni1DSpectra(By_filt,Lx,threshold);
%[E_k_B_z_filt,~]=Omni1DSpectra(Bz_filt,Lx,threshold);

[E_k_B_x_pri,k_bins]=Omni1DSpectra(Bx_pri,Lx,threshold);
%[E_k_B_y_pri,~]=Omni1DSpectra(By_pri,Lx,threshold);
%[E_k_B_z_pri,k_bins]=Omni1DSpectra(Bz_pri,Lx,threshold);
%----------------------------------------------------------------------

%{
%----------------------------------------------------------------------
% This is to get the 1D omni spectra
%----------------------------------------------------------------------
[E_k_tau_v_x_B_tau_x,~]=Omni1DSpectra(tau_v_x_B_tau_x,Lx,threshold);
[E_k_tau_nE_tau_x,~]=Omni1DSpectra(tau_nE_tau_x,Lx,threshold);
[E_k_tau_J_x_B_tau_x,~]=Omni1DSpectra(tau_J_x_B_tau_x,Lx,threshold);
[E_k_tau_Div_tau1_x,~]=Omni1DSpectra(tau_Div_tau1_x,Lx,threshold);

[E_k_term1_dt,~]=Omni1DSpectra(term1_dt,Lx,threshold);
[E_k_term2_dt,~]=Omni1DSpectra(term2_dt,Lx,threshold);
[E_k_term3_dt,~]=Omni1DSpectra(term3_dt,Lx,threshold);
[E_k_term4_dt,~]=Omni1DSpectra(term4_dt,Lx,threshold);
[E_k_term5_dt,~]=Omni1DSpectra(term5_dt,Lx,threshold);

term2to5_dt = -term2_dt +term3_dt -term4_dt + term5_dt;
term2to5_filt = -term2_filt +term3_filt -term4_filt + term5_filt;

[E_k_term2to5_dt,~]=Omni1DSpectra(term2to5_dt,Lx,threshold);
[E_k_term2to5_filt,~]=Omni1DSpectra(term2to5_filt,Lx,threshold);

[E_k_term1_filt,~]=Omni1DSpectra(term1_filt,Lx,threshold);
[E_k_term2_filt,~]=Omni1DSpectra(term2_filt,Lx,threshold);
[E_k_term3_filt,~]=Omni1DSpectra(term3_filt,Lx,threshold);
[E_k_term4_filt,~]=Omni1DSpectra(term4_filt,Lx,threshold);
[E_k_term5_filt,k_bins]=Omni1DSpectra(term5_filt,Lx,threshold);
%----------------------------------------------------------------------
%
%----------------------------------------------------------------------
% This is to get the 2D spectra of the different terms withouth filtering
%----------------------------------------------------------------------
[P2D_term1_dt,~]=Power_of_filtering_kernel(term1_dt,Lx,Ly,Lz);
[P2D_term2_dt,~]=Power_of_filtering_kernel(term2_dt,Lx,Ly,Lz);
[P2D_term3_dt,~]=Power_of_filtering_kernel(term3_dt,Lx,Ly,Lz);
[P2D_term4_dt,~]=Power_of_filtering_kernel(term4_dt,Lx,Ly,Lz);
[P2D_term5_dt,~]=Power_of_filtering_kernel(term5_dt,Lx,Ly,Lz);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
% This is to get the 2D spectra of the different terms withouth filtering
%----------------------------------------------------------------------
[P2D_term1_filt,~]=Power_of_filtering_kernel(term1_filt,Lx,Ly,Lz);
[P2D_term2_filt,~]=Power_of_filtering_kernel(term2_filt,Lx,Ly,Lz);
[P2D_term3_filt,~]=Power_of_filtering_kernel(term3_filt,Lx,Ly,Lz);
[P2D_term4_filt,~]=Power_of_filtering_kernel(term4_filt,Lx,Ly,Lz);
[P2D_term5_filt,kpar,kper,kz]=Power_of_filtering_kernel(term5_filt,Lx,Ly,Lz);
%}
%----------------------------------------------------------------------
%%[KPAR,KPER] = meshgrid(kpar,kper);
%----------------------------------------------------------------------

% This is to get the perpendicular reduced spectrum
%----------------------------------------------------------------------
%{
[P1Dper_term1_dt,P1Dpar_term1_dt]=Compute1DSpectra(P2D_term1_dt,kper,threshold);
[P1Dper_term2_dt,P1Dpar_term2_dt]=Compute1DSpectra(P2D_term2_dt,kper,threshold);
[P1Dper_term3_dt,P1Dpar_term3_dt]=Compute1DSpectra(P2D_term3_dt,kper,threshold);
[P1Dper_term4_dt,P1Dpar_term4_dt]=Compute1DSpectra(P2D_term4_dt,kper,threshold);
[P1Dper_term5_dt,P1Dpar_term5_dt]=Compute1DSpectra(P2D_term5_dt,kper,threshold);

[P1Dper_term1_filt,P1Dpar_term1_filt]=Compute1DSpectra(P2D_term1_filt,kper,threshold);
[P1Dper_term2_filt,P1Dpar_term2_filt]=Compute1DSpectra(P2D_term2_filt,kper,threshold);
[P1Dper_term3_filt,P1Dpar_term3_filt]=Compute1DSpectra(P2D_term3_filt,kper,threshold);
[P1Dper_term4_filt,P1Dpar_term4_filt]=Compute1DSpectra(P2D_term4_filt,kper,threshold);
[P1Dper_term5_filt,P1Dpar_term5_filt]=Compute1DSpectra(P2D_term5_filt,kper,threshold);
%----------------------------------------------------------------------
%}
%%

fs=20; x0=45;y0=54;xx1=1200;yy1=500;
%--------------------------------------------------------------------------
f21=figure(21);
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(1,3,1)
%----------------------------------------------------------------------
loglog(k_bins(1:end-1), E_k_B_x(1:end-1),'r-','LineWidth',2)
hold on
dumm = E_k_B_x_filt + E_k_B_x_pri;
loglog(k_bins(1:end-1), dumm(1:end-1),'r--','LineWidth',2)
set(gca,'FontSize',fs)
%set(gca,'XScale','lin','YScale','log','FontSize',fs)
y1=get(gca,'ylim');
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = [1,10]; %ax.YTick = [];
ax.XLabel.String = '$k d_i$';
ax.YLabel.String = '$P_{1D} \ unfiltered$';

legend('$B_{x}$'...
    ,'$\overline{B}_{x} + B_{x}^{l}$', ...
    'Interpreter','latex','NumColumns',1,'Location','southwest')
xlim([k_bins(2) threshold]);
ylim([10^(-8) 10^(15)]);
%----------------------------------------------------------------------
subplot(1,3,2)
%----------------------------------------------------------------------
loglog(k_bins(1:end-1), E_k_B_x_filt(1:end-1),'r-','LineWidth',2)
hold on
set(gca,'FontSize',fs)
%set(gca,'XScale','lin','YScale','log','FontSize',fs)
y1=get(gca,'ylim');
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = [1,10]; %ax.YTick = [];
ax.XLabel.String = '$k d_i$';
ax.YLabel.String = '$P_{1D} \ filtered$';
legend('$\overline{B}_{x}$','Interpreter','latex','NumColumns',1,'Location','southwest')
xlim([k_bins(2) threshold]);
ylim([10^(-8) 10^(15)]);
%----------------------------------------------------------------------
subplot(1,3,3)
%----------------------------------------------------------------------
loglog(k_bins(1:end-1), E_k_B_x_pri(1:end-1),'r-','LineWidth',2)
hold on
set(gca,'FontSize',fs)
%set(gca,'XScale','lin','YScale','log','FontSize',fs)
y1=get(gca,'ylim');
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = [1,10]; %ax.YTick = [];
ax.XLabel.String = '$k d_i$';
ax.YLabel.String = '$P_{1D} \ unresolved$';
legend('$B_{x}^{l}$','Interpreter','latex','NumColumns',1,'Location','southwest')
xlim([k_bins(2) threshold]);
ylim([10^(-8) 10^(15)]);
%-------------------------------------

%plots magnetic field components

fs=20; x0=45;y0=54;xx1=1200;yy1=500;
%--------------------------------------------------------------------------
f21=figure(21);
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(1,3,1)
%----------------------------------------------------------------------
loglog(k_bins(1:end-1), E_k_B_x(1:end-1),'r-','LineWidth',2)
hold on
loglog(k_bins(1:end-1), E_k_B_y(1:end-1),'b-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_B_z(1:end-1),'g-','LineWidth',2)
dumm = E_k_B_x_filt + E_k_B_x_pri;
loglog(k_bins(1:end-1), dumm(1:end-1),'r--','LineWidth',2)
dumm = E_k_B_y_filt + E_k_B_y_pri;
loglog(k_bins(1:end-1), dumm(1:end-1),'b--','LineWidth',2)
dumm = E_k_B_z_filt + E_k_B_z_pri;
loglog(k_bins(1:end-1), dumm(1:end-1),'g--','LineWidth',2)
set(gca,'FontSize',fs)
%set(gca,'XScale','lin','YScale','log','FontSize',fs)
y1=get(gca,'ylim');
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = [1,10]; %ax.YTick = [];
ax.XLabel.String = '$k d_i$';
ax.YLabel.String = '$P_{1D} \ unfiltered$';
%legend(legends_x ,'Interpreter','latex','NumColumns',1,'Location','southwest')
legend('$B_{x}$','$B_{y}$','$B_{z}$',...
    '$\overline{B}_{x} + B_{x}^{l}$', ...
    '$\overline{B}_{y} + B_{y}^{l}$', ...
    '$\overline{B}_{z} + B_{z}^{l}$','Interpreter','latex','NumColumns',1,'Location','southwest')
xlim([k_bins(2) threshold]);
ylim([10^(-8) 10^(15)]);
%----------------------------------------------------------------------
subplot(1,3,2)
%----------------------------------------------------------------------
loglog(k_bins(1:end-1), E_k_B_x_filt(1:end-1),'r-','LineWidth',2)
hold on
loglog(k_bins(1:end-1), E_k_B_y_filt(1:end-1),'b-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_B_z_filt(1:end-1),'g-','LineWidth',2)
set(gca,'FontSize',fs)
%set(gca,'XScale','lin','YScale','log','FontSize',fs)
y1=get(gca,'ylim');
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = [1,10]; %ax.YTick = [];
ax.XLabel.String = '$k d_i$';
ax.YLabel.String = '$P_{1D} \ filtered$';
%legend(legends_x ,'Interpreter','latex','NumColumns',1,'Location','southwest')
legend('$\overline{B}_{x}$','$\overline{B}_{y}$','$\overline{B}_{z}$','Interpreter','latex','NumColumns',1,'Location','southwest')
xlim([k_bins(2) threshold]);
ylim([10^(-8) 10^(15)]);
%----------------------------------------------------------------------
subplot(1,3,3)
%----------------------------------------------------------------------
loglog(k_bins(1:end-1), E_k_B_x_pri(1:end-1),'r-','LineWidth',2)
hold on
loglog(k_bins(1:end-1), E_k_B_y_pri(1:end-1),'b-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_B_z_pri(1:end-1),'g-','LineWidth',2)
set(gca,'FontSize',fs)
%set(gca,'XScale','lin','YScale','log','FontSize',fs)
y1=get(gca,'ylim');
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = [1,10]; %ax.YTick = [];
ax.XLabel.String = '$k d_i$';
ax.YLabel.String = '$P_{1D} \ unresolved$';
%legend(legends_x ,'Interpreter','latex','NumColumns',1,'Location','southwest')
legend('$B_{x}^{l}$','$B_{y}^{l}$','$B_{z}^{l}$','Interpreter','latex','NumColumns',1,'Location','southwest')
xlim([k_bins(2) threshold]);
ylim([10^(-8) 10^(15)]);
%----------------------------------------------------------------------
%saveas(f21,strcat(num2str(component),'Omni_spectra_E.png'));

%saveas(f21,strcat(num2str(component),'Omni_spectra_BxByBz_2.png'));

%%%
% Defining the functions to use in this script
%----------------------------------------------------------------------

% Funtion to make the filtering
%----------------------------------------------------------------------
function [convolution_result]=Filtering_kernel(var,l_wind_x)
%----------------------------------------------------------------------
% The inputs are the variable, the fourier transform of the kernel and
% the output is the filted signal
% These four lines are the filtering

%----------------------------------------------------------------------
% Perform the FFT of the function f
F_var = fftn(var);
F_var = fftshift(fftshift(fftshift(F_var,1),2),3);

% Convolve in the frequency domain (element-wise multiplication)
l_wind_x = fftshift(fftshift(fftshift(l_wind_x,1),2),3);
F_convolution = F_var .* l_wind_x;
F_convolution = fftshift(fftshift(fftshift(F_convolution,1),2),3);

% Perform the inverse FFT to get the convolved function
convolution_result = ifftn(F_convolution);

% Ensure the result is real (the imaginary part should be very small due to numerical errors)
convolution_result = real(convolution_result);
%----------------------------------------------------------------------
end

%----------------------------------------------------------------------


% This is better as a function to make the filter and the associated
% spectrum easier to compute.
function [P2D,kpar,kper,kz]=Power_of_filtering_kernel(Bx,Lx,Ly,Lz)
%----------------------------------------------------------------------
% Perform the FFT of the function f
F_Bx = fftn(Bx);

%Shift the ffts
F_Bx_shift = fftshift(fftshift(fftshift(F_Bx,1),2),3);
%F_Bx_shift = F_Bx;

%Get the amplitudes
F_f_shift_amp = F_Bx_shift .* conj(F_Bx_shift);

%l_wind_x_shift = fftshift(fftshift(fftshift(l_wind_x,1),2),3);
%F_g_shift_amp = l_wind_x_shift .* conj(l_wind_x_shift);
%convolution_shift = fftshift(fftshift(fftshift(F_convolution,1),2),3);
%convolution_result_amp = convolution_shift .* conj(convolution_shift);

ff=F_f_shift_amp;
Ns=size(ff);

kx=((0:Ns(1)-1)-Ns(1)/2).*2*pi/Lx; %Includes negative wavenumbers
ky=((0:Ns(2)-1)-Ns(2)/2).*2*pi/Ly;
kz=((0:Ns(3)-1)-Ns(3)/2).*2*pi/Lz;

kp = zeros(Ns(1),Ns(2));
kp2 = zeros(1,Ns(3));
for j=1:Ns(2)
    for i=1:Ns(1)
        %--------------------------------------------------------------------------
        kp(i,j)=sqrt(ky(j).^2 + kx(i).^2); %Calculate kperp array with negative wavenumbers
        %--------------------------------------------------------------------------
        %kp(i,j)=sqrt(ky(j).^2); %This is for the case of the 2D harris
        %configuration
        %--------------------------------------------------------------------------
    end
end
for k=1:size(ff,3)
    kp2(k)=abs(kz(k)); %Calculate kpar vector with negative wavenumbers
end

%Calculate kpar and kperp for 2D spectrum:
dkpar=kz(2)-kz(1);
nkpar=fix(max(max(kz))/dkpar)+1;
kpar=(0:nkpar-1).*dkpar;

dkper=ky(2)-ky(1);
nkper=fix(max(max(kp))/dkper)+1;
kper=(0:nkper-1).*dkper;

%Use linear interpolation to intergrate in concentric circles of k_perp:

%Initialise arrays:
Ptemp=zeros(size(ff,3),nkper); %old kper vs. new kper
P2D=zeros(nkpar,nkper); %kpar vs. kper

Nkper=zeros(size(ff,3),nkper);

i1=fix(kp/dkper); %Index linking kp with each kper value. Index of the cells
i2=i1+1; % indexes of next cells
i3=fix(kp2/dkpar); %Index linking kp2 with each kpar value

k2=kp/dkper-i1; % this is calculating basically the residuo. kp is a matrix
k1=1-k2;

for k= 1:size(ff,3) %For each value of kpar, integrate over rings of kper
    P1=k1.*ff(:,:,k); %For interpolation
    P2=k2.*ff(:,:,k);
    for j=1:size(ff,2) %Cycle through every grid point in x-y plane
        for i=1:size(ff,1)
            if(i2(i,j) < nkper)
                %Use linear interpolation to sum up power to surrounding
                %rings of kper:
                Ptemp(k,i2(i,j)+1)=Ptemp(k,i2(i,j)+1)+P2(i,j); %Interpolate power to next ring
                Ptemp(k,i1(i,j)+1)=Ptemp(k,i1(i,j)+1)+P1(i,j); %Interpolate power to previous ring

                %Update number of points interpolated for each ring:
                Nkper(i2(i,j)+1)=Nkper(i2(i,j)+1)+k2(i,j);
                Nkper(i1(i,j)+1)=Nkper(i1(i,j)+1)+k1(i,j);
            end
        end
    end
    if i3(k)<nkpar
        P2D(i3(k)+1,:)=P2D(i3(k)+1,:)+Ptemp(k,:); %Fill array with kper values for each kpar
    end
end
end
%----------------------------------------------------------------------

%----------------------------------------------------------------------
function [P1Dper,P1Dpar]=Compute1DSpectra(P2D,kper,threshold)
%Calculate parallel and perpendicular 1D sepctra from the 2D spectrum.
[c1,index1]=min(abs(kper-threshold)); %Cut spectrum above a threshold k

[c,index]=min(abs(kper-threshold)); %Cut spectrum above a threshold k
Pthres=P2D(2,index);
mask2D=P2D>Pthres;
fieldMASKED=P2D.*mask2D;
P1Dper=sum(fieldMASKED,1); %Sum over parallel k
P1Dpar=sum(fieldMASKED,2); %Sum over perpendicular k
end
%----------------------------------------------------------------------


%----------------------------------------------------------------------
% Plot the power spectrum of B to verify
function [E_k,k_bins]=Omni1DSpectra(Bx_dt,Lx,threshold)

B_hat_mag = abs(fftshift(fftn(Bx_dt))).^2;

%k0 = threshold; 
k0 = 2 * pi / Lx;    % Smallest wave number
Ns=size(Bx_dt);

kx = (-Ns/2:Ns/2-1) * k0;
ky = (-Ns/2:Ns/2-1) * k0;
kz = (-Ns/2:Ns/2-1) * k0;
[KX, KY, KZ] = meshgrid(kx, ky, kz);
k_mag = sqrt(KX.^2 + KY.^2 + KZ.^2);
%k_bins = unique(k_mag(:));

k_max = threshold;%max(K(:)); % Maximum wavenumber
k_bins = 0:k0:k_max; % Radial wavenumber bins

P_k = zeros(size(k_bins));

for i = 1:length(k_bins)
    P_k(i) = mean(B_hat_mag(k_mag == k_bins(i)));
end
E_k = P_k;
end
%----------------------------------------------------------------------

% % %----------------------------------------------------------------------
% % function [E_k,k_bins]=Omni1DSpectra(Bx_dt,Lx,threshold)
% % 
% % % Perform the FFT of the 3D field B
% % F_B = fftn(Bx_dt);
% % Ns=size(Bx_dt);
% % 
% % % Compute the wavenumbers
% % kx = (2*pi/Lx) * [0:(Ns(1)/2-1) -Ns(1)/2:-1];
% % ky = kx;
% % kz = kx;
% % [KX, KY, KZ] = meshgrid(kx, ky, kz);
% % 
% % % Calculate the radial wavenumber k
% % K = sqrt(KX.^2 + KY.^2 + KZ.^2);
% % 
% % % Calculate the energy spectrum
% % energy = abs(F_B).^2;
% % 
% % % Define the bins for the radial wavenumber
% % dk = 2 * pi / Lx; % Bin width in k-space
% % k_max = threshold;%max(K(:)); % Maximum wavenumber
% % k_bins = 0:dk:k_max; % Radial wavenumber bins
% % 
% % % Initialize the omnidirectional spectrum
% % E_k = zeros(size(k_bins));
% % 
% % % Bin the energy into the radial wavenumber bins
% % for i = 1:length(k_bins)-1
% %     k_min = k_bins(i);
% %     k_max = k_bins(i+1);
% %     % Find the indices of the Fourier modes that fall within the current bin
% %     indices = (K >= k_min) & (K < k_max);
% %     % Sum the energy of these modes
% %     E_k(i) = sum(energy(indices));
% % end
% % 
% % % Normalize the spectrum by the bin width
% %  E_k = E_k / dk;
% % 
% % % % Plot the omnidirectional spectrum
% % % figure;
% % % loglog(k_bins(1:end-1), E_k(1:end-1), 'LineWidth', 1.5);
% % % title('1D Omnidirectional Spectrum');
% % % xlabel('k');
% % % ylabel('E(k)');
% % end