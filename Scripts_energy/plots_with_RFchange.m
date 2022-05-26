cd '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here'

% This plot goes in the paper Ba, vea vectors, via vectors
%--------------------------------------------------------------------------
asf=2.3;sv=7; lwv=1.0; ypc_i=127; xpc_i = 93;
colorFVBl=[0 0 0 0.5];

%Thi is the plot of the out of the plane components WITHOUT magnetic arrows
%{
f14=figure(14);
%--------------------------------------------------------------------------
h1=subaxis(1,3,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
%dum_p=J_Gp{1,2};
%dum_p=(dum_p)./VA2c; 
dum_p=B_Gp{1,2};
dum_p=(dum_p+0.1)./B0;  
hc = pcolor(XLL,YLL,dum_p);
set(hc,'edgecolor','none')
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,BWR); 
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ticks = linspace(-4,4,5); hcb.TickLabels = [-4,-2,0,2,4] ; caxis([-5 5]);
caxis([-1 1]); hcb.Ticks = linspace(-0.8,0.8,5); hcb.TickLabels = [-0.8,-0.4,0,0.4,0.8] ;
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.5, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
%title('$J_{a}/J_{0}$','Interpreter','latex','FontSize',fs);
title('$(B_{a}-B_{0})/B_{0}$','Interpreter','latex','FontSize',fs);
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,3,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=ve_Gp{1,2}./VA2c;    
hc = pcolor(XLL,YLL,dum_p);
set(hc,'edgecolor','none')
hold on
%hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
%hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
h2v=quiver(xll(1:sv:end,1:sv:end), yll(1:sv:end,1:sv:end), Vev_x(1:sv:end,1:sv:end), Vev_y(1:sv:end,1:sv:end), 0);
set(h2v,'AutoScale','on', 'AutoScaleFactor', asf, 'Color', 'k');
lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR); 
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-4,4,5); hcb.TickLabels = [-4,-2,0,2,4] ; caxis([-5 5]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$u_{e,a}/v_{A,i} \ ; \ \mathbf{u}_{e} $','Interpreter','latex','FontSize',fs);
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,3,3,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=vi_Gp{1,2}./VA2c;    
hc = pcolor(XLL,YLL,dum_p);
set(hc,'edgecolor','none')
hold on
%hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
%hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
h2v=quiver(xll(1:sv:end,1:sv:end), yll(1:sv:end,1:sv:end), Viv_x(1:sv:end,1:sv:end), Viv_y(1:sv:end,1:sv:end), 0);
set(h2v,'AutoScale','on', 'AutoScaleFactor', asf, 'Color', 'k');
lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR); %caxis([-5 5]) 
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.8,0.8,5); hcb.TickLabels = [-0.8,-0.4,0,0.4,0.8] ; caxis([-1 1]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$u_{i,a}/v_{A,i} \ ; \ \mathbf{u}_{i}$','Interpreter','latex','FontSize',fs);
hold off
sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------
%}


%Thi is the plot of the out of the plane components WITH magnetic arrows
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
map_r = [1.0 1.0 1.0
    1.0 0.9 0.9
    1.0 0.8 0.8
    1.0 0.7 0.7
    1.0 0.6 0.6
    1.0 0.5 0.5
    1.0 0.4 0.4
    1.0 0.3 0.3
    1.0 0.2 0.2
    1.0 0.1 0.1
    1.0 0 0
    0.8 0 0];

filtvec=[3,3]; %The unfiltered one can be seen using [1,1] 
%This is to check the components of the heat flux tensor closure
%--------------------------------------------------------------------------
%{
%
%dum_p = medfilt2(dum_p,filtvec);

f211=figure(211);
subplot(2,3,1)
hc=pcolor(XLL,YLL,Pij_e_Gp{1,1}); set(hc,'edgecolor','none');colorbar;
subplot(2,3,2)
hc=pcolor(XLL,YLL,Pij_e_Gp{2,2}); set(hc,'edgecolor','none');colorbar;
subplot(2,3,3)
hc=pcolor(XLL,YLL,Pij_e_Gp{3,3}); set(hc,'edgecolor','none');colorbar;
subplot(2,3,4)
hc=pcolor(XLL,YLL,dk_Qijk_e_Gp{1,1}); set(hc,'edgecolor','none');colorbar;caxis([-0.0001,0.0001])
subplot(2,3,5)
hc=pcolor(XLL,YLL,dk_Qijk_e_Gp{2,2}); set(hc,'edgecolor','none');colorbar;caxis([-0.0001,0.0001])
subplot(2,3,6)
hc=pcolor(XLL,YLL,dk_Qijk_e_Gp{3,3}); set(hc,'edgecolor','none');colorbar;caxis([-0.0001,0.0001])

f212=figure(212);
subplot(2,3,1)
hc=pcolor(XLL,YLL,dk_Qijk_e2_Gp{1,1}); set(hc,'edgecolor','none');colorbar;caxis([-0.0001,0.0001])
subplot(2,3,2)
hc=pcolor(XLL,YLL,dk_Qijk_e2_Gp{2,2}); set(hc,'edgecolor','none');colorbar;caxis([-0.0001,0.0001])
subplot(2,3,3)
hc=pcolor(XLL,YLL,dk_Qijk_e2_Gp{3,3}); set(hc,'edgecolor','none');colorbar;caxis([-0.0001,0.0001])
subplot(2,3,4)
hc=pcolor(XLL,YLL,dk_Qijk_e3_Gp{1,1}); set(hc,'edgecolor','none');colorbar;caxis([-0.0001,0.0001])
subplot(2,3,5)
hc=pcolor(XLL,YLL,dk_Qijk_e3_Gp{2,2}); set(hc,'edgecolor','none');colorbar;caxis([-0.0001,0.0001])
subplot(2,3,6)
hc=pcolor(XLL,YLL,dk_Qijk_e3_Gp{3,3}); set(hc,'edgecolor','none');colorbar;caxis([-0.0001,0.0001])

f213=figure(213);
subplot(1,2,1)
dumpp=0.5.*(dk_Qijk_e_Gp{1,1}+dk_Qijk_e_Gp{2,2}+dk_Qijk_e_Gp{3,3});
%dumpp = medfilt2(dumpp,filtvec);
%contourf(XLL,YLL,dumpp); 
hc=pcolor(XLL,YLL,dumpp); set(hc,'edgecolor','none');
colorbar;caxis([-0.001,0.001])
f213=figure(213);
subplot(1,2,2)
dumpp=0.5.*(dk_Qijk_e3_Gp{1,1}+dk_Qijk_e3_Gp{2,2}+dk_Qijk_e3_Gp{3,3});
%dumpp = medfilt2(dumpp,filtvec);
%contourf(XLL,YLL,dumpp); 
hc=pcolor(XLL,YLL,dumpp); set(hc,'edgecolor','none');
colorbar;caxis([-0.001,0.001])
%}
%--------------------------------------------------------------------------

x0=-1562;y0=142;width=1355;height=499; fs=25;

