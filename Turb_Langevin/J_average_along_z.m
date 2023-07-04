path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large';
path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini_L8di_8_dum'; % this has a high beta=0.8 and is L4, 32 waves.guide 0.2
path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini_L8di_8'; % this is L8, beta02, n01, dB02 

path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
%--------------------------------------------------------------------------
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';

for kn=1:8

%     % This set shows the difference in terms of the onset.
%     %----------------------------------------------------------------------------------------------------------------------
%     % ABCDE
%     %----------------------------------------------------------------------------------------------------------------------
%     if(kn==1)
%         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_alone_large';
%     elseif(kn==2)
%         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large';
%     elseif(kn==3)
%         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_Ax_large';
%     elseif(kn==4)
%         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large';
%     elseif(kn==5)
%         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini_L8di_8_du02'; %<-- this is in reality L=4.
%         %----------------------------------------------------------------------------------------------------------------------
%         % ABg02
%         %----------------------------------------------------------------------------------------------------------------------
%     elseif(kn==6)
%         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large_Bg02'; % this is with no pinch
%         %----------------------------------------------------------------------------------------------------------------------
%         %  Cyclotron frequency runs and short wave lengths
%         %----------------------------------------------------------------------------------------------------------------------
%     elseif(kn==7)
%         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1';
%     elseif(kn==8)
%         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_Omc1';
%     elseif(kn==9)
%         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kd1';
%     elseif(kn==10)
%         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_Omc1_kd1';
%         %-----------------------------------------------------------------------------------------------------------------------
% 
%         %  plasma, cyclotron frequency, di, rho
%         %----------------------------------------------------------------------------------------------------------------------
%     elseif(kn==11)
%         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kLd1';
%     elseif(kn==12)
%         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kLr1';
%     elseif(kn==13)
%         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_omp1_kLd1';
%     elseif(kn==14)
%         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_omp1_kLr1';
%     end
%     %-----------------------------------------------------------------------------------------------------------------------
% 
%     %-----------------------------------------------------------------------------------------------------------------------    
%     %including the effect of turning the fluctuations later
% 
%     kn=15; %1 to 105
%     path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_cpinch_sSR';
% 
%     kn=16; %1 to 45
%     path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_cpinch_sSR_lange';
%     %-----------------------------------------------------------------------------------------------------------------------

        % E1 E2 E3 E4 E5
    % This set shows the difference with n0, omega0, gamma0 and dB.
    %----------------------------------------------------------------------------------------------------------------------
    if(kn==1)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_nb01';
    elseif(kn==2)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_Bg01';
    elseif(kn==3)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_0mega09';
    elseif(kn==4)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_gamma06';
    elseif(kn==5)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB02';
    %elseif(kn==6)
    %    path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large';
    %legends_comp={'E1','E2','E3','E4','E5'};
    %-----------------------------------------------------------------------------------------------------------------------

    % This E, EdB08, EdB08_ome01, EdB08_ome01_cp .
    %----------------------------------------------------------------------------------------------------------------------
    elseif(kn==6)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08'; % this is with no pinch    
    elseif(kn==7)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_ome01';
    elseif(kn==8)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_ome01_cp'; % this one took longer. why?
    end
    %-----------------------------------------------------------------------------------------------------------------------


    % To save the plots
    path_rec_r = strcat(path,'/spectra/rec_r');
    path_rec_line = strcat(path,'/spectra/rec_line');
    path_rec_line_ByBzJx_zoom = strcat(path,'/spectra/rec_line/ByBzJx_zoom');
    if not(isfolder(path_rec_r))
        mkdir(path_rec_r)
    end
    if not(isfolder(path_rec_line))
        mkdir(path_rec_line)
    end
    if not(isfolder(path_rec_line_ByBzJx_zoom))
        mkdir(path_rec_line_ByBzJx_zoom)
    end
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
    jn=1;
    in=1;
    fileID =  S(in).name; %change the 1 per i
    %h5disp(fileID);
    info = h5info(fileID);
    EHJ_1st = info.Groups(16).Name;
    B=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    ss=size(B);
    LZs=ss(3);
    clearvars B
    %N=183;
    jn=N;
    in=jn;
    N_jn=N; %This is to store some but not all the time steps
    %N=61;N_jn=61; &lt;------------------------------- this is for the 3000

    time_t_2=zeros(1,N_jn);
    Jx_avg=zeros(1024,N_jn);
    ni_avg=zeros(1024,N_jn);
    ne_avg=zeros(1024,N_jn);
    %--------------------------------------------------------------------------
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
        %----------------------------------------------------------------------
        J{1,1}=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'));
        %----------------------------------------------------------------------
        %----------------------------------------------------------------------
        % slice in x
        ssz=size(J{1,1});
        sli_x = 1; % this value has to change to reconstruct the vector potential
        sli_y = floor(4+ssz(2)/2);%380;
        sli_z = floor(2+ssz(3)/2);%700;
        %----------------------------------------------------------------------
        Jx = J{1,1}; Jx = squeeze(Jx(sli_x,:,:));
        sss=size(Jx);
        size_X=sss;
        zll=linspace(-Lz,Lz,size_X(2)); %Jeff flag it works with (1,size_x(2))
        yll=linspace(-Ly,Ly,size_X(1));
        [ZLL, YLL] = meshgrid(zll,yll);
        %----------------------------------------------------------------------
        %--------------------------------------------------------------------------
        str = string(S(in).name);
        newStr = extractBetween(str,"pfd.","_p000000.h5");
        N_steps = str2double(newStr);
        time_t = dt*N_steps;
        time_t_2_Omega=time_t./omega_pe_Omega_ce;
        time_t_2(1,in)=time_t_2_Omega;
        %----------------------------------------------------------------------
        Jx_avg(:,in) = mean(Jx,2);
        cd(path)

        %----------------------------------------------------------------------
        disp(strcat('Computing step ...',S2(in).name))
        fileID2 =  S2(in).name; %change the 1 per i
        %h5disp(fileID2);
        info2 = h5info(fileID2);
        moments_1st = info2.Groups(1).Name;
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

        ni = n_i{1,1}; ni = squeeze(ni(sli_x,:,:));
        ne = n_e{1,1}; ne = squeeze(ne(sli_x,:,:));
        ni_avg(:,in) = mean(ni,2);
        ne_avg(:,in) = mean(ne,2);
        %----------------------------------------------------------------------
        fs=18;
        aa=1/23;
        ylen=length(yll); Dy=floor(aa*ylen);ycn=ylen/2;
        f2=figure(2);
        h1=subplot(2,1,1)
        hc=pcolor(ZLL, YLL,ni);
        hold on
        set(hc,'edgecolor','none')
        colorbar; caxis([0,4])
        colormap(h1,'jet');
        xlim([zll(1 ) zll(end )]);
        ylim([yll(ycn - Dy) yll(ycn + Dy)]);
        title('$n_{i}$','Interpreter','latex','FontSize',fs)
        ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
        ax.FontSize=fs;
        ax.XLabel.String = '$z / d_{i}$';
        ax.YLabel.String = '$y / d_{i}$';
        hold off
        h2=subplot(2,1,2)
        hc=pcolor(ZLL, YLL,ne);
        hold on
        set(hc,'edgecolor','none')
        colorbar; caxis([0,4])
        colormap(h2,'jet');
        xlim([zll(1 ) zll(end )]);
        ylim([yll(ycn - Dy) yll(ycn + Dy)]);
        ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
        ax.FontSize=fs;
        ax.XLabel.String = '$z / d_{i}$';
        ax.YLabel.String = '$y / d_{i}$';
        title('$n_{e}$','Interpreter','latex','FontSize',fs)
        hold off
        %----------------------------------------------------------------------
        sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
        %----------------------------------------------------------------------
        cd(path)
        saveas(f2,strcat(num2str(time_t),'ni_e_zoom.png'));
        %----------------------------------------------------------------------
    end


    %----------------------------------------------------------------------
    % Stack plots
    %----------------------------------------------------------------------
    time_t_2_Omega=time_t_2;
    [OMT, YLT]=meshgrid(time_t_2_Omega, yll);
    %----------------------------------------------------------------------
    fs=18;
    cd(path_s2)
    f35=figure(35)
    h1=subplot(1,1,1);
    dum_p=(Jx_avg/B0);%/max(max(abs(inte_Ax_i)));
    hc = pcolor(YLT,OMT,dum_p);
    hold on
    set(hc,'edgecolor','none')
    %colorbar; colormap(h1,flipud(turbo))
    colorbar; colormap(h1,BWR)
    %lim_yp=0.7*max(max(max(abs(dum_p))));
    caxis([-1.1,1.1]);
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs;
    ax.YLabel.String = '$t / \Omega_{e}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$y / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([yll(456) yll(568)]);ylim([time_t_2_Omega(1) time_t_2_Omega(end)]);
    lgnd=legend([h1],'$\frac{J_{x}}{J_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    hold off
    %----------------------------------------------------------------------
    %cd(path_rec_line)
    cd(path_comp)
    saveas(f35,strcat(num2str(kn),'Jx_avg_z_stack.png'));
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    fs=18;
    cd(path_s2)
    f36=figure(36)
    h1=subplot(1,1,1);
    dum_p=(ni_avg/B0);%/max(max(abs(inte_Ax_i)));
    hc = pcolor(YLT,OMT,dum_p);
    hold on
    set(hc,'edgecolor','none')
    %colorbar; colormap(h1,flipud(turbo))
    colorbar; colormap(h1,'jet')
    %lim_yp=0.7*max(max(max(abs(dum_p))));
    caxis([0,8]);
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs;
    ax.YLabel.String = '$t / \Omega_{e}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$y / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([yll(456) yll(568)]);ylim([time_t_2_Omega(1) time_t_2_Omega(end)]);
    lgnd=legend([h1],'$n_{i} $','Interpreter','latex','FontSize',1.3*fs);
    hold off
    %----------------------------------------------------------------------
    %cd(path_rec_line)
    cd(path_comp)
    saveas(f36,strcat(num2str(kn),'ni_avg_z_stack.png'));
    %----------------------------------------------------------------------

    cd(path)


end
