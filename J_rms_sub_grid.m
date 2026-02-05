%This is to type faster 
%--------------------------------------------------------------------------
path = '/home/UNN/pfcy6/DATA_CIRRUS/turb_alf_cam_3D';
%-----------------------------------------------------------------------------------------------------------------------
cd(path)
%--------------------------------------------------------------------------
S = dir(fullfile(path,'pfd.*.h5'));
N=numel(S); % number of files to use
H=zeros(N);
%--------------------------------------------------------------------------
J_rms_n=zeros(1,N);
B_rms_n=zeros(1,N);

for in=1:floor(N)
%------------------------------------------------------------------
disp(strcat('Computing step ...',S(in).name))
fileID = S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;
%----------------------------------------------------------------------
%------------------------------------------------------------------
Jx=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'));
Jy=h5read(fileID,strcat(EHJ_1st,'/jy_ec/p0/3d'));
Jz=h5read(fileID,strcat(EHJ_1st,'/jz_ec/p0/3d'));
Jx2 = Jx.^2; Jy2 = Jy.^2; Jz2 = Jz.^2;
J_rms_n(1,in) = sqrt(mean(Jx2 + Jy2 + Jz2,'all')); %
clearvars Jx Jx2 Jy Jy2 Jz Jz2

Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));
Bx2 = Bx.^2; By2 = By.^2; Bz2 = Bz.^2;
B_rms_n(1,in) = sqrt(mean(Bx2 + By2 + Bz2,'all')); %
clearvars Bx Bx2 By By2 Bz Bz2
%------------------------------------------------------------------
end

f1=figure(1)
plot(J_rms_n, 'r')
hold on
plot(B_rms_n,'b')
hold off

