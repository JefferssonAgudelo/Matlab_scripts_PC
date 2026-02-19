doubke_folder_factor= 0 ;


%% FILE PATH
dir = input('Name of the directory? (Like ./low_amplitude/12 or ./large_amplitude/01): ', 's');
f_path = [dir, '/'];
fprintf('FILE PATH = %s\n', f_path);


% Box dimensions
xl = input('Box length in x-direction in 2*pi unity? (xl): ');
Lx = 2.0 * pi * xl;
fprintf('\n');

yl = input('Box length in y-direction in 2*pi unity? (yl): ');
Ly = 2.0 * pi * yl;
fprintf('\n');

zl = input('Box length in z-direction in 2*pi unity? (zl): ');
Lz = 2.0 * pi * zl;
fprintf('\n');

%%% Output format (0-> unformatted ; 1-> formatted)
outformat = input('Output format? (0-> unformatted ; 1-> formatted) [default: 0]: ');
if isempty(outformat)
    outformat = 0;
end
fprintf('\n');

if outformat == 0
    fprintf('Selected format: UNFORMATTED\n');
elseif outformat == 1
    fprintf('Selected format: FORMATTED\n');
end
fprintf('\n');

%%% Initialize variables
%a0 = 0.0;
%a1 = 0;
%a2 = 0;
%a3 = 0;
%b0 = 0.0;
%b1 = 0.0;
%b2 = 0.0;
%b3 = 0.0;
%b4 = 0.0;
%b5 = 0.0;

%%% Read times from tempo.dat
time = [];
dimt = 0;
filename = [f_path, 'tempo.dat'];

fid = fopen(filename, 'r');
if fid == -1
    error('Failed to open tempo.dat');
end

while ~feof(fid)
    line = fgetl(fid);
    if ischar(line)
        a0 = str2double(strtrim(line));
        time = [time; a0];
        dimt = dimt + 1;
    end
end

fclose(fid);

fprintf('TIMES TO BE READ ARE:\n');
for it = 1:dimt
    fprintf('%f\n', time(it));
end

%%% Read the dimensions from Ion.bin
filename = [f_path, 'Ion.bin'];

if outformat == 0
    fid = fopen(filename, 'rb');
    if fid == -1
        error('Failed to open Ion.bin');
    end

    % Read the first value with a 4-byte offset
    fseek(fid, 4, 'cof');
    a0 = fread(fid, 1, 'float64');

    % Read dimensions
    a1 = fread(fid, 1, 'int32');
    a2 = fread(fid, 1, 'int32');
    a3 = fread(fid, 1, 'int32');
    fclose(fid);

    fprintf('%d %d %d\n', a1, a2, a3);
else
    fid = fopen(filename, 'rb');
    if fid == -1
        error('Failed to open Ion.bin');
    end

    % Read values directly
    a0 = fread(fid, 1, 'float64');
    a1 = fread(fid, 1, 'int32');
    a2 = fread(fid, 1, 'int32');
    a3 = fread(fid, 1, 'int32');
    fclose(fid);
end

dim1 = a1;
dim2 = a2;
dim3 = a3;

%b0 = zeros(dim1, dim2, dim3);
%b1 = zeros(dim1, dim2, dim3);
%b2 = zeros(dim1, dim2, dim3);
%b3 = zeros(dim1, dim2, dim3);
%b4 = zeros(dim1, dim2, dim3);
%b5 = zeros(dim1, dim2, dim3);

kx = (0:dim1-1) - dim1 / 2 + 1;
kx = kx / xl;
ky = (0:dim2-1) - dim2 / 2 + 1;
ky = ky / yl;
kz = (0:dim3-1) - dim3 / 2 + 1;
kz = kz / zl;

%%% Number of times saved in tempo.dat
ns = input('Number of times saved in tempo.dat: ');
fprintf('\n');


% Now lets select the time stamp and clear space
tt = input('Time step to analyse (integer):');
fprintf('\n');

pressure_on = input('compute pressure terms 1 (true) 0(false) (integer):');
fprintf('\n');

%%% Read Ion.bin file data
llion = true; % Assuming llion is true based on the Python script
if llion
    time = [];
    px = [];
    py = [];
    pz = [];
    rho = [];
    outformat = 1;

    if outformat
        fid = fopen(filename, 'rb');
        if fid == -1
            error('Failed to open Ion.bin');
        end

        % Skip initial 4 bytes
        fseek(fid, 4, 'cof');

        for i = 1:ns
            time = [time; fread(fid, 1, 'float64')];
            dims = fread(fid, 3, 'int32');
            nx = dims(1);
            ny = dims(2);
            nz = dims(3);

            fprintf('%f\n', time(end));

            TOTAL_SIZE = nx * ny * nz;
            SHAPE = [nx, ny, nz];

            % Skip 8 bytes (int32 padding)
            fseek(fid, 8, 'cof');

            px = cat(4, px, reshape(fread(fid, TOTAL_SIZE, 'float64'), SHAPE));
            py = cat(4, py, reshape(fread(fid, TOTAL_SIZE, 'float64'), SHAPE));
            pz = cat(4, pz, reshape(fread(fid, TOTAL_SIZE, 'float64'), SHAPE));
            rho = cat(4, rho, reshape(fread(fid, TOTAL_SIZE, 'float64'), SHAPE));

            % Skip 8 bytes (int32 padding)
            fseek(fid, 8, 'cof');
        end

        fclose(fid);
    end
end

%%% Density perturbation:
%rho = permute(rho, [2, 3, 4, 1]);

% Total density:
den = 1.0 + rho;

% 2nd moments:
%px = permute(px, [2, 3, 4, 1]);
%py = permute(py, [2, 3, 4, 1]);
%pz = permute(pz, [2, 3, 4, 1]);

% Ion velocities:
uxp = px ./ (rho + 1.0);
uyp = py ./ (rho + 1.0);
uzp = pz ./ (rho + 1.0);

clearvars px py pz

%%% Magnetic and Electric Fields
lleb = 'y';
lleb = strcmp(lleb, 'y');

if lleb
    filename = [f_path, 'EB.bin'];
    time = [];
    ex = [];
    ey = [];
    ez = [];
    bx = [];
    by = [];
    bz = [];
    outformat = 1;

    if outformat
        fid = fopen(filename, 'rb');
        if fid == -1
            error('Failed to open EB.bin');
        end

        fseek(fid, 4, 'cof');

        for i = 1:ns
            time = [time; fread(fid, 1, 'float64')];
            dims = fread(fid, 3, 'int32');
            nx = dims(1);
            ny = dims(2);
            nz = dims(3);

            fprintf('%f\n', time(end));

            TOTAL_SIZE = nx * ny * nz;
            SHAPE = [nx, ny, nz];

            fseek(fid, 8, 'cof');

            ex = cat(4, ex, reshape(fread(fid, TOTAL_SIZE, 'float64'), SHAPE));
            ey = cat(4, ey, reshape(fread(fid, TOTAL_SIZE, 'float64'), SHAPE));
            ez = cat(4, ez, reshape(fread(fid, TOTAL_SIZE, 'float64'), SHAPE));
            bx = cat(4, bx, reshape(fread(fid, TOTAL_SIZE, 'float64'), SHAPE));
            by = cat(4, by, reshape(fread(fid, TOTAL_SIZE, 'float64'), SHAPE));
            bz = cat(4, bz, reshape(fread(fid, TOTAL_SIZE, 'float64'), SHAPE));

            fseek(fid, 8, 'cof');
        end

        fclose(fid);
    end
end

%%% Magnetic field and electric field perturbations:
%bx = permute(bx, [2, 3, 4, 1]);
%by = permute(by, [2, 3, 4, 1]);
%bz = permute(bz, [2, 3, 4, 1]);
%ex = permute(ex, [2, 3, 4, 1]);
%ey = permute(ey, [2, 3, 4, 1]);
%ez = permute(ez, [2, 3, 4, 1]);

%%% Axis and time
nx = dim1;
ny = dim2;
nz = dim3;
ns = dimt;
x = (0:nx-1) * xl * 2.0 * pi / (nx - 1);
y = (0:ny-1) * yl * 2.0 * pi / (ny - 1);
z = (0:nz-1) * zl * 2.0 * pi / (nz - 1);
t = time;
%------------------------------------------------------------------------

%------------------------------------------------------------------------
ex_t = squeeze(ex(:,:,:,tt));
ey_t = squeeze(ey(:,:,:,tt));
ez_t = squeeze(ez(:,:,:,tt));
clearvars ex ey ez

bx_t = squeeze(bx(:,:,:,tt));
by_t = squeeze(by(:,:,:,tt));
bz_t = squeeze(bz(:,:,:,tt)) + 1 ; % here is where I included the 1 of the normalization
clearvars bx by bz

uxp_t = squeeze(uxp(:,:,:,tt));
uyp_t = squeeze(uyp(:,:,:,tt));
uzp_t = squeeze(uzp(:,:,:,tt));
clearvars uxp uyp uzp

% rho_t = squeeze(rho(:,:,:,tt));
% clearvars rho

den_t = squeeze(den(:,:,:,tt));
clearvars den
%------------------------------------------------------------------------

%%% Read the pressure component

if(pressure_on == 1)
    llpress = 'y';
    llpress = strcmp(llpress, 'y');

    if llpress
        filename = [f_path, 'Press.bin'];
        time = [];
        pxx = [];
        pyy = [];
        pzz = [];
        pxy = [];
        pxz = [];
        pyz = [];
        outformat = 1;

        if outformat
            fid = fopen(filename, 'rb');
            if fid == -1
                error('Failed to open Press.bin');
            end

            fseek(fid, 4, 'cof');

            for i = 1:ns
                time = [time; fread(fid, 1, 'float64')];
                dims = fread(fid, 3, 'int32');
                nx = dims(1);
                ny = dims(2);
                nz = dims(3);

                fprintf('%f\n', time(end));

                TOTAL_SIZE = nx * ny * nz;
                SHAPE = [nx, ny, nz];

                fseek(fid, 8, 'cof');

                pxx = cat(4, pxx, reshape(fread(fid, TOTAL_SIZE, 'float64'), SHAPE));
                pyy = cat(4, pyy, reshape(fread(fid, TOTAL_SIZE, 'float64'), SHAPE));
                pzz = cat(4, pzz, reshape(fread(fid, TOTAL_SIZE, 'float64'), SHAPE));
                pxy = cat(4, pxy, reshape(fread(fid, TOTAL_SIZE, 'float64'), SHAPE));
                pxz = cat(4, pxz, reshape(fread(fid, TOTAL_SIZE, 'float64'), SHAPE));
                pyz = cat(4, pyz, reshape(fread(fid, TOTAL_SIZE, 'float64'), SHAPE));

                fseek(fid, 8, 'cof');
            end

            fclose(fid);
        end
    end

    %%% Convert pressure components to array format
    %pxx = permute(pxx, [2, 3, 4, 1]);
    %pyy = permute(pyy, [2, 3, 4, 1]);
    %pzz = permute(pzz, [2, 3, 4, 1]);
    %pxy = permute(pxy, [2, 3, 4, 1]);
    %pxz = permute(pxz, [2, 3, 4, 1]);
    %pyz = permute(pyz, [2, 3, 4, 1]);

    pxx_t = squeeze(pxx(:,:,:,tt));
    pyy_t = squeeze(pyy(:,:,:,tt));
    pzz_t = squeeze(pzz(:,:,:,tt));
    pxy_t = squeeze(pxy(:,:,:,tt));
    pxz_t = squeeze(pxz(:,:,:,tt));
    pyz_t = squeeze(pyz(:,:,:,tt));

    clearvars pxx pyy pzz pxy pxz pyz

end

%%% Compute the parallel and perpendicular temperature
%{
% Calculate the magnetic field magnitude including the guide field: (+ 1)
B_mag = sqrt(bx_t.^2 + by_t.^2 + (bz_t + 1.0).^2);

% Calculate the unit vector in the magnetic field direction
b_x = bx_t ./ B_mag;
b_y = by_t ./ B_mag;
b_z = (bz_t + 1.0) ./ B_mag;

% Calculate the gyrotropic pressure components
Ppar = pxx_t .* b_x.^2  + pyy_t .* b_y.^2  + pzz_t .* b_z.^2 + ...
       2 * (pxy_t .* b_x .* b_y + pxz_t .* b_x .* b_z + pyz_t .* b_y .* b_z);
Pperp = 0.5 * (pxx_t .* (1 - b_x.^2) + pyy_t .* (1 - b_y.^2) + pzz_t .* (1 - b_z.^2) + ...
       2.0 * (pxy_t .* (-b_x .* b_y) + pxz_t .* (-b_x .* b_z) + pyz_t .* (-b_y .* b_z)));

% Divide by density to get the temperature components
Tpar = Ppar ./ den_t;
Tperp = Pperp ./ den_t;
%}

%%% Compute the current components
% Compute the gradients of Bx, By, Bz

% This is the correct of computing the gradient component. It also matches
% the way I am computing the gradients for the PSC data.

% This is important for this data because this is the correct way to
% estimate the current.
%--------------------------------------------------------------------------

