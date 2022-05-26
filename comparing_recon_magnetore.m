%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% This is to check the errors between the reconstructed fields and the
% original after preprosecing with paraview
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
cd '/Volumes/PSC_DiRAC_DATA/MagneTORE/Synthetic_field_configurations/Reconstructed_fields/Reconstructed_states'

% This is for the datasets that have different sampling but has the curls
% and divs
%--------------------------------------------------------------------------
%{
filename='dipole_Bmag_curlmag_div.csv';
opts=detectImportOptions(filename);
opts.SelectedVariableNames = {'B_org_mag','B_rec_mag','curl_org_mag','curl_rec_mag','Div_org_couarse_3di','Div_coarse_recon','arc_length'};
dipole_v = readtable(filename,opts);

filename='multiple_dipole_Bmag_curlmag_div.csv';
opts=detectImportOptions(filename);
opts.SelectedVariableNames = {'B_org_mag','B_rec_mag','curl_org_mag','curl_rec_mag','Div_org_couarse_3di','Div_coarse_recon','arc_length'};
m_dipole_v = readtable(filename,opts);

filename='fluxrope3_Bmag_curlmag_div.csv';
opts=detectImportOptions(filename);
opts.SelectedVariableNames = {'B_org_mag','B_rec_mag','curl_org_mag','curl_rec_mag','Div_org_couarse_3di','Div_coarse_recon','arc_length'};
fluxrope_v = readtable(filename,opts);

filename='multiple_fluxrope3_Bmag_curlmag_div.csv';
opts=detectImportOptions(filename);
opts.SelectedVariableNames = {'B_org_mag','B_rec_mag','curl_org_mag','curl_rec_mag','Div_org_couarse_3di','Div_coarse_recon','arc_length'};
m_fluxrope_v = readtable(filename,opts);
%--------------------------------------------------------------------------

fs=20;
% For the magnetic field magnitude/B_{max} with arc 
%--------------------------------------------------------------------------
f666=figure(666);
subplot(2,2,1)
semilogy(dipole_v.arc_length,dipole_v.B_org_mag./max(max(max(dipole_v.B_org_mag))),'*k')
hold on
semilogy(dipole_v.arc_length,dipole_v.B_rec_mag./max(max(max(dipole_v.B_rec_mag))),'*b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Dipole','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{max}$','Interpreter','latex','FontSize',fs);
xlabel('$|\mathbf{r}/d_{i}|$','Interpreter','latex','FontSize',fs);
%xlim([0,])
%xlabel('')
hold off
subplot(2,2,2)
semilogy(m_dipole_v.arc_length,m_dipole_v.B_org_mag./max(max(max(m_dipole_v.B_org_mag))),'*k')
hold on
semilogy(m_dipole_v.arc_length,m_dipole_v.B_rec_mag./max(max(max(m_dipole_v.B_rec_mag))),'*b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Multiple dipoles','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{max}$','Interpreter','latex','FontSize',fs);
xlabel('$|\mathbf{r}/d_{i}|$','Interpreter','latex','FontSize',fs);
hold off
subplot(2,2,3)
semilogy(fluxrope_v.arc_length,fluxrope_v.B_org_mag./max(max(max(fluxrope_v.B_org_mag))),'*k')
hold on
semilogy(fluxrope_v.arc_length,fluxrope_v.B_rec_mag./max(max(max(fluxrope_v.B_rec_mag))),'*b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Flux-rope','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{max}$','Interpreter','latex','FontSize',fs);
xlabel('$|\mathbf{r}/d_{i}|$','Interpreter','latex','FontSize',fs);
hold off
subplot(2,2,4)
semilogy(m_fluxrope_v.arc_length,m_fluxrope_v.B_org_mag./max(max(max(m_fluxrope_v.B_org_mag))),'*k')
hold on
semilogy(m_fluxrope_v.arc_length,m_fluxrope_v.B_rec_mag./max(max(max(m_fluxrope_v.B_rec_mag))),'*b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Multiple flux-ropes','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{max}$','Interpreter','latex','FontSize',fs);
xlabel('$|\mathbf{r}/d_{i}|$','Interpreter','latex','FontSize',fs);
hold off
%--------------------------------------------------------------------------


% For the magnetic field magnitude/B_{n} with arc and B_{n}=1 
fs=20;
%--------------------------------------------------------------------------
f667=figure(667);
subplot(2,2,1)
semilogy(dipole_v.arc_length,dipole_v.B_org_mag,'*k')
hold on
semilogy(dipole_v.arc_length,dipole_v.B_rec_mag,'*b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Dipole','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{n}$','Interpreter','latex','FontSize',fs);
xlabel('$|\mathbf{r}/d_{i}|$','Interpreter','latex','FontSize',fs);
%xlim([0,])
%xlabel('')
hold off
subplot(2,2,2)
semilogy(m_dipole_v.arc_length,m_dipole_v.B_org_mag,'*k')
hold on
semilogy(m_dipole_v.arc_length,m_dipole_v.B_rec_mag,'*b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Multiple dipoles','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{n}$','Interpreter','latex','FontSize',fs);
xlabel('$|\mathbf{r}/d_{i}|$','Interpreter','latex','FontSize',fs);
hold off
subplot(2,2,3)
semilogy(fluxrope_v.arc_length,fluxrope_v.B_org_mag,'*k')
hold on
semilogy(fluxrope_v.arc_length,fluxrope_v.B_rec_mag,'*b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Flux-rope','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{n}$','Interpreter','latex','FontSize',fs);
xlabel('$|\mathbf{r}/d_{i}|$','Interpreter','latex','FontSize',fs);
hold off
subplot(2,2,4)
semilogy(m_fluxrope_v.arc_length,m_fluxrope_v.B_org_mag,'*k')
hold on
semilogy(m_fluxrope_v.arc_length,m_fluxrope_v.B_rec_mag,'*b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Multiple flux-ropes','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{n}$','Interpreter','latex','FontSize',fs);
xlabel('$|\mathbf{r}/d_{i}|$','Interpreter','latex','FontSize',fs);
hold off
%--------------------------------------------------------------------------

% For the magnetic field magnitude cell index
fs=20;
%--------------------------------------------------------------------------
f668=figure(668);
subplot(2,2,1)
semilogy(dipole_v.B_org_mag./max(max(max(dipole_v.B_org_mag))),'k')
hold on
semilogy(dipole_v.B_rec_mag./max(max(max(dipole_v.B_rec_mag))),'b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Dipole','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{max}$','Interpreter','latex','FontSize',fs);
xlabel('Cell index','Interpreter','latex','FontSize',fs);
%xlim([0,])
%xlabel('')
hold off
subplot(2,2,2)
semilogy(m_dipole_v.B_org_mag./max(max(max(m_dipole_v.B_org_mag))),'k')
hold on
semilogy(m_dipole_v.B_rec_mag./max(max(max(m_dipole_v.B_rec_mag))),'b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Multiple dipoles','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{max}$','Interpreter','latex','FontSize',fs);
xlabel('Cell index','Interpreter','latex','FontSize',fs);
hold off
subplot(2,2,3)
semilogy(fluxrope_v.B_org_mag./max(max(max(fluxrope_v.B_org_mag))),'k')
hold on
semilogy(fluxrope_v.B_rec_mag./max(max(max(fluxrope_v.B_rec_mag))),'b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Flux-rope','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{max}$','Interpreter','latex','FontSize',fs);
xlabel('Cell index','Interpreter','latex','FontSize',fs);
hold off
subplot(2,2,4)
semilogy(m_fluxrope_v.B_org_mag./max(max(max(m_fluxrope_v.B_org_mag))),'k')
hold on
semilogy(m_fluxrope_v.B_rec_mag./max(max(max(m_fluxrope_v.B_rec_mag))),'b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Multiple flux-ropes','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{max}$','Interpreter','latex','FontSize',fs);
xlabel('Cell index','Interpreter','latex','FontSize',fs);
hold off
%}
%--------------------------------------------------------------------------