% Extra plots 
%--------------------------------------------------------------------------
f146=figure(146);
set(gcf,'position',[x0,y0,width,height])
%--------------------------------------------------------------------------
h1=subaxis(1,4,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
%dum_p=J_Gp{1,2};
%dum_p=(dum_p)./VA2c; 
dum_p=sqrt(B_Gp{1,1}.^2 + B_Gp{1,2}.^2 + B_Gp{1,3}.^2); mean(abs(dum_p),'all')
dum_p=(dum_p)./B0;  
hc = pcolor(XLL,YLL,dum_p);
%contourf(XLL,YLL,dum_p)
set(hc,'edgecolor','none')
%hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.5, 'Color', colorFVBl);
%hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.5, 'Color', colorFVBl);
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', [0 0 0 0.5]);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', [0 0 0 0.5]);
%hlines1=streamline(ccc12);set(hlines1,'LineWidth',1.0,'Color', 'c');% [0.2,0.1,0.5]);
%hlines1=streamline(ccc12m);set(hlines1,'LineWidth',1.0,'Color', 'c');
hold on
A = sqrt(B_Gp{1,1}.^2 + B_Gp{1,3}.^2)./0.1;
v = [0.1,0.15];
[M3,c] = contour(xll,yll,A,v,'-k','ShowText','off');c.LineWidth = 1.5;
%h2=quiver(xll(1:sv:end,1:sv:end), yll(1:sv:end,1:sv:end), ubx(1:sv:end,1:sv:end), vby(1:sv:end,1:sv:end), 0);
%set(h2,'AutoScale','on', 'AutoScaleFactor', asf, 'Color', 'k');
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,map_r); 
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ticks = linspace(-4,4,5); hcb.TickLabels = [-4,-2,0,2,4] ; caxis([-5 5]);
caxis([0 1]); hcb.Ticks = linspace(0.2,1.0,5); hcb.TickLabels = [0.2,0.4,0.6,0.8,1.0] ;
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
%title('$J_{a}/J_{0}$','Interpreter','latex','FontSize',fs);
title('$|\mathbf{B}|/B_{0} \ ; \ B_{rp} \ lines$','Interpreter','latex','FontSize',fs);
rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h1=subaxis(1,4,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
%dum_p=J_Gp{1,2};
%dum_p=(dum_p)./VA2c; 
dum_p=B_Gp{1,2};
dum_p2=-0.33/sqrt(1+(3.33^2));
%dum_p=(dum_p-dum_p2)./B0; %<----- 
%dum_p=(dum_p+0.1)./B0;  
dum_p=(dum_p)./B0;  
hc = pcolor(XLL,YLL,dum_p);
set(hc,'edgecolor','none')
hold on
%hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);
%hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
%hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', [0 0 0 0.3]);
%hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', [0 0 0 0.3]);
h2=quiver(xll(1:sv:end,1:sv:end), yll(1:sv:end,1:sv:end), ubx(1:sv:end,1:sv:end), vby(1:sv:end,1:sv:end), 0);
set(h2,'AutoScale','on', 'AutoScaleFactor', asf, 'Color', 'k','linewidth',lwv);
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,BWR); 
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ticks = linspace(-4,4,5); hcb.TickLabels = [-4,-2,0,2,4] ; caxis([-5 5]);
caxis([-1 1]); hcb.Ticks = linspace(-0.8,0.8,5); hcb.TickLabels = [-0.8,-0.4,0,0.4,0.8] ; %<----
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.5, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
%title('$J_{a}/J_{0}$','Interpreter','latex','FontSize',fs);
title('$(B_{a}-B_{a,0})/B_{0} \ ; \ \mathbf{B}_{rp}$','Interpreter','latex','FontSize',fs);
rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,4,3,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=ve_Gp{1,2}./VA2c;    
hc = pcolor(XLL,YLL,dum_p);
set(hc,'edgecolor','none')
hold on
%hlines1=streamline(ccc12);set(hlines1,'LineWidth',1.0,'Color', 'g');% [0.2,0.1,0.5]);
%hlines1=streamline(ccc12m);set(hlines1,'LineWidth',1.0,'Color', 'g');
%hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
%hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
%asf=2;sv=3;
h2v=quiver(xll(1:sv:end,1:sv:end), yll(1:sv:end,1:sv:end), Vev_x(1:sv:end,1:sv:end), Vev_y(1:sv:end,1:sv:end), 0);
set(h2v,'AutoScale','on', 'AutoScaleFactor', 1.2*asf, 'Color', 'k','linewidth',lwv);
%asf=2.3;sv=7;
lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR); 
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-4,4,5); hcb.TickLabels = [-4,-2,0,2,4] ; caxis([-5 5]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
%xlim([4 8]); ylim([5 9]);
title('$u_{a,e}/v_{A,i} \ ; \ \mathbf{u}_{rp,e} $','Interpreter','latex','FontSize',fs);
rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
v = [0.1,0.15];
[M3,c] = contour(xll,yll,A,v,'-k','ShowText','off');c.LineWidth = 1.5;
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,4,4,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=vi_Gp{1,2}./VA2c;    
hc = pcolor(XLL,YLL,dum_p);
set(hc,'edgecolor','none')
hold on
%hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
%hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
h2v=quiver(xll(1:sv:end,1:sv:end), yll(1:sv:end,1:sv:end), Viv_x(1:sv:end,1:sv:end), Viv_y(1:sv:end,1:sv:end), 0);
set(h2v,'AutoScale','on', 'AutoScaleFactor', asf, 'Color', 'k','linewidth',lwv);
lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR); %caxis([-5 5]) 
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.8,0.8,5); hcb.TickLabels = [-0.8,-0.4,0,0.4,0.8] ; caxis([-1 1]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$u_{a,i}/v_{A,i} \ ; \ \mathbf{u}_{rp,i}$','Interpreter','latex','FontSize',fs);
rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% For the field lines and vectors withouth substracting the ptojection of
% th ebackground magnetic field
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1462=figure(1462);
set(gcf,'position',[x0,y0,width,height])
%--------------------------------------------------------------------------
h1=subaxis(1,4,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
%dum_p=sqrt(B_Gp{1,1}.^2 + B_Gp{1,2}.^2 + B_Gp{1,3}.^2); mean(abs(dum_p),'all')
%dum_p=(dum_p)./B0;  
dum_p=sqrt(ve_Gp{1,1}.^2 + ve_Gp{1,2}.^2 + ve_Gp{1,3}.^2); mean(abs(dum_p),'all')
dum_p=(dum_p)./VA2c; 
hc = pcolor(XLL,YLL,dum_p);
set(hc,'edgecolor','none')
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', [0 0 0 0.5]);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', [0 0 0 0.5]);
hold on
asf=1.5;sv=3; 
h2v=quiver(xll(1:sv:end,1:sv:end), yll(1:sv:end,1:sv:end), Vev_x(1:sv:end,1:sv:end), Vev_y(1:sv:end,1:sv:end), 0);
set(h2v,'AutoScale','on', 'AutoScaleFactor', 1.2*asf, 'Color', 'k','linewidth',lwv);

A = sqrt(B_Gp{1,1}.^2 + B_Gp{1,3}.^2)./0.1;
v = [0.1,0.15];
%[M3,c] = contour(xll,yll,A,v,'-k','ShowText','off');c.LineWidth = 1.5;
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,map_r); 
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ticks = linspace(-4,4,5); hcb.TickLabels = [-4,-2,0,2,4] ; caxis([-5 5]);
caxis([0 1]); hcb.Ticks = linspace(0.2,1.0,5); hcb.TickLabels = [0.2,0.4,0.6,0.8,1.0] ;
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
%title('$J_{a}/J_{0}$','Interpreter','latex','FontSize',fs);
title('$|\mathbf{B}|/B_{0} \ ; \ B_{rp} \ lines$','Interpreter','latex','FontSize',fs);
rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
xlim([4 8]); ylim([5 9]);
hold off
%--------------------------------------------------------------------------
h1=subaxis(1,4,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=B_Gp{1,2};
dum_p=0.*(dum_p)./B0;  
hc = pcolor(XLL,YLL,dum_p);
set(hc,'edgecolor','none')
hold on
%h2=quiver(xll(1:sv:end,1:sv:end), yll(1:sv:end,1:sv:end), ubx(1:sv:end,1:sv:end), vby(1:sv:end,1:sv:end), 0);
asf=1.5;sv=3; 
h2=quiver(xll(1:sv:end,1:sv:end), yll(1:sv:end,1:sv:end), Vev_x(1:sv:end,1:sv:end), Vev_y(1:sv:end,1:sv:end), 0);
set(h2,'AutoScale','on', 'AutoScaleFactor', asf, 'Color', 'k','linewidth',lwv);
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,BWR); 
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
caxis([-1.5 1.5]); hcb.Ticks = linspace(-1.0,1.0,5); hcb.TickLabels = [-1.0,-0.5,0,0.5,1.0] ; %<----
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$B_{a}/B_{0} \ ; \ \mathbf{B}_{rp}$','Interpreter','latex','FontSize',fs);
rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,4,3,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=ve_Gp{1,2}./VA2c;    
hc = pcolor(XLL,YLL,dum_p);
set(hc,'edgecolor','none')
hold on
asf=1.5;sv=3; 
h2v=quiver(xll(1:sv:end,1:sv:end), yll(1:sv:end,1:sv:end), Vev_x(1:sv:end,1:sv:end), Vev_y(1:sv:end,1:sv:end), 0);
set(h2v,'AutoScale','on', 'AutoScaleFactor', 1.2*asf, 'Color', 'k','linewidth',lwv);
lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR); 
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-4,4,5); hcb.TickLabels = [-4,-2,0,2,4] ; caxis([-5 5]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
%xlim([4 8]); ylim([5 9]);
title('$u_{a,e}/v_{A,i} \ ; \ \mathbf{u}_{rp,e} $','Interpreter','latex','FontSize',fs);
rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
v = [0.1,0.15];
%[M3,c] = contour(xll,yll,A,v,'-k','ShowText','off');c.LineWidth = 1.5;
xlim([4 8]); ylim([5 9]);
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,4,4,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=vi_Gp{1,2}./VA2c;    
hc = pcolor(XLL,YLL,dum_p);
set(hc,'edgecolor','none')
asf=2.3;sv=7;
hold on
h2v=quiver(xll(1:sv:end,1:sv:end), yll(1:sv:end,1:sv:end), Viv_x(1:sv:end,1:sv:end), Viv_y(1:sv:end,1:sv:end), 0);
set(h2v,'AutoScale','on', 'AutoScaleFactor', asf, 'Color', 'k','linewidth',lwv);
lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR); %caxis([-5 5]) 
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.8,0.8,5); hcb.TickLabels = [-0.8,-0.4,0,0.4,0.8] ; caxis([-1 1]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$u_{a,i}/v_{A,i} \ ; \ \mathbf{u}_{rp,i}$','Interpreter','latex','FontSize',fs);
rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off



% this is to check the direction of the electron and ion flows and the
% contributions to the zenitany parameter
f1462=figure(1462);
set(gcf,'position',[x0,y0,width,height])
%--------------------------------------------------------------------------
h1=subaxis(1,4,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);  
dum_p=ve_Gp{1,1}.*vi_Gp{1,1} + ve_Gp{1,2}.*vi_Gp{1,2} + ve_Gp{1,3}.*vi_Gp{1,3}; 
dum_p = dum_p./(sqrt(ve_Gp{1,1}.^2 + ve_Gp{1,2}.^2 + ve_Gp{1,3}.^2).*sqrt(vi_Gp{1,1}.^2 + vi_Gp{1,2}.^2 + vi_Gp{1,3}.^2));
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);set(hc,'edgecolor','none')
%hc = contourf(XLL,YLL,dum_p);
%hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', [0 0 0 0.5]);
%hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', [0 0 0 0.5]);
hold on
asf=1.5;sv=3; 
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,BWR); 
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
caxis([-1 1]); hcb.Ticks = linspace(-1.0,1.0,5); hcb.TickLabels = [-1,-0.5,0,0.5,1.0] ;
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\cos(\theta_{uiue})$','Interpreter','latex','FontSize',fs);
rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
%xlim([4 8]); ylim([5 9]);
hold off
%--------------------------------------------------------------------------
h1=subaxis(1,4,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p = sqrt(vi_Gp{1,1}.^2 + vi_Gp{1,2}.^2 + vi_Gp{1,3}.^2)./sqrt(ve_Gp{1,1}.^2 + ve_Gp{1,2}.^2 + ve_Gp{1,3}.^2);
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);set(hc,'edgecolor','none')
%hc = contourf(XLL,YLL,dum_p);
hold on
%h2=quiver(xll(1:sv:end,1:sv:end), yll(1:sv:end,1:sv:end), ubx(1:sv:end,1:sv:end), vby(1:sv:end,1:sv:end), 0);
asf=1.5;sv=3; 
%h2=quiver(xll(1:sv:end,1:sv:end), yll(1:sv:end,1:sv:end), Vev_x(1:sv:end,1:sv:end), Vev_y(1:sv:end,1:sv:end), 0);
%set(h2,'AutoScale','on', 'AutoScaleFactor', asf, 'Color', 'k','linewidth',lwv);
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,map_r); 
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
caxis([0 1]); hcb.Ticks = linspace(0,1.0,5); hcb.TickLabels = [0.2,0.4,0.6,0.8,1.0] ; %<----
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$|\mathbf{u}_{i}|/|\mathbf{u}_{e}|$','Interpreter','latex','FontSize',fs);
rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,4,3,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p1=(E_Gp{1,1}.*vi_Gp{1,1} + E_Gp{1,2}.*vi_Gp{1,2} + E_Gp{1,3}.*vi_Gp{1,3}); 
dum_p1m=((E_Gp{1,1}.*vi_Gp{1,1}).^2 + (E_Gp{1,2}.*vi_Gp{1,2}).^2 + (E_Gp{1,3}.*vi_Gp{1,3}).^2);
dum_p2_1=vi_Gp{1,1}.*(ve_Gp{1,2}.*B_Gp{1,3} - ve_Gp{1,3}.*B_Gp{1,2});
dum_p2_2=vi_Gp{1,2}.*(ve_Gp{1,3}.*B_Gp{1,1} - ve_Gp{1,1}.*B_Gp{1,3});
dum_p2_3=vi_Gp{1,3}.*(ve_Gp{1,1}.*B_Gp{1,2} - ve_Gp{1,2}.*B_Gp{1,1});
dum_p2 = (dum_p2_1 + dum_p2_2 + dum_p2_3);
dum_p2m = sqrt(dum_p2_1.^2 + dum_p2_2.^2 + dum_p2_3.^2);
%dum_p = dum_p1./dum_p2;
dum_p = dum_p1;
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
set(hc,'edgecolor','none')
hold on
asf=1.5;sv=3; 
%h2v=quiver(xll(1:sv:end,1:sv:end), yll(1:sv:end,1:sv:end), Vev_x(1:sv:end,1:sv:end), Vev_y(1:sv:end,1:sv:end), 0);
%set(h2v,'AutoScale','on', 'AutoScaleFactor', 1.2*asf, 'Color', 'k','linewidth',lwv);
lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR); 
hcb=colorbar; hcb.Location = 'northoutside';
%hcb.Ticks = linspace(-0.8,0.8,5); hcb.TickLabels = [-0.8,-0.4,0,0.4,0.8] ; caxis([-1 1]); 
lim_yp=max(max(max(abs(dum_p))));
%caxis([-lim_yp lim_yp]);
caxis([-0.001 0.001]);
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
%xlim([4 8]); ylim([5 9]);
title('$\mathbf{u}_{i}\cdot \mathbf{E} $','Interpreter','latex','FontSize',fs);
rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
v = [0.1,0.15];
%[M3,c] = contour(xll,yll,A,v,'-k','ShowText','off');c.LineWidth = 1.5;
%xlim([4 8]); ylim([5 9]);
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,4,4,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
%dum_p = dum_p2./dum_p2m;
dum_p = dum_p2;
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
set(hc,'edgecolor','none')
asf=2.3;sv=7;
hold on
%h2v=quiver(xll(1:sv:end,1:sv:end), yll(1:sv:end,1:sv:end), Viv_x(1:sv:end,1:sv:end), Viv_y(1:sv:end,1:sv:end), 0);
%set(h2v,'AutoScale','on', 'AutoScaleFactor', asf, 'Color', 'k','linewidth',lwv);
lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR); %caxis([-5 5]) 
hcb=colorbar; hcb.Location = 'northoutside';
%hcb.Ticks = linspace(-0.8,0.8,5); hcb.TickLabels = [-0.8,-0.4,0,0.4,0.8] ; caxis([-1 1]); 
lim_yp=max(max(max(abs(dum_p))));
%caxis([-lim_yp lim_yp]);
caxis([-0.001 0.001]);
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\mathbf{u}_{i}\cdot(\mathbf{u}_{e}\times\mathbf{B}) $','Interpreter','latex','FontSize',fs);
rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filtvec=[3,3]; %The unfiltered one can be seen using [1,1] 
dum_p1=(Pij_e_Gp{1,1} + Pij_e_Gp{2,2} + Pij_e_Gp{3,3})/3 ;
dum_p2=(B_Gp{1,1}.^2 + B_Gp{1,2}.^2 + B_Gp{1,3}.^2)/2;
dum_p12=(Pij_i_Gp{1,1} + Pij_i_Gp{2,2} + Pij_i_Gp{3,3})/3;
dum_p13=(dum_p1 + dum_p12)./1 ;
dum_p1f = medfilt2(dum_p1,filtvec); %filter
dum_p2f = medfilt2(dum_p2,filtvec); %filter
dum_p12f = medfilt2(dum_p12,filtvec); %filter
dum_p13f = medfilt2(dum_p13,filtvec); %filter

