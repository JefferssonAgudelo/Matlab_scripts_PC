
% In this script I compare different runs in terms of the reconnection rate.
% Saving some of the results in files to load. Comparing, reconneciton
% rate, reconnected flux and the maximum of each of the components. 


N=220;
%N=183;
%N=156;

%--------------------------------------------------------------------------
Bx2_mean_T = zeros(N,5);
By2_mean_T = zeros(N,5);
Bz2_mean_T = zeros(N,5);
B2_mean_T = zeros(N,5);
Bx2_max_T = zeros(N,5);
By2_max_T = zeros(N,5);
Bz2_max_T = zeros(N,5);
B2_max_T = zeros(N,5);
%--------------------------------------------------------------------------
%A_max_min_To_o = zeros(N,6); % this is to add an extra column 
%A_max_min_To_o(:,1:5) = A_max_min_To;
A_max_min_To = zeros(N,5);
time_t_2_T = zeros(N,5);
%--------------------------------------------------------------------------

kn=6;
kn=1;
kn=5

for kn=1:4

% %     % This set shows the difference in terms of the onset.
% %     % ABCDE
% %     %----------------------------------------------------------------------------------------------------------------------
% %     if(kn==1)
% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_alone_large';
% %     elseif(kn==2)
% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large';
% %     elseif(kn==3)
% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_Ax_large';
% %     elseif(kn==4)
% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large';
% %     elseif(kn==5)
% %         %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini_L8di_8_du02'; %<-- this is in reality L=4.
% %     end
% %     %legends_comp={'A','B','C','D','E'};
% %     legends_comp={'A','B','C','D'};

% %     legends_comp={'A','B','C','D','E','D*'};
    %-----------------------------------------------------------------------------------------------------------------------

    % E1 E2 E3 E4 E5
% %     % This set shows the difference with n0, omega0, gamma0 and dB.
% %     %----------------------------------------------------------------------------------------------------------------------
% %     if(kn==1)
% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_nb01';
% %     elseif(kn==2)
% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_Bg01';
% %     elseif(kn==3)
% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_0mega09';
% %     elseif(kn==4)
% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_gamma06';
% %     elseif(kn==5)
% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB02';
% %     %elseif(kn==6)
% %     %    path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large';
% %     end
% %     legends_comp={'E1','E2','E3','E4','E5'};
% %     %-----------------------------------------------------------------------------------------------------------------------


% %     %  A ABg02 E
% %     %----------------------------------------------------------------------------------------------------------------------
% %     if(kn==1)
% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_alone_large';
% %     elseif(kn==2)
% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large_Bg02'; % this is with no pinch    
% %     elseif(kn==3)
% %         %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini_L8di_8_du02';
% %         %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_Bg01'; % what is this really?
% %         continue
% %     elseif(kn==4)
% %         %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_Bg01_below';
% %         continue
% %     elseif(kn==5)
% %         %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini_L8di_8_du02';
% %         continue
% %     end
% %     legends_comp={'A','ABg02','E'};
% %     %-----------------------------------------------------------------------------------------------------------------------
    

    %----------------------------------------------------------------------------------------------------------------------
    %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_Bg01_below';
    %----------------------------------------------------------------------------------------------------------------------


% %     % This E, EdB08, EdB08_ome01, EdB08_ome01_cp .
% %     %----------------------------------------------------------------------------------------------------------------------
% %     if(kn==1)
% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini_L8di_8_du02';
% %     elseif(kn==2)
% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08'; % this is with no pinch    
% %     elseif(kn==3)
% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_ome01';
% %     elseif(kn==4)
% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_ome01_cp'; % this one took longer. why?
% %     elseif(kn==5)
% %         %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini_L8di_8_du02';        
% %     continue
% %     end
% %     legends_comp={'E','EdB08','EdB08O01','EdB08O01cp'};
% %     %-----------------------------------------------------------------------------------------------------------------------

% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_Omc1';
% % 
% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1';

    %  Cyclotron frequency runs and short wave lengths 
