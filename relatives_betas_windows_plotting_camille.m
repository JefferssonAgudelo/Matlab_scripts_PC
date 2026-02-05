% This script is to make and save the plots for the 3 components relatives
% terms 


time_in = 1;


legendsgsmhd = {'$<J \times B>/<u \times B>$','$<\nabla \cdot P>/<u \times B>$','$<\nabla \cdot (uJ+Ju-JJ/ne)>/<u \times B>$',...
    '$<RHS>/<u \times B>$','$<\tau_{nE}>/<u \times B>$','$<\tau_{u \times B}>/<ux \times B>$','$<\tau_{J \times B}>/<u \times B>$',...
    '$<\tau_{\nabla\cdot(uJ+Ju-JJ/ne)}>/<u \times B>$','$<\Sigma \tau>/<u \times B>$'};

legendsgsmhd_0 = {'$<|\overline{E}|>$','$<|u \times B|>$','$<|J \times B|/ne>$','$<\nabla \cdot P>$','$<\nabla \cdot (uJ+Ju-JJ/ne)>$','$<RHS>$',...
    '$<\tau_{nE}>$','$<\tau_{u \times B}>$','$<\tau_{J \times B}>$',...
    '$<\tau_{\nabla\cdot(uJ+Ju-JJ/ne)}>$','$<\Sigma \tau>$'};

legendsgsmhd_1 = {'$<|\overline{E}|>/<|\overline{u} \times \overline{B}|>$',...
    '$<|\overline{u} \times \overline{B}|>/<|\overline{u} \times \overline{B}|>$',...
    '$<|\overline{J} \times \overline{B}|/\overline{n}e>/<|\overline{u} \times \overline{B}|>$'...
    ,'$<|\nabla \cdot \overline{P}|>/<|\overline{u} \times \overline{B}|>$',...
    '$<|\nabla \cdot (\overline{u}\overline{J}+\overline{J}\overline{u}-\overline{J}\overline{J}/\overline{n}e)m_{e}/\overline{n}e^2|>/<|\overline{u} \times \overline{B}|>$',...
    '$<RHS>/<|\overline{u} \times \overline{B}|>$',...
    '$<\tau_{nE}>/<|\overline{u} \times \overline{B}|>$',...
    '$<\tau_{u \times B}>/<|\overline{u} \times \overline{B}|>$',...
    '$<\tau_{J \times B}>/<|\overline{u} \times \overline{B}|>$',...
    '$<\tau_{\nabla\cdot(uJ+Ju-JJ/ne)}>/<|\overline{u} \times \overline{B}|>$',...
    '$<\Sigma \tau>/<|\overline{u} \times \overline{B}|>$'};

legendsgsmhd_2 = {'$<\overline{E}>/<\overline{u} \times \overline{B}>$',...
    '$<\overline{u} \times \overline{B}>/<\overline{u} \times \overline{B}>$',...
    '$<\overline{J} \times \overline{B}/\overline{n}e>/<\overline{u} \times \overline{B}>$'...
    ,'$<\nabla \cdot \overline{P}>/<\overline{u} \times \overline{B}>$',...
    '$<\nabla \cdot (\overline{u}\overline{J}+\overline{J}\overline{u}-\overline{J}\overline{J}/\overline{n}e)m_{e}/\overline{n}e^2>/<\overline{u} \times \overline{B}>$',...
    '$<RHS>/<\overline{u} \times \overline{B}>$',...
    '$<\tau_{nE}>/<\overline{u} \times \overline{B}>$',...
    '$<\tau_{u \times B}>/<\overline{u} \times \overline{B}>$',...
    '$<\tau_{J \times B}>/<\overline{u} \times \overline{B}>$',...
    '$<\tau_{\nabla\cdot(uJ+Ju-JJ/ne)}>/<\overline{u} \times \overline{B}>$',...
    '$<\Sigma \tau>/<\overline{u} \times \overline{B}>$'};

%time_in = linspace(1,21,Nf);
fs=18;

fs=16; x0=45;y0=54;xx1=1000;yy1=800;

legendsgsmhd_3 = {'$<\overline{E}>/<\overline{u} \times \overline{B}>$',...
    '$<\Sigma \tau>/<\overline{u} \times \overline{B}>$'...,
    '$<\Sigma \tau>/<\overline{E}>$'};