% This files where returning the same values. Bad resampling
%--------------------------------------------------------------------------
%{
% This is for the resampled data from paraviw but only the components of B
% no coordinates values apriori
%--------------------------------------------------------------------------
filename='resampled_dipole.csv';
opts=detectImportOptions(filename);
opts.SelectedVariableNames = {'B_rec_x','B_rec_y','B_rec_z','Bx','By','Bz','B_rec_mag'};
dipole_v = readtable(filename,opts);

filename='resampled_m_dipole.csv';
opts=detectImportOptions(filename);
opts.SelectedVariableNames = {'B_rec_x','B_rec_y','B_rec_z','Bx','By','Bz','B_rec_mag'};
m_dipole_v = readtable(filename,opts);

filename='resampled_fluxrope.csv';
opts=detectImportOptions(filename);
opts.SelectedVariableNames = {'B_rec_x','B_rec_y','B_rec_z','Bx','By','Bz','B_rec_mag'};
fluxrope_v = readtable(filename,opts);

filename='resampled_m_fluxrope.csv';
opts=detectImportOptions(filename);
opts.SelectedVariableNames = {'B_rec_x','B_rec_y','B_rec_z','Bx','By','Bz','B_rec_mag'};
m_fluxrope_v = readtable(filename,opts);


dummy=dipole_v;
B_org_d=sqrt(dummy.Bx.^2 + dummy.By.^2 + dummy.Bz.^2);
B_rec_d=dummy.B_rec_mag;
clearvars dummy

dummy=m_dipole_v;
B_org_md=sqrt(dummy.Bx.^2 + dummy.By.^2 + dummy.Bz.^2);
B_rec_md=dummy.B_rec_mag;
clearvars dummy

dummy=fluxrope_v;
B_org_f=sqrt(dummy.Bx.^2 + dummy.By.^2 + dummy.Bz.^2);
B_rec_f=dummy.B_rec_mag;
clearvars dummy

dummy=m_fluxrope_v;
B_org_mf=sqrt(dummy.Bx.^2 + dummy.By.^2 + dummy.Bz.^2);
B_rec_mf=dummy.B_rec_mag;
clearvars dummy
%}
%--------------------------------------------------------------------------


% This is for the resampled data from paraviw but only the components of B
% no coordinates values apriori
%--------------------------------------------------------------------------
filename='dip_org_resam.csv';
opts=detectImportOptions(filename); opts.SelectedVariableNames = {'Bx','By','Bz'};
dipole_v_org = readtable(filename,opts);
filename='dip_rec_resam.csv';
opts=detectImportOptions(filename); opts.SelectedVariableNames = {'Bx','By','Bz'};
dipole_v_rec = readtable(filename,opts);

filename='m_dip_org_resam.csv';
opts=detectImportOptions(filename);opts.SelectedVariableNames = {'Bx','By','Bz'};
m_dipole_v_org = readtable(filename,opts);
filename='m_dip_rec_resam.csv';
opts=detectImportOptions(filename);opts.SelectedVariableNames = {'Bx','By','Bz'};
m_dipole_v_rec = readtable(filename,opts);

filename='flu_org_resam.csv';
opts=detectImportOptions(filename);opts.SelectedVariableNames = {'Bx','By','Bz'};
fluxrope_v_org = readtable(filename,opts);
filename='flu_rec_resam.csv';
opts=detectImportOptions(filename);opts.SelectedVariableNames = {'Bx','By','Bz'};
fluxrope_v_rec = readtable(filename,opts);