resx = Lx/nx;
resy = Ly/ny;
resz = Lz/nz;

grad_fact=1;

[Bx_dt2_y, Bx_dt2_x, Bx_dt2_z] = gradient(bx_t);
[By_dt2_y, By_dt2_x, By_dt2_z] = gradient(by_t);
[Bz_dt2_y, Bz_dt2_x, Bz_dt2_z] = gradient(bz_t);

Div_B_dt2 = Bx_dt2_x/(grad_fact.*resx) + By_dt2_y/(grad_fact.*resy) + Bz_dt2_z/(grad_fact.*resz);

Jx_t = Bz_dt2_y/(grad_fact.*resy) - By_dt2_z/(grad_fact.*resz);
Jy_t = Bx_dt2_z/(grad_fact.*resz) - Bz_dt2_x/(grad_fact.*resx);
Jz_t = By_dt2_x/(grad_fact.*resx) - Bx_dt2_y/(grad_fact.*resy);
%--------------------------------------------------------------------------

clearvars Bx_dt2_* By_dt2_* Bz_dt2_*

%%% Compute the electron velocities (uxe, uye, uze)
uxe_t = uxp_t - Jx_t ./ den_t;
uye_t = uyp_t - Jy_t ./ den_t;
uze_t = uzp_t - Jz_t ./ den_t;

