% Linear to non-linear time ratios.


% This part is to plot the teoretical linear to non-linear time ratio profiles
% %--------------------------------------------------------------------------
% %--------------------------------------------------------------------------
path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
% %--------------------------------------------------------------------------
% %--------------------------------------------------------------------------
% this is to see how the nonlinear parameter X=tau_lin/tau_nl should scale
% with distance y.

x0=45;y0=54;xx1=1100;yy1=400;

Lx=2*pi; % l_perp
Lz=2*pi; % l_parallel

fs=18;
x=linspace(0,10,200);

% Nonlinear time without fluctuations
%--------------------------------------------------------------------------
f45=figure(45);
zeta = 0.1; epsilon=0.1;
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(1,3,1)
a =1; y = (Lz/Lx) * zeta./sqrt((tanh(x./a)).^2 + epsilon.^2);
plot(x,y,'b',LineWidth=2)
hold on
a =2; y = (Lz/Lx) * zeta./sqrt((tanh(x./a)).^2 + epsilon.^2);
plot(x,y,'r',LineWidth=2)
a =4; y = (Lz/Lx) * zeta./sqrt((tanh(x./a)).^2 + epsilon.^2);
plot(x,y,'g',LineWidth=2)
y = (Lz/Lx) * zeta./sqrt(epsilon.^2 + 0); % this is the value at the x-line for epsilon=0.1
yline(y,'k',LineWidth=2)
y = (Lz/Lx) * zeta./sqrt(epsilon.^2 + 1);
yline(y,'k --',LineWidth=2) % this is the assymtotic value at the downstream region
%ylim([0.4,1])
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\chi_{l,nl}$';
ax.XLabel.String = '$y / d_{i}$';
legend('$\Delta=1d_{i}$','$\Delta=2d_{i}$','$\Delta=4d_{i}$','x-line','asym','Interpreter','latex','FontSize',1.0*fs)
title('$\epsilon=0.1 \ ; \ \xi_{b}=0.1 ; \ l_{\parallel} \sim l_{\perp}$' ,'Interpreter','latex','FontSize',1.0*fs)
hold off
%--------------------------------------------------------------------------
zeta=0.1; a=4;
subplot(1,3,2)
epsilon = 0.1; y = (Lz/Lx) * zeta./sqrt((tanh(x./a)).^2 + epsilon.^2);
plot(x,y,'b',LineWidth=2)
hold on
epsilon = 0.5; y = (Lz/Lx) * zeta./sqrt((tanh(x./a)).^2 + epsilon.^2);
plot(x,y,'r',LineWidth=2)
epsilon = 1; y = (Lz/Lx) * zeta./sqrt((tanh(x./a)).^2 + epsilon.^2);
plot(x,y,'g',LineWidth=2)
% These asymptotic values are obvius
% epsilon = 0.1;  y = (Lz/Lx) * zeta./sqrt(epsilon.^2); % this is the value at the x-line
% yline(y,'b --',LineWidth=2)
% epsilon = 0.5;  y = (Lz/Lx) * zeta./sqrt(epsilon.^2); % this is the value at the x-line
% yline(y,'r --',LineWidth=2)
% epsilon = 1.0;  y = (Lz/Lx) * zeta./sqrt(epsilon.^2); % this is the value at the x-line
% yline(y,'g --',LineWidth=2)
%ylim([0.4,1])
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\chi_{l,nl}$';
ax.XLabel.String = '$y / d_{i}$';
legend('$\epsilon=0.1$','$\epsilon=0.5$','$\epsilon=1$','Interpreter','latex','FontSize',1.0*fs)
title('$\Delta=4d_{i} \ ; \ \xi_{b}=0.1 ; \ l_{\parallel} \sim l_{\perp}$' ,'Interpreter','latex','FontSize',1.0*fs)
hold off
%--------------------------------------------------------------------------
epsilon = 0.1; a=4;
subplot(1,3,3)
zeta = 0.1; y = (Lz/Lx) * zeta./sqrt((tanh(x./a)).^2 + epsilon.^2);
plot(x,y,'b',LineWidth=2)
hold on
zeta = 0.5; y = (Lz/Lx) * zeta./sqrt((tanh(x./a)).^2 + epsilon.^2);
plot(x,y,'r',LineWidth=2)
zeta = 1; y = (Lz/Lx) * zeta./sqrt((tanh(x./a)).^2 + epsilon.^2);
plot(x,y,'g',LineWidth=2)
%ylim([0.4,1])
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\chi_{l,nl}$';
ax.XLabel.String = '$y / d_{i}$';
legend('$\xi_{b}=0.1$','$\xi_{b}=0.5$','$\xi_{b}=1$','Interpreter','latex','FontSize',1.0*fs)
title('$\Delta=4d_{i} \ ; \ \epsilon_{b}=0.1 ; \ l_{\parallel} \sim l_{\perp}$' ,'Interpreter','latex','FontSize',1.0*fs)
hold off
% %--------------------------------------------------------------------------

