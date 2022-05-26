%#-----------------------------------------------------------------------
%This is the script to read the particle infoprmation
% Currently the program does not create a xdmf but only a .h5

%This file is to do the brasil plots and the instability things
%#----------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd '/Volumes/PSC_DiRAC_DATA/ELECTRON_PROJECT/electron_project_mac/electron_test/field_outputs';
path = '/Volumes/PSC_DiRAC_DATA/ELECTRON_PROJECT/electron_project_mac/electron_test/field_outputs';

%cd '/Volumes/PSC_DiRAC_DATA/103_thinner'
%path = '/Volumes/PSC_DiRAC_DATA/103_thinner';
%Constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    kb = 1.;
    mu0 =1.;
    mi_over_me_ =300.;
    vA_over_c_ = .008;
    B0_ = vA_over_c_;
    mi = 1.;
    me = 1. / mi_over_me_;
    mes = 1. / mi_over_me_;

    omega_pi=1;
    Omega_e=vA_over_c_*sqrt(mi_over_me_)*omega_pi;
    Omega_i=Omega_e / mi_over_me_;
    TOmega_e=1/Omega_e; %2*pi/Omega_e;
    TOmega_i=1/Omega_i;
    Ttotal=300*TOmega_e;
    dt=0.0029;
    d_step_out=500;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%The magnetic field is directed along z-direction  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mime=300;
%Sp = dir(fullfile(path,'prt.*'));
S = dir(fullfile(path,'*.h5'));
N=numel(S); % number of files to use
H=zeros(N);
%i=1;
for i=1:28
    disp(strcat('Computing step ...',S(i).name)) 
    fileID =  S(i).name; %change the 1 per i
    %h5disp(fileID);
    info = h5info(fileID);
   
    T_1st = info.Groups(1).Name;
    B_1st = info.Groups(18).Name;
    n_1st = info.Groups(23).Name;
       
    
    Txx_i=squeeze(h5read(fileID,strcat(T_1st,'/Txx_i/p0/3d')));
    Tyy_i=squeeze(h5read(fileID,strcat(T_1st,'/Tyy_i/p0/3d')));
    Tzz_i=squeeze(h5read(fileID,strcat(T_1st,'/Tzz_i/p0/3d')));
    
    Bx=squeeze(h5read(fileID,strcat(B_1st,'/hx/p0/3d')));
    By=squeeze(h5read(fileID,strcat(B_1st,'/hy/p0/3d')));
    Bz=squeeze(h5read(fileID,strcat(B_1st,'/hz/p0/3d')));
    
    ni = squeeze(h5read(fileID,strcat(n_1st,'/n_i/p0/3d')));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %i=2;
    %d_step_out=150000;
     
    time_Oe_i=d_step_out*dt*vA_over_c_*sqrt(mime)*(i-1); %This is in terms of omega_e
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fact=1;%100000; % This is due to there temperature values are too low and 
    %I don't know why this is happening. It should be arround 1 by default.
    T_par =fact*Tzz_i./ni;
    %T_perp =sqrt(Txx_i .*Txx_i  + Tyy_i.*Tyy_i)./(2*ni);
    T_perp =fact*(Txx_i  + Tyy_i)./(2*ni);
    T_perp_2_T_par = T_perp ./ T_par;
    B2=Bx.*Bx + By.*By + Bz.*Bz;
    beta_i_par = 2.*(ni.*T_par) ./ B2;
    
    %T_par_2_T_per = T_par ./ T_perp;
    %beta_i_per = (ni.*T_perp) ./ B2;
    
    dx=0.05;
    dy=0.05;
    dxT=200;

    %Xedges2D = linspace(dx,2,dxT);
    %Yedges2D = linspace(dy,2,dxT);
    
    Xedges2D = linspace(0,5,dxT);
    Yedges2D = linspace(0,5,dxT);

    [Ne,Xedgese,Redgese] = histcounts2(beta_i_par,T_perp_2_T_par,Xedges2D,Yedges2D);
    %[Ne,Xedgese,Redgese] = histcounts2(T_par,T_perp_2_T_par,Xedges2D,Yedges2D);
    
    Ne=Ne(1:dxT-1,1:dxT-1)';
    %Ne2=Ne2(1:dxT-1,1:dxT-1)';
    Xedges2e=Xedgese(2:dxT)';
    Redges2e=Redgese(2:dxT)';
    
    %{
    Xedges3e=Xedges2e-(Xedges2e(2)-Xedges2e(1))/2;    
    Redges3e=Redges2e-(Redges2e(2)-Redges2e(1))/2;
    [Ce,De]=meshgrid(Xedges3e,Redges3e);
    x = linspace(-pi,pi);
    y = linspace(0,2*pi);
    [X,Y] = meshgrid(x,y);
    Z = sqrt(X.*X + Y.*Y);
    v = [1,1];
    Nenan=Ne./(De);
    Nenan(Nenan==0)=NaN;
    %}
   
    Ne(Ne==0)=NaN; 
    %Ne2(Ne2==0)=NaN;    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %{
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    f3=figure(3);
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
    title('$$T_{i\perp}/T_{i\|} \ t = $$'+string(round(time_Oe_i,2)) + '$$\ \Omega_{e}^{-1}$$','Interpreter','latex','FontSize',20)
    %[M,c]=contour(X,Y,Z,v);
    %c.LineWidth = 3;
    grid off
    pbaspect([1 1 1])
    hold off
    %saveas(f3,strcat('therm_aniso_' + string(i) +'.png'));
    %}
    %Nenanes19{i}=Nenan;
    