%%%
%------------------------------------------------------------------------
% Now lets make some plots:
%------------------------------------------------------------------------
% % f5=figure(5);
% % subplot(1,3,1)
% % dum=sqrt(ex_t.^2 + ey_t.^2 + ez_t.^2 );
% % dump = squeeze(dum(:,:,end));
% % y_lim = max(max(max(abs(dump))));
% % hc=pcolor(x,y,dump');
% % hold on
% % set(hc,'edgecolor','none')
% % set(gca,'ColorScale','log')
% % colorbar
% % clim([-y_lim y_lim])
% % title('E_{mag}')
% %
% % subplot(1,3,2)
% % dum=B_mag;
% % dump = squeeze(dum(:,:,end));
% % y_lim = max(max(max(abs(dump))));
% % hc=pcolor(x,y,dump');
% % hold on
% % set(hc,'edgecolor','none')
% % set(gca,'ColorScale','log')
% % colorbar
% % clim([-y_lim y_lim])
% % title('B_{mag}')
% %
% % subplot(1,3,3)
% % dum=sqrt(Jx.^2 + Jy.^2 + Jz.^2 );
% % dump = squeeze(dum(:,:,end));
% % y_lim = max(max(max(abs(dump))));
% % hc=pcolor(x,y,dump');
% % hold on
% % set(hc,'edgecolor','none')
% % set(gca,'ColorScale','log')
% % colorbar
% % clim([-y_lim y_lim])
% % title('J_{mag}')
% %
% % clearvars dum dump
% % %--------------------------------------------------------------------------

% This shows that the x, y and z coordinates are correct. When plotting I
% am using the transpose
%--------------------------------------------------------------------------
% % f6=figure(6);
% % subplot(1,3,1)
% % dum=ex_t;
% % dump = squeeze(dum(:,:,1));
% % y_lim = max(max(max(abs(dump))));
% % hc=pcolor(x,y,dump');
% % hold on
% % set(hc,'edgecolor','none')
% % set(gca,'ColorScale','lin')
% % colorbar
% % clim([-y_lim y_lim])
% % title('Ex_{xy}')
% % subplot(1,3,2)
% % dum=ex_t;
% % dump = squeeze(dum(:,1,:));
% % y_lim = max(max(max(abs(dump))));
% % hc=pcolor(x,z,dump');
% % hold on
% % set(hc,'edgecolor','none')
% % set(gca,'ColorScale','lin')
% % colorbar
% % clim([-y_lim y_lim])
% % title('Ex_{xz}')
% % subplot(1,3,3)
% % dum=ex_t;
% % dump = squeeze(dum(1,:,:));
% % y_lim = max(max(max(abs(dump))));
% % hc=pcolor(y,z,dump');
% % hold on
% % set(hc,'edgecolor','none')
% % set(gca,'ColorScale','lin')
% % colorbar
% % clim([-y_lim y_lim])
% % title('Ex_{yz}')
% % clearvars dum dump
% %
% %
% % f7=figure(7);
% % subplot(1,3,1)
% % dum=Jx_t;
% % dump = squeeze(dum(:,:,1));
% % y_lim = max(max(max(abs(dump))));
% % hc=pcolor(x,y,dump');
% % hold on
% % set(hc,'edgecolor','none')
% % set(gca,'ColorScale','lin')
% % colorbar
% % clim([-y_lim y_lim])
% % title('Jx_{xy}')
% % subplot(1,3,2)
% % dum=Jx_t;
% % dump = squeeze(dum(:,1,:));
% % y_lim = max(max(max(abs(dump))));
% % hc=pcolor(x,z,dump');
% % hold on
% % set(hc,'edgecolor','none')
% % set(gca,'ColorScale','lin')
% % colorbar
% % clim([-y_lim y_lim])
% % title('Jx_{xz}')
% % subplot(1,3,3)
% % dum=Jx_t;
% % dump = squeeze(dum(1,:,:));
% % y_lim = max(max(max(abs(dump))));
% % hc=pcolor(y,z,dump');
% % hold on
% % set(hc,'edgecolor','none')
% % set(gca,'ColorScale','lin')
% % colorbar
% % clim([-y_lim y_lim])
% % title('Jx_{yz}')
% % clearvars dum dump
%------------------------------------------------------------------------
%------------------------------------------------------------------------

%%%
% This is now to compute the terms that correspond to the filtering and stuff
% There is no electron pressure.
%----------------------------------------------------------------------------
xl=x; yl=y; zl=z;
%----------------------------------------------------------------------------

% Here is where the parameter for the scale filtering are defined (the size of the window)
%----------------------------------------------------------------------
% define the window for the kernel and convolution

%for ndv =1:10
ndv = 1; % fractiopn of the box size. create a patch for the size of the convolution window
%l_wind = nx/ndv; %size of the window

%----------------------------------------------------------------------

% Maybe it is better to define this in terms of the real resolution
%----------------------------------------------------------------------
%l_wind = (ndv/10)*Lx; %size of the window
%l_wind = 4; % l_wind = 4; this is the value that I use for reference 

l_wind = input('Window size:');
fprintf('\n');
%----------------------------------------------------------------------

%----------------------------------------------------------------------
Bx_dt=bx_t;
By_dt=by_t;
Bz_dt=bz_t;

clearvars bx_t by_t bz_t

Ex_dt=ex_t;
Ey_dt=ey_t;
Ez_dt=ez_t;

clearvars ex_t ey_t ez_t

Jx_dt=Jx_t;
Jy_dt=Jy_t;
Jz_dt=Jz_t;

clearvars Jx_t Jy_t Jz_t

n_0_dt = den_t;

clearvars den_t


v_x_dt=uxp_t;
v_y_dt=uyp_t;
v_z_dt=uzp_t;

clearvars uxp_t uyp_t uzp_t uxe_t uye_t uze_t

% To get the electron pressure

beta_i = input('set the beta_i % : ');
Ti02Te0 = input('set the Ti0/Te0 % : ');

mu0 = 1;

Te0 = beta_i/(2*mu0*Ti02Te0);
%Te0 = beta_i/(8*pi*Ti02Te0);

Pe_dt = n_0_dt * Te0;

if(pressure_on == 1)
    Pij_ixx_dt=pxx_t;
    Pij_ixy_dt=pxy_t;
    Pij_ixz_dt=pxz_t;
    Pij_iyy_dt=pyy_t;
    Pij_iyz_dt=pyz_t;
    Pij_izz_dt=pzz_t;

    clearvars pxx_t pxy_t pxz_t pyy_t pyz_t pzz_t
end

%----------------------------------------------------------------------


%%% ----------------------------------------------------------------------
% Lets compute the generalised ohms terms for total field

%For memory constraints lets devive this into components
%select the component % component x=1, y=2, z=3;
component = input('select the component % component x=1, y=2, z=3: ');

%----------------------------------------------------------------------
me = 1/100;
mi=1;
mre = mi*me/(mi+me);
%----------------------------------------------------------------------


% This is where the analysis of things begin 
%----------------------------------------------------------------------
% Computing non-linear terms for the generalised Ohms law
%----------------------------------------------------------------------

if (component == 1)
    v_x_B_x_dt = v_y_dt.*Bz_dt - v_z_dt.*By_dt;
    J_x_B_x_dt = Jy_dt.*Bz_dt - Jz_dt.*By_dt;
    %J_x_B_x_dt = (mre/me)*J_x_B_x_dt;
    v_J_xx_dt = v_x_dt.*Jx_dt;
    v_J_yx_dt = v_y_dt.*Jx_dt;
    v_J_zx_dt = v_z_dt.*Jx_dt;
    J_v_xx_dt = Jx_dt.*v_x_dt;
    J_v_yx_dt = Jy_dt.*v_x_dt;
    J_v_zx_dt = Jz_dt.*v_x_dt;
    J_J_2n_xx_dt = Jx_dt.*Jx_dt./(n_0_dt );
    J_J_2n_xy_dt = Jx_dt.*Jy_dt./(n_0_dt );
    J_J_2n_xz_dt = Jx_dt.*Jz_dt./(n_0_dt );
elseif (component == 2)
    v_x_B_y_dt = v_z_dt.*Bx_dt - v_x_dt.*Bz_dt;
    J_x_B_y_dt = Jz_dt.*Bx_dt - Jx_dt.*Bz_dt;
    %J_x_B_y_dt = (mre/me)*J_x_B_y_dt;
    v_J_xy_dt = v_x_dt.*Jy_dt;
    v_J_yy_dt = v_y_dt.*Jy_dt;
    v_J_zy_dt = v_z_dt.*Jy_dt;
    J_v_xy_dt = Jx_dt.*v_y_dt;
    J_v_yy_dt = Jy_dt.*v_y_dt;
    J_v_zy_dt = Jz_dt.*v_y_dt;
    J_J_2n_xy_dt = Jx_dt.*Jy_dt./(n_0_dt );
    J_J_2n_yy_dt = Jy_dt.*Jy_dt./(n_0_dt );
    J_J_2n_yz_dt = Jy_dt.*Jz_dt./(n_0_dt );
elseif (component == 3)
    v_x_B_z_dt = v_x_dt.*By_dt - v_y_dt.*Bx_dt;
    J_x_B_z_dt = Jx_dt.*By_dt - Jy_dt.*Bx_dt;
    %J_x_B_z_dt = (mre/me)*J_x_B_z_dt;
    v_J_xz_dt = v_x_dt.*Jz_dt;
    v_J_yz_dt = v_y_dt.*Jz_dt;
    v_J_zz_dt = v_z_dt.*Jz_dt;
    J_v_xz_dt = Jx_dt.*v_z_dt;
    J_v_yz_dt = Jy_dt.*v_z_dt;
    J_v_zz_dt = Jz_dt.*v_z_dt;
    J_J_2n_xz_dt = Jx_dt.*Jz_dt./(n_0_dt );
    J_J_2n_yz_dt = Jy_dt.*Jz_dt./(n_0_dt );
    J_J_2n_zz_dt = Jz_dt.*Jz_dt./(n_0_dt );
end


% J_J_2n_xx_dt = Jx_dt.*Jx_dt./(n_0_dt );
% J_J_2n_xy_dt = Jx_dt.*Jy_dt./(n_0_dt );
% J_J_2n_xz_dt = Jx_dt.*Jz_dt./(n_0_dt );
% J_J_2n_yy_dt = Jy_dt.*Jy_dt./(n_0_dt );
% J_J_2n_yz_dt = Jy_dt.*Jz_dt./(n_0_dt );
% J_J_2n_zz_dt = Jz_dt.*Jz_dt./(n_0_dt );
%----------------------------------------------------------------------

%Now let lets compute the gradients
grad_fact = 1; % This always need to be two??
sigma_g = 1;
%Grad_Pe
%----------------------------------------------------------------------


%----------------------------------------------------------------------
[Pe_dt_y, Pe_dt_x, Pe_dt_z] = gradient(Pe_dt);
%----------------------------------------------------------------------
if (component == 1)
    Div_Pe_dt_x = Pe_dt_x/(grad_fact.*resx);
elseif (component == 2)
    Div_Pe_dt_y = Pe_dt_y/(grad_fact.*resy);
elseif (component == 3)
    Div_Pe_dt_z = Pe_dt_z/(grad_fact.*resz);
end
clearvars Pe_dt_*
%----------------------------------------------------------------------

if(pressure_on == 1)
    %----------------------------------------------------------------------
    [Pij_ixx_dt_y, Pij_ixx_dt_x, Pij_ixx_dt_z] = gradient(Pij_ixx_dt);
    [Pij_iyy_dt_y, Pij_iyy_dt_x, Pij_iyy_dt_z] = gradient(Pij_iyy_dt);
    [Pij_izz_dt_y, Pij_izz_dt_x, Pij_izz_dt_z] = gradient(Pij_izz_dt);
    [Pij_ixy_dt_y, Pij_ixy_dt_x, Pij_ixy_dt_z] = gradient(Pij_ixy_dt);
    [Pij_ixz_dt_y, Pij_ixz_dt_x, Pij_ixz_dt_z] = gradient(Pij_ixz_dt);
    [Pij_iyz_dt_y, Pij_iyz_dt_x, Pij_iyz_dt_z] = gradient(Pij_iyz_dt);
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    if (component == 1)
        Div_Pi_dt_x = Pij_ixx_dt_x/(grad_fact.*resx) + Pij_ixy_dt_y/(grad_fact.*resy) + Pij_ixz_dt_z/(grad_fact.*resz);
    elseif (component == 2)
        Div_Pi_dt_y = Pij_ixy_dt_x/(grad_fact.*resx) + Pij_iyy_dt_y/(grad_fact.*resy) + Pij_iyz_dt_z/(grad_fact.*resz);
    elseif (component == 3)
        Div_Pi_dt_z = Pij_ixz_dt_x/(grad_fact.*resx) + Pij_iyz_dt_y/(grad_fact.*resy) + Pij_izz_dt_z/(grad_fact.*resz);
    end
    clearvars Pij_ixx_dt_* Pij_ixy_dt_* Pij_ixz_dt_* ...
        Pij_iyy_dt_* Pij_iyz_dt_* Pij_izz_dt_* ...
        %----------------------------------------------------------------------
end


% This is the correction of the div Pe
%----------------------------------------------------------------------
if (component == 1)
    %     Div_Pe_dt_x = (mre/me)*Div_Pe_dt_x - doubke_folder_factor*(mre/mi)*Div_Pi_dt_x ;
    % elseif (component == 2)
    %     Div_Pe_dt_y = (mre/me)*Div_Pe_dt_y - doubke_folder_factor*(mre/mi)*Div_Pi_dt_y ;
    % elseif (component == 3)
    %     Div_Pe_dt_z = (mre/me)*Div_Pe_dt_z - doubke_folder_factor*(mre/mi)*Div_Pi_dt_z ;
    % 
        Div_Pe_dt_x = (mre/me)*Div_Pe_dt_x ;
    elseif (component == 2)
        Div_Pe_dt_y = (mre/me)*Div_Pe_dt_y ;
    elseif (component == 3)
        Div_Pe_dt_z = (mre/me)*Div_Pe_dt_z ;
end
%----------------------------------------------------------------------
%Considering the ion speed as the flow speed.

% Compute the derivatives, the dyadic products and their derivatives in a
% component based fashion
%----------------------------------------------------------------------

% In the Hybrid-Vlasov there is no electron pressure
%{
%----------------------------------------------------------------------
[Pij_exx_dt_y, Pij_exx_dt_x, Pij_exx_dt_z] = gradient(Pij_exx_dt);
[Pij_eyy_dt_y, Pij_eyy_dt_x, Pij_eyy_dt_z] = gradient(Pij_eyy_dt);
[Pij_ezz_dt_y, Pij_ezz_dt_x, Pij_ezz_dt_z] = gradient(Pij_ezz_dt);
[Pij_exy_dt_y, Pij_exy_dt_x, Pij_exy_dt_z] = gradient(Pij_exy_dt);
[Pij_exz_dt_y, Pij_exz_dt_x, Pij_exz_dt_z] = gradient(Pij_exz_dt);
[Pij_eyz_dt_y, Pij_eyz_dt_x, Pij_eyz_dt_z] = gradient(Pij_eyz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    Div_Pe_dt_x = Pij_exx_dt_x/(grad_fact.*resx) + Pij_exy_dt_y/(grad_fact.*resy) + Pij_exz_dt_z/(grad_fact.*resz);
elseif (component == 2)
    Div_Pe_dt_y = Pij_exy_dt_x/(grad_fact.*resx) + Pij_eyy_dt_y/(grad_fact.*resy) + Pij_eyz_dt_z/(grad_fact.*resz);
elseif (component == 3)
    Div_Pe_dt_z = Pij_exz_dt_x/(grad_fact.*resx) + Pij_eyz_dt_y/(grad_fact.*resy) + Pij_ezz_dt_z/(grad_fact.*resz);
end
clearvars Pij_exx_dt_* Pij_exy_dt_* Pij_exz_dt_* ...
    Pij_eyy_dt_* Pij_eyz_dt_* Pij_ezz_dt_* ...
%----------------------------------------------------------------------
%}


%----------------------------------------------------------------------
if (component == 1)
    [v_J_dt_xx_y, v_J_dt_xx_x, v_J_dt_xx_z] = gradient(v_J_xx_dt);
    [v_J_dt_yx_y, v_J_dt_yx_x, v_J_dt_yx_z] = gradient(v_J_yx_dt);
    [v_J_dt_zx_y, v_J_dt_zx_x, v_J_dt_zx_z] = gradient(v_J_zx_dt);
    Div_vJ_dt_x = v_J_dt_xx_x/(grad_fact.*resx) + v_J_dt_yx_y/(grad_fact.*resy) + v_J_dt_zx_z/(grad_fact.*resz);
elseif (component == 2)
    [v_J_dt_xy_y, v_J_dt_xy_x, v_J_dt_xy_z] = gradient(v_J_xy_dt);
    [v_J_dt_yy_y, v_J_dt_yy_x, v_J_dt_yy_z] = gradient(v_J_yy_dt);
    [v_J_dt_zy_y, v_J_dt_zy_x, v_J_dt_zy_z] = gradient(v_J_zy_dt);
    Div_vJ_dt_y = v_J_dt_xy_x/(grad_fact.*resx) + v_J_dt_yy_y/(grad_fact.*resy) + v_J_dt_zy_z/(grad_fact.*resz);
elseif (component == 3)
    [v_J_dt_xz_y, v_J_dt_xz_x, v_J_dt_xz_z] = gradient(v_J_xz_dt);
    [v_J_dt_yz_y, v_J_dt_yz_x, v_J_dt_yz_z] = gradient(v_J_yz_dt);
    [v_J_dt_zz_y, v_J_dt_zz_x, v_J_dt_zz_z] = gradient(v_J_zz_dt);
    Div_vJ_dt_z = v_J_dt_xz_x/(grad_fact.*resx) + v_J_dt_yz_y/(grad_fact.*resy) + v_J_dt_zz_z/(grad_fact.*resz);
end
%----------------------------------------------------------------------

%----------------------------------------------------------------------
clearvars v_J_dt_xx_* v_J_dt_xy_* v_J_dt_xz_* ...
    v_J_dt_yx_* v_J_dt_yy_* v_J_dt_yz_* ...
    v_J_dt_zx_* v_J_dt_zy_* v_J_dt_zz_*
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    [J_v_dt_xx_y, J_v_dt_xx_x, J_v_dt_xx_z] = gradient(J_v_xx_dt);
    [J_v_dt_yx_y, J_v_dt_yx_x, J_v_dt_yx_z] = gradient(J_v_yx_dt);
    [J_v_dt_zx_y, J_v_dt_zx_x, J_v_dt_zx_z] = gradient(J_v_zx_dt);
    Div_Jv_dt_x = J_v_dt_xx_x/(grad_fact.*resx) + J_v_dt_yx_y/(grad_fact.*resy) + J_v_dt_zx_z/(grad_fact.*resz);
elseif (component == 2)
    [J_v_dt_xy_y, J_v_dt_xy_x, J_v_dt_xy_z] = gradient(J_v_xy_dt);
    [J_v_dt_yy_y, J_v_dt_yy_x, J_v_dt_yy_z] = gradient(J_v_yy_dt);
    [J_v_dt_zy_y, J_v_dt_zy_x, J_v_dt_zy_z] = gradient(J_v_zy_dt);
    Div_Jv_dt_y = J_v_dt_xy_x/(grad_fact.*resx) + J_v_dt_yy_y/(grad_fact.*resy) + J_v_dt_zy_z/(grad_fact.*resz);
elseif (component == 3)
    [J_v_dt_xz_y, J_v_dt_xz_x, J_v_dt_xz_z] = gradient(J_v_xz_dt);
    [J_v_dt_yz_y, J_v_dt_yz_x, J_v_dt_yz_z] = gradient(J_v_yz_dt);
    [J_v_dt_zz_y, J_v_dt_zz_x, J_v_dt_zz_z] = gradient(J_v_zz_dt);
    Div_Jv_dt_z = J_v_dt_xz_x/(grad_fact.*resx) + J_v_dt_yz_y/(grad_fact.*resy) + J_v_dt_zz_z/(grad_fact.*resz);
end

clearvars J_v_dt_xx_* J_v_dt_xy_* J_v_dt_xz_* ...
    J_v_dt_yx_* J_v_dt_yy_* J_v_dt_yz_* ...
    J_v_dt_zx_* J_v_dt_zy_* J_v_dt_zz_*
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    [J_J_dt_xx_y, J_J_dt_xx_x, J_J_dt_xx_z] = gradient(J_J_2n_xx_dt);
    [J_J_dt_xy_y, J_J_dt_xy_x, J_J_dt_xy_z] = gradient(J_J_2n_xy_dt);
    [J_J_dt_xz_y, J_J_dt_xz_x, J_J_dt_xz_z] = gradient(J_J_2n_xz_dt);
    Div_JJ_dt_x = J_J_dt_xx_x/(grad_fact.*resx) + J_J_dt_xy_y/(grad_fact.*resy) + J_J_dt_xz_z/(grad_fact.*resz);
elseif (component == 2)
    [J_J_dt_xy_y, J_J_dt_xy_x, J_J_dt_xy_z] = gradient(J_J_2n_xy_dt);
    [J_J_dt_yy_y, J_J_dt_yy_x, J_J_dt_yy_z] = gradient(J_J_2n_yy_dt);
    [J_J_dt_yz_y, J_J_dt_yz_x, J_J_dt_yz_z] = gradient(J_J_2n_yz_dt);
    Div_JJ_dt_y = J_J_dt_xy_x/(grad_fact.*resx) + J_J_dt_yy_y/(grad_fact.*resy) + J_J_dt_yz_z/(grad_fact.*resz);
elseif (component == 3)
    [J_J_dt_xz_y, J_J_dt_xz_x, J_J_dt_xz_z] = gradient(J_J_2n_xz_dt);
    [J_J_dt_yz_y, J_J_dt_yz_x, J_J_dt_yz_z] = gradient(J_J_2n_yz_dt);
    [J_J_dt_zz_y, J_J_dt_zz_x, J_J_dt_zz_z] = gradient(J_J_2n_zz_dt);
    Div_JJ_dt_z = J_J_dt_xz_x/(grad_fact.*resx) + J_J_dt_yz_y/(grad_fact.*resy) + J_J_dt_zz_z/(grad_fact.*resz);
end

clearvars J_J_dt_xx_* J_J_dt_xy_* J_J_dt_xz_* ...
    J_J_dt_yy_* J_J_dt_yz_* J_J_dt_zz_*
%----------------------------------------------------------------------

% for the tau
%(<vJ + Jv - JJ/n> - (<v><J> + <J><v> - <J><J>/<n>))/<n>
% % %----------------------------------------------------------------------

% % sub_tau1_xx = v_J_xx_dt + J_v_xx_dt - J_J_2n_xx_dt;
% % %sub_tau1_xy = v_J_xy_dt + J_v_xy_dt - J_J_2n_xy_dt;
% % %sub_tau1_xz = v_J_xz_dt + J_v_xz_dt - J_J_2n_xz_dt;
% % sub_tau1_yx = v_J_yx_dt + J_v_yx_dt - J_J_2n_xy_dt;
% % %sub_tau1_yy = v_J_yy_dt + J_v_yy_dt - J_J_2n_yy_dt;
% % %sub_tau1_yz = v_J_yz_dt + J_v_yz_dt - J_J_2n_yz_dt;
% % sub_tau1_zx = v_J_zx_dt + J_v_zx_dt - J_J_2n_xz_dt;
% % %sub_tau1_zy = v_J_zy_dt + J_v_zy_dt - J_J_2n_yz_dt;
% % %sub_tau1_zz = v_J_zz_dt + J_v_zz_dt - J_J_2n_zz_dt;

if (component == 1)
    sub_tau1_xx = v_J_xx_dt + J_v_xx_dt - J_J_2n_xx_dt;
    sub_tau1_yx = v_J_yx_dt + J_v_yx_dt - J_J_2n_xy_dt;
    sub_tau1_zx = v_J_zx_dt + J_v_zx_dt - J_J_2n_xz_dt;
elseif (component == 2)
    sub_tau1_xy = v_J_xy_dt + J_v_xy_dt - J_J_2n_xy_dt;
    sub_tau1_yy = v_J_yy_dt + J_v_yy_dt - J_J_2n_yy_dt;
    sub_tau1_zy = v_J_zy_dt + J_v_zy_dt - J_J_2n_yz_dt;
elseif (component == 3)
    sub_tau1_xz = v_J_xz_dt + J_v_xz_dt - J_J_2n_xz_dt;
    sub_tau1_yz = v_J_yz_dt + J_v_yz_dt - J_J_2n_yz_dt;
    sub_tau1_zz = v_J_zz_dt + J_v_zz_dt - J_J_2n_zz_dt;
end
% % %----------------------------------------------------------------------

%----------------------------------------------------------------------
clearvars v_J_* J_v_* J_J_*
%----------------------------------------------------------------------

%%% Proceed with the scale filtering
%----------------------------------------------------------------------
%Compute the fft    %Compute the averages using a kernel
%----------------------------------------------------------------------

% These four lines are the filtering
%----------------------------------------------------------------------


kx = 2 * pi * [0:nx/2 -nx/2+1:-1] / Lx; % Wavenumbers in x
ky = 2 * pi * [0:ny/2 -ny/2+1:-1] / Lz; % Wavenumbers in y
kz = 2 * pi * [0:nz/2 -nz/2+1:-1] / Lz; % Wavenumbers in z
[Kz, Kx, Ky] = meshgrid(kz, kx ,ky); % Note the order here Kz goes first

%Dx = 8*Lx/nx; 
%Ex_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,Ex_dt);

Dx = l_wind*Lx/nx;

Bx_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,Bx_dt);
By_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,By_dt);
Bz_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,Bz_dt);

Ex_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,Ex_dt);
Ey_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,Ey_dt);
Ez_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,Ez_dt);

Jx_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,Jx_dt);
Jy_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,Jy_dt);
Jz_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,Jz_dt);

