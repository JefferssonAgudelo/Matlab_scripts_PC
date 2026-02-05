%-----------------------------------------------------------------------------------------------------------------------
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/Cirrus_folders/6cube';
%path = '/Users/jeffersson_agudelo/Downloads/data_desktop';
%path = '/Users/jeffersson_agudelo/Documents/New_psc/second_try_version/build_2/testing_jeff/lin_den'; % this has the problem _UP
%path = '/Users/jeffersson_agudelo/Documents/New_psc/second_try_version/build_2/testing_jeff/psc_turb_alf'; % this has the problem _UP
path = '/Volumes/PSC_DiRAC_DATA/Data_Cirrus/turb_alf_cam_3D_small';
%-----------------------------------------------------------------------------------------------------------------------

% For the scripts
path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
%-----------------------------------------------------------------------------------------------------------------------

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
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
in=input('select the time stamp: ');

fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;
B=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
%--------------------------------------------------------------------------
ss=size(B);
LXs=ss(1); LYs=ss(2); LZs=ss(3);
clearvars B
N_jn=N;
% %--------------------------------------------------------------------
% % Making a plot for B2 as a function of time to see the growth rate of
% the instability
% %--------------------------------------------------------------------

%--------------------------------------------------------------------------
nx1=1;    nx2=LXs;
ny1=1;    ny2=LYs;
nz1=1;    nz2=LZs;

px2 = nx2; py2 = ny2; pz2 = nz2;
start = [nx1 ny1 nz1];
count = [px2 py2 pz2];

% time_t_2=zeros(1,N);

%in = 1;

%for in=1:floor(N)

%------------------------------------------------------------------
disp(strcat('Computing step ...',S(in).name))
fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;
grid_dt = info.Groups(20).Attributes;

grid_length = info.Groups(17).Attributes;
Lx=grid_length(4).Value(1) - grid_length(3).Value(1); %(The substraction give the total size of the domain) -Lx0 to Lx0
Ly=grid_length(4).Value(2) - grid_length(3).Value(2);
Lz=grid_length(4).Value(3) - grid_length(3).Value(3);
%------------------------------------------------------------------

%------------------------------------------------------------------
%To make the coordinate transformation
%------------------------------------------------------------------
% Get the fiel name and remove the prt.
stri = S(in).name;
newStri = erase(stri,"pfd.");

% load the field files
Sm = dir(fullfile(path,'pfd_moments.*.h5'));
Nf=numel(Sm); % number of files to use

%The idea is to find the index that corresponds to the file that has
%the same name as in the prt info
Nff = {Sm.name};
Xff = contains(Nff,num2str(newStri));
jjn=find(Xff==1); % this finds the index
%Nff{Xff}
%------------------------------------------------------------------

%------------------------------------------------------------------
disp(strcat('Computing step ...',S2(jjn).name))
fileID2 =  S2(jjn).name; %change the 1 per i
%h5disp(fileID2);
info2 = h5info(fileID2);
moments_1st = info2.Groups(1).Name;
%----------------------------------------------------------------------

%----------------------------------------------------------------------
xl = linspace(-Lx/2,Lx/2,LXs);
yl = linspace(-Ly/2,Ly/2,LYs);
zl = linspace(-Lz/2,Lz/2,LZs);
%----------------------------------------------------------------------

% Here is where the parameter for the scale filtering are defined (the size of the window)
%----------------------------------------------------------------------
%----------------------------------------------------------------------
% define the window for the kernel and convolution

%for ndv =1:10
ndv = 1; % fractiopn of the box size. create a patch for the size of the convolution window
%l_wind_x = LXs/ndv; %size of the window

resx = Lx/LXs;
resy = Ly/LYs;
resz = Lz/LZs;
%----------------------------------------------------------------------

% Maybe it is better to define this in terms of the real resolution
%----------------------------------------------------------------------
%l_wind_x = (ndv/10)*Lx; %size of the window

l_wind_x = input('Window size:');
fprintf('\n');

l_wind_y = l_wind_x;
l_wind_z = l_wind_x;

[XL3d, YL3d, ZL3d] = meshgrid(xl,yl,zl);
%----------------------------------------------------------------------


% Define the gaussian kernel function
%----------------------------------------------------------------------
% First kernel
%----------------------------------------------------------------------
%----------------------------------------------------------------------
% C_gs = (1/(2.*pi.*l_wind_x.^2))^(3/2);
% G_gs = C_gs.*...
%    exp(-(0.5.*(XL3d./l_wind_x).^2)).*...
%    exp(-(0.5.*(YL3d./l_wind_y).^2)).*...
%    exp(-(0.5.*(ZL3d./l_wind_z).^2));
%----------------------------------------------------------------------
%----------------------------------------------------------------------
% %second kernel
% %----------------------------------------------------------------------
% C_gs = (1/(2.*pi.*l_wind_x.^2))^(3/2);
% G_gs = C_gs.*...
%     exp(-(0.5.*(XL3d./l_wind_x).^2)).*...
%     exp(-(0.5.*(YL3d./l_wind_y).^2)).*...
%     exp(-(0.5.*(ZL3d./l_wind_z).^2));
%----------------------------------------------------------------------

% G_gs_n = G_gs./sum(G_gs(:)); % This is to ensure that the integral of the kernel is one
% G_gs_n = G_gs;

