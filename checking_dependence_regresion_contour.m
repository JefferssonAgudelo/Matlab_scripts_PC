% Example data
%X = randn(10000,1); 
%Y = randn(10000,1); 
% (Use your own X and Y)



%{
nbins = 80; % Adjust number of bins for resolution
nl =4;
fs=20; x0=45;y0=54;xx1=1200;yy1=700;
f3=figure(3);
set(gcf,'position',[x0,y0,xx1,yy1])
%-----------------------------------------------------------------------
subplot(2,2,1)
xx=J_scatter_x;
yy= var_tau_total_x/max(abs(var_tau_total_x));
scatter(xx,yy,'.r')
hold on;
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'k', 'LineWidth', 2); % 20 levels
hold off

subplot(2,2,2)
xx=J_scatter_y;
yy= var_tau_total_y/max(abs(var_tau_total_y));
scatter(xx,yy,'.b')
hold on;
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'k','LineWidth', 2); % 20 levels
hold off

subplot(2,2,3)
xx=J_scatter_z;
yy= var_tau_total_z/max(abs(var_tau_total_z));
scatter(xx,yy,'.c')
hold on;
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'k','LineWidth', 2); % 20 levels
hold off

subplot(2,2,4)
xx=J_mag_scatter;
yy= var_tau_total/max(abs(var_tau_total));
scatter(xx,yy,'.k')
hold on;
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'm','LineWidth', 2); % 20 levels
hold off

set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\Sigma \tau_i$','Interpreter','latex')
xlabel('$J_i$')
%legend('$x$','$y$','$z$','$mag$','Interpreter','latex','NumColumns',4,'Location','northoutside')
hold off


nbins = 80; % Adjust number of bins for resolution
nl =4;
fs=20; x0=45;y0=54;xx1=1200;yy1=700;
f336=figure(336);
set(gcf,'position',[x0,y0,xx1,yy1])
%-----------------------------------------------------------------------
subplot(2,3,1)
xx=J_scatter_x;
yy= var_tau_total_x/max(abs(var_tau_total_x));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
hold on;
xx=J_scatter_y;
yy= var_tau_total_y/max(abs(var_tau_total_y));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'b','LineWidth', 2); % 20 levels
xx=J_scatter_z;
yy= var_tau_total_z/max(abs(var_tau_total_z));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'c','LineWidth', 2); % 20 levels
xx=J_mag_scatter;
yy= var_tau_total/max(abs(var_tau_total));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'k','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\Sigma \tau_i$','Interpreter','latex')
xlabel('$J_i$')
legend('$x$','$y$','$z$','$mag$','Interpreter','latex','NumColumns',4,'Location','northoutside')
hold off
%-----------------------------------------------------------------------
subplot(2,3,2)
xx=B_scatter_x;
yy= var_tau_total_x/max(abs(var_tau_total_x));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
hold on;
xx=B_scatter_y;
yy= var_tau_total_y/max(abs(var_tau_total_y));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'b','LineWidth', 2); % 20 levels
xx=B_scatter_z;
yy= var_tau_total_z/max(abs(var_tau_total_z));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'c','LineWidth', 2); % 20 levels
xx=B_mag_scatter;
yy= var_tau_total/max(abs(var_tau_total));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'k','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\Sigma \tau_i$','Interpreter','latex')
xlabel('$B_i$')
legend('$x$','$y$','$z$','$mag$','Interpreter','latex','NumColumns',4,'Location','northoutside')
hold off
%-----------------------------------------------------------------------
subplot(2,3,3)
xx=vort_scatter_x;
yy= var_tau_total_x/max(abs(var_tau_total_x));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
hold on;
xx=vort_scatter_y;
yy= var_tau_total_y/max(abs(var_tau_total_y));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'b','LineWidth', 2); % 20 levels
xx=vort_scatter_z;
yy= var_tau_total_z/max(abs(var_tau_total_z));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'c','LineWidth', 2); % 20 levels
xx=vort_mag_scatter;
yy= var_tau_total/max(abs(var_tau_total));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'k','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\Sigma \tau_i$','Interpreter','latex')
xlabel('$\Omega_i$')
legend('$x$','$y$','$z$','$mag$','Interpreter','latex','NumColumns',4,'Location','northoutside')
hold off
%-----------------------------------------------------------------------
subplot(2,3,4)
xx=v_scatter_x;
yy= var_tau_total_x/max(abs(var_tau_total_x));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
hold on;
xx=v_scatter_y;
yy= var_tau_total_y/max(abs(var_tau_total_y));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'b','LineWidth', 2); % 20 levels
xx=v_scatter_z;
yy= var_tau_total_z/max(abs(var_tau_total_z));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'c','LineWidth', 2); % 20 levels
xx=v_mag_scatter;
yy= var_tau_total/max(abs(var_tau_total));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'k','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\Sigma \tau_i$','Interpreter','latex')
xlabel('$u_i$')
legend('$x$','$y$','$z$','$mag$','Interpreter','latex','NumColumns',4,'Location','northoutside')
hold off
%-----------------------------------------------------------------------
subplot(2,3,5)
xx=E_scatter_x;
yy= var_tau_total_x/max(abs(var_tau_total_x));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
hold on;
xx=E_scatter_y;
yy= var_tau_total_y/max(abs(var_tau_total_y));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'b','LineWidth', 2); % 20 levels
xx=E_scatter_z;
yy= var_tau_total_z/max(abs(var_tau_total_z));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'c','LineWidth', 2); % 20 levels
xx=E_mag_scatter;
yy= var_tau_total/max(abs(var_tau_total));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'k','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\Sigma \tau_i$','Interpreter','latex')
xlabel('$E_i$')
legend('$x$','$y$','$z$','$mag$','Interpreter','latex','NumColumns',4,'Location','northoutside')
hold off
%-----------------------------------------------------------------------
subplot(2,3,6)
xx=n_scatter;
yy= var_tau_total_x/max(abs(var_tau_total_x));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
hold on;
xx=n_scatter;
yy= var_tau_total_y/max(abs(var_tau_total_y));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'b','LineWidth', 2); % 20 levels
xx=n_scatter;
yy= var_tau_total_z/max(abs(var_tau_total_z));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'c','LineWidth', 2); % 20 levels
xx=n_scatter;
yy= var_tau_total/max(abs(var_tau_total));
X=xx; Y=yy;
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'k','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$\Sigma \tau_i$','Interpreter','latex')
xlabel('$n$')
legend('$x$','$y$','$z$','$mag$','Interpreter','latex','NumColumns',4,'Location','northoutside')
hold off

