

%%%
for d=1
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
    % % % path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_alone_large'; %A
    % % % path ='/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_base_2_large'; %B
    path = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/psc_harris_yz_lange_Ax_large';%C
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
end
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

path = '/Volumes/Perlmutterdata/Data_P1/psc_harris_yz_pinch_short_L4di';
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
    % Bx = B{1,1}; Bx = squeeze(Bx(sli_x,:,:));
    By = B{1,2}; By = squeeze(By(sli_x,:,:));
    % Bz = B{1,3}; Bz = squeeze(Bz(sli_x,:,:));
    % Ex = E{1,1}; Ex = squeeze(Ex(sli_x,:,:));
    % Ey = E{1,2}; Ey = squeeze(Ey(sli_x,:,:));
    % Ez = E{1,3}; Ez = squeeze(Ez(sli_x,:,:));
    % Jx = J{1,1}; Jx = squeeze(Jx(sli_x,:,:));
%     Jy = J{1,2}; Jy = squeeze(Jy(sli_x,:,:));
%     Jz = J{1,3}; Jz = squeeze(Jz(sli_x,:,:));
    %----------------------------------------------------------------------
    sss=size(By);
    size_X=sss;
    zll=linspace(-Lz,Lz,size_X(2)); %Jeff flag it works with (1,size_x(2))
    yll=linspace(-Ly,Ly,size_X(1));
    [ZLL, YLL] = meshgrid(zll,yll);
