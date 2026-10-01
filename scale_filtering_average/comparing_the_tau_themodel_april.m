% This script is to plot tau and the model. This uses the already loaded
% data.
path_color = '/home/UNN/pfcy6/codes/processing_scripts/Matlab_Scripts_Laptop';

curls = 0;
if (curls == 1)
    term1_dt = term1_dt_x;
    term2_dt = term2_dt_x;
    term3_dt = term3_dt_x;
    term4_dt = term4_dt_x;
    term5_dt = term5_dt_x;
    term6_dt = term6_dt_x;

    term1_filt = term1_filt_x;
    term2_filt = term2_filt_x;
    term3_filt = term3_filt_x;
    term4_filt = term4_filt_x;
    term5_filt = term5_filt_x;
    term6_filt = term6_filt_x;    

    tau_total = tau_total_x;
    tau_nE_tau = tau_nE_tau_x;
    tau_v_x_B_tau = tau_v_x_B_tau_x;
    tau_J_x_B_tau = tau_J_x_B_tau_x;
    tau_Div_tau1 = tau_Div_tau1_x;

    % I don't know where is the file where I define this. but it has to do with
    %  using K, H Omega vs not using them
    %sum_tau_model1 = tau_M1_x;
    %sum_tau_model2 = tau_M2_x;
end

%%%
% This needs to be articulated with the part that computes the fits so
% there is a clearer connection. Extract the coefficients form the fits and
% put them here to compute the curl and compare. It is worth checking first
% the results from the fits.

% This is to compute the voritcity
%--------------------------------------------------------------------------
[v_x_dt_y, v_x_dt_x, v_x_dt_z] = gradient(v_x_dt);
[v_y_dt_y, v_y_dt_x, v_y_dt_z] = gradient(v_y_dt);
[v_z_dt_y, v_z_dt_x, v_z_dt_z] = gradient(v_z_dt);
vort_x_dt = (v_z_dt_y - v_y_dt_z)./(grad_fact.*resx);
vort_y_dt = (v_x_dt_z - v_z_dt_x)./(grad_fact.*resy);
vort_z_dt = (v_y_dt_x - v_x_dt_y)./(grad_fact.*resz);

[v_x_filt_y, v_x_filt_x, v_x_filt_z] = gradient(v_x_filt);
[v_y_filt_y, v_y_filt_x, v_y_filt_z] = gradient(v_y_filt);
[v_z_filt_y, v_z_filt_x, v_z_filt_z] = gradient(v_z_filt);
vort_x_filt = (v_z_filt_y - v_y_filt_z)./(grad_fact.*resx);
vort_y_filt = (v_x_filt_z - v_z_filt_x)./(grad_fact.*resy);
vort_z_filt = (v_y_filt_x - v_x_filt_y)./(grad_fact.*resz);

% Using a constant dencity for the alfven units
%----------------------------------------------------------------------
Bx_pri = (Bx_dt - Bx_filt)./sqrt(4*pi*n_filt);
Jx_pri = (Jx_dt - Jx_filt)./sqrt(4*pi*n_filt);
v_x_pri = v_x_dt - v_x_filt;
vort_x_pri = vort_x_dt - vort_x_filt;

By_pri = (By_dt - By_filt)./sqrt(4*pi*n_filt);
Jy_pri = (Jy_dt - Jy_filt)./sqrt(4*pi*n_filt);
v_y_pri = v_y_dt - v_y_filt;
vort_y_pri = vort_y_dt - vort_y_filt;

Bz_pri = (Bz_dt - Bz_filt)./sqrt(4*pi*n_filt);
Jz_pri = (Jz_dt - Jz_filt)./sqrt(4*pi*n_filt);
v_z_pri = v_z_dt - v_z_filt;
vort_z_pri = vort_z_dt - vort_z_filt;

WW = v_x_pri.*Bx_pri + v_y_pri.*By_pri + v_z_pri.*Bz_pri;

HH = -(v_x_pri.*vort_x_pri + v_y_pri.*vort_y_pri + v_z_pri.*vort_z_pri)...
    + (Bx_pri.*Jx_pri + By_pri.*Jy_pri +Bz_pri.*Jz_pri);
KK = 0.5.*(v_x_pri.^2 + v_y_pri.^2 + v_z_pri.^2 ...
    + Bx_pri.^2 + By_pri.^2 + Bz_pri.^2  );
KK_R = 0.5.*(v_x_pri.^2 + v_y_pri.^2 + v_z_pri.^2 ...
    - Bx_pri.^2 - By_pri.^2 - Bz_pri.^2  );

W_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,WW);
H_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,HH);
K_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,KK);
KR_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,KK_R);

% This is including the correction from Nobu
%--------------------------------------------------------------------------
K_filt_J_filt_x = (K_filt - KR_filt).*Jx_filt ;
H_filt_B_filt_x = H_filt.*Bx_filt ;
W_filt_ome_filt_x = W_filt.*vort_x_filt ;

K_filt_J_filt_y = (K_filt - KR_filt).*Jy_filt ;
H_filt_B_filt_y = H_filt.*By_filt ;
W_filt_ome_filt_y= W_filt.*vort_y_filt ;

K_filt_J_filt_z = (K_filt - KR_filt).*Jz_filt ;
H_filt_B_filt_z = H_filt.*Bz_filt ;
W_filt_ome_filt_z = W_filt.*vort_z_filt ;
%--------------------------------------------------------------------------



% This is the list of values from the liner combinations
%Xx	Xy	Xz	KHW_Xx	KHW_Xy	KHW_Xz
Coeficcient_025 = [-0.000527206,	-3.86E-05,	0.001820998,	-0.000527206,	-3.86E-05,	0.001820998;
    0.002620198,	0.003438909,	0.000367263,	0.002390187,	0.003833585,	0.000426968;
    0.001187516,	2.95E-05,	0.000323526,	-0.000202175,	-0.000472438,	0.000332304;
    0.000705051,	0.000442428,	0.000898668,	7.40E-05,	0.000272464,	-8.86E-07];


