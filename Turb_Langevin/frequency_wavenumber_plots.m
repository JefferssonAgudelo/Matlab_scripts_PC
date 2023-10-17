% Aiming to get the 2D frequency and wavenumber plots to see the type of
% waves and fluctuations that are presnt in the simulations 


% This is the expresion for delta' in slab geometry using rob goldston
% chapter 20 goldston2020introduction

x=linspace(0,5,100);
y = x.*(exp(-x) - x + 1 )./(exp(-x) + x - 1 );
f1=figure(1)
plot(x,y)
hold on
yline(0)
xline(1.279)
hold off


% This is to make those plots for the parameter space
%--------------------------------------------------------------------------
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1';
path = '/Users/jeffersson_agudelo/Downloads/plot_laptop/local_file';
%--------------------------------------------------------------------------
% Normalization parameters
%--------------------------------------------------------------------------
mime =1.;
mi = 1.;
eps0 = 1.;
kb = 1.;
mu0 = 1.;
c = 1;
q = 1;
di=1;
n0 = 1;
omega_pe = 1;
omega_pi = 1;

VA2c = 0.2; 
Vai = 0.2;    
Vae = 0.2;
B0 = 0.2;
beta0 = 0.2;

rho_i = di*sqrt(beta0);
me = 1. / mime; 

%E = vB, as B0=0.1 and v in units of c, E0= B0*Vai/c
E0 = 0.2;
T0 = 0.02;
J0 = Vae;

omega_pe_Omega_ce = 5;
%Omega_ce = omega_pe / omega_pe_Omega_ce;

Omega_e = Vai*sqrt(mime)*omega_pi;
Omega_i = Omega_e / mime;

nb_n0 = 0.1;
Vai_b = Vai/sqrt(nb_n0);
Vae_b = Vae/sqrt(nb_n0);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
cd(path)
S = dir(fullfile(path,'pfd.*.h5'));
N=numel(S); % number of files to use
in=1;
disp(strcat('Computing step ...',S(in).name))
fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;

grid_ng = info.Groups(19).Attributes;
Dx=grid_ng(10).Value(1);
Dy=grid_ng(10).Value(2);
Dz=grid_ng(10).Value(3);

grid_length = info.Groups(17).Attributes;
Lx0=grid_length(4).Value(1);% - grid_length(3).Value(1);
Ly0=grid_length(4).Value(2);% - grid_length(3).Value(2);
Lz0=grid_length(4).Value(3);% - grid_length(3).Value(3);

resx=double(Lx0)/double(Dx);
resy=double(Ly0)/double(Dy);
resz=double(Lz0)/double(Dz); res=resy;

threshold=pi/resy;

grid_dt = info.Groups(20).Attributes;
dt=double(grid_dt(15).Value);
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
Lz = Lz0;
kz = 1/Lz ;%(2*pi/Lz);

omega_max = pi/dt;
k_max = threshold;

%tearing grows
omegas_u = omega_pe * [0.9*kz*VA2c ,0.9*kz*VA2c, 0.2, 0.9*kz*VA2c, 1, 0.2,0.2,...
    1, 0.9*kz*VA2c, 0.9*kz*VA2c, 0.9*kz*VA2c,0.9*kz*VA2c];
ksdi_u = di * kz * [Lz/4, Lz/8, Lz/4, Lz/Lz, Lz/Lz, Lz/Lz, Lz/4, Lz/1, Lz/16, Lz/4, Lz/8, Lz/2]; 
dB_B0_u = [0.125,0.125,0.125,0.2,0.2,0.8,0.125,0.01, 0.8, 0.4, 0.8, 0.2];