% v_ix_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,v_ix_dt);
% v_iy_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,v_iy_dt);
% v_iz_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,v_iz_dt);
% 
% v_ex_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,v_ex_dt);
% v_ey_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,v_ey_dt);
% v_ez_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,v_ez_dt);

v_x_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,v_x_dt);
v_y_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,v_y_dt);
v_z_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,v_z_dt);

n_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,n_0_dt);

if(pressure_on == 1)
    Pij_ixx_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,Pij_ixx_dt);
    Pij_ixy_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,Pij_ixy_dt);
    Pij_ixz_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,Pij_ixz_dt);
    Pij_iyy_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,Pij_iyy_dt);
    Pij_iyz_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,Pij_iyz_dt);
    Pij_izz_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,Pij_izz_dt);
end

%----------------------------------------------------------------------
%correction of the electric field

%L2Ex_dt = 4*del2(Ex_dt)/(grad_fact.*resx)^2;
%L2Ey_dt = 4*del2(Ey_dt)/(grad_fact.*resx)^2;
%L2Ez_dt = 4*del2(Ez_dt)/(grad_fact.*resx)^2;

if (component == 1)
    [Ex_dt_y, Ex_dt_x, Ex_dt_z] = gradient(Ex_dt);
    [Ex_dt_yy, ~, ~] = gradient(Ex_dt_y);
    [~, Ex_dt_xx, ~] = gradient(Ex_dt_x);
    [~, ~, Ex_dt_zz] = gradient(Ex_dt_z);
    L2Ex_dt = (Ex_dt_xx + Ex_dt_yy + Ex_dt_zz)/(grad_fact.*resx)^2;
    %----------------------------------------------------------------------
    L2Ex_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,L2Ex_dt);
    %----------------------------------------------------------------------
elseif (component == 2)
    [Ey_dt_y, Ey_dt_x, Ey_dt_z] = gradient(Ey_dt);
    [Ey_dt_yy, ~, ~] = gradient(Ey_dt_y);
    [~, Ey_dt_xx, ~] = gradient(Ey_dt_x);
    [~, ~, Ey_dt_zz] = gradient(Ey_dt_z);
    L2Ey_dt = (Ey_dt_xx + Ey_dt_yy + Ey_dt_zz)/(grad_fact.*resx)^2;
    %----------------------------------------------------------------------
    L2Ey_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,L2Ey_dt);
    %----------------------------------------------------------------------
elseif (component == 3)
    [Ez_dt_y, Ez_dt_x, Ez_dt_z] = gradient(Ez_dt);
    [Ez_dt_yy, ~, ~] = gradient(Ez_dt_y);
    [~, Ez_dt_xx, ~] = gradient(Ez_dt_x);
    [~, ~, Ez_dt_zz] = gradient(Ez_dt_z);
    L2Ez_dt = (Ez_dt_xx + Ez_dt_yy + Ez_dt_zz)/(grad_fact.*resx)^2;
    %----------------------------------------------------------------------
    L2Ez_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,L2Ez_dt);
    %----------------------------------------------------------------------
end


%%% Computing non-linear terms for the generalised Ohms law
%----------------------------------------------------------------------
if (component == 1)
    v_filt_x_B_filt_x = v_y_filt.*Bz_filt - v_z_filt.*By_filt;
    J_filt_x_B_filt_x = Jy_filt.*Bz_filt - Jz_filt.*By_filt;
    J_filt_x_B_filt_x = (mre/me)*J_filt_x_B_filt_x;
elseif (component == 2)
    v_filt_x_B_filt_y = v_z_filt.*Bx_filt - v_x_filt.*Bz_filt;
    J_filt_x_B_filt_y = Jz_filt.*Bx_filt - Jx_filt.*Bz_filt;
    J_filt_x_B_filt_y = (mre/me)*J_filt_x_B_filt_y;    
elseif (component == 3)
    v_filt_x_B_filt_z = v_x_filt.*By_filt - v_y_filt.*Bx_filt;
    J_filt_x_B_filt_z = Jx_filt.*By_filt - Jy_filt.*Bx_filt;
    J_filt_x_B_filt_z = (mre/me)*J_filt_x_B_filt_z;
end


if (component == 1)
    v_filt_J_filt_xx = v_x_filt.*Jx_filt;
    v_filt_J_filt_yx = v_y_filt.*Jx_filt;
    v_filt_J_filt_zx = v_z_filt.*Jx_filt;
    J_filt_v_filt_xx = Jx_filt.*v_x_filt;
    J_filt_v_filt_yx = Jy_filt.*v_x_filt;
    J_filt_v_filt_zx = Jz_filt.*v_x_filt;
    J_filt_J_filt_2n_xx = Jx_filt.*Jx_filt./(n_filt);
    J_filt_J_filt_2n_xy = Jx_filt.*Jy_filt./(n_filt);
    J_filt_J_filt_2n_xz = Jx_filt.*Jz_filt./(n_filt);
elseif (component == 2)
    v_filt_J_filt_xy = v_x_filt.*Jy_filt;
    v_filt_J_filt_yy = v_y_filt.*Jy_filt;
    v_filt_J_filt_zy = v_z_filt.*Jy_filt;
    J_filt_v_filt_xy = Jx_filt.*v_y_filt;
    J_filt_v_filt_yy = Jy_filt.*v_y_filt;
    J_filt_v_filt_zy = Jz_filt.*v_y_filt;
    J_filt_J_filt_2n_xy = Jx_filt.*Jy_filt./(n_filt);
    J_filt_J_filt_2n_yy = Jy_filt.*Jy_filt./(n_filt);
    J_filt_J_filt_2n_yz = Jy_filt.*Jz_filt./(n_filt);
elseif (component == 3)
    v_filt_J_filt_xz = v_x_filt.*Jz_filt;
    v_filt_J_filt_yz = v_y_filt.*Jz_filt;
    v_filt_J_filt_zz = v_z_filt.*Jz_filt;
    J_filt_v_filt_xz = Jx_filt.*v_z_filt;
    J_filt_v_filt_yz = Jy_filt.*v_z_filt;
    J_filt_v_filt_zz = Jz_filt.*v_z_filt;
    J_filt_J_filt_2n_xz = Jx_filt.*Jz_filt./(n_filt);
    J_filt_J_filt_2n_yz = Jy_filt.*Jz_filt./(n_filt);
    J_filt_J_filt_2n_zz = Jz_filt.*Jz_filt./(n_filt);
end




%----------------------------------------------------------------------


%----------------------------------------------------------------------
Pe_filt = n_filt * Te0;
%----------------------------------------------------------------------
[Pe_filt_y, Pe_filt_x, Pe_filt_z] = gradient(Pe_filt);
%----------------------------------------------------------------------

if (component == 1)
    Div_Pe_filt_x = Pe_filt_x/(grad_fact.*resx);
elseif (component == 2)
    Div_Pe_filt_y = Pe_filt_y/(grad_fact.*resy);
elseif (component == 3)
    Div_Pe_filt_z = Pe_filt_z/(grad_fact.*resz);
end
clearvars Pe_filt_*
%----------------------------------------------------------------------

if(pressure_on == 1)
    %----------------------------------------------------------------------
    [Pij_ixx_filt_y, Pij_ixx_filt_x, Pij_ixx_filt_z] = gradient(Pij_ixx_filt);
    [Pij_iyy_filt_y, Pij_iyy_filt_x, Pij_iyy_filt_z] = gradient(Pij_iyy_filt);
    [Pij_izz_filt_y, Pij_izz_filt_x, Pij_izz_filt_z] = gradient(Pij_izz_filt);
    [Pij_ixy_filt_y, Pij_ixy_filt_x, Pij_ixy_filt_z] = gradient(Pij_ixy_filt);
    [Pij_ixz_filt_y, Pij_ixz_filt_x, Pij_ixz_filt_z] = gradient(Pij_ixz_filt);
    [Pij_iyz_filt_y, Pij_iyz_filt_x, Pij_iyz_filt_z] = gradient(Pij_iyz_filt);
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    if (component == 1)
        Div_Pi_filt_x = Pij_ixx_filt_x/(grad_fact.*resx) + Pij_ixy_filt_y/(grad_fact.*resy) + Pij_ixz_filt_z/(grad_fact.*resz);
    elseif (component == 2)
        Div_Pi_filt_y = Pij_ixy_filt_x/(grad_fact.*resx) + Pij_iyy_filt_y/(grad_fact.*resy) + Pij_iyz_filt_z/(grad_fact.*resz);
    elseif (component == 3)
        Div_Pi_filt_z = Pij_ixz_filt_x/(grad_fact.*resx) + Pij_iyz_filt_y/(grad_fact.*resy) + Pij_izz_filt_z/(grad_fact.*resz);
    end
    clearvars Pij_ixx_filt_* Pij_ixy_filt_* Pij_ixz_filt_* ...
        Pij_iyy_filt_* Pij_iyz_filt_* Pij_izz_filt_* ...
        %----------------------------------------------------------------------
end

%----------------------------------------------------------------------
% This is the correction of the div Pe
%----------------------------------------------------------------------
% if (component == 1)
%         Div_Pe_filt_x = (mre/me)*Div_Pe_filt_x - (mre/mi)*Div_Pi_filt_x ;
%     elseif (component == 2)
%         Div_Pe_filt_y = (mre/me)*Div_Pe_filt_y - (mre/mi)*Div_Pi_filt_y ;
%     elseif (component == 3)
%         Div_Pe_filt_z = (mre/me)*Div_Pe_filt_z - (mre/mi)*Div_Pi_filt_z ;
% end
if (component == 1)
        Div_Pe_filt_x = (mre/me)*Div_Pe_filt_x ;
    elseif (component == 2)
        Div_Pe_filt_y = (mre/me)*Div_Pe_filt_y ;
    elseif (component == 3)
        Div_Pe_filt_z = (mre/me)*Div_Pe_filt_z ;
end
%----------------------------------------------------------------------


%----------------------------------------------------------------------
if (component == 1)
    [v_filt_J_filt_xx_y, v_filt_J_filt_xx_x, v_filt_J_filt_xx_z] = gradient(v_filt_J_filt_xx);
    [v_filt_J_filt_yx_y, v_filt_J_filt_yx_x, v_filt_J_filt_yx_z] = gradient(v_filt_J_filt_yx);
    [v_filt_J_filt_zx_y, v_filt_J_filt_zx_x, v_filt_J_filt_zx_z] = gradient(v_filt_J_filt_zx);
    Div_vJ_filt_x = v_filt_J_filt_xx_x/(grad_fact.*resx) + v_filt_J_filt_yx_y/(grad_fact.*resy) + v_filt_J_filt_zx_z/(grad_fact.*resz);
elseif (component == 2)
    [v_filt_J_filt_xy_y, v_filt_J_filt_xy_x, v_filt_J_filt_xy_z] = gradient(v_filt_J_filt_xy);
    [v_filt_J_filt_yy_y, v_filt_J_filt_yy_x, v_filt_J_filt_yy_z] = gradient(v_filt_J_filt_yy);
    [v_filt_J_filt_zy_y, v_filt_J_filt_zy_x, v_filt_J_filt_zy_z] = gradient(v_filt_J_filt_zy);
    Div_vJ_filt_y = v_filt_J_filt_xy_x/(grad_fact.*resx) + v_filt_J_filt_yy_y/(grad_fact.*resy) + v_filt_J_filt_zy_z/(grad_fact.*resz);
