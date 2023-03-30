%Checking magnetic field magnitude to see if there are changes between the
%different runs

%--------------------------------------------------------------------------
% For the scripts
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
%--------------------------------------------------------------------------

%path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc100_ome5_mime1_dB002';% <---
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc100_ome5_mime1_dB005';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc100_ome5_mime1_dB01';

%path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB002';% <---
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB005';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB01';
path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_1_ppc1000_ome5_mime1_dB02';

il=4; %<-- this is for the first one

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

% %--------------------------------------------------------------------------
% B_mag_mean = zeros(4,N);
% B_mag_std = zeros(4,N);
% B_mag_max = zeros(4,N);
% %--------------------------------------------------------------------------

%jn=31;
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
        
    Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
    Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));
    
%     Ex=h5read(fileID,strcat(EHJ_1st,'/ex_ec/p0/3d'));
%     Ey=h5read(fileID,strcat(EHJ_1st,'/ey_ec/p0/3d'));
%     Ez=h5read(fileID,strcat(EHJ_1st,'/ez_ec/p0/3d'));
%     
%     Jx=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'));
%     Jy=h5read(fileID,strcat(EHJ_1st,'/jy_ec/p0/3d'));
%     Jz=h5read(fileID,strcat(EHJ_1st,'/jz_ec/p0/3d'));
%     %----------------------------------------------------------------------

    %magnitudes
    %----------------------------------------------------------------------  
    B_mag = sqrt(Bx.^2 + By.^2 + Bz.^2);
    B_mag_mean_i = mean(B_mag,'all');
    B_mag_std_i = std(B_mag,0,'all');
    B_mag_max_i = max(B_mag,[],'all');

    B_mag_mean(il,in) = B_mag_mean_i;
    B_mag_std(il,in) = B_mag_std_i;
    B_mag_max(il,in) = B_mag_max_i;

    B_mag_mean_i=0;
    B_mag_std_i=0;

    %     E_mag = sqrt(Ex.^2 + Ey.^2 + Ez.^2);
    %     J_mag = sqrt(Jx.^2 + Jy.^2 + Jz.^2);
    %     E_mag_mean_i = mean(mean(mean(E_mag)));
    %     J_mag_mean_ = mean(mean(mean(J_mag)));

    %----------------------------------------------------------------------    
    cd(path)
end

f1=figure(1);
subplot(1,3,1);
plot(B_mag_mean(1,:),'k')
hold on
plot(B_mag_mean(2,:),'r')
plot(B_mag_mean(3,:),'b')
plot(B_mag_mean(4,:),'c')
legend('002','005','01','02')
title('mean B')
hold off
subplot(1,3,2);
plot(B_mag_std(1,:),'k')
hold on
plot(B_mag_std(2,:),'r')
plot(B_mag_std(3,:),'b')
plot(B_mag_std(4,:),'c')
legend('002','005','01','02')
title('std B')
hold off
subplot(1,3,3);
plot(B_mag_max(1,:),'k')
hold on
plot(B_mag_max(2,:),'r')
plot(B_mag_max(3,:),'b')
plot(B_mag_max(4,:),'c')
legend('002','005','01','02')
title('max B')
hold off

cd(path_rec_line)
saveas(f1,'checkingdB_002_005_01_02.png');




