%This is to check the waves from the simulations

% This is an important note on this. 

% For the alfven modes and different times to extract the frequencies
%--------------------------------------------------------------------------
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_cpinch_sSR';

%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_many_Ax_large_L8di_dB01_Omc1_kLd1_local_3';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_all_pert_par_ppc1000_ome5_mime1';
path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini_L8di_8';

path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large';
%--------------------------------------------------------------------------
path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
%--------------------------------------------------------------------------

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
%in=10;
%--------------------------------------------------------------------------
% Change this accordingly
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Normalization
%B are normalized to the background magnetic field
B0=0.2;
%n is normalise to the proton density n0=1
n0=1;
%Vi normalised to the proton alfven speed V_a=0.1c The alfven speed of
%electrons is Vae=10Vai
Vai=0.2;%0.2;
Vae=0.2;%0.2;
%E = vB, as B0=0.1 and v in units of c, E0= B0*Vai/c
E0=0.2;%0.2; %??
%T=(beta/2)B^2, Thus, as beta=1
T0=0.02;%0.02;
%The current density J0=1?
J0=Vae;
mime =1.;
omega_pe_Omega_ce=5;
MFT0=1; % is this simply one in this normalization
nb_n0 =0.1;
Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);
%Normalising only when making plots
VA2c = 0.2;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
nb_n0 =0.1;
Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
kb = 1.;
mu0 =1.;
c=1;
q = 1;
mi = 1.;
me = 1. / mime; eps0=1.;
omega_pi=1;
Omega_e=Vai*sqrt(mime)*omega_pi;
Omega_i=Omega_e / mime;
TOmega_e=1/Omega_e;
TOmega_i=1/Omega_i;
%--------------------------------------------------------------------------
jn=1;
in=N;
fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;
B=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
ss=size(B);
LZs=ss(3);

grid_size = [ss(2), ss(3), N]; % y,z,t

Bx_i = zeros(grid_size);
%By_i = zeros(grid_size);
%Bz_i = zeros(grid_size);

clearvars B
%N=183;
jn=N;
in=jn;
N_jn=N; %This is to store some but not all the time steps

time_t_2=zeros(1,N_jn);

for dt_i=1:N
    %dt_i=jn;
    %----------------------------------------------------------------------
    disp(strcat('Computing step ...',S(dt_i).name))
    fileID =  S(dt_i).name; %change the 1 per i
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
    Lx=grid_length(4).Value(1);% - grid_length(3).Value(1); % this is in di 
    Ly=grid_length(4).Value(2);% - grid_length(3).Value(2);
    Lz=grid_length(4).Value(3);% - grid_length(3).Value(3);
    resx=double(Lx)/double(dx);
    resy=double(Ly)/double(dy);
    resz=double(Lz)/double(dz); res=resy;
    threshold=pi/resy;
    %----------------------------------------------------------------------

%     %By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
%     %Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));
%     

%     %By_i(:,:,dt_i) = squeeze(By(1,:,:));
%     %Bz_i(:,:,dt_i) = squeeze(Bz(1,:,:));

%     Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
%     Bx_i(:,:,dt_i) = squeeze(Bx(1,:,:));

%      Bx=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));
%      Bx_i(:,:,dt_i) = squeeze(Bx(1,:,:));

     Ex=h5read(fileID,strcat(EHJ_1st,'/ez_ec/p0/3d')); 
     Bx_i(:,:,dt_i) = squeeze(Ex(1,:,:));

    
    %----------------------------------------------------------------------
end


% % %--------------------------------------------------------------------------
% % % Let's visualise the waves
% % time=(1:N)*dt;
% % dt_i=1;
% % for dt_i=1:N
% %     f1=figure(1);
% %     imagesc(Bx_i(:,:,dt_i))
% %     hold on
% %     colorbar; 
% %     %caxis([-5 5]);
% %     colormap('parula')
% %     title('time='+string(time(dt_i)))
% %     hold off
% % end
% % %--------------------------------------------------------------------------


% Although this seems to be working I need to apply a filter to remove the
% fast frequencies.
%--------------------------------------------------------------------------
clearvars Bx %By_i Bz_i
var1 = Bx_i;
clearvars Bx_i

%var2 = By_i;
N=size(var1);
Lx = N(1)*resy;
Ly = N(2)*resz;
Lt = N(3)*dt;

f1=abs(fftn(var1))*sqrt(N(1)*N(2)*N(3)); %Take abs value and normalise
%f2=abs(fftn(var2))*sqrt(N(1)*N(2)*N(3));

ft1=fftshift(f1); %Shift ft to centre wavenumber
%ft2=fftshift(f2);

