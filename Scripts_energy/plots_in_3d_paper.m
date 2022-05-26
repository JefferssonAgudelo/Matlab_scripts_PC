% This script is to make the 3d plots 

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
%
Vectorsc=cell(6,N);
Tensorsc=cell(4,N);
Densitiesc=cell(2,N);
Poyn_theoc=cell(3,N);
kin_energy_terms_ic=cell(4,N);
kin_energy_terms_ec=cell(4,N);
Int_energy_terms_ic=cell(7,N);
Int_energy_terms_ec=cell(7,N);
Param_proxiesc=cell(6,N);

%T_energy_terms_sub=cell(8,N);
Xi_k_i_in=zeros(1,N);
Xi_k_e_in=zeros(1,N);
Xi_th_i_in=zeros(1,N);
Xi_th_e_in=zeros(1,N);
%}
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




%This is the block which computes the energy averages for the sub box. 10/05/2022 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the whole core of the analysis and the data generation !! 
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
for in=1:N-1
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
B{1,1} =h5read(fileID,strcat(B_1st,'/hx/p0/3d'),start,count)./B0; %Bx=Bx(nx1:nx2,ny1:ny2,nz1:nz2);
B{1,2} =h5read(fileID,strcat(B_1st,'/hy/p0/3d'),start,count)./B0; %By=By(nx1:nx2,ny1:ny2,nz1:nz2);
B{1,3} =h5read(fileID,strcat(B_1st,'/hz/p0/3d'),start,count)./B0; %Bz=Bz(nx1:nx2,ny1:ny2,nz1:nz2);
E{1,1} =h5read(fileID,strcat(E_1st,'/ex/p0/3d'),start,count)./E0; %Ex=Ex(nx1:nx2,ny1:ny2,nz1:nz2);
E{1,2} =h5read(fileID,strcat(E_1st,'/ey/p0/3d'),start,count)./E0; %Ey=Ey(nx1:nx2,ny1:ny2,nz1:nz2);
E{1,3} =h5read(fileID,strcat(E_1st,'/ez/p0/3d'),start,count)./E0; %Ez=Ez(nx1:nx2,ny1:ny2,nz1:nz2);
J{1,1} =h5read(fileID,strcat(J_1st,'/jx/p0/3d'),start,count)./VA2c; %Jx=Jx(nx1:nx2,ny1:ny2,nz1:nz2);
J{1,2} =h5read(fileID,strcat(J_1st,'/jy/p0/3d'),start,count)./VA2c; %Jy=Jy(nx1:nx2,ny1:ny2,nz1:nz2);
J{1,3} =h5read(fileID,strcat(J_1st,'/jz/p0/3d'),start,count)./VA2c; %Jz=Jz(nx1:nx2,ny1:ny2,nz1:nz2);
vi{1,1} =h5read(fileID,strcat(V_1st,'/vx_i/p0/3d'),start,count)./VA2c; %vix=vix(nx1:nx2,ny1:ny2,nz1:nz2);
vi{1,2} =h5read(fileID,strcat(V_1st,'/vy_i/p0/3d'),start,count)./VA2c; %viy=viy(nx1:nx2,ny1:ny2,nz1:nz2);
vi{1,3} =h5read(fileID,strcat(V_1st,'/vz_i/p0/3d'),start,count)./VA2c; %viz=viz(nx1:nx2,ny1:ny2,nz1:nz2);
ve{1,1} =h5read(fileID,strcat(V_1st,'/vx_e/p0/3d'),start,count)./VA2c; %vex=vex(nx1:nx2,ny1:ny2,nz1:nz2);
ve{1,2} =h5read(fileID,strcat(V_1st,'/vy_e/p0/3d'),start,count)./VA2c; %vey=vey(nx1:nx2,ny1:ny2,nz1:nz2);
ve{1,3} =h5read(fileID,strcat(V_1st,'/vz_e/p0/3d'),start,count)./VA2c; %vez=vez(nx1:nx2,ny1:ny2,nz1:nz2);
ni{1,1} = h5read(fileID,strcat(n_1st,'/n_i/p0/3d'),start,count); %ni=ni(nx1:nx2,ny1:ny2,nz1:nz2);
ne{1,1} = h5read(fileID,strcat(n_1st,'/n_e/p0/3d'),start,count); %ne=ne(nx1:nx2,ny1:ny2,nz1:nz2);
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

% The internal energy can be compute using (1/2)Pij_i/ni?
%------------------------------------------------------------------
%{
PPij_i=cell(3,3);
PPij_e=cell(3,3);
for i=1:3
    for j=1:3
        if(isempty(Pij_i{i,j}) == 1)
            continue
        end
        PPij_i{i,j} = Pij_i{i,j} - ni.*mi.*vi{1,i}.*vi{1,j};
        PPij_e{i,j} = Pij_e{i,j} - ne.*me.*ve{1,i}.*ve{1,j};
    end
end
Pij_i=PPij_i;
Pij_e=PPij_e;
%}
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
% For vectors apply the function directly
%--------------------------------------------------------------------------
% Magnetic field in the prime reference frame
Qb = cell(1,3);
Qb{1,1} = B{1,1}; Qb{1,2} = B{1,2}; Qb{1,3} = B{1,3};% -0.1; % it is very important to remember this substraction
B = Ref_Frame_2(uip,ujp,ukp,Qb); clearvars Qb;
% Electric field
Qb=E;
E = Ref_Frame_2(uip,ujp,ukp,Qb); clearvars Qb
% Current
Qb=J;
J = Ref_Frame_2(uip,ujp,ukp,Qb); clearvars Qb
% Ion velocity
Qb=vi;
vi = Ref_Frame_2(uip,ujp,ukp,Qb); clearvars Qb
% Electron velocity
Qb=ve;
ve = Ref_Frame_2(uip,ujp,ukp,Qb); clearvars Qb
%--------------------------------------------------------------------------

% The densities which are scalars are invariant uner coordinates transformations. 

%--------------------------------------------------------------------------
%Now the proper transformation of the tensor.
%--------------------------------------------------------------------------
%For ions
GPij=cell(3,3);
%--------------------------------------------------------------------------
% Make the tensor [3, 3] for the ions
GPij{1,1}=Pij_i{1,1}; GPij{1,2}=Pij_i{1,2}; GPij{1,3}=Pij_i{1,3};
GPij{2,1}=Pij_i{1,2}; GPij{2,2}=Pij_i{2,2}; GPij{2,3}=Pij_i{2,3};
GPij{3,1}=Pij_i{1,3}; GPij{3,2}=Pij_i{2,3}; GPij{3,3}=Pij_i{3,3};
Qb=GPij;
Pij_i = Ref_Frame_2(uip,ujp,ukp,Qb); clearvars Qb
% Make the tensor [3, 3] for the electrons
GPij{1,1}=Pij_e{1,1}; GPij{1,2}=Pij_e{1,2}; GPij{1,3}=Pij_e{1,3};
GPij{2,1}=Pij_e{1,2}; GPij{2,2}=Pij_e{2,2}; GPij{2,3}=Pij_e{2,3};
GPij{3,1}=Pij_e{1,3}; GPij{3,2}=Pij_e{2,3}; GPij{3,3}=Pij_e{3,3};
Qb=GPij;
Pij_e = Ref_Frame_2(uip,ujp,ukp,Qb); clearvars Qb
%--------------------------------------------------------------------------

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