% Nonlinear time WITH the fluctuations
%--------------------------------------------------------------------------
f46=figure(46);
set(gcf,'position',[x0,y0,xx1,yy1])
zeta = 0.1; epsilon=0.1;
subplot(1,3,1)
a =1; y = (Lz/Lx) * zeta./sqrt((zeta + tanh(x./a)).^2 + zeta.^2 + epsilon.^2);
plot(x,y,'b',LineWidth=2)
hold on
a =2; y = (Lz/Lx) * zeta./sqrt((zeta + tanh(x./a)).^2 + zeta.^2 + epsilon.^2);
plot(x,y,'r',LineWidth=2)
a =4; y = (Lz/Lx) * zeta./sqrt((zeta + tanh(x./a)).^2 + zeta.^2 + epsilon.^2);
plot(x,y,'g',LineWidth=2)
y = (Lz/Lx) * zeta./sqrt(epsilon.^2 + 2*zeta.^2); % this is the value at the x-line for epsilon=0.1
yline(y,'k',LineWidth=2)
y = (Lz/Lx) * zeta./sqrt(epsilon.^2 + zeta.^2 + (1 +zeta).^2);
yline(y,'k --',LineWidth=2) % this is the assymtotic value at the downstream region
%ylim([0.4,1])
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\chi_{l,nl}$';
ax.XLabel.String = '$y / d_{i}$';
legend('$\Delta=1d_{i}$','$\Delta=2d_{i}$','$\Delta=4d_{i}$','x-line','asym','Interpreter','latex','FontSize',1.0*fs)
title('$\epsilon=0.1 \ ; \ \xi_{b}=0.1 ; \ l_{\parallel} \sim l_{\perp}$' ,'Interpreter','latex','FontSize',1.0*fs)
hold off
%--------------------------------------------------------------------------
zeta=0.1; a=4;
subplot(1,3,2)
epsilon = 0.1; y = (Lz/Lx) * zeta./sqrt((zeta + tanh(x./a)).^2 + zeta.^2 + epsilon.^2);
plot(x,y,'b',LineWidth=2)
hold on
epsilon = 0.5; y = (Lz/Lx) * zeta./sqrt((zeta + tanh(x./a)).^2 + zeta.^2 + epsilon.^2);
plot(x,y,'r',LineWidth=2)
epsilon = 1; y = (Lz/Lx) * zeta./sqrt((zeta + tanh(x./a)).^2 + zeta.^2 + epsilon.^2);
plot(x,y,'g',LineWidth=2)
%ylim([0.4,1])
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\chi_{l,nl}$';
ax.XLabel.String = '$y / d_{i}$';
legend('$\epsilon=0.1$','$\epsilon=0.5$','$\epsilon=1$','Interpreter','latex','FontSize',1.0*fs)
title('$\Delta=4d_{i} \ ; \ \xi_{b}=0.1 ; \ l_{\parallel} \sim l_{\perp}$' ,'Interpreter','latex','FontSize',1.0*fs)
hold off
%--------------------------------------------------------------------------
epsilon = 0.1; a=4;
subplot(1,3,3)
zeta = 0.1; y = (Lz/Lx) * zeta./sqrt((zeta + tanh(x./a)).^2 + zeta.^2 + epsilon.^2);
plot(x,y,'b',LineWidth=2)
hold on
zeta = 0.5; y = (Lz/Lx) * zeta./sqrt((zeta + tanh(x./a)).^2 + zeta.^2 + epsilon.^2);
plot(x,y,'r',LineWidth=2)
zeta = 1; y = (Lz/Lx) * zeta./sqrt((zeta + tanh(x./a)).^2 + zeta.^2 + epsilon.^2);
plot(x,y,'g',LineWidth=2)
%ylim([0.4,1])
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\chi_{l,nl}$';
ax.XLabel.String = '$y / d_{i}$';
legend('$\xi_{b}=0.1$','$\xi_{b}=0.5$','$\xi_{b}=1$','Interpreter','latex','FontSize',1.0*fs)
title('$\Delta=4d_{i} \ ; \ \epsilon_{b}=0.1 ; \ l_{\parallel} \sim l_{\perp}$' ,'Interpreter','latex','FontSize',1.0*fs)
hold off
%--------------------------------------------------------------------------
cd(path_comp)
saveas(f45,strcat(num2str(1),'xi_lnl.png'));
saveas(f46,strcat(num2str(1),'xi_lnl_fluc.png'));
%--------------------------------------------------------------------------
% %--------------------------------------------------------------------------
% %--------------------------------------------------------------------------




