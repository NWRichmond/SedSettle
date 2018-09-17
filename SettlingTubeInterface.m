%% WELCOME TO THE SETTLING TUBE INTERFACE
% SIMPLY SET THE FOLLOWING VARIABLES IN THE 'SETUP' SECTION:
%    sample_short_name, dry_weight_input, minutes, sampling_interval, water_temp
% ...and press 'Run' to begin the data collection
%% CLEANUP
clear; clc;
%% SETUP
sample_short_name = 'DanSand_02';
sample_long_name = strcat(sample_short_name,'_', ...
    string(datetime('now','Format','d-MMM-y_HH:mm')));
dry_weight_input = 9.80; % g
minutes = 10; % number of minutes to collect data (default is 10 minutes)
sampling_interval = 0.1; % how often should the data be collected (seconds)?
water_temp = 23; % degrees C
settling_tube_length = 203.3; % cm
time_collected = datetime;
%% PACKAGE DATA AS STRUCTS
SampleVars = struct('minutes',minutes,'sampling_interval',sampling_interval, ...
    'dry_weight_input',dry_weight_input);
STvars = struct('water_temp',water_temp,'st_length',settling_tube_length);
%% TAKE MEASUREMENTS WITH THE MASS BALANCE
[data_grainSizeResults, mass_plot, data_mass_timeseries, data_expected_kinematics] = runSettlingTube(SampleVars, STvars);
%% RUN THE STATISTICS
grainStatistics(dry_weight_input, data_grainSizeResults)
folkWardStats(data_grainSizeResults, phiPercentiles(data_grainSizeResults))
methodOfMoments(data_grainSizeResults)
%% PLOT RESULTS
cumulative_curve_plot = plotCumulativeCurve(data_grainSizeResults);
phi_size_distribution = plotPhiDistribution(data_grainSizeResults);
%% SAVE RESULTS
% NOTE: This happens automatically if you are in the SedSettle directory
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
disp('Settling tube data collection COMPLETE')