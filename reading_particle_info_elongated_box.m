%#-----------------------------------------------------------------------
%This is the script to read the particle infoprmation
% Jeffersson Agudelo, 05/01/2024
% The first part simply load the particle info. The second part is a bit
% more elaborated and it takes 4 subregions and perform coordinate
% transformation to the par and per plane (with respect to the local field using the pfd.h5 files)
%#----------------------------------------------------------------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/Cirrus_folders/elongated_box';
path = '/Volumes/PSC_CORI_DATA/TESTS_2022/Cirrus_folders/short_cube';

path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
path_s = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(path)
%--------------------------------------------------------------------------
S = dir(fullfile(path,'prt.*'));
N=numel(S); % number of files to use
%H=zeros(N);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% This has to be put by hand
ppc = 200;
mime =100.;
Lx0 = 4; % this can be extracted better 
Ly0 = 4;
Lz0 = 20;
me=1;
mi=mime;
c=1;
omega_pe_Omega_ce=5;
%--------------------------------------------------------------------------
% chose the particle file to work with.
i=13;
%5 for the later; 100 for the initial. %This is for the distribution function plot. at later time the electrons
%have way more energy 
frac= 10;
frac= 100;
%frac= 5;

%number of points to get a ndi window
ndi=0.2;
run_z = 306;
% Noise level
no_le=1;
% this is for the countour
cll=5;
%--------------------------------------------------------------------------

% read the particle output
%--------------------------------------------------------------------------
disp(strcat('Computing step ...',S(i).name))
fileID =  S(i).name; %change the 1 per i
%h5disp(fileID); %this is the command to show the information in the file
info = h5info(fileID);
%info = h5info(fileID,'TextEncoding','UTF-8');

aa = info.Groups(1).Groups.Datasets;
MyMatrix = vertcat(aa.Dataspace);
size1 = horzcat(MyMatrix.MaxSize);
Lxp = size1(2);
Lyp = size1(3);
Lzp = size1(4);

% This goes from -Lx to 0; -Ly to 0; -Lz to 0 and then 0 to Lx; 0 to Ly; 0 to Lz; 
%----------------------------------------------------------------------
%----------------------------------------------------------------------

%This has isotropic distributions at t=0 
%----------------------------
Lz1 = 1*Lzp/6;
Lz2 = 5*Lzp/6;
start = Lxp*ppc*Lyp*(run_z)*3; % 2 is the one for the good initial maxwellim
count = 80*Lzp*ppc;
stride = 1;
%-----------------------------

% This has a problem, I think it can be boundary ?
% The electron distribution has funny features
%-----------------------------
% Lz1 = 1*Lzp/6;
% Lz2 = 5*Lzp/6;
% start = Lxp*ppc*Lyp*(Lz1)*10; % 10 (boundary issue)
% count = 50*Lzp*ppc;
% stride = 1;
%-----------------------------

prt = info.Groups(1).Name;
%read the information from the fields of the struct
%prtfields=h5read(fileID,strcat(prt,'/p0/1d'),start,count,stride); 
prtfields=h5read(fileID,strcat(prt,'/p0/1d'));
x = prtfields.x;
y = prtfields.y;
z = prtfields.z;
px = prtfields.px;
py = prtfields.py;
pz = prtfields.pz;
q = prtfields.q;
%m = prtfields.m;
%w = prtfields.w;

% % Check the variables
% f1=figure(1);
% subplot(1,3,1)
% plot(x)
% subplot(1,3,2)
% plot(y)
% subplot(1,3,3)
% plot(z)

%separate the popullations

%q_i_index = find(q==1); % ions
q_i_index = find(q==-1); %electrons

%Coordinates of ions
xi=x(q_i_index); 
yi=y(q_i_index); 
zi=z(q_i_index);
pxi=px(q_i_index); 
pyi=py(q_i_index); 
pzi=pz(q_i_index);
qi=q(q_i_index);

clearvars px py pz x y z q
%-------------------------------------------------


% Include here and extra condition to select a localized region rather than a big plane. 
%-------------------------------------------------
x_max=max(xi);
x_min = min(xi);
y_max=max(yi);
y_min = min(yi);
z_max=max(zi);
z_min = min(zi);

ini_a = [x_min, y_min, z_min]
ini_b = [x_max, y_max, z_max]

% Second part, Doing a selection of a sub-regions and a coordinate transformation the local magnetic field.
%--------------------------------------------------------------------------
% To get the particle info in a sub-region when need it
%----------------------------------------------------------------------
res_x = Lx0/Lxp; 
res_y = Ly0/Lyp; 
res_z = Lz0/Lzp;