%Xx	Xy	Xz	KHW_Xx	KHW_Xy	KHW_Xz
Coeficcient_1 = [-0.000237823,	0.000329488,	0.000116506,	-0.000237823,	0.000329488,	0.000116506;
    0.001255388,	0.000984037,	0.000431472,	0.001383668,	0.001132884,	0.000532939;
    1.35E-07,	1.20E-05,	-2.94E-05,	0.000329173,	-0.000352335,	-0.000383341;
    9.24E-05,	0.000182779,	0.000188546	2.13E-06,	0.000286343,	-2.95E-06];


%Xx	Xy	Xz	KHW_Xx	KHW_Xy	KHW_Xz
Coeficcient_4 = [-0.000214167,	9.06E-05,	4.89E-05,	-0.000214167,	9.06E-05,	4.89E-05;
    0.001433167,	0.000506811,	0.000576335,	0.001710364,	0.000881001,	0.000596076;
    0.000471995,	-0.000426648,	-5.61E-05,	0.000383813,	-0.000951165,	-0.000353544;
    0.000587131,	-7.87E-05,	1.89E-05,	0.000723724,	-0.000113932,	0.000572511];

%this is to check if it looks better with no coeficcients;
sppp=1;



% this is just for the x component
%tau00 = -tau_nE_tau - tau_v_x_B_tau + tau_J_x_B_tau + tau_Div_tau1; % total tau
%tau01 = -term4_filt + term5_filt + 0.*term6_filt + tau00; % tau HMHD
%tau02 = term3_filt + tau01; % tau MHD

beta_i=0.25;