% This is for the window 2 only
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% rms =1, abs 0 for beta 0.25
%--------------------------------------------------------------------------
time_in = [0, 2, 4, 6, 7.6, 9.2, 10.8, 12.4, 14];

MHD_E2vxB_mean = [0, 1.3017, 1.3627, 1.368, 1.4138, 1.4059, 1.4027, 1.4395, 1.3473];
MHD_vxB2vxB_mean = [0,1,1,1,1,1,1,1,1];
MHD_JxB2vxB_mean = [0, 0.58864, 0.80151, 0.88618, 0.88764, 0.91167, 0.88498, 0.93502, 0.80614];
MHD_divP2vxB_mean = [0, 0.04888, 0.058154, 0.052438, 0.065718, 0.073673, 0.076147, 0.081777, 0.081948];
MHD_divvJall2vxB_mean = [0, 0.0046654, 0.0061193, 0.0074556, 0.0082312, 0.0091456, 0.0090406, 0.0099363, 0.0093473];
MHD_RHS2vxB_mean = [0, 1.3169, 1.3828, 1.3929, 1.4431, 1.4368, 1.4351, 1.4778, 1.3808];

SGS_tau_nE_mean2vxB_mean = [0, 0.0076339, 0.0078627, 0.0072507, 0.0097366, 0.010215, 0.011107, 0.012792, 0.01209];
SGS_tau_vxB_mean2vxB_mean = [0, 0.0070733, 0.0066349, 0.0064501, 0.007767, 0.007502, 0.0070787, 0.0073466, 0.0067038];
SGS_tau_JxB_mean2vxB_mean = [0, 0.0060366, 0.0070344, 0.0099801, 0.013006, 0.016348, 0.018402, 0.020439, 0.019519];
SGS_tau_Div_mean2vxB_mean = [0, 0.00040352, 0.00066961, 0.00081316, 0.0015576, 0.0015651, 0.0018417, 0.0023254, 0.0025591];
SGS_tau_total_mean2vxB_mean = [0, 0.0089922, 0.0094701, 0.012059, 0.015468, 0.019036, 0.021869, 0.025081, 0.023894];
%--------------------------------------------------------------------------

f30 = figure(30);
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(3,1,1)
semilogy(time_in,MHD_E2vxB_mean,'-or',LineWidth=2)
hold on
semilogy(time_in,MHD_vxB2vxB_mean,'-ob',LineWidth=2)
semilogy(time_in,MHD_JxB2vxB_mean,'-og',LineWidth=2)
semilogy(time_in,MHD_divP2vxB_mean,'-om',LineWidth=2)
semilogy(time_in,MHD_divvJall2vxB_mean,'-oc',LineWidth=2)
semilogy(time_in,MHD_RHS2vxB_mean,'-ok',LineWidth=2)
semilogy(time_in,SGS_tau_nE_mean2vxB_mean,'-+r',LineWidth=2)
semilogy(time_in,SGS_tau_vxB_mean2vxB_mean,'-+b',LineWidth=2)
semilogy(time_in,SGS_tau_JxB_mean2vxB_mean,'-+g',LineWidth=2)
semilogy(time_in,SGS_tau_Div_mean2vxB_mean,'-+c',LineWidth=2)
semilogy(time_in,SGS_tau_total_mean2vxB_mean,'-*k',LineWidth=2)
legend(legendsgsmhd_2,'FontSize',fs,'Interpreter','latex','NumColumns',1,'Location','northeastoutside')
xlabel('$t/t_{\Omega_{ci}}$','FontSize',fs,Interpreter='latex')
ylabel('$\beta_{i} = 0.25$','FontSize',fs,Interpreter='latex')
xlim([1,14])
ylim([10^(-4),10]) 
hold off


% rms =1, abs 0 for beta 1
%--------------------------------------------------------------------------
time_in = [1.25, 2.5, 3.75, 5, 6.25, 7.5, 8.75, 10, 11.25, 12, 12.79, 13.56];

