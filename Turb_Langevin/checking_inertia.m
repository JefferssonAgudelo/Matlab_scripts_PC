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

for jn=1:N
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
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    ssz=size(B{1,1});
    sli_x = 1; %floor(4+ssz(1)/2);%1;
    sli_y = 512; %floor(4+ssz(2)/2);%380;
    sli_z = 904; %floor(2+ssz(3)/2);%700;
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    Ex = E{1,1}; Ex = squeeze(Ex(sli_x,:,:));

    Bx = B{1,1}; Bx = squeeze(Bx(sli_x,:,:));
    By = B{1,2}; By = squeeze(By(sli_x,:,:));
    Bz = B{1,3}; Bz = squeeze(Bz(sli_x,:,:));


    clearvars E B 
    %---------------------------------------------------------------------


    % Loading the data for the bulk speed of the particles
    %----------------------------------------------------------------------    
    p_e_up{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e_UP/p0/3d')); 
    
    p_i_up{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i_UP/p0/3d'));

    p_e_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e_BA/p0/3d')); 
    
    p_i_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i_BA/p0/3d'));

    p_e{1,1}=(p_e_up{1,1}+p_e_ba{1,1})./1; 

    p_i{1,1}=(p_i_up{1,1}+p_i_ba{1,1})./1; 

    %clearvars p_i_up p_e_up p_i_ba p_e_ba
    %----------------------------------------------------------------------

    % computing the velocities in units of c
    %----------------------------------------------------------------------
    v_e{1,1} = p_e{1,1} * c ./ sqrt(c^2 * me^2 + p_e{1,1}.^2);
    v_i{1,1} = p_i{1,1} * c ./ sqrt(c^2 * mi^2 + p_i{1,1}.^2);
    %---------------------------------------------------------------------- 


    %----------------------------------------------------------------------
    v_ex = v_e{1,1}; v_ex = squeeze(v_ex(sli_x,:,:));    
    v_ix = v_i{1,1}; v_ix = squeeze(v_ix(sli_x,:,:));
    %---------------------------------------------------------------------

    ay_a = 496 ;    ay_b = 530 ;
    az_a = 488 ;    az_b = 540 ;

    Bx=Bx(ay_a:ay_b,az_a:az_b);
    By=By(ay_a:ay_b,az_a:az_b);
    Bz=Bz(ay_a:ay_b,az_a:az_b);

    Ex=Ex(ay_a:ay_b,az_a:az_b);

    v_ex=v_ex(ay_a:ay_b,az_a:az_b);
    v_ix=v_ix(ay_a:ay_b,az_a:az_b);

    %----------------------------------------------------------------------
    sss=size(Bx);
    size_X=sss;
%     zll=linspace(-Lz,Lz,size_X(2)); %Jeff flag it works with (1,size_x(2))
%     yll=linspace(-Ly,Ly,size_X(1));
%     [ZLL, YLL] = meshgrid(zll,yll);
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
    Ax_y_short_i(1,in) = abs(mean(Ax_y,"all"));
    ve_x_short_i(1,in) = abs(mean(v_ex,"all"));
   %----------------------------------------------------------------------

end

   f1=figure(1)
   plot(time_t_2,Ax_y_short_i,'r',LineWidth=2)
   hold on
   plot(time_t_2,ve_x_short_i,'b',LineWidth=2)
   legend('A_x','v_{ex}')
   xlabel('t/omega')
   %xlim([0 110])
   hold off


  cd(path)
  saveas(f1,strcat('reconnection_inertia' + string(i) +'.png'));