kx=((0:N(1)-1)-N(1)/2).*2*pi/Lx; %Includes negative wavenumbers
ky=((0:N(2)-1)-N(2)/2).*2*pi/Ly;
om=((0:N(3)-1)-N(3)/2).*2*pi/Lt;

ff = ft1; 
clearvars ft1

%ff = ft1 + ft2;

P3D=ff/(N(1)*N(2)*N(3)); 


for j=1:size(ff,2)
    for i=1:size(ff,1) 
        %--------------------------------------------------------------------------
        kp(i,j)=sqrt(ky(j).^2+kx(i).^2); %Calculate kperp array with negative wavenumbers
        %--------------------------------------------------------------------------
    end
end

for k=1:size(ff,3)
    kp2(k)=abs(om(k)); %Calculate kpar vector with negative wavenumbers
end

%Calculate kpar and kperp for 2D spectrum:
dkpar=om(2)-om(1);
nkpar=fix(max(max(om)/dkpar))+1;
kpar=(0:nkpar-1).*dkpar;

dkper=ky(2)-ky(1);
nkper=fix(max(max(kp)/dkper))+1;
kper=(0:nkper-1).*dkper;
%Initialise arrays:
Ptemp=zeros(size(ff,3),nkper); %old kper vs. new kper
P2D=zeros(nkpar,nkper); %kpar vs. kper

Nkper=zeros(size(ff,3),nkper);

i1=fix(kp/dkper); %Index linking kp with each kper value. Index of the cells
i2=i1+1; % indexes of next cells
i3=fix(kp2/dkpar); %Index linking kp2 with each kpar value

k2=kp/dkper-i1; % this is calculating basically the residuo. kp is a matrix
k1=1-k2;
for k= 1:size(P3D,3) %For each value of kpar, integrate over rings of kper
    P1=k1.*P3D(:,:,k); %For interpolation
    P2=k2.*P3D(:,:,k);
    for j=1:size(P3D,2) %Cycle through every grid point in x-y plane
        for i=1:size(P3D,1)
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
%--------------------------------------------------------------------------

kper_max = 2*pi/(2*resy); 
kpar_max = (2*pi/(2*dt))/Omega_e;

threshold = kper_max;
% This is to apply the filter
[c,index]=min(abs(kper-threshold)); %Cut spectrum above a threshold k
Pthres=P2D(2,index);
mask2D=P2D.*(P2D>Pthres);

%k_per

%--------------------------------------------------------------------------
f91=figure(91);
[C,h]=contourf(kper,kpar*Omega_e,P2D,'LevelStep',1.0);
set(h,'LineColor','none')
set(gca,'XScale','lin','YScale','lin','FontSize',18)
set(gca,'ColorScale','log')
%imagesc(kper, kpar, log10(P2D))
lim = caxis;
caxis([1e-6 100]);
colormap(jet)
colorbar
xlabel('$k_\perp d_i$','Interpreter','latex')
ylabel('$\omega/\Omega_{ce}$','Interpreter','latex')
%title('$P_{\mathbf{B}_{z}}(k_{\perp},\omega)$','Interpreter','latex')
title('$P_{\mathbf{E}_{z}}(k_{\perp},\omega)$','Interpreter','latex')
hold on
ylim([0 5])
xlim([0 5])
%yline(1,'--k','LineWidth',1);
%xline(1,'--k','LineWidth',1);
hold off

% There is a problem here with the Pthres, it is just a number.
% % f92=figure(92);
% % [C,h]=contourf(kper,kpar*Omega_e,Pthres,'LevelStep',1.0);
% % set(h,'LineColor','none')
% % set(gca,'XScale','lin','YScale','lin','FontSize',18)
% % set(gca,'ColorScale','log')
% % %imagesc(kper, kpar, log10(P2D))
% % lim = caxis;
% % %caxis([1e-4 1]);
% % colormap(jet)
% % colorbar
% % xlabel('$k_\perp d_i$','Interpreter','latex')
% % ylabel('$\omega/\Omega_{ce}$','Interpreter','latex')
% % title('$P_{\mathbf{E}_{x}}(k_{\perp},\omega)$','Interpreter','latex')
% % hold on
% % ylim([0 5])
% % xlim([0 5])
% % %yline(1,'--k','LineWidth',1);
% % %xline(1,'--k','LineWidth',1);
% % hold off

cd(path)
%saveas(f91,strcat(num2str(1),'Bz_power_spect_kper_omega.png'));
%saveas(f912,strcat(num2str(1),'Bx_big_power_spect_kper_omega.png'));

saveas(f91,strcat(num2str(1),'Ez_power_spect_kper_omega.png'));
saveas(f912,strcat(num2str(1),'Ex_big_power_spect_kper_omega.png'));
%--------------------------------------------------------------------------



