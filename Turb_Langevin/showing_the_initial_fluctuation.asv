% this script is to keep a simple file to make plots showing the initial
% fluctuations 

path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kLd1_local';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L8di_dB01_Omc1_kLd1_local_2';

%--------------------------------------------------------------------------
path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
%--------------------------------------------------------------------------

% To save the plots
path_rec_r = strcat(path,'/spectra/rec_r');
path_rec_line = strcat(path,'/spectra/rec_line');
path_rec_line_ByBzJx_zoom = strcat(path,'/spectra/rec_line/ByBzJx_zoom');
if not(isfolder(path_rec_r))
    mkdir(path_rec_r)
end
if not(isfolder(path_rec_line))
    mkdir(path_rec_line)
end
if not(isfolder(path_rec_line_ByBzJx_zoom))
    mkdir(path_rec_line_ByBzJx_zoom)
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
c=1; VA2c = 0.2;
%B0 = VA2c; E0 = B0*VA2c;
%Pi0 = mi*VA2c*VA2c; Pe0 = me*VA2c*VA2c;
%DeltaEpsilon0=VA2c*Pi0;
%DeltaEpsilon0=Pi0;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
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
in=1;
fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;
B=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
ss=size(B);
LZs=ss(3);
clearvars B
%N=183;
jn=N;
in=jn;
N_jn=N; %This is to store some but not all the time steps
%N=61;N_jn=61; &lt;------------------------------- this is for the 3000


time_t_2=zeros(1,N_jn);


jn=N-1; % for prt central pinch