%}

% % % X=xx;
% % % Y=yy;
% % % % Define grid
% % % nbins = 100; % Adjust number of bins for resolution
% % % xedges = linspace(min(X), max(X), nbins);
% % % yedges = linspace(min(Y), max(Y), nbins);
% % % % Compute 2D histogram
% % % [N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
% % % % Convert bin centers
% % % xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
% % % ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
% % % contour(xcenters, ycenters, N', 3, 'LineColor', 'black'); % 20 levels



%--------------------------------------------------------------------------
cd('~/Downloads/New_images_may')
% %load("beta025_scatter.mat")
% %load("beta1_scatter.mat")
% %load("beta4_scatter.mat")
% 
%load("beta025_scatter_KJHBWO_time4.mat")

load("beta025_scatter_KJHBWOgradndivPi_time4_AN32.mat")
% %load("beta1_scatter_KJHBWO_time6.mat")
% %load("beta4_scatter_KJHBWO.mat")
%--------------------------------------------------------------------------



% This part is to check linear regrression dependence
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%
% this is for the multilinear regression
% % % x component
% % X = [J_scatter_x', B_scatter_x',vort_scatter_x', v_scatter_x',E_scatter_x', n_scatter'];
% % Y = var_tau_total_x';
% % 
% % % y component
% % X = [J_scatter_y', B_scatter_y',vort_scatter_y', v_scatter_y',E_scatter_y', n_scatter'];
% % Y = var_tau_total_y';
% % 
% % % z component
% % X = [J_scatter_z', HB_scatter_z',vort_scatter_z', v_scatter_z',E_scatter_z', n_scatter'];
% % Y = var_tau_total_z';


% This is to check each of the components of Tau depending on each linear
% combination of the same components
%--------------------------------------------------------------------------
% x component
X = [KJ_scatter_x', HB_scatter_x',Wvort_scatter_x'];
Y = var_tau_total_x';
%X = [KJ_scatter_x', HB_scatter_x',Wvort_scatter_x'];

% y component
%X = [KJ_scatter_y', HB_scatter_y',Wvort_scatter_y'];
%Y = var_tau_total_y';

% z component
%X = [KJ_scatter_z', (KJ_scatter_z.^2)',Wvort_scatter_z'];
%Y = var_tau_total_z';
%--------------------------------------------------------------------------



% This is to check each of the components of Tau depending on each linear
% combination of ALL the components
%--------------------------------------------------------------------------
% x component
%X = [KJ_scatter_x', HB_scatter_x',Wvort_scatter_x',KJ_scatter_y', HB_scatter_y',Wvort_scatter_y',KJ_scatter_z', HB_scatter_z',Wvort_scatter_z'];
%Y = var_tau_total_x';

% y component
%X = [KJ_scatter_y', HB_scatter_y',Wvort_scatter_y'];
%Y = var_tau_total_y';

% z component
%X = [KJ_scatter_z', (KJ_scatter_z.^2)',Wvort_scatter_z'];
%Y = var_tau_total_z';
%--------------------------------------------------------------------------


% To make the analysis 
% Remove outlayers IS NOT A GOOD IDEA AS THE VALUES REFLECT DIFFERENT
% POPULLATIONS NOT ERRORS
% Do the regression considering the coefficients erros and checking the significance of statistically different from zero  
%{
%--------------------------------------------------------------------------
nbins=80;
xx=KJ_scatter_y;
yy=HB_scatter_y;
% remove outlayers in one and in the other 
%xx = [1,2,2,2,2,2,20,2,2,2,2];
pct_l = 1; pct_u = 99;

% these returns the outlayers 
[KJ_scatter_x_B,TFrm_x] = rmoutliers(KJ_scatter_x,"percentiles",[pct_l pct_u]);
[HB_scatter_x_B,TFrm_y] = rmoutliers(HB_scatter_x,"percentiles",[pct_l pct_u]);

%TFrm_x2 = ~TFrm_x; xx_2 = xx.*TFrm_x2.*TFrm_y2;
%TFrm_y2 = ~TFrm_y; yy_2 = yy.*TFrm_x2.*TFrm_y2;

f3=figure(3);
scatter(xx,yy)
hold on
scatter(xx_B,yy_B)
hold off

XX=xx_B/max(abs(xx_B)) ; YY=(yy_B)/max(abs(yy_B));

%XX=xx/max(abs(xx)) ; YY=(yy)/max(abs(yy));

%XX=(xx - mean(xx))/max(xx - mean(xx)) ; YY=(yy - mean(yy))/max(yy - mean(yy));


% Binning the data for the analysis is not a good idea. Maybe it is good
% just for the visualization.  <-----
%--------------------------------------------------------------------------
xedges = linspace(min(XX), max(XX), nbins);
yedges = linspace(min(YY), max(YY), nbins);
[N, xedges, yedges] = histcounts2(XX, YY, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
%--------------------------------------------------------------------------

f4=figure(4);
subplot(1,3,1)
contourf(N', 5, 'LineColor', 'none','LineWidth', 1); % 20 levels

%B = rmoutliers(N);
%B = rmoutliers(N,"percentiles",[10 90]);
[B,TFrm] = rmoutliers(N,"percentiles",[20 90]);
C= N.*~TFrm;

nl=20;
f3=figure(3);
subplot(1,3,1)
scatter(XX,YY)
subplot(1,3,2)
%contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
contour(N', nl, 'LineColor', 'r','LineWidth', 1); % 20 levels
subplot(1,3,3)
contour(C', nl, 'LineColor', 'k','LineWidth', 1); % 20 levels
%--------------------------------------------------------------------------
%}


X = [J_scatter_x', B_scatter_x',vort_scatter_x'];
Y = var_tau_total_x';

X = [KJ_scatter_x', HB_scatter_x',Wvort_scatter_x'];
Y = var_tau_total_x';
%--------------------------------------------------------------------------
% Check rank
r = rank(X);
nVars = size(X, 2);  % Should be 6

% Output result
if r == nVars
    disp('✅ The variables X1 to X6 are linearly independent.');
else
    disp('❌ The variables X1 to X6 are linearly dependent.');
    fprintf('Rank is %d < %d (number of variables).\n', r, nVars);
end


% --- QR decomposition ---
[Q, R] = qr(X, 0);  % Economy-size QR

% --- Check for linear dependence using the diagonal of R ---
tol = 1e-12;  % Tolerance for numerical precision
diagonalR = abs(diag(R));

fprintf('QR diagonal values:\n');
disp(diagonalR);

% Determine which columns are linearly independent
independentCols = find(diagonalR > tol);
dependentCols   = find(diagonalR <= tol);

% --- Display result ---
if length(independentCols) == size(X, 2)
    disp('✅ All variables X1 to X6 are linearly independent.');
else
    disp('❌ Some variables are linearly dependent.');
    fprintf('Linearly independent variables: X%d\n', independentCols);
    fprintf('Linearly dependent variables: X%d\n', dependentCols);
end

% Suppose X is an n x 6 matrix (6 independent variables)
% and Y is an n x 1 column vector (dependent variable)
% Step 1: Add intercept term (column of ones)
X_aug = [ones(size(X,1), 1), X];  % Now X_aug is n x 7
% Step 2: Compute regression coefficients (a0 to a6)
coeffs = (X_aug' * X_aug) \ (X_aug' * Y);  % 7 x 1 vector
% Step 3: Make predictions
Y_pred = X_aug * coeffs;
% Optional: Display results
disp('Intercept (a0) and coefficients (a1 to a6):');
disp(coeffs);
% Optional: Compute R²
residuals = Y - Y_pred;
SS_res = sum(residuals.^2);
SS_tot = sum((Y - mean(Y)).^2);
R_squared = 1 - SS_res / SS_tot;
fprintf('R-squared: %.4f\n', R_squared);
%--------------------------------------------------------------------------

%Lets make the plots for the prediction and the residuals to see
%--------------------------------------------------------------------------
% % f24=figure(24)
% % subplot(1,2,1)
% % %plot(residuals,'*')
% % scatterhistogram(residuals)
% % title('residuals')
% % subplot(1,2,2)
% % histogram(residuals)
% % title('Residuals')
% % %--------------------------------------------------------------------------
% % 
% % 
% % tbl = table(residuals,xx_x',yy_y');
% % s = scatterhistogram(tbl,'Var2','Var3');
% % xlabel('Age')
% % ylabel('Smoker')


%}
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


% % % yy_x = var_tau_total_x;
% % % yy_y = var_tau_total_y;
% % % yy_z = var_tau_total_z;
% % % yy_mag = var_tau_total;

%yy_x = E_scatter_x;
%yy_y = E_scatter_y;
%yy_z = E_scatter_z;
%yy_mag = E_mag_scatter;

% yy_x = n_scatter;
% yy_y = n_scatter;
% yy_z = n_scatter;
% yy_mag = n_scatter;

%yy_x = v_scatter_y;
%yy_y = v_scatter_y;
%yy_z = v_scatter_y;
%yy_mag = v_scatter_y;

% % f337_v = Make_plot_dependence(J_scatter_x,J_scatter_y,J_scatter_z,J_mag_scatter,...
% %     B_scatter_x,B_scatter_y,B_scatter_z,B_mag_scatter,...
% %     vort_scatter_x,vort_scatter_y,vort_scatter_z,vort_mag_scatter,...
% %     v_scatter_x,v_scatter_y,v_scatter_z,v_mag_scatter,...
% %     E_scatter_x,E_scatter_y,E_scatter_z,E_mag_scatter,...
% %     n_scatter,...
% %     yy_x,yy_y,yy_z,yy_mag);
% % 
% % f338_v = Make_plot_dependence2(J_scatter_x,J_scatter_y,J_scatter_z,J_mag_scatter,...
% %     B_scatter_x,B_scatter_y,B_scatter_z,B_mag_scatter,...
% %     vort_scatter_x,vort_scatter_y,vort_scatter_z,vort_mag_scatter,...
% %     v_scatter_x,v_scatter_y,v_scatter_z,v_mag_scatter,...
% %     E_scatter_x,E_scatter_y,E_scatter_z,E_mag_scatter,...
% %     n_scatter,...
% %     yy_x,yy_y,yy_z,yy_mag);

%saveas(f338_v,strcat(num2str(i),'total_tau_dependence_xyzmag_beta025_3_contour_vy.png'));


ylabx = '$\Sigma\tau_x$';
ylaby = '$\Sigma\tau_y$';
ylabz = '$\Sigma\tau_z$';
yy_x = var_tau_total_x;
yy_y = var_tau_total_y;
yy_z = var_tau_total_z;

%yy_x = E_scatter_x;
%yy_y = E_scatter_y;
%yy_z = E_scatter_z;

%ylabx = '$E_{x}$';
%ylaby = '$E_{y}$';
%ylabz = '$E_{z}$';

xlabx = '$W\Omega_{x}$';
xlaby = '$W\Omega_{y}$';
xlabz = '$W\Omega_{z}$';
xx_x = Wvort_scatter_x;
xx_y = Wvort_scatter_y;
xx_z = Wvort_scatter_z;



f339_v = Make_plot_dependence3(xx_x,xx_y,xx_z,...
    yy_x,yy_y,yy_z, xlabx,xlaby,xlabz,ylabx,ylaby,ylabz);







% Defining the functions
%--------------------------------------------------------------------------
function[f337] =  Make_plot_dependence(J_scatter_x,J_scatter_y,J_scatter_z,J_mag_scatter,...
    B_scatter_x,B_scatter_y,B_scatter_z,B_mag_scatter,...
    vort_scatter_x,vort_scatter_y,vort_scatter_z,vort_mag_scatter,...
    v_scatter_x,v_scatter_y,v_scatter_z,v_mag_scatter,...
    E_scatter_x,E_scatter_y,E_scatter_z,E_mag_scatter,...
    n_scatter,...
    yy_x,yy_y,yy_z,yy_mag)

nbins = 80; % Adjust number of bins for resolution
nl =4;
xlimit=0.7; ylimit=0.7;
flag1 = 1; % 0 for no average substracting, 1 for average substracting
fs=20; x0=45;y0=54;xx1=1200;yy1=700;

f337=figure(337);
set(gcf,'position',[x0,y0,xx1,yy1])
%-----------------------------------------------------------------------
subplot(2,3,1)
xx=J_scatter_x;
yy=yy_x;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
hold on;
xx=J_scatter_y;
yy=yy_y;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'b','LineWidth', 2); % 20 levels
xx=J_scatter_z;
yy=yy_z;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'c','LineWidth', 2); % 20 levels
xx=J_mag_scatter;
yy=yy_mag;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'k','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$F_i$','Interpreter','latex')
xlabel('$J_i$','Interpreter','latex')
legend('$x$','$y$','$z$','$mag$','Interpreter','latex','NumColumns',4,'Location','northoutside')
pbaspect([1 1 1])
xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]);
hold off
%-----------------------------------------------------------------------
subplot(2,3,2)
xx=B_scatter_x;
yy=yy_x;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
hold on;
xx=B_scatter_y;
yy=yy_y;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'b','LineWidth', 2); % 20 levels
xx=B_scatter_z;
yy=yy_z;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'c','LineWidth', 2); % 20 levels
xx=B_mag_scatter;
yy=yy_mag;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'k','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$F_i$','Interpreter','latex')
xlabel('$B_i$','Interpreter','latex')
legend('$x$','$y$','$z$','$mag$','Interpreter','latex','NumColumns',4,'Location','northoutside')
pbaspect([1 1 1])
xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]);
hold off
%-----------------------------------------------------------------------
subplot(2,3,3)
xx=vort_scatter_x;
yy=yy_x;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
hold on;
xx=vort_scatter_y;
yy=yy_y;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'b','LineWidth', 2); % 20 levels
xx=vort_scatter_z;
yy=yy_z;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'c','LineWidth', 2); % 20 levels
xx=vort_mag_scatter;
yy=yy_mag;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'k','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$F_i$','Interpreter','latex')
xlabel('$\Omega_i$','Interpreter','latex')
legend('$x$','$y$','$z$','$mag$','Interpreter','latex','NumColumns',4,'Location','northoutside')
pbaspect([1 1 1])
xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]);
hold off
%-----------------------------------------------------------------------
subplot(2,3,4)
xx=v_scatter_x;
yy=yy_x;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
hold on;
xx=v_scatter_y;
yy=yy_y;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'b','LineWidth', 2); % 20 levels
xx=v_scatter_z;
yy=yy_z;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'c','LineWidth', 2); % 20 levels
xx=v_mag_scatter;
yy=yy_mag;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'k','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$F_i$','Interpreter','latex')
xlabel('$v_i$','Interpreter','latex')
legend('$x$','$y$','$z$','$mag$','Interpreter','latex','NumColumns',4,'Location','northoutside')
pbaspect([1 1 1])
xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]);
hold off
%-----------------------------------------------------------------------
subplot(2,3,5)
xx=E_scatter_x;
yy=yy_x;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
hold on;
xx=E_scatter_y;
yy=yy_y;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'b','LineWidth', 2); % 20 levels
xx=E_scatter_z;
yy=yy_z;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'c','LineWidth', 2); % 20 levels
xx=E_mag_scatter;
yy=yy_mag;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'k','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$F_i$','Interpreter','latex')
xlabel('$E_i$','Interpreter','latex')
legend('$x$','$y$','$z$','$mag$','Interpreter','latex','NumColumns',4,'Location','northoutside')
pbaspect([1 1 1])
xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]);
hold off
%-----------------------------------------------------------------------
subplot(2,3,6)
xx=n_scatter;
yy=yy_x;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
hold on;
xx=n_scatter;
yy=yy_y;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'b','LineWidth', 2); % 20 levels
xx=n_scatter;
yy=yy_z;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'c','LineWidth', 2); % 20 levels
xx=n_scatter;
yy=yy_mag;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'k','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$F_i$','Interpreter','latex')
xlabel('$n$','Interpreter','latex')
legend('$x$','$y$','$z$','$mag$','Interpreter','latex','NumColumns',4,'Location','northoutside')
pbaspect([1 1 1])
xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]);
hold off
%-----------------------------------------------------------------------
end