% %     %----------------------------------------------------------------------------------------------------------------------
% %     if(kn==1)
% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1';
% %     elseif(kn==2)
% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_Omc1';
% %     elseif(kn==3)
% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kd1';
% %     elseif(kn==4)
% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_Omc1_kd1';
% %     elseif(kn==5)
% %         path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB04_Omc1_kd1';
% % 
% %     end
% %     legends_comp={'Oc1dB01','Oc1dB08','Oc1dkd1B01','Oc1dkd1B08','Oc1dkd1B04'};
% %     %-----------------------------------------------------------------------------------------------------------------------

    %  plasma, cyclotron frequency, di, rho 
    %----------------------------------------------------------------------------------------------------------------------
    if(kn==1)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kLd1';
    elseif(kn==2)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kLr1';
    elseif(kn==3)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_omp1_kLd1';
    elseif(kn==4)
        path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_omp1_kLr1';
    end
    legends_comp={'Oc1d1dB01','Oc1r1dB01','Op1d1B01','Op1r1B01'};
    %-----------------------------------------------------------------------------------------------------------------------


    path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison'; 

    %-----------------------------------------------------------------------------------------------------------------------
    % For the scripts
    path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
    path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
    %-----------------------------------------------------------------------------------------------------------------------

    %-----------------------------------------------------------------------------------------------------------------------
    % To save the plots
    path_rec_r = strcat(path,'/spectra/rec_r');
    path_rec_line = strcat(path,'/spectra/rec_line');
    path_rec_line_ByBzJx = strcat(path,'/spectra/rec_line/ByBzJx');

    if not(isfolder(path_rec_r))
        mkdir(path_rec_r)
    end
    if not(isfolder(path_rec_line))
        mkdir(path_rec_line)
    end
    if not(isfolder(path_rec_line_ByBzJx))
        mkdir(path_rec_line_ByBzJx)
    end
    %-----------------------------------------------------------------------------------------------------------------------

    cd(path)
    %--------------------------------------------------------------------------
    S = dir(fullfile(path,'pfd.*.h5'));
    N=numel(S); % number of files to use
    H=zeros(N);
    %--------------------------------------------------------------------------
    S2 = dir(fullfile(path,'pfd_moments.*.h5'));
    N2=numel(S2); % number of files to use
    H2=zeros(N2);
    %--------------------------------------------------------------------------

    %--------------------------------------------------------------------------
    % Normalization
    %B are normalized to the background magnetic field
    B0=0.2;
    %n is normalise to the proton density n0=1
    n0=1;
    %Vi normalised to the proton alfven speed V_a=0.1c The alfven speed of
    %electrons is Vae=10Vai
    Vai=0.2;%0.2;
    Vae=0.2;%0.2;
    Va=0.2;%0.2;
    %E = vB, as B0=0.1 and v in units of c, E0= B0*Vai/c
    E0=0.2;%0.2; %??
    %T=(beta/2)B^2, Thus, as beta=1
    T0=0.02;%0.02;
    %The current density J0=1?
    J0=Vae;

    mime =1.;

    MFT0=1; % is this simply one in this normalization

    %--------------------------------------------------------------------------
    nb_n0 =0.1;
    Vai_b=Vai/sqrt(nb_n0);
    Vae_b=Vae/sqrt(nb_n0);

    %--------------------------------------------------------------------------
    kb = 1.;
    mu0 =1.;
    c=1;
    q = 1;
    %mime =1.;
    mi = 1.;
    me = 1. / mime; eps0=1.;
    omega_pi=1;
    Omega_e=Vai*sqrt(mime)*omega_pi;
    Omega_i=Omega_e / mime;
    TOmega_e=1/Omega_e;
    TOmega_i=1/Omega_i;
    omega_pe_Omega_ce=5;
    %--------------------------------------------------------------------------
    in=1;
    fileID =  S(in).name; %change the 1 per i
    %h5disp(fileID);
    info = h5info(fileID);
    EHJ_1st = info.Groups(16).Name;
    B=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    ss=size(B);
    LZs=ss(3);
    clearvars B

    %N=215;
    %N=183; %N =183 is the limit for the run to keep the same time steps.
    %N=156;
    N_jn=N;

    % %--------------------------------------------------------------------------
    % % Making a plot for B2 as a function of time to see the growth rate of
    % the instability
    % %--------------------------------------------------------------------------
    %
    time_t_2=zeros(1,N);

    Bz2_mean=zeros(1,N);

    Bx2_max=zeros(1,N);
    By2_max=zeros(1,N);
    Bz2_max=zeros(1,N);
    B2_max=zeros(1,N);

    for in=1:N
        disp(strcat('Computing step ...',S(in).name))
        fileID =  S(in).name; %change the 1 per i
        %h5disp(fileID);
        info = h5info(fileID);
        EHJ_1st = info.Groups(16).Name;
        grid_dt = info.Groups(20).Attributes;

        grid_length = info.Groups(17).Attributes;
        Lx=grid_length(4).Value(1);% - grid_length(3).Value(1);
        Ly=grid_length(4).Value(2);% - grid_length(3).Value(2);
        Lz=grid_length(4).Value(3);% - grid_length(3).Value(3);

        Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
        By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
        Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));

        Bx2 = Bx.^2; By2 = By.^2; Bz2 = Bz.^2;
        B2 = Bx2 + By2 + Bz2; % it seems the total magnetic field goes

        Bx2_max(1,in) = max(max(max(Bx2)));
        By2_max(1,in) = max(max(max(By2)));
        Bz2_max(1,in) = max(max(max(Bz2)));
        B2_max(1,in) = max(max(max(B2)));
        %down

        %----------------------------------------------------------------------
        sli_x = 1; 
        Bz = squeeze(Bz(sli_x,:,:));

        sss=size(Bz);
        size_X=sss;
        zll=linspace(-Lz,Lz,size_X(2)); %Jeff flag it works with (1,size_x(2))
        yll=linspace(-Ly,Ly,size_X(1));
  
        ly=length(yll);
        Ly_2_0 = ly/2;
        Ly_2_2 = Ly_2_0 + 2*Ly_2_0/4;
        Ly_2_4 = Ly_2_0 + 4*Ly_2_0/4;
      
        Bz_24 = Bz(Ly_2_2:Ly_2_4,:);
        Bz2_mean(1,in) = mean(abs(Bz_24),'all').*mean(abs(Bz_24),'all');

        dt=double(grid_dt(15).Value);
        str = string(S(in).name);
        newStr = extractBetween(str,"pfd.","_p000000.h5");
        N_steps = str2double(newStr);
        time_t = dt*N_steps;
        time_t_2_Omega=time_t./omega_pe_Omega_ce;
        time_t_2(1,in)=time_t_2_Omega;


        cd(path)
    end

    %--------------------------------------------------------------------------

    %--------------------------------------------------------------------------
    % Keep the data to compare among the different runs.
    %kn=1; %<-----------------------

% %     Bx2_mean_T(:,kn) = Bx2_mean;
% %     By2_mean_T(:,kn) = By2_mean;
% %     Bz2_mean_T(:,kn) = Bz2_mean;
% %     B2_mean_T(:,kn) = B2_mean;
% % 
% %     Bx2_max_T(:,kn) = Bx2_max;
% %     By2_max_T(:,kn) = By2_max;
% %     Bz2_max_T(:,kn) = Bz2_max;
% %     B2_max_T(:,kn) = B2_max;
% % 
% %     time_t_2_T(:,kn) = time_t_2;

    % This is to get the mena value of the upstream magnetic field for the
    %normalization of the reconnection rate

    Bz2_mean_T{kn} = Bz2_mean;

    Bx2_max_T{kn} = Bx2_max;
    By2_max_T{kn} = By2_max;
    Bz2_max_T{kn} = Bz2_max;
    B2_max_T{kn} = B2_max;

    time_t_2_T{kn} = time_t_2;

end

    %--------------------------------------------------------------------------
    %}
    %--------------------------------------------------------------------------
    %--------------------------------------------------------------------------    
    %--------------------------------------------------------------------------

    cd(path)

    % This now seems to work ok to compute the reconnection rate taking the
    % maximum and minimum
    % %--------------------------------------------------------------------------
    % %--------------------------------------------------------------------------
    jn=N;
    time_t_2=zeros(1,N);
    A_max_min_T=zeros(1,N);
    %Ax_y_T=cell(1,N);
    %Ex_T=cell(1,N);
    for jn=1:N
        in=jn;
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
        Lx=grid_length(4).Value(1);% - grid_length(3).Value(1);
        Ly=grid_length(4).Value(2);% - grid_length(3).Value(2);
        Lz=grid_length(4).Value(3);% - grid_length(3).Value(3);

        resx=double(Lx)/double(dx);
        resy=double(Ly)/double(dy);
        resz=double(Lz)/double(dz); res=resy;

        threshold=pi/resy;
        %--------------------------------------------------------------------------

        B{1,1}=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
        B{1,2}=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
        B{1,3}=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));

        %From 3D to 2D (x,y,z) to (y,z)
        %----------------------------------------------------------------------
        %----------------------------------------------------------------------
        % slice in x
        ssz=size(B{1,1});
        sli_x = 1; % this value has to change to reconstruct the vector potential
        sli_y = floor(4+ssz(2)/2);%380;
        sli_z = floor(2+ssz(3)/2);%700;
        %----------------------------------------------------------------------
        %----------------------------------------------------------------------

        % computing the electric field terms
        %----------------------------------------------------------------------
        %Bx = B{1,1}; Bx = squeeze(Bx(sli_x,:,:));
        By = B{1,2}; By = squeeze(By(sli_x,:,:));
        Bz = B{1,3}; Bz = squeeze(Bz(sli_x,:,:));
        %----------------------------------------------------------------------
        sss=size(By);
        size_X=sss;
        zll=linspace(-Lz,Lz,size_X(2)); %Jeff flag it works with (1,size_x(2))
        yll=linspace(-Ly,Ly,size_X(1));
        [ZLL, YLL] = meshgrid(zll,yll);
        %----------------------------------------------------------------------

        % Compute the out of the plane vector potential
        %----------------------------------------------------------------------
        % get ax integrating over y
        dx = resy; dy = resz;
        ny=sss(1);
        nz=sss(2);
        Iapprox = zeros(size(By));
        Iapprox_i=0;
        %integral over y
        for i=1:ny-1
            Iapprox_i = Iapprox_i + dy*Bz(i,:);
            Iapprox(i,:) = Iapprox_i;
        end

        Ax_y=Iapprox; %<------- This is the correct Ax
        Ax_y=-Ax_y;
        %----------------------------------------------------------------------

        %--------------------------------------------------------------------------
        str = string(S(in).name);
        newStr = extractBetween(str,"pfd.","_p000000.h5");
        N_steps = str2double(newStr);
        time_t = dt*N_steps;
        time_t_2_Omega=time_t./omega_pe_Omega_ce;
        time_t_2(1,in)=time_t_2_Omega;
        %----------------------------------------------------------------------

        % At a given time
        % Apply the condition of along Bz=0; %<------------ I still need to
        % include the correct normalization of the reconnection rate
        %----------------------------------------------------------------------

        ll=1;
        %for lln=1:N
        %Ax_y=Ax_y_T{1,lln};
        ss=size(Ax_y);
        A_cond=zeros(ss);
        for ln=1:length(zll)
            bz_min = min(abs(Bz(:,ln)));
            A_cond(:,ln) = abs(Bz(:,ln))<= 1*bz_min; % this runs for each Bz
        end

        Ax_y_bz0=A_cond.*Ax_y; % find the value of Ax where Bz=0
        Ax_y_bz0=Ax_y_bz0(Ax_y_bz0~=0); % remove zeros
        [N_bins,edges] = histcounts(Ax_y_bz0,80); %Create bins to find the values max and min Ax

        edges_c = edges(2:end).*N_bins(1:end); %Multiply to get rid of the zero counts
        edges_c2 = edges(2:end).*(edges_c~=0);
        edges_c2 = edges_c2(edges_c2~=0); %remove the zero counts

        A_min = min(edges_c2); % get the actual min and max
        A_max = max(edges_c2);
        %Safe the value of the diference
        A_max_min = A_max - A_min;
        %disp(A_max_min)
        A_max_min_T(1,in) = A_max_min;
        %end

        %----------------------------------------------------------------------
        %Ax_y_T{1,in} = Ax_y; % This is to store the whole data of Ax if
        %needed it
    end

