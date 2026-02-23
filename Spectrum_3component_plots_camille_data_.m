%cd ('/Users/jeffersson_agudelo/Downloads/New_images_may/')
%load('beta025_scatter.mat')
% Reddish Purple+6	(204, 121, 167)
% Blue	(0, 114, 178)
% Grey	(128, 128, 128)
% Vermillion	(213, 94, 0)
% Orange	(230, 159, 0)
% Black	(0, 0, 0)
% Bluish Green	(0, 158, 115)
% Yellow	(240, 228, 66)
My_colors = [ 204, 121, 167;
    0, 114, 178;
    128, 128, 128
    213, 94, 0;
    230, 159, 0;
    0, 0, 0;
    86, 180, 233;
    0, 158, 115;
    ]/256;

%--------------------------------------------------------------------------
lwm=2;
i=50; j=50;
fs=18; x0=45;y0=54;xx1=900;yy1=500;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%sp = 7/3;
%sp = 1/3; % This is for JxB/n
%sp = 11/3; % This is for the uxB term
%sp = 5/3; % This is for E
%sp = 0;
rho_terms = 0;
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
curls = 0;
if (curls == 1)
    term1_dt = term1_dt_x;
    term2_dt = term2_dt_x;
    term3_dt = term3_dt_x;
    term4_dt = term4_dt_x;
    term5_dt = term5_dt_x;
    term6_dt = term6_dt_x;

    tau_total = tau_total_x;
    tau_nE_tau = tau_nE_tau_x;
    tau_v_x_B_tau = tau_v_x_B_tau_x;
    tau_J_x_B_tau = tau_J_x_B_tau_x;
    tau_Div_tau1 = tau_Div_tau1_x;

    % I don't know where is the file where I define this. but it has to do with
    %  using K, H Omega vs not using them
    sum_tau_model1 = tau_M1_x;
    sum_tau_model2 = tau_M2_x;
end