% %     %----------------------------------------------------------------------
% %     % Compute the out of the plane vector potential
% %     %----------------------------------------------------------------------
% %     % get ax integrating over y
% %     dx = resy; dy = resz;
% %     ny=sss(1);
% %     nz=sss(2);
% %     Iapprox = zeros(size(By));
% %     Iapprox_i=0;
% %     %integral over y
% %     for i=1:ny-1
% %         Iapprox_i = Iapprox_i + dy*Bz(i,:);
% %         Iapprox(i,:)=Iapprox_i;
% %     end
% %     Ax_y=Iapprox; %&lt;------- This is the correct Ax
% %     Ax_y=-Ax_y;
% %     %----------------------------------------------------------------------
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
% % 
% %     % to plot closer
% %     aa=1/8; %(it was 1/4)
% % 
% %     %This plot shows the close-up with the squares to show the particle
% %     %info regions
% %     cd(path_s2)
% %     %----------------------------------------------------------------------
% %     fs=18;
% %     x0=45;y0=54;xx1=810;yy1=173;
% %     %----------------------------------------------------------------------
% %     f1=figure(1);
% %     set(gcf,'position',[x0,y0,xx1,yy1])
% %     h3=subplot(1,1,1);
% %     %dum_p2=Jx/J0;
% %     dum_p2=Jx/max(max(Jx));
% %     lim_yp2=max(max(max(abs(dum_p2))));
% %     %dum_p2=dum_p2/lim_yp2;
% %     hc=pcolor(ZLL,YLL,dum_p2);
% %     set(hc,'edgecolor','none')
% %     hold on
% %     %----------------------------------------------------------------------
% %     dum_p=Ax_y;
% %     lim_yp=max(max(max(abs(dum_p))));
% %     dum_p=dum_p/lim_yp;
% %     [C,h]=contour(ZLL,YLL,dum_p,'LevelStep',0.1);
% %     set(h,'LineColor','black','LineWidth',1)
% %     %----------------------------------------------------------------------
% %     colorbar; colormap(h3,BWR);
% %     hcb=colorbar; hcb.Location = 'eastoutside';
% %     hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
% %     % lange_all
% %     ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% %     ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
% %     ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
% %     ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
% % 
% %     zlen=length(zll); Dz=floor(aa*zlen); ylen=length(yll); Dy=floor(aa*ylen);
% %     xlim([zll(1 ) zll(end )]);
% %     %ylim([yll(1 + Dy) yll(end - Dy)]);
% %     ylim([-30 30]);
% % 
% %     %length_yl=yll(end) - yll(1); ylim([-length_yl/4 length_yl/4]);
% %     lgnd=legend([h3],'$\frac{J_{x}}{J_{0}} $','Interpreter','latex','FontSize',1.3*fs);
% %     %set(lgnd,'color','none');
% %     %rectangle('Position',[-10 10 20 10],'EdgeColor','b','LineWidth',2) %reconnecting
% %     %rectangle('Position',[-10 -5 20 10],'EdgeColor','r','LineWidth',2) %reconnecting
% %     %caxis([-1.0 1.0]); 
% %     %%rectangle('Position',[-60 10 20 10],'EdgeColor','b','LineWidth',2) %lange disrupt
% %     %%rectangle('Position',[-60 -5 20 10],'EdgeColor','r','LineWidth',2) %lange disrupt
% %     %%caxis([-1.0 1.0]);
% % 
% %     %%rectangle('Position',[0 10 20 10],'EdgeColor','b','LineWidth',2) %reconnecting
% %     %%rectangle('Position',[0 -5 20 10],'EdgeColor','r','LineWidth',2) %reconnecting
% % 
% %     % central pinch island
% %     %rectangle('Position',[30 10 20 10],'EdgeColor','b','LineWidth',2) %reconnecting
% %     %rectangle('Position',[30 -5 20 10],'EdgeColor','r','LineWidth',2) %reconnecting
% % 
% %     % dB02kd2 island
% % %     rectangle('Position',[-50 -5 20 10],'EdgeColor','k','LineWidth',1.8) %R1
% % %     rectangle('Position',[-70 -5 20 10],'EdgeColor','r','LineWidth',1.8) %R2
% % %     rectangle('Position',[-70 10 20 10],'EdgeColor','b','LineWidth',1.8) %R3
% % %     rectangle('Position',[-50 20 20 10],'EdgeColor','m','LineWidth',1.8) %R4
% % 
% %     % dB01kd1 island
% % %     rectangle('Position',[-60 -5 20 10],'EdgeColor','k','LineWidth',1.8) %R1
% % %     rectangle('Position',[-40 -5 20 10],'EdgeColor','r','LineWidth',1.8) %R2
% % %     rectangle('Position',[-40 10 20 10],'EdgeColor','b','LineWidth',1.8) %R3
% % %     rectangle('Position',[-60 20 20 10],'EdgeColor','m','LineWidth',1.8) %R4
% % 
% %     % central pinch
% %     rectangle('Position',[-10 -5 20 10],'EdgeColor','k','LineWidth',1.8) %R1
% %     rectangle('Position',[30 -5 20 10],'EdgeColor','r','LineWidth',1.8) %R2
% %     rectangle('Position',[30 10 20 10],'EdgeColor','b','LineWidth',1.8) %R3
% %     rectangle('Position',[-10 20 20 10],'EdgeColor','m','LineWidth',1.8) %R4
% % 
% %     caxis([-1.0 1.0]);
% %     hold off
% %     %----------------------------------------------------------------------
% %     sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
% %     %----------------------------------------------------------------------
% %     %cd(path_comp)
% %     cd(path)
% % 
% %     %saveas(f1,strcat(num2str(time_t),'Jx_zoom_squaresR4_dB02kd2_mag_inside.png'));
% %     saveas(f1,strcat(num2str(time_t),'Jx_zoom_squares_src.png'));
% %     %saveas(f1,strcat(num2str(time_t),'Jx_zoom_squaresR4_dB01kd1_mag_inside.png'));
% %     %----------------------------------------------------------------------
% %     %----------------------------------------------------------------------
% % 
% %     B0=0.2;
% %     J0=0.2;
% %     cd(path_s2)
% %     fs=18;
% %     %----------------------------------------------------------------------
% %     x0=45;y0=54;xx1=810;yy1=710;
% %     f57=figure();
% %     set(gcf,'Visible', 'off'); 
% %     set(gcf,'position',[x0,y0,xx1,yy1])
% %     %----------------------------------------------------------------------
% %     h1=subplot(3,1,1);
% %     dum_p2=By/B0;
% %     %dum_p2=By/max(max(abs(By)));
% %     lim_yp2=max(max(max(abs(dum_p2))));
% %     %dum_p2=dum_p2/lim_yp2;
% %     hc=pcolor(ZLL,YLL,dum_p2);
% %     set(hc,'edgecolor','none')
% %     hold on
% %     %----------------------------------------------------------------------
% %     dum_p=Ax_y;
% %     lim_yp=max(max(max(abs(dum_p))));
% %     dum_p=dum_p/lim_yp;
% %     [C,h]=contour(ZLL,YLL,dum_p,'LevelStep',0.1);
% %     set(h,'LineColor','black','LineWidth',1)
% %     %----------------------------------------------------------------------
% %     colorbar; colormap(h1,BWR);
% %     hcb=colorbar; hcb.Location = 'eastoutside';
% %     hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
% %     caxis([-1.0 1.0]); % lange_all
% %     ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% %     ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
% %     ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
% %     ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
% %     zlen=length(zll); Dz=floor(aa*zlen); ylen=length(yll); Dy=floor(aa*ylen);
% %     xlim([zll(1 ) zll(end )]);
% %     ylim([yll(1 + Dy) yll(end - Dy)]);
% %     %length_yl=yll(end) - yll(1); ylim([-length_yl/4 length_yl/4]);
% %     lgnd=legend([h1],'$\frac{B_{y}}{B_{0}} $','Interpreter','latex','FontSize',1.3*fs);
% %     %set(lgnd,'color','none');
% %     hold off
% %     %----------------------------------------------------------------------
% %     %----------------------------------------------------------------------
% %     h2=subplot(3,1,2);
% %     dum_p2=Bz/B0;
% %     %dum_p2=Bz/max(max(abs(Bz)));
% %     lim_yp2=max(max(max(abs(dum_p2))));
% %     %dum_p2=dum_p2/lim_yp2;
% %     hc=pcolor(ZLL,YLL,dum_p2);
% %     set(hc,'edgecolor','none')
% %     hold on
% %     %----------------------------------------------------------------------
% %     dum_p=Ax_y;
% %     lim_yp=max(max(max(abs(dum_p))));
% %     dum_p=dum_p/lim_yp;
% %     [C,h]=contour(ZLL,YLL,dum_p,'LevelStep',0.1);
% %     set(h,'LineColor','black','LineWidth',1)
% %     %----------------------------------------------------------------------
% %     colorbar; colormap(h2,BWR);
% %     hcb=colorbar; hcb.Location = 'eastoutside';
% %     hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
% %     caxis([-1.0 1.0]); % lange_all
% %     ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% %     ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
% %     ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
% %     ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
% %     zlen=length(zll); Dz=floor(aa*zlen); ylen=length(yll); Dy=floor(aa*ylen);
% %     xlim([zll(1 ) zll(end )]);
% %     ylim([yll(1 + Dy) yll(end - Dy)]);
% %     %length_yl=yll(end) - yll(1); ylim([-length_yl/4 length_yl/4]);
% %     lgnd=legend([h2],'$\frac{B_{z}}{B_{0}} $','Interpreter','latex','FontSize',1.3*fs);
% %     %set(lgnd,'color','none');
% %     hold off
% %     %----------------------------------------------------------------------
% %     %----------------------------------------------------------------------
% %     h3=subplot(3,1,3);
% %     %f1=figure(1)
% %     %h3=subplot(1,1,1);
% %     dum_p2=Jx/J0;
% %     %dum_p2=Jx/max(max(abs(Jx)));
% %     lim_yp2=max(max(max(abs(dum_p2))));
% %     %dum_p2=dum_p2/lim_yp2;
% %     hc=pcolor(ZLL,YLL,dum_p2);
% %     set(hc,'edgecolor','none')
% %     hold on
% %     %----------------------------------------------------------------------
% %     dum_p=Ax_y;
% %     lim_yp=max(max(max(abs(dum_p))));
% %     dum_p=dum_p/lim_yp;
% %     [C,h]=contour(ZLL,YLL,dum_p,'LevelStep',0.1);
% %     set(h,'LineColor','black','LineWidth',1)
% %     %----------------------------------------------------------------------
% %     colorbar; colormap(h3,BWR);
% %     hcb=colorbar; hcb.Location = 'eastoutside';
% %     hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
% %     caxis([-1.0 1.0]); % lange_all
% %     ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
% %     ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
% %     ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
% %     ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
% % 
% %     zlen=length(zll); Dz=floor(aa*zlen); ylen=length(yll); Dy=floor(aa*ylen);
% %     xlim([zll(1 ) zll(end )]);
% %     ylim([yll(1 + Dy) yll(end - Dy)]);
% % 
% %     %length_yl=yll(end) - yll(1); ylim([-length_yl/4 length_yl/4]);
% %     lgnd=legend([h3],'$\frac{J_{x}}{J_{0}} $','Interpreter','latex','FontSize',1.3*fs);
% %     %set(lgnd,'color','none');
% %     %rectangle('Position',[-10 10 20 20],'EdgeColor','b','LineWidth',2)
% %     %rectangle('Position',[-10 -5 20 5],'EdgeColor','r','LineWidth',2)
% %     hold off
% %     %----------------------------------------------------------------------
% %     sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)
% %     %----------------------------------------------------------------------
    % % 
    % % %----------------------------------------------------------------------
    % % 
    % % %----------------------------------------------------------------------
    % % cd(path_rec_line_ByBzJx_zoom)
    % % saveas(f57,strcat(num2str(time_t),'ByBzJx_zoom.png'));
    % % close(f57);
    % % delete(f57);
    % % %----------------------------------------------------------------------
    cd(path)
    By_y0_i(:,jn) = By(length(yll)/2,:); %For the stack plots I'm taking the y=0 so it doesnt consider the oscillation 
    %Bx_y0_i(:,jn) = Bx(length(yll)/2,:);
    %Bz_y0_i(:,jn) = Bz(length(yll)/2,:);

    % This block is to make plotss that better show the initial
    % fluctuations and their effect
    %----------------------------------------------------------------------
    

    %----------------------------------------------------------------------

