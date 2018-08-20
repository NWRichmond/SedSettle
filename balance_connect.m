%% Notes
% T is time (observed)
% PHIT is expected phi time
% Q is mass read from the balance
% QQ is weight
% WT is interval weight
% G is a copy of WT (interval weight)
% ED is dry weight input
% E is total immersed weight
% F is a record of phi sizes from -1 to 4 in increments of 0.25
% G is a copy of WT, interval weight
% H is Cumulative Total Weight
% HH is a new record of H for use in a new loop
% K is Percent Weight Error
% L is a record of the cumulative weights
% A is percentile (for PHI)
% P is phi size at percentile P

%% Setup
minutes = 0.2; % number of minutes to collect data (default is 10 minutes)
sampling_interval = 0.25; % how often should the data be collected (seconds)?
sample_number = 1;
water_temp = 23; % degrees C
settling_tube_length = 203.3; % cm
STvars = struct('water_temp',water_temp,'st_length',settling_tube_length);
dry_weight_input = 1.23; % g

%% Create dummy data
% NOTE: This code requires the MATLAB Fuzzy Logic Toolbox
use_dummy_data = true;
if use_dummy_data == true
    x = (0:0.6:((60*10)-0.6)); % time in seconds
    x = x(:);
    y = cumsum(gaussmf(x,[80 120])/33); % cumulative sum of gaussian distribution
    mass_record = [x y];
    immersed_mass_record = [x (y/1.65)];
    dry_weight_input = max(y);
    [kvel,phiT, water_properties] = settlingVelocity(water_temp, settling_tube_length);
    vel = [kvel phiT];
    data_mass_timeseries = array2table(immersed_mass_record, ...
        'VariableNames',{'time','mass'});
    data_expected_kinematics = array2table(vel, ...
        'VariableNames',{'velocity','phiT'});
    new_mass_timeseries = compareExpectedMeasuredPhi(data_mass_timeseries, ...
        data_expected_kinematics, water_properties.density, dry_weight_input);
end
%% Take measurements at a specified sampling interval
%   Time increment defined by 'sampling_interval'
%   Total duration of sampling period is defined by 'minutes'
if use_dummy_data == false
    mass_balance = connectToBalance('/dev/cu.usbserial-DN02DXXM');
    t = timer();
    t.ExecutionMode = 'fixedRate';
    t.TasksToExecute = (60*minutes)/sampling_interval;
    t.Period = sampling_interval;
    t.UserData = zeros(60*minutes,2);
    t.TimerFcn = {@collectMass, mass_balance, t, sampling_interval};
    t.StartFcn = @startSounds;
    t.StopFcn = {@closeCollection, mass_balance, t, sampling_interval, STvars};
    start(t)
    wait(t)
    data_out = t.UserData;
    data_mass_timeseries = array2table(data_out{1}, ...
        'VariableNames',{'time','mass'});
    data_expected_kinematics = array2table(data_out{2}, ...
        'VariableNames',{'velocity','phiT'});
    stop(t)
    [kvel,phiT, water_properties] = settlingVelocity(water_temp, settling_tube_length);
    vel = [kvel phiT];
    new_mass_timeseries = compareExpectedMeasuredPhi(data_mass_timeseries, ...
        data_expected_kinematics, water_properties.density, dry_weight_input);
end
%% RUN THE STATISTICS
grainStatistics(dry_weight_input, new_mass_timeseries)
cumulative_curve_plot = plotCumulativeCurve(new_mass_timeseries);
phiPercentiles(new_mass_timeseries)
folkWardStats(new_mass_timeseries)