%In the new reference frame the (rh,a,p) calculate the energy terms
%--------------------------------------------------------------------------
% This is to unlock. These are the lines to calculate the energy terms
%{\  
% Get again the densities right
%ni=nic1{1,1};
%ne=nec1{1,1};
% Kinetic energy densities 
%------------------------------------------------------------------
Ki = 0.5.*ni{1,1}.* mi.*(vi{1,1}.*vi{1,1} + vi{1,2}.*vi{1,2} + vi{1,3}.*vi{1,3});
Ke = 0.5.*ne{1,1}.* me.*(ve{1,1}.*ve{1,1} + ve{1,2}.*ve{1,2} + ve{1,3}.*vi{1,3});
%------------------------------------------------------------------

% Internal energy densities from Fadanelli et al, 2020 
%------------------------------------------------------------------
Ui = 0.5.*(Pij_i{1,1} + Pij_i{2,2} + Pij_i{3,3});
Ue = 0.5.*(Pij_e{1,1} + Pij_e{2,2} + Pij_e{3,3});
%------------------------------------------------------------------

%For the partial time derivative
%------------------------------------------------------------------
%{
Ki_1 = Ki;
Ke_1 = Ke;
Ui_1 = Ui;
Ue_1 = Ue;
%clearvars -except Ki_0 Ke_0 Ui_0 Ue_0 
partialKi = (Ki_1 - Ki_0)/6;
partialKe = (Ke_1 - Ke_0)/6;
partialUi = (Ui_1 - Ui_0)/6;
partialUe = (Ue_1 - Ue_0)/6;
%}
%------------------------------------------------------------------

%Derivates%
%------------------------------------------------------------------
%Grad_B
[Bx_x,Bx_y,Bx_z] = gradient(B{1,1});
[By_x,By_y,By_z] = gradient(B{1,2});
[Bz_x,Bz_y,Bz_z] = gradient(B{1,3});
grad_B{1,1} = Bx_x/resx; grad_B{1,2} = By_x/resx; grad_B{1,3} = Bz_x/resx;
grad_B{2,1} = Bx_y/resy; grad_B{2,2} = By_y/resy; grad_B{2,3} = Bz_y/resy;
grad_B{3,1} = Bx_z/resz; grad_B{3,2} = By_z/resz; grad_B{3,3} = Bz_z/resz;

clearvars Bx_x Bx_y Bx_z By_x By_y By_z Bz_x Bz_y Bz_z 
Div_B=grad_B{1,1} + grad_B{2,2} + grad_B{3,3};

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

%Grad_Pi
[Pxxi_x, Pxxi_y, Pxxi_z] = gradient(Pij_i{1,1}); 
[Pyyi_x, Pyyi_y, Pyyi_z] = gradient(Pij_i{2,2}); 
[Pzzi_x, Pzzi_y, Pzzi_z] = gradient(Pij_i{3,3}); 
[Pxyi_x, Pxyi_y, Pxyi_z] = gradient(Pij_i{1,2}); 
[Pxzi_x, Pxzi_y, Pxzi_z] = gradient(Pij_i{1,3}); 
[Pyzi_x, Pyzi_y, Pyzi_z] = gradient(Pij_i{2,3});
Div_Pi_t{1,1} = Pxxi_x/resx + Pxyi_y/resy + Pxzi_z/resz;  
Div_Pi_t{1,2} = Pxyi_x/resx + Pyyi_y/resy + Pyzi_z/resz; 
Div_Pi_t{1,3} = Pxzi_x/resx + Pyzi_y/resy + Pzzi_z/resz;
clearvars Pxxi_y Pxxi_z Pyyi_x Pyyi_z Pzzi_x Pzzi_z Pxyi_z Pxzi_y Pyzi_x
clearvars Pxxi_x Pxyi_x Pxyi_y Pyyi_y Pyzi_y Pyzi_z Pxzi_x Pxzi_z Pzzi_z

%Grad_Pe
[Pxxe_x, Pxxe_y, Pxxe_z] = gradient(Pij_e{1,1}); 
[Pyye_x, Pyye_y, Pyye_z] = gradient(Pij_e{2,2}); 
[Pzze_x, Pzze_y, Pzze_z] = gradient(Pij_e{3,3}); 
[Pxye_x, Pxye_y, Pxye_z] = gradient(Pij_e{1,2}); 
[Pxze_x, Pxze_y, Pxze_z] = gradient(Pij_e{1,3}); 
[Pyze_x, Pyze_y, Pyze_z] = gradient(Pij_e{2,3});
Div_Pe_t{1,1} = Pxxe_x/resx + Pxye_y/resy + Pxze_z/resz;  
Div_Pe_t{1,2} = Pxye_x/resx + Pyye_y/resy + Pyze_z/resz; 
Div_Pe_t{1,3} = Pxze_x/resx + Pyze_y/resy + Pzze_z/resz;
clearvars Pxxe_y Pxxe_z Pyye_x Pyye_z Pzze_x Pzze_z Pxye_z Pxze_y Pyze_x
clearvars Pxxe_x Pxye_x Pxye_y Pyye_y Pyze_y Pyze_z Pxze_x Pxze_z Pzze_z

%Grad_Ki
[Ki_x,Ki_y,Ki_z] = gradient(Ki);
grad_Ki{1,1} = Ki_x/resx; 
grad_Ki{1,2} = Ki_y/resy; 
grad_Ki{1,3} = Ki_z/resz;
clearvars Ki_x Ki_y Ki_z

%Grad_Ki
[Ke_x,Ke_y,Ke_z] = gradient(Ke);
grad_Ke{1,1} = Ke_x/resx; 
grad_Ke{1,2} = Ke_y/resy; 
grad_Ke{1,3} = Ke_z/resz;
clearvars Ke_x Ke_y Ke_z

%Grad_Ui
[Ui_x,Ui_y,Ui_z] = gradient(Ui);
grad_Ui{1,1} = Ui_x/resx; 
grad_Ui{1,2} = Ui_y/resy; 
grad_Ui{1,3} = Ui_z/resz;
clearvars Ui_x Ui_y Ui_z

%Grad_Ue
[Ue_x,Ue_y,Ue_z] = gradient(Ue);
grad_Ue{1,1} = Ue_x/resx; 
grad_Ue{1,2} = Ue_y/resy; 
grad_Ue{1,3} = Ue_z/resz;
clearvars Ue_x Ue_y Ue_z
%------------------------------------------------------------------


% Dyadic products
%------------------------------------------------------------------
%vivi and %veve
vivi=cell(3,3);
veve=cell(3,3);
for i=1:3
    for j=1:3
        vivi{i,j} = vi{1,i}.*vi{1,j};
        veve{i,j} = ve{1,i}.*ve{1,j};
    end
end

%Pivi
Pit_vi{1,1} = Pij_i{1,1}.*vi{1,1} + Pij_i{1,2}.*vi{1,2} + Pij_i{1,3}.*vi{1,3};
Pit_vi{1,2} = Pij_i{1,2}.*vi{1,1} + Pij_i{2,2}.*vi{1,2} + Pij_i{2,3}.*vi{1,3};
Pit_vi{1,3} = Pij_i{1,3}.*vi{1,1} + Pij_i{2,3}.*vi{1,2} + Pij_i{3,3}.*vi{1,3};

%Peve
Pet_ve{1,1} = Pij_e{1,1}.*ve{1,1} + Pij_e{1,2}.*ve{1,2} + Pij_e{1,3}.*ve{1,3};
Pet_ve{1,2} = Pij_e{1,2}.*ve{1,1} + Pij_e{2,2}.*ve{1,2} + Pij_e{2,3}.*ve{1,3};
Pet_ve{1,3} = Pij_e{1,3}.*ve{1,1} + Pij_e{2,3}.*ve{1,2} + Pij_e{3,3}.*ve{1,3};
%------------------------------------------------------------------


% Scalar products
%------------------------------------------------------------------
% Pit_grad_vi. this the the same double dot procut
Pit_grad_vi = Pij_i{1,1}.*grad_vi{1,1} + Pij_i{1,2}.*grad_vi{1,2} + Pij_i{1,3}.*grad_vi{1,3} +...
              Pij_i{1,2}.*grad_vi{2,1} + Pij_i{2,2}.*grad_vi{2,2} + Pij_i{2,3}.*grad_vi{2,3} +...
              Pij_i{1,3}.*grad_vi{3,1} + Pij_i{2,3}.*grad_vi{3,2} + Pij_i{3,3}.*grad_vi{3,3};

% Pet_grad_ve
Pet_grad_ve = Pij_e{1,1}.*grad_ve{1,1} + Pij_e{1,2}.*grad_ve{1,2} + Pij_e{1,3}.*grad_ve{1,3} +...
              Pij_e{1,2}.*grad_ve{2,1} + Pij_e{2,2}.*grad_ve{2,2} + Pij_e{2,3}.*grad_ve{2,3} +...
              Pij_e{1,3}.*grad_ve{3,1} + Pij_e{2,3}.*grad_ve{3,2} + Pij_e{3,3}.*grad_ve{3,3};

%--------------------------------------------------------------------------          
% Diagonal          
% Pit_grad_vi_ii
Pit_grad_vi_ii = Pij_i{1,1}.*grad_vi{1,1} + Pij_i{2,2}.*grad_vi{2,2} + Pij_i{3,3}.*grad_vi{3,3};

% Pet_grad_ve_ii
Pet_grad_ve_ii = Pij_e{1,1}.*grad_ve{1,1} + Pij_e{2,2}.*grad_ve{2,2} + Pij_e{3,3}.*grad_ve{3,3};

% Off diagonal
% Pit_grad_vi_ij
Pit_grad_vi_ij = Pij_i{1,2}.*grad_vi{1,2} + Pij_i{1,3}.*grad_vi{1,3} + Pij_i{1,2}.*grad_vi{2,1} +...
                 Pij_i{2,3}.*grad_vi{2,3} + Pij_i{1,3}.*grad_vi{3,1} + Pij_i{2,3}.*grad_vi{3,2};

% Pet_grad_ve_ij
Pet_grad_ve_ij =  Pij_e{1,2}.*grad_ve{1,2} + Pij_e{1,3}.*grad_ve{1,3} + Pij_e{1,2}.*grad_ve{2,1} +...
                  Pij_e{2,3}.*grad_ve{2,3} + Pij_e{1,3}.*grad_ve{3,1} + Pij_e{2,3}.*grad_ve{3,2};
%--------------------------------------------------------------------------          
              
% vi_Div_Pit
vi_Div_Pit = vi{1,1}.*Div_Pi_t{1,1} + vi{1,2}.*Div_Pi_t{1,2} + vi{1,3}.*Div_Pi_t{1,3}; 

% ve_Div_Pet
ve_Div_Pet = ve{1,1}.*Div_Pe_t{1,1} + ve{1,2}.*Div_Pe_t{1,2} + ve{1,3}.*Div_Pe_t{1,3}; 

%--------------------------------------------------------------------------
% Div_Pi_dot_vi
Div_Pis_dot_vi = Pit_grad_vi + vi_Div_Pit;
% Div_Pe_dot_e
Div_Pes_dot_ve = Pet_grad_ve + ve_Div_Pet;
%--------------------------------------------------------------------------

% Ki_Div_vi
Ki_Div_vi = Ki.*Div_vi; 

% Ke_Div_ve
Ke_Div_ve = Ke.*Div_ve; 

% Ui_Div_vi
Ui_Div_vi = Ui.*Div_vi; 

% Ke_Div_ve
Ue_Div_ve = Ue.*Div_ve; 

%qi_ni_vi_E
qi_ni_vi_E = qi.*ni{1,1}.*(vi{1,1}.*E{1,1} + vi{1,2}.*E{1,2} + vi{1,3}.*E{1,3});

%qe_ne_ve_E
qe_ne_ve_E = qe.*ne{1,1}.*(ve{1,1}.*E{1,1} + ve{1,2}.*E{1,2} + ve{1,1}.*E{1,3});

%vi_grad_Ki
vi_grad_Ki = vi{1,1}.*grad_Ki{1,1} + vi{1,2}.*grad_Ki{1,2} + vi{1,3}.*grad_Ki{1,3}; 

%ve_grad_Ke
ve_grad_Ke = ve{1,1}.*grad_Ke{1,1} + ve{1,2}.*grad_Ke{1,2} + ve{1,3}.*grad_Ke{1,3}; 

%vi_grad_Ui
vi_grad_Ui = vi{1,1}.*grad_Ui{1,1} + vi{1,2}.*grad_Ui{1,2} + vi{1,3}.*grad_Ui{1,3}; 

%ve_grad_Ue
ve_grad_Ue = ve{1,1}.*grad_Ue{1,1} + ve{1,2}.*grad_Ue{1,2} + ve{1,3}.*grad_Ue{1,3}; 
%------------------------------------------------------------------


% Zenitani paramater
%------------------------------------------------------------------
Zernitani_i =  (J{1,1} -ni{1,1}.*qi.*vi{1,1}).*E{1,1} + J{1,1}.*(vi{1,2}.*B{1,3} -vi{1,3}.*B{1,2}) + ...
               (J{1,2} -ni{1,1}.*qi.*vi{1,2}).*E{1,2} + J{1,2}.*(vi{1,3}.*B{1,1} -vi{1,1}.*B{1,3}) + ...
               (J{1,3} -ni{1,1}.*qi.*vi{1,3}).*E{1,3} + J{1,3}.*(vi{1,1}.*B{1,2} -vi{1,2}.*B{1,1});
           
Zernitani_e =  (J{1,1} -ne{1,1}.*qe.*ve{1,1}).*E{1,1} + J{1,1}.*(ve{1,2}.*B{1,3} -ve{1,3}.*B{1,2}) + ...
               (J{1,2} -ne{1,1}.*qe.*ve{1,2}).*E{1,2} + J{1,2}.*(ve{1,3}.*B{1,1} -ve{1,1}.*B{1,3}) + ...
               (J{1,3} -ne{1,1}.*qe.*ve{1,3}).*E{1,3} + J{1,3}.*(ve{1,1}.*B{1,2} -ve{1,2}.*B{1,1});           
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
        Pij_i{2,1}.*DD_i{2,1} + Pij_i{2,2}.*DD_i{2,2} + Pij_i{2,3}.*DD_i{2,3} + ...
        Pij_i{3,1}.*DD_i{3,1} + Pij_i{3,2}.*DD_i{3,2} + Pij_i{3,3}.*DD_i{3,3};

PiD_e = Pij_e{1,1}.*DD_e{1,1} + Pij_e{1,2}.*DD_e{1,2} + Pij_e{1,3}.*DD_e{1,3} + ...
        Pij_e{2,1}.*DD_e{2,1} + Pij_e{2,2}.*DD_e{2,2} + Pij_e{2,3}.*DD_e{2,3} + ...
        Pij_e{3,1}.*DD_e{3,1} + Pij_e{3,2}.*DD_e{3,2} + Pij_e{3,3}.*DD_e{3,3};  
   
%------------------------------------------------------------------


%------------------------------------------------------------------
% From the definition in the code I think Tij is actually Pij as
% Pij = m * int f(vi - ui)(vj - uj) dv^3 and not int( fvivj )dv^3 which is
% PPij = Pij + nmuiuj 
% (HERE PPij is for the total energy and Pij is the thermal, the other way aroaund from the notes)

% The internal energy can be compute using (1/2)Pij_i/ni?
%------------------------------------------------------------------
PPij_i=cell(3,3);
PPij_e=cell(3,3);
for i=1:3
    for j=1:3
        if(isempty(Pij_i{i,j}) == 1)
            continue
        end
        PPij_i{i,j} = Pij_i{i,j} + ni{1,1}.*mi.*vi{1,i}.*vi{1,j};
        PPij_e{i,j} = Pij_e{i,j} + ne{1,1}.*me.*ve{1,i}.*ve{1,j};
    end
end
%------------------------------------------------------------------


% Calculating the temperatures
%------------------------------------------------------------------
Tij_i=cell(3,3);
Tij_e=cell(3,3);
for i=1:3
    for j=1:3
        if(isempty(Pij_i{i,j}) == 1)
            continue
        end
        Tij_i{i,j} =Pij_i{i,j}./(3.*ni{1,1});
        Tij_e{i,j} =Pij_e{i,j}./(3.*ne{1,1});
    end
end
%------------------------------------------------------------------


%Lets compute the averages to see what is what
%------------------------------------------------------------------
ni_bar=mean(ni{1,1},'all');
ne_bar=mean(ne{1,1},'all');

PPij_i_bar=zeros(3);
PPij_e_bar=zeros(3);
Tij_i_bar=zeros(3);
Tij_e_bar=zeros(3);
for i=1:3
    for j=1:3
        PPij_i_bar(i,j)=mean(PPij_i{i,j}, 'all');
        PPij_e_bar(i,j)=mean(PPij_e{i,j}, 'all');
        Tij_i_bar(i,j)=mean(Tij_i{i,j}, 'all');
        Tij_e_bar(i,j)=mean(Tij_e{i,j}, 'all');
    end 
end

%{
Pij_i{1,1} = Pxxi; Pij_i{1,2} = Pxyi; Pij_i{1,3} = Pxzi; 
Pij_i{2,1} = Pxyi; Pij_i{2,2} = Pyyi; Pij_i{2,3} = Pyzi; 
Pij_i{3,1} = Pxzi; Pij_i{3,2} = Pyzi; Pij_i{3,3} = Pzzi; 
clearvars Pxxi Pxyi Pxzi Pyyi Pyzi Pzzi
Pij_e{1,1} = Pxxe; Pij_e{1,2} = Pxye; Pij_e{1,3} = Pxze; 
Pij_e{2,1} = Pxye; Pij_e{2,2} = Pyye; Pij_e{2,3} = Pyze; 
Pij_e{3,1} = Pxze; Pij_e{3,2} = Pyze; Pij_e{3,3} = Pzze; 
clearvars Pxxe Pxye Pxze Pyye Pyzi Pzze
%}
Pij_i_bar=zeros(3);
Pij_e_bar=zeros(3);
for i=1:3
    for j=1:3
        Pij_i_bar(i,j)=mean(Pij_i{i,j}, 'all');
        Pij_e_bar(i,j)=mean(Pij_e{i,j}, 'all');
    end 
end
%------------------------------------------------------------------


% To calculate the grad of the heat flux vector wang et al, 2015
%------------------------------------------------------------------

vth_i = sqrt((Tij_i{1,1} + Tij_i{2,2} + Tij_i{3,3})./(3*mi));
vth_e = sqrt((Tij_e{1,1} + Tij_e{2,2} + Tij_e{3,3})./(3*me));


%(HERE PPij is for the total energy and Qij is the (v-u)..., the other way aroaund from the notes)
%dkQijk_i{1,1} = vth_i.*k00.*( Pij_i{1,1} - Pij_i_bar(1,1) - ((ni - ni_bar).*Tij_i_bar(1,1)));
dk_Qijk_i=cell(3,3);
dk_Qijk_e=cell(3,3);
for i=1:3
    for j=1:3
        if(isempty(PPij_i{i,j}) == 1)
            continue
        end
        dk_Qijk_i{i,j} = vth_i.*k00.*( Pij_i{i,j} - Pij_i_bar(i,j) - ((i == j).*(ni{1,1} - ni_bar).*Tij_i_bar(i,j)));
        dk_Qijk_e{i,j} = vth_e.*k00.*( Pij_e{i,j} - Pij_e_bar(i,j) - ((i == j).*(ne{1,1} - ne_bar).*Tij_e_bar(i,j)));        
    end
end

dk_Qijk_i2=cell(3,3);
dk_Qijk_e2=cell(3,3);
for i=1:3
    for j=1:3
        if(isempty(PPij_i{i,j}) == 1)
            continue
        end
        dk_Qijk_i2{i,j} = -(vth_i./k00).*del2( Pij_i{i,j} - Pij_i_bar(i,j));
        dk_Qijk_e2{i,j} = -(vth_e./k00).*del2( Pij_e{i,j} - Pij_e_bar(i,j));        
    end
end

% This is to smooth the second derivative thing
%-------------------------------------------------------------------------
filtvec3=[3,3,3];
dk_Qijk_i3=cell(3,3);
dk_Qijk_e3=cell(3,3);
for i=1:3
    for j=1:3
        if(isempty(PPij_i{i,j}) == 1)
            continue
        end
        Pij_ifil{i,j} = medfilt3(Pij_i{i,j},filtvec3);
        Pij_efil{i,j} = medfilt3(Pij_e{i,j},filtvec3);
        dk_Qijk_i3{i,j} = -(vth_i./k00).*del2( Pij_ifil{i,j} - Pij_i_bar(i,j));
        dk_Qijk_e3{i,j} = -(vth_e./k00).*del2( Pij_efil{i,j} - Pij_e_bar(i,j));        
    end
end
%-----------------------------------------------------------------------------
%------------------------------------------------------------------

%Now lets compute the poynting terms
%------------------------------------------------------------------
mu0=1;
eps0=1;
% The poynting vector
Poyn_v=cell(1,3);
Poyn_v{1,1}=(1/mu0).*(E{1,2}.*B{1,3} - E{1,3}.*B{1,2}); 
Poyn_v{1,2}=(1/mu0).*(E{1,3}.*B{1,1} - E{1,1}.*B{1,3});
Poyn_v{1,3}=(1/mu0).*(E{1,1}.*B{1,2} - E{1,2}.*B{1,1});

% Now the divergence of the poyting vector
[Poyn_vx_x,Poyn_vx_y,Poyn_vx_z] = gradient(Poyn_v{1,1});
[Poyn_vy_x,Poyn_vy_y,Poyn_vy_z] = gradient(Poyn_v{1,2});
[Poyn_vz_x,Poyn_vz_y,Poyn_vz_z] = gradient(Poyn_v{1,3});
grad_Poyn_v{1,1} = Poyn_vx_x/resx; grad_Poyn_v{1,2} = Poyn_vy_x/resx; grad_Poyn_v{1,3} = Poyn_vz_x/resx;
grad_Poyn_v{2,1} = Poyn_vx_y/resy; grad_Poyn_v{2,2} = Poyn_vy_y/resy; grad_Poyn_v{2,3} = Poyn_vz_y/resy;
grad_Poyn_v{3,1} = Poyn_vx_z/resz; grad_Poyn_v{3,2} = Poyn_vy_z/resz; grad_Poyn_v{3,3} = Poyn_vz_z/resz;

clearvars Poyn_vx_x Poyn_vx_y Poyn_vx_z Poyn_vy_x Poyn_vy_y Poyn_vy_z Poyn_vz_x Poyn_vz_y Poyn_vz_z 
Div_Poyn_v=grad_Poyn_v{1,1} + grad_Poyn_v{2,2} + grad_Poyn_v{3,3};


% J dot E
JdotE = J{1,1}.*E{1,1} + J{1,2}.*E{1,2} + J{1,3}.*E{1,3};  

% Electromagnetic energy 
E2 = E{1,1}.^2 + E{1,2}.^2 + E{1,3}.^2; 
B2 = B{1,1}.^2 + B{1,2}.^2 + B{1,3}.^2; 
E_em = 0.5.*( eps0.*E2 + B2./mu0 );
%------------------------------------------------------------------

% Now lets compute the time changes of the energy quantities
%------------------------------------------------------------------
% Time change of the electromagnetic energy 
dt_E_em = - JdotE - Div_Poyn_v;  

% Time change of the electromagnetic energy 

% These are the divvergence of h
%------------------------------------------------------------------
dkQiik_05_i{1,1} = (dk_Qijk_i{1,1} + dk_Qijk_i{2,2} + dk_Qijk_i{3,3})/2; 
dkQiik_05_e{1,1} = (dk_Qijk_e{1,1} + dk_Qijk_e{2,2} + dk_Qijk_e{3,3})/2;

dkQiik_05_i2{1,1} = (dk_Qijk_i2{1,1} + dk_Qijk_i2{2,2} + dk_Qijk_i2{3,3})/2; 
dkQiik_05_e2{1,1} = (dk_Qijk_e2{1,1} + dk_Qijk_e2{2,2} + dk_Qijk_e2{3,3})/2;
%------------------------------------------------------------------
% This is to save the data for the whole subbox not only the slides as with
% the _Gp case
%--------------------------------------------------------------------------
% Vectors
%{
Vectorsc{1,in} =B;
Vectorsc{2,in} =E;
Vectorsc{3,in} =vi;
Vectorsc{4,in} =ve;
Vectorsc{5,in} =J;
Vectorsc{6,in} = Poyn_v; 

%Tensors
Tensorsc{1,in} = Pij_i;
Tensorsc{2,in} = Pij_e;
Tensorsc{3,in} = grad_vi;
Tensorsc{4,in} = grad_ve;

% Densities
Densitiesc{1,in} = ni;
Densitiesc{2,in} = ne;

% Poyn theorem terms
Poyn_theoc{1,in} = dt_E_em; %This is the one calculated adding the terms 
Poyn_theoc{2,in} = Div_Poyn_v;
Poyn_theoc{3,in} = JdotE;


%Kinetic Energy
kin_energy_terms_ic{1,in} = vi_grad_Ki;
kin_energy_terms_ic{2,in} = vi_Div_Pit;
kin_energy_terms_ic{3,in} = Ki_Div_vi;
kin_energy_terms_ic{4,in} = qi_ni_vi_E;

kin_energy_terms_ec{1,in} = ve_grad_Ke;
kin_energy_terms_ec{2,in} = ve_Div_Pet;
kin_energy_terms_ec{3,in} = Ke_Div_ve;
kin_energy_terms_ec{4,in} = qe_ne_ve_E;

% Internal energy terms
Int_energy_terms_ic{1,in} = vi_grad_Ui;
Int_energy_terms_ic{2,in} = dk_Qijk_i;
Int_energy_terms_ic{3,in} = dkQiik_05_i;
Int_energy_terms_ic{4,in} = Pit_grad_vi;
Int_energy_terms_ic{5,in} = Pit_grad_vi_ii;
Int_energy_terms_ic{6,in} = Pit_grad_vi_ij;
Int_energy_terms_ic{7,in} = Ui_Div_vi; 

Int_energy_terms_ec{1,in} = ve_grad_Ue;
Int_energy_terms_ec{2,in} = dk_Qijk_e; 
Int_energy_terms_ec{3,in} = dkQiik_05_e;
Int_energy_terms_ec{4,in} = Pet_grad_ve;
Int_energy_terms_ec{5,in} = Pet_grad_ve_ii;
Int_energy_terms_ec{6,in} = Pet_grad_ve_ij;
Int_energy_terms_ec{7,in} = Ue_Div_ve; 

% Parameter proxies 
Param_proxiesc{1,in} = Zernitani_i;
Param_proxiesc{2,in} = Zernitani_e;
Param_proxiesc{3,in} = p_theta_i;
Param_proxiesc{4,in} = p_theta_e;
Param_proxiesc{5,in} = PiD_i;
Param_proxiesc{6,in} = PiD_e;
%}

%To get just the average terms at different time steps
%--------------------------------------------------------------------------

%Kinetic Energy terms ions    
%--------------------------------------------------------------------------
% To get the size of the domain
ss1=size(vi_grad_Ki);
%ss2=ss1(1)*ss1(2);
ss2=ss1(1)*ss1(2)*ss1(3); %in the case of three dimensions
vi_grad_Ki_in_a = sum(vi_grad_Ki,'all')./ss2;

vi_Div_Pit_in_a = sum(vi_Div_Pit,'all')./ss2;

Ki_Div_vi_in_a = sum(Ki_Div_vi,'all')./ss2;

qi_ni_vi_E_in_a = sum(qi_ni_vi_E,'all')./ss2;

%dtKi_in_Gp_2_in_a = sum(dtKi_in_Gp_2,'all')./ss2;

Xi_k_i_in(1,in)= vi_grad_Ki_in_a + vi_Div_Pit_in_a +...
            Ki_Div_vi_in_a - qi_ni_vi_E_in_a;
 
%--------------------------------------------------------------------------

%Kinetic Energy terms electrons
%--------------------------------------------------------------------------
ve_grad_Ke_in_a = sum(ve_grad_Ke,'all')./ss2;

ve_Div_Pet_in_a = sum(ve_Div_Pet,'all')./ss2;

Ke_Div_ve_in_a = sum(Ke_Div_ve,'all')./ss2;

qe_ne_ve_E_in_a = sum(qe_ne_ve_E,'all')./ss2;

%dtKe_in_Gp_2_in_a = sum(dtKe_in_Gp_2,'all')./ss2;

Xi_k_e_in(1,in)= ve_grad_Ke_in_a + ve_Div_Pet_in_a +...
            Ke_Div_ve_in_a - qe_ne_ve_E_in_a;
%--------------------------------------------------------------------------


% Internal energy terms ions
%--------------------------------------------------------------------------
vi_grad_Ui_in_a = sum(vi_grad_Ui,'all')./ss2;

dk_Qijk_i_in_a = sum(dk_Qijk_i{1,1},'all')./ss2;

dkQiik_05_i_in_a = sum(dkQiik_05_i{1,1},'all')./ss2;

Pit_grad_vi_in_a = sum(Pit_grad_vi,'all')./ss2;

Pit_grad_vi_ii_in_a = sum(Pit_grad_vi_ii,'all')./ss2;

Pit_grad_vi_ij_in_a = sum(Pit_grad_vi_ij,'all')./ss2;

Ui_Div_vi_in_a = sum(Ui_Div_vi,'all')./ss2;

%dtUi_in_Gp_2_in_a = sum(dtUi_in_Gp_2,'all')./ss2;

Xi_th_i_in(1,in) =  vi_grad_Ui_in_a + dkQiik_05_i_in_a +...
            Pit_grad_vi_in_a + Ui_Div_vi_in_a;
%--------------------------------------------------------------------------

% Internal energy terms electrons
%--------------------------------------------------------------------------
ve_grad_Ue_in_a = sum(ve_grad_Ue,'all')./ss2;

dk_Qijk_e_in_a = sum(dk_Qijk_e{1,1},'all')./ss2;

dkQiik_05_e_in_a = sum(dkQiik_05_e{1,1},'all')./ss2;

Pet_grad_ve_in_a = sum(Pet_grad_ve,'all')./ss2;

Pet_grad_ve_ii_in_a = sum(Pet_grad_ve_ii,'all')./ss2;

Pet_grad_ve_ij_in_a = sum(Pet_grad_ve_ij,'all')./ss2;

Ue_Div_ve_in_a = sum(Ue_Div_ve,'all')./ss2;

%dtUe_in_Gp_2_in_a = sum(dtUe_in_Gp_2,'all')./ss2;

Xi_th_e_in(1,in) = ve_grad_Ue_in_a + dkQiik_05_e_in_a +...
    Pet_grad_ve_in_a + Ue_Div_ve_in_a;
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------

cd '/Volumes/PSC_DiRAC_DATA/DATACB104/raw_data';

%--------------------------------------------------------------------------

clearvars -except  in ...
    kin_energy_terms_ic kin_energy_terms_ec ...
    Int_energy_terms_ic Int_energy_terms_ec...
    Param_proxiesc...
    Vectorsc Tensorsc Densitiesc Poyn_theoc ... 
    Xi_k_i_in...
    Xi_k_e_in...
    Xi_th_i_in...
    Xi_th_e_in;
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

end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
cd '/Volumes/PSC_DiRAC_DATA/Energy_Budget_things'

save('variable2000_WithRF_subbox.mat','Vectorsc','Tensorsc','Densitiesc','Poyn_theoc',...
    'kin_energy_terms_ic','kin_energy_terms_ec',...
    'Int_energy_terms_ic','Int_energy_terms_ec','Param_proxiesc')
%--------------------------------------------------------------------------

% To load the data in the subbox
%--------------------------------------------------------------------------
cd '/Volumes/PSC_DiRAC_DATA/Energy_Budget_things'
load('variable2000_WithRF_subbox.mat')
%--------------------------------------------------------------------------


in=19;
%--------------------------------------------------------------------------
% Vectors
B_Gp = Vectorsc{1,in} ;
%
E_Gp = Vectorsc{2,in} ;
vi_Gp = Vectorsc{3,in} ;
ve_Gp = Vectorsc{4,in} ;
J_Gp = Vectorsc{5,in} ;
Poyn_v_Gp = Vectorsc{6,in} ; 

%Tensors
Pij_i_Gp = Tensorsc{1,in} ;
Pij_e_Gp = Tensorsc{2,in} ;
grad_vi_Gp = Tensorsc{3,in} ;
grad_ve_Gp = Tensorsc{4,in} ;

% Densities
ni_Gp = Densitiesc{1,in} ;
ne_Gp = Densitiesc{2,in} ;

% Poyn theorem terms
dt_E_em_Gp = Poyn_theoc{1,in} ; %This is the one calculated adding the terms 
Div_Poyn_v_Gp = Poyn_theoc{2,in} ;
JdotE_Gp = Poyn_theoc{3,in} ;

%Kinetic Energy
vi_grad_Ki_Gp = kin_energy_terms_ic{1,in} ;
vi_Div_Pit_Gp = kin_energy_terms_ic{2,in} ;
Ki_Div_vi_Gp = kin_energy_terms_ic{3,in} ;
qi_ni_vi_E_Gp = kin_energy_terms_ic{4,in} ;

ve_grad_Ke_Gp = kin_energy_terms_ec{1,in} ;
ve_Div_Pet_Gp = kin_energy_terms_ec{2,in} ;
Ke_Div_ve_Gp = kin_energy_terms_ec{3,in} ;
qe_ne_ve_E_Gp = kin_energy_terms_ec{4,in} ;

% Internal energy terms
vi_grad_Ui_Gp = Int_energy_terms_ic{1,in} ;
dk_Qijk_i_Gp = Int_energy_terms_ic{2,in} ;
dkQiik_05_i_Gp = Int_energy_terms_ic{3,in} ;
Pit_grad_vi_Gp = Int_energy_terms_ic{4,in} ;
Pit_grad_vi_ii_Gp = Int_energy_terms_ic{5,in} ;
Pit_grad_vi_ij_Gp = Int_energy_terms_ic{6,in} ;
Ui_Div_vi_Gp = Int_energy_terms_ic{7,in} ; 

ve_grad_Ue_Gp = Int_energy_terms_ec{1,in} ;
dk_Qijk_e_Gp = Int_energy_terms_ec{2,in} ; 
dkQiik_05_e_Gp = Int_energy_terms_ec{3,in} ;
Pet_grad_ve_Gp =Int_energy_terms_ec{4,in} ;
Pet_grad_ve_ii_Gp = Int_energy_terms_ec{5,in} ;
Pet_grad_ve_ij_Gp = Int_energy_terms_ec{6,in} ;
Ue_Div_ve_Gp = Int_energy_terms_ec{7,in} ; 

%--------------------------------------------------------------------------
% Div_Pi_dot_vi <----- this one is the one that appears to work
Div_Pis_dot_vi_Gp{1,1} = Pit_grad_vi_Gp + vi_Div_Pit_Gp;
% Div_Pe_dot_e
Div_Pes_dot_ve_Gp{1,1} = Pet_grad_ve_Gp + ve_Div_Pet_Gp;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Parameter proxies 
Zernitani_i_Gp = Param_proxiesc{1,in} ;
Zernitani_e_Gp = Param_proxiesc{2,in} ;
p_theta_i_Gp = Param_proxiesc{3,in} ;
p_theta_e_Gp = Param_proxiesc{4,in} ;
PiD_i_Gp = Param_proxiesc{5,in} ;
PiD_e_Gp = Param_proxiesc{6,in} ;
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
cd '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_energy'
cd '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here'
% This is to call the script that will make and save the latests plots
%--------------------------------------------------------------------------
c=1;
VA2c = 0.1;
B0 = VA2c;
E0 = B0*VA2c;
Pi0 = mi*VA2c*VA2c;
Pe0 = me*VA2c*VA2c;
%DeltaEpsilon0=VA2c*Pi0;
DeltaEpsilon0=Pi0;

dCp=25;
colorFVBl=[0 0 0 0.2];
sv=3; asf=3;
fs=18; lw=1.5;
fs=20;
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%To check withouth directly taking cuts no need to compute variables on the
%slides. This is meant to be a complementary way to show what happens in
%the third dimension
%--------------------------------------------------------------------------
% To make the plot with the perpendicular slices 
%--------------------------------------------------------------------------
[X,Y,Z] = meshgrid(xl,yl,zl);
ypc_i=127; 
xpc_i = 93; 
xslice = 17.08;%xl(xpc_i);%[-1.2,0.8,2];   
yslice = 17.84;%yl(ypc_i);%[];
zslice = zl(46); %<-- this is the correct slice in z after ref transformation

%V=(B{1,2}+0.1)./0.1;
%V2=sqrt(B{1,2}.*B{1,2} + B{1,1}.*B{1,1} + B{1,3}.*B{1,3})./0.1;

%xlim([xll(1) xll(end)]); ylim([yll(1) yll(end)]);

x0=-1562;y0=142;width=1355;height=499; fs=25;
% pe, Pi_era, Pi_epa,  pi_epr
f151=figure(151);
set(gcf,'position',[x0,y0,width,height])


xslice = [xl(end)];  
yslice = [yl(end)];
zslice = [zl(1)];


%x0=-1562;y0=142;width=955;height=600; fs=20;

xslice = [];  
yslice = [];
zslice = [zl(1), zl(46), zl(end)];

x0=-20;y0=112;width=880;height=740; fs=20;
timesst=2; %<---- This is to define how many times the standard deviation for the treshhold 
%--------------------------------------------------------------------------
f3=figure(3);
set(gcf,'position',[x0,y0,width,height])
h1=subplot(2,2,1);
%h1=subaxis(2,2,1,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=(Pij_e_Gp{1,1} + Pij_e_Gp{2,2} + Pij_e_Gp{3,3})/3;
dum_p = dum_p./Pi0;
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
%------------------------------------------------
%dum_p=dum_p(~isnan(dum_p)); %<-- this put a problem
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$p_{e}/p_{0}$','Interpreter','latex','FontSize',fs);
colormap(h1,jet);
hcb=colorbar; hcb.Location = 'eastoutside';
caxis([0 0.9]); hcb.Ticks = linspace(0.2,0.8,4); hcb.TickLabels = [0.2,0.4,0.6,0.8] ;  
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.6);
isosurface(X,Y,Z,dum_p,dum_thresh);
hold off
view(caz,cel)

h2=subplot(2,2,2);
%h2=subaxis(2,2,2,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=(Pij_e_Gp{1,2} + Pij_e_Gp{2,1})/2; 
dum_p = dum_p./Pi0;
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\Pi_{ra,e}/p_{0}$','Interpreter','latex','FontSize',fs);
colormap(h2,BWR);
%caxis([-0.9 0.9])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.12,0.12,5); hcb.TickLabels = [-0.12,-0.06,0,0.06,0.12] ; caxis([-0.16 0.16]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.1);
%isosurface(X,Y,Z,dum_p,-0.1);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h3=subplot(2,2,3);
%h3=subaxis(2,2,3,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=(Pij_e_Gp{3,2} + Pij_e_Gp{2,3})/2; 
dum_p = dum_p./Pi0;
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\Pi_{pa,e}/p_{0}$','Interpreter','latex','FontSize',fs);
colormap(h3,BWR);
%caxis([-0.9 0.9])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.12,0.12,5); hcb.TickLabels = [-0.12,-0.06,0,0.06,0.12] ; caxis([-0.16 0.16]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.1);
%isosurface(X,Y,Z,dum_p,-0.1);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h4=subplot(2,2,4);
%h4=subaxis(2,2,4,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=(Pij_e_Gp{3,1} + Pij_e_Gp{1,3})/2;  
dum_p = dum_p./Pi0;
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\Pi_{pr,e}/p_{0}$','Interpreter','latex','FontSize',fs);
colormap(h4,BWR);
%caxis([-0.9 0.9])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.12,0.12,5); hcb.TickLabels = [-0.12,-0.06,0,0.06,0.12] ; caxis([-0.16 0.16]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.1);
%isosurface(X,Y,Z,dum_p,-0.1);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)
%--------------------------------------------------------------------------