end

% % %Exfin=Ex;
% % 
% % %Bz0=Bz;
% % f21=figure(21)
% % %plot(yll,Ex(:,512),'b')
% % %hold on
% % contourf(By_y0_i')
% % %hold off
% % 
% % f3=figure(3)
% % plot(yll,Bz0(:,512),'b')
% % hold on
% % plot(yll,Bz0(:,1024),'k')
% % plot(yll,Bz(:,512),'--b')
% % plot(yll,Bz(:,1024),'--k')
% % xline(-4,'--')
% % xline(4,'--')
% % hold off
% % %}
% % %--------------------------------------------------------------------------
% % %--------------------------------------------------------------------------
% %

% % %--------------------------------------------------------------------------
% % %This is to make the stsack plot of By Bx Bz
% %
% %--------------------------------------------------------------------------
%
%time_t_2_Omega=time_t_2./omega_pe_Omega_ce;

%%Error in plots_in_time (line 450) <------ here I go, I need to resolve
%%this
%%caxis([-lim_yp,lim_yp])




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

saveas(f35,strcat(num2str(time_t),'By_stack_long_cont.png'));

%making the stack plot Bx
%--------------------------------------------------------------------------
fs=18; % here I am actually plotting -Ax because I changed its sign to get the magnetic field components
[ZLT,OMT]=meshgrid(zll,time_t_2_Omega);
cd(path_s2)
f36=figure(36)
%set(gcf,'position',[x0,y0,0.9*width,height]) % there is a problem with the
%size of the font when using this
h1=subplot(1,1,1);
dum_p=Bx_y0_i'/B0;%/max(max(abs(inte_Ax_i)));
hc = pcolor(ZLT,OMT,dum_p);
hold on
set(hc,'edgecolor','none')
%colorbar; colormap(h1,flipud(turbo))
colorbar; colormap(h1,BWR)
lim_yp=0.7*max(max(max(abs(dum_p))));
caxis([-lim_yp,lim_yp])
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
ax.YLabel.String = '$t / \Omega_{e}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
xlim([zll(1) zll(end)]); ylim([time_t_2_Omega(1) time_t_2_Omega(end)]);
lgnd=legend([h1],'$\frac{B_{x}}{B_{0}} $','Interpreter','latex','FontSize',1.3*fs);
hold off

