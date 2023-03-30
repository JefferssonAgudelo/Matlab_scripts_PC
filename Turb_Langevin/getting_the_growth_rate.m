% This is the script to get amplitude of each mode of the vector potential
% in this example x is the out of the plane component, y is the
% perpendicular direction and z is the parallel direction

    % Extract the modes to get the growth rate of each mode 
    %----------------------------------------------------------------------  
    threshold=pi/resy; % define a threshold  
    var=Ax; % Ax is the out of the plane vector potential in my case
        
    N=size(var);
    var=var-mean(mean(mean((var)))); %Detrend mean
    FF_Ax = abs(fftn(var)).*sqrt(N(1)*N(2)); % perform the 2D fourier transform 
    S_FF_Ax = fftshift(FF_Ax); % Shift the transform 
    
    kz=((0:N(2)-1)-N(2)/2).*2*pi/Lz; %create the array of kz including negative wavenumbers
    ky=((0:N(1)-1)-N(1)/2).*2*pi/Ly; %create the array of kz including negative wavenumbers
    %kz=((0:N(3)-1)-N(3)/2).*2*pi/Lz;

    % get the real and imaginary parts 
    zz=real(S_FF_Ax);
    yy=imag(S_FF_Ax);

    % get the amplitude and phase 
    Amp=sqrt(zz.^2)./(N(1)*N(2)); % the amplitude of the real part   
    phase=atan(yy./zz)./(N(1)*N(2));

    % Get the step in kz and ky
    dky=ky(end)-ky(end-1);
    dkz=kz(end)-kz(end-1);

    % make a grid for the values of kz and ky
    [KZ,KY]=meshgrid(kz,ky);

    % Removing first the values above the threshold.
    Amp= Amp.*((KY<threshold)).*((KZ<threshold));
    phase= phase.*((KY<threshold)).*((KZ<threshold));

    % integrate over each direction 
    Amp_y = sum(Amp,1)*dky; %integral over y
    Amp_z = sum(Amp,2)*dkz; %integral over z
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    % Get the position and value of the first k
    kz0_1 = 2*1*2*pi/Lz;    kz0_2 = 2*2*2*pi/Lz; % the extra 2 in front its to account for the negative-positive interval
    kz0_3 = 2*3*2*pi/Lz;    kz0_4 = 2*4*2*pi/Lz;

    ky0_1 = 2*1*2*pi/Ly;    ky0_2 = 2*2*2*pi/Ly;
    ky0_3 = 2*3*2*pi/Ly;    ky0_4 = 2*4*2*pi/Ly;

    % Get the value for the first four modes in kz 
    cond_1=(kz==kz0_1);
    Amp_y_1 = Amp_y.*cond_1;
    Amp_y_1 = sum(Amp_y_1)/sum(cond_1);

    cond_2=(kz==kz0_2);
    Amp_y_2 = Amp_y.*cond_2;
    Amp_y_2 = sum(Amp_y_2)/sum(cond_2);

    cond_3=(kz==kz0_3);
    Amp_y_3 = Amp_y.*cond_3;
    Amp_y_3 = sum(Amp_y_3)/sum(cond_3);

    cond_4=(kz==kz0_4);
    Amp_y_4 = Amp_y.*cond_4;
    Amp_y_4 = sum(Amp_y_4)/sum(cond_4);

    % Get the value for the first four modes in ky 
    cond_1=(ky==ky0_1)';
    Amp_z_1 = Amp_z.*cond_1;
    Amp_z_1 = sum(Amp_z_1)/sum(cond_1);

    cond_2=(ky==ky0_2)';
    Amp_z_2 = Amp_z.*cond_2;
    Amp_z_2 = sum(Amp_z_2)/sum(cond_2);

    cond_3=(ky==ky0_3)';
    Amp_z_3 = Amp_z.*cond_3;
    Amp_z_3 = sum(Amp_z_3)/sum(cond_3);

    cond_4=(ky==ky0_4)';
    Amp_z_4 = Amp_z.*cond_4;
    Amp_z_4 = sum(Amp_z_4)/sum(cond_4);

    % Store the values
    Amp_ky_T_i(in,:) = [Amp_y_1; Amp_y_2; Amp_y_3; Amp_y_4];
    Amp_kz_T_i(in,:) = [Amp_z_1; Amp_z_2; Amp_z_3; Amp_z_4]; 
%   %----------------------------------------------------------------------