% When using the three components to get the curl of tau
%compute the components of the taus
curls = 1;
if(curls ==1)
    if(beta_i==0.25)
    tau_M1_x = 0*Coeficcient_025(1,1) + Coeficcient_025(2,1)*Jx_filt + Coeficcient_025(3,1)*Bx_filt + Coeficcient_025(4,1)*vort_x_filt;
    tau_M1_y = 0*Coeficcient_025(1,2) + Coeficcient_025(2,2)*Jy_filt + Coeficcient_025(3,2)*By_filt + Coeficcient_025(4,2)*vort_y_filt;
    tau_M1_z = 0*Coeficcient_025(1,3) + Coeficcient_025(2,3)*Jz_filt + Coeficcient_025(3,3)*Bz_filt + Coeficcient_025(4,3)*vort_z_filt;

    tau_M2_x = 0*Coeficcient_025(1,4) + Coeficcient_025(2,4)*K_filt_J_filt_x + Coeficcient_025(3,4)*H_filt_B_filt_x + Coeficcient_025(4,4)*W_filt_ome_filt_x;
    tau_M2_y = 0*Coeficcient_025(1,5) + Coeficcient_025(2,5)*K_filt_J_filt_y + Coeficcient_025(3,5)*H_filt_B_filt_y + Coeficcient_025(4,5)*W_filt_ome_filt_y;
    tau_M2_z = 0*Coeficcient_025(1,6) + Coeficcient_025(2,6)*K_filt_J_filt_z + Coeficcient_025(3,6)*H_filt_B_filt_z + Coeficcient_025(4,6)*W_filt_ome_filt_z;
    elseif(beta_i==1)
    tau_M1_x = 0*Coeficcient_1(1,1) + Coeficcient_1(2,1)*Jx_filt + Coeficcient_1(3,1)*Bx_filt + Coeficcient_1(4,1)*vort_x_filt;
    tau_M1_y = 0*Coeficcient_1(1,2) + Coeficcient_1(2,2)*Jy_filt + Coeficcient_1(3,2)*By_filt + Coeficcient_1(4,2)*vort_y_filt;
    tau_M1_z = 0*Coeficcient_1(1,3) + Coeficcient_1(2,3)*Jz_filt + Coeficcient_1(3,3)*Bz_filt + Coeficcient_1(4,3)*vort_z_filt;

    tau_M2_x = 0*Coeficcient_1(1,4) + Coeficcient_1(2,4)*K_filt_J_filt_x + Coeficcient_1(3,4)*H_filt_B_filt_x + Coeficcient_1(4,4)*W_filt_ome_filt_x;
    tau_M2_y = 0*Coeficcient_1(1,5) + Coeficcient_1(2,5)*K_filt_J_filt_y + Coeficcient_1(3,5)*H_filt_B_filt_y + Coeficcient_1(4,5)*W_filt_ome_filt_y;
    tau_M2_z = 0*Coeficcient_1(1,6) + Coeficcient_1(2,6)*K_filt_J_filt_z + Coeficcient_1(3,6)*H_filt_B_filt_z + Coeficcient_1(4,6)*W_filt_ome_filt_z;
    elseif(beta_i==4)
    tau_M1_x = 0*Coeficcient_4(1,1) + Coeficcient_4(2,1)*Jx_filt + Coeficcient_4(3,1)*Bx_filt + Coeficcient_4(4,1)*vort_x_filt;
    tau_M1_y = 0*Coeficcient_4(1,2) + Coeficcient_4(2,2)*Jy_filt + Coeficcient_4(3,2)*By_filt + Coeficcient_4(4,2)*vort_y_filt;
    tau_M1_z = 0*Coeficcient_4(1,3) + Coeficcient_4(2,3)*Jz_filt + Coeficcient_4(3,3)*Bz_filt + Coeficcient_4(4,3)*vort_z_filt;

    tau_M2_x = 0*Coeficcient_4(1,4) + Coeficcient_4(2,4)*K_filt_J_filt_x + Coeficcient_4(3,4)*H_filt_B_filt_x + Coeficcient_4(4,4)*W_filt_ome_filt_x;
    tau_M2_y = 0*Coeficcient_4(1,5) + Coeficcient_4(2,5)*K_filt_J_filt_y + Coeficcient_4(3,5)*H_filt_B_filt_y + Coeficcient_4(4,5)*W_filt_ome_filt_y;
    tau_M2_z = 0*Coeficcient_4(1,6) + Coeficcient_4(2,6)*K_filt_J_filt_z + Coeficcient_4(3,6)*H_filt_B_filt_z + Coeficcient_4(4,6)*W_filt_ome_filt_z;
    end


    % This is tau HMHD
    tau01_x = -term4_filt_x + term5_filt_x + 0.*term6_filt_x + tau_total_x; 
    tau01_y = -term4_filt_y + term5_filt_y + 0.*term6_filt_y + tau_total_y;
    tau01_z = -term4_filt_z + term5_filt_z + 0.*term6_filt_z + tau_total_z;

    % This is tau MHD
    tau02_x = term3_filt_x + tau01_x; 
    tau02_y = term3_filt_y + tau01_y;
    tau02_z = term3_filt_z + tau01_z;

  % this it to compute the phase difference 
    [phase_diff_tau_total_tau_M1,~] = Phase_difference3D(tau_total_x,tau_total_y,tau_total_z, ...
    tau_M1_x,tau_M1_y,tau_M1_z,Lx,threshold);

    [phase_diff_tau_total_tau_M2,~] = Phase_difference3D(tau_total_x,tau_total_y,tau_total_z, ...
    tau_M2_x,tau_M2_y,tau_M2_z,Lx,threshold);

    [phase_diff_tau_total_tau_MHD,~] = Phase_difference3D(tau_total_x,tau_total_y,tau_total_z, ...
    tau02_x,tau02_y,tau02_z,Lx,threshold);

    [phase_diff_tau_total_tau_HMHD,~] = Phase_difference3D(tau_total_x,tau_total_y,tau_total_z, ...
    tau01_x,tau01_y,tau01_z,Lx,threshold);    

    [phase_diff_tau_MHD_tau_M1,~] = Phase_difference3D(tau02_x,tau02_y,tau02_z, ...
    tau_M1_x,tau_M1_y,tau_M1_z,Lx,threshold);

    [phase_diff_tau_HMHD_tau_M2,~] = Phase_difference3D(tau01_x,tau01_y,tau01_z, ...
    tau_M2_x,tau_M2_y,tau_M2_z,Lx,threshold);

    % this is for the spectrum
    [Ek_sum_tauHMHD,~]=Omni1DSpectra3c(tau01_x,tau01_y,tau01_z,Lx,threshold);
    [Ek_sum_tauMHD,~]=Omni1DSpectra3c(tau02_x,tau02_y,tau02_z,Lx,threshold);
    [Ek_sum_tau_M1,~]=Omni1DSpectra3c(tau_M1_x,tau_M1_y,tau_M1_z,Lx,threshold);
    [Ek_sum_tau_M2,~]=Omni1DSpectra3c(tau_M2_x,tau_M2_y,tau_M2_z,Lx,threshold);
    [Ek_sum_tau,~]=Omni1DSpectra3c(tau_total_x,tau_total_y,tau_total_z,Lx,threshold);

    
    % Compute gradients of the taus
    [tau_total_x_y, tau_total_x_x, tau_total_x_z] = gradient(tau_total_x);
    [tau_total_y_y, tau_total_y_x, tau_total_y_z] = gradient(tau_total_y);
    [tau_total_z_y, tau_total_z_x, tau_total_z_z] = gradient(tau_total_z);

    [tau_M1_x_y, tau_M1_x_x, tau_M1_x_z] = gradient(tau_M1_x);
    [tau_M1_y_y, tau_M1_y_x, tau_M1_y_z] = gradient(tau_M1_y);
    [tau_M1_z_y, tau_M1_z_x, tau_M1_z_z] = gradient(tau_M1_z);

    [tau_M2_x_y, tau_M2_x_x, tau_M2_x_z] = gradient(tau_M2_x);
    [tau_M2_y_y, tau_M2_y_x, tau_M2_y_z] = gradient(tau_M2_y);
    [tau_M2_z_y, tau_M2_z_x, tau_M2_z_z] = gradient(tau_M2_z);

    [tau01_x_y, tau01_x_x, tau01_x_z] = gradient(tau01_x);
    [tau01_y_y, tau01_y_x, tau01_y_z] = gradient(tau01_y);
    [tau01_z_y, tau01_z_x, tau01_z_z] = gradient(tau01_z);

    [tau02_x_y, tau02_x_x, tau02_x_z] = gradient(tau02_x);
    [tau02_y_y, tau02_y_x, tau02_y_z] = gradient(tau02_y);
    [tau02_z_y, tau02_z_x, tau02_z_z] = gradient(tau02_z);

    %Compute the curls
    curl_tau_total_x = tau_total_z_y/(grad_fact.*resy) - tau_total_y_z/(grad_fact.*resz);
    curl_tau_total_y = tau_total_x_z/(grad_fact.*resz) - tau_total_z_x/(grad_fact.*resx);
    curl_tau_total_z = tau_total_y_x/(grad_fact.*resx) - tau_total_x_y/(grad_fact.*resy);

    curl_tau_M1_x = tau_M1_z_y/(grad_fact.*resy) - tau_M1_y_z/(grad_fact.*resz);
    curl_tau_M1_y = tau_M1_x_z/(grad_fact.*resz) - tau_M1_z_x/(grad_fact.*resx);
    curl_tau_M1_z = tau_M1_y_x/(grad_fact.*resx) - tau_M1_x_y/(grad_fact.*resy);

    curl_tau_M2_x = tau_M2_z_y/(grad_fact.*resy) - tau_M2_y_z/(grad_fact.*resz);
    curl_tau_M2_y = tau_M2_x_z/(grad_fact.*resz) - tau_M2_z_x/(grad_fact.*resx);
    curl_tau_M2_z = tau_M2_y_x/(grad_fact.*resx) - tau_M2_x_y/(grad_fact.*resy);

    curl_tau01_x = tau01_z_y/(grad_fact.*resy) - tau01_y_z/(grad_fact.*resz);
    curl_tau01_y = tau01_x_z/(grad_fact.*resz) - tau01_z_x/(grad_fact.*resx);
    curl_tau01_z = tau01_y_x/(grad_fact.*resx) - tau01_x_y/(grad_fact.*resy);

    curl_tau02_x = tau02_z_y/(grad_fact.*resy) - tau02_y_z/(grad_fact.*resz);
    curl_tau02_y = tau02_x_z/(grad_fact.*resz) - tau02_z_x/(grad_fact.*resx);
    curl_tau02_z = tau02_y_x/(grad_fact.*resx) - tau02_x_y/(grad_fact.*resy);

    curl_tau_total_mag = sqrt(curl_tau_total_x.^2 + curl_tau_total_y.^2 + curl_tau_total_z.^2);
    curl_tau_M1_mag = sqrt(curl_tau_M1_x.^2 + curl_tau_M1_y.^2 + curl_tau_M1_z.^2);
    curl_tau_M2_mag = sqrt(curl_tau_M2_x.^2 + curl_tau_M2_y.^2 + curl_tau_M2_z.^2);
    curl_tau01_mag = sqrt(curl_tau01_x.^2 + curl_tau01_y.^2 + curl_tau01_z.^2);
    curl_tau02_mag = sqrt(curl_tau02_x.^2 + curl_tau02_y.^2 + curl_tau02_z.^2);


     % this it to compute the phase difference for the curl
    [phase_diff_curl_tau_total_tau_M1,~] = Phase_difference3D(curl_tau_total_x,curl_tau_total_y,curl_tau_total_z, ...
    curl_tau_M1_x,curl_tau_M1_y,curl_tau_M1_z,Lx,threshold);

    [phase_diff_curl_tau_total_tau_M2,~] = Phase_difference3D(curl_tau_total_x,curl_tau_total_y,curl_tau_total_z, ...
    curl_tau_M2_x,curl_tau_M2_y,curl_tau_M2_z,Lx,threshold);

    [phase_diff_curl_tau_total_tau_MHD,~] = Phase_difference3D(curl_tau_total_x,curl_tau_total_y,curl_tau_total_z, ...
    curl_tau02_x,curl_tau02_y,curl_tau02_z,Lx,threshold);

    [phase_diff_curl_tau_total_tau_HMHD,~] = Phase_difference3D(curl_tau_total_x,curl_tau_total_y,curl_tau_total_z, ...
    curl_tau01_x,curl_tau01_y,curl_tau01_z,Lx,threshold);    

    [phase_diff_curl_tau_MHD_tau_M1,~] = Phase_difference3D(curl_tau02_x,curl_tau02_y,curl_tau02_z, ...
    curl_tau_M1_x,curl_tau_M1_y,curl_tau_M1_z,Lx,threshold);

    [phase_diff_curl_tau_HMHD_tau_M2,~] = Phase_difference3D(curl_tau01_x,curl_tau01_y,curl_tau01_z, ...
    curl_tau_M2_x,curl_tau_M2_y,curl_tau_M2_z,Lx,threshold);

     % this is for the spectrum
    [Ek_curl_sum_tauHMHD,~]=Omni1DSpectra3c(curl_tau01_x,curl_tau01_y,curl_tau01_z,Lx,threshold);
    [Ek_curl_sum_tauMHD,~]=Omni1DSpectra3c(curl_tau02_x,curl_tau02_y,curl_tau02_z,Lx,threshold);
    [Ek_curl_sum_tau_M1,~]=Omni1DSpectra3c(curl_tau_M1_x,curl_tau_M1_y,curl_tau_M1_z,Lx,threshold);
    [Ek_curl_sum_tau_M2,~]=Omni1DSpectra3c(curl_tau_M2_x,curl_tau_M2_y,curl_tau_M2_z,Lx,threshold);
    [Ek_curl_sum_tau,~]=Omni1DSpectra3c(curl_tau_total_x,curl_tau_total_y,curl_tau_total_z,Lx,threshold);



    sp = 0; % This is for E
    maxx = 1; % To decide whether divide for maximum or not
    fs=25;
     x0=45;y0=54;xx1=900;yy1=500;
   
    f10041=figure(10041);
     set(gcf,'position',[x0,y0,1*xx1,yy1*1])
    subplot(2,1,1)
    %hold on
    dump = (Ek_sum_tau./max(Ek_sum_tau)^maxx);
    loglog(k_bins,dump,'-.',color=My_colors(1,:),LineWidth=2)
    hold on
    dump = (Ek_sum_tau_M1./max(Ek_sum_tau_M1)^maxx);
    loglog(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
    dump = (Ek_sum_tau_M2./max(Ek_sum_tau_M2)^maxx);
    loglog(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
    dump = (Ek_sum_tauMHD./max(Ek_sum_tauMHD)^maxx);
    loglog(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=2)
    dump = (Ek_sum_tauHMHD./max(Ek_sum_tauHMHD)^maxx);
    loglog(k_bins,dump,'-.',color=My_colors(4,:),LineWidth=2)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$P^{1D}/max$';
    ax.XTick = [10^0, 10^1];
    %ax.YTick = [10^-10, 10^-5, 10^0];
    xline(10,'--')
    xline(1,'--')
    %yline(1,'--')
    xline(1*pi/(sqrt(12)*0.59),'k--', LineWidth=1.5)
    xlim([min(k_bins),20])
    %ax.YTick = [10^-4, 10^1];
    ylim([10^(-5),5*10^(0)])

    legend('$\Sigma\tau$',...
        '$\Sigma\tau_{M1}$',...
        '$\Sigma\tau_{M2}$',...
        '$\Sigma \tau_{MHD}$',...
        '$\Sigma \tau_{Hall}$',...
        'Interpreter','latex','NumColumns',5,'Location','southeastoutside')
    hold off

    subplot(2,1,2)
    dump = phase_diff_tau_total_tau_M1;
    semilogx(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
    hold on
    dump = phase_diff_tau_total_tau_M2;
    semilogx(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
    dump = phase_diff_tau_total_tau_MHD;
    semilogx(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=2)
    dump = phase_diff_tau_total_tau_HMHD;
    semilogx(k_bins,dump,'-.',color=My_colors(4,:),LineWidth=2)

    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$\Delta \phi^{\circ} (\Sigma \tau, \Sigma \tau_{j})$';
    ax.XTick = [10^0, 10^1];
    ax.YTick = [0, 90, 180];
    %ax.YTick = [10^-10, 10^-5, 10^0];
    xline(10,'--')
    xline(1,'--')
    %yline(1,'--')
    xline(1*pi/(sqrt(12)*0.59),'k--', LineWidth=1.5)
    xlim([min(k_bins),20])
    %legend( '$\Sigma \tau_{M1},\Sigma \tau$', ...
    %    '$\Sigma \tau_{M2},\Sigma \tau$',...
    %    '$\Sigma \tau_{MHD},\Sigma \tau$',...
    %    '$\Sigma \tau_{Hall},\Sigma \tau$',...
    %    'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    %title('$\beta_{i}=4$', 'Interpreter','latex')
    hold off

  f10042=figure(10042);
     set(gcf,'position',[x0,y0,1*xx1,yy1*1])
    subplot(2,1,1)
    %hold on
    dump = (Ek_curl_sum_tau./max(Ek_curl_sum_tau)^maxx);
    loglog(k_bins,dump,'-.',color=My_colors(1,:),LineWidth=2)
    hold on
    dump = (Ek_curl_sum_tau_M1./max(Ek_curl_sum_tau_M1)^maxx);
    loglog(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
    dump = (Ek_curl_sum_tau_M2./max(Ek_curl_sum_tau_M2)^maxx);
    loglog(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
    dump = (Ek_curl_sum_tauMHD./max(Ek_curl_sum_tauMHD)^maxx);
    loglog(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=2)
    dump = (Ek_curl_sum_tauHMHD./max(Ek_curl_sum_tauHMHD)^maxx);
    loglog(k_bins,dump,'-.',color=My_colors(4,:),LineWidth=2)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    %ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$P^{1D}/max$';
    ax.XTick = [];
    %ax.YTick = [10^-10, 10^-5, 10^0];
    xline(10,'--')
    xline(1,'--')
    %yline(1,'--')
    xline(1*pi/(sqrt(12)*0.59),'k--', LineWidth=1.5)
    xlim([min(k_bins),20])
    %ax.YTick = [10^-4, 10^1];
    ylim([10^(-5),5*10^(0)])

    legend('$\nabla \times \Sigma\tau$',...
        '$\nabla \times\Sigma\tau_{M1}$',...
        '$\nabla \times\Sigma\tau_{M2}$',...
        '$\nabla \times\Sigma \tau_{MHD}$',...
        '$\nabla \times\Sigma \tau_{Hall}$',...
        'Interpreter','latex','NumColumns',5,'Location','southeastoutside')
    hold off

    subplot(2,1,2)
    dump = phase_diff_curl_tau_total_tau_M1;
    semilogx(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
    hold on
    dump = phase_diff_curl_tau_total_tau_M2;
    semilogx(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
    dump = phase_diff_curl_tau_total_tau_MHD;
    semilogx(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=2)
    dump = phase_diff_curl_tau_total_tau_HMHD;
    semilogx(k_bins,dump,'-.',color=My_colors(4,:),LineWidth=2)

    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$\Delta \phi^{\circ} (\nabla \times \tau, \nabla \times \tau_{j})$';
    ax.XTick = [10^0, 10^1];
    ax.YTick = [0, 90, 180];
    %ax.YTick = [10^-10, 10^-5, 10^0];
    xline(10,'--')
    xline(1,'--')
    %yline(1,'--')
    xline(1*pi/(sqrt(12)*0.59),'k--', LineWidth=1.5)
    xlim([min(k_bins),20])
    ylim([0,110])
%    legend( '$\nabla \times\Sigma \tau_{M1},\Sigma \tau$', ...
%        '$\nabla \times\Sigma \tau_{M2},\Sigma \tau$',...
%        '$\nabla \times\Sigma \tau_{MHD},\Sigma \tau$',...
%        '$\Sigma \tau_{Hall},\Sigma \tau$',...
%        'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    %title('$\beta_{i}=4$', 'Interpreter','latex')
    hold off



    f123 =figure(123);
     set(gcf,'position',[x0,y0,1*xx1,yy1*1])
    dump = phase_diff_tau_HMHD_tau_M2;
    semilogx(k_bins,dump,'-.',color=My_colors(4,:),LineWidth=1.5)
    hold on
    dump = phase_diff_tau_MHD_tau_M1;
    semilogx(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=1.5)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$\Delta \phi^{\circ}$';
    ax.XTick = [10^0, 10^1];
    ax.YTick = [0, 90, 180];
    xline(1*pi/(sqrt(12)*0.59),'k--', LineWidth=1.5)
    ylim([0,110])
    xlim([min(k_bins),20])
    legend( '$\Sigma \tau_{Hall},\Sigma \tau_{M2}$',...
        '$\Sigma \tau_{MHD},\Sigma \tau_{M1}$',...
        'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    %title('$\beta_{i}=4$', 'Interpreter','latex')
    hold off


  

    f1230 =figure(1230);
     set(gcf,'position',[x0,y0,1*xx1,yy1*1])
    dump = phase_diff_curl_tau_HMHD_tau_M2;
    semilogx(k_bins,dump,'-.',color=My_colors(4,:),LineWidth=1.5)
    hold on
    dump = phase_diff_curl_tau_MHD_tau_M1;
    semilogx(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=1.5)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$kd_i$';
    ax.YLabel.String = '$\Delta \phi^{\circ}$';
    ax.XTick = [10^0, 10^1];
    ax.YTick = [0, 90, 180];
    xline(1*pi/(sqrt(12)*0.59),'k--', LineWidth=1.5)
    ylim([0,110])
    xlim([min(k_bins),20])
    legend( '$\nabla \times\Sigma \tau_{Hall},\Sigma \tau_{M2}$',...
        '$\nabla \times\Sigma \tau_{MHD},\Sigma \tau_{M1}$',...
        'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
    %title('$\beta_{i}=4$', 'Interpreter','latex')
    hold off


    stopp

    % these plots here is just to see how the curl of the models look in
    % the real space
    cd(path_color)

    x0=45;y0=54;xx1=900;yy1=500;
    i=50;j=50;
    i=50;j=50;

    f555=figure(555);
    set(gcf,'position',[x0,y0,1.0*xx1,1.0*yy1])
    ax1=subplot(2,3,1);
    dum = curl_tau_total_x;
    dump = squeeze(dum(:,:,i));
    hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));
    y_lim = 1.;%max(max(max(abs(dump))));
    hold on
    set(hc,'edgecolor','none')
    clim([-y_lim y_lim]);
    xline(xl(1,j),'--k','LineWidth',1.5)
    cb = colorbar; cb.TickLabelInterpreter = 'Latex';
    colormap(ax1,BWR)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$x/d_i$';
    ax.YLabel.String = '$y/d_i$';
    pbaspect([1 1 1])
    title('$\nabla \times \Sigma \tau_x / max $','Interpreter','latex')
    hold off

    ax1=subplot(2,3,2);
    dum = curl_tau_M1_x;
    dump = squeeze(dum(:,:,i));
    hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));
    y_lim = 1.;%max(max(max(abs(dump))));
    hold on
    set(hc,'edgecolor','none')
    clim([-y_lim y_lim]);
    xline(xl(1,j),'--k','LineWidth',1.5)
    cb = colorbar; cb.TickLabelInterpreter = 'Latex';
    colormap(ax1,BWR)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$x/d_i$';
    ax.YLabel.String = '$y/d_i$';
    pbaspect([1 1 1])
    title('$\nabla \times \Sigma \tau_{M1,x} / max $','Interpreter','latex')
    hold off

    ax1=subplot(2,3,3);
    dum = curl_tau_M2_x;
    dump = squeeze(dum(:,:,i));
    hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));
    y_lim = 1.;%max(max(max(abs(dump))));
    hold on
    set(hc,'edgecolor','none')
    clim([-y_lim y_lim]);
    xline(xl(1,j),'--k','LineWidth',1.5)
    cb = colorbar; cb.TickLabelInterpreter = 'Latex';
    colormap(ax1,BWR)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$x/d_i$';
    ax.YLabel.String = '$y/d_i$';
    pbaspect([1 1 1])
    title('$\nabla \times \Sigma \tau_{M2,x} / max $','Interpreter','latex')
    hold off

    ax1=subplot(2,3,4);
    dum = curl_tau01_x;
    dump = squeeze(dum(:,:,i));
    hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));
    y_lim = 1.;%max(max(max(abs(dump))));
    hold on
    set(hc,'edgecolor','none')
    clim([-y_lim y_lim]);
    xline(xl(1,j),'--k','LineWidth',1.5)
    cb = colorbar; cb.TickLabelInterpreter = 'Latex';
    colormap(ax1,BWR)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$x/d_i$';
    ax.YLabel.String = '$y/d_i$';
    pbaspect([1 1 1])
    title('$\nabla \times \Sigma \tau_{01,x} / max $','Interpreter','latex')
    hold off

    ax1=subplot(2,3,5);
    dum = curl_tau02_x;
    dump = squeeze(dum(:,:,i));
    hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));
    y_lim = 1.;%max(max(max(abs(dump))));
    hold on
    set(hc,'edgecolor','none')
    clim([-y_lim y_lim]);
    xline(xl(1,j),'--k','LineWidth',1.5)
    cb = colorbar; cb.TickLabelInterpreter = 'Latex';
    colormap(ax1,BWR)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$x/d_i$';
    ax.YLabel.String = '$y/d_i$';
    pbaspect([1 1 1])
    title('$\nabla \times \Sigma \tau_{02,x} / max $','Interpreter','latex')
    hold off


    f556=figure(556);
    set(gcf,'position',[x0,y0,1.0*xx1,1.0*yy1])
    ax1=subplot(2,3,1);
    dum = curl_tau_total_mag;
    dump = squeeze(dum(:,:,i));
    hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));
    y_lim = 1.;%max(max(max(abs(dump))));
    hold on
    set(hc,'edgecolor','none')
    clim([-y_lim*0 y_lim]);
    xline(xl(1,j),'--k','LineWidth',1.5)
    cb = colorbar; cb.TickLabelInterpreter = 'Latex';
    colormap(ax1,BWR)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$x/d_i$';
    ax.YLabel.String = '$y/d_i$';
    pbaspect([1 1 1])
    title('$|\nabla \times \Sigma \tau| / max $','Interpreter','latex')
    hold off

    ax1=subplot(2,3,2);
    dum = curl_tau_M1_mag;
    dump = squeeze(dum(:,:,i));
    hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));
    y_lim = 1.;%max(max(max(abs(dump))));
    hold on
    set(hc,'edgecolor','none')
    clim([-y_lim*0 y_lim]);
    xline(xl(1,j),'--k','LineWidth',1.5)
    cb = colorbar; cb.TickLabelInterpreter = 'Latex';
    colormap(ax1,BWR)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$x/d_i$';
    ax.YLabel.String = '$y/d_i$';
    pbaspect([1 1 1])
    title('$|\nabla \times \Sigma \tau_{M1}| / max $','Interpreter','latex')
    hold off

    ax1=subplot(2,3,3);
    dum = curl_tau_M2_mag;
    dump = squeeze(dum(:,:,i));
    hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));
    y_lim = 1.;%max(max(max(abs(dump))));
    hold on
    set(hc,'edgecolor','none')
    clim([-y_lim*0 y_lim]);
    xline(xl(1,j),'--k','LineWidth',1.5)
    cb = colorbar; cb.TickLabelInterpreter = 'Latex';
    colormap(ax1,BWR)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$x/d_i$';
    ax.YLabel.String = '$y/d_i$';
    pbaspect([1 1 1])
    title('$|\nabla \times \Sigma \tau_{M2}| / max $','Interpreter','latex')
    hold off

    ax1=subplot(2,3,4);
    dum = curl_tau01_mag;
    dump = squeeze(dum(:,:,i));
    hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));
    y_lim = 1.;%max(max(max(abs(dump))));
    hold on
    set(hc,'edgecolor','none')
    clim([-y_lim*0 y_lim]);
    xline(xl(1,j),'--k','LineWidth',1.5)
    cb = colorbar; cb.TickLabelInterpreter = 'Latex';
    colormap(ax1,BWR)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$x/d_i$';
    ax.YLabel.String = '$y/d_i$';
    pbaspect([1 1 1])
    title('$|\nabla \times \Sigma \tau_{01}| / max $','Interpreter','latex')
    hold off

    ax1=subplot(2,3,5);
    dum = curl_tau02_mag;
    dump = squeeze(dum(:,:,i));
    hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));
    y_lim = 1.;%max(max(max(abs(dump))));
    hold on
    set(hc,'edgecolor','none')
    clim([-y_lim*0 y_lim]);
    xline(xl(1,j),'--k','LineWidth',1.5)
    cb = colorbar; cb.TickLabelInterpreter = 'Latex';
    colormap(ax1,BWR)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$x/d_i$';
    ax.YLabel.String = '$y/d_i$';
    pbaspect([1 1 1])
    title('$|\nabla \times \Sigma \tau_{02}| / max $','Interpreter','latex')
    hold off