%stables (tearing doesn't grow)
omegas_s = omega_pe * [0.2, 0.2 ,1 ,1, 0.2, 0.9*kz*VA2c, 0.2];
ksdi_s = di * kz * [Lz/rho_i, Lz/1, Lz/rho_i, Lz/1, Lz/4, Lz/1, Lz]; 
dB_B0_s = [0.2, 0.2, 0.2, 0.2, 0.8, 0.2, 0.4];
%--------------------------------------------------------------------------

% The relation for k and w for a given dB
%--------------------------------------------------------------------------

%This thing is still not working. I still need to find a way to trace a
%curve that is consistent with the simulations that remain unsteable to
%short eavelengths with dB_B0 = 0.01  
%--------------------------------------------------------------------------
beta01 = 0.2;
dB_B01 = 0.01;
dB_B02 = 0.2;
dB_B03 = 0.8;

Omegac = 0.2;
Omega1 = linspace(0.0001,10,100);

kdi1 = ((dB_B01).^-3/2) .* (beta01.^(1/4)) .* (Omega1./Omegac).^(3/4); %(1/3)
kdi2 = ((dB_B02).^-3/2) .* (beta01.^(1/4)) .* (Omega1./Omegac).^(3/4); %(1/3)
kdi3 = ((dB_B03).^-3/2) .* (beta01.^(1/4)) .* (Omega1./Omegac).^(3/4); %(1/3)

%kdi1 = ((dB_B01).^(3/2)) .* (beta01.^(-3/4)) .* (Omegac./Omega1).^(3/4); %(2/3) 
%kdi2 = ((dB_B02).^(3/2)) .* (beta01.^(-3/4)) .* (Omegac./Omega1).^(3/4); %(2/3) 


xline2_eff = (dB_B03^2)*Omegac/beta01;

f2=figure(2)
loglog(Omega1,kdi1,'k',LineWidth=2)
hold on
loglog(Omega1,kdi2,'b',LineWidth=2)
hold off
%--------------------------------------------------------------------------


% the possible equation considering critical balance is 
% K_per = (omega/Omega)^(3/2)*D
omega2 = linspace(0.001,1);
k_per2 =  (omega2/Omega_i).^(3/2);

k_per21 = 10*k_per2;  %choosing a random value of C=10 


% The plot
%--------------------------------------------------------------------------
fs=18; %x0=45;y0=54;xx1=810;yy1=710;
f1=figure(1);
%set(gcf,'position',[x0,y0,1.3*xx1,yy1/2])
%--------------------------------------------------------------------------
%plot(omegas,ks,'+k',LineWidth=2)
colormap(jet(9))                           
scatter(omegas_u, ksdi_u, 140, dB_B0_u,"square",LineWidth=2)     
hold on
scatter(omegas_s, ksdi_s, 60, dB_B0_s, "filled","d")  

plot(omega2,k_per2,'k',LineWidth=1.5)
plot(omega2,k_per21,'b',LineWidth=1.5)
% x1=linspace(0.2,omega_max,10);
% curve1 = 2*pi*ones(size(x1));
% curve2 = k_max*pi*ones(size(x1));
% x2 = [x1, fliplr(x1)];
% inBetween = [curve1, fliplr(curve2)];
% fill(x2, inBetween,'k','FaceAlpha',0.3);
% 
% x12=linspace(0.2,omega_max,10);
% curve1 = 2*pi*ones(size(x12));
% curve2 = kz*Lz/4*ones(size(x12));
% x22 = [x12, fliplr(x12)];
% inBetween = [curve1, fliplr(curve2)];
% fill(x22, inBetween,'k','FaceAlpha',0.1);

xline(0.2,'--k','LineWidth',1);
%xline(xline2_eff,'--k','LineWidth',1);
%xline(1,'--k','LineWidth',1);

%%yline(kz*Lz/4,'--r','LineWidth',1);
yline(kz*Lz/rho_i,'--k','LineWidth',1);

%yline((beta01^(1/4))*(0.2^(-3/2)),'--c','LineWidth',1);
%yline((beta01^(1/4))*(0.8^(-3/2)),'--r','LineWidth',1);
%yline((beta01^(1/4))*(1^(-3/2)),'--k','LineWidth',1);

x2=log10([0.21 1]); y2=x2 + 1.05;
x3=log10([0.06 0.2]); y3=(3/2)*x3 + 1.4;
%loglog(10.^x2,10.^y2,'--k','LineWidth',2)
%loglog(10.^x3,10.^y3,'--k','LineWidth',2)

txt = '$\rho_{e}^{-1}$';
%txt = '$k_{\perp} \Delta$';
txt2 = '$\Omega_{ce}$';
%text(0.2,0.5,txt,'FontSize',15)
text(0.002,2.5,txt,'Interpreter','latex','FontSize',1.3*fs)
text(0.3,51e-4,txt2,'Interpreter','latex','FontSize',1.3*fs)

txt3 = '$\delta B \sim 0.1B_{0}$';
txt4 = '$\delta B \sim 0.8B_{0}$';
%text(2.5,20,txt3,'Interpreter','latex','FontSize',20)
%text(2.5,3,txt4,'Interpreter','latex','FontSize',20)

ylim([5e-4 k_max]);
xlim([5e-4 omega_max]);
%legend('$\delta B / B_{0}}$','Interpreter','latex','FontSize',1.0*fs,'Location','southeast','NumColumns',1)

ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
set(gca,'XScale','log','YScale','log','FontSize',1.3*fs)
ax.YLabel.String = '$k d_{e}$'; 
ax.XLabel.String = '$\omega_{0}/\omega_{pe}$'; 

c = colorbar;
c.Location = "northoutside";
%hL = ylabel(c,'\delta B / B_{0}');     
%set(hL,'Rotation',90);

c.Title.Interpreter = 'latex';
c.Title.String = '$\delta B/B_{0}$'; 
%c.Label.Rotation = 90;
c.Title.FontSize = 1.3*fs;
c.TickLabelInterpreter = "latex";

%caxis([0 1.2*max(max(dB_B0_s),max(dB_B0_u))])
caxis([0 1])

%loglog(Omega1,kdi1,'--b',LineWidth=2)
%loglog(Omega1,kdi2,'--c',LineWidth=2)
%loglog(Omega1,kdi3,'--r',LineWidth=2)

hold off
%--------------------------------------------------------------------------





% Now looking at the magnetic field dependence 
%--------------------------------------------------------------------------
f3=figure(3);
loglog(ksdi_s,dB_B0_s,"b*")
hold on
loglog(ksdi_u,dB_B0_u,"r*")
%loglog(ksdi_u,dB_B0_u,"k*")
x2=log10([0.0021 10]); y2=-x2/3 - 0.7;
loglog(10.^x2,10.^y2,'--k','LineWidth',2)
x2=log10([0.0021 10]); y2=-x2*4/3 - 0.7;
loglog(10.^x2,10.^y2,'--r','LineWidth',2)
x2=log10([0.0021 10]); y2=-x2*1 - 0.7;
loglog(10.^x2,10.^y2,'--b','LineWidth',2)
xlim([1e-2 100]);
ylim([1e-2 100]);
hold off

klin = 2*pi./linspace(1,100,10);
Blin = (10^(-0.7)).*(klin).^(-2/3);
llin=2*pi./klin;
f4=figure(4);
%scatter(log(ksdi_s),log(dB_B0_s))
loglog(ksdi_s,dB_B0_s,'*')
hold on
%scatter(log(klin),log(Blin));
loglog(klin,Blin,'*');
hold off
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
Blin = 0.0586    0.3071    0.4739    0.6150    0.7413    0.8577    0.9666    1.0697    1.1681    1.2624
llin = 1.0000   12.0000   23.0000   34.0000   45.0000   56.0000   67.0000   78.0000   89.0000  100.0000
%--------------------------------------------------------------------------

%I know that
B = 0.2 0.8 
lin = 1 4 
%--------------------------------------------------------------------------
path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
cd(path_comp);
saveas(f1,'Parameter_space_3.png');

%--------------------------------------------------------------------------


0.0441*(2*pi)^(2/3)



path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';

%-----------------------------------------------------------------------------------------------------------------------
% For the scripts
path_s_T  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Turb_Langevin';
path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
%-----------------------------------------------------------------------------------------------------------------------



%--------------------------------------------------------------------------
cd(path)
S = dir(fullfile(path,'pfd.*.h5'));
N=numel(S); % number of files to use
H=zeros(N);

%in=N;
P2D2_i=cell(1,N);
time_t_2=zeros(1,N);
for in=1:N
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
Dx=grid_ng(10).Value(1);
Dy=grid_ng(10).Value(2);
Dz=grid_ng(10).Value(3);

grid_length = info.Groups(17).Attributes;
Lx0=grid_length(4).Value(1);% - grid_length(3).Value(1);
Ly0=grid_length(4).Value(2);% - grid_length(3).Value(2);
Lz0=grid_length(4).Value(3);% - grid_length(3).Value(3);

resx=double(Lx0)/double(Dx);
resy=double(Ly0)/double(Dy);
resz=double(Lz0)/double(Dz); res=resy;

threshold=pi/resy;

dt=double(grid_dt(15).Value);
str = string(S(in).name);
newStr = extractBetween(str,"pfd.","_p000000.h5");
N_steps = str2double(newStr);
time_t = dt*N_steps;
time_t_2_Omega = time_t./omega_pe_Omega_ce;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));

