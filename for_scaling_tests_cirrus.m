
% This is for the weak scaling tests in cirrus (changing size and cores)

nodes = [1, 2, 4, 8, 16, 32, 64, 192];
cores = [36, 72, 144, 288, 576, 1152, 2304, 6912];

gr_n = 168^3;
grid_points = gr_n*nodes;


%in sec, to 200 steps
time_200 = [899.717, 966.889, 947.506, 947.035, 962.033, 996.088, 991.485];

%in sec, to 500 steps
time_500 = [2300.3, 2979.86, 2688.1, 2673.63, 2775.55, 2504.74, 2510.54];

effi = 100*time_500(1)./time_500;

%in sec, to 1001 steps
%time_1000 = [5659.82, N/A 6706.39,  5776.54] % the last one

%in Gb
size_field_f = [0.163, 0.270, 0.652, 1.3, 2.6, 5.1, 11]; 
    
size_field_p = [0.471, 0.941, 1.9, 3.7, 7.4, 15, 30];  
    
% There was a proble with 6612, time 7193 (920 steps) (maybe it was the distribution 3 4 6)


%This is for the strong scaling (keeping the size constant)
%--------------------------------------------------------------------------
nodes_s = [0.5, 1, 2, 4, 8, 16, 32, 64, 192];
cores_s = [18, 36, 72, 144, 288, 576, 1152, 2304, 6912];
time_strong = [4365.51, 2300.3, 1360.82, 814.359, 433.257, 229.206, 128.719, 68.2838, 30.791]; 
%--------------------------------------------------------------------------

% Plots for the scaling
%--------------------------------------------------------------------------
x0=45;y0=54;xx1=850;yy1=210;
%--------------------------------------------------------------------------
lw=1; fs=18;
f1=figure(1);
subplot(1,2,1)
set(gcf,'position',[x0,y0,xx1,yy1])
loglog(cores_s,time_strong,'*k','LineWidth',lw); 
hold on
x=log10([10 7000]); y=-(0.84)*x + 4.7;
loglog(10.^x,10.^y,'--b','LineWidth',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = 'Cirrus CPUs';
ax.YLabel.String = 'Completion time (s)';
ax.FontSize=fs;
xlim([10, 7000])
title('Strong scaling test','Interpreter','latex','FontSize',fs)
hold off
subplot(1,2,2)
semilogx(cores(1:end-1),effi,'*k','LineWidth',lw); 
hold on
yline(mean(effi),'--b', LineWidth=1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = 'Cirrus CPUs';
ax.YLabel.String = 'Efficiency $\%$';
ax.FontSize=fs;
legend('','mean(Efficiency) = ($87.9 \pm 7.4$)$\%$ ','Interpreter','latex','FontSize',fs)
%xlim([10, 2040])
title('Weak scaling test','Interpreter','latex','FontSize',fs)
hold off

% f2=figure(2);
% %set(gcf,'position',[x0,y0,xx1,yy1])
% loglog(nodes_s,time_strong,'*k','LineWidth',lw); 
% hold on
% x=log10([0.5 80]); y=-(0.84)*x + 3.38;
% loglog(10.^x,10.^y,'--b','LineWidth',1)
% ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% ax.XLabel.String = 'Cirrus nodes';
% ax.YLabel.String = 'Completion time (s)';
% ax.FontSize=fs;
% title('Strong scaling test','Interpreter','latex','FontSize',fs)
% hold off

%cd('~/Downloads/')
saveas(f1,'scaling_strong_weak_cirrus_cpus.png');
%saveas(f2,'scaling_cirrus_nodes.png');


f3=figure(3);
%set(gcf,'position',[x0,y0,xx1,yy1])
plot(log(nodes_s),log(time_strong),'*k','LineWidth',lw); 
hold on
%x=log10([0.5 32]); y=-(0.9)*x + 3.35;
%loglog(10.^x,10.^y,'--b','LineWidth',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = 'Cirrus nodes';
ax.YLabel.String = 'Completion time (s)';
ax.FontSize=fs;
title('Strong scaling test','Interpreter','latex','FontSize',fs)
hold off


cd('/Users/jeffersson_agudelo/Downloads/scaling_times')


Tn2 = readmatrix('wall_times_strong_6cuben2.txt');
Tn4 = readmatrix('wall_times_strong_6cuben4.txt');
Tn8 = readmatrix('wall_times_strong_6cuben8.txt');
Tn16 = readmatrix('wall_times_strong_6cuben16.txt');
Tn32 = readmatrix('wall_times_strong_6cuben32.txt');
Tn64 = readmatrix('wall_times_strong_6cuben64.txt');
Tnlarge = readmatrix('wall_times_strong_large.txt');

T6cu = readmatrix('wall_times_strong_6cube.txt');
T24cu = readmatrix('wall_times_strong_24cube.txt');

steps =linspace(1,501,501);
steps=steps';

f4=figure(4)
plot(steps,Tn2, '-',LineWidth=1.3)
hold on
plot(steps(1:500),Tn4(1:500),LineWidth=1.3)
plot(steps(1:500),Tn8(1:500),LineWidth=1.3)
plot(steps(1:500),Tn16(1:500),LineWidth=1.3)
plot(steps(1:500),Tn32(1:500),LineWidth=1.3)
plot(steps(1:500),Tn64(1:500),LineWidth=1.3)
legend('n2','n4','n8','n16','n32','n64')
hold off


f5=figure(5)
plot(T6cu, '-b',LineWidth=1.3)
hold on
plot(T24cu, '-k',LineWidth=1.3)
legend('6cube','24cube')
title('week scaling')
hold off