elseif (component == 3)
    [v_filt_J_filt_xz_y, v_filt_J_filt_xz_x, v_filt_J_filt_xz_z] = gradient(v_filt_J_filt_xz);
    [v_filt_J_filt_yz_y, v_filt_J_filt_yz_x, v_filt_J_filt_yz_z] = gradient(v_filt_J_filt_yz);
    [v_filt_J_filt_zz_y, v_filt_J_filt_zz_x, v_filt_J_filt_zz_z] = gradient(v_filt_J_filt_zz);
    Div_vJ_filt_z = v_filt_J_filt_xz_x/(grad_fact.*resx) + v_filt_J_filt_yz_y/(grad_fact.*resy) + v_filt_J_filt_zz_z/(grad_fact.*resz);
end

clearvars v_filt_J_filt_xx_* v_filt_J_filt_xy_* v_filt_J_filt_xz_* ...
    v_filt_J_filt_yx_* v_filt_J_filt_yy_* v_filt_J_filt_yz_* ...
    v_filt_J_filt_zx_* v_filt_J_filt_zy_* v_filt_J_filt_zz_*
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    [J_filt_v_filt_xx_y, J_filt_v_filt_xx_x, J_filt_v_filt_xx_z] = gradient(J_filt_v_filt_xx);
    [J_filt_v_filt_yx_y, J_filt_v_filt_yx_x, J_filt_v_filt_yx_z] = gradient(J_filt_v_filt_yx);
    [J_filt_v_filt_zx_y, J_filt_v_filt_zx_x, J_filt_v_filt_zx_z] = gradient(J_filt_v_filt_zx);
    Div_Jv_filt_x = J_filt_v_filt_xx_x/(grad_fact.*resx) + J_filt_v_filt_yx_y/(grad_fact.*resy) + J_filt_v_filt_zx_z/(grad_fact.*resz);
elseif (component == 2)
    [J_filt_v_filt_xy_y, J_filt_v_filt_xy_x, J_filt_v_filt_xy_z] = gradient(J_filt_v_filt_xy);
    [J_filt_v_filt_yy_y, J_filt_v_filt_yy_x, J_filt_v_filt_yy_z] = gradient(J_filt_v_filt_yy);
    [J_filt_v_filt_zy_y, J_filt_v_filt_zy_x, J_filt_v_filt_zy_z] = gradient(J_filt_v_filt_zy);
    Div_Jv_filt_y = J_filt_v_filt_xy_x/(grad_fact.*resx) + J_filt_v_filt_yy_y/(grad_fact.*resy) + J_filt_v_filt_zy_z/(grad_fact.*resz);
elseif (component == 3)
    [J_filt_v_filt_xz_y, J_filt_v_filt_xz_x, J_filt_v_filt_xz_z] = gradient(J_filt_v_filt_xz);
[J_filt_v_filt_yz_y, J_filt_v_filt_yz_x, J_filt_v_filt_yz_z] = gradient(J_filt_v_filt_yz);
[J_filt_v_filt_zz_y, J_filt_v_filt_zz_x, J_filt_v_filt_zz_z] = gradient(J_filt_v_filt_zz);
    Div_Jv_filt_z = J_filt_v_filt_xz_x/(grad_fact.*resx) + J_filt_v_filt_yz_y/(grad_fact.*resy) + J_filt_v_filt_zz_z/(grad_fact.*resz);
end

clearvars J_filt_v_filt_xx_* J_filt_v_filt_xy_* J_filt_v_filt_xz_* ...
    J_filt_v_filt_yx_* J_filt_v_filt_yy_* J_filt_v_filt_yz_* ...
    J_filt_v_filt_zx_* J_filt_v_filt_zy_* J_filt_v_filt_zz_*
%----------------------------------------------------------------------


%----------------------------------------------------------------------
if (component == 1)
    [J_filt_J_filt_xx_y, J_filt_J_filt_xx_x, J_filt_J_filt_xx_z] = gradient(J_filt_J_filt_2n_xx);
[J_filt_J_filt_xy_y, J_filt_J_filt_xy_x, J_filt_J_filt_xy_z] = gradient(J_filt_J_filt_2n_xy);
[J_filt_J_filt_xz_y, J_filt_J_filt_xz_x, J_filt_J_filt_xz_z] = gradient(J_filt_J_filt_2n_xz);
    Div_JJ_filt_2n_x = J_filt_J_filt_xx_x/(grad_fact.*resx) + J_filt_J_filt_xy_y/(grad_fact.*resy) + J_filt_J_filt_xz_z/(grad_fact.*resz);
elseif (component == 2)
    [J_filt_J_filt_xy_y, J_filt_J_filt_xy_x, J_filt_J_filt_xy_z] = gradient(J_filt_J_filt_2n_xy);
    [J_filt_J_filt_yy_y, J_filt_J_filt_yy_x, J_filt_J_filt_yy_z] = gradient(J_filt_J_filt_2n_yy);
    [J_filt_J_filt_yz_y, J_filt_J_filt_yz_x, J_filt_J_filt_yz_z] = gradient(J_filt_J_filt_2n_yz);
    Div_JJ_filt_2n_y = J_filt_J_filt_xy_x/(grad_fact.*resx) + J_filt_J_filt_yy_y/(grad_fact.*resy) + J_filt_J_filt_yz_z/(grad_fact.*resz);
elseif (component == 3)
    [J_filt_J_filt_xz_y, J_filt_J_filt_xz_x, J_filt_J_filt_xz_z] = gradient(J_filt_J_filt_2n_xz);
    [J_filt_J_filt_yz_y, J_filt_J_filt_yz_x, J_filt_J_filt_yz_z] = gradient(J_filt_J_filt_2n_yz);
    [J_filt_J_filt_zz_y, J_filt_J_filt_zz_x, J_filt_J_filt_zz_z] = gradient(J_filt_J_filt_2n_zz);
    Div_JJ_filt_2n_z = J_filt_J_filt_xz_x/(grad_fact.*resx) + J_filt_J_filt_yz_y/(grad_fact.*resy) + J_filt_J_filt_zz_z/(grad_fact.*resz);
end

clearvars J_filt_J_filt_xx_* J_filt_J_filt_xy_* J_filt_J_dt_xz_* ...
    J_filt_J_dt_yy_* J_filt_J_dt_yz_* J_filt_J_dt_zz_*
%----------------------------------------------------------------------

%----------------------------------------------------------------------
clearvars v_filt_J_filt_* J_filt_v_filt_* J_filt_J_filt_*
%----------------------------------------------------------------------

%%% Normalization values
%----------------------------------------------------------------------
B_mod_dt = sqrt(Bx_dt.^2 + By_dt.^2 + Bz_dt.^2);
B0 = mean(B_mod_dt,'all');

clearvars B_mod_dt

n0 = mean(n_0_dt,'all');
mu0 = 1;
v_a = B0./sqrt(mu0 * n0);
c = v_a;

%----------------------------------------------------------------------


%%%  Now let's compute the tensors
% % %----------------------------------------------------------------------
%----------------------------------------------------------------------

if (component == 1)
[sub_tau1_xx_y, sub_tau1_xx_x, sub_tau1_xx_z] = gradient(sub_tau1_xx);
[sub_tau1_yx_y, sub_tau1_yx_x, sub_tau1_yx_z] = gradient(sub_tau1_yx);
[sub_tau1_zx_y, sub_tau1_zx_x, sub_tau1_zx_z] = gradient(sub_tau1_zx);
elseif (component == 2)
[sub_tau1_xy_y, sub_tau1_xy_x, sub_tau1_xy_z] = gradient(sub_tau1_xy);
[sub_tau1_yy_y, sub_tau1_yy_x, sub_tau1_yy_z] = gradient(sub_tau1_yy);
[sub_tau1_zy_y, sub_tau1_zy_x, sub_tau1_zy_z] = gradient(sub_tau1_zy);
elseif (component == 3)
[sub_tau1_xz_y, sub_tau1_xz_x, sub_tau1_xz_z] = gradient(sub_tau1_xz);
[sub_tau1_yz_y, sub_tau1_yz_x, sub_tau1_yz_z] = gradient(sub_tau1_yz);
[sub_tau1_zz_y, sub_tau1_zz_x, sub_tau1_zz_z] = gradient(sub_tau1_zz);
end
%----------------------------------------------------------------------

%----------------------------------------------------------------------
if (component == 1)
    %(<nE> - <n><E>)/<n>
    % % %----------------------------------------------------------------------
    tau_nE_tau = (B0*c)^(1)*((Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,n_0_dt.*Ex_dt))./n_filt - Ex_filt);
    %%nEx_filt = (B0*c)^(1)*Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,n_0_dt.*Ex_dt);
    %(<nevxB> - <n><v>x<B>)/<ne>
    % % %----------------------------------------------------------------------
    tau_v_x_B_tau = (B0*c)^(1)*((Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,n_0_dt.*v_x_B_x_dt))./n_filt - v_filt_x_B_filt_x);
    %%v_x_B_filt_x = (B0*c)^(1)*(Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,n_0_dt.*v_x_B_x_dt));
    %(<nevxB> - <n><J>x<B>)/<ne>
    %----------------------------------------------------------------------
    tau_J_x_B_tau = (mre/me)*(B0*c)^(1)*((Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,J_x_B_x_dt) - J_filt_x_B_filt_x)./n_filt);
    %----------------------------------------------------------------------
    Div_sub_tau1 = sub_tau1_xx_x/(grad_fact.*resx) + sub_tau1_yx_y/(grad_fact.*resy) + sub_tau1_zx_z/(grad_fact.*resz);
    %----------------------------------------------------------------------
    tau_Div_tau1 = mre*c*c*(1.*(Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,Div_sub_tau1) - (Div_vJ_filt_x + Div_Jv_filt_x - Div_JJ_filt_2n_x))./n_filt);
    % % %----------------------------------------------------------------------
elseif (component == 2)
    % % %----------------------------------------------------------------------
    tau_nE_tau = (B0*c)^(1)*((Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,n_0_dt.*Ey_dt))./n_filt - Ey_filt);
    %%nEy_filt = (B0*c)^(1)*Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,n_0_dt.*Ey_dt);
    % % %----------------------------------------------------------------------
    tau_v_x_B_tau = (B0*c)^(1)*((Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,n_0_dt.*v_x_B_y_dt))./n_filt - v_filt_x_B_filt_y);
    %%v_x_B_filt_y = (B0*c)^(1)*(Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,n_0_dt.*v_x_B_y_dt));
    % % %----------------------------------------------------------------------
    tau_J_x_B_tau = (mre/me)*(B0*c)^(1)*((Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,J_x_B_y_dt) - J_filt_x_B_filt_y)./n_filt);
    % % %----------------------------------------------------------------------
    Div_sub_tau1 = sub_tau1_xy_x/(grad_fact.*resx) + sub_tau1_yy_y/(grad_fact.*resy) + sub_tau1_zy_z/(grad_fact.*resz);
    % % %----------------------------------------------------------------------
    tau_Div_tau1 = mre*c*c*(1.*(Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,Div_sub_tau1) - (Div_vJ_filt_y + Div_Jv_filt_y - Div_JJ_filt_2n_y))./n_filt);
elseif (component == 3)
    % % %----------------------------------------------------------------------
    tau_nE_tau = (B0*c)^(1)*((Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,n_0_dt.*Ez_dt))./n_filt - Ez_filt);
    %%nEz_filt = (B0*c)^(1)*Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,n_0_dt.*Ez_dt);
    % % %----------------------------------------------------------------------
    tau_v_x_B_tau = (B0*c)^(1)*((Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,n_0_dt.*v_x_B_z_dt))./n_filt - v_filt_x_B_filt_z);
    %%v_x_B_filt_z = (B0*c)^(1)*(Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,n_0_dt.*v_x_B_z_dt));
    % % %----------------------------------------------------------------------
    tau_J_x_B_tau = (mre/me)*(B0*c)^(1)*((Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,J_x_B_z_dt) - J_filt_x_B_filt_z)./n_filt);
    % % %----------------------------------------------------------------------
    Div_sub_tau1 = sub_tau1_xz_x/(grad_fact.*resx) + sub_tau1_yz_y/(grad_fact.*resy) + sub_tau1_zz_z/(grad_fact.*resz);
    %----------------------------------------------------------------------
    tau_Div_tau1 = mre*c*c*(1.*(Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,Div_sub_tau1) - (Div_vJ_filt_z + Div_Jv_filt_z - Div_JJ_filt_2n_z))./n_filt);
    %----------------------------------------------------------------------
end

clearvars sub_*

%%% clear variables to release space
%----------------------------------------------------------------------
%clearvars Div* E* J* v_* Pij* sub*
%----------------------------------------------------------------------

%%% Select the components to plot

%%% ----------------------------------------------------------------------
%ext_fact = sqrt(1/mime);

