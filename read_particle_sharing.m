%#-----------------------------------------------------------------------
%This is the script to read the particle infoprmation
% Jeffersson Agudelo, 05/01/2024
% The first part simply load the particle info. The second part is a bit
% more elaborated and it takes 4 subregions and perform coordinate
% transformation to the par and per plane (with respect to the local field using the pfd.h5 files)
%#----------------------------------------------------------------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/Cirrus_folders/elongated_box';
path = '/home/UNN/pfcy6/codes/PSC/psc-main/build_noGPU/Testing_no_GPU/testing_kappa_nomagnetic_field/kappa_rejection';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(path)

% It is important to put the correct values here
%--------------------------------------------------------------------------
mime =100.;
omega_pe_Omega_ce=5;
% This has to be put by hand
%--------------------------------------------------------------------------
ppc = 50;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

S = dir(fullfile(path,'prt.*'));
N=numel(S); % number of files to use
%H=zeros(N);

% chose the particle file to work on.
i=2;

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

Lz1 = 4*Lzp/6;
Lz2 = 5*Lzp/6;

start = Lxp*ppc*Lyp*(Lz1)*1;
count = 2*Lzp*ppc;
stride = 30;

prt = info.Groups(1).Name;

% This way using start and count allows to load only a subset of the data
%read the information from the fields of the struct
prtfields=h5read(fileID,strcat(prt,'/p0/1d'),start,count,stride);
x = prtfields.x;
y = prtfields.y;
z = prtfields.z;

% Check the variables
f1=figure(1);
subplot(1,3,1)
plot(x)
subplot(1,3,2)
plot(y)
subplot(1,3,3)
plot(z)

x_max=max(x);
x_min = min(x);
y_max=max(y);
y_min = min(y);
z_max=max(z);
z_min = min(z);

px = prtfields.px;
py = prtfields.py;
pz = prtfields.pz;
q = prtfields.q;

%m = prtfields.m;
%w = prtfields.w;


%separate the popullations

%q_i_index = find(q==1); % ions
q_i_index = find(q==-1); %electrons
%Coordinates of ions
xi=x(q_i_index); yi=y(q_i_index); zi=z(q_i_index);
pxi=px(q_i_index); pyi=py(q_i_index); pzi=pz(q_i_index);
qi=q(q_i_index);

%yi=y(q_i_index); zi=z(q_i_index);

% q_e_index = find(q==-1);
% %Coordinates of electrons
% %xe=x(q_e_index); ye=y(q_e_index); ze=z(q_e_index);
% pxe=px(q_e_index); pye=py(q_e_index); pze=pz(q_e_index);
% qe=q(q_e_index);
%--------------------------------------------------------------------------

clearvars px py pz q

%--------------------------------------------------------------------------


% Second part, Doing a selection of 4 sub-regions and a coordinate transformation the local magnetic field.
%--------------------------------------------------------------------------
% To get the particle info in a sub-region
% This is to get even a sub sub region. You need to define the limits
% accordingly
%----------------------------------------------------------------------
xii1 = x_min; xii2 = x_max; 
yii1 = y_min; yii2 = y_max; 
zii1=z_min; zii2=z_max; 
cond_y1 = find((xi>=xii1) & (xii2>=xi) & (yi>=yii1) & (yii2>=yi) & (zi>=zii1) & (zii2>=zi) );  
%----------------------------------------------------------------------
pxi_sub1=pxi(cond_y1);
pyi_sub1=pxi(cond_y1);
pzi_sub1=pxi(cond_y1);

clearvars pxi pyi pzi
%----------------------------------------------------------------------

