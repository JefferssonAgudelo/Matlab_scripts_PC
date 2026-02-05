% This is to read the hybrid vlasov simulation data from Camille

%-----------------------------------------------------------------------------------------------------------------------
%path = '/Users/jeffersson_agudelo/Documents/New_psc/second_try_version/build_2/testing_jeff/psc_turb_alf'; % this has the problem _UP
path = '/Volumes/PSC_DiRAC_DATA/DATA_HVM/betai=1/01'; 
%-----------------------------------------------------------------------------------------------------------------------

% For the scripts
%-----------------------------------------------------------------------------------------------------------------------
path_comp = '/Volumes/PSC_CORI_DATA/TESTS_2022/New_V_tests/runs_with_L_05/testing_dB/Data_comparison';
path_s  = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Scripts_spectra';
path_s2 = '/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here';
%-----------------------------------------------------------------------------------------------------------------------

%--------------------------------------------------------------------------
cd(path)
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% Box dimensions
% ---------------> Enter 3.0
xl = 3.0; yl = 3.0; zl=3.0; 
Lx = 2.0 * pi * xl;
Ly = 2.0 * pi * yl;
Lz = 2.0 * pi * zl;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
a0 = 0.0;
a1 = 0;
a2 = 0;
a3 = 0;

b0 = 0.0;
b1 = 0.0;
b2 = 0.0;
b3 = 0.0;
b4 = 0.0;
b5 = 0.0;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
fileID_tempo =  fopen('tempo.dat'); 
tempo = fread(fileID_tempo,'single');

fileID_energ =  fopen('energ.dat'); 
tempo = fread(fileID_energ,'*int16');
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
fileID_Ion =  fopen('Ion.bin','rb'); 
Ion = fread(fileID_Ion,'single'); 

%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
fileID_EB =  fopen('EB.bin','rb'); 
frewind(fileID_EB);
EB = fread(fileID_EB,'*int16');
%--------------------------------------------------------------------------


fileID_Press =  fopen('Press.bin'); 
%--------------------------------------------------------------------------





%--------------------------------------------------------------------------

%--------------------------------------------------------------------------



%h5disp(fileID);
info = h5info(fileID);
EHJ_1st = info.Groups(16).Name;
grid_dt = info.Groups(20).Attributes;

grid_length = info.Groups(17).Attributes;
Lx=grid_length(4).Value(1) - grid_length(3).Value(1); %(The substraction give the total size of the domain) -Lx0 to Lx0
Ly=grid_length(4).Value(2) - grid_length(3).Value(2);
Lz=grid_length(4).Value(3) - grid_length(3).Value(3);
%------------------------------------------------------------------