%---------
fs=20;
%---------
f9981=figure(9981);
h1=subplot(3,2,1);
dum_p = dum_p13./Pi0;
hc = pcolor(XLL,YLL,dum_p); set(hc,'edgecolor','none')
%contourf(XLL,YLL,dum_p)
caxis([0 1.6])
colorbar
title('$p_{p}/p_{0}$','Interpreter','latex','FontSize',fs);
colormap(h1,jet);
rectangle('Position',[4 5 4 4],'LineWidth',1.5);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
hcb=colorbar; %hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];%ax.XLabel.Position = [5.1, -0.6];    


h1=subplot(3,2,2);
dum_p = dum_p2./Pi0;
hc = pcolor(XLL,YLL,dum_p); set(hc,'edgecolor','none')
%contourf(XLL,YLL,dum_p)
colorbar
caxis([0 1.6])
title('$p_{b}/p_{0}$','Interpreter','latex','FontSize',fs);
colormap(h1,jet);
rectangle('Position',[4 5 4 4],'LineWidth',1.5);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
hcb=colorbar; %hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];%ax.XLabel.Position = [5.1, -0.6];    


h1=subplot(3,2,3);
dum_p=dum_p13+dum_p2;
dum_p=medfilt2(dum_p,filtvec);
dum_p = dum_p./Pi0;
%hc = pcolor(XLL,YLL,dum_p); set(hc,'edgecolor','none')
contourf(XLL,YLL,dum_p)
colorbar
caxis([0 3.5])
title('$(p_{p}+p_{b})/p_{0}$','Interpreter','latex','FontSize',fs);
colormap(h1,jet);
rectangle('Position',[4 5 4 4],'LineWidth',1.5);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
hcb=colorbar; %hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];%ax.XLabel.Position = [5.1, -0.6];    


h1=subplot(3,2,4);
dum_p = dum_p1f./dum_p2f;
%hc = pcolor(XLL,YLL,log(dum_p)); set(hc,'edgecolor','none')
contourf(XLL,YLL,log(dum_p))
caxis([-3 3])
colorbar
%title('log(pe/pb)')
title('$\log(p_{e}/p_{b})$','Interpreter','latex','FontSize',fs);
colormap(h1,BWR);
rectangle('Position',[4 5 4 4],'LineWidth',1.5);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
hcb=colorbar; %hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];%ax.XLabel.Position = [5.1, -0.6];    


h1=subplot(3,2,5);
dum_p = dum_p12f./dum_p2f;
%hc = pcolor(XLL,YLL,log(dum_p)); set(hc,'edgecolor','none')
contourf(XLL,YLL,log(dum_p))
caxis([-3 3])
colorbar
%title('log(pe/pb)')
title('$\log(p_{i}/p_{b})$','Interpreter','latex','FontSize',fs);
colormap(h1,BWR);
rectangle('Position',[4 5 4 4],'LineWidth',1.5);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
hcb=colorbar; %hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];%ax.XLabel.Position = [5.1, -0.6];    