% % Second part, Doing a selection of 4 sub-regions and a coordinate transformation the local magnetic field.
% %--------------------------------------------------------------------------
% % To get the particle info in a sub-region
% % This is for the 4 plots in one
% %----------------------------------------------------------------------
% yii1 = 10; yii2 = 20; zii1=30; zii2=50; % 3 is out
% yjj1 = -5; yjj2 = 5; zjj1=30; zjj2=50; % 2 is in
% ykk1 = -5; ykk2 = 5; zkk1=-10; zkk2=10; % 1 x
% yll1 = 20; yll2 = 30; zll1=-10; zll2=10; % 4 top
% %----------------------------------------------------------------------
% 
% % for the
% %----------------------------------------------------------------------
% cond_y1 = find((yi>yii1) & (yii2>yi) & (zi>zii1) & (zii2>zi) );  % out
% cond_y2 = find((yi>yjj1) & (yjj2>yi) & (zi>zjj1) & (zjj2>zi) );  % in
% cond_y3 = find((yi>ykk1) & (ykk2>yi) & (zi>zkk1) & (zkk2>zi) );  % x
% cond_y4 = find((yi>yll1) & (yll2>yi) & (zi>zll1) & (zll2>zi) );  % top
% %----------------------------------------------------------------------
% 
% pxi_sub1=pxi(cond_y1);
% pyi_sub1=pyi(cond_y1);
% pzi_sub1=pzi(cond_y1);
% 
% pxi_sub2=pxi(cond_y2);
% pyi_sub2=pyi(cond_y2);
% pzi_sub2=pzi(cond_y2);
% 
% pxi_sub3=pxi(cond_y3);
% pyi_sub3=pyi(cond_y3);
% pzi_sub3=pzi(cond_y3);
% 
% pxi_sub4=pxi(cond_y4);
% pyi_sub4=pyi(cond_y4);
% pzi_sub4=pzi(cond_y4);
% 
% clearvars pxi pyi pzi
% %----------------------------------------------------------------------

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

% in case it is in 3D
sli_x = 1;
Bx = squeeze(Bx(:,sli_x,:));
By = squeeze(By(:,sli_x,:));
Bz = squeeze(Bz(:,sli_x,:));

sss=size(Bx);
size_X=sss;
zll=linspace(-Lz,Lz,size_X(2)); %Jeff flag it works with (1,size_x(2))
yll=linspace(-Lx,Lx,size_X(1));
[ZLL, YLL] = meshgrid(zll,yll);

% out
Bxout = Bx; Bxout(Bxout==0)=NaN;
Byout = By; Byout(Byout==0)=NaN;
Bzout = Bz; Bzout(Bzout==0)=NaN;

% 5 this has to be accordingly
% cond_ii = (YLL>=xii1).*(YLL<=xii2).*(ZLL>=zii1).*(ZLL<=zii2);
% Bxout = Bx.*cond_ii; Bxout(Bxout==0)=NaN;
% Byout = By.*cond_ii; Byout(Byout==0)=NaN;
% Bzout = Bz.*cond_ii; Bzout(Bzout==0)=NaN;

% in
%{
cond_jj = (YLL>yjj1).*(YLL<yjj2).*(ZLL>zjj1).*(ZLL<zjj2);
Bxin = Bx.*cond_jj; Bxin(Bxin==0)=NaN;
Byin = By.*cond_jj; Byin(Byin==0)=NaN;
Bzin = Bz.*cond_jj; Bzin(Bzin==0)=NaN;

% x
cond_kk = (YLL>ykk1).*(YLL<ykk2).*(ZLL>zkk1).*(ZLL<zkk2);
Bx_x = Bx.*cond_kk; Bx_x(Bx_x==0)=NaN;
By_x = By.*cond_kk; By_x(By_x==0)=NaN;
Bz_x = Bz.*cond_kk; Bz_x(Bz_x==0)=NaN;

% top
cond_ll = (YLL>yll1).*(YLL<yll2).*(ZLL>zll1).*(ZLL<zll2);
Bxtop = Bx.*cond_ll; Bxtop(Bxtop==0)=NaN;
Bytop = By.*cond_ll; Bytop(Bytop==0)=NaN;
Bztop = Bz.*cond_ll; Bztop(Bztop==0)=NaN;
%}
%----------------------------------------------------------------------


% Now lets compute the averages to get the parallel and perpendicular


% It seems there are many NaNs
% remove the NaNs
Bxout(isnan(Bxout)) = []; Byout(isnan(Byout)) = [];  Bzout(isnan(Bzout)) = [];
Bxout_av = mean(Bxout,'all'); Byout_av = mean(Byout,'all'); Bzout_av = mean(Bzout,'all');
Bout_m_av = sqrt(Bxout_av.^2 + Byout_av.^2 + Bzout_av.^2);