MHD_E2vxB_mean = [1.3211, 1.4485, 1.5063, 1.449, 1.6529, 1.4842, 1.5668, 1.4827, 1.5263, 1.5977, 1.6737, 1.684 ];
MHD_vxB2vxB_mean = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
MHD_JxB2vxB_mean = [0.5831, 0.90603, 0.96334, 0.91866, 1.2289, 1.0409, 1.2373, 1.0852, 1.2293, 1.3524, 1.4618, 1.4724 ];
MHD_divP2vxB_mean = [0.039254, 0.04434, 0.038952, 0.047854, 0.062326, 0.058671, 0.064293, 0.065439, 0.072787, 0.077996, 0.082271, 0.082217];
MHD_divvJall2vxB_mean = [0.0040955, 0.0052776, 0.0064178, 0.0070346, 0.0090795, 0.0090418, 0.01013, 0.010081, 0.010988, 0.011331, 0.011773, 0.011831];
MHD_RHS2vxB_mean = [1.3356, 1.4673, 1.5299, 1.4804, 1.7061, 1.5398, 1.6435, 1.5644, 1.6261, 1.7101, 1.7977, 1.8105];

SGS_tau_nE_mean2vxB_mean = [0.0039628, 0.0040501, 0.0038118, 0.0047834, 0.0072634, 0.0074998, 0.0094058, 0.0097337, 0.011198, 0.012065, 0.012987, 0.013038];
SGS_tau_vxB_mean2vxB_mean = [0.003405, 0.0028348, 0.0026687, 0.0027838, 0.0027788, 0.0025237, 0.0026338, 0.0023965, 0.0025044, 0.0026125, 0.0027599, 0.0027033];
SGS_tau_JxB_mean2vxB_mean = [0.0049659, 0.0080658, 0.011919, 0.016776, 0.025924, 0.024673, 0.028473, 0.027384, 0.031125, 0.032896, 0.034208, 0.034007];
SGS_tau_Div_mean2vxB_mean = [0.00028941, 0.00060524, 0.00095245, 0.0015642, 0.0030735, 0.0034518, 0.0050118, 0.0058908, 0.0067431, 0.0070607, 0.0076358, 0.0077462];
SGS_tau_total_mean2vxB_mean = [0.0066523, 0.009139, 0.012896, 0.01798, 0.028677, 0.028012, 0.033407, 0.033306, 0.038129, 0.040391, 0.042415, 0.042465];
%--------------------------------------------------------------------------

subplot(3,1,2)
semilogy(time_in,MHD_E2vxB_mean,'or',LineWidth=2)
hold on
semilogy(time_in,MHD_vxB2vxB_mean,'-ob',LineWidth=2)
semilogy(time_in,MHD_JxB2vxB_mean,'-og',LineWidth=2)
semilogy(time_in,MHD_divP2vxB_mean,'-om',LineWidth=2)
semilogy(time_in,MHD_divvJall2vxB_mean,'-oc',LineWidth=2)
semilogy(time_in,MHD_RHS2vxB_mean,'-ok',LineWidth=2)
semilogy(time_in,SGS_tau_nE_mean2vxB_mean,'-+r',LineWidth=2)
semilogy(time_in,SGS_tau_vxB_mean2vxB_mean,'-+b',LineWidth=2)
semilogy(time_in,SGS_tau_JxB_mean2vxB_mean,'-+g',LineWidth=2)
semilogy(time_in,SGS_tau_Div_mean2vxB_mean,'-+c',LineWidth=2)
semilogy(time_in,SGS_tau_total_mean2vxB_mean,'-*k',LineWidth=2)
legend(legendsgsmhd_2,'FontSize',fs,'Interpreter','latex','NumColumns',1,'Location','northeastoutside')
xlabel('$t/t_{\Omega_{ci}}$','FontSize',fs,Interpreter='latex')
xlim([1,14])
ylim([10^(-4),10]) 
ylabel('$\beta_{i} = 1.0$','FontSize',fs,Interpreter='latex')
hold off

% rms =1, abs 0 for beta 4
%--------------------------------------------------------------------------
time_in = [0.0, 1.6, 3.2, 4.8, 6.4, 8.0, 9.2, 10.4, 11.6, 12.8];