function[f338] =  Make_plot_dependence2(J_scatter_x,J_scatter_y,J_scatter_z,J_mag_scatter,...
    B_scatter_x,B_scatter_y,B_scatter_z,B_mag_scatter,...
    vort_scatter_x,vort_scatter_y,vort_scatter_z,vort_mag_scatter,...
    v_scatter_x,v_scatter_y,v_scatter_z,v_mag_scatter,...
    E_scatter_x,E_scatter_y,E_scatter_z,E_mag_scatter,...
    n_scatter,...
    yy_x,yy_y,yy_z,yy_mag)

nbins = 80; % Adjust number of bins for resolution
nl =4;
xlimit=0.7; ylimit=0.7;
flag1 = 1; % 0 for no average substracting, 1 for average substracting
fs=20; x0=45;y0=54;xx1=1200;yy1=700;

f338=figure(338);
set(gcf,'position',[x0,y0,xx1,yy1])
%-----------------------------------------------------------------------
subplot(6,4,1)

xx=J_scatter_x;
yy=yy_x;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$\Sigma\tau_x$','Interpreter','latex'); 
ylabel('$J$','Interpreter','latex');
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]); xline(0,'--k');yline(0,'--k');

subplot(6,4,2)

xx=J_scatter_y;
yy=yy_y;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'b','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$\Sigma\tau_y$','Interpreter','latex'); 
%xlabel('$J_y$','Interpreter','latex');
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

