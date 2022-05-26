% This is to check the tmeperature anisotropy in the simulation domain. 
% Especially in the region of interest to make plots in time to see how the 
% anisotropy changes

%--------------------------------------------------------------------------
cd '/Volumes/PSC_DiRAC_DATA/DATACB104/raw_data'; %This is important because the xdmf files are in that directory
path = '/Volumes/PSC_DiRAC_DATA/DATACB104/raw_data';

% useful parameters used in the simulation
%--------------------------------------------------------------------------
kb = 1.; mu0 =1.; mi_over_me_ =100.; vA_over_c_ = 0.1; B0_ = vA_over_c_;
mi = 1.; me = 1. / mi_over_me_; eps0=1.;
omega_pi=1;
Omega_e=vA_over_c_*sqrt(mi_over_me_)*omega_pi;
Omega_i=Omega_e / mi_over_me_;
TOmega_e=1/Omega_e; 
TOmega_i=1/Omega_i;
dt=0.06;
d_step_out=400;
%------------------------------------------------------------------
%vectors as 1 arrow 3 columns
%mi=1;
mime=100;
%me=mi/mime;
qi=1;
qe=-1;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
S = dir(fullfile(path,'*.h5'));
N=numel(S); % number of files to use <---------------- This is the N 
H=zeros(N);
%in=30;
%i=2;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
nx1=166;    nx2=333;
ny1=232;    ny2=400;
nz1=1200;   nz2=1367;

%px2 = 400; py2 = 400; pz2 = 168; For the no reference change
px2 = 168; py2 = 168; pz2 = 168;
start = [nx1 ny1 nz1];
count = [px2 py2 pz2];
%--------------------------------------------------------------------------

resx=0.06; %0.06081
resy=0.06;
resz=0.06; %0.06152

Lx=px2*resx; k0x=1/Lx;
Ly=px2*resy; k0y=1/Ly;
Lz=px2*resz; k0z=1/Lz;
k00=sqrt(k0x*k0x + k0y*k0y + k0z*k0z);
%--------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%in=2;

for in=1:N
%--------------------------------------------------------------------------
disp(strcat('Computing step ...',S(in).name))
%--------------------------------------------------------------------------
%N_steps = 2000;
%time_t = dt*N_steps; %(In terms of 1/omega_pi)
str = string(S(in).name);
newStr = extractBetween(str,"pfd.","_p000000.h5");
N_steps = str2double(newStr);
time_t = dt*N_steps;
%--------------------------------------------------------------------------

fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
T_1st = info.Groups(1).Name;
B_1st = info.Groups(18).Name;
n_1st = info.Groups(23).Name;
%--------------------------------------------------------------------------

% Including the normalization of the quantities before hand 
%--------------------------------------------------------------------------
c=1;
VA2c = 1.;%0.1;
B0 = 1.;%VA2c;
E0 = 1.;%B0*VA2c;
Pi0 = 1.;%mi*VA2c*VA2c;
Pe0 = 1.;%me*VA2c*VA2c;
%--------------------------------------------------------------------------

% First ions and then electrons
%------------------------------------------------------------------
Txx_i=h5read(fileID,strcat(T_1st,'/Txx_e/p0/3d'),start,count);
Tyy_i=h5read(fileID,strcat(T_1st,'/Tyy_e/p0/3d'),start,count);
Tzz_i=h5read(fileID,strcat(T_1st,'/Tzz_e/p0/3d'),start,count);
Bx=h5read(fileID,strcat(B_1st,'/hx/p0/3d'),start,count);
By=h5read(fileID,strcat(B_1st,'/hy/p0/3d'),start,count);
Bz=h5read(fileID,strcat(B_1st,'/hz/p0/3d'),start,count);    
ni = h5read(fileID,strcat(n_1st,'/n_e/p0/3d'),start,count);