MHD_E2vxB_mean = [0, 1.4741, 1.7434, 2.2682, 2.4731, 2.4869, 3.0494, 3.2767, 3.3037, 2.994];
MHD_vxB2vxB_mean = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1];
MHD_JxB2vxB_mean = [0, 1.0276, 1.5108, 2.0256, 2.46, 2.6624, 3.1361, 3.376, 3.5156, 3.2807];
MHD_divP2vxB_mean = [0, 0.023594, 0.032776, 0.0418, 0.044441, 0.054652, 0.060383, 0.064832, 0.070465, 0.065195];
MHD_divvJall2vxB_mean = [0, 0.0042504, 0.0056632, 0.008722, 0.011559, 0.013754, 0.01823, 0.021234, 0.022681, 0.021879];
MHD_RHS2vxB_mean = [0, 1.4917, 1.776, 2.3313, 2.5778, 2.6557, 3.269, 3.5512, 3.6375, 3.3336];

SGS_tau_nE_mean2vxB_mean = [0, 0.0017552, 0.0027781, 0.0041327, 0.0052322, 0.0071962, 0.0094586, 0.01179, 0.013647, 0.013349];
SGS_tau_vxB_mean2vxB_mean = [0, 0.0023703, 0.0021702, 0.0022926, 0.0025307, 0.0025731, 0.0026295, 0.0027835, 0.0026897, 0.0026266];
SGS_tau_JxB_mean2vxB_mean = [0, 0.0056897, 0.01281, 0.02666, 0.04333, 0.059387, 0.075155, 0.087065, 0.095255, 0.089579];
SGS_tau_Div_mean2vxB_mean = [0, 0.00028118, 0.00064615, 0.0020112, 0.0041925, 0.0075506, 0.010862, 0.014009, 0.016937, 0.018367];
SGS_tau_total_mean2vxB_mean = [0, 0.0067834, 0.01381, 0.028018, 0.045573, 0.063495, 0.081653, 0.095897, 0.10575, 0.10084];
%--------------------------------------------------------------------------

subplot(3,1,3)
semilogy(time_in,MHD_E2vxB_mean,'-or',LineWidth=2)
hold on
semilogy(time_in,MHD_vxB2vxB_mean,'-ob',LineWidth=2)
semilogy(time_in,MHD_JxB2vxB_mean,'-og',LineWidth=2)
semilogy(time_in,MHD_divP2vxB_mean,'-om',LineWidth=2)
semilogy(time_in,MHD_divvJall2vxB_mean,'-oc',LineWidth=2)
semilogy(time_in,MHD_RHS2vxB_mean,'-ok',LineWidth=2)
semilogy(time_in,SGS_tau_nE_mean2vxB_mean,'-+r',LineWidth=2)
semilogy(time_in,SGS_tau_vxB_mean2vxB_mean,'-+b',LineWidth=2)
semilogy(time_in,SGS_tau_JxB_mean2vxB_mean,'-+g',LineWidth=2)
semilogy(time_in,SGS_tau_Div_mean2vxB_mean,'-+c',LineWidth=2)
semilogy(time_in,SGS_tau_total_mean2vxB_mean,'-*k',LineWidth=2)
xlabel('$t/t_{\Omega_{ci}}$','FontSize',fs,Interpreter='latex')
xlim([1,14])
ylim([10^(-4),10]) 
ylabel('$\beta_{i} = 4.0$','FontSize',fs,Interpreter='latex')
legend(legendsgsmhd_2,'FontSize',fs,'Interpreter','latex','NumColumns',1,'Location','northeastoutside')
hold off
%saveas(f30,strcat(num2str(i),'relatives_terms_time_rms_log_025-1-4.png'));


% this is to compare the values of the different betas.
% I think I should take only the last time and the contribution from the sum of sub grid as a function of beta
%--------------------------------------------------------------------------
betas = [0.25, 1, 4];
sum_sgs = [0.023894, 0.042465, 0.10084];
E_betas = [1.3473, 1.684, 2.994];
rela_sum2E = sum_sgs./E_betas;
%--------------------------------------------------------------------------
f32 = figure(32);
%set(gcf,'position',[x0,y0,xx1,yy1])
semilogy(betas,E_betas,'or',LineWidth=2)
hold on
semilogy(betas,sum_sgs,'*k',LineWidth=2)
semilogy(betas,rela_sum2E,'*m',LineWidth=2)
legend(legendsgsmhd_3,'FontSize',fs,'Interpreter','latex','NumColumns',1,'Location','northeastoutside')
xlabel('$\beta_{i}$','FontSize',fs,Interpreter='latex')
xlim([0,5])
hold off
%--------------------------------------------------------------------------
%saveas(f32,strcat(num2str(i),'log_betas.png'));
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------


