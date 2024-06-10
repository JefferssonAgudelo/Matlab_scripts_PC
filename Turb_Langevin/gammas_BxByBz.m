%--------------------------------------------------------------------------
% BxByBz and gammas
%--------------------------------------------------------------------------
N_kn=14;
%--------------------------------------------------------------------------
Bx2_max_T = cell(1,N_kn);
Bx2_mean_T = cell(1,N_kn);

By2_max_T = cell(1,N_kn);
By2_mean_T = cell(1,N_kn);

Bz2_max_T = cell(1,N_kn);
Bz2_mean_T = cell(1,N_kn);

gammas = cell(1,N_kn);
%--------------------------------------------------------------------------
time_t_2_T = cell(1,N_kn);
%--------------------------------------------------------------------------

for kn=1:14

    % This set shows the difference in terms of the onset.
    % ABCDE
    %----------------------------------------------------------------------------------------------------------------------
    if(kn==1)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_alone_large';
    elseif(kn==2)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large';
    elseif(kn==3)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_Ax_large';
    elseif(kn==4)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large';
    elseif(kn==5)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini_L8di_8_du02'; %<-- this is in reality L=4.
    elseif(kn==6)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large_Bg02';
        %-----------------------------------------------------------------------------------------------------------------------
        %  Cyclotron frequency runs and short wave lengths
        %----------------------------------------------------------------------------------------------------------------------
    elseif(kn==7)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1';
    elseif(kn==8)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_Omc1';
    elseif(kn==9)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kd1';
    elseif(kn==10)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_Omc1_kd1';
        %-----------------------------------------------------------------------------------------------------------------------
        %  plasma, cyclotron frequency, di, rho
        %----------------------------------------------------------------------------------------------------------------------
    elseif(kn==11)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kLd1';
    elseif(kn==12)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kLr1';
    elseif(kn==13)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_omp1_kLd1';
    elseif(kn==14)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_omp1_kLr1';
    end
    %-----------------------------------------------------------------------------------------------------------------------


