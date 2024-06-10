% Computing the time average quantities for the reconnecion electric field.


%----------------------------------------------------------------------
path_1 = '/Volumes/Perlmutterdata/tmp_jeff/psc_lower_hybrid_mime100';

path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
%----------------------------------------------------------------------

% Factors to change along this file depending on the case
%----------------------------------------------------------------------
% Try smoothing the variables before comuping any further.
% IT IS IMPORTANT TO KEEP THIS IN MIND AT ALL TIMES!!!
%----------------------------------------------------------------------
sigma_g = 1; % this is for the smoothing. This gets read of fast frequencies
dab = 0; % this needs to be related to the gyro frequency or something
UP_BA = 0;
IS_2D = 0;

grad_fact = 2; % This always need to be two!!!

mime = 100.;
omega_pe_Omega_ce = 10;
nb_n0 =0.1;
%T=(beta/2)B^2, Thus, as beta=1
T0=0.02;%0.02;

frac = 0.8;

B0 = 1/omega_pe_Omega_ce;
n0 = 1;

Vae = 1/omega_pe_Omega_ce;
Vai = Vae*sqrt(1/mime); 
c=1; VA2c = Vai;

%E = vB, as B0=0.1 and v in units of c, E0= B0*Vai/c
E0=B0;

%The current density J0=1?
J0=Vae;
Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);

kb = 1.;
mu0 =1.;

q = 1;
mi = 1.;
me = 1. / mime; eps0=1.;
omega_pi=1;
Omega_e=Vai*sqrt(mime)*omega_pi;
Omega_i=Omega_e / mime;
TOmega_e=1/Omega_e;
TOmega_i=1/Omega_i;
%--------------------------------------------------------------------------


JN=40;
sli_y = 512; sli_z = 452; 

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

%--------------------------------------------------------------------------
in=1;
fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;
B=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
ss=size(B);
LXs=ss(1); LYs=ss(2); LZs=ss(3);
%--------------------------------------------------------------------------
nx1=1;    nx2=LXs;
ny1=1;    ny2=LYs;
nz1=1;    nz2=LZs;

px2 = nx2/4; py2 = ny2; pz2 = nz2;
start = [nx1 ny1 nz1];
count = [px2 py2 pz2];

clearvars B
N_jn=N; %This is to store some but not all the time steps
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% allocate space for the energies
%--------------------------------------------------------------------------

%time_t_2=zeros(1,N_jn);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%JN=106; % This is the center of the interval for the time average

jn=JN;
jjn=4;

if dab ~= 0
j_a = JN - dab;
j_b = JN + dab;
j_a_b = j_b - j_a;
elseif dab ==0
j_a = 1;
j_b = 1;
j_a_b =1;
end
%--------------------------------------------------------------------------
E_in = cell(3,j_a_b);
B_in = cell(3,j_a_b);
J_in = cell(3,j_a_b);
n_in = cell(3,j_a_b);
v_i_in = cell(3,j_a_b);
v_e_in = cell(3,j_a_b);
v_in = cell(3,j_a_b);
Pij_i_in = cell(6,j_a_b);
Pij_e_in = cell(6,j_a_b);

n_i_vi_in = cell(3,j_a_b);
n_e_ve_in = cell(3,j_a_b);
n_v_in = cell(3,j_a_b);

ni_vi_x_B_in = cell(3,j_a_b);
ne_ve_x_B_in = cell(3,j_a_b);
n_v_x_B_in = cell(3,j_a_b);

ni_vivi_in = cell(6,j_a_b);
ne_veve_in = cell(6,j_a_b);
n_vv_in = cell(6,j_a_b);

jn=11