% This is to ake the plots
%--------------------------------------------------------------------------
% f35 = figure(35);
% set(gcf,'position',[x0,y0,xx1,yy1])
% semilogy(time_in,MHD_E2vxB_mean,'or',LineWidth=2)
% hold on
% semilogy(time_in,MHD_vxB2vxB_mean,'ob',LineWidth=2)
% semilogy(time_in,MHD_JxB2vxB_mean,'og',LineWidth=2)
% semilogy(time_in,MHD_divP2vxB_mean,'om',LineWidth=2)
% semilogy(time_in,MHD_divvJall2vxB_mean,'oc',LineWidth=2)
% semilogy(time_in,MHD_RHS2vxB_mean,'-k',LineWidth=2)
% semilogy(time_in,SGS_tau_nE_mean2vxB_mean,'+r',LineWidth=2)
% semilogy(time_in,SGS_tau_vxB_mean2vxB_mean,'+b',LineWidth=2)
% semilogy(time_in,SGS_tau_JxB_mean2vxB_mean,'+g',LineWidth=2)
% semilogy(time_in,SGS_tau_Div_mean2vxB_mean,'+c',LineWidth=2)
% semilogy(time_in,SGS_tau_total_mean2vxB_mean,'*k',LineWidth=2)
% legend(legendsgsmhd_2,'FontSize',fs,'Interpreter','latex','NumColumns',1,'Location','northeastoutside')
% xlabel('$t/t_{\Omega_{ci}}$','FontSize',fs,Interpreter='latex')
% xlim([1,14])
% hold off
%--------------------------------------------------------------------------
%saveas(f35,strcat(num2str(i),'relatives_terms_time_rms_log_4.png'));





resx = 0.0736;

% This is changing the window size for each beta
%--------------------------------------------------------------------------
time_in = [2*resx, 4*resx, 8*resx, 12*resx, 14*resx, 16*resx];
%--------------------------------------------------------------------------

% rms =1, abs 0 for beta 0.25
%--------------------------------------------------------------------------
MHD_E2vxB_mean = [1.3473, 1.3227, 1.292, 1.2751, 1.2685,1.2625];
MHD_vxB2vxB_mean = [1,1,1,1,1,1];
MHD_JxB2vxB_mean = [0.80614, 0.73197, 0.65493, 0.61525, 0.60135, 0.5896];
MHD_divP2vxB_mean = [0.081948, 0.065165, 0.047513, 0.039013, 0.036203, 0.033951];
MHD_divvJall2vxB_mean = [0.0093473, 0.0054023, 0.0028685, 0.001907, 0.0016104, 0.0013758];
MHD_RHS2vxB_mean = [1.3808, 1.3439, 1.3053, 1.2848, 1.277, 1.2696];

SGS_tau_nE_mean2vxB_mean = [0.01209, 0.025291, 0.048823, 0.070404, 0.080597, 0.090347];
SGS_tau_vxB_mean2vxB_mean = [0.0067038, 0.018753, 0.045779, 0.072367, 0.084948, 0.096964];
SGS_tau_JxB_mean2vxB_mean = [0.019519, 0.031964, 0.044742, 0.052599, 0.055956, 0.059043];
SGS_tau_Div_mean2vxB_mean = [0.0025591, 0.002149, 0.0016694, 0.0014443, 0.0013826, 0.0013437];
SGS_tau_total_mean2vxB_mean = [0.023894, 0.040672, 0.062588, 0.080781, 0.08967, 0.098434];
%--------------------------------------------------------------------------


f31 = figure(31);
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(3,1,1)
semilogy(time_in,MHD_E2vxB_mean,'-or',LineWidth=2)
hold on
semilogy(time_in,MHD_vxB2vxB_mean,'-ob',LineWidth=2)
semilogy(time_in,MHD_JxB2vxB_mean,'-og',LineWidth=2)
semilogy(time_in,MHD_divP2vxB_mean,'-om',LineWidth=2)
semilogy(time_in,MHD_divvJall2vxB_mean,'-oc',LineWidth=2)
semilogy(time_in,MHD_RHS2vxB_mean,'-ok',LineWidth=2)
semilogy(time_in,SGS_tau_nE_mean2vxB_mean,'-+r',LineWidth=2)
semilogy(time_in,SGS_tau_vxB_mean2vxB_mean,'-+b',LineWidth=2)
semilogy(time_in,SGS_tau_JxB_mean2vxB_mean,'-+g',LineWidth=2)
semilogy(time_in,SGS_tau_Div_mean2vxB_mean,'-+c',LineWidth=2)
semilogy(time_in,SGS_tau_total_mean2vxB_mean,'-*k',LineWidth=2)
legend(legendsgsmhd_2,'FontSize',fs,'Interpreter','latex','NumColumns',1,'Location','northeastoutside')
xlabel('$sw/d_{i}$','FontSize',fs,Interpreter='latex')
ylabel('$\beta_{i} = 0.25$','FontSize',fs,Interpreter='latex')
xlim([0,1.3])
ylim([10^(-4),10]) 
hold off

