%--------------------------------------------------------------------------
function spectra = CalcSpectra_2D(varx,vary,varz,resy,resz,threshold)
%--------------------------------------------------------------------------
disp('Computing 2D and 1D spectra...')
[kpar,kper,P2D]=Compute2Dspectrum(resy,resz,varx,vary,varz);
spectra.kpar=kpar; spectra.kper=kper; spectra.P2D=P2D;
clear varx vary varz;
end
%--------------------------------------------------------------------------
%var1 = Bx_1; var2 = By_1; var3 = Bz_1;
%--------------------------------------------------------------------------
function [kpar,kper,P2D,Nkper]=Compute2Dspectrum(resy,resz,var1,var2,var3)
%Compute the 2D power swpectrum of variables 'var1', 'var2' & 'var3'.

dy=resy;
dz=resz;

N=size(var1); %all the variables has the same size
Ly=N(1)*dy; 
Lz=N(2)*dz; 
    
if nargin==4 %Calculate 3D Fourier transform of each variable (narging return the number of inputs of a function)
    [ff,ky,kz]=Four3D(var1,Ly,Lz);
    ff=ff.^2;
elseif nargin==5
    [fx,ky,kz]=Four3D(var1,Ly,Lz);
    [fy,ky,kz]=Four3D(var2,Ly,Lz);
    ff=fx.^2+fy.^2;
elseif nargin==6
    [fx,ky,kz]=Four3D(var1,Ly,Lz); %3D transform of each component of B
    [fy,ky,kz]=Four3D(var2,Ly,Lz);
    [fz,ky,kz]=Four3D(var3,Ly,Lz);
    ff=fx.^2+fy.^2+fz.^2; %Trace
end

%ff=ft;
P3D=ff./(N(1)*N(2)); %Normalise by 1/Nx*Ny*Nz  %Second normalization? jeff

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

%kp=ky;
for k=1:size(ff,2)
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
    
for k= 1:size(P3D,2) %For each value of kpar, integrate over rings of kper
    P1=k1.*P3D(:,k); %For interpolation
    P2=k2.*P3D(:,k);
    for j=1:size(P3D,1) %Cycle through every grid point in x-y plane
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

end
%--------------------------------------------------------------------------

%var = Bx_1;
%----------------------------------------------------------------------
function [ft,ky,kz]=Four3D(var,Ly,Lz)
    %Calculates 3D spatial Fourier transfrom of variable 'var', shifted so
    %that the centre is the zero k. xx/yy/zz are Lx, Ly and Lz.
    
    var=var-mean(mean(mean((var)))); %Detrend mean

    N=size(var); %N=[Nx,Ny,Nz]

    f=abs(fftn(var))*sqrt(N(1)*N(2)); %Take abs value and normalise
    %^Should it be fftn instead of ifftn?
    
    ft=fftshift(f); %Shift ft to centre wavenumber
    
    %Includes negative wavenumbers
    ky=((0:N(1)-1)-N(1)/2).*2*pi/Ly;
    kz=((0:N(2)-1)-N(2)/2).*2*pi/Lz;

end
%----------------------------------------------------------------------