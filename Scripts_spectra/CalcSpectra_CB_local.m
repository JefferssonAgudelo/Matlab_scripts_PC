function spectra=CalcSpectra_CB_local(varx,vary,varz,resx,resy,resz,threshold)
%This code calculates the 2D and 1D reduced power spectrum of the magnetic
%field. Bx, By, and Bz are the 3D arrays; resx,resy, resz are the spatial resolution in
%terms of d_i ; threshold is the k_perp at which I want to filter (taking the
%isocontour of the 2D spectrum corrisponding at P(k_par=0,k_per=threshold)
%This code is based on Luca Franci's routines (see Franci et al. ApJ 2018)
%and adapted by Lloyd Woodham [Current version: 15/08/2019].
%Adapted by Jeffersson Agudelo [version: 21/10/19]

%--------------------------------------------------------------------------
disp('Computing 2D and 1D spectra...')
[kpar,kper,P2D]=Compute2Dspectrum(resx,resy,resz,varx,vary,varz);
[P1Dper,P1Dpar]=Compute1DSpectra(P2D,kper,threshold);
spectra.kpar=kpar; spectra.kper=kper; %spectra.Nkper=Nkper;
spectra.P2D=P2D; spectra.P1Dpar=P1Dpar; spectra.P1Dper=P1Dper;
clear varx vary varz;
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
function [kpar,kper,P2D,Nkper]=Compute2Dspectrum(resx,resy,resz,var1,var2,var3)
%Compute the 2D power swpectrum of variables 'var1', 'var2' & 'var3'.

dx=resx; %Fraction of d_i
dy=resy;
dz=resz;

N=size(var1); %all the variables has the same size
Lx=N(1)*dx; %Length of box as function of d_i
Ly=N(2)*dy;
Lz=N(3)*dz;

if nargin==4 %Calculate 3D Fourier transform of each variable (narging return the number of inputs of a function)
    [ff,kx,ky,kz]=Four3D(var1,Lx,Ly,Lz);
    ff=ff.^2;
elseif nargin==5
    [fx,kx,ky,kz]=Four3D(var1,Lx,Ly,Lz);
    [fy,kx,ky,kz]=Four3D(var2,Lx,Ly,Lz);
    ff=fx.^2+fy.^2;
elseif nargin==6
    [fx,kx,ky,kz]=Four3D(var1,Lx,Ly,Lz); %3D transform of each component of B
    [fy,kx,ky,kz]=Four3D(var2,Lx,Ly,Lz);
    [fz,kx,ky,kz]=Four3D(var3,Lx,Ly,Lz);
    ff=fx.^2+fy.^2+fz.^2; %Trace
end

P3D=ff./(N(1)*N(2)*N(3)); %Normalise by 1/Nx*Ny*Nz  %Second normalization? jeff

for j=1:size(ff,2)
    for i=1:size(ff,1)
        %--------------------------------------------------------------------------
        %kp(i,j)=sqrt(ky(j).^2+kx(i).^2); %Calculate kperp array with negative wavenumbers
        %--------------------------------------------------------------------------
        kp(i,j)=sqrt(ky(j).^2); %This is for the case of the 2D harris
        %configuration
        %--------------------------------------------------------------------------
    end
end

for k=1:size(ff,3)
    kp2(k)=abs(kz(k)); %Calculate kpar vector with negative wavenumbers
end

%Calculate kpar and kperp for 2D spectrum:
dkpar=kz(2)-kz(1);
nkpar=fix(max(max(kz)/dkpar))+1;
kpar=(0:nkpar-1).*dkpar;

%dkper=kx(2)-kx(1);
%nkper=fix(max(max(kp)/dkper))+1;
%kper=(0:nkper-1).*dkper;

dkper=ky(2)-ky(1);
nkper=fix(max(max(kp)/dkper))+1;
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

for k= 1:size(P3D,3) %For each value of kpar, integrate over rings of kper
    P1=k1.*P3D(:,:,k); %For interpolation
    P2=k2.*P3D(:,:,k);
    for j=1:size(P3D,2) %Cycle through every grid point in x-y plane
        for i=1:size(P3D,1)
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

%[kpJ, kp2J]=meshgrid(kper,kpar);
%disp(string(size(kpJ)))
%disp(string(size(kp2J)))
%disp(string(size(P2D)))
%disp(string(kper(2)))
%P2D=P2D./kper(2);
%P2D=P2D./(kpJ.*kpJ); %Normalise // P2D=P2D./(kper(2)*kpar(2)); Is this correct?
% it is dividing by a single value of kper
%disp(string(size(P2D)))
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
function [ft,kx,ky,kz]=Four3D(var,Lx,Ly,Lz)
%Calculates 3D spatial Fourier transfrom of variable 'var', shifted so
%that the centre is the zero k. xx/yy/zz are Lx, Ly and Lz.

var=var-mean(mean(mean((var)))); %Detrend mean

N=size(var); %N=[Nx,Ny,Nz]

f=abs(fftn(var))*sqrt(N(1)*N(2)*N(3)); %Take abs value and normalise
%^Should it be fftn instead of ifftn?

ft=fftshift(f); %Shift ft to centre wavenumber

kx=((0:N(1)-1)-N(1)/2).*2*pi/Lx; %Includes negative wavenumbers
ky=((0:N(2)-1)-N(2)/2).*2*pi/Ly;
kz=((0:N(3)-1)-N(3)/2).*2*pi/Lz;

%     From Groselj et al (2018)
%     Kper can be assumed as kper = (k_{x}^2 + k_{y}^{2})^{1/2}
%     The definition is consistent with previous works [44–46] and is
%     motivated by the fact that the local k⊥ is to lowest order in ϵ =
%     δB/B0 equal to (kx, ky), whereas, even to lowest order in ϵ, kz
%     cannot be considered representative for the local kk [45,46].
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% function [ft,kx,ky,kz]=Four3DLocal(var,Lx,Ly,Lz)
%
%     N=size(var); %N=[Nx,Ny,Nz]
%     kx=((0:N(1)-1)-N(1)/2).*2*pi/Lx; %Includes negative wavenumbers % Make an array of Kx
%     ky=((0:N(2)-1)-N(2)/2).*2*pi/Ly;
%     kz=((0:N(3)-1)-N(3)/2).*2*pi/Lz;
%
%     %Fourier transform
%
%     var=var-mean(mean(mean((var)))); %Detrend mean
%
%     % fftn The N-D transform is equivalent to computing the 1-D transform along each dimension of X.
%     f=abs(fftn(var)).*sqrt(N(1)*N(2)*N(3)); %Take abs value and normalise
%
%     ft=fftshift(f); %Shift ft to centre wavenumber
%
% end

% to erase
%------------------
%     f1=figure(1)
%     subplot(2,2,1)
%     f=real(fftn(var));
%     dum=squeeze(f(:,:,400));
%     contourf(dum)
%     colorbar
%     subplot(2,2,2)
%     f=abs(fftn(var));
%     dum=squeeze(f(:,:,400));
%     contourf(dum)
%     colorbar
%     subplot(2,2,3)
%     f=abs(fftn(var)).*sqrt(N(1)*N(2)*N(3));
%     dum=squeeze(f(:,:,400));
%     contourf(dum)
%     colorbar
%     subplot(2,2,4)
%     f=abs(fftn(var)).*sqrt(N(1)*N(2)*N(3));
%     ft=fftshift(f);
%     dum=squeeze(ft(:,:,400));
%     contourf(dum)
%     colorbar
%
%     f2=figure(2)
%     dum=squeeze(var(:,:,400));
%     contourf(dum)
%     colorbar
%------------------
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% This part in here needs to be corrected including the parallel and
% perpendicular values with respect to the local magnetic field
%--------------------------------------------------------------------------

% This also needs to be fixed to use it in non symmetry configurations

%     From Groselj et al (2018) the local magnetic field is obtained by
%     "At a given perpendicular wave number k⊥, we define a local mean magnetic
%     field B_{0,k⊥} and a local fluctuating field δBk⊥. The local mean field is
%     obtained by eliminating the Fourier modes with perpendicular wave numbers
%     greater than k⊥/2 and the fluctuating field is obtained by eliminating
%     the modes with wave numbers less than k⊥/2 or greater than 2k⊥."
%    f_local = f - f*(kper_l>kper_p)


% for each kper set a threshold
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