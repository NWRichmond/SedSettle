function [new_mass_timeseries, figHandle, data_mass_timeseries, data_expected_kinematics] = runSettlingTube(SampleVars, STvars)
% RUNSETTLINGTUBE drives the data collection process from the digital mass
%   balance. The process is driven using a timer. 
    minutes = SampleVars.minutes;
    sampling_interval = SampleVars.sampling_interval;
    mass_balance = connectToBalance;
    figHandle = figure('Name','Accumulated Sediment','NumberTitle','off');
    firstbeeps = 10;
    secondbeeps = 4;
    time_between_beeps = 2;
    t = timer();
    t.StartDelay = time_between_beeps * (firstbeeps + secondbeeps + 1);
    t.ExecutionMode = 'fixedRate';
    t.TasksToExecute = (60*minutes)/sampling_interval;
    t.Period = sampling_interval;
    t.UserData = cell(1,3);
    t.UserData{1,1} = zeros(60*minutes,2);
    t.UserData{1,3} = figHandle;
    t.TimerFcn = {@collectMass, mass_balance, t, sampling_interval, figHandle};
    t.StartFcn = {@startSounds, firstbeeps, secondbeeps, time_between_beeps};
    t.StopFcn = {@closeCollection, mass_balance};
    start(t)
    wait(t)
    [kvel,phiT,~] = settlingVelocity(STvars);
    t.UserData{1,2} = [kvel,phiT];
    data_out = t.UserData;
    data_mass_timeseries = array2table(data_out{1}, ...
        'VariableNames',{'time','mass'});
    data_expected_kinematics = array2table(data_out{2}, ...
        'VariableNames',{'velocity','phiT'});
    figHandle = data_out{3};
    stop(t)
    new_mass_timeseries = compareExpectedMeasuredPhi(data_mass_timeseries, ...
        data_expected_kinematics);
end