subplot(6,4,3)

xx=J_scatter_z;
yy=yy_z;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'c','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$\Sigma\tau_z$','Interpreter','latex'); 
%xlabel('$J_z$','Interpreter','latex');
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

subplot(6,4,4)

xx=J_mag_scatter;
yy=yy_mag;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'k','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$|\Sigma\tau|$','Interpreter','latex'); 
%xlabel('$|J|$','Interpreter','latex')
pbaspect([1 1 1])
xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

%-----------------------------------------------------------------------
subplot(6,4,5)

xx=B_scatter_x;
yy=yy_x;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$\Sigma\tau_x$','Interpreter','latex'); 
ylabel('$B$','Interpreter','latex')
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

subplot(6,4,6)

xx=B_scatter_y;
yy=yy_y;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'b','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$\Sigma\tau_y$','Interpreter','latex'); 
%xlabel('$B_y$','Interpreter','latex')
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

subplot(6,4,7)

xx=B_scatter_z;
yy=yy_z;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'c','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$\Sigma\tau_z$','Interpreter','latex'); 
%xlabel('$B_z$','Interpreter','latex')
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

subplot(6,4,8)

xx=B_mag_scatter;
yy=yy_mag;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'k','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$|\Sigma\tau|$','Interpreter','latex'); 
%xlabel('$|B|$','Interpreter','latex')
pbaspect([1 1 1])
xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

