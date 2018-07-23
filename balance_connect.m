%% Notes
% T is timer
% Q is mass read from the balance
% 
%% Setup
minutes = 0.1; % number of minutes to collect data
sampling_interval = 0.25; % how often should the data be collected (seconds)?
sample_number = 1;
water_temp = 25; % degrees C
settling_tube_length = 203.3; % cm
STvars = struct('water_temp',water_temp,'st_length',settling_tube_length);

%% Take measurements at a specified sampling interval
%   Time increment defined by 'sampling_interval'
%   Total duration of sampling period is defined by 'minutes'
mass_balance = connectToBalance('COM3');
t = timer();
t.ExecutionMode = 'fixedRate';
t.TasksToExecute = (60*minutes)/sampling_interval;
t.Period = sampling_interval;
t.UserData = zeros(60*minutes,2);
t.TimerFcn = {@collect_mass, mass_balance, t, sampling_interval};
t.StopFcn = {@close_collection, mass_balance, t, sampling_interval, STvars};
start(t)
wait(t)
data_out = t.UserData;
data_mass_timeseries = array2table(data_out{1}, ...
    'VariableNames',{'time','mass'});
data_expected_kinematics = array2table(data_out{2}, ...
    'VariableNames',{'velocity','phiT'});
stop(t)

%% Instrument Connection
function mass_balance = connectToBalance(COM_port)
% Establish connection with the balance
    % Find a serial port object.
    mass_balance = instrfind('Type', 'serial', 'Port', COM_port, 'Tag', '');

    % Create the serial port object if it does not exist
    if isempty(mass_balance)
        mass_balance = serial(COM_port);
    else % otherwise use the object that was found.
        fclose(mass_balance);
        mass_balance = mass_balance(1);
    end

    % Connect to instrument object, mass_balance.
    fopen(mass_balance);
end

%% Define timer callback function for collecting data from the balance
function collect_mass(~, ~, mass_balance, timer, sampling_interval)
% 'TimerFcn' for the timer
    seconds = int64(timer.TasksExecuted);
    mass_record = timer.UserData;
    mass_record(seconds,1) = double(seconds)*sampling_interval;
    disp(fscanf(mass_balance))
    mass_record(seconds,2) = str2double(fscanf(mass_balance));
    timer.UserData = mass_record;
    flushinput(mass_balance); % Flush the data in the input buffer
    mass_record = get(timer, 'UserData');
    plot_mass(mass_record, sampling_interval)
end

%% PERFORM ACTIONS AFTER FINISHED RECORDING MASS
function close_collection(~, ~, mass_balance, timer, sampling_interval, STvars)
% 'StopFcn' for the timer
    fclose(mass_balance); % Terminate connection with the mass balance
    mass_record = get(timer, 'UserData');
    plot_mass(mass_record, sampling_interval)
    settling_tube_length = STvars.st_length;
    water_temp = STvars.water_temp;
    [kvel,phiT] = settlingVelocity(water_temp, settling_tube_length);
    timer.UserData = {timer.UserData,[kvel,phiT]};
end

%% PLOT MASS VS. TIME
function plot_mass(mass_record, sampling_interval)
% Create a plot of Mass vs. Time
    dataTable = array2table(mass_record, ...
    'VariableNames',{'Time','Mass'});
    scatter(dataTable.Time,dataTable.Mass, ...
        'MarkerEdgeColor',[0 .5 .5], ...
        'MarkerFaceColor',[0 .7 .7], ...
        'LineWidth',1.5)
    title('Accumulated Sediment Mass vs. Time')
    xlabel('Time (s)')
    ylabel('Mass (g)')
    xlim([0 size(mass_record,1)*sampling_interval])
    ylim([0 inf])
    drawnow
end

%% CALCULATE SETTLING VELOCITY
function [kvel,phiT] = settlingVelocity(water_temp, settling_tube_length)
% Calculate settling velocities for 1/4 phi intervals
%   NOTE: Density and Viscosity interploation is valid only for 16-30 degC
    density = 1.002878 - (0.000236 * water_temp);
    kinVisc = 1.657 * exp(-0.0248 * water_temp);
    dynVisc = kinVisc / (density * 100);
    diamm = zeros(20,1);
    rcm = zeros(20,1);
    kvel = zeros(20,1);
    phiT = zeros(20,1);
    for i = 1:20
        if i == 1
            diamm(i) = 2.37841423;
        else
            diamm(i) = diamm(i-1) / sqrt(sqrt(2));
        end
        rcm(i) = diamm(i) * 0.05;
        % Gibbs Settling Equation after Komar, 1981
        gibbs_a = -3 * dynVisc;
        gibbs_b = 9 * dynVisc^2;
        gibbs_c = 981 * rcm(i)^2 * (density * (2.65 - density));
        gibbs_d = 0.015476 + 0.19841 * rcm(i);
        gibbs_e = density * (.011607 + .14881 * rcm(i));
        % Komar correction for velocity = 1.0269 below
        kvel(i) = 1.0269 * (gibbs_a + sqrt(gibbs_b + gibbs_c * gibbs_d)) / gibbs_e;
        % Phi Settling Time = Tube Length / Velocity
        phiT(i) = settling_tube_length / kvel(i);
    end
end

%% COMPARE DATA TO EXPECTED PHI TIMES
function [ new_mass_timeseries ] = compareExpectedMeasuredPhi(mass_timeseries, expected_kinematics)
    interval_weight = zeros(20,1);
    phi = -1;
    for i = 1:size(expected_kinematics,1)
        measured_time = mass_timeseries.time;
        measured_mass = mass_timeseries.mass;
        expected = expected_kinematics.phiT;
        low = expected(i) - 0.03;
        for j = 1:size(mass_record,1)
            if measured_time(j) >= low
                measured_time(i) = measured_time(j);
                measured_mass(i) = measured_mass(j);
                interval_weight = measured_mass(i) - measured_mass(i-1);
                if interval_weight(i) < 0
                    interval_weight = 0;
                end
            end
        end
        phi = phi + 0.25;
    end
    new_mass_timeseries.time = measured_time;
    new_mass_timeseries.mass = measured_mass;
    new_mass_timeseries.interval_weight = interval_weight;
end
%% ASSIGN SIZE LABELS BASED ON PHI SIZE
function sizeLabel = convertPhiToSize(phi)
    switch phi
        case phi <= -8 
            sizeLabel = "BOULDERS";
        case (phi <= -6 & phi > -2)
            sizeLabel = "COBBLES";
        case (phi <= -2 & phi > -1)
            sizeLabel = "PEBBLES";
        case (phi <= -1 & phi > 0)
            sizeLabel = "GRANULES";
        case (phi <= -1 & phi > 0)
            sizeLabel = "VERY COARSE SAND";
        case (phi <= -1 & phi > 0)
            sizeLabel = "GRANULES";
        otherwise
            warning('Unexpected plot type. No plot created.')
    end
end