filename='m_flu_org_resam.csv';
opts=detectImportOptions(filename);opts.SelectedVariableNames = {'Bx','By','Bz'};
m_fluxrope_v_org = readtable(filename,opts);
filename='m_flu_rec_resam.csv';
opts=detectImportOptions(filename);opts.SelectedVariableNames = {'Bx','By','Bz'};
m_fluxrope_v_rec = readtable(filename,opts);

dummy=dipole_v_org;
B_org_d=sqrt(dummy.Bx.^2 + dummy.By.^2 + dummy.Bz.^2);
dummy=dipole_v_rec;
B_rec_d=sqrt(dummy.Bx.^2 + dummy.By.^2 + dummy.Bz.^2);
clearvars dummy
B_org_d=B_org_d.*(B_org_d<0.1); %this is to remove the outlayer
B_rec_d=B_rec_d.*(B_org_d<0.1);

dummy=m_dipole_v_org;
B_org_md=sqrt(dummy.Bx.^2 + dummy.By.^2 + dummy.Bz.^2);
dummy=m_dipole_v_rec;
B_rec_md=sqrt(dummy.Bx.^2 + dummy.By.^2 + dummy.Bz.^2);
clearvars dummy

dummy=fluxrope_v_org;
B_org_f=sqrt(dummy.Bx.^2 + dummy.By.^2 + dummy.Bz.^2);
dummy=fluxrope_v_rec;
B_rec_f=sqrt(dummy.Bx.^2 + dummy.By.^2 + dummy.Bz.^2);
clearvars dummy

dummy=m_fluxrope_v_org;
B_org_mf=sqrt(dummy.Bx.^2 + dummy.By.^2 + dummy.Bz.^2);
dummy=m_fluxrope_v_rec;
B_rec_mf=sqrt(dummy.Bx.^2 + dummy.By.^2 + dummy.Bz.^2);
clearvars dummy

%Averages
B_av_d=mean(B_org_d);  
B_av_md=mean(B_org_md);
B_av_f=mean(B_org_f);
B_av_mf=mean(B_org_mf);

%--------------------------------------------------------------------------

% These are the plots that work
% For the magnetic field magnitude cell index
fs=20;
Bn=1;
%--------------------------------------------------------------------------
f34=figure(34);
subplot(2,2,1)
semilogy(B_org_d./Bn,'k')
hold on
semilogy(B_rec_d./Bn,'b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Dipole','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{n}$','Interpreter','latex','FontSize',fs);
xlabel('Cell index','Interpreter','latex','FontSize',fs);
%xlim([0,])
%xlabel('')
hold off
subplot(2,2,2)
semilogy(B_org_md./Bn,'k')
hold on
semilogy(B_rec_md./Bn,'b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Multiple dipoles','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{n}$','Interpreter','latex','FontSize',fs);
xlabel('Cell index','Interpreter','latex','FontSize',fs);
hold off
subplot(2,2,3)
semilogy(B_org_f./Bn,'k')
hold on
semilogy(B_rec_f./Bn,'b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Flux-rope','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{n}$','Interpreter','latex','FontSize',fs);
xlabel('Cell index','Interpreter','latex','FontSize',fs);
hold off
subplot(2,2,4)
semilogy(B_org_mf./Bn,'k')
hold on
semilogy(B_rec_mf./Bn,'b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Multiple flux-ropes','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{n}$','Interpreter','latex','FontSize',fs);
xlabel('Cell index','Interpreter','latex','FontSize',fs);
hold off
%--------------------------------------------------------------------------

% plot With the ./max
%--------------------------------------------------------------------------
%{
f35=figure(35);
subplot(2,2,1)
semilogy(B_org_d./max(max(max(B_org_d))),'k')
hold on
semilogy(B_rec_d./max(max(max(B_rec_d))),'b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Dipole','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{max}$','Interpreter','latex','FontSize',fs);
xlabel('Cell index','Interpreter','latex','FontSize',fs);
%xlim([0,])
%xlabel('')
hold off
subplot(2,2,2)
semilogy(B_org_md./max(max(max(B_org_md))),'k')
hold on
semilogy(B_rec_md./max(max(max(B_rec_md))),'b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Multiple dipoles','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{max}$','Interpreter','latex','FontSize',fs);
xlabel('Cell index','Interpreter','latex','FontSize',fs);
hold off
subplot(2,2,3)
semilogy(B_org_f./max(max(max(B_org_f))),'k')
hold on
semilogy(B_rec_f./max(max(max(B_rec_f))),'b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Flux-rope','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{max}$','Interpreter','latex','FontSize',fs);
xlabel('Cell index','Interpreter','latex','FontSize',fs);
hold off
subplot(2,2,4)
semilogy(B_org_mf./max(max(max(B_org_mf))),'k')
hold on
semilogy(B_rec_mf./max(max(max(B_rec_mf))),'b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Multiple flux-ropes','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{max}$','Interpreter','latex','FontSize',fs);
xlabel('Cell index','Interpreter','latex','FontSize',fs);
hold off
%}
%--------------------------------------------------------------------------

% plot With the ./average
%--------------------------------------------------------------------------
%
f35=figure(35);
subplot(2,2,1)
semilogy(B_org_d./B_av_d,'k')
hold on
semilogy(B_rec_d./B_av_d,'b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Dipole','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{max}$','Interpreter','latex','FontSize',fs);
xlabel('Cell index','Interpreter','latex','FontSize',fs);
%xlim([0,])
%xlabel('')
hold off
subplot(2,2,2)
semilogy(B_org_md./B_av_md,'k')
hold on
semilogy(B_rec_md./B_av_md,'b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Multiple dipoles','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{max}$','Interpreter','latex','FontSize',fs);
xlabel('Cell index','Interpreter','latex','FontSize',fs);
hold off
subplot(2,2,3)
semilogy(B_org_f./B_av_f,'k')
hold on
semilogy(B_rec_f./B_av_f,'b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Flux-rope','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{max}$','Interpreter','latex','FontSize',fs);
xlabel('Cell index','Interpreter','latex','FontSize',fs);
hold off
subplot(2,2,4)
semilogy(B_org_mf./B_av_mf,'k')
hold on
semilogy(B_rec_mf./B_av_mf,'b')
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Multiple flux-ropes','Interpreter','latex','FontSize',fs);
ylabel('$|\mathbf{B}|/B_{max}$','Interpreter','latex','FontSize',fs);
xlabel('Cell index','Interpreter','latex','FontSize',fs);
hold off
%}
%--------------------------------------------------------------------------


