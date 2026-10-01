% Just to run the spectra

fs=20;
threshold = pi/resx;
%----------------------------------------------------------------------

%----------------------------------------------------------------------
% This is to get the 1D omni spectra 
%----------------------------------------------------------------------

[Ex_k_dt,~]=Omni1DSpectra(Ex_dt - mean(Ex_dt,"all"),Lx,threshold);
% % [Ey_k_dt,~]=Omni1DSpectra(Ey_dt - mean(Ey_dt,"all"),Lx,threshold);
% % [Ez_k_dt,~]=Omni1DSpectra(Ez_dt - mean(Ez_dt,"all"),Lx,threshold);
% % 
% % [vxBx_k_dt,~]=Omni1DSpectra(-v_x_B_x_dt - mean(-v_x_B_x_dt,"all"),Lx,threshold);
% % [vxBy_k_dt,~]=Omni1DSpectra(-v_x_B_y_dt - mean(-v_x_B_y_dt,"all"),Lx,threshold);
% % [vxBz_k_dt,~]=Omni1DSpectra(-v_x_B_z_dt - mean(-v_x_B_z_dt,"all"),Lx,threshold);
% % 
% % [JxBx_k_dt,~]=Omni1DSpectra(J_x_B_x_dt./n_0_dt - mean(J_x_B_x_dt./n_0_dt,"all"),Lx,threshold);
% % [JxBy_k_dt,~]=Omni1DSpectra(J_x_B_y_dt./n_0_dt - mean(J_x_B_y_dt./n_0_dt,"all"),Lx,threshold);
% % [JxBz_k_dt,~]=Omni1DSpectra(J_x_B_z_dt./n_0_dt - mean(J_x_B_z_dt./n_0_dt,"all"),Lx,threshold);
% % 
% % [Div_Pex_k_dt,~]=Omni1DSpectra(Div_Pe_dt_x./n_0_dt - mean(Div_Pe_dt_x./n_0_dt,"all"),Lx,threshold);
% % [Div_Pey_k_dt,~]=Omni1DSpectra(Div_Pe_dt_y./n_0_dt - mean(Div_Pe_dt_y./n_0_dt,"all"),Lx,threshold);
% % [Div_Pez_k_dt,~]=Omni1DSpectra(Div_Pe_dt_z./n_0_dt - mean(Div_Pe_dt_z./n_0_dt,"all"),Lx,threshold);
% % 
% % vxB_JxB2n_x = -v_x_B_x_dt + J_x_B_x_dt./n_0_dt + Div_Pe_dt_x./n_0_dt;
% % vxB_JxB2n_y = -v_x_B_y_dt + J_x_B_y_dt./n_0_dt + Div_Pe_dt_y./n_0_dt;
% % vxB_JxB2n_z = -v_x_B_z_dt + J_x_B_z_dt./n_0_dt + Div_Pe_dt_z./n_0_dt;
% % 
% % [vxB_JxB2nx_k_dt,~]=Omni1DSpectra(vxB_JxB2n_x  - mean(vxB_JxB2n_x,"all"),Lx,threshold);
% % [vxB_JxB2ny_k_dt,~]=Omni1DSpectra(vxB_JxB2n_y  - mean(vxB_JxB2n_y,"all"),Lx,threshold);
% % [vxB_JxB2nz_k_dt,k_bins]=Omni1DSpectra(vxB_JxB2n_z - mean(vxB_JxB2n_z,"all"),Lx,threshold);
% % 

%----------------------------------------------------------------------