%-----------------------------------------------------------------------
subplot(6,4,9)
xx=vort_scatter_x;
yy=yy_x;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$\Sigma\tau_x$','Interpreter','latex'); 
ylabel('$\Omega$','Interpreter','latex')
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

subplot(6,4,10)

xx=vort_scatter_y;
yy=yy_y;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'b','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$\Sigma\tau_y$','Interpreter','latex'); 
%xlabel('$\Omega_y$','Interpreter','latex')
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

subplot(6,4,11)

xx=vort_scatter_z;
yy=yy_z;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'c','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$\Sigma\tau_z$','Interpreter','latex'); 
%xlabel('$\Omega_z$','Interpreter','latex')
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

subplot(6,4,12)

xx=vort_mag_scatter;
yy=yy_mag;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'k','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$|\Sigma\tau|$','Interpreter','latex'); 
%xlabel('$|\Omega|$','Interpreter','latex')
pbaspect([1 1 1])
xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

%-----------------------------------------------------------------------
subplot(6,4,13)

xx=v_scatter_x;
yy=yy_x;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$\Sigma\tau_x$','Interpreter','latex'); 
ylabel('$u_{i}$','Interpreter','latex')
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

subplot(6,4,14)

xx=v_scatter_y;
yy=yy_y;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'b','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$\Sigma\tau_y$','Interpreter','latex'); 
%xlabel('$u_{iy}$','Interpreter','latex')
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

