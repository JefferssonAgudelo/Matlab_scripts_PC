% This is to check the evolution of the energy terms

%--------------------------------------------------------------------------
path_1 = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large';
%path_1 = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_cpinch_sSR/checkin_energy';
%path_2 = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_cpinch_sSR_lange/checkin_energy';

%--------------------------------------------------------------------------
path=path_1;
%--------------------------------------------------------------------------
% To save the plots
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
% This file still requires to check the normalization 
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
N_jn=N; %This is to store some but not all the time steps
%--------------------------------------------------------------------------

% allocate space for the energies
%--------------------------------------------------------------------------
U_em_mean=zeros(1,N_jn); % electromagnetic energy density
U_em_std=zeros(1,N_jn);

time_t_2=zeros(1,N_jn);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
JN=106;
dab = 3;
j_a = JN - dab;
j_b = JN + dab;
j_a_b = j_b - j_a;

%--------------------------------------------------------------------------    
E_in = cell(3,j_a_b);
B_in = cell(3,j_a_b);
J_in = cell(3,j_a_b);
n_in = cell(2,j_a_b);
v_i_in = cell(3,j_a_b);
v_e_in = cell(3,j_a_b);
v_in = cell(3,j_a_b);
Pij_i_in = cell(6,j_a_b);
Pij_e_in = cell(6,j_a_b);
%--------------------------------------------------------------------------    

Ax_y_short_i = zeros(1,N);
ve_x_short_i = zeros(1,N);

%106 <--
jn=106;
%for jn=j_a:j_b
for jn=1:N
    in=jn;
    %for jn=2:floor(N/10)
    %    in=(jn-1)*jn;
