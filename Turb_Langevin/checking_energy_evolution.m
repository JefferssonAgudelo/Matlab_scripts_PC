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

% kinetic energy density electrons and ions
Ue_k_mean=zeros(1,N_jn); % 
Ue_k_std=zeros(1,N_jn);
Ue_k_up_mean=zeros(1,N_jn); %
Ue_k_up_std=zeros(1,N_jn);
Ue_k_ba_mean=zeros(1,N_jn); % 
Ue_k_ba_std=zeros(1,N_jn);

Ui_k_mean=zeros(1,N_jn); %
Ui_k_std=zeros(1,N_jn);
Ui_k_up_mean=zeros(1,N_jn); %
Ui_k_up_std=zeros(1,N_jn);
Ui_k_ba_mean=zeros(1,N_jn); % 
Ui_k_ba_std=zeros(1,N_jn);

% thermal energy density electrons and ions
Ue_th_mean=zeros(1,N_jn); % 
Ue_th_std=zeros(1,N_jn);
Ue_th_up_mean=zeros(1,N_jn); %
Ue_th_up_std=zeros(1,N_jn);
Ue_th_ba_mean=zeros(1,N_jn); % 
Ue_th_ba_std=zeros(1,N_jn);

Ui_th_mean=zeros(1,N_jn); %
Ui_th_std=zeros(1,N_jn);
Ui_th_up_mean=zeros(1,N_jn); %
Ui_th_up_std=zeros(1,N_jn);
Ui_th_ba_mean=zeros(1,N_jn); % 
Ui_th_ba_std=zeros(1,N_jn);