% % for kn=1:4

    % % % This set shows the difference in terms of the onset.
    % % % ABCDE
    % % %----------------------------------------------------------------------------------------------------------------------
    % % if(kn==1)    
    % % path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_short_L4di';
    % % elseif(kn==2)
    % % path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_short_L4di'; 
    % % elseif(kn==3)
    % % path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_Tba_perpar_short_L4di'; 
    % % elseif(kn==4)
    % % path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_short_L4di_dB03'; 
    % % end
    % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_omp1_kLd1';
    % % %-----------------------------------------------------------------------------------------------------------------------
  
    
    % For the scripts
    path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
    path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
    path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
    %-----------------------------------------------------------------------------------------------------------------------

    %-----------------------------------------------------------------------------------------------------------------------
    % To save the plots
    path_rec_r = strcat(path,'/spectra/rec_r');
    path_rec_line = strcat(path,'/spectra/rec_line');
    path_rec_line_ByBzJx = strcat(path,'/spectra/rec_line/ByBzJx');

    if not(isfolder(path_rec_r))
        mkdir(path_rec_r)
    end
    if not(isfolder(path_rec_line))
        mkdir(path_rec_line)
    end
    if not(isfolder(path_rec_line_ByBzJx))
        mkdir(path_rec_line_ByBzJx)
    end
    %-----------------------------------------------------------------------------------------------------------------------

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

    % %--------------------------------------------------------------------------
    % % Making a plot for B2 as a function of time to see the growth rate of
    % the instability
    % %--------------------------------------------------------------------------
    %

    time_t_2=zeros(1,N);

    Bx2_max=zeros(1,N);
    Bx2_mean=zeros(1,N);

    By2_max=zeros(1,N);
    By2_mean=zeros(1,N);

    Bz2_max=zeros(1,N);
    Bz2_mean=zeros(1,N);

    for in=1:N
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


        Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
        By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
        Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));
        Bx2 = Bx.^2; By2 = By.^2; Bz2 = Bz.^2;
        B2 = mean((Bx2 + By2 + Bz2),'all'); % it seems the total magnetic field goes

        Bx2_max(1,in) = max(max(max(Bx2/B2)));
        Bx2_mean(1,in) = mean((Bx2/B2) , 'all');
        By2_max(1,in) = max(max(max(By2/B2)));
        By2_mean(1,in) = mean((By2/B2) , 'all');
        Bz2_max(1,in) = max(max(max(Bz2/B2)));
        Bz2_mean(1,in) = mean((Bz2/B2) , 'all');

        clearvars Bx2
        clearvars By2
        clearvars Bz2

        dt=double(grid_dt(15).Value);
        str = string(S(in).name);
        newStr = extractBetween(str,"pfd.","_p000000.h5");
        N_steps = str2double(newStr);
        time_t = dt*N_steps;
        time_t_2_Omega=time_t./omega_pe_Omega_ce;
        time_t_2(1,in)=time_t_2_Omega;

        cd(path)

    end
    % Estimating the growth rates
    %--------------------------------------------------------------------------
    sigma_g=25;
    % This is to find the growth rate of the maximum value
    %--------------------------------------------------------------------------
    % First smooth the curve

    % get the delta t
    DT=100;
    L_thick = 4; % Thickness of the current sheet
    tA = L_thick * (1/omega_pe_Omega_ce) * sqrt(nb_n0); % Alfven time = a/vAb
    delta_t = dt * DT; % time interval in omegape
    delta_t_Om = delta_t/omega_pe_Omega_ce;
    delta_t_A = delta_t/tA; % time interval in tA
    time_t_2_tA = time_t_2.*omega_pe_Omega_ce/tA; %time array in tA

    dump=sqrt(Bx2_max);
    dump = imgaussfilt((dump),sigma_g);
    gamma_max_x = (log(dump(2:end)) - log(dump(1:end-1)))./(delta_t_Om);
    gamma_max_x_mean = mean(gamma_max_x);

    dump=sqrt(By2_max);
    dump = imgaussfilt((dump),sigma_g);
    gamma_max_y = (log(dump(2:end)) - log(dump(1:end-1)))./(delta_t_Om);
    gamma_max_y_mean = mean(gamma_max_y);

    dump=sqrt(Bz2_max);
    dump = imgaussfilt((dump),sigma_g);
    gamma_max_z = (log(dump(2:end)) - log(dump(1:end-1)))./(delta_t_Om);
    gamma_max_z_mean = mean(gamma_max_z);

    %--------------------------------------------------------------------------

    Bx2_max_T{kn} = Bx2_max; % these quantities are divided by the mean of the total B2
    Bx2_mean_T{kn} = Bx2_mean;

    By2_max_T{kn} = By2_max; % these quantities are divided by the mean of the total B2
    By2_mean_T{kn} = By2_mean;

    Bz2_max_T{kn} = Bz2_max; % these quantities are divided by the mean of the total B2
    Bz2_mean_T{kn} = Bz2_mean;

    time_t_2_T{kn} = time_t_2;

    gammas{kn} = [gamma_max_x_mean,gamma_max_y_mean,gamma_max_z_mean];

end

% % this is for the mean value of the gammas
% %--------------------------------------------------------------------------
% for i=1:14
%     dump = gammas{1,i};
%     dump = dump(1,1);
%     disp(dump)
% end
% %--------------------------------------------------------------------------


%--------------------------------------------------------------------------
C = {
    [204/255, 102/255, 119/255],... %rose
    [51/255, 34/255, 136/255],... % indigo
    [221/255, 204/255, 119/255],... %sand
    [17/255, 119/255, 51/255],... %green
    [136/255, 204/255, 238/255],... %cyan
    [136/255, 34/255, 85/255],... %wine
    [68/255, 170/255, 153/255],... %teal
    [170/255, 68/255, 153/255],... %purple
    [153/255, 153/255, 51/255],... %olive
    [221/255, 100/255, 100/255],... %pale grey
    [21/255, 221/255, 221/255],... %cian 2
    [121/255, 221/255, 221/255],... %cian clear 3
    [221/255, 21/255, 221/255],... %magenta 3
    [221/255, 121/255, 221/255],... %magenta clear 3
    };

