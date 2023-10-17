%This is the file that computes the vector potential initially in 2D also
%trying to get the reconnection rate

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_1/psc_harris_yz_base_ppc1000_ome2_mime1/psc_harris_yz_base_ppc1000_ome2_mime1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_1/psc_harris_yz_lange_all_ppc1000_ome2_mime1/psc_harris_yz_lange_all_ppc1000_ome2_mime1';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/psc_harris_yz_lange_all_ppc600_ome2_mime1_3D';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_3';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large';

%With the guide field and 4di thickness
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_Ax_large';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_alone_large';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_alone_large_2';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_8';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noiniL8di_8';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini_L8di_8_dum';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini_L8di_8_du02';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_ome01_cp';

path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_Omc1';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_dummy_2';

%--------------------------------------------------------------------------
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_many_Ax_large_L10di/';
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_many_Ax_large_L10di_CP/';
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_many_Ax_large_L10di_lange_local/';
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_Tba_perpar_short_L1di';
path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_short_L1di';
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_short_L1di';
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_Tba_perpar_short_L4di';
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_short_L4di';
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_short_L4di';
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_many_Ax_large_L8di_lange_local/';
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_many_Ax_large_L8di_lange_local_asi/';
%--------------------------------------------------------------------------

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
%--------------------------------------------------------------------------
S = dir(fullfile(path,'pfd.*.h5'));
N=numel(S); % number of files to use
H=zeros(N);
%--------------------------------------------------------------------------
S2 = dir(fullfile(path,'pfd_moments.*.h5'));
N2=numel(S2); % number of files to use
H2=zeros(N2);
%--------------------------------------------------------------------------

in=10;

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

nb_n0 =0.2;

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
nb_n0 =0.2;

Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);

%Normalising only when making plots
%c=1; VA2c = 0.2;
%B0 = VA2c; E0 = B0*VA2c;
%Pi0 = mi*VA2c*VA2c; Pe0 = me*VA2c*VA2c;
%DeltaEpsilon0=VA2c*Pi0;
%DeltaEpsilon0=Pi0;
%--------------------------------------------------------------------------

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
%--------------------------------------------------------------------------
jn=1;
jn=N

N_jn=N; %This is to store some but not all the time steps
Ex_rec_avg=zeros(1,N_jn);
time_t_2=zeros(1,N_jn);
Ax_maxmin_avg=zeros(1,N_jn);
Ax_max_a=zeros(1,jn);
Ax_min_a=zeros(1,jn);

J_mag_max=zeros(1,N_jn);
%--------------------------------------------------------------------------

%for jn=1:N
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
    %disp(strcat('Computing step ...',S2(in).name))    
%     fileID2 =  S2(in).name; %change the 1 per i
%     %h5disp(fileID2);
%     info2 = h5info(fileID2);
%     moments_1st = info2.Groups(1).Name;
    %----------------------------------------------------------------------
    
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
    %----------------------------------------------------------------------  

    % computing magnetic flux velocity
    %----------------------------------------------------------------------  
    Bp=sqrt(B{1,2}.^2 + B{1,3}.^2);

    by=B{1,2}./Bp;
    bz=B{1,3}./Bp;

    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    % slice in x
    ssz=size(Bp);
    sli_x = 1; % this value has to change to reconstruct the vector potential
    sli_y = floor(4+ssz(2)/2);%380;
    sli_z = floor(2+ssz(3)/2);%700;
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------

    Bp=squeeze(Bp(sli_x,:,:));