time_t_2=zeros(1,N_jn);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%N =183 is the limit for the run to keep the same time steps.
jn=220;
jn=in;
%106 <--
for jn=10:12
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
    %----------------------------------------------------------------------
    
    %----------------------------------------------------------------------
    % Computing the electro magnetic energy density average
    %----------------------------------------------------------------------
    B2=(B{1,1}.^2 + B{1,2}.^2 + B{1,3}.^2);
    E2=(E{1,1}.^2 + E{1,2}.^2 + E{1,3}.^2);
    U_em = 0.5*(B2 + E2); 
    s_Uem = size(U_em);
    s_Uem = s_Uem(1)*s_Uem(2)*s_Uem(3);

    U_em_mean_i = sum(U_em,'all')/s_Uem;
    U_em2_mean_i = sum((U_em.^2),'all')/s_Uem;

    U_em_std_i = sqrt(U_em2_mean_i - U_em_mean_i.^2); 

    U_em_mean(1,jn) = U_em_mean_i;
    U_em_std(1,jn) = U_em_std_i;

    clearvars B E B2 E2 U_em
    %----------------------------------------------------------------------
    
    % Loading the darta for the bulk speed of the particles
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
    
    % densities
    %----------------------------------------------------------------------
    cd(path)
    n_e_up{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_e_UP/p0/3d'));
    n_i_up{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_i_UP/p0/3d'));
    n_e_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_e_BA/p0/3d'));
    n_i_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_i_BA/p0/3d'));
    n_e{1,1}=(n_e_up{1,1} + n_e_ba{1,1})./1;
    n_i{1,1}=(n_i_up{1,1} + n_i_ba{1,1})./1;
    
    n_e_up{1,1}=-1.*n_e_up{1,1};
    n_e_ba{1,1}=-1.*n_e_ba{1,1};
    n_e{1,1}=-1.*n_e{1,1};
    %clearvars n_e_up n_e_ba n_i_up n_i_ba 

    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    % Computing the kinetic energy densities average
    %----------------------------------------------------------------------
    
    % using a general variable so I don't have to write everything again
    % electrons
    %----------------------------------------------------------------------
    dum2=(v_e_up{1,1}.^2 + v_e_up{1,2}.^2 + v_e_up{1,3}.^2); %<--
    Udum = 0.5.*n_e_up{1,1}.*dum2; %<--  
    Udum_mean_i = sum(Udum,'all')/s_Uem;
    Udum2_mean_i = sum((Udum.^2),'all')/s_Uem;
    Udum_std_i = sqrt(Udum2_mean_i - Udum_mean_i.^2);  
    Ue_k_up_mean(1,jn) = Udum_mean_i; %<--
    Ue_k_up_std(1,jn) = Udum_std_i; %<--
    clearvars Udum_mean_i Udum_std_i dum2

    dum2=(v_e_ba{1,1}.^2 + v_e_ba{1,2}.^2 + v_e_ba{1,3}.^2); %<--
    Udum = 0.5.*n_e_ba{1,1}.*dum2; %<--  
    Udum_mean_i = sum(Udum,'all')/s_Uem;
    Udum2_mean_i = sum((Udum.^2),'all')/s_Uem;
    Udum_std_i = sqrt(Udum2_mean_i - Udum_mean_i.^2);  
    Ue_k_ba_mean(1,jn) = Udum_mean_i; %<--
    Ue_k_ba_std(1,jn) = Udum_std_i; %<--
    clearvars Udum_mean_i Udum_std_i dum2

    dum2=(v_e{1,1}.^2 + v_e{1,2}.^2 + v_e{1,3}.^2); %<--
    Udum = 0.5.*n_e{1,1}.*dum2;   
    Udum_mean_i = sum(Udum,'all')/s_Uem;
    Udum2_mean_i = sum((Udum.^2),'all')/s_Uem;
    Udum_std_i = sqrt(Udum2_mean_i - Udum_mean_i.^2);  
    Ue_k_mean(1,jn) = Udum_mean_i; %<--
    Ue_k_std(1,jn) = Udum_std_i; %<--
    clearvars Udum_mean_i Udum_std_i dum2
    %----------------------------------------------------------------------

    % ions
     %----------------------------------------------------------------------
    dum2=(v_i_up{1,1}.^2 + v_i_up{1,2}.^2 + v_i_up{1,3}.^2); %<--
    Udum = 0.5.*n_i_up{1,1}.*dum2; %<--  
    Udum_mean_i = sum(Udum,'all')/s_Uem;
    Udum2_mean_i = sum((Udum.^2),'all')/s_Uem;
    Udum_std_i = sqrt(Udum2_mean_i - Udum_mean_i.^2);  
    Ui_k_up_mean(1,jn) = Udum_mean_i; %<--
    Ui_k_up_std(1,jn) = Udum_std_i; %<--
    clearvars Udum_mean_i Udum_std_i dum2

    dum2=(v_i_ba{1,1}.^2 + v_i_ba{1,2}.^2 + v_i_ba{1,3}.^2); %<--
    Udum = 0.5.*n_i_ba{1,1}.*dum2; %<--  
    Udum_mean_i = sum(Udum,'all')/s_Uem;
    Udum2_mean_i = sum((Udum.^2),'all')/s_Uem;
    Udum_std_i = sqrt(Udum2_mean_i - Udum_mean_i.^2);  
    Ui_k_ba_mean(1,jn) = Udum_mean_i; %<--
    Ui_k_ba_std(1,jn) = Udum_std_i; %<--
    clearvars Udum_mean_i Udum_std_i dum2

    dum2=(v_i{1,1}.^2 + v_i{1,2}.^2 + v_i{1,3}.^2); %<--
    Udum = 0.5.*n_i{1,1}.*dum2;   
    Udum_mean_i = sum(Udum,'all')/s_Uem;
    Udum2_mean_i = sum((Udum.^2),'all')/s_Uem;
    Udum_std_i = sqrt(Udum2_mean_i - Udum_mean_i.^2);  
    Ui_k_mean(1,jn) = Udum_mean_i; %<--
    Ui_k_std(1,jn) = Udum_std_i; %<--
    clearvars Udum_mean_i Udum_std_i dum2
    %----------------------------------------------------------------------
%     clearvars v_e_up v_e_ba v_e n_e_ba n_e_up
%     clearvars v_i_up v_i_ba v_i n_i_ba n_i_up
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    Txx_e_up=h5read(fileID2,strcat(moments_1st,'/txx_e_UP/p0/3d')); 
    Tyy_e_up=h5read(fileID2,strcat(moments_1st,'/tyy_e_UP/p0/3d'));
    Tzz_e_up=h5read(fileID2,strcat(moments_1st,'/tzz_e_UP/p0/3d'));
    Txy_e_up=h5read(fileID2,strcat(moments_1st,'/txy_e_UP/p0/3d')); 
    Txz_e_up=h5read(fileID2,strcat(moments_1st,'/tzx_e_UP/p0/3d'));
    Tyz_e_up=h5read(fileID2,strcat(moments_1st,'/tyz_e_UP/p0/3d'));

    Txx_e_ba=h5read(fileID2,strcat(moments_1st,'/txx_e_BA/p0/3d')); 
    Tyy_e_ba=h5read(fileID2,strcat(moments_1st,'/tyy_e_BA/p0/3d'));
    Tzz_e_ba=h5read(fileID2,strcat(moments_1st,'/tzz_e_BA/p0/3d'));
    Txy_e_ba=h5read(fileID2,strcat(moments_1st,'/txy_e_BA/p0/3d')); 
    Txz_e_ba=h5read(fileID2,strcat(moments_1st,'/tzx_e_BA/p0/3d'));
    Tyz_e_ba=h5read(fileID2,strcat(moments_1st,'/tyz_e_BA/p0/3d'));

    Txx_e=(Txx_e_up + Txx_e_ba)./1; 
    Tyy_e=(Tyy_e_up + Tyy_e_ba)./1;
    Tzz_e=(Tzz_e_up + Tzz_e_ba)./1;
    Txy_e=(Txy_e_up + Txy_e_ba)./1;
    Txz_e=(Txz_e_up + Txz_e_ba)./1;
    Tyz_e=(Tyz_e_up + Tyz_e_ba)./1;

    %clearvars Txx_e_ba Txx_e_up Tyy_e_ba Tyy_e_up Tzz_e_ba Tzz_e_up
    %clearvars Txy_e_ba Txy_e_up Txz_e_ba Txz_e_up Tyz_e_ba Tyz_e_up

    Txx_i_up=h5read(fileID2,strcat(moments_1st,'/txx_i_UP/p0/3d')); 
    Tyy_i_up=h5read(fileID2,strcat(moments_1st,'/tyy_i_UP/p0/3d'));
    Tzz_i_up=h5read(fileID2,strcat(moments_1st,'/tzz_i_UP/p0/3d'));
    Txy_i_up=h5read(fileID2,strcat(moments_1st,'/txy_i_UP/p0/3d')); 
    Txz_i_up=h5read(fileID2,strcat(moments_1st,'/tzx_i_UP/p0/3d'));
    Tyz_i_up=h5read(fileID2,strcat(moments_1st,'/tyz_i_UP/p0/3d'));

    Txx_i_ba=h5read(fileID2,strcat(moments_1st,'/txx_i_BA/p0/3d')); 
    Tyy_i_ba=h5read(fileID2,strcat(moments_1st,'/tyy_i_BA/p0/3d'));
    Tzz_i_ba=h5read(fileID2,strcat(moments_1st,'/tzz_i_BA/p0/3d'));
    Txy_i_ba=h5read(fileID2,strcat(moments_1st,'/txy_i_BA/p0/3d')); 
    Txz_i_ba=h5read(fileID2,strcat(moments_1st,'/tzx_i_BA/p0/3d'));
    Tyz_i_ba=h5read(fileID2,strcat(moments_1st,'/tyz_i_BA/p0/3d'));

    Txx_i=(Txx_i_up + Txx_i_ba)./1; 
    Tyy_i=(Tyy_i_up + Tyy_i_ba)./1;
    Tzz_i=(Tzz_i_up + Tzz_i_ba)./1;
    Txy_i=(Txy_i_up + Txy_i_ba)./1;
    Txz_i=(Txz_i_up + Txz_i_ba)./1;
    Tyz_i=(Tyz_i_up + Tyz_i_ba)./1;

    %----------------------------------------------------------------------  
    Pij_i=cell(3,3);
    Pij_e=cell(3,3);
    Pij_i_ba=cell(3,3);
    Pij_e_ba=cell(3,3);
    Pij_i_up=cell(3,3);
    Pij_e_up=cell(3,3);
    %--------------------------------------------------------------------------
    % Make the tensor [3, 3] for the ions
    Pij_i{1,1}=Txx_i; Pij_i{1,2}=Txy_i; Pij_i{1,3}=Txz_i;
    Pij_i{2,1}=Txy_i; Pij_i{2,2}=Tyy_i; Pij_i{2,3}=Tyz_i;
    Pij_i{3,1}=Txz_i; Pij_i{3,2}=Tyz_i; Pij_i{3,3}=Tzz_i;
    clearvars Txx_i Txy_i Txz_i Tyy_i Tyz_i Tzz_i
    % Make the tensor [3, 3] for the electrons
    Pij_e{1,1}=Txx_e; Pij_e{1,2}=Txy_e; Pij_e{1,3}=Txz_e;
    Pij_e{2,1}=Txy_e; Pij_e{2,2}=Tyy_e; Pij_e{2,3}=Tyz_e;
    Pij_e{3,1}=Txz_e; Pij_e{3,2}=Tyz_e; Pij_e{3,3}=Tzz_e;
    clearvars Txx_e Txy_e Txz_e Tyy_e Tyz_e Tzz_e
    %--------------------------------------------------------------------------
    % Make the tensor [3, 3] for the ions
    Pij_i_ba{1,1}=Txx_i_ba; Pij_i_ba{1,2}=Txy_i_ba; Pij_i_ba{1,3}=Txz_i_ba;
    Pij_i_ba{2,1}=Txy_i_ba; Pij_i_ba{2,2}=Tyy_i_ba; Pij_i_ba{2,3}=Tyz_i_ba;
    Pij_i_ba{3,1}=Txz_i_ba; Pij_i_ba{3,2}=Tyz_i_ba; Pij_i_ba{3,3}=Tzz_i_ba;
    clearvars Txx_i_ba Txy_i_ba Txz_i_ba Tyy_i_ba Tyz_i_ba Tzz_i_ba
    % Make the tensor [3, 3] for the electrons
    Pij_e_ba{1,1}=Txx_e_ba; Pij_e_ba{1,2}=Txy_e_ba; Pij_e_ba{1,3}=Txz_e_ba;
    Pij_e_ba{2,1}=Txy_e_ba; Pij_e_ba{2,2}=Tyy_e_ba; Pij_e_ba{2,3}=Tyz_e_ba;
    Pij_e_ba{3,1}=Txz_e_ba; Pij_e_ba{3,2}=Tyz_e_ba; Pij_e_ba{3,3}=Tzz_e_ba;
    clearvars Txx_e_ba Txy_e_ba Txz_e_ba Tyy_e_ba Tyz_e_ba Tzz_e_ba
    %--------------------------------------------------------------------------
    % Make the tensor [3, 3] for the ions
    Pij_i_up{1,1}=Txx_i_up; Pij_i_up{1,2}=Txy_i_up; Pij_i_up{1,3}=Txz_i_up;
    Pij_i_up{2,1}=Txy_i_up; Pij_i_up{2,2}=Tyy_i_up; Pij_i_up{2,3}=Tyz_i_up;
    Pij_i_up{3,1}=Txz_i_up; Pij_i_up{3,2}=Tyz_i_up; Pij_i_up{3,3}=Tzz_i_up;
    clearvars Txx_i_up Txy_i_up Txz_i_up Tyy_i_up Tyz_i_up Tzz_i_up
    % Make the tensor [3, 3] for the electrons
    Pij_e_up{1,1}=Txx_e_up; Pij_e_up{1,2}=Txy_e_up; Pij_e_up{1,3}=Txz_e_up;
    Pij_e_up{2,1}=Txy_e_up; Pij_e_up{2,2}=Tyy_e_up; Pij_e_up{2,3}=Tyz_e_up;
    Pij_e_up{3,1}=Txz_e_up; Pij_e_up{3,2}=Tyz_e_up; Pij_e_up{3,3}=Tzz_e_up;
    clearvars Txx_e_up Txy_e_up Txz_e_up Tyy_e_up Tyz_e_up Tzz_e_up

    % This is to get the central momment pressure.
    %------------------------------------------------------------------
    PPij_i=cell(3,3);
    PPij_e=cell(3,3);
    PPij_i_ba=cell(3,3);
    PPij_e_ba=cell(3,3);
    PPij_i_up=cell(3,3);
    PPij_e_up=cell(3,3);
    for i=1:3
        for j=1:3
            if(isempty(Pij_i{i,j}) == 1)
                continue
            end
            PPij_i{i,j} = Pij_i{i,j} - n_i{1,1}.*mi.*v_i{1,i}.*v_i{1,j};
            PPij_e{i,j} = Pij_e{i,j} - n_e{1,1}.*me.*v_e{1,i}.*v_e{1,j};
            PPij_i_ba{i,j} = Pij_i_ba{i,j} - n_i_ba{1,1}.*mi.*v_i_ba{1,i}.*v_i_ba{1,j};
            PPij_e_ba{i,j} = Pij_e_ba{i,j} - n_e_ba{1,1}.*me.*v_e_ba{1,i}.*v_e_ba{1,j};
            PPij_i_up{i,j} = Pij_i_up{i,j} - n_i_up{1,1}.*mi.*v_i_up{1,i}.*v_i_up{1,j};
            PPij_e_up{i,j} = Pij_e_up{i,j} - n_e_up{1,1}.*me.*v_e_up{1,i}.*v_e_up{1,j};
        end
    end

    % This is just to rename the variable
    Pij_i = PPij_i;
    Pij_e = PPij_e;
    Pij_i_ba = PPij_i_ba;
    Pij_e_ba = PPij_e_ba;
    Pij_i_up = PPij_i_up;
    Pij_e_up = PPij_e_up;

    clearvars PPij_i PPij_i_ba PPij_i_up
    clearvars PPij_e PPij_e_ba PPij_e_up

    clearvars n_i_up n_e_up n_i_ba n_e_ba n_i n_e
    clearvars v_i_up v_e_up v_i_ba v_e_ba v_i v_e

    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    % Computing the thermal energy densities average
    %----------------------------------------------------------------------

    Ue_th = (1/3).*( Pij_e{1,1} + Pij_e{2,2} + Pij_e{2,2} ) ;
    Udum = Ue_th;   
    Udum_mean_i = sum(Udum,'all')/s_Uem;
    Udum2_mean_i = sum((Udum.^2),'all')/s_Uem;
    Udum_std_i = sqrt(Udum2_mean_i - Udum_mean_i.^2);  
    Ue_th_mean(1,jn) = Udum_mean_i; %<--
    Ue_th_std(1,jn) = Udum_std_i; %<--
    clearvars Udum_mean_i Udum_std_i Udum Ue_th;  

    Ui_th = (1/3).*( Pij_i{1,1} + Pij_i{2,2} + Pij_i{2,2} ) ;
    Udum = Ui_th;   
    Udum_mean_i = sum(Udum,'all')/s_Uem;
    Udum2_mean_i = sum((Udum.^2),'all')/s_Uem;
    Udum_std_i = sqrt(Udum2_mean_i - Udum_mean_i.^2);  
    Ui_th_mean(1,jn) = Udum_mean_i; %<--
    Ui_th_std(1,jn) = Udum_std_i; %<--
    clearvars Udum_mean_i Udum_std_i Udum Ui_th;

    Ue_ba_th = (1/3).*( Pij_e_ba{1,1} + Pij_e_ba{2,2} + Pij_e_ba{2,2} ) ;
    Udum = Ue_ba_th;   
    Udum_mean_i = sum(Udum,'all')/s_Uem;
    Udum2_mean_i = sum((Udum.^2),'all')/s_Uem;
    Udum_std_i = sqrt(Udum2_mean_i - Udum_mean_i.^2);  
    Ue_th_ba_mean(1,jn) = Udum_mean_i; %<--
    Ue_th_ba_std(1,jn) = Udum_std_i; %<--
    clearvars Udum_mean_i Udum_std_i Udum Ue_ba_th;

    Ui_ba_th = (1/3).*( Pij_i_ba{1,1} + Pij_i_ba{2,2} + Pij_i_ba{2,2} ) ;
    Udum = Ui_ba_th;   
    Udum_mean_i = sum(Udum,'all')/s_Uem;
    Udum2_mean_i = sum((Udum.^2),'all')/s_Uem;
    Udum_std_i = sqrt(Udum2_mean_i - Udum_mean_i.^2);  
    Ui_th_ba_mean(1,jn) = Udum_mean_i; %<--
    Ui_th_ba_std(1,jn) = Udum_std_i; %<--
    clearvars Udum_mean_i Udum_std_i Udum Ui_ba_th; 

    Ue_up_th = (1/3).*( Pij_e_up{1,1} + Pij_e_up{2,2} + Pij_e_up{2,2} ) ;
    Udum = Ue_up_th;   
    Udum_mean_i = sum(Udum,'all')/s_Uem;
    Udum2_mean_i = sum((Udum.^2),'all')/s_Uem;
    Udum_std_i = sqrt(Udum2_mean_i - Udum_mean_i.^2);  
    Ue_th_up_mean(1,jn) = Udum_mean_i; %<--
    Ue_th_up_std(1,jn) = Udum_std_i; %<--
    clearvars Udum_mean_i Udum_std_i Udum Ue_up_th

    Ui_up_th = (1/3).*( Pij_i_up{1,1} + Pij_i_up{2,2} + Pij_i_up{2,2} ) ;
    Udum = Ui_up_th;   
    Udum_mean_i = sum(Udum,'all')/s_Uem;
    Udum2_mean_i = sum((Udum.^2),'all')/s_Uem;
    Udum_std_i = sqrt(Udum2_mean_i - Udum_mean_i.^2);  
    Ui_th_up_mean(1,jn) = Udum_mean_i; %<--
    Ui_th_up_std(1,jn) = Udum_std_i; %<--
    clearvars Udum_mean_i Udum_std_i Udum Ui_up_th

    clearvars Pij_i Pij_i_ba Pij_i_up
    clearvars Pij_e Pij_e_ba Pij_e_up

     cd(path)
    save('energy_densities_base_pinch_over.mat',...
        'Ui_th_up_mean','Ui_th_ba_mean','Ui_th_mean','Ue_th_up_mean','Ue_th_ba_mean','Ue_th_mean',...
        'Ui_th_up_std','Ui_th_ba_std','Ui_th_std','Ue_th_up_std','Ue_th_ba_std','Ue_th_std',...
        'Ui_k_up_mean','Ui_k_ba_mean','Ui_k_mean','Ue_k_up_mean','Ue_k_ba_mean','Ue_k_mean',...
        'Ui_k_up_std','Ui_k_ba_std','Ui_k_std','Ue_k_up_std','Ue_k_ba_std','Ue_k_std',...
        'U_em_mean','U_em_std',...        
        'time_t_2')

end

 cd(path)
    save('energy_densities_base_pinch.mat',...
        'Ui_th_up_mean','Ui_th_ba_mean','Ui_th_mean','Ue_th_up_mean','Ue_th_ba_mean','Ue_th_mean',...
        'Ui_th_up_std','Ui_th_ba_std','Ui_th_std','Ue_th_up_std','Ue_th_ba_std','Ue_th_std',...
        'Ui_k_up_mean','Ui_k_ba_mean','Ui_k_mean','Ue_k_up_mean','Ue_k_ba_mean','Ue_k_mean',...
        'Ui_k_up_std','Ui_k_ba_std','Ui_k_std','Ue_k_up_std','Ue_k_ba_std','Ue_k_std',...
        'U_em_mean','U_em_std',...        
        'time_t_2')
   
 
    cd(path_1)
    ene=load('energy_densities_base_pinch.mat');

    cd(path_2)
    ene_lange=load('energy_densities_base_pinch_lange.mat');

%--------------------------------------------------------------------------    

% Loading files to compare
%--------------------------------------------------------------------------
    path_1 = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison/comparing_energies';
    path=path_1;
    cd(path_1)

    ene1=load('psc_harris_yz_base_2_alone_large.mat');
    ene2=load('psc_harris_yz_cpinch_sSR.mat');
    ene3=load('psc_harris_yz_cpinch_sSR_lange.mat');
    
    ene4=load('psc_harris_yz_lange_many_Ax_large_L4di_Bg01.mat');

    ene5=load('psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kLd1.mat');
    ene6=load('psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kLr1.mat');
    ene7=load('psc_harris_yz_lange_many_Ax_large_L4di_dB01_omp1_kLd1.mat');
    ene8=load('psc_harris_yz_lange_many_Ax_large_L4di_dB01_omp1_kLr1.mat');    

    ene9=load('psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kd1.mat'); %dB01
    ene10=load('psc_harris_yz_lange_many_Ax_large_L4di_dB04_Omc1_kd1.mat');
    ene11=load('psc_harris_yz_lange_many_Ax_large_L4di_dB08_Omc1_kd1.mat');%dB08

    %psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1 % this looks like E
    %psc_harris_yz_lange_many_Ax_large_L4di_dB08_Omc1 % this wavy in the e)

%--------------------------------------------------------------------------

% Making the ebergy plots
%--------------------------------------------------------------------------
% from  https://yoshke.org/blog/colorblind-friendly-diagrams
C = {[0/255, 0/255, 0/255],...
    [230/255, 159/255, 0/255],...
    [86/255, 180/255, 233/255],...
    [0/255, 158/255, 115/255],...
    [240/255, 228/255, 66/255],...
    [0/255, 114/255, 178/255],...
    [213/255, 94/255, 0/255],...
    [204/255, 121/255, 167/255]};
%----------------------------------------------------------------------

% Plot with stds
% %----------------------------------------------------------------------
% fs=18; x0=45;y0=54;xx1=810;yy1=710;
% f2=figure(2);
% set(gcf,'position',[x0,y0,1.3*xx1,yy1/2])
% %--------------------------------------------------------------------------
% dum_p1 = U_em_mean + U_em_std;
% dum_p2 = U_em_mean - U_em_std;
% semilogy(time_t_2,dum_p1,LineWidth=2,color=C{1})
% hold on
% semilogy(time_t_2,dum_p2,LineWidth=2,color=C{1})
% x2 = [time_t_2, fliplr(time_t_2)];
% inBetween = [dum_p1, fliplr(dum_p2)];fill(x2, inBetween, C{1});
% 
% dum_p1 = (Ue_k_mean + Ue_k_std) + (Ui_k_mean + Ui_k_std);
% dum_p2 = (Ue_k_mean - Ue_k_std) + (Ui_k_mean - Ui_k_std);
% semilogy(time_t_2,dum_p1,LineWidth=2,color=C{2})
% hold on
% semilogy(time_t_2,dum_p2,LineWidth=2,color=C{2})
% x2 = [time_t_2, fliplr(time_t_2)];
% inBetween = [dum_p1, fliplr(dum_p2)];fill(x2, inBetween, C{2});
% 
% dum_p1 = (Ue_th_mean + Ue_th_std) + (Ui_th_mean + Ui_th_std);
% dum_p2 = (Ue_th_mean - Ue_th_std) + (Ui_th_mean - Ui_th_std);
% semilogy(time_t_2,dum_p1,LineWidth=2,color=C{3})
% hold on
% semilogy(time_t_2,dum_p2,LineWidth=2,color=C{3})
% x2 = [time_t_2, fliplr(time_t_2)];
% inBetween = [dum_p1, fliplr(dum_p2)];fill(x2, inBetween, C{3});
% legend('Uem', 'Uk', 'Uth','Ukup', 'Uthup')
% %--------------------------------------------------------------------------

% Plot without stds
%--------------------------------------------------------------------------
fs=18; x0=45;y0=54;xx1=810;yy1=710;
f3=figure(3);
set(gcf,'position',[x0,y0,1.3*xx1,yy1/2])
%--------------------------------------------------------------------------
dump_s=ene8;
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean + dump_s.Ue_k_mean + ...
    dump_s.Ui_k_mean + dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,LineWidth=2,color=C{1})