% Now let's try to get the meassurements of the linear non-linear time
% ratio
% %--------------------------------------------------------------------------
% %--------------------------------------------------------------------------
path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1';

path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';

%-----------------------------------------------------------------------------------------------------------------------
% For the scripts
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
%-----------------------------------------------------------------------------------------------------------------------

B0=0.2;
n0=1;
Vai=0.2;%0.2;
Vae=0.2;%0.2;
E0=0.2;%0.2; %??
T0=0.02;%0.02;
J0=Vae;

mime =1.;
omega_pe_Omega_ce=5;

MFT0=1; % is this simply one in this normalization
c=1; VA2c = 0.2;

cd(path)
S = dir(fullfile(path,'pfd.*.h5'));
N=numel(S); % number of files to use
H=zeros(N);
%--------------------------------------------------------------------------
S2 = dir(fullfile(path,'pfd_moments.*.h5'));
N2=numel(S2); % number of files to use
H2=zeros(N2);

in=6;


%for in=1:N
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
Lx=grid_length(4).Value(1);% - grid_length(3).Value(1);
Ly=grid_length(4).Value(2);% - grid_length(3).Value(2);
Lz=grid_length(4).Value(3);% - grid_length(3).Value(3);

resx=double(Lx)/double(dx);
resy=double(Ly)/double(dy);
resz=double(Lz)/double(dz); res=resy;

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
zll=linspace(-Lz,Lz,size_X(2));
yll=linspace(-Ly,Ly,size_X(1));

%[ZLL, YLL] = meshgrid(zll,yll);


% The average need to be related to the scale...

% Now let's compute the local B field.
% This requires to define where to get the averages

ly=length(yll);
Ly_2_0 = ly/2;
Ly_2_1 = Ly_2_0 + 1*Ly_2_0/4;
Ly_2_2 = Ly_2_0 + 2*Ly_2_0/4;
Ly_2_3 = Ly_2_0 + 3*Ly_2_0/4;
Ly_2_4 = Ly_2_0 + 4*Ly_2_0/4;

[ZLL,YLL] = meshgrid(zll,yll);
dummy_f = YLL;
YLL_1 = dummy_f(Ly_2_0:Ly_2_1,:);
dummy_f = ZLL;
ZLL_1 = dummy_f(Ly_2_0:Ly_2_1,:);

% Divide the top part of the harris into 4 sectors
%----------------------------------------------------------------------
dummy_f = Bx;
Bx_1 = dummy_f(Ly_2_0:Ly_2_1,:); % from the x-line to the top
% %     Bx_2 = dummy_f(Ly_2_1:Ly_2_2,:);
% %     Bx_3 = dummy_f(Ly_2_2:Ly_2_3,:);
% %     Bx_4 = dummy_f(Ly_2_3:Ly_2_4,:);

dummy_f = By;
By_1 = dummy_f(Ly_2_0:Ly_2_1,:); % from the x-line to the top
% %     By_2 = dummy_f(Ly_2_1:Ly_2_2,:);
% %     By_3 = dummy_f(Ly_2_2:Ly_2_3,:);
% %     By_4 = dummy_f(Ly_2_3:Ly_2_4,:);