%--------------------------------------------------------------------------
B0=1;   E0=1;   J0=1;   pi0=1;  pe0=1;  ni0=1;  ne0=1; Ti0=1;   Te0=1;
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%for jn=j_a:j_b
for jn=11:11    
    %for jn=1:N
    %----------------------------------------------------------------------
    in = jn;
    %jjn = jn;
    %----------------------------------------------------------------------
    %for jn=2:floor(N/10)
    %    in=(jn-1)*jn;
    % %     in=2 + floor(N*(jn-1)/10);
    %----------------------------------------------------------------------
    disp(strcat('Computing step ...',S(in).name))
    fileID =  S(in).name; %change the 1 per i
    %h5disp(fileID);
    info = h5info(fileID);
    EHJ_1st = info.Groups(16).Name;
    %----------------------------------------------------------------------
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

    %----------------------------------------------------------------------
    str = string(S(in).name);
    newStr = extractBetween(str,"pfd.","_p000000.h5");
    N_steps = str2double(newStr);
    time_t = dt*N_steps;
    time_t_2_Omega=time_t./omega_pe_Omega_ce;
    time_t_2(1,in)=time_t_2_Omega;
    %----------------------------------------------------------------------

    %To make the coordinate transformation
    %----------------------------------------------------------------------
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
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    disp(strcat('Computing step ...',S2(jjn).name))
    fileID2 =  S2(jjn).name; %change the 1 per i
    %h5disp(fileID2);
    info2 = h5info(fileID2);
    moments_1st = info2.Groups(1).Name;
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    B{1,1} = h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'),start,count)./B0;
    B{1,2}=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'),start,count)./B0;
    B{1,3}=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'),start,count)./B0;

    E{1,1}=h5read(fileID,strcat(EHJ_1st,'/ex_ec/p0/3d'),start,count)./E0;
    E{1,2}=h5read(fileID,strcat(EHJ_1st,'/ey_ec/p0/3d'),start,count)./E0;
    E{1,3}=h5read(fileID,strcat(EHJ_1st,'/ez_ec/p0/3d'),start,count)./E0;

    J{1,1}=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'),start,count)./J0;
    J{1,2}=h5read(fileID,strcat(EHJ_1st,'/jy_ec/p0/3d'),start,count)./J0;
    J{1,3}=h5read(fileID,strcat(EHJ_1st,'/jz_ec/p0/3d'),start,count)./J0;
    %----------------------------------------------------------------------
    

    % This is considering the electron current only.
    %----------------------------------------------------------------------
    % if UP_BA==1
    %     J_up{1,1}=h5read(fileID2,strcat(moments_1st,'/jx_e_UP/p0/3d'),start,count)./J0;
    %     J_up{1,2}=h5read(fileID2,strcat(moments_1st,'/jy_e_UP/p0/3d'),start,count)./J0;
    %     J_up{1,3}=h5read(fileID2,strcat(moments_1st,'/jz_e_UP/p0/3d'),start,count)./J0;
    %     J_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/jx_e_BA/p0/3d'),start,count)./J0;
    %     J_ba{1,2}=h5read(fileID2,strcat(moments_1st,'/jy_e_BA/p0/3d'),start,count)./J0;
    %     J_ba{1,3}=h5read(fileID2,strcat(moments_1st,'/jz_e_BA/p0/3d'),start,count)./J0;
    %     J{1,1}=(J_up{1,1}+J_ba{1,1})./1;
    %     J{1,2}=(J_up{1,2}+J_ba{1,2})./1;
    %     J{1,3}=(J_up{1,3}+J_ba{1,3})./1;
    %     clearvars J_ba J_up
    % elseif UP_BA==0
    %     J{1,1}=h5read(fileID2,strcat(moments_1st,'/jx_e_UP/p0/3d'),start,count)./J0;
    %     J{1,2}=h5read(fileID2,strcat(moments_1st,'/jy_e_UP/p0/3d'),start,count)./J0;
    %     J{1,3}=h5read(fileID2,strcat(moments_1st,'/jz_e_UP/p0/3d'),start,count)./J0;
    % end
    %----------------------------------------------------------------------


    % here is where I chose the values for the 1D cuts
    %----------------------------------------------------------------------
    ssz=size(B{1,1});
    sli_x = 1; %floor(4+ssz(1)/2);%1;
    %----------------------------------------------------------------------
    Ex = E{1,1};
    Ey = E{1,2};
    Ez = E{1,3};

    Bx = B{1,1};
    By = B{1,2};
    Bz = B{1,3};

    Jx = J{1,1};
    Jy = J{1,2};
    Jz = J{1,3};
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    clearvars E B J
    %----------------------------------------------------------------------

    % Loading the data for the bulk speed of the particles
    %----------------------------------------------------------------------
    if UP_BA == 1
        p_e_up{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e_UP/p0/3d'),start,count)./pe0;
        p_e_up{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e_UP/p0/3d'),start,count)./pe0;
        p_e_up{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e_UP/p0/3d'),start,count)./pe0;

        p_i_up{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i_UP/p0/3d'),start,count)./pi0;
        p_i_up{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i_UP/p0/3d'),start,count)./pi0;
        p_i_up{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i_UP/p0/3d'),start,count)./pi0;

        p_e_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e_BA/p0/3d'),start,count)./pe0;
        p_e_ba{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e_BA/p0/3d'),start,count)./pe0;
        p_e_ba{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e_BA/p0/3d'),start,count)./pe0;

        p_i_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i_BA/p0/3d'),start,count)./pi0;
        p_i_ba{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i_BA/p0/3d'),start,count)./pi0;
        p_i_ba{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i_BA/p0/3d'),start,count)./pi0;
    elseif UP_BA == 0
        p_e{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e_UP/p0/3d'),start,count)./pe0;
        p_e{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e_UP/p0/3d'),start,count)./pe0;
        p_e{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e_UP/p0/3d'),start,count)./pe0;

        p_i{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i_UP/p0/3d'),start,count)./pi0;
        p_i{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i_UP/p0/3d'),start,count)./pi0;
        p_i{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i_UP/p0/3d'),start,count)./pi0;
    end


    % densities
    %----------------------------------------------------------------------
    if UP_BA == 1
        n_e_up0=h5read(fileID2,strcat(moments_1st,'/rho_e_UP/p0/3d'),start,count)./ne0;
        n_i_up0=h5read(fileID2,strcat(moments_1st,'/rho_i_UP/p0/3d'),start,count)./ni0;
        n_e_up0=-1.*n_e_up0;
        n_e_ba0=h5read(fileID2,strcat(moments_1st,'/rho_e_BA/p0/3d'),start,count)./ne0;
        n_i_ba0=h5read(fileID2,strcat(moments_1st,'/rho_i_BA/p0/3d'),start,count)./ni0;
        n_e_ba0=-1.*n_e_ba0;
        n_e0=(n_e_up0 + n_e_ba0)./1;
        n_i0=(n_i_up0 + n_i_ba0)./1;
    elseif UP_BA == 0
        n_e0=h5read(fileID2,strcat(moments_1st,'/rho_e_UP/p0/3d'),start,count)./ne0;
        n_i0=h5read(fileID2,strcat(moments_1st,'/rho_i_UP/p0/3d'),start,count)./ni0;
        n_e0=-1.*n_e0;
    end
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    if UP_BA == 1
        n_e0(n_e0==0)=1e-20;
        n_i0(n_i0==0)=1e-20;
        n_e_up0(n_e_up0==0)=1e-20;
        n_i_up0(n_i_up0==0)=1e-20;
        n_e_ba0(n_e_ba0==0)=1e-20;
        n_i_ba0(n_i_ba0==0)=1e-20;
    elseif UP_BA == 0
        n_e0(n_e0==0)=1e-20;
        n_i0(n_i0==0)=1e-20;
    end
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------

    if UP_BA == 1
        n_e_up{1,1} = n_e_up0;
        n_i_up{1,1} = n_i_up0;
        n_e_ba{1,1} = n_e_ba0;
        n_i_ba{1,1} = n_i_ba0;
        n_e{1,1} = n_e0;
        n_i{1,1} = n_i0;
    elseif UP_BA == 0
        n_e{1,1} = n_e0;
        n_i{1,1} = n_i0;
    end
    %----------------------------------------------------------------------

    % p correction so it is not nv anymore but just v
    %----------------------------------------------------------------------

    if UP_BA == 1

        p_e_up{1,1}=p_e_up{1,1}./n_e_up{1,1};
        p_e_up{1,2}=p_e_up{1,2}./n_e_up{1,1};
        p_e_up{1,3}=p_e_up{1,3}./n_e_up{1,1};

        p_i_up{1,1}=p_i_up{1,1}./n_i_up{1,1};
        p_i_up{1,2}=p_i_up{1,2}./n_i_up{1,1};
        p_i_up{1,3}=p_i_up{1,3}./n_i_up{1,1};

        p_e_ba{1,1}=p_e_ba{1,1}./n_e_ba{1,1};
        p_e_ba{1,2}=p_e_ba{1,2}./n_e_ba{1,1};
        p_e_ba{1,3}=p_e_ba{1,3}./n_e_ba{1,1};

        p_i_ba{1,1}=p_i_ba{1,1}./n_i_ba{1,1};
        p_i_ba{1,2}=p_i_ba{1,2}./n_i_ba{1,1};
        p_i_ba{1,3}=p_i_ba{1,3}./n_i_ba{1,1};

    elseif UP_BA == 0
        p_e{1,1}=p_e{1,1}./n_e{1,1};
        p_e{1,2}=p_e{1,2}./n_e{1,1};
        p_e{1,3}=p_e{1,3}./n_e{1,1};
        p_i{1,1}=p_i{1,1}./n_i{1,1};
        p_i{1,2}=p_i{1,2}./n_i{1,1};
        p_i{1,3}=p_i{1,3}./n_i{1,1};
    end
    %----------------------------------------------------------------------


    % %----------------------------------------------------------------------
    % p_e_up{1,1}=fillmissing(p_e_up{1,1}, 'linear');
    % %----------------------------------------------------------------------

    % this has to be here because it is after the correction dividing by n
    %----------------------------------------------------------------------
    if UP_BA == 1
        p_e{1,1}=(p_e_up{1,1} + p_e_ba{1,1})./1;
        p_e{1,2}=(p_e_up{1,2} + p_e_ba{1,2})./1;
        p_e{1,3}=(p_e_up{1,3} + p_e_ba{1,3})./1;

        p_i{1,1}=(p_i_up{1,1} + p_i_ba{1,1})./1;
        p_i{1,2}=(p_i_up{1,2} + p_i_ba{1,2})./1;
        p_i{1,3}=(p_i_up{1,3} + p_i_ba{1,3})./1;
    end
    %----------------------------------------------------------------------

    %clearvars p_i_up p_e_up p_i_ba p_e_ba
    %----------------------------------------------------------------------

    % computing the velocities in units of c
    %----------------------------------------------------------------------

    if UP_BA == 1
        v_e=cell(1,3);
        v_i=cell(1,3);
        v_e_up=cell(1,3);
        v_i_up=cell(1,3);
        v_e_ba=cell(1,3);
        v_i_ba=cell(1,3);
        for i=1:3
            v_e{1,i} = (p_e{1,i} .* c ./ sqrt(c^2 .* me^2 + p_e{1,i}.^2))./1; % Do I need to do this normalization by VA2c
            v_i{1,i} = (p_i{1,i} .* c ./ sqrt(c^2 .* mi^2 + p_i{1,i}.^2))./1;
            v_e_up{1,i} = (p_e_up{1,i} .* c ./ sqrt(c^2 .* me^2 + p_e_up{1,i}.^2))./1;
            v_i_up{1,i} = (p_i_up{1,i} .* c ./ sqrt(c^2 .* mi^2 + p_i_up{1,i}.^2))./1;
            v_e_ba{1,i} = (p_e_ba{1,i} .* c ./ sqrt(c^2 .* me^2 + p_e_ba{1,i}.^2))./1;
            v_i_ba{1,i} = (p_i_ba{1,i} .* c ./ sqrt(c^2 .* mi^2 + p_i_ba{1,i}.^2))./1;
        end
        clearvars p_i p_e p_i_up p_e_up p_i_ba p_e_ba
    elseif UP_BA == 0
        v_e=cell(1,3);
        v_i=cell(1,3);
        for i=1:3
            v_e{1,i} = (p_e{1,i} .* c ./ sqrt(c^2 .* me^2 + p_e{1,i}.^2))./1; % Do I need to do this normalization by VA2c
            v_i{1,i} = (p_i{1,i} .* c ./ sqrt(c^2 .* mi^2 + p_i{1,i}.^2))./1;
        end
        clearvars p_i p_e
    end
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    v_ex = v_e{1,1};
    v_ey = v_e{1,2};
    v_ez = v_e{1,3};

    v_ix = v_i{1,1};
    v_iy = v_i{1,2};
    v_iz = v_i{1,3};

    if UP_BA == 1
        v_i_upx = v_i_up{1,1};
        v_i_upy = v_i_up{1,2};
        v_i_upz = v_i_up{1,3};

        v_e_upx = v_e_up{1,1};
        v_e_upy = v_e_up{1,2};
        v_e_upz = v_e_up{1,3};

        v_e_bax = v_e_ba{1,1};
        v_e_bay = v_e_ba{1,2};
        v_e_baz = v_e_ba{1,3};

        v_i_bax = v_i_ba{1,1};
        v_i_bay = v_i_ba{1,2};
        v_i_baz = v_i_ba{1,3};
    end

    %clearvars v_i_up v_e_up v_i_ba v_e_ba %<----


    %----------------------------------------------------------------------

    if UP_BA == 1
        Txx_e_up=h5read(fileID2,strcat(moments_1st,'/txx_e_UP/p0/3d'),start,count)./Te0;
        Tyy_e_up=h5read(fileID2,strcat(moments_1st,'/tyy_e_UP/p0/3d'),start,count)./Te0;
        Tzz_e_up=h5read(fileID2,strcat(moments_1st,'/tzz_e_UP/p0/3d'),start,count)./Te0;
        Txy_e_up=h5read(fileID2,strcat(moments_1st,'/txy_e_UP/p0/3d'),start,count)./Te0;
        Txz_e_up=h5read(fileID2,strcat(moments_1st,'/tzx_e_UP/p0/3d'),start,count)./Te0;
        Tyz_e_up=h5read(fileID2,strcat(moments_1st,'/tyz_e_UP/p0/3d'),start,count)./Te0;

        Txx_i_up=h5read(fileID2,strcat(moments_1st,'/txx_i_UP/p0/3d'),start,count)./Ti0;
        Tyy_i_up=h5read(fileID2,strcat(moments_1st,'/tyy_i_UP/p0/3d'),start,count)./Ti0;
        Tzz_i_up=h5read(fileID2,strcat(moments_1st,'/tzz_i_UP/p0/3d'),start,count)./Ti0;
        Txy_i_up=h5read(fileID2,strcat(moments_1st,'/txy_i_UP/p0/3d'),start,count)./Ti0;
        Txz_i_up=h5read(fileID2,strcat(moments_1st,'/tzx_i_UP/p0/3d'),start,count)./Ti0;
        Tyz_i_up=h5read(fileID2,strcat(moments_1st,'/tyz_i_UP/p0/3d'),start,count)./Ti0;

        Txx_e_ba=h5read(fileID2,strcat(moments_1st,'/txx_e_BA/p0/3d'),start,count)./Te0;
        Tyy_e_ba=h5read(fileID2,strcat(moments_1st,'/tyy_e_BA/p0/3d'),start,count)./Te0;
        Tzz_e_ba=h5read(fileID2,strcat(moments_1st,'/tzz_e_BA/p0/3d'),start,count)./Te0;
        Txy_e_ba=h5read(fileID2,strcat(moments_1st,'/txy_e_BA/p0/3d'),start,count)./Te0;
        Txz_e_ba=h5read(fileID2,strcat(moments_1st,'/tzx_e_BA/p0/3d'),start,count)./Te0;
        Tyz_e_ba=h5read(fileID2,strcat(moments_1st,'/tyz_e_BA/p0/3d'),start,count)./Te0;

        Txx_i_ba=h5read(fileID2,strcat(moments_1st,'/txx_i_BA/p0/3d'),start,count)./Ti0;
        Tyy_i_ba=h5read(fileID2,strcat(moments_1st,'/tyy_i_BA/p0/3d'),start,count)./Ti0;
        Tzz_i_ba=h5read(fileID2,strcat(moments_1st,'/tzz_i_BA/p0/3d'),start,count)./Ti0;
        Txy_i_ba=h5read(fileID2,strcat(moments_1st,'/txy_i_BA/p0/3d'),start,count)./Ti0;
        Txz_i_ba=h5read(fileID2,strcat(moments_1st,'/tzx_i_BA/p0/3d'),start,count)./Ti0;
        Tyz_i_ba=h5read(fileID2,strcat(moments_1st,'/tyz_i_BA/p0/3d'),start,count)./Ti0;

        Pij_i_ba=cell(3,3);
        Pij_e_ba=cell(3,3);
        Pij_i_up=cell(3,3);
        Pij_e_up=cell(3,3);
        % % %----------------------------------------------------------------------
        % Make the tensor [3, 3] for the ions
        Pij_i_ba{1,1}=Txx_i_ba; Pij_i_ba{1,2}=Txy_i_ba; Pij_i_ba{1,3}=Txz_i_ba;
        Pij_i_ba{2,1}=Txy_i_ba; Pij_i_ba{2,2}=Tyy_i_ba; Pij_i_ba{2,3}=Tyz_i_ba;
        Pij_i_ba{3,1}=Txz_i_ba; Pij_i_ba{3,2}=Tyz_i_ba; Pij_i_ba{3,3}=Tzz_i_ba;
        %clearvars Txx_i_ba Txy_i_ba Txz_i_ba Tyy_i_ba Tyz_i_ba Tzz_i_ba
        % Make the tensor [3, 3] for the electrons
        Pij_e_ba{1,1}=Txx_e_ba; Pij_e_ba{1,2}=Txy_e_ba; Pij_e_ba{1,3}=Txz_e_ba;
        Pij_e_ba{2,1}=Txy_e_ba; Pij_e_ba{2,2}=Tyy_e_ba; Pij_e_ba{2,3}=Tyz_e_ba;
        Pij_e_ba{3,1}=Txz_e_ba; Pij_e_ba{3,2}=Tyz_e_ba; Pij_e_ba{3,3}=Tzz_e_ba;
        %clearvars Txx_e_ba Txy_e_ba Txz_e_ba Tyy_e_ba Tyz_e_ba Tzz_e_ba
        %----------------------------------------------------------------------
        % Make the tensor [3, 3] for the ions
        Pij_i_up{1,1}=Txx_i_up; Pij_i_up{1,2}=Txy_i_up; Pij_i_up{1,3}=Txz_i_up;
        Pij_i_up{2,1}=Txy_i_up; Pij_i_up{2,2}=Tyy_i_up; Pij_i_up{2,3}=Tyz_i_up;
        Pij_i_up{3,1}=Txz_i_up; Pij_i_up{3,2}=Tyz_i_up; Pij_i_up{3,3}=Tzz_i_up;
        %clearvars Txx_i_up Txy_i_up Txz_i_up Tyy_i_up Tyz_i_up Tzz_i_up
        % Make the tensor [3, 3] for the electrons
        Pij_e_up{1,1}=Txx_e_up; Pij_e_up{1,2}=Txy_e_up; Pij_e_up{1,3}=Txz_e_up;
        Pij_e_up{2,1}=Txy_e_up; Pij_e_up{2,2}=Tyy_e_up; Pij_e_up{2,3}=Tyz_e_up;
        Pij_e_up{3,1}=Txz_e_up; Pij_e_up{3,2}=Tyz_e_up; Pij_e_up{3,3}=Tzz_e_up;
        %clearvars Txx_e_up Txy_e_up Txz_e_up Tyy_e_up Tyz_e_up Tzz_e_up
        %----------------------------------------------------------------------

        % This is to get the central momment pressure.
        %----------------------------------------------------------------------
        % % PPij_i=cell(3,3);
        % % PPij_e=cell(3,3);
        PPij_i_ba=cell(3,3);
        PPij_e_ba=cell(3,3);
        PPij_i_up=cell(3,3);
        PPij_e_up=cell(3,3);

        for i=1:3
            for j=1:3
                if(isempty(Pij_i_ba{i,j}) == 1) % This is where if P_ba is zero, this should be changed.
                    continue
                end
                PPij_i_ba{i,j} = Pij_i_ba{i,j} - 1.*n_i_ba{1,1}.*mi.*v_i_ba{1,i}.*v_i_ba{1,j};
                PPij_e_ba{i,j} = Pij_e_ba{i,j} - 1.*n_e_ba{1,1}.*me.*v_e_ba{1,i}.*v_e_ba{1,j};
                PPij_i_up{i,j} = Pij_i_up{i,j} - 1.*n_i_up{1,1}.*mi.*v_i_up{1,i}.*v_i_up{1,j};
                PPij_e_up{i,j} = Pij_e_up{i,j} - 1.*n_e_up{1,1}.*me.*v_e_up{1,i}.*v_e_up{1,j};
            end
        end

        % This is just to rename the variable
        Pij_i_ba = PPij_i_ba;
        Pij_e_ba = PPij_e_ba;
        Pij_i_up = PPij_i_up;
        Pij_e_up = PPij_e_up;

        clearvars v_i_up v_e_up v_i_ba v_e_ba %<----
        clearvars Txx_e_ba Txx_e_up Tyy_e_ba Tyy_e_up Tzz_e_ba Tzz_e_up
        clearvars Txy_e_ba Txy_e_up Txz_e_ba Txz_e_up Tyz_e_ba Tyz_e_up
        clearvars Txx_i_ba Txx_i_up Tyy_i_ba Tyy_i_up Tzz_i_ba Tzz_i_up
        clearvars Txy_i_ba Txy_i_up Txz_i_ba Txz_i_up Tyz_i_ba Tyz_i_up
        clearvars PPij_i PPij_e

    elseif UP_BA == 0

        Txx_e_up=h5read(fileID2,strcat(moments_1st,'/txx_e_UP/p0/3d'),start,count)./Te0;
        Tyy_e_up=h5read(fileID2,strcat(moments_1st,'/tyy_e_UP/p0/3d'),start,count)./Te0;
        Tzz_e_up=h5read(fileID2,strcat(moments_1st,'/tzz_e_UP/p0/3d'),start,count)./Te0;
        Txy_e_up=h5read(fileID2,strcat(moments_1st,'/txy_e_UP/p0/3d'),start,count)./Te0;
        Txz_e_up=h5read(fileID2,strcat(moments_1st,'/tzx_e_UP/p0/3d'),start,count)./Te0;
        Tyz_e_up=h5read(fileID2,strcat(moments_1st,'/tyz_e_UP/p0/3d'),start,count)./Te0;

        Txx_i_up=h5read(fileID2,strcat(moments_1st,'/txx_i_UP/p0/3d'),start,count)./Ti0;
        Tyy_i_up=h5read(fileID2,strcat(moments_1st,'/tyy_i_UP/p0/3d'),start,count)./Ti0;
        Tzz_i_up=h5read(fileID2,strcat(moments_1st,'/tzz_i_UP/p0/3d'),start,count)./Ti0;
        Txy_i_up=h5read(fileID2,strcat(moments_1st,'/txy_i_UP/p0/3d'),start,count)./Ti0;
        Txz_i_up=h5read(fileID2,strcat(moments_1st,'/tzx_i_UP/p0/3d'),start,count)./Ti0;
        Tyz_i_up=h5read(fileID2,strcat(moments_1st,'/tyz_i_UP/p0/3d'),start,count)./Ti0;

        Pij_i_up=cell(3,3);
        Pij_e_up=cell(3,3);
        %----------------------------------------------------------------------
        %----------------------------------------------------------------------
        % Make the tensor [3, 3] for the ions
        Pij_i_up{1,1}=Txx_i_up; Pij_i_up{1,2}=Txy_i_up; Pij_i_up{1,3}=Txz_i_up;
        Pij_i_up{2,1}=Txy_i_up; Pij_i_up{2,2}=Tyy_i_up; Pij_i_up{2,3}=Tyz_i_up;
        Pij_i_up{3,1}=Txz_i_up; Pij_i_up{3,2}=Tyz_i_up; Pij_i_up{3,3}=Tzz_i_up;
        %clearvars Txx_i_up Txy_i_up Txz_i_up Tyy_i_up Tyz_i_up Tzz_i_up
        % Make the tensor [3, 3] for the electrons
        Pij_e_up{1,1}=Txx_e_up; Pij_e_up{1,2}=Txy_e_up; Pij_e_up{1,3}=Txz_e_up;
        Pij_e_up{2,1}=Txy_e_up; Pij_e_up{2,2}=Tyy_e_up; Pij_e_up{2,3}=Tyz_e_up;
        Pij_e_up{3,1}=Txz_e_up; Pij_e_up{3,2}=Tyz_e_up; Pij_e_up{3,3}=Tzz_e_up;
        %clearvars Txx_e_up Txy_e_up Txz_e_up Tyy_e_up Tyz_e_up Tzz_e_up
        %----------------------------------------------------------------------

        % This is to get the central momment pressure.
        %----------------------------------------------------------------------
        PPij_i_up=cell(3,3);
        PPij_e_up=cell(3,3);

        for i=1:3
            for j=1:3
                if(isempty(Pij_i_up{i,j}) == 1) % This is where if P_ba is zero, this should be changed.
                    continue
                end
                PPij_i_up{i,j} = Pij_i_up{i,j} - 1.*n_i{1,1}.*mi.*v_i{1,i}.*v_i{1,j};
                PPij_e_up{i,j} = Pij_e_up{i,j} - 1.*n_e{1,1}.*me.*v_e{1,i}.*v_e{1,j};
            end
        end

        % This is just to rename the variable
        Pij_i_up = PPij_i_up;
        Pij_e_up = PPij_e_up;

        clearvars v_i_up v_e_up v_i_ba v_e_ba %<----
        clearvars Txx_e_ba Txx_e_up Tyy_e_ba Tyy_e_up Tzz_e_ba Tzz_e_up
        clearvars Txy_e_ba Txy_e_up Txz_e_ba Txz_e_up Tyz_e_ba Tyz_e_up
        clearvars Txx_i_ba Txx_i_up Tyy_i_ba Tyy_i_up Tzz_i_ba Tzz_i_up
        clearvars Txy_i_ba Txy_i_up Txz_i_ba Txz_i_up Tyz_i_ba Tyz_i_up
        clearvars PPij_i PPij_e

    end

    %----------------------------------------------------------------------

    n_i = n_i{1,1}; %n_i = squeeze(n_i(sli_x,:,:));
    n_e = n_e{1,1}; %n_e = squeeze(n_e(sli_x,:,:));

    if UP_BA == 1
        Pij_i_xx =  Pij_i_ba{1,1} +  Pij_i_up{1,1}; %Pij_i_xx = squeeze(Pij_i_xx(sli_x,:,:));
        Pij_i_xy =  Pij_i_ba{1,2} +  Pij_i_up{1,2}; %Pij_i_xy = squeeze(Pij_i_xy(sli_x,:,:));
        Pij_i_xz =  Pij_i_ba{1,3} +  Pij_i_up{1,3}; %Pij_i_xz = squeeze(Pij_i_xz(sli_x,:,:));
        Pij_i_yy =  Pij_i_ba{2,2} +  Pij_i_up{2,2}; %Pij_i_yy = squeeze(Pij_i_yy(sli_x,:,:));
        Pij_i_yz =  Pij_i_ba{2,3} +  Pij_i_up{2,3}; %Pij_i_yz = squeeze(Pij_i_yz(sli_x,:,:));
        Pij_i_zz =  Pij_i_ba{3,3} +  Pij_i_up{3,3}; %Pij_i_zz = squeeze(Pij_i_zz(sli_x,:,:));

        Pij_e_xx =  Pij_e_ba{1,1} +  Pij_e_up{1,1}; %Pij_e_xx = squeeze(Pij_e_xx(sli_x,:,:));
        Pij_e_xy =  Pij_e_ba{1,2} +  Pij_e_up{1,2}; %Pij_e_xy = squeeze(Pij_e_xy(sli_x,:,:));
        Pij_e_xz =  Pij_e_ba{1,3} +  Pij_e_up{1,3}; %Pij_e_xz = squeeze(Pij_e_xz(sli_x,:,:));
        Pij_e_yy =  Pij_e_ba{2,2} +  Pij_e_up{2,2}; %Pij_e_yy = squeeze(Pij_e_yy(sli_x,:,:));
        Pij_e_yz =  Pij_e_ba{2,3} +  Pij_e_up{2,3}; %Pij_e_yz = squeeze(Pij_e_yz(sli_x,:,:));
        Pij_e_zz =  Pij_e_ba{3,3} +  Pij_e_up{3,3}; %Pij_e_zz = squeeze(Pij_e_zz(sli_x,:,:));
    elseif UP_BA == 0
        Pij_i_xx =  Pij_i_up{1,1}; %Pij_i_xx = squeeze(Pij_i_xx(sli_x,:,:));
        Pij_i_xy =  Pij_i_up{1,2}; %Pij_i_xy = squeeze(Pij_i_xy(sli_x,:,:));
        Pij_i_xz =  Pij_i_up{1,3}; %Pij_i_xz = squeeze(Pij_i_xz(sli_x,:,:));
        Pij_i_yy =  Pij_i_up{2,2}; %Pij_i_yy = squeeze(Pij_i_yy(sli_x,:,:));
        Pij_i_yz =  Pij_i_up{2,3}; %Pij_i_yz = squeeze(Pij_i_yz(sli_x,:,:));
        Pij_i_zz =  Pij_i_up{3,3}; %Pij_i_zz = squeeze(Pij_i_zz(sli_x,:,:));

        Pij_e_xx =  Pij_e_up{1,1}; %Pij_e_xx = squeeze(Pij_e_xx(sli_x,:,:));
        Pij_e_xy =  Pij_e_up{1,2}; %Pij_e_xy = squeeze(Pij_e_xy(sli_x,:,:));
        Pij_e_xz =  Pij_e_up{1,3}; %Pij_e_xz = squeeze(Pij_e_xz(sli_x,:,:));
        Pij_e_yy =  Pij_e_up{2,2}; %Pij_e_yy = squeeze(Pij_e_yy(sli_x,:,:));
        Pij_e_yz =  Pij_e_up{2,3}; %Pij_e_yz = squeeze(Pij_e_yz(sli_x,:,:));
        Pij_e_zz =  Pij_e_up{3,3}; %Pij_e_zz = squeeze(Pij_e_zz(sli_x,:,:));
    end

    clearvars v_i_up v_e_up v_i_ba v_e_ba v_i v_e
    clearvars Pij_i Pij_e
    clearvars Pij_e_ba Pij_e_up  Pij_i_ba Pij_i_up

    %----------------------------------------------------------------------

    % v
    %----------------------------------------------------------------------
    v_x = (mi .* n_i .* v_ix + me .* n_e .* v_ex)./(mi .* n_i + me .* n_e);
    v_y = (mi .* n_i .* v_iy + me .* n_e .* v_ey)./(mi .* n_i + me .* n_e);
    v_z = (mi .* n_i .* v_iz + me .* n_e .* v_ez)./(mi .* n_i + me .* n_e);

    n = (mi .* n_i + me .* n_e) / (mi + me);
    %----------------------------------------------------------------------

    % Save the data for the time average
    %----------------------------------------------------------------------
    if dab ~= 0
        inn=(jn - j_a +1); % This has to be properly set to compute this for every time.
    elseif dab == 0
        inn=1;
    end

    % This fills in the array of values for the window moving with the central
    % value

    % % If there is a nan problem
    % %----------------------------------------------------------------------   
    % Ex(isnan(Ex)) = 0;
    % Ey(isnan(Ey)) = 0;
    % Ez(isnan(Ez)) = 0;
    % %----------------------------------------------------------------------

    if IS_2D == 1

    %----------------------------------------------------------------------
    E_in{1,inn} = imgaussfilt(Ex ,sigma_g);
    E_in{2,inn} = imgaussfilt(Ey ,sigma_g);
    E_in{3,inn} = imgaussfilt(Ez ,sigma_g);

    B_in{1,inn} = imgaussfilt(Bx ,sigma_g);
    B_in{2,inn} = imgaussfilt(By ,sigma_g);
    B_in{3,inn} = imgaussfilt(Bz ,sigma_g);

    J_in{1,inn} = imgaussfilt(Jx ,sigma_g);
    J_in{2,inn} = imgaussfilt(Jy ,sigma_g);
    J_in{3,inn} = imgaussfilt(Jz ,sigma_g);

    n_in{1,inn} = imgaussfilt(n_e ,sigma_g);
    n_in{2,inn} = imgaussfilt(n_i ,sigma_g);

    v_i_in{1,inn} = imgaussfilt(v_ix ,sigma_g);
    v_i_in{2,inn} = imgaussfilt(v_iy ,sigma_g);
    v_i_in{3,inn} = imgaussfilt(v_iz ,sigma_g);

    v_e_in{1,inn} = imgaussfilt(v_ex ,sigma_g);
    v_e_in{2,inn} = imgaussfilt(v_ey ,sigma_g);
    v_e_in{3,inn} = imgaussfilt(v_ez ,sigma_g);

    Pij_i_in{1,inn} = imgaussfilt(Pij_i_xx ,sigma_g);
    Pij_i_in{2,inn} = imgaussfilt(Pij_i_xy ,sigma_g);
    Pij_i_in{3,inn} = imgaussfilt(Pij_i_xz ,sigma_g);
    Pij_i_in{4,inn} = imgaussfilt(Pij_i_yy ,sigma_g);
    Pij_i_in{5,inn} = imgaussfilt(Pij_i_yz ,sigma_g);
    Pij_i_in{6,inn} = imgaussfilt(Pij_i_zz ,sigma_g);

    Pij_e_in{1,inn} = imgaussfilt(Pij_e_xx ,sigma_g);
    Pij_e_in{2,inn} = imgaussfilt(Pij_e_xy ,sigma_g);
    Pij_e_in{3,inn} = imgaussfilt(Pij_e_xz ,sigma_g);
    Pij_e_in{4,inn} = imgaussfilt(Pij_e_yy ,sigma_g);
    Pij_e_in{5,inn} = imgaussfilt(Pij_e_yz ,sigma_g);
    Pij_e_in{6,inn} = imgaussfilt(Pij_e_zz ,sigma_g);

    % The composed quiantities
    %----------------------------------------------------------------------
    % velocity MHD
    v_in{1,inn} = imgaussfilt(v_x ,sigma_g);
    v_in{2,inn} = imgaussfilt(v_y ,sigma_g);
    v_in{3,inn} = imgaussfilt(v_z ,sigma_g);

    n_in{3,inn} = imgaussfilt(n ,sigma_g);

    n_i_vi_in{1,inn} = imgaussfilt(n_i.*v_ix ,sigma_g);
    n_i_vi_in{2,inn} = imgaussfilt(n_i.*v_iy ,sigma_g);
    n_i_vi_in{3,inn} = imgaussfilt(n_i.*v_iz ,sigma_g);

    n_e_ve_in{1,inn} = imgaussfilt(n_e.*v_ex ,sigma_g);
    n_e_ve_in{2,inn} = imgaussfilt(n_e.*v_ey ,sigma_g);
    n_e_ve_in{3,inn} = imgaussfilt(n_e.*v_ez ,sigma_g);

    n_v_in{1,inn} = imgaussfilt(n.*v_x ,sigma_g);
    n_v_in{2,inn} = imgaussfilt(n.*v_y ,sigma_g);
    n_v_in{3,inn} = imgaussfilt(n.*v_z ,sigma_g);
    %----------------------------------------------------------------------

    % n_s_u_s_x_B
    %--------------------------------------------------------------------------
    ni_vi_x_B_in{1,inn} = imgaussfilt((n_i.*v_iy.* Bz - n_i.*v_iz.* By) ,sigma_g);
    ni_vi_x_B_in{2,inn} = imgaussfilt((n_i.*v_iz.* Bx - n_i.*v_ix.* Bz) ,sigma_g);
    ni_vi_x_B_in{3,inn} = imgaussfilt((n_i.*v_ix.* By - n_i.*v_iy.* Bx) ,sigma_g);

    ne_ve_x_B_in{1,inn} = imgaussfilt((n_e.*v_ey.* Bz - n_e.*v_ez.* By) ,sigma_g);
    ne_ve_x_B_in{2,inn} = imgaussfilt((n_e.*v_ez.* Bx - n_e.*v_ex.* Bz) ,sigma_g);
    ne_ve_x_B_in{3,inn} = imgaussfilt((n_e.*v_ex.* By - n_e.*v_ey.* Bx) ,sigma_g);

    n_v_x_B_in{1,inn} = imgaussfilt((n.*v_y.* Bz - n.*v_z.* By) ,sigma_g);
    n_v_x_B_in{2,inn} = imgaussfilt((n.*v_z.* Bx - n.*v_x.* Bz) ,sigma_g);
    n_v_x_B_in{3,inn} = imgaussfilt((n.*v_x.* By - n.*v_y.* Bx) ,sigma_g);
    %--------------------------------------------------------------------------

    %tensor product of the averages (nU)_ave U_ave
    %--------------------------------------------------------------------------
    ni_vivi_in{1,inn} = imgaussfilt((n_i .* v_ix .* v_ix) ,sigma_g);
    ni_vivi_in{2,inn} = imgaussfilt((n_i .* v_ix .* v_iy) ,sigma_g);
    ni_vivi_in{3,inn} = imgaussfilt((n_i .* v_ix .* v_iz) ,sigma_g);
    ni_vivi_in{4,inn} = imgaussfilt((n_i .* v_iy .* v_iy) ,sigma_g);
    ni_vivi_in{5,inn} = imgaussfilt((n_i .* v_iy .* v_iz) ,sigma_g);
    ni_vivi_in{6,inn} = imgaussfilt((n_i .* v_iz .* v_iz) ,sigma_g);

    ne_veve_in{1,inn} = imgaussfilt((n_e .* v_ex .* v_ex) ,sigma_g);
    ne_veve_in{2,inn} = imgaussfilt((n_e .* v_ex .* v_ey) ,sigma_g);
    ne_veve_in{3,inn} = imgaussfilt((n_e .* v_ex .* v_ez) ,sigma_g);
    ne_veve_in{4,inn} = imgaussfilt((n_e .* v_ey .* v_ey) ,sigma_g);
    ne_veve_in{5,inn} = imgaussfilt((n_e .* v_ey .* v_ez) ,sigma_g);
    ne_veve_in{6,inn} = imgaussfilt((n_e .* v_ez .* v_ez) ,sigma_g);

    n_vv_in{1,inn} = imgaussfilt((n .* v_x .* v_x) ,sigma_g);
    n_vv_in{2,inn} = imgaussfilt((n .* v_x .* v_y) ,sigma_g);
    n_vv_in{3,inn} = imgaussfilt((n .* v_x .* v_z) ,sigma_g);
    n_vv_in{4,inn} = imgaussfilt((n .* v_y .* v_y) ,sigma_g);
    n_vv_in{5,inn} = imgaussfilt((n .* v_y .* v_z) ,sigma_g);
    n_vv_in{6,inn} = imgaussfilt((n .* v_z .* v_z) ,sigma_g);
    
    elseif IS_2D == 0

    E_in{1,inn} = imgaussfilt3(Ex ,sigma_g);
    E_in{2,inn} = imgaussfilt3(Ey ,sigma_g);
    E_in{3,inn} = imgaussfilt3(Ez ,sigma_g);

    B_in{1,inn} = imgaussfilt3(Bx ,sigma_g);
    B_in{2,inn} = imgaussfilt3(By ,sigma_g);
    B_in{3,inn} = imgaussfilt3(Bz ,sigma_g);

    J_in{1,inn} = imgaussfilt3(Jx ,sigma_g);
    J_in{2,inn} = imgaussfilt3(Jy ,sigma_g);
    J_in{3,inn} = imgaussfilt3(Jz ,sigma_g);

    n_in{1,inn} = imgaussfilt3(n_e ,sigma_g);
    n_in{2,inn} = imgaussfilt3(n_i ,sigma_g);

    v_i_in{1,inn} = imgaussfilt3(v_ix ,sigma_g);
    v_i_in{2,inn} = imgaussfilt3(v_iy ,sigma_g);
    v_i_in{3,inn} = imgaussfilt3(v_iz ,sigma_g);

    v_e_in{1,inn} = imgaussfilt3(v_ex ,sigma_g);
    v_e_in{2,inn} = imgaussfilt3(v_ey ,sigma_g);
    v_e_in{3,inn} = imgaussfilt3(v_ez ,sigma_g);

    Pij_i_in{1,inn} = imgaussfilt3(Pij_i_xx ,sigma_g);
    Pij_i_in{2,inn} = imgaussfilt3(Pij_i_xy ,sigma_g);
    Pij_i_in{3,inn} = imgaussfilt3(Pij_i_xz ,sigma_g);
    Pij_i_in{4,inn} = imgaussfilt3(Pij_i_yy ,sigma_g);
    Pij_i_in{5,inn} = imgaussfilt3(Pij_i_yz ,sigma_g);
    Pij_i_in{6,inn} = imgaussfilt3(Pij_i_zz ,sigma_g);

    Pij_e_in{1,inn} = imgaussfilt3(Pij_e_xx ,sigma_g);
    Pij_e_in{2,inn} = imgaussfilt3(Pij_e_xy ,sigma_g);
    Pij_e_in{3,inn} = imgaussfilt3(Pij_e_xz ,sigma_g);
    Pij_e_in{4,inn} = imgaussfilt3(Pij_e_yy ,sigma_g);
    Pij_e_in{5,inn} = imgaussfilt3(Pij_e_yz ,sigma_g);
    Pij_e_in{6,inn} = imgaussfilt3(Pij_e_zz ,sigma_g);

    % The composed quiantities
    %----------------------------------------------------------------------
    % velocity MHD
    v_in{1,inn} = imgaussfilt3(v_x ,sigma_g);
    v_in{2,inn} = imgaussfilt3(v_y ,sigma_g);
    v_in{3,inn} = imgaussfilt3(v_z ,sigma_g);

    n_in{3,inn} = imgaussfilt3(n ,sigma_g);

    n_i_vi_in{1,inn} = imgaussfilt3(n_i.*v_ix ,sigma_g);
    n_i_vi_in{2,inn} = imgaussfilt3(n_i.*v_iy ,sigma_g);
    n_i_vi_in{3,inn} = imgaussfilt3(n_i.*v_iz ,sigma_g);

    n_e_ve_in{1,inn} = imgaussfilt3(n_e.*v_ex ,sigma_g);
    n_e_ve_in{2,inn} = imgaussfilt3(n_e.*v_ey ,sigma_g);
    n_e_ve_in{3,inn} = imgaussfilt3(n_e.*v_ez ,sigma_g);

    n_v_in{1,inn} = imgaussfilt3(n.*v_x ,sigma_g);
    n_v_in{2,inn} = imgaussfilt3(n.*v_y ,sigma_g);
    n_v_in{3,inn} = imgaussfilt3(n.*v_z ,sigma_g);
    %----------------------------------------------------------------------

    % n_s_u_s_x_B
    %--------------------------------------------------------------------------
    ni_vi_x_B_in{1,inn} = imgaussfilt3((n_i.*v_iy.* Bz - n_i.*v_iz.* By) ,sigma_g);
    ni_vi_x_B_in{2,inn} = imgaussfilt3((n_i.*v_iz.* Bx - n_i.*v_ix.* Bz) ,sigma_g);
    ni_vi_x_B_in{3,inn} = imgaussfilt3((n_i.*v_ix.* By - n_i.*v_iy.* Bx) ,sigma_g);

    ne_ve_x_B_in{1,inn} = imgaussfilt3((n_e.*v_ey.* Bz - n_e.*v_ez.* By) ,sigma_g);
    ne_ve_x_B_in{2,inn} = imgaussfilt3((n_e.*v_ez.* Bx - n_e.*v_ex.* Bz) ,sigma_g);
    ne_ve_x_B_in{3,inn} = imgaussfilt3((n_e.*v_ex.* By - n_e.*v_ey.* Bx) ,sigma_g);

    n_v_x_B_in{1,inn} = imgaussfilt3((n.*v_y.* Bz - n.*v_z.* By) ,sigma_g);
    n_v_x_B_in{2,inn} = imgaussfilt3((n.*v_z.* Bx - n.*v_x.* Bz) ,sigma_g);
    n_v_x_B_in{3,inn} = imgaussfilt3((n.*v_x.* By - n.*v_y.* Bx) ,sigma_g);
    %--------------------------------------------------------------------------

    %tensor product of the averages (nU)_ave U_ave
    %--------------------------------------------------------------------------
    ni_vivi_in{1,inn} = imgaussfilt3((n_i .* v_ix .* v_ix) ,sigma_g);
    ni_vivi_in{2,inn} = imgaussfilt3((n_i .* v_ix .* v_iy) ,sigma_g);
    ni_vivi_in{3,inn} = imgaussfilt3((n_i .* v_ix .* v_iz) ,sigma_g);
    ni_vivi_in{4,inn} = imgaussfilt3((n_i .* v_iy .* v_iy) ,sigma_g);
    ni_vivi_in{5,inn} = imgaussfilt3((n_i .* v_iy .* v_iz) ,sigma_g);
    ni_vivi_in{6,inn} = imgaussfilt3((n_i .* v_iz .* v_iz) ,sigma_g);

    ne_veve_in{1,inn} = imgaussfilt3((n_e .* v_ex .* v_ex) ,sigma_g);
    ne_veve_in{2,inn} = imgaussfilt3((n_e .* v_ex .* v_ey) ,sigma_g);
    ne_veve_in{3,inn} = imgaussfilt3((n_e .* v_ex .* v_ez) ,sigma_g);
    ne_veve_in{4,inn} = imgaussfilt3((n_e .* v_ey .* v_ey) ,sigma_g);
    ne_veve_in{5,inn} = imgaussfilt3((n_e .* v_ey .* v_ez) ,sigma_g);
    ne_veve_in{6,inn} = imgaussfilt3((n_e .* v_ez .* v_ez) ,sigma_g);

    n_vv_in{1,inn} = imgaussfilt3((n .* v_x .* v_x) ,sigma_g);
    n_vv_in{2,inn} = imgaussfilt3((n .* v_x .* v_y) ,sigma_g);
    n_vv_in{3,inn} = imgaussfilt3((n .* v_x .* v_z) ,sigma_g);
    n_vv_in{4,inn} = imgaussfilt3((n .* v_y .* v_y) ,sigma_g);
    n_vv_in{5,inn} = imgaussfilt3((n .* v_y .* v_z) ,sigma_g);
    n_vv_in{6,inn} = imgaussfilt3((n .* v_z .* v_z) ,sigma_g);
    end
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    clearvars Ex Ey Ez Bx By Bz Jx Jy Jz n_i n_e n_i_up n_i_ba n_e_up n_e_ba
    clearvars v_ix v_iy v_iz v_ex v_ey v_ez v_x v_y v_z
    clearvars Pij_e_xx Pij_e_xy Pij_e_xz Pij_e_yy Pij_e_yz Pij_e_zz
    clearvars Pij_i_xx Pij_i_xy Pij_i_xz Pij_i_yy Pij_i_yz Pij_i_zz
    %----------------------------------------------------------------------

end


    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    % So far the adaptatio to include up_ba vs only up is correct
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------


% Now I have to take ensamble average in the out of plane direction.

% Lets make it first for the anomalous drag term


Ex_avgt_i = mean(E_in{1,1},'all');
Ey_avgt_i = mean(E_in{2,1},'all');
Ez_avgt_i = mean(E_in{3,1},'all');
n_e_avgt_i = mean(n_in{1,1},'all');
n_i_avgt_i = mean(n_in{2,1},'all');
n_avgt_i = mean(n_in{3,1},'all');

% Compute the fluctuations, e.g., delta_n_e = n_e_time_i - <n>
%----------------------------------------------------------------------
del_Ex = (E_in{1,1} - Ex_avgt_i);
del_Ey = (E_in{2,1} - Ey_avgt_i);
del_Ez = (E_in{3,1} - Ez_avgt_i);

del_n_e = (n_in{1,1} - n_e_avgt_i);
del_n_i = (n_in{2,1} - n_i_avgt_i);
%----------------------------------------------------------------------
% now the composed quantities
%----------------------------------------------------------------------
del_n = (n_in{3,1} - n_avgt_i);
%----------------------------------------------------------------------

%del_n_del_E
%----------------------------------------------------------------------
del_n_i_del_Ex = (del_n_i .* del_Ex);
del_n_i_del_Ey = (del_n_i .* del_Ey);
del_n_i_del_Ez = (del_n_i .* del_Ez);

del_n_e_del_Ex = (del_n_e .* del_Ex);
del_n_e_del_Ey = (del_n_e .* del_Ey);
del_n_e_del_Ez = (del_n_e .* del_Ez);

del_n_del_Ex = (del_n .* del_Ex);
del_n_del_Ey = (del_n .* del_Ey);
del_n_del_Ez = (del_n .* del_Ez);
%----------------------------------------------------------------------


% Now compute the ensamble average along the x direction
%----------------------------------------------------------------------
Ex_ens = mean(squeeze(E_in{1,1}),1);
Ey_ens = mean(squeeze(E_in{2,1}),1);
Ez_ens = mean(squeeze(E_in{3,1}),1);

v_ex_ens = mean(squeeze(v_e_in{1,1}),1);
v_ey_ens = mean(squeeze(v_e_in{2,1}),1);
v_ez_ens = mean(squeeze(v_e_in{3,1}),1);

v_ix_ens = mean(squeeze(v_i_in{1,1}),1);
v_iy_ens = mean(squeeze(v_i_in{2,1}),1);
v_iz_ens = mean(squeeze(v_i_in{3,1}),1);

Bx_ens = mean(squeeze(B_in{1,1}),1);
By_ens = mean(squeeze(B_in{2,1}),1);
Bz_ens = mean(squeeze(B_in{3,1}),1);

Pij_exx_ens = mean(squeeze(Pij_e_in{1,1}),1);
Pij_exy_ens = mean(squeeze(Pij_e_in{2,1}),1);
Pij_exz_ens = mean(squeeze(Pij_e_in{3,1}),1);
Pij_eyy_ens = mean(squeeze(Pij_e_in{4,1}),1);
Pij_eyz_ens = mean(squeeze(Pij_e_in{5,1}),1);
Pij_ezzz_ens = mean(squeeze(Pij_e_in{6,1}),1);

Pij_ixx_ens = mean(squeeze(Pij_i_in{1,1}),1);
Pij_ixy_ens = mean(squeeze(Pij_i_in{2,1}),1);
Pij_ixz_ens = mean(squeeze(Pij_i_in{3,1}),1);
Pij_iyy_ens = mean(squeeze(Pij_i_in{4,1}),1);
Pij_iyz_ens = mean(squeeze(Pij_i_in{5,1}),1);
Pij_izzz_ens = mean(squeeze(Pij_i_in{6,1}),1);

ne_ens = mean(squeeze(n_in{1,1}),1);
ni_ens = mean(squeeze(n_in{2,1}),1);

ne_ve_x_Bx_ens = mean(squeeze(ne_ve_x_B_in{1,1}),1);
ne_ve_x_By_ens = mean(squeeze(ne_ve_x_B_in{2,1}),1);
ne_ve_x_Bz_ens = mean(squeeze(ne_ve_x_B_in{3,1}),1);

ne_veve_xx_ens = mean(squeeze(ne_veve_in{1,1}),1);
ne_veve_xy_ens = mean(squeeze(ne_veve_in{2,1}),1);
ne_veve_xz_ens = mean(squeeze(ne_veve_in{3,1}),1);
ne_veve_yy_ens = mean(squeeze(ne_veve_in{4,1}),1);
ne_veve_yz_ens = mean(squeeze(ne_veve_in{5,1}),1);
ne_veve_zz_ens = mean(squeeze(ne_veve_in{6,1}),1);

ni_vivi_xx_ens = mean(squeeze(ni_vivi_in{1,1}),1);
ni_vivi_xy_ens = mean(squeeze(ni_vivi_in{2,1}),1);
ni_vivi_xz_ens = mean(squeeze(ni_vivi_in{3,1}),1);
ni_vivi_yy_ens = mean(squeeze(ni_vivi_in{4,1}),1);
ni_vivi_yz_ens = mean(squeeze(ni_vivi_in{5,1}),1);
ni_vivi_zz_ens = mean(squeeze(ni_vivi_in{6,1}),1);

del_n_e_del_Ex_ens = mean(del_n_e_del_Ex,1);
del_n_e_del_Ey_ens = mean(del_n_e_del_Ey,1);
del_n_e_del_Ez_ens = mean(del_n_e_del_Ez,1);


% Now the cruz products and the product of the ensambles
%----------------------------------------------------------------------

% this is where I go ...


%----------------------------------------------------------------------

sss=size(del_n_i_del_Ex);
size_X=sss;
zll=linspace(-Lz,Lz,size_X(3)); %Jeff flag it works with (1,size_x(2))
yll=linspace(-Ly,Ly,size_X(2));
[ZLL, YLL] = meshgrid(zll,yll);

yticks_mine=[floor(-Ly*0.9) floor(-Ly/2) 0 floor(Ly/2) floor(Ly*0.9)];
zticks_mine=[floor(-Lz*0.9) floor(-Lz/2) 0 floor(Lz/2) floor(Lz*0.9)];

cd(path_s2)
fs=18;lw=2;

E_dum = del_n_e_del_Ey;
for i=1:200
    f1=figure(1);
    h1=subplot(1,1,1);
    hold on
    dump = squeeze(E_dum(i,:,:));
    hc=pcolor(ZLL,YLL,dump);
    set(hc,'edgecolor','none')
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    colormap(h1,BWR); caxlim=max(max(abs(dump))).*1;
    caxis([-caxlim, caxlim]);
    %xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    %xline(zll(sli_z),'--k','LineWidth',lw);
    ax.FontSize=fs;
    lgnd=legend([h1],'$n_{e} E_{y}$','Interpreter','latex','FontSize',fs);
    hold off
end


E_dum = mean(del_n_e_del_Ey,1);
f3=figure(3);
subplot(2,1,1)
dump = squeeze(E_dum);
hc=pcolor(ZLL,YLL,(dump));
set(hc,'edgecolor','none')
colorbar
subplot(2,1,2)
plot(dump(:,1))


f2=figure(2)
histogram(E_in{1,1})


E_dum =E_in{2,1};
for i=1:1
    f3=figure(3);
    dump = squeeze(E_dum(i,:,:));
    hc=pcolor(ZLL,YLL,(dump));
    set(hc,'edgecolor','none')
    colorbar
end

%Consolidate the averages in time

% setting the initial values to zero
%----------------------------------------------------------------------
DUM = 0.*E_in{1,1};

[Ex_avgt_i, Ey_avgt_i, Ez_avgt_i,...
    Bx_avgt_i, By_avgt_i, Bz_avgt_i,...
    Jx_avgt_i, Jy_avgt_i, Jz_avgt_i] = deal(DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM);

[n_e_avgt_i, n_i_avgt_i, n_avgt_i] = deal(DUM,DUM,DUM);

[v_ix_avgt_i, v_iy_avgt_i, v_iz_avgt_i,...
    v_ex_avgt_i, v_ey_avgt_i, v_ez_avgt_i,...
    v_x_avgt_i, v_y_avgt_i, v_z_avgt_i] = deal(DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM);

[Pij_i_xx_avgt_i, Pij_i_xy_avgt_i, Pij_i_xz_avgt_i,...
    Pij_i_yy_avgt_i, Pij_i_yz_avgt_i, Pij_i_zz_avgt_i] = deal(DUM,DUM,DUM,DUM,DUM,DUM);

[Pij_e_xx_avgt_i, Pij_e_xy_avgt_i, Pij_e_xz_avgt_i,...
    Pij_e_yy_avgt_i, Pij_e_yz_avgt_i, Pij_e_zz_avgt_i] = deal(DUM,DUM,DUM,DUM,DUM,DUM);

[n_i_vix_avgt_i, n_i_viy_avgt_i, n_i_viz_avgt_i,...
    n_e_vex_avgt_i, n_e_vey_avgt_i, n_e_vez_avgt_i,...
    n_vx_avgt_i, n_vy_avgt_i, n_vz_avgt_i] = deal(DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM);

[ni_vi_x_Bx_avgt_i, ni_vi_x_By_avgt_i, ni_vi_x_Bz_avgt_i,...
    ne_ve_x_Bx_avgt_i, ne_ve_x_By_avgt_i, ne_ve_x_Bz_avgt_i,...
    n_v_x_Bx_avgt_i, n_v_x_By_avgt_i, n_v_x_Bz_avgt_i] = deal(DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM);

[ni_vivi_xx_avgt_i, ni_vivi_xy_avgt_i, ni_vivi_xz_avgt_i, ni_vivi_yy_avgt_i, ni_vivi_yz_avgt_i, ni_vivi_zz_avgt_i, ...
    ne_veve_xx_avgt_i, ne_veve_xy_avgt_i, ne_veve_xz_avgt_i, ne_veve_yy_avgt_i, ne_veve_yz_avgt_i, ne_veve_zz_avgt_i, ...
    n_vv_xx_avgt_i, n_vv_xy_avgt_i, n_vv_xz_avgt_i, n_vv_yy_avgt_i, n_vv_yz_avgt_i, n_vv_zz_avgt_i] = ...
    deal(DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
nu_av=j_a_b+1; % this is for the average
%----------------------------------------------------------------------

% Compute the sums for the averages
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
    n_i_avgt_o = n_i_avgt_i + n_in{2,ii} ; n_i_avgt_i = n_i_avgt_o;

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

    n_avgt_o = n_avgt_i + n_in{3,ii}; n_avgt_i = n_avgt_o;

    n_i_vix_avgt_o = n_i_vi_in{1,ii} + n_i_vix_avgt_i ; n_i_vix_avgt_i = n_i_vix_avgt_o;
    n_i_viy_avgt_o = n_i_vi_in{2,ii} + n_i_viy_avgt_i ; n_i_viy_avgt_i = n_i_viy_avgt_o;
    n_i_viz_avgt_o = n_i_vi_in{3,ii} + n_i_viz_avgt_i ; n_i_viz_avgt_i = n_i_viz_avgt_o;

    n_e_vex_avgt_o = n_e_ve_in{1,ii} + n_e_vex_avgt_i ; n_e_vex_avgt_i = n_e_vex_avgt_o;
    n_e_vey_avgt_o = n_e_ve_in{2,ii} + n_e_vey_avgt_i ; n_e_vey_avgt_i = n_e_vey_avgt_o;
    n_e_vez_avgt_o = n_e_ve_in{3,ii} + n_e_vez_avgt_i ; n_e_vez_avgt_i = n_e_vez_avgt_o;

    n_vx_avgt_o = n_v_in{1,ii} + n_vx_avgt_i ; n_vx_avgt_i = n_vx_avgt_o;
    n_vy_avgt_o = n_v_in{2,ii} + n_vy_avgt_i ; n_vy_avgt_i = n_vy_avgt_o;
    n_vz_avgt_o = n_v_in{3,ii} + n_vz_avgt_i ; n_vz_avgt_i = n_vz_avgt_o;

    ni_vi_x_Bx_avgt_o = ni_vi_x_B_in{1,ii} + ni_vi_x_Bx_avgt_i ; ni_vi_x_Bx_avgt_i = ni_vi_x_Bx_avgt_o;
    ni_vi_x_By_avgt_o = ni_vi_x_B_in{2,ii} + ni_vi_x_By_avgt_i ; ni_vi_x_By_avgt_i = ni_vi_x_By_avgt_o;    
    ni_vi_x_Bz_avgt_o = ni_vi_x_B_in{3,ii} + ni_vi_x_Bz_avgt_i ; ni_vi_x_Bz_avgt_i = ni_vi_x_Bz_avgt_o;

    ne_ve_x_Bx_avgt_o = ne_ve_x_B_in{1,ii} + ne_ve_x_Bx_avgt_i ; ne_ve_x_Bx_avgt_i = ne_ve_x_Bx_avgt_o;
    ne_ve_x_By_avgt_o = ne_ve_x_B_in{2,ii} + ne_ve_x_By_avgt_i ; ne_ve_x_By_avgt_i = ne_ve_x_By_avgt_o;    
    ne_ve_x_Bz_avgt_o = ne_ve_x_B_in{3,ii} + ne_ve_x_Bz_avgt_i ; ne_ve_x_Bz_avgt_i = ne_ve_x_Bz_avgt_o;

    n_v_x_Bx_avgt_o = n_v_x_B_in{1,ii} + n_v_x_Bx_avgt_i ; n_v_x_Bx_avgt_i = n_v_x_Bx_avgt_o;
    n_v_x_By_avgt_o = n_v_x_B_in{2,ii} + n_v_x_By_avgt_i ; n_v_x_By_avgt_i = n_v_x_By_avgt_o;    
    n_v_x_Bz_avgt_o = n_v_x_B_in{3,ii} + n_v_x_Bz_avgt_i ; n_v_x_Bz_avgt_i = n_v_x_Bz_avgt_o;

    ni_vivi_xx_avgt_o = ni_vivi_in{1,ii} + ni_vivi_xx_avgt_i ; ni_vivi_xx_avgt_i = ni_vivi_xx_avgt_o;
    ni_vivi_xy_avgt_o = ni_vivi_in{2,ii} + ni_vivi_xy_avgt_i ; ni_vivi_xy_avgt_i = ni_vivi_xy_avgt_o;
    ni_vivi_xz_avgt_o = ni_vivi_in{3,ii} + ni_vivi_xz_avgt_i ; ni_vivi_xz_avgt_i = ni_vivi_xz_avgt_o;
    ni_vivi_yy_avgt_o = ni_vivi_in{4,ii} + ni_vivi_yy_avgt_i ; ni_vivi_yy_avgt_i = ni_vivi_yy_avgt_o;    
    ni_vivi_yz_avgt_o = ni_vivi_in{5,ii} + ni_vivi_yz_avgt_i ; ni_vivi_yz_avgt_i = ni_vivi_yz_avgt_o;
    ni_vivi_zz_avgt_o = ni_vivi_in{6,ii} + ni_vivi_zz_avgt_i ; ni_vivi_zz_avgt_i = ni_vivi_zz_avgt_o;

    ne_veve_xx_avgt_o = ne_veve_in{1,ii} + ne_veve_xx_avgt_i ; ne_veve_xx_avgt_i = ne_veve_xx_avgt_o;
    ne_veve_xy_avgt_o = ne_veve_in{2,ii} + ne_veve_xy_avgt_i ; ne_veve_xy_avgt_i = ne_veve_xy_avgt_o;
    ne_veve_xz_avgt_o = ne_veve_in{3,ii} + ne_veve_xz_avgt_i ; ne_veve_xz_avgt_i = ne_veve_xz_avgt_o;
    ne_veve_yy_avgt_o = ne_veve_in{4,ii} + ne_veve_yy_avgt_i ; ne_veve_yy_avgt_i = ne_veve_yy_avgt_o;    
    ne_veve_yz_avgt_o = ne_veve_in{5,ii} + ne_veve_yz_avgt_i ; ne_veve_yz_avgt_i = ne_veve_yz_avgt_o;
    ne_veve_zz_avgt_o = ne_veve_in{6,ii} + ne_veve_zz_avgt_i ; ne_veve_zz_avgt_i = ne_veve_zz_avgt_o;

    n_vv_xx_avgt_o = n_vv_in{1,ii} + n_vv_xx_avgt_i ; n_vv_xx_avgt_i = n_vv_xx_avgt_o;
    n_vv_xy_avgt_o = n_vv_in{2,ii} + n_vv_xy_avgt_i ; n_vv_xy_avgt_i = n_vv_xy_avgt_o;
    n_vv_xz_avgt_o = n_vv_in{3,ii} + n_vv_xz_avgt_i ; n_vv_xz_avgt_i = n_vv_xz_avgt_o;
    n_vv_yy_avgt_o = n_vv_in{4,ii} + n_vv_yy_avgt_i ; n_vv_yy_avgt_i = n_vv_yy_avgt_o;    
    n_vv_yz_avgt_o = n_vv_in{5,ii} + n_vv_yz_avgt_i ; n_vv_yz_avgt_i = n_vv_yz_avgt_o;
    n_vv_zz_avgt_o = n_vv_in{6,ii} + n_vv_zz_avgt_i ; n_vv_zz_avgt_i = n_vv_zz_avgt_o;    

end


clearvars *_o
%--------------------------------------------------------------------------

% setting the initial values to zero
%----------------------------------------------------------------------
[del_Ex_1, del_Ey_1, del_Ez_1] = ...
    deal(DUM,DUM,DUM);

[del_n_e_1, del_n_i_1, del_n_1] = ...
    deal(DUM,DUM,DUM); 
%----------------------------------------------------------------------
[del_n_i_del_Ex_1, del_n_i_del_Ey_1, del_n_i_del_Ez_1,...
    del_n_e_del_Ex_1, del_n_e_del_Ey_1, del_n_e_del_Ez_1,...
    del_n_del_Ex_1, del_n_del_Ey_1, del_n_del_Ez_1] = deal(DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM,DUM);
%----------------------------------------------------------------------


% to compute the averages of the delta quantities
%----------------------------------------------------------------------
for ii=1:j_a_b+1
    %ii = floor(j_a_b/2) + 1; % the center of the interval

    % Extract the instantaneus fields
    %----------------------------------------------------------------------
    Ex_avgt_o = E_in{1,ii};
    Ey_avgt_o = E_in{2,ii};
    Ez_avgt_o = E_in{3,ii};
    n_e_avgt_o = n_in{1,ii};
    n_i_avgt_o = n_in{2,ii};
    n_avgt_o = n_in{3,ii};

    %----------------------------------------------------------------------

    % Compute the fluctuations, e.g., delta_n_e = n_e_time_i - <n>
    %----------------------------------------------------------------------
    del_Ex = (Ex_avgt_o - Ex_avgt_i./nu_av);
    del_Ey = (Ey_avgt_o - Ey_avgt_i./nu_av);
    del_Ez = (Ez_avgt_o - Ez_avgt_i./nu_av);

    del_n_e = (n_e_avgt_o - n_e_avgt_i./nu_av);
    del_n_i = (n_i_avgt_o - n_i_avgt_i./nu_av);
    %----------------------------------------------------------------------
    % now the composed quantities
    %----------------------------------------------------------------------
    del_n = (n_avgt_o - n_avgt_i./nu_av);
    %----------------------------------------------------------------------
    
    %del_n_del_E
    %----------------------------------------------------------------------
    del_n_i_del_Ex = (del_n_i .* del_Ex);
    del_n_i_del_Ey = (del_n_i .* del_Ey);
    del_n_i_del_Ez = (del_n_i .* del_Ez);

    del_n_e_del_Ex = (del_n_e .* del_Ex);
    del_n_e_del_Ey = (del_n_e .* del_Ey);
    del_n_e_del_Ez = (del_n_e .* del_Ez);

    del_n_del_Ex = (del_n .* del_Ex);
    del_n_del_Ey = (del_n .* del_Ey);
    del_n_del_Ez = (del_n .* del_Ez);
    %----------------------------------------------------------------------
    
    % make the adding
    %----------------------------------------------------------------------
    del_Ex_0 = del_Ex_1 + del_Ex; del_Ex_1 = del_Ex_0;
    del_Ey_0 = del_Ey_1 + del_Ey; del_Ey_1 = del_Ey_0;
    del_Ez_0 = del_Ez_1 + del_Ez; del_Ez_1 = del_Ez_0;

    del_n_e_0 = del_n_e_1 + del_n_e; del_n_e_1 = del_n_e_0;
    del_n_i_0 = del_n_i_1 + del_n_i; del_n_i_1 = del_n_i_0;
    %----------------------------------------------------------------------

    % now the composed quantities
    %----------------------------------------------------------------------
    del_n_0 = del_n_1 + del_n; del_n_1 = del_n_0;
    %----------------------------------------------------------------------

    %del_n_del_E
    %----------------------------------------------------------------------
    del_n_i_del_Ex_0 = del_n_i_del_Ex_1 + del_n_i_del_Ex; del_n_i_del_Ex_1 = del_n_i_del_Ex_0;
    del_n_i_del_Ey_0 = del_n_i_del_Ey_1 + del_n_i_del_Ey; del_n_i_del_Ey_1 = del_n_i_del_Ey_0;
    del_n_i_del_Ez_0 = del_n_i_del_Ez_1 + del_n_i_del_Ez; del_n_i_del_Ez_1 = del_n_i_del_Ez_0;

    del_n_e_del_Ex_0 = del_n_e_del_Ex_1 + del_n_e_del_Ex; del_n_e_del_Ex_1 = del_n_e_del_Ex_0;
    del_n_e_del_Ey_0 = del_n_e_del_Ey_1 + del_n_e_del_Ey; del_n_e_del_Ey_1 = del_n_e_del_Ey_0;
    del_n_e_del_Ez_0 = del_n_e_del_Ez_1 + del_n_e_del_Ez; del_n_e_del_Ez_1 = del_n_e_del_Ez_0;

    del_n_del_Ex_0 = del_n_del_Ex_1 + del_n_del_Ex; del_n_del_Ex_1 = del_n_del_Ex_0;
    del_n_del_Ey_0 = del_n_del_Ey_1 + del_n_del_Ey; del_n_del_Ey_1 = del_n_del_Ey_0;
    del_n_del_Ez_0 = del_n_del_Ez_1 + del_n_del_Ez; del_n_del_Ez_1 = del_n_del_Ez_0;
    %----------------------------------------------------------------------
end

%--------------------------------------------------------------------------
clearvars Pij_e_ba Pij_e_up Pij_e_in
clearvars Pij_i_ba Pij_i_up Pij_i_in
clearvars E_in B_in J_in n_in v_i_in v_e_in v_in
clearvars n_in n_i_vi_in n_e_ve_in n_v_in 
%clearvars vixB_in vexB_in vxB_in

clearvars *_o
clearvars *_0
%--------------------------------------------------------------------------


% saving only the averages. 
%----------------------------------------------------------------------
Ex_avgt_i = Ex_avgt_i./nu_av;
Ey_avgt_i = Ey_avgt_i./nu_av;
Ez_avgt_i = Ez_avgt_i./nu_av;

Bx_avgt_i = Bx_avgt_i./nu_av;
By_avgt_i = By_avgt_i./nu_av;
Bz_avgt_i = Bz_avgt_i./nu_av;

n_e_avgt_i = n_e_avgt_i./nu_av;
n_i_avgt_i = n_i_avgt_i./nu_av;

v_ix_avgt_i = v_ix_avgt_i./nu_av;
v_iy_avgt_i = v_iy_avgt_i./nu_av;
v_iz_avgt_i = v_iz_avgt_i./nu_av;

v_ex_avgt_i = v_ex_avgt_i./nu_av;
v_ey_avgt_i = v_ey_avgt_i./nu_av;
v_ez_avgt_i = v_ez_avgt_i./nu_av;

v_x_avgt_i = v_x_avgt_i./nu_av;
v_y_avgt_i = v_y_avgt_i./nu_av;
v_z_avgt_i = v_z_avgt_i./nu_av;

Pij_i_xx_avgt_i = Pij_i_xx_avgt_i./nu_av;
Pij_i_xy_avgt_i = Pij_i_xy_avgt_i./nu_av;
Pij_i_xz_avgt_i = Pij_i_xz_avgt_i./nu_av;
Pij_i_yy_avgt_i = Pij_i_yy_avgt_i./nu_av;
Pij_i_yz_avgt_i = Pij_i_yz_avgt_i./nu_av;
Pij_i_zz_avgt_i = Pij_i_zz_avgt_i./nu_av;

Pij_e_xx_avgt_i = Pij_e_xx_avgt_i./nu_av;
Pij_e_xy_avgt_i = Pij_e_xy_avgt_i./nu_av;
Pij_e_xz_avgt_i = Pij_e_xz_avgt_i./nu_av;
Pij_e_yy_avgt_i = Pij_e_yy_avgt_i./nu_av;
Pij_e_yz_avgt_i = Pij_e_yz_avgt_i./nu_av;
Pij_e_zz_avgt_i = Pij_e_zz_avgt_i./nu_av;

n_avgt_i = n_avgt_i./nu_av;

% Composed quentities
n_i_vix_avgt_i = n_i_vix_avgt_i./nu_av; % there is an isue here with the name of the variable
n_i_viy_avgt_i = n_i_viy_avgt_i./nu_av;
n_i_viz_avgt_i = n_i_viz_avgt_i./nu_av;

n_e_vex_avgt_i = n_e_vex_avgt_i./nu_av;
n_e_vey_avgt_i = n_e_vey_avgt_i./nu_av;
n_e_vez_avgt_i = n_e_vez_avgt_i./nu_av;

n_vx_avgt_i = n_vx_avgt_i./nu_av;
n_vy_avgt_i = n_vy_avgt_i./nu_av;
n_vz_avgt_i = n_vz_avgt_i./nu_av;

ni_vi_x_Bx_avgt_i = ni_vi_x_Bx_avgt_i./nu_av;
ni_vi_x_By_avgt_i = ni_vi_x_By_avgt_i./nu_av;
ni_vi_x_Bz_avgt_i = ni_vi_x_Bz_avgt_i./nu_av;

ne_ve_x_Bx_avgt_i = ne_ve_x_Bx_avgt_i./nu_av;
ne_ve_x_By_avgt_i = ne_ve_x_By_avgt_i./nu_av;
ne_ve_x_Bz_avgt_i = ne_ve_x_Bz_avgt_i./nu_av;

n_v_x_Bx_avgt_i = n_v_x_Bx_avgt_i./nu_av;
n_v_x_By_avgt_i = n_v_x_By_avgt_i./nu_av;
n_v_x_Bz_avgt_i = n_v_x_Bz_avgt_i./nu_av;

ni_vivi_xx_avgt_i = ni_vivi_xx_avgt_i./nu_av;  
ni_vivi_xy_avgt_i = ni_vivi_xy_avgt_i./nu_av;
ni_vivi_xz_avgt_i = ni_vivi_xz_avgt_i./nu_av;
ni_vivi_yy_avgt_i = ni_vivi_yy_avgt_i./nu_av;
ni_vivi_yz_avgt_i = ni_vivi_yz_avgt_i./nu_av;
ni_vivi_zz_avgt_i = ni_vivi_zz_avgt_i./nu_av;

ne_veve_xx_avgt_i = ne_veve_xx_avgt_i./nu_av;
ne_veve_xy_avgt_i = ne_veve_xy_avgt_i./nu_av;
ne_veve_xz_avgt_i = ne_veve_xz_avgt_i./nu_av;
ne_veve_yy_avgt_i = ne_veve_yy_avgt_i./nu_av;
ne_veve_yz_avgt_i = ne_veve_yz_avgt_i./nu_av;
ne_veve_zz_avgt_i = ne_veve_zz_avgt_i./nu_av;

n_vv_xx_avgt_i = n_vv_xx_avgt_i./nu_av; 
n_vv_xy_avgt_i = n_vv_xy_avgt_i./nu_av;
n_vv_xz_avgt_i = n_vv_xz_avgt_i./nu_av;
n_vv_yy_avgt_i = n_vv_yy_avgt_i./nu_av;
n_vv_yz_avgt_i = n_vv_yz_avgt_i./nu_av;
n_vv_zz_avgt_i = n_vv_zz_avgt_i./nu_av;
%----------------------------------------------------------------------

% For the fluctuations
%----------------------------------------------------------------------
del_Ex = del_Ex_1./nu_av;
del_Ey = del_Ey_1./nu_av;
del_Ez = del_Ez_1./nu_av;

del_n_e = del_n_e_1./nu_av;
del_n_i = del_n_i_1./nu_av;

del_n = del_n_1./nu_av;
%----------------------------------------------------------------------
del_n_i_del_Ex = del_n_i_del_Ex_1./nu_av;
del_n_i_del_Ey = del_n_i_del_Ey_1./nu_av;
del_n_i_del_Ez = del_n_i_del_Ez_1./nu_av;

del_n_e_del_Ex = del_n_e_del_Ex_1./nu_av;
del_n_e_del_Ey = del_n_e_del_Ey_1./nu_av;
del_n_e_del_Ez = del_n_e_del_Ez_1./nu_av;

del_n_del_Ex = del_n_del_Ex_1./nu_av;
del_n_del_Ey = del_n_del_Ey_1./nu_av;
del_n_del_Ez = del_n_del_Ez_1./nu_av;
%----------------------------------------------------------------------

%----------------------------------------------------------------------
clearvars *_1
%----------------------------------------------------------------------

% compute the gradients and divergence of the vectors ans tensors.
%Grad_B
%----------------------------------------------------------------------
[By_avgt_i_z,By_avgt_i_y] = gradient(By_avgt_i);
[Bz_avgt_i_z,Bz_avgt_i_y] = gradient(Bz_avgt_i);

%grad_fact = 4;

By_avgt_i_z = By_avgt_i_z/(grad_fact.*resz);   By_avgt_i_y = By_avgt_i_y/(grad_fact.*resy);
Bz_avgt_i_z = Bz_avgt_i_z/(grad_fact.*resz);   Bz_avgt_i_y = Bz_avgt_i_y/(grad_fact.*resy);
%----------------------------------------------------------------------

%Grad_Pi
%----------------------------------------------------------------------
[Pij_i_xx_avgt_i_z, Pij_i_xx_avgt_i_y] = gradient(Pij_i_xx_avgt_i);
[Pij_i_yy_avgt_i_z, Pij_i_yy_avgt_i_y] = gradient(Pij_i_yy_avgt_i);
[Pij_i_zz_avgt_i_z, Pij_i_zz_avgt_i_y] = gradient(Pij_i_zz_avgt_i);
[Pij_i_xy_avgt_i_z, Pij_i_xy_avgt_i_y] = gradient(Pij_i_xy_avgt_i);
[Pij_i_xz_avgt_i_z, Pij_i_xz_avgt_i_y] = gradient(Pij_i_xz_avgt_i);
[Pij_i_yz_avgt_i_z, Pij_i_yz_avgt_i_y] = gradient(Pij_i_yz_avgt_i);
%----------------------------------------------------------------------
%----------------------------------------------------------------------
Div_Pi_x_avgt_i = Pij_i_xy_avgt_i_y/(grad_fact.*resy) + Pij_i_xz_avgt_i_z/(grad_fact.*resz);
Div_Pi_y_avgt_i = Pij_i_yy_avgt_i_y/(grad_fact.*resy) + Pij_i_yz_avgt_i_z/(grad_fact.*resz);
Div_Pi_z_avgt_i = Pij_i_yz_avgt_i_y/(grad_fact.*resy) + Pij_i_zz_avgt_i_z/(grad_fact.*resz);
%----------------------------------------------------------------------

%Grad_Pe
%----------------------------------------------------------------------
[Pij_e_xx_avgt_i_z, Pij_e_xx_avgt_i_y] = gradient(Pij_e_xx_avgt_i);
[Pij_e_yy_avgt_i_z, Pij_e_yy_avgt_i_y] = gradient(Pij_e_yy_avgt_i);
[Pij_e_zz_avgt_i_z, Pij_e_zz_avgt_i_y] = gradient(Pij_e_zz_avgt_i);
[Pij_e_xy_avgt_i_z, Pij_e_xy_avgt_i_y] = gradient(Pij_e_xy_avgt_i);
[Pij_e_xz_avgt_i_z, Pij_e_xz_avgt_i_y] = gradient(Pij_e_xz_avgt_i);
[Pij_e_yz_avgt_i_z, Pij_e_yz_avgt_i_y] = gradient(Pij_e_yz_avgt_i);
%----------------------------------------------------------------------
%----------------------------------------------------------------------
Div_Pe_x_avgt_i = Pij_e_xy_avgt_i_y/(grad_fact.*resy) + Pij_e_xz_avgt_i_z/(grad_fact.*resz);
Div_Pe_y_avgt_i = Pij_e_yy_avgt_i_y/(grad_fact.*resy) + Pij_e_yz_avgt_i_z/(grad_fact.*resz);
Div_Pe_z_avgt_i = Pij_e_yz_avgt_i_y/(grad_fact.*resy) + Pij_e_zz_avgt_i_z/(grad_fact.*resz);
%----------------------------------------------------------------------

% The grad of the average of the product ni_vivi_xx_avgt_i
%Grad_ni_vivi_avg
%----------------------------------------------------------------------
[ni_vivi_xx_avgt_i_z, ni_vivi_xx_avgt_i_y] = gradient(ni_vivi_xx_avgt_i);
[ni_vivi_xy_avgt_i_z, ni_vivi_xy_avgt_i_y] = gradient(ni_vivi_xy_avgt_i);
[ni_vivi_xz_avgt_i_z, ni_vivi_xz_avgt_i_y] = gradient(ni_vivi_xz_avgt_i);
[ni_vivi_yy_avgt_i_z, ni_vivi_yy_avgt_i_y] = gradient(ni_vivi_yy_avgt_i);
[ni_vivi_yz_avgt_i_z, ni_vivi_yz_avgt_i_y] = gradient(ni_vivi_yz_avgt_i);
[ni_vivi_zz_avgt_i_z, ni_vivi_zz_avgt_i_y] = gradient(ni_vivi_zz_avgt_i);
%----------------------------------------------------------------------
%----------------------------------------------------------------------
Div_ni_vivi_avg_i_x = (ni_vivi_xy_avgt_i_y/(grad_fact.*resy) + ni_vivi_xz_avgt_i_z/(grad_fact.*resz));
Div_ni_vivi_avg_i_y = (ni_vivi_yy_avgt_i_y/(grad_fact.*resy) + ni_vivi_yz_avgt_i_z/(grad_fact.*resz));
Div_ni_vivi_avg_i_z = (ni_vivi_yz_avgt_i_y/(grad_fact.*resy) + ni_vivi_zz_avgt_i_z/(grad_fact.*resz));
%----------------------------------------------------------------------

%Grad_ne_veve_avg
%----------------------------------------------------------------------
[ne_veve_xx_avgt_i_z, ne_veve_xx_avgt_i_y] = gradient(ne_veve_xx_avgt_i);
[ne_veve_xy_avgt_i_z, ne_veve_xy_avgt_i_y] = gradient(ne_veve_xy_avgt_i);
[ne_veve_xz_avgt_i_z, ne_veve_xz_avgt_i_y] = gradient(ne_veve_xz_avgt_i);
[ne_veve_yy_avgt_i_z, ne_veve_yy_avgt_i_y] = gradient(ne_veve_yy_avgt_i);
[ne_veve_yz_avgt_i_z, ne_veve_yz_avgt_i_y] = gradient(ne_veve_yz_avgt_i);
[ne_veve_zz_avgt_i_z, ne_veve_zz_avgt_i_y] = gradient(ne_veve_zz_avgt_i);
%----------------------------------------------------------------------
%----------------------------------------------------------------------
Div_ne_veve_avg_i_x = (ne_veve_xy_avgt_i_y/(grad_fact.*resy) + ne_veve_xz_avgt_i_z/(grad_fact.*resz));
Div_ne_veve_avg_i_y = (ne_veve_yy_avgt_i_y/(grad_fact.*resy) + ne_veve_yz_avgt_i_z/(grad_fact.*resz));
Div_ne_veve_avg_i_z = (ne_veve_yz_avgt_i_y/(grad_fact.*resy) + ne_veve_zz_avgt_i_z/(grad_fact.*resz));
%----------------------------------------------------------------------

%Grad_n_vv_avg
%----------------------------------------------------------------------
[n_vv_xx_avgt_i_z, n_vv_xx_avgt_i_y] = gradient(n_vv_xx_avgt_i);
[n_vv_xy_avgt_i_z, n_vv_xy_avgt_i_y] = gradient(n_vv_xy_avgt_i);
[n_vv_xz_avgt_i_z, n_vv_xz_avgt_i_y] = gradient(n_vv_xz_avgt_i);
[n_vv_yy_avgt_i_z, n_vv_yy_avgt_i_y] = gradient(n_vv_yy_avgt_i);
[n_vv_yz_avgt_i_z, n_vv_yz_avgt_i_y] = gradient(n_vv_yz_avgt_i);
[n_vv_zz_avgt_i_z, n_vv_zz_avgt_i_y] = gradient(n_vv_zz_avgt_i);
%----------------------------------------------------------------------
%----------------------------------------------------------------------
Div_n_vv_avg_i_x = (n_vv_xy_avgt_i_y/(grad_fact.*resy) + n_vv_xz_avgt_i_z/(grad_fact.*resz));
Div_n_vv_avg_i_y = (n_vv_yy_avgt_i_y/(grad_fact.*resy) + n_vv_yz_avgt_i_z/(grad_fact.*resz));
Div_n_vv_avg_i_z = (n_vv_yz_avgt_i_y/(grad_fact.*resy) + n_vv_zz_avgt_i_z/(grad_fact.*resz));
%----------------------------------------------------------------------

% The grad of the product of the averages ni_av_vivi_avg_xx_i
%----------------------------------------------------------------------
ni_av_vivi_avg_xx_i = n_i_avgt_i .* v_ix_avgt_i .* v_ix_avgt_i;
ni_av_vivi_avg_xy_i = n_i_avgt_i .* v_ix_avgt_i .* v_iy_avgt_i;
ni_av_vivi_avg_xz_i = n_i_avgt_i .* v_ix_avgt_i .* v_iz_avgt_i;
ni_av_vivi_avg_yy_i = n_i_avgt_i .* v_iy_avgt_i .* v_iy_avgt_i;
ni_av_vivi_avg_yz_i = n_i_avgt_i .* v_iy_avgt_i .* v_iz_avgt_i;
ni_av_vivi_avg_zz_i = n_i_avgt_i .* v_iz_avgt_i .* v_iz_avgt_i;

ne_av_veve_avg_xx_i = n_e_avgt_i .* v_ex_avgt_i .* v_ex_avgt_i;
ne_av_veve_avg_xy_i = n_e_avgt_i .* v_ex_avgt_i .* v_ey_avgt_i;
ne_av_veve_avg_xz_i = n_e_avgt_i .* v_ex_avgt_i .* v_ez_avgt_i;
ne_av_veve_avg_yy_i = n_e_avgt_i .* v_ey_avgt_i .* v_ey_avgt_i;
ne_av_veve_avg_yz_i = n_e_avgt_i .* v_ey_avgt_i .* v_ez_avgt_i;
ne_av_veve_avg_zz_i = n_e_avgt_i .* v_ez_avgt_i .* v_ez_avgt_i;

n_av_vv_avg_xx_i = n_avgt_i .* v_x_avgt_i .* v_x_avgt_i;
n_av_vv_avg_xy_i = n_avgt_i .* v_x_avgt_i .* v_y_avgt_i;
n_av_vv_avg_xz_i = n_avgt_i .* v_x_avgt_i .* v_z_avgt_i;
n_av_vv_avg_yy_i = n_avgt_i .* v_y_avgt_i .* v_y_avgt_i;
n_av_vv_avg_yz_i = n_avgt_i .* v_y_avgt_i .* v_z_avgt_i;
n_av_vv_avg_zz_i = n_avgt_i .* v_z_avgt_i .* v_z_avgt_i;
%----------------------------------------------------------------------

%Grad_ni_av_vivi_av
%----------------------------------------------------------------------
[ni_av_vivi_avg_xx_i_z, ni_av_vivi_avg_xx_i_y] = gradient(ni_av_vivi_avg_xx_i);
[ni_av_vivi_avg_xy_i_z, ni_av_vivi_avg_xy_i_y] = gradient(ni_av_vivi_avg_xy_i);
[ni_av_vivi_avg_xz_i_z, ni_av_vivi_avg_xz_i_y] = gradient(ni_av_vivi_avg_xz_i);
[ni_av_vivi_avg_yy_i_z, ni_av_vivi_avg_yy_i_y] = gradient(ni_av_vivi_avg_yy_i);
[ni_av_vivi_avg_yz_i_z, ni_av_vivi_avg_yz_i_y] = gradient(ni_av_vivi_avg_yz_i);
[ni_av_vivi_avg_zz_i_z, ni_av_vivi_avg_zz_i_y] = gradient(ni_av_vivi_avg_zz_i);
%----------------------------------------------------------------------
%----------------------------------------------------------------------
Div_ni_av_vivi_avg_i_x = (ni_av_vivi_avg_xy_i_y/(grad_fact.*resy) + ni_av_vivi_avg_xz_i_z/(grad_fact.*resz));
Div_ni_av_vivi_avg_i_y = (ni_av_vivi_avg_yy_i_y/(grad_fact.*resy) + ni_av_vivi_avg_yz_i_z/(grad_fact.*resz));
Div_ni_av_vivi_avg_i_z = (ni_av_vivi_avg_yz_i_y/(grad_fact.*resy) + ni_av_vivi_avg_zz_i_z/(grad_fact.*resz));
%----------------------------------------------------------------------

%Grad_ne_av_veve_av
%----------------------------------------------------------------------
[ne_av_veve_avg_xx_i_z, ne_av_veve_avg_xx_i_y] = gradient(ne_av_veve_avg_xx_i);
[ne_av_veve_avg_xy_i_z, ne_av_veve_avg_xy_i_y] = gradient(ne_av_veve_avg_xy_i);
[ne_av_veve_avg_xz_i_z, ne_av_veve_avg_xz_i_y] = gradient(ne_av_veve_avg_xz_i);
[ne_av_veve_avg_yy_i_z, ne_av_veve_avg_yy_i_y] = gradient(ne_av_veve_avg_yy_i);
[ne_av_veve_avg_yz_i_z, ne_av_veve_avg_yz_i_y] = gradient(ne_av_veve_avg_yz_i);
[ne_av_veve_avg_zz_i_z, ne_av_veve_avg_zz_i_y] = gradient(ne_av_veve_avg_zz_i);
%----------------------------------------------------------------------
%----------------------------------------------------------------------
Div_ne_av_veve_avg_i_x = (ne_av_veve_avg_xy_i_y/(grad_fact.*resy) + ne_av_veve_avg_xz_i_z/(grad_fact.*resz));
Div_ne_av_veve_avg_i_y = (ne_av_veve_avg_yy_i_y/(grad_fact.*resy) + ne_av_veve_avg_yz_i_z/(grad_fact.*resz));
Div_ne_av_veve_avg_i_z = (ne_av_veve_avg_yz_i_y/(grad_fact.*resy) + ne_av_veve_avg_zz_i_z/(grad_fact.*resz));
%----------------------------------------------------------------------

%Grad_n_av_vv_av
%----------------------------------------------------------------------
[n_av_vv_avg_xx_i_z, n_av_vv_avg_xx_i_y] = gradient(n_av_vv_avg_xx_i);
[n_av_vv_avg_xy_i_z, n_av_vv_avg_xy_i_y] = gradient(n_av_vv_avg_xy_i);
[n_av_vv_avg_xz_i_z, n_av_vv_avg_xz_i_y] = gradient(n_av_vv_avg_xz_i);
[n_av_vv_avg_yy_i_z, n_av_vv_avg_yy_i_y] = gradient(n_av_vv_avg_yy_i);
[n_av_vv_avg_yz_i_z, n_av_vv_avg_yz_i_y] = gradient(n_av_vv_avg_yz_i);
[n_av_vv_avg_zz_i_z, n_av_vv_avg_zz_i_y] = gradient(n_av_vv_avg_zz_i);
%----------------------------------------------------------------------
%----------------------------------------------------------------------
Div_n_av_vv_avg_i_x = (n_av_vv_avg_xy_i_y/(grad_fact.*resy) + n_av_vv_avg_xz_i_z/(grad_fact.*resz));
Div_n_av_vv_avg_i_y = (n_av_vv_avg_yy_i_y/(grad_fact.*resy) + n_av_vv_avg_yz_i_z/(grad_fact.*resz));
Div_n_av_vv_avg_i_z = (n_av_vv_avg_yz_i_y/(grad_fact.*resy) + n_av_vv_avg_zz_i_z/(grad_fact.*resz));
%----------------------------------------------------------------------
%----------------------------------------------------------------------
% So far everything is working. The del_* and *_i are all time averaged quantities.!!! 
%----------------------------------------------------------------------

clearvars v_i_bax v_i_bay v_i_baz v_i_upx v_i_upy v_i_upz
clearvars v_e_bax v_e_bay v_e_baz v_e_upx v_e_upy v_e_upz
clearvars n_v_x_B_in n_vv_in ne_ve_x_B_in ne_veve_in ni_vi_x_B_in ni_vivi_in
clearvars PPij_i_ba PPij_i_up PPij_e_ba PPij_e_up         

% Making the Plots for electrons
%----------------------------------------------------------------------
%xlim_a = 1; xlim_b = ssz(1,3);
%ylim_a = 1; ylim_b = ssz(1,2);

sss=size(Bx_avgt_i);
size_X=sss;
zll=linspace(-Lz,Lz,size_X(2)); %Jeff flag it works with (1,size_x(2))
yll=linspace(-Ly,Ly,size_X(1));
[ZLL, YLL] = meshgrid(zll,yll);

yticks_mine=[floor(-Ly*0.9) floor(-Ly/2) 0 floor(Ly/2) floor(Ly*0.9)];
zticks_mine=[floor(-Lz*0.9) floor(-Lz/2) 0 floor(Lz/2) floor(Lz*0.9)];

%xlim_a = zll(704); xlim_b = zll(1104);
%ylim_a = yll(454); ylim_b = yll(571);

% compute the electric field terms
%----------------------------------------------------------------------

% <E> + <ve>x<B> = -nabla . P_{e}/e<ne> - (me/e<ne>) nabla . (<ne><ve><ve>) + D + T + I

% D = - <dne E> / <ne> 

% T = - <nevexB>/<ne> + <ve>x<B>

% I = - (me/e<ne>) (nabla . <neveve> - nabla . (<ne><ve><ve>)) 
%----------------------------------------------------------------------

%----------------------------------------------------------------------
V_ish=1;% WHY IS IT THAT I HAVE TO DIVIDE BY B0????
%V_ish=1;

% Making the plots
%--------------------------------------------------------------------------
normi_f = B0*VA2c;
%normi_f = B0*Vae_b;
c
lw=2;

% In this plot I still need to include the time derivative.
sli_y = floor(ssz(2)/2);%380;
sli_z = floor(ssz(3)/2);%700;

xlim_a = -2; xlim_b = 2;
ylim_a = -2; ylim_b = 2;

sli_y = 512;%380;
sli_z = 452;%700;
xlim_a = -16; xlim_b = 16;
ylim_a = -16; ylim_b = 16;

%--------------------------------------------------------------------------

% This is the plot of the ohms law. 
%--------------------------------------------------------------------------
fs=18;

% This is the log of the density and of the Ex to see if there are
% fluctuations
%--------------------------------------------------------------------------
f1=figure(1);
h1=subplot(2,2,1);
dump = (n_e_avgt_i) ;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
xline(zll(sli_z),'--k','LineWidth',lw);
ax.FontSize=fs;
lgnd=legend([h1],'$log(n_e)$','Interpreter','latex','FontSize',fs);
hold off

h2 = subplot(2,2,2)
dump = log(abs(Ex_avgt_i)) ;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
xline(zll(sli_z),'--k','LineWidth',lw);
ax.FontSize=fs;
lgnd=legend([h2],'$log(|E_{x}|)$','Interpreter','latex','FontSize',fs);
hold off

subplot(2,2,3)
dump = (n_e_avgt_i) ;
plot(yll,dump(:,sli_z),'k','LineWidth',lw);
hold on
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.YLabel.String = '$log(n_{e})$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$y / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ax.FontSize=fs;
hold off

subplot(2,2,4)
dump = log(abs(Ex_avgt_i)) ;
plot(yll,dump(:,sli_z),'k','LineWidth',lw);
hold on
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.YLabel.String = '$log(|E_{x}|)$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$y / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ax.FontSize=fs;
hold off
%--------------------------------------------------------------------------


x0=45;y0=54;xx1=1200;yy1=710;
%--------------------------------------------------------------------------
f2=figure(2);
set(gcf,'position',[x0,y0,xx1,yy1])
% lets look at the normal momentum equation for the electrons
%--------------------------------------------------------------------------
%E+vexB = - (me/neq)*(d\dt(neve)) - (me/neq)*(nabla .(neveve)) - (1/neq)*(nabla .(Pe))
%--------------------------------------------------------------------------
ve_av_x_B_av_x = (v_ey_avgt_i .* Bz_avgt_i - v_ez_avgt_i .* By_avgt_i)/V_ish;
LH_x_e = Ex_avgt_i + ve_av_x_B_av_x./1;
RH_x_1_e = -(1./n_e_avgt_i) .* Div_Pe_x_avgt_i;
RH_x_2_e = - (me./n_e_avgt_i) .* Div_ne_av_veve_avg_i_x./(1); 
RH_x_e = RH_x_1_e + RH_x_2_e;   
%--------------------------------------------------------------------------
subplot(2,1,1)
dum_1 = (Ex_avgt_i)./normi_f;
plot(yll,dum_1(:,sli_z),'k','LineWidth',lw);
hold on
dum_2 = -ve_av_x_B_av_x./(normi_f);
plot(yll,dum_2(:,sli_z),'--k','LineWidth',lw);
dum_6 = RH_x_1_e./normi_f ; 
plot(yll,dum_6(:,sli_z),'r','LineWidth',lw);
dum_6 = RH_x_2_e./normi_f ; 
plot(yll,dum_6(:,sli_z),'b','LineWidth',lw);
dum_6 = (LH_x_e - RH_x_e)./normi_f; 
plot(yll,dum_6(:,sli_z),'--g','LineWidth',lw);
xlim([ylim_a, ylim_b]); 

ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = '$y / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ax.FontSize=fs;

legend({'$\langle E_{x} \rangle $',...
        '$(-\langle v_{e} \rangle \times \langle B \rangle)_{x}$',...
        '$-(\nabla \cdot \langle P_{e} \rangle)_{x}/e\langle n_{e} \rangle$',...
        '$-(m_{e}\nabla \cdot (\langle n_{e} \rangle \langle v_{e} \rangle \langle v_{e} \rangle)_{x}/e\langle n_{e} \rangle$',...
        '$LH_{e,x} - RH_{e,x}$',...
        },'Interpreter','latex','FontSize',fs,...
        'Location','southeastout','NumColumns',1)
hold off

%--------------------------------------------------------------------------
% compute the electric field terms
%----------------------------------------------------------------------
% <E> + <ve>x<B> = -nabla . P_{e}/e<ne> - (me/e<ne>) nabla . (<ne><ve><ve>) + D + T + I
% D = - <dne E> / <ne> 
% T = - <nevexB>/<ne> + <ve>x<B>
% I = - (me/e<ne>) (nabla . <neveve> - nabla . (<ne><ve><ve>)) 
%----------------------------------------------------------------------
ve_av_x_B_av_x = (v_ey_avgt_i .* Bz_avgt_i - v_ez_avgt_i .* By_avgt_i)/V_ish;
LH_x_e = Ex_avgt_i + ve_av_x_B_av_x;
RH_x_1_e = -(1./n_e_avgt_i) .* Div_Pe_x_avgt_i;
RH_x_2_e = - (me./n_e_avgt_i) .* Div_ne_av_veve_avg_i_x; 
D_x_e = - del_n_e_del_Ex ./ n_e_avgt_i;
T_x_e = - (ne_ve_x_Bx_avgt_i./(n_e_avgt_i.*1)) + ve_av_x_B_av_x;
I_x_e = - (me./n_e_avgt_i) .* (Div_ne_veve_avg_i_x  - Div_ne_av_veve_avg_i_x) ;   
RH_x_e = RH_x_1_e + RH_x_2_e + D_x_e + T_x_e + I_x_e;  
%----------------------------------------------------------------------
subplot(2,1,2)
dum_1 = (Ex_avgt_i)./normi_f;
plot(yll,dum_1(:,sli_z),'k','LineWidth',lw);
hold on
dum_2 = -ve_av_x_B_av_x./(1.*normi_f);
plot(yll,dum_2(:,sli_z),'--k','LineWidth',lw);
dum_6 = RH_x_1_e./normi_f ; 
plot(yll,dum_6(:,sli_z),'r','LineWidth',lw);
dum_6 = RH_x_2_e./normi_f ; 
plot(yll,dum_6(:,sli_z),'b','LineWidth',lw);
dum_3 = D_x_e./normi_f; 
plot(yll,dum_3(:,sli_z),'m','LineWidth',lw);
dum_4 = T_x_e./normi_f; 
plot(yll,dum_4(:,sli_z),'c','LineWidth',lw);
dum_5 = I_x_e./normi_f; 
plot(yll,dum_5(:,sli_z),'--c','LineWidth',lw);
dum_6 = (LH_x_e - RH_x_e)./normi_f; 
plot(yll,dum_6(:,sli_z),'--g','LineWidth',lw);
xlim([ylim_a, ylim_b]); 

ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = '$y / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ax.FontSize=fs;

legend({'$\langle E_{x} \rangle $',...
        '$(-\langle v_{e} \rangle \times \langle B \rangle)_{x}$',...
        '$-(\nabla \cdot \langle P_{e} \rangle)_{x}/e\langle n_{e} \rangle$',...
        '$-(m_{e}\nabla \cdot (\langle n_{e} \rangle \langle v_{e} \rangle \langle v_{e} \rangle)_{x}/e\langle n_{e} \rangle$',...
        '$D_{e,x}$',...
        '$T_{e,x}$',...
        '$I_{e,x}$',...
        '$LH_{e,x} - RH_{e,x}$',...
        },'Interpreter','latex','FontSize',fs,...
        'Location','southeastout','NumColumns',1)
hold off
%----------------------------------------------------------------------


%sli_y = 512; sli_z = 552; 
%----------------------------------------------------------------------
f3=figure(3);
set(gcf,'position',[x0,y0,xx1,yy1])
%--------------------------------------------------------------------------
subplot(2,1,1)
ve_av_x_B_av_x = (v_ey_avgt_i .* Bz_avgt_i - v_ez_avgt_i .* By_avgt_i);
dum1 = Ex_avgt_i ./ normi_f;
dum2 = - ve_av_x_B_av_x ./ normi_f;
dum3 = -(1./n_e_avgt_i) .* Div_Pe_x_avgt_i ./ normi_f;
dum4 = - (me./n_e_avgt_i) .* Div_ne_av_veve_avg_i_x ./ normi_f; 
dum5 = - del_n_e_del_Ex ./ (n_e_avgt_i.*normi_f);
dum6 = - ne_ve_x_Bx_avgt_i ./ (n_e_avgt_i.*normi_f); 
dum7 = - (me./n_e_avgt_i) .* (Div_ne_veve_avg_i_x) ./ normi_f;
dum8 = dum1 - (dum2 + dum3 + dum4);
%--------------------------------------------------------------------------
plot(yll,dum1(:,sli_z),'k','LineWidth',lw);
hold on
plot(yll,dum2(:,sli_z),'--k','LineWidth',lw);
plot(yll,dum3(:,sli_z),'r','LineWidth',lw);
plot(yll,dum4(:,sli_z),'b','LineWidth',lw);
plot(yll,dum5(:,sli_z),'c','LineWidth',lw);
plot(yll,dum6(:,sli_z),'c--','LineWidth',lw);
plot(yll,dum7(:,sli_z),'--b','LineWidth',lw);
plot(yll,dum8(:,sli_z),'m','LineWidth',lw);
xlim([ylim_a, ylim_b]); 

ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = '$y / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ax.FontSize=fs;

legend({'$\langle E_{x} \rangle $',...
        '$(-\langle v_{e} \rangle \times \langle B \rangle)_{x}$',...
        '$-(\nabla \cdot \langle P_{e} \rangle)_{x}/e\langle n_{e} \rangle$',...
        '$-(\nabla \cdot \langle n_{e} \rangle \langle v_{e} \rangle \langle v_{e} \rangle)_{x}/e\langle n_{e} \rangle$',...
        '$D_{e,x}$',...
        '$-\langle n_{e} v_{e} \times B \rangle)_{x}/\langle n_{e} \rangle$',...
        '$-(\nabla \cdot \langle n_{e}  v_{e}  v_{e} \rangle)_{x}/e\langle n_{e} \rangle$',...
        '$LH_{e,x} - RH_{e,x}$',...
        },'Interpreter','latex','FontSize',fs,...
        'Location','southeastout','NumColumns',1)
hold off
%--------------------------------------------------------------------------
subplot(2,1,2)
vi_av_x_B_av_x = (v_iy_avgt_i .* Bz_avgt_i - v_iz_avgt_i .* By_avgt_i);
dum1 = Ex_avgt_i ./normi_f;
dum2 = - vi_av_x_B_av_x./normi_f;
dum3 = (1./n_i_avgt_i) .* Div_Pi_x_avgt_i./normi_f;
dum4 =  (mi./n_i_avgt_i) .* Div_ni_av_vivi_avg_i_x./normi_f; 
dum5 = - del_n_i_del_Ex ./ (n_i_avgt_i.*normi_f);
dum6 = - ni_vi_x_Bx_avgt_i./(n_i_avgt_i.*normi_f); 
dum7 =  (mi./n_i_avgt_i) .* (Div_ni_vivi_avg_i_x )./normi_f;   
dum8 = dum1 - (dum2 + dum3 + dum4);
%--------------------------------------------------------------------------
plot(yll,dum1(:,sli_z),'k','LineWidth',lw);
hold on
plot(yll,dum2(:,sli_z),'--k','LineWidth',lw);
plot(yll,dum3(:,sli_z),'r','LineWidth',lw);
plot(yll,dum4(:,sli_z),'b','LineWidth',lw);
plot(yll,dum5(:,sli_z),'c','LineWidth',lw);
plot(yll,dum6(:,sli_z),'c--','LineWidth',lw);
plot(yll,dum7(:,sli_z),'--b','LineWidth',lw);
plot(yll,dum8(:,sli_z),'m','LineWidth',lw);
xlim([ylim_a, ylim_b]); 

ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = '$y / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ax.FontSize=fs;

legend({'$\langle E_{x} \rangle $',...
        '$(-\langle v_{i} \rangle \times \langle B \rangle)_{x}$',...
        '$(\nabla \cdot \langle P_{i} \rangle)_{x}/q\langle n_{i} \rangle$',...
        '$(\nabla \cdot \langle n_{i} \rangle \langle v_{i} \rangle \langle v_{i} \rangle)_{x}/q\langle n_{i} \rangle$',...
        '$D_{i,x}$',...
        '$-\langle n_{i} v_{i} \times B \rangle)_{x}/\langle n_{i} \rangle$',...
        '$(\nabla \cdot \langle n_{i}  v_{i}  v_{i} \rangle)_{x}/q\langle n_{i} \rangle$',...
        '$LH_{e,x} - RH_{e,x}$',...
        },'Interpreter','latex','FontSize',fs,...
        'Location','southeastout','NumColumns',1)
hold off
%--------------------------------------------------------------------------


cd(path_s2)
% This is to see the components of E, B and vxB to see why it is not
% balancing.
%--------------------------------------------------------------------------
% E, B, vxB, 1D cut
%--------------------------------------------------------------------------
f4=figure(4)
%--------------------------------------------------------------------------
set(gcf,'position',[x0,y0,xx1,yy1])
h1=subplot(3,3,1);
dump = v_ex_avgt_i ;
%dump = n_e_avgt_i ;
plot(yll,dump(:,sli_z),'k','LineWidth',lw);
hold on
caxlim=max(max(abs(dump))).*frac;
%ylim([-caxlim, caxlim]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = '$y / d_{i}$'; 
ax.YLabel.String = '$v_{e,x}$'; 
ax.FontSize=fs;
hold off

h1=subplot(3,3,2);
dump = v_ey_avgt_i ;
plot(yll,dump(:,sli_z),'k','LineWidth',lw);
hold on
caxlim=max(max(abs(dump))).*frac;
%ylim([-caxlim, caxlim]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = '$y / d_{i}$'; 
ax.YLabel.String = '$v_{e,y}$'; 
ax.FontSize=fs;

hold off
h1=subplot(3,3,3);
dump = v_ez_avgt_i ;
plot(yll,dump(:,sli_z),'k','LineWidth',lw);
hold on
caxlim=max(max(abs(dump))).*frac;
%ylim([-caxlim, caxlim]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = '$y / d_{i}$'; 
ax.YLabel.String = '$v_{e,z}$'; 
ax.FontSize=fs;
hold off

h1=subplot(3,3,4);
dump = Bx_avgt_i ;
plot(yll,dump(:,sli_z),'k','LineWidth',lw);
hold on
caxlim=max(max(abs(dump))).*frac;
%ylim([-caxlim, caxlim]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = '$y / d_{i}$'; 
ax.YLabel.String = '$B_{x}$'; 
ax.FontSize=fs;
hold off
h1=subplot(3,3,5);
dump = By_avgt_i ;
plot(yll,dump(:,sli_z),'k','LineWidth',lw);
hold on
caxlim=max(max(abs(dump))).*frac;
%ylim([-caxlim, caxlim]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = '$y / d_{i}$'; 
ax.YLabel.String = '$B_{y}$'; 
ax.FontSize=fs;
hold off
h1=subplot(3,3,6);
dump = Bz_avgt_i ;
plot(yll,dump(:,sli_z),'k','LineWidth',lw);
hold on
caxlim=max(max(abs(dump))).*frac;
%ylim([-caxlim, caxlim]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = '$y / d_{i}$'; 
ax.YLabel.String = '$B_{z}$'; 
ax.FontSize=fs;
hold off

h1=subplot(3,3,7);
dump = (v_ey_avgt_i.*Bz_avgt_i - v_ez_avgt_i.*By_avgt_i)/V_ish;
plot(yll,dump(:,sli_z),'k','LineWidth',lw);
hold on
dump2=Ex_avgt_i;
plot(yll,dump2(:,sli_z),'r','LineWidth',lw);
caxlim=max(max(abs(dump))).*frac;
caxlim = 0.008;
%ylim([-caxlim, caxlim]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = '$y / d_{i}$'; 
ax.YLabel.String = '$(v_{e} \times B)_{x}, \ E_{x}$'; 
ax.FontSize=fs;
hold off

h1=subplot(3,3,8);
dump = (v_ez_avgt_i.*Bx_avgt_i - v_ex_avgt_i.*Bz_avgt_i)/V_ish;
plot(yll,dump(:,sli_z),'k','LineWidth',lw);
hold on
dump2=Ey_avgt_i;
plot(yll,dump2(:,sli_z),'r','LineWidth',lw);
caxlim=max(max(abs(dump))).*frac;
caxlim = 0.002;
%ylim([-caxlim, caxlim]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = '$y / d_{i}$'; 
ax.YLabel.String = '$(v_{e} \times B)_{y}, \ E_{y}$'; 
ax.FontSize=fs;
hold off

h1=subplot(3,3,9);
dump = (v_ex_avgt_i.*By_avgt_i - v_ey_avgt_i.*Bx_avgt_i)/V_ish;
plot(yll,dump(:,sli_z),'k','LineWidth',lw);
hold on
dump2=Ez_avgt_i;
plot(yll,dump2(:,sli_z),'r','LineWidth',lw);
caxlim=max(max(abs(dump))).*frac;
caxlim = 0.002;
%ylim([-caxlim, caxlim]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = '$y / d_{i}$'; 
ax.YLabel.String = '$(v_{e} \times B)_{z}, \ E_{z}$'; 
ax.FontSize=fs;
hold off
%camroll(-90)
%--------------------------------------------------------------------------


% E, B, vxB, 2D
%--------------------------------------------------------------------------
f5=figure(5)
set(gcf,'position',[x0,y0,xx1,yy1])
h1=subplot(3,3,1);
dump = v_ex_avgt_i ;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
colormap(h1,BWR); caxlim=max(max(abs(dump))).*frac;
caxis([-caxlim, caxlim]);
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
xline(zll(sli_z),'--k','LineWidth',lw);
ax.FontSize=fs;
lgnd=legend([h1],'$v_{e,x}$','Interpreter','latex','FontSize',fs);
hold off

h1=subplot(3,3,2);
dump = v_ey_avgt_i ;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
colormap(h1,BWR); caxlim=max(max(abs(dump))).*frac;
caxis([-caxlim, caxlim]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
xline(zll(sli_z),'--k','LineWidth',lw);
ax.FontSize=fs;
lgnd=legend([h1],'$v_{e,y}$','Interpreter','latex','FontSize',fs);
hold off

h1=subplot(3,3,3);
dump = v_ez_avgt_i ;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex'; 
colormap(h1,BWR); caxlim=max(max(abs(dump))).*frac;
caxis([-caxlim, caxlim]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
xline(zll(sli_z),'--k','LineWidth',lw);
ax.FontSize=fs;
lgnd=legend([h1],'$v_{e,z}$','Interpreter','latex','FontSize',fs);
hold off

h1=subplot(3,3,4);
dump = Bx_avgt_i ;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex'; 
colormap(h1,BWR); caxlim=max(max(abs(dump))).*frac;
caxis([-caxlim, caxlim]);
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
xline(zll(sli_z),'--k','LineWidth',lw);
ax.FontSize=fs;
lgnd=legend([h1],'$B_{x}$','Interpreter','latex','FontSize',fs);
hold off

h1=subplot(3,3,5);
dump = By_avgt_i ;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex'; 
colormap(h1,BWR); caxlim=max(max(abs(dump))).*frac;
caxis([-caxlim, caxlim]);
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
xline(zll(sli_z),'--k','LineWidth',lw);
ax.FontSize=fs;
lgnd=legend([h1],'$B_{y}$','Interpreter','latex','FontSize',fs);
hold off

h1=subplot(3,3,6);
dump = Bz_avgt_i ;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex'; 
colormap(h1,BWR); caxlim=max(max(abs(dump))).*frac;
caxis([-caxlim, caxlim]);
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
xline(zll(sli_z),'--k','LineWidth',lw);
ax.FontSize=fs;
lgnd=legend([h1],'$B_{z}$','Interpreter','latex','FontSize',fs);
hold off

h1=subplot(3,3,7);
dump = (v_ey_avgt_i.*Bz_avgt_i - v_ez_avgt_i.*By_avgt_i)/V_ish;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex'; 
colormap(h1,BWR); caxlim=max(max(abs(dump))).*frac;
caxis([-caxlim, caxlim]);
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
xline(zll(sli_z),'--k','LineWidth',lw);
ax.FontSize=fs;
lgnd=legend([h1],'$(v_{e} \times B)_{x}$','Interpreter','latex','FontSize',fs);
hold off

h1=subplot(3,3,8);
dump = (v_ez_avgt_i.*Bx_avgt_i - v_ex_avgt_i.*Bz_avgt_i)/V_ish;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex'; 
colormap(h1,BWR); caxlim=max(max(abs(dump))).*frac;
caxis([-caxlim, caxlim]);
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
xline(zll(sli_z),'--k','LineWidth',lw);
ax.FontSize=fs;
lgnd=legend([h1],'$(v_{e} \times B)_{y}$','Interpreter','latex','FontSize',fs);
hold off

h1=subplot(3,3,9);
dump = (v_ex_avgt_i.*By_avgt_i - v_ey_avgt_i.*Bz_avgt_i)/V_ish;
hc=pcolor(ZLL,YLL,dump);
hold on
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex'; 
colormap(h1,BWR); caxlim=max(max(abs(dump))).*frac;
caxis([-caxlim, caxlim]);
%xlim([xlim_a, xlim_b]); ylim([ylim_a, ylim_b]);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
xline(zll(sli_z),'--k','LineWidth',lw);
ax.FontSize=fs;
lgnd=legend([h1],'$(v_{e} \times B)_{z}$','Interpreter','latex','FontSize',fs);
hold off
%camroll(-90)
%--------------------------------------------------------------------------
% % 
% % %--------------------------------------------------------------------------
cd(path)
% % saveas(f1,strcat('log_ne_log_E' + string(JN) +'.png'));
saveas(f2,strcat('Ohms_x_terms_two_ways_' + string(20.88) +'.png'));
%saveas(f3,strcat('ohms_x_terms_each' + string(JN) +'.png'));
% % saveas(f4,strcat('ve_B_vexB_x_y_z_1D' + string(JN) +'.png'));
% % saveas(f5,strcat('ve_B_vexB_x_y_z_2D' + string(JN) +'.png'));
% % % %--------------------------------------------------------------------------