hold on
dum_p2 = dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,LineWidth=2,color=C{2})

dum_p2 = dump_s.Ue_k_mean + dump_s.Ui_k_mean;
semilogy(dump_s.time_t_2,dum_p2,LineWidth=2,color=C{3})

dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean;
semilogy(dump_s.time_t_2,dum_p2,LineWidth=2,color=C{4})

legend('$$\varepsilon_{T}$$','$$\varepsilon_{em}$$',...
    '$$\varepsilon_{k}$$','$$\varepsilon_{th}$$','Interpreter','latex','FontSize',1.0*fs,'Location','southeast','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\langle \varepsilon \rangle$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{ce}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
%ylim([1e-6 1e-1]);
xlim([0 350]);
hold off
%--------------------------------------------------------------------------
cd(path)
saveas(f3,strcat(num2str(dump_s.time_t_2(end)),'Energy_density_pinch.png'));


% Plot alone, base pinch, many Bg01
%--------------------------------------------------------------------------
fs=18; x0=45;y0=54;xx1=810;yy1=710;
f32=figure(34);
set(gcf,'position',[x0,y0,1.3*xx1,yy1/2])
%--------------------------------------------------------------------------
dump_s=ene1;
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean + dump_s.Ue_k_mean + ...
    dump_s.Ui_k_mean + dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,'-',LineWidth=2,color=C{1})
