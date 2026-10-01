%% FILE PATH
%dir = input('Name of the directory? (Like ./low_amplitude/12 or ./large_amplitude/01): ', 's');
%dir = '/Volumes/PSC_DiRAC_DATA/DATA_HVM/betai=0.25/01';

dir = '/JAAR-DATA/DATA_HVM/betai=4';
%dir = '/JAAR-DATA/DATA_HVM/betai=0.25/02';
%dir = '/JAAR-DATA/DATA_HVM/betai=1/02';

xl = 3.0;
yl = 3.0;
zl = 3.0;
outformat = 0;

%ns = 4; tt = 4;
%ns = 5; tt = 4;
%beta_i = 0.25; Ti02Te0 = 2.5;

%ns = 6; tt = 3;
%beta_i = 1; Ti02Te0 = 10;

ns = 10; tt = 10;
beta_i = 4; Ti02Te0 = 40;

pressure_on = 0; % This is ion pressure correction (dosen't actually add mutch)
l_wind = 16;
rms_value = 1;
absolute = 1;



f_path = [dir, '/'];
fprintf('FILE PATH = %s\n', f_path);

%cd(f_path)

% Box dimensions
%xl = input('Box length in x-direction in 2*pi unity? (xl): ');
Lx = 2.0 * pi * xl;
fprintf('\n');

%yl = input('Box length in y-direction in 2*pi unity? (yl): ');
Ly = 2.0 * pi * yl;
fprintf('\n');

%zl = input('Box length in z-direction in 2*pi unity? (zl): ');
Lz = 2.0 * pi * zl;
fprintf('\n');

%%% Output format (0-> unformatted ; 1-> formatted)
%outformat = input('Output format? (0-> unformatted ; 1-> formatted) [default: 0]: ');
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



kx = (0:dim1-1) - dim1 / 2 + 1;
kx = kx / xl;
ky = (0:dim2-1) - dim2 / 2 + 1;
ky = ky / yl;
kz = (0:dim3-1) - dim3 / 2 + 1;
kz = kz / zl;

%%% Number of times saved in tempo.dat
%ns = input('Number of times saved in tempo.dat: ');
fprintf('\n');


% Now lets select the time stamp and clear space
%tt = input('Time step to analyse (integer):');
fprintf('\n');

%pressure_on = input('compute pressure terms 1 (true) 0(false) (integer):');
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


    pxx_t = squeeze(pxx(:,:,:,tt));
    pyy_t = squeeze(pyy(:,:,:,tt));
    pzz_t = squeeze(pzz(:,:,:,tt));
    pxy_t = squeeze(pxy(:,:,:,tt));
    pxz_t = squeeze(pxz(:,:,:,tt));
    pyz_t = squeeze(pyz(:,:,:,tt));

    clearvars pxx pyy pzz pxy pxz pyz

end

%--------------------------------------------------------------------------

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


%l_wind = input('Window size:');
fprintf('\n');



%%% This is a list of the variables
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

%beta_i = input('set the beta_i % : ');
%Ti02Te0 = input('set the Ti0/Te0 % : ');

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



%Up to here is to load the data



%%% ----------------------------------------------------------------------
% Lets compute the generalised ohms terms for total field

%For memory constraints lets devive this into components
%select the component % component x=1, y=2, z=3;
%component = input('select the component % component x=1, y=2, z=3: ');


%----------------------------------------------------------------------
me = 1/100;
mi=1;
mre = mi*me/(mi+me);
%----------------------------------------------------------------------

% This is where the analysis of things begin
%----------------------------------------------------------------------
% Computing non-linear terms for the generalised Ohms law
%----------------------------------------------------------------------

%if (component == 1)
v_x_B_x_dt = v_y_dt.*Bz_dt - v_z_dt.*By_dt;
J_x_B_x_dt = Jy_dt.*Bz_dt - Jz_dt.*By_dt;
%elseif (component == 2)
v_x_B_y_dt = v_z_dt.*Bx_dt - v_x_dt.*Bz_dt;
J_x_B_y_dt = Jz_dt.*Bx_dt - Jx_dt.*Bz_dt;
%elseif (component == 3)
v_x_B_z_dt = v_x_dt.*By_dt - v_y_dt.*Bx_dt;
J_x_B_z_dt = Jx_dt.*By_dt - Jy_dt.*Bx_dt;
%end

v_J_xx_dt = v_x_dt.*Jx_dt;
v_J_xy_dt = v_x_dt.*Jy_dt;
v_J_xz_dt = v_x_dt.*Jz_dt;
v_J_yx_dt = v_y_dt.*Jx_dt;
v_J_yy_dt = v_y_dt.*Jy_dt;
v_J_yz_dt = v_y_dt.*Jz_dt;
v_J_zx_dt = v_z_dt.*Jx_dt;
v_J_zy_dt = v_z_dt.*Jy_dt;
v_J_zz_dt = v_z_dt.*Jz_dt;

J_v_xx_dt = Jx_dt.*v_x_dt;
J_v_xy_dt = Jx_dt.*v_y_dt;
J_v_xz_dt = Jx_dt.*v_z_dt;
J_v_yx_dt = Jy_dt.*v_x_dt;
J_v_yy_dt = Jy_dt.*v_y_dt;
J_v_yz_dt = Jy_dt.*v_z_dt;
J_v_zx_dt = Jz_dt.*v_x_dt;
J_v_zy_dt = Jz_dt.*v_y_dt;
J_v_zz_dt = Jz_dt.*v_z_dt;

J_J_2n_xx_dt = Jx_dt.*Jx_dt./(n_0_dt );
J_J_2n_xy_dt = Jx_dt.*Jy_dt./(n_0_dt );
J_J_2n_xz_dt = Jx_dt.*Jz_dt./(n_0_dt );
J_J_2n_yy_dt = Jy_dt.*Jy_dt./(n_0_dt );
J_J_2n_yz_dt = Jy_dt.*Jz_dt./(n_0_dt );
J_J_2n_zz_dt = Jz_dt.*Jz_dt./(n_0_dt );
%----------------------------------------------------------------------

%Now let lets compute the gradients
grad_fact = 1; % This always need to be two??
sigma_g = 1;
%Grad_Pe
%----------------------------------------------------------------------

%----------------------------------------------------------------------
%correction of the electric field
me = 1/100;

%L2Ex_dt = me*4*del2(Ex_dt)/(grad_fact.*resx)^2;
%L2Ey_dt = me*4*del2(Ey_dt)/(grad_fact.*resx)^2;
%L2Ez_dt = me*4*del2(Ez_dt)/(grad_fact.*resx)^2;

[Ex_dt_y, Ex_dt_x, Ex_dt_z] = gradient(Ex_dt);
[Ex_dt_yy, ~, ~] = gradient(Ex_dt_y); [~, Ex_dt_xx, ~] = gradient(Ex_dt_x); [~, ~, Ex_dt_zz] = gradient(Ex_dt_z);
L2Ex_dt = (me^0)*(Ex_dt_xx + Ex_dt_yy + Ex_dt_zz)/(grad_fact.*resx)^2;

[Ey_dt_y, Ey_dt_x, Ey_dt_z] = gradient(Ey_dt);
[Ey_dt_yy, ~, ~] = gradient(Ey_dt_y); [~, Ey_dt_xx, ~] = gradient(Ey_dt_x); [~, ~, Ey_dt_zz] = gradient(Ey_dt_z);
L2Ey_dt = (me^0)*(Ey_dt_xx + Ey_dt_yy + Ey_dt_zz)/(grad_fact.*resx)^2;

[Ez_dt_y, Ez_dt_x, Ez_dt_z] = gradient(Ez_dt);
[Ez_dt_yy, ~, ~] = gradient(Ez_dt_y); [~, Ez_dt_xx, ~] = gradient(Ez_dt_x); [~, ~, Ez_dt_zz] = gradient(Ez_dt_z);
L2Ez_dt = (me^0)*(Ez_dt_xx + Ez_dt_yy + Ez_dt_zz)/(grad_fact.*resx)^2;

%Correction (electron inertia) (I should not substract this )
%----------------------------------------------------------------------
%Ex_dt = Ex_dt - L2Ex_dt;
%Ey_dt = Ey_dt - L2Ey_dt;
%Ez_dt = Ez_dt - L2Ez_dt;
%----------------------------------------------------------------------


%----------------------------------------------------------------------
[Pe_dt_y, Pe_dt_x, Pe_dt_z] = gradient(Pe_dt);
%----------------------------------------------------------------------
%if (component == 1)
Div_Pe_dt_x = Pe_dt_x/(grad_fact.*resx);
%elseif (component == 2)
Div_Pe_dt_y = Pe_dt_y/(grad_fact.*resy);
%elseif (component == 3)
Div_Pe_dt_z = Pe_dt_z/(grad_fact.*resz);
%end
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
    %if (component == 1)
    Div_Pi_dt_x = Pij_ixx_dt_x/(grad_fact.*resx) + Pij_ixy_dt_y/(grad_fact.*resy) + Pij_ixz_dt_z/(grad_fact.*resz);
    %elseif (component == 2)
    Div_Pi_dt_y = Pij_ixy_dt_x/(grad_fact.*resx) + Pij_iyy_dt_y/(grad_fact.*resy) + Pij_iyz_dt_z/(grad_fact.*resz);
    %elseif (component == 3)
    Div_Pi_dt_z = Pij_ixz_dt_x/(grad_fact.*resx) + Pij_iyz_dt_y/(grad_fact.*resy) + Pij_izz_dt_z/(grad_fact.*resz);
    %end
    clearvars Pij_ixx_dt_* Pij_ixy_dt_* Pij_ixz_dt_* ...
        Pij_iyy_dt_* Pij_iyz_dt_* Pij_izz_dt_*
    %----------------------------------------------------------------------

    % This is the correction of the div Pe
    %----------------------------------------------------------------------
    %if (component == 1)
    Div_Pe_dt_x = (mre/me)*Div_Pe_dt_x - (mre/mi)*Div_Pi_dt_x ;
    %    elseif (component == 2)
    Div_Pe_dt_y = (mre/me)*Div_Pe_dt_y - (mre/mi)*Div_Pi_dt_y ;
    %    elseif (component == 3)
    Div_Pe_dt_z = (mre/me)*Div_Pe_dt_z - (mre/mi)*Div_Pi_dt_z ;
    %end
    %----------------------------------------------------------------------
end

%----------------------------------------------------------------------

%----------------------------------------------------------------------
[v_J_dt_xx_y, v_J_dt_xx_x, v_J_dt_xx_z] = gradient(v_J_xx_dt);
[v_J_dt_xy_y, v_J_dt_xy_x, v_J_dt_xy_z] = gradient(v_J_xy_dt);
[v_J_dt_xz_y, v_J_dt_xz_x, v_J_dt_xz_z] = gradient(v_J_xz_dt);
[v_J_dt_yx_y, v_J_dt_yx_x, v_J_dt_yx_z] = gradient(v_J_yx_dt);
[v_J_dt_yy_y, v_J_dt_yy_x, v_J_dt_yy_z] = gradient(v_J_yy_dt);
[v_J_dt_yz_y, v_J_dt_yz_x, v_J_dt_yz_z] = gradient(v_J_yz_dt);
[v_J_dt_zx_y, v_J_dt_zx_x, v_J_dt_zx_z] = gradient(v_J_zx_dt);
[v_J_dt_zy_y, v_J_dt_zy_x, v_J_dt_zy_z] = gradient(v_J_zy_dt);
[v_J_dt_zz_y, v_J_dt_zz_x, v_J_dt_zz_z] = gradient(v_J_zz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
%if (component == 1)
Div_vJ_dt_x = v_J_dt_xx_x/(grad_fact.*resx) + v_J_dt_yx_y/(grad_fact.*resy) + v_J_dt_zx_z/(grad_fact.*resz);
%elseif (component == 2)
Div_vJ_dt_y = v_J_dt_xy_x/(grad_fact.*resx) + v_J_dt_yy_y/(grad_fact.*resy) + v_J_dt_zy_z/(grad_fact.*resz);
%elseif (component == 3)
Div_vJ_dt_z = v_J_dt_xz_x/(grad_fact.*resx) + v_J_dt_yz_y/(grad_fact.*resy) + v_J_dt_zz_z/(grad_fact.*resz);
%end

clearvars v_J_dt_xx_* v_J_dt_xy_* v_J_dt_xz_* ...
    v_J_dt_yx_* v_J_dt_yy_* v_J_dt_yz_* ...
    v_J_dt_zx_* v_J_dt_zy_* v_J_dt_zz_*
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[J_v_dt_xx_y, J_v_dt_xx_x, J_v_dt_xx_z] = gradient(J_v_xx_dt);
[J_v_dt_xy_y, J_v_dt_xy_x, J_v_dt_xy_z] = gradient(J_v_xy_dt);
[J_v_dt_xz_y, J_v_dt_xz_x, J_v_dt_xz_z] = gradient(J_v_xz_dt);
[J_v_dt_yx_y, J_v_dt_yx_x, J_v_dt_yx_z] = gradient(J_v_yx_dt);
[J_v_dt_yy_y, J_v_dt_yy_x, J_v_dt_yy_z] = gradient(J_v_yy_dt);
[J_v_dt_yz_y, J_v_dt_yz_x, J_v_dt_yz_z] = gradient(J_v_yz_dt);
[J_v_dt_zx_y, J_v_dt_zx_x, J_v_dt_zx_z] = gradient(J_v_zx_dt);
[J_v_dt_zy_y, J_v_dt_zy_x, J_v_dt_zy_z] = gradient(J_v_zy_dt);
[J_v_dt_zz_y, J_v_dt_zz_x, J_v_dt_zz_z] = gradient(J_v_zz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
%if (component == 1)
Div_Jv_dt_x = J_v_dt_xx_x/(grad_fact.*resx) + J_v_dt_yx_y/(grad_fact.*resy) + J_v_dt_zx_z/(grad_fact.*resz);
%elseif (component == 2)
Div_Jv_dt_y = J_v_dt_xy_x/(grad_fact.*resx) + J_v_dt_yy_y/(grad_fact.*resy) + J_v_dt_zy_z/(grad_fact.*resz);
%elseif (component == 3)
Div_Jv_dt_z = J_v_dt_xz_x/(grad_fact.*resx) + J_v_dt_yz_y/(grad_fact.*resy) + J_v_dt_zz_z/(grad_fact.*resz);
%end

clearvars J_v_dt_xx_* J_v_dt_xy_* J_v_dt_xz_* ...
    J_v_dt_yx_* J_v_dt_yy_* J_v_dt_yz_* ...
    J_v_dt_zx_* J_v_dt_zy_* J_v_dt_zz_*
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[J_J_dt_xx_y, J_J_dt_xx_x, J_J_dt_xx_z] = gradient(J_J_2n_xx_dt);
[J_J_dt_xy_y, J_J_dt_xy_x, J_J_dt_xy_z] = gradient(J_J_2n_xy_dt);
[J_J_dt_xz_y, J_J_dt_xz_x, J_J_dt_xz_z] = gradient(J_J_2n_xz_dt);
[J_J_dt_yy_y, J_J_dt_yy_x, J_J_dt_yy_z] = gradient(J_J_2n_yy_dt);
[J_J_dt_yz_y, J_J_dt_yz_x, J_J_dt_yz_z] = gradient(J_J_2n_yz_dt);
[J_J_dt_zz_y, J_J_dt_zz_x, J_J_dt_zz_z] = gradient(J_J_2n_zz_dt);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
%if (component == 1)
Div_JJ_dt_x = J_J_dt_xx_x/(grad_fact.*resx) + J_J_dt_xy_y/(grad_fact.*resy) + J_J_dt_xz_z/(grad_fact.*resz);
%elseif (component == 2)
Div_JJ_dt_y = J_J_dt_xy_x/(grad_fact.*resx) + J_J_dt_yy_y/(grad_fact.*resy) + J_J_dt_yz_z/(grad_fact.*resz);
%elseif (component == 3)
Div_JJ_dt_z = J_J_dt_xz_x/(grad_fact.*resx) + J_J_dt_yz_y/(grad_fact.*resy) + J_J_dt_zz_z/(grad_fact.*resz);
%end

clearvars J_J_dt_xx_* J_J_dt_xy_* J_J_dt_xz_* ...
    J_J_dt_yy_* J_J_dt_yz_* J_J_dt_zz_*
%----------------------------------------------------------------------

% for the tau
%(<vJ + Jv - JJ/n> - (<v><J> + <J><v> - <J><J>/<n>))/<n>
% % %----------------------------------------------------------------------
sub_tau1_xx = v_J_xx_dt + J_v_xx_dt - J_J_2n_xx_dt;
sub_tau1_xy = v_J_xy_dt + J_v_xy_dt - J_J_2n_xy_dt;
sub_tau1_xz = v_J_xz_dt + J_v_xz_dt - J_J_2n_xz_dt;
sub_tau1_yx = v_J_yx_dt + J_v_yx_dt - J_J_2n_xy_dt;
sub_tau1_yy = v_J_yy_dt + J_v_yy_dt - J_J_2n_yy_dt;
sub_tau1_yz = v_J_yz_dt + J_v_yz_dt - J_J_2n_yz_dt;
sub_tau1_zx = v_J_zx_dt + J_v_zx_dt - J_J_2n_xz_dt;
sub_tau1_zy = v_J_zy_dt + J_v_zy_dt - J_J_2n_yz_dt;
sub_tau1_zz = v_J_zz_dt + J_v_zz_dt - J_J_2n_zz_dt;
% % %----------------------------------------------------------------------

%----------------------------------------------------------------------
clearvars v_J_* J_v_* J_J_*
%----------------------------------------------------------------------

%%% Proceed with the scale filtering
%----------------------------------------------------------------------
%Compute the fft    %Compute the averages using a kernel
%----------------------------------------------------------------------

kx = 2 * pi * [0:nx/2 -nx/2+1:-1] / Lx; % Wavenumbers in x
ky = 2 * pi * [0:ny/2 -ny/2+1:-1] / Lz; % Wavenumbers in y
kz = 2 * pi * [0:nz/2 -nz/2+1:-1] / Lz; % Wavenumbers in z
[Kz, Kx, Ky] = meshgrid(kz, kx ,ky); % Note the order here Kz goes first

Dx = l_wind*Lx/nx;

% These four lines are the filtering
%----------------------------------------------------------------------
Bx_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,Bx_dt);
By_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,By_dt);
Bz_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,Bz_dt);

