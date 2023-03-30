% This is for the 2D case in the xy-plane

path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_lange_2D_xy';

% For the scripts
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';

% To save the plots
path_rec_r = strcat(path,'/spectra/rec_r');
path_rec_line = strcat(path,'/spectra/rec_line');

if not(isfolder(path_rec_r))
    mkdir(path_rec_r)
end
if not(isfolder(path_rec_line))
    mkdir(path_rec_line)
end


cd(path)
S = dir(fullfile(path,'pfd.*.h5'));
N=numel(S); % number of files to use
H=zeros(N);
%--------------------------------------------------------------------------
S2 = dir(fullfile(path,'pfd_moments.*.h5'));
N2=numel(S2); % number of files to use
H2=zeros(N2);
in=1;
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
c=1; VA2c = 0.2;
%B0 = VA2c; E0 = B0*VA2c;
%Pi0 = mi*VA2c*VA2c; Pe0 = me*VA2c*VA2c;
%DeltaEpsilon0=VA2c*Pi0;
%DeltaEpsilon0=Pi0;
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% % Normalization
% %B are normalized to the background magnetic field
% B0=0.2;
% %n is normalise to the proton density n0=1
% n0=1;
% %Vi normalised to the proton alfven speed V_a=0.1c The alfven speed of
% %electrons is Vae=10Vai
% Vai=0.2;
% Vae=0.2;
% %E = vB, as B0=0.1 and v in units of c, E0= B0*Vai/c
% E0=0.2; %??
% %T=(beta/2)B^2, Thus, as beta=1
% T0=0.02;
% %The current density J0=1?
% J0=Vai;
% 
% MFT0=1; % is this simply one in this normalization

nb_n0 =0.1;

Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);

%Normalising only when making plots
%c=1; VA2c = 0.2;
%B0 = VA2c; E0 = B0*VA2c;
%Pi0 = mi*VA2c*VA2c; Pe0 = me*VA2c*VA2c;
%DeltaEpsilon0=VA2c*Pi0;
%DeltaEpsilon0=Pi0;

%--------------------------------------------------------------------------

kb = 1.; 
mu0 =1.; 
c=1; 
q = 1;
%mime =1.; 
mi = 1.; 
me = 1. / mime; eps0=1.;
omega_pi=1;
Omega_e=Vai*sqrt(mime)*omega_pi;
Omega_i=Omega_e / mime;
TOmega_e=1/Omega_e; 
TOmega_i=1/Omega_i;


N_jn=N; %This is to store some but not all the time steps
jn=20;
Ex_rec_avg=zeros(1,N_jn);
time_t_2=zeros(1,N_jn);
Ax_maxmin_avg=zeros(1,N_jn);
Ax_max_a=zeros(1,jn);
Ax_min_a=zeros(1,jn);

J_mag_max=zeros(1,N_jn);


%--------------------------------------------------------------------------

for jn=1:N
    %in=2 + floor(N*(jn-1)/10);
    in=jn;
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
    %--------------------------------------------------------------------------
    
    %----------------------------------------------------------------------