% %     %now safe the reconnection rate array
% %     A_max_min_To(:,kn) = A_max_min_T; 
% %     %A_max_min_To_o(:,kn) = A_max_min_T; % when adding the extra column

    A_max_min_To{kn} = A_max_min_T;
    time_t_2_T{kn} = time_t_2;

end

% The other thing that I need to get is the time derivatative and the 
% normalization of Ax to finally get the reconnection rate 

    %--------------------------------------------------------------------------
    cd(path_comp)
    save('Bfield_mean_max_A_comparison_ABCD.mat',...
        'time_t_2','Bz2_mean_T',...
        'Bx2_max_T','By2_max_T','Bz2_max_T','B2_max_T','A_max_min_To','time_t_2_T')
    %--------------------------------------------------------------------------

    % %--------------------------------------------------------------------------
    path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';    
    cd(path_comp)
    %load('Bfield_mean_max_A_comparison.mat')
    load('Bfield_mean_max_A_comparison_ABCD.mat')

    time_t_2_T_ABCD = time_t_2_T;
    %Bx2_mean_T_ABCD = Bx2_mean_T;
    %By2_mean_T_ABCD = By2_mean_T;
    Bz2_mean_T_ABCD = Bz2_mean_T;
    Bx2_max_T_ABCD = Bx2_max_T;
    By2_max_T_ABCD = By2_max_T;
    Bz2_max_T_ABCD = Bz2_max_T;
    A_max_min_To_ABCD = A_max_min_To;
    % %--------------------------------------------------------------------------


   % safe both B_components and A to use the later
    % %--------------------------------------------------------------------------
% %     cd(path_comp)
% %     save('Bfield_mean_max_A_comparison_EdBom_cp.mat',...
% %         'time_t_2','Bz2_mean_T',...
% %         'Bx2_max_T','By2_max_T','Bz2_max_T','B2_max_T','A_max_min_To', 'time_t_2_T')
    % %--------------------------------------------------------------------------
    path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison'; 
    cd(path_comp)
    load('Bfield_mean_max_A_comparison_EdBom_cp.mat')

    time_t_2_T_EdBom_cp = time_t_2_T;
    Bx2_mean_T_EdBom_cp = Bx2_mean_T;
    By2_mean_T_EdBom_cp = By2_mean_T;
    Bz2_mean_T_EdBom_cp = Bz2_mean_T;
    Bx2_max_T_EdBom_cp = Bx2_max_T;
    By2_max_T_EdBom_cp = By2_max_T;
    Bz2_max_T_EdBom_cp = Bz2_max_T;
    A_max_min_To_EdBom_cp = A_max_min_To;    

    
% %     % %--------------------------------------------------------------------------
% %     cd(path_comp)
% %     save('Bfield_mean_max_A_comparison_ABg02.mat',...
% %         'time_t_2','Bz2_mean_T',...
% %         'Bx2_max_T','By2_max_T','Bz2_max_T','B2_max_T','A_max_min_To','time_t_2_T')
% %     % %--------------------------------------------------------------------------
    path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';     
    cd(path_comp)
    load('Bfield_mean_max_A_comparison_ABg02.mat')
    time_t_2_T_ABg02 = time_t_2_T;
    Bx2_mean_T_ABg02 = Bx2_mean_T;
    By2_mean_T_ABg02 = By2_mean_T;
    Bz2_mean_T_ABg02 = Bz2_mean_T;
    Bx2_max_T_ABg02 = Bx2_max_T;
    By2_max_T_ABg02 = By2_max_T;
    Bz2_max_T_ABg02 = Bz2_max_T;
    A_max_min_To_ABg02 = A_max_min_To;


    % %--------------------------------------------------------------------------