% % % % This is to estimate the three term in the Ohm's law. for the plots 111
% % % % and 222
% % % %--------------------------------------------------------------------------
% % % if (component == 1)
% % % v_x_B_x_dt = v_y_dt.*Bz_dt - v_z_dt.*By_dt;
% % % J_x_B_x_dt = Jy_dt.*Bz_dt - Jz_dt.*By_dt;
% % % %Div_Pe_dt_x = Pe_dt_x/(grad_fact.*resx);
% % % v_x_B_x_filt = v_y_filt.*Bz_filt - v_z_filt.*By_filt;
% % % J_x_B_x_filt = Jy_filt.*Bz_filt - Jz_filt.*By_filt;
% % % %Div_Pe_filt_x = Pe_filt_x/(grad_fact.*resx);
% % % elseif (component == 2)
% % % v_x_B_y_dt = v_z_dt.*Bx_dt - v_x_dt.*Bz_dt;
% % % J_x_B_y_dt = Jz_dt.*Bx_dt - Jx_dt.*Bz_dt;
% % % %Div_Pe_dt_y = Pe_dt_y/(grad_fact.*resy);
% % % v_x_B_y_filt = v_z_dt.*Bx_filt - v_x_filt.*Bz_filt;
% % % J_x_B_y_filt = Jz_dt.*Bx_filt - Jx_filt.*Bz_filt;
% % % %Div_Pe_filt_y = Pe_filt_y/(grad_fact.*resy);
% % % elseif (component == 3)
% % % v_x_B_z_dt = v_x_dt.*By_dt - v_y_dt.*Bx_dt;
% % % J_x_B_z_dt = Jx_dt.*By_dt - Jy_dt.*Bx_dt;
% % % %Div_Pe_dt_z = Pe_dt_z/(grad_fact.*resz);
% % % v_x_B_z_filt = v_x_filt.*By_filt - v_y_filt.*Bx_filt;
% % % J_x_B_z_filt = Jx_filt.*By_filt - Jy_filt.*Bx_filt;
% % % %Div_Pe_filt_z = Pe_filt_z/(grad_fact.*resz);
% % % end
% % % clearvars Pe_dt_*
% % % clearvars Pe_filt_*
% % % %--------------------------------------------------------------------------

% Inertia correction
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------


%----------------------------------------------------------------------
% terms from the owns law with no signs
%----------------------------------------------------------------------
if (component == 1)
term1_dt = B0*v_a*(Ex_dt);
term2_dt = B0*v_a*(v_x_B_x_dt);
term3_dt = (mre/me)*B0*v_a*J_x_B_x_dt./n_0_dt;
term4_dt = v_a*v_a*((Div_Pe_dt_x./n_0_dt)); 
term5_dt = mre*v_a*v_a*((Div_vJ_dt_x + Div_Jv_dt_x - Div_JJ_dt_x)./n_0_dt);
term6_dt = mre*v_a*v_a*L2Ex_dt./n_0_dt;
%----------------------------------------------------------------------
% This is for the filtered quantities
%----------------------------------------------------------------------
term1_filt = B0*v_a*(Ex_filt);
term2_filt = B0*v_a*(v_filt_x_B_filt_x);
term3_filt = (mre/me)*B0*v_a*J_filt_x_B_filt_x./n_filt;
term4_filt = v_a*v_a*(Div_Pe_filt_x./n_filt);
term5_filt = me*v_a*v_a*((Div_vJ_filt_x + Div_Jv_filt_x - Div_JJ_filt_2n_x)./n_filt);
term6_filt = mre*v_a*v_a*L2Ex_filt./n_filt;
elseif (component == 2)
term1_dt = B0*v_a*(Ey_dt);
term2_dt = B0*v_a*(v_x_B_y_dt);
term3_dt = (mre/me)*B0*v_a*J_x_B_y_dt./n_0_dt;
term4_dt = v_a*v_a*(Div_Pe_dt_y./n_0_dt); 
term5_dt = mre*v_a*v_a*((Div_vJ_dt_y + Div_Jv_dt_y - Div_JJ_dt_y)./n_0_dt);
term6_dt = mre*v_a*v_a*L2Ey_dt./n_0_dt;
%----------------------------------------------------------------------
% This is for the filtered quantities
%----------------------------------------------------------------------
term1_filt = B0*v_a*(Ey_filt);
term2_filt = B0*v_a*(v_filt_x_B_filt_y);
term3_filt = (mre/me)*B0*v_a*J_filt_x_B_filt_y./n_filt;
term4_filt = v_a*v_a*(Div_Pe_filt_y./n_filt);
term5_filt = mre*v_a*v_a*((Div_vJ_filt_y + Div_Jv_filt_y - Div_JJ_filt_2n_y)./n_filt);
term6_filt = mre*v_a*v_a*L2Ey_filt./n_filt;
elseif (component ==3)
term1_dt = B0*v_a*(Ez_dt);
term2_dt = B0*v_a*(v_x_B_z_dt);
term3_dt = (mre/me)*B0*v_a*J_x_B_z_dt./n_0_dt;
term4_dt = v_a*v_a*(Div_Pe_dt_z./n_0_dt); 
term5_dt = mre*v_a*v_a*((Div_vJ_dt_z + Div_Jv_dt_z - Div_JJ_dt_z)./n_0_dt);
term6_dt = mre*v_a*v_a*L2Ez_dt./n_0_dt;
%----------------------------------------------------------------------
% This is for the filtered quantities
%----------------------------------------------------------------------
term1_filt = B0*v_a*(Ez_filt);
term2_filt = B0*v_a*(v_filt_x_B_filt_z);
term3_filt = (mre/me)*B0*v_a*J_filt_x_B_filt_z./n_filt;
term4_filt = v_a*v_a*(Div_Pe_filt_z./n_filt);
term5_filt = mre*v_a*v_a*((Div_vJ_filt_z + Div_Jv_filt_z - Div_JJ_filt_2n_z)./n_filt);
term6_filt = mre*v_a*v_a*L2Ez_filt./n_filt;
end 

% % %%----------------------------------------------------------------------
% % if (component == 1)
% % term1_dt = term1_dt_x ;
% % term2_dt = term2_dt_x ;
% % term3_dt = term3_dt_x ;
% % term4_dt = term4_dt_x ;
% % term5_dt = term5_dt_x ;
% % clearvars term1_dt_x term2_dt_x term3_dt_x term4_dt_x term5_dt_x
% % term1_filt = term1_filt_x ;
% % term2_filt = term2_filt_x ;
% % term3_filt = term3_filt_x ;
% % term4_filt = term4_filt_x ;
% % term5_filt = term5_filt_x ;
% % clearvars term1_filt_x term2_filt_x term3_filt_x term4_filt_x term5_filt_x
% % elseif (component == 2)
% % term1_dt = term1_dt_y ;
% % term2_dt = term2_dt_y ;
% % term3_dt = term3_dt_y ;
% % term4_dt = term4_dt_y ;
% % term5_dt = term5_dt_y ;
% % clearvars term1_dt_y term2_dt_y term3_dt_y term4_dt_y term5_dt_y
% % term1_filt = term1_filt_y ;
% % term2_filt = term2_filt_y ;
% % term3_filt = term3_filt_y ;
% % term4_filt = term4_filt_y ;
% % term5_filt = term5_filt_y ;
% % clearvars term1_filt_y term2_filt_y term3_filt_y term4_filt_y term5_filt_y
% % elseif (component == 3) 
% % term1_dt = term1_dt_z ;
% % term2_dt = term2_dt_z ;
% % term3_dt = term3_dt_z ;
% % term4_dt = term4_dt_z ;
% % term5_dt = term5_dt_z ;
% % clearvars term1_dt_z term2_dt_z term3_dt_z term4_dt_z term5_dt_z
% % term1_filt = term1_filt_z ;
% % term2_filt = term2_filt_z ;
% % term3_filt = term3_filt_z ;
% % term4_filt = term4_filt_z ;
% % term5_filt = term5_filt_z ;
% % clearvars term1_filt_z term2_filt_z term3_filt_z term4_filt_z term5_filt_z
% % end
% % %----------------------------------------------------------------------




% % % % This is to check the downsamplig selection to check the dependence
% % % %-------------------------------------------------------------------------
% % % down_sample_rate = 32;
% % % nbins = 80;
% % % 
% % % % The tau_vxB has been divided already by the density.
% % % %--------------------------------------------------------------------------
% % % % this is to text the difference with a random sampling
% % % %--------------------------------------------------------------------------
% % % J_scatter_x = downsample(Jx_filt(:),down_sample_rate); %J_scatter_x = J_scatter_x/max(abs(J_scatter_x));
% % % var_tau1_x = downsample(tau_v_x_B_tau(:),down_sample_rate); %var_tau1_x = var_tau1_x/max(abs(var_tau1_x));
% % % 
% % % 
% % % num_elements = numel(Jx_filt);
% % % % How many to randomly sample
% % % AN = 250*250*8;
% % % % Generate random linear indices
% % % rand_inds = randperm(num_elements, AN);
% % % % Get values
% % % J_scatter_x2 = Jx_filt(rand_inds);
% % % var_tau1_x2 = tau_v_x_B_tau(rand_inds);
% % % 
% % % %--------------------------------------------------------------------------
% % % % This is to put the histograms on the side
% % % % This par of plots also show how the sampling is different, the first one
% % % % takes several structures that are contigues,
% % % %-----------------------------------------------------------------------
% % % f1=figure(1);
% % % subplot(1,2,1)
% % % s = scatterhistogram(J_scatter_x,var_tau1_x,'NumBins',nbins,'MarkerStyle','.');
% % % s.YLabel = '\tau_{nu \times B}';
% % % s.MarkerSize = 0.5;
% % % s.HistogramDisplayStyle = 'bar';
% % % 
% % % subplot(1,2,2)
% % % s = scatterhistogram(J_scatter_x2,var_tau1_x2,'NumBins',nbins,'MarkerStyle','.');
% % % s.YLabel = '\tau_{nu \times B}';
% % % s.MarkerSize = 0.5;
% % % s.HistogramDisplayStyle = 'bar';
% % % %-----------------------------------------------------------------------
% % % 
% % % %meany = accumarray(loc(:),yy(:))./accumarray(loc(:),1);
% % % %-----------------------------------------------------------------------
% % % 
% % % 
% % % 
% % % 
% % % fs=15; x0=45;y0=54;xx1=1000;yy1=400;
% % % f253=figure(253);
% % % set(gcf,'position',[x0,y0,xx1,yy1])
% % % %-----------------------------------------------------------------------
% % % %subplot(2,3,1)
% % % xx=J_scatter_x;
% % % yy=var_tau1_x;
% % % [~,edges,loc] = histcounts(xx,nbins);
% % % meany = accumarray(loc(:),yy(:),[],@mean);
% % % mediany = accumarray(loc(:),yy(:),[],@median);
% % % xmid = 0.5*(edges(1:end-1)+edges(2:end));
% % % P = polyfit(xx,yy,1); yfit = P(1)*xx+P(2);
% % % P1 = polyfit(xmid,meany,1); yfit_meany = P1(1)*xx+P1(2);
% % % P2 = polyfit(xmid,mediany,1); yfit_mediany = P2(1)*xx+P2(2);
% % % scatter(xx,yy,'.')
% % % hold on;
% % % plot(xmid,meany,'xr','LineWidth',2);
% % % plot(xx,yfit_meany,'k--','LineWidth',2);
% % % set(gca,'FontSize',fs)
% % % ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% % % ylabel('$\tau_{nu \times B}$','Interpreter','latex')
% % % bb = sprintf('avg,b = %.2g ', P(1));
% % % title(bb,'Interpreter','Latex')
% % % xlabel('$J$')
% % % xlim([-1 1]); ylim([-1 1]); 
% % % hold off
% % % %-----------------------------------------------------------------------

%--------------------------------------------------------------------------


%-------------------------------------------------------------------------


% This is for the colors
%--------------------------------------------------------------------------
% Reddish Purple	(204, 121, 167) 
% Blue	(0, 114, 178) 
% Grey	(128, 128, 128) 
% Vermillion	(213, 94, 0) 
% Orange	(230, 159, 0) 
% Black	(0, 0, 0) 
% Bluish Green	(0, 158, 115) 
% Yellow	(240, 228, 66) 

My_colors = [ 204, 121, 167; 
0, 114, 178; 
128, 128, 128
213, 94, 0; 
230, 159, 0; 
0, 0, 0;
86, 180, 233; 
0, 158, 115; 
]/256; 

% x=linspace(1,100,2000); 
% f1=figure(1); 
% y=(x).^2; 
% plot(x,y,color=My_colors(1,:),LineWidth=2) 
% hold on 
% for i=2:length(My_colors) 
% y=(i*x).^2; 
% plot(x,y,color=My_colors(i,:),LineWidth=2) 
% end 
% hold off 

%--------------------------------------------------------------------------


%----------------------------------------------------------------------
% plot of the component x of the electric field
%----------------------------------------------------------------------
%
fs=15; x0=45;y0=54;xx1=1200;yy1=500;

%if(pressure_on == 1)
%legends_x = {'$E$', '$-u \times B$','$\frac{J \times B}{ne}$',...
%    '$-\frac{\nabla \cdot P_{e}}{ne}$','$\frac{m_{e}\nabla \cdot (uJ + Ju - JJ/ne)}{ne^{2}}$',...
%    '$RHS$'};
legends_x = {'$E$', '$-u \times B$','$m^{*}J \times B/n e m_{e}$',...
    '$-\frac{\nabla \cdot P}{ne}$',...
    '$\frac{m^{*}}{ne^{2}}\left(\nabla \cdot (uJ + Ju - JJ/ne) + \nabla^{2}\overline{E}/\mu_{0}\right)$',...
    '$RHS$'};