h1=subplot(3,2,6);
dum_p = dum_p13f./dum_p2f;
%hc = pcolor(XLL,YLL,log(dum_p)); set(hc,'edgecolor','none')
contourf(XLL,YLL,log(dum_p))
caxis([-3 3])
colorbar
%title('log(pe/pb)')
title('$\log(p_{p}/p_{b})$','Interpreter','latex','FontSize',fs);
colormap(h1,BWR);
rectangle('Position',[4 5 4 4],'LineWidth',1.5);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
hcb=colorbar; %hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];%ax.XLabel.Position = [5.1, -0.6];    
%---------
fs=25;
%---------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------------------------------------------------
%{
r1 = [1:100]'.*rand(100,1);
figure;
a1 = axes();
plot(a1,r1);
a2 = axes();
a2.Position = [0.3200 0.6600 0.2 0.2]; % xlocation, ylocation, xsize, ysize
plot(a2,r1(50:70)); axis tight
annotation('ellipse',[.2 .3 .2 .2])
annotation('arrow',[.1 .2],[.1 .2])
legend(a1,'u')
%}
%--------------------------------------------------------------------------

% pe, Pi_era, Pi_epa,  
%--------------------------------------------------------------------------
%{
f15=figure(15);
%--------------------------------------------------------------------------
h1=subaxis(1,3,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=(Pij_e_Gp{1,1} + Pij_e_Gp{2,2} + Pij_e_Gp{3,3})/3;
dum_p = dum_p./Pi0;
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,jet); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
caxis([0 0.9]); hcb.Ticks = linspace(0.2,0.8,4); hcb.TickLabels = [0.2,0.4,0.6,0.8] ;  
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.5, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$p_{e}/p_{0}$','Interpreter','latex','FontSize',fs);
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,3,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=(Pij_e_Gp{1,2} + Pij_e_Gp{2,1})/2;  
dum_p = dum_p./Pi0;
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.12,0.12,5); hcb.TickLabels = [-0.12,-0.06,0,0.06,0.12] ; caxis([-0.16 0.16]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\Pi_{ra,e}/p_{0}$','Interpreter','latex','FontSize',fs);
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,3,3,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=(Pij_e_Gp{3,2} + Pij_e_Gp{2,3})/2;  
dum_p = dum_p./Pi0;
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.12,0.12,5); hcb.TickLabels = [-0.12,-0.06,0,0.06,0.12] ; caxis([-0.16 0.16]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\Pi_{pa,e}/p_{0}$','Interpreter','latex','FontSize',fs);
hold off
sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------
%}
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%{
NN52=6; 
xx52 = linspace(xll(10),xll(end-10),NN52);
yy52 = linspace(yll(10),yll(end-10),NN52);
[xx52, yy52] = meshgrid(xx52,yy52);
bbbb5=stream2(XLL,YLL,ubx,vby,xx52,yy52);
bbbb5m=stream2(XLL,YLL,-ubx,-vby,xx52,yy52);
%}
%--------------------------------------------------------------------------

x0=-1562;y0=142;width=1355;height=499; fs=25;
% pe, Pi_era, Pi_epa,  pi_epr
f151=figure(151);
set(gcf,'position',[x0,y0,width,height])
%--------------------------------------------------------------------------
h1=subaxis(1,4,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=(Pij_e_Gp{1,1} + Pij_e_Gp{2,2} + Pij_e_Gp{3,3})/3;
dum_p = dum_p./Pi0;
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,jet); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
caxis([0 0.9]); hcb.Ticks = linspace(0.2,0.8,4); hcb.TickLabels = [0.2,0.4,0.6,0.8] ;  
%%caxis([0 1.6]); hcb.Ticks = linspace(0.4,1.2,3); hcb.TickLabels = [0.4,0.8,1.2] ; 
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$p_{e}/p_{0}$','Interpreter','latex','FontSize',fs);
%rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,4,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=(Pij_e_Gp{1,2} + Pij_e_Gp{2,1})/2;  
dum_p = dum_p./Pi0;
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.12,0.12,5); hcb.TickLabels = [-0.12,-0.06,0,0.06,0.12] ; caxis([-0.16 0.16]); 
%hcb.Ticks = linspace(-0.5,0.5,5); hcb.TickLabels = [-0.5,-0.3,0,0.3,0.5] ; caxis([-0.6 0.6]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\Pi_{ra,e}/p_{0}$','Interpreter','latex','FontSize',fs);
%rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,4,3,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=(Pij_e_Gp{3,2} + Pij_e_Gp{2,3})/2;  
dum_p = dum_p./Pi0;
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.12,0.12,5); hcb.TickLabels = [-0.12,-0.06,0,0.06,0.12] ; caxis([-0.16 0.16]); 
%hcb.Ticks = linspace(-0.5,0.5,5); hcb.TickLabels = [-0.5,-0.3,0,0.3,0.5] ; caxis([-0.6 0.6]);
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\Pi_{pa,e}/p_{0}$','Interpreter','latex','FontSize',fs);
%rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------
h4=subaxis(1,4,4,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=(Pij_e_Gp{3,1} + Pij_e_Gp{1,3})/2;  
dum_p = dum_p./Pi0;
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h4,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.12,0.12,5); hcb.TickLabels = [-0.12,-0.06,0,0.06,0.12] ; caxis([-0.16 0.16]); 
%hcb.Ticks = linspace(-0.3,0.3,5); hcb.TickLabels = [-0.3,-0.1,0,0.1,0.3] ; caxis([-0.3 0.3]);
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\Pi_{pr,e}/p_{0}$','Interpreter','latex','FontSize',fs);
%rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% pe, Pi_era, Pi_epa,  pi_epr
f1512=figure(1512);
set(gcf,'position',[x0,y0,width,height])
%--------------------------------------------------------------------------
h1=subaxis(1,4,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=(Pij_e_Gp{1,1} + Pij_e_Gp{2,2} + Pij_e_Gp{3,3})/3;
dum_p = dum_p./Pi0;
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,jet); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
caxis([0 0.9]); hcb.Ticks = linspace(0.2,0.8,4); hcb.TickLabels = [0.2,0.4,0.6,0.8] ;
%caxis([0 1.6]); hcb.Ticks = linspace(0.4,1.2,3); hcb.TickLabels = [0.4,0.8,1.2] ;
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [5.5 6.5 7.5 8.5]; ax.YLabel.Position = [3.5, 7];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [4.5 5.5 6.5 7.5]; ax.XLabel.Position = [6, 4.75];    
xlim([4 8]); ylim([5 9]);
title('$p_{e}/p_{0}$','Interpreter','latex','FontSize',fs);
%rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,4,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=(Pij_e_Gp{1,2} + Pij_e_Gp{2,1})/2;  
dum_p = dum_p./Pi0;
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.12,0.12,5); hcb.TickLabels = [-0.12,-0.06,0,0.06,0.12] ; caxis([-0.16 0.16]); 
%hcb.Ticks = linspace(-0.5,0.5,5); hcb.TickLabels = [-0.5,-0.3,0,0.3,0.5] ; caxis([-0.6 0.6]);
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [4.5 5.5 6.5 7.5]; ax.XLabel.Position = [6, 4.75];   
xlim([4 8]); ylim([5 9]);
title('$\Pi_{ra,e}/p_{0}$','Interpreter','latex','FontSize',fs);
%rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,4,3,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=(Pij_e_Gp{3,2} + Pij_e_Gp{2,3})/2;  
dum_p = dum_p./Pi0;
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.12,0.12,5); hcb.TickLabels = [-0.12,-0.06,0,0.06,0.12] ; caxis([-0.16 0.16]); 
%hcb.Ticks = linspace(-0.5,0.5,5); hcb.TickLabels = [-0.5,-0.3,0,0.3,0.5] ; caxis([-0.6 0.6]);
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [4.5 5.5 6.5 7.5]; ax.XLabel.Position = [6, 4.75];   
xlim([4 8]); ylim([5 9]);
title('$\Pi_{pa,e}/p_{0}$','Interpreter','latex','FontSize',fs);
%rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------
h4=subaxis(1,4,4,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=(Pij_e_Gp{3,1} + Pij_e_Gp{1,3})/2;  
dum_p = dum_p./Pi0;
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h4,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.12,0.12,5); hcb.TickLabels = [-0.12,-0.06,0,0.06,0.12] ; caxis([-0.16 0.16]); 
%hcb.Ticks = linspace(-0.3,0.3,5); hcb.TickLabels = [-0.3,-0.1,0,0.1,0.3] ; caxis([-0.3 0.3]);
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [4.5 5.5 6.5 7.5]; ax.XLabel.Position = [6, 4.75];   
xlim([4 8]); ylim([5 9]);
title('$\Pi_{pr,e}/p_{0}$','Interpreter','latex','FontSize',fs);
%rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