% Perform the FFT of the function g
% F_G_gs_n = fftn(G_gs_n);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
% This is to test
%{
%----------------------------------------------------------------------
B{1,1}=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'),start,count);
Bx_dt=B{1,1};
Bx_filt = imgaussfilt3(Bx_dt,l_wind_x);
Bx_pri = Bx_dt - Bx_filt;

i=30;

f11=figure(11);
%subplot(2,5,ndv)
%dump = squeeze(Bx_filt(i,:,:));
dump = squeeze(Bx_filt(:,:,i));
hc=pcolor(dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
title(num2str(ndv))
%strcat(num2str(i),'Ohms_terms_regular.png')
hold off
% %----------------------------------------------------------------------

end


f2=figure(2);
% %----------------------------------------------------------------------
subplot(1,3,1)
%dump = squeeze(Bx_dt(i,:,:));
dump = squeeze(Bx_dt(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
title('Bx')
colorbar
hold off

subplot(1,3,2)
dump = squeeze(Bx_filt(:,:,i));
hc=pcolor(dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
title('<Bx>')
hold off

subplot(1,3,3)
dump = squeeze(Bx_pri(:,:,i));
hc=pcolor(dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
title('Bx_{pri} ' )
hold off
% %----------------------------------------------------------------------

BBx = Bx_dt;
BBx_f = imgaussfilt3(BBx,30);
f3=figure(3);
% %----------------------------------------------------------------------
subplot(1,2,1)
dump = squeeze(BBx(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
title('Bx')
colorbar
hold off
subplot(1,2,2)
dump = squeeze(BBx_f(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
title('Bx_f')
colorbar
hold off
%}
% %----------------------------------------------------------------------


% % This is the core and bulky part. Do not erare!
% %----------------------------------------------------------------------
% %----------------------------------------------------------------------
%
%----------------------------------------------------------------------
B{1,1}=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'),start,count);
B{1,2}=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'),start,count);
B{1,3}=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'),start,count);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
E{1,1}=h5read(fileID,strcat(EHJ_1st,'/ex_ec/p0/3d'),start,count);
E{1,2}=h5read(fileID,strcat(EHJ_1st,'/ey_ec/p0/3d'),start,count);
E{1,3}=h5read(fileID,strcat(EHJ_1st,'/ez_ec/p0/3d'),start,count);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
J{1,1}=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'),start,count);
J{1,2}=h5read(fileID,strcat(EHJ_1st,'/jy_ec/p0/3d'),start,count);
J{1,3}=h5read(fileID,strcat(EHJ_1st,'/jz_ec/p0/3d'),start,count);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
p_e{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e/p0/3d'),start,count);
p_e{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e/p0/3d'),start,count);
p_e{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e/p0/3d'),start,count);

p_i{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i/p0/3d'),start,count);
p_i{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i/p0/3d'),start,count);
p_i{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i/p0/3d'),start,count);
%----------------------------------------------------------------------

% % % % The permutation is necessary to get the correct order in the derivatives.
% % % %Byp = permute(B{1,2},[2,1,3]);
% % % %----------------------------------------------------------------------
% % % B{1,1} = permute(B{1,1},[2,1,3]);
% % % B{1,2} = permute(B{1,2},[2,1,3]);
% % % B{1,3} = permute(B{1,3},[2,1,3]);
% % %
% % % E{1,1} = permute(E{1,1},[2,1,3]);
% % % E{1,2} = permute(E{1,2},[2,1,3]);
% % % E{1,3} = permute(E{1,3},[2,1,3]);
% % %
% % % % The current is negative
% % % %-----------------------------------
% % % J{1,1} = permute(J{1,1},[2,1,3]);
% % % J{1,2} = permute(J{1,2},[2,1,3]);
% % % J{1,3} = permute(J{1,3},[2,1,3]);
% % % %----------------------------------------------------------------------

%----------------------------------------------------------------------
n_e0=h5read(fileID2,strcat(moments_1st,'/rho_e/p0/3d'),start,count);
n_i0=h5read(fileID2,strcat(moments_1st,'/rho_i/p0/3d'),start,count);

% % % n_e0 = permute(n_e0,[2,1,3]);
% % % n_i0 = permute(n_i0,[2,1,3]);

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

%--------------------------------------------------------------------

%--------------------------------------------------------------------


% This is to verify that J = -qeneve + qinivi
%--------------------------------------------------------------------
%{
v_ex = v_e{1,1};
v_ey = v_e{1,2};
v_ez = v_e{1,3};

v_ix = v_i{1,1};
v_iy = v_i{1,2};
v_iz = v_i{1,3};

f1=figure(1);
subplot(1,2,1)
dum=J{1,1};
dump = squeeze(dum(:,10,25));
plot(dump)
hold on
title('Jx')
ylim([-0.015 0.035])
hold off

subplot(1,2,2)
dum=(v_ix.*n_i0 - v_ex.*n_e0);
dump = squeeze(dum(:,10,25));
plot(dump)
hold on
title('J_calc')
ylim([-0.015 0.035])
hold off
%}
%--------------------------------------------------------------------


%----------------------------------------------------------------------
Pij_e{1,1}=h5read(fileID2,strcat(moments_1st,'/txx_e/p0/3d'),start,count);
Pij_e{2,2}=h5read(fileID2,strcat(moments_1st,'/tyy_e/p0/3d'),start,count);
Pij_e{3,3}=h5read(fileID2,strcat(moments_1st,'/tzz_e/p0/3d'),start,count);
Pij_e{1,2}=h5read(fileID2,strcat(moments_1st,'/txy_e/p0/3d'),start,count);
Pij_e{1,3}=h5read(fileID2,strcat(moments_1st,'/tzx_e/p0/3d'),start,count);
Pij_e{2,3}=h5read(fileID2,strcat(moments_1st,'/tyz_e/p0/3d'),start,count);
Pij_e{2,1} = Pij_e{1,2}; Pij_e{3,2} = Pij_e{2,3}; Pij_e{3,1} = Pij_e{1,3};

pressure_ion = input('compute pressure terms 1 (true) 0(false) (integer):');
fprintf('\n');

if(pressure_ion == 1)
    Pij_i{1,1}=h5read(fileID2,strcat(moments_1st,'/txx_i/p0/3d'),start,count);
    Pij_i{2,2}=h5read(fileID2,strcat(moments_1st,'/tyy_i/p0/3d'),start,count);
    Pij_i{3,3}=h5read(fileID2,strcat(moments_1st,'/tzz_i/p0/3d'),start,count);
    Pij_i{1,2}=h5read(fileID2,strcat(moments_1st,'/txy_i/p0/3d'),start,count);
    Pij_i{1,3}=h5read(fileID2,strcat(moments_1st,'/tzx_i/p0/3d'),start,count);
    Pij_i{2,3}=h5read(fileID2,strcat(moments_1st,'/tyz_i/p0/3d'),start,count);
    Pij_i{2,1} = Pij_i{1,2}; Pij_i{3,2} = Pij_i{2,3}; Pij_i{3,1} = Pij_i{1,3};
end
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
        if(pressure_ion == 1)
            PPij_i{i,j} = Pij_i{i,j} - 1.*n_i0.*mi.*v_i{1,i}.*v_i{1,j};
        end
        PPij_e{i,j} = Pij_e{i,j} - 1.*n_e0.*me.*v_e{1,i}.*v_e{1,j};
    end
end

% remove the variables just to rename them again
clearvars Pij_i Pij_e

% This is just to rename the variable
if(pressure_ion == 1)
    Pij_i = PPij_i;
end

Pij_e = PPij_e;

clearvars PPij_i PPij_e
%----------------------------------------------------------------------


% If the detrend is not need it ?
%----------------------------------------------------------------------
%----------------------------------------------------------------------
% This is how the derivatives should B computed.
% The gradient with % y,x,z
%It seems the problem is that the plot (PCOLOR) goes in the wrong direction. xl goes
%in the vertical and yl in the horizontal when doing the plot
%--------------------------------------------------------------------------
%{
Bx_dt=B{1,1};
By_dt=B{1,2};
Bz_dt=B{1,3};

Ex_dt=E{1,1};
Ey_dt=E{1,2};
Ez_dt=E{1,3};

Jx_dt=J{1,1};
Jy_dt=J{1,2};
Jz_dt=J{1,3};
clearvars B E J
%--------------------------------------------------------------------------
grad_fact=1;
[Bx_dt2_y, Bx_dt2_x, Bx_dt2_z] = gradient(imgaussfilt(Bx_dt ,sigma_g));
[By_dt2_y, By_dt2_x, By_dt2_z] = gradient(imgaussfilt(By_dt ,sigma_g));
[Bz_dt2_y, Bz_dt2_x, Bz_dt2_z] = gradient(imgaussfilt(Bz_dt ,sigma_g));

Div_B_dt2 = Bx_dt2_x/(grad_fact.*resx) + By_dt2_y/(grad_fact.*resy) + Bz_dt2_z/(grad_fact.*resz);

J_x2 = Bz_dt2_y/(grad_fact.*resy) - By_dt2_z/(grad_fact.*resz);
J_y2 = Bx_dt2_z/(grad_fact.*resz) - Bz_dt2_x/(grad_fact.*resx);
J_z2 = By_dt2_x/(grad_fact.*resx) - Bx_dt2_y/(grad_fact.*resy);
%--------------------------------------------------------------------------

%This figure show the agreement between J and curl B
%--------------------------------------------------------------------------
f5=figure(5);
subplot(1,3,1)
dum=Jx_dt;
dump = squeeze(dum(end,:,:));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
title('J_{x}')
subplot(1,3,2)
dum=J_x2;
dump = squeeze(dum(end,:,:));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
title('(\nabla \times B)_{x}')
subplot(1,3,3)
dum=Jx_dt;
dump = squeeze(dum(end,1,:));
plot(zl,dump,'-r');
hold on
dum=J_x2;
dump = squeeze(dum(end,1,:));
y_lim = max(max(max(abs(dump))));
plot(zl,dump,'-b');
ylim([-y_lim y_lim])
title('J_{x}')
%}
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%It seems the problem is that the plot (PCOLOR) goes in the wrong direction. xl goes
%in the vertical and yl in the horizontal when doing the plot
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%{
f2=figure(2);
subplot(3,3,1)
dum = Bx_dt2_x; 
dump = squeeze(dum(:,:,end));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
title('Bx_dt2_x')
colorbar
hold off

subplot(3,3,2)
dum = Bx_dt2_y; 
dump = squeeze(dum(:,:,end));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
title('Bx_dt2_y')
hold off

subplot(3,3,3)
dum = Bx_dt2_z; 
dump = squeeze(dum(:,:,end));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
title('Bx_dt2_z')
hold off

subplot(3,3,4)
dum = By_dt2_x; 
dump = squeeze(dum(:,:,end));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
title('By_dt2_x')
hold off

subplot(3,3,5)
dum = By_dt2_y; 
dump = squeeze(dum(:,:,end));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
title('By_dt2_y')
hold off

subplot(3,3,6)
dum = By_dt2_z; 
dump = squeeze(dum(:,:,end));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
title('By_dt2_z')
hold off

subplot(3,3,7)
dum = Bz_dt2_x; 
dump = squeeze(dum(:,:,end));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
title('Bz_dt2_x')
hold off

subplot(3,3,8)
dum = Bz_dt2_y; 
dump = squeeze(dum(:,:,end));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
title('Bz_dt2_y')
hold off

subplot(3,3,9)
dum = Bz_dt2_z; 
dump = squeeze(dum(:,:,end));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
title('Bz_dt2_z')
hold off
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
f3=figure(3);
subplot(3,3,1)
dum=Jx_dt;
%dum = Bx_dt2_x; 
dump = squeeze(dum(:,:,end));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
xlabel('xl')
ylabel('yl')
title('Jx_teo')

subplot(3,3,2)
dum=Jy_dt;
%dum = Bx_dt2_y; 
dump = squeeze(dum(:,:,end));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
xlabel('xl')
ylabel('yl')
title('Jy_teo')

subplot(3,3,3)
dum=Jz_dt;
%dum = Bx_dt2_z; 
dump = squeeze(dum(:,:,end));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
xlabel('xl')
ylabel('yl')
title('Jz_teo')

subplot(3,3,4)
dum=Jx_dt;
%dum = By_dt2_x; 
dump = squeeze(dum(:,end,:));% norm y
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,zl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
xlabel('xl')
ylabel('zl')
title('Jx_teo')

subplot(3,3,5)
dum=Jy_dt;
%dum = By_dt2_y; 
dump = squeeze(dum(:,end,:));% norm y
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,zl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
xlabel('xl')
ylabel('zl')
title('Jy_teo')

subplot(3,3,6)
dum=Jz_dt;
%dum = By_dt2_z; 
dump = squeeze(dum(:,end,:)); % norm y
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,zl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
xlabel('xl')
ylabel('zl')
title('Jz_teo')

subplot(3,3,7)
dum=Jx_dt;
%dum = Bz_dt2_x; 
dump = squeeze(dum(end,:,:));
y_lim = max(max(max(abs(dump))));
hc=pcolor(yl,zl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
xlabel('yl')
ylabel('zl')
title('Jx_teo')

subplot(3,3,8)
dum=Jy_dt;
%dum = Bz_dt2_y; 
dump = squeeze(dum(end,:,:));
y_lim = max(max(max(abs(dump))));
hc=pcolor(yl,zl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
xlabel('yl')
ylabel('zl')
title('Jy_teo')

subplot(3,3,9)
dum=Jz_dt;
%dum = Bz_dt2_z; 
dump = squeeze(dum(end,:,:));
y_lim = max(max(max(abs(dump))));
hc=pcolor(yl,zl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
xlabel('yl')
ylabel('zl')
title('Jz_teo')
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
f4=figure(4);
dum=Div_B_dt2;
dump = squeeze(dum(:,:,end));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
title('Div_B_dt2')
%--------------------------------------------------------------------------
%}
%--------------------------------------------------------------------

n_e0_dt = n_e0;
n_i0_dt = n_i0;
n_0_dt = (n_e0_dt.*me + n_i0_dt.*mi)./(me + mi);

clearvars n_e0 n_i0

v_ex_dt=v_e{1,1};
v_ey_dt=v_e{1,2};
v_ez_dt=v_e{1,3};

v_ix_dt=v_i{1,1};
v_iy_dt=v_i{1,2};
v_iz_dt=v_i{1,3};

clearvars v_i v_e

v_x_dt = (me.*n_e0_dt.*v_ex_dt + mi.*n_i0_dt.*v_ix_dt)./(me.*n_e0_dt + mi.*n_i0_dt);
v_y_dt = (me.*n_e0_dt.*v_ey_dt + mi.*n_i0_dt.*v_iy_dt)./(me.*n_e0_dt + mi.*n_i0_dt);
v_z_dt = (me.*n_e0_dt.*v_ez_dt + mi.*n_i0_dt.*v_iz_dt)./(me.*n_e0_dt + mi.*n_i0_dt);

if(pressure_ion == 1)
    Pij_ixx_dt=Pij_i{1,1};
    Pij_ixy_dt=Pij_i{1,2};
    Pij_ixz_dt=Pij_i{1,3};
    Pij_iyy_dt=Pij_i{2,2};
    Pij_iyz_dt=Pij_i{2,3};
    Pij_izz_dt=Pij_i{3,3};
end

%Pij_iyx_dt = Pij_ixy_dt; Pij_izx_dt = Pij_ixz_dt; Pij_izy_dt = Pij_iyz_dt;

Pij_exx_dt=Pij_e{1,1};
Pij_exy_dt=Pij_e{1,2};
Pij_exz_dt=Pij_e{1,3};
Pij_eyy_dt=Pij_e{2,2};
Pij_eyz_dt=Pij_e{2,3};
Pij_ezz_dt=Pij_e{3,3};

%Pij_eyx_dt = Pij_exy_dt; Pij_ezx_dt = Pij_exz_dt; Pij_ezy_dt = Pij_eyz_dt;

clearvars Pij_i Pij_e
%----------------------------------------------------------------------

Bx_dt=B{1,1};
By_dt=B{1,2};
Bz_dt=B{1,3};

Ex_dt=E{1,1};
Ey_dt=E{1,2};
Ez_dt=E{1,3};

Jx_dt=J{1,1};
Jy_dt=J{1,2};
Jz_dt=J{1,3};
clearvars B E J

% This is a plot to see if E and vxB are similar. But it seems they are not
%--------------------------------------------------------------------------
%{
v_x_B_x_dt = v_y_dt.*Bz_dt - v_z_dt.*By_dt;
v_x_B_y_dt = v_z_dt.*Bx_dt - v_x_dt.*Bz_dt;
v_x_B_z_dt = v_x_dt.*By_dt - v_y_dt.*Bx_dt;

f1=figure(1);
subplot(1,3,1)
dum=Ex_dt;
dump = squeeze(dum(:,:,50));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
title('Ex')
hold off

subplot(1,3,2)
dum=v_x_B_x_dt;
dump = squeeze(dum(:,:,50));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump');
hold on
set(hc,'edgecolor','none')
colorbar
title('vxBx')
hold off

subplot(1,3,3)
dum=Ex_dt;
dump = squeeze(dum(:,50,50));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'-r');
hold on
dum=v_x_B_x_dt;
dump = squeeze(dum(:,50,50));
%y_lim = max(max(max(abs(dump))));
plot(xl,dump,'-b');
legend('Ex','vxBx')
hold off
%}
%--------------------------------------------------------------------------


%----------------------------------------------------------------------
%select the component % component x=1, y=2, z=3;
component = input('select the component % component x=1, y=2, z=3: ');
%----------------------------------------------------------------------

% Lets compute the generalised ohms terms for total field
%----------------------------------------------------------------------
% Computing non-linear terms for the generalised Ohms law
%----------------------------------------------------------------------

if (component == 1)
    v_x_B_x_dt = v_y_dt.*Bz_dt - v_z_dt.*By_dt;
    J_x_B_x_dt = Jy_dt.*Bz_dt - Jz_dt.*By_dt;
elseif (component == 2)
    v_x_B_y_dt = v_z_dt.*Bx_dt - v_x_dt.*Bz_dt;
    J_x_B_y_dt = Jz_dt.*Bx_dt - Jx_dt.*Bz_dt;
elseif (component == 3)
    v_x_B_z_dt = v_x_dt.*By_dt - v_y_dt.*Bx_dt;
    J_x_B_z_dt = Jx_dt.*By_dt - Jy_dt.*Bx_dt;
end

v_J_xx_dt = v_x_dt.*Jx_dt;
v_J_xy_dt = v_x_dt.*Jy_dt;
v_J_xz_dt = v_x_dt.*Jz_dt;
v_J_yx_dt = v_y_dt.*Jx_dt;
v_J_yy_dt = v_y_dt.*Jy_dt;
v_J_yz_dt = v_y_dt.*Jz_dt;
v_J_zx_dt = v_z_dt.*Jx_dt;
v_J_zy_dt = v_z_dt.*Jy_dt;
v_J_zz_dt = v_z_dt.*Jz_dt;

J_v_xx_dt = Jx_dt.*v_x_dt;
J_v_xy_dt = Jx_dt.*v_y_dt;
J_v_xz_dt = Jx_dt.*v_z_dt;
J_v_yx_dt = Jy_dt.*v_x_dt;
J_v_yy_dt = Jy_dt.*v_y_dt;
J_v_yz_dt = Jy_dt.*v_z_dt;
J_v_zx_dt = Jz_dt.*v_x_dt;
J_v_zy_dt = Jz_dt.*v_y_dt;
J_v_zz_dt = Jz_dt.*v_z_dt;

J_J_2n_xx_dt = Jx_dt.*Jx_dt./(n_0_dt );
J_J_2n_xy_dt = Jx_dt.*Jy_dt./(n_0_dt );
J_J_2n_xz_dt = Jx_dt.*Jz_dt./(n_0_dt );
J_J_2n_yy_dt = Jy_dt.*Jy_dt./(n_0_dt );
J_J_2n_yz_dt = Jy_dt.*Jz_dt./(n_0_dt );
J_J_2n_zz_dt = Jz_dt.*Jz_dt./(n_0_dt );
%----------------------------------------------------------------------

%----------------------------------------------------------------------
%Now let lets compute the gradients
grad_fact = 1; % This always need to be two??
sigma_g=1;
%Grad_Pe
%----------------------------------------------------------------------

%--------------------------------------------------------------------------
% This part shows that the gradient and the divergence work well when the
% input array is well defined.
% Maybe the problem comes from the fact that the B field is not correctly
% set
% grad_fact = 1 is the correct definition
%--------------------------------------------------------------------------
%{
i=100;
j=100;

Bx_dt2_p = cos(YL3d);
By_dt2_p = cos(ZL3d);
Bz_dt2_p = cos(XL3d);

Jx_teo = sin(ZL3d);
Jy_teo = sin(XL3d);
Jz_teo = sin(YL3d);

[Bx_dt2_x, Bx_dt2_y, Bx_dt2_z] = gradient(Bx_dt);%gradient(imgaussfilt(Bx_dt ,sigma_g));
[By_dt2_x, By_dt2_y, By_dt2_z] = gradient(By_dt);%gradient(imgaussfilt(By_dt ,sigma_g));
[Bz_dt2_x, Bz_dt2_y, Bz_dt2_z] = gradient(Bz_dt);%gradient(imgaussfilt(Bz_dt ,sigma_g));

Div_B_dt2 = Bx_dt2_x/(grad_fact.*resx) + By_dt2_y/(grad_fact.*resx) + Bz_dt2_z/(grad_fact.*resx);

J_x2 = Bz_dt2_y/(grad_fact.*resx) - By_dt2_z/(grad_fact.*resx);
J_y2 = Bx_dt2_z/(grad_fact.*resx) - Bz_dt2_x/(grad_fact.*resx);
J_z2 = By_dt2_x/(grad_fact.*resx) - Bx_dt2_y/(grad_fact.*resx);

f4=figure(4);
subplot(1,3,1)
%dum=Jy_dt;
dum = J_x2;
%dum=Bz_dt2_x;
dump = squeeze(dum(:,:,end));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
title('Jy_teo')
subplot(1,3,2)
%dum=Jy_dt;
dum = J_y2;
%dum=Bz_dt2_y;
dump = squeeze(dum(:,:,end));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
title('J_y2')
subplot(1,3,3)
dum=Div_B_dt2;
%dum=Jz_dt;
%dum = J_z2;
%dum=Bz_dt2_z;
dump = squeeze(dum(:,:,end));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
colorbar
clim([-y_lim y_lim])
title('Div_B_dt2')
%}
%--------------------------------------------------------------------

%----------------------------------------------------------------------
[Pij_exx_dt_y, Pij_exx_dt_x, Pij_exx_dt_z] = gradient(Pij_exx_dt);
[Pij_eyy_dt_y, Pij_eyy_dt_x, Pij_eyy_dt_z] = gradient(Pij_eyy_dt);
[Pij_ezz_dt_y, Pij_ezz_dt_x, Pij_ezz_dt_z] = gradient(Pij_ezz_dt);
[Pij_exy_dt_y, Pij_exy_dt_x, Pij_exy_dt_z] = gradient(Pij_exy_dt);
[Pij_exz_dt_y, Pij_exz_dt_x, Pij_exz_dt_z] = gradient(Pij_exz_dt);
[Pij_eyz_dt_y, Pij_eyz_dt_x, Pij_eyz_dt_z] = gradient(Pij_eyz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    Div_Pe_dt_x = Pij_exx_dt_x/(grad_fact.*resx) + Pij_exy_dt_y/(grad_fact.*resy) + Pij_exz_dt_z/(grad_fact.*resz);
elseif (component == 2)
    Div_Pe_dt_y = Pij_exy_dt_x/(grad_fact.*resx) + Pij_eyy_dt_y/(grad_fact.*resy) + Pij_eyz_dt_z/(grad_fact.*resz);
elseif (component == 3)
    Div_Pe_dt_z = Pij_exz_dt_x/(grad_fact.*resx) + Pij_eyz_dt_y/(grad_fact.*resy) + Pij_ezz_dt_z/(grad_fact.*resz);
end
clearvars Pij_exx_dt_* Pij_exy_dt_* Pij_exz_dt_* ...
    Pij_eyy_dt_* Pij_eyz_dt_* Pij_ezz_dt_* ...
    %----------------------------------------------------------------------

if(pressure_ion == 1)
    %----------------------------------------------------------------------
    [Pij_ixx_dt_y, Pij_ixx_dt_x, Pij_ixx_dt_z] = gradient(Pij_ixx_dt);
    [Pij_iyy_dt_y, Pij_iyy_dt_x, Pij_iyy_dt_z] = gradient(Pij_iyy_dt);
    [Pij_izz_dt_y, Pij_izz_dt_x, Pij_izz_dt_z] = gradient(Pij_izz_dt);
    [Pij_ixy_dt_y, Pij_ixy_dt_x, Pij_ixy_dt_z] = gradient(Pij_ixy_dt);
    [Pij_ixz_dt_y, Pij_ixz_dt_x, Pij_ixz_dt_z] = gradient(Pij_ixz_dt);
    [Pij_iyz_dt_y, Pij_iyz_dt_x, Pij_iyz_dt_z] = gradient(Pij_iyz_dt);
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    if (component == 1)
        Div_Pi_dt_x = Pij_ixx_dt_x/(grad_fact.*resx) + Pij_ixy_dt_y/(grad_fact.*resy) + Pij_ixz_dt_z/(grad_fact.*resz);
    elseif (component == 2)
        Div_Pi_dt_y = Pij_ixy_dt_x/(grad_fact.*resx) + Pij_iyy_dt_y/(grad_fact.*resy) + Pij_iyz_dt_z/(grad_fact.*resz);
    elseif (component == 3)
        Div_Pi_dt_z = Pij_ixz_dt_x/(grad_fact.*resx) + Pij_iyz_dt_y/(grad_fact.*resy) + Pij_izz_dt_z/(grad_fact.*resz);
    end
    clearvars Pij_ixx_dt_* Pij_ixy_dt_* Pij_ixz_dt_* ...
        Pij_iyy_dt_* Pij_iyz_dt_* Pij_izz_dt_* ...
        %----------------------------------------------------------------------
end

%----------------------------------------------------------------------
[v_J_dt_xx_y, v_J_dt_xx_x, v_J_dt_xx_z] = gradient(v_J_xx_dt);
[v_J_dt_xy_y, v_J_dt_xy_x, v_J_dt_xy_z] = gradient(v_J_xy_dt);
[v_J_dt_xz_y, v_J_dt_xz_x, v_J_dt_xz_z] = gradient(v_J_xz_dt);
[v_J_dt_yx_y, v_J_dt_yx_x, v_J_dt_yx_z] = gradient(v_J_yx_dt);
[v_J_dt_yy_y, v_J_dt_yy_x, v_J_dt_yy_z] = gradient(v_J_yy_dt);
[v_J_dt_yz_y, v_J_dt_yz_x, v_J_dt_yz_z] = gradient(v_J_yz_dt);
[v_J_dt_zx_y, v_J_dt_zx_x, v_J_dt_zx_z] = gradient(v_J_zx_dt);
[v_J_dt_zy_y, v_J_dt_zy_x, v_J_dt_zy_z] = gradient(v_J_zy_dt);
[v_J_dt_zz_y, v_J_dt_zz_x, v_J_dt_zz_z] = gradient(v_J_zz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    Div_vJ_dt_x = v_J_dt_xx_x/(grad_fact.*resx) + v_J_dt_yx_y/(grad_fact.*resy) + v_J_dt_zx_z/(grad_fact.*resz);
elseif (component == 2)
    Div_vJ_dt_y = v_J_dt_xy_x/(grad_fact.*resx) + v_J_dt_yy_y/(grad_fact.*resy) + v_J_dt_zy_z/(grad_fact.*resz);
elseif (component == 3)
    Div_vJ_dt_z = v_J_dt_xz_x/(grad_fact.*resx) + v_J_dt_yz_y/(grad_fact.*resy) + v_J_dt_zz_z/(grad_fact.*resz);
end

clearvars v_J_dt_xx_* v_J_dt_xy_* v_J_dt_xz_* ...
    v_J_dt_yx_* v_J_dt_yy_* v_J_dt_yz_* ...
    v_J_dt_zx_* v_J_dt_zy_* v_J_dt_zz_*
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[J_v_dt_xx_y, J_v_dt_xx_x, J_v_dt_xx_z] = gradient(J_v_xx_dt);
[J_v_dt_xy_y, J_v_dt_xy_x, J_v_dt_xy_z] = gradient(J_v_xy_dt);
[J_v_dt_xz_y, J_v_dt_xz_x, J_v_dt_xz_z] = gradient(J_v_xz_dt);
[J_v_dt_yx_y, J_v_dt_yx_x, J_v_dt_yx_z] = gradient(J_v_yx_dt);
[J_v_dt_yy_y, J_v_dt_yy_x, J_v_dt_yy_z] = gradient(J_v_yy_dt);
[J_v_dt_yz_y, J_v_dt_yz_x, J_v_dt_yz_z] = gradient(J_v_yz_dt);
[J_v_dt_zx_y, J_v_dt_zx_x, J_v_dt_zx_z] = gradient(J_v_zx_dt);
[J_v_dt_zy_y, J_v_dt_zy_x, J_v_dt_zy_z] = gradient(J_v_zy_dt);
[J_v_dt_zz_y, J_v_dt_zz_x, J_v_dt_zz_z] = gradient(J_v_zz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    Div_Jv_dt_x = J_v_dt_xx_x/(grad_fact.*resx) + J_v_dt_yx_y/(grad_fact.*resy) + J_v_dt_zx_z/(grad_fact.*resz);
elseif (component == 2)
    Div_Jv_dt_y = J_v_dt_xy_x/(grad_fact.*resx) + J_v_dt_yy_y/(grad_fact.*resy) + J_v_dt_zy_z/(grad_fact.*resz);
elseif (component == 3)
    Div_Jv_dt_z = J_v_dt_xz_x/(grad_fact.*resx) + J_v_dt_yz_y/(grad_fact.*resy) + J_v_dt_zz_z/(grad_fact.*resz);
end

clearvars J_v_dt_xx_* J_v_dt_xy_* J_v_dt_xz_* ...
    J_v_dt_yx_* J_v_dt_yy_* J_v_dt_yz_* ...
    J_v_dt_zx_* J_v_dt_zy_* J_v_dt_zz_*
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[J_J_dt_xx_y, J_J_dt_xx_x, J_J_dt_xx_z] = gradient(J_J_2n_xx_dt);
[J_J_dt_xy_y, J_J_dt_xy_x, J_J_dt_xy_z] = gradient(J_J_2n_xy_dt);
[J_J_dt_xz_y, J_J_dt_xz_x, J_J_dt_xz_z] = gradient(J_J_2n_xz_dt);
[J_J_dt_yy_y, J_J_dt_yy_x, J_J_dt_yy_z] = gradient(J_J_2n_yy_dt);
[J_J_dt_yz_y, J_J_dt_yz_x, J_J_dt_yz_z] = gradient(J_J_2n_yz_dt);
[J_J_dt_zz_y, J_J_dt_zz_x, J_J_dt_zz_z] = gradient(J_J_2n_zz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    Div_JJ_dt_x = J_J_dt_xx_x/(grad_fact.*resx) + J_J_dt_xy_y/(grad_fact.*resy) + J_J_dt_xz_z/(grad_fact.*resz);
elseif (component == 2)
    Div_JJ_dt_y = J_J_dt_xy_x/(grad_fact.*resx) + J_J_dt_yy_y/(grad_fact.*resy) + J_J_dt_yz_z/(grad_fact.*resz);
elseif (component == 3)
    Div_JJ_dt_z = J_J_dt_xz_x/(grad_fact.*resx) + J_J_dt_yz_y/(grad_fact.*resy) + J_J_dt_zz_z/(grad_fact.*resz);
end

clearvars J_J_dt_xx_* J_J_dt_xy_* J_J_dt_xz_* ...
    J_J_dt_yy_* J_J_dt_yz_* J_J_dt_zz_*
%----------------------------------------------------------------------


%(<vJ + Jv - JJ/n> - (<v><J> + <J><v> - <J><J>/<n>))/<n>
% % %----------------------------------------------------------------------
sub_tau1_xx = v_J_xx_dt + J_v_xx_dt - J_J_2n_xx_dt;
sub_tau1_xy = v_J_xy_dt + J_v_xy_dt - J_J_2n_xy_dt;
sub_tau1_xz = v_J_xz_dt + J_v_xz_dt - J_J_2n_xz_dt;
sub_tau1_yx = v_J_yx_dt + J_v_yx_dt - J_J_2n_xy_dt;
sub_tau1_yy = v_J_yy_dt + J_v_yy_dt - J_J_2n_yy_dt;
sub_tau1_yz = v_J_yz_dt + J_v_yz_dt - J_J_2n_yz_dt;
sub_tau1_zx = v_J_zx_dt + J_v_zx_dt - J_J_2n_xz_dt;
sub_tau1_zy = v_J_zy_dt + J_v_zy_dt - J_J_2n_yz_dt;
sub_tau1_zz = v_J_zz_dt + J_v_zz_dt - J_J_2n_zz_dt;
% % %----------------------------------------------------------------------

clearvars v_J_* J_v_* J_J_*

%----------------------------------------------------------------------
% I need to discusse this with julia
% Detrend the variable to keep only the fluctuating part
%----------------------------------------------------------------------
%{
    %----------------------------------------------------------------------
    Bx_dt=B{1,1}-mean(mean(mean((B{1,1})))); 
    By_dt=B{1,2}-mean(mean(mean((B{1,2})))); 
    Bz_dt=B{1,3}-mean(mean(mean((B{1,3}))));

    Ex_dt=E{1,1}-mean(mean(mean((E{1,1})))); 
    Ey_dt=E{1,2}-mean(mean(mean((E{1,2})))); 
    Ez_dt=E{1,3}-mean(mean(mean((E{1,3}))));

    Jx_dt=B{1,1}-mean(mean(mean((J{1,1})))); 
    Jy_dt=B{1,2}-mean(mean(mean((J{1,2})))); 
    Jz_dt=B{1,3}-mean(mean(mean((J{1,3}))));
    clearvars B E J

    v_ix_dt=v_i{1,1}-mean(mean(mean((v_i{1,1})))); 
    v_iy_dt=v_i{1,2}-mean(mean(mean((v_i{1,2})))); 
    v_iz_dt=v_i{1,3}-mean(mean(mean((v_i{1,3}))));

    v_ex_dt=B{1,1}-mean(mean(mean((v_e{1,1})))); 
    v_ey_dt=B{1,2}-mean(mean(mean((v_e{1,2})))); 
    v_ez_dt=B{1,3}-mean(mean(mean((v_e{1,3}))));

    clearvars v_i v_e

    n_e0_dt = n_e0 - mean(mean(mean((n_e0))));
    n_i0_dt = n_i0 - mean(mean(mean((n_i0))));

    clearvars n_e0 n_i0

    Pij_ixx_dt=Pij_i{1,1}-mean(mean(mean((Pij_i{1,1}))));
    Pij_ixy_dt=Pij_i{1,2}-mean(mean(mean((Pij_i{1,2}))));
    Pij_ixz_dt=Pij_i{1,3}-mean(mean(mean((Pij_i{1,3})))); 
    Pij_iyy_dt=Pij_i{2,2}-mean(mean(mean((Pij_i{2,2}))));    
    Pij_iyz_dt=Pij_i{2,3}-mean(mean(mean((Pij_i{2,3}))));
    Pij_izz_dt=Pij_i{3,3}-mean(mean(mean((Pij_i{3,3}))));

    Pij_iyx_dt = Pij_ixy_dt; Pij_izx_dt = Pij_ixz_dt; Pij_izy_dt = Pij_iyz_dt;

    Pij_exx_dt=Pij_e{1,1}-mean(mean(mean((Pij_e{1,1}))));
    Pij_exy_dt=Pij_e{1,2}-mean(mean(mean((Pij_e{1,2}))));
    Pij_exz_dt=Pij_e{1,3}-mean(mean(mean((Pij_e{1,3})))); 
    Pij_eyy_dt=Pij_e{2,2}-mean(mean(mean((Pij_e{2,2}))));    
    Pij_eyz_dt=Pij_e{2,3}-mean(mean(mean((Pij_e{2,3}))));
    Pij_ezz_dt=Pij_e{3,3}-mean(mean(mean((Pij_e{3,3}))));

    Pij_eyx_dt = Pij_exy_dt; Pij_ezx_dt = Pij_exz_dt; Pij_ezy_dt = Pij_eyz_dt;

    clearvars Pij_i Pij_e
    %----------------------------------------------------------------------
%}
%----------------------------------------------------------------------

% % Make a plot to see the variable
% %----------------------------------------------------------------------
% y_lim = max(max(max(abs(Bx))));
%
% f1=figure(1);
% for i=1:168
%     hc=pcolor(squeeze(Bx(:,:,i)));
%     hold on
%     set(hc,'edgecolor','none')
%     clim([-y_lim y_lim]);
%     colorbar
%     hold off
%     pause(0.3)
% end
% %----------------------------------------------------------------------

% important note about the convolution and FFT
%----------------------------------------------------------------------
%The FFT imposes a periodic boundary condition, whereas conv assumes zeros outside the input domain.

%---------------------------------------------------------------------

% Proceed with the scale filtering
%----------------------------------------------------------------------
%Compute the fft    %Compute the averages using a kernel
%----------------------------------------------------------------------

% These four lines are the filtering
%----------------------------------------------------------------------
Bx_filt = imgaussfilt3(Bx_dt,l_wind_x);
By_filt = imgaussfilt3(By_dt,l_wind_x);
Bz_filt = imgaussfilt3(Bz_dt,l_wind_x);

Ex_filt = imgaussfilt3(Ex_dt,l_wind_x);
Ey_filt = imgaussfilt3(Ey_dt,l_wind_x);
Ez_filt = imgaussfilt3(Ez_dt,l_wind_x);

Jx_filt = imgaussfilt3(Jx_dt,l_wind_x);
Jy_filt = imgaussfilt3(Jy_dt,l_wind_x);
Jz_filt = imgaussfilt3(Jz_dt,l_wind_x);

v_ix_filt = imgaussfilt3(v_ix_dt,l_wind_x);
v_iy_filt = imgaussfilt3(v_iy_dt,l_wind_x);
v_iz_filt = imgaussfilt3(v_iz_dt,l_wind_x);

v_ex_filt = imgaussfilt3(v_ex_dt,l_wind_x);
v_ey_filt = imgaussfilt3(v_ey_dt,l_wind_x);
v_ez_filt = imgaussfilt3(v_ez_dt,l_wind_x);

v_x_filt = imgaussfilt3(v_x_dt,l_wind_x);
v_y_filt = imgaussfilt3(v_y_dt,l_wind_x);
v_z_filt = imgaussfilt3(v_z_dt,l_wind_x);

n_e_filt = imgaussfilt3(n_e0_dt,l_wind_x);
n_i_filt = imgaussfilt3(n_i0_dt,l_wind_x);
n_filt = imgaussfilt3(n_0_dt,l_wind_x);

if(pressure_ion == 1)
    Pij_ixx_filt = imgaussfilt3(Pij_ixx_dt,l_wind_x);
    Pij_ixy_filt = imgaussfilt3(Pij_ixy_dt,l_wind_x);
    Pij_ixz_filt = imgaussfilt3(Pij_ixz_dt,l_wind_x);
    Pij_iyy_filt = imgaussfilt3(Pij_iyy_dt,l_wind_x);
    Pij_iyz_filt = imgaussfilt3(Pij_iyz_dt,l_wind_x);
    Pij_izz_filt = imgaussfilt3(Pij_izz_dt,l_wind_x);
end

Pij_exx_filt = imgaussfilt3(Pij_exx_dt,l_wind_x);
Pij_exy_filt = imgaussfilt3(Pij_exy_dt,l_wind_x);
Pij_exz_filt = imgaussfilt3(Pij_exz_dt,l_wind_x);
Pij_eyy_filt = imgaussfilt3(Pij_eyy_dt,l_wind_x);
Pij_eyz_filt = imgaussfilt3(Pij_eyz_dt,l_wind_x);
Pij_ezz_filt = imgaussfilt3(Pij_ezz_dt,l_wind_x);
%----------------------------------------------------------------------

% Computing non-linear terms for the generalised Ohms law
%----------------------------------------------------------------------
if (component == 1)
    v_filt_x_B_filt_x = v_y_filt.*Bz_filt - v_z_filt.*By_filt;
    J_filt_x_B_filt_x = Jy_filt.*Bz_filt - Jz_filt.*By_filt;
elseif (component == 2)
    v_filt_x_B_filt_y = v_z_filt.*Bx_filt - v_x_filt.*Bz_filt;
    J_filt_x_B_filt_y = Jz_filt.*Bx_filt - Jx_filt.*Bz_filt;
elseif (component == 3)
    v_filt_x_B_filt_z = v_x_filt.*By_filt - v_y_filt.*Bx_filt;
    J_filt_x_B_filt_z = Jx_filt.*By_filt - Jy_filt.*Bx_filt;
end

v_filt_J_filt_xx = v_x_filt.*Jx_filt;
v_filt_J_filt_xy = v_x_filt.*Jy_filt;
v_filt_J_filt_xz = v_x_filt.*Jz_filt;
v_filt_J_filt_yx = v_y_filt.*Jx_filt;
v_filt_J_filt_yy = v_y_filt.*Jy_filt;
v_filt_J_filt_yz = v_y_filt.*Jz_filt;
v_filt_J_filt_zx = v_z_filt.*Jx_filt;
v_filt_J_filt_zy = v_z_filt.*Jy_filt;
v_filt_J_filt_zz = v_z_filt.*Jz_filt;

J_filt_v_filt_xx = Jx_filt.*v_x_filt;
J_filt_v_filt_xy = Jx_filt.*v_y_filt;
J_filt_v_filt_xz = Jx_filt.*v_z_filt;
J_filt_v_filt_yx = Jy_filt.*v_x_filt;
J_filt_v_filt_yy = Jy_filt.*v_y_filt;
J_filt_v_filt_yz = Jy_filt.*v_z_filt;
J_filt_v_filt_zx = Jz_filt.*v_x_filt;
J_filt_v_filt_zy = Jz_filt.*v_y_filt;
J_filt_v_filt_zz = Jz_filt.*v_z_filt;

J_filt_J_filt_2n_xx = Jx_filt.*Jx_filt./(n_filt);
J_filt_J_filt_2n_xy = Jx_filt.*Jy_filt./(n_filt);
J_filt_J_filt_2n_xz = Jx_filt.*Jz_filt./(n_filt);
J_filt_J_filt_2n_yy = Jy_filt.*Jy_filt./(n_filt);
J_filt_J_filt_2n_yz = Jy_filt.*Jz_filt./(n_filt);
J_filt_J_filt_2n_zz = Jz_filt.*Jz_filt./(n_filt);
%----------------------------------------------------------------------

% % %This is to check tha the derivative is properly computed
% % %----------------------------------------------------------------------
%{
% % dump_1 = sin(XL3d);
% % dump_2 = cos(XL3d);
% % [dump_1_x, dump_1_y, dump_1_z] = gradient(dump_1);
% % Div_dump_1 = dump_1_x/(grad_fact.*resx) + dump_1_y/(grad_fact.*resx) + dump_1_z/(grad_fact.*resx);
% % %----------------------------------------------------------------------
% % i=60;
% % f3=figure(3);
% % subplot(1,3,1)
% % dum = dump_1;
% % y_lim = max(max(max(dum)));
% % hc=pcolor(squeeze(dum(:,:,i)));
% % hold on
% % set(hc,'edgecolor','none')
% % clim([-y_lim y_lim]);
% % colorbar
% % title('sin')
% % hold off
% % subplot(1,3,2)
% % dum = dump_2;
% % y_lim = max(max(max(dum)));
% % hc=pcolor(squeeze(dum(:,:,i)));
% % hold on
% % set(hc,'edgecolor','none')
% % clim([-y_lim y_lim]);
% % colorbar
% % title('cos_t')
% % hold off
% % subplot(1,3,3)
% % dum = dump_1_x/(grad_fact.*resx);
% % y_lim = max(max(max(dum)));
% % hc=pcolor(squeeze(dum(:,:,i)));
% % hold on
% % set(hc,'edgecolor','none')
% % clim([-y_lim y_lim]);
% % colorbar
% % title('cos_c')
% % hold off
%}
% % %----------------------------------------------------------------------

%----------------------------------------------------------------------
[Pij_exx_filt_y, Pij_exx_filt_x, Pij_exx_filt_z] = gradient(Pij_exx_filt);
[Pij_eyy_filt_y, Pij_eyy_filt_x, Pij_eyy_filt_z] = gradient(Pij_eyy_filt);
[Pij_ezz_filt_y, Pij_ezz_filt_x, Pij_ezz_filt_z] = gradient(Pij_ezz_filt);
[Pij_exy_filt_y, Pij_exy_filt_x, Pij_exy_filt_z] = gradient(Pij_exy_filt);
[Pij_exz_filt_y, Pij_exz_filt_x, Pij_exz_filt_z] = gradient(Pij_exz_filt);
[Pij_eyz_filt_y, Pij_eyz_filt_x, Pij_eyz_filt_z] = gradient(Pij_eyz_filt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    Div_Pe_filt_x = Pij_exx_filt_x/(grad_fact.*resx) + Pij_exy_filt_y/(grad_fact.*resy) + Pij_exz_filt_z/(grad_fact.*resz);
elseif (component == 2)
    Div_Pe_filt_y = Pij_exy_filt_x/(grad_fact.*resx) + Pij_eyy_filt_y/(grad_fact.*resy) + Pij_eyz_filt_z/(grad_fact.*resz);
elseif (component == 3)
    Div_Pe_filt_z = Pij_exz_filt_x/(grad_fact.*resx) + Pij_eyz_filt_y/(grad_fact.*resy) + Pij_ezz_filt_z/(grad_fact.*resz);
end
clearvars Pij_exx_filt_* Pij_exy_filt_* Pij_exz_filt_* ...
    Pij_eyy_filt_* Pij_eyz_filt_* Pij_ezz_filt_* ...
    %----------------------------------------------------------------------

if(pressure_ion == 1)
    %----------------------------------------------------------------------
    [Pij_ixx_filt_y, Pij_ixx_filt_x, Pij_ixx_filt_z] = gradient(Pij_ixx_filt);
    [Pij_iyy_filt_y, Pij_iyy_filt_x, Pij_iyy_filt_z] = gradient(Pij_iyy_filt);
    [Pij_izz_filt_y, Pij_izz_filt_x, Pij_izz_filt_z] = gradient(Pij_izz_filt);
    [Pij_ixy_filt_y, Pij_ixy_filt_x, Pij_ixy_filt_z] = gradient(Pij_ixy_filt);
    [Pij_ixz_filt_y, Pij_ixz_filt_x, Pij_ixz_filt_z] = gradient(Pij_ixz_filt);
    [Pij_iyz_filt_y, Pij_iyz_filt_x, Pij_iyz_filt_z] = gradient(Pij_iyz_filt);
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    if (component == 1)
        Div_Pi_filt_x = Pij_ixx_filt_x/(grad_fact.*resx) + Pij_ixy_filt_y/(grad_fact.*resy) + Pij_ixz_filt_z/(grad_fact.*resz);
    elseif (component == 2)
        Div_Pi_filt_y = Pij_ixy_filt_x/(grad_fact.*resx) + Pij_iyy_filt_y/(grad_fact.*resy) + Pij_iyz_filt_z/(grad_fact.*resz);
    elseif (component == 3)
        Div_Pi_filt_z = Pij_ixz_filt_x/(grad_fact.*resx) + Pij_iyz_filt_y/(grad_fact.*resy) + Pij_izz_filt_z/(grad_fact.*resz);
    end
    clearvars Pij_ixx_filt_* Pij_ixy_filt_* Pij_ixz_filt_* ...
        Pij_iyy_filt_* Pij_iyz_filt_* Pij_izz_filt_* ...
        %----------------------------------------------------------------------
end

%----------------------------------------------------------------------
[v_filt_J_filt_xx_y, v_filt_J_filt_xx_x, v_filt_J_filt_xx_z] = gradient(v_filt_J_filt_xx);
[v_filt_J_filt_xy_y, v_filt_J_filt_xy_x, v_filt_J_filt_xy_z] = gradient(v_filt_J_filt_xy);
[v_filt_J_filt_xz_y, v_filt_J_filt_xz_x, v_filt_J_filt_xz_z] = gradient(v_filt_J_filt_xz);
[v_filt_J_filt_yx_y, v_filt_J_filt_yx_x, v_filt_J_filt_yx_z] = gradient(v_filt_J_filt_yx);
[v_filt_J_filt_yy_y, v_filt_J_filt_yy_x, v_filt_J_filt_yy_z] = gradient(v_filt_J_filt_yy);
[v_filt_J_filt_yz_y, v_filt_J_filt_yz_x, v_filt_J_filt_yz_z] = gradient(v_filt_J_filt_yz);
[v_filt_J_filt_zx_y, v_filt_J_filt_zx_x, v_filt_J_filt_zx_z] = gradient(v_filt_J_filt_zx);
[v_filt_J_filt_zy_y, v_filt_J_filt_zy_x, v_filt_J_filt_zy_z] = gradient(v_filt_J_filt_zy);
[v_filt_J_filt_zz_y, v_filt_J_filt_zz_x, v_filt_J_filt_zz_z] = gradient(v_filt_J_filt_zz);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    Div_vJ_filt_x = v_filt_J_filt_xx_x/(grad_fact.*resx) + v_filt_J_filt_yx_y/(grad_fact.*resy) + v_filt_J_filt_zx_z/(grad_fact.*resz);
elseif (component == 2)
    Div_vJ_filt_y = v_filt_J_filt_xy_x/(grad_fact.*resx) + v_filt_J_filt_yy_y/(grad_fact.*resy) + v_filt_J_filt_zy_z/(grad_fact.*resz);
elseif (component == 3)
    Div_vJ_filt_z = v_filt_J_filt_xz_x/(grad_fact.*resx) + v_filt_J_filt_yz_y/(grad_fact.*resy) + v_filt_J_filt_zz_z/(grad_fact.*resz);
end

clearvars v_filt_J_filt_xx_* v_filt_J_filt_xy_* v_filt_J_filt_xz_* ...
    v_filt_J_filt_yx_* v_filt_J_filt_yy_* v_filt_J_filt_yz_* ...
    v_filt_J_filt_zx_* v_filt_J_filt_zy_* v_filt_J_filt_zz_*
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[J_filt_v_filt_xx_y, J_filt_v_filt_xx_x, J_filt_v_filt_xx_z] = gradient(J_filt_v_filt_xx);
[J_filt_v_filt_xy_y, J_filt_v_filt_xy_x, J_filt_v_filt_xy_z] = gradient(J_filt_v_filt_xy);
[J_filt_v_filt_xz_y, J_filt_v_filt_xz_x, J_filt_v_filt_xz_z] = gradient(J_filt_v_filt_xz);
[J_filt_v_filt_yx_y, J_filt_v_filt_yx_x, J_filt_v_filt_yx_z] = gradient(J_filt_v_filt_yx);
[J_filt_v_filt_yy_y, J_filt_v_filt_yy_x, J_filt_v_filt_yy_z] = gradient(J_filt_v_filt_yy);
[J_filt_v_filt_yz_y, J_filt_v_filt_yz_x, J_filt_v_filt_yz_z] = gradient(J_filt_v_filt_yz);
[J_filt_v_filt_zx_y, J_filt_v_filt_zx_x, J_filt_v_filt_zx_z] = gradient(J_filt_v_filt_zx);
[J_filt_v_filt_zy_y, J_filt_v_filt_zy_x, J_filt_v_filt_zy_z] = gradient(J_filt_v_filt_zy);
[J_filt_v_filt_zz_y, J_filt_v_filt_zz_x, J_filt_v_filt_zz_z] = gradient(J_filt_v_filt_zz);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    Div_Jv_filt_x = J_filt_v_filt_xx_x/(grad_fact.*resx) + J_filt_v_filt_yx_y/(grad_fact.*resy) + J_filt_v_filt_zx_z/(grad_fact.*resz);
elseif (component == 2)
    Div_Jv_filt_y = J_filt_v_filt_xy_x/(grad_fact.*resx) + J_filt_v_filt_yy_y/(grad_fact.*resy) + J_filt_v_filt_zy_z/(grad_fact.*resz);
elseif (component == 3)
    Div_Jv_filt_z = J_filt_v_filt_xz_x/(grad_fact.*resx) + J_filt_v_filt_yz_y/(grad_fact.*resy) + J_filt_v_filt_zz_z/(grad_fact.*resz);
end

clearvars J_filt_v_filt_xx_* J_filt_v_filt_xy_* J_filt_v_filt_xz_* ...
    J_filt_v_filt_yx_* J_filt_v_filt_yy_* J_filt_v_filt_yz_* ...
    J_filt_v_filt_zx_* J_filt_v_filt_zy_* J_filt_v_filt_zz_*
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[J_filt_J_filt_xx_y, J_filt_J_filt_xx_x, J_filt_J_filt_xx_z] = gradient(J_filt_J_filt_2n_xx);
[J_filt_J_filt_xy_y, J_filt_J_filt_xy_x, J_filt_J_filt_xy_z] = gradient(J_filt_J_filt_2n_xy);
[J_filt_J_filt_xz_y, J_filt_J_filt_xz_x, J_filt_J_filt_xz_z] = gradient(J_filt_J_filt_2n_xz);
[J_filt_J_filt_yy_y, J_filt_J_filt_yy_x, J_filt_J_filt_yy_z] = gradient(J_filt_J_filt_2n_yy);
[J_filt_J_filt_yz_y, J_filt_J_filt_yz_x, J_filt_J_filt_yz_z] = gradient(J_filt_J_filt_2n_yz);
[J_filt_J_filt_zz_y, J_filt_J_filt_zz_x, J_filt_J_filt_zz_z] = gradient(J_filt_J_filt_2n_zz);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    Div_JJ_filt_2n_x = J_filt_J_filt_xx_x/(grad_fact.*resx) + J_filt_J_filt_xy_y/(grad_fact.*resy) + J_filt_J_filt_xz_z/(grad_fact.*resz);
elseif (component == 2)
    Div_JJ_filt_2n_y = J_filt_J_filt_xy_x/(grad_fact.*resx) + J_filt_J_filt_yy_y/(grad_fact.*resy) + J_filt_J_filt_yz_z/(grad_fact.*resz);
elseif (component == 3)
    Div_JJ_filt_2n_z = J_filt_J_filt_xz_x/(grad_fact.*resx) + J_filt_J_filt_yz_y/(grad_fact.*resy) + J_filt_J_filt_zz_z/(grad_fact.*resz);
end

clearvars J_filt_J_filt_xx_* J_filt_J_filt_xy_* J_filt_J_dt_xz_* ...
    J_filt_J_dt_yy_* J_filt_J_dt_yz_* J_filt_J_dt_zz_*
%----------------------------------------------------------------------

%----------------------------------------------------------------------
clearvars v_filt_J_filt_* J_filt_v_filt_* J_filt_J_filt_*
%----------------------------------------------------------------------

%%% Normalization values
%----------------------------------------------------------------------
B_mod_dt = sqrt(Bx_dt.^2 + By_dt.^2 + Bz_dt.^2);
B0 = mean(B_mod_dt,'all');

clearvars B_mod_dt

n0 = mean(n_0_dt,'all');
mu0 = 1;
v_a = B0./sqrt(mu0 * n0);
c = v_a;
me = 1/100;
%----------------------------------------------------------------------

%%%  Now let's compute the tensors
% % %----------------------------------------------------------------------
%----------------------------------------------------------------------
[sub_tau1_xx_y, sub_tau1_xx_x, sub_tau1_xx_z] = gradient(sub_tau1_xx);
[sub_tau1_xy_y, sub_tau1_xy_x, sub_tau1_xy_z] = gradient(sub_tau1_xy);
[sub_tau1_xz_y, sub_tau1_xz_x, sub_tau1_xz_z] = gradient(sub_tau1_xz);
[sub_tau1_yx_y, sub_tau1_yx_x, sub_tau1_yx_z] = gradient(sub_tau1_yx);
[sub_tau1_yy_y, sub_tau1_yy_x, sub_tau1_yy_z] = gradient(sub_tau1_yy);
[sub_tau1_yz_y, sub_tau1_yz_x, sub_tau1_yz_z] = gradient(sub_tau1_yz);
[sub_tau1_zx_y, sub_tau1_zx_x, sub_tau1_zx_z] = gradient(sub_tau1_zx);
[sub_tau1_zy_y, sub_tau1_zy_x, sub_tau1_zy_z] = gradient(sub_tau1_zy);
[sub_tau1_zz_y, sub_tau1_zz_x, sub_tau1_zz_z] = gradient(sub_tau1_zz);
%----------------------------------------------------------------------


% % % Now let's compute the tensors
%----------------------------------------------------------------------
if (component == 1)
    %(<nE> - <n><E>)/<n>
    % % %----------------------------------------------------------------------
    tau_nE_tau = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*Ex_dt,l_wind_x))./n_filt - Ex_filt);
    %(<nevxB> - <n><v>x<B>)/<ne>
    % % %----------------------------------------------------------------------
    tau_v_x_B_tau = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*v_x_B_x_dt,l_wind_x))./n_filt - v_filt_x_B_filt_x);
    %(<nevxB> - <n><J>x<B>)/<ne>
    %----------------------------------------------------------------------
    tau_J_x_B_tau = (B0*c)^(1)*((imgaussfilt3(J_x_B_x_dt,l_wind_x) - J_filt_x_B_filt_x)./n_filt);
    %----------------------------------------------------------------------
    Div_sub_tau1 = sub_tau1_xx_x/(grad_fact.*resx) + sub_tau1_yx_y/(grad_fact.*resy) + sub_tau1_zx_z/(grad_fact.*resz);
    %----------------------------------------------------------------------
    tau_Div_tau1 = me*c*c*(1.*(imgaussfilt3(Div_sub_tau1,l_wind_x) - (Div_vJ_filt_x + Div_Jv_filt_x - Div_JJ_filt_2n_x))./n_filt);
    % % %----------------------------------------------------------------------
elseif (component == 2)
    % % %----------------------------------------------------------------------
    tau_nE_tau = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*Ey_dt,l_wind_x))./n_filt - Ey_filt);
    % % %----------------------------------------------------------------------
    tau_v_x_B_tau = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*v_x_B_y_dt,l_wind_x))./n_filt - v_filt_x_B_filt_y);
    % % %----------------------------------------------------------------------
    tau_J_x_B_tau = (B0*c)^(1)*((imgaussfilt3(J_x_B_y_dt,l_wind_x) - J_filt_x_B_filt_y)./n_filt);
    % % %----------------------------------------------------------------------
    Div_sub_tau1 = sub_tau1_xy_x/(grad_fact.*resx) + sub_tau1_yy_y/(grad_fact.*resy) + sub_tau1_zy_z/(grad_fact.*resz);
    % % %----------------------------------------------------------------------
    tau_Div_tau1 = me*c*c*(1.*(imgaussfilt3(Div_sub_tau1,l_wind_x) - (Div_vJ_filt_y + Div_Jv_filt_y - Div_JJ_filt_2n_y))./n_filt);
elseif (component == 3)
    % % %----------------------------------------------------------------------
    tau_nE_tau = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*Ez_dt,l_wind_x))./n_filt - Ez_filt);
    % % %----------------------------------------------------------------------
    tau_v_x_B_tau = (B0*c)^(1)*((imgaussfilt3(n_0_dt.*v_x_B_z_dt,l_wind_x))./n_filt - v_filt_x_B_filt_z);
    % % %----------------------------------------------------------------------
    tau_J_x_B_tau = (B0*c)^(1)*((imgaussfilt3(J_x_B_z_dt,l_wind_x) - J_filt_x_B_filt_z)./n_filt);
    % % %----------------------------------------------------------------------
    Div_sub_tau1 = sub_tau1_xz_x/(grad_fact.*resx) + sub_tau1_yz_y/(grad_fact.*resy) + sub_tau1_zz_z/(grad_fact.*resz);
    %----------------------------------------------------------------------
    tau_Div_tau1 = me*c*c*(1.*(imgaussfilt3(Div_sub_tau1,l_wind_x) - (Div_vJ_filt_z + Div_Jv_filt_z - Div_JJ_filt_2n_z))./n_filt);
    %----------------------------------------------------------------------
end

clearvars sub_*


%clear variables to release space
%----------------------------------------------------------------------
%clearvars Div* E* J* v_* Pij* sub*
%----------------------------------------------------------------------


%ext_fact = sqrt(1/mime);
if (component == 1)
% For the x component
%----------------------------------------------------------------------
% terms from the owns law with no signs
%----------------------------------------------------------------------
term1_dt_x = B0*c*(Ex_dt);
term2_dt_x = B0*c*(v_x_B_x_dt);
term3_dt_x = B0*c*J_x_B_x_dt./n_0_dt;
term4_dt_x = n0*me*c*c*(Div_Pe_dt_x./n_0_dt);
term5_dt_x = me*c*c*((Div_vJ_dt_x + Div_Jv_dt_x - Div_JJ_dt_x)./n_0_dt);
%term4_dt_x = ext_fact*(mi*omega_pi*c)*(Div_Pe_dt_x./n_0_dt);
%term5_dt_x = B0*(mi*omega_pi*c/mime)*((Div_vJ_dt_x + Div_Jv_dt_x - Div_JJ_dt_x)./n_0_dt);
%----------------------------------------------------------------------
LHD_dt_x = term1_dt_x + term2_dt_x;
RHD_dt_x = term3_dt_x - term4_dt_x + term5_dt_x;
%----------------------------------------------------------------------

%----------------------------------------------------------------------
term1_filt_x = B0*c*(Ex_filt);
term2_filt_x = B0*c*(v_filt_x_B_filt_x);
term3_filt_x = B0*c*J_filt_x_B_filt_x./n_filt;
term4_filt_x = n0*me*c*c*(Div_Pe_filt_x./n_filt);
term5_filt_x = me*c*c*((Div_vJ_filt_x + Div_Jv_filt_x - Div_JJ_filt_2n_x)./n_filt);
%term4_filt_x = ext_fact*(mi*omega_pi*c)*(Div_Pe_filt_x./n_filt);
%term5_filt_x = B0*(mi*omega_pi*c/mime)*((Div_vJ_filt_x + Div_Jv_filt_x - Div_JJ_filt_2n_x)./n_filt);
%----------------------------------------------------------------------
LHD_filt_x = term1_filt_x + term2_filt_x;
RHD_filt_x = term3_filt_x - term4_filt_x + term5_filt_x;
%----------------------------------------------------------------------

elseif (component == 2)
% For the y component
%----------------------------------------------------------------------
%
% terms from the owns law with no signs
%----------------------------------------------------------------------
term1_dt_x = B0*c*(Ey_dt);
term2_dt_x = B0*c*(v_x_B_y_dt);
term3_dt_x = B0*c*J_x_B_y_dt./n_0_dt;
term4_dt_x = n0*me*c*c*(Div_Pe_dt_y./n_0_dt);
term5_dt_x = me*c*c*((Div_vJ_dt_y + Div_Jv_dt_y - Div_JJ_dt_y)./n_0_dt);
%----------------------------------------------------------------------
LHD_dt_x = term1_dt_x + term2_dt_x;
RHD_dt_x = term3_dt_x - term4_dt_x + term5_dt_x;
%----------------------------------------------------------------------

% terms from the owns law with no signs
%----------------------------------------------------------------------
term1_filt_x = B0*c*(Ey_filt);
term2_filt_x = B0*c*(v_filt_x_B_filt_y);
term3_filt_x = B0*c*J_filt_x_B_filt_y./n_filt;
term4_filt_x = n0*me*c*c*(Div_Pe_filt_y./n_filt);
term5_filt_x = me*c*c*((Div_vJ_filt_y + Div_Jv_filt_y - Div_JJ_filt_2n_y)./n_filt);
%----------------------------------------------------------------------
LHD_filt_x = term1_filt_x + term2_filt_x;
RHD_filt_x = term3_filt_x - term4_filt_x + term5_filt_x;
%----------------------------------------------------------------------
%}
%----------------------------------------------------------------------
elseif (component == 3)
% For the z component
%----------------------------------------------------------------------
%
% terms from the owns law with no signs
%----------------------------------------------------------------------
term1_dt_x = B0*c*(Ez_dt);
term2_dt_x = B0*c*(v_x_B_z_dt);
term3_dt_x = B0*c*J_x_B_z_dt./n_0_dt;
term4_dt_x = n0*me*c*c*(Div_Pe_dt_z./n_0_dt);
term5_dt_x = me*c*c*((Div_vJ_dt_z + Div_Jv_dt_z - Div_JJ_dt_z)./n_0_dt);
%----------------------------------------------------------------------
LHD_dt_x = term1_dt_x + term2_dt_x;
RHD_dt_x = term3_dt_x - term4_dt_x + term5_dt_x;
%----------------------------------------------------------------------

% terms from the owns law with no signs
%----------------------------------------------------------------------
term1_filt_x = B0*c*(Ez_filt);
term2_filt_x = B0*c*(v_filt_x_B_filt_z);
term3_filt_x = B0*c*J_filt_x_B_filt_z./n_filt;
term4_filt_x = n0*me*c*c*(Div_Pe_filt_z./n_filt);
term5_filt_x = me*c*c*((Div_vJ_filt_z + Div_Jv_filt_z - Div_JJ_filt_2n_z)./n_filt);
%----------------------------------------------------------------------
LHD_filt_x = term1_filt_x + term2_filt_x;
RHD_filt_x = term3_filt_x - term4_filt_x + term5_filt_x;
%----------------------------------------------------------------------
%}
end
%----------------------------------------------------------------------

%----------------------------------------------------------------------
% plot of the component x of the electric field
%----------------------------------------------------------------------
%
fs=20;
fs=20; x0=45;y0=54;xx1=1200;yy1=500;

legends_x = {'$E$', '$v \times B$','$\frac{J \times B}{ne}$',...
    '$\frac{\nabla \cdot P_{e}}{ne}$','$\frac{m_{e}\nabla \cdot (vJ + Jv - JJ/ne)}{ne^{2}}$',...
    '$RHS$'};

i=50; j=50;

f1=figure(1)
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(1,2,1)
dum = term1_dt_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-r',LineWidth=1.5)
hold on
dum = -term2_dt_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-b',LineWidth=1.5)
dum = term3_dt_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-g',LineWidth=1.5)
dum = -term4_dt_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-m',LineWidth=1.5)
dum = term5_dt_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-c',LineWidth=1.5)
dum = -term2_dt_x + term3_dt_x -term4_dt_x + term5_dt_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'--k',LineWidth=1.5)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_e$';
ax.YLabel.String = '$E$';
legend(legends_x ,'Interpreter','latex','NumColumns',1,'Location','southwest')
title('Unfilterd','Interpreter','latex')
xlim([-15.2,15.2])
hold off

subplot(1,2,2)
dum = term1_filt_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-r',LineWidth=1.5)
hold on
dum = -term2_filt_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-b',LineWidth=1.5)
dum = term3_filt_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-g',LineWidth=1.5)
dum = -term4_filt_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-m',LineWidth=1.5)
dum = term5_filt_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-c',LineWidth=1.5)
dum = -term2_filt_x + term3_filt_x -term4_filt_x + term5_filt_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'--k',LineWidth=1.5)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_e$';
ax.YLabel.String = '$E$';
legend(legends_x ,'Interpreter','latex','NumColumns',1,'Location','southwest')
title('Filterd','Interpreter','latex')
xlim([-15.2,15.2])
hold off
%}
%----------------------------------------------------------------------



%Select the components to plot
%----------------------------------------------------------------------
term1_dt = term1_dt_x ;
term2_dt = term2_dt_x ;
term3_dt = term3_dt_x ;
term4_dt = term4_dt_x ;
term5_dt = term5_dt_x ;

clearvars term1_dt_x term2_dt_x term3_dt_x term4_dt_x term5_dt_x

term1_filt = term1_filt_x ;
term2_filt = term2_filt_x ;
term3_filt = term3_filt_x ;
term4_filt = term4_filt_x ;
term5_filt = term5_filt_x ;

clearvars term1_filt_x term2_filt_x term3_filt_x term4_filt_x term5_filt_x

LHD_dt = LHD_dt_x;
RHD_dt = RHD_dt_x;

LHD_filt = LHD_filt_x;
RHD_filt = RHD_filt_x;

clearvars LHD_dt_x RHD_dt_x LHD_filt_x RHD_filt_x
%----------------------------------------------------------------------

%----------------------------------------------------------------------
fs=20;
threshold = pi/resx;
%----------------------------------------------------------------------

%----------------------------------------------------------------------
% This is to get the 1D omni spectra 
%----------------------------------------------------------------------
if (component == 1)
[E_k_tau_v_x_B_tau_x,~]=Omni1DSpectra(tau_v_x_B_tau_x,Lx,threshold);
[E_k_tau_nE_tau_x,~]=Omni1DSpectra(tau_nE_tau_x,Lx,threshold);
[E_k_tau_J_x_B_tau_x,~]=Omni1DSpectra(tau_J_x_B_tau_x,Lx,threshold);
[E_k_tau_Div_tau1_x,~]=Omni1DSpectra(tau_Div_tau1_x,Lx,threshold);
elseif (component == 2)
[E_k_tau_v_x_B_tau_x,~]=Omni1DSpectra(tau_v_x_B_tau_y,Lx,threshold);
[E_k_tau_nE_tau_x,~]=Omni1DSpectra(tau_nE_tau_y,Lx,threshold);
[E_k_tau_J_x_B_tau_x,~]=Omni1DSpectra(tau_J_x_B_tau_y,Lx,threshold);
[E_k_tau_Div_tau1_x,~]=Omni1DSpectra(tau_Div_tau1_y,Lx,threshold);
elseif (component ==3)
[E_k_tau_v_x_B_tau_x,~]=Omni1DSpectra(tau_v_x_B_tau_z,Lx,threshold);
[E_k_tau_nE_tau_x,~]=Omni1DSpectra(tau_nE_tau_z,Lx,threshold);
[E_k_tau_J_x_B_tau_x,~]=Omni1DSpectra(tau_J_x_B_tau_z,Lx,threshold);
[E_k_tau_Div_tau1_x,~]=Omni1DSpectra(tau_Div_tau1_z,Lx,threshold);
end

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
%----------------------------------------------------------------------
[KPAR,KPER] = meshgrid(kpar,kper);
%----------------------------------------------------------------------

% This is to get the perpendicular reduced spectrum
%----------------------------------------------------------------------
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


% This is the bloque for the plots
%--------------------------------------------------------------------------
fs=20; x0=45;y0=54;xx1=1200;yy1=500;
%--------------------------------------------------------------------------
f21=figure(21);
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(1,3,1)
%----------------------------------------------------------------------
loglog(k_bins(1:end-1), E_k_term1_dt(1:end-1),'-','LineWidth',2)
hold on
loglog(k_bins(1:end-1), E_k_term2_dt(1:end-1),'-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_term3_dt(1:end-1),'-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_term4_dt(1:end-1),'-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_term5_dt(1:end-1),'-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_term2to5_dt(1:end-1),'-','LineWidth',2)
set(gca,'FontSize',fs)
%set(gca,'XScale','lin','YScale','log','FontSize',fs)
y1=get(gca,'ylim');
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$k d_e$';
ax.YLabel.String = '$P_{1D}$';
legend(legends_x ,'Interpreter','latex','NumColumns',1,'Location','southwest')
xlim([k_bins(2) threshold]);
ylim([10^(-3) 10^(10)]);
%----------------------------------------------------------------------
hold off
%----------------------------------------------------------------------
subplot(1,3,2)
%----------------------------------------------------------------------
loglog(k_bins(1:end-1), E_k_term1_filt(1:end-1),'-','LineWidth',2)
hold on
loglog(k_bins(1:end-1), E_k_term2_filt(1:end-1),'-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_term3_filt(1:end-1),'-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_term4_filt(1:end-1),'-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_term5_filt(1:end-1),'-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_term2to5_filt(1:end-1),'-','LineWidth',2)
set(gca,'FontSize',fs)
%set(gca,'XScale','lin','YScale','log','FontSize',fs)
y1=get(gca,'ylim');
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$k d_e$';
ax.YLabel.String = '$P_{1D}$';
legend(legends_x ,'Interpreter','latex','NumColumns',1,'Location','southwest')
xlim([k_bins(2) threshold]);
ylim([10^(-3) 10^(10)]);
%----------------------------------------------------------------------
hold off
%----------------------------------------------------------------------
subplot(1,3,3)
%----------------------------------------------------------------------
loglog(k_bins(1:end-1), E_k_tau_nE_tau_x(1:end-1),'-','LineWidth',2)
hold on
loglog(k_bins(1:end-1), E_k_tau_v_x_B_tau_x(1:end-1),'-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_tau_J_x_B_tau_x(1:end-1),'-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_tau_Div_tau1_x(1:end-1),'-','LineWidth',2)
set(gca,'FontSize',fs)
%set(gca,'XScale','lin','YScale','log','FontSize',fs)
y1=get(gca,'ylim');
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$k d_e$';
ax.YLabel.String = '$P_{1D}$';
legend('$tau_{nE}$',...
    '$tau_{vxb}$',...
    '$tau_{Jxb}$',...
    '$Div tau_{vJ+Jv -jj/qn}$',...
    'Interpreter','latex','NumColumns',1,'Location','southwest')
xlim([k_bins(2) threshold]);
ylim([10^(-3) 10^(10)]);
%----------------------------------------------------------------------
hold off
%----------------------------------------------------------------------

%%%%%% This perpendicular doesn't make much sense as it is
%{
f22=figure(22);
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(1,2,1)
%----------------------------------------------------------------------
loglog(kper, P1Dper_term1_dt,'-','LineWidth',2)
hold on
loglog(kper, P1Dper_term2_dt,'-','LineWidth',2)
loglog(kper, P1Dper_term3_dt,'-','LineWidth',2)
loglog(kper, P1Dper_term4_dt,'-','LineWidth',2)
loglog(kper, P1Dper_term5_dt,'-','LineWidth',2)
set(gca,'FontSize',fs)
%set(gca,'XScale','lin','YScale','log','FontSize',fs)
y1=get(gca,'ylim');
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$k_\perp d_i$';
ax.YLabel.String = '$P_{1D_\perp}$';
legend(legends_x ,'Interpreter','latex','NumColumns',1,'Location','southwest')
xlim([kper(2) threshold]);
ylim([10^(0) 10^(10)]);
%----------------------------------------------------------------------
hold off
%----------------------------------------------------------------------
subplot(1,2,2)
%----------------------------------------------------------------------
loglog(kper, P1Dper_term1_filt,'-','LineWidth',2)
hold on
loglog(kper, P1Dper_term2_filt,'-','LineWidth',2)
loglog(kper, P1Dper_term3_filt,'-','LineWidth',2)
loglog(kper, P1Dper_term4_filt,'-','LineWidth',2)
loglog(kper, P1Dper_term5_filt,'-','LineWidth',2)
set(gca,'FontSize',fs)
%set(gca,'XScale','lin','YScale','log','FontSize',fs)
y1=get(gca,'ylim');
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$k_\perp d_i$';
ax.YLabel.String = '$P_{1D_\perp}$';
legend(legends_x ,'Interpreter','latex','NumColumns',1,'Location','southwest')
xlim([kper(2) threshold]);
ylim([10^(0) 10^(10)]);
%----------------------------------------------------------------------
hold off
%----------------------------------------------------------------------
%}

% This is the plot of the tensors
%----------------------------------------------------------------------
%

if (component == 1)
tau_nE_tau = tau_nE_tau_x;
tau_v_x_B_tau = tau_v_x_B_tau_x;
tau_J_x_B_tau = tau_J_x_B_tau_x;
tau_Div_tau1 = tau_Div_tau1_x;
elseif (component == 2)
tau_nE_tau = tau_nE_tau_y;
tau_v_x_B_tau = tau_v_x_B_tau_y;
tau_J_x_B_tau = tau_J_x_B_tau_y;
tau_Div_tau1 = tau_Div_tau1_y;
elseif (component == 3)
tau_nE_tau = tau_nE_tau_z;
tau_v_x_B_tau = tau_v_x_B_tau_z;
tau_J_x_B_tau = tau_J_x_B_tau_z;
tau_Div_tau1 = tau_Div_tau1_z;
end

i=50;j=50;
%----------------------------------------------------------------------
f12=figure(12);
set(gcf,'position',[x0,y0,1.0*xx1,1.0*yy1])
subplot(2,4,1)
dum = tau_nE_tau/(10^(-4));
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_e$';
ylim([-y_lim, y_lim]);
xlim([-15.2 15.2]);
title('$\tau(nE)/n$','Interpreter','latex')
hold off

subplot(2,4,2)
dum = tau_v_x_B_tau/(10^(-4));
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_e$';
ylim([-y_lim, y_lim]);
title('$\tau(v \times B)/n$','Interpreter','latex')
xlim([-15.2 15.2]);
hold off

subplot(2,4,3)
dum = tau_J_x_B_tau/(10^(-4));
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_e$';
ylim([-y_lim, y_lim]);
title('$\tau(J \times B)/n$','Interpreter','latex')
xlim([-15.2 15.2]);
hold off

subplot(2,4,4)
dum = tau_Div_tau1/(10^(-4));
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_e$';
ylim([-y_lim, y_lim]);
title('$\nabla \cdot \tau(vJ+Jv-JJ/nq))/n$','Interpreter','latex')
xlim([-15.2 15.2]);
hold off
%----------------------------------------------------------------------

subplot(2,4,5)
dum = tau_nE_tau;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
xline(xl(1,j),'--k','LineWidth',1.5)
colorbar
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_e$';
ax.YLabel.String = '$y/d_e$';
%title('$\tau(nE)/n$','Interpreter','latex')
xlim([-15.2 15.2]);
ylim([-15.2 15.2]);
hold off

subplot(2,4,6)
dum = tau_v_x_B_tau;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
xline(xl(1,j),'--k','LineWidth',1.5)
colorbar
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_e$';
ax.YLabel.String = '$y/d_e$';
%title('$\tau(vxB)/n$','Interpreter','latex')
xlim([-15.2 15.2]);
ylim([-15.2 15.2]);
hold off

subplot(2,4,7)
dum = tau_J_x_B_tau;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_e$';
ax.YLabel.String = '$y/d_e$';
%title('$\tau(JxB)/n$','Interpreter','latex')
xlim([-15.2 15.2]);
ylim([-15.2 15.2]);
hold off

subplot(2,4,8)
dum = tau_Div_tau1;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_e$';
ax.YLabel.String = '$y/d_e$';
%title('$m_{e} \nabla cdot \tau(vJ+Jv-JJ/nq))/n$','Interpreter','latex')
xlim([-15.2 15.2]);
ylim([-15.2 15.2]);
hold off
%}
% %------------------------------------------------------------------------

% % %----------------------------------------------------------------------
% % %----------------------------------------------------------------------
% % i=30;j=30;
% % f8=figure(8);
% % set(gcf,'position',[x0,y0,xx1,yy1])
% % subplot(1,2,1)
% % dum = term1_dt;
% % dump = squeeze(dum(:,j,i));
% % y_lim = max(max(max(abs(dump))));
% % plot(xl,dump,'LineWidth',2);
% % hold on
% % dum = term2to5_dt ;%+ term2_dt;
% % dump = squeeze(dum(:,j,i));
% % plot(xl,dump,'LineWidth',2);
% % %ylim([-y_lim, y_lim]);
% % %title('LHS')
% % legend('$E_{x}$','RHS')
% % hold off
% % subplot(1,2,2)
% % dum = term1_filt;
% % dump = squeeze(dum(:,j,i));
% % y_lim = max(max(max(abs(dump))));
% % plot(xl,dump,'LineWidth',2);
% % hold on
% % dum = term2to5_filt ;%+ term2_filt;
% % dump = squeeze(dum(:,j,i));
% % plot(xl,dump,'LineWidth',2);
% % %ylim([-y_lim, y_lim]);
% % %title('LHS')
% % legend('$E_{x,filt}$','RHS')
% % hold off
% % %----------------------------------------------------------------------
% % %----------------------------------------------------------------------


% These are the Plots showing the filter and unfilterd terms in the ohms
% law
%----------------------------------------------------------------------
%
%----------------------------------------------------------------------
% This is for the unfiltered case
%----------------------------------------------------------------------
i=30;j=30;
%----------------------------------------------------------------------
f10=figure(10);
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(2,5,1)
%dum = LHD_x_dt;
dum = term1_dt;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
ylim([-y_lim, y_lim]);
%title('LHS')
title('E')
hold off

subplot(2,5,2)
dum = -term2_dt;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
ylim([-y_lim, y_lim]);
%title('RHS')
title('-vxB')
hold off

subplot(2,5,3)
dum = term3_dt;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
ylim([-y_lim, y_lim]);
title('(1/qn)JxB')
hold off

subplot(2,5,4)
dum = -term4_dt;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
ylim([-y_lim, y_lim]);
title('-divPe/qn')
hold off

subplot(2,5,5)
dum = term5_dt;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
ylim([-y_lim, y_lim]);
title('(1/q^{2}n)div(vJ+Jv-JJ/qn)')
hold off
%----------------------------------------------------------------------

%i=30;
%----------------------------------------------------------------------
%f10=figure(10);
subplot(2,5,6)
%dum = LHD_dt;
dum = term1_dt;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
%title('LHS')
title('E')
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
hold off

subplot(2,5,7)
%dum = RHD_x_dt;
dum = -term2_dt;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
%title('RHS')
title('-vxB')
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
hold off

subplot(2,5,8)
dum = term3_dt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
title('(1/qn)JxB')
hold off

subplot(2,5,9)
dum = -term4_dt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
title('-divPe/qn')
hold off

subplot(2,5,10)
dum = term5_dt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
title('(m_{e}/q^{2}n)div(vJ+Jv-JJ/qn)')
hold off
sgtitle('$$ Unfiltered $$','Interpreter','latex','FontSize',fs)
%----------------------------------------------------------------------


%----------------------------------------------------------------------
%i=30;j=30;
%----------------------------------------------------------------------
f11=figure(11);
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(2,5,1)
%dum = LHD_filt_x;
dum = term1_filt;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
ylim([-y_lim, y_lim]);
%title('LHS')
title('E')
hold off

subplot(2,5,2)
%dum = RHD_filt_x;
dum = -term2_filt;
dump = squeeze(dum(:,j,i));
y_lim = max(max(max(abs(dump))));
plot(xl,dump,'LineWidth',2);
hold on
ylim([-y_lim, y_lim]);
%title('RHS')
title('-vxB')
hold off

subplot(2,5,3)
dum = term3_filt;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
ylim([-y_lim, y_lim]);
title('(1/qn)JxB')
hold off

subplot(2,5,4)
dum = -term4_filt;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
ylim([-y_lim, y_lim]);
title('-divPe/qn F')
hold off

subplot(2,5,5)
dum = term5_filt;
dump = squeeze(dum(:,j,i));
plot(xl,dump,'LineWidth',2);
y_lim = max(max(max(abs(dump))));
hold on
ylim([-y_lim, y_lim]);
title('(1/q^{2}n)div(vJ+Jv-JJ/qn F)')
hold off
%--------------------------------------------------------------------------
%f11=figure(11);
subplot(2,5,6)
%dum = LHD_filt_x;
dum = term1_filt;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
%title('LHS')
title('E')
xline(xl(1,j),'--k','LineWidth',1.5)
colorbar
hold off

subplot(2,5,7)
%dum = RHD_filt_x;
dum = -term2_filt;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
%title('RHS')
title('-vxB')
xline(xl(1,j),'--k','LineWidth',1.5)
colorbar
hold off

subplot(2,5,8)
dum = term3_filt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
title('((1/qn)JxB)')
hold off

subplot(2,5,9)
dum = -term4_filt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
title('-divPe/qn F')
hold off

subplot(2,5,10)
dum = term5_filt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
title('(1/q^{2}n)div(vJ+Jv-JJ/qn F)')
hold off
sgtitle('$$ filtered $$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------


%This is to make the plots for the spectra
%----------------------------------------------------------------------


f13=figure(13)
set(gcf,'position',[x0,y0,xx1,yy1])
%----------------------------------------------------------------------
subplot(2,5,1);
dum = P2D_term1_dt;
%dum = dum./(max(max(dum)));
dum = log(dum);
caxis_max = max(max(dum));
caxis_min = min(min(dum));
hc=pcolor(KPAR',KPER',dum);
hold on
set(hc,'edgecolor','none')
%set(gca, 'YScale', 'log', 'XScale', 'log')
hold on
colorbar
title('log(P2D term1)');
xlabel('kpar'); ylabel('kper');
xlim([kpar(2) threshold]);
ylim([kper(2) threshold]);
clim([caxis_min, caxis_max])
hold off
%----------------------------------------------------------------------
subplot(2,5,2);
dum = P2D_term2_dt;
%dum = dum./(max(max(dum)));
dum = log(dum);
caxis_max = max(max(dum));
caxis_min = min(min(dum));
hc=pcolor(KPAR',KPER',dum);
hold on
set(hc,'edgecolor','none')
%set(gca, 'YScale', 'log', 'XScale', 'log')
hold on
colorbar
title('log(P2D term2)');
xlabel('kpar'); ylabel('kper');
xlim([kpar(2) threshold]);
ylim([kper(2) threshold]);
clim([caxis_min, caxis_max])
hold off
%----------------------------------------------------------------------
subplot(2,5,3);
dum = P2D_term3_dt;
%dum = dum./(max(max(dum)));
dum = log(dum);
caxis_max = max(max(dum));
caxis_min = min(min(dum));
hc=pcolor(KPAR',KPER',dum);
hold on
set(hc,'edgecolor','none')
%set(gca, 'YScale', 'log', 'XScale', 'log')
hold on
colorbar
title('log(P2D term3)');
xlabel('kpar'); ylabel('kper');
xlim([kpar(2) threshold]);
ylim([kper(2) threshold]);
clim([caxis_min, caxis_max])
hold off
%----------------------------------------------------------------------
subplot(2,5,4);
dum = P2D_term4_dt;
%dum = dum./(max(max(dum)));
dum = log(dum);
caxis_max = max(max(dum));
caxis_min = min(min(dum));
hc=pcolor(KPAR',KPER',dum);
hold on
set(hc,'edgecolor','none')
%set(gca, 'YScale', 'log', 'XScale', 'log')
hold on
colorbar
title('log(P2D term4)');
xlabel('kpar'); ylabel('kper');
xlim([kpar(2) threshold]);
ylim([kper(2) threshold]);
clim([caxis_min, caxis_max])
hold off
%----------------------------------------------------------------------
subplot(2,5,5);
dum = P2D_term5_dt;
%dum = dum./(max(max(dum)));
dum = log(dum);
caxis_max = max(max(dum));
caxis_min = min(min(dum));
hc=pcolor(KPAR',KPER',dum);
hold on
set(hc,'edgecolor','none')
%set(gca, 'YScale', 'log', 'XScale', 'log')
hold on
colorbar
title('log(P2D term5)');
xlabel('kpar'); ylabel('kper');
xlim([kpar(2) threshold]);
ylim([kper(2) threshold]);
clim([caxis_min, caxis_max])
hold off
%----------------------------------------------------------------------
subplot(2,5,6);
dum = P2D_term1_filt;
%dum = dum./(max(max(dum)));
dum = log(dum);
caxis_max = max(max(dum));
caxis_min = min(min(dum));
hc=pcolor(KPAR',KPER',dum);
hold on
set(hc,'edgecolor','none')
%set(gca, 'YScale', 'log', 'XScale', 'log')
hold on
colorbar
title('log(P2D term1)');
xlabel('kpar'); ylabel('kper');
xlim([kpar(2) threshold]);
ylim([kper(2) threshold]);
clim([caxis_min, caxis_max])
hold off
%----------------------------------------------------------------------
subplot(2,5,7);
dum = P2D_term2_filt;
%dum = dum./(max(max(dum)));
dum = log(dum);
caxis_max = max(max(dum));
caxis_min = min(min(dum));
hc=pcolor(KPAR',KPER',dum);
hold on
set(hc,'edgecolor','none')
%set(gca, 'YScale', 'log', 'XScale', 'log')
hold on
colorbar
title('log(P2D term2)');
xlabel('kpar'); ylabel('kper');
xlim([kpar(2) threshold]);
ylim([kper(2) threshold]);
clim([caxis_min, caxis_max])
hold off
%----------------------------------------------------------------------
subplot(2,5,8);
dum = P2D_term3_filt;
%dum = dum./(max(max(dum)));
dum = log(dum);
caxis_max = max(max(dum));
caxis_min = min(min(dum));
hc=pcolor(KPAR',KPER',dum);
hold on
set(hc,'edgecolor','none')
%set(gca, 'YScale', 'log', 'XScale', 'log')
hold on
colorbar
title('log(P2D term3)');
xlabel('kpar'); ylabel('kper');
xlim([kpar(2) threshold]);
ylim([kper(2) threshold]);
clim([caxis_min, caxis_max])
hold off
%----------------------------------------------------------------------
subplot(2,5,9);
dum = P2D_term4_filt;
%dum = dum./(max(max(dum)));
dum = log(dum);
caxis_max = max(max(dum));
caxis_min = min(min(dum));
hc=pcolor(KPAR',KPER',dum);
hold on
set(hc,'edgecolor','none')
%set(gca, 'YScale', 'log', 'XScale', 'log')
hold on
colorbar
title('log(P2D term4)');
xlabel('kpar'); ylabel('kper');
xlim([kpar(2) threshold]);
ylim([kper(2) threshold]);
clim([caxis_min, caxis_max])
hold off
%----------------------------------------------------------------------
subplot(2,5,10);
dum = P2D_term5_filt;
%dum = dum./(max(max(dum)));
dum = log(dum);
caxis_max = max(max(dum));
caxis_min = min(min(dum));
hc=pcolor(KPAR',KPER',dum);
hold on
set(hc,'edgecolor','none')
%set(gca, 'YScale', 'log', 'XScale', 'log')
hold on
colorbar
title('log(P2D term5)');
xlabel('kpar'); ylabel('kper');
xlim([kpar(2) threshold]);
ylim([kper(2) threshold]);
clim([caxis_min, caxis_max])
hold off
%----------------------------------------------------------------------


% Checking the different terms
% %----------------------------------------------------------------------
set(gcf,'position',[x0,y0,xx1,yy1])
f14=figure(14);
subplot(1,2,1)
dum = -term2_dt + term3_dt + term5_dt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
title('RHS')
hold off

subplot(1,2,2);
dum = P2D_term5_filt;
%dum = dum./(max(max(dum)));
dum = log(dum);
caxis_max = max(max(dum));
caxis_min = min(min(dum));
hc=pcolor(KPAR',KPER',dum);
hold on
set(hc,'edgecolor','none')
%set(gca, 'YScale', 'log', 'XScale', 'log')
hold on
colorbar
title('log(P2D term5)');
xlabel('kpar'); ylabel('kper');
%xlim([k_min,k_max])
%ylim([k_min,k_max])
clim([caxis_min, caxis_max])
hold off
% %----------------------------------------------------------------------
%}
% %----------------------------------------------------------------------



%{
cd(path)
saveas(f1,strcat(num2str(i),'Ohms_terms_1D_together.png'));
saveas(f10,strcat(num2str(i),'Ohms_terms_regular.png'));
saveas(f11,strcat(num2str(i),'Ohms_terms_filterd.png'));
%saveas(f13,strcat(num2str(i),'Ohms_terms_power_2D.png')); %This needs the legends to be corrected 
saveas(f21,strcat(num2str(i),'Ohms_terms_power_omni_1D.png'));
%saveas(f22,strcat(num2str(i),'Ohms_terms_power_1D_per.png'));
saveas(f12,strcat(num2str(i),'Ohms_terms_taus.png'));
%saveas(f8,strcat(num2str(i),'Ohms_Ex_RHS.png'));
% %----------------------------------------------------------------------
%}
% %----------------------------------------------------------------------
% %----------------------------------------------------------------------


% This section is to compute the correlations point by point
%--------------------------------------------------------------------------
% The correlation are between the different cumulants or tensors and the
% variables. % For instance, in the smagorinsky model 
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% tau = <uu> -<u><u>

% From the model tau_ij = -2 nu_{T} S_ij hwere S_ij = 1/2(del_{j}U_{i} +
% del_{i}U_{j} ) the resolved strain tensor.

% Let's begin with tau and the strain tensor to see if there is something 

% In the case of the omhs law we are interested in capturing the
% contriobution of the subgrid scale terms to the total electric field. (This is partially done)

% The other thing to do is to see if the tensors are correlated with the quantities. 
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
var1 = tau_v_x_B_tau;
var2 = Jx_filt;
%var3 = Bx_filt;

%var3 = vorticity;% ??
%--------------------------------------------------------------------------


% This is just to see the corresponde
%--------------------------------------------------------------------------
%{
f144=figure(144);
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(1,2,1)
dum = var1;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
title('tau_{nuxB}')
hold off
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(1,2,2)
dum = var2;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
colorbar
xline(xl(1,j),'--k','LineWidth',1.5)
title('J')
hold off
%}
%--------------------------------------------------------------------------


% Now actually computing point by point thing
%--------------------------------------------------------------------------

%down_sample_rate = 200;
down_sample_rate = input('input must be integer and the matrix must be divisible: ');

[v_x_filt_y, v_x_filt_x, v_x_filt_z] = gradient(v_x_filt);
[v_y_filt_y, v_y_filt_x, v_y_filt_z] = gradient(v_y_filt);
[v_z_filt_y, v_z_filt_x, v_z_filt_z] = gradient(v_z_filt);

% The tau_vxB has been divided already by the density.

if (component == 1)
vort_x_filt = (v_z_filt_y - v_y_filt_z)./(grad_fact.*resx);
var2_x = downsample(Jx_filt(:),down_sample_rate);
var3_x = downsample(Bx_filt(:),down_sample_rate);
var4_x = downsample(vort_x_filt(:),down_sample_rate);

var_tau1_x = downsample(tau_v_x_B_tau_x(:),down_sample_rate);
var_tau2_x = downsample(tau_nE_tau_x(:),down_sample_rate);
var_tau3_x = downsample(tau_J_x_B_tau_x(:),down_sample_rate);
var_tau4_x = downsample(tau_Div_tau1_x(:),down_sample_rate);

elseif (component == 2)
vort_x_filt = (v_x_filt_z - v_z_filt_x)./(grad_fact.*resx);
var2_x = downsample(Jy_filt(:),down_sample_rate);
var3_x = downsample(By_filt(:),down_sample_rate);
var4_x = downsample(vort_x_filt(:),down_sample_rate);

var_tau1_x = downsample(tau_v_x_B_tau_y(:),down_sample_rate);
var_tau2_x = downsample(tau_nE_tau_y(:),down_sample_rate);
var_tau3_x = downsample(tau_J_x_B_tau_y(:),down_sample_rate);
var_tau4_x = downsample(tau_Div_tau1_y(:),down_sample_rate);

elseif (component == 3)
vort_x_filt = (v_y_filt_x - v_x_filt_y)./(grad_fact.*resx);
var2_x = downsample(Jz_filt(:),down_sample_rate);
var3_x = downsample(Bz_filt(:),down_sample_rate);
var4_x = downsample(vort_x_filt(:),down_sample_rate);

var_tau1_x = downsample(tau_v_x_B_tau_z(:),down_sample_rate);
var_tau2_x = downsample(tau_nE_tau_z(:),down_sample_rate);
var_tau3_x = downsample(tau_J_x_B_tau_z(:),down_sample_rate);
var_tau4_x = downsample(tau_Div_tau1_z(:),down_sample_rate);
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
f155=figure(155)
subplot(4,3,1)
plot(var2_x,var_tau1_x,'*')
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{u \times B}$')
hold off
subplot(4,3,2)
plot(var3_x,var_tau1_x,'*')
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
hold off
subplot(4,3,3)
plot(var4_x,var_tau1_x,'*')
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
hold off
%-----------------------
subplot(4,3,4)
plot(var2_x,var_tau2_x,'o')
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{nE}$')
hold off
subplot(4,3,5)
plot(var3_x,var_tau2_x,'o')
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
hold off
subplot(4,3,6)
plot(var4_x,var_tau2_x,'o')
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
hold off
%-----------------------
subplot(4,3,7)
plot(var2_x,var_tau3_x,'o')
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{J \times B}$')
hold off
subplot(4,3,8)
plot(var3_x,var_tau3_x,'o')
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
hold off
subplot(4,3,9)
plot(var4_x,var_tau3_x,'o')
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
hold off
%-----------------------
subplot(4,3,10)
plot(var2_x,var_tau4_x,'o')
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\tau_{\nabla \cdot(uJ+Ju - JJ/n)}$')
xlabel('$J$')
hold off
subplot(4,3,11)
plot(var3_x,var_tau4_x,'o')
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
xlabel('$B$')
hold off
subplot(4,3,12)
plot(var4_x,var_tau4_x,'o')
hold on
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
xlabel('$\Omega$')
hold off
%-----------------------------------------------------------------------
cd(path)
saveas(f155,strcat(num2str(component),'taus_dependence.png'));
%-----------------------------------------------------------------------


%-----------------------------------------------------------------------




% % % % % compute the fluctuating quantities (prime quantities)
% % % % %----------------------------------------------------------------------
%{
    % % % % %---------------------------------------------------------------------- 
    % % % % Bx_pri = Bx_dt - Bx_filt;
    % % % % By_pri = By_dt - By_filt;
    % % % % Bz_pri = Bz_dt - Bz_filt;    
    % % % % 
    % % % % Ex_pri = Ex_dt - Ex_filt;
    % % % % Ey_pri = Ey_dt - Ey_filt;
    % % % % Ez_pri = Ez_dt - Ez_filt;    
    % % % % 
    % % % % Jx_pri = Jx_dt - Jx_filt;
    % % % % Jy_pri = Jy_dt - Jy_filt;
    % % % % Jz_pri = Jz_dt - Jz_filt; 
    % % % % 
    % % % % % v_ix_pri = v_ix_dt - v_ix_filt;
    % % % % % v_iy_pri = v_iy_dt - v_iy_filt;
    % % % % % v_iz_pri = v_iz_dt - v_iz_filt;
    % % % % % 
    % % % % % v_ex_pri = v_ex_dt - v_ex_filt;
    % % % % % v_ey_pri = v_ey_dt - v_ey_filt;
    % % % % % v_ez_pri = v_ez_dt - v_ez_filt;    
    % % % % 
    % % % % v_x_pri = v_x_dt - v_x_filt;
    % % % % v_y_pri = v_y_dt - v_y_filt;
    % % % % v_z_pri = v_z_dt - v_z_filt;
    % % % % 
    % % % % n_e_pri = n_e0_dt - n_e_filt;
    % % % % n_i_pri = n_i0_dt - n_i_filt; 
    % % % % 
    % % % % Pij_exx_pri = Pij_exx_dt - Pij_exx_filt;
    % % % % Pij_exy_pri = Pij_exy_dt - Pij_exy_filt;
    % % % % Pij_exz_pri = Pij_exz_dt - Pij_exz_filt;
    % % % % Pij_eyy_pri = Pij_eyy_dt - Pij_eyy_filt;
    % % % % Pij_eyz_pri = Pij_eyz_dt - Pij_eyz_filt;
    % % % % Pij_ezz_pri = Pij_ezz_dt - Pij_ezz_filt;
    % % % % 
    % % % % Pij_ixx_pri = Pij_ixx_dt - Pij_ixx_filt;
    % % % % Pij_ixy_pri = Pij_ixy_dt - Pij_ixy_filt;
    % % % % Pij_ixz_pri = Pij_ixz_dt - Pij_ixz_filt;
    % % % % Pij_iyy_pri = Pij_iyy_dt - Pij_iyy_filt;
    % % % % Pij_iyz_pri = Pij_iyz_dt - Pij_iyz_filt;
    % % % % Pij_izz_pri = Pij_izz_dt - Pij_izz_filt;
    % % % % %----------------------------------------------------------------------  
    % % % % 
    % % % % 
    % % % % 
    % % % % % Double terms multifluid
    % % % % %----------------------------------------------------------------------
    % % % % BB_xx_dt = Bx_dt .* Bx_dt;
    % % % % BB_xy_dt = Bx_dt .* By_dt;
    % % % % BB_xz_dt = Bx_dt .* Bz_dt;
    % % % % BB_yy_dt = By_dt .* By_dt;
    % % % % BB_yz_dt = By_dt .* Bz_dt;
    % % % % BB_zz_dt = Bz_dt .* Bz_dt;
    % % % % 
    % % % % vivi_xx_dt = v_ix_dt .* v_ix_dt;
    % % % % vivi_xy_dt = v_ix_dt .* v_iy_dt;
    % % % % vivi_xz_dt = v_ix_dt .* v_iz_dt;
    % % % % vivi_yy_dt = v_iy_dt .* v_iy_dt;
    % % % % vivi_yz_dt = v_iy_dt .* v_iz_dt;
    % % % % vivi_zz_dt = v_iz_dt .* v_iz_dt;
    % % % % 
    % % % % veve_xx_dt = v_ex_dt .* v_ex_dt;
    % % % % veve_xy_dt = v_ex_dt .* v_ey_dt;
    % % % % veve_xz_dt = v_ex_dt .* v_ez_dt;
    % % % % veve_yy_dt = v_ey_dt .* v_ey_dt;
    % % % % veve_yz_dt = v_ey_dt .* v_ez_dt;
    % % % % veve_zz_dt = v_ez_dt .* v_ez_dt;
    % % % % %----------------------------------------------------------------------
    % % % % 
    % % % % % Filtering Double terms
    % % % % %----------------------------------------------------------------------
    % % % % BB_xx_filt = imgaussfilt3(BB_xx_dt,l_wind_x);
    % % % % BB_xy_filt = imgaussfilt3(BB_xy_dt,l_wind_x);
    % % % % BB_xz_filt = imgaussfilt3(BB_xz_dt,l_wind_x);
    % % % % BB_yy_filt = imgaussfilt3(BB_yy_dt,l_wind_x);
    % % % % BB_yz_filt = imgaussfilt3(BB_yz_dt,l_wind_x);
    % % % % BB_zz_filt = imgaussfilt3(BB_zz_dt,l_wind_x);
    % % % % 
    % % % % vivi_xx_filt = imgaussfilt3(vivi_xx_dt,l_wind_x);
    % % % % vivi_xy_filt = imgaussfilt3(vivi_xy_dt,l_wind_x);
    % % % % vivi_xz_filt = imgaussfilt3(vivi_xz_dt,l_wind_x);
    % % % % vivi_yy_filt = imgaussfilt3(vivi_yy_dt,l_wind_x);
    % % % % vivi_yz_filt = imgaussfilt3(vivi_yz_dt,l_wind_x);
    % % % % vivi_zz_filt = imgaussfilt3(vivi_zz_dt,l_wind_x);
    % % % % 
    % % % % veve_xx_filt = imgaussfilt3(veve_xx_dt,l_wind_x);
    % % % % veve_xy_filt = imgaussfilt3(veve_xy_dt,l_wind_x);
    % % % % veve_xz_filt = imgaussfilt3(veve_xz_dt,l_wind_x);
    % % % % veve_yy_filt = imgaussfilt3(veve_yy_dt,l_wind_x);
    % % % % veve_yz_filt = imgaussfilt3(veve_yz_dt,l_wind_x);
    % % % % veve_zz_filt = imgaussfilt3(veve_zz_dt,l_wind_x);
    % % % % %----------------------------------------------------------------------
    % % 
    % % % % % Define the Reynolds and Maxwell stress tensors
    % % % % %----------------------------------------------------------------------  
    % % % % %tau_vv = <vv> - <v><v>
    % % % % 
    % % % % tau_BB_xx = BB_xx_filt - Bx_filt.*Bx_filt; 
    % % % % tau_BB_xy = BB_xy_filt - Bx_filt.*By_filt;
    % % % % tau_BB_xz = BB_xz_filt - Bx_filt.*Bz_filt; 
    % % % % tau_BB_yy = BB_yy_filt - By_filt.*By_filt;
    % % % % tau_BB_yz = BB_yz_filt - By_filt.*Bz_filt; 
    % % % % tau_BB_zz = BB_zz_filt - Bz_filt.*Bz_filt; 
    % % % % 
    % % % % tau_veve_xx = veve_xx_filt - v_ex_filt.*v_ex_filt; 
    % % % % tau_veve_xy = veve_xy_filt - v_ex_filt.*v_ey_filt;
    % % % % tau_veve_xz = veve_xz_filt - v_ex_filt.*v_ez_filt; 
    % % % % tau_veve_yy = veve_yy_filt - v_ey_filt.*v_ey_filt;
    % % % % tau_veve_yz = veve_yz_filt - v_ey_filt.*v_ez_filt; 
    % % % % tau_veve_zz = veve_zz_filt - v_ez_filt.*v_ez_filt; 
    % % % % 
    % % % % tau_vivi_xx = vivi_xx_filt - v_ix_filt.*v_ix_filt; 
    % % % % tau_vivi_xy = vivi_xy_filt - v_ix_filt.*v_iy_filt;
    % % % % tau_vivi_xz = vivi_xz_filt - v_ix_filt.*v_iz_filt; 
    % % % % tau_vivi_yy = vivi_yy_filt - v_iy_filt.*v_iy_filt;
    % % % % tau_vivi_yz = vivi_yz_filt - v_iy_filt.*v_iz_filt; 
    % % % % tau_vivi_zz = vivi_zz_filt - v_iz_filt.*v_iz_filt;    
%}
% % % % %----------------------------------------------------------------------


% % Let's have a look a the quantities
% % Bx_dt is the unfilterd, B_filt is the filtered, B_pri is the
% % unresolved
% % %----------------------------------------------------------------------
%{
% i=30;
% f1=figure(1);
% subplot(2,3,1)
% dump = squeeze(Bx_dt(:,:,i));
% y_lim = max(max(max(abs(dump))));
% hc=pcolor(dump);
% hold on
% set(hc,'edgecolor','none')
% clim([-y_lim y_lim]);
% title('Bx')
% colorbar
% hold off
%
% subplot(2,3,2)
% dump = squeeze(Bx_filt(:,:,i));
% hc=pcolor(dump);
% %y_lim = max(max(max(abs(dump))));
% hold on
% set(hc,'edgecolor','none')
% clim([-y_lim y_lim]);
% colorbar
% title('<Bx>')
% hold off
%
% subplot(2,3,3)
% dump = squeeze(Bx_pri(:,:,i));
% hc=pcolor(dump);
% %y_lim = max(max(max(abs(dump))));
% hold on
% set(hc,'edgecolor','none')
% clim([-y_lim y_lim]);
% colorbar
% title('Bx_{pri} ' )
% hold off
%
% subplot(2,3,4)
% dump = squeeze(v_ex_dt(:,:,i));
% y_lim = max(max(max(abs(dump))));
% hc=pcolor(dump);
% hold on
% set(hc,'edgecolor','none')
% clim([-y_lim y_lim]);
% title('vex')
% colorbar
% hold off
%
% subplot(2,3,5)
% dump = squeeze(v_ex_filt(:,:,i));
% hc=pcolor(dump);
% %y_lim = max(max(max(abs(dump))));
% hold on
% set(hc,'edgecolor','none')
% clim([-y_lim y_lim]);
% colorbar
% title('<vex>')
% hold off
%
% subplot(2,3,6)
% dump = squeeze(v_ex_pri(:,:,i));
% hc=pcolor(dump);
% %y_lim = max(max(max(abs(dump))));
% hold on
% set(hc,'edgecolor','none')
% clim([-y_lim y_lim]);
% colorbar
% title('vex_{pri}' )
% hold off
%}
% % %----------------------------------------------------------------------

%----------------------------------------------------------------------
% This is to get the spectra
%----------------------------------------------------------------------
% [P2D_Bx,~]=Power_of_fimgaussfilt3(Bx_dt,Lx,Ly,Lz);
% [P2D_G_gs_n,~]= Power_of_filtering_kernel(G_gs_n,Lx,Ly,Lz);
% [P2D_convolution,kpar,kper,kz] = Power_of_filtering_kernel(convolution_result,Lx,Ly,Lz);
% [KPAR,KPER] = meshgrid(kpar,kper);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
% Plots the field to see how it looks with the filter
% y_lim = max(max(max(abs(Bx_dt))));
% %----------------------------------------------------------------------
% i=84;
% f3=figure(3);
% subplot(2,3,1)
% hc=pcolor(squeeze(Bx_dt(:,:,i)));
% hold on
% set(hc,'edgecolor','none')
% clim([-y_lim y_lim]);
% title('Bx')
% colorbar
% hold off
%
% subplot(2,3,2)
% hc=pcolor(squeeze(G_gs(:,:,i)));
% hold on
% set(hc,'edgecolor','none')
% %clim([-y_lim y_lim]);
% colorbar
% title('G')
% hold off
%
% subplot(2,3,3)
% y_lim_cv = max(max(max(abs(convolution_result(:,:,i)))));
% hc=pcolor(squeeze(convolution_result(:,:,i)));
% hold on
% set(hc,'edgecolor','none')
% clim([-y_lim_cv y_lim_cv]);
% colorbar
% title('Bx filtered')
% hold off
% %----------------------------------------------------------------------


%----------------------------------------------------------------------
% %This is to make the plots for the spectra
% %----------------------------------------------------------------------
% caxis_max = max(max(log(P2D_Bx)));
% caxis_min = min(min(log(P2D_Bx)));
%
% subplot(2,3,4);
% hc=pcolor(KPAR',KPER',log(P2D_Bx));
% hold on
% set(hc,'edgecolor','none')
% %set(gca, 'YScale', 'log', 'XScale', 'log')
% hold on
% colorbar
% title('log(P2D Bx)');
% xlabel('kpar'); ylabel('kper');
% %xlim([k_min,k_max])
% %ylim([k_min,k_max])
% clim([caxis_min, caxis_max])
% hold off
%
% subplot(2,3,5);
% hc=pcolor(KPAR',KPER',log(P2D_G_gs_n));
% hold on
% set(hc,'edgecolor','none')
% %set(gca, 'YScale', 'log', 'XScale', 'log')
% hold on
% colorbar
% title('log(P2D G)');
% xlabel('kpar'); ylabel('kper');
% %xlim([k_min,k_max])
% %ylim([k_min,k_max])
% clim([caxis_min, caxis_max])
% hold off
%
% subplot(2,3,6);
% hc=pcolor(KPAR',KPER',log(P2D_convolution));
% hold on
% set(hc,'edgecolor','none')
% %set(gca, 'YScale', 'log', 'XScale', 'log')
% hold on
% colorbar
% title('log(P2D Bx filtered)');
% xlabel('kpar'); ylabel('kper');
% %xlim([k_min,k_max])
% %ylim([k_min,k_max])
% clim([caxis_min, caxis_max])
% hold off
% %----------------------------------------------------------------------
%----------------------------------------------------------------------


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