% %     cd(path_comp)
% %     save('Bfield_mean_max_A_comparison_Omc1.mat',...
% %         'time_t_2','Bz2_mean_T',...
% %         'Bx2_max_T','By2_max_T','Bz2_max_T','B2_max_T','A_max_min_To','time_t_2_T')
% % % %--------------------------------------------------------------------------
    path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison'; 
    cd(path_comp)
    load('Bfield_mean_max_A_comparison_Omc1.mat')
    time_t_2_T_Omc1 = time_t_2_T;
    Bx2_mean_T_Omc1 = Bx2_mean_T;
    By2_mean_T_Omc1 = By2_mean_T;
    Bz2_mean_T_Omc1 = Bz2_mean_T;
    Bx2_max_T_Omc1 = Bx2_max_T;
    By2_max_T_Omc1 = By2_max_T;
    Bz2_max_T_Omc1 = Bz2_max_T;
    A_max_min_To_Omc1 = A_max_min_To;


    % %--------------------------------------------------------------------------
    cd(path_comp)
    save('Bfield_mean_max_A_comparison_dB01_Omc1.mat',...
        'time_t_2','Bz2_mean_T',...
        'Bx2_max_T','By2_max_T','Bz2_max_T','B2_max_T','A_max_min_To','time_t_2_T')
    % %--------------------------------------------------------------------------
    path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison'; 
    cd(path_comp)
    load('Bfield_mean_max_A_comparison_dB01_Omc1.mat')
    time_t_2_T_Omc1dB01 = time_t_2_T;
    Bx2_mean_T_Omc1dB01 = Bx2_mean_T;
    By2_mean_T_Omc1dB01 = By2_mean_T;
    Bz2_mean_T_Omc1dB01 = Bz2_mean_T;
    Bx2_max_T_Omc1dB01 = Bx2_max_T;
    By2_max_T_Omc1dB01 = By2_max_T;
    Bz2_max_T_Omc1dB01 = Bz2_max_T;
    A_max_min_To_Omc1dB01 = A_max_min_To;


    % %--------------------------------------------------------------------------
    cd(path_comp)
    save('Bfield_mean_max_A_comparison_Oc1kd1dB_2.mat',...
        'time_t_2','Bx2_mean_T','By2_mean_T','Bz2_mean_T','B2_mean_T',...
        'Bx2_max_T','By2_max_T','Bz2_max_T','B2_max_T','A_max_min_To','time_t_2_T')
    % %--------------------------------------------------------------------------

    path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison'; 
    cd(path_comp)
    load('Bfield_mean_max_A_comparison_Oc1kd1dB_2.mat')
    time_t_2_T_Oc1kd1dB = time_t_2_T;
    Bx2_mean_T_Oc1kd1dB = Bx2_mean_T;
    By2_mean_T_Oc1kd1dB = By2_mean_T;
    Bz2_mean_T_Oc1kd1dB = Bz2_mean_T;
    Bx2_max_T_Oc1kd1dB = Bx2_max_T;
    By2_max_T_Oc1kd1dB = By2_max_T;
    Bz2_max_T_Oc1kd1dB = Bz2_max_T;
    A_max_min_To_Oc1kd1dB = A_max_min_To;


    % %--------------------------------------------------------------------------
    cd(path_comp)
    save('Bfield_mean_max_A_comparison_Oc_op1d1_r1.mat',...
        'time_t_2','Bz2_mean_T',...
        'Bx2_max_T','By2_max_T','Bz2_max_T','B2_max_T','A_max_min_To','time_t_2_T')
    % %--------------------------------------------------------------------------

    path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison'; 
    cd(path_comp)
    load('Bfield_mean_max_A_comparison_Oc_op1d1_r1.mat')
    time_t_2_T_Oc_op1d1_r1 = time_t_2_T;
    Bz2_mean_T_Oc_op1d1_r1 = Bz2_mean_T;
    Bx2_max_T_Oc_op1d1_r1 = Bx2_max_T;
    By2_max_T_Oc_op1d1_r1 = By2_max_T;
    Bz2_max_T_Oc_op1d1_r1 = Bz2_max_T;
    A_max_min_To_Oc_op1d1_r1 = A_max_min_To;



% %     % safe the data so I don't have to run the same thing over and over again
% %     % %--------------------------------------------------------------------------
% %     cd(path_comp)
% %     save('Bfield_mean_max_comparison_4.mat',...
% %         'time_t_2','Bx2_mean_T','By2_mean_T','Bz2_mean_T','B2_mean_T',...
% %         'Bx2_max_T','By2_max_T','Bz2_max_T','B2_max_T')
% %     %----------------------------------------------------------------------
% % 
% % 
% %     % safe the data so I don't have to run the same thing over and over again
% %     % %--------------------------------------------------------------------------
% %     cd(path_comp)
% %     save('A_max_min_comparison_4.mat','A_max_min_To')
% %     %save('A_max_min_comparison_o.mat','A_max_min_To_o') % this is the one
% %     %that shows the initial fluctuattions don't change the reconnection
% %     %rate D and D*
% %     % %--------------------------------------------------------------------------


    %surf(Ax_y_bz0)% This returns a 3D plot that might be interesting
    %----------------------------------------------------------------------

    % Load the data to work with it after
    % %--------------------------------------------------------------------------
    %cd(path_comp)
    %load('Bfield_mean_max_comparison.mat')
    % %--------------------------------------------------------------------------
    %Warning: Variable 'Ax_y_T' was not saved. For variables larger than 2GB use MAT-file version 7.3 or later. 
    % %--------------------------------------------------------------------------
    %cd(path_comp)
    %load('Ax_comparison.mat')
    % %--------------------------------------------------------------------------



% %--------------------------------------------------------------------------
% %--------------------------------------------------------------------------