% pi, Pi_ira, Pi_ipa,  
%{
f16=figure(16);
%--------------------------------------------------------------------------
h1=subaxis(1,3,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=(Pij_i_Gp{1,1} + Pij_i_Gp{2,2} + Pij_i_Gp{3,3})/3;
dum_p = dum_p./Pi0;
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,jet); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
caxis([0 1.6]); hcb.Ticks = linspace(0.4,1.2,3); hcb.TickLabels = [0.4,0.8,1.2] ;  
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.5, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$p_{i}/p_{0}$','Interpreter','latex','FontSize',fs);
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,3,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=(Pij_i_Gp{1,2} + Pij_i_Gp{2,1})/2;  
dum_p = dum_p./Pi0;
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.6,0.6,3); hcb.TickLabels = [-0.6,0,0.6] ; caxis([-0.7 0.7]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\Pi_{ra,i}/p_{0}$','Interpreter','latex','FontSize',fs);
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,3,3,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=(Pij_i_Gp{3,2} + Pij_i_Gp{2,3})/2;  
dum_p = dum_p./Pi0;
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.6,0.6,3); hcb.TickLabels = [-0.6,0,0.6] ; caxis([-0.7 0.7]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\Pi_{pa,i}/p_{0}$','Interpreter','latex','FontSize',fs);
hold off
sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)
%}
%--------------------------------------------------------------------------

% pi, Pi_ira, Pi_ipa, Pi_ipr 
f161=figure(161);
set(gcf,'position',[x0,y0,width,height])
%--------------------------------------------------------------------------
h1=subaxis(1,4,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=(Pij_i_Gp{1,1} + Pij_i_Gp{2,2} + Pij_i_Gp{3,3})/3;
dum_p = dum_p./Pi0;
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,jet); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
caxis([0 1.6]); hcb.Ticks = linspace(0.4,1.2,3); hcb.TickLabels = [0.4,0.8,1.2] ; 
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$p_{i}/p_{0}$','Interpreter','latex','FontSize',fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,4,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=(Pij_i_Gp{1,2} + Pij_i_Gp{2,1})/2;  
dum_p = dum_p./Pi0;
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.5,0.5,5); hcb.TickLabels = [-0.5,-0.3,0,0.3,0.5] ; caxis([-0.6 0.6]);
%hcb.Ticks = linspace(-0.6,0.6,3); hcb.TickLabels = [-0.6,0,0.6] ; caxis([-0.7 0.7]); 
%hcb.Ticks = linspace(-0.12,0.12,5); hcb.TickLabels = [-0.12,-0.06,0,0.06,0.12] ; caxis([-0.16 0.16]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\Pi_{ra,i}/p_{0}$','Interpreter','latex','FontSize',fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,4,3,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=(Pij_i_Gp{3,2} + Pij_i_Gp{2,3})/2;  
dum_p = dum_p./Pi0;
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
%hcb.Ticks = linspace(-0.6,0.6,3); hcb.TickLabels = [-0.6,0,0.6] ; caxis([-0.7 0.7]); 
hcb.Ticks = linspace(-0.5,0.5,5); hcb.TickLabels = [-0.5,-0.3,0,0.3,0.5] ; caxis([-0.6 0.6]);
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\Pi_{pa,i}/p_{0}$','Interpreter','latex','FontSize',fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h4=subaxis(1,4,4,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=(Pij_i_Gp{3,1} + Pij_i_Gp{1,3})/2;  
dum_p = dum_p./Pi0;
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h4,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.3,0.3,5); hcb.TickLabels = [-0.3,-0.1,0,0.1,0.3] ; caxis([-0.3 0.3]);
%hcb.Ticks = linspace(-0.6,0.6,3); hcb.TickLabels = [-0.6,0,0.6] ; caxis([-0.7 0.7]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5.1, -0.6];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\Pi_{pr,i}/p_{0}$','Interpreter','latex','FontSize',fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------


% Checking the densities and pressures
%--------------------------------------------------------------------------
f999=figure(999)
subplot(1,4,1)
dum_p=E_Gp{1,1}.*B_Gp{1,1} + E_Gp{1,2}.*B_Gp{1,2} + E_Gp{1,2}.*B_Gp{1,2};
hc = pcolor(XLL,YLL,dum_p);
set(hc,'edgecolor','none')
colorbar; caxis([-0.003 0.003])
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
title('Epar')
hold off
subplot(1,4,2)
dum_p=E_Gp{1,1};
hc = pcolor(XLL,YLL,dum_p);
set(hc,'edgecolor','none')
colorbar; %caxis([-0.003 0.003])
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
title('Ep')
hold off
subplot(1,4,3)
dum_p=E_Gp{1,2};
hc = pcolor(XLL,YLL,dum_p);
set(hc,'edgecolor','none')
colorbar; %caxis([-0.003 0.003])
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
title('Ea')
hold off
subplot(1,4,4)
dum_p=E_Gp{1,3};
hc = pcolor(XLL,YLL,dum_p);
set(hc,'edgecolor','none')
colorbar; %caxis([-0.003 0.003])
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
title('Er')
hold off

f998=figure(998)
subplot(3,2,1)
dum_p=(Pij_i_Gp{1,1} + Pij_i_Gp{2,2} + Pij_i_Gp{3,3})/3;
dum_p = dum_p./Pi0;
%hc = pcolor(XLL,YLL,dum_p); set(hc,'edgecolor','none')
contourf(XLL,YLL,dum_p)
caxis([0 1.6])
colorbar
title('pi')
subplot(3,2,2)
dum_p=(Pij_e_Gp{1,1} + Pij_e_Gp{2,2} + Pij_e_Gp{3,3})/3;
dum_p = dum_p./Pi0;
%hc = pcolor(XLL,YLL,dum_p); set(hc,'edgecolor','none')
contourf(XLL,YLL,dum_p)
colorbar
caxis([0 1.6])
title('pe')
subplot(3,2,3)
dum_p = ni_Gp{1,1};
%hc = pcolor(XLL,YLL,dum_p); set(hc,'edgecolor','none')
contourf(XLL,YLL,dum_p)
colorbar
caxis([0 2.2])
title('ni')
subplot(3,2,4)
dum_p = ne_Gp{1,1};
%hc = pcolor(XLL,YLL,dum_p); set(hc,'edgecolor','none')
contourf(XLL,YLL,dum_p)
colorbar
caxis([0 2.2])
title('ne')
subplot(3,2,5)
dum_p=(Pij_i_Gp{1,1} + Pij_i_Gp{2,2} + Pij_i_Gp{3,3})/3;
dum_p = dum_p./ni_Gp{1,1};
dum_p=dum_p./Pi0;
%hc = pcolor(XLL,YLL,dum_p); set(hc,'edgecolor','none')
contourf(XLL,YLL,dum_p)
colorbar
caxis([0 0.9])
title('Ti')
subplot(3,2,6)
dum_p=(Pij_e_Gp{1,1} + Pij_e_Gp{2,2} + Pij_e_Gp{3,3})/3;
dum_p = dum_p./ne_Gp{1,1};
dum_p=dum_p./Pi0;
%hc = pcolor(XLL,YLL,dum_p); set(hc,'edgecolor','none')
contourf(XLL,YLL,dum_p)
colorbar
%caxis([0 0.9])
title('Te')

% histograms
f997=figure(997)
subplot(3,2,1)
dum_p=(Pij_i_Gp{1,1} + Pij_i_Gp{2,2} + Pij_i_Gp{3,3})/3;
dum_p=dum_p./Pi0;
histogram(dum_p)
title('pi')
subplot(3,2,2)
dum_p=(Pij_e_Gp{1,1} + Pij_e_Gp{2,2} + Pij_e_Gp{3,3})/3;
dum_p=dum_p./Pi0;
histogram(dum_p)
title('pe')
subplot(3,2,3)
dum_p = ni_Gp{1,1}; 
histogram(dum_p)
title('ni')
subplot(3,2,4)
dum_p = ne_Gp{1,1}; 
histogram(dum_p)
title('ne')
subplot(3,2,5)
dum_p=(Pij_i_Gp{1,1} + Pij_i_Gp{2,2} + Pij_i_Gp{3,3})/3;
dum_p = dum_p./ni_Gp{1,1}; dum_p=dum_p./Pi0;
histogram(dum_p)
title('Ti')
subplot(3,2,6)
dum_p=(Pij_e_Gp{1,1} + Pij_e_Gp{2,2} + Pij_e_Gp{3,3})/3;
dum_p = dum_p./ne_Gp{1,1}; dum_p=dum_p./Pi0;
histogram(dum_p)
title('Te')


f9981=figure(9981)
subplot(2,4,1)
dum_p=(Pij_i_Gp{1,1} + Pij_i_Gp{2,2} + Pij_i_Gp{3,3})/3;
dum_p1i=dum_p./Pi0; histogram(dum_p); title('pi')
subplot(2,4,2)
dum_p=(Pij_i_Gp{1,2} + Pij_i_Gp{2,1})/2;
dum_p2i = dum_p./Pi0; histogram(dum_p); title('pira')
subplot(2,4,3)
dum_p=(Pij_i_Gp{3,2} + Pij_i_Gp{2,3})/2;  
dum_p3i = dum_p./Pi0; histogram(dum_p); title('pipa')
subplot(2,4,4)
dum_p=(Pij_i_Gp{3,1} + Pij_i_Gp{1,3})/2;  
dum_p4i = dum_p./Pi0; histogram(dum_p); title('pipr')
subplot(2,4,5)
dum_p=(Pij_e_Gp{1,1} + Pij_e_Gp{2,2} + Pij_e_Gp{3,3})/3;
dum_p1e=dum_p./Pi0; histogram(dum_p); title('pe')
subplot(2,4,6)
dum_p=(Pij_e_Gp{1,2} + Pij_e_Gp{2,1})/2;
dum_p2e = dum_p./Pi0; histogram(dum_p); title('pera')
subplot(2,4,7)
dum_p=(Pij_e_Gp{3,2} + Pij_e_Gp{2,3})/2;  
dum_p3e = dum_p./Pi0; histogram(dum_p); title('pepa')
subplot(2,4,8)
dum_p=(Pij_e_Gp{3,1} + Pij_e_Gp{1,3})/2;  
dum_p4e = dum_p./Pi0; histogram(dum_p); title('pepr')

