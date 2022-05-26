%--------------------------------------------------------------------------
% this is to compute the average of the pitheta and piD

%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
cd '/Volumes/PSC_DiRAC_DATA/DATACB104/raw_data'; %This is important because the xdmf files are in that directory
path = '/Volumes/PSC_DiRAC_DATA/DATACB104/raw_data';

% useful parameters used in the simulation
%--------------------------------------------------------------------------
kb = 1.; mu0 =1.; mi_over_me_ =100.; vA_over_c_ = 0.1; B0_ = vA_over_c_;
mi = 1.; me = 1. / mi_over_me_; eps0=1.;
omega_pi=1;
Omega_e=vA_over_c_*sqrt(mi_over_me_)*omega_pi;
Omega_i=Omega_e / mi_over_me_;
TOmega_e=1/Omega_e; 
TOmega_i=1/Omega_i;
dt=0.06;
%------------------------------------------------------------------
%vectors as 1 arrow 3 columns
%mi=1;
mime=100;
%me=mi/mime;
qi=1;
qe=-1;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
S = dir(fullfile(path,'*.h5'));
N=numel(S); % number of files to use <---------------- This is the N 
H=zeros(N);
%in=30;
%i=2;
%--------------------------------------------------------------------------

% To save some variables in a file for all the times. Uncomment this when
% running again the program to generate the data
%--------------------------------------------------------------------------
%{
Vectorsc=cell(6,N);
Tensorsc=cell(4,N);
Densitiesc=cell(2,N);
Poyn_theoc=cell(3,N);
kin_energy_terms_ic=cell(4,N);
kin_energy_terms_ec=cell(4,N);
Int_energy_terms_ic=cell(7,N);
Int_energy_terms_ec=cell(7,N);
Param_proxiesc=cell(6,N);
%}
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
ptheta_pidi_avg=cell(N,4);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
nx1=166;    nx2=333;
ny1=232;    ny2=400;
nz1=1200;   nz2=1367;

%px2 = 400; py2 = 400; pz2 = 168; For the no reference change
px2 = 168; py2 = 168; pz2 = 168;
start = [nx1 ny1 nz1];
count = [px2 py2 pz2];
%--------------------------------------------------------------------------

resx=0.06; %0.06081
resy=0.06;
resz=0.06; %0.06152

Lx=px2*resx; k0x=1/Lx;
Ly=px2*resy; k0y=1/Ly;
Lz=px2*resz; k0z=1/Lz;
k00=sqrt(k0x*k0x + k0y*k0y + k0z*k0z);
%--------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


in=19;

%Here is where the xll is 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the whole core of the analysis and the data generation !! 
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
for in=2:N
%--------------------------------------------------------------------------
disp(strcat('Computing step ...',S(in).name))
%--------------------------------------------------------------------------
%N_steps = 2000;
%time_t = dt*N_steps; %(In terms of 1/omega_pi)
str = string(S(in).name);
newStr = extractBetween(str,"pfd.","_p000000.h5");
N_steps = str2double(newStr);
time_t = dt*N_steps;
%--------------------------------------------------------------------------

fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
T_1st = info.Groups(1).Name;
E_1st = info.Groups(17).Name;
B_1st = info.Groups(18).Name;
J_1st = info.Groups(19).Name;
V_1st = info.Groups(25).Name;
n_1st = info.Groups(23).Name;
%--------------------------------------------------------------------------

% Including the normalization of the quantities before hand 
%--------------------------------------------------------------------------
c=1;
VA2c = 1.;%0.1;
B0 = 1.;%VA2c;
E0 = 1.;%B0*VA2c;
Pi0 = 1.;%mi*VA2c*VA2c;
Pe0 = 1.;%me*VA2c*VA2c;
%--------------------------------------------------------------------------