% %     in=2 + floor(N*(jn-1)/10);
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

    %--------------------------------------------------------------------------
    str = string(S(in).name);
    newStr = extractBetween(str,"pfd.","_p000000.h5");
    N_steps = str2double(newStr);
    time_t = dt*N_steps;
    time_t_2_Omega=time_t./omega_pe_Omega_ce;
    time_t_2(1,in)=time_t_2_Omega;
    %--------------------------------------------------------------------------

    %----------------------------------------------------------------------
    disp(strcat('Computing step ...',S2(in).name))    
    fileID2 =  S2(in).name; %change the 1 per i
    %h5disp(fileID2);
    info2 = h5info(fileID2);
    moments_1st = info2.Groups(1).Name;
    %----------------------------------------------------------------------
    
    %----------------------------------------------------------------------        
    B{1,1}=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    B{1,2}=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
    B{1,3}=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));
    
    E{1,1}=h5read(fileID,strcat(EHJ_1st,'/ex_ec/p0/3d'));
    E{1,2}=h5read(fileID,strcat(EHJ_1st,'/ey_ec/p0/3d'));
    E{1,3}=h5read(fileID,strcat(EHJ_1st,'/ez_ec/p0/3d'));

    % This needs to be changed including the background 
    J_up{1,1}=h5read(fileID2,strcat(moments_1st,'/jx_e_UP/p0/3d'));
    J_up{1,2}=h5read(fileID2,strcat(moments_1st,'/jy_e_UP/p0/3d'));
    J_up{1,3}=h5read(fileID2,strcat(moments_1st,'/jz_e_UP/p0/3d'));

    J_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/jx_e_BA/p0/3d'));
    J_ba{1,2}=h5read(fileID2,strcat(moments_1st,'/jy_e_BA/p0/3d'));
    J_ba{1,3}=h5read(fileID2,strcat(moments_1st,'/jz_e_BA/p0/3d'));

    J{1,1}=(J_up{1,1}+J_ba{1,1})./1; 
    J{1,2}=(J_up{1,2}+J_ba{1,2})./1; 
    J{1,3}=(J_up{1,3}+J_ba{1,3})./1; 

    clearvars J_ba J_up

    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    ssz=size(B{1,1});
    sli_x = 1; %floor(4+ssz(1)/2);%1;
    sli_y = 512; %floor(4+ssz(2)/2);%380;
    sli_z = 904; %floor(2+ssz(3)/2);%700;
    %----------------------------------------------------------------------

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

    clearvars E B J
    %---------------------------------------------------------------------


    % Loading the data for the bulk speed of the particles
    %----------------------------------------------------------------------    
    p_e_up{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e_UP/p0/3d')); 
    p_e_up{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e_UP/p0/3d'));
    p_e_up{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e_UP/p0/3d'));
    
    p_i_up{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i_UP/p0/3d'));
    p_i_up{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i_UP/p0/3d'));
    p_i_up{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i_UP/p0/3d'));

    p_e_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e_BA/p0/3d')); 
    p_e_ba{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e_BA/p0/3d'));
    p_e_ba{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e_BA/p0/3d'));
    
    p_i_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i_BA/p0/3d'));
    p_i_ba{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i_BA/p0/3d'));
    p_i_ba{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i_BA/p0/3d'));

    p_e{1,1}=(p_e_up{1,1}+p_e_ba{1,1})./1; 
    p_e{1,2}=(p_e_up{1,2}+p_e_ba{1,2})./1; 
    p_e{1,3}=(p_e_up{1,3}+p_e_ba{1,3})./1; 

    p_i{1,1}=(p_i_up{1,1}+p_i_ba{1,1})./1; 
    p_i{1,2}=(p_i_up{1,2}+p_i_ba{1,2})./1; 
    p_i{1,3}=(p_i_up{1,3}+p_i_ba{1,3})./1; 

    %clearvars p_i_up p_e_up p_i_ba p_e_ba
    %----------------------------------------------------------------------

    % computing the velocities in units of c
    %----------------------------------------------------------------------
    v_e=cell(1,3);
    v_i=cell(1,3);
    v_e_ba=cell(1,3);
    v_i_ba=cell(1,3);
    v_e_up=cell(1,3);
    v_i_up=cell(1,3);

    for i=1:3
        v_e{1,i} = p_e{1,i} * c ./ sqrt(c^2 * me^2 + p_e{1,i}.^2);
        v_i{1,i} = p_i{1,i} * c ./ sqrt(c^2 * mi^2 + p_i{1,i}.^2);
        v_e_up{1,i} = p_e_up{1,i} * c ./ sqrt(c^2 * me^2 + p_e_up{1,i}.^2);
        v_i_up{1,i} = p_i_up{1,i} * c ./ sqrt(c^2 * mi^2 + p_i_up{1,i}.^2);
        v_e_ba{1,i} = p_e_ba{1,i} * c ./ sqrt(c^2 * me^2 + p_e_ba{1,i}.^2);
        v_i_ba{1,i} = p_i_ba{1,i} * c ./ sqrt(c^2 * mi^2 + p_i_ba{1,i}.^2);
    end

    clearvars p_i p_e p_i_up p_e_up p_i_ba p_e_ba
    %---------------------------------------------------------------------- 


    %----------------------------------------------------------------------
    v_ex = v_e{1,1}; v_ex = squeeze(v_ex(sli_x,:,:));
    v_ey = v_e{1,2}; v_ey = squeeze(v_ey(sli_x,:,:));
    v_ez = v_e{1,3}; v_ez = squeeze(v_ez(sli_x,:,:));
    
    v_e_upx = v_e_up{1,1}; v_e_upx = squeeze(v_e_upx(sli_x,:,:));
    v_e_upy = v_e_up{1,2}; v_e_upy = squeeze(v_e_upy(sli_x,:,:));
    v_e_upz = v_e_up{1,3}; v_e_upz = squeeze(v_e_upz(sli_x,:,:));

    v_e_bax = v_e_ba{1,1}; v_e_bax = squeeze(v_e_bax(sli_x,:,:));
    v_e_bay = v_e_ba{1,2}; v_e_bay = squeeze(v_e_bay(sli_x,:,:));
    v_e_baz = v_e_ba{1,3}; v_e_baz = squeeze(v_e_baz(sli_x,:,:));
    
    v_ix = v_i{1,1}; v_ix = squeeze(v_ix(sli_x,:,:));
    v_iy = v_i{1,2}; v_iy = squeeze(v_iy(sli_x,:,:));
    v_iz = v_i{1,3}; v_iz = squeeze(v_iz(sli_x,:,:));
    
    v_i_upx = v_i_up{1,1}; v_i_upx = squeeze(v_i_upx(sli_x,:,:));
    v_i_upy = v_i_up{1,2}; v_i_upy = squeeze(v_i_upy(sli_x,:,:));
    v_i_upz = v_i_up{1,3}; v_i_upz = squeeze(v_i_upz(sli_x,:,:));

    v_i_bax = v_i_ba{1,1}; v_i_bax = squeeze(v_i_bax(sli_x,:,:));
    v_i_bay = v_i_ba{1,2}; v_i_bay = squeeze(v_i_bay(sli_x,:,:));
    v_i_baz = v_i_ba{1,3}; v_i_baz = squeeze(v_i_baz(sli_x,:,:));

    clearvars v_i v_e v_i_up v_e_up v_i_ba v_e_ba 
    %---------------------------------------------------------------------


    % to get the vector potential
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
    Ax_y=Iapprox; %&lt;------- This is the correct Ax
    Ax_y=-Ax_y;
    %----------------------------------------------------------------------
 

    % Important to localise near the x-line
    %----------------------------------------------------------------------
    ay_a = 496 ;    ay_b = 530 ;
    az_a = 488 ;    az_b = 540 ;

    Ax_y_short_i(1,in) = abs(mean(Ax_y(ay_a:ay_b,az_a:az_b),"all"));
    ve_x_short_i(1,in) = abs(mean(v_ex(ay_a:ay_b,az_a:az_b),"all"));
   %-----------------------------------------------------------------------

   f1=figure(1)
   plot(Ax_y_short_i/100,'r')
   hold on
   plot(ve_x_short_i,'b')
   xlim([0 110])
   hold off
   %-----------------------------------------------------------------------  


% %    %----------------------------------------------------------------------   
% %     f1=figure(1);
% %     %hc=pcolor(ZLL, YLL,Ax_y);
% %     %hc=pcolor(Ax_y_short);
% %     hc=pcolor(ve_x_short);
% %     set(hc,'edgecolor','none')
% %     colorbar; caxis([-0.09 0.09])
% % 
% %     xlim_a = zll(704); xlim_b = zll(1104);
% %     ylim_a = yll(391); ylim_b = yll(591);
% %     ylim_a = yll(488); ylim_b = yll(541);
% %     %xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
% %     %----------------------------------------------------------------------

% %     %----------------------------------------------------------------------
% %     str = string(S(in).name);
% %     newStr = extractBetween(str,"pfd.","_p000000.h5");
% %     N_steps = str2double(newStr);
% %     time_t = dt*N_steps;
% %     time_t_2_Omega=time_t./omega_pe_Omega_ce;
% %     time_t_2(1,in)=time_t_2_Omega;
% %     %----------------------------------------------------------------------
% % 
% %     
% %     % densities
% %     %----------------------------------------------------------------------
% %     n_e_up{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_e_UP/p0/3d'));
% %     n_i_up{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_i_UP/p0/3d'));
% %     n_e_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_e_BA/p0/3d'));
% %     n_i_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_i_BA/p0/3d'));
% %     n_e_up{1,1}=-1.*n_e_up{1,1};
% %     n_e_ba{1,1}=-1.*n_e_ba{1,1};
% % 
% %     n_e{1,1}=(n_e_up{1,1} + n_e_ba{1,1})./1;
% %     n_i{1,1}=(n_i_up{1,1} + n_i_ba{1,1})./1;
% %     n_e{1,1}=-1.*n_e{1,1};
% %     %----------------------------------------------------------------------
% % 
% % 
% %     %----------------------------------------------------------------------
% %     Txx_e_up=h5read(fileID2,strcat(moments_1st,'/txx_e_UP/p0/3d')); 
% %     Tyy_e_up=h5read(fileID2,strcat(moments_1st,'/tyy_e_UP/p0/3d'));
% %     Tzz_e_up=h5read(fileID2,strcat(moments_1st,'/tzz_e_UP/p0/3d'));
% %     Txy_e_up=h5read(fileID2,strcat(moments_1st,'/txy_e_UP/p0/3d')); 
% %     Txz_e_up=h5read(fileID2,strcat(moments_1st,'/tzx_e_UP/p0/3d'));
% %     Tyz_e_up=h5read(fileID2,strcat(moments_1st,'/tyz_e_UP/p0/3d'));
% % 
% %     Txx_e_ba=h5read(fileID2,strcat(moments_1st,'/txx_e_BA/p0/3d')); 
% %     Tyy_e_ba=h5read(fileID2,strcat(moments_1st,'/tyy_e_BA/p0/3d'));
% %     Tzz_e_ba=h5read(fileID2,strcat(moments_1st,'/tzz_e_BA/p0/3d'));
% %     Txy_e_ba=h5read(fileID2,strcat(moments_1st,'/txy_e_BA/p0/3d')); 
% %     Txz_e_ba=h5read(fileID2,strcat(moments_1st,'/tzx_e_BA/p0/3d'));
% %     Tyz_e_ba=h5read(fileID2,strcat(moments_1st,'/tyz_e_BA/p0/3d'));
% % 
% %     Txx_e=(Txx_e_up + Txx_e_ba)./1; 
% %     Tyy_e=(Tyy_e_up + Tyy_e_ba)./1;
% %     Tzz_e=(Tzz_e_up + Tzz_e_ba)./1;
% %     Txy_e=(Txy_e_up + Txy_e_ba)./1;
% %     Txz_e=(Txz_e_up + Txz_e_ba)./1;
% %     Tyz_e=(Tyz_e_up + Tyz_e_ba)./1;
% % 
% %     %clearvars Txx_e_ba Txx_e_up Tyy_e_ba Tyy_e_up Tzz_e_ba Tzz_e_up
% %     %clearvars Txy_e_ba Txy_e_up Txz_e_ba Txz_e_up Tyz_e_ba Tyz_e_up
% % 
% %     Txx_i_up=h5read(fileID2,strcat(moments_1st,'/txx_i_UP/p0/3d')); 
% %     Tyy_i_up=h5read(fileID2,strcat(moments_1st,'/tyy_i_UP/p0/3d'));
% %     Tzz_i_up=h5read(fileID2,strcat(moments_1st,'/tzz_i_UP/p0/3d'));
% %     Txy_i_up=h5read(fileID2,strcat(moments_1st,'/txy_i_UP/p0/3d')); 
% %     Txz_i_up=h5read(fileID2,strcat(moments_1st,'/tzx_i_UP/p0/3d'));
% %     Tyz_i_up=h5read(fileID2,strcat(moments_1st,'/tyz_i_UP/p0/3d'));
% % 
% %     Txx_i_ba=h5read(fileID2,strcat(moments_1st,'/txx_i_BA/p0/3d')); 
% %     Tyy_i_ba=h5read(fileID2,strcat(moments_1st,'/tyy_i_BA/p0/3d'));
% %     Tzz_i_ba=h5read(fileID2,strcat(moments_1st,'/tzz_i_BA/p0/3d'));
% %     Txy_i_ba=h5read(fileID2,strcat(moments_1st,'/txy_i_BA/p0/3d')); 
% %     Txz_i_ba=h5read(fileID2,strcat(moments_1st,'/tzx_i_BA/p0/3d'));
% %     Tyz_i_ba=h5read(fileID2,strcat(moments_1st,'/tyz_i_BA/p0/3d'));
% % 
% %     Txx_i=(Txx_i_up + Txx_i_ba)./1; 
% %     Tyy_i=(Tyy_i_up + Tyy_i_ba)./1;
% %     Tzz_i=(Tzz_i_up + Tzz_i_ba)./1;
% %     Txy_i=(Txy_i_up + Txy_i_ba)./1;
% %     Txz_i=(Txz_i_up + Txz_i_ba)./1;
% %     Tyz_i=(Tyz_i_up + Tyz_i_ba)./1;
% % 
% %     %----------------------------------------------------------------------  
% %     Pij_i=cell(3,3);
% %     Pij_e=cell(3,3);
% %     Pij_i_ba=cell(3,3);
% %     Pij_e_ba=cell(3,3);
% %     Pij_i_up=cell(3,3);
% %     Pij_e_up=cell(3,3);
% %     %--------------------------------------------------------------------------
% %     % Make the tensor [3, 3] for the ions
% %     Pij_i{1,1}=Txx_i; Pij_i{1,2}=Txy_i; Pij_i{1,3}=Txz_i;
% %     Pij_i{2,1}=Txy_i; Pij_i{2,2}=Tyy_i; Pij_i{2,3}=Tyz_i;
% %     Pij_i{3,1}=Txz_i; Pij_i{3,2}=Tyz_i; Pij_i{3,3}=Tzz_i;
% %     clearvars Txx_i Txy_i Txz_i Tyy_i Tyz_i Tzz_i
% %     % Make the tensor [3, 3] for the electrons
% %     Pij_e{1,1}=Txx_e; Pij_e{1,2}=Txy_e; Pij_e{1,3}=Txz_e;
% %     Pij_e{2,1}=Txy_e; Pij_e{2,2}=Tyy_e; Pij_e{2,3}=Tyz_e;
% %     Pij_e{3,1}=Txz_e; Pij_e{3,2}=Tyz_e; Pij_e{3,3}=Tzz_e;
% %     clearvars Txx_e Txy_e Txz_e Tyy_e Tyz_e Tzz_e
% %     %----------------------------------------------------------------------
% %     % Make the tensor [3, 3] for the ions
% %     Pij_i_ba{1,1}=Txx_i_ba; Pij_i_ba{1,2}=Txy_i_ba; Pij_i_ba{1,3}=Txz_i_ba;
% %     Pij_i_ba{2,1}=Txy_i_ba; Pij_i_ba{2,2}=Tyy_i_ba; Pij_i_ba{2,3}=Tyz_i_ba;
% %     Pij_i_ba{3,1}=Txz_i_ba; Pij_i_ba{3,2}=Tyz_i_ba; Pij_i_ba{3,3}=Tzz_i_ba;
% %     clearvars Txx_i_ba Txy_i_ba Txz_i_ba Tyy_i_ba Tyz_i_ba Tzz_i_ba
% %     % Make the tensor [3, 3] for the electrons
% %     Pij_e_ba{1,1}=Txx_e_ba; Pij_e_ba{1,2}=Txy_e_ba; Pij_e_ba{1,3}=Txz_e_ba;
% %     Pij_e_ba{2,1}=Txy_e_ba; Pij_e_ba{2,2}=Tyy_e_ba; Pij_e_ba{2,3}=Tyz_e_ba;
% %     Pij_e_ba{3,1}=Txz_e_ba; Pij_e_ba{3,2}=Tyz_e_ba; Pij_e_ba{3,3}=Tzz_e_ba;
% %     clearvars Txx_e_ba Txy_e_ba Txz_e_ba Tyy_e_ba Tyz_e_ba Tzz_e_ba
% %     %----------------------------------------------------------------------
% %     % Make the tensor [3, 3] for the ions
% %     Pij_i_up{1,1}=Txx_i_up; Pij_i_up{1,2}=Txy_i_up; Pij_i_up{1,3}=Txz_i_up;
% %     Pij_i_up{2,1}=Txy_i_up; Pij_i_up{2,2}=Tyy_i_up; Pij_i_up{2,3}=Tyz_i_up;
% %     Pij_i_up{3,1}=Txz_i_up; Pij_i_up{3,2}=Tyz_i_up; Pij_i_up{3,3}=Tzz_i_up;
% %     clearvars Txx_i_up Txy_i_up Txz_i_up Tyy_i_up Tyz_i_up Tzz_i_up
% %     % Make the tensor [3, 3] for the electrons
% %     Pij_e_up{1,1}=Txx_e_up; Pij_e_up{1,2}=Txy_e_up; Pij_e_up{1,3}=Txz_e_up;
% %     Pij_e_up{2,1}=Txy_e_up; Pij_e_up{2,2}=Tyy_e_up; Pij_e_up{2,3}=Tyz_e_up;
% %     Pij_e_up{3,1}=Txz_e_up; Pij_e_up{3,2}=Tyz_e_up; Pij_e_up{3,3}=Tzz_e_up;
% %     clearvars Txx_e_up Txy_e_up Txz_e_up Tyy_e_up Tyz_e_up Tzz_e_up
% %     %----------------------------------------------------------------------
% %     % This is to get the central momment pressure.
% %     %----------------------------------------------------------------------
% %     PPij_i=cell(3,3);
% %     PPij_e=cell(3,3);
% %     PPij_i_ba=cell(3,3);
% %     PPij_e_ba=cell(3,3);
% %     PPij_i_up=cell(3,3);
% %     PPij_e_up=cell(3,3);
% %     for i=1:3
% %         for j=1:3
% %             if(isempty(Pij_i{i,j}) == 1)
% %                 continue
% %             end
% %             PPij_i{i,j} = Pij_i{i,j} - n_i{1,1}.*mi.*v_i{1,i}.*v_i{1,j};
% %             PPij_e{i,j} = Pij_e{i,j} - n_e{1,1}.*me.*v_e{1,i}.*v_e{1,j};
% % %             PPij_i_ba{i,j} = Pij_i_ba{i,j} - n_i_ba{1,1}.*mi.*v_i_ba{1,i}.*v_i_ba{1,j};
% % %             PPij_e_ba{i,j} = Pij_e_ba{i,j} - n_e_ba{1,1}.*me.*v_e_ba{1,i}.*v_e_ba{1,j};
% % %             PPij_i_up{i,j} = Pij_i_up{i,j} - n_i_up{1,1}.*mi.*v_i_up{1,i}.*v_i_up{1,j};
% % %             PPij_e_up{i,j} = Pij_e_up{i,j} - n_e_up{1,1}.*me.*v_e_up{1,i}.*v_e_up{1,j};
% %         end
% %     end
% % 
% %     % This is just to rename the variable
% %     Pij_i = PPij_i;
% %     Pij_e = PPij_e;
% % %     Pij_i_ba = PPij_i_ba;
% % %     Pij_e_ba = PPij_e_ba;
% % %     Pij_i_up = PPij_i_up;
% % %     Pij_e_up = PPij_e_up;
% % 
% %     clearvars PPij_i PPij_e  
% % %     clearvars PPij_e_ba PPij_e_up PPij_i_ba PPij_i_up
% %     %----------------------------------------------------------------------
% % 
% % 
% %     %----------------------------------------------------------------------
% %     n_i = n_i{1,1}; n_i = squeeze(n_i(sli_x,:,:));
% %     n_e = n_e{1,1}; n_e = squeeze(n_e(sli_x,:,:));
% % %     n_i_ba = n_i_ba{1,1}; n_i_ba = squeeze(n_i_ba(sli_x,:,:));
% % %     n_e_ba = n_e_ba{1,1}; n_e_ba = squeeze(n_e_ba(sli_x,:,:));
% % %     n_i_up = n_i_up{1,1}; n_i_up = squeeze(n_i_up(sli_x,:,:));
% % %     n_e_up = n_e_up{1,1}; n_e_up = squeeze(n_e_up(sli_x,:,:));
% % 
% %     Pij_i_xx =  Pij_i{1,1}; Pij_i_xx = squeeze(Pij_i_xx(sli_x,:,:));
% %     Pij_i_xy =  Pij_i{1,2}; Pij_i_xy = squeeze(Pij_i_xy(sli_x,:,:));
% %     Pij_i_xz =  Pij_i{1,3}; Pij_i_xz = squeeze(Pij_i_xz(sli_x,:,:));
% %     Pij_i_yy =  Pij_i{2,2}; Pij_i_yy = squeeze(Pij_i_yy(sli_x,:,:));
% %     Pij_i_yz =  Pij_i{2,2}; Pij_i_yz = squeeze(Pij_i_yz(sli_x,:,:));    
% %     Pij_i_zz =  Pij_i{2,2}; Pij_i_zz = squeeze(Pij_i_zz(sli_x,:,:));
% % 
% % %     Pij_i_ba_xx =  Pij_i_ba{1,1}; Pij_i_ba_xx = squeeze(Pij_i_ba_xx(sli_x,:,:));
% % %     Pij_i_ba_xy =  Pij_i_ba{1,2}; Pij_i_ba_xy = squeeze(Pij_i_ba_xy(sli_x,:,:));
% % %     Pij_i_ba_xz =  Pij_i_ba{1,3}; Pij_i_ba_xz = squeeze(Pij_i_ba_xz(sli_x,:,:));
% % %     Pij_i_ba_yy =  Pij_i_ba{2,2}; Pij_i_ba_yy = squeeze(Pij_i_ba_yy(sli_x,:,:));
% % %     Pij_i_ba_yz =  Pij_i_ba{2,2}; Pij_i_ba_yz = squeeze(Pij_i_ba_yz(sli_x,:,:));    
% % %     Pij_i_ba_zz =  Pij_i_ba{2,2}; Pij_i_ba_zz = squeeze(Pij_i_ba_zz(sli_x,:,:));    
% % % 
% % %     Pij_i_up_xx =  Pij_i_up{1,1}; Pij_i_up_xx = squeeze(Pij_i_up_xx(sli_x,:,:));
% % %     Pij_i_up_xy =  Pij_i_up{1,2}; Pij_i_up_xy = squeeze(Pij_i_up_xy(sli_x,:,:));
% % %     Pij_i_up_xz =  Pij_i_up{1,3}; Pij_i_up_xz = squeeze(Pij_i_up_xz(sli_x,:,:));
% % %     Pij_i_up_yy =  Pij_i_up{2,2}; Pij_i_up_yy = squeeze(Pij_i_up_yy(sli_x,:,:));
% % %     Pij_i_up_yz =  Pij_i_up{2,2}; Pij_i_up_yz = squeeze(Pij_i_up_yz(sli_x,:,:));    
% % %     Pij_i_up_zz =  Pij_i_up{2,2}; Pij_i_up_zz = squeeze(Pij_i_up_zz(sli_x,:,:));
% % 
% %     Pij_e_xx =  Pij_e{1,1}; Pij_e_xx = squeeze(Pij_e_xx(sli_x,:,:));
% %     Pij_e_xy =  Pij_e{1,2}; Pij_e_xy = squeeze(Pij_e_xy(sli_x,:,:));
% %     Pij_e_xz =  Pij_e{1,3}; Pij_e_xz = squeeze(Pij_e_xz(sli_x,:,:));
% %     Pij_e_yy =  Pij_e{2,2}; Pij_e_yy = squeeze(Pij_e_yy(sli_x,:,:));
% %     Pij_e_yz =  Pij_e{2,2}; Pij_e_yz = squeeze(Pij_e_yz(sli_x,:,:));    
% %     Pij_e_zz =  Pij_e{2,2}; Pij_e_zz = squeeze(Pij_e_zz(sli_x,:,:));
% % 
% % %     Pij_e_ba_xx =  Pij_e_ba{1,1}; Pij_e_ba_xx = squeeze(Pij_e_ba_xx(sli_x,:,:));
% % %     Pij_e_ba_xy =  Pij_e_ba{1,2}; Pij_e_ba_xy = squeeze(Pij_e_ba_xy(sli_x,:,:));
% % %     Pij_e_ba_xz =  Pij_e_ba{1,3}; Pij_e_ba_xz = squeeze(Pij_e_ba_xz(sli_x,:,:));
% % %     Pij_e_ba_yy =  Pij_e_ba{2,2}; Pij_e_ba_yy = squeeze(Pij_e_ba_yy(sli_x,:,:));
% % %     Pij_e_ba_yz =  Pij_e_ba{2,2}; Pij_e_ba_yz = squeeze(Pij_e_ba_yz(sli_x,:,:));    
% % %     Pij_e_ba_zz =  Pij_e_ba{2,2}; Pij_e_ba_zz = squeeze(Pij_e_ba_zz(sli_x,:,:));    
% % % 
% % %     Pij_e_up_xx =  Pij_e_up{1,1}; Pij_e_up_xx = squeeze(Pij_e_up_xx(sli_x,:,:));
% % %     Pij_e_up_xy =  Pij_e_up{1,2}; Pij_e_up_xy = squeeze(Pij_e_up_xy(sli_x,:,:));
% % %     Pij_e_up_xz =  Pij_e_up{1,3}; Pij_e_up_xz = squeeze(Pij_e_up_xz(sli_x,:,:));
% % %     Pij_e_up_yy =  Pij_e_up{2,2}; Pij_e_up_yy = squeeze(Pij_e_up_yy(sli_x,:,:));
% % %     Pij_e_up_yz =  Pij_e_up{2,2}; Pij_e_up_yz = squeeze(Pij_e_up_yz(sli_x,:,:));    
% % %     Pij_e_up_zz =  Pij_e_up{2,2}; Pij_e_up_zz = squeeze(Pij_e_up_zz(sli_x,:,:));
% % 
% % 
% %     %clearvars n_e_up n_i_up n_i n_e n_e_ba n_i_ba
% %     %clearvars n_i_up n_e_up n_i_ba n_e_ba n_i n_e
% % 
% %     clearvars v_i_up v_e_up v_i_ba v_e_ba v_i v_e
% %     clearvars Pij_i Pij_e 
% %     %clearvars Pij_e_ba Pij_e_up  Pij_i_ba Pij_i_up
% %     %----------------------------------------------------------------------
% % 
% %     % v
% %     %---------------------------------------------------------------------- 
% %     v_x = (n_i .* v_ix + n_e .* v_ex)./(n_i+n_e);
% %     v_y = (n_i .* v_iy + n_e .* v_ey)./(n_i+n_e);
% %     v_z = (n_i .* v_iz + n_e .* v_ez)./(n_i+n_e);
% % 
% % %     v_x_ba = (n_i_ba .* v_i_bax + n_e_ba .* v_e_bax)./(n_i_ba+n_e_ba);
% % %     v_y_ba = (n_i_ba .* v_i_bay + n_e_ba .* v_e_bay)./(n_i_ba+n_e_ba);
% % %     v_z_ba = (n_i_ba .* v_i_baz + n_e_ba .* v_e_baz)./(n_i_ba+n_e_ba);
% % % 
% % %     v_x_up = (n_i_up .* v_i_upx + n_e_up .* v_e_upx)./(n_i_up+n_e_up);
% % %     v_y_up = (n_i_up .* v_i_upy + n_e_up .* v_e_upy)./(n_i_up+n_e_up);
% % %     v_z_up = (n_i_up .* v_i_upz + n_e_up .* v_e_upz)./(n_i_up+n_e_up);
% %     %---------------------------------------------------------------------- 
% % 
% %     % Save the data for the time average
% %     %----------------------------------------------------------------------
% %     inn=(jn - j_a +1);
% % 
% %     E_in{1,inn} = Ex;
% %     E_in{2,inn} = Ey;
% %     E_in{3,inn} = Ez;
% % 
% %     B_in{1,inn} = Bx;
% %     B_in{2,inn} = By;
% %     B_in{3,inn} = Bz;
% % 
% %     J_in{1,inn} = Jx;
% %     J_in{2,inn} = Jy;
% %     J_in{3,inn} = Jz;
% % 
% %     n_in{1,inn} = n_e;
% %     n_in{2,inn} = n_i;
% % 
% %     v_i_in{1,inn} = v_ix;
% %     v_i_in{2,inn} = v_iy;
% %     v_i_in{3,inn} = v_iz;
% % 
% %     v_e_in{1,inn} = v_ex;
% %     v_e_in{2,inn} = v_ey;
% %     v_e_in{3,inn} = v_ez;
% % 
% %     v_in{1,inn} = v_x;
% %     v_in{2,inn} = v_y;
% %     v_in{3,inn} = v_z;
% % 
% %     Pij_i_in{1,inn} = Pij_i_xx;
% %     Pij_i_in{2,inn} = Pij_i_xy;
% %     Pij_i_in{3,inn} = Pij_i_xz;
% %     Pij_i_in{4,inn} = Pij_i_yy;
% %     Pij_i_in{5,inn} = Pij_i_yz;
% %     Pij_i_in{6,inn} = Pij_i_zz;
% % 
% %     Pij_e_in{1,inn} = Pij_e_xx;
% %     Pij_e_in{2,inn} = Pij_e_xy;
% %     Pij_e_in{3,inn} = Pij_e_xz;
% %     Pij_e_in{4,inn} = Pij_e_yy;
% %     Pij_e_in{5,inn} = Pij_e_yz;
% %     Pij_e_in{6,inn} = Pij_e_zz;
% %     %----------------------------------------------------------------------
% % 
% % 
% % 
% %     %----------------------------------------------------------------------
% %     clearvars Ex Ey Ez Bx By Bz Jx Jy Jz n_i n_e n_i_up n_i_ba n_e_up n_e_ba
% %     clearvars v_ix v_iy v_iz v_ex v_ey v_ez v_x v_y v_z 
% %     clearvars Pij_e_xx Pij_e_xy Pij_e_xz Pij_e_y Pij_e_yz Pij_e_zz
% %     clearvars Pij_i_xx Pij_i_xy Pij_i_xz Pij_i_y Pij_i_yz Pij_i_zz
% %     %----------------------------------------------------------------------

end



    %Consolidate the averages in time 
    %----------------------------------------------------------------------
    DUM = 0.*E_in{1,1};
    Ex_avgt_i = DUM; Ey_avgt_i = DUM; Ez_avgt_i = DUM; 
    Bx_avgt_i = DUM; By_avgt_i = DUM; Bz_avgt_i = DUM; 
    Jx_avgt_i = DUM; Jy_avgt_i = DUM; Jz_avgt_i = DUM; 

    n_e_avgt_i = DUM; n_i_avgt_i = DUM;  

    v_ix_avgt_i = DUM; v_iy_avgt_i = DUM; v_iz_avgt_i = DUM; 
    v_ex_avgt_i = DUM; v_ey_avgt_i = DUM; v_ez_avgt_i = DUM; 
    v_x_avgt_i = DUM; v_y_avgt_i = DUM; v_z_avgt_i = DUM; 

    Pij_i_xx_avgt_i = DUM; Pij_i_xy_avgt_i = DUM; Pij_i_xz_avgt_i = DUM; 
    Pij_i_yy_avgt_i = DUM; Pij_i_yz_avgt_i = DUM; Pij_i_zz_avgt_i = DUM;   

    Pij_e_xx_avgt_i = DUM; Pij_e_xy_avgt_i = DUM; Pij_e_xz_avgt_i = DUM; 
    Pij_e_yy_avgt_i = DUM; Pij_e_yz_avgt_i = DUM; Pij_e_zz_avgt_i = DUM;   

%     Bz_avgt_i=0.*Bz_avgt_i;
%     for ii=1:j_a_b+1        
%         Bz_avgt_o = Bz_avgt_i + B_in{3,ii}; Bz_avgt_i = Bz_avgt_o; 
%     end
    %----------------------------------------------------------------------



    %----------------------------------------------------------------------
    for ii=1:j_a_b+1

        Ex_avgt_o = Ex_avgt_i + E_in{1,ii}; Ex_avgt_i = Ex_avgt_o; 
        Ey_avgt_o = Ey_avgt_i + E_in{2,ii}; Ey_avgt_i = Ey_avgt_o; 
        Ez_avgt_o = Ez_avgt_i + E_in{3,ii}; Ez_avgt_i = Ez_avgt_o; 

        Bx_avgt_o = Bx_avgt_i + B_in{1,ii}; Bx_avgt_i = Bx_avgt_o; 
        By_avgt_o = By_avgt_i + B_in{2,ii}; By_avgt_i = By_avgt_o; 
        Bz_avgt_o = Bz_avgt_i + B_in{3,ii}; Bz_avgt_i = Bz_avgt_o; 

        Jx_avgt_o = Jx_avgt_i + J_in{1,ii}; Jx_avgt_i = Jx_avgt_o; 
        Jy_avgt_o = Jy_avgt_i + J_in{2,ii}; Jy_avgt_i = Jy_avgt_o; 
        Jz_avgt_o = Jz_avgt_i + J_in{3,ii}; Jz_avgt_i = Jz_avgt_o; 
       

        n_e_avgt_o = n_e_avgt_i + n_in{1,ii}; n_e_avgt_i = n_e_avgt_o;
        n_i_avgt_o = n_in{2,ii} + n_i_avgt_i; n_i_avgt_i = n_i_avgt_o;

        v_ix_avgt_o = v_i_in{1,ii} + v_ix_avgt_i ; v_ix_avgt_i = v_ix_avgt_o;
        v_iy_avgt_o = v_i_in{2,ii} + v_iy_avgt_i ; v_iy_avgt_i = v_iy_avgt_o;
        v_iz_avgt_o = v_i_in{3,ii} + v_iz_avgt_i ; v_iz_avgt_i = v_iz_avgt_o;

        v_ex_avgt_o = v_e_in{1,ii} + v_ex_avgt_i ; v_ex_avgt_i = v_ex_avgt_o;
        v_ey_avgt_o = v_e_in{2,ii} + v_ey_avgt_i ; v_ey_avgt_i = v_ey_avgt_o;
        v_ez_avgt_o = v_e_in{3,ii} + v_ez_avgt_i ; v_ez_avgt_i = v_ez_avgt_o;

        v_x_avgt_o = v_in{1,ii} + v_x_avgt_i ; v_x_avgt_i = v_x_avgt_o;
        v_y_avgt_o = v_in{2,ii} + v_y_avgt_i ; v_y_avgt_i = v_y_avgt_o;
        v_z_avgt_o = v_in{3,ii} + v_z_avgt_i ; v_z_avgt_i = v_z_avgt_o;

        Pij_i_xx_avgt_o = Pij_i_in{1,ii} + Pij_i_xx_avgt_i ; Pij_i_xx_avgt_i = Pij_i_xx_avgt_o;
        Pij_i_xy_avgt_o = Pij_i_in{2,ii} + Pij_i_xy_avgt_i ; Pij_i_xy_avgt_i = Pij_i_xy_avgt_o;
        Pij_i_xz_avgt_o = Pij_i_in{3,ii} + Pij_i_xz_avgt_i ; Pij_i_xz_avgt_i = Pij_i_xz_avgt_o;
        Pij_i_yy_avgt_o = Pij_i_in{4,ii} + Pij_i_yy_avgt_i ; Pij_i_yy_avgt_i = Pij_i_yy_avgt_o;
        Pij_i_yz_avgt_o = Pij_i_in{5,ii} + Pij_i_yz_avgt_i ; Pij_i_yz_avgt_i = Pij_i_yz_avgt_o;
        Pij_i_zz_avgt_o = Pij_i_in{6,ii} + Pij_i_zz_avgt_i ; Pij_i_zz_avgt_i = Pij_i_zz_avgt_o;

        Pij_e_xx_avgt_o = Pij_e_in{1,ii} + Pij_e_xx_avgt_i ; Pij_e_xx_avgt_i = Pij_e_xx_avgt_o;
        Pij_e_xy_avgt_o = Pij_e_in{2,ii} + Pij_e_xy_avgt_i ; Pij_e_xy_avgt_i = Pij_e_xy_avgt_o;
        Pij_e_xz_avgt_o = Pij_e_in{3,ii} + Pij_e_xz_avgt_i ; Pij_e_xz_avgt_i = Pij_e_xz_avgt_o;
        Pij_e_yy_avgt_o = Pij_e_in{4,ii} + Pij_e_yy_avgt_i ; Pij_e_yy_avgt_i = Pij_e_yy_avgt_o;
        Pij_e_yz_avgt_o = Pij_e_in{5,ii} + Pij_e_yz_avgt_i ; Pij_e_yz_avgt_i = Pij_e_yz_avgt_o;
        Pij_e_zz_avgt_o = Pij_e_in{6,ii} + Pij_e_zz_avgt_i ; Pij_e_zz_avgt_i = Pij_e_zz_avgt_o;        

    end
    clearvars *_o 
    %----------------------------------------------------------------------

    

    % computing the time derivative
    dJxdt_avgt_i = DUM;
    dJydt_avgt_i = DUM;
    dJzdt_avgt_i = DUM;
    %----------------------------------------------------------------------
    for ii=1:j_a_b
        dJxdt_s = J_in{1,ii+1} - J_in{1,ii}; 
        dJxdt_avgt_o = dJxdt_avgt_i + dJxdt_s; dJxdt_avgt_i = dJxdt_avgt_o;

        dJydt_s = J_in{2,ii+1} - J_in{2,ii}; 
        dJydt_avgt_o = dJydt_avgt_i + dJydt_s; dJydt_avgt_i = dJydt_avgt_o;

        dJzdt_s = J_in{3,ii+1} - J_in{3,ii}; 
        dJzdt_avgt_o = dJzdt_avgt_i + dJzdt_s; dJzdt_avgt_i = dJzdt_avgt_o;
    end
    clearvars *_o 
    %----------------------------------------------------------------------


    %----------------------------------------------------------------------
    nu_av=j_a_b+1;
    Ex = Ex_avgt_i./nu_av; Ey = Ey_avgt_i./nu_av; Ez = Ez_avgt_i./nu_av;
    Bx = Bx_avgt_i./nu_av; By = By_avgt_i./nu_av; Bz = Bz_avgt_i./nu_av; 
    Jx = Jx_avgt_i./nu_av; Jy = Jy_avgt_i./nu_av; Jz = Jz_avgt_i./nu_av;

    n_e = n_e_avgt_i./nu_av; n_i = n_i_avgt_i./nu_av;

    v_ix = v_ix_avgt_i./nu_av; v_iy = v_iy_avgt_i./nu_av; v_iz = v_iz_avgt_i./nu_av;
    v_ex = v_ex_avgt_i./nu_av; v_ey = v_ey_avgt_i./nu_av; v_ez = v_ez_avgt_i./nu_av;
    v_x = v_x_avgt_i./nu_av; v_y = v_y_avgt_i./nu_av; v_z = v_z_avgt_i./nu_av;

    Pij_i_xx = Pij_i_xx_avgt_i./nu_av; 
    Pij_i_xy = Pij_i_xy_avgt_i./nu_av; 
    Pij_i_xz = Pij_i_xz_avgt_i./nu_av; 
    Pij_i_yy = Pij_i_yy_avgt_i./nu_av; 
    Pij_i_yz = Pij_i_yz_avgt_i./nu_av; 
    Pij_i_zz = Pij_i_zz_avgt_i./nu_av; 

    Pij_e_xx = Pij_e_xx_avgt_i./nu_av; 
    Pij_e_xy = Pij_e_xy_avgt_i./nu_av; 
    Pij_e_xz = Pij_e_xz_avgt_i./nu_av; 
    Pij_e_yy = Pij_e_yy_avgt_i./nu_av; 
    Pij_e_yz = Pij_e_yz_avgt_i./nu_av; 
    Pij_e_zz = Pij_e_zz_avgt_i./nu_av; 

    dJxdt = dJxdt_avgt_i./(nu_av-1)/dt;
    dJydt = dJydt_avgt_i./(nu_av-1)/dt;
    dJzdt = dJzdt_avgt_i./(nu_av-1)/dt;
    %----------------------------------------------------------------------   


    % computing the electric field contribution terms
    %----------------------------------------------------------------------


    %vxB
    %----------------------------------------------------------------------
    vixB_x = v_iy.*Bz - v_iz.*By; 
    vixB_y = v_iz.*Bx - v_ix.*Bz;
    vixB_z = v_ix.*By - v_iy.*Bx;

%     vi_baxB_x = v_i_bay.*Bz - v_i_baz.*By; 
%     vi_baxB_y = v_i_baz.*Bx - v_i_bax.*Bz;
%     vi_baxB_z = v_i_bax.*By - v_i_bay.*Bx;
% 
%     vi_upxB_x = v_i_upy.*Bz - v_i_upz.*By; 
%     vi_upxB_y = v_i_upz.*Bx - v_i_upx.*Bz;
%     vi_upxB_z = v_i_upx.*By - v_i_upy.*Bx;

    vexB_x = v_ey.*Bz - v_ez.*By; 
    vexB_y = v_ez.*Bx - v_ex.*Bz;
    vexB_z = v_ex.*By - v_ey.*Bx;

%     ve_baxB_x = v_e_bay.*Bz - v_e_baz.*By; 
%     ve_baxB_y = v_e_baz.*Bx - v_e_bax.*Bz;
%     ve_baxB_z = v_e_bax.*By - v_e_bay.*Bx;
% 
%     ve_upxB_x = v_e_upy.*Bz - v_e_upz.*By; 
%     ve_upxB_y = v_e_upz.*Bx - v_e_upx.*Bz;
%     ve_upxB_z = v_e_upx.*By - v_e_upy.*Bx;

    vxB_x = v_y.*Bz - v_z.*By; 
    vxB_y = v_z.*Bx - v_x.*Bz;
    vxB_z = v_x.*By - v_y.*Bx;

%     v_baxB_x = v_y_ba.*Bz - v_z_ba.*By; 
%     v_baxB_y = v_z_ba.*Bx - v_x_ba.*Bz;
%     v_baxB_z = v_x_ba.*By - v_y_ba.*Bx;
% 
%     v_upxB_x = v_y_up.*Bz - v_z_up.*By; 
%     v_upxB_y = v_z_up.*Bx - v_x_up.*Bz;
%     v_upxB_z = v_x_up.*By - v_y_up.*Bx;
    %---------------------------------------------------------------------- 

        % JJ
    %---------------------------------------------------------------------- 
    JJ_xx = Jx.*Jx./n_i;
    JJ_xy = Jx.*Jy./n_i;
    JJ_xz = Jx.*Jz./n_i;
    JJ_yy = Jy.*Jy./n_i;
    JJ_yz = Jy.*Jz./n_i;
    JJ_zz = Jz.*Jz./n_i;
    %---------------------------------------------------------------------- 

%     % JV + JV % symmetric
    %---------------------------------------------------------------------- 
    JV_VJ_xx = Jx.*v_x + v_x.*Jx - JJ_xx;
    JV_VJ_xy = Jx.*v_y + v_x.*Jy - JJ_xy;
    JV_VJ_xz = Jx.*v_z + v_x.*Jz - JJ_xz;
    JV_VJ_yy = Jy.*v_y + v_y.*Jy - JJ_yy;
    JV_VJ_yz = Jy.*v_z + v_y.*Jz - JJ_yz;
    JV_VJ_zz = Jz.*v_z + v_z.*Jz - JJ_zz;
    %---------------------------------------------------------------------- 

%     % JV + JV % symmetric
%     %---------------------------------------------------------------------- 
%     JV_VJ_xx = Jx.*v_x + v_x.*Jx;
%     JV_VJ_xy = Jx.*v_y + v_x.*Jy;
%     JV_VJ_xz = Jx.*v_z + v_x.*Jz;
%     JV_VJ_yy = Jy.*v_y + v_y.*Jy;
%     JV_VJ_yz = Jy.*v_z + v_y.*Jz;
%     JV_VJ_zz = Jz.*v_z + v_z.*Jz;
%     %---------------------------------------------------------------------- 


    %----------------------------------------------------------------------

    % In 2D
    %----------------------------------------------------------------------
    %[Bx_z,Bx_y] = gradient(Bx); % This is the correct order 

    %resx = 1; resy = 1; resz = 1;

    %Grad_B
    [By_z,By_y] = gradient(By);
    [Bz_z,Bz_y] = gradient(Bz);

    By_z = By_z/resz;   By_y = By_y/resy;   
    Bz_z = Bz_z/resz;   Bz_y = Bz_y/resy;

    %Grad_Pi
    [Pij_i_xx_z, Pij_i_xx_y] = gradient(Pij_i_xx);
    [Pij_i_yy_z, Pij_i_yy_y] = gradient(Pij_i_yy);
    [Pij_i_zz_z, Pij_i_zz_y] = gradient(Pij_i_zz);
    [Pij_i_xy_z, Pij_i_xy_y] = gradient(Pij_i_xy);
    [Pij_i_xz_z, Pij_i_xz_y] = gradient(Pij_i_xz);
    [Pij_i_yz_z, Pij_i_yz_y] = gradient(Pij_i_yz);

    Div_Pi_x = Pij_i_xy_y/resy + Pij_i_xz_z/resz;
    Div_Pi_y = Pij_i_yy_y/resy + Pij_i_yz_z/resz;
    Div_Pi_z = Pij_i_yz_y/resy + Pij_i_zz_z/resz;

    %Grad_Pe
    [Pij_e_xx_z, Pij_e_xx_y] = gradient(Pij_e_xx);
    [Pij_e_yy_z, Pij_e_yy_y] = gradient(Pij_e_yy);
    [Pij_e_zz_z, Pij_e_zz_y] = gradient(Pij_e_zz);
    [Pij_e_xy_z, Pij_e_xy_y] = gradient(Pij_e_xy);
    [Pij_e_xz_z, Pij_e_xz_y] = gradient(Pij_e_xz);
    [Pij_e_yz_z, Pij_e_yz_y] = gradient(Pij_e_yz);

    Div_Pe_x = Pij_e_xy_y/resy + Pij_e_xz_z/resz;
    Div_Pe_y = Pij_e_yy_y/resy + Pij_e_yz_z/resz;
    Div_Pe_z = Pij_e_yz_y/resy + Pij_e_zz_z/resz;

    %Grad_JV_VJ
    [JV_VJ_xx_z, JV_VJ_xx_y] = gradient(JV_VJ_xx);
    [JV_VJ_xy_z, JV_VJ_xy_y] = gradient(JV_VJ_xy);
    [JV_VJ_xz_z, JV_VJ_xz_y] = gradient(JV_VJ_xz);
    [JV_VJ_yy_z, JV_VJ_yy_y] = gradient(JV_VJ_yy);
    [JV_VJ_yz_z, JV_VJ_yz_y] = gradient(JV_VJ_yz);
    [JV_VJ_zz_z, JV_VJ_zz_y] = gradient(JV_VJ_zz);

    Div_JV_VJ_x = (JV_VJ_xy_y/resy + JV_VJ_xz_z/resz)./(1*n_i);
    Div_JV_VJ_y = (JV_VJ_yy_y/resy + JV_VJ_yz_z/resz)./(1*n_i);
    Div_JV_VJ_z = (JV_VJ_yz_y/resy + JV_VJ_zz_z/resz)./(1*n_i);

    Div_Pe_Pi_x = -(Div_Pe_x - Div_Pi_x)./(2*n_i);
    Div_Pe_Pi_y = -(Div_Pe_y - Div_Pi_y)./(2*n_i);
    Div_Pe_Pi_z = -(Div_Pe_z - Div_Pi_z)./(2*n_i);
    %----------------------------------------------------------------------



    % Plots 
    %----------------------------------------------------------------------
    %xlim_a = 1; xlim_b = ssz(1,3);
    %ylim_a = 1; ylim_b = ssz(1,2);

    sss=size(Ex);
    size_X=sss;
    zll=linspace(-Lz,Lz,size_X(2)); %Jeff flag it works with (1,size_x(2))
    yll=linspace(-Ly,Ly,size_X(1));
    [ZLL, YLL] = meshgrid(zll,yll);

    yticks_mine=[floor(-Ly*0.9) floor(-Ly/2) 0 floor(Ly/2) floor(Ly*0.9)];
    zticks_mine=[floor(-Lz*0.9) floor(-Lz/2) 0 floor(Lz/2) floor(Lz*0.9)];

    xlim_a = zll(704); xlim_b = zll(1104);
    ylim_a = yll(391); ylim_b = yll(591);
    ylim_a = yll(488); ylim_b = yll(541);

    % Note4s: Ex + vexB_x, Ex + vixB_x and Ex + vxB_x have the same profile
    % because the normalisation probably

    % 492 to 530 

    lw=2;
    %----------------------------------------------------------------------
    
    %----------------------------------------------------------------------
    f1=figure(1)
    subplot(2,2,1)
    plot(yll,Ex(:,sli_z),'b','LineWidth',lw);
    xlim([ylim_a, ylim_b]); xlabel('y/d_i')
    subplot(2,2,2)
    dump = Ex;
    hc=pcolor(ZLL,YLL,dump);
    hold on
    set(hc,'edgecolor','none')
    colorbar; title('E_x'); xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    xlabel('z/d_i'); ylabel('y/d_i');
    xline(zll(sli_z),'--k','LineWidth',lw);
    hold off
    subplot(2,2,3)
    dump = Bz;
    hc=pcolor(ZLL,YLL,dump);
    hold on
    set(hc,'edgecolor','none')
    colorbar; title('B_z'); xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    xlabel('z/d_i'); ylabel('y/d_i');
    xline(zll(sli_z),'--k','LineWidth',lw);
    hold off
    subplot(2,2,4)
    hc=pcolor(ZLL,YLL,Jx);
    hold on
    set(hc,'edgecolor','none')
    colorbar; title('J_x'); xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    xlabel('z/d_i'); ylabel('y/d_i');
    xline(zll(sli_z),'--k','LineWidth',lw)
    hold off
    %----------------------------------------------------------------------


    % checking the tensors in space Pij_e Pij_i
    %----------------------------------------------------------------------
    cssa=0.03;
    f22=figure(22)
        subplot(4,3,1)
    dump=Pij_e_xx;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('Pije_xx'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([0 cssa]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(4,3,2)
    dump=Pij_e_xy;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('Pije_xy'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-cssa cssa]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(4,3,3)
    dump=Pij_e_xz;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('Pije_xz'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-cssa cssa]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(4,3,4)
    dump=Pij_e_yy;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('Pije_yy'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([0 cssa]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(4,3,5)
    dump=Pij_e_yz;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('Pije_yz'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-cssa cssa]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(4,3,6)
    dump=Pij_e_zz;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('Pije_zz'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([0 cssa]);
    xlabel('z/d_i'); ylabel('y/d_i');
    %----------------------------------------------------------------------
        subplot(4,3,7)
    dump=Pij_i_xx;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('Piji_xx'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([0 cssa]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(4,3,8)
    dump=Pij_i_xy;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('Piji_xy'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-cssa cssa]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(4,3,9)
    dump=Pij_i_xz;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('Piji_xz'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-cssa cssa]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(4,3,10)
    dump=Pij_i_yy;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('Piji_yy'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([0 cssa]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(4,3,11)
    dump=Pij_i_yz;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('Piji_yz'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-cssa cssa]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(4,3,12)
    dump=(Pij_i_zz);
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('Piji_zz'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([0 cssa]);
    xlabel('z/d_i'); ylabel('y/d_i');
    %----------------------------------------------------------------------


    % checking JV_VJ
    %----------------------------------------------------------------------
    f23=figure(23)
        subplot(2,3,1)
    dump=JV_VJ_xx;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('JVVJ_xx'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-0.1 0.1]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(2,3,2)
    dump=JV_VJ_xy;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('JVVJ_xy'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-0.1 0.1]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(2,3,3)
    dump=JV_VJ_xz;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('JVVJ_xz'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-0.1 0.1]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(2,3,4)
    dump=JV_VJ_yy;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('JVVJ_yy'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-0.1 0.1]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(2,3,5)
    dump=JV_VJ_yz;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('JVVJ_yz'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-0.1 0.1]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(2,3,6)
    dump=JV_VJ_zz;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('JVVJ_zz'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-0.1 0.1]);
    xlabel('z/d_i'); ylabel('y/d_i');
    %----------------------------------------------------------------------


    % checking JJ
    %----------------------------------------------------------------------
    f24=figure(24)
        subplot(2,3,1)
    dump=JJ_xx;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('JJ_xx'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-0.01 0.01]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(2,3,2)
    dump=JJ_xy;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('JJ_xy'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-0.01 0.01]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(2,3,3)
    dump=JJ_xz;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('JJ_xz'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-0.01 0.01]);
    xlabel('z/d_i'); ylabel('y/d_i');
    %----------------------------------------------------------------------
        subplot(2,3,4)
    dump=JJ_yy;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('JJ_yy'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-0.01 0.01]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(2,3,5)
    dump=JJ_yz;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('JJ_yz'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-0.01 0.01]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(2,3,6)
    dump=JJ_zz;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('JJ_zz'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-0.01 0.01]);
    xlabel('z/d_i'); ylabel('y/d_i');
    %----------------------------------------------------------------------

    % checking JJ
    %----------------------------------------------------------------------
    f25=figure(25)
        subplot(2,3,1)
    dump=Div_JV_VJ_x;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('DivJVVJ_x'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-0.1 0.1]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(2,3,2)
    dump=Div_JV_VJ_y;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('DivJVVJ_y'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-0.1 0.1]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(2,3,3)
    dump=Div_JV_VJ_z;
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('DivJVVJ_z'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-0.1 0.1]);
    xlabel('z/d_i'); ylabel('y/d_i');
    %----------------------------------------------------------------------
        subplot(2,3,4)
    dump=dJxdt./(n_i);
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('dJxdt'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-0.1 0.1]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(2,3,5)
    dump=dJydt./(n_i);
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('dJydt'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-0.1 0.1]);
    xlabel('z/d_i'); ylabel('y/d_i');
        subplot(2,3,6)
    dump=dJzdt./(n_i);
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    colorbar; title('dJzdt'); 
    xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    caxis([-0.1 0.1]);
    xlabel('z/d_i'); ylabel('y/d_i');
    %----------------------------------------------------------------------


    %----------------------------------------------------------------------
    f4=figure(4);
    plot(yll,v_ex(:,sli_z),'r','LineWidth',lw);
    hold on
    plot(yll,v_ix(:,sli_z),'--r','LineWidth',lw);
    plot(yll,v_ey(:,sli_z),'g','LineWidth',lw);
    plot(yll,v_iy(:,sli_z),'--g','LineWidth',lw);
    plot(yll,v_ez(:,sli_z),'b','LineWidth',lw);
    plot(yll,v_iz(:,sli_z),'--b','LineWidth',lw);
    xlim([ylim_a, ylim_b]); 
    legend('ve_x','vi_x','ve_y','vi_y','ve_z','vi_z')
    xlabel('y/d_i')
    %ylim([-0.01, 0.01,]); 
    hold off
    %----------------------------------------------------------------------
   

    f6=figure(6);
    %----------------------------------------------------------------------
        subplot(5,3,1)
    dump=Ex;
    plot(yll,dump(:,sli_z) ,'r','LineWidth',lw);
    hold on
    %plot(yll,Jx(:,sli_z) ,'--r','LineWidth',lw);
    xlim([ylim_a, ylim_b]);
    legend('Ex');%legend('Ex','Jx');
    xlabel('y/d_i'); ylim([-0.01 0.01]);
    hold off
        subplot(5,3,2)
    plot(yll,Ey(:,sli_z),'g','LineWidth',lw);
    hold on
    %plot(yll,Jy(:,sli_z),'--g','LineWidth',lw);
    xlim([ylim_a, ylim_b]); 
    legend('Ey');%legend('Ey','Jy');
    xlabel('y/d_i'); ylim([-0.01 0.01]);
    hold off
        subplot(5,3,3)
    plot(yll,Ez(:,sli_z),'b','LineWidth',lw);
    hold on
    %plot(yll,Jz(:,sli_z),'--b','LineWidth',lw);
    xlim([ylim_a, ylim_b]); 
    legend('Ez');%legend('Ey','Jy');
    xlabel('y/d_i'); ylim([-0.01 0.01]);
    hold off
    %----------------------------------------------------------------------
        subplot(5,3,4)
    plot(yll,vxB_x(:,sli_z),'r','LineWidth',lw);
    hold on
    plot(yll,vexB_x(:,sli_z),'g','LineWidth',lw);
    plot(yll,vixB_x(:,sli_z),'b','LineWidth',lw);
    xlim([ylim_a, ylim_b]); 
    legend('vxB_x','vexB_x','vixB_x');
    xlabel('y/d_i'); ylim([-0.1 0.1]);
    hold off
        subplot(5,3,5)
    plot(yll,vxB_y(:,sli_z),'r','LineWidth',lw);
    hold on
    plot(yll,vexB_y(:,sli_z),'g','LineWidth',lw);
    plot(yll,vixB_y(:,sli_z),'b','LineWidth',lw);
    xlim([ylim_a, ylim_b]); 
    legend('vxB_y','vexB_y','vixB_y');
    xlabel('y/d_i'); ylim([-0.1 0.1]);
    hold off
        subplot(5,3,6)
    plot(yll,vxB_z(:,sli_z),'r','LineWidth',lw);
    hold on
    plot(yll,vexB_z(:,sli_z),'g','LineWidth',lw);
    plot(yll,vixB_z(:,sli_z),'b','LineWidth',lw);
    xlim([ylim_a, ylim_b]); 
    legend('vxB_z','vexB_z','vixB_z');
    xlabel('y/d_i'); ylim([-0.1 0.1]);
    hold off
    %----------------------------------------------------------------------
        subplot(5,3,7)
    plot(yll,Div_JV_VJ_x(:,sli_z),'r','LineWidth',lw);
    hold on
    legend('DivJVVJ_x')
    xlim([ylim_a, ylim_b]); 
    xlabel('y/d_i')
    hold off
        subplot(5,3,8)
    plot(yll,Div_JV_VJ_y(:,sli_z),'g','LineWidth',lw);
    hold on
    legend('DivJVVJ_y')
    xlim([ylim_a, ylim_b]); 
    xlabel('y/d_i')
    hold off
        subplot(5,3,9)
    plot(yll,Div_JV_VJ_z(:,sli_z),'b','LineWidth',lw);
    hold on
    legend('DivJVVJ_z')
    xlim([ylim_a, ylim_b]); 
    xlabel('y/d_i')
    hold off
    %----------------------------------------------------------------------
        subplot(5,3,10)
    plot(yll,Div_Pe_Pi_x(:,sli_z),'r','LineWidth',lw);
    hold on
    legend('DivPePi_x')
    xlim([ylim_a, ylim_b]); 
    xlabel('y/d_i'); ylim([-0.02 0.02]);
    hold off
        subplot(5,3,11)
    plot(yll,Div_Pe_Pi_y(:,sli_z),'g','LineWidth',lw);
    hold on
    legend('DivPePi_y')
    xlim([ylim_a, ylim_b]); 
    xlabel('y/d_i'); ylim([-0.02 0.02]);
    hold off
        subplot(5,3,12)
    plot(yll,Div_Pe_Pi_z(:,sli_z),'b','LineWidth',lw);
    hold on
    legend('DivPePi_z')
    xlim([ylim_a, ylim_b]);
    xlabel('y/d_i'); ylim([-0.02 0.02]);
    hold off
    %----------------------------------------------------------------------
        subplot(5,3,13)
    dump=dJxdt./(n_i);
    plot(yll,dump(:,sli_z),'r','LineWidth',lw);
    hold on
    legend('dJxdt')
    xlim([ylim_a, ylim_b]); 
    xlabel('y/d_i'); ylim([-0.1 0.1]);
    hold off
        subplot(5,3,14)
    dump=dJydt./(n_i);
    plot(yll,dump(:,sli_z),'g','LineWidth',lw);
    hold on
    legend('dJydt')
    xlim([ylim_a, ylim_b]); 
    xlabel('y/d_i'); ylim([-0.1 0.1]);
    hold off
        subplot(5,3,15)
    dump=dJzdt./(n_i);
    plot(yll,dump(:,sli_z),'b','LineWidth',lw);
    hold on
    legend('dJzdt')
    xlim([ylim_a, ylim_b]);
    xlabel('y/d_i'); ylim([-0.1 0.1]);
    hold off
    %----------------------------------------------------------------------





  cd(path)
  saveas(f1,strcat('1_i' + string(i) +'.png'));
  saveas(f4,strcat('2_i' + string(i) +'.png'));
  saveas(f6,strcat('3_i' + string(i) +'.png'));
  saveas(f22,strcat('4_i' + string(i) +'.png'));
  saveas(f23,strcat('5_i' + string(i) +'.png'));
  saveas(f24,strcat('6_i' + string(i) +'.png'));
  saveas(f25,strcat('7_i' + string(i) +'.png'));



%     %----------------------------------------------------------------------    
%     f2=figure(2);
%     subplot(3,3,1)
%     hc=pcolor(ZLL,YLL,v_i_upx);
%     set(hc,'edgecolor','none')
%     colorbar; title('vi_upx'); xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
%     subplot(3,3,2)
%     hc=pcolor(ZLL,YLL,v_i_bax);
%     set(hc,'edgecolor','none')
%     colorbar; title('vi_bax'); xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
%     subplot(3,3,3)
%     hc=pcolor(ZLL,YLL,v_ix);
%     set(hc,'edgecolor','none')
%     colorbar; title('vix'); xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
%     subplot(3,3,4)
%     hc=pcolor(ZLL,YLL,v_e_upx);
%     set(hc,'edgecolor','none')
%     colorbar; title('ve_upx'); xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
%     subplot(3,3,5)
%     hc=pcolor(ZLL,YLL,v_e_bax);
%     set(hc,'edgecolor','none')
%     colorbar; title('ve_bax'); xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
%     subplot(3,3,6)
%     hc=pcolor(ZLL,YLL,v_ex);
%     set(hc,'edgecolor','none')
%     colorbar; title('vex'); xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
%     subplot(3,3,7)
%     hc=pcolor(ZLL,YLL,n_e_up);
%     set(hc,'edgecolor','none')
%     colorbar; title('ne_up'); xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
%     subplot(3,3,8)
%     hc=pcolor(ZLL,YLL,n_e_ba);
%     set(hc,'edgecolor','none')
%     colorbar; title('ne_ba'); xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
%     subplot(3,3,9)
%     hc=pcolor(ZLL,YLL,n_e);
%     set(hc,'edgecolor','none')
%     colorbar; title('ne'); xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
%     %----------------------------------------------------------------------


    