n_x_di = ndi/res_x; 
n_y_di = ndi/res_y; 
n_z_di = ndi/res_z; 

%Select a window of 1di between the interval
xii1 = x_min; xii2 = x_min +ndi; 
yii1 = y_min; yii2 = y_min +ndi; 
zii1 = z_min; zii2 = z_min +ndi; 

% % xii1 = x_min; xii2 = x_max; % This is for the whole domain
% % yii1 = y_min; yii2 = y_max; 
% % zii1 = z_min; zii2 = z_max; 


cond_y1 = find(ge(xi,xii1) & le(xi,xii2) & ge(yi,yii1) & le(yi,yii2) & ge(zi,zii1) & le(zi,zii2) );  
%----------------------------------------------------------------------
pxi_sub1=pxi(cond_y1);
pyi_sub1=pyi(cond_y1);
pzi_sub1=pzi(cond_y1);
% %----------------------------------------------------------------------
clearvars pxi pyi pzi x y z
pxi = pxi_sub1;
pyi = pyi_sub1;
pzi = pzi_sub1;

ini_a_sub = [xii1, yii1, zii1]
ini_b_sub = [xii2, yii2, zii2]
%----------------------------------------------------------------------
%-------------------------------------------------

% substract the average to remove the shift
%-------------------------------------------------
pxi_av = mean(pxi);
pyi_av = mean(pyi);
pzi_av = mean(pzi);

pxi = pxi - pxi_av;
pyi = pyi - pyi_av;
pzi = pzi - pzi_av;


% ions
%pxi = pxi .* c ./ sqrt(c^2 .* me^2 + pxi.^2);

% % % %iones
% % % pxi = pxi .* c ./ sqrt(c^2 .* 1^2 + pxi.^2);
% % % pyi = pyi .* c ./ sqrt(c^2 .* 1^2 + pyi.^2);
% % % pzi = pzi .* c ./ sqrt(c^2 .* 1^2 + pzi.^2);

% %electrons
pxi = pxi .* c ./ sqrt(c^2 .* mi^2 + pxi.^2);
pyi = pyi .* c ./ sqrt(c^2 .* mi^2 + pyi.^2);
pzi = pzi .* c ./ sqrt(c^2 .* mi^2 + pzi.^2);
%-------------------------------------------------

% limits electrons
%----------------------------------------------------------------------
 
%frac= 5;
xspace_par = [-1.0, -0.5, 0, 0.5, 1.0]./frac;
yspace_per = [0, 0.5, 1.0]./frac;
xlims = [-1.0, 1.0]./frac;
ylims = [0.0, 1.0]./frac;
Xedges2D = linspace(-1.0,1.0)./frac;
Yedges2D = linspace(0.0,1.0)./frac;
%----------------------------------------------------------------------


%yi=y(q_i_index); zi=z(q_i_index);

% q_e_index = find(q==-1);
% %Coordinates of electrons
% %xe=x(q_e_index); ye=y(q_e_index); ze=z(q_e_index);
% pxe=px(q_e_index); pye=py(q_e_index); pze=pz(q_e_index);
% qe=q(q_e_index);
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------


% This part is important because is where the magnetic field file is
% loaded and it needs to be consistent

%To make the coordinate transformation
%----------------------------------------------------------------------
% Get the fiel name and remove the prt.
str = S(i).name;
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

Lx=grid_length(4).Value(1) - grid_length(3).Value(1);
Ly=grid_length(4).Value(2) - grid_length(3).Value(2);
Lz=grid_length(4).Value(3) - grid_length(3).Value(3);

resx=double(Lx)/double(dx);
resy=double(Ly)/double(dy);
resz=double(Lz)/double(dz); res=resy;
threshold=pi/resy;

xll=single(linspace(-Lx/2,Lx/2,Lxp));
yll=linspace(-Ly/2,Ly/2,Lyp);
zll=linspace(-Lz/2,Lz/2,Lzp);

cond_x = find(ge(xll,xii1) & le(xll,xii2)); % this returns the indices
cond_y = find(ge(yll,yii1) & le(yll,yii2));
cond_z = find(ge(zll,zii1) & le(zll,zii2));

% cond_x = find(ge(xll,x_min) & le(xll,x_max)); % this is taking the max
% and min
% cond_y = find(ge(yll,y_min) & le(yll,y_max));
% cond_z = find(ge(zll,z_min) & le(zll,z_max));

startf = [cond_x(1),cond_y(1),cond_z(1)]
startf2 = [cond_x(end),cond_y(end),cond_z(end)]
countf = [length(cond_x),length(cond_y),length(cond_z)];

