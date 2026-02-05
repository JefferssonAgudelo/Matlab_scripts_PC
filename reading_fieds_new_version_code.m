% this is to read the fields from the new version of the code.

%cd '/home/UNN/pfcy6/codes/psc_harris_turb/build/mytest_jeff'
cd '/home/UNN/pfcy6/codes/PSC/psc-main/build/my_test_jeff'

path = '/home/UNN/pfcy6/codes/PSC/psc-main/build/my_test_jeff';

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
B0=0.2;
%n is normalise to the proton density n0=1
n0=1;
%Vi normalised to the proton alfven speed V_a=0.1c The alfven speed of
%electrons is Vae=10Vai
Vae=0.2;%0.2;
Va=0.2;%0.2;
%--------------------------------------------------------------------------
nb_n0 =0.1;
kb = 1.; mu0 =1.; c=1; q = 1;

Vai=0.2;
Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);

mime =1.;
mi = 1.;
me = 1. / mime; eps0=1.;
omega_pi=1;
Omega_e=Vai*sqrt(mime)*omega_pi;
Omega_i=Omega_e / mime;
TOmega_e=1/Omega_e;
TOmega_i=1/Omega_i;
omega_pe_Omega_ce=5;
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
N_jn=N;

% %--------------------------------------------------------------------
% % Making a plot for B2 as a function of time to see the growth rate of
% the instability
% %--------------------------------------------------------------------

in=8;
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

px2 = nx2; py2 = ny2; pz2 = nz2;
start = [nx1 ny1 nz1];
count = [px2 py2 pz2];

time_t_2=zeros(1,N);

B2_n=zeros(1,N);
E2_n=zeros(1,N);

U_EM2_n=zeros(1,N);
U_k_e_n=zeros(1,in);
U_k_i_n=zeros(1,in);
U_th_e_n=zeros(1,in);
U_th_i_n=zeros(1,in);

in = 21;

%for in=1:floor(N)

    %------------------------------------------------------------------
    disp(strcat('Computing step ...',S(in).name))
    fileID =  S(in).name; %change the 1 per i
    %h5disp(fileID);
    info = h5info(fileID);
    EHJ_1st = info.Groups(16).Name;
    grid_dt = info.Groups(20).Attributes;

    grid_length = info.Groups(17).Attributes;
    Lx=grid_length(4).Value(1);% - grid_length(3).Value(1);
    Ly=grid_length(4).Value(2);% - grid_length(3).Value(2);
    Lz=grid_length(4).Value(3);% - grid_length(3).Value(3);
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

    %------------------------------------------------------------------
    Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'),start,count);
    By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'),start,count);
    Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'),start,count);
    Bx2 = Bx.^2; By2 = By.^2; Bz2 = Bz.^2;
    B2 = mean((Bx2 + By2 + Bz2),'all'); % it seems the total magnetic field goes
    %clearvars Bx Bx2 By By2 Bz Bz2
    %------------------------------------------------------------------
%end

f1 = figure(1);
%subplot(2,2,1)
dum = By;
dump = dum(:,:,10);
dum_max = max(max(abs(dump)));
hc = pcolor(dump);
set(hc,'edgecolor','none')
clim([-dum_max, dum_max]);
caxis_limits = clim;
colorbar