hold on
dum_p2 = dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,'-',LineWidth=2,color=C{2})
dum_p2 = dump_s.Ue_k_mean + dump_s.Ui_k_mean;
semilogy(dump_s.time_t_2,dum_p2,'-',LineWidth=2,color=C{3})
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean;
semilogy(dump_s.time_t_2,dum_p2,'-',LineWidth=2,color=C{4})

dump_s=ene2;
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean + dump_s.Ue_k_mean + ...
    dump_s.Ui_k_mean + dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,':',LineWidth=2,color=C{1})
dum_p2 = dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,':',LineWidth=2,color=C{2})
dum_p2 = dump_s.Ue_k_mean + dump_s.Ui_k_mean;
semilogy(dump_s.time_t_2,dum_p2,':',LineWidth=2,color=C{3})
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean;
semilogy(dump_s.time_t_2,dum_p2,':',LineWidth=2,color=C{4})

dump_s=ene4;
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean + dump_s.Ue_k_mean + ...
    dump_s.Ui_k_mean + dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,'-.',LineWidth=2,color=C{1})
dum_p2 = dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,'-.',LineWidth=2,color=C{2})
dum_p2 = dump_s.Ue_k_mean + dump_s.Ui_k_mean;
semilogy(dump_s.time_t_2,dum_p2,'-.',LineWidth=2,color=C{3})
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean;
semilogy(dump_s.time_t_2,dum_p2,'-.',LineWidth=2,color=C{4})