if(rho_terms == 0)
    %--------------------------------------------------------------------------

    fs=20;
    threshold =pi/resx; %


    %
    [Ek_B_dt,~]=Omni1DSpectra3c(Bx_dt,By_dt,Bz_dt,Lx,threshold);

    term1_prime_x = term1_dt_x - term1_filt_x;
    term1_prime_y = term1_dt_y - term1_filt_y;
    term1_prime_z = term1_dt_z - term1_filt_z;

    [Ek_prime,~]=Omni1DSpectra3c(term1_prime_x,term1_prime_y,term1_prime_z,Lx,threshold);

    [Ek_term1_dt,~]=Omni1DSpectra3c(term1_dt_x,term1_dt_y,term1_dt_z,Lx,threshold);
    [Ek_term2_dt,~]=Omni1DSpectra3c(term2_dt_x,term2_dt_y,term2_dt_z,Lx,threshold);
    [Ek_term3_dt,~]=Omni1DSpectra3c(term3_dt_x,term3_dt_y,term3_dt_z,Lx,threshold);
    [Ek_term4_dt,~]=Omni1DSpectra3c(term4_dt_x,term4_dt_y,term4_dt_z,Lx,threshold);

    [Ek_term5_dt,~]=Omni1DSpectra3c(term5_dt_x,term5_dt_y, term5_dt_z,Lx,threshold);
    %[Ek_term6_dt,~]=Omni1DSpectra3c(term6_dt_x,term6_dt_y, term6_dt_z,Lx,threshold);
    [Ek_term7_dt,~] = Omni1DSpectra3c(term7_dt_x,term7_dt_y,term7_dt_z,Lx,threshold);

    [Ek_term1_filt,~]=Omni1DSpectra3c(term1_filt_x,term1_filt_y,term1_filt_z,Lx,threshold);
    [Ek_term2_filt,~]=Omni1DSpectra3c(term2_filt_x,term2_filt_y,term2_filt_z,Lx,threshold);
    [Ek_term3_filt,~]=Omni1DSpectra3c(term3_filt_x,term3_filt_y,term3_filt_z,Lx,threshold);
    [Ek_term4_filt,~]=Omni1DSpectra3c(term4_filt_x,term4_filt_y,term4_filt_z,Lx,threshold);

    [Ek_term5_filt,~]=Omni1DSpectra3c(term5_filt_x ,term5_filt_y,term5_filt_z,Lx,threshold);
    %[Ek_term6_filt,~]=Omni1DSpectra3c(term6_filt_x ,term6_filt_y,term6_filt_z,Lx,threshold);
    [Ek_term7_filt,~] = Omni1DSpectra3c(term7_filt_x,term7_filt_y,term7_filt_z,Lx,threshold);

    [Ek_tau_nE_tau,~]=Omni1DSpectra3c(tau_nE_tau_x,tau_nE_tau_y,tau_nE_tau_z,Lx,threshold);
    [Ek_tau_v_x_B_tau,~]=Omni1DSpectra3c(tau_v_x_B_tau_x,tau_v_x_B_tau_y,tau_v_x_B_tau_z,Lx,threshold);
    [Ek_tau_J_x_B_tau,~]=Omni1DSpectra3c(tau_J_x_B_tau_x,tau_J_x_B_tau_y,tau_J_x_B_tau_z,Lx,threshold);
    [Ek_tau_Div_tau1,~]=Omni1DSpectra3c(tau_Div_tau1_x,tau_Div_tau1_y,tau_Div_tau1_z,Lx,threshold);

    sum_tau_x = -tau_nE_tau_x -tau_v_x_B_tau_x + tau_J_x_B_tau_x + tau_Div_tau1_x;
    sum_tau_y = -tau_nE_tau_y -tau_v_x_B_tau_y + tau_J_x_B_tau_y + tau_Div_tau1_y;
    sum_tau_z = -tau_nE_tau_z -tau_v_x_B_tau_z + tau_J_x_B_tau_z + tau_Div_tau1_z;

    [Ek_sum_tau,k_bins]=Omni1DSpectra3c(sum_tau_x,sum_tau_y,sum_tau_z,Lx,threshold);

    % sum_tau01_x = -term4_filt_x + term5_filt_x + 1.*term6_filt_x + sum_tau_x;
    % sum_tau01_y = -term4_filt_y + term5_filt_y + 1.*term6_filt_y + sum_tau_y;
    % sum_tau01_z = -term4_filt_z + term5_filt_z + 1.*term6_filt_z + sum_tau_z;
    %
    % sum_tau02_x = term3_filt_x + sum_tau01_x;
    % sum_tau02_y = term3_filt_y + sum_tau01_y;
    % sum_tau02_z = term3_filt_z + sum_tau01_z;
    %
    % [Ek_sum_tau01,~]=Omni1DSpectra3c(sum_tau01_x,sum_tau01_y,sum_tau01_z,Lx,threshold);
    % [Ek_sum_tau02,~]=Omni1DSpectra3c(sum_tau02_x,sum_tau02_y,sum_tau02_z,Lx,threshold);

    %
    % [phase_diff_sum_tau_01,~] = Phase_difference(sum_tau01_x,sum_tau_x,Lx,threshold);
    % [phase_diff_sum_tau_02,k_bins] = Phase_difference(sum_tau02_x,sum_tau_x,Lx,threshold);
    %
    % if (curls == 1)
    % [Ek_sum_tau_M1, ~]=Omni1DSpectra(sum_tau_model1,x,threshold);
    % [Ek_sum_tau_M2, ~]=Omni1DSpectra(sum_tau_model2,Lx,threshold);
    %
    % % These phase difference also need to be modified (this ony has x so far)
    % [phase_diff_sum_tau_01_M2,~] = Phase_difference(sum_tau01_x, sum_tau_model2,Lx,threshold);
    % [phase_diff_sum_tau_02_M1,~] = Phase_difference(sum_tau02_x, sum_tau_model1,Lx,threshold);
    %
    % [phase_diff_sum_tau_M1,~] = Phase_difference(sum_tau_model1,sum_tau,Lx,threshold);
    % [phase_diff_sum_tau_M2,k_bins] = Phase_difference(sum_tau_model2,sum_tau,Lx,threshold);
    % end
    %}
    %----------------------------------------------------------------------

    fs=30;
    sp = 0; % This is for E
    f10013=figure(10013);
    set(gcf,'position',[x0,y0,2*xx1,yy1*2])

    subplot(2,2,1)
    dump = Ek_term1_dt.*(k_bins.^(sp));
    loglog(k_bins,dump,'--',color=My_colors(1,:),LineWidth=lwm)
    hold on
    dump = Ek_term1_filt.*(k_bins.^(sp));
    loglog(k_bins,dump,'r--',LineWidth=lwm)
    dump = Ek_prime.*(k_bins.^(sp));
    loglog(k_bins,dump,'b--',LineWidth=lwm)
    dump = Ek_B_dt.*(k_bins.^(sp));
    loglog(k_bins,dump,'-k',LineWidth=lwm)
    set(gca,'FontSize',fs)

    x2 = log10([1 10]); y2 = x2.*(-8/3) -1.3;
    loglog(10.^x2, 10.^y2,'k--',LineWidth=1.2);
    x2 = log10([2 10]); y2 = x2.*(-5/3) - 1.5;
    loglog(10.^x2, 10.^y2,'-',color=My_colors(3,:),LineWidth=1.5);
    txt1 = '$$ k^{-5/3}$$';
    txt2 = '$$ k^{-8/3}$$';
    txt3 = '$$ k_{c}$$';
    text(10 , 1e-2,txt1,'Interpreter','latex','FontSize',0.9*fs);
    text(6 , 1e-3,txt2,'Interpreter','latex','FontSize',0.9*fs);
    text(2 , 1e-6,txt3,'Interpreter','latex','FontSize',0.9*fs)

    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ylim([10^(-7),10^(0)])
    xlim([min(k_bins),threshold])
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$P1D$';
    xline(10,'--')
    xline(1,'--')
    xline(2*pi/(sqrt(12)*0.59),'k--', LineWidth=1.5)
    ax.YTick = [10^-9 10^-6, 10^-3];
    ax.XTick = [10^0, 10^1];
    set(gca,'FontSize',fs)
    legend( '$E$', '$\overline{E}$',...
        '$E^{\prime}$','$B $',...
        'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    hold off

    subplot(2,2,2)
    dump = Ek_term1_dt.*(k_bins.^(sp));
    loglog(k_bins,dump,'--',color=My_colors(1,:),LineWidth=lwm)
    hold on
    dump = Ek_term2_dt.*(k_bins.^(sp));
    loglog(k_bins,dump,'--',color=My_colors(2,:),LineWidth=lwm)
    dump = Ek_term3_dt.*(k_bins.^(sp));
    loglog(k_bins,dump,'--',color=My_colors(3,:),LineWidth=lwm)
    dump = Ek_term4_dt.*(k_bins.^(sp));
    loglog(k_bins,dump,'--',color=My_colors(4,:),LineWidth=lwm)
    dump = Ek_term5_dt.*(k_bins.^(sp));
    loglog(k_bins,dump,'--',color=My_colors(5,:),LineWidth=lwm)
    dump = Ek_term7_dt.*(k_bins.^(sp));
    loglog(k_bins,dump,'--',color=My_colors(6,:),LineWidth=lwm)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ylim([10^(-7),10^(0)])
    xlim([min(k_bins),threshold])
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$P1D$';
    xline(10,'--')
    xline(1,'--')
    xline(2*pi/(sqrt(12)*0.59),'k--', LineWidth=1.5)
    xlim([min(k_bins),threshold])
    ax.YTick = [10^-9 10^-6, 10^-3];
    ax.XTick = [10^0, 10^1];

    x2 = log10([2 10]); y2 = x2.*(-8/3) -1.3;
    loglog(10.^x2, 10.^y2,'-',color=My_colors(1,:),LineWidth=1.5);
    x2 = log10([1 5]); y2 = x2.*(-11/3) - 1.6;
    loglog(10.^x2, 10.^y2,'-',color=My_colors(2,:),LineWidth=1.5);
    x2 = log10([2 10]); y2 = x2.*(-5/3) - 1.2;
    loglog(10.^x2, 10.^y2,'-',color=My_colors(3,:),LineWidth=1.5);

    txt1 = '$$ k^{-5/3}$$';
    txt2 = '$$ k^{-8/3}$$';
    txt3 = '$$ k^{-11/3}$$';
    text(10 , 1e-2,txt1,'Interpreter','latex','FontSize',0.9*fs);
    text(10 , 1e-4,txt2,'Interpreter','latex','FontSize',0.9*fs);
    text(3 , 1e-3,txt3,'Interpreter','latex','FontSize',0.9*fs)

    legend( '${\mathbf{E}}$', ...
        '${\mathbf{E}}_{MHD}$',...
        '${\mathbf{E}}_{Hall}$',...
        '${\mathbf{E}}_{Pe}$', ...
        '${\mathbf{E}}_{Ine}$',...
        '${\mathbf{E}}_{RHS}$',...
        'Interpreter','latex','NumColumns',1,'Location','southoutside')
    set(gca,'FontSize',fs)
    hold off


    subplot(2,2,3)
    dump = Ek_term1_filt.*(k_bins.^(sp));
    loglog(k_bins,dump,'-',color=My_colors(1,:),LineWidth=1.5)
    hold on
    dump = Ek_term2_filt.*(k_bins.^(sp));
    loglog(k_bins,dump,'-',color=My_colors(2,:),LineWidth=1.5)
    dump = Ek_term3_filt.*(k_bins.^(sp));
    loglog(k_bins,dump,'-',color=My_colors(3,:),LineWidth=1.5)
    dump = Ek_term4_filt.*(k_bins.^(sp));
    loglog(k_bins,dump,'-',color=My_colors(4,:),LineWidth=1.5)
    dump = Ek_term5_filt.*(k_bins.^(sp));
    loglog(k_bins,dump,'-',color=My_colors(5,:),LineWidth=1.5)
    dump = Ek_term7_filt.*(k_bins.^(sp));
    loglog(k_bins,dump,'-',color=My_colors(6,:),LineWidth=1.5)

    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    %ax.YTick = [10^5, 10^11];
    %ax.XTick = [10^0, 10^1];
    %yline(1*10^4,'--')
    ylim([10^(-7),10^(0)])
    xlim([min(k_bins),10])
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$P1D$';
    ax.YTick = [10^-9 10^-6, 10^-3];
    ax.XTick = [10^0, 10^1];
    xline(10,'--')
    xline(1,'--')
    xline(2*pi/(sqrt(12)*0.59),'k--', LineWidth=1.5)
    set(gca,'FontSize',fs)
    legend( '$\overline{\mathbf{E}}$', ...
        '$\overline{\mathbf{E}}_{MHD}$',...
        '$\overline{\mathbf{E}}_{Hall}$',...
        '$\overline{\mathbf{E}}_{Pe}$', ...
        '$\overline{\mathbf{E}}_{Ine}$',...
        '$\overline{\mathbf{E}}_{RHS}$',...
        'Interpreter','latex','NumColumns',1,'Location','southoutside')
    hold off

    subplot(2,2,4)
    dump = Ek_tau_nE_tau.*(k_bins.^(sp));
    loglog(k_bins,dump,'-.',color=My_colors(1,:),LineWidth=lwm)
    hold on
    dump = Ek_tau_v_x_B_tau.*(k_bins.^(sp));
    loglog(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=lwm)
    dump = Ek_tau_J_x_B_tau.*(k_bins.^(sp));
    loglog(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=lwm)
    dump = Ek_tau_Div_tau1.*(k_bins.^(sp));
    loglog(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=lwm)
    dump = Ek_sum_tau.*(k_bins.^(sp));
    loglog(k_bins,dump,'-.',color=My_colors(6,:),LineWidth=lwm)
    set(gca,'FontSize',fs)

    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    %ax.YTick = [10^5, 10^10];
    %ax.YLabel.String = '$k^{5/3} P1D_{x}$';
    %ax.XTick = [10^0, 10^1];

    %ylim([-0.6,0.3])
    % legend('$-\tau_{nE}$', ...
    %     '$-\tau_{nu \times B}$', ...
    %     '$\tau_{J \times B}$',...
    %     '$\tau_{\nabla \cdot(uJ+Ju-JJ/ne)}$',...
    %     '$\Sigma \tau$',...
    %     'Interpreter','latex','NumColumns',1,'Location','southeastoutside')

    ylim([10^(-11),10^(-3)])
    xlim([min(k_bins),10])
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$P1D$';
    ax.YTick = [10^-9 10^-6, 10^-3];
    ax.XTick = [10^0, 10^1];
    xline(10,'--')
    xline(1,'--')
    xline(2*pi/(sqrt(12)*0.59),'k--', LineWidth=1.5)
    legend( '${\tau}_{nE}$', ...
        '$\tau_{nu \times B}$', ...
        '$\tau_{J \times B}$',...
        '$\tau_{Ine}$',...
        '$\Sigma \tau$',...
        'Interpreter','latex','NumColumns',1,'Location','southoutside')
    hold off




    % Lets make also plots for the ratios julia style fo

    %--------------------------------------------------------------------------
    fs=20;
    sp = 0; % This is for E
    f10014=figure(10014);
    set(gcf,'position',[x0,y0,1*xx1,yy1*1])
    dump = Ek_term3_dt./Ek_term2_dt;
    loglog(k_bins,dump,'-',color=My_colors(3,:),LineWidth=lwm)
    hold on
    dump = Ek_term4_dt./Ek_term3_dt;
    loglog(k_bins,dump,'-',color=My_colors(4,:),LineWidth=lwm)
    dump = Ek_term5_dt./Ek_term4_dt;
    loglog(k_bins,dump,'-',color=My_colors(5,:),LineWidth=lwm)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    %ylim([10^(-7),10^(0)])
    xlim([min(k_bins),threshold])
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$Ratio \ P1D$';
    xline(10,'--')
    xline(1,'--')
    xline(2*pi/(sqrt(12)*0.59),'k--', LineWidth=1.5)
    xlim([min(k_bins),threshold])
    %ax.YTick = [10^-9 10^-6, 10^-3];
    ax.XTick = [10^0, 10^1];

    txt1 = '$$ k^{-5/3}$$';
    txt2 = '$$ k^{-8/3}$$';
    txt3 = '$$ k^{-11/3}$$';
    text(10 , 1e-2,txt1,'Interpreter','latex','FontSize',0.9*fs);
    text(10 , 1e-4,txt2,'Interpreter','latex','FontSize',0.9*fs);
    text(3 , 1e-3,txt3,'Interpreter','latex','FontSize',0.9*fs)

    legend( '$\mathbf{E}_{Hall}/\mathbf{E}_{MHD}$',...
        '$\mathbf{E}_{Pe}/\mathbf{E}_{Hall}$',...
        '$\mathbf{E}_{Ine} / \mathbf{E}_{Pe}$', ...
        'Interpreter','latex','NumColumns',1,'Location','southoutside')
    set(gca,'FontSize',fs)
    hold off
    %--------------------------------------------------------------------------


        % This is for the plot of the phase differences
    %----------------------------------------------------------------------
    %[phase_diff_uxB,~] = Phase_difference(term2_filt_x,tau_v_x_B_tau_x,Lx,threshold);
    % [phase_diff_JxB,~] = Phase_difference(term3_filt_x,tau_J_x_B_tau_x,Lx,threshold);
    % [phase_diff_div,~] = Phase_difference(term5_filt_x,tau_Div_tau1_x,Lx,threshold);
    % [phase_diff_sumtau,k_bins] = Phase_difference(term7_filt_x,sum_tau_x,Lx,threshold);

    %for the three components doing the average of the phase angle
    %{
    [phase_diff_uxB_x,~] = Phase_difference(term2_filt_x,tau_v_x_B_tau_x,Lx,threshold);
    [phase_diff_JxB_x,~] = Phase_difference(term3_filt_x,tau_J_x_B_tau_x,Lx,threshold);
    [phase_diff_div_x,~] = Phase_difference(term5_filt_x,tau_Div_tau1_x,Lx,threshold);
    [phase_diff_sumtau_x,~] = Phase_difference(term7_filt_x,sum_tau_x,Lx,threshold);

    [phase_diff_uxB_y,~] = Phase_difference(term2_filt_y,tau_v_x_B_tau_y,Lx,threshold);
    [phase_diff_JxB_y,~] = Phase_difference(term3_filt_y,tau_J_x_B_tau_y,Lx,threshold);
    [phase_diff_div_y,~] = Phase_difference(term5_filt_y,tau_Div_tau1_y,Lx,threshold);
    [phase_diff_sumtau_y,~] = Phase_difference(term7_filt_y,sum_tau_y,Lx,threshold);

    [phase_diff_uxB_z,~] = Phase_difference(term2_filt_z,tau_v_x_B_tau_z,Lx,threshold);
    [phase_diff_JxB_z,~] = Phase_difference(term3_filt_z,tau_J_x_B_tau_z,Lx,threshold);
    [phase_diff_div_z,~] = Phase_difference(term5_filt_z,tau_Div_tau1_z,Lx,threshold);
    [phase_diff_sumtau_z,k_bins] = Phase_difference(term7_filt_z,sum_tau_z,Lx,threshold);

    phase_diff_uxB = sqrt(phase_diff_uxB_x.^2 + phase_diff_uxB_y.^2 + phase_diff_uxB_z.^2);
    phase_diff_JxB = sqrt(phase_diff_JxB_x.^2 + phase_diff_JxB_y.^2 + phase_diff_JxB_z.^2);
    phase_diff_div = sqrt(phase_diff_div_x.^2 + phase_diff_div_y.^2 + phase_diff_div_z.^2);
    phase_diff_sumtau = sqrt(phase_diff_sumtau_x.^2 + phase_diff_sumtau_y.^2 + phase_diff_sumtau_z.^2);
    %}

    % This is computing the phase angle of the dot product of between tau
    % and the complex conjugate
    %Phase_difference3D(uxB_x,uxB_y,uxB_z,tauuxB_x,tauuxB_y,tauuxB_z,Lx,threshold)    


    [phase_diff_uxB,~] = Phase_difference3D(term2_filt_x,term2_filt_y,term2_filt_z, ...
        tau_v_x_B_tau_x,tau_v_x_B_tau_y,tau_v_x_B_tau_z,Lx,threshold);

    [phase_diff_JxB,~] = Phase_difference3D(term3_filt_x,term3_filt_y,term3_filt_z, ...
        tau_J_x_B_tau_x,tau_J_x_B_tau_y,tau_J_x_B_tau_z,Lx,threshold);

    [phase_diff_div,~] = Phase_difference3D(term5_filt_x,term5_filt_y,term5_filt_z, ...
        tau_Div_tau1_x,tau_Div_tau1_y,tau_Div_tau1_z,Lx,threshold); 

    [phase_diff_sumtau,~] = Phase_difference3D(term7_filt_x,term7_filt_y,term7_filt_z, ...
        sum_tau_x,sum_tau_y,sum_tau_z,Lx,threshold);     

    f1006=figure(1006);
    set(gcf,'position',[x0,y0,1*xx1,yy1*1])
    subplot(2,1,1)
    dump = Ek_tau_v_x_B_tau./Ek_term2_filt;
    loglog(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
    hold on
    dump = Ek_tau_J_x_B_tau./Ek_term3_filt;
    loglog(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=4)
    dump = Ek_tau_Div_tau1./Ek_term5_filt;
    loglog(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=2)
    dump = Ek_sum_tau./Ek_term7_filt;
    loglog(k_bins,dump,'-.',color=My_colors(6,:),LineWidth=2)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$Ratio \ P1D$';
    %xlim([10^(0),1.1*10^(1)])
    %xlim([min(sqrt(beta_i)*k_bins),threshold])
    xline(10,'--')
    xline(1,'--')
    xline(2*pi/(sqrt(12)*0.28),'k--', LineWidth=1.5)
    xlim([min(k_bins),20])
    ax.XTick = [10^0, 10^1];
    ax.YTick = [10^-1, 10^2];
    ylim([10^(-5),1*10^(3)])
    %ylim([-0.6,0.3])
    legend('$\tau_{nu \times B}/\overline{\mathbf{E}}_{MHD}$', ...
        '$\tau_{J \times B} / \overline{\mathbf{E}}_{Hall}$',...
        '$\tau_{Ine} / \overline{\mathbf{E}}_{Ine}$',...
        '$\Sigma \tau / \overline{\mathbf{E}}_{RHS}$',...
        'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    title('$\Delta_{l} = 0.28 d_{i}$','Interpreter','latex')
    hold off

    subplot(2,1,2)
    dump = phase_diff_uxB./sqrt(3);
    semilogx(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
    hold on
    dump = phase_diff_JxB./sqrt(3);
    semilogx(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
    dump = phase_diff_div./sqrt(3);
    semilogx(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=2)
    dump = phase_diff_sumtau./sqrt(3);
    semilogx(k_bins,dump,'-.',color=My_colors(6,:),LineWidth=2)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$\Delta \phi^{\circ}$';
    %xlim([10^(0),1.1*10^(1)])
    %xlim([min(sqrt(beta_i)*k_bins),threshold])
    %ylim([10^(0),10^(14)])
    xlim([0.3,threshold])
    ax.XTick = [10^0, 10^1];
    ax.YTick = [0, 90, 180];
    yline(135,'--')
    yline(90,'--')
    ylim([0,180])

    xline(10,'--')
    xline(1,'--')
    xline(2*pi/(sqrt(12)*0.28),'k--', LineWidth=1.5)
    xlim([min(k_bins),20])
    %ax.YTick = [10^-9 10^-6, 10^-3];
    ax.XTick = [10^0, 10^1];

    %ylim([-0.6,0.3])
    legend('$\tau_{nu \times B}/\overline{\mathbf{E}}_{MHD}$', ...
        '$\tau_{J \times B} / \overline{\mathbf{E}}_{Hall}$',...
        '$\tau_{Ine} / \overline{\mathbf{E}}_{Ine}$',...
        '$\Sigma \tau / \overline{\mathbf{E}}_{RHS}$',...
        'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    %title('$\Delta_{l} = 0.59 d_{i}$','Interpreter','latex')
    hold off

    stopp

  f1006=figure(1006);
    set(gcf,'position',[x0,y0,1*xx1,yy1*2])


    subplot(4,1,1)
    dump = phase_diff_uxB_x;
    semilogx(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
    hold on
    dump = phase_diff_JxB_x;
    semilogx(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
    dump = phase_diff_div_x;
    semilogx(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=2)
    dump = phase_diff_sumtau_x;
    semilogx(k_bins,dump,'-.',color=My_colors(6,:),LineWidth=2)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$\Delta \phi^{\circ}_{x}$';
    xlim([0.3,threshold])
    ax.YTick = [0, 90, 180];
    yline(135,'--')
    yline(90,'--')
    ylim([0,180])
    xline(10,'--')
    xline(1,'--')
    xline(2*pi/(sqrt(12)*0.59),'k--', LineWidth=1.5)
    xlim([min(k_bins),20])
    ax.XTick = [10^0, 10^1];
    legend('$\tau_{nu \times B}/\overline{\mathbf{E}}_{MHD}$', ...
        '$\tau_{J \times B} / \overline{\mathbf{E}}_{Hall}$',...
        '$\tau_{Ine} / \overline{\mathbf{E}}_{Ine}$',...
        '$\Sigma \tau / \overline{\mathbf{E}}_{RHS}$',...
        'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    hold off


    subplot(4,1,2)
    dump = phase_diff_uxB_y;
    semilogx(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
    hold on
    dump = phase_diff_JxB_y;
    semilogx(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
    dump = phase_diff_div_y;
    semilogx(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=2)
    dump = phase_diff_sumtau_y;
    semilogx(k_bins,dump,'-.',color=My_colors(6,:),LineWidth=2)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$\Delta \phi^{\circ}_{y}$';
    xlim([0.3,threshold])
    ax.YTick = [0, 90, 180];
    yline(135,'--')
    yline(90,'--')
    ylim([0,180])
    xline(10,'--')
    xline(1,'--')
    xline(2*pi/(sqrt(12)*0.59),'k--', LineWidth=1.5)
    xlim([min(k_bins),20])
    ax.XTick = [10^0, 10^1];
    legend('$\tau_{nu \times B}/\overline{\mathbf{E}}_{MHD}$', ...
        '$\tau_{J \times B} / \overline{\mathbf{E}}_{Hall}$',...
        '$\tau_{Ine} / \overline{\mathbf{E}}_{Ine}$',...
        '$\Sigma \tau / \overline{\mathbf{E}}_{RHS}$',...
        'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    hold off

    subplot(4,1,3)
    dump = phase_diff_uxB_z;
    semilogx(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
    hold on
    dump = phase_diff_JxB_z;
    semilogx(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
    dump = phase_diff_div_z;
    semilogx(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=2)
    dump = phase_diff_sumtau_z;
    semilogx(k_bins,dump,'-.',color=My_colors(6,:),LineWidth=2)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$\Delta \phi^{\circ}_{z}$';
    xlim([0.3,threshold])
    ax.YTick = [0, 90, 180];
    yline(135,'--')
    yline(90,'--')
    ylim([0,180])
    xline(10,'--')
    xline(1,'--')
    xline(2*pi/(sqrt(12)*0.59),'k--', LineWidth=1.5)
    xlim([min(k_bins),20])
    ax.XTick = [10^0, 10^1];
    legend('$\tau_{nu \times B}/\overline{\mathbf{E}}_{MHD}$', ...
        '$\tau_{J \times B} / \overline{\mathbf{E}}_{Hall}$',...
        '$\tau_{Ine} / \overline{\mathbf{E}}_{Ine}$',...
        '$\Sigma \tau / \overline{\mathbf{E}}_{RHS}$',...
        'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    hold off

    subplot(4,1,4)
    dump = phase_diff_uxB./sqrt(3);
    semilogx(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
    hold on
    dump = phase_diff_JxB./sqrt(3);
    semilogx(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
    dump = phase_diff_div./sqrt(3);
    semilogx(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=2)
    dump = phase_diff_sumtau./sqrt(3);
    semilogx(k_bins,dump,'-.',color=My_colors(6,:),LineWidth=2)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$\Delta \phi^{\circ}$';
    xlim([0.3,threshold])
    ax.YTick = [0, 90, 180];
    yline(135,'--')
    yline(90,'--')
    ylim([0,180])
    xline(10,'--')
    xline(1,'--')
    xline(2*pi/(sqrt(12)*0.59),'k--', LineWidth=1.5)
    xlim([min(k_bins),20])
    ax.XTick = [10^0, 10^1];
    legend('$\tau_{nu \times B}/\overline{\mathbf{E}}_{MHD}$', ...
        '$\tau_{J \times B} / \overline{\mathbf{E}}_{Hall}$',...
        '$\tau_{Ine} / \overline{\mathbf{E}}_{Ine}$',...
        '$\Sigma \tau / \overline{\mathbf{E}}_{RHS}$',...
        'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    hold off


stopp


    %----------------------------------------------------------------------

    stopp


    % % This is to test the random and phase things
    % %--------------------------------------------------------------------------
    % % This part is to check the phase difference with the random values
    % rng(1)
    % %N = 64;
    % tau = randn(size(tau_total_x));
    % %%% --- Model 1: scaled + noise (mostly in-phase) ---
    % tauM1 = 0.8*tau + 0.3*randn(size(tau_total_x));
    % %%% --- Model 2: spatially shifted field (introduces phase lag) ---
    % dx_shift = 2; % shift by 2 grid cells in x
    % tauM2 = circshift(tau, [dx_shift 0 0]); % exact spatial shift
    %
    % %AA = rand(size(tau_total_x));
    % %BB = rand(size(tau_total_x));
    %
    % AA = tau;
    % BB = tauM2;
    %
    % [Ek_AA,~]=Omni1DSpectra(AA,Lx,threshold);
    % [Ek_BB,~]=Omni1DSpectra(BB,Lx,threshold);
    % [phase_diff_AABB,k_bins] = Phase_difference(AA,BB,Lx,threshold);
    %
    % f10047=figure(10047);
    % subplot(2,1,1)
    % %hold on
    % dump = (Ek_AA./max(Ek_AA)^1);
    % loglog(k_bins,dump,'-.',color=My_colors(1,:),LineWidth=2)
    % hold on
    % dump = (Ek_BB./max(Ek_BB)^1);
    % loglog(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
    % set(gca,'FontSize',fs)
    % ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    % ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    % ax.XLabel.String = '$kd_i$';
    % ax.YLabel.String = '$P1D_{x}/max$';
    % ax.XTick = [10^0, 10^1];
    % ax.YTick = [10^-10, 10^-5, 10^0];
    % ylim([10^(-12),5*10^(0)])
    % xlim([0.3,0.8*threshold])
    % legend('$Rand A$',...
    %     '$Rand B$',...
    %     'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    % hold off
    %
    % subplot(1,1,1)
    % dump = phase_diff_AABB;
    % semilogx(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
    % hold on
    % set(gca,'FontSize',fs)
    % ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    % ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    % ax.XLabel.String = '$kd_i$';
    % ax.YLabel.String = '$\Delta \phi^{\circ}$';
    % %ax.XTick = [10^0, 10^1];
    % %ax.YTick = [0, 90, 180];
    % %ylim([0,180])
    % %xlim([0.3,0.8*threshold])
    % legend( '$rand,rand$',...
    %     'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    % %title('$\beta_{i}=4$', 'Interpreter','latex')
    % hold off
    % %--------------------------------------------------------------------------

    %stopp

    % This is for the case of the curls
    %--------------------------------------------------------------------------
    %{
    [Ek_curl_tau_total_x,~]=Omni1DSpectra(curl_tau_total_x,Lx,threshold);
    [Ek_curl_tau_M1_x,~]=Omni1DSpectra(curl_tau_M1_x,Lx,threshold);
    [Ek_curl_tau_M2_x,~]=Omni1DSpectra(curl_tau_M2_x,Lx,threshold);
    [Ek_curl_tau01_x,~]=Omni1DSpectra(curl_tau01_x,Lx,threshold);
    [Ek_curl_tau02_x,~]=Omni1DSpectra(curl_tau02_x,Lx,threshold);

    [phase_diff_curl_tau_M1_x,~] = Phase_difference(curl_tau_M1_x,curl_tau_total_x,Lx,threshold);
    [phase_diff_curl_tau_M2_x,~] = Phase_difference(curl_tau_M2_x,curl_tau_total_x,Lx,threshold);
    [phase_diff_curl_tau01_x,~] = Phase_difference(curl_tau01_x,curl_tau_total_x,Lx,threshold);
    [phase_diff_curl_tau02_x,~] = Phase_difference(curl_tau02_x,curl_tau_total_x,Lx,threshold);

    [Ek_curl_tau_total_mag,~]=Omni1DSpectra(curl_tau_total_mag,Lx,threshold);
    [Ek_curl_tau_M1_mag,~]=Omni1DSpectra(curl_tau_M1_mag,Lx,threshold);
    [Ek_curl_tau_M2_mag,~]=Omni1DSpectra(curl_tau_M2_mag,Lx,threshold);
    [Ek_curl_tau01_mag,~]=Omni1DSpectra(curl_tau01_mag,Lx,threshold);
    [Ek_curl_tau02_mag,~]=Omni1DSpectra(curl_tau02_mag,Lx,threshold);

    [phase_diff_curl_tau_M1_mag,~] = Phase_difference(curl_tau_M1_mag,curl_tau_total_mag,Lx,threshold);
    [phase_diff_curl_tau_M2_mag,~] = Phase_difference(curl_tau_M2_mag,curl_tau_total_mag,Lx,threshold);
    [phase_diff_curl_tau01_mag,~] = Phase_difference(curl_tau01_mag,curl_tau_total_mag,Lx,threshold);
    [phase_diff_curl_tau02_mag,k_bins] = Phase_difference(curl_tau02_mag,curl_tau_total_mag,Lx,threshold);

    f10045=figure(10045);
    subplot(2,1,1)
    %hold on
    dump = (Ek_curl_tau_total_x./max(Ek_curl_tau_total_x)^1);
    loglog(k_bins,dump,'-.',color=My_colors(1,:),LineWidth=2)
    hold on
    dump = (Ek_curl_tau_M1_x./max(Ek_curl_tau_M1_x)^1);
    loglog(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
    dump = (Ek_curl_tau_M2_x./max(Ek_curl_tau_M2_x)^1);
    loglog(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
    dump = (Ek_curl_tau02_x./max(Ek_curl_tau02_x)^1);
    loglog(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=2)
    dump = (Ek_curl_tau01_x./max(Ek_curl_tau01_x)^1);
    loglog(k_bins,dump,'-.',color=My_colors(4,:),LineWidth=2)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$P1D_{x}/max$';
    ax.XTick = [10^0, 10^1];
    ax.YTick = [10^-10, 10^-5, 10^0];
    ylim([10^(-12),5*10^(0)])
    xlim([0.3,0.8*threshold])
    % legend('$\nabla \times \Sigma \tau$',...
    %     '$\nabla \times \Sigma \tau_{M1}$',...
    %     '$\nabla \times \Sigma\tau_{M2}$',...
    %     '$\nabla \times \Sigma \tau_{MHD}$',...
    %     '$\nabla \times \Sigma \tau_{HMHD}$',...
    %     'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    title('$\nabla \times \Sigma \tau_{x}$', 'Interpreter','latex')
    hold off

    subplot(2,1,2)
    dump = phase_diff_curl_tau_M1_x;
    semilogx(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
    hold on
    dump = phase_diff_curl_tau_M2_x;
    semilogx(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
    dump = phase_diff_curl_tau02_x;
    semilogx(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=2)
    dump = phase_diff_curl_tau01_x;
    semilogx(k_bins,dump,'-.',color=My_colors(4,:),LineWidth=2)

    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$\Delta \phi^{\circ}$';
    ax.XTick = [10^0, 10^1];
    ax.YTick = [0, 90, 180];
    ylim([0,180])
    xlim([0.3,0.8*threshold])
    % legend( '$\nabla \times \Sigma \tau_{M1,x},\Sigma \tau_x$', ...
    %     '$\nabla \times \Sigma \tau_{M2,x},\Sigma \tau_x$',...
    %     '$\nabla \times \Sigma \tau_{MHD,x},\Sigma \tau_x$',...
    %     '$\nabla \times \Sigma \tau_{HMHD,x},\Sigma \tau_x$',...
    %     'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    %title('$\beta_{i}=4$', 'Interpreter','latex')
    hold off

    f10046=figure(10046);
    subplot(2,1,1)
    %hold on
    dump = (Ek_curl_tau_total_mag./max(Ek_curl_tau_total_mag)^1);
    loglog(k_bins,dump,'-.',color=My_colors(1,:),LineWidth=2)
    hold on
    dump = (Ek_curl_tau_M1_mag./max(Ek_curl_tau_M1_mag)^1);
    loglog(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
    dump = (Ek_curl_tau_M2_mag./max(Ek_curl_tau_M2_mag)^1);
    loglog(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
    dump = (Ek_curl_tau02_mag./max(Ek_curl_tau02_mag)^1);
    loglog(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=2)
    dump = (Ek_curl_tau01_mag./max(Ek_curl_tau01_mag)^1);
    loglog(k_bins,dump,'-.',color=My_colors(4,:),LineWidth=2)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$P1D_{x}/max$';
    ax.XTick = [10^0, 10^1];
    ax.YTick = [10^-10, 10^-5, 10^0];
    ylim([10^(-12),5*10^(0)])
    xlim([0.3,0.8*threshold])
    % legend('$|\nabla \times \Sigma \tau|$',...
    %     '$|\nabla \times \Sigma \tau_{M1}|$',...
    %     '$|\nabla \times \Sigma \tau_{M2}|$',...
    %     '$|\nabla \times \Sigma \tau_{MHD}|$',...
    %     '$|\nabla \times \Sigma \tau_{HMHD}|$',...
    %     'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
        title('$|\nabla \times \Sigma \tau|$', 'Interpreter','latex')
    hold off

    subplot(2,1,2)
    dump = phase_diff_curl_tau_M1_mag;
    semilogx(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
    hold on
    dump = phase_diff_curl_tau_M2_mag;
    semilogx(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
    dump = phase_diff_curl_tau02_mag;
    semilogx(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=2)
    dump = phase_diff_curl_tau01_mag;
    semilogx(k_bins,dump,'-.',color=My_colors(4,:),LineWidth=2)

    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$\Delta \phi^{\circ}$';
    ax.XTick = [10^0, 10^1];
    ax.YTick = [0, 90, 180];
    ylim([0,180])
    xlim([0.3,0.8*threshold])
    % legend( '$|\nabla \times \Sigma \tau_{M1}|,|\nabla \times \Sigma \tau|$', ...
    %     '$|\nabla \times \Sigma \tau_{M2}|,|\nabla \times \Sigma \tau|$',...
    %     '$|\nabla \times \Sigma \tau_{MHD}|,|\nabla \times \Sigma \tau|$',...
    %     '$|\nabla \times \Sigma \tau_{HMHD}|,|\nabla \times \Sigma \tau|$',...
    %     'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    hold off
    %}
    %stopp
    %--------------------------------------------------------------------------


    %----------------------------------------------------------------------
    sp = 0; % This is for E

    f1000=figure(1000);
    set(gcf,'position',[x0,y0,xx1,yy1/2])
    subplot(1,1,1)
    dump = Ek_sum_tau./max(Ek_sum_tau.^1).*(k_bins.^(sp));
    loglog(k_bins,dump,'--',color=My_colors(1,:),LineWidth=lwm)
    hold on
    dump = Ek_sum_tau01./max(Ek_sum_tau01.^1).*(k_bins.^(sp));
    loglog(k_bins,dump,'*',color=My_colors(4,:),LineWidth=lwm)
    dump = Ek_sum_tau02./max(Ek_sum_tau02.^1).*(k_bins.^(sp));
    loglog(k_bins,dump,'^',color=My_colors(5,:),LineWidth=lwm);
    dump = Ek_sum_tau_M1./max(Ek_sum_tau_M1.^1).*(k_bins.^(sp));
    loglog(k_bins,dump,'--',color=My_colors(2,:),LineWidth=lwm)
    dump = Ek_sum_tau_M2./max(Ek_sum_tau_M2.^1).*(k_bins.^(sp));
    loglog(k_bins,dump,'--',color=My_colors(3,:),LineWidth=lwm)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$P1D_{x}/P1D_{x,max}$';
    xlim([min(k_bins),threshold])
    %ylim([10^(-12),5*10^(0)])
    ax.YTick = [10^-7, 10^0];
    ax.XTick = [10^0, 10^1];
    legend( '$\Sigma \tau$',...
        '$\Sigma \tau_{HMHD}$',...
        '$\Sigma \tau_{MHD}$',...
        '$\Sigma \tau_{M1}$',...
        '$\Sigma \tau_{M2}$', ...
        'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    % %ylim([-0.045,0.045])
    set(gca,'FontSize',fs)
    title('$\beta_{i}=4$', 'Interpreter','latex')
    hold off

    f10041=figure(10041);
    subplot(2,1,1)
    %hold on
    dump = (Ek_sum_tau./max(Ek_sum_tau)^1);
    loglog(k_bins,dump,'-.',color=My_colors(1,:),LineWidth=2)
    hold on
    dump = (Ek_sum_tau_M1./max(Ek_sum_tau_M1)^1);
    loglog(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
    dump = (Ek_sum_tau_M2./max(Ek_sum_tau_M2)^1);
    loglog(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
    dump = (Ek_sum_tau02./max(Ek_sum_tau02)^1);
    loglog(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=2)
    dump = (Ek_sum_tau01./max(Ek_sum_tau01)^1);
    loglog(k_bins,dump,'-.',color=My_colors(4,:),LineWidth=2)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$P1D_{x}/max$';
    ax.XTick = [10^0, 10^1];
    ax.YTick = [10^-10, 10^-5, 10^0];
    ylim([10^(-12),5*10^(0)])
    xlim([0.3,0.8*threshold])
    legend('$\Sigma\tau$',...
        '$\Sigma\tau_{M1}$',...
        '$\Sigma\tau_{M2}$',...
        '$\Sigma \tau_{MHD}$',...
        '$\Sigma \tau_{HMHD}$',...
        'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    hold off

    subplot(2,1,2)
    dump = phase_diff_sum_tau_M1;
    semilogx(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
    hold on
    dump = phase_diff_sum_tau_M2;
    semilogx(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
    dump = phase_diff_sum_tau_02;
    semilogx(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=2)
    dump = phase_diff_sum_tau_01;
    semilogx(k_bins,dump,'-.',color=My_colors(4,:),LineWidth=2)

    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$\Delta \phi^{\circ}$';
    ax.XTick = [10^0, 10^1];
    ax.YTick = [0, 90, 180];
    ylim([0,180])
    xlim([0.3,0.8*threshold])
    legend( '$\Sigma \tau_{M1},\Sigma \tau$', ...
        '$\Sigma \tau_{M2},\Sigma \tau$',...
        '$\Sigma \tau_{MHD},\Sigma \tau$',...
        '$\Sigma \tau_{HMHD},\Sigma \tau$',...
        'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    %title('$\beta_{i}=4$', 'Interpreter','latex')
    hold off


    f123 =figure(123);
    dump = phase_diff_sum_tau_01_M2;
    semilogx(k_bins,dump,'-.',color=My_colors(4,:),LineWidth=1.5)
    hold on
    dump = phase_diff_sum_tau_02_M1;
    semilogx(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=1.5)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$\Delta \phi^{\circ}$';
    ax.XTick = [10^0, 10^1];
    ax.YTick = [0, 90, 180];
    ylim([0,180])
    xlim([0.3,threshold])
    legend( '$\Sigma \tau_{HMHD},\Sigma \tau_{M2}$',...
        '$\Sigma \tau_{MHD},\Sigma \tau_{M1}$',...
        'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    title('$\beta_{i}=4$', 'Interpreter','latex')
    hold off


    %cd('~/Downloads')
    %saveas(f1000,strcat(num2str(component),'spectrum_taus_model_4.png'));
    %saveas(f1005,strcat(num2str(component),'spectrum_taus_model_phase_diff_4_legen.png'));

    %stopp

    %--------------------------------------------------------------------------
    % % cumulative energy fraction
    % cumE_tau = cumsum(Ek_tau_nE_tau)./sum(Ek_tau_nE_tau);
    % k50 = k_bins(find(cumE_tau>0.5,1));
    % % median contributing k
    % disp(['Median contribution of tau at k ~ ', num2str(k50)]);
    %--------------------------------------------------------------------------

    sp = 0; % This is for E
    f1001=figure(1001);
    set(gcf,'position',[x0,y0,xx1/2,yy1*2])
    subplot(3,1,1)
    dump = Ek_term1_dt.*(k_bins.^(sp));
    loglog(k_bins,dump,'--',color=My_colors(1,:),LineWidth=lwm)
    hold on
    dump = Ek_term2_dt.*(k_bins.^(sp));
    loglog(k_bins,dump,'--',color=My_colors(2,:),LineWidth=lwm)
    dump = Ek_term3_dt.*(k_bins.^(sp));
    loglog(k_bins,dump,'--',color=My_colors(3,:),LineWidth=lwm)
    dump = Ek_term4_dt.*(k_bins.^(sp));
    loglog(k_bins,dump,'--',color=My_colors(4,:),LineWidth=lwm)
    dump = Ek_term5_dt.*(k_bins.^(sp));
    loglog(k_bins,dump,'--',color=My_colors(5,:),LineWidth=lwm)
    dump = Ek_term7_dt.*(k_bins.^(sp));
    loglog(k_bins,dump,'--',color=My_colors(6,:),LineWidth=lwm)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    %ax.XLabel.String = '$kd_i$';
    %ax.YLabel.String = '$k^{5/3} P1D_{x}$';
    ax.YLabel.String = '$P1D_{x}$';

    %ylim([10^(-),10^(8)])
    yline(1*10^9,'--')
    xline(2,'--')
    xline(5,'-')

    xlim([min(k_bins),threshold])
    %xlim([0.5,threshold])

    %ylim([10^(3),10^(14)])

    ax.YTick = [10^5, 10^10];
    ax.XTick = [10^0, 10^1];

    % x2 = log10([0.5 15]); y2 = x2.*(-8/3) + 9.7;
    % loglog(10.^x2, 10.^y2,'-',color=My_colors(1,:),LineWidth=1.5);
    % x2 = log10([0.5 15]); y2 = x2.*(-11/3) + 9;
    % loglog(10.^x2, 10.^y2,'-',color=My_colors(2,:),LineWidth=1.5);
    % x2 = log10([0.5 15]); y2 = x2.*(-5/3) + 10;
    % loglog(10.^x2, 10.^y2,'-',color=My_colors(3,:),LineWidth=1.5);
    % txt1 = '$$ k^{-8/3}$$';
    % txt2 = '$$ k^{-11/3}$$';
    % txt3 = '$$ k^{-5/3}$$';
    % text(10 , 10^10,txt1,'Interpreter','latex','FontSize',0.7*fs);
    % text(6 , 10^6,txt2,'Interpreter','latex','FontSize',0.7*fs);
    % text(6 , 10^13,txt3,'Interpreter','latex','FontSize',0.7*fs)

    % legend( '$E$', '$u \times B$',...
    %     '$\frac{m^{*}J \times B}{m_{e}ne}$',...
    %     '$-\frac{\nabla \cdot P}{ne}$', ...
    %     '$\frac{m^{*}\nabla \cdot (uJ + Ju - JJ/ne) + \nabla^{2}E/\mu_{0}}{ne^{2}}$',...
    %     '$RHS$',...
    %     '$\overline{E}$', '$-\overline{u} \times \overline{B}$',...
    %     'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    % %ylim([-0.045,0.045])
    set(gca,'FontSize',fs)
    hold off


    subplot(3,1,2)
    dump = Ek_term1_filt.*(k_bins.^(sp));
    loglog(k_bins,dump,'-',color=My_colors(1,:),LineWidth=1.5)
    hold on
    dump = Ek_term2_filt.*(k_bins.^(sp));
    loglog(k_bins,dump,'-',color=My_colors(2,:),LineWidth=1.5)
    dump = Ek_term3_filt.*(k_bins.^(sp));
    loglog(k_bins,dump,'-',color=My_colors(3,:),LineWidth=1.5)
    dump = Ek_term4_filt.*(k_bins.^(sp));
    loglog(k_bins,dump,'-',color=My_colors(4,:),LineWidth=1.5)
    dump = Ek_term5_filt.*(k_bins.^(sp));
    loglog(k_bins,dump,'-',color=My_colors(5,:),LineWidth=1.5)
    dump = Ek_term7_filt.*(k_bins.^(sp));
    loglog(k_bins,dump,'-',color=My_colors(6,:),LineWidth=1.5)

    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    %ax.XLabel.String = '$kd_i$';
    %ax.YLabel.String = '$k^{5/3} P1D_{x}$';
    ax.YLabel.String = '$P1D_{x}$';
    xlim([min(k_bins),threshold])
    ylim([10^(2),10^(14)])
    %ax.YTick = [10^5, 10^10];
    ax.XTick = [10^0, 10^1];
    xline(5,'--')
    %yline(1*10^4,'--')

    % legend('$\overline{E}$', ...
    %     '$-\overline{u} \times \overline{B}$',...
    %     '$\frac{m^{*}\overline{J} \times \overline{B}}{m_{e}\overline{n}e}$',...
    %     '$-\frac{\nabla \cdot \overline{P}}{\overline{n}e}$', ...
    %     '$\frac{m^{*}[\nabla \cdot (\overline{u}\overline{J} + \overline{J}\overline{u} - \overline{J}\overline{J}/ne) + \nabla^{2}\overline{E}/\mu_{0}]}{\overline{n}e^{2}}$',...
    %     '$\overline{RHS}$',...
    %     'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    % %ylim([-0.045,0.045])
    set(gca,'FontSize',fs)
    hold off

    subplot(3,1,3)
    dump = Ek_tau_nE_tau.*(k_bins.^(sp));
    loglog(k_bins,dump,'-.',color=My_colors(1,:),LineWidth=lwm)
    hold on
    dump = Ek_tau_v_x_B_tau.*(k_bins.^(sp));
    loglog(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=lwm)
    dump = Ek_tau_J_x_B_tau.*(k_bins.^(sp));
    loglog(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=lwm)
    dump = Ek_tau_Div_tau1.*(k_bins.^(sp));
    loglog(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=lwm)
    dump = Ek_sum_tau.*(k_bins.^(sp));
    loglog(k_bins,dump,'-.',color=My_colors(6,:),LineWidth=lwm)
    set(gca,'FontSize',fs)

    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$P1D_{x}$';
    ax.YTick = [10^5, 10^10];
    %ax.YLabel.String = '$k^{5/3} P1D_{x}$';
    %xlim([10^(0),1.1*10^(1)])
    xlim([min(k_bins),threshold])
    %ylim([10^(-5),10^(8)])
    %ylim([10^(2),10^(14)])
    ax.XTick = [10^0, 10^1];

    %ylim([-0.6,0.3])
    % legend('$-\tau_{nE}$', ...
    %     '$-\tau_{nu \times B}$', ...
    %     '$\tau_{J \times B}$',...
    %     '$\tau_{\nabla \cdot(uJ+Ju-JJ/ne)}$',...
    %     '$\Sigma \tau$',...
    %     'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    hold off

else


    fs=20;
    threshold = sqrt(beta_i)*pi/resx; % This is including the beta for rho

    [Ek_term1_dt,~]=Omni1DSpectra(term1_dt,Lx,threshold);
    [Ek_term2_dt,~]=Omni1DSpectra(term2_dt,Lx,threshold);
    [Ek_term3_dt,~]=Omni1DSpectra(term3_dt,Lx,threshold);
    [Ek_term4_dt,~]=Omni1DSpectra(term4_dt,Lx,threshold);
    [Ek_term5_dt,~]=Omni1DSpectra(term5_dt + 0.*term6_dt,Lx,threshold);
    term7_dt = - term2_dt + term3_dt - term4_dt + term5_dt + 0.*term6_dt;
    [Ek_term7_dt,~]=Omni1DSpectra(term7_dt,Lx,threshold);

    [Ek_term1_filt,~]=Omni1DSpectra(term1_filt,Lx,threshold);
    [Ek_term2_filt,~]=Omni1DSpectra(term2_filt,Lx,threshold);
    [Ek_term3_filt,~]=Omni1DSpectra(term3_filt,Lx,threshold);
    [Ek_term4_filt,~]=Omni1DSpectra(term4_filt,Lx,threshold);
    [Ek_term5_filt,~]=Omni1DSpectra(term5_filt+0.*term6_filt,Lx,threshold);
    term7_filt = - term2_filt + term3_filt - term4_filt + term5_filt + 0.*term6_filt;
    [Ek_term7_filt,~]=Omni1DSpectra(term7_filt,Lx,threshold);

    [Ek_tau_nE_tau,~]=Omni1DSpectra(tau_nE_tau,Lx,threshold);
    [Ek_tau_v_x_B_tau,~]=Omni1DSpectra(tau_v_x_B_tau,Lx,threshold);
    [Ek_tau_J_x_B_tau,~]=Omni1DSpectra(tau_J_x_B_tau,Lx,threshold);
    [Ek_tau_Div_tau1,~]=Omni1DSpectra(tau_Div_tau1,Lx,threshold);

    sum_tau = -tau_nE_tau -tau_v_x_B_tau + tau_J_x_B_tau + tau_Div_tau1;
    [Ek_sum_tau,k_bins]=Omni1DSpectra(sum_tau,Lx,threshold);


    % This is in terms of rho
    f1002=figure(1002)
    set(gcf,'position',[x0,y0,xx1,yy1])
    subplot(3,1,1)
    dump = Ek_term1_dt.*((sqrt(beta_i)*k_bins).^(sp));
    loglog(sqrt(beta_i)*k_bins,dump,'--',color=My_colors(1,:),LineWidth=1.5)
    hold on
    dump = Ek_term2_dt.*((sqrt(beta_i)*k_bins).^(sp));
    loglog(sqrt(beta_i)*k_bins,dump,'--',color=My_colors(2,:),LineWidth=1.5)
    dump = Ek_term3_dt.*((sqrt(beta_i)*k_bins).^(sp));
    loglog(sqrt(beta_i)*k_bins,dump,'--',color=My_colors(3,:),LineWidth=1.5)
    dump = Ek_term4_dt.*((sqrt(beta_i)*k_bins).^(sp));
    loglog(sqrt(beta_i)*k_bins,dump,'--',color=My_colors(4,:),LineWidth=1.5)
    dump = Ek_term5_dt.*((sqrt(beta_i)*k_bins).^(sp));
    loglog(sqrt(beta_i)*k_bins,dump,'--',color=My_colors(5,:),LineWidth=1.5)
    dump = Ek_term7_dt.*((sqrt(beta_i)*k_bins).^(sp));
    loglog(sqrt(beta_i)*k_bins,dump,'--',color=My_colors(6,:),LineWidth=1.5)

    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$k\rho_i$';
    ax.YLabel.String = '$k^{5/3} P1D_{x}$';

    %xlim([min(sqrt(beta_i)*k_bins),threshold])
    %ylim([10^(2),10^(14)])
    %yline(4*10^12,'--')

    xlim([0.1,threshold])
    ylim([10^(2),10^(15)])

    legend( '$E$', ...
        '$u \times B$',...
        '$\frac{m^{*}J \times B}{m_{e}ne}$',...
        '$-\frac{\nabla \cdot P}{ne}$', ...
        '$\frac{m^{*}\nabla \cdot (uJ + Ju - JJ/ne) + \nabla^{2}E/\mu_{0}}{ne^{2}}$',...
        '$RHS$',...
        'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    %ylim([-0.045,0.045])
    hold off


    subplot(3,1,2)
    dump = Ek_term1_filt.*((sqrt(beta_i)*k_bins).^(sp));
    loglog(sqrt(beta_i)*k_bins,dump,'-',color=My_colors(1,:),LineWidth=1.5)
    hold on
    dump = Ek_term2_filt.*((sqrt(beta_i)*k_bins).^(sp));
    loglog(sqrt(beta_i)*k_bins,dump,'-',color=My_colors(2,:),LineWidth=1.5)
    dump = Ek_term3_filt.*((sqrt(beta_i)*k_bins).^(sp));
    loglog(sqrt(beta_i)*k_bins,dump,'-',color=My_colors(3,:),LineWidth=1.5)
    dump = Ek_term4_filt.*((sqrt(beta_i)*k_bins).^(sp));
    loglog(sqrt(beta_i)*k_bins,dump,'-',color=My_colors(4,:),LineWidth=1.5)
    dump = Ek_term5_filt.*((sqrt(beta_i)*k_bins).^(sp));
    loglog(sqrt(beta_i)*k_bins,dump,'-',color=My_colors(5,:),LineWidth=1.5)
    dump = Ek_term7_filt.*((sqrt(beta_i)*k_bins).^(sp));
    loglog(sqrt(beta_i)*k_bins,dump,'-',color=My_colors(6,:),LineWidth=1.5)
    set(gca,'FontSize',fs)

    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$k\rho_i$';
    ax.YLabel.String = '$k^{5/3} P1D_{x}$';
    %xlim([10^(0),1.1*10^(1)])
    %xlim([min(sqrt(beta_i)*k_bins),threshold])
    %ylim([10^(0),10^(14)])

    xlim([0.1,threshold])
    ylim([10^(2),10^(15)])

    %ylim([-0.6,0.3])
    legend( '$\overline{E}$', ...
        '$-\overline{u} \times \overline{B}$',...
        '$\frac{m^{*}\overline{J} \times \overline{B}}{m_{e}\overline{n}e}$',...
        '$-\frac{\nabla \cdot \overline{P}_{e}}{\overline{n}e}$', ...
        '$\frac{m^{*}\nabla \cdot (\overline{u}\overline{J} + \overline{J}\overline{u} - \overline{J}\overline{J}/ne) + \nabla^{2}E/\mu_{0}}{\overline{n}e^{2}}$',...
        '$\overline{RHS}$',...
        'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    hold off

    subplot(3,1,3)
    dump = Ek_tau_nE_tau.*((sqrt(beta_i)*k_bins).^(sp));
    hold on
    loglog(sqrt(beta_i)*k_bins,dump,'-.',color=My_colors(1,:),LineWidth=1.5)
    dump = Ek_tau_v_x_B_tau.*((sqrt(beta_i)*k_bins).^(sp));
    loglog(sqrt(beta_i)*k_bins,dump,'-.',color=My_colors(2,:),LineWidth=1.5)
    dump = Ek_tau_J_x_B_tau.*((sqrt(beta_i)*k_bins).^(sp));
    loglog(sqrt(beta_i)*k_bins,dump,'-.',color=My_colors(3,:),LineWidth=1.5)
    dump = Ek_tau_Div_tau1.*((sqrt(beta_i)*k_bins).^(sp));
    loglog(sqrt(beta_i)*k_bins,dump,'-.',color=My_colors(5,:),LineWidth=1.5)
    dump = Ek_sum_tau.*((sqrt(beta_i)*k_bins).^(sp));
    loglog(sqrt(beta_i)*k_bins,dump,'-.',color=My_colors(6,:),LineWidth=1.5)
    set(gca,'FontSize',fs)

    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$k\rho_i$';
    ax.YLabel.String = '$k^{5/3} P1D_{x}$';
    %xlim([10^(0),1.1*10^(1)])
    %xlim([min(sqrt(beta_i)*k_bins),threshold])
    %ylim([10^(0),10^(14)])

    xlim([0.1,threshold])
    ylim([10^(2),10^(15)])

    %ylim([-0.6,0.3])
    legend('$-\tau_{nE}$', ...
        '$-\tau_{nu \times B}$', ...
        '$\tau_{J \times B}$',...
        '$\tau_{\nabla \cdot(uJ+Ju-JJ/ne)}$',...
        '$\Sigma \tau$',...
        'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    hold off

end

%cd('~/Downloads')
%saveas(f1001,strcat(num2str(component),'spectrum_E_taus_1D_2.png'));



% This is the part to compute the contribution bar(uxB) = bar(u) x bar(B) + tau

f1003=figure(1003)
subplot(2,1,1)
set(gcf,'position',[x0,y0,xx1,yy1])
dump = Ek_term1_dt;
loglog(k_bins,dump,'--',color=My_colors(2,:),LineWidth=1.5)
hold on
%dump = spectra.P1Dper;
%loglog(spectra.kper,dump,'--r',LineWidth=1.5)
dump = Ek_tau_v_x_B_tau.*(k_bins.^(sp));
loglog(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=lwm)
dump = Ek_term2_filt.*(k_bins).^(sp) + Ek_tau_v_x_B_tau.*(k_bins.^(sp));
loglog(k_bins,dump,'*',color=My_colors(2,:),LineWidth=lwm)
ylim([10^0, 10^15]);
xlim([10^-1, 10^2]);
hold off
subplot(2,1,2)
fgcon = Ek_term2_filt.*conj(Ek_tau_v_x_B_tau);
%dump = atan (abs( imag(fgcon)./real(fgcon))); % This is not working
%becasue the spectrum is returning the abs value and not the full complex
%number
dump = Ek_tau_v_x_B_tau./Ek_term2_filt;
loglog(k_bins,dump,'--',color=My_colors(2,:),LineWidth=1.5)

dump = Ek_term3_filt.*((sqrt(beta_i)*k_bins).^(sp));
loglog(sqrt(beta_i)*k_bins,dump,'-',color=My_colors(3,:),LineWidth=1.5)
dump = Ek_term4_filt.*((sqrt(beta_i)*k_bins).^(sp));
loglog(sqrt(beta_i)*k_bins,dump,'-',color=My_colors(4,:),LineWidth=1.5)
dump = Ek_term5_filt.*((sqrt(beta_i)*k_bins).^(sp));
loglog(sqrt(beta_i)*k_bins,dump,'-',color=My_colors(5,:),LineWidth=1.5)
dump = Ek_term7_filt.*((sqrt(beta_i)*k_bins).^(sp));
loglog(sqrt(beta_i)*k_bins,dump,'-',color=My_colors(6,:),LineWidth=1.5)



f1004=figure(1004);
dump = Ek_tau_v_x_B_tau./Ek_term2_filt;
loglog(sqrt(beta_i)*k_bins,dump,'-.',color=My_colors(2,:),LineWidth=1.5)
hold on
dump = Ek_tau_J_x_B_tau./Ek_term3_filt;
loglog(sqrt(beta_i)*k_bins,dump,'-.',color=My_colors(3,:),LineWidth=1.5)
dump = Ek_tau_Div_tau1./Ek_term5_filt;
loglog(sqrt(beta_i)*k_bins,dump,'-.',color=My_colors(5,:),LineWidth=1.5)
dump = Ek_sum_tau./Ek_term7_filt;
loglog(sqrt(beta_i)*k_bins,dump,'-.',color=My_colors(6,:),LineWidth=1.5)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$k\rho_i$';
%ax.YLabel.String = '$Ratio \ P1D_{x}$';
%xlim([10^(0),1.1*10^(1)])
%xlim([min(sqrt(beta_i)*k_bins),threshold])
%ylim([10^(0),10^(14)])

%xlim([0.1,threshold])
ax.XTick = [10^0, 10^1];
%ylim([10^(2),10^(15)])

%ylim([-0.6,0.3])
legend('$\tau_{nu \times B}/\overline{u} \times \overline{B}$', ...
    '$\tau_{J \times B}/\frac{m^{*}\overline{J} \times \overline{B}}{m_{e}\overline{n}e}$',...
    '$\tau_{\nabla \cdot(uJ+Ju-JJ/ne)}/\frac{m^{*}\nabla \cdot (\overline{u}\overline{J} + \overline{J}\overline{u} - \overline{J}\overline{J}/ne) + \nabla^{2}E/\mu_{0}}{\overline{n}e^{2}}$',...
    '$\Sigma \tau/\overline{RHS}$',...
    'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
hold off


[phase_diff_uxB,~] = Phase_difference(term2_filt,tau_v_x_B_tau,Lx,threshold);
[phase_diff_JxB,~] = Phase_difference(term3_filt,tau_J_x_B_tau,Lx,threshold);
[phase_diff_div,~] = Phase_difference(term5_filt,tau_Div_tau1,Lx,threshold);
[phase_diff_sumtau,k_bins] = Phase_difference(term7_filt,sum_tau,Lx,threshold);


f1005=figure(1005);
subplot(2,1,1)
dump = Ek_tau_v_x_B_tau./Ek_term2_filt;
loglog(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
hold on
dump = Ek_tau_J_x_B_tau./Ek_term3_filt;
loglog(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=4)
dump = Ek_tau_Div_tau1./Ek_term5_filt;
loglog(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=2)
dump = Ek_sum_tau./Ek_term7_filt;
loglog(k_bins,dump,'-.',color=My_colors(6,:),LineWidth=2)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$kd_i$';
%ax.YLabel.String = '$Ratio \ P1D_{x}$';
%xlim([10^(0),1.1*10^(1)])
%xlim([min(sqrt(beta_i)*k_bins),threshold])
ylim([10^(-5),10^(15)])
xlim([0.3,threshold])
ax.XTick = [10^0, 10^1];
ax.YTick = [10^0, 10^10];
%ylim([10^(2),10^(15)])
%ylim([-0.6,0.3])
legend('$\tau_{nu \times B}/\overline{u} \times \overline{B}$', ...
    '$\tau_{J \times B}/\frac{m^{*}\overline{J} \times \overline{B}}{m_{e}\overline{n}e}$',...
    '$\tau_{\nabla \cdot(uJ+Ju-JJ/ne)}/\frac{m^{*}\nabla \cdot (\overline{u}\overline{J} + \overline{J}\overline{u} - \overline{J}\overline{J}/ne) + \nabla^{2}E/\mu_{0}}{\overline{n}e^{2}}$',...
    '$\Sigma \tau/\overline{RHS}$',...
    'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
title('$\Delta_{l} = 0.14 d_{i}$','Interpreter','latex')
hold off

subplot(2,1,2)
dump = phase_diff_uxB;
semilogx(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
hold on
dump = phase_diff_JxB;
semilogx(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
dump = phase_diff_div;
semilogx(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=2)
dump = phase_diff_sumtau;
semilogx(k_bins,dump,'-.',color=My_colors(6,:),LineWidth=2)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$kd_i$';
ax.YLabel.String = '$\Delta \phi^{\circ}$';
%xlim([10^(0),1.1*10^(1)])
%xlim([min(sqrt(beta_i)*k_bins),threshold])
%ylim([10^(0),10^(14)])
xlim([0.3,threshold])
ax.XTick = [10^0, 10^1];
ax.YTick = [0, 90, 180];
yline(135,'--')
yline(90,'--')
ylim([0,180])
%ylim([-0.6,0.3])
legend('$\tau_{nu \times B}/\overline{u} \times \overline{B}$', ...
    '$\tau_{J \times B}/\frac{m^{*}\overline{J} \times \overline{B}}{m_{e}\overline{n}e}$',...
    '$\tau_{\nabla \cdot(uJ+Ju-JJ/ne)}/\frac{m^{*}\nabla \cdot (\overline{u}\overline{J} + \overline{J}\overline{u} - \overline{J}\overline{J}/ne) + \nabla^{2}E/\mu_{0}}{\overline{n}e^{2}}$',...
    '$\Sigma \tau/\overline{RHS}$',...
    'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
%title('$\Delta_{l} = 0.59 d_{i}$','Interpreter','latex')
hold off


% % assume n, E are 64^3 arrays, Lx=Ly=Lz=2*pi
% [kc, gamma] = OmniCoherence(n, E, Lx, Ly, Lz, kmax);
% loglog(kc, gamma); ylim([0 1.05]);
% xlabel('k'); ylabel('Coherence \gamma(k)');
% title('Omnidirectional coherence between n and E');



% %--------------------------------------------------------------------------
% disp('Computing 2D and 1D spectra...')
% [kpar,kper,P2D]=Compute2Dspectrum(resx,resy,resz,term1_dt,term1_dt,term1_dt);
% [P1Dper,P1Dpar]=Compute1DSpectra(P2D,kper,threshold);
% spectra.kpar=kpar; spectra.kper=kper; %spectra.Nkper=Nkper;
% spectra.P2D=P2D; spectra.P1Dpar=P1Dpar; spectra.P1Dper=P1Dper;
% f1007=figure(1007)
% subplot(2,1,1)
%     dump = spectra.P1Dper;
%     loglog(spectra.kper,dump,'--',color=My_colors(2,:),LineWidth=1.5)
% %--------------------------------------------------------------------------



function [E_k,k_bins]=Omni1DSpectra(Bx_dt,Lx,threshold)
% Detrend the variable
Bx_dt_DT = Bx_dt - mean(Bx_dt,'all');
% Perform the FFT of the 3D field B
F_B = fftn(Bx_dt_DT);
Ns=size(Bx_dt);
% Compute the wavenumbers
kx = (2*pi/Lx) * [0:(Ns(1)/2-1) -Ns(1)/2:-1];
ky = kx;
kz = kx;
[KX, KY, KZ] = meshgrid(kx, ky, kz);
% Calculate the radial wavenumber k
K = sqrt(KX.^2 + KY.^2 + KZ.^2);
% Calculate the energy spectrum
energy = abs(F_B).^2;
% Define the bins for the radial wavenumber
dk = 2 * pi / Lx; % Bin width in k-space
k_max = threshold;%max(K(:)); % Maximum wavenumber
k_bins = 0:dk:k_max; % Radial wavenumber bins
% Initialize the omnidirectional spectrum
E_k = zeros(size(k_bins));
% Bin the energy into the radial wavenumber bins
for i = 1:length(k_bins)-1
    k_min = k_bins(i);
    k_max = k_bins(i+1);
    % Find the indices of the Fourier modes that fall within the current bin
    indices = (K >= k_min) & (K < k_max);
    % Sum the energy of these modes
    E_k(i) = sum(energy(indices));
end

% Normalize the spectrum by the bin width
E_k = E_k / dk;

% % Plot the omnidirectional spectrum
% figure;
% loglog(k_bins(1:end-1), E_k(1:end-1), 'LineWidth', 1.5);
% title('1D Omnidirectional Spectrum');
% xlabel('k');
% ylabel('E(k)');
end

function [E_k,k_bins]=Omni1DSpectra3c(Bx_dt,By_dt,Bz_dt,Lx,threshold)
% Detrend the variable
Bx_dt_DT = Bx_dt - mean(Bx_dt,'all');
By_dt_DT = By_dt - mean(By_dt,'all');
Bz_dt_DT = Bz_dt - mean(Bz_dt,'all');

% Perform the FFT of the 3D field B
F_Bx = fftn(Bx_dt_DT);
F_By = fftn(By_dt_DT);
F_Bz = fftn(Bz_dt_DT);

Ns=size(Bx_dt);
% Compute the wavenumbers
kx = (2*pi/Lx) * [0:(Ns(1)/2-1) -Ns(1)/2:-1];
ky = kx;
kz = kx;
[KX, KY, KZ] = meshgrid(kx, ky, kz);
% Calculate the radial wavenumber k
K = sqrt(KX.^2 + KY.^2 + KZ.^2);
% Calculate the energy spectrum
energy = (abs(F_Bx).^2 + abs(F_By).^2 + abs(F_Bz).^2) / (prod(Ns)^2);
% Define the bins for the radial wavenumber
dk = 2 * pi / Lx; % Bin width in k-space
k_max = threshold;%max(K(:)); % Maximum wavenumber
k_bins = 0:dk:k_max; % Radial wavenumber bins
% Initialize the omnidirectional spectrum
E_k = zeros(size(k_bins));
% Bin the energy into the radial wavenumber bins
for i = 1:length(k_bins)-1
    k_min = k_bins(i);
    k_max = k_bins(i+1);
    % Find the indices of the Fourier modes that fall within the current bin
    indices = (K >= k_min) & (K < k_max);
    % Sum the energy of these modes
    E_k(i) = sum(energy(indices));
end

% Normalize the spectrum by the bin width
E_k = E_k / dk;

% % Plot the omnidirectional spectrum
% figure;
% loglog(k_bins(1:end-1), E_k(1:end-1), 'LineWidth', 1.5);
% title('1D Omnidirectional Spectrum');
% xlabel('k');
% ylabel('E(k)');
end

%--------------------------------------------------------------------------
%uxB = AA; %term2_filt_x;
%tauuxB = BB; %tau_v_x_B_tau_x;


function [E_k,k_bins]=Phase_difference3D(uxB_x,uxB_y,uxB_z,tauuxB_x,tauuxB_y,tauuxB_z,Lx,threshold)
% Detrend the variable
Bx_dt_DT_x = uxB_x - mean(uxB_x,'all');
Bx_dt_DT_y = uxB_y - mean(uxB_y,'all');
Bx_dt_DT_z = uxB_z - mean(uxB_z,'all');

Bx_dt_DT2_x = tauuxB_x - mean(tauuxB_x,'all');
Bx_dt_DT2_y = tauuxB_y - mean(tauuxB_y,'all');
Bx_dt_DT2_z = tauuxB_z - mean(tauuxB_z,'all');

% Perform the FFT of the 3D field B
F_B_x = fftn(Bx_dt_DT_x);
F_B_y = fftn(Bx_dt_DT_y);
F_B_z = fftn(Bx_dt_DT_z);

F_B2_x = fftn(Bx_dt_DT2_x);
F_B2_y = fftn(Bx_dt_DT2_y);
F_B2_z = fftn(Bx_dt_DT2_z);

fgcon = F_B_x.*conj(F_B2_x) + F_B_y.*conj(F_B2_y) + F_B_z.*conj(F_B2_z);

%%% --- Phase differences in Fourier space ---
phi1 = atan2(imag(fgcon), real(fgcon));
phi1 = rad2deg(phi1);

Ns=size(uxB_x);
% Compute the wavenumbers
kx = (2*pi/Lx) * [0:(Ns(1)/2-1) -Ns(1)/2:-1];
ky = kx;
kz = kx;
[KX, KY, KZ] = meshgrid(kx, ky, kz);
% Calculate the radial wavenumber k
K = sqrt(KX.^2 + KY.^2 + KZ.^2);

%% --- Omnidirectional averaging (simple linear mean of abs phase) ---
%kx = fftshift(-N/2:N/2-1);
%[KY,KX,KZ] = meshgrid(kx,kx,kx);
kr = round(sqrt(KX.^2 + KY.^2 + KZ.^2));
kmax = floor(Ns(1)/2)+1;
spec_phi1 = zeros(kmax,1);

% Define the bins for the radial wavenumber
dk = 2 * pi / Lx; % Bin width in k-space
k_max = threshold;%max(K(:)); % Maximum wavenumber
k_bins = 0:dk:k_max; % Radial wavenumber bins
% Initialize the omnidirectional spectrum

for k = 1:kmax
    mask = (kr == k);
    if any(mask(:))
        % use mean of absolute phase difference magnitude
        spec_phi1(k) = mean(abs(phi1(mask)));
    end
end

E_k = spec_phi1;

end


function [E_k,k_bins]=Phase_difference(uxB,tauuxB,Lx,threshold)
% Detrend the variable
Bx_dt_DT = uxB - mean(uxB,'all');
Bx_dt_DT2 = tauuxB - mean(tauuxB,'all');

% Perform the FFT of the 3D field B
F_B = fftn(Bx_dt_DT);
F_B2 = fftn(Bx_dt_DT2);
fgcon = F_B.*conj(F_B2);
phi1 = atan2(imag(fgcon), real(fgcon));
phi1 = rad2deg(phi1);

%%% --- Phase differences in Fourier space ---
%phi1 = angle(F_B2) - angle(F_B);
% wrap to [-pi, pi]
%phi1 = atan2(sin(phi1), cos(phi1));
%phi1 = rad2deg(phi1);

Ns=size(uxB);
% Compute the wavenumbers
kx = (2*pi/Lx) * [0:(Ns(1)/2-1) -Ns(1)/2:-1];
ky = kx;
kz = kx;
[KX, KY, KZ] = meshgrid(kx, ky, kz);
% Calculate the radial wavenumber k
K = sqrt(KX.^2 + KY.^2 + KZ.^2);

%% --- Omnidirectional averaging (simple linear mean of abs phase) ---
%kx = fftshift(-N/2:N/2-1);
%[KY,KX,KZ] = meshgrid(kx,kx,kx);
kr = round(sqrt(KX.^2 + KY.^2 + KZ.^2));
kmax = floor(Ns(1)/2)+1;
spec_phi1 = zeros(kmax,1);

% Define the bins for the radial wavenumber
dk = 2 * pi / Lx; % Bin width in k-space
k_max = threshold;%max(K(:)); % Maximum wavenumber
k_bins = 0:dk:k_max; % Radial wavenumber bins
% Initialize the omnidirectional spectrum

for k = 1:kmax
    mask = (kr == k);
    if any(mask(:))
        % use mean of absolute phase difference magnitude
        spec_phi1(k) = mean(abs(phi1(mask)));
    end
end

E_k = spec_phi1;

% % Plot the omnidirectional spectrum
% figure;
% loglog(k_bins(1:end-1), E_k(1:end-1), 'LineWidth', 1.5);
% title('1D Omnidirectional Spectrum');
% xlabel('k');
% ylabel('E(k)');

%{
% Calculate the energy spectrum
phasediff = atan (abs( imag(fgcon)./real(fgcon))); %removin
phasediff = rad2deg(phasediff);
% Define the bins for the radial wavenumber
dk = 2 * pi / Lx; % Bin width in k-space
k_max = threshold;%max(K(:)); % Maximum wavenumber
k_bins = 0:dk:k_max; % Radial wavenumber bins
% Initialize the omnidirectional spectrum
E_k = zeros(size(k_bins));
% Bin the energy into the radial wavenumber bins
for i = 1:length(k_bins)-1
    k_min = k_bins(i);
    k_max = k_bins(i+1);
    % Find the indices of the Fourier modes that fall within the current bin
    indices = (K >= k_min) & (K < k_max);
    % Sum the energy of these modes
    E_k(i) = mean(phasediff(indices));
end
% Normalize the spectrum by the bin width
E_k = E_k / dk;
%}

end
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
function  [phaseSpectrum,kvals] = Phase_difference_no(A,B,Lx,threshold)
%A=sum_tau;
%B = gradient(sum_tau);
assert(all(size(A) == size(B)), 'A and B must be same size');
[Nx,Ny,Nz] = size(A);
%%% === Fourier Transform ===
Ahat = fftshift(fftn(A));
Bhat = fftshift(fftn(B));
%%% === Compute Phase Difference ===
% Avoid divide-by-zero
eps = 1e-12;
phaseA = angle(Ahat + eps);
phaseB = angle(Bhat + eps);
phaseDiff = angle(exp(1i*(phaseB - phaseA))); % wrapped to [-pi,pi]
%%% === Wavenumber Axes ===
kx = (-Nx/2:Nx/2-1);
ky = (-Ny/2:Ny/2-1);
kz = (-Nz/2:Nz/2-1);
[KX,KY,KZ] = ndgrid(kx,ky,kz);
Kmag = sqrt(KX.^2 + KY.^2 + KZ.^2);
kmax = floor(min([Nx Ny Nz])/2);
kbins = 0:kmax;
%%% === Bin average to get omnidirectional spectrum ===
phaseSpectrum = zeros(1,length(kbins)-1);
count = zeros(1,length(kbins)-1);
for i = 1:length(kbins)-1
    mask = (Kmag >= kbins(i) & Kmag < kbins(i+1));
    values = phaseDiff(mask);
    %phaseSpectrum(i) = mean(values(:)); % circular mean? see note below
    phaseSpectrum(i) = angle(mean(exp(1i*values(:))));
    count(i) = sum(mask(:));
end
kvals = kbins(1:end-1);
%%% === Plot ===
% figure;
% semilogx(kvals, phaseSpectrum, 'LineWidth',2)
% xlabel('|k| (radial mode)')
% ylabel('Phase difference (rad)')
% title('Omnidirectional Phase Difference Spectrum')
% %grid on
% ylim([-pi pi])
end
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
function [kpar,kper,P2D,Nkper]=Compute2Dspectrum(resx,resy,resz,var1,var2,var3)
%Compute the 2D power swpectrum of variables 'var1', 'var2' & 'var3'.

dx=resx; %Fraction of d_i
dy=resy;
dz=resz;

N=size(var1); %all the variables has the same size
Lx=N(1)*dx; %Length of box as function of d_i
Ly=N(2)*dy;
Lz=N(3)*dz;

if nargin==4 %Calculate 3D Fourier transform of each variable (narging return the number of inputs of a function)
    [ff,kx,ky,kz]=Four3D(var1,Lx,Ly,Lz);
    ff=ff.^2;
elseif nargin==5
    [fx,kx,ky,kz]=Four3D(var1,Lx,Ly,Lz);
    [fy,kx,ky,kz]=Four3D(var2,Lx,Ly,Lz);
    ff=fx.^2+fy.^2;
elseif nargin==6
    [fx,kx,ky,kz]=Four3D(var1,Lx,Ly,Lz); %3D transform of each component of B
    [fy,kx,ky,kz]=Four3D(var2,Lx,Ly,Lz);
    [fz,kx,ky,kz]=Four3D(var3,Lx,Ly,Lz);
    ff=fx.^2+fy.^2+fz.^2; %Trace
end

P3D=ff./(N(1)*N(2)*N(3)); %Normalise by 1/Nx*Ny*Nz  %Second normalization? jeff

for j=1:size(ff,2)
    for i=1:size(ff,1)
        %--------------------------------------------------------------------------
        %kp(i,j)=sqrt(ky(j).^2+kx(i).^2); %Calculate kperp array with negative wavenumbers
        %--------------------------------------------------------------------------
        kp(i,j)=sqrt(ky(j).^2); %This is for the case of the 2D harris
        %configuration
        %--------------------------------------------------------------------------
    end
end

for k=1:size(ff,3)
    kp2(k)=abs(kz(k)); %Calculate kpar vector with negative wavenumbers
end

%Calculate kpar and kperp for 2D spectrum:
dkpar=kz(2)-kz(1);
nkpar=fix(max(max(kz)/dkpar))+1;
kpar=(0:nkpar-1).*dkpar;

%dkper=kx(2)-kx(1);
%nkper=fix(max(max(kp)/dkper))+1;
%kper=(0:nkper-1).*dkper;

dkper=ky(2)-ky(1);
nkper=fix(max(max(kp)/dkper))+1;
kper=(0:nkper-1).*dkper;

%Use linear interpolation to intergrate in concentric circles of k_perp:

%Initialise arrays:
Ptemp=zeros(size(ff,3),nkper); %old kper vs. new kper
P2D=zeros(nkpar,nkper); %kpar vs. kper

Nkper=zeros(size(ff,3),nkper);

i1=fix(kp/dkper); %Index linking kp with each kper value. Index of the cells
i2=i1+1; % indexes of next cells
i3=fix(kp2/dkpar); %Index linking kp2 with each kpar value

k2=kp/dkper-i1; % this is calculating basically the residuo. kp is a matrix
k1=1-k2;

for k= 1:size(P3D,3) %For each value of kpar, integrate over rings of kper
    P1=k1.*P3D(:,:,k); %For interpolation
    P2=k2.*P3D(:,:,k);
    for j=1:size(P3D,2) %Cycle through every grid point in x-y plane
        for i=1:size(P3D,1)
            if(i2(i,j) < nkper)
                %Use linear interpolation to sum up power to surrounding
                %rings of kper:
                Ptemp(k,i2(i,j)+1)=Ptemp(k,i2(i,j)+1)+P2(i,j); %Interpolate power to next ring
                Ptemp(k,i1(i,j)+1)=Ptemp(k,i1(i,j)+1)+P1(i,j); %Interpolate power to previous ring

                %Update number of points interpolated for each ring:
                Nkper(i2(i,j)+1)=Nkper(i2(i,j)+1)+k2(i,j);
                Nkper(i1(i,j)+1)=Nkper(i1(i,j)+1)+k1(i,j);
            end
        end
    end
    if i3(k)<nkpar
        P2D(i3(k)+1,:)=P2D(i3(k)+1,:)+Ptemp(k,:); %Fill array with kper values for each kpar
    end
end

%[kpJ, kp2J]=meshgrid(kper,kpar);
%disp(string(size(kpJ)))
%disp(string(size(kp2J)))
%disp(string(size(P2D)))
%disp(string(kper(2)))
%P2D=P2D./kper(2);
%P2D=P2D./(kpJ.*kpJ); %Normalise // P2D=P2D./(kper(2)*kpar(2)); Is this correct?
% it is dividing by a single value of kper
%disp(string(size(P2D)))
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
function [ft,kx,ky,kz]=Four3D(var,Lx,Ly,Lz)
%Calculates 3D spatial Fourier transfrom of variable 'var', shifted so
%that the centre is the zero k. xx/yy/zz are Lx, Ly and Lz.

var=var-mean(mean(mean((var)))); %Detrend mean

N=size(var); %N=[Nx,Ny,Nz]

f=abs(fftn(var))*sqrt(N(1)*N(2)*N(3)); %Take abs value and normalise
%^Should it be fftn instead of ifftn?

ft=fftshift(f); %Shift ft to centre wavenumber

kx=((0:N(1)-1)-N(1)/2).*2*pi/Lx; %Includes negative wavenumbers
ky=((0:N(2)-1)-N(2)/2).*2*pi/Ly;
kz=((0:N(3)-1)-N(3)/2).*2*pi/Lz;

end
%--------------------------------------------------------------------------


% for each kper set a threshold
function [P1Dper,P1Dpar]=Compute1DSpectra(P2D,kper,threshold)
%Calculate parallel and perpendicular 1D sepctra from the 2D spectrum.
[c1,index1]=min(abs(kper-threshold)); %Cut spectrum above a threshold k

[c,index]=min(abs(kper-threshold)); %Cut spectrum above a threshold k
Pthres=P2D(2,index);
mask2D=P2D>Pthres;
fieldMASKED=P2D.*mask2D;
P1Dper=sum(fieldMASKED,1); %Sum over parallel k
P1Dpar=sum(fieldMASKED,2); %Sum over perpendicular k
end



%
% function [k_centers, coh] = OmniCoherence(n, E, Lx, Ly, Lz, kmax)
% % OmniCoherence Omnidirectional coherence between 3D fields n and E
% %
% % Inputs:
% % n, E : 3D real arrays (same size)
% % Lx,Ly,Lz: domain lengths (same units as coordinate space)
% % kmax : maximum k to include (optional). If [], uses Nyquist.
% %
% % Outputs:
% % k_centers : bin center values (length Nbins-1)
% % coh : coherence gamma(k) (same length as k_centers)
% %
% % Notes:
% % - Uses shell sums (no extra normalization needed for ratio).
% % - If you want gamma^2, square the returned coh.
% if nargin<6 || isempty(kmax)
% % use min Nyquist
% Nx = size(n,1); Ny = size(n,2); Nz = size(n,3);
% dkx = 2*pi/Lx; dky = 2*pi/Ly; dkz = 2*pi/Lz;
% kmax = min([pi/dkx, pi/dky, pi/dkz]); % conservative
% end
% Ns = size(n);
% % Fourier transforms
% Ntot = prod(Ns);
% N1=Ns(1); N2=Ns(2); N3=Ns(3);
% N = Ns;
% % construct k vectors (consistent with fftn ordering)
% kx = (2*pi/Lx) * [0:(N1/2-1) -N1/2:-1];
% ky = (2*pi/Ly) * [0:(N2/2-1) -N2/2:-1];
% kz = (2*pi/Lz) * [0:(N3/2-1) -N3/2:-1];
% [KX, KY, KZ] = ndgrid(kx, ky, kz);
% K = sqrt(KX.^2 + KY.^2 + KZ.^2);
% Nn = fftn(n);
% NE = fftn(E);
% % cross-spectrum (complex) and autos
% cross_spec_3D = Nn .* conj(NE); % note: complex
% nn_spec_3D = abs(Nn).^2;
% EE_spec_3D = abs(NE).^2;
% % radial bins
% dk = 2*pi / max([Lx,Ly,Lz]); % choose bin width (can be tuned)
% k_bins = 0:dk:kmax;
% Nbins = length(k_bins)-1;
% S_ne = zeros(1,Nbins);
% S_nn = zeros(1,Nbins);
% S_EE = zeros(1,Nbins);
% k_centers = zeros(1,Nbins);
% for i=1:Nbins
% kmin = k_bins(i);
% kmaxb = k_bins(i+1);
% mask = (K >= kmin) & (K < kmaxb);
% if ~any(mask,'all')
% S_ne(i) = 0;
% S_nn(i) = 0;
% S_EE(i) = 0;
% else
% S_ne(i) = sum(cross_spec_3D(mask),'all'); % complex sum
% S_nn(i) = sum(nn_spec_3D(mask),'all');
% S_EE(i) = sum(EE_spec_3D(mask),'all');
% end
% k_centers(i) = 0.5*(kmin + kmaxb);
% end
% % coherence (magnitude)
% coh = zeros(size(S_ne));
% idx = (S_nn>0) & (S_EE>0);
% coh(idx) = abs(S_ne(idx)) ./ sqrt( S_nn(idx) .* S_EE(idx) );
% % ensure numerical bounds [0,1]
% coh = min(max(real(coh),0),1);
% end
%
%
% function [E_k, k_bins] = Omni1DSpectra(Bx_dt, Lx, threshold)
% Ly = Lx;
% Lz = Lx;
% % Remove mean
% Bx_dt_DT = Bx_dt - mean(Bx_dt, 'all');
% % FFT of the 3D field
% F_B = fftn(Bx_dt_DT);
% Ns = size(Bx_dt);
% % Wavenumber grids
% kx = (2*pi/Lx) * [0:(Ns(1)/2-1) -Ns(1)/2:-1];
% ky = (2*pi/Ly) * [0:(Ns(2)/2-1) -Ns(2)/2:-1];
% kz = (2*pi/Lz) * [0:(Ns(3)/2-1) -Ns(3)/2:-1];
% [KX, KY, KZ] = ndgrid(kx, ky, kz);
% % Radial wavenumber
% K = sqrt(KX.^2 + KY.^2 + KZ.^2);
% % Energy spectrum (Parseval normalization)
% energy = abs(F_B).^2 / prod(Ns);
% % Radial bins
% dk = 2 * pi / Lx; % works if cubic box, otherwise choose min spacing
% k_bins = 0:dk:threshold;
% % Omnidirectional spectrum
% E_k = zeros(size(k_bins));
% for i = 1:length(k_bins)-1
% k_min = k_bins(i);
% k_max = k_bins(i+1);
% indices = (K >= k_min) & (K < k_max);
% E_k(i) = sum(energy(indices));
% end
% % Normalize by bin width
% E_k = E_k / dk;
% end



