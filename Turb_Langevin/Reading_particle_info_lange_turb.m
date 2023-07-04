%#-----------------------------------------------------------------------
%This is the script to read the particle infoprmation
% Currently the program does not create a xdmf but only a .h5
%#----------------------------------------------------------------------
 
%th 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/checking_stages/psc_harris_yz_base_3_adios2';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_cpinch_sSR_prt';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_cpinch_sSR_lange_prt';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_cpinch_sSR/particle_late';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_cpinch_sSR_lange/particle_late';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_olong_kLd16';
path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB04_olong_kLd4';


%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB02_olong_kLd2';
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kLd1';
path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_cpinch_sSR_prt';

path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
path_s = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(path)
mime =1.;
omega_pe_Omega_ce=5;
S = dir(fullfile(path,'prt.*'));
N=numel(S); % number of files to use
H=zeros(N);
i=1;

% This is the loop to calculate the VDF of the particles
%
%for i=1:N
i=N;
    disp(strcat('Computing step ...',S(i).name)) 
    fileID =  S(i).name; %change the 1 per i
    %h5disp(fileID); %this is the command to show the information in the file 
    info = h5info(fileID);    
    %info = h5info(fileID,'TextEncoding','UTF-8');
    
    prt = info.Groups(1).Name;
    %read the information from the fields of the struct
    prtfields=h5read(fileID,strcat(prt,'/p0/1d'));
    %x = prtfields.x;
    y = prtfields.y;
    z = prtfields.z;
    px = prtfields.px;
    py = prtfields.py;
    pz = prtfields.pz;
    q = prtfields.q;
    %m = prtfields.m;
    %w = prtfields.w;

    %separate the popullations
    
    q_i_index = find(q==1);
    %Coordinates of ions
    %xi=x(q_i_index); yi=y(q_i_index); zi=z(q_i_index);
    pxi=px(q_i_index); pyi=py(q_i_index); pzi=pz(q_i_index);
    qi=q(q_i_index);

    yi=y(q_i_index); zi=z(q_i_index); 

%     q_e_index = find(q==-1);
%     %Coordinates of electrons
%     %xe=x(q_e_index); ye=y(q_e_index); ze=z(q_e_index);
%     pxe=px(q_e_index); pye=py(q_e_index); pze=pz(q_e_index);
%     qe=q(q_e_index);
  
    clearvars px py pz q
    % To get the particle info in a sub-region

%     % for the limits dB01kd1
%     %----------------------------------------------------------------------    
%     yii1 = 10; yii2 = 20; zii1=0; zii2=20; % 1 is out 
%     yjj1 = -5; yjj2 = 5; zjj1=0; zjj2=20; % 2 is in
%     %----------------------------------------------------------------------

    % for the limits inside island central pinch
    %----------------------------------------------------------------------    
    yii1 = 10; yii2 = 20; zii1=30; zii2=50; % 1 is out 
    yjj1 = -5; yjj2 = 5; zjj1=30; zjj2=50; % 2 is in
    %----------------------------------------------------------------------