end
%------------------------------------------------------------------------

%stopp

cd(path_color)

% f120=figure(120);
% subplot(1,3,1)
% dum = (-tau_nE_tau - tau_v_x_B_tau)/(256^3);
% histogram(dum);
% subplot(1,3,2)
% dum = -tau_nE_tau/(256^3);
% histogram(dum);
% subplot(1,3,3)
% dum = tau_v_x_B_tau/(256^3);
% histogram(dum);
% dum = tau_nE_tau(abs(-tau_nE_tau - tau_v_x_B_tau)>0 & abs(-tau_nE_tau - tau_v_x_B_tau)<1e-4);
% length(dum)/(256^3)


%{
f121=figure(121);
set(gcf,'position',[x0,y0,1.0*xx1,1.0*yy1])
ax1=subplot(1,2,1);
dum = tau00;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));
y_lim = 1.;%max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
xline(xl(1,j),'--k','LineWidth',1.5)
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(ax1,BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
%title('$m_{e} \nabla cdot \tau(vJ+Jv-JJ/nq))/n$','Interpreter','latex')
%xlim([-15.2 15.2]);
%ylim([-15.2 15.2]);
pbaspect([1 1 1])
title('$\Sigma \tau / max(\Sigma \tau) $','Interpreter','latex')
hold off

ax1=subplot(1,2,2);
%dum = (Jx_dt.*Ex_dt + Jy_dt.*Ey_dt +Jz_dt.*Ez_dt);
dum =Ex_filt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));
y_lim = 1.;%max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
xline(xl(1,j),'--k','LineWidth',1.5)
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(ax1,BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
%title('$m_{e} \nabla cdot \tau(vJ+Jv-JJ/nq))/n$','Interpreter','latex')
%xlim([-15.2 15.2]);
%ylim([-15.2 15.2]);
pbaspect([1 1 1])
title('$Ex$','Interpreter','latex')
%title('$J/cdot E$','Interpreter','latex')
hold off
%}

