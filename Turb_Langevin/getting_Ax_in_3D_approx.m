% This is to get an approximation to the out of the plane vector potential
% in 3D

clear all
close all

path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/psc_harris_yz_base_ppc600_ome2_mime1_3D';

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

mime =1.; %<----
omega_pe_Omega_ce=5;

MFT0=1; % is this simply one in this normalization

nb_n0 =0.1;

Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);

%Normalising only when making plots
c=1; VA2c = 0.2;
%--------------------------------------------------------------------------

nb_n0 =0.1;

Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);

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
jn=2;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
in=1;
%----------------------------------------------------------------------
fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;
B=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
ss=size(B);
LZs=ss(3);
clearvars B

%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
N_jn=N; %This is to store some but not all the time steps
Ex_rec_avg=zeros(1,N_jn);
time_t_2=zeros(1,N_jn);
inte_Ax_i=zeros(LZs,N_jn); %the 304 has to be replaced and defined in a better way

Ax_maxmin_avg=zeros(1,N_jn);
Ax_max_a=zeros(1,jn);
Ax_min_a=zeros(1,jn);
Ax_maxmin=zeros(1,jn);
Ex_maxmin=zeros(1,jn);

%To get the k of the dominant modes
kz_0_i=zeros(N_jn,4);
ky_0_i=zeros(N_jn,4);

Amp_ky_0_i=zeros(N_jn,4);
Amp_kz_0_i=zeros(N_jn,4);

Amp_ky_T_i=zeros(N_jn,4);
Amp_kz_T_i=zeros(N_jn,4);

J_mag_max=zeros(1,N_jn);
jn=50;
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

    B{1,1}=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    B{1,2}=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
    B{1,3}=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));

    E{1,1}=h5read(fileID,strcat(EHJ_1st,'/ex_ec/p0/3d'));
    %     E{1,2}=h5read(fileID,strcat(EHJ_1st,'/ey_ec/p0/3d'));
    %     E{1,3}=h5read(fileID,strcat(EHJ_1st,'/ez_ec/p0/3d'));

    %     J{1,1}=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'));
    %     J{1,2}=h5read(fileID,strcat(EHJ_1st,'/jy_ec/p0/3d'));
    %     J{1,3}=h5read(fileID,strcat(EHJ_1st,'/jz_ec/p0/3d'));

    %From 3D to 2D (x,y,z) to (y,z)
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------

    % computing magnetic flux velocity
    %----------------------------------------------------------------------
    Bp=sqrt(B{1,2}.^2 + B{1,3}.^2);

    by=B{1,2}./Bp;
    bz=B{1,3}./Bp;
    %----------------------------------------------------------------------
    % slice in x
    ssz=size(Bp);
    %----------------------------------------------------------------------
    Ax_i=zeros(ssz(1),ssz(2),ssz(3));
    %----------------------------------------------------------------------
    for ix=1:ssz(1)
        sli_x = ix; % this is the index that has to change
        sli_y = floor(4+ssz(2)/2);%380;
        sli_z = floor(2+ssz(3)/2);%700;
        %----------------------------------------------------------------------
        %----------------------------------------------------------------------

        Bp_s=squeeze(Bp(sli_x,:,:));

        % computing the electric field terms
        %----------------------------------------------------------------------
        Ex = E{1,1}; Ex_s = squeeze(Ex(sli_x,:,:));
        %     Ey = E{1,2}; Ey = squeeze(Ey(sli_x,:,:));
        %     Ez = E{1,3}; Ez = squeeze(Ez(sli_x,:,:));

        Bx = B{1,1}; Bx_s = squeeze(Bx(sli_x,:,:));
        By = B{1,2}; By_s = squeeze(By(sli_x,:,:));
        Bz = B{1,3}; Bz_s = squeeze(Bz(sli_x,:,:));

        %     Jx = J{1,1}; Jx = squeeze(Jx(sli_x,:,:));
        %     Jy = J{1,2}; Jy = squeeze(Jy(sli_x,:,:));
        %     Jz = J{1,3}; Jz = squeeze(Jz(sli_x,:,:));
        %----------------------------------------------------------------------

        % Defining the function to compute the reconnection rate
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %----------------------------------------------------------------------
        sss=size(Bx);
        size_X=sss;
        zll=linspace(-Lz,Lz,size_X(3)); %Jeff flag it works with (1,size_x(2))
        yll=linspace(-Ly,Ly,size_X(2));
        [ZLL, YLL] = meshgrid(zll,yll);

        %----------------------------------------------------------------------
        ny=sss(2);
        nz=sss(1);
        dz = resz; dy = resy;
        %----------------------------------------------------------------------

        %Computing Ax integrating; %This is the one that works better so far
        %----------------------------------------------------------------------
        Iapprox_j = zeros(size(By_s(1,:)));
        Iapprox_j(1,1)=dy*By_s(1,1); %<----- there is a problem here its a single and not double value

        for j=2:ny
            Iapprox_j(1,j) = Iapprox_j(1,j-1) + dy*By_s(1,j);
        end
        Iapprox_i = zeros(size(By_s));
        Iapprox_i(1,:)=Iapprox_j;
        for i=2:nz
            Iapprox_i(i,:) = Iapprox_i(i-1,:) - dz*Bz_s(i,:);
        end

        Ax=-Iapprox_i; %
        Ax_i(ix,:,:) = Ax;
    end

    Ax_m = squeeze(mean(Ax_i,1));
    Ax=Ax_m;


    % Let's do the average over the x axis to get an estimate