%Making plots
% %--------------------------------------------------------------------------
% %--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% For a single file at the time
%{
%--------------------------------------------------------------------------
% This is the plot of the reconnection rate

% To smooth the plot
%------------------------------------
windowSize=20;
b=(1/windowSize)*ones(1,windowSize);
a=1;
%------------------------------------

%--------------------------------------------------------------------------
fs=18; x0=45;y0=54;xx1=810;yy1=710;
f1=figure(1);
set(gcf,'position',[x0,y0,xx1,yy1])
%--------------------------------------------------------------------------
subplot(2,1,1)
y=A_max_min_To{1,1};
%y=A_max_min_To_o;
y = filter(b,a,y);
plot(time_t_2,y,LineWidth=2)
hold on
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\Delta \psi_{xo} = A_{x}|^{max}_{min} $'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{ce}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
%legend('\Delta=16d_{i}','latex','FontSize',1.0*fs,'Location','southeast','NumColumns',1)
legend('EdB01Omc1','latex','FontSize',1.0*fs,'Location','southeast','NumColumns',1)
hold off
subplot(2,1,2)
A_max_min_To1=A_max_min_To{1,1};
A_max_min_2 = A_max_min_To1(1,:); %<--- _o
A_max_min_2 = filter(b,a,A_max_min_2);
A_max_min_dt = (A_max_min_2(2:end) - A_max_min_2(1:end-1))./(time_t_2(2:end) - time_t_2(1:end-1));
y = A_max_min_dt./(B0*Va ); % now this is the normalization
plot(time_t_2(1:end-1),y,LineWidth=2)
hold on
%legend('\Delta=16d_{i}','latex','FontSize',1.0*fs,'Location','southeast','NumColumns',1)
legend('EdB01Omc1','latex','FontSize',1.0*fs,'Location','southeast','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\frac{\partial \Delta \psi_{xo}}{\partial t}\frac{1}{B_{0}V_{a}}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{ce}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
%ylim([0.5e-1 5e0]);
hold off

cd(path_comp)
saveas(f1,strcat(num2str(kn),'Reconnection_Rate_EdB01.png'));


% For the out of plane magnetic field
fs=18; x0=45;y0=54;xx1=810;yy1=710;
f2=figure(2);
set(gcf,'position',[x0,y0,1.3*xx1,yy1/2])
%--------------------------------------------------------------------------
subplot(1,2,1)
Bx2_max = Bx2_max_T(:,1);
    y = Bx2_max'./(B0^2);
    semilogy(time_t_2,y,LineWidth=2)
hold on
%legend('\Delta=16d_{i}','latex','FontSize',1.0*fs,'Location','southeast','NumColumns',1)
legend('EdB08','latex','FontSize',1.0*fs,'Location','southeast','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$B_{x,max}^{2}/B^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{ce}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([0.5e-3 5e0]);
hold off
%--------------------------------------------------------------------------
subplot(1,2,2)
By2_max = By2_max_T(:,1);
    y = By2_max'./(B0^2);
    semilogy(time_t_2,y,LineWidth=2)
hold on
%legend('\Delta=16d_{i}','latex','FontSize',1.0*fs,'Location','southeast','NumColumns',1)
legend('EdB08','latex','FontSize',1.0*fs,'Location','southeast','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$B_{y,max}^{2}/B^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{ce}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([0.5e-5 5e0]);
hold off
%--------------------------------------------------------------------------

cd(path_comp)
saveas(f2,strcat(num2str(kn),'BxBy_max_EdB08.png'));
% %--------------------------------------------------------------------------


f3=figure(3);
set(gcf,'position',[x0,y0,1.3*xx1,yy1/2])
%--------------------------------------------------------------------------
subplot(1,2,1)
Bz2_max = Bz2_max_T(:,1);
    y = Bz2_max'./(B0^2);
    semilogy(time_t_2,y,LineWidth=2)
hold on
%legend('\Delta=16d_{i}','latex','FontSize',1.0*fs,'Location','southeast','NumColumns',1)
legend('EdB08','latex','FontSize',1.0*fs,'Location','southeast','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$B_{z,max}^{2}/B^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{ce}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([0.5e-1 5e0]);
hold off
%--------------------------------------------------------------------------
subplot(1,2,2)
Bz2_max = Bz2_max_T(:,1) - B0^2;
    y = Bz2_max'./(B0^2);
    semilogy(time_t_2,y,LineWidth=2)
hold on
%legend('\Delta=16d_{i}','latex','FontSize',1.0*fs,'Location','southeast','NumColumns',1)
legend('EdB08','latex','FontSize',1.0*fs,'Location','southeast','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$(B_{z,max}^{2}-B_{0}^{2})/B^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{ce}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([0.5e-2 5e0]);
hold off
%--------------------------------------------------------------------------

cd(path_comp)
saveas(f3,strcat(num2str(kn),'BzBz_minus_max_EdB08.png'));
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%}
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% To compare several runs at the time
% This is the plot of the reconnection rate

%--------------------------------------------------------------------------
B0=0.2;
N_kn=4;

%Vai=0.2;Vae=0.2;
   
%--------------------------------------------------------------------------
% %Make one plot for a quantity comparing the different set ups B components 
%--------------------------------------------------------------------------
C = {'k','b','r','c','m',[.5 .6 .7],[.8 .2 .6],'y'} ;

% from  https://yoshke.org/blog/colorblind-friendly-diagrams
C = {[0/255, 0/255, 0/255],...
    [230/255, 159/255, 0/255],...
    [86/255, 180/255, 233/255],...
    [0/255, 158/255, 115/255],...
    [240/255, 228/255, 66/255],...
    [0/255, 114/255, 178/255],...
    [213/255, 94/255, 0/255],...
    [204/255, 121/255, 167/255]};

% from  https://personal.sron.nl/~pault/#sec:qualitative
C = {
    [204/255, 102/255, 119/255],... %rose
    [51/255, 34/255, 136/255],... % indigo
    [221/255, 204/255, 119/255],... %sand
    [17/255, 119/255, 51/255],... %green
    [136/255, 204/255, 238/255],... %cyan
    [136/255, 34/255, 85/255],... %wine
    [68/255, 170/255, 153/255],... %teal
    [170/255, 68/255, 153/255],... %purple
    [153/255, 153/255, 51/255],... %olive
    [221/255, 221/255, 221/255] %pale grey
    }; 

% % clearvars Bx2_max_T By2_max_T Bz2_max_T A_max_min_To time_t_2_T
% % clearvars Bx2_max By2_max Bz2_max time_t_2
% % clearvars B2_max B2_max_T B2_mean B2_mean_T 

time_t_2_T=time_t_2_T_ABCD; %<----
Bx2_max_T = Bx2_max_T_ABCD; 
By2_max_T = By2_max_T_ABCD;
Bz2_max_T = Bz2_max_T_ABCD;
A_max_min_To = A_max_min_To_ABCD;
Bz2_mean_T = Bz2_mean_T_ABCD;

% % time_t_2_T=time_t_2_T_EdBom_cp; %<----
% % Bx2_max_T = Bx2_max_T_EdBom_cp; 
% % By2_max_T = By2_max_T_EdBom_cp;
% % Bz2_max_T = Bz2_max_T_EdBom_cp;
% % A_max_min_To = A_max_min_To_EdBom_cp;

time_t_2_T=time_t_2_T_Oc1kd1dB; %<----
Bx2_max_T = Bx2_max_T_Oc1kd1dB; 
By2_max_T = By2_max_T_Oc1kd1dB;
Bz2_max_T = Bz2_max_T_Oc1kd1dB;
A_max_min_To = A_max_min_To_Oc1kd1dB;
Bz2_mean_T = Bz2_mean_T_Oc1kd1dB;


legends_comp={'A','B','C','D'};

%legends_comp={'A','B','C','D','E','ABg02'};

%legends_comp={'A','B','C','D','E','ABg02','EOmc1','EOmc1dB01'};

legends_comp={'Oc1dB01','Oc1dB08','Oc1dkd1B01','Oc1dkd1B08'};

% For the out of plane magnetic field
fs=18; x0=45;y0=54;xx1=810;yy1=710;
f2=figure(2);
set(gcf,'position',[x0,y0,1.3*xx1,yy1/2])
%--------------------------------------------------------------------------
subplot(1,2,1)
Bx2_max = Bx2_max_T{1}; time_t_2 = time_t_2_T{1};
y = Bx2_max'./(B0^2);
semilogy(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:N_kn
    Bx2_max = Bx2_max_T{kn};   time_t_2 = time_t_2_T{kn};
    y = Bx2_max'./(B0^2);
    semilogy(time_t_2,y,LineWidth=2,color=C{kn})
end
%--------------------------------------------------------------------------
% % Bx2_max = Bx2_max_T_EdBom_cp{1}; time_t_2 = time_t_2_T_EdBom_cp{1};
% % y = Bx2_max'./(B0^2);
% % semilogy(time_t_2,y,LineWidth=2,color=C{5})
% % 
% % Bx2_max = Bx2_max_T_ABg02{1}; time_t_2 = time_t_2_T_ABg02{1};
% % y = Bx2_max'./(B0^2);
% % semilogy(time_t_2,y,LineWidth=2,color=C{6})
% % 
% % Bx2_max = Bx2_max_T_Omc1{1}; time_t_2 = time_t_2_T_Omc1{1};
% % y = Bx2_max'./(B0^2);
% % semilogy(time_t_2,y,LineWidth=2,color=C{7})
% % 
% % Bx2_max = Bx2_max_T_Omc1dB01{1}; time_t_2 = time_t_2_T_Omc1dB01{1};
% % y = Bx2_max'./(B0^2);
% % semilogy(time_t_2,y,LineWidth=2,color=C{8})
% % %--------------------------------------------------------------------------
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeast','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$B_{x,max}^{2}/B^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{ce}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([1e-2 1e1]);
xlim([0 350]);
hold off
%--------------------------------------------------------------------------
subplot(1,2,2)
By2_max = By2_max_T{1}; time_t_2 = time_t_2_T{1};
    y = By2_max'./(B0^2);
    semilogy(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:N_kn
    By2_max = By2_max_T{kn}; time_t_2 = time_t_2_T{kn};
    y = By2_max'./(B0^2);
    semilogy(time_t_2,y,LineWidth=2,color=C{kn})
end
%--------------------------------------------------------------------------
% % By2_max = By2_max_T_EdBom_cp{1}; time_t_2 = time_t_2_T_EdBom_cp{1};
% % y = By2_max'./(B0^2);
% % semilogy(time_t_2,y,LineWidth=2,color=C{5})
% % 
% % By2_max = By2_max_T_ABg02{1}; time_t_2 = time_t_2_T_ABg02{1};
% % y = By2_max'./(B0^2);
% % semilogy(time_t_2,y,LineWidth=2,color=C{6})
% % 
% % By2_max = By2_max_T_Omc1{1}; time_t_2 = time_t_2_T_Omc1{1};
% % y = By2_max'./(B0^2);
% % semilogy(time_t_2,y,LineWidth=2,color=C{7})
% % 
% % By2_max = By2_max_T_Omc1dB01{1}; time_t_2 = time_t_2_T_Omc1dB01{1};
% % y = By2_max'./(B0^2);
% % semilogy(time_t_2,y,LineWidth=2,color=C{8})
% % %--------------------------------------------------------------------------
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeast','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$B_{y,max}^{2}/B^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{ce}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([1e-5 1e2]);
xlim([0 350]);
hold off
%--------------------------------------------------------------------------

 cd(path_comp)
 %saveas(f2,strcat(num2str(kn),'BxBy_max_ABCD.png'));
 %saveas(f2,strcat(num2str(kn),'BxBy_max_ABCDEABg02.png'));
 %saveas(f2,strcat(num2str(kn),'BxBy_max_ABCDEABg02dB01_kd1.png'));
 saveas(f2,strcat(num2str(kn),'BxBy_max_Bg02dB01_Ocopkdr1.png'));
 %saveas(f2,strcat(num2str(kn),'BxBy_max_EdBom_cp.png'));
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
f3=figure(3);
set(gcf,'position',[x0,y0,1.3*xx1,yy1/2])
%--------------------------------------------------------------------------
subplot(1,2,1)
Bz2_max = Bz2_max_T{1}; time_t_2 = time_t_2_T{1};
    y = Bz2_max'./(B0^2);
    semilogy(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:N_kn
    Bz2_max = Bz2_max_T{kn}; time_t_2 = time_t_2_T{kn};
    y = Bz2_max'./(B0^2);
    semilogy(time_t_2,y,LineWidth=2,color=C{kn})
end
% % %--------------------------------------------------------------------------
% % Bz2_max = Bz2_max_T_EdBom_cp{1}; time_t_2 = time_t_2_T_EdBom_cp{1};
% % y = Bz2_max'./(B0^2);
% % semilogy(time_t_2,y,LineWidth=2,color=C{5})
% % 
% % Bz2_max = Bz2_max_T_ABg02{1}; time_t_2 = time_t_2_T_ABg02{1};
% % y = Bz2_max'./(B0^2);
% % semilogy(time_t_2,y,LineWidth=2,color=C{6})
% % 
% % Bz2_max = Bz2_max_T_Omc1{1}; time_t_2 = time_t_2_T_Omc1{1};
% % y = Bz2_max'./(B0^2);
% % semilogy(time_t_2,y,LineWidth=2,color=C{7})
% % 
% % Bz2_max = Bz2_max_T_Omc1dB01{1}; time_t_2 = time_t_2_T_Omc1dB01{1};
% % y = Bz2_max'./(B0^2);
% % semilogy(time_t_2,y,LineWidth=2,color=C{8})
% % %--------------------------------------------------------------------------
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeast','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$B_{z,max}^{2}/B^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{ce}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([1e-1 0.5e2]);
xlim([0 350]);
hold off
%--------------------------------------------------------------------------
subplot(1,2,2)
Bz2_max = Bz2_max_T{1} - B0^2; time_t_2 = time_t_2_T{1};
    y = Bz2_max'./(B0^2);
    semilogy(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:N_kn
    Bz2_max = Bz2_max_T{kn} - B0^2; time_t_2 = time_t_2_T{kn};
    y = Bz2_max'./(B0^2);
    semilogy(time_t_2,y,LineWidth=2,color=C{kn})
end
% % %--------------------------------------------------------------------------
% % Bz2_max = Bz2_max_T_EdBom_cp{1} - B0^2; time_t_2 = time_t_2_T_EdBom_cp{1};
% % y = Bz2_max'./(B0^2);
% % semilogy(time_t_2,y,LineWidth=2,color=C{5})
% % 
% % Bz2_max = Bz2_max_T_ABg02{1} - B0^2; time_t_2 = time_t_2_T_ABg02{1};
% % y = Bz2_max'./(B0^2);
% % semilogy(time_t_2,y,LineWidth=2,color=C{6})
% % 
% % Bz2_max = Bz2_max_T_Omc1{1} - B0^2; time_t_2 = time_t_2_T_Omc1{1};
% % y = Bz2_max'./(B0^2);
% % semilogy(time_t_2,y,LineWidth=2,color=C{7})
% % 
% % Bz2_max = Bz2_max_T_Omc1dB01{1} - B0^2; time_t_2 = time_t_2_T_Omc1dB01{1};
% % y = Bz2_max'./(B0^2);
% % semilogy(time_t_2,y,LineWidth=2,color=C{8})
% % %--------------------------------------------------------------------------
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','southeast','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$(B_{z,max}^{2}-B_{0}^{2})/B^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{ce}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([1e-2 1e2]);
xlim([0 350]);
hold off
%--------------------------------------------------------------------------
 cd(path_comp)
 %saveas(f3,strcat(num2str(kn),'BzBz_minus_max_ABCD.png'));
 %saveas(f3,strcat(num2str(kn),'BzBz_minus_max_ABCDEABg02_2.png'));
 %saveas(f3,strcat(num2str(kn),'BzBz_minus_max_ABCDEABg02dB01_kd1.png'));
 saveas(f3,strcat(num2str(kn),'BzBz_minus_max_Bg02dB01_Ocop_kdr1.png'));
 %saveas(f3,strcat(num2str(kn),'BzBz_minus_max_EdBom_cp.png'));

%--------------------------------------------------------------------------


% To smooth the plot
%--------------------------------------------------------------------------
windowSize=1;
b=(1/windowSize)*ones(1,windowSize);
a=1;
%--------------------------------------------------------------------------
% Magnetic flux alone
fs=18; x0=45;y0=54;xx1=810;yy1=400;
f12=figure(12);
set(gcf,'position',[x0,y0,xx1,yy1])
%--------------------------------------------------------------------------
subplot(1,1,1)
%y=A_max_min_To_o;
y=A_max_min_To{1}; time_t_2 = time_t_2_T{1};
y = filter(b,a,y);
plot(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:N_kn
    y = A_max_min_To{kn}; time_t_2 = time_t_2_T{kn};
    y = filter(b,a,y);
    plot(time_t_2,y,LineWidth=2,color=C{kn})
end
% % %--------------------------------------------------------------------------
% % y=A_max_min_To_EdBom_cp{1}; time_t_2 = time_t_2_T_EdBom_cp{1}; y = filter(b,a,y);
% % plot(time_t_2,y,LineWidth=2,color=C{5})
% % 
% % y=A_max_min_To_ABg02{1}; time_t_2 = time_t_2_T_ABg02{1}; y = filter(b,a,y);
% % plot(time_t_2,y,LineWidth=2,color=C{6})
% % 
% % y=A_max_min_To_Omc1{1}; time_t_2 = time_t_2_T_Omc1{1}; y = filter(b,a,y);
% % plot(time_t_2,y,LineWidth=2,color=C{7})
% % 
% % y=A_max_min_To_Omc1dB01{1}; time_t_2 = time_t_2_T_Omc1dB01{1}; y = filter(b,a,y);
% % plot(time_t_2,y,LineWidth=2,color=C{8})
% % %--------------------------------------------------------------------------
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','northwest','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\Delta \psi_{xo} = A_{x}|^{max}_{min} $'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{ce}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
%ylim([0.0 2.5]);
xlim([0 350]);
hold off

cd(path_comp)
%saveas(f12,strcat(num2str(kn),'Reconnected_flux_comp_ABCDEABg02_nofilter.png'));
%saveas(f12,strcat(num2str(kn),'Reconnected_flux_comp_ABCDEABg02_Omc1dB01_kd1_nofilter.png'));
saveas(f12,strcat(num2str(kn),'Reconnected_flux_comp_Bg02_Ocop1dB01_kdr1_nofilter.png'));


Vae=0.2;
%--------------------------------------------------------------------------
windowSize=20;
b=(1/windowSize)*ones(1,windowSize);
a=1;
%--------------------------------------------------------------------------
% Magnetic flux and reconnection rate
%--------------------------------------------------------------------------
fs=18; x0=45;y0=54;xx1=810;yy1=710;
f1=figure(1);
set(gcf,'position',[x0,y0,xx1,yy1])
%--------------------------------------------------------------------------
subplot(2,1,1)
%y=A_max_min_To_o;
y=A_max_min_To{1}; time_t_2 = time_t_2_T{1};
y = filter(b,a,y);
plot(time_t_2,y,LineWidth=2,color=C{1})
hold on
for kn=2:N_kn
    y = A_max_min_To{kn}; time_t_2 = time_t_2_T{kn};
    y = filter(b,a,y);
    plot(time_t_2,y,LineWidth=2,color=C{kn})
end
% % %--------------------------------------------------------------------------
% % y=A_max_min_To_EdBom_cp{1}; time_t_2 = time_t_2_T_EdBom_cp{1}; y = filter(b,a,y);
% % plot(time_t_2,y,LineWidth=2,color=C{5})
% % 
% % y=A_max_min_To_ABg02{1}; time_t_2 = time_t_2_T_ABg02{1}; y = filter(b,a,y);
% % plot(time_t_2,y,LineWidth=2,color=C{6})
% % 
% % y=A_max_min_To_Omc1{1}; time_t_2 = time_t_2_T_Omc1{1}; y = filter(b,a,y);
% % plot(time_t_2,y,LineWidth=2,color=C{7})
% % 
% % y=A_max_min_To_Omc1dB01{1}; time_t_2 = time_t_2_T_Omc1dB01{1}; y = filter(b,a,y);
% % plot(time_t_2,y,LineWidth=2,color=C{8})
% % %--------------------------------------------------------------------------
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','northwest','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\Delta \psi_{xo} = A_{x}|^{max}_{min} $'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{ce}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
%ylim([0.0 3.5]);
xlim([0 350]);
hold off

%--------------------------------------------------------------------------
subplot(2,1,2)
A_max_min_2 = A_max_min_To{1}; time_t_2 = time_t_2_T{1};
A_max_min_2 = filter(b,a,A_max_min_2);
%A_max_min_dt = (A_max_min_2(3:end) - A_max_min_2(1:end-2))./1.*((time_t_2(3:end) - time_t_2(1:end-2)));
delta_t=time_t_2(2)-time_t_2(1);
A_max_min_dt = (A_max_min_2(3:end) - A_max_min_2(1:end-2))./2.*(delta_t);

%nb_n0 =0.1; Vae_b=Vae/sqrt(nb_n0);
nb_n0 =0.2; Vae_b=Vae/sqrt(nb_n0); %for the cyclotron runs

%normi = Bz2_mean_T{1}./sqrt(nb_n0);
normi = B0*Vae_b*ones(1,length(A_max_min_dt) + 2);

y = A_max_min_dt./(normi(1:end-2)); % now this is the normalization
y = filter(b,a,y);

%plot(time_t_2(2:end-1),y,LineWidth=2,color=C{1})

yline(mean(y),color=C{1});
hold on
for kn=2:N_kn
    %A_max_min_2 = A_max_min_To(:,kn)'; %<--- _o
    A_max_min_2 = A_max_min_To{kn}; time_t_2 = time_t_2_T{kn};
    A_max_min_2 = filter(b,a,A_max_min_2);

    %A_max_min_dt = (A_max_min_2(3:end) - A_max_min_2(1:end-2))./(1.*(time_t_2(3:end) - time_t_2(1:end-2)));
    delta_t=time_t_2(2)-time_t_2(1);
    A_max_min_dt = (A_max_min_2(3:end) - A_max_min_2(1:end-2))./2.*(delta_t);

    %normi = Bz2_mean_T{kn}./sqrt(nb_n0);
    normi = B0*Vae_b*ones(1,length(A_max_min_dt) + 2);

    %y = A_max_min_dt./(B0*Vae_b ); % now this is the normalization
    y = A_max_min_dt./(normi(1:end-2));
    y = filter(b,a,y);
    %plot(time_t_2(1:end-1),y,LineWidth=2)
    %%plot(time_t_2(2:end-1),y,LineWidth=2,color=C{kn})
    yline(mean(y),color=C{kn});
end
% % %--------------------------------------------------------------------------
% % nb_n0 =0.2; Vae_b=Vae/sqrt(nb_n0);
% % A_max_min_2 = A_max_min_To_EdBom_cp{1}; time_t_2 = time_t_2_T_EdBom_cp{1};
% % A_max_min_2 = filter(b,a,A_max_min_2); delta_t=time_t_2(2)-time_t_2(1);
% % A_max_min_dt = (A_max_min_2(3:end) - A_max_min_2(1:end-2))./2.*(delta_t);
% % y = A_max_min_dt./(B0*Vae_b ); % now this is the normalization
% % y = filter(b,a,y);
% % plot(time_t_2(2:end-1),y,LineWidth=2,color=C{5})
% % 
% % nb_n0 =0.1; Vae_b=Vae/sqrt(nb_n0);
% % A_max_min_2 = A_max_min_To_ABg02{1}; time_t_2 = time_t_2_T_ABg02{1};
% % A_max_min_2 = filter(b,a,A_max_min_2); delta_t=time_t_2(2)-time_t_2(1);
% % A_max_min_dt = (A_max_min_2(3:end) - A_max_min_2(1:end-2))./2.*(delta_t);
% % y = A_max_min_dt./(B0*Vae_b ); % now this is the normalization
% % y = filter(b,a,y);
% % plot(time_t_2(2:end-1),y,LineWidth=2,color=C{6})
% % 
% % nb_n0 =0.2; Vae_b=Vae/sqrt(nb_n0);
% % A_max_min_2 = A_max_min_To_Omc1{1}; time_t_2 = time_t_2_T_Omc1{1};
% % A_max_min_2 = filter(b,a,A_max_min_2); delta_t=time_t_2(2)-time_t_2(1);
% % A_max_min_dt = (A_max_min_2(3:end) - A_max_min_2(1:end-2))./2.*(delta_t);
% % y = A_max_min_dt./(B0*Vae_b ); % now this is the normalization
% % y = filter(b,a,y);
% % plot(time_t_2(2:end-1),y,LineWidth=2,color=C{7})
% % 
% % nb_n0 =0.2; Vae_b=Vae/sqrt(nb_n0);
% % A_max_min_2 = A_max_min_To_Omc1dB01{1}; time_t_2 = time_t_2_T_Omc1dB01{1};
% % A_max_min_2 = filter(b,a,A_max_min_2); delta_t=time_t_2(2)-time_t_2(1);
% % A_max_min_dt = (A_max_min_2(3:end) - A_max_min_2(1:end-2))./2.*(delta_t);
% % y = A_max_min_dt./(B0*Vae_b ); % now this is the normalization
% % y = filter(b,a,y);
% % plot(time_t_2(2:end-1),y,LineWidth=2,color=C{8})
% % 
% % %--------------------------------------------------------------------------
legend(legends_comp,'Interpreter','latex','FontSize',1.0*fs,'Location','northwest','NumColumns',1)
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$\frac{\partial \Delta \psi_{xo}}{\partial t}\frac{1}{B_{0}V_{a}}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$t / \Omega_{ce}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
ylim([-0.1 0.9]);
xlim([0 350]);
hold off

 cd(path_comp)
 saveas(f1,strcat(num2str(kn),'Reconnection_Rate_comp_ABCD.png'));
 %saveas(f1,strcat(num2str(kn),'Reconnection_Rate_comp_ABCDEABg02_2.png'));
 %saveas(f1,strcat(num2str(kn),'Reconnection_Rate_comp_ABCDEABg02_Omc1dB01_kd1.png'));
 saveas(f1,strcat(num2str(kn),'Reconnection_Rate_comp_Bg01_Ocop1dB01_kdr1.png'));
 %saveas(f1,strcat(num2str(kn),'Reconnection_Rate_comp_EdBom_cp.png'));
%--------------------------------------------------------------------------


% Computing the average values to 


%}
% %--------------------------------------------------------------------------
% %--------------------------------------------------------------------------



% Now the other quantities that I am gonna use to compare.

% % %--------------------------------------------------------------------------
% % %--------------------------------------------------------------------------
Ex_rec_avg=zeros(1,N_jn);

Bx_y0_i = zeros(LZs,N_jn);
By_y0_i = zeros(LZs,N_jn);
Bz_y0_i = zeros(LZs,N_jn);
% % %--------------------------------------------------------------------------

% % %--------------------------------------------------------------------------
% % %--------------------------------------------------------------------------
jn=N;
in=jn;
% % %--------------------------------------------------------------------------
% % %--------------------------------------------------------------------------

% % % %Make independent plots for each set up
% % % %--------------------------------------------------------------------------
% % for kn=1:5
% %     % select the data once loaded
% %     Bx2_mean = Bx2_mean_T(:,kn);
% %     By2_mean = By2_mean_T(:,kn);
% %     Bz2_mean = Bz2_mean_T(:,kn);
% %     B2_mean = B2_mean_T(:,kn);
% % 
% %     Bx2_max = Bx2_max_T(:,kn);
% %     By2_max = By2_max_T(:,kn);
% %     Bz2_max = Bz2_max_T(:,kn);
% %     B2_max = B2_max_T(:,kn);
% % 
% %     % Make the plot
% %     cd(path_s2)
% %     %----------------------------------------------------------------------
% %     fs=18; x0=45;y0=54;xx1=810;yy1=710;
% %     %----------------------------------------------------------------------
% %     f1=figure(1);
% %     set(gcf,'position',[x0,y0,xx1,yy1])
% %     %--------------------------------------------------------------------------
% %     subplot(2,1,1)
% %     y = Bx2_mean'./(B0^2);
% %     semilogy(time_t_2,y,'r',LineWidth=2)
% %     hold on
% %     y = By2_mean'./(B0^2);
% %     semilogy(time_t_2,y,'b',LineWidth=2)
% %     y = Bz2_mean'./(B0^2);
% %     semilogy(time_t_2,y,'c',LineWidth=2)
% %     y = B2_mean'./(B0^2);
% %     semilogy(time_t_2,y,'k',LineWidth=2)
% %     legend('$B_{x}^{2}$','$B_{y}^{2}$','$B_{z}^{2}$','$|B|^{2}$','Interpreter','latex','FontSize',1.0*fs,'Location','northwest','NumColumns',3);
% %     ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% %     ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
% %     ax.YLabel.String = '$\langle B_{i}^{2} \rangle/B^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
% %     ax.XLabel.String = '$t / \Omega_{ce}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
% %     ylim([1e-6 1e1]);
% %     hold off
% %     %--------------------------------------------------------------------------
% %     subplot(2,1,2)
% %     y = Bx2_max'./(B0^2);
% %     semilogy(time_t_2,y,'r',LineWidth=2)
% %     hold on
% %     y = By2_max'./(B0^2);
% %     semilogy(time_t_2,y,'b',LineWidth=2)
% %     y = Bz2_max'./(B0^2);
% %     semilogy(time_t_2,y,'c',LineWidth=2)
% %     y = B2_max'./(B0^2);
% %     semilogy(time_t_2,y,'k',LineWidth=2)
% %     legend('$B_{x}^{2}$','$B_{y}^{2}$','$B_{z}^{2}$','$|B|^{2}$','Interpreter','latex','FontSize',1.0*fs,'Location','northwest','NumColumns',3)
% %     ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% %     ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
% %     ax.YLabel.String = '$B_{i,max}^{2}/B^{2}_{0}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
% %     ax.XLabel.String = '$t / \Omega_{ce}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
% %     ylim([1e-4 1e1]);
% %     hold off
% %     %--------------------------------------------------------------------------
% % 
% %     %save the plot
% %     %--------------------------------------------------------------------------
% %     cd(path_comp)
% %     saveas(f1,strcat(num2str(kn),'Bi_mean_mag.png'));
% %     %--------------------------------------------------------------------------
% % end


x=linspace(0,1,100);
y= 0.1*x;
y1= 0.4*x;
y2= 0.8*x;
f1=figure(1);
semilogy(x,y)
hold on
semilogy(x,y1)
semilogy(x,y2)
legend('y=0.1x','y=0.4x', 'y=0.8x')
hold off