% These are the errors of the coarsed graing reconstructions
%--------------------------------------------------------------------------
% errors dipole

%Normalise to the neighbours ?

%Linear error
l_e_d = abs(B_org_d - B_rec_d)./B_org_d;
l_e_md = abs(B_org_md - B_rec_md)./B_org_md;
l_e_f = abs(B_org_f - B_rec_d)./B_org_f;
l_e_mf = abs(B_org_mf - B_rec_f)./B_org_mf;


%Arc error
%ar_e_d = (2.*atan(abs(B_rec_mf/B_org_d)) - pi/2);
%Edges
%edges_arc = linspace(-pi/2,pi/2,100);

%f38=figure(38);
%subplot(1,2,1)
%plot(l_e_d,'k')
%subplot(1,2,2)
%plot(l_e_d_av,'b')


%Linear error average
%--------------------------------------------------------------------------

%Linear error average abs
%--------------------------------------------------------------------------
l_e_d_av = abs(B_org_d - B_rec_d)./B_av_d;
l_e_md_av = abs(B_org_md - B_rec_md)./B_av_md;
l_e_f_av = abs(B_org_f - B_rec_d)./B_av_f;
l_e_mf_av = abs(B_org_mf - B_rec_f)./B_av_mf;

%Edges
edges_lin = linspace(0,10,100);
[N_l_e_d,edges_lin_d] = histcounts(l_e_d_av,edges_lin);
edges_lin = linspace(0,10,100);
[N_l_e_md,edges_lin_md] = histcounts(l_e_md_av,edges_lin);
edges_lin = linspace(0,10,100);
[N_l_e_f,edges_lin_f] = histcounts(l_e_f_av,edges_lin);
edges_lin = linspace(0,10,100);
[N_l_e_mf,edges_lin_mf] = histcounts(l_e_mf_av,edges_lin);

%{
f37=figure(37);
subplot(2,2,1)
semilogx(edges_lin_d(2:100),N_l_e_d./sum(N_l_e_d),'-k','LineWidth',2)
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
%legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Dipole','Interpreter','latex','FontSize',fs);
ylabel('$Counts/N$','Interpreter','latex','FontSize',fs);
xlabel('$\epsilon_{B}$','Interpreter','latex','FontSize',fs);
xticks([1 10])
subplot(2,2,2)
semilogx(edges_lin_md(2:100),N_l_e_md./sum(N_l_e_md),'-k','LineWidth',2) 
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
%legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Multiple dipoles','Interpreter','latex','FontSize',fs);
ylabel('$Counts/N$','Interpreter','latex','FontSize',fs);
xlabel('$\epsilon_{B}$','Interpreter','latex','FontSize',fs);
xticks([1 10])
subplot(2,2,3)
semilogx(edges_lin_f(2:100),N_l_e_f./sum(N_l_e_f),'-k','LineWidth',2) 
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
%legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Flux-rope','Interpreter','latex','FontSize',fs);
ylabel('$Counts/N$','Interpreter','latex','FontSize',fs);
xlabel('$\epsilon_{B}$','Interpreter','latex','FontSize',fs);
xticks([1 10])
subplot(2,2,4)
semilogx(edges_lin_mf(2:100),N_l_e_mf./sum(N_l_e_mf),'-k','LineWidth',2) 
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
%legend('$B_{org}$','$B_{rec}$','Interpreter','latex','FontSize',fs);
title('Multiple flux-ropes','Interpreter','latex','FontSize',fs);
ylabel('$Counts/N$','Interpreter','latex','FontSize',fs);
xlabel('$\epsilon_{B}$','Interpreter','latex','FontSize',fs);
xticks([1 10])
%}
%--------------------------------------------------------------------------



%Linear error over under estimation
%--------------------------------------------------------------------------
l_e_d_av = (B_org_d - B_rec_d)./B_av_d;
l_e_d_av = rmmissing(l_e_d_av);
%epsav_d=sqrt(sum((l_e_d_av.*l_e_d_av)))./length(l_e_d_av);
epsav_d=(sum(abs(l_e_d_av)))./length(l_e_d_av);
epsav_d_std=std(abs(l_e_d_av));

l_e_md_av = (B_org_md - B_rec_md)./B_av_md;
l_e_md_av = rmmissing(l_e_md_av);
%epsav_md=sqrt(sum((l_e_md_av.*l_e_md_av)))./length(l_e_md_av);
epsav_md=(sum(abs(l_e_md_av)))./length(l_e_md_av);
epsav_md_std=std(abs(l_e_md_av));

l_e_f_av = (B_org_f - B_rec_d)./B_av_f;
l_e_f_av = rmmissing(l_e_f_av);
%epsav_f=sqrt(sum((l_e_f_av.*l_e_f_av)))./length(l_e_f_av);
epsav_f=(sum(abs(l_e_f_av)))./length(l_e_f_av);

l_e_mf_av = (B_org_mf - B_rec_f)./B_av_mf;
l_e_mf_av = rmmissing(l_e_mf_av);
%epsav_mf=sqrt(sum((l_e_mf_av.*l_e_mf_av)))./length(l_e_mf_av);
epsav_mf=(sum(abs(l_e_mf_av)))./length(l_e_mf_av);

