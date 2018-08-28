%% CLEANUP
clear
clc
%% SETUP
sample_short_name = 'Ottawa_20-30';
sample_long_name = strcat(sample_short_name,'_', ...
    string(datetime('now','Format','d-MMM-y_HH:mm')));
dry_weight_input = 10.00; % g
minutes = 2; % number of minutes to collect data (default is 10 minutes)
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
    SampleVars.dry_weight_input = 9.456;
    [data_grainSizeResults, mass_plot] = runSyntheticData(STvars,10,0.6);
end
%% TAKE MEASUREMENTS WITH THE MASS BALANCE
if use_synthetic_data == false
    [data_grainSizeResults, mass_plot, data_mass_timeseries, data_expected_kinematics] = runSettlingTube(SampleVars, STvars);
end
%% RUN THE STATISTICS
grainStatistics(dry_weight_input, data_grainSizeResults)
cumulative_curve_plot = plotCumulativeCurve(data_grainSizeResults);
phiPercentileRecord = phiPercentiles(data_grainSizeResults);
folkWardStats(data_grainSizeResults, phiPercentileRecord)
methodOfMoments(data_grainSizeResults)
%% SAVE THE RESULTS
saveResults(sample_long_name)