Ex_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,Ex_dt);
Ey_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,Ey_dt);
Ez_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,Ez_dt);

Jx_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,Jx_dt);
Jy_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,Jy_dt);
Jz_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,Jz_dt);

v_x_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,v_x_dt);
v_y_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,v_y_dt);
v_z_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,v_z_dt);

n_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,n_0_dt);

if(pressure_on == 1)
    Pij_ixx_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,Pij_ixx_dt);
    Pij_ixy_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,Pij_ixy_dt);
    Pij_ixz_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,Pij_ixz_dt);
    Pij_iyy_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,Pij_iyy_dt);
    Pij_iyz_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,Pij_iyz_dt);
    Pij_izz_filt = Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,Pij_izz_dt);
end
%----------------------------------------------------------------------

%----------------------------------------------------------------------
%correction of the electric field

%L2Ex_dt = 4*del2(Ex_dt)/(grad_fact.*resx)^2;
%L2Ey_dt = 4*del2(Ey_dt)/(grad_fact.*resx)^2;
%L2Ez_dt = 4*del2(Ez_dt)/(grad_fact.*resx)^2;

%if (component == 1)
[Ex_dt_y, Ex_dt_x, Ex_dt_z] = gradient(Ex_dt);
[Ex_dt_yy, ~, ~] = gradient(Ex_dt_y);
[~, Ex_dt_xx, ~] = gradient(Ex_dt_x);
[~, ~, Ex_dt_zz] = gradient(Ex_dt_z);
L2Ex_dt = (me^0)*(Ex_dt_xx + Ex_dt_yy + Ex_dt_zz)/(grad_fact.*resx)^2;
%----------------------------------------------------------------------
L2Ex_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,L2Ex_dt);
%----------------------------------------------------------------------
%elseif (component == 2)
[Ey_dt_y, Ey_dt_x, Ey_dt_z] = gradient(Ey_dt);
[Ey_dt_yy, ~, ~] = gradient(Ey_dt_y);
[~, Ey_dt_xx, ~] = gradient(Ey_dt_x);
[~, ~, Ey_dt_zz] = gradient(Ey_dt_z);
L2Ey_dt = (me^0)*(Ey_dt_xx + Ey_dt_yy + Ey_dt_zz)/(grad_fact.*resx)^2;
%----------------------------------------------------------------------
L2Ey_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,L2Ey_dt);
%----------------------------------------------------------------------
%elseif (component == 3)
[Ez_dt_y, Ez_dt_x, Ez_dt_z] = gradient(Ez_dt);
[Ez_dt_yy, ~, ~] = gradient(Ez_dt_y);
[~, Ez_dt_xx, ~] = gradient(Ez_dt_x);
[~, ~, Ez_dt_zz] = gradient(Ez_dt_z);
L2Ez_dt = (me^0)*(Ez_dt_xx + Ez_dt_yy + Ez_dt_zz)/(grad_fact.*resx)^2;
%----------------------------------------------------------------------
L2Ez_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,L2Ez_dt);
%----------------------------------------------------------------------
%end



%%% Computing non-linear terms for the generalised Ohms law
%----------------------------------------------------------------------
%if (component == 1)
v_filt_x_B_filt_x = v_y_filt.*Bz_filt - v_z_filt.*By_filt;
J_filt_x_B_filt_x = Jy_filt.*Bz_filt - Jz_filt.*By_filt;
%elseif (component == 2)
v_filt_x_B_filt_y = v_z_filt.*Bx_filt - v_x_filt.*Bz_filt;
J_filt_x_B_filt_y = Jz_filt.*Bx_filt - Jx_filt.*Bz_filt;
%elseif (component == 3)
v_filt_x_B_filt_z = v_x_filt.*By_filt - v_y_filt.*Bx_filt;
J_filt_x_B_filt_z = Jx_filt.*By_filt - Jy_filt.*Bx_filt;
%end

v_filt_J_filt_xx = v_x_filt.*Jx_filt;
v_filt_J_filt_xy = v_x_filt.*Jy_filt;
v_filt_J_filt_xz = v_x_filt.*Jz_filt;
v_filt_J_filt_yx = v_y_filt.*Jx_filt;
v_filt_J_filt_yy = v_y_filt.*Jy_filt;
v_filt_J_filt_yz = v_y_filt.*Jz_filt;
v_filt_J_filt_zx = v_z_filt.*Jx_filt;
v_filt_J_filt_zy = v_z_filt.*Jy_filt;
v_filt_J_filt_zz = v_z_filt.*Jz_filt;

J_filt_v_filt_xx = Jx_filt.*v_x_filt;
J_filt_v_filt_xy = Jx_filt.*v_y_filt;
J_filt_v_filt_xz = Jx_filt.*v_z_filt;
J_filt_v_filt_yx = Jy_filt.*v_x_filt;
J_filt_v_filt_yy = Jy_filt.*v_y_filt;
J_filt_v_filt_yz = Jy_filt.*v_z_filt;
J_filt_v_filt_zx = Jz_filt.*v_x_filt;
J_filt_v_filt_zy = Jz_filt.*v_y_filt;
J_filt_v_filt_zz = Jz_filt.*v_z_filt;

J_filt_J_filt_2n_xx = Jx_filt.*Jx_filt./(n_filt);
J_filt_J_filt_2n_xy = Jx_filt.*Jy_filt./(n_filt);
J_filt_J_filt_2n_xz = Jx_filt.*Jz_filt./(n_filt);
J_filt_J_filt_2n_yy = Jy_filt.*Jy_filt./(n_filt);
J_filt_J_filt_2n_yz = Jy_filt.*Jz_filt./(n_filt);
J_filt_J_filt_2n_zz = Jz_filt.*Jz_filt./(n_filt);
%----------------------------------------------------------------------


%----------------------------------------------------------------------
Pe_filt = n_filt * Te0;
%----------------------------------------------------------------------
[Pe_filt_y, Pe_filt_x, Pe_filt_z] = gradient(Pe_filt);
%----------------------------------------------------------------------
%if (component == 1)
Div_Pe_filt_x = Pe_filt_x/(grad_fact.*resx);
%elseif (component == 2)
Div_Pe_filt_y = Pe_filt_y/(grad_fact.*resy);
%elseif (component == 3)
Div_Pe_filt_z = Pe_filt_z/(grad_fact.*resz);
%end
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
    %if (component == 1)
    Div_Pi_filt_x = Pij_ixx_filt_x/(grad_fact.*resx) + Pij_ixy_filt_y/(grad_fact.*resy) + Pij_ixz_filt_z/(grad_fact.*resz);
    %elseif (component == 2)
    Div_Pi_filt_y = Pij_ixy_filt_x/(grad_fact.*resx) + Pij_iyy_filt_y/(grad_fact.*resy) + Pij_iyz_filt_z/(grad_fact.*resz);
    %elseif (component == 3)
    Div_Pi_filt_z = Pij_ixz_filt_x/(grad_fact.*resx) + Pij_iyz_filt_y/(grad_fact.*resy) + Pij_izz_filt_z/(grad_fact.*resz);
    %end
    clearvars Pij_ixx_filt_* Pij_ixy_filt_* Pij_ixz_filt_* ...
        Pij_iyy_filt_* Pij_iyz_filt_* Pij_izz_filt_*
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    % This is the correction of the div Pe
    %----------------------------------------------------------------------
    %if (component == 1)
    Div_Pe_filt_x = (mre/me)*Div_Pe_filt_x - (mre/mi)*Div_Pi_filt_x ;
    %    elseif (component == 2)
    Div_Pe_filt_y = (mre/me)*Div_Pe_filt_y - (mre/mi)*Div_Pi_filt_y ;
    %    elseif (component == 3)
    Div_Pe_filt_z = (mre/me)*Div_Pe_filt_z - (mre/mi)*Div_Pi_filt_z ;
    %end
    %----------------------------------------------------------------------

