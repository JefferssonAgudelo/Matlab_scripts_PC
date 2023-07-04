% %--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%this is to test the how to change the initial fluctuation
% %--------------------------------------------------------------------------
%
path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_alone_large';
%--------------------------------------------------------------------------
% For the scripts
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
%--------------------------------------------------------------------------
path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';

S = dir(fullfile(path,'pfd.*.h5'));
N=numel(S); % number of files to use
H=zeros(N);
B0=0.2;
in=2;
omega_pe_Omega_ce=5;

cd(path)
for in=1:2
    disp(strcat('Computing step ...',S(in).name))
    fileID =  S(in).name; %change the 1 per i
    %h5disp(fileID);
    info = h5info(fileID);
    EHJ_1st = info.Groups(16).Name;
    grid_dt = info.Groups(20).Attributes;

    Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
    Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));
    Bx=squeeze(Bx(1,:,:));By=squeeze(By(1,:,:));Bz=squeeze(Bz(1,:,:));

    ss=size(Bx);
    size_X=ss;

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

    zll=linspace(-Lz,Lz,size_X(2)); %Jeff flag it works with (1,size_x(2))
    yll=linspace(-Ly,Ly,size_X(1));
    [ZLL, YLL] = meshgrid(zll,yll);

    dt=double(grid_dt(15).Value);
    str = string(S(in).name);
    newStr = extractBetween(str,"pfd.","_p000000.h5");
    N_steps = str2double(newStr);
    time_t = dt*N_steps;
    time_t_2_Omega = time_t./omega_pe_Omega_ce;

    db_b0 = 0.2; L=8; delta = 2;

    %dBy = -db_b0 * B0 * pi * L / Ly; dBz =  db_b0 * B0 * 2 * pi * L / Lz;
    %By_teo = dBy .* sin(2 .* pi .* (ZLL - 0.5 .* Lz) ./ Lz) .* cos(pi .*
    %YLL ./ Ly); % this returns twice what I see in the pic code Bz_teo =
    %dBz .* cos(2 .* pi .* (ZLL - 0.5 .* Lz) ./ Lz) .* sin(pi .* YLL ./
    %Ly);

    % Initial fluctuation for the magnetic field (central pinch). 
    %----------------------------------------------------------------------
    dBy = -db_b0 .* B0 .*1 .*pi .* 0.5*L ./ ( 0.5*Ly);
    dBz = db_b0 .* B0 .*2 .* pi .* 0.5*L ./ ( 0.5*Lz);
    By_teo = dBy .* (sin(1 .* pi .* (ZLL - 1.0 .* Lz) ./ Lz)) .* (cos(0.5*pi .* YLL ./ Ly));
    Bz_teo = dBz .* (cos(1 .* pi .* (ZLL - 1.0 .* Lz) ./ Lz)) .* (sin(0.5*pi .* YLL ./ Ly));
    Bz_teo = Bz_teo + B0.*tanh(YLL/delta);
    %----------------------------------------------------------------------
   
    % Checking the superposition of the modes with a centralised region
    %----------------------------------------------------------------------
    % For the alfven modes and different times to extract the frequencies
    %--------------------------------------------------------------------------
    % Define the parameters of your simulation
    grid_size = size(Bx);  % Size of the simulation grid
    dy = resy;  % Spatial resolution (grid spacing)
    dz = resz;
    dt = 0.06;  % Temporal resolution (time step)

    % Number of waves;
    nw=8;

    % Define the wave parameters for each mode
    bn = 0.5 * db_b0;
    Dy = Ly/32;
    Dz = Lz/64;

    amplitude = bn .* ones(1, nw);  % Wave amplitudes for each mode. This amplitudes needs to be scale dependent and consistent
    ky = 2*pi*rand(1, nw) ./ (Ly/8);  % Wave vectors in x-direction for each mode (randomly generated) polarizations
    kz = 2*pi*rand(1, nw) ./ (Lz/8);  % Wave vectors in y-direction for each mode (randomly generated) polarizations
    omega = 2*pi*rand(1, nw) ./ dt;  % Angular frequencies for each mode (randomly generated)
    phase = 2*pi*rand(1, nw); % Random phase for each mode

    ky0=ky; kz0=kz; omega0=omega;
    k0 = sqrt(ky0.^2 + kz0.^2);

    % Create a grid of coordinates
    z = dz * (-grid_size(2)/2:grid_size(2)/2-1);
    y = dy * (-grid_size(1)/2:grid_size(1)/2-1);
    [Z, Y] = meshgrid(z, y);

    % Initialize arrays for magnetic field components
    Ax = zeros(grid_size);
    Ax_i = zeros(ss(1),ss(2),2);

    Ax_sub = zeros(grid_size);
    Ax_sub_i = zeros(ss(1),ss(2),2);

    Axdz_sub = zeros(grid_size);
    mAxdy_sub = zeros(grid_size);

    Axdz_sub_i = zeros(ss(1),ss(2),2);
    mAxdy_sub_i = zeros(ss(1),ss(2),2);

    wnoise= rand(1)*B0*Y;

    % Superposition of the modes
    %----------------------------------------------------------------------        
    for dt_i = 1:2
        for i = 1:length(amplitude)
            k_perp_i = sqrt(ky(i).^2 + kz(i).^2);
            cos_arg = cos(ky(i).*Y + kz(i).*Z - omega(i).*dt_i*dt + phase(i)); 
            sin_arg = sin(ky(i).*Y + kz(i).*Z - omega(i).*dt_i*dt + phase(i)); 
            arg2 = sqrt( (Y./Dy).^2 + (Z./Dz).^2 ); 
            sech2 = (sech(arg2)).^2;
            tanh2 = (tanh(arg2)).^2;

            Ax_temp = (amplitude(i)./k_perp_i) * cos_arg ;%+ wnoise/nw;
            Ax = Ax + Ax_temp;          
            Ax_i(:,:,dt_i) = Ax;

            Ax_sub = Ax_sub + Ax_temp.* sech2; 
            Ax_sub_i(:,:,dt_i) = Ax_sub;

            Axdz_sub = -(amplitude(i)./k_perp_i) .* sech2.*( (kz(i).*sin_arg./Dz) + tanh2.*2.*Z./(Dz.*arg2)); 
            mAxdy_sub = (amplitude(i)./k_perp_i) .* sech2.*( (ky(i).*sin_arg./Dy) + tanh2.*2.*Y./(Dy.*arg2)); 

            Axdz_sub_i(:,:,dt_i) = Axdz_sub;
            mAxdy_sub_i(:,:,dt_i) = mAxdy_sub;
        end
    end

    %Warning: Rank deficient, rank = 30, tol =  1.005943e-09. 
    % Arrays have incompatible sizes for this operation.
    %----------------------------------------------------------------------    

    % Checking the plot
    %----------------------------------------------------------------------    
    cd(path_s2)
    %----------------------------------------------------------------------
    fs=18;
    x0=45;y0=54;xx1=810;yy1=710;
    %----------------------------------------------------------------------
    f57=figure(57);
    set(gcf,'position',[x0,y0,xx1,yy1])
    %----------------------------------------------------------------------
    h1=subplot(2,1,1);
    dum_p2=squeeze(Ax_i(:,:,1));
    hc=pcolor(ZLL,YLL,dum_p2);
    set(hc,'edgecolor','none')
    hold on
    colorbar; colormap(h1,BWR);
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    caxis([-2 2]); % lange_all
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([zll(1) zll(end)]);
    ylim([yll(1) yll(end)]);
    lgnd=legend([h1],'$A_{x} $','Interpreter','latex','FontSize',1.3*fs);
    hold off
    %----------------------------------------------------------------------
    h1=subplot(2,1,2);
    dum_p2=squeeze(Ax_sub_i(:,:,1));
    hc=pcolor(ZLL,YLL,dum_p2);
    set(hc,'edgecolor','none')
    hold on
    colorbar; colormap(h1,BWR);
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    caxis([-2 2]);
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([zll(1) zll(end)]);
    ylim([yll(1) yll(end)]);
    lgnd=legend([h1],'$A_{x,sub} $','Interpreter','latex','FontSize',1.3*fs);
    hold off
    %----------------------------------------------------------------------

    f58=figure(58);
    set(gcf,'position',[x0,y0,xx1,yy1])
    %----------------------------------------------------------------------
    h1=subplot(2,1,1);
    dum_p2=squeeze(Axdz_sub_i(:,:,1));
    hc=pcolor(ZLL,YLL,dum_p2);
    set(hc,'edgecolor','none')
    hold on
    colorbar; colormap(h1,BWR);
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    caxis([-2 2]); % lange_all
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([zll(1) zll(end)]);
    ylim([yll(1) yll(end)]);
    lgnd=legend([h1],'$B_{y,sub} $','Interpreter','latex','FontSize',1.3*fs);
    hold off
    %----------------------------------------------------------------------
    h1=subplot(2,1,2);
    dum_p2=squeeze(mAxdy_sub_i(:,:,1));
    hc=pcolor(ZLL,YLL,dum_p2);
    set(hc,'edgecolor','none')
    hold on
    colorbar; colormap(h1,BWR);
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    caxis([-2 2]);
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([zll(1) zll(end)]);
    ylim([yll(1) yll(end)]);
    lgnd=legend([h1],'$B_{z,sub} $','Interpreter','latex','FontSize',1.3*fs);
    hold off

    cd(path_comp)
    saveas(f57,strcat(num2str(time_t),'Ax_Axsub_exa.png'));
    saveas(f58,strcat(num2str(time_t),'By_Bz_sub_exa.png'));
    cd(path)
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    kx = 2*pi/Lx;   ky = 2*pi/Ly;   kz = 2*pi/Lz;
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------    
    % Create grids for kx and ky
    [ny, nz, nt] = size(Bx);
    ky=((0:ny-1)-ny/2).*2*pi/(ny * (1*dy)); %Includes negative wavenumbers
    kz=((0:nz-1)-nz/2).*2*pi/(nz * (1*dz));
    om=((0:ny-1)-nt/2).*2*pi/(nt * (1*dt));
    [Kz, Ky] = meshgrid(kz, ky);    
    %----------------------------------------------------------------------


    % Make the plots to see how this should look in the simulation output
    cd(path_s2)
    %----------------------------------------------------------------------
    fs=18;
    x0=45;y0=54;xx1=810;yy1=710;
    %----------------------------------------------------------------------
    f57=figure(57);
    set(gcf,'position',[x0,y0,xx1,yy1])
    %----------------------------------------------------------------------
    h1=subplot(3,1,1);
    dum_p2=By_teo./B0;
    %lim_yp2=max(max(max(abs(dum_p2))));dum_p2=dum_p2/lim_yp2;
    hc=pcolor(ZLL,YLL,dum_p2);
    set(hc,'edgecolor','none')
    hold on
    colorbar; colormap(h1,BWR);
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    caxis([-0.1 0.1]); % lange_all
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([zll(1) zll(end)]);
    ylim([yll(1) yll(end)]);
    lgnd=legend([h1],'$\frac{B_{y,t}}{B_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    hold off
    %--------------------------------------------------------------------------
    h2=subplot(3,1,2);
    dum_p2=(Bz_teo- B0.*tanh(YLL/delta))./B0;
    %lim_yp2=max(max(max(abs(dum_p2))));dum_p2=dum_p2/lim_yp2;
    hc=pcolor(ZLL,YLL,dum_p2);
    set(hc,'edgecolor','none')
    hold on
    colorbar; colormap(h2,BWR);
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    caxis([-0.1 0.1]); % lange_all
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([zll(1) zll(end)]);
    ylim([yll(1) yll(end)]);
    lgnd=legend([h2],'$\frac{B_{z,t}}{B_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    hold off
    %--------------------------------------------------------------------------
    h3=subplot(3,1,3);
    dum_p2=sqrt(By_teo.^2 + Bz_teo.^2)./B0;
    %lim_yp2=max(max(max(abs(dum_p2))));dum_p2=dum_p2/lim_yp2;
    hc=pcolor(ZLL,YLL,dum_p2);
    set(hc,'edgecolor','none')
    hold on
    colorbar; colormap(h3,'jet');
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    caxis([0.0 1.0]);% lange_all
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([zll(1) zll(end)]);
    ylim([yll(1) yll(end)]);
    lgnd=legend([h3],'$\frac{B_{yz,t}}{B_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    hold off
    % %--------------------------------------------------------------------------

    cd(path_s2)
    %----------------------------------------------------------------------
    f58=figure(58);
    set(gcf,'position',[x0,y0,xx1,yy1])
    %----------------------------------------------------------------------
    h1=subplot(3,1,1);
    dum_p2=By/B0;
    %lim_yp2=max(max(max(abs(dum_p2))));dum_p2=dum_p2/lim_yp2;
    hc=pcolor(ZLL,YLL,dum_p2);
    set(hc,'edgecolor','none')
    hold on
    colorbar; colormap(h1,BWR);
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    caxis([-0.1 0.1]); % lange_all
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([zll(1) zll(end)]);
    ylim([yll(1) yll(end)]);
    lgnd=legend([h1],'$\frac{B_{y}}{B_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    hold off
    %--------------------------------------------------------------------------
    h2=subplot(3,1,2);
    dum_p2=(Bz - B0.*tanh(YLL/delta))./B0;
    %lim_yp2=max(max(max(abs(dum_p2))));dum_p2=dum_p2/lim_yp2;
    hc=pcolor(ZLL,YLL,dum_p2);
    set(hc,'edgecolor','none')
    hold on
    colorbar; colormap(h2,BWR);
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    caxis([-0.1 0.1]); % lange_all
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([zll(1) zll(end)]);
    ylim([yll(1) yll(end)]);
    lgnd=legend([h2],'$\frac{(B_{z} - B_{0}(y))}{B_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    hold off
    %--------------------------------------------------------------------------
    h3=subplot(3,1,3);
    dum_p2=sqrt(By.^2 + Bz.^2)./B0;
    %lim_yp2=max(max(max(abs(dum_p2))));dum_p2=dum_p2/lim_yp2;
    hc=pcolor(ZLL,YLL,dum_p2);
    set(hc,'edgecolor','none')
    hold on
    colorbar; colormap(h3,'jet');
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    caxis([0.0 1.0]); % lange_all
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([zll(1) zll(end)]);
    ylim([yll(1) yll(end)]);
    lgnd=legend([h3],'$\frac{B_{yz}}{B_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    hold off
    sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
    % %--------------------------------------------------------------------------

    cd(path_rec_line)
    saveas(f58,strcat(num2str(time_t),'ByBz_Byz.png'));
    cd(path)
end
%}
% %--------------------------------------------------------------------------
% %--------------------------------------------------------------------------