dummy_f = Bz;
Bz_1 = dummy_f(Ly_2_0:Ly_2_1,:); % from the x-line to the top
% %     Bz_2 = dummy_f(Ly_2_1:Ly_2_2,:);
% %     Bz_3 = dummy_f(Ly_2_2:Ly_2_3,:);
% %     Bz_4 = dummy_f(Ly_2_3:Ly_2_4,:);
%----------------------------------------------------------------------

clearvars Bx By Bz


% This is to compute the local B in the Cho Visniac 2000
%----------------------------------------------------------------------

dummy_f = Bx_1; size_dum = size(dummy_f);
B_local_x_1=zeros(size_dum);
B_local_y_1=zeros(size_dum);
B_local_z_1=zeros(size_dum);

RYLL_1=zeros(size_dum);
RZLL_1=zeros(size_dum);

% %     dB_x_1=zeros(size_dum);
% %     dB_y_1=zeros(size_dum);
% %     dB_z_1=zeros(size_dum);

% initial values
%for a single pair of j0, k0;
j0=1; k0=1;
j=1;k=1;


% This is another way using four for loops
%----------------------------------------------------------------------
%{

    for j0=1:size_dum(1)-1
        for k0=1:size_dum(2)-1
            for j=j0:size_dum(1)-j0
                for k=1:size_dum(2)-k0
                    % the y21 and z21
                    RYLL_1(j,k) = YLL_1(j,k) - YLL_1(j0,k0);
                    RZLL_1(j,k) = ZLL_1(j,k) - ZLL_1(j0,k0);

                    % the components of the local magnetic field
                    B_local_x_1(j,k) = (Bx_1(j,k) + Bx_1(j0,k0))./2;
                    B_local_y_1(j,k) = (By_1(j,k) + By_1(j0,k0))./2;
                    B_local_z_1(j,k) = (Bz_1(j,k) + Bz_1(j0,k0))./2;

                    % the components of the fluctuations dB
                    dB_x_1(j,k) = Bx_1(j,k) - Bx_1(j0,k0);
                    dB_y_1(j,k) = By_1(j,k) - By_1(j0,k0);
                    dB_z_1(j,k) = Bz_1(j,k) - Bz_1(j0,k0);

                end
            end
        end
    end
%}
%----------------------------------------------------------------------
% This stores the info in cells
% This computes the difference with rescpect to the value in each cell and
% then stores the info as a cell array. The idea is to get the histograms
% for the values of Rpar Rperp y dB to get the average.
% this stores Blocal and dB as well
%--------------------------------------------------------------------------
%dummy_f = Bx_1; size_dum = size(dummy_f);

size_dum = [5,5];

% Get the R_par, R_perp, anf F2B in cells arrays for each difference
% plane (B - B(i,j))

B_local_mag_1=cell(size_dum);
Fb2_1=cell(size_dum);
R21_par_1=cell(size_dum);
R21_perp_1=cell(size_dum);

for j=1:size_dum(1)
    for k=1:size_dum(2)
        % the y21 and z21
        RYLL_1 = YLL_1 - YLL_1(j,k);
        RZLL_1 = ZLL_1 - ZLL_1(j,k);

        % the components of the local magnetic field
        B_local_x_1 = (Bx_1 + Bx_1(j,k))./2;
        B_local_y_1 = (By_1 + By_1(j,k))./2;
        B_local_z_1 = (Bz_1 + Bz_1(j,k))./2;

        % Compute the magnitud of the local field
        B_local_mag_1{j,k} = sqrt(B_local_x_1.^2 + B_local_y_1.^2 + B_local_z_1.^2);

        % Compute the unitary vectors that form the unitary vector that tells
        % the direction of the magnetic field
        x_hat = B_local_x_1./B_local_mag_1{j,k};
        y_hat = B_local_y_1./B_local_mag_1{j,k};
        z_hat = B_local_z_1./B_local_mag_1{j,k};

        % compute the parallel and perpendicular coordinates
        R21_par_1{j,k} = abs(RYLL_1.*y_hat  + RZLL_1.*z_hat);
        R21_perp_1{j,k} = sqrt( (y_hat.*RZLL_1  - z_hat.*RYLL_1).^2 +...
            (-x_hat.*RZLL_1).^2 + (x_hat.*RYLL_1).^2);

        % the components of the fluctuations dB
        dB_x_1 = Bx_1 - Bx_1(j,k);
        dB_y_1 = By_1 - By_1(j,k);
        dB_z_1 = Bz_1 - Bz_1(j,k);

        Fb2_1{j,k} = (dB_x_1.^2 + dB_y_1.^2 + dB_z_1.^2);

    end