%     % for the dB02kd2 island
%     %----------------------------------------------------------------------    
%     yii1 = 10; yii2 = 20; zii1=-30; zii2=-10; % 1 is out 
%     yjj1 = -5; yjj2 = 5; zjj1=-30; zjj2=-10; % 2 is in
%     %----------------------------------------------------------------------
%     %----------------------------------------------------------------------    
%     yii1 = 10; yii2 = 20; zii1=-70; zii2=-50; % 1 is out 
%     yjj1 = -5; yjj2 = 5; zjj1=-70; zjj2=-50; % 2 is in
%     %----------------------------------------------------------------------

    % This is to get the subregion
    % Reconnecting
    %----------------------------------------------------------------------
    %yii1 = 10; yii2 = 20; zii1=-10; zii2=10; % 1 is out 
    %yjj1 = -5; yjj2 = 5; zjj1=-10; zjj2=10; % 2 is in
    %----------------------------------------------------------------------
    % Lange disruption
    %----------------------------------------------------------------------
    %yii1 = 10; yii2 = 20; zii1=-60; zii2=-40; % 1 is out 
    %yjj1 = -5; yjj2 = 5; zjj1=-60; zjj2=-40; % 2 is in
    %----------------------------------------------------------------------
    
    % for the case of dB04_kd4
    %----------------------------------------------------------------------
    cond_y1 = find((yi>yii1) & (yii2>yi) & (zi>zii1) & (zii2>zi) );  % out   
    cond_y2 = find((yi>yjj1) & (yjj2>yi) & (zi>zjj1) & (zjj2>zi) );  % in  
    %----------------------------------------------------------------------

    pxi_sub1=pxi(cond_y1); 
    pyi_sub1=pyi(cond_y1); 
    pzi_sub1=pzi(cond_y1);    

    pxi_sub2=pxi(cond_y2); 
    pyi_sub2=pyi(cond_y2); 
    pzi_sub2=pzi(cond_y2);   

    clearvars pxi pyi pzi

    %To make the coordinate transformation 
    %----------------------------------------------------------------------
    Sf = dir(fullfile(path,'pfd.*.h5'));
    Nf=numel(Sf); % number of files to use
    H=zeros(Nf);   
    in = Nf;
    disp(strcat('Computing step ...',Sf(in).name))
    fileID =  Sf(in).name; %change the 1 per i
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
    %--------------------------------------------------------------------------
    Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
    Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d')); 

    sli_x = 1;
    Bx = squeeze(Bx(sli_x,:,:));
    By = squeeze(By(sli_x,:,:));
    Bz = squeeze(Bz(sli_x,:,:));

    sss=size(Bx);
    size_X=sss;
    zll=linspace(-Lz,Lz,size_X(2)); %Jeff flag it works with (1,size_x(2))
    yll=linspace(-Ly,Ly,size_X(1));
    [ZLL, YLL] = meshgrid(zll,yll);

    % out
    cond_ii = (YLL>yii1).*(YLL<yii2).*(ZLL>zii1).*(ZLL<zii2);
    Bxout = Bx.*cond_ii; Bxout(Bxout==0)=NaN; 
    Byout = By.*cond_ii; Byout(Byout==0)=NaN;
    Bzout = Bz.*cond_ii; Bzout(Bzout==0)=NaN;
    
    % in 
    cond_jj = (YLL>yjj1).*(YLL<yjj2).*(ZLL>zjj1).*(ZLL<zjj2);
    Bxin = Bx.*cond_jj; Bxin(Bxin==0)=NaN; 
    Byin = By.*cond_jj; Byin(Byin==0)=NaN;
    Bzin = Bz.*cond_jj; Bzin(Bzin==0)=NaN; 
    %----------------------------------------------------------------------

    % Now lets compute the averages to get the parallel and perpendicular

    % remove the NaNs
    Bxout(isnan(Bxout)) = []; Byout(isnan(Byout)) = [];  Bzout(isnan(Bzout)) = [];
    Bxout_av = mean(Bxout,'all'); Byout_av = mean(Byout,'all'); Bzout_av = mean(Bzout,'all');
    Bout_m_av = sqrt(Bxout_av.^2 + Byout_av.^2 + Bzout_av.^2);

    % remove the NaNs
    Bxin(isnan(Bxin)) = []; Byin(isnan(Byin)) = [];  Bzin(isnan(Bzin)) = [];
    Bxin_av = mean(Bxin,'all'); Byin_av = mean(Byin,'all'); Bzin_av = mean(Bzin,'all');
    Bin_m_av = sqrt(Bxin_av.^2 + Byin_av.^2 + Bzin_av.^2);

    %----------------------------------------------------------------------
    % Define the initial coordinates
    xx = [1; 0; 0]; % Example x-coordinate
    yy = [0; 1; 0]; % Example y-coordinate
    zz = [0; 0; 1]; % Example z-coordinate

    % Define the magnetic field vector
    B = [Bxin_av; Byin_av; Bzin_av]; % Example magnetic field vector

    % Normalize the magnetic field vector
    B_normalized = B / norm(B);

    % Calculate the rotation axis
    R = cross(B_normalized, [1; 0; 0]); % Cross product with x-axis

    % Calculate the rotation angle
    theta = acos(dot(B_normalized, [1; 0; 0])); % Dot product with x-axis

    % Create the rotation matrix
    K = [0 -R(3) R(2); R(3) 0 -R(1); -R(2) R(1) 0]; % Skew-symmetric matrix
    R_matrix = eye(3) + sin(theta) * K + (1 - cos(theta)) * K^2; % Rodrigues' rotation formula

    % Perform the coordinate transformation
    transformed_coords = R_matrix * [xx'; yy'; zz'];

    % Extract the transformed coordinates
    x_prime = transformed_coords(1, :)';
    y_prime = transformed_coords(2, :)';
    z_prime = transformed_coords(3, :)';

    % Define the vector in the initial reference frame
    v_initial_1 = [pxi_sub1, pyi_sub1, pzi_sub1]'; % Example vector in the initial reference frame
    v_initial_2 = [pxi_sub2, pyi_sub2, pzi_sub2]'; % Example vector in the initial reference frame

    % Calculate the inverse of the rotation matrix
    R_inverse = inv(R_matrix); % Inverse of the rotation matrix A\b

    % Express the vector in the new reference frame
    v_new_1 = R_matrix \ v_initial_1;
    v_new_2 = R_matrix \ v_initial_2;

    v_new_par_1 = v_new_1(1,:);
    v_new_per_1 = sqrt(v_new_1(2,:).^2 + v_new_1(3,:).^2);

    v_new_par_2 = v_new_2(1,:);
    v_new_per_2 = sqrt(v_new_2(2,:).^2 + v_new_2(3,:).^2);
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    str = string(S(i).name);
    newStr = extractBetween(str,"prt.","_p000000.h5");
    N_steps = str2double(newStr);
    dt = 0.0653;% <--- This has to come from the field data because this do not store the time resolution
    time_t = dt*N_steps;
    time_t_2_Omega=time_t./omega_pe_Omega_ce;
    %xspace = [-0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6];
    
    % reconnecting
    %----------------------------------------------------------------------
%     xspace = [-0.4, -0.2, 0, 0.2, 0.4];
%     xlims = [-0.5, 0.5];
%     Xedges2D = linspace(-0.5,0.5);
%     Yedges2D = linspace(-0.5,0.5);
    %----------------------------------------------------------------------
    
    % disrupting
    %----------------------------------------------------------------------
    xspace = [-1.0, -0.5, 0, 0.5, 1.0];
    xlims = [-1.0, 1.0];
    Xedges2D = linspace(-1.0,1.0);
    Yedges2D = linspace(-1.0,1.0);
    %----------------------------------------------------------------------

    % disrupting
    %----------------------------------------------------------------------
    xspace_par = [-1.0, -0.5, 0, 0.5, 1.0];
    yspace_per = [0, 0.5, 1.0];
    xlims = [-1.0, 1.0];
    ylims = [0.0, 1.0];
    Xedges2D = linspace(-1.0,1.0);
    Yedges2D = linspace(0.0,1.0);
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    % Noise level
    no_le=1;
    %----------------------------------------------------------------------

    % plots in the par per plane
    %----------------------------------------------------------------------
    cd(path_s) 
    fs=18;  x0=45;  y0=54;  xx1=1210;    yy1=510;
    %----------------------------------------------------------------------
    f12=figure(12);
    set(gcf,'position',[x0,y0,xx1,yy1])
    h1=subaxis(1,2,1,'SV',0.01,'SH',0.004,'MR',0.01,'ML',0.05,'PL',0.01,'PR',0.006);
    dum1 = v_new_par_2; dum2 = v_new_per_2;    
    [Ni,Xedgesi,Redgesi] = histcounts2(dum1,dum2,Xedges2D,Yedges2D);
    Ni=Ni(1:99,1:99)';    Xedges2i=Xedgesi(2:100)'; Redges2i=Redgesi(2:100)';
    %c_lim = (max(max(Ni)));
    c_lim=0.5*10^6;
    Xedges2i=Xedges2i-(Xedges2i(2)-Xedges2i(1))/2;    
    Redges2i=Redges2i-(Redges2i(2)-Redges2i(1))/2;
    Ni(Ni<=no_le)=NaN;
    [Ci,Di]=meshgrid(Xedges2i,Redges2i);
    hc=pcolor(Xedges2i,Redges2i, Ni./Di);
    hold on
    set(hc,'edgecolor','none');
    set(gca,'ColorScale','log','FontSize',fs)
    set(gca,'XScale','lin','YScale','lin','FontSize',fs)
    colormap(h1,'jet');
    caxis([1 (c_lim)]); %hcb.Ticks = linspace(-0.8,0.8,5); hcb.TickLabels = [-0.8,-0.4,0,0.4,0.8] ;  
    hcb=colorbar; hcb.Location = 'northoutside'; %hcb.Ruler.Exponent = -2;
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.XLabel.String = '$v_{\parallel}$'; ax.XTick = xspace_par;
    ax.YLabel.String = '$v_{\perp}$'; ax.YTick = yspace_per;
    xline(0,'--k'); yline(0,'--k');
    xlim(xlims); ylim(ylims); 
    title('In','Interpreter','latex','FontSize',fs');
    pbaspect([2 1 1])
    hold off
    %----------------------------------------------------------------------
    h2=subaxis(1,2,2,'SV',0.01,'SH',0.004,'MR',0.01,'ML',0.07,'PL',0.005,'PR',0.006);
    dum1 = v_new_par_1; dum2 = v_new_per_1;  
    [Ni,Xedgesi,Redgesi] = histcounts2(dum1,dum2,Xedges2D,Yedges2D);
    Ni=Ni(1:99,1:99)';    Xedges2i=Xedgesi(2:100)'; Redges2i=Redgesi(2:100)';
    Xedges2i=Xedges2i-(Xedges2i(2)-Xedges2i(1))/2;    
    Redges2i=Redges2i-(Redges2i(2)-Redges2i(1))/2;
    [Ci,Di]=meshgrid(Xedges2i,Redges2i);
    %c_lim = (max(max(Ni)));
    c_lim=0.5*10^6;
    Ni(Ni<=no_le)=NaN;
    hc=pcolor(Xedges2i,Redges2i, Ni./Di);
    hold on
    set(hc,'edgecolor','none');
    set(gca,'ColorScale','log','FontSize',fs)
    set(gca,'XScale','lin','YScale','lin','FontSize',fs)
    colormap(h2,'jet');
    caxis([1 (c_lim)]); %hcb.Ticks = linspace(-0.8,0.8,5); hcb.TickLabels = [-0.8,-0.4,0,0.4,0.8] ;  
    hcb=colorbar; hcb.Location = 'northoutside'; %hcb.Ruler.Exponent = -2;
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.XLabel.String = '$v_{\parallel}$'; ax.XTick = xspace_par;
    %ax.YLabel.String = '$v_{\perp}$'; 
    ax.YTick = yspace_per;
    xline(0,'--k'); yline(0,'--k');
    xlim(xlims); ylim(ylims);
    title('Out','Interpreter','latex','FontSize',fs);
    pbaspect([2 1 1])
    hold off
    %----------------------------------------------------------------------
    sgtitle('$$log(f_{i}) \ ; \ t = \ $$'+string(round(time_t_2_Omega,2))+'$$\ \Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
    %----------------------------------------------------------------------
    cd(path)
    saveas(f12,strcat('large_vper_par_in_out_island_' + string(round(time_t_2_Omega,2)) +'.png'));
    %----------------------------------------------------------------------


    % For the x y and z coordinates
    %----------------------------------------------------------------------
    xspace = [-1.0, -0.5, 0, 0.5, 1.0];
    xlims = [-1.0, 1.0];
    Xedges2D = linspace(-1.0,1.0);
    Yedges2D = linspace(-1.0,1.0);
    %----------------------------------------------------------------------

    % plots in the x, y, z coordinates
    %----------------------------------------------------------------------
    cd(path_s) 
    fs=18;  x0=45;  y0=54;  xx1=1210;    yy1=510;
    %----------------------------------------------------------------------
    f1=figure(1);
    set(gcf,'position',[x0,y0,xx1,yy1])
    h1=subaxis(1,3,1,'SV',0.01,'SH',0.004,'MR',0.01,'ML',0.05,'PL',0.01,'PR',0.006);
    dum1 = pzi_sub1; dum2 = pyi_sub1;    
    [Ni,Xedgesi,Redgesi] = histcounts2(dum1,dum2,Xedges2D,Yedges2D);
    Ni=Ni(1:99,1:99)';    Xedges2i=Xedgesi(2:100)'; Redges2i=Redgesi(2:100)';
    %c_lim = (max(max(Ni)));
    c_lim=0.5*10^6;
    Xedges2i=Xedges2i-(Xedges2i(2)-Xedges2i(1))/2;    
    Redges2i=Redges2i-(Redges2i(2)-Redges2i(1))/2;
    Ni(Ni<=no_le)=NaN;
    hc=pcolor(Xedges2i,Redges2i, Ni);
    hold on
    set(hc,'edgecolor','none');
    set(gca,'ColorScale','log','FontSize',fs)
    set(gca,'XScale','lin','YScale','lin','FontSize',fs)
    colormap(h1,'jet');
    caxis([1 (c_lim)]); %hcb.Ticks = linspace(-0.8,0.8,5); hcb.TickLabels = [-0.8,-0.4,0,0.4,0.8] ;  
    hcb=colorbar; hcb.Location = 'northoutside'; %hcb.Ruler.Exponent = -2;
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.XLabel.String = '$v_{z}$'; ax.XTick = xspace;
    ax.YLabel.String = '$v_{y}$'; ax.YTick = xspace;
    xline(0,'--k'); yline(0,'--k');
    xlim(xlims); ylim(xlims); 
    hold off
    %----------------------------------------------------------------------
    h2=subaxis(1,3,2,'SV',0.01,'SH',0.004,'MR',0.01,'ML',0.07,'PL',0.005,'PR',0.006);
    dum1 = pzi_sub1; dum2 = pxi_sub1;    
    [Ni,Xedgesi,Redgesi] = histcounts2(dum1,dum2,Xedges2D,Yedges2D);
    Ni=Ni(1:99,1:99)';    Xedges2i=Xedgesi(2:100)'; Redges2i=Redgesi(2:100)';
    Xedges2i=Xedges2i-(Xedges2i(2)-Xedges2i(1))/2;    
    Redges2i=Redges2i-(Redges2i(2)-Redges2i(1))/2;
    %c_lim = (max(max(Ni)));
    c_lim=0.5*10^6;
    Ni(Ni<=no_le)=NaN;
    hc=pcolor(Xedges2i,Redges2i, Ni);
    hold on
    set(hc,'edgecolor','none');
    set(gca,'ColorScale','log','FontSize',fs)
    set(gca,'XScale','lin','YScale','lin','FontSize',fs)
    colormap(h2,'jet');
    caxis([1 (c_lim)]); %hcb.Ticks = linspace(-0.8,0.8,5); hcb.TickLabels = [-0.8,-0.4,0,0.4,0.8] ;  
    hcb=colorbar; hcb.Location = 'northoutside'; %hcb.Ruler.Exponent = -2;
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.XLabel.String = '$v_{z}$'; ax.XTick = xspace;
    ax.YLabel.String = '$v_{x}$'; ax.YTick = [];
    xline(0,'--k'); yline(0,'--k');
    xlim(xlims); ylim(xlims);
    hold off
    %----------------------------------------------------------------------
    h3=subaxis(1,3,3,'SV',0.01,'SH',0.004,'MR',0.01,'ML',0.1,'PL',0.005,'PR',0.006);
    dum1 = pyi_sub1; dum2 = pxi_sub1;    
    [Ni,Xedgesi,Redgesi] = histcounts2(dum1,dum2,Xedges2D,Yedges2D);
    Ni=Ni(1:99,1:99)';    Xedges2i=Xedgesi(2:100)'; Redges2i=Redgesi(2:100)';
    Xedges2i=Xedges2i-(Xedges2i(2)-Xedges2i(1))/2;    
    Redges2i=Redges2i-(Redges2i(2)-Redges2i(1))/2;
    Redges2i=Redges2i-(Redges2i(2)-Redges2i(1))/2;
    %c_lim = (max(max(Ni)));
    c_lim=0.5*10^6;
    Ni(Ni<=no_le)=NaN;
    hc=pcolor(Xedges2i,Redges2i, Ni);
    hold on
    set(hc,'edgecolor','none');
    set(gca,'ColorScale','log','FontSize',fs)
    set(gca,'XScale','lin','YScale','lin','FontSize',fs)
    colormap(h3,'jet');
    caxis([1 (c_lim)]); %hcb.Ticks = linspace(-0.8,0.8,5); hcb.TickLabels = [-0.8,-0.4,0,0.4,0.8] ;  
    hcb=colorbar; hcb.Location = 'northoutside'; %hcb.Ruler.Exponent = -2;
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.XLabel.String = '$v_{y}$'; ax.XTick = xspace;
    ax.YLabel.String = '$v_{x}$'; ax.YTick = [];
    xline(0,'--k'); yline(0,'--k');
    xlim(xlims); ylim(xlims);
    hold off
    %----------------------------------------------------------------------
    sgtitle('$$Out \ log(f_{i}) \ ; \ t = \ $$'+string(round(time_t_2_Omega,2))+'$$\ \Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
    
    %----------------------------------------------------------------------
    f2=figure(2);
    set(gcf,'position',[x0,y0,xx1,yy1])
    h1=subaxis(1,3,1,'SV',0.01,'SH',0.004,'MR',0.01,'ML',0.05,'PL',0.01,'PR',0.006);
    dum1 = pzi_sub2; dum2 = pyi_sub2;    
    [Ni,Xedgesi,Redgesi] = histcounts2(dum1,dum2,Xedges2D,Yedges2D);
    Ni=Ni(1:99,1:99)';    Xedges2i=Xedgesi(2:100)'; Redges2i=Redgesi(2:100)';
    %c_lim = (max(max(Ni)));
    c_lim=0.5*10^6;
    Xedges2i=Xedges2i-(Xedges2i(2)-Xedges2i(1))/2;    
    Redges2i=Redges2i-(Redges2i(2)-Redges2i(1))/2;
    Ni(Ni<=no_le)=NaN;
    hc=pcolor(Xedges2i,Redges2i, Ni);
    hold on
    set(hc,'edgecolor','none');
    set(gca,'ColorScale','log','FontSize',fs)
    set(gca,'XScale','lin','YScale','lin','FontSize',fs)
    colormap(h1,'jet');
    caxis([1 (c_lim)]); %hcb.Ticks = linspace(-0.8,0.8,5); hcb.TickLabels = [-0.8,-0.4,0,0.4,0.8] ;  
    hcb=colorbar; hcb.Location = 'northoutside'; %hcb.Ruler.Exponent = -2;
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.XLabel.String = '$v_{z}$'; ax.XTick = xspace;
    ax.YLabel.String = '$v_{y}$'; ax.YTick = xspace;
    xline(0,'--k'); yline(0,'--k');
    xlim(xlims); ylim(xlims);
    hold off
    %----------------------------------------------------------------------
    h2=subaxis(1,3,2,'SV',0.01,'SH',0.004,'MR',0.01,'ML',0.07,'PL',0.005,'PR',0.006);
    dum1 = pzi_sub2; dum2 = pxi_sub2;    
    [Ni,Xedgesi,Redgesi] = histcounts2(dum1,dum2,Xedges2D,Yedges2D);
    Ni=Ni(1:99,1:99)';    Xedges2i=Xedgesi(2:100)'; Redges2i=Redgesi(2:100)';
    Xedges2i=Xedges2i-(Xedges2i(2)-Xedges2i(1))/2;    
    Redges2i=Redges2i-(Redges2i(2)-Redges2i(1))/2;
    %c_lim = (max(max(Ni)));
    c_lim=0.5*10^6;
    Ni(Ni<=no_le)=NaN;
    hc=pcolor(Xedges2i,Redges2i, Ni);
    hold on
    set(hc,'edgecolor','none');
    set(gca,'ColorScale','log','FontSize',fs)
    set(gca,'XScale','lin','YScale','lin','FontSize',fs)
    colormap(h2,'jet');
    caxis([1 (c_lim)]); %hcb.Ticks = linspace(-0.8,0.8,5); hcb.TickLabels = [-0.8,-0.4,0,0.4,0.8] ;  
    hcb=colorbar; hcb.Location = 'northoutside'; %hcb.Ruler.Exponent = -2;
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.XLabel.String = '$v_{z}$'; ax.XTick = xspace;
    ax.YLabel.String = '$v_{x}$'; ax.YTick = [];
    xline(0,'--k'); yline(0,'--k');
    xlim(xlims); ylim(xlims);
    hold off
    %----------------------------------------------------------------------
    h3=subaxis(1,3,3,'SV',0.01,'SH',0.004,'MR',0.01,'ML',0.1,'PL',0.005,'PR',0.006);
    dum1 = pyi_sub2; dum2 = pxi_sub2;    
    [Ni,Xedgesi,Redgesi] = histcounts2(dum1,dum2,Xedges2D,Yedges2D);
    Ni=Ni(1:99,1:99)';    Xedges2i=Xedgesi(2:100)'; Redges2i=Redgesi(2:100)';
    Xedges2i=Xedges2i-(Xedges2i(2)-Xedges2i(1))/2;    
    Redges2i=Redges2i-(Redges2i(2)-Redges2i(1))/2;
    Redges2i=Redges2i-(Redges2i(2)-Redges2i(1))/2;
    %c_lim = (max(max(Ni)));
    c_lim=0.5*10^6;
    Ni(Ni<=no_le)=NaN;
    hc=pcolor(Xedges2i,Redges2i, Ni);
    hold on
    set(hc,'edgecolor','none');
    set(gca,'ColorScale','log','FontSize',fs)
    set(gca,'XScale','lin','YScale','lin','FontSize',fs)
    colormap(h3,'jet');
    caxis([1 (c_lim)]); %hcb.Ticks = linspace(-0.8,0.8,5); hcb.TickLabels = [-0.8,-0.4,0,0.4,0.8] ;  
    hcb=colorbar; hcb.Location = 'northoutside'; %hcb.Ruler.Exponent = -2;
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.XLabel.String = '$v_{y}$'; ax.XTick = xspace;
    ax.YLabel.String = '$v_{x}$'; ax.YTick = [];
    xline(0,'--k'); yline(0,'--k');
    xlim(xlims); ylim(xlims);
    hold off
    %----------------------------------------------------------------------
    sgtitle('$$In \ log(f_{i}) \ ; \ t = \ $$'+string(round(time_t_2_Omega,2))+'$$\ \Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
    %----------------------------------------------------------------------    

    %----------------------------------------------------------------------
    %cd(path_comp)
    cd(path)
    saveas(f1,strcat('large_vxvyvz_i_sub_out_disr_8' + string(round(time_t_2_Omega,2)) +'.png'));
    saveas(f2,strcat('large_vxvyvz_i_sub_in_disr_8' + string(round(time_t_2_Omega,2)) +'.png'));
    %----------------------------------------------------------------------


% %     % total particle file
% %     %----------------------------------------------------------------------
% %     cd(path_s) 
% %     fs=18;  x0=45;  y0=54;  xx1=1210;    yy1=510;
% %     %----------------------------------------------------------------------
% %     f3=figure(3);
% %     set(gcf,'position',[x0,y0,xx1,yy1])
% %     h1=subaxis(1,3,1,'SV',0.01,'SH',0.004,'MR',0.01,'ML',0.05,'PL',0.01,'PR',0.006);
% %     dum1 = pzi; dum2 = pyi;    
% %     [Ni,Xedgesi,Redgesi] = histcounts2(dum1,dum2,Xedges2D,Yedges2D);
% %     Ni=Ni(1:99,1:99)';    Xedges2i=Xedgesi(2:100)'; Redges2i=Redgesi(2:100)';
% %     %c_lim = (max(max(Ni)));
% %     c_lim=0.5*10^6;
% %     Xedges2i=Xedges2i-(Xedges2i(2)-Xedges2i(1))/2;    
% %     Redges2i=Redges2i-(Redges2i(2)-Redges2i(1))/2;
% %     Ni(Ni<=no_le)=NaN;
% %     hc=pcolor(Xedges2i,Redges2i, Ni);
% %     hold on
% %     set(hc,'edgecolor','none');
% %     set(gca,'ColorScale','log','FontSize',fs)
% %     set(gca,'XScale','lin','YScale','lin','FontSize',fs)
% %     colormap(h1,'jet');
% %     caxis([1 (c_lim)]); %hcb.Ticks = linspace(-0.8,0.8,5); hcb.TickLabels = [-0.8,-0.4,0,0.4,0.8] ;  
% %     hcb=colorbar; hcb.Location = 'northoutside'; %hcb.Ruler.Exponent = -2;
% %     hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
% %     ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% %     ax.XLabel.String = '$v_{z}$'; ax.XTick = [ -0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6];
% %     ax.YLabel.String = '$v_{y}$'; ax.YTick = [ -0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6];
% %     hold off
% %     %----------------------------------------------------------------------
% %     h2=subaxis(1,3,2,'SV',0.01,'SH',0.004,'MR',0.01,'ML',0.07,'PL',0.005,'PR',0.006);
% %     dum1 = pzi; dum2 = pxi;    
% %     [Ni,Xedgesi,Redgesi] = histcounts2(dum1,dum2,Xedges2D,Yedges2D);
% %     Ni=Ni(1:99,1:99)';    Xedges2i=Xedgesi(2:100)'; Redges2i=Redgesi(2:100)';
% %     Xedges2i=Xedges2i-(Xedges2i(2)-Xedges2i(1))/2;    
% %     Redges2i=Redges2i-(Redges2i(2)-Redges2i(1))/2;
% %     %c_lim = (max(max(Ni)));
% %     c_lim=0.5*10^6;
% %     Ni(Ni<=no_le)=NaN;
% %     hc=pcolor(Xedges2i,Redges2i, Ni);
% %     hold on
% %     set(hc,'edgecolor','none');
% %     set(gca,'ColorScale','log','FontSize',fs)
% %     set(gca,'XScale','lin','YScale','lin','FontSize',fs)
% %     colormap(h2,'jet');
% %     caxis([1 (c_lim)]); %hcb.Ticks = linspace(-0.8,0.8,5); hcb.TickLabels = [-0.8,-0.4,0,0.4,0.8] ;  
% %     hcb=colorbar; hcb.Location = 'northoutside'; %hcb.Ruler.Exponent = -2;
% %     hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
% %     ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% %     ax.XLabel.String = '$v_{z}$'; ax.XTick = [ -0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6];
% %     ax.YLabel.String = '$v_{x}$'; ax.YTick = [];
% %     hold off
% %     %----------------------------------------------------------------------
% %     h3=subaxis(1,3,3,'SV',0.01,'SH',0.004,'MR',0.01,'ML',0.1,'PL',0.005,'PR',0.006);
% %     dum1 = pyi; dum2 = pxi;    
% %     [Ni,Xedgesi,Redgesi] = histcounts2(dum1,dum2,Xedges2D,Yedges2D);
% %     Ni=Ni(1:99,1:99)';    Xedges2i=Xedgesi(2:100)'; Redges2i=Redgesi(2:100)';
% %     Xedges2i=Xedges2i-(Xedges2i(2)-Xedges2i(1))/2;    
% %     Redges2i=Redges2i-(Redges2i(2)-Redges2i(1))/2;
% %     Redges2i=Redges2i-(Redges2i(2)-Redges2i(1))/2;
% %     %c_lim = (max(max(Ni)));
% %     c_lim=0.5*10^6;
% %     Ni(Ni<=no_le)=NaN;
% %     hc=pcolor(Xedges2i,Redges2i, Ni);
% %     hold on
% %     set(hc,'edgecolor','none');
% %     set(gca,'ColorScale','log','FontSize',fs)
% %     set(gca,'XScale','lin','YScale','lin','FontSize',fs)
% %     colormap(h3,'jet');
% %     caxis([1 (c_lim)]); %hcb.Ticks = linspace(-0.8,0.8,5); hcb.TickLabels = [-0.8,-0.4,0,0.4,0.8] ;  
% %     hcb=colorbar; hcb.Location = 'northoutside'; %hcb.Ruler.Exponent = -2;
% %     hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
% %     ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% %     ax.XLabel.String = '$v_{y}$'; ax.XTick = [ -0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6];
% %     ax.YLabel.String = '$v_{x}$'; ax.YTick = [];
% %     hold off
% %     %----------------------------------------------------------------------
% %     sgtitle('$$ log(f_{i}) \ ; \ t = \ $$'+string(round(time_t_2_Omega,2))+'$$\ \Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
% %     %----------------------------------------------------------------------
% %     cd(path)
% %     saveas(f3,strcat('large_vxvyvz_i_8_' + string(i) +'.png'));
% %     %----------------------------------------------------------------------

%end
   




%--------------------------------------------------------------------------
%     f1=figure(1)
%     subplot(2,3,1)
%     histogram(pxe);
%     xlim([-3,3]);
%     title('pxe')
%     set(gca,'XScale','lin','YScale','log','FontSize',18)
%     subplot(2,3,2)
%     histogram(pye);
%     xlim([-3,3])
%     title('pye')
%     set(gca,'XScale','lin','YScale','log','FontSize',18)
%     subplot(2,3,3)
%     histogram(pze);
%     xlim([-3,3])
%     title('pze')
%     set(gca,'XScale','lin','YScale','log','FontSize',18)
%     subplot(2,3,4)
%     histogram(pxi);
%     xlim([-3,3])
%     title('pxi')
%     set(gca,'XScale','lin','YScale','log','FontSize',18)
%     subplot(2,3,5)
%     histogram(pyi);
%     xlim([-3,3])
%     title('pyi')
%     set(gca,'XScale','lin','YScale','log','FontSize',18)
%     subplot(2,3,6)
%     histogram(pzi);
%     xlim([-3,3])
%     title('pzi')
%     set(gca,'XScale','lin','YScale','log','FontSize',18)
%--------------------------------------------------------------------------


   
    

    