% else
%     legends_x = {'$E$', '$u \times B$','$\frac{J \times B}{ne}$',...
%         '$\frac{m_{e}\nabla \cdot (uJ + Ju - JJ/ne)}{ne^{2}}$',...
%         '$RHS$'};
% end

% Figure 1
%----------------------------------------------------------------------
i=50; j=50;
%
f1=figure(1)
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(1,2,1)
dum = term1_dt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-r',LineWidth=1.5)
hold on
dum = -term2_dt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-b',LineWidth=1.5)
dum = term3_dt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-g',LineWidth=1.5)
dum = -term4_dt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-m',LineWidth=1.5)
dum = term5_dt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-c',LineWidth=1.5)
dum = -term2_dt + term3_dt -term4_dt + term5_dt + term6_dt;
%dum = term2to5_dt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'--k',LineWidth=1.5)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$y/d_i$';
ax.YLabel.String = '$E_{x}$';
legend(legends_x ,'Interpreter','latex','NumColumns',1,'Location','southoutside')
title('Unfiltered','Interpreter','latex')
xlim([min(xl),max(xl)])
ylim([-0.6, 0.6]);
hold off

subplot(1,2,2)
dum = term1_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-r',LineWidth=1.5)
hold on
dum = -term2_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-b',LineWidth=1.5)
dum = term3_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-g',LineWidth=1.5)
dum = -term4_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-m',LineWidth=1.5)
dum = term5_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-c',LineWidth=1.5)
dum = -term2_filt + term3_filt -term4_filt + term5_filt + term6_filt;
%dum = term2to5_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'--k',LineWidth=1.5)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$y/d_i$';
ax.YLabel.String = '$\overline{E}_{x}$';
legend(legends_x ,'Interpreter','latex','NumColumns',1,'Location','southoutside')
title('Filtered','Interpreter','latex')
xlim([min(xl),max(xl)])
ylim([-0.6, 0.6]);
hold off
%}
%----------------------------------------------------------------------

% This is the BWR
%path_color = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
path_color = '/home/UNN/pfcy6/codes/processing_scripts/Matlab_Scripts_Laptop';

cd(path_color)

fs=15; x0=45;y0=54;xx1=1400;yy1=500;
%----------------------------------------------------------------------
i=50;j=50;
i=50;j=50;
%----------------------------------------------------------------------
f10=figure(10);
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(2,5,1)
%dum = LHD_x_dt;
dum = term1_dt;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
%title('LHS')
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; 
ax.XTick = []; 
%ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
xline(xl(1,j),'--k','LineWidth',1.5)
%title('$E_{x}$','Interpreter','latex')
pbaspect([1 1 1])
title('$E$','Interpreter','latex')
hold off

subplot(2,5,2)
dum = -term2_dt;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
%title('LHS')
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
%ax.XLabel.String = '$x/d_i$';
ax.XTick = [];
ax.YLabel.String = '$y/d_i$';
xline(xl(1,j),'--k','LineWidth',1.5)
%title('$E_{x}$','Interpreter','latex')
pbaspect([1 1 1])
title('$-u \times B$','Interpreter','latex')
hold off

subplot(2,5,3)
dum = term3_dt;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
%title('LHS')
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
%ax.XLabel.String = '$x/d_i$';
ax.XTick = [];
ax.YLabel.String = '$y/d_i$';
xline(xl(1,j),'--k','LineWidth',1.5)
%title('$E_{x}$','Interpreter','latex')
pbaspect([1 1 1])
%title('$J \times B/nq$','Interpreter','latex')
title('$m^{*}J \times B /n e m_{e}$','Interpreter','latex')
hold off

subplot(2,5,4)
dum = -term4_dt;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
%title('LHS')
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
%ax.XLabel.String = '$x/d_i$';
ax.XTick = [];
ax.YLabel.String = '$y/d_i$';
xline(xl(1,j),'--k','LineWidth',1.5)
%title('$E_{x}$','Interpreter','latex')
pbaspect([1 1 1])
%title('$-\nabla \cdot P_{e}/ne$','Interpreter','latex')
title('$-\nabla \cdot P/ne$','Interpreter','latex')
hold off

subplot(2,5,5)
dum = term5_dt + term6_dt;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
%title('LHS')
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
%ax.XLabel.String = '$x/d_i$';
ax.XTick = [];
ax.YLabel.String = '$y/d_i$';
xline(xl(1,j),'--k','LineWidth',1.5)
%title('$E_{x}$','Interpreter','latex')
pbaspect([1 1 1])
%title('$\nabla \cdot (uJ+Ju-JJ/ne)m_{e}/ne^{2}$','Interpreter','latex')
title('$\frac{m^{*}}{ne^{2}}\left(\nabla \cdot (uJ + Ju - JJ/ne) + \nabla^{2}E/\mu_{0}\right)$','Interpreter','latex')
hold off
%----------------------------------------------------------------------

%i=30;
%----------------------------------------------------------------------
%f10=figure(10);
subplot(2,5,6)
%dum = LHD_dt;
dum = term1_filt;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
%title('LHS')
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
xline(xl(1,j),'--k','LineWidth',1.5)
%title('$E_{x}$','Interpreter','latex')
pbaspect([1 1 1])
hold off

subplot(2,5,7)
%dum = RHD_x_dt;
dum = -term2_filt;
dump = squeeze(dum(:,:,i));
y_lim = max(max(max(abs(dump))));
hc=pcolor(xl,yl,dump);
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
%title('RHS')
%title('$-u \times B$','Interpreter','latex')
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
xline(xl(1,j),'--k','LineWidth',1.5)
pbaspect([1 1 1])
hold off

subplot(2,5,8)
dum = term3_filt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
xline(xl(1,j),'--k','LineWidth',1.5)
%title('$J \times B/nq$','Interpreter','latex')
pbaspect([1 1 1])
hold off

subplot(2,5,9)
dum = -term4_filt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
%if(pressure_on==1)
    clim([-y_lim y_lim]);
%end
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
xline(xl(1,j),'--k','LineWidth',1.5)
%title('$-\nabla \cdot P_{e}/nq$','Interpreter','latex')
pbaspect([1 1 1])
hold off

subplot(2,5,10)
dum = term5_filt + term6_filt;
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
xline(xl(1,j),'--k','LineWidth',1.5)
%title('$\nabla \cdot (uJ+Ju-JJ/qn)(m_{e}/q^{2}n)$','Interpreter','latex')
pbaspect([1 1 1])
hold off
sgtitle('$$ Unfiltered $$','Interpreter','latex','FontSize',fs)



cd(path_color)
fs=15; x0=45;y0=54;xx1=1400;yy1=500;
f345=figure(345)
dum = term1_dt -(-term2_dt + term3_dt - term4_dt + term5_dt + 0.*term6_dt);
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
xline(xl(1,j),'--k','LineWidth',1.5)
%title('$\nabla \cdot (uJ+Ju-JJ/qn)(m_{e}/q^{2}n)$','Interpreter','latex')
pbaspect([1 1 1])
hold off
sgtitle('$$ Unfiltered $$','Interpreter','latex','FontSize',fs)


%--------------------------------------------------------------------------
My_colors = [ 204, 121, 167; 
0, 114, 178; 
128, 128, 128
213, 94, 0; 
230, 159, 0; 
0, 0, 0;
86, 180, 233; 
0, 158, 115; 
]/256;
lwm=2;


% Plot for the magnitude instead of the x  component

term1_dt = sqrt(term1_dt_x.^2 + term1_dt_y.^2 + term1_dt_z.^2 );
term2_dt = sqrt(term2_dt_x.^2 + term2_dt_y.^2 + term2_dt_z.^2 );
term3_dt = sqrt(term3_dt_x.^2 + term3_dt_y.^2 + term3_dt_z.^2 );
term4_dt = sqrt(term4_dt_x.^2 + term4_dt_y.^2 + term4_dt_z.^2 );
term5_dt = sqrt(term5_dt_x.^2 + term5_dt_y.^2 + term5_dt_z.^2 );

term1_filt = sqrt(term1_filt_x.^2 + term1_filt_y.^2 + term1_filt_z.^2 );
term2_filt = sqrt(term2_filt_x.^2 + term2_filt_y.^2 + term2_filt_z.^2 );
term3_filt = sqrt(term3_filt_x.^2 + term3_filt_y.^2 + term3_filt_z.^2 );
term4_filt = sqrt(term4_filt_x.^2 + term4_filt_y.^2 + term4_filt_z.^2 );
term5_filt = sqrt(term5_filt_x.^2 + term5_filt_y.^2 + term5_filt_z.^2 );
term6_filt = sqrt(term6_filt_x.^2 + term6_filt_y.^2 + term6_filt_z.^2 );

tau_nE_tau = sqrt(tau_nE_tau_x.^2 + tau_nE_tau_y.^2 + tau_nE_tau_z.^2);
tau_v_x_B_tau = sqrt(tau_v_x_B_tau_x.^2 + tau_v_x_B_tau_y.^2 + tau_v_x_B_tau_z.^2);
tau_J_x_B_tau = sqrt(tau_J_x_B_tau_x.^2 + tau_J_x_B_tau_y.^2 + tau_J_x_B_tau_z.^2);
tau_Div_tau1 = sqrt(tau_Div_tau1_x.^2 + tau_Div_tau1_y.^2 + tau_Div_tau1_z.^2);

fs=15; x0=45;y0=54;xx1=1400;yy1=500;