%making the stack plot Bz
%--------------------------------------------------------------------------
fs=18; % here I am actually plotting -Ax because I changed its sign to get the magnetic field components
[ZLT,OMT]=meshgrid(zll,time_t_2_Omega);
cd(path_s2)
f37=figure(37)
%set(gcf,'position',[x0,y0,0.9*width,height]) % there is a problem with the
%size of the font when using this
h1=subplot(1,1,1);
dum_p=Bz_y0_i'/B0;%/max(max(abs(inte_Ax_i)));
hc = pcolor(ZLT,OMT,dum_p);
hold on
set(hc,'edgecolor','none')
%colorbar; colormap(h1,flipud(turbo))
colorbar; colormap(h1,BWR)
lim_yp=0.7*max(max(max(abs(dum_p))));
if lim_yp~=0
    caxis([-lim_yp lim_yp]);
else
    caxis([-1 1]);
end
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs;
ax.YLabel.String = '$t / \Omega_{e}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
xlim([zll(1) zll(end)]); ylim([time_t_2_Omega(1) time_t_2_Omega(end)]);
lgnd=legend([h1],'$\frac{B_{z}}{B_{0}} $','Interpreter','latex','FontSize',1.3*fs);
hold off
cd(path_rec_line)

% %
saveas(f35,strcat(num2str(time_t),'By_stack_long_cont.png'));
saveas(f36,strcat(num2str(time_t),'Bx_stack_long_cont.png'));
saveas(f37,strcat(num2str(time_t),'Bz_stack_long_cont.png'));
% % %--------------------------------------------------------------------------
%}
% %--------------------------------------------------------------------------
% %--------------------------------------------------------------------------