%Edges
edges_lin = linspace(-10,10,100);
[N_l_e_d,edges_lin_d] = histcounts(l_e_d_av,edges_lin);
[N_l_e_md,edges_lin_md] = histcounts(l_e_md_av,edges_lin);
[N_l_e_f,edges_lin_f] = histcounts(l_e_f_av,edges_lin);
[N_l_e_mf,edges_lin_mf] = histcounts(l_e_mf_av,edges_lin);


% This is to estimate the percentage of data that fall within an error of
% 50 percent
range_d=sum(N_l_e_d.*(abs(edges_lin_d(2:100))<0.5))/sum(N_l_e_d)
range_md=sum(N_l_e_md.*(abs(edges_lin_md(2:100))<0.5))/sum(N_l_e_md)
range_f=sum(N_l_e_f.*(abs(edges_lin_f(2:100))<0.5))/sum(N_l_e_f)
range_mf=sum(N_l_e_mf.*(abs(edges_lin_mf(2:100))<0.5))/sum(N_l_e_mf)

% this didn't work
%log_edge=sign(edges_lin_d(2:100)).*log10(abs(edges_lin_d(2:100)));
%plot(log_edge,N_l_e_d./sum(N_l_e_d),'-k','LineWidth',2)

f38=figure(38);
subplot(2,2,1)
plot(edges_lin_d(2:100),N_l_e_d./sum(N_l_e_d),'-*k','LineWidth',2)
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
title("Dipole",'Interpreter','latex','FontSize',fs);
ylabel('$Counts/N_{c}$','Interpreter','latex','FontSize',fs);
xlabel('$\epsilon_{B}$','Interpreter','latex','FontSize',fs);
%legend("$\langle\epsilon_{B}\rangle$="+round(epsav_d,3),'Interpreter','latex','FontSize',fs);
txt1 = "$\langle|\epsilon_{B}|\rangle$="+round(epsav_d,2);
text(-10 , 0.2,txt1,'Interpreter','latex','FontSize',20);
xticks([-10 0 10])
subplot(2,2,2)
plot(edges_lin_md(2:100),N_l_e_md./sum(N_l_e_md),'-*k','LineWidth',2) 
%semilogx(edges_lin_md(2:100),N_l_e_md./sum(N_l_e_md),'-k','LineWidth',2) 
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
%legend(num2str(round(epsav_md,3)),'Interpreter','latex','FontSize',fs);
title('Multiple dipoles','Interpreter','latex','FontSize',fs);
ylabel('$Counts/N_{c}$','Interpreter','latex','FontSize',fs);
xlabel('$\epsilon_{B}$','Interpreter','latex','FontSize',fs);
txt1 = "$\langle|\epsilon_{B}|\rangle$="+round(epsav_md,2);
text(-10 , 0.5,txt1,'Interpreter','latex','FontSize',20);
xticks([-10 0 10])
subplot(2,2,3)
plot(edges_lin_f(2:100),N_l_e_f./sum(N_l_e_f),'-*k','LineWidth',2) 
%semilogy(edges_lin_f(2:100),N_l_e_f./sum(N_l_e_f),'-k','LineWidth',2) 
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
%legend(num2str(round(epsav_f,3)),'Interpreter','latex','FontSize',fs);
title('Flux-rope','Interpreter','latex','FontSize',fs);
ylabel('$Counts/N_{c}$','Interpreter','latex','FontSize',fs);
xlabel('$\epsilon_{B}$','Interpreter','latex','FontSize',fs);
txt1 = "$\langle|\epsilon_{B}|\rangle$="+round(epsav_f,2);
text(-10 , 0.2,txt1,'Interpreter','latex','FontSize',20);
xticks([-10 0 10])
subplot(2,2,4)
plot(edges_lin_mf(2:100),N_l_e_mf./sum(N_l_e_mf),'-*k','LineWidth',2) 
%semilogy(edges_lin_mf(2:100),N_l_e_mf./sum(N_l_e_mf),'-k','LineWidth',2) 
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
%legend(num2str(round(epsav_mf,3)),'Interpreter','latex','FontSize',fs);
title('Multiple flux-ropes','Interpreter','latex','FontSize',fs);
ylabel('$Counts/N_{c}$','Interpreter','latex','FontSize',fs);
xlabel('$\epsilon_{B}$','Interpreter','latex','FontSize',fs);
txt1 = "$\langle|\epsilon_{B}|\rangle$="+round(epsav_mf,2);
text(-10 , 0.2,txt1,'Interpreter','latex','FontSize',20);
xticks([-10 0 10])
%--------------------------------------------------------------------------
% with absolutes 
%--------------------------------------------------------------------------
f388=figure(388);
subplot(2,2,1)
semilogx(abs(edges_lin_d(2:100)),N_l_e_d./sum(N_l_e_d),'-*k','LineWidth',2)
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
title("Dipole",'Interpreter','latex','FontSize',fs);
ylabel('$Counts/N_{c}$','Interpreter','latex','FontSize',fs);
xlabel('$\epsilon_{B}$','Interpreter','latex','FontSize',fs);
%legend("$\langle\epsilon_{B}\rangle$="+round(epsav_d,3),'Interpreter','latex','FontSize',fs);
txt1 = "$\langle|\epsilon_{B}|\rangle$="+round(epsav_d,2);
text(0 , 0.2,txt1,'Interpreter','latex','FontSize',20);
xticks([0 1 10])
subplot(2,2,2)
semilogx(abs(edges_lin_d(2:100)),N_l_e_md./sum(N_l_e_md),'-*k','LineWidth',2) 
%semilogx(edges_lin_md(2:100),N_l_e_md./sum(N_l_e_md),'-k','LineWidth',2) 
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
%legend(num2str(round(epsav_md,3)),'Interpreter','latex','FontSize',fs);
title('Multiple dipoles','Interpreter','latex','FontSize',fs);
ylabel('$Counts/N_{c}$','Interpreter','latex','FontSize',fs);
xlabel('$\epsilon_{B}$','Interpreter','latex','FontSize',fs);
txt1 = "$\langle|\epsilon_{B}|\rangle$="+round(epsav_md,2);
text(0 , 0.2,txt1,'Interpreter','latex','FontSize',20);
xticks([0 1 10])
subplot(2,2,3)
semilogx(abs(edges_lin_d(2:100)),N_l_e_f./sum(N_l_e_f),'-*k','LineWidth',2) 
%semilogy(edges_lin_f(2:100),N_l_e_f./sum(N_l_e_f),'-k','LineWidth',2) 
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
%legend(num2str(round(epsav_f,3)),'Interpreter','latex','FontSize',fs);
title('Flux-rope','Interpreter','latex','FontSize',fs);
ylabel('$Counts/N_{c}$','Interpreter','latex','FontSize',fs);
xlabel('$\epsilon_{B}$','Interpreter','latex','FontSize',fs);
txt1 = "$\langle|\epsilon_{B}|\rangle$="+round(epsav_f,2);
text(0 , 0.2,txt1,'Interpreter','latex','FontSize',20);
xticks([0 1 10])
subplot(2,2,4)
semilogx(abs(edges_lin_d(2:100)),N_l_e_mf./sum(N_l_e_mf),'-*k','LineWidth',2) 
%semilogy(edges_lin_mf(2:100),N_l_e_mf./sum(N_l_e_mf),'-k','LineWidth',2) 
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
%legend(num2str(round(epsav_mf,3)),'Interpreter','latex','FontSize',fs);
title('Multiple flux-ropes','Interpreter','latex','FontSize',fs);
ylabel('$Counts/N_{c}$','Interpreter','latex','FontSize',fs);
xlabel('$\epsilon_{B}$','Interpreter','latex','FontSize',fs);
txt1 = "$\langle|\epsilon_{B}|\rangle$="+round(epsav_mf,2);
text(0 , 0.2,txt1,'Interpreter','latex','FontSize',20);
xticks([0 1 10])
%--------------------------------------------------------------------------