%     %disp(strcat('Computing step ...',S2(in).name))    
%     fileID2 =  S2(in).name; %change the 1 per i
%     %h5disp(fileID2);
%     info2 = h5info(fileID2);
%     moments_1st = info2.Groups(1).Name;
%     %----------------------------------------------------------------------
    
    %----------------------------------------------------------------------
    % 'rho_e_UP' 'jx_e_UP' 'jy_e_UP' 'jz_e_UP' 'px_e_UP' 'py_e_UP'
    % 'pz_e_UP' 'txx_e_UP' 'tyy_e_UP' 'tzz_e_UP' 'txy_e_UP' 'tyz_e_UP'
    % 'tzx_e_UP' 'rho_i_UP' 'jx_i_UP' 'jy_i_UP' 'jz_i_UP' 'px_i_UP'
    % 'py_i_UP' 'pz_i_UP' 'txx_i_UP' 'tyy_i_UP' 'tzz_i_UP' 'txy_i_UP'
    % 'tyz_i_UP' 'tzx_i_UP'
    %----------------------------------------------------------------------
        
    B{1,1}=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    B{1,2}=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
    B{1,3}=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));
    
    E{1,1}=h5read(fileID,strcat(EHJ_1st,'/ex_ec/p0/3d'));
    E{1,2}=h5read(fileID,strcat(EHJ_1st,'/ey_ec/p0/3d'));
    E{1,3}=h5read(fileID,strcat(EHJ_1st,'/ez_ec/p0/3d'));
    
    J{1,1}=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'));
    J{1,2}=h5read(fileID,strcat(EHJ_1st,'/jy_ec/p0/3d'));
    J{1,3}=h5read(fileID,strcat(EHJ_1st,'/jz_ec/p0/3d'));

    %From 3D to 2D (x,y,z) to (y,z)
    %----------------------------------------------------------------------  
        % computing the electric field terms
    %---------------------------------------------------------------------- 
    %----------------------------------------------------------------------
    % slice in x
    ssz=size(B{1,1});
    sli_y = floor(4+ssz(1)/2);
    sli_x = floor(4+ssz(2)/2);%380;
    sli_z = 1;%floor(2+ssz(3)/2);%700;
    %----------------------------------------------------------------------

    Ex = E{1,1}; Ex=-permute(Ex,[2 1 3]); Ex = squeeze(Ex(:,:,sli_z)); 
    Ey = E{1,2}; Ey=-permute(Ey,[2 1 3]); Ey = squeeze(Ey(:,:,sli_z));
    Ez = E{1,3}; Ez=-permute(Ez,[2 1 3]); Ez = squeeze(Ez(:,:,sli_z)); 

    Bx = B{1,1}; Bx=-permute(Bx,[2 1 3]); Bx = squeeze(Bx(:,:,sli_z));
    By = B{1,2}; By=-permute(By,[2 1 3]); By = squeeze(By(:,:,sli_z));
    Bz = B{1,3}; Bz=-permute(Bz,[2 1 3]); Bz = squeeze(Bz(:,:,sli_z));

    Jx = J{1,1}; Jx=-permute(Jx,[2 1 3]); Jx = squeeze(Jx(:,:,sli_z));
    Jy = J{1,2}; Jy=-permute(Jy,[2 1 3]); Jy = squeeze(Jy(:,:,sli_z));
    Jz = J{1,3}; Jz=-permute(Jz,[2 1 3]); Jz = squeeze(Jz(:,:,sli_z));
    %--------------------------------------------------------------------------
    %----------------------------------------------------------------------  

    % computing magnetic flux velocity
    %----------------------------------------------------------------------  
    Bp=sqrt(Bx.^2 + By.^2);

    by=By./Bp;
    bz=Bz./Bp;

    % Is this still well defined like this in the 3D case?
    MFT_y = - (c.*Ex./Bp).*bz ; 
    MFT_z =  (Ex./Bp).*by ;
    MFTm=sqrt(MFT_z.^2 + MFT_y.^2);    
    %----------------------------------------------------------------------


% This has to be corrected so the gradient is computed correctly
%    %----------------------------------------------------------------------
%     MFT_y=squeeze(MFT_y(:,:,sli_z));
%     MFT_z=squeeze(MFT_z(:,:,sli_z));
%     Bp=squeeze(Bp(:,:,sli_z));

    % Computing the divergence
    %----------------------------------------------------------------------  
%     [MFT_y_y, MFT_y_z] = gradient(MFT_y);
%     [MFT_z_y, MFT_z_z] = gradient(MFT_z);
%     Div_MFT = MFT_y_y/resy + MFT_z_z/resz;
%     
%     MFTm_1d_ay=squeeze(Div_MFT(:,sli_z));
%     MFTm_1d_az=squeeze(Div_MFT(sli_y,:))';
% 
%     Div_MFT_1d_ay=squeeze(Div_MFT(:,sli_z));
%     Div_MFT_1d_az=squeeze(Div_MFT(sli_y,:))';
    %----------------------------------------------------------------------  
 
    sss=size(Bx);
    size_X=sss;
    xll=linspace(-Lx,Lx,size_X(1));
    yll=linspace(-Ly,Ly,size_X(2)); %Jeff flag it works with (1,size_x(2))
    [XLL, YLL] = meshgrid(xll,yll);


    % Compute the out of the plane vector potential
    %----------------------------------------------------------------------
    % get ax integrating over y
    dx = resx; dy = resy;
    nx=sss(1);
    ny=sss(2);

%     %----------------------------------------------------------------------
%     Iapprox = zeros(size(By));
%     Iapprox_i=0;
%     
%     %integral over y
%     for i=1:ny-1
%             Iapprox_i = Iapprox_i + dx*By(i,:);
%             Iapprox(i,:)=Iapprox_i;
%     end
% 
%     Ax_y=-Iapprox; %<------- This is the correct Az
%     Az=Ax_y;
%     %----------------------------------------------------------------------

    %----------------------------------------------------------------------