legend('$$\varepsilon_{T}^{A}$$','$$\varepsilon_{em}^{A}$$',...
    '$$\varepsilon_{k}^{A}$$','$$\varepsilon_{th}^{A}$$',...
    '$$\varepsilon_{T}^{B}$$','$$\varepsilon_{em}^{B}$$',...
    '$$\varepsilon_{k}^{B}$$','$$\varepsilon_{th}^{B}$$',...
    '$$\varepsilon_{T}^{EBg01}$$','$$\varepsilon_{em}^{EBg01}$$',...
    '$$\varepsilon_{k}^{EBg01}$$','$$\varepsilon_{th}^{EBg01}$$','Interpreter','latex',...
    'FontSize',1.0*fs,'Location','southeast','NumColumns',3)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\langle \varepsilon \rangle$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{ce}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([1e-6 5]);
xlim([0 350]);
%sgtitle('$$ -- $$','Interpreter','latex','FontSize',fs)
hold off
%--------------------------------------------------------------------------
saveas(f32,strcat(num2str(dump_s.time_t_2(end)),'Energy_density_ABCEBg.png'));
%--------------------------------------------------------------------------

% Plot dB0108
%--------------------------------------------------------------------------
fs=18; x0=45;y0=54;xx1=810;yy1=710;
f33=figure(33);
set(gcf,'position',[x0,y0,1.3*xx1,yy1/2])
%--------------------------------------------------------------------------
dump_s=ene9;
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean + dump_s.Ue_k_mean + ...
    dump_s.Ui_k_mean + dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,'-',LineWidth=2,color=C{1})
