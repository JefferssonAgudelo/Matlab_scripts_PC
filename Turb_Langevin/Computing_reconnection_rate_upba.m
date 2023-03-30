% Computing reconnection rates.

%path = '/Volumes/PSC_DiRAC_DATA/TESTS_2022/New_V_tests/second_set_simulations';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/Harris_yz_base_large';

%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/Harris_yz_lange_no_pert_large_wavelength'; %done
%path =
%'/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/harris_yz_lange_no_pert_large_alf';
%%done

%path = '/Volumes/PSC_DiRAC_DATA/TESTS_2022/New_V_tests/Harris_yz_lange_pert_large';
%path = '/Volumes/PSC_DiRAC_DATA/TESTS_2022/New_V_tests/Harris_yz_lange_no_pert_large_wavelength';


%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_3';
path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2';

% For the scripts
path_s= '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';

% To save the plots
path_B = strcat(path,'/spectra/unnormalised/Magnetic_field/P2D');
path_M = strcat(path,'/spectra/unnormalised/Momentum/P2D');
path_1D = strcat(path,'/spectra/unnormalised/P1D_per');
path_tp = strcat(path,'/spectra/unnormalised/time_plots');
path_rr = strcat(path,'/spectra/unnormalised/reconnection_rate');
path_rr_mft = strcat(path,'/spectra/unnormalised/reconnection_rate/MFT_comp');
path_rr_Ef = strcat(path,'/spectra/unnormalised/reconnection_rate/electric_f');
path_rr_1dcuts = strcat(path,'/spectra/unnormalised/reconnection_rate/1dcuts');

if not(isfolder(path_B))
    mkdir(path_B)
end
if not(isfolder(path_M))
    mkdir(path_M)
end
if not(isfolder(path_1D))
    mkdir(path_1D)
end
if not(isfolder(path_tp))
    mkdir(path_tp)    
end
if not(isfolder(path_rr))
    mkdir(path_rr)    
end
if not(isfolder(path_rr_mft))
    mkdir(path_rr_mft)    
end
if not(isfolder(path_rr_Ef))
    mkdir(path_rr_Ef)    
end
if not(isfolder(path_rr_1dcuts))
    mkdir(path_rr_1dcuts)    
end


cd(path)
S = dir(fullfile(path,'pfd.*.h5'));
N=numel(S); % number of files to use
H=zeros(N);
%--------------------------------------------------------------------------
S2 = dir(fullfile(path,'pfd_moments.*.h5'));
N2=numel(S2); % number of files to use
H2=zeros(N2);
in=28;
%--------------------------------------------------------------------------
% Change this accordingly
%--------------------------------------------------------------------------
% Normalization
%B are normalized to the background magnetic field
B0=0.4;
%n is normalise to the proton density n0=1
n0=1;
%Vi normalised to the proton alfven speed V_a=0.1c The alfven speed of
%electrons is Vae=10Vai
Vai=0.4;
Vae=0.4;
%E = vB, as B0=0.1 and v in units of c, E0= B0*Vai/c
E0=0.4; %??
%T=(beta/2)B^2, Thus, as beta=1
T0=0.04;
%The current density J0=1?
J0=Vai;

MFT0=1; % is this simply one in this normalization

%Normalising only when making plots
c=1; VA2c = 0.1;
%B0 = VA2c; E0 = B0*VA2c;
%Pi0 = mi*VA2c*VA2c; Pe0 = me*VA2c*VA2c;
%DeltaEpsilon0=VA2c*Pi0;
%DeltaEpsilon0=Pi0;

kb = 1.; 
mu0 =1.; 
c=1; 
q = 1;
mime =1.; 
mi = 1.; 
me = 1. / mime; eps0=1.;
omega_pi=1;
Omega_e=Vai*sqrt(mime)*omega_pi;
Omega_i=Omega_e / mime;
TOmega_e=1/Omega_e; 
TOmega_i=1/Omega_i;
jn=1;
%--------------------------------------------------------------------------

for jn=1:10
    %in=2 + floor(N*(jn-1)/10);
    in=1;
    jn=1;
    %----------------------------------------------------------------------
    disp(strcat('Computing step ...',S(in).name))    
    fileID =  S(in).name; %change the 1 per i
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
    %--------------------------------------------------------------------------
    
    %----------------------------------------------------------------------
    disp(strcat('Computing step ...',S2(in).name))    
    fileID2 =  S2(in).name; %change the 1 per i
    %h5disp(fileID2);
    info2 = h5info(fileID2);
    moments_1st = info2.Groups(1).Name;
    %----------------------------------------------------------------------
    
    %----------------------------------------------------------------------
    % 'rho_e_UP' 'jx_e_UP' 'jy_e_UP' 'jz_e_UP' 'px_e_UP' 'py_e_UP'
    % 'pz_e_UP' 'txx_e_UP' 'tyy_e_UP' 'tzz_e_UP' 'txy_e_UP' 'tyz_e_UP'
    % 'tzx_e_UP' 'rho_i_UP' 'jx_i_UP' 'jy_i_UP' 'jz_i_UP' 'px_i_UP'
    % 'py_i_UP' 'pz_i_UP' 'txx_i_UP' 'tyy_i_UP' 'tzz_i_UP' 'txy_i_UP'
    % 'tyz_i_UP' 'tzx_i_UP'
    %----------------------------------------------------------------------
        
    B{1,1}=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    B{1,2}=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
    B{1,3}=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));
    
    E{1,1}=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'));
    E{1,2}=h5read(fileID,strcat(EHJ_1st,'/jy_ec/p0/3d'));
    E{1,3}=h5read(fileID,strcat(EHJ_1st,'/jz_ec/p0/3d'));
    
    J{1,1}=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'));
    J{1,2}=h5read(fileID,strcat(EHJ_1st,'/jy_ec/p0/3d'));
    J{1,3}=h5read(fileID,strcat(EHJ_1st,'/jz_ec/p0/3d'));
    
