% This is to do the plots comapring the different tests

cd '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here'
load('colorblind_colormap.mat');

% This is to define my own color blind friendly pallet
%https://coolors.co/363636-d62839-fb8b24-4ba3c3-a4a5ae-eeabc4-ac3cf6-ead94c-87bba2-0f8b8d
%--------------------------------------------------------------------------
cb_my=[ % This is normalised
    0.211, 0.211, 0.211;
    0.839, 0.156, 0.223;
    0.984, 0.545, 0.141;
    0.294, 0.639, 0.764;
    0.643, 0.647, 0.682;
    0.933, 0.670, 0.768;
    0.674, 0.235, 0.964;
    0.917, 0.850, 0.298;
    0.529, 0.733, 0.635;
    0.058, 0.545, 0.552];
% These bloque are the names and the un normalised values
% -------------------------------------------------------------------------
%{
cb_my2=[
    54,54,54;
    214,40,57;
    251,139,36;
    75,163,195;
    164,165,174;
    238,171,196;
    172,60,246;
    234,217,76;
    135,187,162;
    15,139,141];

cb_my2n{1,1}='jet';
cb_my2n{1,2}='Crimson';
cb_my2n{1,3}='Dark Orange';
cb_my2n{1,4}='MAximum Blue';
cb_my2n{1,5}='Silver Metallic';
cb_my2n{1,6}='Nadeshiko pink';
cb_my2n{1,7}='Electric Purple';
cb_my2n{1,8}='Minion Yellow';
cb_my2n{1,9}='Eton Blue';
cb_my2n{1,10}='Dark Cyan';
    %}
% -------------------------------------------------------------------------

% Load the data for the different tests
% -------------------------------------------------------------------------
cd /Volumes/PSC_DiRAC_DATA/TEST2020_1/Analysis;
load('ppc_mime_VA2c8_spectras.mat')
% -------------------------------------------------------------------------