hold on
dum_p2 = dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,'-',LineWidth=2,color=C{2})
dum_p2 = dump_s.Ue_k_mean + dump_s.Ui_k_mean;
semilogy(dump_s.time_t_2,dum_p2,'-',LineWidth=2,color=C{3})
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean;
semilogy(dump_s.time_t_2,dum_p2,'-',LineWidth=2,color=C{4})

dump_s=ene11;
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean + dump_s.Ue_k_mean + ...
    dump_s.Ui_k_mean + dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,':',LineWidth=2,color=C{1})
dum_p2 = dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,':',LineWidth=2,color=C{2})
dum_p2 = dump_s.Ue_k_mean + dump_s.Ui_k_mean;
semilogy(dump_s.time_t_2,dum_p2,':',LineWidth=2,color=C{3})
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean;
semilogy(dump_s.time_t_2,dum_p2,':',LineWidth=2,color=C{4})

legend('$$\varepsilon_{T}^{dB01}$$','$$\varepsilon_{em}^{dB01}$$',...
    '$$\varepsilon_{k}^{dB01}$$','$$\varepsilon_{th}^{dB01}$$',...
    '$$\varepsilon_{T}^{dB08}$$','$$\varepsilon_{em}^{dB08}$$',...
    '$$\varepsilon_{k}^{dB08}$$','$$\varepsilon_{th}^{dB08}$$','Interpreter','latex',...
    'FontSize',1.0*fs,'Location','southeast','NumColumns',2)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\langle \varepsilon \rangle$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{ce}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([1e-6 5]);