end
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% get the maximum values of R_par and R_perp for all the difference
% planes

R21_par_max=zeros(size_dum(1),size_dum(1));
R21_perp_max=zeros(size_dum(2),size_dum(2));
for jj=1:size_dum(1)
    for kk=1:size_dum(2)
        %read each plane associated to the difference with that element
        R21_par_i=R21_par_1{jj,kk};
        R21_perp_i=R21_perp_1{jj,kk};
        R21_par_max(jj,kk) = max(max(R21_par_i));
        R21_perp_max(jj,kk) = max(max(R21_perp_i));
    end
end

R21_par_i_max = max(max(R21_par_max));
R21_perp_i_max = max(max(R21_perp_max));

R21_par_h = linspace(0,R21_par_i_max,51); % this generates different resolutions in par and perp
R21_perp_h = linspace(0,R21_perp_i_max,51);

%Make the grid
[R_PAR, R_PERP] = meshgrid(R21_par_h,R21_perp_h);
% fill the arary using a condition
Rpar_l_m = length(R21_par_h)-1;
Rperp_l_m = length(R21_perp_h)-1;
%--------------------------------------------------------------------------

% each pixel has a value of R_par, R_perp and Fb2
% Now lets create the grids and arrays for the histograms

% difference plane my have a different r_par and r_perp
%R21_par_i_max = max(max(R21_par_i));
%R21_perp_i_max = max(max(R21_perp_i));

%--------------------------------------------------------------------------
%Safe the Fb2 that fullfill the condition for each difference plane
Fb2_cond_i=cell(size_dum(1),size_dum(2),Rpar_l_m,Rperp_l_m);
for jj=1:size_dum(1)
    for kk=1:size_dum(2)
        %jj=1;kk=2;
        %read each plane associated to the difference with that element
        R21_par_i=R21_par_1{jj,kk};
        R21_perp_i=R21_perp_1{jj,kk};
        Fb2_i = Fb2_1{jj,kk};

        %i=1;ii=1;
        for i=1:Rpar_l_m
            for ii=1:Rperp_l_m
                %i=1;ii=1;
                cond11 = (R21_par_h(1,i) < R21_par_i);
                cond12 = (R21_par_i <= R21_par_h(1,i+1));
                cond1 = cond11.*cond12;
                cond21 = (R21_perp_h(1,ii) < R21_perp_i);
                cond22 = (R21_perp_i <= R21_perp_h(1,ii+1));
                cond2 = cond21.*cond22;
                Fb2_cond = Fb2_i.*(cond1.*cond2);
                Fb2_cond_i{jj,kk,i,ii} = Fb2_cond; % this correspons to each R_par R_perp pixel
                clearvars cond11 cond12 cond21 cond22 cond1 cond2
            end
        end

    end
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Now quantify the mean F2b and the number of counts N_mean
Fb2_cond_mean = zeros(size(R_PAR));
N_mean = zeros(size(R_PAR));
for i=1:Rpar_l_m
    for ii =1:Rperp_l_m
        %i=1;ii=1;
        %Add all the difference planes to increase the statistics
        Fb2_cond_total_d = zeros(size(dB_x_1));
        for jj=1:size_dum(1)
            for kk=1:size_dum(2)
                %jj=1;kk=1;
                Fb2_cond_total_i = Fb2_cond_i{jj,kk,i,ii};
                Fb2_cond_total_d = Fb2_cond_total_i + Fb2_cond_total_d;
            end
        end

        %remove the zero elements
        dum_A = nonzeros(Fb2_cond_total_d);
        N_mean_i=length(dum_A);
        %compute the mean value
        if(N_mean_i ~= 0)
            Fb2_cond_mean_i = sum(dum_A)/N_mean_i;
            Fb2_cond_mean(i,ii) = Fb2_cond_mean_i;
            N_mean(i,ii) = N_mean_i;
        else
            Fb2_cond_mean(i,ii) = nan;
            N_mean(i,ii) = nan;
        end
        clearvars Fb2_cond_total_i Fb2_cond_total_d
    end
end
%----------------------------------------------------------------------