% rms =1, abs 0 for beta 1
%--------------------------------------------------------------------------
MHD_E2vxB_mean = [1.684, 1.5462, 1.4268, 1.3808, 1.3675, 1.357];
MHD_vxB2vxB_mean = [1, 1, 1, 1, 1, 1];
MHD_JxB2vxB_mean = [1.4724, 1.167, 0.96077, 0.89815, 0.88383, 0.87389];
MHD_divP2vxB_mean = [0.082217, 0.061041, 0.040354, 0.032021, 0.029787, 0.028184];
MHD_divvJall2vxB_mean = [0.011831, 0.0053171, 0.0024054, 0.0015391, 0.0013007, 0.0011177];
MHD_RHS2vxB_mean = [1.8105, 1.5933, 1.4494, 1.3979, 1.3827, 1.3702];

SGS_tau_nE_mean2vxB_mean = [0.013038, 0.019108, 0.026452, 0.034789, 0.039461, 0.04439];
SGS_tau_vxB_mean2vxB_mean = [0.0027033, 0.0077943, 0.020407, 0.033778, 0.040347, 0.046755];
SGS_tau_JxB_mean2vxB_mean = [0.034007, 0.048955, 0.065852, 0.077429, 0.0823, 0.086627];
SGS_tau_Div_mean2vxB_mean = [0.0077462, 0.0048001, 0.0027097, 0.0021135, 0.0019676, 0.0018731];
SGS_tau_total_mean2vxB_mean = [0.042465, 0.057146, 0.075854, 0.092613, 0.10078, 0.10876];
%--------------------------------------------------------------------------

subplot(3,1,2) 
semilogy(time_in,MHD_E2vxB_mean,'or',LineWidth=2) 
hold on 
semilogy(time_in,MHD_vxB2vxB_mean,'-ob',LineWidth=2) 
semilogy(time_in,MHD_JxB2vxB_mean,'-og',LineWidth=2) 
semilogy(time_in,MHD_divP2vxB_mean,'-om',LineWidth=2) 
semilogy(time_in,MHD_divvJall2vxB_mean,'-oc',LineWidth=2) 
semilogy(time_in,MHD_RHS2vxB_mean,'-ok',LineWidth=2) 
semilogy(time_in,SGS_tau_nE_mean2vxB_mean,'-+r',LineWidth=2) 
semilogy(time_in,SGS_tau_vxB_mean2vxB_mean,'-+b',LineWidth=2) 
semilogy(time_in,SGS_tau_JxB_mean2vxB_mean,'-+g',LineWidth=2) 
semilogy(time_in,SGS_tau_Div_mean2vxB_mean,'-+c',LineWidth=2) 
semilogy(time_in,SGS_tau_total_mean2vxB_mean,'-*k',LineWidth=2) 
legend(legendsgsmhd_2,'FontSize',fs,'Interpreter','latex','NumColumns',1,'Location','northeastoutside') 
xlabel('$sw/d_{i}$','FontSize',fs,Interpreter='latex') 
xlim([0,1.3])
ylim([10^(-4),10]) 
ylabel('$\beta_{i} = 1.0$','FontSize',fs,Interpreter='latex') 
hold off