%     % Apply the condition of along Bz=0; 
%     A_cond=zeros(length(xll),length(yll));
%     for kn=1:length(yll)
%         bz_min = min(abs(Bz(:,kn)));
%         A_cond(:,kn)=(Bz(:,kn)==bz_min);
%     end
% 
% %     epsi_1=0.001; %threshold
% %     A1=(Bz<epsi_1); % find the regions where Bz=0
% %     A_cond=A1;
% 
% 
%     Ax_y_bz0=A_cond.*Ax_y; % find the value of the reconnecting electric field
%     %----------------------------------------------------------------------
% 
%     Ax_max=max(max(Ax_y_bz0));
%     Ax_min=min(min(Ax_y_bz0));
%     Ax_maxmin = Ax_max - Ax_min;
%     Ax_maxmin_avg_i=Ax_maxmin; 
% 
%     Ax_max_a(1,jn)=Ax_max;
%     Ax_min_a(1,jn)=Ax_min;
% %     A_cond_n= A_cond(A_cond~=0);
% %     Ax_maxmin_avera= sum((Ax_maxmin),'all')./ length(A_cond_n);
% %     Ax_maxmin_avg_i=Ax_maxmin_avera/Vae_b; 
% 
%     %store the value to compute the time derivative    
%     Ax_maxmin_avg(1,in)=Ax_maxmin_avg_i;
    %----------------------------------------------------------------------  

    J_mag=sqrt(Jx.^2 + Jy.^2 + Jz.^2);
    J_mag_max_i=max(max(max(J_mag)));
    J_mag_max(1,jn)=J_mag_max_i;
    %--------------------------------------------------------------------------

    %str = string(S2(in).name);
    %newStr = extractBetween(str,"pfd_moments.","_p000000.h5");
    str = string(S(in).name);
    newStr = extractBetween(str,"pfd.","_p000000.h5");
    N_steps = str2double(newStr);
    time_t = dt*N_steps;    
    time_t_2(1,in)=time_t;

    yticks_mine=[floor(-Ly*0.9) floor(-Ly/2) 0 floor(Ly/2) floor(Ly*0.9)];
    zticks_mine=[floor(-Lx*0.9) floor(-Lx/2) 0 floor(Lx/2) floor(Lx*0.9)];


