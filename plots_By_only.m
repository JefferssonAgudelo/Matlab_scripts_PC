%for d=1
    % % % %With the guide field and 4di thickness
    % % %
    % % % path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_alone_large';%A
    % % % path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_alone_large_2';%A
    % % % %path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large';%B
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_Ax_large';%C
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large';%D
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini_L8di_8_dum';%E
    % % %
    % % %
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_8';
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini';
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini_L8di_8';
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large_L8di';
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_Ax_large_noini_L8di';
    % % %
    % % %
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_dummy_pinch';
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_dummy_slow_fre';
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_dummy_high_fre';
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_dummy_high_fre_long';
    % % %
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_dummy_deb';
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_dummy_2';
    % % %
    % % %
    % % %
    % % %
    % % % % This set shows the difference in terms of the onset.
    % % % %----------------------------------------------------------------------------------------------------------------------
    path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_alone_large'; %A
    % % % path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large'; %B
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_Ax_large';%C
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large';%D
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini_L8di_8_du02';%E %<-- this is in reality L=4.
    % % % %-----------------------------------------------------------------------------------------------------------------------
    % % %
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_Bg01'
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large_Bg02';
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_Bg01_below';
    % % %
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_Bg01_below';
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08';
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_ome01_cp';
    % % %
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1';
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_Omc1';
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kd1';
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_Omc1_kd1';
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB04_Omc1_kd1';
    % % %
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kLd1';
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kLr1';
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_omp1_kLd1';
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_omp1_kLr1';
    % % %
    % % %
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_omp1_kLr1';
    % % %
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kLr1_res';
    % % %
    % % %
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_3_time';
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_3_adios2';
    % % %
    % % %
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_cpinch_sSR';
    % % %
    % % %
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_cpinch_sSR_lange';
    % % %
    % % %
    % % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kLd1';
    % % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kLr1';
    % % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_omp1_kLd1';
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_omp1_kLr1';
    % % %
    % % %
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large';
    % % %
    % % %
    % % %
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB001_omp1_kLd1';
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large';
    % % % %path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_alone_large';%A
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_noini_L8di_8_du02';%E %<-- this is in reality L=4.
    % % %
    % % % %--------------------------------------------------------------------------
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_omp1_klong/psc_harris_yz_lange_many_Ax_large_L4di_dB01_omp1_klong';
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_olong_kLd1/psc_harris_yz_lange_many_Ax_large_L4di_dB01_olong_kLd1';
    % % % %--------------------------------------------------------------------------
    % % %
    % % % %--------------------------------------------------------------------------
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_cpinch_sSR/particle_late';
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_cpinch_sSR_lange/particle_late';
    % % % path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
    % % % %--------------------------------------------------------------------------
    % % %
    % % %
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_Omc1';
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_ome01_cp';
    % % % % This is the localised region for the anomalous resistivity
    % % % %--------------------------------------------------------------------------
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kLd1_local';
    % % % %--------------------------------------------------------------------------
    % % %
    % % % % check what is actually this because is really messy
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB04_Omc1_kd1';
    % % %
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_ome01';
    % % %
    % % % % These are the paths for the runs to compare
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kd1';
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_Omc1_kd1';
    % % %
    % % %
    % % %
    % % % %--------------------------------------------------------------------------
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB02_olong_kLd2';
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB04_olong_kLd4';
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_olong_kLd8';
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB08_olong_kLd16';
    % % % %--------------------------------------------------------------------------
    % % %
    % % %
    % % %
    % % %
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L8di_dB01_Omc1_kLd1_local_2';
    % % %
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L8di_dB01_Omc1_kLd1_local_3';
    % % %
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB02_olong_kLd2';
    % % %
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_olong_kLd1_mime25';
    % % %
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_cpinch_sSR_mime25';
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_olong_kLd1_mime25';
    % % %
    % % %
    % % %
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB02_olong_kLd2';
    % % % %path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB01_Omc1_kLd1';
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_cpinch_sSR_prt';
    % % %
    % % %
    % % % path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_2_alone_large_ppc1000';
    % % %
    % % % path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_many_Ax_large_L8di_dB01_Omc1_kLd1_local_3';
    % % %
    % % % %path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_many_Ax_large_L8di_dB01_Omc1_kLd1_local_mime25';
    % % %
    % % % %path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_many_Ax_large_L8di_dB01_Omc1_kLd1_local_off';
    % % %
    % % % %path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_many_Ax_large_L8di_dB01_Omc1_kLrho1_local_mime25';
    % % %
    % % %
    % % % path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_3';
    % % %
    % % % path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_many_Ax_large_L8di_dB01_Omc1_kLd1_local_3_conf2';
    % % %
    % % % path = '/Users/jeffersson_agudelo/Documents/New_psc/second_try_version/build_2/testing_jeff/psc_harris_yz_base_2_alone_large';
    % % %
    % % %
    % % % path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_many_Ax_large_L8di_dB01_Omc1_kLd1_local_3_conf3';
    % % % %--------------------------------------------------------------------------