% rms =1, abs 0 for beta 4
%--------------------------------------------------------------------------
MHD_E2vxB_mean = [2.994, 2.5457, 2.0718, 1.8522, 1.787, 1.7397];
MHD_vxB2vxB_mean = [1, 1, 1, 1, 1, 1];
MHD_JxB2vxB_mean = [3.2807, 2.5938, 2.0151, 1.7684, 1.6985, 1.6491];
MHD_divP2vxB_mean = [0.065195, 0.052806, 0.038896, 0.031998, 0.029817, 0.028128];
MHD_divvJall2vxB_mean = [0.021879, 0.009129, 0.0036511, 0.0020672, 0.0016631, 0.0013763];
MHD_RHS2vxB_mean = [3.3336, 2.6809, 2.1355, 1.8989, 1.83, 1.7806];

SGS_tau_nE_mean2vxB_mean = [0.013349, 0.020706, 0.027357, 0.032944, 0.03543, 0.037826];
SGS_tau_vxB_mean2vxB_mean = [0.0026266, 0.0076247, 0.020655, 0.035033, 0.042241, 0.049341];
SGS_tau_JxB_mean2vxB_mean = [0.089579, 0.12703, 0.16363, 0.18407, 0.18988, 0.19345];
SGS_tau_Div_mean2vxB_mean = [0.018367, 0.011671, 0.0066016, 0.0049421, 0.004516, 0.0042335];
SGS_tau_total_mean2vxB_mean = [0.10084, 0.13775, 0.17527, 0.20046, 0.20906, 0.21547];
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
subplot(3,1,3) 
semilogy(time_in,MHD_E2vxB_mean,'-or',LineWidth=2) 
hold on 
semilogy(time_in,MHD_vxB2vxB_mean,'-ob',LineWidth=2) 
semilogy(time_in,MHD_JxB2vxB_mean,'-og',LineWidth=2) 
semilogy(time_in,MHD_divP2vxB_mean,'-om',LineWidth=2) 
semilogy(time_in,MHD_divvJall2vxB_mean,'-oc',LineWidth=2) 
semilogy(time_in,MHD_RHS2vxB_mean,'-ok',LineWidth=2) 
semilogy(time_in,SGS_tau_nE_mean2vxB_mean,'-+r',LineWidth=2) 
semilogy(time_in,SGS_tau_vxB_mean2vxB_mean,'-+b',LineWidth=2) 
semilogy(time_in,SGS_tau_JxB_mean2vxB_mean,'-+g',LineWidth=2) 
semilogy(time_in,SGS_tau_Div_mean2vxB_mean,'-+c',LineWidth=2) 
semilogy(time_in,SGS_tau_total_mean2vxB_mean,'-*k',LineWidth=2) 
xlabel('$sw/d_{i}$','FontSize',fs,Interpreter='latex') 
xlim([0,1.3])
ylim([10^(-4),10]) 
ylabel('$\beta_{i} = 4.0$','FontSize',fs,Interpreter='latex') 
legend(legendsgsmhd_2,'FontSize',fs,'Interpreter','latex','NumColumns',1,'Location','northeastoutside') 
hold off 
%--------------------------------------------------------------------------
%saveas(f31,strcat(num2str(i),'relatives_terms_windows_rms_log_025-1-4.png')); 
%--------------------------------------------------------------------------






%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


E_betas025 = [1.3473, 1.3227, 1.292, 1.2751, 1.2685,1.2625];
sum_sgs025 = [0.023894, 0.040672, 0.062588, 0.080781, 0.08967, 0.098434];
rela_sum2E025 = sum_sgs025./E_betas025;

E_betas1 = [1.684, 1.5462, 1.4268, 1.3808, 1.3675, 1.357];
sum_sgs1 = [0.042465, 0.057146, 0.075854, 0.092613, 0.10078, 0.10876];
rela_sum2E1 = sum_sgs1./E_betas1;

E_betas4 = [2.994, 2.5457, 2.0718, 1.8522, 1.787, 1.7397];
sum_sgs4 = [0.10084, 0.13775, 0.17527, 0.20046, 0.20906, 0.21547];
rela_sum2E4 = sum_sgs4./E_betas4;

f42=figure(42);
semilogy(time_in,rela_sum2E025,'-or',LineWidth=2) 
hold on 
semilogy(time_in,rela_sum2E1,'-ob',LineWidth=2) 
semilogy(time_in,rela_sum2E4,'-ok',LineWidth=2) 
xlabel('$sw/d_{i}$','FontSize',fs,Interpreter='latex') 
ylabel('$<\Sigma \tau>/<\overline{E}>$','FontSize',fs,Interpreter='latex') 
xlim([0,1.3])
%ylim([10^(-3),10]) 
legend('$\beta_{i} = 0.25$','$\beta_{i} = 1.0$','$\beta_{i} = 4.0$','FontSize',fs,Interpreter='latex') 
hold off