f1222=figure(1222);
set(gcf,'position',[x0,y0,1.0*xx1,1.0*yy1])
ax1=subplot(1,3,1);
dum = tau00_x;
sum_tau_0 = dum;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));
y_lim = 1.;%max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
xline(xl(1,j),'--k','LineWidth',1.5)
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(ax1,BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
%title('$m_{e} \nabla cdot \tau(vJ+Jv-JJ/nq))/n$','Interpreter','latex')
%xlim([-15.2 15.2]);
%ylim([-15.2 15.2]);
pbaspect([1 1 1])
title('$\Sigma \tau_{x} / \max(\Sigma \tau_{x}) $','Interpreter','latex')
hold off


if (beta_i==0.25)
    ax1=subplot(1,3,2);
    dum = 0*Coeficcient_025(1,1) + Coeficcient_025(2,1)^(sppp)*Jx_filt + Coeficcient_025(3,1)^(sppp)*Bx_filt + Coeficcient_025(4,1)^(sppp)*vort_x_filt;
    sum_tau_model1 = dum;
    dump = squeeze(dum(:,:,i));
    hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));
    y_lim = 1.;%max(max(max(abs(dump))));
    hold on
    set(hc,'edgecolor','none')
    clim([-y_lim y_lim]);
    xline(xl(1,j),'--k','LineWidth',1.5)
    cb = colorbar; cb.TickLabelInterpreter = 'Latex';
    colormap(ax1,BWR)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$x/d_i$';
    ax.YLabel.String = '$y/d_i$';
    %title('$m_{e} \nabla cdot \tau(vJ+Jv-JJ/nq))/n$','Interpreter','latex')
    %xlim([-15.2 15.2]);
    %ylim([-15.2 15.2]);
    pbaspect([1 1 1])
    %title('$\Sigma \tau \sim  a_{\beta}J + a_{\alpha}B + a_{\gamma}\Omega $','Interpreter','latex')
    title('$\Sigma \tau_{M1,x} / \max(\Sigma \tau_{M1,x}) $','Interpreter','latex')
    hold off

    ax1=subplot(1,3,3);
    dum = 0*Coeficcient_025(1,4) + Coeficcient_025(2,4)^(sppp)*K_filt_J_filt_x + Coeficcient_025(3,4)^(sppp)*H_filt_B_filt_x + Coeficcient_025(4,4)^(sppp)*W_filt_ome_filt_x;
    sum_tau_model2 = dum;
    dump = squeeze(dum(:,:,i));
    hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));