%this is for the x-component
%--------------------------------------------------------------------------
f100=figure(100)
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(1,2,2)
dum = -tau_nE_tau_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-.',color=My_colors(1,:),LineWidth=lwm)
hold on
dum = -tau_v_x_B_tau_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-.',color=My_colors(2,:),LineWidth=lwm)
dum = tau_J_x_B_tau_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-.',color=My_colors(3,:),LineWidth=lwm)
dum = tau_Div_tau1_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-.',color=My_colors(5,:),LineWidth=lwm)
set(gca,'FontSize',fs)
dum = -tau_nE_tau_x -tau_v_x_B_tau_x + tau_J_x_B_tau_x + tau_Div_tau1_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-.',color=My_colors(6,:),LineWidth=lwm)
set(gca,'FontSize',fs)

ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$y/d_i$';
%ax.YLabel.String = '$E$';
% legend('$-\tau_{nE}$','$-\tau_{nu \times B}$', ...
%      '$\tau_{J \times B}$',...
%      '$\tau_{\nabla \cdot (uJ+Ju-JJ/ne)}$',...
%      '$\Sigma \tau$',...
%      'Interpreter','latex','NumColumns',1,'Location','southoutside')
%title('Unfilterd','Interpreter','latex')
xlim([min(xl),max(xl)])
%legend( '$\overline{E}$', '$-\overline{u} \times \overline{B}$',...
%    '$\frac{\overline{J} \times \overline{B}}{\overline{n}e}$',...
%    '$-\frac{\nabla \cdot \overline{P}_{e}}{\overline{n}e}$', ...
%    '$\frac{m_{e}\nabla \cdot (\overline{u}\overline{J} + \overline{J}\overline{u} - \overline{J}\overline{J}/ne)}{\overline{n}e^{2}}$',...
%    'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
%ylim([-0.045,0.045])
hold off

subplot(1,2,1)
dum = term1_filt_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-',color=My_colors(1,:),LineWidth=lwm)
hold on
dum = -term2_filt_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-',color=My_colors(2,:),LineWidth=lwm)
dum = term3_filt_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-',color=My_colors(3,:),LineWidth=lwm)
dum = -term4_filt_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-',color=My_colors(4,:),LineWidth=lwm)
dum = term5_filt_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-',color=My_colors(5,:),LineWidth=lwm)
sum_filt_x = - term2_filt_x + term3_filt_x - term4_filt_x + term5_filt_x + 0.*term6_filt_x;
dum = sum_filt_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-',color=My_colors(6,:),LineWidth=lwm)

dum = -tau_nE_tau_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-.',color=My_colors(1,:),LineWidth=lwm)
dum = -tau_v_x_B_tau_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-.',color=My_colors(2,:),LineWidth=lwm)
dum = tau_J_x_B_tau_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-.',color=My_colors(3,:),LineWidth=lwm)
dum = tau_Div_tau1_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-.',color=My_colors(5,:),LineWidth=lwm)
set(gca,'FontSize',fs)
dum = -tau_nE_tau_x -tau_v_x_B_tau_x + tau_J_x_B_tau_x + tau_Div_tau1_x;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-.',color=My_colors(6,:),LineWidth=lwm)
set(gca,'FontSize',fs)

ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$y/d_i$';
ax.YLabel.String = '$\mathbf{E}_{x}$';
xlim([min(xl),max(xl)])
%ylim([-0.6,0.3])
legend( '$\overline{\mathbf{E}}$', '$-\overline{\mathbf{E}}_{MHD}$',...
    '$\overline{\mathbf{E}}_{Hall}$',...
    '$-\overline{\mathbf{E}}_{Pe}$', ...
    '$\overline{\mathbf{E}}_{Ine}$',...
    '$\overline{\mathbf{E}}_{RHS}$',...
    '$-\mathbf{\tau}_{nE}$', ...
    '$-\tau_{nu \times B}$', ...
    '$\tau_{J \times B}$',...
    '$\tau_{Ine}$',...
    '$\Sigma \tau$',...
    'Interpreter','latex','NumColumns',1,'Location','southoutside')

% legend( '$\overline{E}$', '$-\overline{u} \times \overline{B}$',...
%     '$\frac{m^{*}\overline{J} \times \overline{B}}{m_{e}\overline{n}e}$',...
%     '$-\frac{\nabla \cdot \overline{P}}{\overline{n}e}$', ...
%     '$\frac{m^{*}[\nabla \cdot (\overline{u}\overline{J} + \overline{J}\overline{u} - \overline{J}\overline{J}/ne) + \nabla^{2}\overline{E}/\mu_{0}]}{\overline{n}e^{2}}$',...
%     '$\overline{RHS}$',...
%     '$-\tau_{nE}$','$-\tau_{nu \times B}$', ...
%     '$\tau_{J \times B}$',...
%     '$\tau_{\nabla \cdot(uJ+Ju-JJ/ne)}$',...
%     '$\Sigma \tau$',...
%     'Interpreter','latex','NumColumns',2,'Location','southoutside')
hold off

% This is for the amplitude
f101=figure(101)
set(gcf,'position',[x0,y0,xx1,yy1])
subplot(1,2,2)
dum = tau_nE_tau;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-.',color=My_colors(1,:),LineWidth=lwm)
hold on
dum = tau_v_x_B_tau;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-.',color=My_colors(2,:),LineWidth=lwm)
dum = tau_J_x_B_tau;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-.',color=My_colors(3,:),LineWidth=lwm)
dum = tau_Div_tau1;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-.',color=My_colors(5,:),LineWidth=lwm)
set(gca,'FontSize',fs)
dum = tau_nE_tau +tau_v_x_B_tau + tau_J_x_B_tau + tau_Div_tau1;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-.',color=My_colors(6,:),LineWidth=lwm)
set(gca,'FontSize',fs)

ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$y/d_i$';
%ax.YLabel.String = '$E$';
legend('$\tau_{nE}$','$\tau_{nu \times B}$', ...
     '$\tau_{J \times B}$',...
     '$\tau_{\nabla \cdot (uJ+Ju-JJ/ne)}$',...
     '$\Sigma \tau$',...
     'Interpreter','latex','NumColumns',1,'Location','southoutside')
%title('Unfilterd','Interpreter','latex')
xlim([min(xl),max(xl)])
%legend( '$\overline{E}$', '$-\overline{u} \times \overline{B}$',...
%    '$\frac{\overline{J} \times \overline{B}}{\overline{n}e}$',...
%    '$-\frac{\nabla \cdot \overline{P}_{e}}{\overline{n}e}$', ...
%    '$\frac{m_{e}\nabla \cdot (\overline{u}\overline{J} + \overline{J}\overline{u} - \overline{J}\overline{J}/ne)}{\overline{n}e^{2}}$',...
%    'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
%ylim([-0.045,0.045])
hold off

subplot(1,2,1)
dum = term1_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-',color=My_colors(1,:),LineWidth=lwm)
hold on
dum = term2_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-',color=My_colors(2,:),LineWidth=lwm)
dum = term3_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-',color=My_colors(3,:),LineWidth=lwm)
dum = term4_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-',color=My_colors(4,:),LineWidth=lwm)
dum = term5_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-',color=My_colors(5,:),LineWidth=lwm)
sum_filt = term2_filt + term3_filt + term4_filt + term5_filt + 0.*term6_filt;
dum = sum_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-',color=My_colors(6,:),LineWidth=lwm)

dum = tau_nE_tau;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-.',color=My_colors(1,:),LineWidth=lwm)
dum = tau_v_x_B_tau;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-.',color=My_colors(2,:),LineWidth=lwm)
dum = tau_J_x_B_tau;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-.',color=My_colors(3,:),LineWidth=lwm)
dum = tau_Div_tau1;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-.',color=My_colors(5,:),LineWidth=lwm)
set(gca,'FontSize',fs)
dum = tau_nE_tau + tau_v_x_B_tau + tau_J_x_B_tau + tau_Div_tau1;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-.',color=My_colors(6,:),LineWidth=lwm)
set(gca,'FontSize',fs)

ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$y/d_i$';
ax.YLabel.String = '$\overline{E}$';
xlim([min(xl),max(xl)])
%ylim([-0.6,0.3])
legend( '$\overline{\mathbf{E}}$', '$-\overline{\mathbf{E}}_{MHD}$',...
    '$\overline{\mathbf{E}}_{Hall}$',...
    '$-\overline{\mathbf{E}}_{Pe}$', ...
    '$\overline{\mathbf{E}}_{Ine}$',...
    '$\overline{\mathbf{E}}_{RHS}$',...
    '$-\tau_{nE}$','$-\tau_{nu \times B}$', ...
    '$\tau_{J \times B}$',...
    '$\tau_{\nabla \cdot(uJ+Ju-JJ/ne)}$',...
    '$\Sigma \tau$',...
    'Interpreter','latex','NumColumns',2,'Location','southoutside')
hold off
%-----------------------------------------------------------------------


fs=15; x0=45;y0=54;xx1=1200;yy1=250;
%----------------------------------------------------------------------
f12=figure(12);
set(gcf,'position',[x0,y0,1.0*xx1,1.0*yy1])
ax1=subplot(1,4,1);
dum = -tau_nE_tau/(10^(0));
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
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
title('$-\tau_{nE} $','Interpreter','latex')
hold off

ax2=subplot(1,4,2);
dum = -tau_v_x_B_tau/(10^(0));
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
xline(xl(1,j),'--k','LineWidth',1.5)
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(ax2,BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
%title('$m_{e} \nabla cdot \tau(vJ+Jv-JJ/nq))/n$','Interpreter','latex')
%xlim([-15.2 15.2]);
%ylim([-15.2 15.2]);
pbaspect([1 1 1])
title('$-\tau_{nu \times B} $','Interpreter','latex')
%xlim([-15.2 15.2]);
hold off

ax3=subplot(1,4,3);
dum = tau_J_x_B_tau/(10^(0));
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
xline(xl(1,j),'--k','LineWidth',1.5)
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(ax3,BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
%title('$m_{e} \nabla cdot \tau(vJ+Jv-JJ/nq))/n$','Interpreter','latex')
%xlim([-15.2 15.2]);
%ylim([-15.2 15.2]);
pbaspect([1 1 1])
title('$\tau_{J \times B} $','Interpreter','latex')
%xlim([-15.2 15.2]);
hold off

ax4=subplot(1,4,4);
dum = tau_Div_tau1/(10^(-2));
dump = squeeze(dum(:,:,i));
hc=pcolor(xl,yl,dump);
y_lim = max(max(max(abs(dump))));
hold on
set(hc,'edgecolor','none')
clim([-y_lim y_lim]);
xline(xl(1,j),'--k','LineWidth',1.5)
cb = colorbar; cb.TickLabelInterpreter = 'Latex';
colormap(ax4,BWR)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$x/d_i$';
ax.YLabel.String = '$y/d_i$';
%title('$m_{e} \nabla cdot \tau(vJ+Jv-JJ/nq))/n$','Interpreter','latex')
%xlim([-15.2 15.2]);
%ylim([-15.2 15.2]);
pbaspect([1 1 1])
title('$ \tau_{\nabla \cdot (uJ+Ju-JJ/ne)} \times 10^2$','Interpreter','latex')
%xlim([-15.2 15.2]);
hold off
%----------------------------------------------------------------------


xx = kx(1,1:128);
yy = xx.^(-5/3);
yy2 = xx.^(-5/3).*exp(-(xx*(8.*resx)).^2);
yy3 = xx.^(-8/3).*exp(-(xx.*(8.*resx)).^2);
yy4 = xx.^(-11/3).*exp(-(xx.*(8.*resx)).^2);

%yy3 = yy.*(1/(2.*pi.*(4.*resx)^2)).*exp(-(xx.*(4.*resx)).^2);
%yy4 = yy.*(1/(2.*pi.*(8.*resx)^2)).*exp(-(xx.*(8.*resx)).^2);

f34=figure(34);
loglog(xx,yy,'k')
hold on
loglog(xx,yy2,'b')
loglog(xx,yy3,'r')
loglog(xx,yy4,'m')
xline(2*pi/(2*resx),'--b');
xline(2*pi/(4*resx),'--r');
xline(2*pi/(8*resx),'--m');
ylim([1e-20 20])
xlim([kx(1,1) 40])
hold off

%------------------------------------------------------------------------

% % % ax5=subplot(2,4,5);
% % % dum = -tau_nE_tau/(10^(0));
% % % dump = squeeze(dum(:,:,i));
% % % y_lim = max(max(max(abs(dump))));
% % % hc=pcolor(xl,yl,dump);
% % % hold on
% % % set(hc,'edgecolor','none')
% % % clim([-y_lim y_lim]);
% % % xline(xl(1,j),'--k','LineWidth',1.5)
% % % cb = colorbar; cb.TickLabelInterpreter = 'Latex';
% % % colormap(ax5,BWR)
% % % set(gca,'FontSize',fs)
% % % ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% % % ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
% % % ax.XLabel.String = '$x/d_i$';
% % % ax.YLabel.String = '$y/d_i$';
% % % %title('$\tau(nE)/n$','Interpreter','latex')
% % % %xlim([-15.2 15.2]);
% % % %ylim([-15.2 15.2]);
% % % pbaspect([1 1 1])
% % % hold off
% % % 
% % % ax6 = subplot(2,4,6);
% % % dum = -tau_v_x_B_tau/(10^(0));
% % % dump = squeeze(dum(:,:,i));
% % % y_lim = max(max(max(abs(dump))));
% % % hc=pcolor(xl,yl,dump);
% % % hold on
% % % set(hc,'edgecolor','none')
% % % clim([-y_lim y_lim]);
% % % xline(xl(1,j),'--k','LineWidth',1.5)
% % % cb = colorbar; cb.TickLabelInterpreter = 'Latex';
% % % colormap(ax6,BWR)
% % % set(gca,'FontSize',fs)
% % % ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% % % ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
% % % ax.XLabel.String = '$x/d_i$';
% % % ax.YLabel.String = '$y/d_i$';
% % % %title('$\tau(vxB)/n$','Interpreter','latex')
% % % %xlim([-15.2 15.2]);
% % % %ylim([-15.2 15.2]);
% % % pbaspect([1 1 1])
% % % hold off
% % % 
% % % ax7 = subplot(2,4,7);
% % % dum = tau_J_x_B_tau/(10^(0));
% % % dump = squeeze(dum(:,:,i));
% % % hc=pcolor(xl,yl,dump);
% % % y_lim = max(max(max(abs(dump))));
% % % hold on
% % % set(hc,'edgecolor','none')
% % % clim([-y_lim y_lim]);
% % % xline(xl(1,j),'--k','LineWidth',1.5)
% % % cb = colorbar; cb.TickLabelInterpreter = 'Latex';
% % % colormap(ax7,BWR)
% % % set(gca,'FontSize',fs)
% % % ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% % % ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
% % % ax.XLabel.String = '$x/d_i$';
% % % ax.YLabel.String = '$y/d_i$';
% % % %title('$\tau(JxB)/n$','Interpreter','latex')
% % % %xlim([-15.2 15.2]);
% % % %ylim([-15.2 15.2]);
% % % pbaspect([1 1 1])
% % % hold off
% % % 
% % % ax8 = subplot(2,4,8);
% % % dum = tau_Div_tau1/(10^(-2));
% % % dump = squeeze(dum(:,:,i));
% % % hc=pcolor(xl,yl,dump);
% % % y_lim = max(max(max(abs(dump))));
% % % hold on
% % % set(hc,'edgecolor','none')
% % % clim([-y_lim y_lim]);
% % % xline(xl(1,j),'--k','LineWidth',1.5)
% % % cb = colorbar; cb.TickLabelInterpreter = 'Latex';
% % % colormap(ax8,BWR)
% % % set(gca,'FontSize',fs)
% % % ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% % % ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
% % % ax.XLabel.String = '$x/d_i$';
% % % ax.YLabel.String = '$y/d_i$';
% % % %title('$m_{e} \nabla cdot \tau(vJ+Jv-JJ/nq))/n$','Interpreter','latex')
% % % %xlim([-15.2 15.2]);
% % % %ylim([-15.2 15.2]);
% % % pbaspect([1 1 1])
% % % hold off

% cd('~/Downloads')
% saveas(f1,strcat(num2str(component),'E_unfiltered_filtered_025_02.png'));
% saveas(f10,strcat(num2str(component),'E_filters_025_02.png'));
% saveas(f12,strcat(num2str(component),'taus_025_02.png'));
% saveas(f101,strcat(num2str(component),'E_taus_1D_025_02.png'));

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