cd(path_s2)
%----------------------------------------------------------------------
fs=18;
x0=45;y0=54;xx1=810;yy1=710;
%----------------------------------------------------------------------
f27=figure(27);
set(gcf,'position',[x0,y0,xx1,yy1])
%----------------------------------------------------------------------
h1=subplot(1,1,1);
dum_p2=Va_3c/(B0/sqrt(0.2)); %nb=0.2
%lim_yp2=max(max(max(abs(dum_p2))));dum_p2=dum_p2/lim_yp2;
hc=pcolor(ZLL,YLL,dum_p2);
set(hc,'edgecolor','none')
hold on
colorbar; colormap(h1,jet);
hcb=colorbar; hcb.Location = 'eastoutside';
hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
caxis([0 1]); % lange_all
ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
xlim([zll(1) zll(end)]);
ylim([yll(1) yll(end)]);
lgnd=legend([h1],'$\frac{v_{A,m}}{v_{A,0}} $','Interpreter','latex','FontSize',1.3*fs);
hold off
set(gcf,'position',[x0,y0,xx1,yy1])
sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)

cd(path_rec_line)
saveas(f27,strcat(num2str(time_t),'VA.png'));
cd(path)

end

% %--------------------------------------------------------------------------
% %--------------------------------------------------------------------------


% % % %--------------------------------------------------------------------------
% % % % Making a plot for B2 as a function of time to see the growth rate of
% % % the instability as shang sang
% % % %--------------------------------------------------------------------------
%{
% % S = dir(fullfile(path,'pfd.*.h5'));
% % N=numel(S); % number of files to use
% % H=zeros(N);
% % in=2;
% % omega_pe_Omega_ce=5;
% % time_t_2=zeros(1,N);
% % B2_mean=zeros(1,N);
% % for in=1:N
% %     disp(strcat('Computing step ...',S(in).name))
% %     fileID =  S(in).name; %change the 1 per i
% %     %h5disp(fileID);
% %     info = h5info(fileID);
% %     EHJ_1st = info.Groups(16).Name;
% %     grid_dt = info.Groups(20).Attributes;
% % 
% %     Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
% %     %By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
% %     %Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));
% % 
% %     %B2 = Bx.^2 + By.^2 + Bz.^2; % it seems the totsl magnetic field goes
% %     %down
% %     B2 = Bx.^2;
% %     B2_mean(1,in) = mean(B2,'all');
% % 
% %     dt=double(grid_dt(15).Value);
% %     str = string(S(in).name);
% %     newStr = extractBetween(str,"pfd.","_p000000.h5");
% %     N_steps = str2double(newStr);
% %     time_t = dt*N_steps;
% %     time_t_2_Omega=time_t./omega_pe_Omega_ce;
% %     time_t_2(1,in)=time_t_2_Omega;
% % 
% %     cd(path)
% % end
% % 
% % %cd(path_s2)
% % %----------------------------------------------------------------------
% % fs=18;
% % x0=45;y0=54;xx1=810;yy1=710;
% % %----------------------------------------------------------------------
% % f46=figure(46)
% % a =1; y = B2_mean;
% % plot(time_t_2,y,'b',LineWidth=2)
% % hold on
% % legend('$B^{2}$','Interpreter','latex','FontSize',1.0*fs)
% % title('$\varepsilon=0.1 \ ; \ \zeta=0.1$','Interpreter','latex','FontSize',1.0*fs)
% % hold off
%}
% % % %--------------------------------------------------------------------------
% % % %--------------------------------------------------------------------------




% %--------------------------------------------------------------------------
% %--------------------------------------------------------------------------
% Make a 2D plot of the alfven speed theoretical and also one that is with
% the data, so it can be substracted and what is left show how the onset of
% the tearing instability affect the profile of the alfven speed for thr
% harris current sheet.
% %--------------------------------------------------------------------------