for jn=1:N-1
    in=jn;
    %----------------------------------------------------------------------
    disp(strcat('Computing step ...',S(in).name))
    fileID =  S(in).name; 
    fileID2 = S(in+1).name;
    %h5disp(fileID);
    info = h5info(fileID);      EHJ_1st = info.Groups(16).Name;
    info2 = h5info(fileID2);    EHJ_1st2 = info2.Groups(16).Name;    
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
    %----------------------------------------------------------------------
    B1{1,1}=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    B1{1,2}=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
    B1{1,3}=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));
    J1{1,1}=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'));
    %----------------------------------------------------------------------
    B2{1,1}=h5read(fileID2,strcat(EHJ_1st2,'/hx_fc/p0/3d'));
    B2{1,2}=h5read(fileID2,strcat(EHJ_1st2,'/hy_fc/p0/3d'));
    B2{1,3}=h5read(fileID2,strcat(EHJ_1st2,'/hz_fc/p0/3d'));
    J2{1,1}=h5read(fileID2,strcat(EHJ_1st2,'/jx_ec/p0/3d'));
    %----------------------------------------------------------------------

    %From 3D to 2D (x,y,z) to (y,z)
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    % slice in x
    ssz=size(B1{1,1});
    sli_x = 1; % this value has to change to reconstruct the vector potential
    sli_y = floor(4+ssz(2)/2);%380;
    sli_z = floor(2+ssz(3)/2);%700;
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    B1x = B1{1,1}; B1x = squeeze(B1x(sli_x,:,:));
    B1y = B1{1,2}; B1y = squeeze(B1y(sli_x,:,:));
    B1z = B1{1,3}; B1z = squeeze(B1z(sli_x,:,:));
    J1x = J1{1,1}; J1x = squeeze(J1x(sli_x,:,:));
    
    B2x = B2{1,1}; B2x = squeeze(B2x(sli_x,:,:));
    B2y = B2{1,2}; B2y = squeeze(B2y(sli_x,:,:));
    B2z = B2{1,3}; B2z = squeeze(B2z(sli_x,:,:));
    J2x = J2{1,1}; J2x = squeeze(J2x(sli_x,:,:));

    %----------------------------------------------------------------------
    sss=size(B1x);
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
    Iapprox = zeros(size(B1y));
    Iapprox_i=0;
    %integral over y
    for i=1:ny-1
        Iapprox_i = Iapprox_i + dy*B1z(i,:);
        Iapprox(i,:)=Iapprox_i;
    end
    Ax_y=Iapprox; %&lt;------- This is the correct Ax
    Ax_y=-Ax_y;
    %----------------------------------------------------------------------
    %--------------------------------------------------------------------------
    str = string(S(in).name);
    newStr = extractBetween(str,"pfd.","_p000000.h5");
    N_steps = str2double(newStr);
    time_t = dt*N_steps;
    time_t_2_Omega=time_t./omega_pe_Omega_ce;
    time_t_2(1,in)=time_t_2_Omega;
    %disp(time_t_2_Omega)
    yticks_mine=[floor(-Ly*0.9) floor(-Ly/2) 0 floor(Ly/2) floor(Ly*0.9)];
    zticks_mine=[floor(-Lz*0.9) floor(-Lz/2) 0 floor(Lz/2) floor(Lz*0.9)];
    %----------------------------------------------------------------------
    
    % to plot closer
    aa=1/4;
     
    %This plot shows the close-up with the squares to show the particle
    %info regions
    cd(path_s2)
    %----------------------------------------------------------------------
    fs=18;
    x0=45;y0=54;xx1=810;yy1=173;
    %----------------------------------------------------------------------

    cd(path_s2)
    %----------------------------------------------------------------------
    x0=45;y0=54;xx1=810;yy1=710;
    f57=figure();
    set(gcf,'Visible', 'off'); 
    set(gcf,'position',[x0,y0,xx1,yy1])
    %----------------------------------------------------------------------
    h1=subplot(3,1,1);
    dum_p2=(B2y-B1y)./B0;
    %dum_p2=By/max(max(abs(By)));
    lim_yp2=max(max(max(abs(dum_p2))));
    %dum_p2=dum_p2/lim_yp2;
    hc=pcolor(ZLL,YLL,dum_p2);
    set(hc,'edgecolor','none')
    hold on
    %----------------------------------------------------------------------
    dum_p=Ax_y;
    lim_yp=max(max(max(abs(dum_p))));
    dum_p=dum_p/lim_yp;
    [C,h]=contour(ZLL,YLL,dum_p,'LevelStep',0.1);
    set(h,'LineColor','black','LineWidth',1)
    %----------------------------------------------------------------------
    colorbar; colormap(h1,BWR);
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    caxis([-0.1 0.1]); % lange_all
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    zlen=length(zll); Dz=floor(aa*zlen); ylen=length(yll); Dy=floor(aa*ylen);
    xlim([zll(1 ) zll(end )]);
    ylim([yll(1 + Dy) yll(end - Dy)]);
    %length_yl=yll(end) - yll(1); ylim([-length_yl/4 length_yl/4]);
    lgnd=legend([h1],'$\frac{B_{y,2} - B_{y,1}}{B_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    %set(lgnd,'color','none');
    hold off
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    h2=subplot(3,1,2);
    dum_p2=(B2z - B1z)./B0;
    %dum_p2=Bz/max(max(abs(Bz)));
    lim_yp2=max(max(max(abs(dum_p2))));
    %dum_p2=dum_p2/lim_yp2;
    hc=pcolor(ZLL,YLL,dum_p2);
    set(hc,'edgecolor','none')
    hold on
    %----------------------------------------------------------------------
    dum_p=Ax_y;
    lim_yp=max(max(max(abs(dum_p))));
    dum_p=dum_p/lim_yp;
    [C,h]=contour(ZLL,YLL,dum_p,'LevelStep',0.1);
    set(h,'LineColor','black','LineWidth',1)
    %----------------------------------------------------------------------
    colorbar; colormap(h2,BWR);
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    caxis([-0.1 0.1]); % lange_all
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    zlen=length(zll); Dz=floor(aa*zlen); ylen=length(yll); Dy=floor(aa*ylen);
    xlim([zll(1 ) zll(end )]);
    ylim([yll(1 + Dy) yll(end - Dy)]);
    %length_yl=yll(end) - yll(1); ylim([-length_yl/4 length_yl/4]);
    lgnd=legend([h2],'$\frac{B_{z,2} - B_{z,1}}{B_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    %set(lgnd,'color','none');
    hold off
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    h3=subplot(3,1,3);
    %f1=figure(1)
    %h3=subplot(1,1,1);
    dum_p2=(J2x-J1x)./J0;
    %dum_p2=Jx/max(max(abs(Jx)));
    lim_yp2=max(max(max(abs(dum_p2))));
    %dum_p2=dum_p2/lim_yp2;
    hc=pcolor(ZLL,YLL,dum_p2);
    set(hc,'edgecolor','none')
    hold on
    %----------------------------------------------------------------------
    dum_p=Ax_y;
    lim_yp=max(max(max(abs(dum_p))));
    dum_p=dum_p/lim_yp;
    [C,h]=contour(ZLL,YLL,dum_p,'LevelStep',0.1);
    set(h,'LineColor','black','LineWidth',1)
    %----------------------------------------------------------------------
    colorbar; colormap(h3,BWR);
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    caxis([-0.1 0.1]); % lange_all
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    
    zlen=length(zll); Dz=floor(aa*zlen); ylen=length(yll); Dy=floor(aa*ylen);
    xlim([zll(1 ) zll(end )]);
    ylim([yll(1 + Dy) yll(end - Dy)]);

    %length_yl=yll(end) - yll(1); ylim([-length_yl/4 length_yl/4]);
    lgnd=legend([h3],'$\frac{J_{x,2} - J_{x,1}}{J_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    %set(lgnd,'color','none');
    %rectangle('Position',[-10 10 20 20],'EdgeColor','b','LineWidth',2)
    %rectangle('Position',[-10 -5 20 5],'EdgeColor','r','LineWidth',2)
    hold off
    %----------------------------------------------------------------------
    sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
    
    %----------------------------------------------------------------------
    cd(path_rec_line_ByBzJx_zoom)
    saveas(f57,strcat(num2str(time_t),'DeltaByBzJx_zoom.png'));
    close(f57);
    delete(f57);
    %----------------------------------------------------------------------
    cd(path)


end