%     % Is this still well defined like this in the 3D case?
%     % Computing the divergence of the MFT
%     %----------------------------------------------------------------------
%     MFT_y = - (c.*E{1,1}./Bp).*bz ; 
%     MFT_z =  (E{1,1}./Bp).*by ;
%     MFTm=sqrt(MFT_z.^2 + MFT_y.^2);
%     
%     MFT_y=squeeze(MFT_y(sli_x,:,:));
%     MFT_z=squeeze(MFT_z(sli_x,:,:));
%     %----------------------------------------------------------------------
% 
%     % Computing the divergence of the MFT
%     %----------------------------------------------------------------------  
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
 

    % computing the electric field terms
    %----------------------------------------------------------------------  
    Ex = E{1,1}; Ex = squeeze(Ex(sli_x,:,:));
    Ey = E{1,2}; Ey = squeeze(Ey(sli_x,:,:));
    Ez = E{1,3}; Ez = squeeze(Ez(sli_x,:,:));

    Bx = B{1,1}; Bx = squeeze(Bx(sli_x,:,:));
    By = B{1,2}; By = squeeze(By(sli_x,:,:));
    Bz = B{1,3}; Bz = squeeze(Bz(sli_x,:,:));

    Jx = J{1,1}; Jx = squeeze(Jx(sli_x,:,:));
    Jy = J{1,2}; Jy = squeeze(Jy(sli_x,:,:));
    Jz = J{1,3}; Jz = squeeze(Jz(sli_x,:,:));


    % Defining the function to compute the reconnection rate
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%     % Solving the poisson equation.. this is not quite working yet
%     %----------------------------------------------------------------------
%     % Compute Curl of magnetic field
%     sss=size(Bx);
%     ny=sss(1);
%     nz=sss(2);
%     curlB=zeros(sss);
%     for j=2:ny-1
%         for k=2:nz-1
%             curlB(j,k)=(Bz(j+1,k)-Bz(j-1,k))/2*resy - (By(j,k+1)-By(j,k-1))/2*resz;
%         end
%     end
%     % To get the cells in the last rows and columns
%     curlB(1,:) = curlB(2,:);
%     curlB(ny,:) = curlB(ny-1,:);
%     curlB(:,1) = curlB(:,nz-1);
%     curlB(:,nz) = curlB(:,2);
% 
%     %----------------------------------------------------------------------    
%     % solve the poisson equation
%     curlB_hat = fft(-curlB);
% 
%     for k=1:nz
%         for j=1:ny
%             factor=(-1i*2*pi*resz*k/Lz)^2 + (-1i*2*pi*resy*j/Ly)^2;
%         end
%     end
% 
%     phipq=curlB_hat./factor;
% 
%     % Computing the out of plane vector potential; 
%     Ax=ifft(phipq);
    %----------------------------------------------------------------------


    %----------------------------------------------------------------------
    sss=size(Bx);
    size_X=sss;
    zll=linspace(-Lz,Lz,size_X(2)); %Jeff flag it works with (1,size_x(2))
    yll=linspace(-Ly,Ly,size_X(1));
    [ZLL, YLL] = meshgrid(zll,yll);
    %----------------------------------------------------------------------
    

    % Compute the out of the plane vector potential
    %----------------------------------------------------------------------
    % get ax integrating over y
    dx = resy; dy = resz;
    ny=sss(1);
    nz=sss(2);
    Iapprox = zeros(size(By));
    Iapprox_i=0;
    %integral over y
    for i=1:ny-1
            Iapprox_i = Iapprox_i + dy*Bz(i,:);
            Iapprox(i,:)=Iapprox_i;
    end

    Ax_y=Iapprox; %<------- This is the correct Ax
    Ax_y=-Ax_y;
    %----------------------------------------------------------------------


    %----------------------------------------------------------------------
    %example to prove that it works and it does.
    By_ej=cos(1*ZLL.*2*pi/Lz); Atest=sin(1*ZLL.*2*pi/Lz);

    %Computing Ax integrating; 
    %----------------------------------------------------------------------
    dx = resy; dy = resz;
    Iapprox = zeros(size(By));
    Iapprox_i=0;
    for i=1:ny-1
        for j=1:nz-1
            Iapprox_i = Iapprox_i + dx*dy*By_ej(i,j);
            Iapprox(i,j)=Iapprox_i;
        end
    end
% 
%     f55=figure(55);
%     subplot(1,2,1)
%     hc=pcolor(Atest);
%     set(hc,'edgecolor','none')
%     colorbar
%     subplot(1,2,2)
%     hc=pcolor(Iapprox);
%     set(hc,'edgecolor','none')
%     colorbar
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    % Check the derivatives to see how beutifully it works
    A2=Ax_y(:,2:end);
    A1=Ax_y(:,1:end-1);
    A21_y=(A2 - A1)/resz;

    A2=Ax_y(2:end,:);
    A1=Ax_y(1:end-1,:);
    A21_z=-(A2 - A1)/resy;
    %---------------------------------------------------------------------- 