% The long tail data
f996=figure(996)
subplot(1,3,1)
dum_p=(Pij_i_Gp{1,1} + Pij_i_Gp{2,2} + Pij_i_Gp{3,3})/3;
dum_p = dum_p./ni_Gp{1,1};
dum_p=dum_p./Pi0;
dum_p1=(dum_p>0.75).*dum_p;
hc = pcolor(XLL,YLL,dum_p1); set(hc,'edgecolor','none')
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
title('Ti')
hold off
subplot(1,3,2)
dum_p=(Pij_e_Gp{1,1} + Pij_e_Gp{2,2} + Pij_e_Gp{3,3})/3;
dum_p = dum_p./ne_Gp{1,1};
dum_p=dum_p./Pi0;
dum_p2=(dum_p>0.35).*dum_p;
hc = pcolor(XLL,YLL,dum_p2); set(hc,'edgecolor','none')
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
title('Te')
hold off
subplot(1,3,3)
dum_p12=dum_p1.*dum_p2;
hc = pcolor(XLL,YLL,dum_p12); set(hc,'edgecolor','none')
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
title('Tie')
hold off
%--------------------------------------------------------------------------



% This is for the filter
filtvec=[3,3]; %The unfiltered one can be seen using [1,1] 
%dum_p = medfilt2(dum_p,filtvec);
% Proxy parameters e  
f17=figure(17);
%--------------------------------------------------------------------------
h1=subaxis(1,3,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=Zernitani_e_Gp{1,1} ;
dum_p = dum_p./(VA2c*Pi0);
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
caxis([-1.5 1.5]); hcb.Ticks = linspace(-1,1,3); hcb.TickLabels = [-1,0,1] ;  
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.5, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{D_{ze}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,3,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=p_theta_e_Gp{1,1};  
dum_p = dum_p./(VA2c*Pi0);
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
caxis([-7 7]); hcb.Ticks = linspace(-6,6,3); hcb.TickLabels = [-6,0,6] ;  
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{p\theta_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,3,3,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=PiD_e_Gp{1,1};  
dum_p = dum_p./(VA2c*Pi0);
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
caxis([-2 2]); hcb.Ticks = linspace(-1,1,3); hcb.TickLabels = [-1,0,1] ;  
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{Pi-D_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
hold off
sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------


% Proxy parameters i  
f18=figure(18);
%--------------------------------------------------------------------------
h1=subaxis(1,3,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=Zernitani_i_Gp{1,1} ;
dum_p = dum_p./(VA2c*Pi0);
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
caxis([-2 2]); hcb.Ticks = linspace(-1,1,3); hcb.TickLabels = [-1,0,1] ;  
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.5, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{D_{zi}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,3,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=p_theta_i_Gp{1,1};  
dum_p = dum_p./(VA2c*Pi0);
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
caxis([-5 5]); hcb.Ticks = linspace(-4,4,3); hcb.TickLabels = [-4,0,4] ;  
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{p\theta_{i}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,3,3,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=PiD_i_Gp{1,1};  
dum_p = dum_p./(VA2c*Pi0);
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
caxis([-1 1]); hcb.Ticks = linspace(-0.5,0.5,3); hcb.TickLabels = [-0.5,0,0.5] ;  
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{Pi-D_{i}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
hold off
sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% This is the one of the kinetic energy terms for electrons. 
%--------------------------------------------------------------------------
f19=figure(19);
%--------------------------------------------------------------------------
h1=subaxis(1,5,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
%dum_p=dtKe_Gp{1,1} + ve_grad_Ke_Gp{1,1}; %dtKe_Gp This is the wrong one!
dum_p = dtKe_in_Gp_2{1,1} + ve_grad_Ke_Gp{1,1};
dum_p=(dum_p)./(VA2c*Pi0);  
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
hcb.Ticks = linspace(-0.5,0.5,5); hcb.TickLabels = [-0.5,-0.3,0,0.3,0.5] ; caxis([-0.7 0.7]);
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.5, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{d\varepsilon^{k}_{e}/dt}{\Delta\varepsilon_{0}} $','Interpreter','latex','FontSize',fs);
%rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,5,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=ve_Div_Pet_Gp{1,1};
dum_p=(dum_p)./(VA2c*Pi0);   
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
%hcb.Ticks = linspace(-7,7,5); hcb.TickLabels = [-7,-3,0,3,7] ; caxis([-8 8]); 
hcb.Ticks = linspace(-5,5,5); hcb.TickLabels = [-5,-3,0,3,5] ; caxis([-6 6]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\mathbf{u}_{e} \cdot \nabla \cdot \overline{\mathbf{P}}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
%rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,5,3,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=Ke_Div_ve_Gp{1,1};
dum_p=(dum_p)./(VA2c*Pi0); 
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.5,0.5,5); hcb.TickLabels = [-0.5,-0.3,0,0.3,0.5] ; caxis([-0.7 0.7]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
%rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
title('$\frac{\varepsilon^{k}_{e} \nabla \cdot \mathbf{u}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
hold off
%--------------------------------------------------------------------------
h4=subaxis(1,5,4,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=-qe_ne_ve_E_Gp{1,1};
dum_p=(dum_p)./(VA2c*Pi0);  
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h4,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-5,5,5); hcb.TickLabels = [-5,-3,0,3,5] ; caxis([-6 6]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
%rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
title('$\frac{-q_{e}n_{e}\mathbf{u}_{e} \cdot \mathbf{E}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
hold off
%--------------------------------------------------------------------------
h5=subaxis(1,5,5,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_pXIe=dtKe_in_Gp_2{1,1} + ve_grad_Ke_Gp{1,1} + ve_Div_Pet_Gp{1,1} + Ke_Div_ve_Gp{1,1} -qe_ne_ve_E_Gp{1,1};    
dum_p=(dum_pXIe)./(VA2c*Pi0); 
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h5,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-12,12,5); hcb.TickLabels = [-12,-6,0,6,12] ; caxis([-13 13]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
%rectangle('Position',[4 5 4 4],'LineWidth',1.5);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
title('$\frac{{\Xi}^{k}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
hold off
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------


% This is the one of the kinetic energy terms for ions. 
%--------------------------------------------------------------------------
f20=figure(20);
%--------------------------------------------------------------------------
h1=subaxis(1,5,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=dtKi_in_Gp_2{1,1} + vi_grad_Ki_Gp{1,1};
dum_p=(dum_p)./(VA2c*Pi0);  
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
hcb.Ticks = linspace(-0.5,0.5,5); hcb.TickLabels = [-0.5,-0.3,0,0.3,0.5] ; caxis([-0.6 0.6]); 
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.5, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{d\varepsilon^{k}_{i}/dt}{\Delta\varepsilon_{0}} $','Interpreter','latex','FontSize',fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,5,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=vi_Div_Pit_Gp{1,1};
dum_p=(dum_p)./(VA2c*Pi0);  
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
hcb.Ticks = linspace(-1,1,5); hcb.TickLabels = [-1,-0.5,0,0.5,1] ; caxis([-1.2 1.2]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\mathbf{u}_{i} \cdot \nabla \cdot \overline{\mathbf{P}}_{i}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,5,3,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=Ki_Div_vi_Gp{1,1};
dum_p=(dum_p)./(VA2c*Pi0);  
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.5,0.5,5); hcb.TickLabels = [-0.5,-0.3,0,0.3,0.5] ; caxis([-0.6 0.6]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\varepsilon^{k}_{i} \nabla \cdot \mathbf{u}_{i}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h4=subaxis(1,5,4,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p= - qi_ni_vi_E_Gp{1,1};
dum_p=(dum_p)./(VA2c*Pi0); 
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h4,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-1,1,5); hcb.TickLabels = [-1,-0.5,0,0.5,1] ; caxis([-1.2 1.2]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{-q_{i}n_{i}\mathbf{u}_{i} \cdot \mathbf{E}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h5=subaxis(1,5,5,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_pXIi=dtKi_in_Gp_2{1,1} + vi_grad_Ki_Gp{1,1} + vi_Div_Pit_Gp{1,1} + Ki_Div_vi_Gp{1,1} -qi_ni_vi_E_Gp{1,1};    
dum_p=(dum_pXIi)./(VA2c*Pi0); 
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h5,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-5,5,5); hcb.TickLabels = [-5,-3,0,3,5] ; caxis([-6 6]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{{\Xi}^{k}_{i}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
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
%--------------------------------------------------------------------------
h1=subaxis(1,5,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=dtUe_in_Gp_2{1,1} + ve_grad_Ue_Gp{1,1};
dum_p=(dum_p)./(VA2c*Pi0); 
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
caxis([-5 5]); hcb.Ticks = linspace(-4,4,5); hcb.TickLabels = [-4,-2,0,2,4] ;  
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.5, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{d\varepsilon^{th}_{e}/dt}{\Delta\varepsilon_{0}} $','Interpreter','latex','FontSize',fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,5,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=dkQiik_05_e_Gp{1,1};
dum_p=(dum_p)./(VA2c*Pi0); 
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.5,0.5,5); hcb.TickLabels = [-0.5,-0.3,0,0.3,0.5] ; caxis([-0.6 0.6]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\nabla \cdot \mathbf{h}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,5,3,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=Pet_grad_ve_Gp{1,1};
dum_p=(dum_p)./(VA2c*Pi0);
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-14,14,5); hcb.TickLabels = [-14,-7.5,0,7.5,14] ; caxis([-15 15]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\nabla \mathbf{u}_{e} : \overline{\mathbf{P}}_{e}}{{\Delta\varepsilon_{0}}}$','Interpreter','latex','FontSize',fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h4=subaxis(1,5,4,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=Ue_Div_ve_Gp{1,1};
dum_p=(dum_p)./(VA2c*Pi0);  
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h4,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-14,14,5); hcb.TickLabels = [-14,-7.5,0,7.5,14] ; caxis([-15 15]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\varepsilon^{th}_{e} \nabla \cdot \mathbf{u}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h5=subaxis(1,5,5,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_pXI2e=dtUe_in_Gp_2{1,1} + ve_grad_Ue_Gp{1,1} + dkQiik_05_e_Gp{1,1} + Pet_grad_ve_Gp{1,1} +...
    Ue_Div_ve_Gp{1,1};% + dum_pXIe;    
dum_p=(dum_pXI2e)./(VA2c*Pi0);  
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h5,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-30,30,5); hcb.TickLabels = [-30,-15,0,15,30] ; caxis([-30 30]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\Xi^{th}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



% This is the one of the thermal energy terms for ionss. 
%--------------------------------------------------------------------------
f22=figure(22);
%--------------------------------------------------------------------------
h1=subaxis(1,5,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=dtUi_in_Gp_2{1,1} + vi_grad_Ui_Gp{1,1};
dum_p=(dum_p)./(VA2c*Pi0);  
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
caxis([-3 3]); hcb.Ticks = linspace(-2,2,5); hcb.TickLabels = [-2,-1,0,1,2] ;  
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.5, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{d\varepsilon^{th}_{i}/dt}{\Delta\varepsilon_{0}} $','Interpreter','latex','FontSize',fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,5,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=dkQiik_05_i_Gp{1,1};
dum_p=(dum_p)./(VA2c*Pi0); 
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-0.2,0.2,5); hcb.TickLabels = [-0.2,-0.1,0,0.1,0.2] ; caxis([-0.2 0.2]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\nabla \cdot \mathbf{h}_{i}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,5,3,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=Pit_grad_vi_Gp{1,1};
dum_p=(dum_p)./(VA2c*Pi0);
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
caxis([-3 3]); hcb.Ticks = linspace(-2,2,5); hcb.TickLabels = [-2,-1,0,1,2] ;  
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\nabla \mathbf{u}_{i} : \overline{\mathbf{P}}_{i}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h4=subaxis(1,5,4,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=Ui_Div_vi_Gp{1,1};
dum_p=(dum_p)./(VA2c*Pi0);    
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
caxis([-3 3]); hcb.Ticks = linspace(-2,2,5); hcb.TickLabels = [-2,-1,0,1,2] ;  
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
%--------------------------------------------------------------------------
h5=subaxis(1,5,5,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_pXI2i=dtUi_in_Gp_2{1,1} + vi_grad_Ui_Gp{1,1} + dkQiik_05_i_Gp{1,1} + Pit_grad_vi_Gp{1,1} +...
    Ui_Div_vi_Gp{1,1};% + dum_pXIi;    
dum_p=(dum_pXI2i)./(VA2c*Pi0); 
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h5,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
%hcb.Ticks = linspace(-20,20,5); hcb.TickLabels = [-20,-10,0,10,20] ; caxis([-22 22]); % for the unfiltered
hcb.Ticks = linspace(-10,10,5); hcb.TickLabels = [-10,-5,0,5,10] ; caxis([-12 12]); % for the unfiltered
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\Xi^{th}_{i}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------

%To check adding the RHS terms on both equations
%--------------------------------------------------------------------------
%
f23=figure(23);
%--------------------------------------------------------------------------
%h1=subaxis(1,1,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p23=(dum_pXI2e)./(VA2c*Pi0) + (dum_pXI2i)./(VA2c*Pi0);
%dum_p=-qe_ne_ve_E_Gp{1,1};
dum_p=J_Gp{1,2};
dum_p=(dum_p)./(VA2c);
%dum_p=(dum_p)./(VA2c*Pi0); 
dum_p23 = medfilt2(dum_p23,filtvec); %filter
%dum_p23 = medfilt2((dum_p23)/max(max(dum_p23)),filtvec); %filter
%hc = pcolor(XLL,YLL,dum_p23);
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%caxis([-55 55]); hcb.Ticks = linspace(-50,50,5); hcb.TickLabels = [-50,-25,0,25,50] ;  
caxis([-2 2]); hcb.Ticks = linspace(-1.8,1.8,5); hcb.TickLabels = [-1.8,-1.4,0,1.4,1.8] ;  
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.5, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
ylim([7,9])
yline(yll(ypc_i),'--k','LineWidth',2)
xline(4,'--k','LineWidth',2)
xline(8,'--k','LineWidth',2)
xline(xll(xpc_i),'--k','LineWidth',2)
%title('$\sum_{s} \frac{0.5 Tr(m_{s}\overline{\mathbf{\Xi}}_{s})}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
%title('$\frac{-q_{e}n_{e}\mathbf{u}_{e} \cdot \mathbf{E}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
title('${J_{a}/J0}$','Interpreter','latex','FontSize',fs);
hold off


%--------------------------------------------------------------------------
% --->  dtE_em_in_Gp_2  Div_Poyn_v_Gp, JdotE    <----- plot of
%--------------------------------------------------------------------------
%
f14=figure(14);
h1=subaxis(1,3,1,'SV',0.01,'SH',0.004,'MR',0.01,'ML',0.05,'PL',0.01,'PR',0.006);
dum_p=dtE_em_in_Gp_2{1,1}./(VA2c*Pi0);  
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside'; %hcb.Ruler.Exponent = -4;
caxis([-0.5 0.5]); hcb.Ticks = linspace(-0.4,0.4,5); hcb.TickLabels = [-0.4,-0.2,0,0.2,0.4] ;  
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%hcb.Ruler.Exponent = -1;
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.5, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5, -0.5];      
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
title('$\frac{d \varepsilon^{em}/dt}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,3,2,'SV',0.01,'SH',0.004,'MR',0.02,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=Div_Poyn_v_Gp{1,1}./(VA2c*Pi0);    
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR);  
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside'; %hcb.Ruler.Exponent = -2;
caxis([-10 10]); hcb.Ticks = linspace(-8,8,5); hcb.TickLabels = [-8,-4,0,4,8] ;  
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5, -0.5];      
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\nabla \cdot \mathbf{S}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,3,3,'SV',0.01,'SH',0.004,'MR',0.02,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=JdotE_Gp{1,1}./(VA2c*Pi0);    
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside'; %hcb.Ruler.Exponent = -2;
caxis([-2.2 2.2]); hcb.Ticks = linspace(-2,2,5); hcb.TickLabels = [-2,-1,0,1,2] ;  
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5, -0.5];      
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\frac{\mathbf{J} \cdot \mathbf{E}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
plot(5.58, 6.6,'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
plot(6.5, 6.2, 'kp', 'MarkerSize',10, 'MarkerFaceColor','k');
hold off
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------
%}



%Banner J 1
f2324=figure(2323);
%--------------------------------------------------------------------------
dum_p=J_Gp{1,2};
dum_p=(dum_p)./(VA2c);
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
caxis([-2 2]); hcb.Ticks = linspace(-1.8,1.8,5); hcb.TickLabels = [-1.8,-1.4,0,1.4,1.8] ;  
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.5, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
ylim([7,9])
yline(yll(ypc_i),'--k','LineWidth',2)
xline(4,'--k','LineWidth',2)
xline(8,'--k','LineWidth',2)
xline(xll(xpc_i),'--k','LineWidth',2)
%title('$\sum_{s} \frac{0.5 Tr(m_{s}\overline{\mathbf{\Xi}}_{s})}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
%title('$\frac{-q_{e}n_{e}\mathbf{u}_{e} \cdot \mathbf{E}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
title('${J_{a}/J0}$','Interpreter','latex','FontSize',fs);
hold off

%Banner J 2
f2324=figure(2324);
%--------------------------------------------------------------------------
dum_p=J_Gp{1,2};
dum_p=(dum_p)./(VA2c);
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
caxis([-2 2]); hcb.Ticks = linspace(-1.8,1.8,5); hcb.TickLabels = [-1.8,-1.4,0,1.4,1.8] ;  
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.5, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
xlim([4,8])
%yline(yll(ypc_i),'--k','LineWidth',2)
yline(6.6,'--k','LineWidth',2)
yline(5,'--k','LineWidth',2)
yline(9,'--k','LineWidth',2)
xline(xll(xpc_i),'--k','LineWidth',2)
%title('$\sum_{s} \frac{0.5 Tr(m_{s}\overline{\mathbf{\Xi}}_{s})}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
%title('$\frac{-q_{e}n_{e}\mathbf{u}_{e} \cdot \mathbf{E}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs);
title('${J_{a}/J0}$','Interpreter','latex','FontSize',fs);
hold off

%}



%--------------------------------------------------------------------------

f33=figure(33)
subplot(1,3,1)
histogram(dum_p23,80);
subplot(1,3,2)
histogram(dum_pXI2e,80);
subplot(1,3,3)
histogram(dum_pXI2i,80);

%To check that they are different third and forth terms on the LHS of
%thermal energy equation
%--------------------------------------------------------------------------
%{
f223=figure(223);
%--------------------------------------------------------------------------
h1=subaxis(1,1,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=Pet_grad_ve_Gp{1,1} - Ue_Div_ve_Gp{1,1};
dum_p=(dum_p)./(VA2c*Pi0); 
dum_p = medfilt2(dum_p,filtvec); %filter
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
caxis([-5 5]); hcb.Ticks = linspace(-10,10,5); hcb.TickLabels = [-10,-5,0,5,10] ;  
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.5, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$\nabla \mathbf{u}_{e} : \overline{\mathbf{P}}_{e} - \varepsilon^{th}_{e} \nabla \cdot \mathbf{u}_{e} $','Interpreter','latex','FontSize',fs);
hold off
%}
%--------------------------------------------------------------------------


%Save the plots
%{
%--------------------------------------------------------------------------
cd '/Volumes/PSC_DiRAC_DATA/Energy_Budget_things/Latest_plots'
%saveas(f14,strcat('Ba_uea_uia_vectors_'+ string(N_steps) +'.png'));
saveas(f14,strcat('Poyting_'+ string(N_steps) +'.png'));
saveas(f146,strcat('Ba_uea_uia_vectors_B_B0_'+ string(N_steps) +'.png'));
%saveas(f15,strcat('pe_PI_e_'+ string(N_steps) +'.png'));
saveas(f1512,strcat('pe_PI_e_2_s_zoom_'+ string(N_steps) +'.png'));
%saveas(f16,strcat('pi_PI_i_'+ string(N_steps) +'.png'));
saveas(f161,strcat('pi_PI_i_2_s_'+ string(N_steps) +'.png'));
saveas(f17,strcat('proxy_para_e_'+ string(N_steps) +'.png'));
saveas(f18,strcat('proxy_para_i_'+ string(N_steps) +'.png'));
saveas(f19,strcat('2kin_enrergy_e_'+ string(N_steps) +'.png'));
saveas(f20,strcat('2kin_enrergy_i_'+ string(N_steps) +'.png'));
saveas(f21,strcat('2ther_enrergy_e_'+ string(N_steps) +'.png'));
saveas(f22,strcat('2ther_enrergy_i_'+ string(N_steps) +'.png'));
saveas(f23,strcat('Ja_banner_'+ string(N_steps) +'.png'));
cd '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
%}

% Clear the figures
%--------------------------------------------------------------------------
%clf(f14); clf(f15); clf(f16); clf(f17); clf(f18); clf(f19); 
%clf(f20); clf(f21); clf(f22);
%--------------------------------------------------------------------------



%Other code lines for even more plots
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%{
%--------------------------------------------------------------------------
asf=3;sv=3;
f1131=figure(1131);
%h1=subplot(1,3,1);
sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}, \ Blines$$','Interpreter','latex','FontSize',20)
h1=subaxis(1,3,1,'SV',0.01,'SH',0.004,'MR',0.02,'ML',0.05,'PL',0.005,'PR',0.006);
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
hold on
h2=quiver(xll(1:sv:end,1:sv:end), yll(1:sv:end,1:sv:end), Vev_x(1:sv:end,1:sv:end), Vev_y(1:sv:end,1:sv:end), 0);
set(h2,'AutoScale','on', 'AutoScaleFactor', asf, 'Color', 'b');
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
xlabel('$$r / d_{i}$$','Interpreter','latex','FontSize',20);
ylabel('$$p / d_{i}$$','Interpreter','latex','FontSize',20);
title('$$u_{e} \ vectors$$','Interpreter','latex','FontSize',20)
set(gca,'XScale','lin','YScale','lin','FontSize',18)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=14;
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];    
hold off
%h2=subplot(1,3,2);
h2=subaxis(1,3,2,'SV',0.01,'SH',0.004,'MR',0.02,'ML',0.05,'PL',0.005,'PR',0.006);
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
hold on
h2=quiver(xll(1:sv:end,1:sv:end), yll(1:sv:end,1:sv:end), Viv_x(1:sv:end,1:sv:end), Viv_y(1:sv:end,1:sv:end), 0);
set(h2,'AutoScale','on', 'AutoScaleFactor', asf, 'Color', 'r');
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
xlabel('$$r / d_{i}$$','Interpreter','latex','FontSize',20);
ylabel('$$p / d_{i}$$','Interpreter','latex','FontSize',20);
title('$$u_{i} \ vectors$$','Interpreter','latex','FontSize',20)
set(gca,'XScale','lin','YScale','lin','FontSize',18)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=14;
ax.YLabel.String = '$''$'; ax.YTick = [];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];    
hold off
%h3=subplot(1,3,3);
h3=subaxis(1,3,3,'SV',0.01,'SH',0.004,'MR',0.02,'ML',0.05,'PL',0.005,'PR',0.006);
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
hold on
h2=quiver(xll(1:sv:end,1:sv:end), yll(1:sv:end,1:sv:end), ubx(1:sv:end,1:sv:end), vby(1:sv:end,1:sv:end), 0);
set(h2,'AutoScale','on', 'AutoScaleFactor', asf, 'Color', 'm');
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
xlabel('$$r / d_{i}$$','Interpreter','latex','FontSize',20);
ylabel('$$p / d_{i}$$','Interpreter','latex','FontSize',20);
title('$$B \ vectors$$','Interpreter','latex','FontSize',20)
set(gca,'XScale','lin','YScale','lin','FontSize',18)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=14;
ax.YLabel.String = '$''$'; ax.YTick = [];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];    
hold off

%--------------------------------------------------------------------------
f13=figure(13);
%--------------------------------------------------------------------------
h1=subaxis(1,5,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=B_Gp{1,2};
dum_p=(dum_p+0.1)./B0;  
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h1,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside'; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
caxis([-1 1]); hcb.Ticks = linspace(-0.8,0.8,5); hcb.TickLabels = [-0.8,-0.4,0,0.4,0.8] ;  
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10]; ax.YLabel.Position = [-0.5, 5];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$(B_{a}-B_{0})/B_{0}$','Interpreter','latex','FontSize',fs);
hold off
%--------------------------------------------------------------------------
h2=subaxis(1,5,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=ve_Gp{1,1}./VA2c;    
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR); 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-4,4,5); hcb.TickLabels = [-4,-2,0,2,4] ; caxis([-5 5]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8]; ax.XLabel.Position = [5, -0.5];   
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$u_{e,p}/v_{A,i}$','Interpreter','latex','FontSize',fs);
hold off
%--------------------------------------------------------------------------
h3=subaxis(1,5,3,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=ve_Gp{1,3}./VA2c;    
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-4,4,5); hcb.TickLabels = [-4,-2,0,2,4] ; caxis([-5 5]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$u_{e,r}/v_{A,i}$','Interpreter','latex','FontSize',fs);
hold off
sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------
h4=subaxis(1,5,4,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=vi_Gp{1,1}./VA2c;    
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h4,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-1,1,5); hcb.TickLabels = [-0.8,-0.4,0,0.4,0.8] ; caxis([-1 1]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$u_{i,r}/v_{A,i}$','Interpreter','latex','FontSize',fs);
hold off
sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)
%--------------------------------------------------------------------------
h5=subaxis(1,5,5,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
dum_p=vi_Gp{1,3}./VA2c;    
hc = pcolor(XLL,YLL,dum_p);
hold on
hlines2=streamline(bbbb5);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
hlines3=streamline(bbbb5m);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
lim_yp=max(max(max(abs(dum_p)))); colormap(h5,BWR); %caxis([-5 5]) 
set(hc,'edgecolor','none')
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Ticks = linspace(-1,1,5); hcb.TickLabels = [-0.8,-0.4,0,0.4,0.8] ; caxis([-1 1]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
%hcb.Ruler.Exponent = -1;
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
%ax.YLabel.String = '$p / d_{i}$'; ax.YTick = [2 4 6 8 10];
ax.XLabel.String = '$r / d_{i}$'; ax.XTick = [2 4 6 8];ax.XLabel.Position = [5, -0.5];    
xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);
title('$u_{i,r}/v_{A,i}$','Interpreter','latex','FontSize',fs);
hold off
sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',fs)

%}

%--------------------------------------------------------------------------