% Dot product
%--------------------------------------------------------------------------
du_org=dipole_v_org;
Bxx=(du_org.Bx).*(B_org_d<0.1); Byy=(du_org.By).*(B_org_d<0.1); Bzz=(du_org.Bz).*(B_org_d<0.1); 
du_rec=dipole_v_rec;
Bxxr=(du_rec.Bx).*(B_org_d<0.1); Byyr=(du_rec.By).*(B_org_d<0.1); Bzzr=(du_rec.Bz).*(B_org_d<0.1); 
cos_TB_d=(Bxx.*Bxxr + Byy.*Byyr + Bzz.*Bzzr)./(B_org_d.*B_rec_d);
cos_TB_d = rmmissing(cos_TB_d);
A=cos_TB_d;
A = A( ~any( isnan( A ) | isinf( A ), 2 ),: );
cos_TB_d=A;
%TBav_d=sqrt(sum((cos_TB_d.*cos_TB_d)))./length(cos_TB_d);
TBav_d=(sum(abs(cos_TB_d)))./length(cos_TB_d);


du_org=m_dipole_v_org;
du_rec=m_dipole_v_rec;
cos_TB_md=(du_org.Bx.*du_rec.Bx + du_org.By.*du_rec.By + du_org.Bz.*du_rec.Bz)./(B_org_md.*B_rec_md);
cos_TB_md = rmmissing(cos_TB_md);
%TBav_md=sqrt(sum((cos_TB_md.*cos_TB_md)))./length(cos_TB_md);
TBav_md=(sum(abs(cos_TB_md)))./length(cos_TB_md);

du_org=fluxrope_v_org;
du_rec=fluxrope_v_rec;
cos_TB_f=(du_org.Bx.*du_rec.Bx + du_org.By.*du_rec.By + du_org.Bz.*du_rec.Bz)./(B_org_f.*B_rec_f);
cos_TB_f = rmmissing(cos_TB_f);
%TBav_f=sqrt(sum((cos_TB_f.*cos_TB_f)))./length(cos_TB_f);
TBav_f=(sum(abs(cos_TB_f)))./length(cos_TB_f);

du_org=m_fluxrope_v_org;
du_rec=m_fluxrope_v_rec;
cos_TB_mf=(du_org.Bx.*du_rec.Bx + du_org.By.*du_rec.By + du_org.Bz.*du_rec.Bz)./(B_org_mf.*B_rec_mf);
cos_TB_mf = rmmissing(cos_TB_mf);
%TBav_mf=sqrt(sum((cos_TB_mf.*cos_TB_mf)))./length(cos_TB_mf);
TBav_mf=(sum(abs(cos_TB_mf)))./length(cos_TB_mf);
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%Edges
edges_lin = linspace(-1,1,100);
[N_cos_d,edges_lin] = histcounts(cos_TB_d,edges_lin);
[N_cos_md,edges_lin] = histcounts(cos_TB_md,edges_lin);
[N_cos_f,edges_lin] = histcounts(cos_TB_f,edges_lin);
[N_cos_mf,edges_lin] = histcounts(cos_TB_mf,edges_lin);