%     % This is the dummy test
%     %----------------------------------------------------------------------
%     %----------------------------------------------------------------------
%     sss=size(Bx);
%     size_X=sss;
%     xll=linspace(-Lx,Lx,size_X(1));
%     yll=linspace(-Ly,Ly,size_X(2)); %Jeff flag it works with (1,size_x(2))
%     [XLL, YLL] = meshgrid(xll,yll);
%     dx = resx; dy = resy;
%     %example to prove tjhat it works and it does.
%     %By_ej=cos(1*XLL.*2*pi/Lx); Atest=sin(1*XLL.*2*pi/Lx);
%     
%     Atest=sin(1*XLL.*2*pi/Lx).*sin(1*YLL.*2*pi/Ly);
%     Bx_ej=sin(1*XLL.*2*pi/Lx).*cos(1*YLL.*2*pi/Ly);
%     By_ej=-cos(1*XLL.*2*pi/Lx).*sin(1*YLL.*2*pi/Ly);
% 
%     %Computing Ax integrating; 
%     %----------------------------------------------------------------------
%     Iapprox_j = zeros(size(By(1,:)));
%     Iapprox_j(1,1)=dy*Bx_ej(1,1);
% 
%     for j=2:ny
%         Iapprox_j(1,j) = Iapprox_j(1,j-1) + dy*By_ej(1,j);
%     end
%     Iapprox_i = zeros(size(By));
%     Iapprox_i(1,:)=Iapprox_j;
%     for i=2:nx
%         Iapprox_i(i,:) = Iapprox_i(i-1,:) - dx*Bx_ej(i,:);
%     end
% 
%     Az=-Iapprox_i; % I need to substract the 0.2 but don's understand why
%     %----------------------------------------------------------------------
% 
%     %----------------------------------------------------------------------
%     cd(path_s2)
%     f55=figure(55);
%     h1=subplot(2,2,1);
%     hc=pcolor(Atest);
%     set(hc,'edgecolor','none')
%     colorbar; colormap(h1,BWR)
%     caxis([-1,1]);
%     title('Atest');
%     h2=subplot(2,2,2);
%     hc=pcolor(Az);
%     set(hc,'edgecolor','none')
%     colorbar; colormap(h2,BWR)
%     caxis([-1,1]);
%     title('Az');
%     h3=subplot(2,2,3);
%     hc=pcolor(Bx_ej);
%     set(hc,'edgecolor','none')
%     colorbar; colormap(h3,BWR)
%     caxis([-1,1]);
%     title('Bx_ej');
%     h4=subplot(2,2,4);
%     hc=pcolor(By_ej);
%     set(hc,'edgecolor','none')
%     colorbar; colormap(h4,BWR)
%     caxis([-1,1]);
%     title('By_ej');
% 
%     %Check the derivatives to see how beutifully it works
%     %----------------------------------------------------------------------
%     A2=zeros(size(Az));
%     A1=zeros(size(Az));
%     
%     A2(:,1:end-1)=Az(:,2:end);
%     A2(:,end)=Az(:,1); % to get the periodic thing correct
%     A1(:,1:end-1)=Az(:,1:end-1);
%     A1(:,end)=Az(:,end);
%     A21_y=(A2 - A1)./resy;
% 
%     %A21_y=-A21_y;
% 
%     A2(1:end-1,:)=Az(2:end,:);
%     A2(end,:)=Az(1,:); % to get the periodic thing correct
%     A1(1:end-1,:)=Az(1:end-1,:);
%     A1(end,:)=Az(end,:);
%     A21_x=(A2 - A1)/resx;
%     %----------------------------------------------------------------------
%     
%     f56=figure(56);
%     h1=subplot(2,2,1);
%     hc=pcolor(By_ej);
%     set(hc,'edgecolor','none')
%     title('By_ej')
%     colorbar; colormap(h1,BWR);caxis([-0.7,0.7]);
%     h2=subplot(2,2,2);
%     hc=pcolor(-A21_y);
%     set(hc,'edgecolor','none')
%     title('-dyAz')
%     colorbar; colormap(h2,BWR);caxis([-0.7,0.7]);
%     h3=subplot(2,2,3);
%     hc=pcolor(Bx_ej);
%     set(hc,'edgecolor','none')
%     title('Bx_ej')
%     colorbar;colormap(h3,BWR);caxis([-0.7,0.7]);
%     h4=subplot(2,2,4);
%     %hc=pcolor(A21_x);
%     hc=pcolor(A21_x);
%     set(hc,'edgecolor','none')
%     title('dxAz')
%     colorbar;colormap(h4,BWR);caxis([-0.7,0.7]);
%     mean(abs(By_ej-(-A21_y)),'all') 
%     mean(abs(Bx_ej-(A21_x)),'all') 
%     %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    %----------------------------------------------------------------------


    % This is with the data and it works!!    
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    dx = resx; dy = resy;
    %----------------------------------------------------------------------
    %Computing Ax integrating; 
    %----------------------------------------------------------------------
    Iapprox_j = zeros(size(By(1,:)));
    Iapprox_j(1,1)=dy*By(1,1);

    for j=2:ny
        Iapprox_j(1,j) = Iapprox_j(1,j-1) + dy*By(1,j);
    end
    Iapprox_i = zeros(size(By));
    Iapprox_i(1,:)=Iapprox_j;
    for i=2:nx
        Iapprox_i(i,:) = Iapprox_i(i-1,:) - dx*Bx(i,:);
    end

    Az=-Iapprox_i; % 
    
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    cd(path_s2)
    f55=figure(55);
    h1=subplot(1,1,1);
    hc=pcolor(Az);
    set(hc,'edgecolor','none')
    colorbar; colormap(h1,BWR)
    %caxis([-1,1]);
    title('Az');

    %Check the derivatives to see how beutifully it works
    %----------------------------------------------------------------------
    A2=zeros(size(Az));
    A1=zeros(size(Az));
    
    A2(:,1:end-1)=Az(:,2:end);
    A2(:,end)=Az(:,1); % to get the periodic thing correct
    A1(:,1:end-1)=Az(:,1:end-1);
    A1(:,end)=Az(:,end);
    A21_y=(A2 - A1)./resy;

    A2=zeros(size(Az));
    A1=zeros(size(Az));

    A2(1:end-1,:)=Az(2:end,:);
    A2(end,:)=Az(1,:); % to get the periodic thing correct
    A1(1:end-1,:)=Az(1:end-1,:);
    A1(end,:)=Az(end,:);
    A21_x=(A2 - A1)/resx;
    %----------------------------------------------------------------------
    
    f56=figure(56);
    h1=subplot(2,2,1);
    dum_p=By ;hc=pcolor(dum_p);
    set(hc,'edgecolor','none')
    title('By')
    colorbar; colormap(h1,BWR);caxis([-max(max(abs(dum_p))),max(max(abs(dum_p)))]);
    h2=subplot(2,2,2);
    dum_p=-A21_y ;hc=pcolor(dum_p);
    set(hc,'edgecolor','none')
    title('-dyAz')
    colorbar; colormap(h2,BWR);caxis([-max(max(abs(dum_p))),max(max(abs(dum_p)))]);
    h3=subplot(2,2,3);
    dum_p=Bx ;hc=pcolor(dum_p);
    set(hc,'edgecolor','none')
    title('Bx')
    colorbar;colormap(h3,BWR);caxis([-max(max(abs(dum_p))),max(max(abs(dum_p)))]);
    h4=subplot(2,2,4);
    %hc=pcolor(A21_x);
    dum_p=A21_x ;hc=pcolor(dum_p);
    set(hc,'edgecolor','none')
    title('dxAz')
    colorbar;colormap(h4,BWR);caxis([-max(max(abs(dum_p))),max(max(abs(dum_p)))]);
    %mean(abs(By-(-A21_y)),'all') 
    %mean(abs(Bx-(A21_x)),'all') 
    %----------------------------------------------------------------------
    clearvars Iapprox_i Iapprox_j Az A21_x A21_y
    %----------------------------------------------------------------------
    cd(path_rec_line)
    saveas(f56,strcat(num2str(time_t),'Az.png'));
    saveas(f56,strcat(num2str(time_t),'BxBy.png'));
    %----------------------------------------------------------------------

    cd(path)
end