% checking the algorithm
%--------------------------------------------------------------------------
tpar2=squeeze(T_par);
tper2=squeeze(T_perp);
tper2tpar=T_perp_2_T_par;

%tpar2=1+randn(1000);
%tper2=1+randn(1000);
%tper2tpar=tper2./tpar2;
%[Ne,Xedgese,Redgese] = histcounts2(tpar2,tper2tpar,Xedges2D,Yedges2D);
%Ne(Ne==0)=NaN;

f4=figure(4);
subplot(2,2,1)
histogram(tpar2)
title('Tpar')
subplot(2,2,2)
histogram(tper2)
title('Tper')
subplot(2,2,3)
histogram(tper2tpar)
title('Tper2Tpar')
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
%xlim([dx 20]); ylim([dy 20]);
set(gca,'XScale','log','YScale','log','FontSize',18)
xlabel('$$\beta_{i\|}$$','Interpreter','latex','FontSize',20)
ylabel('$$T_{i\perp}/T_{i\|}$$','Interpreter','latex','FontSize',20)
title('$$T_{i\perp}/T_{i\|} \ t = $$'+string(round(time_Oe_i,2)) + '$$\ \Omega_{e}^{-1}$$','Interpreter','latex','FontSize',20)
%[M,c]=contour(X,Y,Z,v);
%c.LineWidth = 3;
grid off
pbaspect([1 1 1])
hold off
saveas(f4,strcat('therm_aniso_' + string(i) +'.png'));
%--------------------------------------------------------------------------
end



    
%[Ne,Xedgese,Redgese] = histcounts2(beta_i_par,T_perp_2_T_par);
    f46=figure(46);
    histogram(squeeze(ni),50);
    histogram(squeeze(T),50);
    

    f45=figure(45);
    subplot(1,3,1)
    h=pcolor(squeeze(T_par));
    set(h, 'EdgeColor', 'none');
    colorbar
    subplot(1,3,2)
    h=pcolor(squeeze(T_perp));
    set(h, 'EdgeColor', 'none');
    colorbar
    subplot(1,3,3)
    h=pcolor(squeeze(beta_i_par));
    set(h, 'EdgeColor', 'none');
    colorbar
    

    
    f5=figure(5);
    subplot(2,1,1)
    h=pcolor(Xedges2e_pe,Redges2e_pe, Ne_pe');
    set(h, 'EdgeColor', 'none');
    hold on
    lim = caxis;  
    %caxis([1 1e7]); %caxis([0.01 1e4]); for the other 2 and 5
    %colormap(cool(25));
    colormap(jet(25))
    set(gca,'ColorScale','log','FontSize',18)
    colorbar
    xlim([dx 2]); ylim([dy 2]);
    set(gca,'XScale','log','YScale','log','FontSize',18)
    xlabel('$$\beta_{i\|}$$','Interpreter','latex','FontSize',20)
    ylabel('$$T_{i\perp}/T_{i\|}$$','Interpreter','latex','FontSize',20)
    title('$$T_{i\perp}/T_{i\|} \ t = $$'+string(round(time_Oe_i,2)) + '$$\ \Omega_{e}^{-1}$$','Interpreter','latex','FontSize',20)
    %[M,c]=contour(X,Y,Z,v);
    %c.LineWidth = 3;
    grid off
    pbaspect([1 1 1])
    hold off
    subplot(2,1,2)
    h=pcolor(Xedges2e_pa,Redges2e_pa, Ne_pa');
    set(h, 'EdgeColor', 'none');
    hold on
    lim = caxis;  
    %caxis([1 1e7]); %caxis([0.01 1e4]); for the other 2 and 5
    %colormap(cool(25));
    colormap(jet(25))
    set(gca,'ColorScale','log','FontSize',18)
    colorbar
    xlim([dx 2]); ylim([dy 2]);
    set(gca,'XScale','log','YScale','log','FontSize',18)
    xlabel('$$\beta_{i\|}$$','Interpreter','latex','FontSize',20)
    ylabel('$$T_{i\perp}/T_{i\|}$$','Interpreter','latex','FontSize',20)
    title('$$T_{i\perp}/T_{i\|} \ t = $$'+string(round(time_Oe_i,2)) + '$$\ \Omega_{e}^{-1}$$','Interpreter','latex','FontSize',20)
    %[M,c]=contour(X,Y,Z,v);
    %c.LineWidth = 3;
    grid off
    pbaspect([1 1 1])
    hold off
    