f39=figure(39);
subplot(2,2,1)
plot(edges_lin(2:100),N_cos_d./sum(N_cos_d),'-k','LineWidth',2)
%semilogy(edges_lin(2:100),N_cos_d./sum(N_cos_d),'-k','LineWidth',2)
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
title('Dipole','Interpreter','latex','FontSize',fs);
ylabel('$Counts/N_{c}$','Interpreter','latex','FontSize',fs);
xlabel('$\cos{\theta_{OR}}$','Interpreter','latex','FontSize',fs);
%legend(num2str(round(TBav_d,3)),'Interpreter','latex','FontSize',fs);
txt1 = "$\langle|\cos{\theta_{OR}}|\rangle$="+round(TBav_d,2);
text(-1 , 0.2,txt1,'Interpreter','latex','FontSize',20);
xticks([-1 -0.5 0  0.5 1])
subplot(2,2,2)
plot(edges_lin(2:100),N_cos_md./sum(N_cos_md),'-k','LineWidth',2)
%semilogy(edges_lin(2:100),N_cos_md./sum(N_cos_md),'-k','LineWidth',2)
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
%legend(num2str(round(TBav_md,3)),'Interpreter','latex','FontSize',fs);
txt1 = "$\langle|\cos{\theta_{OR}}|\rangle$="+round(TBav_md,2);
text(-1 , 0.2,txt1,'Interpreter','latex','FontSize',20);
title('Multiple dipoles','Interpreter','latex','FontSize',fs);
ylabel('$Counts/N_{c}$','Interpreter','latex','FontSize',fs);
xlabel('$\cos{\theta_{OR}}$','Interpreter','latex','FontSize',fs);
xticks([-1 -0.5 0  0.5 1])
subplot(2,2,3)
plot(edges_lin(2:100),N_cos_f./sum(N_cos_f),'-k','LineWidth',2)
%semilogy(edges_lin(2:100),N_cos_f./sum(N_cos_f),'-k','LineWidth',2)
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
%legend(num2str(round(TBav_f,3)),'Interpreter','latex','FontSize',fs);
txt1 = "$\langle|\cos{\theta_{OR}}|\rangle$="+round(TBav_f,2);
text(-1 , 0.2,txt1,'Interpreter','latex','FontSize',20);
title('Flux-rope','Interpreter','latex','FontSize',fs);
ylabel('$Counts/N_{c}$','Interpreter','latex','FontSize',fs);
xlabel('$\cos{\theta_{OR}}$','Interpreter','latex','FontSize',fs);
xticks([-1 -0.5 0  0.5 1])
subplot(2,2,4)
plot(edges_lin(2:100),N_cos_mf./sum(N_cos_mf),'-k','LineWidth',2) 
%semilogy(edges_lin(2:100),N_cos_mf./sum(N_cos_mf),'-k','LineWidth',2) 
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
%legend(num2str(round(TBav_mf,3)),'Interpreter','latex','FontSize',fs);
txt1 = "$\langle|\cos{\theta_{OR}}|\rangle$="+round(TBav_mf,2);
text(-1 , 0.2,txt1,'Interpreter','latex','FontSize',20);
title('Multiple flux-ropes','Interpreter','latex','FontSize',fs);
ylabel('$Counts/N_{c}$','Interpreter','latex','FontSize',fs);
xlabel('$\cos{\theta_{OR}}$','Interpreter','latex','FontSize',fs);
xticks([-1 -0.5 0  0.5 1])
%--------------------------------------------------------------------------

saveas(38,strcat('error.png'));
saveas(39,strcat('costhe.png'));


% The same but for the turbulent now
%--------------------------------------------------------------------------
filename='tur_org_resam_6621';
opts=detectImportOptions(filename); opts.SelectedVariableNames = {'hx','hy','hz'};
tur_v_org = readtable(filename,opts);
filename='tur_rec_resam_6621';
opts=detectImportOptions(filename); opts.SelectedVariableNames = {'hx','hy','hz'};
tur_v_rec = readtable(filename,opts);

dummy=tur_v_org;
B_org_t=sqrt(dummy.hx.^2 + dummy.hy.^2 + dummy.hz.^2);
dummy=tur_v_rec;
B_rec_t=sqrt(dummy.hx.^2 + dummy.hy.^2 + dummy.hz.^2);
clearvars dummy
%B_org_t=B_org_t.*(B_org_t<0.1); %this is to remove the outlayer
%B_rec_t=B_rec_t.*(B_org_t<0.1);


B_av_t=mean(B_org_t);

l_e_t_av = (B_org_t - B_rec_t)./B_av_t;
A=l_e_t_av;
A = A( ~any( isnan( A ) | isinf( A ), 2 ),: );
l_e_t_av=A;
%epsav_t=sqrt(sum((l_e_t_av.*l_e_t_av))./length(l_e_t_av));
epsav_t=(sum(abs(l_e_t_av))./length(l_e_t_av));


B_movav_t=movmean(B_org_t,9);
l_e_t_movav = (B_org_t - B_rec_t)./B_movav_t;
A=l_e_t_movav;
A = A( ~any( isnan( A ) | isinf( A ), 2 ),: );
l_e_t_movav=A;
eps_movav_t=(sum(abs(l_e_t_movav))./length(l_e_t_movav));

edges_lin = linspace(-10,10,100);
[N_l_e_t,edges_lin_t] = histcounts(l_e_t_av,edges_lin);
range_t=sum(N_l_e_t.*(abs(edges_lin_t(2:100))<0.5))/sum(N_l_e_t)

[N_l_emov_t,edges_lin_t] = histcounts(l_e_t_movav,edges_lin);



f43=figure(43)
semilogy(abs(l_e_t_av),'*k')
hold on
semilogy(abs(l_e_t_movav),'+b')
hold off

% Dot procut
du_org=tur_v_org;
Bxx=(du_org.hx).*(1); Byy=(du_org.hy).*(1); Bzz=(du_org.hz).*(1); 
du_rec=tur_v_rec;
Bxxr=(du_rec.hx).*(1); Byyr=(du_rec.hy).*(1); Bzzr=(du_rec.hz).*(1); 
cos_TB_t=(Bxx.*Bxxr + Byy.*Byyr + Bzz.*Bzzr)./(B_org_t.*B_rec_t);
cos_TB_t = rmmissing(cos_TB_t);
A=cos_TB_t;
A = A( ~any( isnan( A ) | isinf( A ), 2 ),: );
cos_TB_t=A;
%TBav_t=sqrt(sum((cos_TB_t.*cos_TB_t))./length(cos_TB_t));
TBav_t=(sum(abs(cos_TB_t))./length(cos_TB_t));