%         %Checking the fourier transform to see 
%     %----------------------------------------------------------------------
%     threshold=pi/resy; 
%     var=Az;
%     N=size(var);
%     var=var-mean(mean(mean((var)))); %Detrend mean
%     FF_Az = abs(fftn(var)).*sqrt(N(1)*N(2));
%     S_FF_Az = fftshift(FF_Az);
%     
%     kx=((0:N(1)-1)-N(1)/2).*2*pi/Lx; %Includes negative wavenumbers
%     ky=((0:N(2)-1)-N(2)/2).*2*pi/Ly;
%     %kz=((0:N(3)-1)-N(3)/2).*2*pi/Lz;
% 
%   
%     xx=real(S_FF_Az);
%     yy=imag(S_FF_Az);
% 
%     Amp=sqrt(xx.^2 + yy.^2);
%     phase=atan(yy./xx);
% 
%     %cd(path_s)
%     %S_FF_Az=CalcSpectra_CB_n(Az,resx,threshold);
% 
%     cd(path_s2)
%     f45=figure(45);
%     h1=subplot(2,3,1);
%     hc=pcolor(Az);
%     set(hc,'edgecolor','none')
%     colorbar; colormap(h1,BWR)
%     %caxis([-1,1]);
%     title('Az');
%     h2=subplot(2,3,2);
%     dum_p=xx; 
%     dum_p = sign(dum_p).*log(1+abs(dum_p));
%     hc=pcolor(dum_p);
%     set(hc,'edgecolor','none')
%     colorbar; colormap(h2,BWR)
%     %caxis([-1,1]);
%     title('log(1+xx)');
%     h3=subplot(2,3,3);
%     dum_p=yy; 
%     dum_p = sign(dum_p).*log(1+abs(dum_p));
%     hc=pcolor(dum_p);
%     set(hc,'edgecolor','none')
%     colorbar; colormap(h3,BWR)
%     %caxis([-1,1]);
%     title('log(1+yy)');
%     h4=subplot(2,3,4);
%     dum_p=Amp; 
%     dum_p = sign(dum_p).*log(1+abs(dum_p));
%     hc=pcolor(dum_p);
%     set(hc,'edgecolor','none')
%     colorbar; colormap(h4,BWR)
%     %caxis([-1,1]);
%     title('log(1+Amp)');
%     h5=subplot(2,3,5);
%     hc=pcolor(phase);
%     set(hc,'edgecolor','none')
%     colorbar; colormap(h5,BWR)
%     %caxis([-1,1]);
%     title('phase');
%     %----------------------------------------------------------------------
% 
%     %magnetic fields to check the divB=0 for the simulated Bx and By
%     %----------------------------------------------------------------------
%     A2=zeros(size(By));
%     A1=zeros(size(By));
%     By21_y=zeros(size(By));
%     A2(:,1:end-1)=By(:,2:end); A2(:,end)=By(:,1);
%     A1=By;%A1(:,1:end-1)=By(:,1:end-1); A1(:,end)=By(:,end);
%     By21_y=(A2 - A1)/resy;
% 
%     A2=zeros(size(By));
%     A1=zeros(size(By));
%     Bx21_x=zeros(size(By));
%     A2(1:end-1,:)=Bx(2:end,:); A2(end,:)=Bx(1,:);
%     A1=Bx;%A1(1:end-1,:)=Bx(1:end-1,:); A1(end,:)=Bx(end,:);
%     Bx21_x=(A2 - A1)/resx;   
% 
%     f545=figure(545);
%     h1=subplot(1,1,1);
%     hc=pcolor(Bx21_x+By21_y);
%     set(hc,'edgecolor','none')
%     colorbar; colormap(h1,BWR)
%     %caxis([-1,1]);
%     title('DivBxy');
%     %----------------------------------------------------------------------