%time_Oe_i=d_step_out*dt*vA_over_c_*sqrt(mime)*(in-1); %This is in terms of omega_e
time_Oe_i=d_step_out*dt*vA_over_c_*sqrt(mi)*(in-1); %This is in terms of omega_i
%This is not quite working
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
T_par =Tzz_i./ni;
%T_perp =sqrt(Txx_i .*Txx_i  + Tyy_i.*Tyy_i);
T_perp =(Txx_i  + Tyy_i)./(2*ni);
T_perp_2_T_par = T_perp ./ T_par;
B2=Bx.*Bx + By.*By + Bz.*Bz;
beta_i_par = 2.*(ni.*T_par) ./ B2;
    
    %T_par_2_T_per = T_par ./ T_perp;
    %beta_i_per = (ni.*T_perp) ./ B2;
    
    dx=0.06;
    dy=0.06;
    dxT=200;

    Xedges2D = linspace(dx,10,dxT);
    Yedges2D = linspace(dy,10,dxT);
    
 %   Xedges2D = linspace(0,5,dxT);
 %   Yedges2D = linspace(0,5,dxT);

    [Ne,Xedgese,Redgese] = histcounts2(beta_i_par,T_perp_2_T_par,Xedges2D,Yedges2D);
     
    Ne=Ne(1:dxT-1,1:dxT-1)';
    Xedges2e=Xedgese(2:dxT)';
    Redges2e=Redgese(2:dxT)';
    
    Ne(Ne==0)=NaN; 
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
    f32=figure(32);
    %h=pcolor(Xedges3e,Redges3e, Nenan);
    h=pcolor(Xedges2e,Redges2e, Ne');
    set(h, 'EdgeColor', 'none');
    hold on
    lim = caxis;  
    %caxis([1 1e7]); %caxis([0.01 1e4]); for the other 2 and 5
    %colormap(cool(25));
    colormap(jet(25))
    set(gca,'ColorScale','log','FontSize',18)
    colorbar
    xlim([dx 5]); ylim([dy 5]);
    set(gca,'XScale','log','YScale','log','FontSize',18)
    xlabel('$$\beta_{i\|}$$','Interpreter','latex','FontSize',20)
    ylabel('$$T_{i\perp}/T_{i\|}$$','Interpreter','latex','FontSize',20)
    title('$$B_{0}; T_{i\perp}/T_{i\|} \ t = $$'+string(round(time_Oe_i,2)) + '$$\ \Omega_{e}^{-1}$$','Interpreter','latex','FontSize',20)
    %[M,c]=contour(X,Y,Z,v);
    %c.LineWidth = 3;
    grid off
    pbaspect([1 1 1])
    hold off
    saveas(f32,strcat('backgroundB_therm_aniso_' + string(in) +'.png'));
    %}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% checking the algorithm
%--------------------------------------------------------------------------
tpar2=squeeze(T_par);
tper2=squeeze(T_perp);
tper2tpar=T_perp_2_T_par;

f4=figure(4);
subplot(2,2,1)
histogram(tpar2)
title('Tpar')
%xlim([0 1e-2]);
subplot(2,2,2)
histogram(tper2)
title('Tper')
%xlim([0 1e-3]);
subplot(2,2,3)
histogram(tper2tpar)
title('Tper2Tpar')
%xlim([0 3]);
subplot(2,2,4)
h=pcolor(Xedges2e,Redges2e, Ne);
set(h, 'EdgeColor', 'none');
hold on
lim = caxis;  
%caxis([1 1e7]); %caxis([0.01 1e4]); for the other 2 and 5
%colormap(cool(25));
colormap(jet(25))
set(gca,'ColorScale','log','FontSize',18)
colorbar
xlim([dx 20]); ylim([dy 20]);
set(gca,'XScale','log','YScale','log','FontSize',18)
xlabel('$$\beta_{e\|}$$','Interpreter','latex','FontSize',20)
ylabel('$$T_{e\perp}/T_{e\|}$$','Interpreter','latex','FontSize',20)
%title('$$B_{0}; T_{i\perp}/T_{i\|} \ t = $$'+string(round(time_t,2)) + '$$\ \Omega_{pi}^{-1}$$','Interpreter','latex','FontSize',20)
title('$$B_{0}; T_{e\perp}/T_{e\|} \ t = $$'+string(round(time_t,2)) + '$$\ \Omega_{pi}^{-1}$$','Interpreter','latex','FontSize',20)
%[M,c]=contour(X,Y,Z,v);
%c.LineWidth = 3;
grid off
pbaspect([1 1 1])
hold off
saveas(f4,strcat('backgroundB_therm_aniso_e_' + string(in) +'.png'));
end