%     %----------------------------------------------------------------------
%     f3=figure(3)
%     plot(yll./0.5,-Ax(:,1),'k')
%     hold on
%     plot(yll./0.5,-Ax(:,75),'b')
%     plot(yll./0.5,-Ax(:,150),'r')
%     hold off
% 
%     %----------------------------------------------------------------------
%     %----------------------------------------------------------------------
%     cd(path_s2)
%     f55=figure(55);
%     h1=subplot(1,1,1);
%     hc=pcolor(Ax);
%     set(hc,'edgecolor','none')
%     colorbar; colormap(h1,jet)
%     %caxis([-1,1]);
%     title('Ax');
% 
%     %Check the derivatives to see how beutifully it works
%     %----------------------------------------------------------------------
%     A2=zeros(size(Ax));
%     A1=zeros(size(Ax));
% 
%     % dyAx
%     A2(:,1:end-1)=Ax(:,2:end);
%     A2(:,end)=Ax(:,1); % to get the periodic thing correct
%     A1(:,1:end-1)=Ax(:,1:end-1);
%     A1(:,end)=Ax(:,end);
%     A21_y=(A2 - A1)./resy;
% 
%     A2=zeros(size(Ax));
%     A1=zeros(size(Ax));
% 
%     A2(1:end-1,:)=Ax(2:end,:);
%     A2(end,:)=Ax(1,:); % to get the periodic thing correct
%     A1(1:end-1,:)=Ax(1:end-1,:);
%     A1(end,:)=Ax(end,:);
%     A21_z=(A2 - A1)/resz;
%     %----------------------------------------------------------------------
% 
%     f56=figure(56);
%     h1=subplot(2,2,1);
%     dum_p=By_s ;hc=pcolor(dum_p);
%     set(hc,'edgecolor','none')
%     title('By')
%     colorbar; colormap(h1,BWR);%caxis([-max(max(abs(dum_p))),max(max(abs(dum_p)))]);
%     h2=subplot(2,2,2);
%     dum_p=-A21_y ;hc=pcolor(dum_p);
%     set(hc,'edgecolor','none')
%     title('-dyAx')
%     colorbar; colormap(h2,BWR);%caxis([-max(max(abs(dum_p))),max(max(abs(dum_p)))]);
%     h3=subplot(2,2,3);
%     dum_p=Bz_s ;hc=pcolor(dum_p);
%     set(hc,'edgecolor','none')
%     title('Bz')
%     colorbar;colormap(h3,BWR);%caxis([-max(max(abs(dum_p))),max(max(abs(dum_p)))]);
%     h4=subplot(2,2,4);
%     %hc=pcolor(A21_x);
%     dum_p=A21_z ;hc=pcolor(dum_p);
%     set(hc,'edgecolor','none')
%     title('dzAx')
%     colorbar;colormap(h4,BWR);%caxis([-max(max(abs(dum_p))),max(max(abs(dum_p)))]);
    %mean(abs(By-(-A21_y)),'all')
    %mean(abs(Bx-(A21_x)),'all')
    %----------------------------------------------------------------------
    %clearvars Iapprox_i Iapprox_j Ax A21_z A21_y
    %----------------------------------------------------------------------

    % Integrate to do stack plots on time
    %----------------------------------------------------------------------
    %inte_Ax_i(:,jn) = sum(Ax,1)/length(Ax(:,1)); % this is to compute the average over the y direction
    inte_Ax_i(:,jn) = Ax(length(yll)/2,:); %The value of the Ax at (quasi) the neutral line.
    %----------------------------------------------------------------------

    abs_Ax=abs(Ax(length(yll)/2,:)); % get the Ax values on the neutral line
    %     f22=figure(22);
    %     plot(zll,abs_Ax)
    %     xlim([zll(1),zll(end)])
    %     ylim([-1,1])