% This is for the betas windows plots again
%--------------------------------------------------------------------------
delta = [0.2, 0.4, 0.6, 0.8 1.0, 1.2];

REvxB_betas025 = [1.38, 1.34, 1.31, 1.29, 1.27, 1.26];
REvxB_betas1 = [1.75, 1.58, 1.50, 1.45, 1.40, 1.37];
REvxB_betas4 = [3.25, 2.60, 2.05, 1.85, 1.75, 1.70];

RtauE_betas025 = [0.022, 0.040, 0.053, 0.065, 0.073, 0.082];
RtauE_betas1 = [0.028, 0.042, 0.055, 0.064, 0.071, 0.078];
RtauE_betas4 = [0.035, 0.060, 0.085, 0.102, 0.112, 0.120];
%--------------------------------------------------------------------------

xxx=linspace(0.001,1.2,100);
yy1 = xxx.^(-1/3);
yy2 = xxx.^(-1/3);

yfit025_1_2 = 1.19 + 0.09*yy1;
yfit1_1_2 = 1.12 + 0.28*yy1;
yfit4_1_2 = 0.53 + (1.23)*yy1;

yfit025_1_3 = 1.19 + 0.09*yy1;
yfit1_1_3 = 1.12 + 0.28*yy1;
yfit4_1_3 = 0.53 + (1.23)*yy1;

% This didn't work
%yfit025_1_3 = 0.16 + 1.12*yy2;
%yfit1_1_3 = 0.49 + 0.91*yy2;
%yfit4_1_3 = 2.11 + (0.37)*yy2;


f43=figure(43);
plot(xxx,yfit025_1_2,'-r',LineWidth=1) 
hold on 
plot(xxx,yfit1_1_2,'-b',LineWidth=1) 
plot(xxx,yfit4_1_2,'-k',LineWidth=1) 
plot(delta,REvxB_betas025,'-or',LineWidth=2) 
plot(delta,REvxB_betas1,'-ob',LineWidth=2) 
plot(delta,REvxB_betas4,'-ok',LineWidth=2) 
xlabel('$sw/d_{i}$','FontSize',fs,Interpreter='latex') 
ylabel('$<\Sigma \tau>/<\overline{E}>$','FontSize',fs,Interpreter='latex') 
xlim([0,1.3])
%ylim([10^(-3),10]) 
%legend('$\beta_{i} = 0.25$','$\beta_{i} = 1.0$','$\beta_{i} = 4.0$','FontSize',fs,Interpreter='latex') 
hold off


f44=figure(44);
plot(xxx,yfit025_1_3,'-r',LineWidth=1) 
hold on 
plot(xxx,yfit1_1_3,'-b',LineWidth=1) 
plot(xxx,yfit4_1_3,'-k',LineWidth=1) 
plot(delta,REvxB_betas025,'-or',LineWidth=2) 
plot(delta,REvxB_betas1,'-ob',LineWidth=2) 
plot(delta,REvxB_betas4,'-ok',LineWidth=2) 
xlabel('$sw/d_{i}$','FontSize',fs,Interpreter='latex') 
ylabel('$<\Sigma \tau>/<\overline{E}>$','FontSize',fs,Interpreter='latex') 
xlim([0,1.3])
%ylim([10^(-3),10]) 
%legend('$\beta_{i} = 0.25$','$\beta_{i} = 1.0$','$\beta_{i} = 4.0$','FontSize',fs,Interpreter='latex') 
hold off



%saveas(f42,strcat(num2str(i),'log_windows_ratio_betas.png'));

% this is to make a plot whos colour is another array
% % f21=figure(21);
% % CM = jet(time_in);
% % semilogy(betas, rela_sum2E, 'color',CM(in,:),'LineWidth', 1.5);
% % hold on
% % %loglog(k_bins(1:end-1), E_k_2(1:end-1), 'LineWidth', 1.5);
% % title('1D Omnidirectional Spectrum');
% % xlabel('k');
% % ylabel('E(k)');
% % legend('time')



%0.1472  0.2944    0.5888    0.8832    1.0304    1.1776%
 