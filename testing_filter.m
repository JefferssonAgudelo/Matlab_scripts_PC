%% FILE PATH
%dir = input('Name of the directory? (Like ./low_amplitude/12 or ./large_amplitude/01): ', 's');

dir = '/Volumes/PSC_DiRAC_DATA/DATA_HVM/betai=0.25/02';
xl = 3.0;
yl = 3.0;
zl = 3.0;
outformat = 0;
ns = 5;
tt = 5;
pressure_on = 0;
l_wind = 8;
component=1;
rms_value = 1;
absolute = 1;
beta_i = 0.25;
Ti02Te0 = 2.5;

f_path = [dir, '/'];
fprintf('FILE PATH = %s\n', f_path);

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

% %%% Read Ion.bin file data
% llion = true; % Assuming llion is true based on the Python script
% if llion
%     time = [];
%     px = [];
%     py = [];
%     pz = [];
%     rho = [];
%     outformat = 1;
% 
%     if outformat
%         fid = fopen(filename, 'rb');
%         if fid == -1
%             error('Failed to open Ion.bin');
%         end
% 
%         % Skip initial 4 bytes
%         fseek(fid, 4, 'cof');
% 
%         for i = 1:ns
%             time = [time; fread(fid, 1, 'float64')];
%             dims = fread(fid, 3, 'int32');
%             nx = dims(1);
%             ny = dims(2);
%             nz = dims(3);
% 
%             fprintf('%f\n', time(end));
% 
%             TOTAL_SIZE = nx * ny * nz;
%             SHAPE = [nx, ny, nz];
% 
%             % Skip 8 bytes (int32 padding)
%             fseek(fid, 8, 'cof');
% 
%             px = cat(4, px, reshape(fread(fid, TOTAL_SIZE, 'float64'), SHAPE));
%             py = cat(4, py, reshape(fread(fid, TOTAL_SIZE, 'float64'), SHAPE));
%             pz = cat(4, pz, reshape(fread(fid, TOTAL_SIZE, 'float64'), SHAPE));
%             rho = cat(4, rho, reshape(fread(fid, TOTAL_SIZE, 'float64'), SHAPE));
% 
%             % Skip 8 bytes (int32 padding)
%             fseek(fid, 8, 'cof');
%         end
% 
%         fclose(fid);
%     end
% end
% 
% %%% Density perturbation:
% %rho = permute(rho, [2, 3, 4, 1]);
% 
% % Total density:
% den = 1.0 + rho;
% 
% % 2nd moments:
% %px = permute(px, [2, 3, 4, 1]);
% %py = permute(py, [2, 3, 4, 1]);
% %pz = permute(pz, [2, 3, 4, 1]);
% 
% % Ion velocities:
% uxp = px ./ (rho + 1.0);
% uyp = py ./ (rho + 1.0);
% uzp = pz ./ (rho + 1.0);
% 
% clearvars px py pz

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
clearvars ex ey ez

bx_t = squeeze(bx(:,:,:,tt));
clearvars bx by bz

kx = 2 * pi * [0:nx/2 -nx/2+1:-1] / Lx; % Wavenumbers in x
ky = 2 * pi * [0:ny/2 -ny/2+1:-1] / Lz; % Wavenumbers in y
kz = 2 * pi * [0:nz/2 -nz/2+1:-1] / Lz; % Wavenumbers in z

[Kz, Kx, Ky] = meshgrid(kz, kx ,ky); % Note the order here Kz goes first

Dx = 8*Lx/nx; 
Bx_dt=bx_t;
Ex_dt=ex_t;


Ex_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,Ex_dt);
Bx_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,Bx_dt);

% This is what the imgaussfilt3 funtion does 

fs=20;
resx = Lx/nx;
resy = Ly/ny;
resz = Lz/nz;

xl=x; yl=y; zl=z;

grad_fact=1;
threshold = pi/resx;
%----------------------------------------------------------------------