%     %----------------------------------------------------------------------
%     % Get the local maxima and minima
%     Ax_max=max(max(abs_Ax));
%     Ax_min=min(min(abs_Ax));
%     Ax_maxmin_i = Ax_max - Ax_min;
% 
%     cond_max=(abs_Ax==Ax_max);
%     cond_min=(abs_Ax==Ax_min);
% 
%     clearvars Ex_maxmin_i
%     if(Ax_max~=Ax_min)
%         %get the position of the first min.
%         ind_max=(abs_Ax==Ax_min);
%         zll_2=zll.*ind_max;
%         aa=sum(ind_max~=0);
%         Ex_maxmin_i=sum(Ex_s(length(yll)/2).*ind_max)/aa; %average of the values of the electric field
%     else
%         Ex_maxmin_i=nan;
%     end
% 
%     %----------------------------------------------------------------------
%     %store the value to compute the time derivative
%     Ax_maxmin(1,in)=Ax_maxmin_i;
%     Ex_maxmin(1,in)=Ex_maxmin_i;
%     %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    %str = string(S2(in).name);
    %newStr = extractBetween(str,"pfd_moments.","_p000000.h5");
    str = string(S(in).name);
    newStr = extractBetween(str,"pfd.","_p000000.h5");
    N_steps = str2double(newStr);
    time_t = dt*N_steps;
    time_t_2(1,in)=time_t;

    yticks_mine=[floor(-Ly*0.9) floor(-Ly/2) 0 floor(Ly/2) floor(Ly*0.9)];
    zticks_mine=[floor(-Lz*0.9) floor(-Lz/2) 0 floor(Lz/2) floor(Lz*0.9)];
    %----------------------------------------------------------------------


    % Extract the modes to get the growth rate of each mode
    %----------------------------------------------------------------------
    threshold=pi/resy;
    var=Ax;

    % to test the algorithm
    %     var=1.*sin(2*pi*YLL./Ly) + 1.*sin(2*pi*ZLL./Lz) ;%+ 1.*sin(2*pi*YLL./Ly) + 1.*sin(2*pi*ZLL./Lz);
    %     f87=figure(87)
    %     pcolor(ZLL,YLL,var)

    N=size(var);
    var=var-mean(mean(mean((var)))); %Detrend mean
    FF_Ax = abs(fftn(var)).*sqrt(N(1)*N(2)); % it this normalization necessary?
    S_FF_Ax = fftshift(FF_Ax);

    kz=((0:N(2)-1)-N(2)/2).*2*pi/Lz; %Includes negative wavenumbers
    ky=((0:N(1)-1)-N(1)/2).*2*pi/Ly;
    %kz=((0:N(3)-1)-N(3)/2).*2*pi/Lz;

    % get the real and imaginary parts
    zz=real(S_FF_Ax);
    yy=imag(S_FF_Ax);

    % get the amplitude and phase
    Amp=sqrt(zz.^2)./(N(1)*N(2));
    %Amp=sqrt(yy.^2)./(N(1)*N(2)); % this returns nothing
    %Amp=(zz.^2 + yy.^2)./(N(1)*N(2));
    phase=atan(yy./zz)./(N(1)*N(2));

    %size1=size(Amp);
    %Amp=Amp./(size1(1)*size1(2));
    %size1=size(phase);
    %phase=phase./(size1(1)*size1(2));

    % Get the step in kz and ky
    dky=ky(end)-ky(end-1);
    dkz=kz(end)-kz(end-1);

    % To get the values on a single quadrant and removing the zero k
    %----------------------------------------------------------------------
    Na2_y =length(Amp(:,1))/2 + 1;
    Na2_z =length(Amp(1,:))/2 + 1;

    %     Amp=Amp(Na2_y:end,Na2_z:end);
    %     phase=phase(Na2_y:end,Na2_z:end);
    %     ky=ky(1,Na2_y:end);
    %     kz=kz(1,Na2_z:end);

    [KZ,KY]=meshgrid(kz,ky);
    % Removing first the values above the threshold.
    Amp= Amp.*((KY<threshold)).*((KZ<threshold));
    phase= phase.*((KY<threshold)).*((KZ<threshold));

    Amp_y = sum(Amp,1)*dky; %integral over y
    Amp_z = sum(Amp,2)*dkz; %integral over z

    %This block gives mixed values for the modes as, at each time the modes
    %do not extrictly corresponds to the first 4 harmonics.
    %----------------------------------------------------------------------
    % Get the positions of a given frequency by sorting to get the values
    % for the values ingrated over y so they depends on z
    [sorted_Amp_y, sortedInds_Amp_y] = sort(Amp_y(:),'descend');
    top4_z = sortedInds_Amp_y(1:4); % position of the maxima
    top4_Amp_y =sorted_Amp_y(1:4); % value of the maxima
    kz_0 = kz(top4_z);

    % for the values ingrated over z so they depends on y
    [sorted_Amp_z, sortedInds_Amp_z] = sort(Amp_z(:),'descend');
    top4_y = sortedInds_Amp_z(1:4); % position of the maxima
    top4_Amp_z =sorted_Amp_z(1:4); % value of the maxima
    ky_0 = ky(top4_y);

    %saving the values of the given kz and ky
    kz_0_i(in,:)=kz_0;
    ky_0_i(in,:)=ky_0;
    Amp_kz_0_i(in,:) = top4_Amp_y; % squared amplitud associated to the mode in kz
    Amp_ky_0_i(in,:) = top4_Amp_z; % squared amplitud associated to the mode in ky
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    % Get the position and value of the first k
    kz0_1 = 2*1*2*pi/Lz;    kz0_2 = 2*2*2*pi/Lz; % the extra 2 in front its to account for the negative positive interval
    kz0_3 = 2*3*2*pi/Lz;    kz0_4 = 2*4*2*pi/Lz;

    ky0_1 = 2*1*2*pi/Ly;    ky0_2 = 2*2*2*pi/Ly;
    ky0_3 = 2*3*2*pi/Ly;    ky0_4 = 2*4*2*pi/Ly;

    % Get the value for the first four modes in kz
    cond_1=(kz==kz0_1);
    Amp_y_1 = Amp_y.*cond_1;
    Amp_y_1 = sum(Amp_y_1)/sum(cond_1);

    cond_2=(kz==kz0_2);
    Amp_y_2 = Amp_y.*cond_2;
    Amp_y_2 = sum(Amp_y_2)/sum(cond_2);

    cond_3=(kz==kz0_3);
    Amp_y_3 = Amp_y.*cond_3;
    Amp_y_3 = sum(Amp_y_3)/sum(cond_3);

    cond_4=(kz==kz0_4);
    Amp_y_4 = Amp_y.*cond_4;
    Amp_y_4 = sum(Amp_y_4)/sum(cond_4);

    % Get the value for the first four modes in ky
    cond_1=(ky==ky0_1)';
    Amp_z_1 = Amp_z.*cond_1;
    Amp_z_1 = sum(Amp_z_1)/sum(cond_1);

    cond_2=(ky==ky0_2)';
    Amp_z_2 = Amp_z.*cond_2;
    Amp_z_2 = sum(Amp_z_2)/sum(cond_2);

    cond_3=(ky==ky0_3)';
    Amp_z_3 = Amp_z.*cond_3;
    Amp_z_3 = sum(Amp_z_3)/sum(cond_3);

    cond_4=(ky==ky0_4)';
    Amp_z_4 = Amp_z.*cond_4;
    Amp_z_4 = sum(Amp_z_4)/sum(cond_4);

    % Store the values
    Amp_ky_T_i(in,:) = [Amp_y_1; Amp_y_2; Amp_y_3; Amp_y_4];
    Amp_kz_T_i(in,:) = [Amp_z_1; Amp_z_2; Amp_z_3; Amp_z_4];
    %   %----------------------------------------------------------------------


    %----------------------------------------------------------------------
    %     %----------------------------------------------------------------------
    %     % Apply the condition of along Bz=0;
    %     A_cond=zeros(length(yll),length(zll));
    %     for kn=1:length(zll)
    %         bz_min = min(abs(Bz(:,kn)));
    %         A_cond(:,kn)=(Bz(:,kn)==bz_min);
    %     end
    %
    % %     epsi_1=0.001; %threshold
    % %     A1=(Bz<epsi_1); % find the regions where Bz=0
    % %     A_cond=A1;
    %
    %     Ax_y_bz0=A_cond.*Ax; % find the value of the reconnecting electric field
    %     %----------------------------------------------------------------------
    %
    %     %----------------------------------------------------------------------
    %     % Get the maximum and the minimum
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
    %     %----------------------------------------------------------------------
    %
    %     J_mag=sqrt(Jx.^2 + Jy.^2 + Jz.^2);
    %     J_mag_max_i=max(max(J_mag));
    %     J_mag_max(1,jn)=J_mag_max_i;
    %     %--------------------------------------------------------------------------
    %
    %
    %To see the contours of the vector potential and the value of the
    %reconneting electric field.
    x0=0;y0=0;
    width=1000;%size_X(2);
    height=350;%size_X(1);
    cd(path_s2) % just the vector potential
    %     %----------------------------------------------------------------------
    %     fs=18;
    %     f57=figure(57);
    %     set(gcf,'position',[x0,y0,0.9*width,height])
    %     h1=subplot(1,1,1);
    %     dum_p=-Ax; % there was a -Ax here
    %     lim_yp=max(max(max(abs(dum_p))));
    %     dum_p=dum_p/B0;%lim_yp;
    %     [C,h]=contourf(ZLL,YLL,dum_p,'LevelStep',0.5);
    %     set(h,'LineColor','black','LineWidth',1)
    %     colorbar
    %     %colormap(h1,flipud(jet));
    %     colormap(h1,jet);
    %     %set(hc1,'edgecolor','none')
    %     hcb=colorbar; hcb.Location = 'eastoutside';
    %     hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    %     %caxis([0 1]); % lange_all
    %     %hcb.Ruler.Exponent = -1;
    %     ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    %     ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    %     ax.YLabel.String = '$y / d_{i}$'; ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    %     ax.XLabel.String = '$z / d_{i}$';
    %     ax.XTick = [-30, -20,-10,10,20,30];
    %     ax.XLabel.Position = [0, -10];
    %     xlim([zll(1) zll(end)]); ylim([yll(1) yll(end)]);
    %     lgnd=legend([h1],'$\frac{A_{x}}{d_{i}B_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    %     %set(lgnd,'color','none');
    %     hold off
    %     %----------------------------------------------------------------------
    %     sgtitle('$$t = \ $$'+string(round((time_t/omega_pe_Omega_ce),2)) + ...
    %         '$$ \ \Omega_{ce}^{-1}$$','Interpreter','latex','FontSize',fs)
    %     %----------------------------------------------------------------------
    %     cd(path_rec_line)
    %     saveas(f57,strcat(num2str(time_t),'Ax_contour.png'));
    %     %----------------------------------------------------------------------

    %      %To see the contours of the vector potential and the value of the
    %      %reconneting electric field.
    %     cd(path_s2)
    %     %----------------------------------------------------------------------
    %     fs=18;
    %     f57=figure(57);
    %     h1=subplot(2,1,1);
    %     %hc=pcolor(ZLL,YLL,Ex);
    %     %set(hc,'edgecolor','none')
    %     %hold on
    %     dum_p=-Ax; % there was a -Ax here
    %     lim_yp=max(max(max(abs(dum_p))));
    %     dum_p=dum_p/lim_yp;
    %     [C,h]=contourf(ZLL,YLL,dum_p,'LevelStep',0.1);
    %     set(h,'LineColor','black','LineWidth',1)
    %     colorbar
    %     %colormap(h1,flipud(jet));
    %     colormap(h1,jet);
    %     %set(hc1,'edgecolor','none')
    %     hcb=colorbar; hcb.Location = 'eastoutside';
    %     hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    %     %hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ;
    % %     if lim_yp~=0
    % %     %caxis([0 lim_yp]);
    % %     caxis([0 7]);
    % %     end
    %     %caxis([0 7]); % this changes according to each case
    %     caxis([0 1]); % lange_all
    %     %hcb.Ruler.Exponent = -1;
    %     ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    %     ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    %     ax.YLabel.String = '$y / d_{i}$'; ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    %     ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    %     xlim([zll(1) zll(end)]); ylim([yll(1) yll(end)]);
    %     lgnd=legend([h1],'$\frac{A_{x}}{A_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    %     %set(lgnd,'color','none');
    %     hold off
    %     %----------------------------------------------------------------------
    %     h2=subplot(2,1,2);
    %     dum_p=Ex/E0;
    %     hc2 = pcolor(ZLL,YLL,dum_p);
    %     hold on
    %     set(hc2,'edgecolor','none')
    %     colorbar
    %     lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR);
    %     hcb=colorbar; hcb.Location = 'eastoutside';
    %     hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    %     %hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ;
    %     %if lim_yp~=0
    %     %caxis([-lim_yp lim_yp]);
    %     %end
    %     caxis([-0.7 0.7]);
    %     %hcb.Ruler.Exponent = -1;
    %     ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    %     ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    %     ax.YLabel.String = '$y / d_{i}$'; ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    %     ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    %     xlim([zll(1) zll(end)]); ylim([yll(1) yll(end)]);
    %     lgnd=legend([h2],'$\frac{E_{x}}{E_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    %     %set(lgnd,'color','none');
    %     hold off
    %     sgtitle('$$t = \ $$'+string(round((time_t/omega_pe_Omega_ce),2)) + ...
    %         '$$ \ \Omega_{ce}^{-1}$$','Interpreter','latex','FontSize',fs)
    %
    %     %----------------------------------------------------------------------
    %     cd(path_rec_line)
    %     saveas(f57,strcat(num2str(time_t),'Ax_Ex.png'));
    %     %----------------------------------------------------------------------
    %     %----------------------------------------------------------------------
    %     %----------------------------------------------------------------------

    cd(path)
end

% Making the plots for the modes
time_t_2_Omega=time_t_2./omega_pe_Omega_ce;
lambs_perp=Ly./(2*pi./ky_0_i(:,:));
lambs_par=Lz./(2*pi./kz_0_i(:,:));

width=1300;%size_X(2);
height=500;%size_X(1);
fs=18; x0=0;y0=0;
%--------------------------------------------------------------------------

% Include in this plots the substraction of Amp_ky_T_alone and Amp_kz_T_alone
%--------------------------------------------------------------------------
f86=figure(86);
set(gcf,'position',[x0,y0,500.0,500.0])
subplot(1,1,1)
semilogy(time_t_2_Omega,Amp_ky_T_i(:,1),'k','LineWidth',2)
hold on
semilogy(time_t_2_Omega,Amp_ky_T_i(:,2),'b','LineWidth',2)
semilogy(time_t_2_Omega,Amp_ky_T_i(:,3),'r','LineWidth',2)
semilogy(time_t_2_Omega,Amp_ky_T_i(:,4),'c','LineWidth',2)
set(gca,'FontSize',fs)
ax = gca;
ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
xlim([time_t_2_Omega(1) time_t_2_Omega(end)]);
ylim([0.5*10^(-3) ,10^(2)]);
xlabel('$t (\Omega_{ce}^{-1}) $','Interpreter','latex','FontSize',fs)
ylabel('$|A_{\lambda_{m}}|^{2}$','Interpreter','latex','FontSize',fs)
legend({'$\lambda_{1}$','$\lambda_{2}$','$\lambda_{3}$','$\lambda_{4}$' },...
    'Interpreter','latex','FontSize',fs,...
    'Location','northeast','NumColumns',4)
%title('$$y/d_{i}=$$'+string(yll(1,sli_y)),'Interpreter','latex','FontSize',fs)
hold off
% %--------------------------------------------------------------------------
cd(path_rec_line)
saveas(f86,'modes_growth_one_002.png');
% %--------------------------------------------------------------------------

nxx=15;
nyy=N_jn-nxx;
xx=time_t_2_Omega(1,nxx:nyy);
yy1=log(Amp_ky_T_i(nxx:nyy,1));
yy2=log(Amp_ky_T_i(nxx:nyy,2));
yy3=log(Amp_ky_T_i(nxx:nyy,3));
yy4=log(Amp_ky_T_i(nxx:nyy,4));

[p1,SS1] = polyfit(xx,yy1,1); 
[p2,SS2] = polyfit(xx,yy2,1); 
[p3,SS3] = polyfit(xx,yy3,1); 
[p4,SS4] = polyfit(xx,yy4,1); 

[fit_1,delta_1] = polyval(p1,xx,SS1); 
[fit_2,delta_2] = polyval(p2,xx,SS2); 
[fit_3,delta_3] = polyval(p3,xx,SS3); 
[fit_4,delta_4] = polyval(p4,xx,SS4); 

f44=figure(44);
plot(xx,yy1,'ok',xx,fit_1,'--k','LineWidth',2) 
hold on
plot(xx,yy2,'ob',xx,fit_2,'--b','LineWidth',2) 
plot(xx,yy3,'or',xx,fit_3,'--r','LineWidth',2) 
plot(xx,yy4,'oc',xx,fit_4,'--c','LineWidth',2) 
hold off
%legend('data','linear fit') 


pp=[p1;p2;p3;p4];
deltass=[delta_1;delta_2;delta_3;delta_4];


% % Include in this plots the substraction of Amp_ky_T_alone and Amp_kz_T_alone
% %--------------------------------------------------------------------------
% f86=figure(86);
% set(gcf,'position',[x0,y0,0.8*width,0.7*height])
% subplot(1,2,1)
% semilogy(time_t_2_Omega,Amp_ky_T_i(:,1),'k','LineWidth',2)
% hold on
% semilogy(time_t_2_Omega,Amp_ky_T_i(:,2),'b','LineWidth',2)
% semilogy(time_t_2_Omega,Amp_ky_T_i(:,3),'r','LineWidth',2)
% semilogy(time_t_2_Omega,Amp_ky_T_i(:,4),'c','LineWidth',2)
% set(gca,'FontSize',fs)
% ax = gca;
% ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
% ax.YLabel.Interpreter='latex';
% ax.FontSize=fs;
% xlim([time_t_2_Omega(1) time_t_2_Omega(end)]);
% ylim([0.5*10^(-2) ,10^(2)]);
% xlabel('$t (\Omega_{ce}^{-1}) $','Interpreter','latex','FontSize',fs)
% ylabel('$|A_{\lambda_{m},\perp}|^{2}$','Interpreter','latex','FontSize',fs)
% legend({'$\lambda_{1}$','$\lambda_{2}$','$\lambda_{3}$','$\lambda_{4}$' },...
%     'Interpreter','latex','FontSize',fs,...
%     'Location','northeast','NumColumns',4)
% %title('$$y/d_{i}=$$'+string(yll(1,sli_y)),'Interpreter','latex','FontSize',fs)
% hold off
% % %--------------------------------------------------------------------------
% subplot(1,2,2)
% semilogy(time_t_2_Omega,Amp_kz_T_i(:,1),'k','LineWidth',2)
% hold on
% semilogy(time_t_2_Omega,Amp_kz_T_i(:,2),'b','LineWidth',2)
% semilogy(time_t_2_Omega,Amp_kz_T_i(:,3),'r','LineWidth',2)
% semilogy(time_t_2_Omega,Amp_kz_T_i(:,4),'c','LineWidth',2)
% set(gca,'FontSize',fs)
% ax = gca;
% ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
% ax.YLabel.Interpreter='latex';
% ax.FontSize=fs;
% xlim([time_t_2_Omega(1) time_t_2_Omega(end)]);
% ylim([0.5*10^(-2) ,10^(2)]);
% xlabel('$t (\Omega_{ce}^{-1}) $','Interpreter','latex','FontSize',fs)
% ylabel('$|A_{\lambda_{m},\|}|^{2}$','Interpreter','latex','FontSize',fs)
% legend({'$\lambda_{1}$','$\lambda_{2}$','$\lambda_{3}$','$\lambda_{4}$' },...
%     'Interpreter','latex','FontSize',fs,...
%     'Location','northeast','NumColumns',4)
% %title('$$y/d_{i}=$$'+string(yll(1,sli_y)),'Interpreter','latex','FontSize',fs)
% hold off
%--------------------------------------------------------------------------


% Save the plots
%--------------------------------------------------------------------------
% cd(path_rec_line)
% saveas(f86,'modes_growth.png');
%saveas(f87,'max_four_modes.png');
%--------------------------------------------------------------------------

%making the stack plot
%--------------------------------------------------------------------------
fs=18; % here I am actually plotting -Ax because I changed its sign to get the magnetic field components
[ZLT,OMT]=meshgrid(zll,time_t_2_Omega);
cd(path_s2)
f34=figure(34)
%set(gcf,'position',[x0,y0,0.9*width,height]) % there is a problem with the
%size of the font when using this
h1=subplot(1,1,1);
dum_p=-inte_Ax_i'/B0;%/max(max(abs(inte_Ax_i)));
hc = pcolor(ZLT,OMT,dum_p);
hold on
set(hc,'edgecolor','none')
%colorbar; colormap(h1,flipud(turbo))
colorbar; colormap(h1,turbo)
lim_yp=max(max(max(abs(dum_p))));
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
ax.YLabel.String = '$t / \Omega_{e}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
xlim([zll(1) zll(end)]); ylim([time_t_2_Omega(1) time_t_2_Omega(end)]);
lgnd=legend([h1],'$\frac{A_{x}}{d_{i}B_{0}} $','Interpreter','latex','FontSize',1.3*fs);
hold off
cd(path_rec_line)
saveas(f34,strcat(num2str(time_t),'Ax_stack_002_no_harris.png'));
% %--------------------------------------------------------------------------

function f = fcoeffunction(location,state)
%Nr = 1; % Number of equations
%nr = length(location.z); % Number of columns
f = state.u;%zeros(Nr,nr); % Allocate f
end

function [P1Dper,P1Dpar]=Compute1DSpectra(P2D,kper,threshold)
%Calculate parallel and perpendicular 1D sepctra from the 2D spectrum.
[c,index]=min(abs(kper-threshold)); %Cut spectrum above a threshold k
Pthres=P2D(2,index);
mask2D=P2D>Pthres;
fieldMASKED=P2D.*mask2D;
P1Dper=sum(fieldMASKED,1); %Sum over parallel k
P1Dpar=sum(fieldMASKED,2); %Sum over perpendicular k
end