%{
% remove the NaNs
Bxin(isnan(Bxin)) = []; Byin(isnan(Byin)) = [];  Bzin(isnan(Bzin)) = [];
Bxin_av = mean(Bxin,'all'); Byin_av = mean(Byin,'all'); Bzin_av = mean(Bzin,'all');
Bin_m_av = sqrt(Bxin_av.^2 + Byin_av.^2 + Bzin_av.^2);

% remove the NaNs
Bx_x(isnan(Bx_x)) = []; By_x(isnan(By_x)) = [];  Bz_x(isnan(Bz_x)) = [];
Bx_x_av = mean(Bx_x,'all'); By_x_av = mean(By_x,'all'); Bz_x_av = mean(Bz_x,'all');
B_x_m_av = sqrt(Bx_x_av.^2 + By_x_av.^2 + Bz_x_av.^2);

% remove the NaNs
Bxtop(isnan(Bxtop)) = []; Bytop(isnan(Bytop)) = [];  Bztop(isnan(Bztop)) = [];
Bxtop_av = mean(Bxtop,'all'); Bytop_av = mean(Bytop,'all'); Bztop_av = mean(Bztop,'all');
Btop_m_av = sqrt(Bxtop_av.^2 + Bytop_av.^2 + Bztop_av.^2);
%}


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
% Define the vector in the initial reference frame
v_initial_2 = [pxi_sub1, pyi_sub1, pzi_sub1]'; % Example vector in the initial reference frame
% Express the vector in the new reference frame
v_new_2 = R_matrix_out \ v_initial_2;
v_new_par_2 = v_new_2(1,:);
v_new_per_2 = sqrt(v_new_2(2,:).^2 + v_new_2(3,:).^2);


