%Ploting maximum Bx2/B2 a way to stimate the reconnection rate and
%the effect of driving the fulctuations on the evolution. Something that
% is not affected by the fluctuation noise

% For multiple fiels to compare

%--------------------------------------------------------------------------
Bx2_max_T = cell(1,10);
Bx2_mean_T = cell(1,10);
Bx2_std_T = cell(1,10);
%--------------------------------------------------------------------------
time_t_2_T = cell(1,10);
%--------------------------------------------------------------------------

for kn=1:10

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
    end

    %-----------------------------------------------------------------------------------------------------------------------

     path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_Bg01_below';
    % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_alone_large'; 
    % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_Omc1_kd1';


    %-----------------------------------------------------------------------------------------------------------------------
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
    Bx2_std=zeros(1,N);
   

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
        clearvars By Bz Bx By2 Bz2

        Bx2_max(1,in) = max(max(max(Bx2/B2)));
        Bx2_mean(1,in) = mean((Bx2/B2) , 'all');
        Bx2_std(1,in) = sqrt( mean((Bx2.^2),'all') - (mean(Bx2,'all'))^2 )/B2  ;

        clearvars Bx2

        dt=double(grid_dt(15).Value);
        str = string(S(in).name);
        newStr = extractBetween(str,"pfd.","_p000000.h5");
        N_steps = str2double(newStr);
        time_t = dt*N_steps;
        time_t_2_Omega=time_t./omega_pe_Omega_ce;
        time_t_2(1,in)=time_t_2_Omega;

        cd(path)

    end

    Bx2_max_T{kn} = Bx2_max; % thus qwuantities are divided by the mean of the total B2
    Bx2_mean_T{kn} = Bx2_mean;
    Bx2_std_T{kn} = Bx2_std;
    time_t_2_T{kn} = time_t_2;


end
%--------------------------------------------------------------------------

% Save the data
%--------------------------------------------------------------------------
cd(path_comp)
save('Bxfield_comparison_ABCDEABg02_Oc1dB_0108_kd10_801.mat',...
    'Bx2_mean_T','Bx2_max_T','Bx2_std_T','time_t_2_T')
%--------------------------------------------------------------------------

%Once the data are stored and safe
%--------------------------------------------------------------------------
%path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';

cd(path_comp)
%This loads cells
load('Bxfield_comparison_ABCDEABg02_Oc1dB_0108_kd10_801.mat')
time_t_2_T_ABCD = time_t_2_T;
Bx2_max_T_ABCD = Bx2_max_T;
Bx2_mean_T_ABCD = Bx2_mean_T;
Bx2_std_T_ABCD = Bx2_std_T;
%--------------------------------------------------------------------------



%Making plots
% %--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% To compare several runs at the time
% This is the plot of the reconnection rate

%--------------------------------------------------------------------------
N_kn=kn;

%Vai=0.2;Vae=0.2;

%--------------------------------------------------------------------------
% %Make one plot for a quantity comparing the different set ups B components
%--------------------------------------------------------------------------
% % C = {'k','b','r','c','m',[.5 .6 .7],[.8 .2 .6],'y'} ;
% % 
% % % from  https://yoshke.org/blog/colorblind-friendly-diagrams
% % C = {[0/255, 0/255, 0/255],...
% %     [230/255, 159/255, 0/255],...
% %     [86/255, 180/255, 233/255],...
% %     [0/255, 158/255, 115/255],...
% %     [240/255, 228/255, 66/255],...
% %     [0/255, 114/255, 178/255],...
% %     [213/255, 94/255, 0/255],...
% %     [204/255, 121/255, 167/255]};

% from  https://personal.sron.nl/~pault/#sec:qualitative
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
    [221/255, 221/255, 221/255] %pale grey
    };

legends_comp={'A','B','C','D','E','Abg02','Oc1dB01','Oc1dB08','Oc1dkd1B01','Oc1dkd1B08'};


