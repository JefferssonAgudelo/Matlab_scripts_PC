% This is to create the 2d arrays as a function of time once the data have
% been loaded.
%--------------------------------------------------------------------------

cd '/Volumes/PSC_DiRAC_DATA/DATACB104/raw_data'; %This is important because the xdmf files are in that directory
path = '/Volumes/PSC_DiRAC_DATA/DATACB104/raw_data';
S = dir(fullfile(path,'*.h5'));
N=numel(S); % number of files to use <---------------- This is the N 
H=zeros(N);
%time_t = dt*N_steps; %(In terms of 1/omega_pi)
dt = 0.06;
field =zeros(numel(xll),N-1);
times = zeros(1,N-1);

ypc_i=127;
xpc_i = 93;

% along r direction
field_rp =zeros(numel(xll),N-1);
field_ra =zeros(numel(xll),N-1);
field_rr =zeros(numel(xll),N-1);
%--------------------------------------------------------------------------
for in=1:N-1
str = string(S(in).name);
newStr = extractBetween(str,"pfd.","_p000000.h5");
N_steps = str2double(newStr); time_t = dt*N_steps;
ve_Gp = Vectorsc{4,in} ;
dum_px = ve_Gp{1,1}./VA2c; dum_px1=dum_px(ypc_i,:);
dum_py = ve_Gp{1,2}./VA2c; dum_py1=dum_py(ypc_i,:);
dum_pz = ve_Gp{1,3}./VA2c; dum_pz1=dum_pz(ypc_i,:);
field_rp(:,in) = dum_px1;
field_ra(:,in) = dum_py1;
field_rr(:,in) = dum_pz1;
times(1,in) = time_t;
end
%--------------------------------------------------------------------------

% along p direction
field_pp =zeros(numel(yll),N-1);
field_pa =zeros(numel(yll),N-1);
field_pr =zeros(numel(yll),N-1);
%--------------------------------------------------------------------------
for in=1:N-1
str = string(S(in).name);
newStr = extractBetween(str,"pfd.","_p000000.h5");
N_steps = str2double(newStr); time_t = dt*N_steps;
ve_Gp = Vectorsc{4,in} ;
dum_px = ve_Gp{1,1}./VA2c; dum_px1=dum_px(:,xpc_i);
dum_py = ve_Gp{1,2}./VA2c; dum_py1=dum_py(:,xpc_i);
dum_pz = ve_Gp{1,3}./VA2c; dum_pz1=dum_pz(:,xpc_i);
field_pp(:,in) = dum_px1;
field_pa(:,in) = dum_py1;
field_pr(:,in) = dum_pz1;
times(1,in) = time_t;
end
%--------------------------------------------------------------------------

cd '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here'

f547=figure(547);
h1=subplot(1,3,1);
hc=pcolor(times,xll,field_rp);
set(hc,'edgecolor','none')
xlabel('t \omega_{pi}^{-1}')
ylabel('r/d_{i}')
yline(xll(xpc_i),'--k')
colormap(h1,BWR); caxis([-10 10]); colorbar
h1=subplot(1,3,2);
hc=pcolor(times,xll,field_ra);
set(hc,'edgecolor','none')
xlabel('t \omega_{pi}^{-1}')
ylabel('r/d_{i}')
yline(xll(xpc_i),'--k')
colormap(h1,BWR); caxis([-10 10]); colorbar
h1=subplot(1,3,3);
hc=pcolor(times,xll,field_rr);
set(hc,'edgecolor','none')
xlabel('t \omega_{pi}^{-1}')
ylabel('r/d_{i}')
yline(xll(xpc_i),'--k')
colormap(h1,BWR); caxis([-10 10]); colorbar

f548=figure(548);
h1=subplot(1,3,1);
hc=pcolor(times,yll,field_pp);
set(hc,'edgecolor','none')
xlabel('t \omega_{pi}^{-1}')
ylabel('p/d_{i}')
yline(yll(ypc_i),'--k')
colormap(h1,BWR); caxis([-10 10]); colorbar
h1=subplot(1,3,2);
hc=pcolor(times,yll,field_pa);
set(hc,'edgecolor','none')
xlabel('t \omega_{pi}^{-1}')
ylabel('p/d_{i}')
yline(yll(ypc_i),'--k')
colormap(h1,BWR); caxis([-10 10]); colorbar
h1=subplot(1,3,3);
hc=pcolor(times,yll,field_pr);
set(hc,'edgecolor','none')
xlabel('t \omega_{pi}^{-1}')
ylabel('p/d_{i}')
yline(yll(ypc_i),'--k')
colormap(h1,BWR); caxis([-10 10]); colorbar
%--------------------------------------------------------------------------