%%%end
%%%


%--------------------------------------------------------------------------
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_many_Ax_large_L10di/';
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_many_Ax_large_L10di_CP/';
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_many_Ax_large_L10di_lange_local/';

%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_many_Ax_large_L8di_lange_local_asi/';
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_many_Ax_large_L6di_lange_local/';
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_many_Ax_large_L4di_lange_local/';

%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_many_Ax_large_L8di_lange_local_asi';
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_short_L1di';
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_Tba_perpar_short_L1di';
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_short_L1di';
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_Tba_perpar_short_L4di';
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_short_L4di';

%%%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_pinch_short_L4di';
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_short_L4di';
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_lange_short_L4di_dB03';
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_Tba_perpar_short_L4di'
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_many_Ax_large_L8di_lange_local/';
%path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_base_many_Ax_large_L8di_lange_local_asi/';
%--------------------------------------------------------------------------


%path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_many_Ax_large_L4di_dB02';


%--------------------------------------------------------------------------
path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
%--------------------------------------------------------------------------

% To save the plots
path_rec_r = strcat(path,'/spectra/rec_r');
path_rec_line = strcat(path,'/spectra/rec_line');
path_rec_line_ByBzJx_zoom = strcat(path,'/spectra/rec_line/ByBzJx_zoom');
if not(isfolder(path_rec_r))
    mkdir(path_rec_r)
end
if not(isfolder(path_rec_line))
    mkdir(path_rec_line)
end
if not(isfolder(path_rec_line_ByBzJx_zoom))
    mkdir(path_rec_line_ByBzJx_zoom)
end
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
%in=10;
%--------------------------------------------------------------------------
% Change this accordingly
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
%E = vB, as B0=0.1 and v in units of c, E0= B0*Vai/c
E0=0.2;%0.2; %??
%T=(beta/2)B^2, Thus, as beta=1
T0=0.02;%0.02;
%The current density J0=1?
J0=Vae;
mime =1.;
omega_pe_Omega_ce=5;
MFT0=1; % is this simply one in this normalization
nb_n0 =0.1;
Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);
%Normalising only when making plots
c=1; VA2c = 0.2;
%B0 = VA2c; E0 = B0*VA2c;
%Pi0 = mi*VA2c*VA2c; Pe0 = me*VA2c*VA2c;
%DeltaEpsilon0=VA2c*Pi0;
%DeltaEpsilon0=Pi0;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
nb_n0 =0.1;
Vai_b=Vai/sqrt(nb_n0);
Vae_b=Vae/sqrt(nb_n0);
%Normalising only when making plots
%c=1; VA2c = 0.2;
%B0 = VA2c; E0 = B0*VA2c;
%Pi0 = mi*VA2c*VA2c; Pe0 = me*VA2c*VA2c;
%DeltaEpsilon0=VA2c*Pi0;
%DeltaEpsilon0=Pi0;
%--------------------------------------------------------------------------
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
%--------------------------------------------------------------------------
in=1;
%in=N;
fileID =  S(in).name; %change the 1 per i
%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;
B=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
ss=size(B);
LZs=ss(3);
clearvars B

%in=jn;

N_jn=N; %This is to store some but not all the time steps
%N=61;N_jn=61; &lt;------------------------------- this is for the 3000


time_t_2=zeros(1,N_jn);

% Ex_rec_avg=zeros(1,N_jn);
Bx_y0_i = zeros(LZs,N_jn);
By_y0_i = zeros(LZs,N_jn);
Bz_y0_i = zeros(LZs,N_jn);
% % %--------------------------------------------------------------------------
% % %--------------------------------------------------------------------------
%N =183 is the limit for the run to keep the same time steps.
jn=220;
jn=N;

jn=10;

jn=1;
in=1;


jn=N-1;
in=N-1;

jn=11;
in=11;


%jn=135; %135 is the file number for 174.95


%jn=N-1; % for dB2kd2
%jn=N; % for prt central pinch

%--------------------------------------------------------------------------
%jn = 126 % this is the 25000 for the local_3 time 326 Omega
%jn = 176 % this is the 35000 for the local_3 time 456 Omega
%--------------------------------------------------------------------------

for jn=1:N
    in=jn;