%     f56=figure(56); %<----------------------- this is to check that Bx
%     and dAx works
%     subplot(2,2,1)
%     hc=pcolor(By);
%     set(hc,'edgecolor','none')
%     title('By')
%     colorbar
%     subplot(2,2,2)
%     hc=pcolor(A21_y);
%     set(hc,'edgecolor','none')
%     title('-dzAx')
%     colorbar
%     subplot(2,2,3)
%     hc=pcolor(Bz);
%     set(hc,'edgecolor','none')
%     title('Bz')
%     colorbar
%     subplot(2,2,4)
%     hc=pcolor(A21_z);
%     set(hc,'edgecolor','none')
%     title('dyAx')
%     colorbar
    %----------------------------------------------------------------------   

    % Apply the condition of along Bz=0;
    %----------------------------------------------------------------------
    A_cond=zeros(length(yll),length(zll));
    for kn=1:length(zll)
        bz_min = min(abs(Bz(:,kn)));
        A_cond(:,kn)=(Bz(:,kn)==bz_min);
    end

%     epsi_1=0.001; %threshold
%     A1=(Bz<epsi_1); % find the regions where Bz=0
%     A_cond=A1;

    Ax_y_bz0=A_cond.*Ax_y; % find the value of the reconnecting electric field
    %----------------------------------------------------------------------

    %---------------------------------------------------------------------- 
%     f57=figure(57);
%     subplot(2,2,1)
%     [C,h]=contourf(Ax_y,'LevelStep',0.2);
%     set(h,'LineColor','black','LineWidth',1)
%     %hc=pcolor(-Ax_y);
%     %set(hc,'edgecolor','none')
%     title('Ax_y')
%     colorbar
%     subplot(2,2,2)
%     hc=pcolor(Ax_y_bz0);
%     set(hc,'edgecolor','none')
%     title('cond*Ax_y')
%     colorbar
    %---------------------------------------------------------------------- 

    % Get the maximum and the minimum
    %---------------------------------------------------------------------- 
    Ax_max=max(max(Ax_y_bz0));
    Ax_min=min(min(Ax_y_bz0));
    Ax_maxmin = Ax_max - Ax_min;
    Ax_maxmin_avg_i=Ax_maxmin; 

    Ax_max_a(1,jn)=Ax_max;
    Ax_min_a(1,jn)=Ax_min;
