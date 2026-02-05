%#-----------------------------------------------------------------------
% This script is to study the kappa distributions and see what the code is
% giving back.

%This is the script to read the particle infoprmation
% Currently the program does not create a xdmf but only a .h5
%#----------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
path = '~/codes/PSC/psc-main/build_noGPU/Testing_no_GPU/psc_turb_alf_2D_xz_large_current_kappa_reject';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(path)
mime =100.;
omega_pe_Omega_ce=10;

Sprt = dir(fullfile(path,'prt.*'));
N=numel(Sprt); % number of files to use
%H=zeros(N);
i=2;

% This is the loop to calculate the VDF of the particles
% the for is in case I want to look at different time stamps
for i=2:2
    % i=N;
    %i=2;
    disp(strcat('Computing step ...',Sprt(i).name))
    fileID_prt =  Sprt(i).name; %change the 1 per i
    h5disp(fileID_prt); %this is the command to show the information in the file
    info_prt = h5info(fileID_prt);
    prt = info_prt.Groups(1).Name;

    %info_prt.Groups(1).Attributes.Name % lo, hi
    %----------------------------------------------------------------------
    size_prt_array = info_prt.Groups(1).Groups(1).Datasets(1).Dataspace.MaxSize;
    start_prt = info_prt.Groups(1).Attributes(1).Value; % lo value, hi value
    end_prt = info_prt.Groups(1).Attributes(2).Value; % lo value, hi value
    max_zise = info_prt.Groups(1).Groups(1).Datasets(2).Dataspace.MaxSize;
    %----------------------------------------------------------------------

    %read the information from the fields of the struct
    % If the file is too large I need to give the start, count and stride
    % at the begining.

    %To make the correct field file and see where is the region located
    %----------------------------------------------------------------------
    % Get the fiel name and remove the prt.
    str = Sprt(i).name;
    newStr = erase(str,"prt.");
    % load the field files
    Sf = dir(fullfile(path,'pfd.*.h5'));
    %The idea is to find the index that corresponds to the file that has
    %the same name as in the prt info
    Nff = {Sf.name};
    Xff = contains(Nff,num2str(newStr));
    in=find(Xff==1); % this finds the index
    %Nff{Xff}
    %----------------------------------------------------------------------
    disp(strcat('Computing step ...',Sf(in).name))
    fileID =  Sf(in).name; %change the 1 per i
    %h5disp(fileID);
    info = h5info(fileID);
    EHJ_1st = info.Groups(16).Name;
    %--------------------------------------------------------------------------
    xl_min=info.Groups(7).Attributes(7).Value;
    xl_max=info.Groups(7).Attributes(8).Value;
    yl_min=info.Groups(8).Attributes(7).Value;
    yl_max=info.Groups(8).Attributes(8).Value;
    zl_min=info.Groups(9).Attributes(7).Value;
    zl_max=info.Groups(9).Attributes(8).Value;
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
    resz=double(Lz)/double(dz); res=resx;
    threshold=pi/res;

    xl = linspace(xl_min,xl_max,dx);
    zl = linspace(zl_min,zl_max,dz);

    %--------------------------------------------------------------------------
    Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    ss=size(Bx);
    %--------------------------------------------------------------------------


    % Lets try now a recursive reading storing only the data in the interval
    %--------------------------------------------------------------------------
    % Region of interest
    % Remember that this is in units of de so for the turb_2D case CIRRUS it goes till Lx and Lz

    % These in here need to be a fraction for the large files
    x1 = xl(1,start_prt(1));  x2 = xl(1,end_prt(1));     % x-interval
    z1 = zl(1,start_prt(3));  z2 = zl(1,end_prt(3));    % z-interval

    % Chunk size (number of particles per read)
    chunkSize = 1e7;  % adjust depending on memory

    % --- Get dataset size ---
    interm=info_prt.Groups(1).Groups(1).Datasets.Dataspace;
    N_max_size = interm.MaxSize;

    % --- Storage arrays (start empty, grow as needed) ---
    X = []; Y = []; Z = [];
    PX = []; PY = []; PZ = []; Q = [];

    % --- Loop over chunks ---

    for startIdx = 1:chunkSize:N_max_size
        count = min(chunkSize, N_max_size - startIdx + 1);
        start = [startIdx];

        % Read chunk
        prtfields = h5read(fileID_prt,strcat(prt,'/p0/1d'), start, count);

        % Extract variables
        x  = prtfields.x;
        %y  = prtfields.y;
        z  = prtfields.z;
        px = prtfields.px;
        py = prtfields.py;
        pz = prtfields.pz;
        q  = prtfields.q;

        % Filter region of interest
        mask = (x >= x1 & x <= x2 & z >= z1 & z <= z2);

        % Append filtered data
        X  = [X;  x(mask)];
        %Y  = [Y;  y(mask)];
        Z  = [Z;  z(mask)];
        PX = [PX; px(mask)];
        PY = [PY; py(mask)];
        PZ = [PZ; pz(mask)];
        Q  = [Q;  q(mask)];

        fprintf('Processed %d / %d particles\n', startIdx+count-1, N);

    end
    % Now X,Y,Z,PX,PY,PZ,Q contain only particles inside the region
    disp(['Total particles in region: ', num2str(length(X))]);
    %--------------------------------------------------------------------------

    % this shows that the selection is working
    %--------------------------------------------------------------------------
    x_max = max(X);
    z_max = max(Z);
    x_min = min(X);
    z_min = min(Z);
    min_max = [x_min,x_max, z_min, z_max];
    %disp('x_min,x_max,y_min, y_max, z_min, z_max')
    disp(min_max)

    clearvars y Y
    x=X; z=Z; px=PX; py=PY;pz=PZ; q=Q;
    %--------------------------------------------------------------------------


    %--------------------------------------------------------------------------
    %clearvars y prtfields
    %--------------------------------------------------------------------------

    %separate the popullations

    q_i_index = find(q==-1); %electrons
    pxi=px(q_i_index); pyi=py(q_i_index); pzi=pz(q_i_index);
    qi=q(q_i_index);
    xi=x(q_i_index); zi=z(q_i_index);

    clearvars px py pz q PX PY PZ Q

    % Keep this optional to search in a subset
    xii1 = x1; xii2 = x2; zii1=z1; zii2=z2; % 3 is out
    %----------------------------------------------------------------------


    %----------------------------------------------------------------------
    % Get four regions just to see
    %----------------------------------------------------------------------
    cond_y1 = find((xi>xii1) & (xii2>xi) & (zi>zii1) & (zii2>zi) );  % out
    %----------------------------------------------------------------------

    pxi_sub1=pxi(cond_y1);
    pyi_sub1=pyi(cond_y1);
    pzi_sub1=pzi(cond_y1);

    %clearvars pxi pyi pzi

    edges = linspace(-1,1,150);
    [Nc,edges] = histcounts(pxi,edges);
    [Ns,edges] = histcounts(pyi,edges);
    [Nh,edges] = histcounts(pzi,edges);

    f666=figure(666);
    semilogy(edges(2:end),Nc,'r') %plot(edges(2:100),Nc,'r')
    hold on
    semilogy(edges(2:end),Ns,'b')
    semilogy(edges(2:end),Nh,'k')
    %semilogy(edges(2:end),Ncs,'k')
    xline(0,'k')
    xlabel('$v_{s,\parallel}$','Interpreter','latex','FontSize',20)
    ylabel('Counts','Interpreter','latex','FontSize',20)
    title('$$Distribution$$','Interpreter','latex','FontSize',20)
    legend('$p_{xe}$','$p_{ye}$','$p_{ze}$','Interpreter','latex','FontSize',20)
    hold off

    % This part in here is actually loading data from the different runs to
    % compare cases
    %-----------------------------------------------------------------------
    %
    [Nc1,edges] = histcounts(pxi,edges);
    [Ns1,edges] = histcounts(pyi,edges);

    %----------------------------------------------------------------------

    %To make the coordinate transformation
    %----------------------------------------------------------------------
    % Get the fiel name and remove the prt.
    str = Sprt(i).name;
    newStr = erase(str,"prt.");

    % load the field files
    Sf = dir(fullfile(path,'pfd.*.h5'));
    Nf=numel(Sf); % number of files to use

    %The idea is to find the index that corresponds to the file that has
    %the same name as in the prt info
    Nff = {Sf.name};
    Xff = contains(Nff,num2str(newStr));
    in=find(Xff==1); % this finds the index
    %Nff{Xff}
    %----------------------------------------------------------------------

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
    Bx = squeeze(Bx(:,1,:));
    By = squeeze(By(:,1,:));
    Bz = squeeze(Bz(:,1,:));

    sss=size(Bx);
    size_X=sss;

    [ZLL, XLL] = meshgrid(zl,xl);

    % out
    cond_ii = (XLL>xii1).*(XLL<xii2).*(ZLL>zii1).*(ZLL<zii2);
    Bxout = Bx.*cond_ii; Bxout(Bxout==0)=NaN;
    Byout = By.*cond_ii; Byout(Byout==0)=NaN;
    Bzout = Bz.*cond_ii; Bzout(Bzout==0)=NaN;

    % Now lets compute the averages to get the parallel and perpendicular
    % remove the NaNs
    Bxout(isnan(Bxout)) = []; Byout(isnan(Byout)) = [];  Bzout(isnan(Bzout)) = [];
    Bxout_av = mean(Bxout,'all'); Byout_av = mean(Byout,'all'); Bzout_av = mean(Bzout,'all');
    Bout_m_av = sqrt(Bxout_av.^2 + Byout_av.^2 + Bzout_av.^2);

    %----------------------------------------------------------------------
    % Define the initial coordinates
    xx = [1; 0; 0]; % Example x-coordinate
    yy = [0; 1; 0]; % Example y-coordinate
    zz = [0; 0; 1]; % Example z-coordinate


    B_out = [Bxout_av; Byout_av; Bzout_av]; % Example magnetic field vector
    % Normalize the magnetic field vector
    B_normalized_out = B_out / norm(B_out);
    % Calculate the rotation axis
    R_out = cross(B_normalized_out, [1; 0; 0]); % Cross product with x-axis
    % Calculate the rotation angle
    theta_out = acos(dot(B_normalized_out, [1; 0; 0])); % Dot product with x-axis
    % Create the rotation matrix
    K_out = [0 -R_out(3) R_out(2); R_out(3) 0 -R_out(1); -R_out(2) R_out(1) 0]; % Skew-symmetric matrix
    R_matrix_out = eye(3) + sin(theta_out) * K_out + (1 - cos(theta_out)) * K_out^2; % Rodrigues' rotation formula
    % Perform the coordinate transformation
    transformed_coords_out = R_matrix_out * [xx'; yy'; zz'];
    % Extract the transformed coordinates
    x_prime_out = transformed_coords_out(1, :)';
    y_prime_out = transformed_coords_out(2, :)';
    z_prime_out = transformed_coords_out(3, :)';
    % Define the vector in the initial reference frame
    v_initial_1 = [pxi_sub1, pyi_sub1, pzi_sub1]'; % Example vector in the initial reference frame
    % Calculate the inverse of the rotation matrix
    %R_inverse = inv(R_matrix_in); % Inverse of the rotation matrix A\b
    % Express the vector in the new reference frame
    v_new_1 = R_matrix_out \ v_initial_1;
    v_new_par_1 = v_new_1(1,:);
    v_new_per_1 = sqrt(v_new_1(2,:).^2 + v_new_1(3,:).^2);
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    str = string(Sprt(i).name);
    newStr = extractBetween(str,"prt.","_p000000.h5");
    N_steps = str2double(newStr);
    %dt = 0.0653;% <--- This has to come from the field data because this do not store the time resolution
    time_t = dt*N_steps;
    time_t_2_Omega=time_t./omega_pe_Omega_ce;
    %xspace = [-0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6];

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

    cll=5;

    %cd(path_s)
    fs=18;  x0=45;  y0=54;  xx1=1000;    yy1=400;
    %----------------------------------------------------------------------
    f12=figure(12);
    set(gcf,'position',[x0,y0,xx1*4/5,yy1])
    %----------------------------------------------------------------------
    %h1=subaxis(1,2,1,'SV',0.01,'SH',0.004,'MR',0.01,'ML',0.07,'PL',0.005,'PR',0.006);
    h1=subplot(1,2,1);
    dum1 = v_new_par_1; dum2 = v_new_per_1;
    [Ni,Xedgesi,Redgesi] = histcounts2(dum1,dum2,Xedges2D,Yedges2D);
    Ni=Ni(1:99,1:99)';    Xedges2i=Xedgesi(2:100)'; Redges2i=Redgesi(2:100)';
    Xedges2i=Xedges2i-(Xedges2i(2)-Xedges2i(1))/2;
    Redges2i=Redges2i-(Redges2i(2)-Redges2i(1))/2;
    [Ci,Di]=meshgrid(Xedges2i,Redges2i);
    c_lim=0.5*10^6;
    Ni(Ni<=no_le)=NaN;
    Ni_1_0 = Ni;
    hc=pcolor(Xedges2i,Redges2i, Ni./Di);
    %hc=pcolor(Xedges2i,Redges2i, (1.*Dist_kappa - 1.*Dist_maxwell)./Di);
    %hc=contourf(Xedges2i,Redges2i,Ni./Di,cll);
    hold on
    set(hc,'edgecolor','none');
    set(gca,'ColorScale','log','FontSize',fs)
    set(gca,'XScale','lin','YScale','lin','FontSize',fs)
    colormap(h1,'jet');
    %colormap(h1,BWR);
    caxis([1 (c_lim)]);
    hcb=colorbar; hcb.Location = 'northoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.XLabel.String = '$v_{\parallel}/c$'; ax.XTick = xspace_par;
    %ax.YLabel.String = '$v_{\perp}$';
    ax.YTick = [];
    xline(0,'--k'); yline(0,'--k');
    xlim(xlims); ylim(ylims);
    %title('eVDF Maxwell 1','Interpreter','latex','FontSize',fs);
    pbaspect([2 1 1])
    hold off

    %Dist_maxwell = Ni_1_0 ;
    Dist_kappa = Ni_1_0 ;

    %h2=subaxis(1,2,2,'SV',0.01,'SH',0.004,'MR',0.01,'ML',0.07,'PL',0.005,'PR',0.006);
    h2=subplot(1,2,2);
    dum_p2 = Bx.*cond_ii;
    hc=pcolor(ZLL,XLL,dum_p2);
    set(hc,'edgecolor','none')
    title('$B_{x}$','Interpreter','latex','FontSize',fs)
    ax = gca;
    ax.TickLabelInterpreter = 'latex';
    ax.XLabel.Interpreter='latex';
    ax.YLabel.Interpreter='latex';
    xlabel('$x/d_{e}$','Interpreter','latex','FontSize',fs)
    ylabel('$z/d_{e}$','Interpreter','latex','FontSize',fs)
    pbaspect([1 1 1])

    sgtitle('$$log(eVDF),K \ ; \ t = \ $$'+string(round(time_t_2_Omega,2))+'$$\ \Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
    %----------------------------------------------------------------------
    cd(path)
    %saveas(f12,strcat('large_vper_par_k' + string(round(time_t_2_Omega,2)) +'.png'));

end




 