cd(path)
S = dir(fullfile(path,'pfd.*.h5'));
N=numel(S); % number of files to use
H=zeros(N);
%--------------------------------------------------------------------------
S2 = dir(fullfile(path,'pfd_moments.*.h5'));
N2=numel(S2); % number of files to use
H2=zeros(N2);

in=6;
in=jn;

for in=1:N
    %----------------------------------------------------------------------
    disp(strcat('Computing step ...',S(in).name))
    fileID =  S(in).name; %change the 1 per i
    %h5disp(fileID);
    info = h5info(fileID);
    EHJ_1st = info.Groups(16).Name;
    %----------------------------------------------------------------------
    disp(strcat('Computing step ...',S2(in).name))
    fileID2 =  S2(in).name; %change the 1 per i
    %h5disp(fileID2);
    info2 = h5info(fileID2);
    moments_1st = info2.Groups(1).Name;
    %----------------------------------------------------------------------

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

    dt=double(grid_dt(15).Value);
    str = string(S(in).name);
    newStr = extractBetween(str,"pfd.","_p000000.h5");
    N_steps = str2double(newStr);
    time_t = dt*N_steps;
    time_t_2_Omega = time_t./omega_pe_Omega_ce;

    %--------------------------------------------------------------------------

    Bx=h5read(fileID,strcat(EHJ_1st,'/hx_fc/p0/3d'));
    By=h5read(fileID,strcat(EHJ_1st,'/hy_fc/p0/3d'));
    Bz=h5read(fileID,strcat(EHJ_1st,'/hz_fc/p0/3d'));

    n_e_up{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_e_UP/p0/3d'));
    n_i_up{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_i_UP/p0/3d'));
    n_e_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_e_BA/p0/3d'));
    n_i_ba{1,1}=h5read(fileID2,strcat(moments_1st,'/rho_i_BA/p0/3d'));
    n_e =-(n_e_up{1,1} + n_e_ba{1,1})./1;
    n_i =(n_i_up{1,1} + n_i_ba{1,1})./1;

    Jx=h5read(fileID,strcat(EHJ_1st,'/jx_ec/p0/3d'));

    sli_x=1;

    Bx = squeeze(Bx(sli_x,:,:));
    By = squeeze(By(sli_x,:,:));
    Bz = squeeze(Bz(sli_x,:,:));
    n_i = squeeze(n_i(sli_x,:,:));
    n_e = squeeze(n_e(sli_x,:,:));

    Jx = squeeze(Jx(sli_x,:,:));

    sss=size(Bx);
    size_X=sss;
    zll=linspace(-Lz,Lz,size_X(2)); %Jeff flag it works with (1,size_x(2))
    yll=linspace(-Ly,Ly,size_X(1));
    [ZLL, YLL] = meshgrid(zll,yll);

    me=1; mu0=1;
    Va_3c = sqrt(Bx.^2 + By.^2 + Bz.^2) ./ sqrt(mu0.* me .* n_e);
    %Va_3c = squeeze(Va_3c(1,:,:));

    cd(path_s2)
    %----------------------------------------------------------------------
    fs=18;
    x0=45;y0=54;xx1=810;yy1=710;
    %----------------------------------------------------------------------
    f27=figure(27);
    set(gcf,'position',[x0,y0,xx1,yy1])
    %----------------------------------------------------------------------
    h1=subplot(1,1,1);
    dum_p2=Va_3c/(B0/sqrt(0.2)); %nb=0.2
    %lim_yp2=max(max(max(abs(dum_p2))));dum_p2=dum_p2/lim_yp2;
    hc=pcolor(ZLL,YLL,dum_p2);
    set(hc,'edgecolor','none')
    hold on
    colorbar; colormap(h1,jet);
    hcb=colorbar; hcb.Location = 'eastoutside';
    hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    caxis([0 1]); % lange_all
    ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    xlim([zll(1) zll(end)]);
    ylim([yll(1) yll(end)]);
    lgnd=legend([h1],'$\frac{v_{A,m}}{v_{A,0}} $','Interpreter','latex','FontSize',1.3*fs);
    hold off
    set(gcf,'position',[x0,y0,xx1,yy1])
    % %     %----------------------------------------------------------------------
    % %     h2=subplot(2,1,2);
    % %     dum_p2=Jx; %nb=0.2
    % %     lim_yp2=max(max(max(abs(dum_p2))));dum_p2=dum_p2/lim_yp2;
    % %     hc=pcolor(ZLL,YLL,dum_p2);
    % %     set(hc,'edgecolor','none')
    % %     hold on
    % %     colorbar; colormap(h2,BWR);
    % %     hcb=colorbar; hcb.Location = 'eastoutside';
    % %     hcb.Label.FontSize=fs; hcb.Label.Interpreter = 'latex';hcb.TickLabelInterpreter = 'latex';
    % %     caxis([-1 1]); % lange_all
    % %     ax = gca; ax.TickLabelInterpreter = 'latex';ax.XLabel.Interpreter='latex';ax.YLabel.Interpreter='latex';
    % %     ax.FontSize=fs; %ax.XTick = []; ax.YTick = [];
    % %     ax.YLabel.String = '$y / d_{i}$'; %ax.YTick = yticks_mine; %ax.YLabel.Position = [-0.6, 5];
    % %     ax.XLabel.String = '$z / d_{i}$'; %ax.XTick = zticks_mine; %ax.XLabel.Position = [5.1, -0.6];
    % %     xlim([zll(1) zll(end)]);
    % %     ylim([yll(90) yll(270)]);
    % %     lgnd=legend([h2],'$\frac{J_{x}}{J_{0}} $','Interpreter','latex','FontSize',1.3*fs);
    % %     hold off
    % %     %----------------------------------------------------------------------
    sgtitle('$$t = \ $$'+string(round(time_t_2_Omega,2))+'$$\Omega_{e}^{-1}$$','Interpreter','latex','FontSize',fs)

    cd(path_rec_line)
    saveas(f27,strcat(num2str(time_t),'VA.png'));
    cd(path)

end
% %--------------------------------------------------------------------------
% %--------------------------------------------------------------------------


%checking tanh and sech2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y=linspace(-10,10,200);
z=linspace(-10,10,200);
a=10/(2*pi);

By=-(1-(cos(y./a).*(sin(z./a))./(y+z)));
Bz= (1-(sin(y./a).*(cos(z./a))./(y+z)));
%y4=(tanh(x./a)).^2;

% Nonlinear time without fluctuations
%--------------------------------------------------------------------------
f45=figure(45);
subplot(1,2,1)
plot(y,By,'r',LineWidth=2)
hold on
plot(y,Bz,'b',LineWidth=2)
legend('By', 'Bz')
hold off
subplot(1,2,2)
plot(z,By,'r',LineWidth=2)
hold on
plot(z,Bz,'b',LineWidth=2)
legend('By', 'Bz')
hold off

%--------------------------------------------------------------------------

% In 2D
%z=linspace(-40,40,200);
%y=linspace(-40,40,200);
[zz,yy]=meshgrid(z,y);
Lz=10; Ly=10; % this has to be double to account for the -L to L
a=Lz/(2*pi);

% This is the central pinch
yy1=-sin((2*pi/Lz).*(zz-0.5*Lz)).*cos(pi*yy./Ly);
yy2=cos((2*pi/Lz).*(zz-0.5*Lz)).*sin(pi*yy./Ly);

yy3=yy1.*yy2;

f46=figure(46);
subplot(1,3,1)
hc=pcolor(zz,yy,yy1);
hold on
set(hc,'edgecolor','none'); colorbar
hold off
subplot(1,3,2)
hc=pcolor(zz,yy,yy2);
hold on
set(hc,'edgecolor','none'); colorbar
hold off
subplot(1,3,3)
hc=pcolor(zz,yy,yy3);
hold on
set(hc,'edgecolor','none'); colorbar
hold off

% this is the other 
Byy=-(1-(cos(yy./a).*(sin(zz./a))./(yy+zz)));
Bzz= (1-(sin(yy./a).*(cos(zz./a))./(yy+zz)));

yy3=yy1.*yy2;

f47=figure(47);
subplot(1,3,1)
hc=pcolor(zz,yy,Byy);
hold on
set(hc,'edgecolor','none'); colorbar
hold off
subplot(1,3,2)
hc=pcolor(zz,yy,Bzz);
hold on
set(hc,'edgecolor','none'); colorbar
hold off
subplot(1,3,3)
hc=pcolor(zz,yy,yy3);
hold on
set(hc,'edgecolor','none'); colorbar
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Defining functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function f = fcoeffunction(location,state)
%Nr = 1; % Number of equations
%nr = length(location.z); % Number of columns
f = state.u;%zeros(Nr,nr); % Allocate f
end