subplot(6,4,15)

xx=v_scatter_z;
yy=yy_z;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'c','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$\Sigma\tau_z$','Interpreter','latex'); 
%xlabel('$u_{iz}$','Interpreter','latex')
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

subplot(6,4,16)

xx=v_mag_scatter;
yy=yy_mag;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'k','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$|\Sigma\tau|$','Interpreter','latex'); 
%xlabel('$|u_{i}|$','Interpreter','latex')
pbaspect([1 1 1])
xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');
hold off
%-----------------------------------------------------------------------
subplot(6,4,17)

xx=E_scatter_x;
yy=yy_x;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$\Sigma\tau_x$','Interpreter','latex'); 
ylabel('$E$','Interpreter','latex')
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

subplot(6,4,18)

xx=E_scatter_y;
yy=yy_y;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'b','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$\Sigma\tau_y$','Interpreter','latex'); 
%xlabel('$E_y$','Interpreter','latex')
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

subplot(6,4,19)

xx=E_scatter_z;
yy=yy_z;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'c','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$\Sigma\tau_z$','Interpreter','latex'); 
%xlabel('$E_z$','Interpreter','latex')
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

subplot(6,4,20)

xx=E_mag_scatter;
yy=yy_mag;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'k','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$|\Sigma\tau|$','Interpreter','latex'); 
%xlabel('$|E|$','Interpreter','latex')
pbaspect([1 1 1])
xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');
hold off
%-----------------------------------------------------------------------
subplot(6,4,21)