%--------------------------------------------------------------------------
Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'),startf,countf);
By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'),startf,countf);
Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'),startf,countf);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
Bxout_av = mean(Bx,'all'); Byout_av = mean(By,'all'); Bzout_av = mean(Bz,'all');
Bout_m_av = sqrt(Bxout_av.^2 + Byout_av.^2 + Bzout_av.^2);
%--------------------------------------------------------------------------

%----------------------------------------------------------------------
% Define the initial coordinates
xx = [1; 0; 0]; % Example x-coordinate
yy = [0; 1; 0]; % Example y-coordinate
zz = [0; 0; 1]; % Example z-coordinate

% this only uses the in vector and not the out. I need to repeat this
% because the magnetic field vector is different.
% Define the magnetic field vector

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

%%% Define the vector in the initial reference frame
%%v_initial_1 = [pxi_sub1, pyi_sub1, pzi_sub1]'; % Example vector in the initial reference frame

% Define the vector in the initial reference frame
v_initial_1 = [pxi, pyi, pzi]'; % Example vector in the initial reference frame

% Calculate the inverse of the rotation matrix
%R_inverse = inv(R_matrix_in); % Inverse of the rotation matrix A\b

% Express the vector in the new reference frame
v_new_1 = R_matrix_out \ v_initial_1;
v_new_par_1 = v_new_1(1,:);
v_new_per_1 = sqrt(v_new_1(2,:).^2 + v_new_1(3,:).^2);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
str = string(S(i).name);
newStr = extractBetween(str,"prt.","_p000000.h5");
N_steps = str2double(newStr);
dt = 0.0653;% <--- This has to come from the field data because this do not store the time resolution
time_t = dt*N_steps;
time_t_2_Omega=time_t./omega_pe_Omega_ce;
%----------------------------------------------------------------------