end

%----------------------------------------------------------------------
[v_filt_J_filt_xx_y, v_filt_J_filt_xx_x, v_filt_J_filt_xx_z] = gradient(v_filt_J_filt_xx);
[v_filt_J_filt_xy_y, v_filt_J_filt_xy_x, v_filt_J_filt_xy_z] = gradient(v_filt_J_filt_xy);
[v_filt_J_filt_xz_y, v_filt_J_filt_xz_x, v_filt_J_filt_xz_z] = gradient(v_filt_J_filt_xz);
[v_filt_J_filt_yx_y, v_filt_J_filt_yx_x, v_filt_J_filt_yx_z] = gradient(v_filt_J_filt_yx);
[v_filt_J_filt_yy_y, v_filt_J_filt_yy_x, v_filt_J_filt_yy_z] = gradient(v_filt_J_filt_yy);
[v_filt_J_filt_yz_y, v_filt_J_filt_yz_x, v_filt_J_filt_yz_z] = gradient(v_filt_J_filt_yz);
[v_filt_J_filt_zx_y, v_filt_J_filt_zx_x, v_filt_J_filt_zx_z] = gradient(v_filt_J_filt_zx);
[v_filt_J_filt_zy_y, v_filt_J_filt_zy_x, v_filt_J_filt_zy_z] = gradient(v_filt_J_filt_zy);
[v_filt_J_filt_zz_y, v_filt_J_filt_zz_x, v_filt_J_filt_zz_z] = gradient(v_filt_J_filt_zz);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
%if (component == 1)
Div_vJ_filt_x = v_filt_J_filt_xx_x/(grad_fact.*resx) + v_filt_J_filt_yx_y/(grad_fact.*resy) + v_filt_J_filt_zx_z/(grad_fact.*resz);
%elseif (component == 2)
Div_vJ_filt_y = v_filt_J_filt_xy_x/(grad_fact.*resx) + v_filt_J_filt_yy_y/(grad_fact.*resy) + v_filt_J_filt_zy_z/(grad_fact.*resz);
%elseif (component == 3)
Div_vJ_filt_z = v_filt_J_filt_xz_x/(grad_fact.*resx) + v_filt_J_filt_yz_y/(grad_fact.*resy) + v_filt_J_filt_zz_z/(grad_fact.*resz);
%end

clearvars v_filt_J_filt_xx_* v_filt_J_filt_xy_* v_filt_J_filt_xz_* ...
    v_filt_J_filt_yx_* v_filt_J_filt_yy_* v_filt_J_filt_yz_* ...
    v_filt_J_filt_zx_* v_filt_J_filt_zy_* v_filt_J_filt_zz_*
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[J_filt_v_filt_xx_y, J_filt_v_filt_xx_x, J_filt_v_filt_xx_z] = gradient(J_filt_v_filt_xx);
[J_filt_v_filt_xy_y, J_filt_v_filt_xy_x, J_filt_v_filt_xy_z] = gradient(J_filt_v_filt_xy);
[J_filt_v_filt_xz_y, J_filt_v_filt_xz_x, J_filt_v_filt_xz_z] = gradient(J_filt_v_filt_xz);
[J_filt_v_filt_yx_y, J_filt_v_filt_yx_x, J_filt_v_filt_yx_z] = gradient(J_filt_v_filt_yx);
[J_filt_v_filt_yy_y, J_filt_v_filt_yy_x, J_filt_v_filt_yy_z] = gradient(J_filt_v_filt_yy);
[J_filt_v_filt_yz_y, J_filt_v_filt_yz_x, J_filt_v_filt_yz_z] = gradient(J_filt_v_filt_yz);
[J_filt_v_filt_zx_y, J_filt_v_filt_zx_x, J_filt_v_filt_zx_z] = gradient(J_filt_v_filt_zx);
[J_filt_v_filt_zy_y, J_filt_v_filt_zy_x, J_filt_v_filt_zy_z] = gradient(J_filt_v_filt_zy);
[J_filt_v_filt_zz_y, J_filt_v_filt_zz_x, J_filt_v_filt_zz_z] = gradient(J_filt_v_filt_zz);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
%if (component == 1)
Div_Jv_filt_x = J_filt_v_filt_xx_x/(grad_fact.*resx) + J_filt_v_filt_yx_y/(grad_fact.*resy) + J_filt_v_filt_zx_z/(grad_fact.*resz);
%elseif (component == 2)
Div_Jv_filt_y = J_filt_v_filt_xy_x/(grad_fact.*resx) + J_filt_v_filt_yy_y/(grad_fact.*resy) + J_filt_v_filt_zy_z/(grad_fact.*resz);
%elseif (component == 3)
Div_Jv_filt_z = J_filt_v_filt_xz_x/(grad_fact.*resx) + J_filt_v_filt_yz_y/(grad_fact.*resy) + J_filt_v_filt_zz_z/(grad_fact.*resz);
%end

clearvars J_filt_v_filt_xx_* J_filt_v_filt_xy_* J_filt_v_filt_xz_* ...
    J_filt_v_filt_yx_* J_filt_v_filt_yy_* J_filt_v_filt_yz_* ...
    J_filt_v_filt_zx_* J_filt_v_filt_zy_* J_filt_v_filt_zz_*
%----------------------------------------------------------------------

%----------------------------------------------------------------------
[J_filt_J_filt_xx_y, J_filt_J_filt_xx_x, J_filt_J_filt_xx_z] = gradient(J_filt_J_filt_2n_xx);
[J_filt_J_filt_xy_y, J_filt_J_filt_xy_x, J_filt_J_filt_xy_z] = gradient(J_filt_J_filt_2n_xy);
[J_filt_J_filt_xz_y, J_filt_J_filt_xz_x, J_filt_J_filt_xz_z] = gradient(J_filt_J_filt_2n_xz);
[J_filt_J_filt_yy_y, J_filt_J_filt_yy_x, J_filt_J_filt_yy_z] = gradient(J_filt_J_filt_2n_yy);
[J_filt_J_filt_yz_y, J_filt_J_filt_yz_x, J_filt_J_filt_yz_z] = gradient(J_filt_J_filt_2n_yz);
[J_filt_J_filt_zz_y, J_filt_J_filt_zz_x, J_filt_J_filt_zz_z] = gradient(J_filt_J_filt_2n_zz);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
%if (component == 1)
Div_JJ_filt_2n_x = J_filt_J_filt_xx_x/(grad_fact.*resx) + J_filt_J_filt_xy_y/(grad_fact.*resy) + J_filt_J_filt_xz_z/(grad_fact.*resz);
%elseif (component == 2)
Div_JJ_filt_2n_y = J_filt_J_filt_xy_x/(grad_fact.*resx) + J_filt_J_filt_yy_y/(grad_fact.*resy) + J_filt_J_filt_yz_z/(grad_fact.*resz);
%elseif (component == 3)
Div_JJ_filt_2n_z = J_filt_J_filt_xz_x/(grad_fact.*resx) + J_filt_J_filt_yz_y/(grad_fact.*resy) + J_filt_J_filt_zz_z/(grad_fact.*resz);
%end

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
me = 1/100;
%----------------------------------------------------------------------

%%%  Now let's compute the tensors
% % %----------------------------------------------------------------------
%----------------------------------------------------------------------
[sub_tau1_xx_y, sub_tau1_xx_x, sub_tau1_xx_z] = gradient(sub_tau1_xx);
[sub_tau1_xy_y, sub_tau1_xy_x, sub_tau1_xy_z] = gradient(sub_tau1_xy);
[sub_tau1_xz_y, sub_tau1_xz_x, sub_tau1_xz_z] = gradient(sub_tau1_xz);
[sub_tau1_yx_y, sub_tau1_yx_x, sub_tau1_yx_z] = gradient(sub_tau1_yx);
[sub_tau1_yy_y, sub_tau1_yy_x, sub_tau1_yy_z] = gradient(sub_tau1_yy);
[sub_tau1_yz_y, sub_tau1_yz_x, sub_tau1_yz_z] = gradient(sub_tau1_yz);
[sub_tau1_zx_y, sub_tau1_zx_x, sub_tau1_zx_z] = gradient(sub_tau1_zx);
[sub_tau1_zy_y, sub_tau1_zy_x, sub_tau1_zy_z] = gradient(sub_tau1_zy);
[sub_tau1_zz_y, sub_tau1_zz_x, sub_tau1_zz_z] = gradient(sub_tau1_zz);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
%if (component == 1)
%(<nE> - <n><E>)/<n>
% % %----------------------------------------------------------------------
tau_nE_tau_x = (B0*c)^(1)*((Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,n_0_dt.*Ex_dt))./n_filt - Ex_filt);
%(<nevxB> - <n><v>x<B>)/<ne>
% % %----------------------------------------------------------------------
tau_v_x_B_tau_x = (B0*c)^(1)*((Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,n_0_dt.*v_x_B_x_dt))./n_filt - v_filt_x_B_filt_x);
%(<nevxB> - <n><J>x<B>)/<ne>
%----------------------------------------------------------------------
tau_J_x_B_tau_x = (mre/me)*(B0*c)^(1)*((Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,J_x_B_x_dt) - J_filt_x_B_filt_x)./n_filt);
%----------------------------------------------------------------------
Div_sub_tau1_x = sub_tau1_xx_x/(grad_fact.*resx) + sub_tau1_yx_y/(grad_fact.*resy) + sub_tau1_zx_z/(grad_fact.*resz);
%----------------------------------------------------------------------
tau_Div_tau1_x = mre*c*c*(1.*(Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,Div_sub_tau1_x) - (Div_vJ_filt_x + Div_Jv_filt_x - Div_JJ_filt_2n_x))./n_filt);
% % %----------------------------------------------------------------------
%elseif (component == 2)
% % %----------------------------------------------------------------------
tau_nE_tau_y = (B0*c)^(1)*((Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,n_0_dt.*Ey_dt))./n_filt - Ey_filt);
% % %----------------------------------------------------------------------
tau_v_x_B_tau_y = (B0*c)^(1)*((Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,n_0_dt.*v_x_B_y_dt))./n_filt - v_filt_x_B_filt_y);
% % %----------------------------------------------------------------------
tau_J_x_B_tau_y = (mre/me)*(B0*c)^(1)*((Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,J_x_B_y_dt) - J_filt_x_B_filt_y)./n_filt);
% % %----------------------------------------------------------------------
Div_sub_tau1_y = sub_tau1_xy_x/(grad_fact.*resx) + sub_tau1_yy_y/(grad_fact.*resy) + sub_tau1_zy_z/(grad_fact.*resz);
% % %----------------------------------------------------------------------
tau_Div_tau1_y = mre*c*c*(1.*(Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,Div_sub_tau1_y) - (Div_vJ_filt_y + Div_Jv_filt_y - Div_JJ_filt_2n_y))./n_filt);
%elseif (component == 3)
% % %----------------------------------------------------------------------
tau_nE_tau_z = (B0*c)^(1)*((Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,n_0_dt.*Ez_dt))./n_filt - Ez_filt);
% % %----------------------------------------------------------------------
tau_v_x_B_tau_z = (B0*c)^(1)*((Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,n_0_dt.*v_x_B_z_dt))./n_filt - v_filt_x_B_filt_z);
% % %----------------------------------------------------------------------
tau_J_x_B_tau_z = (mre/me)*(B0*c)^(1)*((Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,J_x_B_z_dt) - J_filt_x_B_filt_z)./n_filt);
% % %----------------------------------------------------------------------
Div_sub_tau1_z = sub_tau1_xz_x/(grad_fact.*resx) + sub_tau1_yz_y/(grad_fact.*resy) + sub_tau1_zz_z/(grad_fact.*resz);
%----------------------------------------------------------------------
tau_Div_tau1_z = mre*c*c*(1.*(Gauss_filter_3D_xyz(Dx,Kx,Ky,Kz,Div_sub_tau1_z) - (Div_vJ_filt_z + Div_Jv_filt_z - Div_JJ_filt_2n_z))./n_filt);
%----------------------------------------------------------------------
%end

clearvars sub_*

%%% clear variables to release space
%----------------------------------------------------------------------
%clearvars Div* E* J* v_* Pij* sub*
%----------------------------------------------------------------------

%%% Select the components to plot

%%% ----------------------------------------------------------------------
%ext_fact = sqrt(1/mime);

% This is to estimate the three term in the Ohm's law. for the plots 111
% and 222