edges_lin = linspace(-1,1,100);
[N_cos_t,edges_lin] = histcounts(cos_TB_t,edges_lin);

f40=figure(40);
subplot(1,2,1)
plot(edges_lin_t(2:100),N_l_e_t./sum(N_l_e_t),'-k','LineWidth',2)
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
title("Turbulent",'Interpreter','latex','FontSize',fs);
ylabel('$Counts/N_{c}$','Interpreter','latex','FontSize',fs);
xlabel('$\epsilon_{B}$','Interpreter','latex','FontSize',fs);
%legend("$\langle\epsilon_{B}\rangle$="+round(epsav_d,3),'Interpreter','latex','FontSize',fs);
txt1 = "$\langle|\epsilon_{B}|\rangle$="+round(epsav_t,2);
text(-10 , 0.2,txt1,'Interpreter','latex','FontSize',20);
xticks([-10 0 10])
subplot(1,2,2)
plot(edges_lin(2:100),N_cos_d./sum(N_cos_d),'-k','LineWidth',2)
ax = gca; ax.FontSize = fs; ax.TickLabelInterpreter ='latex';
title('Turbulent','Interpreter','latex','FontSize',fs);
ylabel('$Counts/N_{c}$','Interpreter','latex','FontSize',fs);
xlabel('$\cos{\theta_{OR}}$','Interpreter','latex','FontSize',fs);
%legend(num2str(round(TBav_d,3)),'Interpreter','latex','FontSize',fs);
txt1 = "$\langle|\cos{\theta_{OR}}|\rangle$="+round(TBav_t,2);
text(-1 , 0.2,txt1,'Interpreter','latex','FontSize',20);
xticks([-1 -0.5 0  0.5 1])

saveas(40,strcat('tur_error_costh.png'));
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
plot(edges(2:100),N_er_B_d,'r') %plot(edges(2:100),Nc,'r')


% Thesis information 
%--------------------------------------------------------------------------
%File 1 successfully uploaded and saved.
%It will be held for 10 days (unless we run low on disk space).
%File name is 'Jeffersson_Andres_Agudelo_Rueda_18084908.pdf'.
%File content type is 'application/pdf'.
%File length is 42265313 bytes.
%File description is 'My name is Jeffersson Andres Agudelo Rueda. My student number is 18084908. This is my PhD dissertation.'.

%Pickup claim id is 62edbf89.

%Pickup passcode is 18357d8e.
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Errors

%Arc errors
%--------------------------------------------------------------------------
%{
% errors dipole
%--------------------------------------------------------------------------
dumS=dipole_v;
er_B_d = 2.*atan(abs(dumS.B_rec_mag/dumS.B_org_mag)) - pi/2;
er_curl_d = 2.*atan(abs(dumS.curl_rec_mag/dumS.curl_org_mag)) - pi/2;
er_div_d = 2.*atan(abs(dumS.Div_coarse_recon/dumS.Div_org_couarse_3di)) - pi/2;

% errors multiple dipole
dumS=m_dipole_v;
er_B_md = 2.*atan(abs(dumS.B_rec_mag/dumS.B_org_mag)) - pi/2;
er_curl_md = 2.*atan(abs(dumS.curl_rec_mag/dumS.curl_org_mag)) - pi/2;
er_div_md = 2.*atan(abs(dumS.Div_coarse_recon/dumS.Div_org_couarse_3di)) - pi/2;

% errors fluxrope
dumS=fluxrope_v;
er_B_f = 2.*atan(abs(dumS.B_rec_mag/dumS.B_org_mag)) - pi/2;
er_curl_f = 2.*atan(abs(dumS.curl_rec_mag/dumS.curl_org_mag)) - pi/2;
er_div_f = 2.*atan(abs(dumS.Div_coarse_recon/dumS.Div_org_couarse_3di)) - pi/2;

% errors mulstiple fluxropes
dumS=m_fluxrope_v;
er_B_mf = 2.*atan(abs(dumS.B_rec_mag/dumS.B_org_mag)) - pi/2;
er_curl_mf = 2.*atan(abs(dumS.curl_rec_mag/dumS.curl_org_mag)) - pi/2;
er_div_mf = 2.*atan(abs(dumS.Div_coarse_recon/dumS.Div_org_couarse_3di)) - pi/2;

edges = linspace(-pi/2,pi/2,100);

[N_er_B_d,edges] = histcounts(er_B_d,edges);
[N_er_curl_d,edges] = histcounts(er_curl_d,edges);
[N_er_div_d,edges] = histcounts(er_div_d,edges);

[N_er_B_md,edges] = histcounts(er_B_md,edges);
[N_er_curl_md,edges] = histcounts(er_curl_md,edges);
[N_er_div_md,edges] = histcounts(er_div_md,edges);

[N_er_B_f,edges] = histcounts(er_B_f,edges);
[N_er_curl_f,edges] = histcounts(er_curl_f,edges);
[N_er_div_f,edges] = histcounts(er_div_f,edges);

[N_er_B_mf,edges] = histcounts(er_B_mf,edges);
[N_er_curl_mf,edges] = histcounts(er_curl_mf,edges);
[N_er_div_mf,edges] = histcounts(er_div_mf,edges);

subplot(4,3,1)
histogram(er_B_d)

f665=figure(665);
plot(dipole_v.arc_length,'*k')
%}
%--------------------------------------------------------------------------
