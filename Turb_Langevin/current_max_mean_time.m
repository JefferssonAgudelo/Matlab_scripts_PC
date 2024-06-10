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
for kn=1:4

    % This set shows the difference in terms of the onset.
    % ABCDE
    %----------------------------------------------------------------------------------------------------------------------
    if(kn==1)    
    path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_pinch_short_L4di';
    elseif(kn==2)
    path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_short_L4di'; 
    elseif(kn==3)
    path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_Tba_perpar_short_L4di'; 
    elseif(kn==4)
    path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_short_L4di_dB03'; 
    end
    %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_omp1_kLd1';
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

legends_comp={'$CP$',...
    '$lange_{01}$',...
    '$T_{\perp}>T_{\parallel}$',...
    '$lange_{03}$',...
    };

fs=18; x0=45;y0=54;xx1=1200;yy1=800;
sigma_g=3; %gauss
%sigma_g=20;         
f2=figure(2);
 set(gcf,'Visible', 'off'); 
set(gcf,'position',[x0,y0,xx1,yy1])
%--------------------------------------------------------------------------
subplot(2,1,1)
Jx2_max = Jx2_max_T{1}; time_t_2 = time_t_2_T{1};
y = imgaussfilt(Jx2_max,sigma_g)';
%y = medfilt1(Jx2_max,sigma_g)';
loglog(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:4
    Jx2_max = Jx2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(Jx2_max,sigma_g)';
    %y = medfilt1(Jx2_max,sigma_g)';
    loglog(time_t_2,y,LineWidth=2,color=C{kn})
end
% for kn=10:N_kn
%     Jx2_max = Jx2_max_T{kn};   time_t_2 = time_t_2_T{kn};
%     y = imgaussfilt(Jx2_max,sigma_g)';
%     %y = medfilt1(Jx2_max,sigma_g)';
%     loglog(time_t_2,y,'--',LineWidth=2,color=C{kn})
% end
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
%y = medfilt1(Jx2_mean,sigma_g);
loglog(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:4
    Jx2_mean = Jx2_mean_T{kn};   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(Jx2_mean,sigma_g)';
    %y = medfilt1(Jx2_mean,sigma_g);
    loglog(time_t_2,y,LineWidth=2,color=C{kn})
end
% for kn=10:N_kn
%     Jx2_mean = Jx2_mean_T{kn};   time_t_2 = time_t_2_T{kn};
%     y = imgaussfilt(Jx2_mean,sigma_g)';
%     %y = medfilt1(Jx2_mean,sigma_g);
%     loglog(time_t_2,y,'--',LineWidth=2,color=C{kn})
% end
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeastoutside','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\langle J_{x}^{2} \rangle /J^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{e}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
%ylim([1e-3 1e0]);
%xlim([0 350]);
hold off
%--------------------------------------------------------------------------

sigma_g=1;
f3=figure(3);
set(gcf,'position',[x0,y0,xx1,yy1/2])
%--------------------------------------------------------------------------
%subplot(2,1,1)
Jx2_max = Jx2_max_T{1}; time_t_2 = time_t_2_T{1};
y = imgaussfilt(Jx2_max,sigma_g)';
%y = medfilt1(Jx2_max,sigma_g)';
semilogy(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:4
    Jx2_max = Jx2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = imgaussfilt(Jx2_max,sigma_g)';
    %y = medfilt1(Jx2_max,sigma_g)';
    semilogy(time_t_2,y,LineWidth=2,color=C{kn})
end
% for kn=10:N_kn
%     Jx2_max = Jx2_max_T{kn};   time_t_2 = time_t_2_T{kn};
%     y = imgaussfilt(Jx2_max,sigma_g)';
%     %y = medfilt1(Jx2_max,sigma_g)';
%     semilogy(time_t_2,y,'--',LineWidth=2,color=C{kn})
% end
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
