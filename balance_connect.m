%% Setup
sample_number = 1;
minutes = 0.2; % number of minutes to collect data (default is 10 minutes)
sampling_interval = 0.25; % how often should the data be collected (seconds)?
dry_weight_input = 9.456; % g
water_temp = 23; % degrees C
settling_tube_length = 203.3; % cm
SampleVars = struct('minutes',minutes,'sampling_interval',sampling_interval, ...
    'dry_weight_input',dry_weight_input);
STvars = struct('water_temp',water_temp,'st_length',settling_tube_length);
use_dummy_data = true;
%% Create dummy data
% NOTE: This code requires the MATLAB Fuzzy Logic Toolbox
if use_dummy_data == true
    [new_mass_timeseries, mass_plot] = runDummyData(STvars,10,0.6);
end
%% Take measurements at a specified sampling interval
if use_dummy_data == false
    [new_mass_timeseries, mass_plot] = runSettlingTube(SampleVars, STvars);
end
%% RUN THE STATISTICS
grainStatistics(dry_weight_input, new_mass_timeseries)
cumulative_curve_plot = plotCumulativeCurve(new_mass_timeseries);
phiPercentileRecord = phiPercentiles(new_mass_timeseries);
folkWardStats(new_mass_timeseries, phiPercentileRecord)
methodOfMoments(new_mass_timeseries)