% For the comparison with the different VA2c
% -------------------------------------------------------------------------
% VA2c_0.06 is the same file as mime_100
% VA2c_0.10 is the same file as ppc_100
% -------------------------------------------------------------------------
    kper0=kper(2);
    
    spectraB1=spectraB_mime_100;
    spectraB2=spectraB_VA2c_008;
    spectraB3=spectraB_ppc_100;
    
    spectraB1=spectravi_mime_100;
    spectraB2=spectravi_VA2c_008;
    spectraB3=spectravi_ppc_100;
    
    kper1=spectraB1.kper;%+spectraB.kper(2); % to correct the zero
    kpar1=spectraB1.kpar;%+spectraB.kpar(2);
    kper2=spectraB2.kper;%+spectraB.kper(2); % to correct the zero
    kpar2=spectraB2.kpar;%+spectraB.kpar(2);
    kper3=spectraB3.kper;%+spectraB.kper(2); % to correct the zero
    kpar3=spectraB3.kpar;%+spectraB.kpar(2);
    
    %N1=400; N2 = 400 ; N3 =2016;
    P1D_perB1=(spectraB1.P1Dper)./(max(spectraB1.P1Dper));
    P1D_perB2=(spectraB2.P1Dper)./(max(spectraB2.P1Dper));
    P1D_perB3=(spectraB3.P1Dper)./(max(spectraB3.P1Dper));  
  
    
    f1=figure(1);
    loglog(kper1,P1D_perB1,'Color',cb_my(1,:),'LineWidth',2)
    hold on
    loglog(kper2,P1D_perB2,'Color',cb_my(2,:),'LineWidth',2) 
    loglog(kper3,P1D_perB3,'Color',cb_my(3,:),'LineWidth',2)
    %loglog(kper,P1D_perni_0, '--','LineWidth',1)
    set(gca,'FontSize',20)
    xx2=log10([1.8 7]);     y2=xx2.*(-3)-0.24; 
    x3=log10([7 20]);     y3=x3.*(-4)+0.5;
    x1=1;    x2=10;    x3=14.0845;
    x4=17.54; x5=23.809;   
    y1=get(gca,'ylim');
    %loglog(10.^xx2,10.^y2,'--b','LineWidth',1.5)
    loglog([x3 x3],y1,'--c','LineWidth',1.5)
    loglog([x4 x4],y1,'--m','LineWidth',1.5)
    loglog([x5 x5],y1,'--b','LineWidth',1.5)
    loglog([x1 x1],y1,'--k','LineWidth',1.5)
    loglog([x2 x2],y1,'--k','LineWidth',1.5)
    % Text in the plot
    txt1 = '$$ k_{\perp}d_i=1$$';
    txt2 = '$$ k_{\perp}d_e=1$$';
    txt3 = '$$ k_{\perp}\lambda_{Ds_{1}}=1$$';
    txt4 = '$$ k_{\perp}\lambda_{Ds_{2}}=1$$';
    txt5 = '$$ k_{\perp}\lambda_{Ds_{3}}=1$$';
    text(0.32 , 2e-5,txt1,'Interpreter','latex','FontSize',18);
    text(3.2 , 2e-5,txt2,'Interpreter','latex','FontSize',18);      
    %text(16 , 3e-3,txt3,'Interpreter','latex','FontSize',18);
    %text(16 , 3e-2,txt4,'Interpreter','latex','FontSize',18);
    %text(16 , 3e-1,txt5,'Interpreter','latex','FontSize',18);
    xlabel('$k_\perp d_i$','Interpreter','latex','FontSize',20)
    %ylabel('$P^{{B}}_{1D_\perp}$','Interpreter','latex','FontSize',20)
    ylabel('$P^{{v_{i}}}_{1D_\perp}$','Interpreter','latex','FontSize',20)
    xlim([0.26 100]); ylim([10^(-5) 10^0])
    legend({'$s_{1}$','$s_{2}$','$s_{3}$','$\lambda_{Ds_{3}}$','$\lambda_{Ds_{2}}$','$\lambda_{Ds_{1}}$'},'Location','northwest','Interpreter','latex','FontSize',20)
    hold off

    %-------------------------------------------------------------------------
    
    
    % This is for ppc
    %-------------------------------------------------------------------------
    spectraB1=spectraB_ppc_50;
    spectraB2=spectraB_ppc_100;
    spectraB3=spectraB_ppc_150;
    spectraB4=spectraB_ppc_200;
    spectraB5=spectraB_ppc_250;
    spectraB6=spectraB_ppc_300;
    
    spectraB1=spectravi_ppc_50;
    spectraB2=spectravi_ppc_100;
    spectraB3=spectravi_ppc_150;
    spectraB4=spectravi_ppc_200;
    spectraB5=spectravi_ppc_250;
    spectraB6=spectravi_ppc_300;
    
    kper1=spectraB1.kper;    kpar1=spectraB1.kpar;
    kper2=spectraB2.kper;    kpar2=spectraB2.kpar;
    kper3=spectraB3.kper;    kpar3=spectraB3.kpar;
    kper4=spectraB4.kper;    kpar4=spectraB4.kpar;
    kper5=spectraB5.kper;    kpar5=spectraB5.kpar;
    kper6=spectraB6.kper;    kpar6=spectraB6.kpar;
    
    P1D_perB1=(spectraB1.P1Dper)./(max(spectraB1.P1Dper));
    P1D_perB2=(spectraB2.P1Dper)./(max(spectraB2.P1Dper));
    P1D_perB3=(spectraB3.P1Dper)./(max(spectraB3.P1Dper));
    P1D_perB4=(spectraB4.P1Dper)./(max(spectraB4.P1Dper));
    P1D_perB5=(spectraB5.P1Dper)./(max(spectraB5.P1Dper));
    P1D_perB6=(spectraB6.P1Dper)./(max(spectraB6.P1Dper));
    
    f2=figure(2);
    loglog(kper1,P1D_perB1,'Color',cb_my(1,:),'LineWidth',2)
    hold on
    loglog(kper2,P1D_perB2,'Color',cb_my(2,:),'LineWidth',2) 
    loglog(kper3,P1D_perB3,'Color',cb_my(3,:),'LineWidth',2)
    loglog(kper4,P1D_perB4,'Color',cb_my(4,:),'LineWidth',2) 
    loglog(kper5,P1D_perB5,'Color',cb_my(5,:),'LineWidth',2)
    loglog(kper6,P1D_perB6,'Color',cb_my(6,:),'LineWidth',2)
    set(gca,'FontSize',20)
    x2=log10([1.8 7]);     y2=x2.*(-3)-0.24; 
    x3=log10([7 20]);     y3=x3.*(-4)+0.5;
    x1=1;    x2=10;    x3=14.0845;
    x4=17.54; x5=23.809;   
    y1=get(gca,'ylim');
    loglog([x3 x3],y1,'--k','LineWidth',1.5)
    loglog([x1 x1],y1,'--k','LineWidth',1.5)
    loglog([x2 x2],y1,'--k','LineWidth',1.5)
    txt1 = '$$ k_{\perp}d_i=1$$';
    txt2 = '$$ k_{\perp}d_e=1$$';
    txt3 = '$$ k_{\perp}\lambda_{D}=1$$';
    text(0.32 , 2e-5,txt1,'Interpreter','latex','FontSize',18);
    text(3.2 , 2e-5,txt2,'Interpreter','latex','FontSize',18); 
    text(16 , 2e-5,txt3,'Interpreter','latex','FontSize',18);
    xlabel('$k_\perp d_i$','Interpreter','latex','FontSize',20)
    %ylabel('$P^{{B}}_{1D_\perp}$','Interpreter','latex','FontSize',20)
    ylabel('$P^{{v_{i}}}_{1D_\perp}$','Interpreter','latex','FontSize',20)
    xlim([0.26 100]); ylim([10^(-5) 10^0])
    legend({'$s_{4}$','$s_{3}$','$s_{5}$','$s_{6}$','$s_{7}$','$s_{8}$'},'Location','northwest','Interpreter','latex','FontSize',20)
    hold off
    
    %-------------------------------------------------------------------------
    
    
    % This is for mime
    %-------------------------------------------------------------------------
    spectraB1=spectraB_mime_1;
    spectraB2=spectraB_mime_10;
    spectraB3=spectraB_mime_100;
    spectraB4=spectraB_mime_200;
    spectraB5=spectraB_mime_300;
    spectraB6=spectraB_mime_400;
    spectraB7=spectraB_mime_500;
    
    spectraB1=spectravi_mime_1;
    spectraB2=spectravi_mime_10;
    spectraB3=spectravi_mime_100;
    spectraB4=spectravi_mime_200;
    spectraB5=spectravi_mime_300;
    spectraB6=spectravi_mime_400;
    spectraB7=spectravi_mime_500;
    
    kper1=spectraB1.kper;    kpar1=spectraB1.kpar;
    kper2=spectraB2.kper;    kpar2=spectraB2.kpar;
    kper3=spectraB3.kper;    kpar3=spectraB3.kpar;
    kper4=spectraB4.kper;    kpar4=spectraB4.kpar;
    kper5=spectraB5.kper;    kpar5=spectraB5.kpar;
    kper6=spectraB6.kper;    kpar6=spectraB6.kpar;
    kper7=spectraB7.kper;    kpar7=spectraB7.kpar;
    
    P1D_perB1=(spectraB1.P1Dper)./(max(spectraB1.P1Dper));
    P1D_perB2=(spectraB2.P1Dper)./(max(spectraB2.P1Dper));
    P1D_perB3=(spectraB3.P1Dper)./(max(spectraB3.P1Dper));
    P1D_perB4=(spectraB4.P1Dper)./(max(spectraB4.P1Dper));
    P1D_perB5=(spectraB5.P1Dper)./(max(spectraB5.P1Dper));
    P1D_perB6=(spectraB6.P1Dper)./(max(spectraB6.P1Dper));
    P1D_perB7=(spectraB7.P1Dper)./(max(spectraB7.P1Dper));
    

    f3=figure(3);
    loglog(kper1,P1D_perB1,'Color',cb_my(1,:),'LineWidth',2)
    hold on
    loglog(kper2,P1D_perB2,'Color',cb_my(2,:),'LineWidth',2) 
    loglog(kper3,P1D_perB3,'Color',cb_my(3,:),'LineWidth',2)
    loglog(kper4,P1D_perB4,'Color',cb_my(4,:),'LineWidth',2) 
    loglog(kper5,P1D_perB5,'Color',cb_my(5,:),'LineWidth',2)
    loglog(kper6,P1D_perB6,'Color',cb_my(6,:),'LineWidth',2)
    loglog(kper7,P1D_perB7,'Color',cb_my(7,:),'LineWidth',2)
    set(gca,'FontSize',20)
    x1=1;   
    x2=10;
    x3=14.14;  
    x4=22.37;
    x5=23.809;
    y1=get(gca,'ylim');
    loglog([x2 x2],y1,'--c','LineWidth',1.5)
    loglog([x3 x3],y1,'--m','LineWidth',1.5)
    loglog([x4 x4],y1,'--b','LineWidth',1.5)
    loglog([x5 x5],y1,'--r','LineWidth',1.5)
    loglog([x1 x1],y1,'--k','LineWidth',1.5)
    txt1 = '$$ k_{\perp}d_i=1$$';
    txt3 = '$$ k_{\perp}\lambda_{D}=1$$';
    text(0.32 , 2e-5,txt1,'Interpreter','latex','FontSize',18);
%    text(16 , 2e-5,txt3,'Interpreter','latex','FontSize',18);
    xlabel('$k_\perp d_i$','Interpreter','latex','FontSize',20)
    %ylabel('$P^{{B}}_{1D_\perp}$','Interpreter','latex','FontSize',20)
    ylabel('$P^{{v_{i}}}_{1D_\perp}$','Interpreter','latex','FontSize',20)
    xlim([0.26 100]); ylim([10^(-5) 10^0])
    legend({'$s_{9}$','$s_{10}$','$s_{1}$','$s_{13}$','$s_{15}$','$s_{16}$','$s_{17}$',...
            '$d_{es_{1}}$','$d_{es_{13}}$','$d_{es_{17}}$','$\lambda_{D}$'},'Location','northwest','Interpreter','latex','FontSize',20)
    hold off

    %----------------------------------------------------------------------

    
    % To save the figures
    %----------------------------------------------------------------------
    cd /Volumes/PSC_DiRAC_DATA/TEST2020_1/Analysis/Images;
    saveas(1,strcat('test_va2c_vi.png'));
    saveas(2,strcat('test_ppc_vi.png'));
    saveas(3,strcat('test_mime_vi.png'));
    %----------------------------------------------------------------------