elseif(beta_i==1)

    ax1=subplot(1,3,2);
    dum = 0*Coeficcient_1(1,1) + Coeficcient_1(2,1)^(sppp)*Jx_filt + Coeficcient_1(3,1)^(sppp)*Bx_filt + Coeficcient_1(4,1)^(sppp)*vort_x_filt;
    sum_tau_model1 = dum;
    dump = squeeze(dum(:,:,i));
    hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));
    y_lim = 1.;%max(max(max(abs(dump))));
    hold on
    set(hc,'edgecolor','none')
    clim([-y_lim y_lim]);
    xline(xl(1,j),'--k','LineWidth',1.5)
    cb = colorbar; cb.TickLabelInterpreter = 'Latex';
    colormap(ax1,BWR)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$x/d_i$';
    ax.YLabel.String = '$y/d_i$';
    %title('$m_{e} \nabla cdot \tau(vJ+Jv-JJ/nq))/n$','Interpreter','latex')
    %xlim([-15.2 15.2]);
    %ylim([-15.2 15.2]);
    pbaspect([1 1 1])
    %title('$\Sigma \tau \sim  a_{\beta}J + a_{\alpha}B + a_{\gamma}\Omega $','Interpreter','latex')
    hold off

    ax1=subplot(1,3,3);
    dum = 0*Coeficcient_1(1,4) + Coeficcient_1(2,4)^(sppp)*K_filt_J_filt_x + Coeficcient_1(3,4)^(sppp)*H_filt_B_filt_x + Coeficcient_1(4,4)^(sppp)*W_filt_ome_filt_x;
    sum_tau_model2 = dum;
    dump = squeeze(dum(:,:,i));
    hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));