%--------------------------------------------------------------------------
%if (component == 1)
v_x_B_x_dt = v_y_dt.*Bz_dt - v_z_dt.*By_dt;
J_x_B_x_dt = Jy_dt.*Bz_dt - Jz_dt.*By_dt;
%Div_Pe_dt_x = Pe_dt_x/(grad_fact.*resx);
v_x_B_x_filt = v_y_filt.*Bz_filt - v_z_filt.*By_filt;
J_x_B_x_filt = Jy_filt.*Bz_filt - Jz_filt.*By_filt;
%Div_Pe_filt_x = Pe_filt_x/(grad_fact.*resx);
%elseif (component == 2)
v_x_B_y_dt = v_z_dt.*Bx_dt - v_x_dt.*Bz_dt;
J_x_B_y_dt = Jz_dt.*Bx_dt - Jx_dt.*Bz_dt;
%Div_Pe_dt_y = Pe_dt_y/(grad_fact.*resy);
v_x_B_y_filt = v_z_dt.*Bx_filt - v_x_filt.*Bz_filt;
J_x_B_y_filt = Jz_dt.*Bx_filt - Jx_filt.*Bz_filt;
%Div_Pe_filt_y = Pe_filt_y/(grad_fact.*resy);
%elseif (component == 3)
v_x_B_z_dt = v_x_dt.*By_dt - v_y_dt.*Bx_dt;
J_x_B_z_dt = Jx_dt.*By_dt - Jy_dt.*Bx_dt;
%Div_Pe_dt_z = Pe_dt_z/(grad_fact.*resz);
v_x_B_z_filt = v_x_filt.*By_filt - v_y_filt.*Bx_filt;
J_x_B_z_filt = Jx_filt.*By_filt - Jy_filt.*Bx_filt;
%Div_Pe_filt_z = Pe_filt_z/(grad_fact.*resz);
%end
clearvars Pe_dt_*
clearvars Pe_filt_*
%--------------------------------------------------------------------------

%----------------------------------------------------------------------
% terms from the owns law with no signs JXB has no correction before here
%----------------------------------------------------------------------
%if (component == 1)
term1_dt_x = B0*v_a*(Ex_dt);
term2_dt_x = B0*v_a*(v_x_B_x_dt);
term3_dt_x = (mre/me)*B0*v_a*J_x_B_x_dt./n_0_dt;
term4_dt_x = v_a*v_a*(Div_Pe_dt_x./n_0_dt);
term5_dt_x = mre*v_a*v_a*((Div_vJ_dt_x + Div_Jv_dt_x - Div_JJ_dt_x)./n_0_dt);
term6_dt_x = mre*v_a*v_a*L2Ex_dt./n_0_dt;
term7_dt_x = - term2_dt_x + term3_dt_x - term4_dt_x + term5_dt_x + term6_dt_x;
%----------------------------------------------------------------------
% This is for the filtered quantities
%----------------------------------------------------------------------
term1_filt_x = B0*v_a*(Ex_filt);
term2_filt_x = B0*v_a*(v_filt_x_B_filt_x);
term3_filt_x = (mre/me)*B0*v_a*J_filt_x_B_filt_x./n_filt;
term4_filt_x = v_a*v_a*(Div_Pe_filt_x./n_filt);
term5_filt_x = mre*v_a*v_a*((Div_vJ_filt_x + Div_Jv_filt_x - Div_JJ_filt_2n_x)./n_filt);
term6_filt_x = mre*v_a*v_a*L2Ex_filt./n_0_dt;
term7_filt_x = - term2_filt_x + term3_filt_x - term4_filt_x + term5_filt_x + term6_filt_x;
%elseif (component == 2)
term1_dt_y = B0*v_a*(Ey_dt);
term2_dt_y = B0*v_a*(v_x_B_y_dt);
term3_dt_y = (mre/me)*B0*v_a*J_x_B_y_dt./n_0_dt;
term4_dt_y = v_a*v_a*(Div_Pe_dt_y./n_0_dt);
term5_dt_y = mre*v_a*v_a*((Div_vJ_dt_y + Div_Jv_dt_y - Div_JJ_dt_y)./n_0_dt);
term6_dt_y = mre*v_a*v_a*L2Ey_dt./n_0_dt;
term7_dt_y = - term2_dt_y + term3_dt_y - term4_dt_y + term5_dt_y + term6_dt_y;
%----------------------------------------------------------------------
% This is for the filtered quantities
%----------------------------------------------------------------------
term1_filt_y = B0*v_a*(Ey_filt);
term2_filt_y = B0*v_a*(v_filt_x_B_filt_y);
term3_filt_y = (mre/me)*B0*v_a*J_filt_x_B_filt_y./n_filt;
term4_filt_y = v_a*v_a*(Div_Pe_filt_y./n_filt);
term5_filt_y = me*v_a*v_a*((Div_vJ_filt_y + Div_Jv_filt_y - Div_JJ_filt_2n_y)./n_filt);
term6_filt_y = mre*v_a*v_a*L2Ey_filt./n_0_dt;
term7_filt_y = - term2_filt_y + term3_filt_y - term4_filt_y + term5_filt_y + term6_filt_y;
%elseif (component ==3)
term1_dt_z = B0*v_a*(Ez_dt);
term2_dt_z = B0*v_a*(v_x_B_z_dt);
term3_dt_z = (mre/me)*B0*v_a*J_x_B_z_dt./n_0_dt;
term4_dt_z = v_a*v_a*(Div_Pe_dt_z./n_0_dt);
term5_dt_z = me*v_a*v_a*((Div_vJ_dt_z + Div_Jv_dt_z - Div_JJ_dt_z)./n_0_dt);
term6_dt_z = mre*v_a*v_a*L2Ez_dt./n_0_dt;
term7_dt_z = - term2_dt_z + term3_dt_z - term4_dt_z + term5_dt_z + term6_dt_z;
%----------------------------------------------------------------------
% This is for the filtered quantities
%----------------------------------------------------------------------
term1_filt_z = B0*v_a*(Ez_filt);
term2_filt_z = B0*v_a*(v_filt_x_B_filt_z);
term3_filt_z = (mre/me)*B0*v_a*J_filt_x_B_filt_z./n_filt;
term4_filt_z = v_a*v_a*(Div_Pe_filt_z./n_filt);
term5_filt_z = me*v_a*v_a*((Div_vJ_filt_z + Div_Jv_filt_z - Div_JJ_filt_2n_z)./n_filt);
term6_filt_z = mre*v_a*v_a*L2Ez_filt./n_0_dt;
term7_filt_z = - term2_filt_z + term3_filt_z - term4_filt_z + term5_filt_z + term6_filt_z;
%end


%correction
%--------------------------------------------------------------------------
term5_dt_x = term5_dt_x + term6_dt_x;
term5_dt_y = term5_dt_y + term6_dt_y;
term5_dt_z = term5_dt_z + term6_dt_z;

term5_filt_x = term5_filt_x + term6_filt_x;
term5_filt_y = term5_filt_y + term6_filt_y;
term5_filt_z = term5_filt_z + term6_filt_z;

%term6_dt_x = term7_dt_x;
%term6_dt_y = term7_dt_y;
%term6_dt_z = term7_dt_z;

%term6_filt_x = term7_filt_x;
%term6_filt_y = term7_filt_y;
%term6_filt_z = term7_filt_z;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
tau_total_x = -tau_nE_tau_x -tau_v_x_B_tau_x + tau_J_x_B_tau_x + tau_Div_tau1_x;
tau_total_y = -tau_nE_tau_y -tau_v_x_B_tau_y + tau_J_x_B_tau_y + tau_Div_tau1_y;
tau_total_z = -tau_nE_tau_z -tau_v_x_B_tau_z + tau_J_x_B_tau_z + tau_Div_tau1_z;
%--------------------------------------------------------------------------


% Thos part here is to make the plot for the contributions. This has the
% correct labels and colours

%  HERE beggings the block for the plots and phase coherence plots <-----------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%{
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

%stopp

fs=25; x0=45;y0=54;xx1=1400;yy1=500;
i = 50;
j = 50;
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
dum = term5_filt_x ;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-',color=My_colors(5,:),LineWidth=lwm)
sum_filt_x = term7_filt_x ;
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
%}
%--------------------------------------------------------------------------