%     A_cond_n= A_cond(A_cond~=0);
%     Ax_maxmin_avera= sum((Ax_maxmin),'all')./ length(A_cond_n);
%     Ax_maxmin_avg_i=Ax_maxmin_avera/Vae_b; 

    %store the value to compute the time derivative    
    Ax_maxmin_avg(1,in)=Ax_maxmin_avg_i;
    %----------------------------------------------------------------------  

    %--------------------------------------------------------------------------
    J_mag=sqrt(Jx.^2 + Jy.^2 + Jz.^2);
    J_mag_max_i=max(max(J_mag));
    J_mag_max(1,jn)=J_mag_max_i;
    %--------------------------------------------------------------------------

    str = string(S(in).name);
    newStr = extractBetween(str,"pfd.","_p000000.h5");
    N_steps = str2double(newStr);
    time_t = dt*N_steps;    
    time_t_2(1,in)=time_t;
    time_t_2_Omega=time_t./omega_pe_Omega_ce;

    yticks_mine=[floor(-Ly*0.9) floor(-Ly/2) 0 floor(Ly/2) floor(Ly*0.9)];
    zticks_mine=[floor(-Lz*0.9) floor(-Lz/2) 0 floor(Lz/2) floor(Lz*0.9)];
    %----------------------------------------------------------------------


    %To see the contours of the vector potential and the value of the
    %reconneting electric field.
    cd(path_s2)
    %----------------------------------------------------------------------
    fs=18;
    f57=figure(57);
    h1=subplot(2,1,1);
    %hc=pcolor(ZLL,YLL,Ex);
    %set(hc,'edgecolor','none')
    %hold on
    dum_p=Ax_y;
    lim_yp=max(max(max(abs(dum_p))));
    dum_p=dum_p/lim_yp;    
    [C,h]=contourf(ZLL,YLL,dum_p,'LevelStep',0.1);
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
    xlim([zll(1) zll(end)]); ylim([yll(1) yll(end)]);
    lgnd=legend([h1],'$\frac{A_{x}}{A_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    %set(lgnd,'color','none');
    hold off
    %----------------------------------------------------------------------
    h2=subplot(2,1,2);
    dum_p=Ex/E0;
    hc2 = pcolor(ZLL,YLL,dum_p);
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
    caxis([-0.6 0.6]);
    %hcb.Ruler.Exponent = -1;
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([zll(1) zll(end)]); ylim([yll(1) yll(end)]);
    lgnd=legend([h2],'$\frac{E_{x}}{E_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    %set(lgnd,'color','none');
    hold off
    sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
    %----------------------------------------------------------------------
    cd(path_rec_line)
    saveas(f57,strcat(num2str(time_t),'Ax_Ex.png'));
    %----------------------------------------------------------------------

    cd(path)
end
%--------------------------------------------------------------------------


% Compute the time derivative
Ax_maxmin_avg21=(Ax_maxmin_avg(1,2:end) - Ax_maxmin_avg(1,1:end-1));
time_t_2_21=time_t_2(1,2:end) - time_t_2(1,1:end-1);
E_rec=(1)*Ax_maxmin_avg21./(Vae*time_t_2_21);


% express the time in terms of Omega_ce
%--------------------------------------------------------------------------

dt_Omega=dt/omega_pe_Omega_ce;
time_t_2_Omega=time_t_2./omega_pe_Omega_ce;
%--------------------------------------------------------------------------


% Where is window defined? The window must be defined with the average?
%--------------------------------------------------------------------------
fs=18;
f7=figure(7);
%dt_plot=time_t_2;
dt_plot=time_t_2_Omega;
plot(dt_plot(1,2:end),E_rec,'-k','LineWidth',2)
%plot(dt_plot(1,1:window),E_rec_av_Ome,'-k','LineWidth',2)
hold on
set(gca,'FontSize',20)
ax = gca;
ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
xlim([dt_plot(1) dt_plot(end)]);
%ylim([10^(1) 10^(10)]);
%xlabel('$$t (\omega_{pe}^{-1}) $$','Interpreter','latex','FontSize',fs)
xlabel('$$t (\Omega_{e}^{-1}) $$','Interpreter','latex','FontSize',fs)
ylabel('$$E_{x}/B_{0}v_{A,B}$$','Interpreter','latex','FontSize',fs)
%legend({'$|B|$','$|p_{ei}|$',},'Interpreter','latex','FontSize',fs)
hold off

f6=figure(6);
dt_plot=time_t_2_Omega;
%plot(time_t_2(1,:),J_mag_max(1,:),'-k','LineWidth',2)
plot(dt_plot(1,:),J_mag_max(1,:),'-k','LineWidth',2)
hold on
    set(gca,'FontSize',20)
    ax = gca;
    ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs;
%xlim([time_t_2(1) time_t_2(end)]);
%xlabel('$$t (\omega_{pe}^{-1}) $$','Interpreter','latex','FontSize',fs)
xlabel('$$t (\Omega_{e}^{-1}) $$','Interpreter','latex','FontSize',fs)
ylabel('$$|J_{max}|$$','Interpreter','latex','FontSize',fs)
%legend({'$|B|$','$|p_{ei}|$',},'Interpreter','latex','FontSize',fs)
hold off

cd(path_rec_line)
saveas(f7,strcat(num2str(time_t),'reconnection_line_2.png'));
saveas(f6,strcat(num2str(time_t),'Jmax_line_2.png'));
cd(path_s2)
%--------------------------------------------------------------------------






    cd(path_s2)
    % This is to call the script that will make and save the latests plots
    %--------------------------------------------------------------------------
    
   
    dCp=25; colorFVBl=[0 0 0 0.2]; %sv=3; asf=3; fs=18; lw=1.5;
    fs=20;

    % Plots
    %---------------------------------------------------------------------

    %---------------------
    map_r = [1.0 1.0 1.0
    1.0 0.9 0.9
    1.0 0.8 0.8
    1.0 0.7 0.7
    1.0 0.6 0.6
    1.0 0.5 0.5
    1.0 0.4 0.4
    1.0 0.3 0.3
    1.0 0.2 0.2
    1.0 0.1 0.1
    1.0 0 0
    0.8 0 0];
    %---------------------


    x0=0;y0=0;
    %x0=-1759;y0=258;
    asf=1;
    sv=10; %this one is for the vectors 
    lwv=1.0; ypc_i=127; xpc_i = 93;
    colorFVBl=[0 0 0 0.5];
    

    width=1300;%size_X(2);
    height=500;%size_X(1); 
    fs=20;


    yticks_mine=[floor(-Ly*0.9) floor(-Ly/2) 0 floor(Ly/2) floor(Ly*0.9)];
    zticks_mine=[floor(-Lz*0.9) floor(-Lz/2) 0 floor(Lz/2) floor(Lz*0.9)];
    %----------------------------------------------------------------------




    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Defining functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function f = fcoeffunction(location,state)
    %Nr = 1; % Number of equations
    %nr = length(location.z); % Number of columns
    f = state.u;%zeros(Nr,nr); % Allocate f
end