%     %magnetic fields to check the divB=0 for the computed Bx and By
%     %----------------------------------------------------------------------
%     A2=zeros(size(By));
%     A1=zeros(size(By));
% 
%     A2=A21_x(:,2:end); A2(:,end)=A21_x(:,1);
%     A1=A21_x(:,1:end-1); A1(:,end)=A21_x(:,end);
%     By21_y=(A2 - A1)/resy;
% 
%     A2=zeros(size(By));
%     A1=zeros(size(By));
% 
%     A2=A21_y(2:end,:); A2(end,:)=A21_y(1,:);
%     A1=A21_y(1:end-1,:); A1(end,:)=A21_y(end,:);
%     Bx21_x=(A2 - A1)/resx;    
%     %----------------------------------------------------------------------
%     f555=figure(555);
%     h1=subplot(1,2,1);
%     hc=pcolor(Az_x);
%     set(hc,'edgecolor','none')
%     colorbar; colormap(h1,BWR)
%     %caxis([-1,1]);
%     title('Az_x');
%     h2=subplot(1,2,2);
%     hc=pcolor(Az_y);
%     set(hc,'edgecolor','none')
%     colorbar; colormap(h2,BWR)
%     %caxis([-1,1]);
%     title('Az_y');
%     %---------------------------------------------------------------------- 
%     f565=figure(565);
%     subplot(2,2,1)
%     hc=pcolor(By);
%     set(hc,'edgecolor','none')
%     title('By')
%     colorbar
%     subplot(2,2,2)
%     hc=pcolor(A21_y);
%     set(hc,'edgecolor','none')
%     title('dyAz')
%     colorbar
%     subplot(2,2,3)
%     hc=pcolor(Bx);
%     set(hc,'edgecolor','none')
%     title('Bx')
%     colorbar
%     subplot(2,2,4)
%     hc=pcolor(-A21_x);
%     set(hc,'edgecolor','none')
%     title('-dxAz')
%     colorbar
%     %----------------------------------------------------------------------   


    %To see the contours of the vector potential and the value of the
    %reconneting electric field.
    cd(path_s2)
    %----------------------------------------------------------------------
    fs=18;
    f575=figure(575);
    h1=subplot(2,1,1);
    %hc=pcolor(ZLL,YLL,Ex);
    %set(hc,'edgecolor','none')
    %hold on
    dum_p=Ax_y;
    lim_yp=max(max(max(abs(dum_p))));
    dum_p=dum_p/lim_yp;    
    [C,h]=contourf(XLL,YLL,dum_p,'LevelStep',0.1);
    set(h,'LineColor','black','LineWidth',1)
    colorbar
    colormap(h1,'jet');
    %set(hc1,'edgecolor','none')
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    %hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ; 
%     if lim_yp~=0
%     %caxis([0 lim_yp]);
%     caxis([0 7]);
%     end
    %caxis([0 7]); % this changes according to each case
    caxis([0 1]); % lange_all
    %hcb.Ruler.Exponent = -1;
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
    lgnd=legend([h1],'$\frac{A_{x}}{A_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    %set(lgnd,'color','none');
    hold off
    %----------------------------------------------------------------------
    h2=subplot(2,1,2);
    dum_p=Ex/E0;
    hc2 = pcolor(XLL,YLL,dum_p);
    hold on
    set(hc2,'edgecolor','none')
    colorbar
    lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR);
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    %hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ; 
    %if lim_yp~=0
    %caxis([-lim_yp lim_yp]);
    %end
    %caxis([-0.6 0.6]);
    %hcb.Ruler.Exponent = -1;
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
    lgnd=legend([h2],'$\frac{E_{x}}{E_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    %set(lgnd,'color','none');
    hold off
    sgtitle('$$t = \ $$'+string(round((time_t/omega_pe_Omega_ce),2)) + ...
        '$$ \ \Omega_{ce}^{-1}$$','Interpreter','latex','FontSize',fs)

    f585=figure(585);
    h1=subplot(2,1,1);
    %hc=pcolor(ZLL,YLL,Ex);
    %set(hc,'edgecolor','none')
    %hold on
    dum_p=Jz;
    lim_yp=max(max(max(abs(dum_p))));
    dum_p=dum_p/lim_yp;    
    [C,h]=contourf(XLL,YLL,dum_p,'LevelStep',0.1);
    set(h,'LineColor','black','LineWidth',1)
    colorbar
    colormap(h1,BWR);
    %set(hc1,'edgecolor','none')
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    %hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ; 
%     if lim_yp~=0
%     %caxis([0 lim_yp]);
%     caxis([0 7]);
%     end
    %caxis([0 7]); % this changes according to each case
    %caxis([0 1]); % lange_all
    %hcb.Ruler.Exponent = -1;
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
    lgnd=legend([h1],'$\frac{J_{z}}{J_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    %set(lgnd,'color','none');
    hold off
    %----------------------------------------------------------------------
    h2=subplot(2,1,2);
    dum_p=sqrt(Bx.^2 + By.^2)./B0;
    hc2 = pcolor(XLL,YLL,dum_p);
    hold on
    set(hc2,'edgecolor','none')
    colorbar
    lim_yp=max(max(max(abs(dum_p)))); colormap(h2,jet);
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    %hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ; 
    %if lim_yp~=0
    %caxis([-lim_yp lim_yp]);
    %end
    %caxis([-0.6 0.6]);
    %hcb.Ruler.Exponent = -1;
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
    lgnd=legend([h2],'$\frac{|B|}{B_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    %set(lgnd,'color','none');
    hold off
    sgtitle('$$t = \ $$'+string(round((time_t/omega_pe_Omega_ce),2)) + ...
        '$$ \ \Omega_{ce}^{-1}$$','Interpreter','latex','FontSize',fs)
    
    %----------------------------------------------------------------------
    cd(path_rec_line)
    saveas(f57,strcat(num2str(time_t),'Ax_Ex.png'));
    %----------------------------------------------------------------------

    cd(path)

%end


% This didn't work that well with the data
%----------------------------------------------------------------------
%     Iapprox_y = zeros(size(By));
%     Iapprox_x = zeros(size(Bx));
%     Iapprox_i_y=0;
%     Iapprox_i_x=0;
%     for j=1:ny-1
%         for i=1:nx-1
%             Iapprox_i_x = Iapprox_i + dx*dy*By(i,j);
%             Iapprox_i_y = Iapprox_i + dx*dy*Bx(i,j);
%             Iapprox_x(i,j)=Iapprox_i_x;
%             Iapprox_y(i,j)=Iapprox_i_y;
%         end
%     end
% 
%     
%     Az_x=Iapprox_x;
%     Az_y=Iapprox_y;
% 
%     f55=figure(55);
%     h1=subplot(2,2,1);
%     hc=pcolor(Az_x);
%     set(hc,'edgecolor','none')
%     colorbar; colormap(h1,BWR)
%     %caxis([-1,1]);
%     title('Az_x');
%     h2=subplot(2,2,2);
%     hc=pcolor(Az_y);
%     set(hc,'edgecolor','none')
%     colorbar; colormap(h2,BWR)
%     %caxis([-1,1]);
%     title('Az_y');
%     h3=subplot(2,2,3);
%     hc=pcolor(Az-Atest);
%     set(hc,'edgecolor','none')
%     colorbar; colormap(h3,BWR)
%     %caxis([-1,1]);
%     title('Az-Atest');
%     mean(abs(Az-Atest),'all') %= 0.0137
% 
%     %Check the derivatives to see how beutifully it works
%     %----------------------------------------------------------------------
%     A2=zeros(size(Az_x));
%     A1=zeros(size(Az_x));
%     
%     A2(:,1:end-1)=Az_y(:,2:end);
%     A2(:,end)=Az(:,1); % to get the periodic thing correct
%     A1(:,1:end-1)=Az_y(:,1:end-1);
%     A1(:,end)=Az(:,end);
%     A21_y=(A2 - A1)./resy;
% 
%     %A21_y=-A21_y;
% 
%     A2(1:end-1,:)=Az_x(2:end,:);
%     A2(end,:)=Az(1,:); % to get the periodic thing correct
%     A1(1:end-1,:)=Az_x(1:end-1,:);
%     A1(end,:)=Az(end,:);
%     A21_x=(A2 - A1)/resx;
%     %----------------------------------------------------------------------
%     
%     %----------------------------------------------------------------------
%     cd(path_s2)
%     f56=figure(56);
%     h1=subplot(2,2,1);
%     dump=By;
%     hc=pcolor(dump);
%     %hc=pcolor(dump./max(max(abs(dump))));
%     set(hc,'edgecolor','none')
%     title('By')
%     colorbar; colormap(h1,BWR); %caxis([-1,1]);
%     h2=subplot(2,2,2);
%     dump=-A21_y;
%     hc=pcolor(dump);
%     %hc=pcolor(dump./max(max(abs(dump))));
%     set(hc,'edgecolor','none')
%     title('-dyAz')
%     colorbar; colormap(h2,BWR);%caxis([-1,1]);
%     h3=subplot(2,2,3);
%     dump=Bx;
%     hc=pcolor(dump);
%     %hc=pcolor(dump./max(max(abs(dump))));
%     set(hc,'edgecolor','none')
%     title('Bx')
%     colorbar;colormap(h3,BWR);%caxis([-1,1]);
%     h4=subplot(2,2,4);
%     dump=A21_x;
%     hc=pcolor(dump);
%     %hc=pcolor(dump./max(max(abs(dump))));
%     set(hc,'edgecolor','none')
%     title('dxAz')
%     colorbar;colormap(h4,BWR);%caxis([-1,1]);
%     mean(abs(By-(-A21_y)),'all') 
%     mean(abs(Bx-(A21_x)),'all') 


%     % this doesn't work on any combination of Bx or By
%     %----------------------------------------------------------------------
%     %integral over x
%     Iapprox = zeros(size(By));
%     Iapprox_i = 0;
%     Iapprox_j = 0;
%     for i=1:ny-1
%             Iapprox_i = Iapprox_i + dx*By(i,:);
%             Iapprox(i,:)=Iapprox_i;
%     end
%     %integral over y. 
%     for j=1:ny-1
%             Iapprox_j = Iapprox_j + dy*Iapprox(:,j);
%             Iapprox(:,j)=Iapprox_j;
%     end
%     Ax_y=Iapprox;
%     %Ax_y=-Ax_y;
% 
%     %----------------------------------------------------------------------



%     %----------------------------------------------------------------------
%     dx = resx; dy = resy;
%     %----------------------------------------------------------------------
%     %integral over x. This produces a correct By
%     Iapprox_x = zeros(size(By));
%     Iapprox_i = 0;
%     for i=1:ny-1
%             Iapprox_i = Iapprox_i + dx*By(i,:); %Bx(i,:)
%             Iapprox_x(i,:)=Iapprox_i;
%     end
% 
%     Az_x=-Iapprox_x; %<------- This is the correct Ax
%     %----------------------------------------------------------------------
% 
%     %----------------------------------------------------------------------
%     %integral over y. This produces a correct Bx
%     Iapprox_y = zeros(size(By));
%     Iapprox_i = 0;
%     for i=1:ny-1
%             Iapprox_i = Iapprox_i + dy*Bx(:,i); %By(i,:)
%             Iapprox_y(:,i)=Iapprox_i;
%     end
%     Az_y=Iapprox_y;
%     %----------------------------------------------------------------------
%     %Ax_y=Az_x; % good By
%     Ax_y=Az_y; % good Bx
%     %Ax_y=(Az_x+Az_y)/2; % The average doesn't work
%     %----------------------------------------------------------------------

%%-------------------------------------------------------------------------
% %-------------------------------------------------------------------------
%     % This is trying to compute the double integral. It doesn't work either
%     %----------------------------------------------------------------------    
%     for i=1:nx% This has the problem of the singular same point
%         for j=1:ny
%             Az_y = trapz(Jz ./ sqrt( (XLL-XLL(i,j))^.2 + (YLL-YLL(i,j))^.2 ) ) ;
%             Az_yx = trapz(Az_y);
%         end
%     end
% 
%     dum_p=0;
%     Az_yxx=zeros(size(By));
%     Az_y=zeros(1,ny);
%     for i=1:100 % loop over x
%         for j=1:100 %loop over y
%             for ip=1:100 %integration over x
%                 for jp=1:100 %integration over y
%                     if(i~=ip || j~=jp) % condition to avoid zero division
%                         Az_y(1,jp) = dum_p + (Jz(ip,jp) ./ sqrt( (XLL(i,j)-XLL(ip,jp))^.2 + (YLL(i,j)-YLL(ip,jp))^.2 ) )*resy ;
%                         dum_p = Az_y(1,jp);                        
%                     elseif(i==ip && j==jp)
%                         continue
%                     end
%                 end
%                 %Az_yx = dum_p2 + Az_y(1,jp)*resx;
%                 %dump_2 = Az_yx;
%                 Az_yx = sum(Az_y)*resx;
%             end
%             Az_yxx(i,j)= Az_yx;
%         end
%     end
% 
%     dum_p=0;
%     Az_yxx=zeros(size(By));
%     Az_y=zeros(1,ny);
%     for i=1:nx-1 % loop over x
%         for j=1:ny-1 %loop over y
%             for ip=1:nx-1 %integration over x
%                 for jp=1:ny-1 %integration over y
%                     if(i~=ip || j~=jp) % condition to avoid zero division
%                         Az_y(1,jp) = real(dum_p + (Jz(ip,jp) ./ sqrt( (xll(1,i)-xll(1,ip)).^2 + (yll(1,j)-yll(1,jp)).^2 ) )*resy) ;
%                         dum_p = (Az_y(1,jp));                        
%                     elseif(i==ip && j==jp)
%                         continue
%                     end
%                 end
%                 %Az_yx = dum_p2 + Az_y(1,jp)*resx;
%                 %dump_2 = Az_yx;
%                 Az_yx = sum(Az_y)*resx;
%             end
%             Az_yxx(i,j)= Az_yx;
%         end
%     end
% 
%     f43=figure(43);
%     h1=subplot(1,1,1)
%     hc=pcolor(real(Az_yxx));
%     set(hc,'edgecolor','none')
%     title('Az_yxx')
%     colorbar
% 
%     Ax_y=Az_yxx;
% 
%     Byt=By';
%     Qy_x = trapz(Byt);
%     [QQ_x,QQ_y] = meshgrid(Qy_x,Qy_y);
%     f44=figure(44);
%     h1=subplot(1,2,1)
%     hc=pcolor(QQ_x);
%     set(hc,'edgecolor','none')
%     title('QQ_x')
%     h2=subplot(1,2,2)
%     hc=pcolor(QQ_y);
%     set(hc,'edgecolor','none')
%     title('QQ_y')
%     %--------------------------------------------------------------------
% %     %--------------------------------------------------------------------
% %     %--------------------------------------------------------------------

%     %----------------------------------------------------------------------
%     % Check the derivatives to see how beutifully it works
%     %----------------------------------------------------------------------
%     A2=zeros(size(By));
%     %A1=zeros(size(By));
% 
%     A2(:,1:end-1)=Ax_y(:,2:end); A2(:,end)=Ax_y(:,1);
%     A1=Ax_y;%A1(:,1:end-1)=Ax_y(:,1:end-1); A1(:,end)=Ax_y(:,end);
%     A21_y=(A2 - A1)/resy;
% 
%     A2=zeros(size(By));
%     %A1=zeros(size(By));
% 
%     A2(1:end-1,:)=Ax_y(2:end,:); A2(end,:)=Ax_y(1,:);
%     A1=Ax_y;%A1(1:end-1,:)=Ax_y(1:end-1,:); A1(end,:)=Ax_y(end,:);
%     A21_x=(A2 - A1)/resx;
%     %----------------------------------------------------------------------