% This is for the ions pi PI 3D
%--------------------------------------------------------------------------
f31=figure(31);
set(gcf,'position',[x0,y0,width,height])
h1=subplot(2,2,1);
%h1=subaxis(2,2,1,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=(Pij_i_Gp{1,1} + Pij_i_Gp{2,2} + Pij_i_Gp{3,3})/3;
dum_p = dum_p./Pi0;
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$p_{i}/p_{0}$','Interpreter','latex','FontSize',fs);
colormap(h1,jet);
hcb=colorbar; hcb.Location = 'eastoutside';
caxis([0 1.6]); hcb.Ticks = linspace(0.4,1.2,3); hcb.TickLabels = [0.4,0.8,1.2] ; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,1.2);
isosurface(X,Y,Z,dum_p,dum_thresh);
hold off
view(caz,cel)

h2=subplot(2,2,2);
%h2=subaxis(2,2,2,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=(Pij_i_Gp{1,2} + Pij_i_Gp{2,1})/2; 
dum_p = dum_p./Pi0;
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\Pi_{ra,i}/p_{0}$','Interpreter','latex','FontSize',fs);
colormap(h2,BWR);
%caxis([-0.9 0.9])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.5,0.5,5); hcb.TickLabels = [-0.5,-0.3,0,0.3,0.5] ; caxis([-0.6 0.6]);
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.35);
%isosurface(X,Y,Z,dum_p,-0.35);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h3=subplot(2,2,3);
%h3=subaxis(2,2,3,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=(Pij_i_Gp{3,2} + Pij_i_Gp{2,3})/2; 
dum_p = dum_p./Pi0;
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\Pi_{pa,i}/p_{0}$','Interpreter','latex','FontSize',fs);
colormap(h3,BWR);
%caxis([-0.9 0.9])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.5,0.5,5); hcb.TickLabels = [-0.5,-0.3,0,0.3,0.5] ; caxis([-0.6 0.6]);
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.35);
%isosurface(X,Y,Z,dum_p,-0.35);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h4=subplot(2,2,4);
%h4=subaxis(2,2,4,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=(Pij_i_Gp{3,1} + Pij_i_Gp{1,3})/2;  
dum_p = dum_p./Pi0;
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\Pi_{pr,i}/p_{0}$','Interpreter','latex','FontSize',fs);
colormap(h4,BWR);
%caxis([-0.9 0.9])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.3,0.3,5); hcb.TickLabels = [-0.3,-0.1,0,0.1,0.3] ; caxis([-0.3 0.3]);
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.15);
%isosurface(X,Y,Z,dum_p,-0.15);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------