elseif(beta_i == 4)

    ax1=subplot(1,3,2);
    dum = 0*Coeficcient_4(1,1) + Coeficcient_4(2,1)^(sppp)*Jx_filt + Coeficcient_4(3,1)^(sppp)*Bx_filt + Coeficcient_4(4,1)^(sppp)*vort_x_filt;
    sum_tau_model1 = dum;
    dump = squeeze(dum(:,:,i));
    hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));
    y_lim = 1.;%max(max(max(abs(dump))));
    hold on
    set(hc,'edgecolor','none')
    clim([-y_lim y_lim]);
    xline(xl(1,j),'--k','LineWidth',1.5)
    cb = colorbar; cb.TickLabelInterpreter = 'Latex';
    colormap(ax1,BWR)
    set(gca,'FontSize',fs)
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.XLabel.String = '$x/d_i$';
    ax.YLabel.String = '$y/d_i$';
    %title('$m_{e} \nabla cdot \tau(vJ+Jv-JJ/nq))/n$','Interpreter','latex')
    %xlim([-15.2 15.2]);
    %ylim([-15.2 15.2]);
    pbaspect([1 1 1])
    %title('$\Sigma \tau \sim  a_{\beta}J + a_{\alpha}B + a_{\gamma}\Omega $','Interpreter','latex')
    hold off

    ax1=subplot(1,3,3);
    dum = 0*Coeficcient_4(1,4) + Coeficcient_4(2,4)^(sppp)*K_filt_J_filt_x + Coeficcient_4(3,4)^(sppp)*H_filt_B_filt_x + Coeficcient_4(4,4)^(sppp)*W_filt_ome_filt_x;
    sum_tau_model2 = dum;
    dump = squeeze(dum(:,:,i));
    hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));