%%
fs=20; x0=45;y0=54;yy1=1100;xx1=600;
%--------------------------------------------------------------------------
f22=figure(22);
set(gcf,'position',[x0,y0,xx1,yy1])
%----------------------------------------------------------------------
subplot(3,1,1)
loglog(k_bins(1:end-1), Ex_k_dt(1:end-1),'r-','LineWidth',2)
hold on
loglog(k_bins(1:end-1), vxBx_k_dt(1:end-1)/(B0^0),'b-','LineWidth',2)
loglog(k_bins(1:end-1), JxBx_k_dt(1:end-1)/(B0^0),'g-','LineWidth',2)
loglog(k_bins(1:end-1), Div_Pex_k_dt(1:end-1)/(B0^0),'m-','LineWidth',2)
loglog(k_bins(1:end-1), vxB_JxB2nx_k_dt(1:end-1)/(B0^0),'k--','LineWidth',2)
set(gca,'FontSize',fs)
%set(gca,'XScale','lin','YScale','log','FontSize',fs)
y1=get(gca,'ylim');
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$k d_i$';
ax.YLabel.String = '$P_{1D} $';
xlim([k_bins(2) threshold]);
ylim([10^(-8) 10^(15)]);
legend('$E_{x}$','$-u \times B_{x}$','$J \times B_{x}$', '$(\nabla \cdot P_{e}/ne)_{x}$', '$(RHS)_{x}$','Interpreter','latex','NumColumns',1,'Location','southwest')
hold off
%----------------------------------------------------------------------
subplot(3,1,2)
loglog(k_bins(1:end-1), Ey_k_dt(1:end-1),'r-','LineWidth',2)
hold on
loglog(k_bins(1:end-1), vxBy_k_dt(1:end-1)/(B0^2),'b-','LineWidth',2)
loglog(k_bins(1:end-1), JxBy_k_dt(1:end-1)/(B0^2),'g-','LineWidth',2)
loglog(k_bins(1:end-1), Div_Pey_k_dt(1:end-1)/(B0^0),'m-','LineWidth',2)
loglog(k_bins(1:end-1), vxB_JxB2ny_k_dt(1:end-1)/(B0^0),'k--','LineWidth',2)
set(gca,'FontSize',fs)
%set(gca,'XScale','lin','YScale','log','FontSize',fs)
y1=get(gca,'ylim');
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$k d_i$';
ax.YLabel.String = '$P_{1D} $';
xlim([k_bins(2) threshold]);
ylim([10^(-8) 10^(15)]);
legend('$E_{y}$','$-u \times B_{y}$','$J \times B_{y}$', '$(\nabla \cdot P_{e}/ne)_{y}$', '$(RHS)_{y}$','Interpreter','latex','NumColumns',1,'Location','southwest')
hold off
%----------------------------------------------------------------------
subplot(3,1,3)
loglog(k_bins(1:end-1), Ez_k_dt(1:end-1),'r-','LineWidth',2)
hold on
loglog(k_bins(1:end-1), vxBz_k_dt(1:end-1)/(B0^2),'b-','LineWidth',2)
loglog(k_bins(1:end-1), JxBz_k_dt(1:end-1)/(B0^2),'g-','LineWidth',2)
loglog(k_bins(1:end-1), Div_Pez_k_dt(1:end-1)/(B0^0),'m-','LineWidth',2)
loglog(k_bins(1:end-1), vxB_JxB2nz_k_dt(1:end-1)/(B0^0),'k--','LineWidth',2)
set(gca,'FontSize',fs)
%set(gca,'XScale','lin','YScale','log','FontSize',fs)
y1=get(gca,'ylim');
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$k d_i$';
ax.YLabel.String = '$P_{1D}$';
xlim([k_bins(2) threshold]);
ylim([10^(-8) 10^(15)]);
legend('$E_{z}$','$-u \times B_{z}$','$J \times B_{z}$', '$(\nabla \cdot P_{e}/ne)_{z}$', '$(RHS)_{z}$','Interpreter','latex','NumColumns',1,'Location','southwest')
hold off

%cd(f_path)
%saveas(f21,strcat(num2str(i),'spectrum_Ohms_EvxBJxB2n.png'));
%----------------------------------------------------------------------



%}
%%

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
function [E_k,k_bins]=Omni1DSpectra(Bx_dt,Lx,threshold)

% Perform the FFT of the 3D field B
F_B = fftn(Bx_dt);
Ns=size(Bx_dt);

% Compute the wavenumbers
kx = (2*pi/Lx) * [0:(Ns(1)/2-1) -Ns(1)/2:-1];
ky = kx;
kz = kx;
[KX, KY, KZ] = meshgrid(kx, ky, kz);

% Calculate the radial wavenumber k
K = sqrt(KX.^2 + KY.^2 + KZ.^2);

% Calculate the energy spectrum
energy = abs(F_B).^2;

% Define the bins for the radial wavenumber
dk = 2 * pi / Lx; % Bin width in k-space
k_max = threshold;%max(K(:)); % Maximum wavenumber
k_bins = 0:dk:k_max; % Radial wavenumber bins

% Initialize the omnidirectional spectrum
E_k = zeros(size(k_bins));

% Bin the energy into the radial wavenumber bins
for i = 1:length(k_bins)-1
    k_min = k_bins(i);
    k_max = k_bins(i+1);
    % Find the indices of the Fourier modes that fall within the current bin
    indices = (K >= k_min) & (K < k_max);
    % Sum the energy of these modes
    E_k(i) = sum(energy(indices));
end

% Normalize the spectrum by the bin width
E_k = E_k / dk;

% % Plot the omnidirectional spectrum
% figure;
% loglog(k_bins(1:end-1), E_k(1:end-1), 'LineWidth', 1.5);
% title('1D Omnidirectional Spectrum');
% xlabel('k');
% ylabel('E(k)');
end