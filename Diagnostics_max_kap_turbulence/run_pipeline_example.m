%% run_pipeline_example.m
% Example usage of the diagnostics pipeline. Edit the paths below.

path_scripts = '/home/UNN/pfcy6/codes/processing_scripts/Matlab_Scripts_PC0/Diagnostics_max_kap_turbulence';

% ---- single run ---------------------------------------------------------
%-------------------------------------------------------------------------------------------
%run_path1 = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/using_22_nodes/cases_beta1/maxwell_TiTe';          % contains pfd.*.h5, pfd_moments.*.h5
%run_path2 = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/using_22_nodes/cases_beta1/kappa_3_TiTe';

%run_path3 = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/using_22_nodes/cases_beta02/kappa_3_TiTe';
%run_path4 = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/using_22_nodes/cases_beta02/maxwell_TiTe';

%run_path = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/using_22_nodes/cases_beta5/kappa_3_TiTe';
%run_path = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/using_22_nodes/cases_beta5/maxwell_TiTe';
%-------------------------------------------------------------------------------------------

%cxx_path = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/using_22_nodes/cases_beta1/maxwell_TiTe/psc_turbulence_2D_maxwellian_3.cxx';         % contains setupParameters()/setupGrid()

%diag = compute_diagnostics(run_path, cxx_path);
%diag = compute_diagnostics(run_path);
%f1=plot_diagnostics(diag, run_path);


% Save so you don't have to re-run the (slow) HDF5 loop every time:
%save(fullfile(run_path, 'diagnostics_cases_beta5_maxwell.mat'), 'diag', '-v7.3');
%cd(run_path)
%saveas(f1,strcat('Diagnostics_cases_beta5_maxwell_TiTe.png'));

% ---- comparing multiple runs --------------------------------------------
% runs = {
%     {'/path/to/runA', '/path/to/runA/setup.cxx', 'Run A'}, ...
%     {'/path/to/runB', '/path/to/runB/setup.cxx', 'Run B'}, ...
% };
%
% diag_list = {};
% labels = {};
% for i = 1:numel(runs)
%     diag_list{i} = compute_diagnostics(runs{i}{1}, runs{i}{2}); %#ok<SAGROW>
%     labels{i} = runs{i}{3}; %#ok<SAGROW>
% end


run_path1 = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/using_22_nodes/cases_beta02/maxwell_TiTe';          % contains pfd.*.h5, pfd_moments.*.h5
run_path2 = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/using_22_nodes/cases_beta02/kappa_3_TiTe';
run_path3 = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/using_22_nodes/cases_beta1/maxwell_TiTe';
run_path4 = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/using_22_nodes/cases_beta1/kappa_3_TiTe';
run_path5 = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/using_22_nodes/cases_beta5/maxwell_TiTe';
run_path6 = '/JAAR-DATA/COSMA_DATA/RUNS_MARCH_JUNE/using_22_nodes/cases_beta5/kappa_3_TiTe';

cd(run_path1)
d1 = load('diagnostics_cases_beta02_maxwell_TiTe.mat');
cd(run_path2)
d2 = load('diagnostics_cases_beta02_kappa_3_TiTe.mat');
cd(run_path3)
d3 = load('diagnostics_beta1_maxwell.mat');
cd(run_path4)
d4 = load('diagnostics_beta1_kappa_3.mat');
cd(run_path5)
d5 = load('diagnostics_cases_beta5_maxwell.mat');
cd(run_path6)
d6 = load('diagnostics_cases_beta5_kappa_3.mat');

diag_list = {d1,d2,d3,d4,d5,d6};
 
labels = {'beta02_maxwell','beta02_kappa_3','beta1_maxwell','beta1_kappa_3','beta5_maxwell','beta5_kappa_3'};

cd(path_scripts)
compare_runs(diag_list, labels);

aa = [d1.diag.t_Oi(end) d2.diag.t_Oi(end)... 
    d3.diag.t_Oi(end) d4.diag.t_Oi(end)... 
    d5.diag.t_Oi(end) d6.diag.t_Oi(end)];
    max_t=min(aa);
    xlim([0,max_t])