end

y_lim = 1.;%max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
xline(xl(1,j),'--k','LineWidth',1.5)
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(ax1,BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
title('$\beta_{i}=025$','Interpreter','latex')
%xlim([-15.2 15.2]);
%ylim([-15.2 15.2]);
pbaspect([1 1 1])
%title('$\Sigma \tau \sim  a_{\beta}KJ + a_{\alpha}HB + a_{\gamma}W\Omega $','Interpreter','latex')
title('$\Sigma \tau_{M2,x} / \max(\Sigma \tau_{M2,x}) $','Interpreter','latex')
hold off





% f123=figure(123);
% set(gcf,'position',[x0,y0,1.0*xx1,1.0*yy1])
%
% ax1=subplot(1,3,1);
% dum = -tau_nE_tau - tau_v_x_B_tau + tau_J_x_B_tau + tau_Div_tau1;
% dump = squeeze(dum(:,:,i));
% hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));
% y_lim = 1.;%max(max(max(abs(dump))));
% hold on
% set(hc,'edgecolor','none')
% clim([-y_lim y_lim]);
% xline(xl(1,j),'--k','LineWidth',1.5)
% cb = colorbar; cb.TickLabelInterpreter = 'Latex';
% colormap(ax1,BWR)
% set(gca,'FontSize',fs)
% ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
% ax.XLabel.String = '$x/d_i$';
% ax.YLabel.String = '$y/d_i$';
% title('$m_{e} \nabla cdot \tau(vJ+Jv-JJ/nq))/n$','Interpreter','latex')
% xlim([-15.2 15.2]);
% ylim([-15.2 15.2]);
% pbaspect([1 1 1])
% title('$\Sigma \tau_y / max(\Sigma \tau) $','Interpreter','latex')
% hold off
%
% ax1=subplot(1,3,2);
% dum = 0*Coeficcient_025(1,2) + Coeficcient_025(2,2)^(sppp)*Jy_filt + Coeficcient_025(3,2)^(sppp)*By_filt + Coeficcient_025(4,2)^(sppp)*vort_y_filt;
% dump = squeeze(dum(:,:,i));
% hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));
% y_lim = 1.;%max(max(max(abs(dump))));
% hold on
% set(hc,'edgecolor','none')
% clim([-y_lim y_lim]);
% xline(xl(1,j),'--k','LineWidth',1.5)
% cb = colorbar; cb.TickLabelInterpreter = 'Latex';
% colormap(ax1,BWR)
% set(gca,'FontSize',fs)
% ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
% ax.XLabel.String = '$x/d_i$';
% ax.YLabel.String = '$y/d_i$';
% title('$m_{e} \nabla cdot \tau(vJ+Jv-JJ/nq))/n$','Interpreter','latex')
% xlim([-15.2 15.2]);
% ylim([-15.2 15.2]);
% pbaspect([1 1 1])
% title('$\Sigma \tau \sim  a_{\beta}J + a_{\alpha}B + a_{\gamma}\Omega $','Interpreter','latex')
% hold off
%
%
% ax1=subplot(1,3,3);
% dum = 0*Coeficcient_025(1,5) + Coeficcient_025(2,5)^(sppp)*K_filt_J_filt_y + Coeficcient_025(3,5)^(sppp)*H_filt_B_filt_y + Coeficcient_025(4,5)^(sppp)*W_filt_ome_filt_y;
% dump = squeeze(dum(:,:,i));
% hc=pcolor(xl,yl,dump/max(max(max(abs(dump)))));
% y_lim = 1.;%max(max(max(abs(dump))));
% hold on
% set(hc,'edgecolor','none')
% clim([-y_lim y_lim]);
% xline(xl(1,j),'--k','LineWidth',1.5)
% cb = colorbar; cb.TickLabelInterpreter = 'Latex';
% colormap(ax1,BWR)
% set(gca,'FontSize',fs)
% ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
% ax.XLabel.String = '$x/d_i$';
% ax.YLabel.String = '$y/d_i$';
% title('$\beta_{i}=0.25$','Interpreter','latex')
% xlim([-15.2 15.2]);
% ylim([-15.2 15.2]);
% pbaspect([1 1 1])
% title('$\Sigma \tau \sim  a_{\beta}KJ + a_{\alpha}HB + a_{\gamma}W\Omega $','Interpreter','latex')
% hold off


%cd('~/Downloads')
%saveas(f122,strcat(num2str(component),'tau_comparison_beta025_x.png'));




%cd('~/Downloads')
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


%----------------------------------------------------------------------
function[Jx_filt] = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,Jx_dt)
% Apply a low-pass Gaussian filter to remove high frequencies
sigma = Dx; % Adjust as needed for filtering strength
filter = exp(-(Kx.^2 + Ky.^2 + Kz.^2) * 0.5 * sigma^2);
% Fourier transforms of vector-field components
Jx_hat = fftn(Jx_dt) .* filter;
Jx_filt = real(ifftn(Jx_hat));
end
%----------------------------------------------------------------------