%     p_e{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e/p0/3d'));
%     p_e{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e/p0/3d'));
%     p_e{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e/p0/3d'));
%     
%     p_i{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i/p0/3d'));
%     p_i{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i/p0/3d'));
%     p_i{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i/p0/3d'));
    
    
    % This has to be fixed because it is only the popullation in or out of the harris
    % THIS IS IMPORATNAT, MAYBE IT IS BECAUSE THE LACK OF THE BACKGROUND
    %POPULLATION THAT I DONT SEE THINGS HAPPENING

    p_e{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e_UP/p0/3d')); 
    p_e{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e_UP/p0/3d'));
    p_e{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e_UP/p0/3d'));
    
    p_i{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i_UP/p0/3d'));
    p_i{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i_UP/p0/3d'));
    p_i{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i_UP/p0/3d'));

    p_e_up=p_e;
    p_i_up=p_i;

    p_e{1,1}=h5read(fileID2,strcat(moments_1st,'/px_e_BA/p0/3d')); 
    p_e{1,2}=h5read(fileID2,strcat(moments_1st,'/py_e_BA/p0/3d'));
    p_e{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_e_BA/p0/3d'));
    
    p_i{1,1}=h5read(fileID2,strcat(moments_1st,'/px_i_BA/p0/3d'));
    p_i{1,2}=h5read(fileID2,strcat(moments_1st,'/py_i_BA/p0/3d'));
    p_i{1,3}=h5read(fileID2,strcat(moments_1st,'/pz_i_BA/p0/3d'));

    p_e_ba=p_e;
    p_i_ba=p_i;

    p_e{1,1} = p_e_up{1,1} + p_e_ba{1,1};
    p_e{1,2} = p_e_up{1,2} + p_e_ba{1,2};
    p_e{1,3} = p_e_up{1,3} + p_e_ba{1,3};

    p_i{1,1} = p_i_up{1,1} + p_i_ba{1,1};
    p_i{1,2} = p_i_up{1,2} + p_i_ba{1,2};
    p_i{1,3} = p_i_up{1,3} + p_i_ba{1,3};


    %----------------------------------------------------------------------


    % computing the velocities in units of c
    %----------------------------------------------------------------------
    v_e=cell(1,3);
    v_i=cell(1,3);
    for i=1:3
        v_e{1,i} = p_e{1,i} * c ./ sqrt(c^2 * me^2 + p_e{1,i}.^2);
        v_i{1,i} = p_i{1,i} * c ./ sqrt(c^2 * me^2 + p_i{1,i}.^2);
    end

%     vy_e = p_e{1,1} * c ./ sqrt(c^2 * me^2 + py_e{1,1}.^2);
%     vz_e = pz_e{1,1} * c ./ sqrt(c^2 * me^2 + pz_e{1,3}.^2);
%     vx_i = px_i * c ./ sqrt(c^2 * mi^2 + px_i.^2);
%     vy_i = py_i * c ./ sqrt(c^2 * mi^2 + py_i.^2);
%     vz_i = pz_i * c ./ sqrt(c^2 * mi^2 + pz_i.^2);
    %----------------------------------------------------------------------  

    % densities
    %----------------------------------------------------------------------
    n_e_up{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_e_UP/p0/3d'));
    n_i_up{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_i_UP/p0/3d'));
    n_e_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_e_BA/p0/3d'));
    n_i_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_i_BA/p0/3d'));

    n_e{1,1}=n_e_up{1,1} + n_e_ba{1,1};
    n_i{1,1}=n_i_up{1,1} + n_i_ba{1,1};

    n_e{1,1}=-1.*n_e{1,1};

    clearvars n_e_ba n_e_up n_i_ba n_i_up p_e_up p_e_ba p_i_up p_i_ba 
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    Txx_e_up=h5read(fileID2,strcat(moments_1st,'/txx_e_UP/p0/3d')); 
    Tyy_e_up=h5read(fileID2,strcat(moments_1st,'/tyy_e_UP/p0/3d'));
    Tzz_e_up=h5read(fileID2,strcat(moments_1st,'/tzz_e_UP/p0/3d'));
    Txy_e_up=h5read(fileID2,strcat(moments_1st,'/txy_e_UP/p0/3d')); 
    Txz_e_up=h5read(fileID2,strcat(moments_1st,'/tzx_e_UP/p0/3d'));
    Tyz_e_up=h5read(fileID2,strcat(moments_1st,'/tyz_e_UP/p0/3d'));

    Txx_i_up=h5read(fileID2,strcat(moments_1st,'/txx_i_UP/p0/3d')); 
    Tyy_i_up=h5read(fileID2,strcat(moments_1st,'/tyy_i_UP/p0/3d'));
    Tzz_i_up=h5read(fileID2,strcat(moments_1st,'/tzz_i_UP/p0/3d'));
    Txy_i_up=h5read(fileID2,strcat(moments_1st,'/txy_i_UP/p0/3d')); 
    Txz_i_up=h5read(fileID2,strcat(moments_1st,'/tzx_i_UP/p0/3d'));
    Tyz_i_up=h5read(fileID2,strcat(moments_1st,'/tyz_i_UP/p0/3d'));

    Txx_e_ba=h5read(fileID2,strcat(moments_1st,'/txx_e_UP/p0/3d')); 
    Tyy_e_ba=h5read(fileID2,strcat(moments_1st,'/tyy_e_UP/p0/3d'));
    Tzz_e_ba=h5read(fileID2,strcat(moments_1st,'/tzz_e_UP/p0/3d'));
    Txy_e_ba=h5read(fileID2,strcat(moments_1st,'/txy_e_UP/p0/3d')); 
    Txz_e_ba=h5read(fileID2,strcat(moments_1st,'/tzx_e_UP/p0/3d'));
    Tyz_e_ba=h5read(fileID2,strcat(moments_1st,'/tyz_e_UP/p0/3d'));

    Txx_i_ba=h5read(fileID2,strcat(moments_1st,'/txx_i_UP/p0/3d')); 
    Tyy_i_ba=h5read(fileID2,strcat(moments_1st,'/tyy_i_UP/p0/3d'));
    Tzz_i_ba=h5read(fileID2,strcat(moments_1st,'/tzz_i_UP/p0/3d'));
    Txy_i_ba=h5read(fileID2,strcat(moments_1st,'/txy_i_UP/p0/3d')); 
    Txz_i_ba=h5read(fileID2,strcat(moments_1st,'/tzx_i_UP/p0/3d'));
    Tyz_i_ba=h5read(fileID2,strcat(moments_1st,'/tyz_i_UP/p0/3d'));

    Txx_i = Txx_i_up + Txx_i_ba;
    Tyy_i = Tyy_i_up + Tyy_i_ba;
    Tzz_i = Tzz_i_up + Tzz_i_ba;
    Txy_i = Txy_i_up + Txy_i_ba;
    Txz_i = Txz_i_up + Txz_i_ba;
    Tyz_i = Tyz_i_up + Tyz_i_ba;
    
    Txx_e = Txx_e_up + Txx_e_ba;
    Tyy_e = Tyy_e_up + Tyy_e_ba;
    Tzz_e = Tzz_e_up + Tzz_e_ba;
    Txy_e = Txy_e_up + Txy_e_ba;
    Txz_e = Txz_e_up + Txz_e_ba;
    Tyz_e = Tyz_e_up + Tyz_e_ba;

    clearvars Txx_i_ba Txx_i_up Tyy_i_ba Tyy_i_up Tzz_i_ba Tzz_i_up
    clearvars Txy_i_ba Txy_i_up Txz_i_ba Txz_i_up Tyz_i_ba Tyz_i_up
    clearvars Txx_e_ba Txx_e_up Tyy_e_ba Tyy_e_up Tzz_e_ba Tzz_e_up
    clearvars Txy_e_ba Txy_e_up Txz_e_ba Txz_e_up Tyz_e_ba Tyz_e_up
 
    %----------------------------------------------------------------------  

    Pij_i=cell(3,3);
    Pij_e=cell(3,3);
    %--------------------------------------------------------------------------
    % Make the tensor [3, 3] for the ions
    Pij_i{1,1}=Txx_i; Pij_i{1,2}=Txy_i; Pij_i{1,3}=Txz_i;
    Pij_i{2,1}=Txy_i; Pij_i{2,2}=Tyy_i; Pij_i{2,3}=Tyz_i;
    Pij_i{3,1}=Txz_i; Pij_i{3,2}=Tyz_i; Pij_i{3,3}=Tzz_i;
    % Make the tensor [3, 3] for the electrons
    Pij_e{1,1}=Txx_e; Pij_e{1,2}=Txy_e; Pij_e{1,3}=Txz_e;
    Pij_e{2,1}=Txy_e; Pij_e{2,2}=Tyy_e; Pij_e{2,3}=Tyz_e;
    Pij_e{3,1}=Txz_e; Pij_e{3,2}=Tyz_e; Pij_e{3,3}=Tzz_e;

    % This is to get the central momment pressure.
    %------------------------------------------------------------------
    PPij_i=cell(3,3);
    PPij_e=cell(3,3);
    for i=1:3
        for j=1:3
            if(isempty(Pij_i{i,j}) == 1)
                continue
            end
            PPij_i{i,j} = Pij_i{i,j} - n_i{1,1}.*mi.*v_i{1,i}.*v_i{1,j};
            PPij_e{i,j} = Pij_e{i,j} - n_e{1,1}.*me.*v_e{1,i}.*v_e{1,j};
        end
    end

    % This is just to rename the variable
    Pij_i = PPij_i;
    Pij_e = PPij_e;
    %----------------------------------------------------------------------

    %From 3D to 2D (x,y,z) to (y,z)
    %----------------------------------------------------------------------  
    %----------------------------------------------------------------------  

    % computing magnetic flux velocity
    %----------------------------------------------------------------------  
    Bp=sqrt(B{1,2}.^2 + B{1,3}.^2);

    by=B{1,2}./Bp;
    bz=B{1,3}./Bp;

    MFT_y = - (c.*E{1,1}./Bp).*bz ; 
    MFT_z =  (E{1,1}./Bp).*by ;
    MFTm=sqrt(MFT_z.^2 + MFT_y.^2);

    % slice in x
    sli_x = 2;
    sli_y = 180;
    sli_z = 350;

    MFT_y=squeeze(MFT_y(sli_x,:,:));
    MFT_z=squeeze(MFT_z(sli_x,:,:));

    Bp=squeeze(Bp(sli_x,:,:));

    % Computing the divergence
    %----------------------------------------------------------------------  
    [MFT_y_y, MFT_y_z] = gradient(MFT_y);
    [MFT_z_y, MFT_z_z] = gradient(MFT_z);
    Div_MFT = MFT_y_y/resy + MFT_z_z/resz;
    
    %MFT vs Div_MFT
    MFTm_1d_ay=squeeze(Div_MFT(:,sli_z));
    MFTm_1d_az=squeeze(Div_MFT(sli_y,:))'; %<-- there is a problem here
    

    Div_MFT_1d_ay=squeeze(Div_MFT(:,sli_z)); 
    Div_MFT_1d_az=squeeze(Div_MFT(sli_y,:))'; %<--- why do I put this?
    %----------------------------------------------------------------------  

    %Computing the grad v
    %----------------------------------------------------------------------  
    vx_e=v_e{1,1}; vy_e=v_e{1,2}; vz_e=v_e{1,3};
    vx_i=v_i{1,1}; vy_i=v_i{1,2}; vz_i=v_i{1,3};

    vx_e=squeeze(vx_e(sli_x,:,:));
    vy_e=squeeze(vy_e(sli_x,:,:));
    vz_e=squeeze(vz_e(sli_x,:,:));

    vx_i=squeeze(vx_i(sli_x,:,:));
    vy_i=squeeze(vy_i(sli_x,:,:));
    vz_i=squeeze(vz_i(sli_x,:,:));

    [Dvx_e_y, Dvx_e_z] = gradient(vx_e);
    [Dvy_e_y, Dvy_e_z] = gradient(vy_e);
    [Dvz_e_y, Dvz_e_z] = gradient(vz_e);


    %Components of the electric field 
    ve_dot_gradve_x = vy_e.*Dvx_e_y/resy + vz_e.*Dvx_e_z/resz;
    ve_dot_gradve_y = vy_e.*Dvy_e_y/resy + vz_e.*Dvy_e_z/resz;
    ve_dot_gradve_z = vy_e.*Dvz_e_y/resy + vz_e.*Dvz_e_z/resz;
    %----------------------------------------------------------------------  


    %Gradients in 2D
    % This has to be done condidering the axis so the derivative is in y
    % and z and not in x
    %----------------------------------------------------------------------
    %For Pi
    Pij_ixx = Pij_i{1,1}; Pij_iyy = Pij_i{2,2}; Pij_izz = Pij_i{3,3};
    Pij_ixy = Pij_i{1,2}; Pij_ixz = Pij_i{1,3}; Pij_iyz = Pij_i{2,3};
    
    Pij_ixx = squeeze(Pij_ixx(sli_x,:,:)); 
    Pij_iyy = squeeze(Pij_iyy(sli_x,:,:)); 
    Pij_izz = squeeze(Pij_izz(sli_x,:,:)); 
    Pij_ixy = squeeze(Pij_ixy(sli_x,:,:)); 
    Pij_ixz = squeeze(Pij_ixz(sli_x,:,:)); 
    Pij_iyz = squeeze(Pij_iyz(sli_x,:,:)); 
    
    %Grad_Pi
    [Pxxi_y, Pxxi_z] = gradient(Pij_ixx);
    [Pyyi_y, Pyyi_z] = gradient(Pij_iyy);
    [Pzzi_y, Pzzi_z] = gradient(Pij_izz);
    [Pxyi_y, Pxyi_z] = gradient(Pij_ixy);
    [Pxzi_y, Pxzi_z] = gradient(Pij_ixz);
    [Pyzi_y, Pyzi_z] = gradient(Pij_iyz);
    Div_Pi_t{1,1} = Pxyi_y/resy + Pxzi_z/resz;
    Div_Pi_t{1,2} = Pyyi_y/resy + Pyzi_z/resz;
    Div_Pi_t{1,3} = Pyzi_y/resy + Pzzi_z/resz;
    %clearvars Pxxi_y Pxxi_z Pyyi_x Pyyi_z Pzzi_x Pzzi_z Pxyi_z Pxzi_y Pyzi_x
    %clearvars Pxxi_x Pxyi_x Pxyi_y Pyyi_y Pyzi_y Pyzi_z Pxzi_x Pxzi_z Pzzi_z
 
    %For Pe
    Pij_exx = Pij_e{1,1}; Pij_eyy = Pij_e{2,2}; Pij_ezz = Pij_e{3,3};
    Pij_exy = Pij_e{1,2}; Pij_exz = Pij_e{1,3}; Pij_eyz = Pij_e{2,3};
    
    Pij_exx = squeeze(Pij_exx(sli_x,:,:)); 
    Pij_eyy = squeeze(Pij_eyy(sli_x,:,:)); 
    Pij_ezz = squeeze(Pij_ezz(sli_x,:,:)); 
    Pij_exy = squeeze(Pij_exy(sli_x,:,:)); 
    Pij_exz = squeeze(Pij_exz(sli_x,:,:)); 
    Pij_eyz = squeeze(Pij_eyz(sli_x,:,:)); 
    
    %Grad_Pi
    [Pxxe_y, Pxxe_z] = gradient(Pij_exx);
    [Pyye_y, Pyye_z] = gradient(Pij_eyy);
    [Pzze_y, Pzze_z] = gradient(Pij_ezz);
    [Pxye_y, Pxye_z] = gradient(Pij_exy);
    [Pxze_y, Pxze_z] = gradient(Pij_exz);
    [Pyze_y, Pyze_z] = gradient(Pij_eyz);
    Div_Pe_t{1,1} = Pxye_y/resy + Pxze_z/resz;
    Div_Pe_t{1,2} = Pyye_y/resy + Pyze_z/resz;
    Div_Pe_t{1,3} = Pyze_y/resy + Pzze_z/resz;
    %clearvars Pxxe_y Pxxe_z Pyye_x Pyye_z Pzze_x Pzze_z Pxye_z Pxze_y Pyze_x
    %clearvars Pxxe_x Pxye_x Pxye_y Pyye_y Pyze_y Pyze_z Pxze_x Pxze_z Pzze_z
    %----------------------------------------------------------------------  


    % computing the electric field terms
    %----------------------------------------------------------------------  
    Ex = E{1,1}; Ex = squeeze(Ex(sli_x,:,:));
    Ey = E{1,2}; Ey = squeeze(Ey(sli_x,:,:));
    Ez = E{1,3}; Ez = squeeze(Ez(sli_x,:,:));

    Bx = B{1,1}; Bx = squeeze(Bx(sli_x,:,:));
    By = B{1,2}; By = squeeze(By(sli_x,:,:));
    Bz = B{1,3}; Bz = squeeze(Bz(sli_x,:,:));

    Jx = J{1,1}; Jx = squeeze(Jx(sli_x,:,:));
    Jy = J{1,2}; Jy = squeeze(Jy(sli_x,:,:));
    Jz = J{1,3}; Jz = squeeze(Jz(sli_x,:,:));

    Ex_p = Ex + (vy_e .*  Bz - vz_e .* By)./c; %E+vexB 
    vixBx = (vy_i .*  Bz - vz_i .* By);
    mJxBx = -(Jy .*  Bz - Jz .* By) ./ (n0 * q);
    DivPex = Div_Pe_t{1,1}; 
    %mJdt = - (me/q^2) * ...
    %----------------------------------------------------------------------  


    % This is to check that the pressure is well balanced
    %----------------------------------------------------------------------
    f333=figure(333);
    dump_p=(Bx.^2 + By.^2 + Bz.^2)+((Pij_exx+Pij_eyy+Pij_ezz)./3 + (Pij_ixx+Pij_iyy+Pij_izz)./3);
    contour(dump_p)
    colorbar
    %----------------------------------------------------------------------


    % Cuts along the reconnection line
    %----------------------------------------------------------------------
    % Along the y direction
    Ex_1d = squeeze(Ex(:,sli_z));
    Ex_p_1d = squeeze(Ex_p(:,sli_z));
    vixBx_1d = squeeze(vixBx(:,sli_z));
    mJxBx_1d = squeeze(mJxBx(:,sli_z));
    ve_dot_gradve_x_1d = squeeze(ve_dot_gradve_x(:,sli_z));
    DivPex_1d = squeeze(DivPex(:,sli_z));

    y_1d = -Ly/2:resy:Ly/2; y_1d = y_1d(1:end-1);

    %Along the z direction
    Ex_1d2 = squeeze(Ex(sli_y,:))';
    Ex_p_1d2 = squeeze(Ex_p(sli_y,:))';
    vixBx_1d2 = squeeze(vixBx(sli_y,:))';
    mJxBx_1d2 = squeeze(mJxBx(sli_y,:))';
    ve_dot_gradve_x_1d2 = squeeze(ve_dot_gradve_x(sli_y,:))';
    DivPex_1d2 = squeeze(DivPex(sli_y,:))';

    z_1d = -Lz/2:resz:Lz/2; z_1d = z_1d(1:end-1);
    %----------------------------------------------------------------------





    %----------------------------------------------------------------------
    % For the 2D plots
    %----------------------------------------------------------------------

    %--------------------------------------------------------------------------

    str = string(S2(in).name);
    newStr = extractBetween(str,"pfd_moments.","_p000000.h5");
    N_steps = str2double(newStr);
    time_t = dt*N_steps;    

    size_X=size(Div_MFT);
    zll=linspace(-Lz,Lz,size_X(2)); %Jeff flag it works with (1,size_x(2))
    yll=linspace(-Ly,Ly,size_X(1));
    [ZLL, YLL] = meshgrid(zll,yll);

    
    % For magnetic field lines
    vby = By;
    wbz = Bz;

    % For the MFT vectors
    vMFTy = MFT_y;
    wMFTz = MFT_z;

    bm_pla=sqrt(vby.*vby + wbz.*wbz);

    % This is for the electron velocities vectors
    Vevm=sqrt(vx_e.^2 + vy_e.^2 + vz_e.^2);
    Vivm=sqrt(vx_i.^2 + vy_i.^2 + vz_i.^2);
    %--------------------------------------------------------------------------


    %--------------------------------------------------------------------------
%     NN=40;
%     zstart1 = (resz)*ones(1,NN);            ystart1 = linspace(yll(1),yll(end),NN);
%     zstart2 = linspace(zll(1),zll(end),NN); ystart2 = (resy)*ones(1,NN);
%     zstart3 = (zll(end)-resz)*ones(1,NN);   ystart3 = linspace(yll(1),yll(end),NN);
%     zstart4 = linspace(zll(1),zll(end),NN); ystart4 = (yll(end)-resy)*ones(1,NN);    
%     zstart = horzcat(zstart1,zstart2,zstart3,zstart4);
%     ystart = horzcat(ystart1,ystart2,ystart3,ystart4);
%     bbb=stream2(ZLL,YLL,wbz,vby,zstart,ystart);
%     bbbm=stream2(ZLL,YLL,-wbz,-vby,zstart,ystart);    
%     MFTb=stream2(ZLL,YLL,wMFTz,vMFTy,zstart,ystart);
%     MFTbm=stream2(ZLL,YLL,-wMFTz,-vMFTy,zstart,ystart);

    sv=80; % This is for the field lines
    ystart_2nd=yll(1:sv:end,1:sv:end);
    zstart_2nd=zll(1:sv:end,1:sv:end);
    [zstart_2nd, ystart_2nd]=meshgrid(zstart_2nd,ystart_2nd);

    bbb=stream2(ZLL,YLL,wbz,vby,zstart_2nd,ystart_2nd);
    bbbm=stream2(ZLL,YLL,-wbz,-vby,zstart_2nd,ystart_2nd);

    MFTb=stream2(ZLL,YLL,wMFTz,vMFTy,zstart_2nd,ystart_2nd);
    MFTbm=stream2(ZLL,YLL,-wMFTz,-vMFTy,zstart_2nd,ystart_2nd);


    path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
    cd(path_s2)
    % This is to call the script that will make and save the latests plots
    %--------------------------------------------------------------------------
    
   
    dCp=25; colorFVBl=[0 0 0 0.2]; %sv=3; asf=3; fs=18; lw=1.5;

    % Plots
    %----------------------------------------------------------------------
    fs=20;

    f11=figure(11);
    dum_p=squeeze(DivPex);
    hc = pcolor(ZLL,YLL,dum_p);
    hold on
    hlines1=streamline(bbb);set(hlines1,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
    hlines1=streamline(bbbm);set(hlines1,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
    set(hc,'edgecolor','none')
    ax = gca;
    ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs;
    colormap(BWR);
    colorbar
    lim_yp=max(max(max(abs(dum_p))));
    caxis([-lim_yp lim_yp]);
    ylim([-Ly/4 Ly/4]);
    xlabel('$z/d_{i} $','Interpreter','latex','FontSize',fs)
    ylabel('$y/d_{i} $','Interpreter','latex','FontSize',fs)
    legend({'$(\nabla \cdot P_{e})_{x}$'},'Interpreter','latex','FontSize',fs)
    %title('$\psi^{std} = \sqrt{\langle \psi^{2} \rangle - \langle \psi \rangle^{2}}$','Interpreter','latex','FontSize',fs)
    hold off

    %---------------------
    map_r = [1.0 1.0 1.0
    1.0 0.9 0.9
    1.0 0.8 0.8
    1.0 0.7 0.7
    1.0 0.6 0.6
    1.0 0.5 0.5
    1.0 0.4 0.4
    1.0 0.3 0.3
    1.0 0.2 0.2
    1.0 0.1 0.1
    1.0 0 0
    0.8 0 0];
    %---------------------


    x0=0;y0=0;
    %x0=-1759;y0=258;
    asf=1;
    sv=30; %this one is for the vectors 
    lwv=1.0; ypc_i=127; xpc_i = 93;
    colorFVBl=[0 0 0 0.5];
    width=size_X(2);height=size_X(1); fs=20;

    yticks_mine=[floor(-Ly*0.9) floor(-Ly/2) 0 floor(Ly/2) floor(Ly*0.9)];
    zticks_mine=[floor(-Lz*0.9) floor(-Lz/2) 0 floor(Lz/2) floor(Lz*0.9)];

    f211=figure(211);
    set(gcf,'position',[x0,y0,1*width,1.1*height])
    %--------------------------------------------------------------------------
    h1=subaxis(1,2,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
    %dum_p = squeeze(Ex(sli_x,:,:));
    dum_p = squeeze(MFT_z(:,:)); Pi0=MFT0;
    dum_p=(dum_p)./(Pi0); 
    hc1 = pcolor(ZLL,YLL,dum_p);
    hold on
    hlines2=streamline(bbb);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
    hlines3=streamline(bbbm);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
    %h2v=quiver(zll(1:sv:end,1:sv:end), yll(1:sv:end,1:sv:end), wMFTz(1:sv:end,1:sv:end), vMFTy(1:sv:end,1:sv:end), 0);
    %set(h2v,'AutoScale','on', 'AutoScaleFactor', asf, 'Color', 'k','linewidth',lwv);
    lim_yp=max(max(max(abs(dum_p)))); colormap(h1,BWR);
    set(hc1,'edgecolor','none')
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    %hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ; 
    caxis([-0.1*lim_yp 0.1*lim_yp]);
    %hcb.Ruler.Exponent = -1;
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([zll(1) zll(end)]); ylim([yll(1) yll(end)]);
    lgnd=legend([h1],'$\frac{U_{\psi,z}}{U_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    %set(lgnd,'color','none');
    hold off
    %--------------------------------------------------------------------------
    h2=subaxis(1,2,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
    dum_p = squeeze(MFT_y(:,:)); Pi0=MFT0;
    dum_p=(dum_p)./(Pi0);
    hc = pcolor(ZLL,YLL,dum_p);
    hold on
    hlines2=streamline(MFTb);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
    hlines3=streamline(MFTbm);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
    lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR); 
    set(hc,'edgecolor','none')
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    %hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ; 
    caxis([-0.1*lim_yp 0.1*lim_yp]);
    %hcb.Ruler.Exponent = -1;
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
    %ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; ax.XTick = zticks_mine; %ax.XLabel.Position = [0, -0.6];
    xlim([zll(1) zll(end)]); ylim([yll(1) yll(end)]);
    lgnd=legend([h2],'$\frac{U_{\psi,y}}{U_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    %set(lgnd,'color','none');
    hold off
    sgtitle('$$t = \ $$'+string(round(time_t,2)) + ...
        '$$ \ \omega_{pe}^{-1}$$','Interpreter','latex','FontSize',fs)
    %--------------------------------------------------------------------------


    f21=figure(21);
    set(gcf,'position',[x0,y0,width,height])
    %--------------------------------------------------------------------------
    h1=subaxis(2,2,1,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
    dum_p = squeeze(Ex(:,:)); Pi0=E0;
    dum_p=(dum_p)./(Pi0); % check the normalization
    hc1 = pcolor(ZLL,YLL,dum_p);
    hold on
    hlines2=streamline(bbb);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
    hlines3=streamline(bbbm);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
    lim_yp=max(max(max(abs(dum_p)))); colormap(h1,BWR);
    set(hc1,'edgecolor','none')
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    %hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ; 
    caxis([-lim_yp lim_yp]);
    %hcb.Ruler.Exponent = -1;
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([zll(1) zll(end)]); ylim([yll(1) yll(end)]);
    lgnd=legend([h1],'$\frac{E_{x}}{E_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    %set(lgnd,'color','none');
    hold off
    %--------------------------------------------------------------------------
    h2=subaxis(2,2,2,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
    dum_p = squeeze(Bx(:,:)); Pi0=B0;
    dum_p=(dum_p)./(Pi0); % check the normalization
    hc = pcolor(ZLL,YLL,dum_p);
    hold on
    hlines2=streamline(bbb);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
    hlines3=streamline(bbbm);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
    lim_yp=max(max(max(abs(dum_p)))); colormap(h2,BWR);%colormap(h2,map_r); 
    set(hc,'edgecolor','none')
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    %hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ; 
    caxis([-lim_yp lim_yp]);
    %hcb.Ruler.Exponent = -1;
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
    %ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    %ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([zll(1) zll(end)]); ylim([yll(1) yll(end)]);
    lgnd=legend([h2],'$\frac{B_{x}}{B_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    %set(lgnd,'color','none');
    hold off
    %--------------------------------------------------------------------------
    h3=subaxis(2,2,3,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
    dum_p = squeeze(Ex_p(:,:)); Pi0=E0;
    dum_p=(dum_p)./(Pi0); % check the normalization
    hc = pcolor(ZLL,YLL,dum_p);
    hold on
    hlines2=streamline(bbb);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
    hlines3=streamline(bbbm);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
    lim_yp=max(max(max(abs(dum_p)))); colormap(h3,BWR);
    set(hc,'edgecolor','none')
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    %hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ; 
    caxis([-lim_yp lim_yp]);
    %hcb.Ruler.Exponent = -1;
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];    
    xlim([zll(1) zll(end)]); ylim([yll(1) yll(end)]);
    lgnd=legend([h3],'$\frac{(E+v_{e}\times B/c)_{x}}{E_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    %set(lgnd,'color','none');
    hold off
    %--------------------------------------------------------------------------
    h4=subaxis(2,2,4,'SV',0.01,'SH',0.004,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
    dum_p = squeeze(Div_MFT(:,:)); Pi0=MFT0;
    dum_p=(dum_p)./(Pi0); % check the normalization
    hc = pcolor(ZLL,YLL,dum_p);
    hold on
    hlines2=streamline(bbb);set(hlines2,'LineWidth',1.0, 'Color', colorFVBl);%colorFVBl);
    hlines3=streamline(bbbm);set(hlines3,'LineWidth',1.0, 'Color', colorFVBl);
    lim_yp=max(max(max(abs(dum_p)))); colormap(h4,BWR);
    set(hc,'edgecolor','none')
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    %hcb.Ticks = linspace(-0.05,0.05,5); hcb.TickLabels = [-0.05,-0.03,0,0.03,0.05] ; 
    caxis([-0.1*lim_yp 0.1*lim_yp]);
    %hcb.Ruler.Exponent = -1;
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; ax.XTick = []; ax.YTick = [];
    %ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([zll(1) zll(end)]); ylim([yll(1) yll(end)]);
    lgnd=legend([h4],'$\frac{\nabla \cdot U_{\psi}}{\omega_{pe}} $','Interpreter','latex','FontSize',1.3*fs);
    %set(lgnd,'color','none');
    hold off
    sgtitle('$$t = \ $$'+string(round(time_t,2)) + ...
        '$$ \ \omega_{pe}^{-1}$$','Interpreter','latex','FontSize',fs)
    %--------------------------------------------------------------------------


    % This one is ready
    f31=figure(31);
    set(gcf,'position',[x0,y0,0.9*width,height])
    h1=subaxis(2,2,1,'SV',0.01,'SH',0.04,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
    plot(yll,Ex_1d/E0,'-k','LineWidth',2)
    hold on
    plot(yll,Ex_p_1d/E0,'-b','LineWidth',2)
    plot(yll,vixBx_1d/E0,'-r','LineWidth',2)
    plot(yll,ve_dot_gradve_x_1d/E0,'-c','LineWidth',2)
    %plot(yll,DivPex_1d/E0,'-m','LineWidth',2)
    %plot(y_1d,mJxBx_1d,'-c','LineWidth',2)
    set(gca,'FontSize',20)
    ax = gca;
    ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs;
    ax.XTick = [];    
    %ax.YTick = [];
    xlim([yll(1) yll(end)]);
    %ylimit=[abs(Ex_1d),abs(Ex_p_1d),abs(vixBx_1d),abs(ve_dot_gradve_x_1d),abs(DivPex_1d)];
    ylimit=[abs(Ex_1d),abs(Ex_p_1d),abs(vixBx_1d),abs(ve_dot_gradve_x_1d)];
    ylimit=max(max(ylimit))/E0;
    ylim([-ylimit ylimit]);
    xlabel('$y/d_{i} $','Interpreter','latex','FontSize',fs)
    ylabel('$E_{x}/E_{0}$','Interpreter','latex','FontSize',fs)
    %legend({'$E_{x}$','$(E + v_{e}\times B/c)_{x}$',...
    %    '$(v_{i}\times B/c)_{x}$','$(v_{e}\cdot\nabla v_{e})_{x}$','$(\nabla \cdot P_{e})_{x}$'},...
    %    'Interpreter','latex','FontSize',fs,'Location','southwest','NumColumns',2)
    legend({'$E_{x}$','$(E + v_{e}\times B/c)_{x}$',...
        '$(v_{i}\times B/c)_{x}$','$(v_{e}\cdot\nabla v_{e})_{x}$'},...
        'Interpreter','latex','FontSize',fs,'Location','southwest','NumColumns',2)
    title('$$z/d_{i}=0$$','Interpreter','latex','FontSize',fs)
    hold off
    %-----------------------
    h2=subaxis(2,2,2,'SV',0.01,'SH',0.04,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
    plot(zll,Ex_1d2/E0,'-k','LineWidth',2)
    hold on
    plot(zll,Ex_p_1d2/E0,'-b','LineWidth',2)
    plot(zll,vixBx_1d2/E0,'-r','LineWidth',2)
    plot(zll,ve_dot_gradve_x_1d2/E0,'-c','LineWidth',2)
    %plot(zll,DivPex_1d2/E0,'-m','LineWidth',2)
    set(gca,'FontSize',20)
    ax = gca;
    ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
    %yyaxis right
    ax.YLabel.Interpreter='latex';
    ax.FontSize=fs;
    ax.XTick = [];    
    %ax.YTick = [];
    xlim([zll(1) zll(end)]);    
    %ylimit=[abs(Ex_1d2),abs(Ex_p_1d2),abs(vixBx_1d2),abs(ve_dot_gradve_x_1d2),abs(DivPex_1d2)];
    ylimit=[abs(Ex_1d2),abs(Ex_p_1d2),abs(vixBx_1d2),abs(ve_dot_gradve_x_1d2)];
    ylimit=max(max(ylimit))/E0;
    ylim([-ylimit ylimit]);
    xlabel('$z/d_{i} $','Interpreter','latex','FontSize',fs)
    ylabel('$E_{x}/E_{0}$','Interpreter','latex','FontSize',fs)
    %legend({'$E_{x}$','$E_{x} + (v_{e}\times B)_{x}/c$','$(v_{i}\times B)_{x}/c$',...
    %    '$(v_{e}\cdot\nabla v_{e})_{x}$','$(\nabla \cdot P_{e})_{x}$'},'Interpreter','latex','FontSize',fs,...
    %    'Location','southwest','NumColumns',2)
    legend({'$E_{x}$','$E_{x} + (v_{e}\times B)_{x}/c$','$(v_{i}\times B)_{x}/c$',...
        '$(v_{e}\cdot\nabla v_{e})_{x}$'},'Interpreter','latex','FontSize',fs,...
        'Location','southwest','NumColumns',2)
    title('$$y/d_{i}=6.36$$','Interpreter','latex','FontSize',fs)
    hold off
    %-----------------------
    h3=subaxis(2,2,3,'SV',0.01,'SH',0.04,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
    plot(yll,Div_MFT_1d_ay/MFT0,'-k','LineWidth',2)
    hold on
    %plot(y_1d,mJxBx_1d,'-c','LineWidth',2)
    set(gca,'FontSize',20)
    ax = gca;
    ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
    ax.YLabel.Interpreter='latex';
    ax.FontSize=fs;
    %ax.XTick = [];    
    %ax.YTick = [];
    xlim([yll(1) yll(end)]);    
    ylimit=max(max(abs(Div_MFT_1d_ay/MFT0)));
    ylim([-ylimit ylimit]);
    xlabel('$y/d_{i} $','Interpreter','latex','FontSize',fs)
    ylabel('$\nabla \cdot U_{\psi}$','Interpreter','latex','FontSize',fs)
    legend({'$\nabla \cdot U_{\psi}$'},'Interpreter','latex','FontSize',fs)
    %title('$$t = \ $$'+string(round(time_t,2)) + '$$ \ \omega_{pe}^{-1} \ ; \ z/d_{i}=0$$','Interpreter','latex','FontSize',fs)
    hold off
    %-----------------------
    h4=subaxis(2,2,4,'SV',0.01,'SH',0.04,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
    plot(zll,Div_MFT_1d_az/MFT0,'-k','LineWidth',2)
    hold on
    set(gca,'FontSize',20)
    ax = gca;
    %yyaxis right
    ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';
    ax.YLabel.Interpreter='latex';
    ax.FontSize=fs;
    %ax.XTick = [];   
    %ax.YTick = [];
    xlim([zll(1) zll(end)]);        
    ylimit=max(max(abs(Div_MFT_1d_az/MFT0)));
    ylim([-ylimit ylimit]);
    xlabel('$z/d_{i} $','Interpreter','latex','FontSize',fs)
    %ylabel('$\nabla \cdot U_{\psi}$','Interpreter','latex','FontSize',fs)
    legend({'$\nabla \cdot U_{\psi}$'},'Interpreter','latex','FontSize',fs)
    %title('$$t = \ $$'+string(round(time_t,2)) + ...
        %'$$ \ \omega_{pe}^{-1} \ ; \ y/d_{i}=0$$','Interpreter','latex','FontSize',fs)
    hold off
    sgtitle('$$t = \ $$'+string(round(time_t,2)) + ...
        '$$ \ \omega_{pe}^{-1}$$','Interpreter','latex','FontSize',fs)    
    %----------------------------------------------------------------------




    cd(path_s2)
    %----------------------------------------------------------------------
    ExB_drift_x= (Ey.*Bz - Ez.*By)./(Bz.^2 + By.^2);
    ExB_drift_y= (-Ex.*Bz + Ez.*Bx)./(Bz.^2 + By.^2);
    ExB_drift_z= (Ex.*By - Ey.*Bx)./(Bz.^2 + By.^2);
    % 
    f41=figure(41);
    set(gcf,'position',[x0,y0,0.9*width,height])
    h1=subaxis(2,2,1,'SV',0.01,'SH',0.04,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
    plot(yll,vx_i(:,sli_z),'-r','LineWidth',2)
    hold on
    plot(yll,vx_e(:,sli_z),'-b','LineWidth',2)
    plot(yll,ExB_drift_x(:,sli_z),'-k','LineWidth',2)
    set(gca,'FontSize',20)
    ax = gca;
    ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs;
    ax.XTick = [];    
    %ax.YTick = [];
    xlim([yll(1) yll(end)]);    
    ylimit=[abs(vx_i(:,sli_z)),abs(vx_e(:,sli_z)),abs(ExB_drift_x(:,sli_z))];
    ylimit=max(max(ylimit));
    ylim([-ylimit ylimit]);
    xlabel('$y/d_{i} $','Interpreter','latex','FontSize',fs)
    ylabel('$v_{x}/v_{0}$','Interpreter','latex','FontSize',fs)
    legend({'$v_{i,x}$','$v_{e,x}$','$(E \times B/|B|^2)_{x}$'},'Interpreter','latex','FontSize',fs,'Location','southwest','NumColumns',2)
    title('$$z/d_{i}=0$$','Interpreter','latex','FontSize',fs)
    hold off
    %----------------------------------------------------------------------
    h2=subaxis(2,2,2,'SV',0.01,'SH',0.04,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
    plot(yll,vy_i(:,sli_z),'-r','LineWidth',2)
    hold on
    plot(yll,vy_e(:,sli_z),'-b','LineWidth',2)
    plot(yll,ExB_drift_y(:,sli_z),'-k','LineWidth',2)
    set(gca,'FontSize',20)
    ax = gca;
    ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs;
    ax.XTick = [];    
    %ax.YTick = [];
    xlim([yll(1) yll(end)]);    
    ylimit=[abs(vy_i(:,sli_z)),abs(vy_e(:,sli_z)),abs(ExB_drift_y(:,sli_z))];
    ylimit=max(max(ylimit));
    ylim([-ylimit ylimit]);
    xlabel('$y/d_{i} $','Interpreter','latex','FontSize',fs)
    ylabel('$v_{y}/v_{0}$','Interpreter','latex','FontSize',fs)
    legend({'$v_{i,y}$','$v_{e,y}$','$(E \times B/|B|^2)_{y}$'},...
        'Interpreter','latex','FontSize',fs,'Location','southwest','NumColumns',2)
    title('$$z/d_{i}=0$$','Interpreter','latex','FontSize',fs)
    hold off
    %----------------------------------------------------------------------
    h3=subaxis(2,2,3,'SV',0.01,'SH',0.04,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
    plot(yll,vz_i(:,sli_z),'-r','LineWidth',2)
    hold on
    plot(yll,vz_e(:,sli_z),'-b','LineWidth',2)
    plot(yll,ExB_drift_z(:,sli_z),'-k','LineWidth',2)
    set(gca,'FontSize',20)
    ax = gca;
    ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs;
    ax.XTick = [];    
    %ax.YTick = [];
    xlim([yll(1) yll(end)]);    
    ylimit=[abs(vz_i(:,sli_z)),abs(vz_e(:,sli_z)),abs(ExB_drift_z(:,sli_z))];
    ylimit=max(max(ylimit));
    ylim([-ylimit ylimit]);
    xlabel('$y/d_{i} $','Interpreter','latex','FontSize',fs)
    ylabel('$v_{z}/v_{0}$','Interpreter','latex','FontSize',fs)
    legend({'$v_{i,z}$','$v_{e,z}$','$(E \times B/|B|^2)_{z}$'},...
        'Interpreter','latex','FontSize',fs,'Location','southwest','NumColumns',2)
    %title('$$z/d_{i}=0$$','Interpreter','latex','FontSize',fs)
    hold off
    %----------------------------------------------------------------------
    h4=subaxis(2,2,4,'SV',0.01,'SH',0.04,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
    plot(yll,MFT_y(:,sli_z),'-c','LineWidth',2)
    hold on
    plot(yll,MFT_z(:,sli_z),'-m','LineWidth',2)
    set(gca,'FontSize',20)
    ax = gca;
    ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs;
    ax.XTick = [];    
    %ax.YTick = [];
    xlim([yll(1) yll(end)]);    
    ylimit=[abs(MFT_y(:,sli_z)),abs(MFT_z(:,sli_z))];
    ylimit=max(max(ylimit));
    ylim([-ylimit ylimit]);
    xlabel('$y/d_{i} $','Interpreter','latex','FontSize',fs)
    %ylabel('$v_{z}/v_{0}$','Interpreter','latex','FontSize',fs)
    legend({'$U_{\psi,y}$','$U_{\psi,z}$'},'Interpreter','latex','FontSize',fs,'Location','southwest','NumColumns',2)
    %title('$$z/d_{i}=0$$','Interpreter','latex','FontSize',fs)
    hold off
    %----------------------------------------------------------------------


    f51=figure(51);
    set(gcf,'position',[x0,y0,0.9*width,height])
    h1=subaxis(2,2,1,'SV',0.01,'SH',0.04,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
    plot(zll,vx_i(sli_y,:),'-r','LineWidth',2)
    hold on
    plot(zll,vx_e(sli_y,:),'-b','LineWidth',2)
    plot(zll,ExB_drift_x(sli_y,:),'-k','LineWidth',2)
    set(gca,'FontSize',20)
    ax = gca;
    ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs;
    ax.XTick = [];    
    %ax.YTick = [];
    xlim([zll(1) zll(end)]);    
    ylimit=[abs(vx_i(sli_y,:)),abs(vx_e(sli_y,:)),abs(ExB_drift_x(sli_y,:))];
    ylimit=max(max(ylimit));
    ylim([-ylimit ylimit]);
    xlabel('$z/d_{i} $','Interpreter','latex','FontSize',fs)
    ylabel('$v_{x}/v_{0}$','Interpreter','latex','FontSize',fs)
    legend({'$v_{i,x}$','$v_{e,x}$','$(E \times B/|B|^2)_{x}$'},'Interpreter','latex','FontSize',fs,'Location','southwest','NumColumns',2)
    title('$$y/d_{i}=6.36$$','Interpreter','latex','FontSize',fs)
    hold off
    %----------------------------------------------------------------------
    h2=subaxis(2,2,2,'SV',0.01,'SH',0.04,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
    plot(zll,vy_i(sli_y,:),'-r','LineWidth',2)
    hold on
    plot(zll,vy_e(sli_y,:),'-b','LineWidth',2)
    plot(zll,ExB_drift_y(sli_y,:),'-k','LineWidth',2)
    set(gca,'FontSize',20)
    ax = gca;
    ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs;
    ax.XTick = [];    
    %ax.YTick = [];
    xlim([zll(1) zll(end)]);    
    ylimit=[abs(vy_i(sli_y,:)),abs(vy_e(sli_y,:)),abs(ExB_drift_y(sli_y,:))];
    ylimit=max(max(ylimit));
    ylim([-ylimit ylimit]);
    xlabel('$z/d_{i} $','Interpreter','latex','FontSize',fs)
    ylabel('$v_{y}/v_{0}$','Interpreter','latex','FontSize',fs)
    legend({'$v_{i,y}$','$v_{e,y}$','$(E \times B/|B|^2)_{y}$'},...
        'Interpreter','latex','FontSize',fs,'Location','southwest','NumColumns',2)
    title('$$y/d_{i}=6.36$$','Interpreter','latex','FontSize',fs)
    hold off
    %----------------------------------------------------------------------
    h3=subaxis(2,2,3,'SV',0.01,'SH',0.04,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
    plot(zll,vz_i(sli_y,:),'-r','LineWidth',2)
    hold on
    plot(zll,vz_e(sli_y,:),'-b','LineWidth',2)
    plot(zll,ExB_drift_z(sli_y,:),'-k','LineWidth',2)
    set(gca,'FontSize',20)
    ax = gca;
    ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs;
    ax.XTick = [];    
    %ax.YTick = [];
    xlim([zll(1) zll(end)]);    
    ylimit=[abs(vz_i(sli_y,:)),abs(vz_e(sli_y,:)),abs(ExB_drift_z(sli_y,:))];
    ylimit=max(max(ylimit));
    ylim([-ylimit ylimit]);
    xlabel('$z/d_{i} $','Interpreter','latex','FontSize',fs)
    ylabel('$v_{z}/v_{0}$','Interpreter','latex','FontSize',fs)
    legend({'$v_{i,z}$','$v_{e,z}$','$(E \times B/|B|^2)_{z}$'},...
        'Interpreter','latex','FontSize',fs,'Location','southwest','NumColumns',2)
    %title('$$y/d_{i}=0$$','Interpreter','latex','FontSize',fs)
    hold off
    %----------------------------------------------------------------------
    h4=subaxis(2,2,4,'SV',0.01,'SH',0.04,'MR',0.005,'ML',0.05,'PL',0.005,'PR',0.006);
    plot(zll,MFT_y(sli_y,:),'-c','LineWidth',2)
    hold on
    plot(zll,MFT_z(sli_y,:),'-m','LineWidth',2)
    set(gca,'FontSize',20)
    ax = gca;
    ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs;
    ax.XTick = [];    
    %ax.YTick = [];
    xlim([zll(1) zll(end)]);    
    ylimit=[abs(MFT_y(sli_y,:)),abs(MFT_z(sli_y,:))];
    ylimit=max(max(ylimit));
    ylim([-ylimit ylimit]);
    xlabel('$z/d_{i} $','Interpreter','latex','FontSize',fs)
    %ylabel('$v_{z}/v_{0}$','Interpreter','latex','FontSize',fs)
    legend({'$U_{\psi,y}$','$U_{\psi,z}$'},'Interpreter','latex','FontSize',fs,'Location','southwest','NumColumns',2)
    %title('$$y/d_{i}=0$$','Interpreter','latex','FontSize',fs)
    hold off
    %----------------------------------------------------------------------


    %----------------------------------------------------------------------


    cd(path_rr)
    %-------------------------------------------------------------------------
    cd(path_rr_mft)
    saveas(f21,strcat(num2str(time_t),'MFT_components.png'));
    cd(path_rr_Ef)
    saveas(f2,strcat(num2str(time_t),'electric_fields.png'));
    saveas(f1,strcat(num2str(time_t),'Div_P_x.png'));
    cd(path_rr_1dcuts)
    saveas(f3,strcat(num2str(time_t),'1D_cuts_mft.png'));
    saveas(f4,strcat(num2str(time_t),'1D_cuts_velocities_y.png'));
    saveas(f5,strcat(num2str(time_t),'1D_cuts_velocities_z.png'));
    cd(path);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%