sli_x=1;

Bx = squeeze(Bx(sli_x,:,:));
By = squeeze(By(sli_x,:,:));
Bz = squeeze(Bz(sli_x,:,:));

sss=size(Bx);
size_X=sss;
zll=linspace(-Lz0,Lz0,size_X(2));
yll=linspace(-Ly0,Ly0,size_X(1));

%[ZLL, YLL] = meshgrid(zll,yll);

ly=length(yll);
Ly_2_0 = 1;%ly/2;
Ly_2_1 = ly;%Ly_2_0 + Ly_2_0/4;

[ZLL,YLL] = meshgrid(zll,yll);
dummy_f = YLL;
YLL_1 = dummy_f(Ly_2_0:Ly_2_1,:);
dummy_f = ZLL;
ZLL_1 = dummy_f(Ly_2_0:Ly_2_1,:);

% Divide the top part of the harris into 4 sectors
%----------------------------------------------------------------------
dummy_f = Bx;
Bx_1 = dummy_f(Ly_2_0:Ly_2_1,:); % from the x-line to the top
dummy_f = By;
By_1 = dummy_f(Ly_2_0:Ly_2_1,:); % from the x-line to the top
dummy_f = Bz;
Bz_1 = dummy_f(Ly_2_0:Ly_2_1,:); % from the x-line to the top
%----------------------------------------------------------------------