%stopp
%{
% lets Compute the Curl %<----------------- to compute the curl and make
% the plots
%--------------------------------------------------------------------------
%
[tau_nE_tau_x_y, tau_nE_tau_x_x, tau_nE_tau_x_z] = gradient(tau_nE_tau_x);
[tau_nE_tau_y_y, tau_nE_tau_y_x, tau_nE_tau_y_z] = gradient(tau_nE_tau_y);
[tau_nE_tau_z_y, tau_nE_tau_z_x, tau_nE_tau_z_z] = gradient(tau_nE_tau_z);

[tau_v_x_B_tau_x_y, tau_v_x_B_tau_x_x, tau_v_x_B_tau_x_z] = gradient(tau_v_x_B_tau_x);
[tau_v_x_B_tau_y_y, tau_v_x_B_tau_y_x, tau_v_x_B_tau_y_z] = gradient(tau_v_x_B_tau_y);
[tau_v_x_B_tau_z_y, tau_v_x_B_tau_z_x, tau_v_x_B_tau_z_z] = gradient(tau_v_x_B_tau_z);

[tau_J_x_B_tau_x_y, tau_J_x_B_tau_x_x, tau_J_x_B_tau_x_z] = gradient(tau_J_x_B_tau_x);
[tau_J_x_B_tau_y_y, tau_J_x_B_tau_y_x, tau_J_x_B_tau_y_z] = gradient(tau_J_x_B_tau_y);
[tau_J_x_B_tau_z_y, tau_J_x_B_tau_z_x, tau_J_x_B_tau_z_z] = gradient(tau_J_x_B_tau_z);

[tau_Div_tau1_x_y, tau_Div_tau1_x_x, tau_Div_tau1_x_z] = gradient(tau_Div_tau1_x);
[tau_Div_tau1_y_y, tau_Div_tau1_y_x, tau_Div_tau1_y_z] = gradient(tau_Div_tau1_y);
[tau_Div_tau1_z_y, tau_Div_tau1_z_x, tau_Div_tau1_z_z] = gradient(tau_Div_tau1_z);


curl_tau_nE_tau_x = (tau_nE_tau_z_y/(grad_fact.*resy) - tau_nE_tau_y_z/(grad_fact.*resz)) ;
curl_tau_nE_tau_y = (tau_nE_tau_x_z/(grad_fact.*resz) - tau_nE_tau_z_x/(grad_fact.*resx)) ;
curl_tau_nE_tau_z = (tau_nE_tau_y_x/(grad_fact.*resx) - tau_nE_tau_x_y/(grad_fact.*resy)) ;

curl_tau_v_x_B_tau_x = (tau_v_x_B_tau_z_y/(grad_fact.*resy) - tau_v_x_B_tau_y_z/(grad_fact.*resz)) ;
curl_tau_v_x_B_tau_y = (tau_v_x_B_tau_x_z/(grad_fact.*resz) - tau_v_x_B_tau_z_x/(grad_fact.*resx)) ;
curl_tau_v_x_B_tau_z = (tau_v_x_B_tau_y_x/(grad_fact.*resx) - tau_v_x_B_tau_x_y/(grad_fact.*resy)) ;

curl_tau_J_x_B_tau_x = (tau_J_x_B_tau_z_y/(grad_fact.*resy) - tau_J_x_B_tau_y_z/(grad_fact.*resz)) ;
curl_tau_J_x_B_tau_y = (tau_J_x_B_tau_x_z/(grad_fact.*resz) - tau_J_x_B_tau_z_x/(grad_fact.*resx)) ;
curl_tau_J_x_B_tau_z = (tau_J_x_B_tau_y_x/(grad_fact.*resx) - tau_J_x_B_tau_x_y/(grad_fact.*resy)) ;

curl_tau_Div_tau_x = (tau_Div_tau1_z_y/(grad_fact.*resy) - tau_Div_tau1_y_z/(grad_fact.*resz)) ;
curl_tau_Div_tau_y = (tau_Div_tau1_x_z/(grad_fact.*resz) - tau_Div_tau1_z_x/(grad_fact.*resx)) ;
curl_tau_Div_tau_z = (tau_Div_tau1_y_x/(grad_fact.*resx) - tau_Div_tau1_x_y/(grad_fact.*resy)) ;

curl_tau_total_tau_x = -curl_tau_nE_tau_x - curl_tau_v_x_B_tau_x + curl_tau_J_x_B_tau_x + curl_tau_Div_tau_x;
curl_tau_total_tau_y = -curl_tau_nE_tau_y - curl_tau_v_x_B_tau_y + curl_tau_J_x_B_tau_y + curl_tau_Div_tau_y;
curl_tau_total_tau_z = -curl_tau_nE_tau_z - curl_tau_v_x_B_tau_z + curl_tau_J_x_B_tau_z + curl_tau_Div_tau_z;
%--------------------------------------------------------------------------


% Making a histogram to see how the curls contribute
%--------------------------------------------------------------------------
B_filt_mag = sqrt(Bx_filt.^2 + By_filt.^2 + Bz_filt.^2);

curl_tau_nE_tau_mag = sqrt(curl_tau_nE_tau_x.^2 + curl_tau_nE_tau_y.^2 + curl_tau_nE_tau_z.^2);
curl_tau_v_x_B_tau_mag = sqrt(curl_tau_v_x_B_tau_x.^2 + curl_tau_v_x_B_tau_y.^2 + curl_tau_v_x_B_tau_z.^2);
curl_tau_J_x_B_tau_mag = sqrt(curl_tau_J_x_B_tau_x.^2 + curl_tau_J_x_B_tau_y.^2 + curl_tau_J_x_B_tau_z.^2);
curl_tau_Div_tau_mag = sqrt(curl_tau_Div_tau_x.^2 + curl_tau_Div_tau_y.^2 + curl_tau_Div_tau_z.^2);
curl_tau_total_tau_mag = sqrt(curl_tau_total_tau_x.^2 + curl_tau_total_tau_y.^2 + curl_tau_total_tau_z.^2);


B_filt_dot_curl_tau_nE = -(Bx_filt.*curl_tau_nE_tau_x + By_filt.*curl_tau_nE_tau_y ...
    + Bz_filt.*curl_tau_nE_tau_z)./(B_filt_mag.*curl_tau_nE_tau_mag);

B_filt_dot_curl_tau_v_x_B = -(Bx_filt.*curl_tau_v_x_B_tau_x + By_filt.*curl_tau_v_x_B_tau_y ...
    + Bz_filt.*curl_tau_v_x_B_tau_z)./(B_filt_mag.*curl_tau_v_x_B_tau_mag);

B_filt_dot_curl_tau_J_x_B = -(Bx_filt.*curl_tau_J_x_B_tau_x + By_filt.*curl_tau_J_x_B_tau_y ...
    + Bz_filt.*curl_tau_J_x_B_tau_z)./(B_filt_mag.*curl_tau_J_x_B_tau_mag);

B_filt_dot_curl_tau_Div = -(Bx_filt.*curl_tau_Div_tau_x + By_filt.*curl_tau_Div_tau_y ...
    + Bz_filt.*curl_tau_Div_tau_z)./(B_filt_mag.*curl_tau_Div_tau_mag);

B_filt_dot_curl_tau_total = -(Bx_filt.*curl_tau_total_tau_x + By_filt.*curl_tau_total_tau_y ...
    + Bz_filt.*curl_tau_total_tau_z)./(B_filt_mag.*curl_tau_total_tau_mag);


acos_B_filt_dot_curl_tau_nE = acosd(B_filt_dot_curl_tau_nE);
acos_B_filt_dot_curl_tau_v_x_B = acosd(B_filt_dot_curl_tau_v_x_B);
acos_B_filt_dot_curl_tau_J_x_B = acosd(B_filt_dot_curl_tau_J_x_B);
acos_B_filt_dot_curl_tau_Div = acosd(B_filt_dot_curl_tau_Div);
acos_B_filt_dot_curl_tau_total = acosd(B_filt_dot_curl_tau_total);
%--------------------------------------------------------------------------

% Now let's make the histograms

edges = linspace(-1,1,101);
edges2=edges(1:end-1);

[N_tau_nE,edges] = histcounts(B_filt_dot_curl_tau_nE,edges);
[N_tau_v_x_B,edges] = histcounts(B_filt_dot_curl_tau_v_x_B,edges);
[N_tau_J_x_B,edges] = histcounts(B_filt_dot_curl_tau_J_x_B,edges);
[N_tau_Div,edges] = histcounts(B_filt_dot_curl_tau_Div,edges);
[N_tau_total,edges] = histcounts(B_filt_dot_curl_tau_total,edges);


acosedges = linspace(0,180,101);
acosedges2=acosedges(1:end-1);

[N_acos_tau_nE,acosedges] = histcounts(acos_B_filt_dot_curl_tau_nE,acosedges);
[N_acos_tau_v_x_B,acosedges] = histcounts(acos_B_filt_dot_curl_tau_v_x_B,acosedges);
[N_acos_tau_J_x_B,acosedges] = histcounts(acos_B_filt_dot_curl_tau_J_x_B,acosedges);
[N_acos_tau_Div,acosedges] = histcounts(acos_B_filt_dot_curl_tau_Div,acosedges);
[N_acos_tau_total,acosedges] = histcounts(acos_B_filt_dot_curl_tau_total,acosedges);


My_colors = [ 204, 121, 167;
    0, 114, 178;
    128, 128, 128
    213, 94, 0;
    230, 159, 0;
    0, 0, 0;
    86, 180, 233;
    0, 158, 115;
    ]/256;

fs=25;
f666=figure(666);
plot(edges2,N_tau_nE/sum(N_tau_nE),color=My_colors(1,:),LineWidth=1.5) %plot(edges(2:100),Nc,'r')
hold on
plot(edges2,N_tau_v_x_B/sum(N_tau_v_x_B),color=My_colors(2,:),LineWidth=1.5)
plot(edges2,N_tau_J_x_B/sum(N_tau_J_x_B),color=My_colors(3,:),LineWidth=1.5)
plot(edges2,N_tau_Div/sum(N_tau_Div),color=My_colors(5,:),LineWidth=1.5)
plot(edges2,N_tau_total/sum(N_tau_total),color=My_colors(6,:),LineWidth=1.5)
xline(0,'--k')
ylim([0, 0.06])
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
xlabel('$\cos(\theta_{-\overline{B} \cdot \nabla \times \tau_{j}})$','Interpreter','latex','FontSize',20)
ylabel('Normalised Counts','Interpreter','latex','FontSize',fs)
title('$\beta_{i} = 0.25$','Interpreter','latex','FontSize',fs)
legend('$\tau_{nE}$','$\tau_{nu_{i} \times B}$','$\tau_{J \times B}$',...
    '$\tau_{Ine}$', '$\Sigma\tau$','Interpreter','latex','FontSize',20)
hold off

f557=figure(557);
plot(acosedges2,N_acos_tau_nE/sum(N_acos_tau_nE),color=My_colors(1,:),LineWidth=1.5) %plot(edges(2:100),Nc,'r')
hold on
plot(acosedges2,N_acos_tau_v_x_B/sum(N_acos_tau_v_x_B),color=My_colors(2,:),LineWidth=1.5)
plot(acosedges2,N_acos_tau_J_x_B/sum(N_acos_tau_J_x_B),color=My_colors(3,:),LineWidth=1.5)
plot(acosedges2,N_acos_tau_Div/sum(N_acos_tau_Div),color=My_colors(5,:),LineWidth=1.5)
plot(acosedges2,N_acos_tau_total/sum(N_acos_tau_total),color=My_colors(6,:),LineWidth=1.5)
xline(0,'--k')
ylim([0, 0.03])
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
xlabel('$\theta^{\circ}_{-\overline{B} \cdot \nabla \times \tau_{j}}$','Interpreter','latex','FontSize',20)
ylabel('Normalised Counts','Interpreter','latex','FontSize',fs)
title('$\beta_{i} = 0.25$','Interpreter','latex','FontSize',fs)
legend('$\tau_{nE}$','$\tau_{nu_{i} \times B}$','$\tau_{J \times B}$',...
    '$\tau_{Ine}$', '$\Sigma\tau$','Interpreter','latex','FontSize',20)
hold off

%stoppp

%Do an analysis by quartiles
Q1_nE = sum(N_tau_nE(1,1:25))/(256*256*256);
Q2_nE = sum(N_tau_nE(1,26:50))/(256*256*256);
Q3_nE = sum(N_tau_nE(1,51:75))/(256*256*256);
Q4_nE = sum(N_tau_nE(1,76:100))/(256*256*256);

Q1_v_x_B = sum(N_tau_v_x_B(1,1:25))/(256*256*256);
Q2_v_x_B = sum(N_tau_v_x_B(1,26:50))/(256*256*256);
Q3_v_x_B = sum(N_tau_v_x_B(1,51:75))/(256*256*256);
Q4_v_x_B = sum(N_tau_v_x_B(1,76:100))/(256*256*256);

Q1_J_x_B = sum(N_tau_J_x_B(1,1:25))/(256*256*256);
Q2_J_x_B = sum(N_tau_J_x_B(1,26:50))/(256*256*256);
Q3_J_x_B = sum(N_tau_J_x_B(1,51:75))/(256*256*256);
Q4_J_x_B = sum(N_tau_J_x_B(1,76:100))/(256*256*256);

Q1_Div = sum(N_tau_Div(1,1:25))/(256*256*256);
Q2_Div = sum(N_tau_Div(1,26:50))/(256*256*256);
Q3_Div = sum(N_tau_Div(1,51:75))/(256*256*256);
Q4_Div = sum(N_tau_Div(1,76:100))/(256*256*256);

Q1_total = sum(N_tau_total(1,1:25))/(256*256*256);
Q2_total = sum(N_tau_total(1,26:50))/(256*256*256);
Q3_total = sum(N_tau_total(1,51:75))/(256*256*256);
Q4_total = sum(N_tau_total(1,76:100))/(256*256*256);

TT = [Q1_nE, Q2_nE, Q3_nE, Q4_nE;...
    Q1_v_x_B, Q2_v_x_B, Q3_v_x_B, Q4_v_x_B;...
    Q1_J_x_B, Q2_J_x_B, Q3_J_x_B, Q4_J_x_B;...
    Q1_Div, Q2_Div, Q3_Div, Q4_Div;...
    Q1_total, Q2_total, Q3_total, Q4_total]
%}
%--------------------------------------------------------------------------

%{
threshold =pi/resx;

% It is still important to look at the phase.
% maybe repeat the same with the model taus?


%--------------------------------------------------------------------------
% what is left is to compute the phases?


% This is the phasedifferences of the components
%--------------------------------------------------------------------------
%
[phase_diff_B_curl_tau_nE_x,~] = Phase_difference(Bx_filt,-curl_tau_nE_tau_x,Lx,threshold);
[phase_diff_B_curl_tau_nE_y,~] = Phase_difference(By_filt,-curl_tau_nE_tau_y,Lx,threshold);
[phase_diff_B_curl_tau_nE_z,~] = Phase_difference(Bz_filt,-curl_tau_nE_tau_z,Lx,threshold);

[phase_diff_B_curl_tau_v_x_B_x,~] = Phase_difference(Bx_filt,-curl_tau_v_x_B_tau_x,Lx,threshold);
[phase_diff_B_curl_tau_v_x_B_y,~] = Phase_difference(By_filt,-curl_tau_v_x_B_tau_y,Lx,threshold);
[phase_diff_B_curl_tau_v_x_B_z,~] = Phase_difference(Bz_filt,-curl_tau_v_x_B_tau_z,Lx,threshold);

[phase_diff_B_curl_tau_J_x_B_x,~] = Phase_difference(Bx_filt,curl_tau_J_x_B_tau_x,Lx,threshold);
[phase_diff_B_curl_tau_J_x_B_y,~] = Phase_difference(By_filt,curl_tau_J_x_B_tau_y,Lx,threshold);
[phase_diff_B_curl_tau_J_x_B_z,~] = Phase_difference(Bz_filt,curl_tau_J_x_B_tau_z,Lx,threshold);

[phase_diff_B_curl_tau_Div_x,~] = Phase_difference(Bx_filt,curl_tau_Div_tau_x,Lx,threshold);
[phase_diff_B_curl_tau_Div_y,~] = Phase_difference(By_filt,curl_tau_Div_tau_y,Lx,threshold);
[phase_diff_B_curl_tau_Div_z,~] = Phase_difference(Bz_filt,curl_tau_Div_tau_z,Lx,threshold);

[phase_diff_B_curl_tau_total_x,~] = Phase_difference(Bx_filt,curl_tau_total_tau_x,Lx,threshold);
[phase_diff_B_curl_tau_total_y,~] = Phase_difference(By_filt,curl_tau_total_tau_y,Lx,threshold);
[phase_diff_B_curl_tau_total_z,k_bins] = Phase_difference(Bz_filt,curl_tau_total_tau_z,Lx,threshold);

%[phase_diff_sum_tau_M2,k_bins] = Phase_difference(sum_tau_model2,sum_tau,Lx,threshold);
%}