% plots in the par per plane with 2 plots
%----------------------------------------------------------------------
cd(path_s)
fs=18;  x0=45;  y0=54;  xx1=1200;    yy1=450;
%----------------------------------------------------------------------
f12=figure(12);
set(gcf,'position',[x0,y0,xx1,yy1])
h1=subaxis(1,2,1,'SV',0.01,'SH',0.004,'MR',0.01,'ML',0.05,'PL',0.01,'PR',0.006);
dum1 = pzi; dum2 = sqrt(pxi.^2 + pyi.^2);
[Ni,Xedgesi,Redgesi] = histcounts2(dum1,dum2,Xedges2D,Yedges2D);
Ni=Ni(1:99,1:99)';    Xedges2i=Xedgesi(2:100)'; Redges2i=Redgesi(2:100)';
c_lim=0.5*10^6;
Xedges2i=Xedges2i-(Xedges2i(2)-Xedges2i(1))/2;
Redges2i=Redges2i-(Redges2i(2)-Redges2i(1))/2;
Ni(Ni<=no_le)=NaN;
Ni_3_0 = Ni;
[Ci,Di]=meshgrid(Xedges2i,Redges2i);
hc=pcolor(Xedges2i,Redges2i, Ni./Di);
%hc=contourf(Xedges2i,Redges2i,Ni./Di,cll);
hold on
set(hc,'edgecolor','none');
set(gca,'ColorScale','log','FontSize',fs)
set(gca,'XScale','lin','YScale','lin','FontSize',fs)
colormap(h1,'jet');
clim([1 (c_lim)]);
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = '$v_{z}/c$'; ax.XTick = xspace_par;
ax.YLabel.String = '$v_{\perp}/c$'; ax.YTick = yspace_per;
xline(0,'--k'); yline(0,'--k');
xlim(xlims); ylim(ylims);
title('$f_{e}(v_{z},\sqrt{v_{x}^2 + v_{y}^2})$','Interpreter','latex','FontSize',fs');
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
c_lim=0.5*10^6;
Ni(Ni<=no_le)=NaN;
Ni_2_0 = Ni;
hc=pcolor(Xedges2i,Redges2i, Ni./Di);
%hc=contourf(Xedges2i,Redges2i,Ni./Di,cll);
hold on
set(hc,'edgecolor','none');
set(gca,'ColorScale','log','FontSize',fs)
set(gca,'XScale','lin','YScale','lin','FontSize',fs)
colormap(h2,'jet');
clim([1 (c_lim)]);
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = '$v_{\parallel}/c$'; ax.XTick = xspace_par;
%ax.YLabel.String = '$v_{\perp}$';
ax.YTick = [];
xline(0,'--k'); yline(0,'--k');
xlim(xlims); ylim(ylims);
title('$f_{e}(v_{\parallel}, v_{\perp})$','Interpreter','latex','FontSize',fs);
pbaspect([2 1 1])
hold off
%----------------------------------------------------------------------
sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\ \Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
%----------------------------------------------------------------------
cd(path)
saveas(f12,strcat('large_vper_par_elec' + string(i+1) +'.png'));
%saveas(f13,strcat('large_vper_par_ion' + string(i+1) +'.png'));
%----------------------------------------------------------------------
%f12=figure(12);






% 
% 
% % limits
% %----------------------------------------------------------------------
% xspace_par = [-1.0, -0.5, 0, 0.5, 1.0];
% yspace_per = [0, 0.5, 1.0];
% xlims = [-1.0, 1.0];
% ylims = [0.0, 1.0];
% Xedges2D = linspace(-1.0,1.0);
% Yedges2D = linspace(0.0,1.0);
% %----------------------------------------------------------------------
% 
% %----------------------------------------------------------------------
% % Noise level
% no_le=1;
% %----------------------------------------------------------------------
% 
% cll=5;
% % plots in the par per plane with 2 plots
% %----------------------------------------------------------------------
% cd(path_s)
% fs=18;  x0=45;  y0=54;  xx1=1000;    yy1=300;
% %----------------------------------------------------------------------
% f2=figure(2);
% %----------------------------------------------------------------------
% subplot(1,2,1)
% dum1 = pzi; dum2 = sqrt(pxi.^2 + pyi.^2);
% [Ni,Xedgesi,Redgesi] = histcounts2(dum1,dum2,Xedges2D,Yedges2D);
% Ni=Ni(1:99,1:99)';    Xedges2i=Xedgesi(2:100)'; Redges2i=Redgesi(2:100)';
% Xedges2i=Xedges2i-(Xedges2i(2)-Xedges2i(1))/2;
% Redges2i=Redges2i-(Redges2i(2)-Redges2i(1))/2;
% [Ci,Di]=meshgrid(Xedges2i,Redges2i);
% c_lim=0.5*10^6;
% Ni(Ni<=no_le)=NaN;
% %Ni_2_0 = Ni;
% hc=pcolor(Xedges2i,Redges2i, Ni./Di);
% %hc=contourf(Xedges2i,Redges2i,Ni./Di,cll);
% hold on
% set(hc,'edgecolor','none');
% set(gca,'ColorScale','log','FontSize',fs)
% set(gca,'XScale','lin','YScale','lin','FontSize',fs)
% colormap('jet');
% clim([1 (c_lim)]);
% hcb=colorbar; hcb.Location = 'northoutside';
% hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
% ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% ax.XLabel.String = '$v_{\parallel}/c$'; ax.XTick = xspace_par;
% ax.YLabel.String = '$v_{\perp}$';
% ax.YTick = [];
% xline(0,'--k'); yline(0,'--k');
% xlim(xlims); ylim(ylims);
% title('R2','Interpreter','latex','FontSize',fs);
% pbaspect([2 1 1])
% hold off
% 
% subplot(1,2,2)
% dum1 = pzi_sub1; dum2 = sqrt(pxi_sub1.^2 + pyi_sub1.^2);
% [Ni,Xedgesi,Redgesi] = histcounts2(dum1,dum2,Xedges2D,Yedges2D);
% Ni=Ni(1:99,1:99)';    Xedges2i=Xedgesi(2:100)'; Redges2i=Redgesi(2:100)';
% Xedges2i=Xedges2i-(Xedges2i(2)-Xedges2i(1))/2;
% Redges2i=Redges2i-(Redges2i(2)-Redges2i(1))/2;
% [Ci,Di]=meshgrid(Xedges2i,Redges2i);
% c_lim=0.5*10^6;
% Ni(Ni<=no_le)=NaN;
% %Ni_2_0 = Ni;
% hc=pcolor(Xedges2i,Redges2i, Ni./Di);
% %hc=contourf(Xedges2i,Redges2i,Ni./Di,cll);
% hold on
% set(hc,'edgecolor','none');
% set(gca,'ColorScale','log','FontSize',fs)
% set(gca,'XScale','lin','YScale','lin','FontSize',fs)
% colormap('jet');
% clim([1 (c_lim)]);
% hcb=colorbar; hcb.Location = 'northoutside';
% hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
% ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% ax.XLabel.String = '$v_{\parallel}/c$'; ax.XTick = xspace_par;
% ax.YLabel.String = '$v_{\perp}$';
% ax.YTick = [];
% xline(0,'--k'); yline(0,'--k');
% xlim(xlims); ylim(ylims);
% title('sub1','Interpreter','latex','FontSize',fs);
% pbaspect([2 1 1])
% hold off
% 
% 








