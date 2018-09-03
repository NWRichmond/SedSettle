%% CLEANUP
clear; clc;
%% SETUP
sample_short_name = 'DanSand_02';
sample_long_name = strcat(sample_short_name,'_', ...
    string(datetime('now','Format','d-MMM-y_HH:mm')));
dry_weight_input = 7.18; % g
minutes = 10; % number of minutes to collect data (default is 10 minutes)
sampling_interval = 0.2; % how often should the data be collected (seconds)?
water_temp = 24; % degrees C
settling_tube_length = 203.3; % cm
use_synthetic_data = false; % set to true to use synthetic data for testing purposes
time_collected = datetime;
%% PACKAGE DATA AS STRUCTS
SampleVars = struct('minutes',minutes,'sampling_interval',sampling_interval, ...
    'dry_weight_input',dry_weight_input);
STvars = struct('water_temp',water_temp,'st_length',settling_tube_length);
%% OPTIONALLY, USE SYNTHETIC DATA
% NOTE: This code requires the MATLAB Fuzzy Logic Toolbox
if use_synthetic_data == true
    [data_grainSizeResults, mass_plot, dry_weight_input] = runSyntheticData(SampleVars, STvars);
end
%% TAKE MEASUREMENTS WITH THE MASS BALANCE
if use_synthetic_data == false
    [data_grainSizeResults, mass_plot, data_mass_timeseries, data_expected_kinematics] = runSettlingTube(SampleVars, STvars);
end
%% RUN THE STATISTICS
grainStatistics(dry_weight_input, data_grainSizeResults)
folkWardStats(data_grainSizeResults, phiPercentiles(data_grainSizeResults))
methodOfMoments(data_grainSizeResults)
%% PLOT RESULTS
cumulative_curve_plot = plotCumulativeCurve(data_grainSizeResults);
phi_size_distribution = plotPhiDistribution(data_grainSizeResults);
%% SAVE RESULTS
% NOTE: This happens automatically if you are in the SedSettle directory
if use_synthetic_data == false
    pwd_parts = strsplit(pwd,'/');
    if strcmp(pwd_parts(end), 'SedSettle') == 1
        workspaceOut = fullfile('results',sample_long_name);
    else % if not in the SedSettle directory, prompt to choose a save location
        msgbox('Select a directory to save the SedSettle results in.')
        selpath = uigetdir(pwd,'Select save location for SedSettle results');
        workspaceOut = fullfile(selpath,sample_long_name);
    end
    warning('off','MATLAB:Figure:FigureSavedToMATFile')
    save(strcat(workspaceOut,'.mat'))
end
disp('Settling tube data collection COMPLETE')