xx=n_scatter;
yy=yy_x;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel('$n$','Interpreter','latex'); 
xlabel('$x$','Interpreter','latex')
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

subplot(6,4,22)

xx=n_scatter;
yy=yy_y;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'b','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$\Sigma\tau_y$','Interpreter','latex'); 
xlabel('$y$','Interpreter','latex')
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

subplot(6,4,23)

xx=n_scatter;
yy=yy_z;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'c','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$\Sigma\tau_z$','Interpreter','latex'); 
xlabel('$z$','Interpreter','latex')
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

subplot(6,4,24)

xx=n_scatter;
yy=yy_mag;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'k','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
%ylabel('$|\Sigma\tau|$','Interpreter','latex'); 
xlabel('$||$','Interpreter','latex')
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]); yticks([]); xline(0,'--k');yline(0,'--k');
hold off
%-----------------------------------------------------------------------
end






function[f339] =  Make_plot_dependence3(xx_x,xx_y,xx_z,...
    yy_x,yy_y,yy_z,xlabx,xlaby,xlabz,ylabx,ylaby,ylabz)


nbins = 80; % Adjust number of bins for resolution
nl =6;
xlimit=0.5; ylimit=0.5;

flag1 = 1; % 0 for no average substracting, 1 for average substracting

fs=20; x0=45;y0=54;xx1=1200;yy1=700;

