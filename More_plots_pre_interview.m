% this are the plots reducing the caxis accordingly

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% This is the one of the kinetic energy terms for electrons. 
%--------------------------------------------------------------------------
x0=-1759;y0=258;width=1574;height=458; fs=25;
f19=figure(19);
set(gcf,'position',[x0,y0,width,height])
%--------------------------------------------------------------------------
h1=subaxis(1,5,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
%dum_p=dtKe_Gp{1,1} + ve_grad_Ke_Gp{1,1}; %dtKe_Gp This is the wrong one!
dum_p = dtKe_in_Gp_2{1,1} + ve_grad_Ke_Gp{1,1};
dum_p=(dum_p)./(Pi0);  
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%caxis([-1.1 1.1]); hcb.Ticks = linspace(-2,2,5); hcb.TickLabels = [-2,-1,0,1,2] ;  
hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ; caxis([-0.05 0.05]);
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{d\varepsilon^{k}_{e}/dt}{\Delta\varepsilon_{0}} $','Interpreter','latex','FontSize',1.3*fs);
%rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
%yline(9,'--k','LineWidth',2)
%yline(5,'--k','LineWidth',2)
%xline(xll(xpc_i),'--k','LineWidth',2)
xline(5.58,'--k','LineWidth',2)
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,5,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=ve_Div_Pet_Gp{1,1};
dum_p=(dum_p)./(Pi0);   
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
%hcb.Ticks = linspace(-7,7,5); hcb.TickLabels = [-7,-3,0,3,7] ; caxis([-8 8]); 
%hcb.Ticks = linspace(-0.5,0.5,5); hcb.TickLabels = [-0.5,-0.3,0,0.3,0.5] ; caxis([-0.6 0.6]); 
hcb.Ticks = linspace(-0.2,0.2,5); hcb.TickLabels = [-0.2,-0.1,0,0.1,0.2] ; caxis([-0.23 0.23]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\mathbf{u}_{e} \cdot \nabla \cdot \overline{\mathbf{P}}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
%rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,5,3,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=Ke_Div_ve_Gp{1,1};
dum_p=(dum_p)./(Pi0); 
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ; caxis([-0.05 0.05]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
%rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
title('$\frac{\varepsilon^{k}_{e} \nabla \cdot \mathbf{u}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
hold off
%--------------------------------------------------------------------------
h4=subaxis(1,5,4,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=-qe_ne_ve_E_Gp{1,1};
dum_p=(dum_p)./(Pi0);  
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h4,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
%hcb.Ticks = linspace(-0.5,0.5,5); hcb.TickLabels = [-0.5,-0.3,0,0.3,0.5] ; caxis([-0.6 0.6]); 
hcb.Ticks = linspace(-0.2,0.2,5); hcb.TickLabels = [-0.2,-0.1,0,0.1,0.2] ; caxis([-0.23 0.23]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
%rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
title('$\frac{-q_{e}n_{e}\mathbf{u}_{e} \cdot \mathbf{E}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
hold off
%--------------------------------------------------------------------------
h5=subaxis(1,5,5,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_pXIe=dtKe_in_Gp_2{1,1} + ve_grad_Ke_Gp{1,1} + ve_Div_Pet_Gp{1,1} + Ke_Div_ve_Gp{1,1} -qe_ne_ve_E_Gp{1,1};    
dum_p=(dum_pXIe)./(Pi0); 
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h5,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
%hcb.Ticks = linspace(-1.2,1.2,5); hcb.TickLabels = [-1.2,-0.6,0,0.6,1.2] ; caxis([-1.3 1.3]); 
hcb.Ticks = linspace(-0.2,0.2,5); hcb.TickLabels = [-0.2,-0.1,0,0.1,0.2] ; caxis([-0.23 0.23]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
%rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
title('$\frac{\Xi^{k}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
hold off
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------


% This is the one of the kinetic energy terms for ions. 
%--------------------------------------------------------------------------
f20=figure(20);
set(gcf,'position',[x0,y0,width,height])
%--------------------------------------------------------------------------
h1=subaxis(1,5,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=dtKi_in_Gp_2{1,1} + vi_grad_Ki_Gp{1,1};
dum_p=(dum_p)./(Pi0);  
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%caxis([-1.7 1.7]); hcb.Ticks = linspace(-1.5,1.5,5); hcb.TickLabels = [-1.5,-1,0,1,1.5] ; 
hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ; caxis([-0.06 0.06]); 
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{d\varepsilon^{k}_{i}/dt}{\Delta\varepsilon_{0}} $','Interpreter','latex','FontSize',1.3*fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,5,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=vi_Div_Pit_Gp{1,1};
dum_p=(dum_p)./(Pi0);  
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
%hcb.Ticks = linspace(-5,5,5); hcb.TickLabels = [-5,-3,0,3,5] ; caxis([-6 6]); 
%hcb.Ticks = linspace(-3,3,5); hcb.TickLabels = [-3,-1.5,0,1.5,3] ; caxis([-4 4]); 
hcb.Ticks = linspace(-0.1,0.1,5); hcb.TickLabels = [-0.1,-0.05,0,0.05,0.1] ; caxis([-0.12 0.12]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\mathbf{u}_{i} \cdot \nabla \cdot \overline{\mathbf{P}}_{i}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,5,3,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=Ki_Div_vi_Gp{1,1};
dum_p=(dum_p)./(Pi0);  
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ; caxis([-0.06 0.06]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\varepsilon^{k}_{i} \nabla \cdot \mathbf{u}_{i}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h4=subaxis(1,5,4,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p= - qi_ni_vi_E_Gp{1,1};
dum_p=(dum_p)./(Pi0); 
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h4,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.1,0.1,5); hcb.TickLabels = [-0.1,-0.05,0,0.05,0.1] ; caxis([-0.12 0.12]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{-q_{i}n_{i}\mathbf{u}_{i} \cdot \mathbf{E}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h5=subaxis(1,5,5,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_pXIi=dtKi_in_Gp_2{1,1} + vi_grad_Ki_Gp{1,1} + vi_Div_Pit_Gp{1,1} + Ki_Div_vi_Gp{1,1} -qi_ni_vi_E_Gp{1,1};    
dum_p=(dum_pXIi)./(Pi0); 
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h5,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.5,0.5,5); hcb.TickLabels = [-0.5,-0.3,0,0.3,0.5] ; caxis([-0.6 0.6]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\Xi^{k}_{i}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% This is the one of the thermal energy terms for electrons. 
%--------------------------------------------------------------------------
f21=figure(21);
set(gcf,'position',[x0,y0,width,height])
%--------------------------------------------------------------------------
h1=subaxis(1,5,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=dtUe_in_Gp_2{1,1} + ve_grad_Ue_Gp{1,1}; 
dum_p=(dum_p)./(Pi0); 
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%caxis([-15 15]); hcb.Ticks = linspace(-14,14,5); hcb.TickLabels = [-14,-7,0,7,14] ;  
caxis([-0.5 0.5]); hcb.Ticks = linspace(-0.4,0.4,5); hcb.TickLabels = [-0.4,-0.2,0,0.2,0.4] ;  
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{d\varepsilon^{th}_{e}/dt}{\Delta\varepsilon_{0}} $','Interpreter','latex','FontSize',1.3*fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
xline(5.58,'--k','LineWidth',2)
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,5,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=dkQiik_05_e_Gp{1,1};
dum_p=(dum_p)./(Pi0); 
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ; caxis([-0.06 0.06]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\nabla \cdot \mathbf{h}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,5,3,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=Pet_grad_ve_Gp{1,1};
dum_p=(dum_p)./(Pi0);
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-1.4,1.4,5); hcb.TickLabels = [-1.4,-0.7,0,0.7,1.4] ; caxis([-1.5 1.5]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\nabla \mathbf{u}_{e} : \overline{\mathbf{P}}_{e}}{{\Delta\varepsilon_{0}}}$','Interpreter','latex','FontSize',1.3*fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h4=subaxis(1,5,4,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=Ue_Div_ve_Gp{1,1}; 
dum_p=(dum_p)./(Pi0);  
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h4,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-1.4,1.4,5); hcb.TickLabels = [-1.4,-0.7,0,0.7,1.4] ; caxis([-1.5 1.5]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\varepsilon^{th}_{e} \nabla \cdot \mathbf{u}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h5=subaxis(1,5,5,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_pXI2e=dtUe_in_Gp_2{1,1} + ve_grad_Ue_Gp{1,1} + dkQiik_05_e_Gp{1,1} + Pet_grad_ve_Gp{1,1} +...
    Ue_Div_ve_Gp{1,1} ;%+ dum_pXIe;    
dum_p=(dum_pXI2e)./(Pi0);  
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h5,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-1.4,1.4,5); hcb.TickLabels = [-1.4,-0.7,0,0.7,1.4] ; caxis([-1.5 1.5]); 
%hcb.Ticks = linspace(-3.0,3.0,5); hcb.TickLabels = [-3.0,-1.5,0,1.5,3.0] ; caxis([-3.0 3.0]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\Xi^{th}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------

% This is the one of the thermal energy terms for ions. 
%--------------------------------------------------------------------------
f22=figure(22);
set(gcf,'position',[x0,y0,width,height])
%--------------------------------------------------------------------------
h1=subaxis(1,5,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=dtUi_in_Gp_2{1,1} + vi_grad_Ui_Gp{1,1};
dum_p=(dum_p)./(Pi0);  
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%caxis([-5 5]); hcb.Ticks = linspace(-4,4,5); hcb.TickLabels = [-4,-2,0,2,4] ;  
caxis([-0.08 0.08]); hcb.Ticks = linspace(-0.07,0.07,5); hcb.TickLabels = [-0.07,-0.03,0,0.03,0.07] ;  
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{d\varepsilon^{th}_{i}/dt}{\Delta\varepsilon_{0}} $','Interpreter','latex','FontSize',1.3*fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,5,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=dkQiik_05_i_Gp{1,1};
dum_p=(dum_p)./(Pi0); 
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
%caxis([-0.08 0.08]); hcb.Ticks = linspace(-0.07,0.07,5); hcb.TickLabels = [-0.07,-0.03,0,0.03,0.07] ;  
hcb.Ticks = linspace(-0.02,0.02,5); hcb.TickLabels = [-0.02,-0.01,0,0.01,0.02] ; caxis([-0.02 0.02]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\nabla \cdot \mathbf{h}_{i}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,5,3,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=Pit_grad_vi_Gp{1,1}; 
dum_p=(dum_p)./(Pi0);
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
%hcb.Ticks = linspace(-8,8,5); hcb.TickLabels = [-8,-4,0,4,8] ; caxis([-9 9]);  
%hcb.Ticks = linspace(-4,4,5); hcb.TickLabels = [-4,-2,0,2,4] ; caxis([-5 5]);
caxis([-0.3 0.3]); hcb.Ticks = linspace(-0.2,0.2,5); hcb.TickLabels = [-0.2,-0.1,0,0.1,0.2] ;  
%caxis([-0.08 0.08]); hcb.Ticks = linspace(-0.07,0.07,5); hcb.TickLabels = [-0.07,-0.03,0,0.03,0.07] ;  
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\nabla \mathbf{u}_{i} : \overline{\mathbf{P}}_{i}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h4=subaxis(1,5,4,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=Ui_Div_vi_Gp{1,1}; 
dum_p=(dum_p)./(Pi0);    
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h4,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
%hcb.Ticks = linspace(-8,8,5); hcb.TickLabels = [-8,-4,0,4,8] ; caxis([-9 9]); 
%hcb.Ticks = linspace(-4,4,5); hcb.TickLabels = [-4,-2,0,2,4] ; caxis([-5 5]);
caxis([-0.3 0.3]); hcb.Ticks = linspace(-0.2,0.2,5); hcb.TickLabels = [-0.2,-0.1,0,0.1,0.2] ;  
%caxis([-0.08 0.08]); hcb.Ticks = linspace(-0.07,0.07,5); hcb.TickLabels = [-0.07,-0.03,0,0.03,0.07] ;  
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\varepsilon^{th}_{i} \nabla \cdot \mathbf{u}_{i}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h5=subaxis(1,5,5,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_pXI2i=dtUi_in_Gp_2{1,1} + vi_grad_Ui_Gp{1,1} + dkQiik_05_i_Gp{1,1} + Pit_grad_vi_Gp{1,1} +...
    Ui_Div_vi_Gp{1,1};% + dum_pXIi;    
dum_p=(dum_pXI2i)./(Pi0); 
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h5,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
%hcb.Ticks = linspace(-20,20,5); hcb.TickLabels = [-20,-10,0,10,20] ; caxis([-22 22]); % for the unfiltered
%hcb.Ticks = linspace(-1.0,1.0,5); hcb.TickLabels = [-1.0,-0.5,0,0.5,1.0] ; caxis([-1.2 1.2]); % for the unfiltered
hcb.Ticks = linspace(-0.5,0.5,5); hcb.TickLabels = [-0.5,-0.3,0,0.3,0.5] ; caxis([-0.6 0.6]); 
%caxis([-0.08 0.08]); hcb.Ticks = linspace(-0.07,0.07,5); hcb.TickLabels = [-0.07,-0.03,0,0.03,0.07] ;  
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\Xi^{th}_{i}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------





%This is another important part to check the values of the enrgy terms so I
%can make myself an idea of what the variation means.

% Calculate the energy values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


Ki_dum = 0.5.*ni_Gp{1,1}.* mi.*(vi_Gp{1,1}.*vi_Gp{1,1} + vi_Gp{1,2}.*vi_Gp{1,2} + vi_Gp{1,3}.*vi_Gp{1,3});
Ke_dum = 0.5.*ne_Gp{1,1}.* me.*(ve_Gp{1,1}.*ve_Gp{1,1} + ve_Gp{1,2}.*ve_Gp{1,2} + ve_Gp{1,3}.*vi_Gp{1,3});
%------------------------------------------------------------------

% Internal energy densities from Fadanelli et al, 2020 
%------------------------------------------------------------------
Ui_dum = 0.5.*(Pij_i_Gp{1,1} + Pij_i_Gp{2,2} + Pij_i_Gp{3,3});
Ue_dum = 0.5.*(Pij_e_Gp{1,1} + Pij_e_Gp{2,2} + Pij_e_Gp{3,3});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pa=2; pb=98;
f423=figure(423);
h4=subplot(2,2,1);
dum_p=Ke_dum; dum_p=(dum_p)./(Pi0); 
dum_p = filloutliers(dum_p, NaN, 'percentiles', [pa pb]);
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
%colormap(h4,map_r); 
colormap(h4,jet); 
colorbar; caxis([0 0.05]);
set(hc,'edgecolor','none'); title('Ke')
hold off
h4=subplot(2,2,2);
dum_p=Ki_dum; dum_p=(dum_p)./(Pi0); 
dum_p = filloutliers(dum_p, NaN, 'percentiles', [pa pb]);
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
%colormap(h4,map_r); 
colormap(h4,jet); 
colorbar; caxis([0 0.5]);
set(hc,'edgecolor','none'); title('Ki')
hold off
h4=subplot(2,2,3);
dum_p=Ue_dum; dum_p=(dum_p)./(Pi0); 
dum_p = filloutliers(dum_p, NaN, 'percentiles', [pa pb]);
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
%colormap(h4,map_r); 
colormap(h4,jet); 
colorbar;
set(hc,'edgecolor','none'); title('Ue')
hold off
h4=subplot(2,2,4);
dum_p=Ui_dum; dum_p=(dum_p)./(Pi0); 
dum_p = filloutliers(dum_p, NaN, 'percentiles', [pa pb]);
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
%colormap(h4,map_r); 
colormap(h4,jet); 
colorbar; 
set(hc,'edgecolor','none'); title('Ui')
hold off

f424=figure(424);
subplot(2,2,1)
histogram(sqrt(ve_Gp{1,1}.^2 + ve_Gp{1,2}.^2 + ve_Gp{1,2}.^2))
subplot(2,2,2)
histogram(sqrt(vi_Gp{1,1}.^2 + vi_Gp{1,2}.^2 + vi_Gp{1,2}.^2))
subplot(2,2,3)
histogram(Ue_dum)
subplot(2,2,4)
histogram(Ui_dum)

f425=figure(425);
dum_p=sqrt(ve_Gp{1,1}.^2 + ve_Gp{1,2}.^2 + ve_Gp{1,2}.^2);
dum_p=dum_p.*(dum_p<1); hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
colormap(h4,map_r); colorbar;
set(hc,'edgecolor','none'); title('ve')
hold off

dum_p=Ki_dum;
dum_p=(dum_p)./(Pi0);    
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h4,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
colormap(h1,map_r); 
%caxis([-0.3 0.3]); hcb.Ticks = linspace(-0.2,0.2,5); hcb.TickLabels = [-0.2,-0.1,0,0.1,0.2] ;  
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\varepsilon^{th}_{i} \nabla \cdot \mathbf{u}_{i}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off




% this was just to check 3d scatter plots. However, the colormap works very
% well to plot with a variable

%Scatter plot
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
ypc_i=127;
xpc_i = 93;
sr=squeeze(xll);
rng default
nval = numel(sr);
cmin = xll(1);
cmax = xll(end);
c = cmin + (cmax-cmin)*rand(1,nval);

dum_px = ve_Gp{1,1}./VA2c; dum_px1=dum_px(ypc_i,:);
dum_py = ve_Gp{1,2}./VA2c; dum_py1=dum_py(ypc_i,:);
dum_pz = ve_Gp{1,3}./VA2c; dum_pz1=dum_pz(ypc_i,:);


f546=figure(546);
h = scatter3(dum_px1,dum_py1,dum_pz1,'filled','MarkerEdgeColor','k');
%axis equal; 
box on; %%%set(gca, 'colormap', c)
h.CData = c;
colormap(BWR); 
cb=colorbar();
%cb.Ticks = [xll(xpc_i)];
xlabel('v_{p,e} / v_{A,i}')
ylabel('v_{a,e} / v_{A,i}')
zlabel('v_{r,e} / v_{A,i}')
view(40,35)


f546=figure(546);
scatter(xll,dum_px1,'s','MarkerEdgeColor','r');
hold on; %%%set(gca, 'colormap', c)
scatter(xll,dum_py1,'o','MarkerEdgeColor','k');
scatter(xll,dum_pz1,'p','MarkerEdgeColor','b');
hold off


% Checking that the terms are not repeated
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
pa = 1;
pb = 99;
f320=figure(320);
h5=subplot(3,2,1);
dum_p=dtUe_in_Gp_2{1,1} + ve_grad_Ue_Gp{1,1}; dum_p=(dum_p)./(Pi0);  
%dum_p = filloutliers(dum_p,'previous'); % rmoutliers(dum_p); dum_p = filloutliers(dum_p,'previous','mean');
dum_p = medfilt2(dum_p,filtvec);
dum_p = filloutliers(dum_p, 'previous', 'percentiles', [pa pb]);
mean1=mean(dum_p,'all'); std1=std2(dum_p);
hc=pcolor(dum_p); set(hc,'edgecolor','none') 
ymax=max(max(abs(dum_p)));
caxis([-ymax ymax]); 
%caxis([-2 2]); 
txt1 = num2str(mean1); text(0,1000,txt1);
txt2 = num2str(std1); text(0,100,txt2);
title('dU/dt')
colormap(h5,BWR);
hcb=colorbar; %hcb.Location = 'northoutside';

h5=subplot(3,2,2);
dum_p=dkQiik_05_e_Gp{1,1}; dum_p=(dum_p)./(Pi0);
%dum_p = filloutliers(dum_p,'previous'); % rmoutliers(dum_p); 
dum_p = medfilt2(dum_p,filtvec);
dum_p = filloutliers(dum_p, 'previous', 'percentiles', [pa pb]);
ymax=max(max(abs(dum_p)));
mean1=mean(dum_p,'all'); std1=std2(dum_p);
hc=pcolor(dum_p); set(hc,'edgecolor','none') 
caxis([-ymax ymax]); colorbar
txt1 = num2str(mean1); text(0,1000,txt1);
txt2 = num2str(std1); text(0,100,txt2);
title('dQ')
colormap(h5,BWR);
hcb=colorbar; %hcb.Location = 'northoutside';

h5=subplot(3,2,3);
dum_p=Pet_grad_ve_Gp{1,1}; dum_p=(dum_p)./(Pi0);
%dum_p = filloutliers(dum_p,'previous'); % rmoutliers(dum_p); 
dum_p = medfilt2(dum_p,filtvec);
dum_p3 = filloutliers(dum_p, 'previous', 'percentiles', [pa pb]);
hc=pcolor(dum_p3); set(hc,'edgecolor','none') 
ymax=max(max(abs(dum_p)));
caxis([-ymax ymax]); 
mean1=mean(dum_p3,'all'); std1=std2(dum_p3);
txt1 = num2str(mean1); text(0,1000,txt1);
txt2 = num2str(std1); text(0,100,txt2);
title('Pgu')
colormap(h5,BWR);
hcb=colorbar; %hcb.Location = 'northoutside';

h5=subplot(3,2,4);
dum_p=Ue_Div_ve_Gp{1,1}; dum_p=(dum_p)./(Pi0);  
%dum_p = filloutliers(dum_p,'previous'); % rmoutliers(dum_p);
dum_p = medfilt2(dum_p,filtvec);
dum_p4 = filloutliers(dum_p, 'previous', 'percentiles', [pa pb]);
hc=pcolor(dum_p4); set(hc,'edgecolor','none') 
ymax=max(max(abs(dum_p4)));
caxis([-ymax ymax]);
mean1=mean(dum_p4,'all'); std1=std2(dum_p4);
txt1 = num2str(mean1); text(0,1000,txt1);
txt2 = num2str(std1); text(0,100,txt2);
title('Udivu')
colormap(h5,BWR);
hcb=colorbar; %hcb.Location = 'northoutside';


f319=figure(319);
h5=subplot(1,1,1);
dum_p = dum_p3 - dum_p4;
hc=pcolor(dum_p); set(hc,'edgecolor','none') 
ymax=max(max(abs(dum_p)));
caxis([-0.3*ymax 0.3*ymax]); 
%caxis([-2 2]); 
mean1=mean(dum_p,'all'); std1=std2(dum_p);
txt1 = num2str(mean1); text(0,1000,txt1);
txt2 = num2str(std1); text(0,100,txt2);
title('Pgu-Udivu')
colormap(h5,BWR);
hcb=colorbar;% hcb.Location = 'northoutside';

h5=subplot(3,2,6);
dum_p=Ue_Div_ve_Gp{1,1}; dum_p=(dum_p)./(Pi0);  
%dum_p = filloutliers(dum_p,'previous'); % rmoutliers(dum_p);
dum_p = medfilt2(dum_p,filtvec);
dum_p = filloutliers(dum_p, NaN, 'percentiles', [pa pb]);
ymax=max(max(abs(dum_p)));
caxis([-ymax ymax]); colorbar
mean1=mean(dum_p,'all'); std1=std2(dum_p);
hc=pcolor(dum_p); set(hc,'edgecolor','none') 
txt1 = num2str(mean1); text(0,1000,txt1);
txt2 = num2str(std1); text(0,100,txt2);
title('Udivu')
colormap(h5,BWR);
hcb=colorbar; hcb.Location = 'northoutside';


f321=figure(321);
dum_p=dtUe_in_Gp_2{1,1} + ve_grad_Ue_Gp{1,1};
dum_p=(dum_p)./(Pi0); filloutliers(dum_p,'previous'); % rmoutliers(dum_p); 
subplot(2,2,1)
mean1=mean(dum_p,'all'); std1=std2(dum_p);
histogram(dum_p)
txt1 = num2str(mean1); text(0,1000,txt1);
txt2 = num2str(std1); text(0,100,txt2);
title('dU/dt')
subplot(2,2,2)
dum_p=dkQiik_05_e_Gp{1,1}; dum_p=(dum_p)./(Pi0);
filloutliers(dum_p,'previous'); % rmoutliers(dum_p); 
mean1=mean(dum_p,'all'); std1=std2(dum_p);
histogram(dum_p)
txt1 = num2str(mean1); text(0,1000,txt1);
txt2 = num2str(std1); text(0,100,txt2);
title('dQ')
subplot(2,2,3)
dum_p=Pet_grad_ve_Gp{1,1}; dum_p=(dum_p)./(Pi0);
filloutliers(dum_p,'previous'); % rmoutliers(dum_p); 
mean1=mean(dum_p,'all'); std1=std2(dum_p);
histogram(dum_p)
txt1 = num2str(mean1); text(0,1000,txt1);
txt2 = num2str(std1); text(0,100,txt2);
title('Pgu')
subplot(2,2,4)
dum_p=Ue_Div_ve_Gp{1,1}; dum_p=(dum_p)./(Pi0);  
filloutliers(dum_p,'previous'); % rmoutliers(dum_p); 
mean1=mean(dum_p,'all'); std1=std2(dum_p);
histogram(dum_p)
txt1 = num2str(mean1); text(0,1000,txt1);
txt2 = num2str(std1); text(0,100,txt2);
title('Udivu')

dum_pXI2e=dtUe_in_Gp_2{1,1} + ve_grad_Ue_Gp{1,1} + dkQiik_05_e_Gp{1,1} + ...
    Pet_grad_ve_Gp{1,1} + Ue_Div_ve_Gp{1,1} ;%+ dum_pXIe;    
dum_p=(dum_pXI2e)./(Pi0);  


subplot(1,2,1)
dum_p=(Ue_Div_ve_Gp{1,1}-Pet_grad_ve_Gp{1,1})/(Pi0);
contourf(dum_p)
colorbar
subplot(1,2,2)
histogram(dum_p)
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


cd '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here'
% This is the plot including the 3 energy transfer rates in 2D (3) and in
% 1D
%--------------------------------------------------------------------------
% This is for the filter
filtvec=[3,3]; %The unfiltered one can be seen using [1,1] 
% Proxy parameters e  
x0=-1756;y0=210;width=1384;height=484; fs=25;
f17=figure(17);
set(gcf,'position',[x0,y0,width,height])
%--------------------------------------------------------------------------
h1=subaxis(1,4,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=Zernitani_e_Gp{1,1} ;
dum_p = dum_p./(Pi0);
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
caxis([-0.12 0.12]); hcb.Ticks = linspace(-0.1,0.1,3); hcb.TickLabels = [-0.1,0,0.1] ;  
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.5, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{D_{ze}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
xline(5.58,'--k','LineWidth',2)
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,4,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=p_theta_e_Gp{1,1};  
dum_p = dum_p./(Pi0);
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
%caxis([-7 7]); hcb.Ticks = linspace(-6,6,3); hcb.TickLabels = [-6,0,6] ;
caxis([-0.5 0.5]); hcb.Ticks = linspace(-0.4,0.4,3); hcb.TickLabels = [-0.4,0,0.4] ;  
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{p\theta_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,4,3,'SV',0.1,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=PiD_e_Gp{1,1};  
dum_p = dum_p./(Pi0);
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
%caxis([-2 2]); hcb.Ticks = linspace(-1,1,3); hcb.TickLabels = [-1,0,1] ; 
caxis([-0.12 0.12]); hcb.Ticks = linspace(-0.1,0.1,3); hcb.TickLabels = [-0.1,0,0.1] ;  
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{Pi-D_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------------------
h4=subaxis(1,4,4,'SV',0.5,'SH',0.00,'MR',0.002,'ML',0.02,'PL',0.005,'PR',0.06);
plot(yll,smoothdata(Zernitani_e_Gp_1d)./(Pi0),'Color',colorblind(1,:), 'LineWidth', lw)
hold on
plot(yll,smoothdata(p_theta_e_Gp_1d)./(Pi0),'Color',colorblind(2,:), 'LineWidth', lw)
plot(yll,smoothdata(PiD_e_Gp_1d)./(Pi0),'Color',colorblind(5,:), 'LineWidth', lw)
 xline(6.6,'--k','LineWidth', lw)
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
ax.YAxisLocation = 'right';
%legend('dKe/dt','vedivPe','Kedivve','-qEe')
legend('$\frac{D_{ze}}{\Delta\varepsilon_{0}}$',...
    '$\frac{p\theta_{e}}{\Delta\varepsilon_{0}}$',...
    '$\frac{Pi-D_{e}}{\Delta\varepsilon_{0}}$',...
    'Interpreter','latex','FontSize',1.3*fs,'Location','northout','NumColumns',3)
%plot(xll,ve_2_1d)
xlabel('$p / d_{i}$','Interpreter','latex','FontSize',fs)
%title('Dissipation surrogates','Interpreter','latex','FontSize',fs)
title('Energy transfer rates','Interpreter','latex','FontSize',fs)
xlim([5,9])
ylim([-0.45, 0.45])
hold off
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)

%--------------------------------------------------------------------------



% Let's check the correlation of the different terms
%--------------------------------------------------------------------------
% Build the parameter space and create the histogram
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
pa = 2;
pb = 98;
count_l=2;
nbins=101;
stdx = 1;
%--------------------------------------------------------------------------
func1 = Pet_grad_ve_Gp{1,1}./Pi0; % This in the horizontal axis
func1 = filloutliers(func1, 'previous', 'percentiles', [pa pb]);
func2 = dkQiik_05_e_Gp{1,1}./Pi0; % This in the vertical axis
func2 = filloutliers(func2, 'previous', 'percentiles', [pa pb]);
fun1xm=max(max(abs(func1))); fun1X=linspace(-fun1xm,fun1xm,nbins);
fun2xm=max(max(abs(func2))); fun2X=linspace(-fun2xm,fun2xm,nbins);
[Nf1f2,Xf1,Xf2] = histcounts2(func1,func2,fun1X,fun2X);
Nf1f2(Nf1f2<=count_l)=(NaN);
f99 = figure(99);
hc = pcolor(Xf1(1:end-1),Xf2(1:end-1),Nf1f2);
hold on 
set(hc,'edgecolor','none'); set(gca,'ColorScale','log'); 
hcb=colorbar;
hcb.Label.String = 'Counts'; hcb.Label.Interpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';
ax.XLabel.Interpreter='latex'; ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
ax.XLabel.String = '$\frac{\nabla \mathbf{u}_{e} : \overline{\mathbf{P}}_{e}}{\Delta\varepsilon_{0}}$'; 
ax.YLabel.String = '$\frac{\nabla \cdot \mathbf{h}_{e}}{\Delta\varepsilon_{0}}$'; 
%--------------------------------------------------------
Xx=Nf1f2; 
Xxa=Xf1(1:end-1).*(isnan(Xx(1,:))); Xxa(isnan(Xxa)) = []; 
Xya=Xf2(1:end-1).*(isnan(Xx(1,:))); Xya(isnan(Xya)) = []; 
%xa = max(Xxa); ya = max(Xya);
xa = stdx*std(Xxa); ya = stdx*std(Xya); 
%xlim([-stdx*std(Xf1),stdx*std(Xf1)]); ylim([-stdx*std(Xf2),stdx*std(Xf2)]);
xlim([-xa,xa]); ylim([-ya,ya]);
%--------------------------------------------------------
hold off
%--------------------------------------------------------------------------

% The four plots in a single one for electrons
%--------------------------------------------------------------------------
f98 = figure(98);
h3=subaxis(2,2,3,'SV',0.1,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
func1 = dum_pXI2e./Pi0; % This in the horizontal axis
func1 = filloutliers(func1, 'previous', 'percentiles', [pa pb]);
func2 = Pet_grad_ve_Gp{1,1}./(Pi0); % This in the vertical axis
func2 = filloutliers(func2, 'previous', 'percentiles', [pa pb]);
fun1xm=max(max(abs(func1))); fun1X=linspace(-fun1xm,fun1xm,nbins);
fun2xm=max(max(abs(func2))); fun2X=linspace(-fun2xm,fun2xm,nbins);
[Nf1f2,Xf1,Xf2] = histcounts2(func1,func2,fun1X,fun2X);
Nf1f2(Nf1f2<=count_l)=(NaN);
colormap(h3,jet)
hc = pcolor(Xf1(1:end-1),Xf2(1:end-1),Nf1f2);
hold on 
set(hc,'edgecolor','none'); set(gca,'ColorScale','log'); 
hcb=colorbar; %hcb.Location = 'northoutside';
hcb.Label.String = 'Counts'; hcb.Label.Interpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';
ax.XLabel.Interpreter='latex'; ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
ax.XLabel.String = '$\frac{\Xi^{th}_{e}}{\Delta\varepsilon_{0}}$'; 
ax.YLabel.String = '$\frac{\nabla \mathbf{u}_{e} : \overline{\mathbf{P}}_{e}}{\Delta\varepsilon_{0}}$'; 
%--------------------------------------------------------
Xx=Nf1f2; 
Xxa=Xf1(1:end-1).*(isnan(Xx(1,:))); Xxa(isnan(Xxa)) = []; 
Xya=Xf2(1:end-1).*(isnan(Xx(1,:))); Xya(isnan(Xya)) = []; 
%xa = max(Xxa); ya = max(Xya);
xa = stdx*std(Xxa); ya = stdx*std(Xya); 
%xlim([-stdx*std(Xf1),stdx*std(Xf1)]); ylim([-stdx*std(Xf2),stdx*std(Xf2)]);
xlim([-xa,xa]); ylim([-ya,ya]);
%--------------------------------------------------------
hold off
%--------------------------------------------------------------------------
h3=subaxis(2,2,2,'SV',0.1,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
func1 = dum_pXI2e./Pi0; % This in the horizontal axis
func1 = filloutliers(func1, 'previous', 'percentiles', [pa pb]);
func2 = dkQiik_05_e_Gp{1,1}./(Pi0); % This in the vertical axis
func2 = filloutliers(func2, 'previous', 'percentiles', [pa pb]);
fun1xm=max(max(abs(func1))); fun1X=linspace(-fun1xm,fun1xm,nbins);
fun2xm=max(max(abs(func2))); fun2X=linspace(-fun2xm,fun2xm,nbins);
[Nf1f2,Xf1,Xf2] = histcounts2(func1,func2,fun1X,fun2X);
Nf1f2(Nf1f2<=count_l)=(NaN);
colormap(h3,jet)
hc = pcolor(Xf1(1:end-1),Xf2(1:end-1),Nf1f2);
hold on 
set(hc,'edgecolor','none'); set(gca,'ColorScale','log');
hcb=colorbar; %hcb.Location = 'northoutside';
hcb.Label.String = 'Counts'; hcb.Label.Interpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';
ax.XLabel.Interpreter='latex'; ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
ax.XLabel.String = '$\frac{\Xi^{th}_{e}}{\Delta\varepsilon_{0}}$'; 
ax.YLabel.String = '$\frac{\nabla \cdot \mathbf{h}_{e}}{\Delta\varepsilon_{0}}$'; 
%--------------------------------------------------------
Xx=Nf1f2; 
Xxa=Xf1(1:end-1).*(isnan(Xx(1,:))); Xxa(isnan(Xxa)) = []; 
Xya=Xf2(1:end-1).*(isnan(Xx(1,:))); Xya(isnan(Xya)) = []; 
%xa = max(Xxa); ya = max(Xya);
xa = stdx*std(Xxa); ya = stdx*std(Xya); 
%xlim([-stdx*std(Xf1),stdx*std(Xf1)]); ylim([-stdx*std(Xf2),stdx*std(Xf2)]);
xlim([-xa,xa]); ylim([-ya,ya]);
%--------------------------------------------------------
hold off
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
h3=subaxis(2,2,1,'SV',0.1,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
func1 = dum_pXI2e./Pi0; % This in the horizontal axis
func1 = filloutliers(func1, 'previous', 'percentiles', [pa pb]);
func2 = (dtUe_in_Gp_2{1,1} + ve_grad_Ue_Gp{1,1})./(Pi0); % This in the vertical axis
func2 = filloutliers(func2, 'previous', 'percentiles', [pa pb]);
fun1xm=max(max(abs(func1))); fun1X=linspace(-fun1xm,fun1xm,nbins);
fun2xm=max(max(abs(func2))); fun2X=linspace(-fun2xm,fun2xm,nbins);
[Nf1f2,Xf1,Xf2] = histcounts2(func1,func2,fun1X,fun2X);
Nf1f2(Nf1f2<=count_l)=(NaN);
hc = pcolor(Xf1(1:end-1),Xf2(1:end-1),Nf1f2);
hold on 
set(hc,'edgecolor','none'); set(gca,'ColorScale','log'); 
hcb=colorbar; %hcb.Location = 'northoutside';
hcb.Label.String = 'Counts'; hcb.Label.Interpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';
ax.XLabel.Interpreter='latex'; ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
ax.XLabel.String = '$\frac{\Xi^{th}_{e}}{\Delta\varepsilon_{0}}$'; 
ax.YLabel.String = '$\frac{d\varepsilon^{th}_{e}/dt}{\Delta\varepsilon_{0}}$'; 
%--------------------------------------------------------
Xx=Nf1f2; 
Xxa=Xf1(1:end-1).*(isnan(Xx(1,:))); Xxa(isnan(Xxa)) = []; 
Xya=Xf2(1:end-1).*(isnan(Xx(1,:))); Xya(isnan(Xya)) = []; 
%xa = max(Xxa); ya = max(Xya);
xa = stdx*std(Xxa); ya = stdx*std(Xya); 
%xlim([-stdx*std(Xf1),stdx*std(Xf1)]); ylim([-stdx*std(Xf2),stdx*std(Xf2)]);
xlim([-xa,xa]); ylim([-ya,ya]);
%--------------------------------------------------------
hold off
%--------------------------------------------------------------------------
%Ue_Div_ve_Gp{1,1}; dtUe_in_Gp_2{1,1} + ve_grad_Ue_Gp{1,1}; -qe_ne_ve_E_Gp{1,1}
%--------------------------------------------------------------------------
h3=subaxis(2,2,4,'SV',0.1,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
func1 = dum_pXI2e./Pi0; % This in the horizontal axis
func1 = filloutliers(func1, 'previous', 'percentiles', [pa pb]);
func2 = (Ue_Div_ve_Gp{1,1})./(Pi0); % This in the vertical axis
func2 = filloutliers(func2, 'previous', 'percentiles', [pa pb]);
fun1xm=max(max(abs(func1))); fun1X=linspace(-fun1xm,fun1xm,nbins);
fun2xm=max(max(abs(func2))); fun2X=linspace(-fun2xm,fun2xm,nbins);
[Nf1f2,Xf1,Xf2] = histcounts2(func1,func2,fun1X,fun2X);
Nf1f2(Nf1f2<=count_l)=(NaN);
%f96 = figure(96);
hc = pcolor(Xf1(1:end-1),Xf2(1:end-1),Nf1f2);
hold on 
set(hc,'edgecolor','none'); set(gca,'ColorScale','log');
hcb=colorbar; %hcb.Location = 'northoutside';
hcb.Label.String = 'Counts'; hcb.Label.Interpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';
ax.XLabel.Interpreter='latex'; ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
ax.XLabel.String = '$\frac{\Xi^{th}_{e}}{\Delta\varepsilon_{0}}$'; 
ax.YLabel.String = '$\frac{\varepsilon^{th}_{e} \nabla \cdot \mathbf{u}_{e}}{\Delta\varepsilon_{0}}$'; 
%--------------------------------------------------------
Xx=Nf1f2; 
Xxa=Xf1(1:end-1).*(isnan(Xx(1,:))); Xxa(isnan(Xxa)) = []; 
Xya=Xf2(1:end-1).*(isnan(Xx(1,:))); Xya(isnan(Xya)) = []; 
%xa = max(Xxa); ya = max(Xya);
xa = stdx*std(Xxa); ya = stdx*std(Xya); 
%xlim([-stdx*std(Xf1),stdx*std(Xf1)]); ylim([-stdx*std(Xf2),stdx*std(Xf2)]);
xlim([-xa,xa]); ylim([-ya,ya]);
%--------------------------------------------------------
hold off
%--------------------------------------------------------------------------


% The four plots in a single one for ions
%--------------------------------------------------------------------------
f981 = figure(981);
h3=subaxis(2,2,3,'SV',0.1,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
func1 = dum_pXI2i./Pi0; % This in the horizontal axis
func1 = filloutliers(func1, 'previous', 'percentiles', [pa pb]);
func2 = Pit_grad_vi_Gp{1,1}./(Pi0); % This in the vertical axis
func2 = filloutliers(func2, 'previous', 'percentiles', [pa pb]);
fun1xm=max(max(abs(func1))); fun1X=linspace(-fun1xm,fun1xm,nbins);
fun2xm=max(max(abs(func2))); fun2X=linspace(-fun2xm,fun2xm,nbins);
[Nf1f2,Xf1,Xf2] = histcounts2(func1,func2,fun1X,fun2X);
Nf1f2(Nf1f2<=count_l)=(NaN);
colormap(h3,jet)
hc = pcolor(Xf1(1:end-1),Xf2(1:end-1),Nf1f2);
hold on 
set(hc,'edgecolor','none'); set(gca,'ColorScale','log'); 
hcb=colorbar; %hcb.Location = 'northoutside';
hcb.Label.String = 'Counts'; hcb.Label.Interpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';
ax.XLabel.Interpreter='latex'; ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
ax.XLabel.String = '$\frac{\Xi^{th}_{i}}{\Delta\varepsilon_{0}}$'; 
ax.YLabel.String = '$\frac{\nabla \mathbf{u}_{i} : \overline{\mathbf{P}}_{i}}{\Delta\varepsilon_{0}}$'; 
%--------------------------------------------------------
Xx=Nf1f2; 
Xxa=Xf1(1:end-1).*(isnan(Xx(1,:))); Xxa(isnan(Xxa)) = []; 
Xya=Xf2(1:end-1).*(isnan(Xx(1,:))); Xya(isnan(Xya)) = []; 
%xa = max(Xxa); ya = max(Xya);
xa = stdx*std(Xxa); ya = stdx*std(Xya); 
%xlim([-stdx*std(Xf1),stdx*std(Xf1)]); ylim([-stdx*std(Xf2),stdx*std(Xf2)]);
xlim([-xa,xa]); ylim([-ya,ya]);
%--------------------------------------------------------
hold off
%--------------------------------------------------------------------------
h3=subaxis(2,2,2,'SV',0.1,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
func1 = dum_pXI2i./Pi0; % This in the horizontal axis
func1 = filloutliers(func1, 'previous', 'percentiles', [pa pb]);
func2 = dkQiik_05_i_Gp{1,1}./(Pi0); % This in the vertical axis
func2 = filloutliers(func2, 'previous', 'percentiles', [pa pb]);
fun1xm=max(max(abs(func1))); fun1X=linspace(-fun1xm,fun1xm,nbins);
fun2xm=max(max(abs(func2))); fun2X=linspace(-fun2xm,fun2xm,nbins);
[Nf1f2,Xf1,Xf2] = histcounts2(func1,func2,fun1X,fun2X);
Nf1f2(Nf1f2<=count_l)=(NaN);
colormap(h3,jet)
hc = pcolor(Xf1(1:end-1),Xf2(1:end-1),Nf1f2);
hold on 
set(hc,'edgecolor','none'); set(gca,'ColorScale','log');
hcb=colorbar; %hcb.Location = 'northoutside';
hcb.Label.String = 'Counts'; hcb.Label.Interpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';
ax.XLabel.Interpreter='latex'; ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
ax.XLabel.String = '$\frac{\Xi^{th}_{i}}{\Delta\varepsilon_{0}}$'; 
ax.YLabel.String = '$\frac{\nabla \cdot \mathbf{h}_{i}}{\Delta\varepsilon_{0}}$'; 
%--------------------------------------------------------
Xx=Nf1f2; 
Xxa=Xf1(1:end-1).*(isnan(Xx(1,:))); Xxa(isnan(Xxa)) = []; 
Xya=Xf2(1:end-1).*(isnan(Xx(1,:))); Xya(isnan(Xya)) = []; 
%xa = max(Xxa); ya = max(Xya);
xa = stdx*std(Xxa); ya = stdx*std(Xya); 
%xlim([-stdx*std(Xf1),stdx*std(Xf1)]); ylim([-stdx*std(Xf2),stdx*std(Xf2)]);
xlim([-xa,xa]); ylim([-ya,ya]);
%--------------------------------------------------------
hold off
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
h3=subaxis(2,2,1,'SV',0.1,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
func1 = dum_pXI2i./Pi0; % This in the horizontal axis
func1 = filloutliers(func1, 'previous', 'percentiles', [pa pb]);
func2 = (dtUi_in_Gp_2{1,1} + vi_grad_Ui_Gp{1,1})./(Pi0); % This in the vertical axis
func2 = filloutliers(func2, 'previous', 'percentiles', [pa pb]);
fun1xm=max(max(abs(func1))); fun1X=linspace(-fun1xm,fun1xm,nbins);
fun2xm=max(max(abs(func2))); fun2X=linspace(-fun2xm,fun2xm,nbins);
[Nf1f2,Xf1,Xf2] = histcounts2(func1,func2,fun1X,fun2X);
Nf1f2(Nf1f2<=count_l)=(NaN);
hc = pcolor(Xf1(1:end-1),Xf2(1:end-1),Nf1f2);
hold on 
set(hc,'edgecolor','none'); set(gca,'ColorScale','log'); 
hcb=colorbar; %hcb.Location = 'northoutside';
hcb.Label.String = 'Counts'; hcb.Label.Interpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';
ax.XLabel.Interpreter='latex'; ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
ax.XLabel.String = '$\frac{\Xi^{th}_{i}}{\Delta\varepsilon_{0}}$'; 
ax.YLabel.String = '$\frac{d\varepsilon^{th}_{i}/dt}{\Delta\varepsilon_{0}}$'; 
%--------------------------------------------------------
Xx=Nf1f2; 
Xxa=Xf1(1:end-1).*(isnan(Xx(1,:))); Xxa(isnan(Xxa)) = []; 
Xya=Xf2(1:end-1).*(isnan(Xx(1,:))); Xya(isnan(Xya)) = []; 
%xa = max(Xxa); ya = max(Xya);
xa = stdx*std(Xxa); ya = stdx*std(Xya); 
%xlim([-stdx*std(Xf1),stdx*std(Xf1)]); ylim([-stdx*std(Xf2),stdx*std(Xf2)]);
xlim([-xa,xa]); ylim([-ya,ya]);
%--------------------------------------------------------
hold off
%--------------------------------------------------------------------------
%Ue_Div_ve_Gp{1,1}; dtUe_in_Gp_2{1,1} + ve_grad_Ue_Gp{1,1}; -qe_ne_ve_E_Gp{1,1}
%--------------------------------------------------------------------------
h3=subaxis(2,2,4,'SV',0.1,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
func1 = dum_pXI2i./Pi0; % This in the horizontal axis
func1 = filloutliers(func1, 'previous', 'percentiles', [pa pb]);
func2 = (Ui_Div_vi_Gp{1,1})./(Pi0); % This in the vertical axis
func2 = filloutliers(func2, 'previous', 'percentiles', [pa pb]);
fun1xm=max(max(abs(func1))); fun1X=linspace(-fun1xm,fun1xm,nbins);
fun2xm=max(max(abs(func2))); fun2X=linspace(-fun2xm,fun2xm,nbins);
[Nf1f2,Xf1,Xf2] = histcounts2(func1,func2,fun1X,fun2X);
Nf1f2(Nf1f2<=count_l)=(NaN);
%f96 = figure(96);
hc = pcolor(Xf1(1:end-1),Xf2(1:end-1),Nf1f2);
hold on 
set(hc,'edgecolor','none'); set(gca,'ColorScale','log');
hcb=colorbar; %hcb.Location = 'northoutside';
hcb.Label.String = 'Counts'; hcb.Label.Interpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';
ax.XLabel.Interpreter='latex'; ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
ax.XLabel.String = '$\frac{\Xi^{th}_{i}}{\Delta\varepsilon_{0}}$'; 
ax.YLabel.String = '$\frac{\varepsilon^{th}_{i} \nabla \cdot \mathbf{u}_{i}}{\Delta\varepsilon_{0}}$'; 
%--------------------------------------------------------
Xx=Nf1f2; 
Xxa=Xf1(1:end-1).*(isnan(Xx(1,:))); Xxa(isnan(Xxa)) = []; 
Xya=Xf2(1:end-1).*(isnan(Xx(1,:))); Xya(isnan(Xya)) = []; 
%xa = max(Xxa); ya = max(Xya);
xa = stdx*std(Xxa); ya = stdx*std(Xya); 
%xlim([-stdx*std(Xf1),stdx*std(Xf1)]); ylim([-stdx*std(Xf2),stdx*std(Xf2)]);
xlim([-xa,xa]); ylim([-ya,ya]);
%--------------------------------------------------------
hold off
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
func1 = dum_pXI2e./Pi0; % This in the horizontal axis
func1 = filloutliers(func1, 'previous', 'percentiles', [pa pb]);
func2 = dum_pXIe./Pi0; % This in the vertical axis
func2 = filloutliers(func2, 'previous', 'percentiles', [pa pb]);
fun1xm=max(max(abs(func1))); fun1X=linspace(-fun1xm,fun1xm,nbins);
fun2xm=max(max(abs(func2))); fun2X=linspace(-fun2xm,fun2xm,nbins);
[Nf1f2,Xf1,Xf2] = histcounts2(func1,func2,fun1X,fun2X);
Nf1f2(Nf1f2<=count_l)=(NaN);
f97 = figure(97);
hc = pcolor(Xf1(1:end-1),Xf2(1:end-1),Nf1f2);
hold on 
set(hc,'edgecolor','none'); set(gca,'ColorScale','log'); 
hcb=colorbar; 
hcb.Label.String = 'Counts'; hcb.Label.Interpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';
ax.XLabel.Interpreter='latex'; ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
ax.XLabel.String = '$\frac{\Xi^{th}_{e}}{\Delta\varepsilon_{0}}$'; 
ax.YLabel.String = '$\frac{\Xi^{k}_{e}}{\Delta\varepsilon_{0}}$'; 
%--------------------------------------------------------
Xx=Nf1f2; 
Xxa=Xf1(1:end-1).*(isnan(Xx(1,:))); Xxa(isnan(Xxa)) = []; 
Xya=Xf2(1:end-1).*(isnan(Xx(1,:))); Xya(isnan(Xya)) = []; 
%xa = max(Xxa); ya = max(Xya);
xa = stdx*std(Xxa); ya = stdx*std(Xya); 
%xlim([-stdx*std(Xf1),stdx*std(Xf1)]); ylim([-stdx*std(Xf2),stdx*std(Xf2)]);
xlim([-xa,xa]); ylim([-ya,ya]);
%--------------------------------------------------------
hold off
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%Ke_Div_ve_Gp{1,1};-qe_ne_ve_E_Gp{1,1}
func1 = Ke_Div_ve_Gp{1,1}./Pi0; % This in the horizontal axis
func1 = filloutliers(func1, 'previous', 'percentiles', [pa pb]);
func2 = -qe_ne_ve_E_Gp{1,1}./Pi0; % This in the vertical axis
func2 = filloutliers(func2, 'previous', 'percentiles', [pa pb]);
fun1xm=max(max(abs(func1))); fun1X=linspace(-fun1xm,fun1xm,nbins);
fun2xm=max(max(abs(func2))); fun2X=linspace(-fun2xm,fun2xm,nbins);
[Nf1f2,Xf1,Xf2] = histcounts2(func1,func2,fun1X,fun2X);
Nf1f2(Nf1f2<=count_l)=(NaN);
f96 = figure(96);
hc = pcolor(Xf1(1:end-1),Xf2(1:end-1),Nf1f2);
hold on 
set(hc,'edgecolor','none'); set(gca,'ColorScale','log'); hcb=colorbar;
hcb.Label.String = 'Counts'; hcb.Label.Interpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';
ax.XLabel.Interpreter='latex'; ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
ax.YLabel.String = '$\frac{-q_{e}n_{e}\mathbf{u}_{e} \cdot \mathbf{E}}{\Delta\varepsilon_{0}}$'; 
%ax.YLabel.String = '$\frac{\mathbf{u}_{e} \cdot \nabla \cdot \overline{\mathbf{P}}_{e}}{\Delta\varepsilon_{0}}$'; 
ax.XLabel.String = '$\frac{ \nabla \cdot \mathbf{u}_{e} \varepsilon^{k}_{e}}{\Delta\varepsilon_{0}}$'; 
hold off
ylim([-0.1,0.1]);
%--------------------------------------------------------------------------

pa = 5;
pb = 95;
%--------------------------------------------------------------------------
%Ke_Div_ve_Gp{1,1};-qe_ne_ve_E_Gp{1,1}
func1 = ve_Div_Pet_Gp{1,1}./Pi0; % This in the horizontal axis
func1 = filloutliers(func1, 'previous', 'percentiles', [pa pb]);
func2 = -qe_ne_ve_E_Gp{1,1}./Pi0; % This in the vertical axis
func2 = filloutliers(func2, 'previous', 'percentiles', [pa pb]);
%func2 = func1;
fun1xm=max(max(abs(func1))); fun1X=linspace(-fun1xm,fun1xm,nbins);
fun2xm=max(max(abs(func2))); fun2X=linspace(-fun2xm,fun2xm,nbins);
[Nf1f2,Xf1,Xf2] = histcounts2(func1,func2,fun1X,fun2X);
Nf1f2(Nf1f2<=count_l)=(NaN);
f95 = figure(95);
hc = pcolor(Xf1(1:end-1),Xf2(1:end-1),Nf1f2);
hold on 
set(hc,'edgecolor','none'); set(gca,'ColorScale','log'); hcb=colorbar;
hcb.Label.String = 'Counts'; hcb.Label.Interpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';
ax.XLabel.Interpreter='latex'; ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
ax.YLabel.String = '$\frac{-q_{e}n_{e}\mathbf{u}_{e} \cdot \mathbf{E}}{\Delta\varepsilon_{0}}$'; 
ax.XLabel.String = '$\frac{\mathbf{u}_{e} \cdot \nabla \cdot \overline{\mathbf{P}}_{e}}{\Delta\varepsilon_{0}}$'; 
hold off
ylim([-0.1,0.1]);
%--------------------------------------------------------------------------


f987=figure(987)
scatter3(dum_px1,dum_py1,dum_pz1,s,c)
view(40,35)



[X,Y,Z] = sphere(16);
x = [0.5*X(:); 0.75*X(:); X(:)];