xlim([0 350]);
%sgtitle('$$ -- $$','Interpreter','latex','FontSize',fs)
hold off
%--------------------------------------------------------------------------
saveas(f33,strcat(num2str(dump_s.time_t_2(end)),'Energy_density_dB01dB08.png'));
%--------------------------------------------------------------------------


% Plot dB010408
%--------------------------------------------------------------------------
fs=18; x0=45;y0=54;xx1=810;yy1=710;
f34=figure(34);
set(gcf,'position',[x0,y0,1.3*xx1,yy1/2])
%--------------------------------------------------------------------------
dump_s=ene9;
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean + dump_s.Ue_k_mean + ...
    dump_s.Ui_k_mean + dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,'-',LineWidth=2,color=C{1})
hold on
dum_p2 = dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,'-',LineWidth=2,color=C{2})
dum_p2 = dump_s.Ue_k_mean + dump_s.Ui_k_mean;
semilogy(dump_s.time_t_2,dum_p2,'-',LineWidth=2,color=C{3})
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean;
semilogy(dump_s.time_t_2,dum_p2,'-',LineWidth=2,color=C{4})

dump_s=ene10;
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean + dump_s.Ue_k_mean + ...
    dump_s.Ui_k_mean + dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,':',LineWidth=2,color=C{1})
dum_p2 = dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,':',LineWidth=2,color=C{2})
dum_p2 = dump_s.Ue_k_mean + dump_s.Ui_k_mean;
semilogy(dump_s.time_t_2,dum_p2,':',LineWidth=2,color=C{3})
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean;
semilogy(dump_s.time_t_2,dum_p2,':',LineWidth=2,color=C{4})

dump_s=ene11;
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean + dump_s.Ue_k_mean + ...
    dump_s.Ui_k_mean + dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,'-.',LineWidth=2,color=C{1})
dum_p2 = dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,'-.',LineWidth=2,color=C{2})
dum_p2 = dump_s.Ue_k_mean + dump_s.Ui_k_mean;
semilogy(dump_s.time_t_2,dum_p2,'-.',LineWidth=2,color=C{3})
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean;
semilogy(dump_s.time_t_2,dum_p2,'-.',LineWidth=2,color=C{4})