%------------------------------------------------------------------
vi{1,1} =h5read(fileID,strcat(V_1st,'/vx_i/p0/3d'),start,count)./VA2c; %vix=vix(nx1:nx2,ny1:ny2,nz1:nz2);
vi{1,2} =h5read(fileID,strcat(V_1st,'/vy_i/p0/3d'),start,count)./VA2c; %viy=viy(nx1:nx2,ny1:ny2,nz1:nz2);
vi{1,3} =h5read(fileID,strcat(V_1st,'/vz_i/p0/3d'),start,count)./VA2c; %viz=viz(nx1:nx2,ny1:ny2,nz1:nz2);
ve{1,1} =h5read(fileID,strcat(V_1st,'/vx_e/p0/3d'),start,count)./VA2c; %vex=vex(nx1:nx2,ny1:ny2,nz1:nz2);
ve{1,2} =h5read(fileID,strcat(V_1st,'/vy_e/p0/3d'),start,count)./VA2c; %vey=vey(nx1:nx2,ny1:ny2,nz1:nz2);
ve{1,3} =h5read(fileID,strcat(V_1st,'/vz_e/p0/3d'),start,count)./VA2c; %vez=vez(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_i{1,1} =h5read(fileID,strcat(T_1st,'/Txx_i/p0/3d'),start,count)./Pi0; %Pxxi=Pxxi(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_i{1,2} =h5read(fileID,strcat(T_1st,'/Txy_i/p0/3d'),start,count)./Pi0; %Pxyi=Pxyi(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_i{1,3} =h5read(fileID,strcat(T_1st,'/Txz_i/p0/3d'),start,count)./Pi0; %Pxzi=Pxzi(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_i{2,2} =h5read(fileID,strcat(T_1st,'/Tyy_i/p0/3d'),start,count)./Pi0; %Pyyi=Pyyi(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_i{2,3} =h5read(fileID,strcat(T_1st,'/Tyz_i/p0/3d'),start,count)./Pi0; %Pyzi=Pyzi(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_i{3,3} =h5read(fileID,strcat(T_1st,'/Tzz_i/p0/3d'),start,count)./Pi0; %Pzzi=Pzzi(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_e{1,1} =h5read(fileID,strcat(T_1st,'/Txx_e/p0/3d'),start,count)./Pe0; %Pxxe=Pxxe(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_e{1,2} =h5read(fileID,strcat(T_1st,'/Txy_e/p0/3d'),start,count)./Pe0; %Pxye=Pxye(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_e{1,3} =h5read(fileID,strcat(T_1st,'/Txz_e/p0/3d'),start,count)./Pe0; %Pxze=Pxze(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_e{2,2} =h5read(fileID,strcat(T_1st,'/Tyy_e/p0/3d'),start,count)./Pe0; %Pyye=Pyye(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_e{2,3} =h5read(fileID,strcat(T_1st,'/Tyz_e/p0/3d'),start,count)./Pe0; %Pyze=Pyze(nx1:nx2,ny1:ny2,nz1:nz2);
Pij_e{3,3} =h5read(fileID,strcat(T_1st,'/Tzz_e/p0/3d'),start,count)./Pe0; %Pzze=Pzze(nx1:nx2,ny1:ny2,nz1:nz2);
%-------------------------------------------------------------------------------------------

ni{1,1} = h5read(fileID,strcat(n_1st,'/n_i/p0/3d'),start,count)./Pi0; %ni=ni(nx1:nx2,ny1:ny2,nz1:nz2);
ne{1,1} = h5read(fileID,strcat(n_1st,'/n_e/p0/3d'),start,count)./Pe0; %ni=ni(nx1:nx2,ny1:ny2,nz1:nz2);

% This is to get the central momment pressure.
%------------------------------------------------------------------
PPij_i=cell(3,3);
PPij_e=cell(3,3);
for i=1:3
    for j=1:3
        if(isempty(Pij_i{i,j}) == 1)
            continue
        end
        PPij_i{i,j} = Pij_i{i,j} - ni{1,1}.*mi.*vi{1,i}.*vi{1,j};
        PPij_e{i,j} = Pij_e{i,j} - ne{1,1}.*me.*ve{1,i}.*ve{1,j};
    end
end

% This is just to rename the variable  
Pij_i = PPij_i;
Pij_e = PPij_e;
%------------------------------------------------------------------

%--------------------------------------------------------------------------
%Now lets do the reference frame transformation
%--------------------------------------------------------------------------
% This is to get the quantities in the slide that is related to the correct plane
% or it seems that way.
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
xl=linspace(nx1,nx1+px2,px2)*resx;
yl=linspace(ny1,ny1+py2,py2)*resy;
zl=linspace(nz1,nz1+pz2,pz2)*resz;
%Pick the slide number along z-axes to get the plots
slide_n =83;
%--------------------------------------------------------------------------
[xm,ym] = meshgrid(xl,yl);
[xm3,ym3, zm3] = meshgrid(xl,yl,zl);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Now it's time to define the values for the slides coordinates
x_pi=60; y_pi=80; z_pi = 46; radi=100;
% xl_i=13.5212, yl_i=18.6884; zl_i=74.7162 <--- this are the values 
%y_pi=60;

% Extract the slide. This is to define the plane using a point a a normal
% vector

% To define the plane lets do the following: 
% 1) Pick the major axis along the current structure (i1p)
% 2) Define the plane perpendicular to the major axis. To do this lets pick
% a generic perpendicular vector 

% This is the point
pt = [x_pi y_pi z_pi]; %pt = [0 0 0];

% This is the normal vector to the plane perpendicular to the current (Vec adjacent)
vec_a = [1 0 -3.3333];
%vec_a = [1 0 0];
%vec_a = [-3.3333 0 1]; %This doesn't work as it is. There is a problem.
%See comment below
mag_va = sqrt(vec_a(1)*vec_a(1) + vec_a(2)*vec_a(2) + vec_a(3)*vec_a(3));
% This is the normal vector to the plane along the current (vec perpendicular) 
vec_p = [vec_a(1) vec_a(2) -(vec_a(1) + vec_a(2))/vec_a(3)]; 
mag_vp = sqrt(vec_p(1)*vec_p(1) + vec_p(2)*vec_p(2) + vec_p(3)*vec_p(3));
% This is the vector from the right hand rule
vec_rh = cross(vec_a, vec_p);
mag_vrh = sqrt(vec_rh(1)*vec_rh(1) + vec_rh(2)*vec_rh(2) + vec_rh(3)*vec_rh(3));
uip = vec_rh/mag_vrh; ujp = vec_a/mag_va; ukp = vec_p/mag_vp;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%uip=[1 0 0]; ujp=[0 1 0]; ukp=[0 0 1]; %This works to mantain the same reference frame 
%--------------------------------------------------------------------------
%To get the slides using the normal vector along the current filament
vec=vec_a; % <----------
%To get the slides using the normal vector perpendicular direction (z'')
%vec=vec_p;

% ------> NOTE: 
% When I use uip=[1 0 0]; ujp=[0 1 0]; ukp=[0 0 1]; and vec=ujp or vec=ukp
% it doesnt work =[] lots of nans
%vec=ukp;
%--------------------------------------------------------------------------
  
% Now lets compute the quantities in the new reference frame  (rh,a,p) 
%--------------------------------------------------------------------------
cd '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';


%Derivates%
%------------------------------------------------------------------
%Grad_vi
[vix_x,vix_y,vix_z] = gradient(vi{1,1});
[viy_x,viy_y,viy_z] = gradient(vi{1,2});
[viz_x,viz_y,viz_z] = gradient(vi{1,3});
grad_vi{1,1} = vix_x/resx; grad_vi{1,2} = viy_x/resx; grad_vi{1,3} = viz_x/resx;
grad_vi{2,1} = vix_y/resy; grad_vi{2,2} = viy_y/resy; grad_vi{2,3} = viz_y/resy;
grad_vi{3,1} = vix_z/resz; grad_vi{3,2} = viy_z/resz; grad_vi{3,3} = viz_z/resz;

clearvars vix_x vix_y vix_z viy_x viy_y viy_z viz_x viz_y viz_z 
Div_vi=grad_vi{1,1} + grad_vi{2,2} + grad_vi{3,3};

%Grad_ve
[vex_x,vex_y,vex_z] = gradient(ve{1,1});
[vey_x,vey_y,vey_z] = gradient(ve{1,2});
[vez_x,vez_y,vez_z] = gradient(ve{1,3});
grad_ve{1,1} = vex_x/resx; grad_ve{1,2} = vey_x/resx; grad_ve{1,3} = vez_x/resx;
grad_ve{2,1} = vex_y/resy; grad_ve{2,2} = vey_y/resy; grad_ve{2,3} = vez_y/resy;
grad_ve{3,1} = vex_z/resz; grad_ve{3,2} = vey_z/resz; grad_ve{3,3} = vez_z/resz;

clearvars vex_x vex_y vex_z vey_x vey_y vey_z vez_x vez_y vez_z 
Div_ve=grad_ve{1,1} + grad_ve{2,2} + grad_ve{3,3};
%------------------------------------------------------------------

% Pi-D and ptheta terms
%------------------------------------------------------------------
p_i = (Pij_i{1,1} + Pij_i{2,2} + Pij_i{3,3})./3;  
p_e = (Pij_e{1,1} + Pij_e{2,2} + Pij_e{3,3})./3;  

theta_i =  grad_vi{1,1} + grad_vi{2,2} + grad_vi{3,3};
theta_e =  grad_ve{1,1} + grad_ve{2,2} + grad_ve{3,3};

DD_i{1,1} = (grad_vi{1,1})-theta_i./3; DD_i{1,2} = 0.5.*(grad_vi{1,2}+grad_vi{2,1}); DD_i{1,3} = 0.5.*(grad_vi{1,3}+grad_vi{3,1}); 
DD_i{2,1} = DD_i{1,2};                 DD_i{2,2} = (grad_vi{2,2})-theta_i./3;        DD_i{2,3} = 0.5.*(grad_vi{2,3}+grad_vi{3,2});
DD_i{3,1} = DD_i{1,3};                 DD_i{3,2} = DD_i{2,3};                        DD_i{3,3} = (grad_vi{3,3})-theta_i./3;  

DD_e{1,1} = (grad_ve{1,1})-theta_e./3; DD_e{1,2} = 0.5.*(grad_ve{1,2}+grad_ve{2,1}); DD_e{1,3} = 0.5.*(grad_ve{1,3}+grad_ve{3,1}); 
DD_e{2,1} = DD_e{1,2};                 DD_e{2,2} = (grad_ve{2,2})-theta_e./3;        DD_e{2,3} = 0.5.*(grad_ve{2,3}+grad_ve{3,2});
DD_e{3,1} = DD_e{1,3};                 DD_e{3,2} = DD_e{2,3};                        DD_e{3,3} = (grad_ve{3,3})-theta_e./3;  

p_theta_i = p_i.*theta_i;
p_theta_e = p_e.*theta_e;

PiD_i = Pij_i{1,1}.*DD_i{1,1} + Pij_i{1,2}.*DD_i{1,2} + Pij_i{1,3}.*DD_i{1,3} + ...
        Pij_i{1,2}.*DD_i{2,1} + Pij_i{2,2}.*DD_i{2,2} + Pij_i{2,3}.*DD_i{2,3} + ...
        Pij_i{1,3}.*DD_i{3,1} + Pij_i{2,3}.*DD_i{3,2} + Pij_i{3,3}.*DD_i{3,3};

PiD_e = Pij_e{1,1}.*DD_e{1,1} + Pij_e{1,2}.*DD_e{1,2} + Pij_e{1,3}.*DD_e{1,3} + ...
        Pij_e{1,2}.*DD_e{2,1} + Pij_e{2,2}.*DD_e{2,2} + Pij_e{2,3}.*DD_e{2,3} + ...
        Pij_e{1,3}.*DD_e{3,1} + Pij_e{2,3}.*DD_e{3,2} + Pij_e{3,3}.*DD_e{3,3};  
   
%------------------------------------------------------------------


% Averaging this terms over the subdomain
%--------------------------------------------------------------------------
% Parameter proxies 
p_theta_i_avg = mean(p_theta_i,'all') ;
p_theta_e_avg = mean(p_theta_e,'all') ;
PiD_i_avg = mean(PiD_i,'all') ;
PiD_e_avg = mean(PiD_e,'all') ;

ptheta_pidi_avg{in,1} = p_theta_i_avg;
ptheta_pidi_avg{in,2} = p_theta_e_avg;
ptheta_pidi_avg{in,3} = PiD_i_avg;
ptheta_pidi_avg{in,4} = PiD_e_avg;
cd '/Volumes/PSC_DiRAC_DATA/DATACB104/raw_data';
%--------------------------------------------------------------------------
end

% These are the data of ptheta PiD averaged over the subdomain box 
load('/Volumes/PSC_DiRAC_DATA/Energy_Budget_things/ptheta_PiD_time_sub.mat')

%--------------------------------------------------------------------------
% get the data in a table to use that syntaxis 
%T_energy_terms_table = cell2table(T_energy_terms');
%--------------------------------------------------------------------------
% get the data in a array to use that syntaxis 

% this is to fix the problem of keeping a cell empty
ptheta_pidi_avg{1,1} = single(0);
ptheta_pidi_avg{1,2} = single(0);
ptheta_pidi_avg{1,3} = single(0);
ptheta_pidi_avg{1,4} = single(0);

ptheta_pidi_table = cell2mat(ptheta_pidi_avg);

p_theta_i_j = ptheta_pidi_table(:,1); 
p_theta_e_j = ptheta_pidi_table(:,2);
PiD_i_j = ptheta_pidi_table(:,3);
PiD_e_j =ptheta_pidi_table(:,4);

%--------------------------------------------------------------------------
%
cd '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here'
load('colorblind_colormap.mat');
%--------------------------------------------------------------------------

%Create the time array
time_line=zeros(1,N);
dt = 0.06;
for in=2:N-1
str = string(S(in).name);
newStr = extractBetween(str,"pfd.","_p000000.h5");
N_steps = str2double(newStr); time_t = dt*N_steps;
time_line(1,in) = time_t; 
end

time = time_line';

% energies
%--------------------------------------------------------------------------
%
c=1;
VA2c = 0.1;
B0 = VA2c;
E0 = B0*VA2c;
Pi0 = mi*VA2c*VA2c;
Pe0 = me*VA2c*VA2c;
lw = 3;
fs=25;
f214 = figure(214);
plot(time(2:end-1),p_theta_i_j(2:end-1)./Pi0,'Color',colorblind(1,:), 'LineWidth', lw)
hold on
plot(time(2:end-1),p_theta_e_j(2:end-1)./Pi0,'Color',colorblind(2,:), 'LineWidth', lw)
plot(time(2:end-1),PiD_i_j(2:end-1)./Pi0,'Color',colorblind(6,:), 'LineWidth', lw)
plot(time(2:end-1),PiD_e_j(2:end-1)./Pi0,'Color',colorblind(7,:), 'LineWidth', lw)
legend('$\frac{p\theta_{i}}{\Delta\varepsilon_{0}}$','$\frac{p\theta_{e}}{\Delta\varepsilon_{0}}$',...
    '$\frac{PiD_{i}}{\Delta\varepsilon_{0}}$',...
    '$\frac{PiD_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',fs)
%xline(4,'--k'); xline(8,'--k'); xline(5.7,'--b')
ax = gca;
ax.FontSize = fs;
ax.TickLabelInterpreter ='latex';
xlabel('$t \omega_{pi}$','Interpreter','latex','FontSize',fs)
ylabel('Energy transfer rates','Interpreter','latex','FontSize',fs)
xlim([24,456])
%ylim([-1.9, 1.9])
%sgtitle('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{i}^{-1}$$','Interpreter','latex','FontSize',20)
hold off


% Compute the integration over time % These are the values
%--------------------------------------------------------------------------
p_theta_i_time = sum(p_theta_i_j(2:end-1))./Pi0 %0.1128 R%  0.1051
p_theta_e_time = sum(p_theta_e_j(2:end-1))./Pi0 %0.0137 R%  0.0125
PiD_i_time = sum(PiD_i_j(2:end-1))./Pi0 %-0.0311        R% -0.0374 
PiD_e_time = sum(PiD_e_j(2:end-1))./Pi0 %-0.0190        R% -0.0133
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
cd '/Volumes/PSC_DiRAC_DATA/Energy_Budget_things'
saveas(f214,strcat('ptheta_PiD_time_2_'+ string(N_steps) +'.png'));
cd '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here'
%--------------------------------------------------------------------------