%----------------------------------------------------------------------
f1=figure(1);
subplot(1,2,1)
hc=pcolor(R_PAR,R_PERP,log(Fb2_cond_mean));
set(hc,'edgecolor','none')
colorbar
subplot(1,2,2)
hc2=pcolor(R_PAR,R_PERP,N_mean);
set(hc2,'edgecolor','none')
colorbar
%----------------------------------------------------------------------

cd(path_comp)
saveas(f1,strcat(num2str(1),'F2b1.png'));

%----------------------------------------------------------------------

%compute averages
%----------------------------------------------------------------------
dummy_f = Bx_1; size_dum = size(dummy_f);
Bx_mean_1 = sum(dummy_f)./(size_dum(1)*size_dum(2));
dummy_f = Bx_2; size_dum = size(dummy_f);
Bx_mean_2 = sum(dummy_f)./(size_dum(1)*size_dum(2));
dummy_f = Bx_3; size_dum = size(dummy_f);
Bx_mean_3 = sum(dummy_f)./(size_dum(1)*size_dum(2));
dummy_f = Bx_4; size_dum = size(dummy_f);
Bx_mean_4 = sum(dummy_f)./(size_dum(1)*size_dum(2));

dummy_f = By_1; size_dum = size(dummy_f);
By_mean_1 = sum(dummy_f)./(size_dum(1)*size_dum(2));
dummy_f = By_2; size_dum = size(dummy_f);
By_mean_2 = sum(dummy_f)./(size_dum(1)*size_dum(2));
dummy_f = By_3; size_dum = size(dummy_f);
By_mean_3 = sum(dummy_f)./(size_dum(1)*size_dum(2));
dummy_f = By_4; size_dum = size(dummy_f);
By_mean_4 = sum(dummy_f)./(size_dum(1)*size_dum(2));

dummy_f = Bz_1; size_dum = size(dummy_f);
Bz_mean_1 = sum(dummy_f)./(size_dum(1)*size_dum(2));
dummy_f = Bz_2; size_dum = size(dummy_f);
Bz_mean_2 = sum(dummy_f)./(size_dum(1)*size_dum(2));
dummy_f = Bz_3; size_dum = size(dummy_f);
Bz_mean_3 = sum(dummy_f)./(size_dum(1)*size_dum(2));
dummy_f = Bz_4; size_dum = size(dummy_f);
Bz_mean_4 = sum(dummy_f)./(size_dum(1)*size_dum(2));
%----------------------------------------------------------------------

% This is to compute the local B field using averages
%----------------------------------------------------------------------
B_mag_local_1 = sqrt(Bx_mean_1.^2 + By_mean_1.^2 + Bz_mean_1.^2);
B_mag_local_2 = sqrt(Bx_mean_2.^2 + By_mean_2.^2 + Bz_mean_2.^2);
B_mag_local_3 = sqrt(Bx_mean_3.^2 + By_mean_3.^2 + Bz_mean_3.^2);
B_mag_local_4 = sqrt(Bx_mean_4.^2 + By_mean_4.^2 + Bz_mean_4.^2);
%----------------------------------------------------------------------

dB_x_1 = Bx(Ly_2_0:Ly_2_1,:) - Bx_mean_1;
dB_x_2 = Bx(Ly_2_1:Ly_2_2,:) - Bx_mean_2;
dB_x_3 = Bx(Ly_2_2:Ly_2_3,:) - Bx_mean_3;
dB_x_4 = Bx(Ly_2_3:Ly_2_4,:) - Bx_mean_4;

dB_y_1 = By(Ly_2_0:Ly_2_1,:) - By_mean_1;
dB_y_2 = By(Ly_2_1:Ly_2_2,:) - By_mean_2;
dB_y_3 = By(Ly_2_2:Ly_2_3,:) - By_mean_3;
dB_y_4 = By(Ly_2_3:Ly_2_4,:) - By_mean_4;

dB_z_1 = Bz(Ly_2_0:Ly_2_1,:) - Bz_mean_1;
dB_z_2 = Bz(Ly_2_1:Ly_2_2,:) - Bz_mean_2;
dB_z_3 = Bz(Ly_2_2:Ly_2_3,:) - Bz_mean_3;
dB_z_4 = Bz(Ly_2_3:Ly_2_4,:) - Bz_mean_4;


% Now lets think about the parallel and perpendicular scales

%How to get r21? for a given lack