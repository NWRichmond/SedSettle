%% Notes
% T is time (observed)
% PHIT is expected phi time
% Q is mass read from the balance
% QQ is weight
% WT is interval weight
% ED is dry weight input
% E is total immersed weight

%% Setup
% NOTE: This code requires the MATLAB Fuzzy Logic Toolbox
minutes = 0.1; % number of minutes to collect data
sampling_interval = 0.25; % how often should the data be collected (seconds)?
sample_number = 1;
water_temp = 25; % degrees C
settling_tube_length = 203.3; % cm
STvars = struct('water_temp',water_temp,'st_length',settling_tube_length);
% Create dummy data
water_temp = 22; % deg C
x = (0:0.6:((60*10)-0.6)); % time in seconds
x = x(:);
y = cumsum(gaussmf(x,[80 120])/33); % cumulative sum of gaussian distribution
mass_record = [x y];
%% Take measurements at a specified sampling interval
%   Time increment defined by 'sampling_interval'
%   Total duration of sampling period is defined by 'minutes'
    % mass_balance = connectToBalance('COM3');
    % t = timer();
    % t.ExecutionMode = 'fixedRate';
    % t.TasksToExecute = (60*minutes)/sampling_interval;
    % t.Period = sampling_interval;
    % t.UserData = zeros(60*minutes,2);
    % t.TimerFcn = {@collectMass, mass_balance, t, sampling_interval};
    % t.StopFcn = {@closeCollection, mass_balance, t, sampling_interval, STvars};
    % start(t)
    % wait(t)
    % data_out = t.UserData;
    % data_mass_timeseries = array2table(data_out{1}, ...
    %     'VariableNames',{'time','mass'});
    % data_expected_kinematics = array2table(data_out{2}, ...
    %     'VariableNames',{'velocity','phiT'});
    % stop(t)

[kvel,phiT] = settlingVelocity(water_temp, settling_tube_length);
vel = [kvel phiT];
data_mass_timeseries = array2table(mass_record, ...
    'VariableNames',{'time','mass'});
data_expected_kinematics = array2table(vel, ...
    'VariableNames',{'velocity','phiT'});
new_mass_timeseries = compareExpectedMeasuredPhi(data_mass_timeseries, ...
    data_expected_kinematics);