% For the out of plane magnetic field
fs=18; x0=45;y0=54;xx1=1200;yy1=1200;
f1=figure(1);
set(gcf,'position',[x0,y0,xx1,yy1])
%--------------------------------------------------------------------------
subplot(3,1,1)
Bx2_max = Bx2_max_T{1}; time_t_2 = time_t_2_T{1};
y = Bx2_max';
loglog(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:N_kn
    Bx2_max = Bx2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = Bx2_max';
    loglog(time_t_2,y,LineWidth=2,color=C{kn})
end
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$B_{x,max}^{2}/B^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([1e-2 1e1]);
xlim([0 350]);
hold off
%--------------------------------------------------------------------------
subplot(3,1,2)
Bx2_mean = Bx2_mean_T{1}; time_t_2 = time_t_2_T{1};
y = Bx2_mean';
loglog(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:N_kn
    Bx2_mean = Bx2_mean_T{kn};   time_t_2 = time_t_2_T{kn};
    y = Bx2_mean';
    loglog(time_t_2,y,LineWidth=2,color=C{kn})
end
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\langle B_{x}^{2} \rangle /B^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([1e-3 1e0]);
xlim([0 350]);
hold off
%--------------------------------------------------------------------------
subplot(3,1,3)
Bx2_std = real(Bx2_std_T{1}); time_t_2 = time_t_2_T{1};
y = Bx2_std';
loglog(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:N_kn
    Bx2_std = real(Bx2_std_T{kn});   time_t_2 = time_t_2_T{kn};
    y = Bx2_std';
    loglog(time_t_2,y,LineWidth=2,color=C{kn})
end
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$(B_{x}^{2})_{std}/B^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([1e-3 1e0]);
xlim([0 350]);
hold off
%--------------------------------------------------------------------------


f2=figure(2);
set(gcf,'position',[x0,y0,xx1,yy1])
%--------------------------------------------------------------------------
subplot(3,1,1)
Bx2_max = Bx2_max_T{1}; time_t_2 = time_t_2_T{1};
y = Bx2_max';
semilogy(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:N_kn
    Bx2_max = Bx2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = Bx2_max';
    semilogy(time_t_2,y,LineWidth=2,color=C{kn})
end
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$B_{x,max}^{2}/B^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([1e-2 1e1]);
xlim([0 350]);
hold off
%--------------------------------------------------------------------------
subplot(3,1,2)
Bx2_max = Bx2_max_T{1}; time_t_2 = time_t_2_T{1};
y = Bx2_max'./time_t_2';
semilogy(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:N_kn
    Bx2_max = Bx2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = Bx2_max'./time_t_2';
    semilogy(time_t_2,y,LineWidth=2,color=C{kn})
end
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$B_{x,max}^{2}/tB^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([1e-4 1e0]);
xlim([0 350]);
hold off
%--------------------------------------------------------------------------
subplot(3,1,3)
Bx2_max = Bx2_max_T{1}; time_t_2 = time_t_2_T{1};
y = Bx2_max'./(time_t_2.^2)';
semilogy(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:N_kn
    Bx2_max = Bx2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = Bx2_max'./(time_t_2.^2)';
    semilogy(time_t_2,y,LineWidth=2,color=C{kn})
end
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$B_{x,max}^{2}/t^{2}B^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
%ylim([1e-4 1e0]);
xlim([0 350]);
hold off
%--------------------------------------------------------------------------

f3=figure(3);
set(gcf,'position',[x0,y0,xx1,yy1])
%--------------------------------------------------------------------------
subplot(3,1,1)
Bx2_max = Bx2_max_T{1}; time_t_2 = time_t_2_T{1};
y = Bx2_max';
plot(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:N_kn
    Bx2_max = Bx2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = Bx2_max';
    plot(time_t_2,y,LineWidth=2,color=C{kn})
end
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$B_{x,max}^{2}/B^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
%ylim([1e-2 1e1]);
xlim([0 350]);
hold off
%--------------------------------------------------------------------------
subplot(3,1,2)
Bx2_max = Bx2_max_T{1}; time_t_2 = time_t_2_T{1};
y = Bx2_max'./time_t_2';
plot(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:N_kn
    Bx2_max = Bx2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = Bx2_max'./time_t_2';
    plot(time_t_2,y,LineWidth=2,color=C{kn})
end
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$B_{x,max}^{2}/tB^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
%ylim([1e-4 1e0]);
xlim([0 350]);
hold off
%--------------------------------------------------------------------------
subplot(3,1,3)
Bx2_max = Bx2_max_T{1}; time_t_2 = time_t_2_T{1};
y = Bx2_max'./(time_t_2.^2)';
plot(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:N_kn
    Bx2_max = Bx2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = Bx2_max'./(time_t_2.^2)';
    plot(time_t_2,y,LineWidth=2,color=C{kn})
end
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$B_{x,max}^{2}/t^{2}B^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
%ylim([1e-4 1e0]);
xlim([0 350]);
hold off
%--------------------------------------------------------------------------

cd(path_comp)
saveas(f1,strcat(num2str(kn),'Bx_max_mean_std_loglog.png'));
saveas(f2,strcat(num2str(kn),'Bx_max_divided_t.png'));
saveas(f3,strcat(num2str(kn),'BxBy_max_divided_t_no_log.png'));
%--------------------------------------------------------------------------






% For a single files
%Bx, Ey, Ez
%--------------------------------------------------------------------------
path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_alone_large';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_Omc1_kd1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_omp1_kLd1';
    
%  plasma, cyclotron frequency, di, rho 
kn=1;
%----------------------------------------------------------------------------------------------------------------------

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kLd1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kLr1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_omp1_kLr1';


%-----------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------

%-----------------------------------------------------------------------------------------------------------------------
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

%--------------------------------------------------------------------------
% Bx Ey Ez
%--------------------------------------------------------------------------
time_t_2=zeros(1,N);

Bx2_max=zeros(1,N);
Bx2_mean=zeros(1,N);
Bx2_std=zeros(1,N);

Ey2_max=zeros(1,N);
Ey2_mean=zeros(1,N);
Ey2_std=zeros(1,N);

Ez2_max=zeros(1,N);
Ez2_mean=zeros(1,N);
Ez2_std=zeros(1,N);



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
    clearvars By Bz Bx By2 Bz2
    Bx2_max(1,in) = max(max(max(Bx2/B2)));
    Bx2_mean(1,in) = mean((Bx2/B2) , 'all');
    %Bx2_std(1,in) = sqrt( mean((Bx2.^2),'all') - (mean(Bx2,'all'))^2 )/B2  ;
    clearvars Bx2

    Ex=h5read(fileID,strcat(EHJ_1st,'/ex_ec/p0/3d'));
    Ey=h5read(fileID,strcat(EHJ_1st,'/ey_ec/p0/3d'));
    Ez=h5read(fileID,strcat(EHJ_1st,'/ez_ec/p0/3d'));
    Ex2 = Ex.^2; Ey2 = Ey.^2; Ez2 = Ez.^2;
    E2 = mean((Ex2 + Ey2 + Ez2),'all'); % it seems the total magnetic field goes
    clearvars Ex Ex2

    Ey2_max(1,in) = max(max(max(Ey2/E2)));
    Ey2_mean(1,in) = mean((Ey2/E2) , 'all');
    %Ey2_std(1,in) = sqrt( mean((Ey2.^2),'all') - (mean(Ey2,'all'))^2 )/E2  ;
    clearvars Ey2

    Ez2_max(1,in) = max(max(max(Ez2/E2)));
    Ez2_mean(1,in) = mean((Ez2/E2) , 'all');
    %Ez2_std(1,in) = sqrt( mean((Ez2.^2),'all') - (mean(Ez2,'all'))^2 )/E2  ;
    clearvars Ez2

    dt=double(grid_dt(15).Value);
    str = string(S(in).name);
    newStr = extractBetween(str,"pfd.","_p000000.h5");
    N_steps = str2double(newStr);
    time_t = dt*N_steps;
    time_t_2_Omega=time_t./omega_pe_Omega_ce;
    time_t_2(1,in)=time_t_2_Omega;

    cd(path)

end


% For the Bx Ey and Ez
fs=18; x0=45;y0=54;xx1=1200;yy1=1200;

f11=figure(11);
set(gcf,'position',[x0,y0,xx1,yy1])
%--------------------------------------------------------------------------
subplot(3,1,1)
y = Bx2_max';
loglog(time_t_2,y,'k',LineWidth=2)
hold on
y = Ey2_max';
loglog(time_t_2,y,'r',LineWidth=2)
y = Ez2_max';
loglog(time_t_2,y,'b',LineWidth=2)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$B_{x,max}^{2}/B^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
legend('$B_{x,max}^{2} / \langle |\mathbf{B}|^{2} \rangle$',...
    '$E_{y,max}^{2} / \langle |\mathbf{E}|^{2} \rangle$',...
    '$E_{z,max}^{2} / \langle |\mathbf{E}|^{2} \rangle$','Interpreter',...
    'latex','FontSize',1.0*fs,'Location','northwest','NumColumns',3)
legend boxoff
%ylim([1e-2 1e1]);
xlim([0 350]);
hold off
%--------------------------------------------------------------------------
subplot(3,1,2)
y = Bx2_max'./Ey2_max';
loglog(time_t_2,y,'k',LineWidth=2)
hold on
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$E_{y,max}^{2}/E^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
yline((0.2.^2),'--b',LineWidth=2)
legend('$(B_{x,max}^{2} / \langle |\mathbf{B}|^{2} \rangle) / (E_{y,max}^{2} / \langle |\mathbf{E}|^{2} \rangle)$','$v^{2}_{A}$','Interpreter',...
    'latex','FontSize',1.0*fs,'Location','northwest','NumColumns',3)
legend boxoff
%ylim([1e-2 1e1]);
xlim([0 350]);
hold off
%--------------------------------------------------------------------------
subplot(3,1,3)
y = Bx2_mean';
%y(isnan(y))=0; y=y/mean(y);
loglog(time_t_2,y,'k',LineWidth=2)
hold on
y = Ey2_mean';
%y(isnan(y))=0; y=y/mean(y);
loglog(time_t_2,y,'r',LineWidth=2)
y = Ez2_mean';
%y(isnan(y))=0; y=y/mean(y);
loglog(time_t_2,y,'b',LineWidth=2)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$E_{z,max}^{2}/E^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
%ylim([1e-2 1e1]);
legend('$\langle B_{x}^{2} \rangle / \langle |\mathbf{B}|^{2} \rangle$',...
    '$\langle E_{y}^{2} \rangle / \langle |\mathbf{E}|^{2} \rangle$',...
    '$\langle E_{z}^{2} \rangle / \langle |\mathbf{E}|^{2} \rangle$','Interpreter',...
    'latex','FontSize',1.0*fs,'Location','northwest','NumColumns',3)
legend boxoff
xlim([0 350]);
sgtitle('$dB_{01}\omega_{p}kd_{e}$','Interpreter','latex','FontSize',1.0*fs)
%sgtitle('Suppresing','Interpreter','latex','FontSize',1.0*fs)
hold off
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
cd(path_comp)
kn=1;
saveas(f11,strcat(num2str(kn),'BxEyEz_max_ratio_mean_LangedB01omp1kd1.png'));
%saveas(f11,strcat(num2str(kn),'BxEyEz_max_ratio_mean_supressing.png'));
%--------------------------------------------------------------------------

% Bx is for sure not directly affected by the drivind but its grow is a
% self consistent fearure





% Bx By Bz
%--------------------------------------------------------------------------
path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_alone_large';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_Omc1_kd1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_omp1_kLd1';
    
%  plasma, cyclotron frequency, di, rho 
kn=1;
%----------------------------------------------------------------------------------------------------------------------

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kLd1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kLr1';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_omp1_kLr1';


%-----------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------

%-----------------------------------------------------------------------------------------------------------------------
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

%--------------------------------------------------------------------------
% Bx By Bz
%--------------------------------------------------------------------------
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

gammas(kn,1) = gamma_max_x_mean;
gammas(kn,2) = gamma_max_y_mean;
gammas(kn,3) = gamma_max_z_mean;
%--------------------------------------------------------------------------

fs=18; x0=45;y0=54;xx1=1200;yy1=1200;


% These are the plots to see the growth rates and how well the gaussian
% filter works.
%--------------------------------------------------------------------------

% In terms of Ome 
% % %max
% % f4=figure(4)
% % subplot(3,3,1)
% % dump=sqrt(Bx2_max);
% % semilogy(time_t_2(1:end),dump,'r',LineWidth=2)
% % subplot(3,3,2)
% % dump = imgaussfilt((dump),sigma_g);
% % semilogy(time_t_2(1:end),dump,'r',LineWidth=2)
% % subplot(3,3,3)
% % gamma_max_x = (log(dump(2:end)) - log(dump(1:end-1)))./(delta_t_Om);
% % gamma_max_x_mean = mean(gamma_max_x);
% % plot(time_t_2(2:end),gamma_max_x,'r',LineWidth=2)
% % yline(gamma_max_x_mean,'--')
% % subplot(3,3,4)
% % dump=sqrt(By2_max);
% % semilogy(time_t_2(1:end),dump,'g',LineWidth=2)
% % subplot(3,3,5)
% % dump = imgaussfilt((dump),sigma_g);
% % semilogy(time_t_2(1:end),dump,'g',LineWidth=2)
% % subplot(3,3,6)
% % plot(time_t_2(2:end),(log(dump(2:end)) - log(dump(1:end-1)))./(delta_t_Om),'g',LineWidth=2)
% % subplot(3,3,7)
% % dump=sqrt(Bz2_max);
% % semilogy(time_t_2(1:end),dump,'b',LineWidth=2)
% % subplot(3,3,8)
% % dump = imgaussfilt((dump),sigma_g);
% % semilogy(time_t_2(1:end),dump,'b',LineWidth=2)
% % subplot(3,3,9)
% % plot(time_t_2(2:end),(log(dump(2:end)) - log(dump(1:end-1)))./(delta_t_Om),'b',LineWidth=2)
% % sgtitle('max')
% % 
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

%--------------------------------------------------------------------------




%--------------------------------------------------------------------------
% Current x
%--------------------------------------------------------------------------
N_kn=4;
%--------------------------------------------------------------------------
Jx2_max_T = cell(1,N_kn);
Jx2_mean_T = cell(1,N_kn);
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
    Jx2_max=zeros(1,N);
    Jx2_mean=zeros(1,N);

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


        Jx=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'));
        Jy=h5read(fileID,strcat(EHJ_1st,'/jy_ec/p0/3d'));
        Jz=h5read(fileID,strcat(EHJ_1st,'/jz_ec/p0/3d'));
        Jx2 = Jx.^2; Jy2 = Jy.^2; Jz2 = Jz.^2;
        J2 = mean((Jx2 + Jy2 + Jz2),'all'); % it seems the total magnetic field goes
        clearvars Jy Jy2 Jz Jz2

        Jx2_max(1,in) = max(max(max(Jx2/J2)));
        Jx2_mean(1,in) = mean((Jx2/J2) , 'all');
        clearvars Jx2

        dt=double(grid_dt(15).Value);
        str = string(S(in).name);
        newStr = extractBetween(str,"pfd.","_p000000.h5");
        N_steps = str2double(newStr);
        time_t = dt*N_steps;
        time_t_2_Omega=time_t./omega_pe_Omega_ce;
        time_t_2(1,in)=time_t_2_Omega;

        cd(path)

    end

    Jx2_max_T{kn} = Jx2_max; % these quantities are divided by the mean of the total B2
    Jx2_mean_T{kn} = Jx2_mean;
    time_t_2_T{kn} = time_t_2;

end

% f1=figure(1)
% plot(time_t_2,Jx2_max)


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
    [221/255, 221/255, 221/255],... %pale grey
    [21/255, 221/255, 221/255],... %pale grey 1
    [121/255, 221/255, 221/255],... %pale grey 2
    [221/255, 21/255, 221/255],... %pale grey 3
    [221/255, 121/255, 221/255],... %pale grey 4
    };

legends_comp={'$A$','$B$','$C$','$D$','$E$','$ABg_{02}$',...
    '$\Omega_{e}\lambda \delta B_{01}$',...
    '$\Omega_{e} \lambda \delta B_{08}$',...
    '$\Omega_{e} \Delta \delta B_{01}$',...
    '$\Omega_{e} \Delta \delta B_{08}$',...
    '$\Omega_{e} d_{e} \delta B_{01}$',...
    '$\Omega_{e} \rho_{e} \delta B_{01}$',...
    '$\omega_{pe} d_{e} \delta B_{01}$',...
    '$\omega_{pe} \rho_{e} \delta B_{01}$',...
    };

% % legends_comp={'$Base$',...
% %     '$lange_{01}$',...
% %     '$T_{\perp}>T_{\parallel}$',...
% %     '$lange_{03}$',...
% %     };

fs=18; x0=45;y0=54;xx1=1200;yy1=800;
sigma_g=25; %gauss


f2=figure(2);
set(gcf,'position',[x0,y0,xx1,yy1])
%--------------------------------------------------------------------------
subplot(2,1,1)
Jx2_max = Jx2_max_T{1}; time_t_2 = time_t_2_T{1};
y = imgaussfilt(Jx2_max,sigma_g)';
loglog(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:9
    Jx2_max = Jx2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(Jx2_max,sigma_g)'; 
    loglog(time_t_2,y,LineWidth=2,color=C{kn})
end
for kn=10:N_kn
    Jx2_max = Jx2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(Jx2_max,sigma_g)';
    loglog(time_t_2,y,'--',LineWidth=2,color=C{kn})
end
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$J_{x,max}^{2}/J^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
%ylim([1e-2 1e1]);
%xlim([0 350]);
hold off
%--------------------------------------------------------------------------
subplot(2,1,2)
Jx2_mean = Jx2_mean_T{1}; time_t_2 = time_t_2_T{1};
y = imgaussfilt(Jx2_mean,sigma_g);
loglog(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:9
    Jx2_mean = Jx2_mean_T{kn};   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(Jx2_mean,sigma_g)';
    loglog(time_t_2,y,LineWidth=2,color=C{kn})
end
for kn=10:N_kn
    Jx2_mean = Jx2_mean_T{kn};   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(Jx2_mean,sigma_g)';
    loglog(time_t_2,y,'--',LineWidth=2,color=C{kn})
end
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\langle J_{x}^{2} \rangle /J^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
%ylim([1e-3 1e0]);
%xlim([0 350]);
hold off
%--------------------------------------------------------------------------


f3=figure(3);
set(gcf,'position',[x0,y0,xx1,yy1/2])
%--------------------------------------------------------------------------
%subplot(2,1,1)
Jx2_max = Jx2_max_T{1}; time_t_2 = time_t_2_T{1};
y = imgaussfilt(Jx2_max,sigma_g)';
semilogy(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:9
    Jx2_max = Jx2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(Jx2_max,sigma_g)';
    semilogy(time_t_2,y,LineWidth=2,color=C{kn})
end
for kn=10:N_kn
    Jx2_max = Jx2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(Jx2_max,sigma_g)';
    semilogy(time_t_2,y,'--',LineWidth=2,color=C{kn})
end
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$J_{x,max}^{2}/\langle |\mathbf{J}|^{2} \rangle$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
%ylim([1e-2 1e1]);
%xlim([0 350]);
hold off
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


%cd(path_comp)
cd(path)
kn=1;
saveas(f2,strcat(num2str(kn),'current_max_mean_all_semilogy.png'));
saveas(f3,strcat(num2str(kn),'current_max_all_semilogy.png'));