clearvars Bx By Bz

% Compute the FFT of the fields Bx_1, By_1; Bz_1;
%--------------------------------------------------------------------------
[ff_x,ky,kz] = Four3D(Bx_1,Ly0,Lz0);
%[ff_y,ky,kz] = Four3D(By_1,Ly0,Lz0);
%[ff_z,ky,kz] = Four3D(Bz_1,Ly0,Lz0);

%ff=ff_x.^2+ff_y.^2+ff_z.^2;
ff=ff_x.^2;

N=size(Bx_1);
P3D=ff./(N(1)*N(2)); 
P2D2=P3D/max(max(P3D));

P2D2_i{in} = P2D2;
time_t_2(1,in)=time_t_2_Omega;

end

%dy=resy;dz=resz;kp=ky;
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% % [kp2J, kpJ]=meshgrid(kz,ky);
% % 
% % ff=ff_z.^2;
% % N=size(Bx_1);
% % P3D=ff./(N(1)*N(2));
% % P2D2=P3D/max(max(P3D));
% % fs=18;
%----------------------------------------------------------------------
% % f8=figure(8);
% % [C,h]=contourf(kz,ky,log10(P2D2),'LevelStep',0.2);
% % set(h,'LineColor','none')
% % lim = caxis;
% % caxis([-8 0]);
% % colormap(jet)
% % colorbar
% % set(gca,'XScale','log','YScale','log','FontSize',fs)
% % xlabel('$k_\| d_i$','Interpreter','latex')
% % ylabel('$k_\perp d_i$','Interpreter','latex')
% % hold on
% % ylim([2*pi/Ly0 threshold])
% % xlim([2*pi/Lz0 threshold])
% % xticks([0.1 1 10]); yticks([0.1 1 10])
% % xticklabels({'10^{-1}','10^{0}','10^{1}'}); yticklabels({'10^{-1}','10^{0}','10^{1}'})
% % yline(10,'--k','LineWidth',1);
% % xline(1,'--k','LineWidth',1);
% % title('$\log_{10}{P^{\mathbf{B}}_{2D}} \ ; \ t = \ $'+string(round((time_t/omega_pe_Omega_ce),2)) + ...
% %     '$$ \ \Omega_{ce}^{-1}$$','Interpreter','latex','FontSize',fs)
% % hold off
%--------------------------------------------------------------------------

% I need to store the fft for each time and safe them so I can analyse them 
% in time with the IF decomposition



% For each pair kx ,ky we perform a IF decomposition and calculate average 
% frequency and amplitude of each IMF



%--------------------------------------------------------------------------
function [ft,ky,kz]=Four3D(var,Ly,Lz)
    %Calculates 3D spatial Fourier transfrom of variable 'var', shifted so
    %that the centre is the zero k. xx/yy/zz are Lx, Ly and Lz.
    
    var=var-mean(mean(mean((var)))); %Detrend mean

    N=size(var); %N=[Nx,Ny,Nz]

    f=abs(fftn(var))*sqrt(N(1)*N(2)); %Take abs value and normalise
    %^Should it be fftn instead of ifftn?
    
    ft=fftshift(f); %Shift ft to centre wavenumber
    
    %Includes negative wavenumbers
    ky=((0:N(1)-1)-N(1)/2).*2*pi/Ly;
    kz=((0:N(2)-1)-N(2)/2).*2*pi/Lz;

end