f339=figure(339);
set(gcf,'position',[x0,y0,xx1,yy1])
%-----------------------------------------------------------------------
subplot(3,3,1)

xx=xx_x;
yy=yy_x;
%flag1 = 1;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel(ylabx,'Interpreter','latex'); 
xlabel(xlabx,'Interpreter','latex');
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]); xline(0,'--k');yline(0,'--k');

subplot(3,3,2)

xx=xx_y;
yy=yy_x;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'b','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel(ylabx,'Interpreter','latex'); 
xlabel(xlaby,'Interpreter','latex');
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

subplot(3,3,3)

xx=xx_z;
yy=yy_x;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'c','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel(ylabx,'Interpreter','latex'); 
xlabel(xlabz,'Interpreter','latex');
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');


%-----------------------------------------------------------------------
subplot(3,3,4)

xx=xx_x;
yy=yy_y;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel(ylaby,'Interpreter','latex'); 
xlabel(xlabx,'Interpreter','latex');
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]); xline(0,'--k');yline(0,'--k');

subplot(3,3,5)

xx=xx_y;
yy=yy_y;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'b','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel(ylaby,'Interpreter','latex'); 
xlabel(xlaby,'Interpreter','latex');
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

subplot(3,3,6)

xx=xx_z;
yy=yy_y;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'c','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel(ylaby,'Interpreter','latex'); 
xlabel(xlabz,'Interpreter','latex');
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');


%-----------------------------------------------------------------------
subplot(3,3,7)

xx=xx_x;
yy=yy_z;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'r','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel(ylabz,'Interpreter','latex'); 
xlabel(xlabx,'Interpreter','latex');
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]); xline(0,'--k');yline(0,'--k');

subplot(3,3,8)

xx=xx_y;
yy=yy_z;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'b','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel(ylabz,'Interpreter','latex'); 
xlabel(xlaby,'Interpreter','latex');
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');

subplot(3,3,9)

% % f3=figure(3)
% % xx=xx_z;
% % yy=yy_z;
% % %X=xx/max(xx); Y=yy/max(yy);
% % X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
% % scatter(X,Y,'.r')

xx=xx_z;
yy=yy_z;
if (flag1 == 0)
X=xx/max(xx); Y=yy/max(yy);
else
X=(xx - mean(xx))/max(xx - mean(xx)) ; Y=(yy - mean(yy))/max(yy - mean(yy));
end
%scatter(X,Y,'.r')
xedges = linspace(min(X), max(X), nbins);
yedges = linspace(min(Y), max(Y), nbins);
[N, xedges, yedges] = histcounts2(X, Y, xedges, yedges);
xcenters = (xedges(1:end-1) + xedges(2:end)) / 2;
ycenters = (yedges(1:end-1) + yedges(2:end)) / 2;
contour(xcenters, ycenters, N', nl, 'LineColor', 'c','LineWidth', 2); % 20 levels
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ylabel(ylabz,'Interpreter','latex'); 
xlabel(xlabz,'Interpreter','latex');
pbaspect([1 1 1]); xlim([-xlimit, xlimit]); ylim([-ylimit, ylimit]); xticks([]); yticks([]);yticks([]); xline(0,'--k');yline(0,'--k');


end