%for jn=2:N%floor(N/20)
    %in=(jn-1)*jn;
    %in=2 + floor(N*(jn-1)/20);
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
    %----------------------------------------------------------------------
    %disp(strcat('Computing step ...',S2(in).name))
    %     fileID2 =  S2(in).name; %change the 1 per i
    %     %h5disp(fileID2);
    %     info2 = h5info(fileID2);
    %     moments_1st = info2.Groups(1).Name;
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    % 'rho_e_UP' 'jx_e_UP' 'jy_e_UP' 'jz_e_UP' 'px_e_UP' 'py_e_UP'
    % 'pz_e_UP' 'txx_e_UP' 'tyy_e_UP' 'tzz_e_UP' 'txy_e_UP' 'tyz_e_UP'
    % 'tzx_e_UP' 'rho_i_UP' 'jx_i_UP' 'jy_i_UP' 'jz_i_UP' 'px_i_UP'
    % 'py_i_UP' 'pz_i_UP' 'txx_i_UP' 'tyy_i_UP' 'tzz_i_UP' 'txy_i_UP'
    % 'tyz_i_UP' 'tzx_i_UP'
    %----------------------------------------------------------------------
    % B{1,1}=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    B{1,2}=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
    % B{1,3}=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));
    % E{1,1}=h5read(fileID,strcat(EHJ_1st,'/ex_ec/p0/3d'));
    % E{1,2}=h5read(fileID,strcat(EHJ_1st,'/ey_ec/p0/3d'));
    % E{1,3}=h5read(fileID,strcat(EHJ_1st,'/ez_ec/p0/3d'));
    % % %
    % J{1,1}=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'));
%     J{1,2}=h5read(fileID,strcat(EHJ_1st,'/jy_ec/p0/3d'));
%     J{1,3}=h5read(fileID,strcat(EHJ_1st,'/jz_ec/p0/3d'));
    %From 3D to 2D (x,y,z) to (y,z)
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    % computing magnetic flux velocity
    %----------------------------------------------------------------------
    %Bp=sqrt(B{1,2}.^2 + B{1,3}.^2);
    %by=B{1,2}./Bp;
    %bz=B{1,3}./Bp;
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    % slice in x
    By2 = B{1,2};
    ssz=size(By2);
    sli_x = 1; % this value has to change to reconstruct the vector potential
    sli_y = floor(4+ssz(2)/2);%380;
    sli_z = floor(2+ssz(3)/2);%700;
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    %Bp=squeeze(Bp(sli_x,:,:));
    % computing the electric field terms
    %----------------------------------------------------------------------
    By = B{1,2}; By = squeeze(By(sli_x,:,:));
    %----------------------------------------------------------------------
    sss=size(By);
    size_X=sss;
    zll=linspace(-Lz,Lz,size_X(2)); %Jeff flag it works with (1,size_x(2))
    yll=linspace(-Ly,Ly,size_X(1));
    [ZLL, YLL] = meshgrid(zll,yll);
    %----------------------------------------------------------------------

    %--------------------------------------------------------------------------
    str = string(S(in).name);
    newStr = extractBetween(str,"pfd.","_p000000.h5");
    N_steps = str2double(newStr);
    time_t = dt*N_steps;
    time_t_2_Omega=time_t./omega_pe_Omega_ce;
    time_t_2(1,in)=time_t_2_Omega;
    %disp(time_t_2_Omega)
    yticks_mine=[floor(-Ly*0.9) floor(-Ly/2) 0 floor(Ly/2) floor(Ly*0.9)];
    zticks_mine=[floor(-Lz*0.9) floor(-Lz/2) 0 floor(Lz/2) floor(Lz*0.9)];
    %----------------------------------------------------------------------

    cd(path)
    By_y0_i(:,jn) = By(length(yll)/2,:); %For the stack plots I'm taking the y=0 so it doesnt consider the oscillation 


end


%making the stack plot By
%--------------------------------------------------------------------------
time_t_2_Omega=time_t_2;
fs=18; % here I am actually plotting -Ax because I changed its sign to get the magnetic field components
[ZLT,OMT]=meshgrid(zll,time_t_2_Omega);
cd(path_s2)
f35=figure(35)
%set(gcf,'position',[x0,y0,0.9*width,height]) % there is a problem with the
%size of the font when using this
h1=subplot(1,1,1);
dum_p=By_y0_i'/B0;%/max(max(abs(inte_Ax_i)));
hc = pcolor(ZLT,OMT,dum_p);
hold on
set(hc,'edgecolor','none')
%colorbar; colormap(h1,flipud(turbo))
colorbar; colormap(h1,BWR)
lim_yp=0.7*max(max(max(abs(dum_p))));
%caxis([-lim_yp,lim_yp]);
caxis([-1.5,1.5]);
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
ax.YLabel.String = '$t / \Omega_{e}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
%xlim([zll(1) zll(end)]); ylim([time_t_2_Omega(1) time_t_2_Omega(end)]);
xlim([zll(1) zll(end)]); ylim([0 300]);
lgnd=legend([h1],'$\frac{B_{y}}{B_{0}} $','Interpreter','latex','FontSize',1.3*fs);
hold off
cd(path_s2)
saveas(f35,strcat(num2str(time_t),'By_stack_long_cont.png'));