%----------------------------------------------------------------------
% This is to get the 1D omni spectra
%----------------------------------------------------------------------
%if (component == 1)
[E_k_Bx_dt,~]=Omni1DSpectra(Bx_dt,Lx,threshold);
[E_k_Ex_dt,~]=Omni1DSpectra(Ex_dt,Lx,threshold);
[E_k_Bx_filt,~]=Omni1DSpectra(Bx_filt,Lx,threshold);
[E_k_Ex_filt,k_bins]=Omni1DSpectra(Ex_filt,Lx,threshold);



%
fs=20; x0=45;y0=54;xx1=700;yy1=500;
% Figure 1
%----------------------------------------------------------------------
i=50; j=50;
%
f1=figure(1)
subplot(2,1,1)
set(gcf,'position',[x0,y0,xx1,yy1])
dum = Bx_dt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-b',LineWidth=1.5)
hold on
dum = Ex_dt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'-r',LineWidth=1.5)
dum = Bx_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'--b',LineWidth=1.5)
dum = Ex_filt;
dump = squeeze(dum(:,i,j));
plot(xl,dump,'--r',LineWidth=1.5)
set(gca,'FontSize',fs)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$y/d_i$';
%ax.YLabel.String = '$E_{x}$';
legend('$B_{x}$','$E_{x}$','$\overline{B}_{x}$', '$\overline{E}_{x}$','Interpreter','latex','NumColumns',1,'Location','southwest')
title('lw=16','Interpreter','latex')
xlim([min(xl),max(xl)])
ylim([-0.6, 0.6]);
hold off



%--------------------------------------------------------------------------
subplot(2,1,2)
set(gcf,'position',[x0,y0,xx1,yy1])
%----------------------------------------------------------------------
loglog(k_bins(1:end-1), E_k_Bx_dt(1:end-1),'b-','LineWidth',2)
hold on
loglog(k_bins(1:end-1), E_k_Ex_dt(1:end-1),'r-','LineWidth',2)
loglog(k_bins(1:end-1), E_k_Bx_filt(1:end-1),'--b','LineWidth',2)
loglog(k_bins(1:end-1), E_k_Ex_filt(1:end-1),'--r','LineWidth',2)
set(gca,'FontSize',fs)
%set(gca,'XScale','lin','YScale','log','FontSize',fs)
y1=get(gca,'ylim');
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.XLabel.String = '$k d_i$';
ax.YLabel.String = '$P_{1D} $';
xlim([k_bins(2) threshold]);
ylim([10^(-8) 10^(15)]);
legend('$B_{x}$','$E_{x}$','$\overline{B}_{x}$', '$\overline{E}_{x}$','Interpreter','latex','NumColumns',1,'Location','southwest')
%title('lw=2','Interpreter','latex')
hold off

cd('~/Downloads')
%saveas(f1,strcat(num2str(i),'spectrum_Bx_Ex_lw_16.png'));

path_f = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';

cd(path_f)

i=50;

f44=figure(44)
subplot(2,2,1)
dum = Ex_dt;
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
title('$Ex$','Interpreter','latex')
pbaspect([1 1 1])
hold off
subplot(2,2,2)
dum = Bx_dt;
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
title('$Bx$','Interpreter','latex')
pbaspect([1 1 1])
hold off
subplot(2,2,3)
dum = Ex_filt;
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
title('$Ex filt$','Interpreter','latex')
pbaspect([1 1 1])
hold off
subplot(2,2,4)
dum = Bx_filt;
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
title('$Bx filt$','Interpreter','latex')
pbaspect([1 1 1])
hold off


%it is l_window is 8, then it filters using 8 times the resolution  

kx = 2 * pi * [0:nx/2 -nx/2+1:-1] / Lx; % Wavenumbers in x
ky = 2 * pi * [0:ny/2 -ny/2+1:-1] / Lz; % Wavenumbers in y
kz = 2 * pi * [0:nz/2 -nz/2+1:-1] / Lz; % Wavenumbers in z
[Kz, Kx, Ky] = meshgrid(kz, kx ,ky); % Note the order here Kz goes first

%Dx = 8*Lx/nx; 
Ex_filt = Gauss_filter_3D_xyz(1*Dx,Kx,Ky,Kz,Ex_dt);
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