legend('$$\varepsilon_{T}^{dB01}$$','$$\varepsilon_{em}^{dB01}$$',...
    '$$\varepsilon_{k}^{dB01}$$','$$\varepsilon_{th}^{dB01}$$',...
    '$$\varepsilon_{T}^{dB04}$$','$$\varepsilon_{em}^{dB04}$$',...
    '$$\varepsilon_{k}^{dB04}$$','$$\varepsilon_{th}^{dB04}$$',...
    '$$\varepsilon_{T}^{dB08}$$','$$\varepsilon_{em}^{dB08}$$',...
    '$$\varepsilon_{k}^{dB08}$$','$$\varepsilon_{th}^{dB08}$$','Interpreter','latex',...
    'FontSize',1.0*fs,'Location','southeast','NumColumns',3)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\langle \varepsilon \rangle$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{ce}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([1e-6 5]);
xlim([0 350]);
%sgtitle('$$ -- $$','Interpreter','latex','FontSize',fs)
hold off
%--------------------------------------------------------------------------
saveas(f34,strcat(num2str(dump_s.time_t_2(end)),'Energy_density_dB0104dB08.png'));
%--------------------------------------------------------------------------

%plot de rho Omegas
%--------------------------------------------------------------------------
fs=18; x0=45;y0=54;xx1=810;yy1=710;
f35=figure(35);
set(gcf,'position',[x0,y0,1.3*xx1,yy1/2])
%--------------------------------------------------------------------------
dump_s=ene5;
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean + dump_s.Ue_k_mean + ...
    dump_s.Ui_k_mean + dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,'-',LineWidth=2,color=C{1})
hold on
dum_p2 = dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,'-',LineWidth=2,color=C{2})
dum_p2 = dump_s.Ue_k_mean + dump_s.Ui_k_mean;
semilogy(dump_s.time_t_2,dum_p2,'-',LineWidth=2,color=C{3})
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean;
semilogy(dump_s.time_t_2,dum_p2,'-',LineWidth=2,color=C{4})

dump_s=ene6;
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean + dump_s.Ue_k_mean + ...
    dump_s.Ui_k_mean + dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,':',LineWidth=2,color=C{1})
dum_p2 = dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,':',LineWidth=2,color=C{2})
dum_p2 = dump_s.Ue_k_mean + dump_s.Ui_k_mean;
semilogy(dump_s.time_t_2,dum_p2,':',LineWidth=2,color=C{3})
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean;
semilogy(dump_s.time_t_2,dum_p2,':',LineWidth=2,color=C{4})

dump_s=ene7;
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean + dump_s.Ue_k_mean + ...
    dump_s.Ui_k_mean + dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,'-.',LineWidth=2,color=C{1})
dum_p2 = dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,'-.',LineWidth=2,color=C{2})
dum_p2 = dump_s.Ue_k_mean + dump_s.Ui_k_mean;
semilogy(dump_s.time_t_2,dum_p2,'-.',LineWidth=2,color=C{3})
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean;
semilogy(dump_s.time_t_2,dum_p2,'-.',LineWidth=2,color=C{4})

dump_s=ene8;
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean + dump_s.Ue_k_mean + ...
    dump_s.Ui_k_mean + dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,'--',LineWidth=2,color=C{1})
dum_p2 = dump_s.U_em_mean;
semilogy(dump_s.time_t_2,dum_p2,'--',LineWidth=2,color=C{2})
dum_p2 = dump_s.Ue_k_mean + dump_s.Ui_k_mean;
semilogy(dump_s.time_t_2,dum_p2,'--',LineWidth=2,color=C{3})
dum_p2 = dump_s.Ue_th_mean + dump_s.Ui_th_mean;
semilogy(dump_s.time_t_2,dum_p2,'--',LineWidth=2,color=C{4})

legend('$$\varepsilon_{T}^{\Omega_{c}d_{e}}$$','$$\varepsilon_{em}^{\Omega_{c}d_{e}}$$',...
    '$$\varepsilon_{k}^{\Omega_{c}d_{e}}$$','$$\varepsilon_{th}^{\Omega_{c}d_{e}}$$',...
    '$$\varepsilon_{T}^{\Omega_{c}\rho_{e}}$$','$$\varepsilon_{em}^{\Omega_{c}\rho_{e}}$$',...
    '$$\varepsilon_{k}^{\Omega_{c}\rho_{e}}$$','$$\varepsilon_{th}^{\Omega_{c}\rho_{e}}$$',...
    '$$\varepsilon_{T}^{\omega_{p}d_{e}}$$','$$\varepsilon_{em}^{\omega_{p}d_{e}}$$',...
    '$$\varepsilon_{k}^{\omega_{p}d_{e}}$$','$$\varepsilon_{th}^{\omega_{p}d_{e}}$$',...
    '$$\varepsilon_{T}^{\omega_{p}\rho_{e}}$$','$$\varepsilon_{em}^{\omega_{p}\rho_{e}}$$',...
    '$$\varepsilon_{k}^{\omega_{p}\rho_{e}}$$','$$\varepsilon_{th}^{\omega_{p}\rho_{e}}$$','Interpreter','latex',...
    'FontSize',1.0*fs,'Location','southeast','NumColumns',4)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\langle \varepsilon \rangle$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{ce}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([1e-6 5]);
xlim([0 350]);
%sgtitle('$$ -- $$','Interpreter','latex','FontSize',fs)
hold off
%--------------------------------------------------------------------------
saveas(f35,strcat(num2str(dump_s.time_t_2(end)),'Energy_density_OcdOcropdopr.png'));
%--------------------------------------------------------------------------