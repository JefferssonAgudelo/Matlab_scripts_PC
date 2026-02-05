%path = '/Users/jeffersson_agudelo/Downloads/psc_turb_harris_xz';

path = '/Users/jeffersson_agudelo/Downloads/plots_relatives_term_02';
%-----------------------------------------------------------------------------------------------------------------------

% For the scripts
path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
path_color = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';

%-----------------------------------------------------------------------------------------------------------------------

cd(path)
%------------------------------------------------------------------------
% --
S = dir(fullfile(path,'pfd.*.h5'));
N=numel(S); % number of files to use
H=zeros(N);
%--------------------------------------------------------------------------
S2 = dir(fullfile(path,'pfd_moments.*.h5'));
N2=numel(S2); % number of files to use
H2=zeros(N2);
%--------------------------------------------------------------------------

in=1;

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
%------------------------------------------------------------------

%------------------------------------------------------------------
disp(strcat('Computing step ...',S(in).name))
fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;

%----------------------------------------------------------------------
B{1,1}=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'),start,count);
B{1,2}=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'),start,count);
B{1,3}=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'),start,count);

Bx = squeeze(B{1,1});
By = squeeze(B{1,2}) - 0.1;
Bz = squeeze(B{1,3});

dB = sqrt((Bx-mean(Bx,'all')).^2 + (By-mean(By,'all')).^2  +(Bz-mean(Bz,'all')).^2 );
dB_mean = mean(dB,'all');
%----------------------------------