% legends_comp={'$A$','$B$','$C$','$D$','$E$','$ABg_{02}$',...
%     '$\Omega_{e}\lambda \delta B_{01}$',...
%     '$\Omega_{e} \lambda \delta B_{08}$',...
%     '$\Omega_{e} \Delta \delta B_{01}$',...
%     '$\Omega_{e} \Delta \delta B_{08}$',...
%     '$\Omega_{e} d_{e} \delta B_{01}$',...
%     '$\Omega_{e} \rho_{e} \delta B_{01}$',...
%     '$\omega_{pe} d_{e} \delta B_{01}$',...
%     '$\omega_{pe} \rho_{e} \delta B_{01}$',...
%     };

legends_comp={'$SA$','$SB$','$SC$','$SD$','$SE$','$SF$',...
    '$SG$',...
    '$SH$',...
    '$SI$',...
    '$SJ$',...
    '$SK$',...
    '$SL$',...
    '$SM$',...
    '$SN$',...
    };

% % legends_comp={'$Base$',...
% %     '$lange_{01}$',...
% %     '$T_{\perp}>T_{\parallel}$',...
% %     '$lange_{03}$',...
% %     };
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
fs=25; x0=45;y0=54;xx1=1200;yy1=500;

%--------------------------------------------------------------------------
%max
sigma_g=5; %gauss
f2=figure(2);
set(gcf,'position',[x0,y0,xx1,yy1])
%--------------------------------------------------------------------------
subplot(2,1,1)
Bx2_max = Jx2_max_T{1}; time_t_2 = time_t_2_T{1};
Bx2_max(1,1) = Bx2_max(1,2);
y = imgaussfilt(sqrt(Bx2_max),sigma_g)';
semilogy(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:9
    Bx2_max = Jx2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    Bx2_max(1,1) = Bx2_max(1,2);
    y = imgaussfilt(sqrt(Bx2_max),sigma_g)';
    semilogy(time_t_2,y,LineWidth=2,color=C{kn})
end
for kn=10:N_kn
    Bx2_max = Jx2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    Bx2_max(1,1) = Bx2_max(1,2);
    y = imgaussfilt(sqrt(Bx2_max),sigma_g)';
    semilogy(time_t_2,y,'--',LineWidth=2,color=C{kn})
end
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$|J_{x,max}|/\langle |\mathbf{J}| \rangle$'; 
ax.YTick = [1e0, 1e1, 1e2]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
%ylim([1e0 0.5e5]);
xlim([0 350]);
hold off
%--------------------------------------------------------------------------
sigma_g=20; %gauss
%--------------------------------------------------------------------------
subplot(2,1,2)
By2_max = By2_max_T{1}; time_t_2 = time_t_2_T{1};
y = imgaussfilt(sqrt(By2_max),sigma_g)';
y = y - y(1,1);
plot(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:9
    By2_max = By2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(sqrt(By2_max),sigma_g)';
    y = y - y(1,1);
    plot(time_t_2,y,LineWidth=2,color=C{kn})
end
for kn=10:N_kn
    By2_max = By2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(sqrt(By2_max),sigma_g)';
    y = y - y(1,1);
    plot(time_t_2,y,'--',LineWidth=2,color=C{kn})
end
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; 
%yline(1.5,'--k');
%yline(1.7,'--k');
%yline(1.0,'--k');
%ax.YTick = [1e-3, 1e0, 1e1];
ax.YLabel.String = '$|B_{y,max}|/ \langle |\mathbf{B}| \rangle$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
%ylim([1e-4 1e1]);
xlim([0 350]);
hold off
%--------------------------------------------------------------------------
cd(path_comp)
kn=1;
saveas(f2,strcat(num2str(kn),'current_max_By_max_all_semilogy3.png'));
%--------------------------------------------------------------------------


% Computing the gammas smooth(|By| - |By0|)

sigma_g=1;
for i=1:14
    %i=1;
    By2_max = (By2_max_T{i});
    y = imgaussfilt(sqrt(By2_max),sigma_g)';
    y = y - y(1,1);
    gamma_max_y = (log(y(2:end)./y(1:end-1)))./(delta_t_Om);
    A = gamma_max_y;
    A = A((isfinite(A)));
    A_mean = mean(A);
    disp(A_mean)
end

% make the plot
sigma_g=15;
f75=figure(75)
for i=1:14
    subplot(5,3,i)
    By2_max = (By2_max_T{i}); time_t_2 = time_t_2_T{i};
    y = imgaussfilt(sqrt(By2_max),sigma_g); % makes the smoothing
    y2 = y - y(1,1); % substract the initial value to shift everything to zero
    gamma_max_y = (log(y2(2:end)./y2(1:end-1)))./(delta_t_Om);

    A = gamma_max_y;     %A = A((isfinite(A)));    %A(~isfinite(A)) = 0;    %A( ~any( isnan( A ) | isinf( A ), 2 ),: )
    A(isinf(A)|isnan(A)) = 0;

    plot(time_t_2(1:end-1),A,'k',LineWidth=2)
    title('gamma By')
    xlim([0,50])
    ylim([1e-3, 1e0])
    clearvars A time_t_2 By2_max
    %pks = max(gamma_i);
    %pks_time = time_t_2(gamma_i==pks);

    %X = sprintf('max %s and time %s',pks,pks_time);
    %X = sprintf('%s',pks);
    %X = sprintf('%s',pks_time);
    %disp(X)
end%





%--------------------------------------------------------------------------
%max
f3=figure(3);
set(gcf,'position',[x0,y0,xx1,yy1])
%--------------------------------------------------------------------------
subplot(3,1,1)
Bx2_max = Bx2_max_T{1}; time_t_2 = time_t_2_T{1};
y = imgaussfilt(Bx2_max,sigma_g)';
semilogy(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:9
    Bx2_max = Bx2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(Bx2_max,sigma_g)';
    semilogy(time_t_2,y,LineWidth=2,color=C{kn})
end
for kn=10:N_kn
    Bx2_max = Bx2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(Bx2_max,sigma_g)';
    semilogy(time_t_2,y,'--',LineWidth=2,color=C{kn})
end
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$B_{x,max}^{2}/\langle |\mathbf{B}|^{2} \rangle$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([1e-2 1e1]);
%xlim([0 350]);
hold off
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
subplot(3,1,2)
By2_max = By2_max_T{1}; time_t_2 = time_t_2_T{1};
y = imgaussfilt(By2_max,sigma_g)';
semilogy(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:9
    By2_max = By2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(By2_max,sigma_g)';
    semilogy(time_t_2,y,LineWidth=2,color=C{kn})
end
for kn=10:N_kn
    By2_max = By2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(By2_max,sigma_g)';
    semilogy(time_t_2,y,'--',LineWidth=2,color=C{kn})
end
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; 
ax.YTick = [1e-3, 1e0, 1e1];
ax.YLabel.String = '$B_{y,max}^{2}/\langle |\mathbf{B}|^{2} \rangle$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([1e-4 1e1]);
%xlim([0 350]);
hold off
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
subplot(3,1,3)
Bz2_max = Bz2_max_T{1}; time_t_2 = time_t_2_T{1};
y = imgaussfilt(Bz2_max,sigma_g)';
semilogy(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:9
    Bz2_max = Bz2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(Bz2_max,sigma_g)';
    semilogy(time_t_2,y,LineWidth=2,color=C{kn})
end
for kn=10:N_kn
    Bz2_max = Bz2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(Bz2_max,sigma_g)';
    semilogy(time_t_2,y,'--',LineWidth=2,color=C{kn})
end
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$B_{z,max}^{2}/\langle |\mathbf{B}|^{2} \rangle$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([1e-1 1e1]);
%xlim([0 350]);
hold off
%--------------------------------------------------------------------------


%mean
sigma_g=25;
f4=figure(4);
set(gcf,'position',[x0,y0,xx1,yy1])
%--------------------------------------------------------------------------
subplot(3,1,1)
Bx2_max = sqrt(Bx2_mean_T{1}); time_t_2 = time_t_2_T{1};
y = imgaussfilt(Bx2_max,sigma_g)';
plot(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:9
    Bx2_max = sqrt(Bx2_mean_T{kn});   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(Bx2_max,sigma_g)';
    plot(time_t_2,y,LineWidth=2,color=C{kn})
end
for kn=10:N_kn
    Bx2_max = sqrt(Bx2_mean_T{kn});   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(Bx2_max,sigma_g)';
    plot(time_t_2,y,'--',LineWidth=2,color=C{kn})
end
%legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
legend('1','Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\sqrt{\langle B_{x}^{2} \rangle / \langle |\mathbf{B}|^{2} \rangle}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([0 0.4]);
%xlim([0 350]);
hold off
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
subplot(3,1,2)
By2_max = sqrt(By2_mean_T{1}); time_t_2 = time_t_2_T{1};
y = imgaussfilt(By2_max,sigma_g)';
plot(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:9
    By2_max = sqrt(By2_mean_T{kn});   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(By2_max,sigma_g)';
    plot(time_t_2,y,LineWidth=2,color=C{kn})
end
for kn=10:N_kn
    By2_max = sqrt(By2_mean_T{kn});   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(By2_max,sigma_g)';
    plot(time_t_2,y,'--',LineWidth=2,color=C{kn})
end
%legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
legend('1','Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\sqrt{\langle B_{y}^{2} \rangle /\langle |\mathbf{B}|^{2} \rangle}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([0 0.7]);
%xlim([0 350]);
hold off
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
subplot(3,1,3)
Bz2_max = sqrt(Bz2_mean_T{1}); time_t_2 = time_t_2_T{1};
y = imgaussfilt(Bz2_max,sigma_g)';
plot(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:9
    Bz2_max = sqrt(Bz2_mean_T{kn});   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(Bz2_max,sigma_g)';
    plot(time_t_2,y,LineWidth=2,color=C{kn})
end
for kn=10:N_kn
    Bz2_max = sqrt(Bz2_mean_T{kn});   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(Bz2_max,sigma_g)';
    plot(time_t_2,y,'--',LineWidth=2,color=C{kn})
end
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\sqrt{\langle B_{z}^{2} \rangle / \langle |\mathbf{B}|^{2}} \rangle$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([0.7 1]);
%xlim([0 350]);
hold off
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
cd(path_comp)
%cd(path)
kn=1;
%saveas(f2,strcat(num2str(kn),'current_max_mean_all_semilogy.png'));
saveas(f3,strcat(num2str(kn),'BxByBz_max_all_semilogy_14.png'));
saveas(f4,strcat(num2str(kn),'BxByBz_mean_all_semilogy_14.png'));
%--------------------------------------------------------------------------


% Let's make a table with the initial values of the <Bx>,<By>,<Bz>
%--------------------------------------------------------------------------

for i=1:14
    dump=Bx2_mean_T{i};
    dump1 = sqrt(dump(1,1));
    
    dump=By2_mean_T{i};
    dump2 = sqrt(dump(1,1));

    dump=Bz2_mean_T{i};
    dump3 = sqrt(dump(1,1));

    dump12 = [dump1, dump2, dump3];
    disp(dump12)
end

% with the filter
for i=1:14
    Bx2_mean = sqrt(Bx2_mean_T{i}); 
    y = imgaussfilt(Bx2_mean,sigma_g)';
    dump1 = y(1,1);
    
    By2_mean = sqrt(By2_mean_T{i});
    y = imgaussfilt(By2_mean,sigma_g)';
    dump2 = y(1,1);
    %disp(dump2)

    Bz2_mean = sqrt(Bz2_mean_T{i});
    y = imgaussfilt(Bz2_mean,sigma_g)';
    dump3 = y(1,1);

    dump12 = [dump1, dump2, dump3];
    
    disp(dump3)
end
%--------------------------------------------------------------------------




% These are the plots to see the growth rates and how well the gaussian
% filter works. Also to get the max growth rates and the time at which it peaks 
%--------------------------------------------------------------------------
% In terms of Ome 

%max
f4=figure(4)
subplot(3,3,1)
Bx2_max = Bx2_max_T{i}; time_t_2 = time_t_2_T{i};
dump=sqrt(Bx2_max);
semilogy(time_t_2(1:end),dump,'r',LineWidth=2)
subplot(3,3,2)
dump = imgaussfilt((dump),sigma_g);
semilogy(time_t_2(1:end),dump,'r',LineWidth=2)
subplot(3,3,3)
gamma_max_x = (log(dump(2:end)) - log(dump(1:end-1)))./(delta_t_Om);
gamma_max_x_mean = mean(gamma_max_x);
plot(time_t_2(2:end),gamma_max_x,'r',LineWidth=2)
yline(gamma_max_x_mean,'--')

subplot(3,3,4)
By2_max = By2_max_T{i}; time_t_2 = time_t_2_T{i};
dump=sqrt(By2_max);
semilogy(time_t_2(1:end),dump,'g',LineWidth=2)
subplot(3,3,5)
dump = imgaussfilt((dump),sigma_g);
semilogy(time_t_2(1:end),dump,'g',LineWidth=2)
subplot(3,3,6)
plot(time_t_2(2:end),(log(dump(2:end)) - log(dump(1:end-1)))./(delta_t_Om),'g',LineWidth=2)

subplot(3,3,7)
Bz2_max = Bz2_max_T{i}; time_t_2 = time_t_2_T{i};
dump=sqrt(Bz2_max);
semilogy(time_t_2(1:end),dump,'b',LineWidth=2)
subplot(3,3,8)
dump = imgaussfilt((dump),sigma_g);
semilogy(time_t_2(1:end),dump,'b',LineWidth=2)
subplot(3,3,9)
plot(time_t_2(2:end),(log(dump(2:end)) - log(dump(1:end-1)))./(delta_t_Om),'b',LineWidth=2)
sgtitle('max')
%--------------------------------------------------------------------------



% These are the plots for the gammas
%--------------------------------------------------------------------------
f6=figure(6)
for i=1:14
    subplot(5,3,i)
    Bx2_max = Bx2_max_T{i}; time_t_2 = time_t_2_T{i};
    dump=sqrt(Bx2_max);
    dump = imgaussfilt((dump),sigma_g);
    gamma_i = (log(dump(2:end)) - log(dump(1:end-1)))./(delta_t_Om);
    plot(time_t_2(2:end),gamma_i,'k',LineWidth=2)
    title('gamma Bx')
    
    pks = max(gamma_i);
    pks_time = time_t_2(gamma_i==pks);
    %X = sprintf('max %s and time %s',pks,pks_time);
    %X = sprintf('%s',pks);
    X = sprintf('%s',pks_time);
    disp(X)

end

f7=figure(7)
for i=1:14
    subplot(5,3,i)
    By2_max = By2_max_T{i}; time_t_2 = time_t_2_T{i};
    dump=sqrt(By2_max);
    dump = imgaussfilt((dump),sigma_g);
    gamma_i = (log(dump(2:end)) - log(dump(1:end-1)))./(delta_t_Om);
    plot(time_t_2(2:end),gamma_i,'k',LineWidth=2)
    title('gamma By')
    pks = max(gamma_i);
    pks_time = time_t_2(gamma_i==pks);

    %X = sprintf('max %s and time %s',pks,pks_time);
    %X = sprintf('%s',pks);
    X = sprintf('%s',pks_time);
    disp(X)
end

f8=figure(8)
for i=1:14
    subplot(5,3,i)
    Bz2_max = Bz2_max_T{i}; time_t_2 = time_t_2_T{i};
    dump=sqrt(Bz2_max);
    dump = imgaussfilt((dump),sigma_g);
    gamma_i = (log(dump(2:end)) - log(dump(1:end-1)))./(delta_t_Om);
    plot(time_t_2(2:end),gamma_i,'k',LineWidth=2)
    title('gamma Bz')
    pks = max(gamma_i);
    pks_time = time_t_2(gamma_i==pks);
    %X = sprintf('max %s and time %s',pks,pks_time);
    %X = sprintf('%s',pks);
    X = sprintf('%s',pks_time);
    disp(X)
end

cd(path_comp)
kn=1;
saveas(f6,strcat(num2str(kn),'gammaBx_14.png'));
saveas(f7,strcat(num2str(kn),'gammaBy_14.png'));
saveas(f8,strcat(num2str(kn),'gammaBz_14.png'));
%--------------------------------------------------------------------------




%--------------------------------------------------------------------------
% % %mean
% % f3=figure(3)
% % subplot(3,3,1)
% % dump=sqrt(Bx2_mean);
% % plot(time_t_2(1:end),dump,'r',LineWidth=2)
% % subplot(3,3,2)
% % dump = imgaussfilt((dump),sigma_g);
% % plot(time_t_2(1:end),dump,'r',LineWidth=2)
% % subplot(3,3,3)
% % plot(time_t_2(2:end),(log(dump(2:end)) - log(dump(1:end-1)))./(delta_t_Om),'r',LineWidth=2)
% % subplot(3,3,4)
% % dump=sqrt(By2_mean);
% % plot(time_t_2(1:end),dump,'g',LineWidth=2)
% % subplot(3,3,5)
% % dump = imgaussfilt((dump),sigma_g);
% % plot(time_t_2(1:end),dump,'g',LineWidth=2)
% % subplot(3,3,6)
% % plot(time_t_2(2:end),(log(dump(2:end)) - log(dump(1:end-1)))./(delta_t_Om),'g',LineWidth=2)
% % subplot(3,3,7)
% % dump=sqrt(Bz2_mean);
% % plot(time_t_2(1:end),dump,'b',LineWidth=2)
% % subplot(3,3,8)
% % dump = imgaussfilt((dump),sigma_g);
% % plot(time_t_2(1:end),dump,'b',LineWidth=2)
% % subplot(3,3,9)
% % plot(time_t_2(2:end),(log(dump(2:end)) - log(dump(1:end-1)))./(delta_t_Om),'b',LineWidth=2)
% % sgtitle('mean')
% % 
% % % In terms of tA
% % %max
% % f2=figure(2)
% % subplot(3,3,1)
% % dump=sqrt(Bx2_max);
% % plot(time_t_2_tA(1:end),dump,'r',LineWidth=2)
% % subplot(3,3,2)
% % dump = imgaussfilt((dump),sigma_g);
% % plot(time_t_2_tA(1:end),dump,'r',LineWidth=2)
% % subplot(3,3,3)
% % plot(time_t_2_tA(2:end),(log(dump(2:end)) - log(dump(1:end-1)))./(delta_t_A),'r',LineWidth=2)
% % subplot(3,3,4)
% % dump=sqrt(By2_max);
% % plot(time_t_2_tA(1:end),dump,'g',LineWidth=2)
% % subplot(3,3,5)
% % dump = imgaussfilt((dump),sigma_g);
% % plot(time_t_2_tA(1:end),dump,'g',LineWidth=2)
% % subplot(3,3,6)
% % plot(time_t_2_tA(2:end),(log(dump(2:end)) - log(dump(1:end-1)))./(delta_t_A),'g',LineWidth=2)
% % subplot(3,3,7)
% % dump=sqrt(Bz2_max);
% % plot(time_t_2_tA(1:end),dump,'b',LineWidth=2)
% % subplot(3,3,8)
% % dump = imgaussfilt((dump),sigma_g);
% % plot(time_t_2_tA(1:end),dump,'b',LineWidth=2)
% % subplot(3,3,9)
% % plot(time_t_2_tA(2:end),(log(dump(2:end)) - log(dump(1:end-1)))./(delta_t_A),'b',LineWidth=2)
% % sgtitle('max')
% % 
% % %mean
% % f1=figure(1)
% % subplot(3,3,1)
% % dump=sqrt(Bx2_mean);
% % plot(time_t_2_tA(1:end),dump,'r',LineWidth=2)
% % subplot(3,3,2)
% % dump = imgaussfilt((dump),sigma_g);
% % plot(time_t_2_tA(1:end),dump,'r',LineWidth=2)
% % subplot(3,3,3)
% % plot(time_t_2_tA(2:end),(log(dump(2:end)) - log(dump(1:end-1)))./(delta_t_A),'r',LineWidth=2)
% % subplot(3,3,4)
% % dump=sqrt(By2_mean);
% % plot(time_t_2_tA(1:end),dump,'g',LineWidth=2)
% % subplot(3,3,5)
% % dump = imgaussfilt((dump),sigma_g);
% % plot(time_t_2_tA(1:end),dump,'g',LineWidth=2)
% % subplot(3,3,6)
% % plot(time_t_2_tA(2:end),(log(dump(2:end)) - log(dump(1:end-1)))./(delta_t_A),'g',LineWidth=2)
% % subplot(3,3,7)
% % dump=sqrt(Bz2_mean);
% % plot(time_t_2_tA(1:end),dump,'b',LineWidth=2)
% % subplot(3,3,8)
% % dump = imgaussfilt((dump),sigma_g);
% % plot(time_t_2_tA(1:end),dump,'b',LineWidth=2)
% % subplot(3,3,9)
% % plot(time_t_2_tA(2:end),(log(dump(2:end)) - log(dump(1:end-1)))./(delta_t_A),'b',LineWidth=2)
% % sgtitle('mean')
% % 
% % %--------------------------------------------------------------------------