%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
f4=figure(4);
set(gcf,'position',[x0,y0,width,height])
h1=subplot(2,2,1);
%h1=subaxis(2,2,1,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p =  ve_grad_Ke_Gp;
dum_p=(dum_p)./(Pi0);
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\frac{d\varepsilon^{k}_{e}/dt}{\Delta\varepsilon_{0}} $','Interpreter','latex','FontSize',1.3*fs);
colormap(h1,BWR);
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ; caxis([-0.05 0.05]);  
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.02);
%isosurface(X,Y,Z,dum_p,-0.02);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h2=subplot(2,2,2);
%h2=subaxis(2,2,2,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=ve_Div_Pet_Gp;
dum_p=(dum_p)./(Pi0); 
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\frac{\mathbf{u}_{e} \cdot \nabla \cdot \overline{\mathbf{P}}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
colormap(h2,BWR);
%caxis([-0.9 0.9])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.2,0.2,5); hcb.TickLabels = [-0.2,-0.1,0,0.1,0.2] ; caxis([-0.23 0.23]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.1);
%isosurface(X,Y,Z,dum_p,-0.1);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h3=subplot(2,2,3);
%h3=subaxis(2,2,3,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=Ke_Div_ve_Gp;
dum_p=(dum_p)./(Pi0); 
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\frac{\varepsilon^{k}_{e} \nabla \cdot \mathbf{u}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
colormap(h3,BWR);
%caxis([-0.9 0.9])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ; caxis([-0.05 0.05]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.02);
%isosurface(X,Y,Z,dum_p,-0.02);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h4=subplot(2,2,4);
%h4=subaxis(2,2,4,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=-qe_ne_ve_E_Gp;
dum_p=(dum_p)./(Pi0); 
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\frac{-q_{e}n_{e}\mathbf{u}_{e} \cdot \mathbf{E}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
colormap(h4,BWR);
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.2,0.2,5); hcb.TickLabels = [-0.2,-0.1,0,0.1,0.2] ; caxis([-0.23 0.23]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.1);
%isosurface(X,Y,Z,dum_p,-0.1);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)
%--------------------------------------------------------------------------




%--------------------------------------------------------------------------
f5=figure(5);
set(gcf,'position',[x0,y0,width,height])
h1=subplot(2,2,1);
%h1=subaxis(2,2,1,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p =  ve_grad_Ue_Gp;
dum_p=(dum_p)./(Pi0);
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\frac{d\varepsilon^{th}_{e}/dt}{\Delta\varepsilon_{0}} $','Interpreter','latex','FontSize',1.3*fs);
colormap(h1,BWR);
hcb=colorbar; hcb.Location = 'eastoutside';
caxis([-0.5 0.5]); hcb.Ticks = linspace(-0.4,0.4,5); hcb.TickLabels = [-0.4,-0.2,0,0.2,0.4] ;  
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.2);
%isosurface(X,Y,Z,dum_p,-0.2);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h2=subplot(2,2,2);
%h2=subaxis(2,2,2,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=dkQiik_05_e_Gp{1,1};
dum_p=(dum_p)./(Pi0); 
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\frac{\nabla \cdot \mathbf{h}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
colormap(h2,BWR);
%caxis([-0.9 0.9])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ; caxis([-0.06 0.06]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.01);
%isosurface(X,Y,Z,dum_p,-0.01);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h3=subplot(2,2,3);
%h3=subaxis(2,2,3,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=Pet_grad_ve_Gp;
dum_p=(dum_p)./(Pi0); 
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\frac{\nabla \mathbf{u}_{e} : \overline{\mathbf{P}}_{e}}{{\Delta\varepsilon_{0}}}$','Interpreter','latex','FontSize',1.3*fs);
colormap(h3,BWR);
%caxis([-0.9 0.9])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-1.4,1.4,5); hcb.TickLabels = [-1.4,-0.7,0,0.7,1.4] ; caxis([-1.5 1.5]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.7);
%isosurface(X,Y,Z,dum_p,-0.7);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h4=subplot(2,2,4);
%h4=subaxis(2,2,4,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=Ue_Div_ve_Gp;
dum_p=(dum_p)./(Pi0); 
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\frac{\varepsilon^{th}_{e} \nabla \cdot \mathbf{u}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
colormap(h4,BWR);
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-1.4,1.4,5); hcb.TickLabels = [-1.4,-0.7,0,0.7,1.4] ; caxis([-1.5 1.5]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.7);
%isosurface(X,Y,Z,dum_p,-0.7);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
x0=-20;y0=112;width=880;height=740; fs=18;
f6=figure(6);
set(gcf,'position',[x0,y0,width,height*0.5])
h1=subplot(1,2,1);
%h1=subaxis(2,2,1,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_pXIe=ve_grad_Ke_Gp + ve_Div_Pet_Gp + Ke_Div_ve_Gp -qe_ne_ve_E_Gp;    
dum_p=(dum_pXIe)./(Pi0);  
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\frac{\Xi^{k}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
colormap(h1,BWR);
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.2,0.2,5); hcb.TickLabels = [-0.2,-0.1,0,0.1,0.2] ; caxis([-0.23 0.23]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.2);
%isosurface(X,Y,Z,dum_p,-0.2);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h2=subplot(1,2,2);
%h2=subaxis(2,2,2,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_pXI2e= ve_grad_Ue_Gp + dkQiik_05_e_Gp{1,1} + Pet_grad_ve_Gp +...
    Ue_Div_ve_Gp ;%+ dum_pXIe;    
dum_p=(dum_pXI2e)./(Pi0);
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\frac{\Xi^{th}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
colormap(h2,BWR);
%caxis([-0.9 0.9])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-1.4,1.4,5); hcb.TickLabels = [-1.4,-0.7,0,0.7,1.4] ; caxis([-1.5 1.5]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.01);
%isosurface(X,Y,Z,dum_p,-0.01);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
cd '/Volumes/PSC_DiRAC_DATA/Energy_Budget_things'
saveas(3,strcat('p_Pi_e_3d.png'));
saveas(31,strcat('p_Pi_i_3d.png'));
saveas(32,strcat('p_Pi_ei_3d.png'));
saveas(4,strcat('pow_kin_e_3d.png'));
saveas(5,strcat('pow_the_e_3d.png'));
saveas(6,strcat('Xi_kin_the_e_3d.png'));
cd '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
%--------------------------------------------------------------------------




%-----------------------------------------------------------

%--------------------------------------------------------------------------
% built the grid to do the right plots
Xs = B_Gp{1,3};
size_X=size(Xs);
xl=linspace(1,size_X(3),size_X(3))*0.06; %Jeff flag it works with (1,size_x(2))
yl=linspace(1,size_X(1),size_X(1))*0.06;
zl=linspace(1,size_X(2),size_X(2))*0.06;
[X, Y, Z] = meshgrid(xl,yl,zl);

xslice = [];  
yslice = [];
zslice = [zl(1), zl(46), zl(end)];

x0=-1020;y0=112;width=880*0.8;height=1.7*740; fs=18;
timesst=2; %<---- This is to define how many times the standard deviation for the treshhold 
%--------------------------------------------------------------------------
f32=figure(32);
%hh = tiledlayout(2,2, 'TileSpacing', 'none', 'Padding', 'none');
set(gcf,'position',[x0,y0,width,height])
h1=subplot(4,2,1);
%h1=subaxis(2,2,1,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=(Pij_e_Gp{1,1} + Pij_e_Gp{2,2} + Pij_e_Gp{3,3})/3;
dum_p = dum_p./Pi0;
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
%------------------------------------------------
%dum_p=dum_p(~isnan(dum_p)); %<-- this put a problem
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$p_{e}/p_{0}$','Interpreter','latex','FontSize',fs);
colormap(h1,jet);
hcb=colorbar; hcb.Location = 'eastoutside';
caxis([0 0.9]); hcb.Ticks = linspace(0.2,0.8,4); hcb.TickLabels = [0.2,0.4,0.6,0.8] ;  
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.6);
isosurface(X,Y,Z,dum_p,dum_thresh);
hold off
view(caz,cel)

h2=subplot(4,2,3);
%h2=subaxis(2,2,2,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=(Pij_e_Gp{1,2} + Pij_e_Gp{2,1})/2; 
dum_p = dum_p./Pi0;
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\Pi_{ra,e}/p_{0}$','Interpreter','latex','FontSize',fs);
colormap(h2,BWR);
%caxis([-0.9 0.9])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.12,0.12,5); hcb.TickLabels = [-0.12,-0.06,0,0.06,0.12] ; caxis([-0.16 0.16]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.1);
%isosurface(X,Y,Z,dum_p,-0.1);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h3=subplot(4,2,5);
%h3=subaxis(2,2,3,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=(Pij_e_Gp{3,2} + Pij_e_Gp{2,3})/2; 
dum_p = dum_p./Pi0;
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\Pi_{pa,e}/p_{0}$','Interpreter','latex','FontSize',fs);
colormap(h3,BWR);
%caxis([-0.9 0.9])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.12,0.12,5); hcb.TickLabels = [-0.12,-0.06,0,0.06,0.12] ; caxis([-0.16 0.16]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.1);
%isosurface(X,Y,Z,dum_p,-0.1);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h4=subplot(4,2,7);
%h4=subaxis(2,2,4,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=(Pij_e_Gp{3,1} + Pij_e_Gp{1,3})/2;  
dum_p = dum_p./Pi0;
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\Pi_{pr,e}/p_{0}$','Interpreter','latex','FontSize',fs);
colormap(h4,BWR);
%caxis([-0.9 0.9])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.12,0.12,5); hcb.TickLabels = [-0.12,-0.06,0,0.06,0.12] ; caxis([-0.16 0.16]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.1);
%isosurface(X,Y,Z,dum_p,-0.1);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)
%--------------------------------------------------------------------------

% This is for the ions pi PI 3D
%--------------------------------------------------------------------------
h5=subplot(4,2,2);
%h1=subaxis(2,2,1,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=(Pij_i_Gp{1,1} + Pij_i_Gp{2,2} + Pij_i_Gp{3,3})/3;
dum_p = dum_p./Pi0;
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$p_{i}/p_{0}$','Interpreter','latex','FontSize',fs);
colormap(h5,jet);
hcb=colorbar; hcb.Location = 'eastoutside';
caxis([0 1.6]); hcb.Ticks = linspace(0.4,1.2,3); hcb.TickLabels = [0.4,0.8,1.2] ; 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,1.2);
isosurface(X,Y,Z,dum_p,dum_thresh);
hold off
view(caz,cel)

h6=subplot(4,2,4);
%h2=subaxis(2,2,2,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=(Pij_i_Gp{1,2} + Pij_i_Gp{2,1})/2; 
dum_p = dum_p./Pi0;
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\Pi_{ra,i}/p_{0}$','Interpreter','latex','FontSize',fs);
colormap(h6,BWR);
%caxis([-0.9 0.9])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.5,0.5,5); hcb.TickLabels = [-0.5,-0.3,0,0.3,0.5] ; caxis([-0.6 0.6]);
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.35);
%isosurface(X,Y,Z,dum_p,-0.35);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h7=subplot(4,2,6);
%h3=subaxis(2,2,3,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=(Pij_i_Gp{3,2} + Pij_i_Gp{2,3})/2; 
dum_p = dum_p./Pi0;
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\Pi_{pa,i}/p_{0}$','Interpreter','latex','FontSize',fs);
colormap(h7,BWR);
%caxis([-0.9 0.9])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.5,0.5,5); hcb.TickLabels = [-0.5,-0.3,0,0.3,0.5] ; caxis([-0.6 0.6]);
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.35);
%isosurface(X,Y,Z,dum_p,-0.35);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h8=subplot(4,2,8);
%h4=subaxis(2,2,4,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=(Pij_i_Gp{3,1} + Pij_i_Gp{1,3})/2;  
dum_p = dum_p./Pi0;
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\Pi_{pr,i}/p_{0}$','Interpreter','latex','FontSize',fs);
colormap(h8,BWR);
%caxis([-0.9 0.9])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.3,0.3,5); hcb.TickLabels = [-0.3,-0.1,0,0.1,0.3] ; caxis([-0.3 0.3]);
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.15);
%isosurface(X,Y,Z,dum_p,-0.15);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)
%----------------------------------------------------------


%--------------------------------------------------------------------------
f52=figure(52);
set(gcf,'position',[x0,y0,width,height])
h1=subplot(4,2,1);
%h1=subaxis(2,2,1,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p =  ve_grad_Ke_Gp;
dum_p=(dum_p)./(Pi0);
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\frac{d\varepsilon^{k}_{e}/dt}{\Delta\varepsilon_{0}} $','Interpreter','latex','FontSize',1.3*fs);
colormap(h1,BWR);
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ; caxis([-0.05 0.05]);  
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.02);
%isosurface(X,Y,Z,dum_p,-0.02);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h2=subplot(4,2,3);
%h2=subaxis(2,2,2,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=ve_Div_Pet_Gp;
dum_p=(dum_p)./(Pi0); 
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\frac{\mathbf{u}_{e} \cdot \nabla \cdot \overline{\mathbf{P}}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
colormap(h2,BWR);
%caxis([-0.9 0.9])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.2,0.2,5); hcb.TickLabels = [-0.2,-0.1,0,0.1,0.2] ; caxis([-0.23 0.23]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.1);
%isosurface(X,Y,Z,dum_p,-0.1);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h3=subplot(4,2,5);
%h3=subaxis(2,2,3,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=Ke_Div_ve_Gp;
dum_p=(dum_p)./(Pi0); 
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\frac{\varepsilon^{k}_{e} \nabla \cdot \mathbf{u}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
colormap(h3,BWR);
%caxis([-0.9 0.9])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ; caxis([-0.05 0.05]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.02);
%isosurface(X,Y,Z,dum_p,-0.02);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h4=subplot(4,2,7);
%h4=subaxis(2,2,4,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=-qe_ne_ve_E_Gp;
dum_p=(dum_p)./(Pi0); 
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\frac{-q_{e}n_{e}\mathbf{u}_{e} \cdot \mathbf{E}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
colormap(h4,BWR);
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.2,0.2,5); hcb.TickLabels = [-0.2,-0.1,0,0.1,0.2] ; caxis([-0.23 0.23]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.1);
%isosurface(X,Y,Z,dum_p,-0.1);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h5=subplot(4,2,2);
%h1=subaxis(2,2,1,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p =  ve_grad_Ue_Gp;
dum_p=(dum_p)./(Pi0);
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\frac{d\varepsilon^{th}_{e}/dt}{\Delta\varepsilon_{0}} $','Interpreter','latex','FontSize',1.3*fs);
colormap(h5,BWR);
hcb=colorbar; hcb.Location = 'eastoutside';
caxis([-0.5 0.5]); hcb.Ticks = linspace(-0.4,0.4,5); hcb.TickLabels = [-0.4,-0.2,0,0.2,0.4] ;  
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.2);
%isosurface(X,Y,Z,dum_p,-0.2);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h6=subplot(4,2,4);
%h2=subaxis(2,2,2,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=dkQiik_05_e_Gp{1,1};
dum_p=(dum_p)./(Pi0); 
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\frac{\nabla \cdot \mathbf{h}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
colormap(h6,BWR);
%caxis([-0.9 0.9])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ; caxis([-0.06 0.06]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.01);
%isosurface(X,Y,Z,dum_p,-0.01);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h7=subplot(4,2,6);
%h3=subaxis(2,2,3,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=Pet_grad_ve_Gp;
dum_p=(dum_p)./(Pi0); 
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\frac{\nabla \mathbf{u}_{e} : \overline{\mathbf{P}}_{e}}{{\Delta\varepsilon_{0}}}$','Interpreter','latex','FontSize',1.3*fs);
colormap(h7,BWR);
%caxis([-0.9 0.9])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-1.4,1.4,5); hcb.TickLabels = [-1.4,-0.7,0,0.7,1.4] ; caxis([-1.5 1.5]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.7);
%isosurface(X,Y,Z,dum_p,-0.7);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)

h8=subplot(4,2,8);
%h4=subaxis(2,2,4,'SV',0.01,'SH',0.04,'MR',0.05,'ML',0.05,'PL',0.05,'PR',0.06);
dum_p=Ue_Div_ve_Gp;
dum_p=(dum_p)./(Pi0); 
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
%------------------------------------------------
dum_siz=size(dum_p); Nstd =dum_siz(1).*dum_siz(2).*dum_siz(3);
dum_mean=mean(abs(dum_p),'all'); dum_sum=sum( (abs(dum_p)-dum_mean).^2, 'all');
dum_std=sqrt((1/Nstd).*(dum_sum)); dum_thresh=dum_mean+timesst*dum_std;
%------------------------------------------------
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice);
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
ax.ZLabel
title('$\frac{\varepsilon^{th}_{e} \nabla \cdot \mathbf{u}_{e}}{\Delta\varepsilon_{0}}$','Interpreter','latex','FontSize',1.3*fs);
colormap(h8,BWR);
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Ticks = linspace(-1.4,1.4,5); hcb.TickLabels = [-1.4,-0.7,0,0.7,1.4] ; caxis([-1.5 1.5]); 
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
hold on
%isosurface(X,Y,Z,dum_p,0.7);
%isosurface(X,Y,Z,dum_p,-0.7);
isosurface(X,Y,Z,dum_p,dum_thresh);
isosurface(X,Y,Z,dum_p,-dum_thresh);
hold off
view(caz,cel)
%--------------------------------------------------------------------------

%----------------------------------------------------------

cd '/Volumes/PSC_DiRAC_DATA/Energy_Budget_things'
saveas(32,strcat('p_Pi_ei_3d.png'));
saveas(52,strcat('pow_kin_the_e_3d.png'));
cd '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';







%--------------------------------------------------------------------------
% This is the one of the with the fieldlines in 3D that do not actually
% look that good
%--------------------------------------------------------------------------
%[caz,cel] = view;

caz = -10;
cel = 10;
view(caz,cel)
xslice = [];  
yslice = [];
zslice = [zl(1) zl(46) zl(end)];
zslice = [zl(46) zl(end)];

f6=figure(6);
h1=subplot(1,1,1);
%dum_p=(Pij_e_Gp{1,1} + Pij_e_Gp{2,2} + Pij_e_Gp{3,3})/3;
%dum_p = dum_p./Pi0;
dum_p=J_Gp{1,2};
dum_p = dum_p./0.1;
filtvec=[3,3,3]; dum_p = medfilt3(dum_p,filtvec);
hc=slice(X,Y,Z,dum_p,xslice,yslice,zslice,'nearest');
set(hc,'edgecolor','none')
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
%title('$p_{e}/p_{0}$','Interpreter','latex','FontSize',fs);
title('$J_{z}/J_{0}$','Interpreter','latex','FontSize',fs);
colormap(h1,BWR);
hcb=colorbar; hcb.Location = 'eastoutside';
caxis([-1.2 1.2]); hcb.Ticks = linspace(-0.8,0.8,4); hcb.TickLabels = [-0.8,-0.4,0.4,0.8] ;  
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
xlim([xl(1) xl(end)]); ylim([yl(1) yl(end)]); zlim([zl(1) zl(end)]);
%xline([xl(end)],'linewidth',2)
%yline(yl(1))
hold on
%hline=streamline(XYZ2);
%hline2=streamline(XYZ2m);
%set(hline,'LineWidth',2.0, 'Color', colorFVBl);
%set(hline2,'LineWidth',2.0, 'Color', colorFVBl);
ax.BoxStyle = 'full';
ax.LineWidth = 1.5;
isosurface(X,Y,Z,dum_p,-1.2);
view(caz,cel)
hold off

%caz=-136.7335
%cel=16.1799


[XL, YL, ZL]=meshgrid(xl,yl,zl);
% For the streamlines
%fr=1;

NN=200;  %Do this just once
ax=xl(1); bx=xl(end);
ay=yl(1); by=yl(end);
az=zl(1); bz=zl(end);
xstart = ax + (bx-ax)*rand(NN,1);
ystart = ay + (by-ay)*rand(NN,1);
zstart = az + (bz-az)*rand(NN,1);

ubx = B_Gp{1,3}; vby = B_Gp{1,1}; wbz = -B_Gp{1,2};  
XYZ2=stream3(XL,YL,ZL,ubx,vby,wbz,xstart,ystart,zstart);
XYZ2m=stream3(XL,YL,ZL,-ubx,-vby,-wbz,xstart,ystart,zstart);

f336=figure(336);
hline3=streamline(XYZ2);
%hline3=streamline(aaa);
hold on
hline4=streamline(XYZ2m);
%hline4=streamline(aaam);
set(hline3,'LineWidth',2.0, 'Color', colorFVBl);
set(hline4,'LineWidth',2.0, 'Color', colorFVBl);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
view(3)
view(0,90)
%view(caz,cel)
hold off


colorFVBl=[0 0 0];
f32=figure(32);
hline=streamline(XYZ2);
hold on
hline2=streamline(XYZ2m);
%hline3=streamline(aaa);
%hline4=streamline(aaam);
set(hline,'LineWidth',2.0, 'Color', colorFVBl);
set(hline2,'LineWidth',2.0, 'Color', colorFVBl);
%set(hline3,'LineWidth',2.0, 'Color', colorFVBl);
%set(hline4,'LineWidth',2.0, 'Color', colorFVBl);
view(3)
hold off



[XLL, YLL] = meshgrid(xl,yl);

X = B_Gp{1,3};
size_X=size(X);
xll=linspace(1,size_X(2),size_X(2))*0.06;
yll=linspace(1,size_X(1),size_X(1))*0.06;
[XLL, YLL] = meshgrid(xll,yll);


% This is to make the lines in 2D
NN=40; 
xstart1 = (resx)*ones(1,NN); 
ystart1 = linspace(0,yll(end),NN); 
xstart2 = linspace(0,xll(end),NN); 
ystart2 = (resy)*ones(1,NN); 
xstart3 = (xll(end)-resx)*ones(1,NN); 
ystart3 = linspace(0,yll(end),NN); 
xstart4 = linspace(0,xll(end),NN); 
ystart4 = (yll(end)-resy)*ones(1,NN); 
xstart = horzcat(xstart1,xstart2,xstart3,xstart4);
ystart = horzcat(ystart1,ystart2,ystart3,ystart4);
%aaa=stream2(XLL,YLL,ubx,vby,xstart,ystart);


ubx = B_Gp{1,1}; vby = B_Gp{1,3}; wbz = B_Gp{1,2};  
sld=100;
aaa=stream2(XLL,YLL,ubx(:,:,sld),vby(:,:,sld),xstart,ystart);
aaam=stream2(XLL,YLL,-ubx(:,:,sld),-vby(:,:,sld),xstart,ystart);

f44=figure(44);
hline3=streamline(aaa);
hold on
hline4=streamline(aaam);
set(hline3,'LineWidth',2.0, 'Color', colorFVBl);
set(hline4,'LineWidth',2.0, 'Color', colorFVBl);
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
ax.YLabel.Interpreter='latex'; ax.ZLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$r / d_{i}$'; %ax.YTick = [2 4 6 8 10]; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$p / d_{i}$'; %ax.XTick = [2 4 6 8]; %ax.XLabel.Position = [5.1, -0.6];    
ax.ZLabel.String = '$a / d_{i}$';
view(3)
%view(0,90)
%view(caz,cel)
hold off








%---------------------------
%f4=figure(4);
%isosurface(X,Y,Z,V,1);
%---------------------------
%--------------------------------------------------------------------------