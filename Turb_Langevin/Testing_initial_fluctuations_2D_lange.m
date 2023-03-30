% %--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%this is to test the how to change the initial fluctuation
% %--------------------------------------------------------------------------
%
path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_alone_large';

S = dir(fullfile(path,'pfd.*.h5'));
N=numel(S); % number of files to use
H=zeros(N);
in=2;
omega_pe_Omega_ce=5
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

    dBy = -db_b0 .* B0 .*1 .*pi .* 0.5*L ./ ( 0.5*Ly);
    dBz = db_b0 .* B0 .*2 .* pi .* 0.5*L ./ ( 0.5*Lz);
    By_teo = dBy .* (sin(1 .* pi .* (ZLL - 1.0 .* Lz) ./ Lz)) .* (cos(0.5*pi .* YLL ./ Ly));
    Bz_teo = dBz .* (cos(1 .* pi .* (ZLL - 1.0 .* Lz) ./ Lz)) .* (sin(0.5*pi .* YLL ./ Ly));
    Bz_teo = Bz_teo + B0.*tanh(YLL/delta);

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