%{
f122 =figure(122);
%-------------------------
subplot(1,5,1)
dump = phase_diff_B_curl_tau_nE_x;
semilogx(k_bins,dump,'-.',color=My_colors(1,:),LineWidth=2)
hold on
dump = phase_diff_B_curl_tau_nE_y;
semilogx(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
dump = phase_diff_B_curl_tau_nE_z;
semilogx(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$kd_i$';
ax.YLabel.String = '$\Delta \phi^{\circ}$';
ax.XTick = [10^0, 10^1];
ax.YTick = [70, 90, 110];
xline(10.64,'--k',LineWidth=1.5)
ylim([70,110])
xlim([0.3,threshold/2])
title('$\tau_{nE}$', 'Interpreter','latex')
hold off
%-------------------------
%-------------------------
subplot(1,5,2)
dump = phase_diff_B_curl_tau_v_x_B_x;
semilogx(k_bins,dump,'-.',color=My_colors(1,:),LineWidth=2)
hold on
dump = phase_diff_B_curl_tau_v_x_B_y;
semilogx(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
dump = phase_diff_B_curl_tau_v_x_B_z;
semilogx(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$kd_i$';
ax.XTick = [10^0, 10^1];
ax.YTick = [70, 90, 110];
xline(10.64,'--k',LineWidth=1.5)
ylim([70,110])
xlim([0.3,threshold/2])
title('$\tau_{nu_{i} \times B}$', 'Interpreter','latex')
hold off
%-------------------------
%-------------------------
subplot(1,5,3)
dump = phase_diff_B_curl_tau_J_x_B_x;
semilogx(k_bins,dump,'-.',color=My_colors(1,:),LineWidth=2)
hold on
dump = phase_diff_B_curl_tau_J_x_B_y;
semilogx(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
dump = phase_diff_B_curl_tau_J_x_B_z;
semilogx(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$kd_i$';
ax.XTick = [10^0, 10^1];
ax.YTick = [70, 90, 110];
xline(10.64,'--k',LineWidth=1.5)
ylim([70,110])
xlim([0.3,threshold/2])
title('$\tau_{J \times B}$', 'Interpreter','latex')
hold off
%-------------------------
%-------------------------
subplot(1,5,4)
dump = phase_diff_B_curl_tau_Div_x;
semilogx(k_bins,dump,'-.',color=My_colors(1,:),LineWidth=2)
hold on
dump = phase_diff_B_curl_tau_Div_y;
semilogx(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
dump = phase_diff_B_curl_tau_Div_z;
semilogx(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$kd_i$';
ax.XTick = [10^0, 10^1];
ax.YTick = [70, 90, 110];
xline(10.64,'--k',LineWidth=1.5)
ylim([70,110])
xlim([0.3,threshold/2])
title('$\tau_{\nabla \cdot (u_{i}J + Ju_{i} -JJ/ne)}$', 'Interpreter','latex')
hold off
%-------------------------
%-------------------------
subplot(1,5,5)
dump = phase_diff_B_curl_tau_total_x;
semilogx(k_bins,dump,'-.',color=My_colors(1,:),LineWidth=2)
hold on
dump = phase_diff_B_curl_tau_total_y;
semilogx(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
dump = phase_diff_B_curl_tau_total_z;
semilogx(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$kd_i$';
ax.XTick = [10^0, 10^1];
ax.YTick = [70, 90, 110];
xline(10.64,'--k',LineWidth=1.5)
%    xline(5.34,'--k',LineWidth=1)
ylim([70,110])
xlim([0.3,threshold/2])
legend('$(Bx, -\nabla \times \tau_{x})$', ...
    '$(By, -\nabla \times \tau_{y})$',...
    '$(Bz, -\nabla \times \tau_{z})$',...
    'Interpreter','latex','NumColumns',1,'Location','southeastoutside')
title('$\Sigma \tau$', 'Interpreter','latex')
hold off
%}
%-------------------------
%--------------------------------------------------------------------------

% This is the pahse difference of the vectors
%--------------------------------------------------------------------------

% Tis is the phase difference with the curl to see how the anomalous terms
% contribute to the generation of magnetic field
%--------------------------------------------------------------------------
% 
%<---- this is where the latest phase analysis is 25/03/2026

%Making arrays of random numbers to see how the phase diff behaves


%{
[phase_diff_B_curl_tau_nE,~] = Phase_difference3D(Bx_filt,By_filt,Bz_filt, ...
    curl_tau_nE_tau_x,curl_tau_nE_tau_y,curl_tau_nE_tau_z,Lx,threshold);

[phase_diff_B_curl_tau_v_x_B,~] = Phase_difference3D(Bx_filt,By_filt,Bz_filt, ...
    curl_tau_v_x_B_tau_x,curl_tau_v_x_B_tau_y,curl_tau_v_x_B_tau_z,Lx,threshold);

[phase_diff_B_curl_tau_J_x_B,~] = Phase_difference3D(Bx_filt,By_filt,Bz_filt, ...
    -curl_tau_J_x_B_tau_x,-curl_tau_J_x_B_tau_y,-curl_tau_J_x_B_tau_z,Lx,threshold);

[phase_diff_B_curl_tau_Div,~] = Phase_difference3D(Bx_filt,By_filt,Bz_filt, ...
    -curl_tau_Div_tau_x,-curl_tau_Div_tau_y,-curl_tau_Div_tau_z,Lx,threshold);

[phase_diff_B_curl_tau_total,k_bins] = Phase_difference3D(Bx_filt,By_filt,Bz_filt, ...
    -curl_tau_total_tau_x,-curl_tau_total_tau_y,-curl_tau_total_tau_z,Lx,threshold);
%--------------------------------------------------------------------------

% this is directly between tau and the resolved electric field 
%--------------------------------------------------------------------------
[phase_diff_E_tau_nE,~] = Phase_difference3D(Ex_filt,Ey_filt,Ez_filt, ...
    -tau_nE_tau_x,-tau_nE_tau_y,-tau_nE_tau_z,Lx,threshold);

[phase_diff_E_tau_v_x_B,~] = Phase_difference3D(Ex_filt,Ey_filt,Ez_filt, ...
    -tau_v_x_B_tau_x,-tau_v_x_B_tau_y,-tau_v_x_B_tau_z,Lx,threshold);

[phase_diff_E_tau_J_x_B,~] = Phase_difference3D(Ex_filt,Ey_filt,Ez_filt, ...
    tau_J_x_B_tau_x,tau_J_x_B_tau_y,tau_J_x_B_tau_z,Lx,threshold);

[phase_diff_E_tau_Div,~] = Phase_difference3D(Ex_filt,Ey_filt,Ez_filt, ...
    tau_Div_tau1_x,tau_Div_tau1_y,tau_Div_tau1_z,Lx,threshold);

[phase_diff_E_tau_total,k_bins] = Phase_difference3D(Ex_filt,Ey_filt,Ez_filt, ...
    tau_total_x,tau_total_y,tau_total_z,Lx,threshold);

%--------------------------------------------------------------------------
% Make the phase difference plot now






fs=25; 
%x0=45;y0=54;xx1=1400;yy1=500;
x0=45;y0=54;xx1=900;yy1=500;
f122 =figure(122);
set(gcf,'position',[x0,y0,xx1,yy1])
%-------------------------
subplot(2,1,1)
dump = phase_diff_E_tau_nE;
semilogx(k_bins,dump,'-.',color=My_colors(1,:),LineWidth=2)
hold on
dump = phase_diff_E_tau_v_x_B;
semilogx(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
dump = phase_diff_E_tau_J_x_B;
semilogx(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
dump = phase_diff_E_tau_Div;
semilogx(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=2)
dump = phase_diff_E_tau_total;
semilogx(k_bins,dump,'-.',color=My_colors(6,:),LineWidth=2)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$kd_i$';
%ax.YLabel.String = '$\Delta \phi^{\circ} (\mathbf{E},\tau)$';
title('$\Delta \phi^{\circ} (\overline{\mathbf{E}},\tau_{\nu})$','Interpreter','latex',FontSize=fs);
ax.XTick = [10^0, 10^1];
ax.YTick = [70, 90, 110];
xline(1*pi/(sqrt(12)*0.28),'k--', LineWidth=1.5)

    yline(90,'--')
    ylim([70,110])

    xline(10,'--')
    xline(1,'--')
xlim([0.3,threshold/2])
%title('$\tau_{nE}$', 'Interpreter','latex')
legend('$-\tau_{nE}$','-$\tau_{nu_{i} \times B}$','$\tau_{J \times B}$','$ \tau_{Ine}$','$ \Sigma \tau$', ...
    'Interpreter','latex','NumColumns',5,'Location','southoutside')
hold off
%-------------------------

%-------------------------
subplot(2,1,2)
dump = phase_diff_B_curl_tau_nE;
semilogx(k_bins,dump,'-.',color=My_colors(1,:),LineWidth=2)
hold on
dump = phase_diff_B_curl_tau_v_x_B;
semilogx(k_bins,dump,'-.',color=My_colors(2,:),LineWidth=2)
dump = phase_diff_B_curl_tau_J_x_B;
semilogx(k_bins,dump,'-.',color=My_colors(3,:),LineWidth=2)
dump = phase_diff_B_curl_tau_Div;
semilogx(k_bins,dump,'-.',color=My_colors(5,:),LineWidth=2)
dump = phase_diff_B_curl_tau_total;
semilogx(k_bins,dump,'-.',color=My_colors(6,:),LineWidth=2)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$kd_i$';
%ax.YLabel.String = '$\Delta \phi^{\circ} (\mathbf{B},-\nabla \times \tau)$';
title('$\Delta \phi^{\circ} (\overline{\mathbf{B}},-\nabla \times \tau_{\nu})$','Interpreter','latex',FontSize=fs);
ax.XTick = [10^0, 10^1];
ax.YTick = [70, 90, 110];
xline(1*pi/(sqrt(12)*0.28),'k--', LineWidth=1.5)
    yline(90,'--')
    ylim([70,110])

    xline(10,'--')
    xline(1,'--')
xlim([0.3,threshold/2])
%title('$\tau_{nE}$', 'Interpreter','latex')
legend('$-\tau_{nE}$','$-\tau_{nu_{i} \times B}$','$\tau_{J \times B}$','$ \tau_{Ine}$','$ \Sigma \tau$', ...
    'Interpreter','latex','NumColumns',5,'Location','southoutside')
hold off
%}
%-------------------------

%} %<---------------------------------- here ends the bloque of the plots
%with the phase coherence




%--------------------------------------------------------------------------
%stoopp
%--------------------------------------------------------------------------

% Now this is to compute the total amplitude

in = 1;
%in=1;
if rms_value==0

    % This is average of th absolute value <sqrt(Ex^2 + Ey^2 + Ez^2)>;
    %----------------------------------------------------------------------
    term1_filt = sqrt(term1_filt_x.^2 + term1_filt_y.^2 + term1_filt_z.^2) ;
    term2_filt = sqrt(term2_filt_x.^2 + term2_filt_y.^2 + term2_filt_z.^2) ;
    term3_filt = sqrt(term3_filt_x.^2 + term3_filt_y.^2 + term3_filt_z.^2) ;
    term4_filt = sqrt(term4_filt_x.^2 + term4_filt_y.^2 + term4_filt_z.^2) ;
    term5_filt = sqrt(term5_filt_x.^2 + term5_filt_y.^2 + term5_filt_z.^2) ;
    term7_filt = sqrt(term7_filt_x.^2 + term7_filt_y.^2 + term7_filt_z.^2) ;

    tau_nE_tau = sqrt(tau_nE_tau_x.^2 + tau_nE_tau_y.^2 + tau_nE_tau_z.^2) ;
    tau_v_x_B_tau = sqrt(tau_v_x_B_tau_x.^2 + tau_v_x_B_tau_y.^2 + tau_v_x_B_tau_z.^2) ;
    tau_J_x_B_tau = sqrt(tau_J_x_B_tau_x.^2 + tau_J_x_B_tau_y.^2 + tau_J_x_B_tau_z.^2) ;
    tau_Div_tau1 = sqrt(tau_Div_tau1_x.^2 + tau_Div_tau1_y.^2 + tau_Div_tau1_z.^2) ;
    tau_total = sqrt(tau_total_x.^2 + tau_total_y.^2 + tau_total_z.^2) ;

    % The idea for the new analysis is to plot the <SGSMhD>rms/<MHD>rms
    % This analysis should be done with the three components not just one

    % The idea of this is to compute relative importance with absolute values
    if absolute==1
        %-----------------------------------------------------------------------
        MHD_E_mean = mean(abs(term1_filt),'all');
        MHD_vxB_mean = mean(abs(term2_filt),'all');
        MHD_JxB_mean = mean(abs(term3_filt),'all');
        MHD_divP_mean = mean(abs(term4_filt),'all');
        MHD_divvJall_mean = mean(abs(term5_filt),'all');
        MHD_RHS_mean = mean(abs(term7_filt),'all');

        SGS_tau_nE_mean = mean(abs(tau_nE_tau),'all');
        SGS_tau_vxB_mean = mean(abs(tau_v_x_B_tau),'all');
        SGS_tau_JxB_mean = mean(abs(tau_J_x_B_tau),'all');
        SGS_tau_Div_mean = mean(abs(tau_Div_tau1),'all');
        SGS_tau_total_mean = mean(abs(tau_total),'all');

        MHD_E2vxB_mean(1,in) = MHD_E_mean;
        MHD_vxB2vxB_mean(1,in) = MHD_vxB_mean;
        MHD_JxB2vxB_mean(1,in) = MHD_JxB_mean;
        MHD_divP2vxB_mean(1,in) = MHD_divP_mean;
        MHD_divvJall2vxB_mean(1,in) = MHD_divvJall_mean;
        MHD_RHS2vxB_mean(1,in) = MHD_RHS_mean;

        SGS_tau_nE_mean2vxB_mean(1,in) = SGS_tau_nE_mean;
        SGS_tau_vxB_mean2vxB_mean(1,in) = SGS_tau_vxB_mean;
        SGS_tau_JxB_mean2vxB_mean(1,in) = SGS_tau_JxB_mean;
        SGS_tau_Div_mean2vxB_mean(1,in) = SGS_tau_Div_mean;
        SGS_tau_total_mean2vxB_mean(1,in) = SGS_tau_total_mean;

        %-----------------------------------------------------------------------
    elseif absolute==0

        % The idea of this is to compute relative importance with NO absolute values
        %-----------------------------------------------------------------------
        MHD_E_mean = mean((term1_filt),'all');
        MHD_vxB_mean = mean((term2_filt),'all');
        MHD_JxB_mean = mean((term3_filt),'all');
        MHD_divP_mean = mean((term4_filt),'all');
        MHD_divvJall_mean = mean((term5_filt),'all');
        MHD_RHS_mean = mean(abs(term7_filt),'all');

        SGS_tau_nE_mean = mean((tau_nE_tau),'all');
        SGS_tau_vxB_mean = mean((tau_v_x_B_tau),'all');
        SGS_tau_JxB_mean = mean((tau_J_x_B_tau),'all');
        SGS_tau_Div_mean = mean((tau_Div_tau1),'all');
        SGS_tau_total_mean = mean((tau_total),'all');

        MHD_E2vxB_mean(1,in) = MHD_E_mean;
        MHD_vxB2vxB_mean(1,in) = MHD_vxB_mean;
        MHD_JxB2vxB_mean(1,in) = MHD_JxB_mean;
        MHD_divP2vxB_mean(1,in) = MHD_divP_mean;
        MHD_divvJall2vxB_mean(1,in) = MHD_divvJall_mean;
        MHD_RHS2vxB_mean(1,in) = MHD_RHS_mean;

        SGS_tau_nE_mean2vxB_mean(1,in) = SGS_tau_nE_mean;
        SGS_tau_vxB_mean2vxB_mean(1,in) = SGS_tau_vxB_mean;
        SGS_tau_JxB_mean2vxB_mean(1,in) = SGS_tau_JxB_mean;
        SGS_tau_Div_mean2vxB_mean(1,in) = SGS_tau_Div_mean;
        SGS_tau_total_mean2vxB_mean(1,in) = SGS_tau_total_mean;
        %-----------------------------------------------------------------------

    end
    %----------------------------------------------------------------------

elseif rms_value == 1
    % This is sqrt( <Ex^2 + Ey^2 + Ez^2 >);
    %----------------------------------------------------------------------
    term1_filt = term1_filt_x.^2 + term1_filt_y.^2 + term1_filt_z.^2 ;
    term2_filt = term2_filt_x.^2 + term2_filt_y.^2 + term2_filt_z.^2 ;
    term3_filt = term3_filt_x.^2 + term3_filt_y.^2 + term3_filt_z.^2 ;
    term4_filt = term4_filt_x.^2 + term4_filt_y.^2 + term4_filt_z.^2 ;
    term5_filt = term5_filt_x.^2 + term5_filt_y.^2 + term5_filt_z.^2 ;
    term7_filt = term7_filt_x.^2 + term7_filt_y.^2 + term7_filt_z.^2 ;

    tau_nE_tau = tau_nE_tau_x.^2 + tau_nE_tau_y.^2 + tau_nE_tau_z.^2 ;
    tau_v_x_B_tau = tau_v_x_B_tau_x.^2 + tau_v_x_B_tau_y.^2 + tau_v_x_B_tau_z.^2 ;
    tau_J_x_B_tau = tau_J_x_B_tau_x.^2 + tau_J_x_B_tau_y.^2 + tau_J_x_B_tau_z.^2 ;
    tau_Div_tau1 = tau_Div_tau1_x.^2 + tau_Div_tau1_y.^2 + tau_Div_tau1_z.^2 ;
    tau_total = tau_total_x.^2 + tau_total_y.^2 + tau_total_z.^2 ;

    % The idea for the new analysis is to plot the <SGSMhD>rms/<MHD>rms
    % This analysis should be done with the three components not just one

    % The idea of this is to compute relative importance with absolute values
    
    if absolute==1
        %-----------------------------------------------------------------------
        MHD_E_mean = sqrt(mean(abs(term1_filt),'all'));
        MHD_vxB_mean = sqrt(mean(abs(term2_filt),'all'));
        MHD_JxB_mean = sqrt(mean(abs(term3_filt),'all'));
        MHD_divP_mean = sqrt(mean(abs(term4_filt),'all'));
        MHD_divvJall_mean = sqrt(mean(abs(term5_filt),'all'));
        MHD_RHS_mean = sqrt(mean(abs(term7_filt),'all'));

        SGS_tau_nE_mean = sqrt(mean(abs(tau_nE_tau),'all'));
        SGS_tau_vxB_mean = sqrt(mean(abs(tau_v_x_B_tau),'all'));
        SGS_tau_JxB_mean = sqrt(mean(abs(tau_J_x_B_tau),'all'));
        SGS_tau_Div_mean = sqrt(mean(abs(tau_Div_tau1),'all'));
        SGS_tau_total_mean = sqrt(mean(abs(tau_total),'all'));

        MHD_E2vxB_mean(1,in) = MHD_E_mean;
        MHD_vxB2vxB_mean(1,in) = MHD_vxB_mean;
        MHD_JxB2vxB_mean(1,in) = MHD_JxB_mean;
        MHD_divP2vxB_mean(1,in) = MHD_divP_mean;
        MHD_divvJall2vxB_mean(1,in) = MHD_divvJall_mean;
        MHD_RHS2vxB_mean(1,in) = MHD_RHS_mean;

        SGS_tau_nE_mean2vxB_mean(1,in) = SGS_tau_nE_mean;
        SGS_tau_vxB_mean2vxB_mean(1,in) = SGS_tau_vxB_mean;
        SGS_tau_JxB_mean2vxB_mean(1,in) = SGS_tau_JxB_mean;
        SGS_tau_Div_mean2vxB_mean(1,in) = SGS_tau_Div_mean;
        SGS_tau_total_mean2vxB_mean(1,in) = SGS_tau_total_mean;

        %-----------------------------------------------------------------------
    elseif absolute==0

        % The idea of this is to compute relative importance with NO absolute values
        %-----------------------------------------------------------------------
        MHD_E_mean = sqrt(mean((term1_filt),'all'));
        MHD_vxB_mean = sqrt(mean((term2_filt),'all'));
        MHD_JxB_mean = sqrt(mean((term3_filt),'all'));
        MHD_divP_mean = sqrt(mean((term4_filt),'all'));
        MHD_divvJall_mean = sqrt(mean((term5_filt),'all'));
        MHD_RHS_mean = sqrt(mean(abs(term7_filt),'all'));

        SGS_tau_nE_mean = sqrt(mean((tau_nE_tau),'all'));
        SGS_tau_vxB_mean = sqrt(mean((tau_v_x_B_tau),'all'));
        SGS_tau_JxB_mean = sqrt(mean((tau_J_x_B_tau),'all'));
        SGS_tau_Div_mean = sqrt(mean((tau_Div_tau1),'all'));
        SGS_tau_total_mean = sqrt(mean((tau_total),'all'));

        MHD_E2vxB_mean(1,in) = MHD_E_mean;
        MHD_vxB2vxB_mean(1,in) = MHD_vxB_mean;
        MHD_JxB2vxB_mean(1,in) = MHD_JxB_mean;
        MHD_divP2vxB_mean(1,in) = MHD_divP_mean;
        MHD_divvJall2vxB_mean(1,in) = MHD_divvJall_mean;
        MHD_RHS2vxB_mean(1,in) = MHD_RHS_mean;

        SGS_tau_nE_mean2vxB_mean(1,in) = SGS_tau_nE_mean;
        SGS_tau_vxB_mean2vxB_mean(1,in) = SGS_tau_vxB_mean;
        SGS_tau_JxB_mean2vxB_mean(1,in) = SGS_tau_JxB_mean;
        SGS_tau_Div_mean2vxB_mean(1,in) = SGS_tau_Div_mean;
        SGS_tau_total_mean2vxB_mean(1,in) = SGS_tau_total_mean;
        %-----------------------------------------------------------------------

    end
J_mean_mag(1,in) = mean(sqrt(Jx_dt.^2 + Jy_dt.^2 + Jz_dt.^2),'all');
J_max_mag(1,in) = max( max( max( sqrt(Jx_dt.^2 + Jy_dt.^2 + Jz_dt.^2))));
J_rms(1,in) = sqrt(mean((Jx_dt.^2 + Jy_dt.^2 + Jz_dt.^2),'all'));

end

% Table of relatives values

% clearvars MHD_E_mean MHD_vxB_mean...
%     MHD_JxB_mean MHD_divP_mean ...
% MHD_divvJall_mean SGS_tau_nE_mean ...
% SGS_tau_vxB_mean SGS_tau_JxB_mean...
% SGS_tau_Div_mean SGS_tau_total_mean


AA = MHD_E2vxB_mean(1,in);
BB = MHD_vxB2vxB_mean(1,in);
CC = MHD_JxB2vxB_mean(1,in);
DD = MHD_divP2vxB_mean(1,in);
EE = MHD_divvJall2vxB_mean(1,in);
FF = MHD_RHS2vxB_mean(1,in);

AS = SGS_tau_nE_mean2vxB_mean(1,in);
BS = SGS_tau_vxB_mean2vxB_mean(1,in);
CS = SGS_tau_JxB_mean2vxB_mean(1,in);
ES = SGS_tau_Div_mean2vxB_mean(1,in);
FS = SGS_tau_total_mean2vxB_mean(1,in);

JJ_mag = J_mean_mag(1,in);
JJ_max = J_max_mag(1,in);
JJ_rms = J_rms(1,in);

T = table([AA;AS],[BB;BS],[CC;CS],[DD;0],[EE;ES],[FF;FS],[JJ_rms;JJ_max],...
    'VariableNames',{'E','vxB','JxB','divP','divvJ','RHS','J_rms_mag_max'},'RowName',{'Resolved','Unresolved'});


disp(T)



%end

%--------------------------------------------------------------------------
%grid_dt = info.Groups(20).Attributes;
%dt = double(grid_dt(15).Value); %this is in omega_pe
%str = string(S(in).name);
%newstr = extractBetween(str,"pfd.","_p000000.h5");
%N_steps = str2double(newstr);
%time = dt*N_steps/sqrt(mime); % This is in omega pi^-1
%time_nl = time/Tau_nl; % This time nonlinear
%time_in = linspace(0,time_nl,N2);
%--------------------------------------------------------------------------


time_in = 1;

%comment%{

%comment
%}


%{

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

%time_in = linspace(1,21,Nf);
fs=18;

fs=16; x0=45;y0=54;xx1=1000;yy1=400;
if absolute==1
    f34 = figure(34);
    set(gcf,'position',[x0,y0,xx1,yy1])
    plot(time_in,MHD_JxB2vxB_mean,'og',LineWidth=2)
    hold on
    plot(time_in,MHD_divP2vxB_mean,'om',LineWidth=2)
    plot(time_in,MHD_divvJall2vxB_mean,'oc',LineWidth=2)
    plot(time_in,MHD_RHS2vxB_mean,'-k',LineWidth=2)
    plot(time_in,SGS_tau_nE_mean2vxB_mean,'+r',LineWidth=2)
    plot(time_in,SGS_tau_vxB_mean2vxB_mean,'+b',LineWidth=2)
    plot(time_in,SGS_tau_JxB_mean2vxB_mean,'+g',LineWidth=2)
    plot(time_in,SGS_tau_Div_mean2vxB_mean,'+c',LineWidth=2)
    plot(time_in,SGS_tau_total_mean2vxB_mean,'*k',LineWidth=2)
    legend(legendsgsmhd,'FontSize',fs,'Interpreter','latex','NumColumns',1,'Location','northeastoutside')
    xlabel('$t/t_{nl}$','FontSize',fs,Interpreter='latex')
    hold off

    f35 = figure(35);
    set(gcf,'position',[x0,y0,xx1,yy1])
    semilogy(time_in,MHD_JxB2vxB_mean,'og',LineWidth=2)
    hold on
    semilogy(time_in,MHD_divP2vxB_mean,'om',LineWidth=2)
    semilogy(time_in,MHD_divvJall2vxB_mean,'oc',LineWidth=2)
    semilogy(time_in,MHD_RHS2vxB_mean,'-k',LineWidth=2)
    semilogy(time_in,SGS_tau_nE_mean2vxB_mean,'+r',LineWidth=2)
    semilogy(time_in,SGS_tau_vxB_mean2vxB_mean,'+b',LineWidth=2)
    semilogy(time_in,SGS_tau_JxB_mean2vxB_mean,'+g',LineWidth=2)
    semilogy(time_in,SGS_tau_Div_mean2vxB_mean,'+c',LineWidth=2)
    semilogy(time_in,SGS_tau_total_mean2vxB_mean,'*k',LineWidth=2)
    legend(legendsgsmhd,'FontSize',fs,'Interpreter','latex','NumColumns',1,'Location','northeastoutside')
    xlabel('$t/t_{nl}$','FontSize',fs,Interpreter='latex')
    hold off
elseif absolute==0

    f34 = figure(34);
    set(gcf,'position',[x0,y0,xx1,yy1])
    dummy = (MHD_E2vxB_mean./MHD_vxB2vxB_mean);
    plot(time_in,dummy,'or',LineWidth=2)
    hold on

    dummy = (MHD_vxB2vxB_mean)./MHD_vxB2vxB_mean;
    plot(time_in,dummy,'ob',LineWidth=2)

    dummy = (MHD_JxB2vxB_mean)./MHD_vxB2vxB_mean;
    plot(time_in,dummy,'og',LineWidth=2)

    dummy = (MHD_divP2vxB_mean)./MHD_vxB2vxB_mean;
    plot(time_in,dummy,'om',LineWidth=2)

    dummy = (MHD_divvJall2vxB_mean)./MHD_vxB2vxB_mean;
    plot(time_in,dummy,'oc',LineWidth=2)

    dummy = (MHD_RHS2vxB_mean)./MHD_vxB2vxB_mean;
    plot(time_in,dummy,'-k',LineWidth=2)

    dummy = (SGS_tau_nE_mean2vxB_mean)./MHD_vxB2vxB_mean;
    plot(time_in,dummy,'+r',LineWidth=2)

    dummy = (SGS_tau_vxB_mean2vxB_mean)./MHD_vxB2vxB_mean;
    plot(time_in,dummy,'+b',LineWidth=2)

    dummy = (SGS_tau_JxB_mean2vxB_mean)./MHD_vxB2vxB_mean;
    plot(time_in,dummy,'+g',LineWidth=2)

    dummy = (SGS_tau_Div_mean2vxB_mean)./MHD_vxB2vxB_mean;
    plot(time_in,dummy,'+c',LineWidth=2)

    dummy = (SGS_tau_total_mean2vxB_mean)./MHD_vxB2vxB_mean;
    plot(time_in,dummy,'*k',LineWidth=2)

    legend(legendsgsmhd_1,'FontSize',fs,'Interpreter','latex','NumColumns',1,'Location','northeastoutside')
    xlabel('$t/t_{nl}$','FontSize',fs,Interpreter='latex')
    %ylabel('$log (1 - |<.>|)$','FontSize',fs,Interpreter='latex')
    %ylim([-5e-6, 5e-6])
    hold off

    f35 = figure(35);
    set(gcf,'position',[x0,y0,xx1,yy1])
    dummy = (MHD_E2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'or',LineWidth=2)
    hold on

    dummy = (MHD_vxB2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'ob',LineWidth=2)

    dummy = (MHD_JxB2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'og',LineWidth=2)

    dummy = (MHD_divP2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'om',LineWidth=2)

    dummy = (MHD_divvJall2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'oc',LineWidth=2)

    dummy = (MHD_RHS2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'-k',LineWidth=2)

    dummy = (SGS_tau_nE_mean2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'+r',LineWidth=2)

    dummy = (SGS_tau_vxB_mean2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'+b',LineWidth=2)

    dummy = (SGS_tau_JxB_mean2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'+g',LineWidth=2)

    dummy = (SGS_tau_Div_mean2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'+c',LineWidth=2)

    dummy = (SGS_tau_total_mean2vxB_mean);
    plot(time_in,sign(dummy).*log10(abs(dummy)),'*k',LineWidth=2)

    legend(legendsgsmhd_0,'FontSize',fs,'Interpreter','latex','NumColumns',1,'Location','northeastoutside')
    xlabel('$t/t_{nl}$','FontSize',fs,Interpreter='latex')
    ylabel('$sgn(|<.>|) * log (|<.>|)$','FontSize',fs,Interpreter='latex')
    %ylim([-10, 10])
    hold off

    f37 = figure(37);
    set(gcf,'position',[x0,y0,xx1,yy1])
    semilogy(time_in,MHD_JxB2vxB_mean./MHD_vxB2vxB_mean,'og',LineWidth=2)
    hold on
    semilogy(time_in,MHD_divP2vxB_mean./MHD_vxB2vxB_mean,'om',LineWidth=2)
    semilogy(time_in,MHD_divvJall2vxB_mean./MHD_vxB2vxB_mean,'oc',LineWidth=2)
    semilogy(time_in,MHD_RHS2vxB_mean./MHD_vxB2vxB_mean,'-k',LineWidth=2)
    semilogy(time_in,SGS_tau_nE_mean2vxB_mean./MHD_vxB2vxB_mean,'+r',LineWidth=2)
    semilogy(time_in,SGS_tau_vxB_mean2vxB_mean./MHD_vxB2vxB_mean,'+b',LineWidth=2)
    semilogy(time_in,SGS_tau_JxB_mean2vxB_mean./MHD_vxB2vxB_mean,'+g',LineWidth=2)
    semilogy(time_in,SGS_tau_Div_mean2vxB_mean./MHD_vxB2vxB_mean,'+c',LineWidth=2)
    semilogy(time_in,SGS_tau_total_mean2vxB_mean./MHD_vxB2vxB_mean,'*k',LineWidth=2)
    legend(legendsgsmhd,'FontSize',fs,'Interpreter','latex','NumColumns',1,'Location','northeastoutside')
    xlabel('$t/t_{nl}$','FontSize',fs,Interpreter='latex')
    hold off


end
%}

%f_path
%{
cd(f_path)

if absolute==1
    saveas(f34,strcat(num2str(i),'relatives_terms_time_abs.png'));
    saveas(f35,strcat(num2str(i),'relatives_terms_time_abs_log.png'));
elseif absolute==0
    saveas(f34,strcat(num2str(i),'relatives_terms_time.png'));
    saveas(f35,strcat(num2str(i),'relatives_terms_time_log.png'));
    saveas(f36,strcat(num2str(i),'relatives_terms_time_abs.png'));
end
%}

% % %T = table([1;5],[2;6],[3;7],[4;8],[],'VariableNames',{'JxB','divP','C','D'},'RowName',{'MHD','SGS/MHD'});
% %
% %
% %



%%
%%%
% Defining the functions to use in this script
%----------------------------------------------------------------------

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
        
        %C = fgcon(mask); % <---- this has the problem of unstable for
        %random
        %spec_phi1(k) = rad2deg(angle(mean(C)));

    end
end

E_k = spec_phi1;

end


function [E_k,k_bins]=Phase_difference(uxB,tauuxB,Lx,threshold)
% Detrend the variable
Bx_dt_DT = uxB - mean(uxB,'all');
Bx_dt_DT2 = tauuxB - mean(tauuxB,'all');

% Perform the FFT of the 3D field B
F_B = fftn(Bx_dt_DT);
F_B2 = fftn(Bx_dt_DT2);
fgcon = F_B.*conj(F_B2);

%%% --- Phase differences in Fourier space ---
phi1 = angle(F_B2) - angle(F_B);
% wrap to [-pi, pi]
phi1 = atan2(sin(phi1), cos(phi1));
phi1 = rad2deg(phi1);

Ns=size(uxB);
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
k_max = threshold; %max(K(:)); % Maximum wavenumber
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

% % Plot the omnidirectional spectrum
% figure;
% loglog(k_bins(1:end-1), E_k(1:end-1), 'LineWidth', 1.5);
% title('1D Omnidirectional Spectrum');
% xlabel('k');
% ylabel('E(k)');

%{
% Calculate the energy spectrum
phasediff = atan (abs( imag(fgcon)./real(fgcon))); %removin
phasediff = rad2deg(phasediff);
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
    E_k(i) = mean(phasediff(indices));
end
% Normalize the spectrum by the bin width
E_k = E_k / dk;
%}

end
%--------------------------------------------------------------------------




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


% Funtion to make the filtering
%----------------------------------------------------------------------
function [convolution_result]=Filtering_kernel(var,l_wind)
%----------------------------------------------------------------------
% The inputs are the variable, the fourier transform of the kernel and
% the output is the filted signal
% These four lines are the filtering

%----------------------------------------------------------------------
% Perform the FFT of the function f
F_var = fftn(var);
F_var = fftshift(fftshift(fftshift(F_var,1),2),3);

% Convolve in the frequency domain (element-wise multiplication)
l_wind = fftshift(fftshift(fftshift(l_wind,1),2),3);
F_convolution = F_var .* l_wind;
F_convolution = fftshift(fftshift(fftshift(F_convolution,1),2),3);

% Perform the inverse FFT to get the convolved function
convolution_result = ifftn(F_convolution);

% Ensure the result is real (the imaginary part should be very small due to numerical errors)
convolution_result = real(convolution_result);
%----------------------------------------------------------------------
end

%----------------------------------------------------------------------


% This is better as a function to make the filter and the associated
% spectrum easier to compute.
function [P2D,kpar,kper,kz]=Power_of_filtering_kernel(Bx,Lx,Ly,Lz)
%----------------------------------------------------------------------
Bx_dt_DT = Bx - mean(Bx,'all');

% Perform the FFT of the 3D field B
F_Bx = fftn(Bx_dt_DT);

%Shift the ffts
F_Bx_shift = fftshift(fftshift(fftshift(F_Bx,1),2),3);
%F_Bx_shift = F_Bx;

%Get the amplitudes
F_f_shift_amp = F_Bx_shift .* conj(F_Bx_shift);

%l_wind_shift = fftshift(fftshift(fftshift(l_wind,1),2),3);
%F_g_shift_amp = l_wind_shift .* conj(l_wind_shift);
%convolution_shift = fftshift(fftshift(fftshift(F_convolution,1),2),3);
%convolution_result_amp = convolution_shift .* conj(convolution_shift);

ff=F_f_shift_amp;
Ns=size(ff);

kx=((0:Ns(1)-1)-Ns(1)/2).*2*pi/Lx; %Includes negative wavenumbers
ky=((0:Ns(2)-1)-Ns(2)/2).*2*pi/Ly;
kz=((0:Ns(3)-1)-Ns(3)/2).*2*pi/Lz;

kp = zeros(Ns(1),Ns(2));
kp2 = zeros(1,Ns(3));
for j=1:Ns(2)
    for i=1:Ns(1)
        %--------------------------------------------------------------------------
        kp(i,j)=sqrt(ky(j).^2 + kx(i).^2); %Calculate kperp array with negative wavenumbers
        %--------------------------------------------------------------------------
        %kp(i,j)=sqrt(ky(j).^2); %This is for the case of the 2D harris
        %configuration
        %--------------------------------------------------------------------------
    end
end
for k=1:size(ff,3)
    kp2(k)=abs(kz(k)); %Calculate kpar vector with negative wavenumbers
end

%Calculate kpar and kperp for 2D spectrum:
dkpar=kz(2)-kz(1);
nkpar=fix(max(max(kz))/dkpar)+1;
kpar=(0:nkpar-1).*dkpar;

dkper=ky(2)-ky(1);
nkper=fix(max(max(kp))/dkper)+1;
kper=(0:nkper-1).*dkper;

%Use linear interpolation to intergrate in concentric circles of k_perp:

%Initialise arrays:
Ptemp=zeros(size(ff,3),nkper); %old kper vs. new kper
P2D=zeros(nkpar,nkper); %kpar vs. kper

Nkper=zeros(size(ff,3),nkper);

i1=fix(kp/dkper); %Index linking kp with each kper value. Index of the cells
i2=i1+1; % indexes of next cells
i3=fix(kp2/dkpar); %Index linking kp2 with each kpar value

k2=kp/dkper-i1; % this is calculating basically the residuo. kp is a matrix
k1=1-k2;

for k= 1:size(ff,3) %For each value of kpar, integrate over rings of kper
    P1=k1.*ff(:,:,k); %For interpolation
    P2=k2.*ff(:,:,k);
    for j=1:size(ff,2) %Cycle through every grid point in x-y plane
        for i=1:size(ff,1)
            if(i2(i,j) < nkper)
                %Use linear interpolation to sum up power to surrounding
                %rings of kper:
                Ptemp(k,i2(i,j)+1)=Ptemp(k,i2(i,j)+1)+P2(i,j); %Interpolate power to next ring
                Ptemp(k,i1(i,j)+1)=Ptemp(k,i1(i,j)+1)+P1(i,j); %Interpolate power to previous ring

                %Update number of points interpolated for each ring:
                Nkper(i2(i,j)+1)=Nkper(i2(i,j)+1)+k2(i,j);
                Nkper(i1(i,j)+1)=Nkper(i1(i,j)+1)+k1(i,j);
            end
        end
    end
    if i3(k)<nkpar
        P2D(i3(k)+1,:)=P2D(i3(k)+1,:)+Ptemp(k,:); %Fill array with kper values for each kpar
    end
end
end
%----------------------------------------------------------------------

%----------------------------------------------------------------------
function [P1Dper,P1Dpar]=Compute1DSpectra(P2D,kper,threshold)
%Calculate parallel and perpendicular 1D sepctra from the 2D spectrum.
[c1,index1]=min(abs(kper-threshold)); %Cut spectrum above a threshold k

[c,index]=min(abs(kper-threshold)); %Cut spectrum above a threshold k
Pthres=P2D(2,index);
mask2D=P2D>Pthres;
fieldMASKED=P2D.*mask2D;
P1Dper=sum(fieldMASKED,1); %Sum over parallel k
P1Dpar=sum(fieldMASKED,2); %Sum over perpendicular k
end
%----------------------------------------------------------------------


%----------------------------------------------------------------------
function [E_k,k_bins]=Omni1DSpectra(Bx_dt,Lx,threshold)

% Detrend the variable

Bx_dt_DT = Bx_dt - mean(Bx_dt,'all');

% Perform the FFT of the 3D field B
F_B = fftn(Bx_dt_DT);
Ns=size(Bx_dt);

% Compute the wavenumbers
kx = (2*pi/Lx) * [0:(Ns(1)/2-1) -Ns(1)/2:-1];
ky = kx;
kz = kx;
[KX, KY, KZ] = meshgrid(kx, ky, kz);

% Calculate the radial wavenumber k
K = sqrt(KX.^2 + KY.^2 + KZ.^2);

% Calculate the energy spectrum
energy = abs(F_B).^2;

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

