
x=linspace(1,10,100);

y = x;

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

% This is in terms of rho
    f1002=figure(1002)
    %set(gcf,'position',[x0,y0,xx1,yy1])
    subplot(3,1,1)
    loglog(x,y,'--',color=My_colors(1,:),LineWidth=1.5)
    hold on
    loglog(x,y,'--',color=My_colors(2,:),LineWidth=1.5)
    loglog(x,y,'--',color=My_colors(3,:),LineWidth=1.5)
    loglog(x,y,'--',color=My_colors(4,:),LineWidth=1.5)
    loglog(x,y,'--',color=My_colors(5,:),LineWidth=1.5)
    loglog(x,y,'--',color=My_colors(6,:),LineWidth=1.5)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$k\rho_i$';
    ax.YLabel.String = '$k^{5/3} P1D_{x}$';
    ylim([10^(2),10^(15)])

    legend( '$E$', ...
        '$u_{i} \times B$',...
        '$\frac{J \times B}{ne}$',...
        '$-\frac{\nabla \cdot P_{e}}{ne}$', ...
        '$\frac{m_{e}[\nabla \cdot (u_{i}J + Ju_{i} - JJ/ne) + \nabla^{2}E/\mu_{0}]}{ne^{2}}$',...
        '$RHS$',...
        'Interpreter','latex','NumColumns',1,'Location','southoutside')
    %ylim([-0.045,0.045])
    hold off


    subplot(3,1,2)
    loglog(x,y,'-',color=My_colors(1,:),LineWidth=1.5)
    hold on
    loglog(x,y,'-',color=My_colors(2,:),LineWidth=1.5)
    loglog(x,y,'-',color=My_colors(3,:),LineWidth=1.5)
    loglog(x,y,'-',color=My_colors(4,:),LineWidth=1.5)
    loglog(x,y,'-',color=My_colors(5,:),LineWidth=1.5)
    loglog(x,y,'-',color=My_colors(6,:),LineWidth=1.5)
    set(gca,'FontSize',fs)

    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$k\rho_i$';
    ax.YLabel.String = '$k^{5/3} P1D_{x}$';

    %ylim([-0.6,0.3])
    legend( '$\overline{E}$', ...
        '$-\overline{u_{i}} \times \overline{B}$',...
        '$\frac{\overline{J} \times \overline{B}}{\overline{n}e}$',...
        '$-\frac{\nabla \cdot \overline{P}_{e}}{\overline{n}e}$', ...
        '$\frac{m_{e}[\nabla \cdot (\overline{u_{i}}\overline{J} + \overline{J}\overline{u_{i}} - \overline{J}\overline{J}/ne) + \nabla^{2}\overline{E}/\mu_{0}]}{\overline{n}e^{2}}$',...
        '$\overline{RHS}$',...
        'Interpreter','latex','NumColumns',1,'Location','southoutside')
    hold off

    subplot(3,1,3)
    loglog(x,y,'-.',color=My_colors(1,:),LineWidth=1.5)
    hold on
    loglog(x,y,'-.',color=My_colors(2,:),LineWidth=1.5)
    loglog(x,y,'-.',color=My_colors(3,:),LineWidth=1.5)
    loglog(x,y,'-.',color=My_colors(5,:),LineWidth=1.5)
    loglog(x,y,'-.',color=My_colors(6,:),LineWidth=1.5)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$k\rho_i$';
    ax.YLabel.String = '$k^{5/3} P1D_{x}$';


    %ylim([-0.6,0.3])
    legend('$-\tau_{nE}$', ...
        '$-\tau_{nu_{i} \times B}$', ...
        '$\tau_{J \times B}$',...
        '$\tau_{\nabla \cdot(u_{i}J+Ju_{i}-JJ/ne)}$',...
        '$\Sigma \tau$',...
        'Interpreter','latex','NumColumns',1,'Location','southoutside')
    hold off



    fs = 25

    f1003=figure(1003)
    %set(gcf,'position',[x0,y0,xx1,yy1])
    subplot(3,1,1)
    loglog(x,y,'-.',color=My_colors(2,:),LineWidth=1.5)
    hold on
    loglog(x,y,'-.',color=My_colors(3,:),LineWidth=1.5)
    loglog(x,y,'-.',color=My_colors(5,:),LineWidth=1.5)
    loglog(x,y,'-.',color=My_colors(6,:),LineWidth=1.5)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$\langle \overline{E} \rangle_{rms} / \langle \overline{u_{i}} \times \overline{B} \rangle_{rms}$';
    ax.XLabel.String = '$k^{5/3} P1D_{x}$';

    legend( '$\tau_{nu_{i} \times B} / \overline{u_{i}} \times \overline{B}$',...
        '$\tau_{J \times B} / \frac{\overline{J} \times \overline{B}}{\overline{n}e}$',...
        '$\tau_{\nabla \cdot(u_{i}J+Ju_{i}-JJ/ne)} / \frac{m_{e}[\nabla \cdot (\overline{u_{i}}\overline{J} + \overline{J}\overline{u_{i}} - \overline{J}\overline{J}/ne) + \nabla^{2}\overline{E}/\mu_{0}]}{\overline{n}e^{2}}$',...
        '$\Sigma \tau / \overline{RHS}$',...
        'Interpreter','latex','NumColumns',1,'Location','southoutside')

    hold off


    subplot(3,1,2)
    
    loglog(x,y,'-',color=My_colors(1,:),LineWidth=1.5)
    hold on
    loglog(x,y,'-',color=My_colors(2,:),LineWidth=1.5)
    loglog(x,y,'-',color=My_colors(3,:),LineWidth=1.5)
    loglog(x,y,'-',color=My_colors(4,:),LineWidth=1.5)    
    loglog(x,y,'-',color=My_colors(5,:),LineWidth=1.5)
    loglog(x,y,'-',color=My_colors(6,:),LineWidth=1.5)

    loglog(x,y,'-.',color=My_colors(1,:),LineWidth=1.5)
    loglog(x,y,'-.',color=My_colors(2,:),LineWidth=1.5)
    loglog(x,y,'-.',color=My_colors(3,:),LineWidth=1.5)   
    loglog(x,y,'-.',color=My_colors(5,:),LineWidth=1.5)
    loglog(x,y,'-.',color=My_colors(6,:),LineWidth=1.5)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$k\rho_i$';
    ax.YLabel.String = '$k^{5/3} P1D_{x}$';

    legend('$\langle \overline{E} \rangle_{rms}$', ...
           '$\langle \overline{u_{i}} \times \overline{B} \rangle_{rms}$',...
           '$\langle \overline{J} \times \overline{B} / \overline{n}e \rangle_{rms}$',...
           '$\langle \nabla \cdot \overline{P_{e}}/\overline{n}e\rangle_{rms}$', ...
           '$\langle m_{e}[\nabla \cdot (\overline{u}_{i}\overline{J} + \overline{J}\overline{u}_{i} - \overline{J}\overline{J}/\overline{n}e) + \nabla^{2}\overline{E}/\mu_{0}]/ \overline{n}e^{2}\rangle_{rms}$',...
           '$\langle RHS \rangle_{rms}$',...
           '$10 \langle \tau_{nE} \rangle_{rms} $',...
           '$10 \langle \tau_{nu_{i} \times B} \rangle_{rms} $',...
           '$10 \langle \tau_{J \times B} \rangle_{rms} $',...
           '$10 \langle \tau_{\nabla \cdot(u_{i}J+Ju_{i}-JJ/ne)} \rangle_{rms}$',...
           '$10 \langle \Sigma \tau \rangle_{rms}$',...           
        'Interpreter','latex','NumColumns',1,'Location','southoutside')

    hold off


        




    f3=figure(3)
    subplot(1,3,1)
    loglog(x,0*y,'-.',color=My_colors(1,:),LineWidth=1.5)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    xline(3,'--k',LineWidth=1.2)
    ax.XLabel.String = '$k\rho_i$';
    ax.YLabel.String = '$k^{5/3} P1D_{x}$';
    title('$\Sigma \tau_{x} / \max(\Sigma \tau_{x})$','Interpreter','latex',FontSize=fs)
    subplot(1,3,2)
    loglog(x,y,'-.',color=My_colors(1,:),LineWidth=1.5)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$k\rho_i$';
    ax.YLabel.String = '$k^{5/3} P1D_{x}$';
    title('$\Sigma \tau_{M1,x} / \max(\Sigma \tau_{M1,x})$','Interpreter','latex',FontSize=fs)
    subplot(1,3,3)
    loglog(x,y,'-.',color=My_colors(1,:),LineWidth=1.5)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$k\rho_i$';
    ax.YLabel.String = '$k^{5/3} P1D_{x}$';
    title('$\Sigma \tau_{M2,x} / \max(\Sigma \tau_{M2,x})$','Interpreter','latex',FontSize=fs)    


    %ylim([-0.6,0.3])
    legend('$-\tau_{nE}$', ...
        '$-\tau_{nu_{i} \times B}$', ...
        '$\tau_{J \times B}$',...
        '$\tau_{\nabla \cdot(u_{i}J+Ju_{i}-JJ/ne)}$',...
        '$\Sigma \tau$',...
        'Interpreter','latex','NumColumns',1,'Location','southoutside')
    hold off