%--------------------------------------------------------------------------
% This part is for the other regions
% Define the magnetic field vector
%{
B_in = [Bxin_av; Byin_av; Bzin_av]; % Example magnetic field vector
B_x = [Bx_x_av; By_x_av; Bz_x_av]; % Example magnetic field vector
B_top = [Bxtop_av; Bytop_av; Bztop_av]; % Example magnetic field vector

% Normalize the magnetic field vector
B_normalized_in = B_in / norm(B_in);
B_normalized_x = B_x / norm(B_x);
B_normalized_top = B_top / norm(B_top);

% Calculate the rotation axis
R_in = cross(B_normalized_in, [1; 0; 0]); % Cross product with x-axis
R_x = cross(B_normalized_x, [1; 0; 0]); % Cross product with x-axis
R_top = cross(B_normalized_top, [1; 0; 0]); % Cross product with x-axis

% Calculate the rotation angle
theta_in = acos(dot(B_normalized_in, [1; 0; 0])); % Dot product with x-axis
theta_x = acos(dot(B_normalized_x, [1; 0; 0])); % Dot product with x-axis
theta_top = acos(dot(B_normalized_top, [1; 0; 0])); % Dot product with x-axis

% Create the rotation matrix
K_in = [0 -R_in(3) R_in(2); R_in(3) 0 -R_in(1); -R_in(2) R_in(1) 0]; % Skew-symmetric matrix
R_matrix_in = eye(3) + sin(theta_in) * K_in + (1 - cos(theta_in)) * K_in^2; % Rodrigues' rotation formula

K_x = [0 -R_x(3) R_x(2); R_x(3) 0 -R_x(1); -R_x(2) R_x(1) 0]; % Skew-symmetric matrix
R_matrix_x = eye(3) + sin(theta_x) * K_x + (1 - cos(theta_x)) * K_x^2; % Rodrigues' rotation formula

K_top = [0 -R_top(3) R_top(2); R_top(3) 0 -R_top(1); -R_top(2) R_top(1) 0]; % Skew-symmetric matrix
R_matrix_top = eye(3) + sin(theta_top) * K_top + (1 - cos(theta_top)) * K_top^2; % Rodrigues' rotation formula

% Perform the coordinate transformation
transformed_coords_in = R_matrix_in * [xx'; yy'; zz'];
transformed_coords_x = R_matrix_x * [xx'; yy'; zz'];
transformed_coords_top = R_matrix_top * [xx'; yy'; zz'];

% Extract the transformed coordinates
x_prime_in = transformed_coords_in(1, :)';
y_prime_in = transformed_coords_in(2, :)';
z_prime_in = transformed_coords_in(3, :)';

% Extract the transformed coordinates
x_prime_x = transformed_coords_x(1, :)';
y_prime_x = transformed_coords_x(2, :)';
z_prime_x = transformed_coords_x(3, :)';

% Extract the transformed coordinates
x_prime_top = transformed_coords_top(1, :)';
y_prime_top = transformed_coords_top(2, :)';
z_prime_top = transformed_coords_top(3, :)';

% Define the vector in the initial reference frame
v_initial_2 = [pxi_sub2, pyi_sub2, pzi_sub2]'; % Example vector in the initial reference frame
v_initial_3 = [pxi_sub3, pyi_sub3, pzi_sub3]'; % Example vector in the initial reference frame
v_initial_4 = [pxi_sub4, pyi_sub4, pzi_sub4]'; % Example vector in the initial reference frame


% Calculate the inverse of the rotation matrix
%R_inverse = inv(R_matrix_in); % Inverse of the rotation matrix A\b

% Express the vector in the new reference frame
v_new_1 = R_matrix_out \ v_initial_1;
v_new_3 = R_matrix_x \ v_initial_3;
v_new_4 = R_matrix_top \ v_initial_4;

v_new_par_1 = v_new_1(1,:);
v_new_per_1 = sqrt(v_new_1(2,:).^2 + v_new_1(3,:).^2);

v_new_par_3 = v_new_3(1,:);
v_new_per_3 = sqrt(v_new_3(2,:).^2 + v_new_3(3,:).^2);

v_new_par_4 = v_new_4(1,:);
v_new_per_4 = sqrt(v_new_4(2,:).^2 + v_new_4(3,:).^2);
%}
%----------------------------------------------------------------------


%----------------------------------------------------------------------
str = string(S(i).name);
newStr = extractBetween(str,"prt.","_p000000.h5");
N_steps = str2double(newStr);
dt = 0.0653;% <--- This has to come from the field data because this do not store the time resolution
time_t = dt*N_steps;
time_t_2_Omega=time_t./omega_pe_Omega_ce;
%----------------------------------------------------------------------

% limits
%----------------------------------------------------------------------
xspace_par = [-.1, -0.05, 0, 0.05, .1];
yspace_per = [0, 0.05, .1];
xlims = [-.1, .1];
ylims = [0.0, 0.1];
Xedges2D = linspace(-.1,.1);
Yedges2D = linspace(0.0,.1);

% xspace_par = [-1.0, -0.5, 0, 0.5, 1.0];
% yspace_per = [0, 0.5, 1.0];
% xlims = [-1.0, 1.0];
% ylims = [0.0, 1.0];
% Xedges2D = linspace(-1.0,1.0);
% Yedges2D = linspace(0.0,1.0);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
% Noise level
no_le=1;
%----------------------------------------------------------------------



cll=5;
% plots in the par per plane with 4 plots
%----------------------------------------------------------------------
%cd(path_s)
fs=18;  x0=45;  y0=54;  xx1=1000;    yy1=300;
%----------------------------------------------------------------------
f12=figure(12);
%----------------------------------------------------------------------
dum1 = v_new_par_2; dum2 = v_new_per_2;
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
colormap('jet');
caxis([1 (c_lim)]);
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = '$v_{\parallel}/c$'; ax.XTick = xspace_par;
%ax.YLabel.String = '$v_{\perp}$';
ax.YTick = [];
xline(0,'--k'); yline(0,'--k');
xlim(xlims); ylim(ylims);
title('R2','Interpreter','latex','FontSize',fs);
pbaspect([2 1 1])
hold off
%----------------------------------------------------------------------
sgtitle('$$log(f_{i}) \ ; \ t = \ $$'+string(round(time_t_2_Omega,2))+'$$\ \Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
%----------------------------------------------------------------------
% cd(path)
% saveas(f12,strcat('large_vper_par_R1R2R3R4' + string(round(time_t_2_Omega,2)) +'.png'));
%----------------------------------------------------------------------



% This is the plot for the four regions
%{
cll=5;
% plots in the par per plane with 4 plots
%----------------------------------------------------------------------
cd(path_s)
fs=18;  x0=45;  y0=54;  xx1=1000;    yy1=300;
%----------------------------------------------------------------------
f12=figure(12);
set(gcf,'position',[x0,y0,xx1,yy1])
h1=subaxis(1,4,1,'SV',0.01,'SH',0.004,'MR',0.01,'ML',0.05,'PL',0.01,'PR',0.006);
dum1 = v_new_par_3; dum2 = v_new_per_3;
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
caxis([1 (c_lim)]);
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = '$v_{\parallel}/c$'; ax.XTick = xspace_par;
ax.YLabel.String = '$v_{\perp}/c$'; ax.YTick = yspace_per;
xline(0,'--k'); yline(0,'--k');
xlim(xlims); ylim(ylims);
title('R1','Interpreter','latex','FontSize',fs');
pbaspect([2 1 1])
hold off
%----------------------------------------------------------------------
h2=subaxis(1,4,2,'SV',0.01,'SH',0.004,'MR',0.01,'ML',0.07,'PL',0.005,'PR',0.006);
dum1 = v_new_par_2; dum2 = v_new_per_2;
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
caxis([1 (c_lim)]);
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = '$v_{\parallel}/c$'; ax.XTick = xspace_par;
%ax.YLabel.String = '$v_{\perp}$';
ax.YTick = [];
xline(0,'--k'); yline(0,'--k');
xlim(xlims); ylim(ylims);
title('R2','Interpreter','latex','FontSize',fs);
pbaspect([2 1 1])
hold off
%----------------------------------------------------------------------
h3=subaxis(1,4,3,'SV',0.01,'SH',0.004,'MR',0.01,'ML',0.07,'PL',0.005,'PR',0.006);
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
%hc=contourf(Xedges2i,Redges2i,Ni./Di,cll);
hold on
set(hc,'edgecolor','none');
set(gca,'ColorScale','log','FontSize',fs)
set(gca,'XScale','lin','YScale','lin','FontSize',fs)
colormap(h3,'jet');
caxis([1 (c_lim)]);
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = '$v_{\parallel}/c$'; ax.XTick = xspace_par;
%ax.YLabel.String = '$v_{\perp}$';
ax.YTick = [];
xline(0,'--k'); yline(0,'--k');
xlim(xlims); ylim(ylims);
title('R3','Interpreter','latex','FontSize',fs);
pbaspect([2 1 1])
hold off
%----------------------------------------------------------------------
h4=subaxis(1,4,4,'SV',0.01,'SH',0.004,'MR',0.01,'ML',0.07,'PL',0.005,'PR',0.006);
%edges1=0.05;
%Xedges2D = linspace(-edges1,edges1);
%Yedges2D = linspace(0.0,edges1);
dum1 = v_new_par_4; dum2 = v_new_per_4;
[Ni,Xedgesi,Redgesi] = histcounts2(dum1,dum2,Xedges2D,Yedges2D);
Ni=Ni(1:99,1:99)';    Xedges2i=Xedgesi(2:100)'; Redges2i=Redgesi(2:100)';
Xedges2i=Xedges2i-(Xedges2i(2)-Xedges2i(1))/2;
Redges2i=Redges2i-(Redges2i(2)-Redges2i(1))/2;
[Ci,Di]=meshgrid(Xedges2i,Redges2i);
c_lim=0.5*10^6;
Ni(Ni<=no_le)=NaN;
Ni_4_0 = Ni;
hc=pcolor(Xedges2i,Redges2i, Ni./Di);
%hc=contourf(Xedges2i,Redges2i,Ni./Di,cll);
hold on
set(hc,'edgecolor','none');
set(gca,'ColorScale','log','FontSize',fs)
set(gca,'XScale','lin','YScale','lin','FontSize',fs)
colormap(h4,'jet');
caxis([1 (c_lim)]);
hcb=colorbar; hcb.Location = 'northoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.XLabel.String = '$v_{\parallel}/c$'; ax.XTick = xspace_par;
%ax.YLabel.String = '$v_{\perp}$';
ax.YTick = [];
xline(0,'--k'); yline(0,'--k');
%xlim([-edges1, edges1]); ylim([0 edges1]);
xlim(xlims); ylim(ylims);
title('R4','Interpreter','latex','FontSize',fs);
pbaspect([2 1 1])
hold off
%----------------------------------------------------------------------
sgtitle('$$log(f_{i}) \ ; \ t = \ $$'+string(round(time_t_2_Omega,2))+'$$\ \Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
%----------------------------------------------------------------------
% cd(path)
% saveas(f12,strcat('large_vper_par_R1R2R3R4' + string(round(time_t_2_Omega,2)) +'.png'));
%----------------------------------------------------------------------
%}












