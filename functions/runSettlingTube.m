function results = runSettlingTube(SampleVars, STvars)
% RUNSETTLINGTUBE drives the data collection process from the digital mass
%   balance. The process is driven using a timer. 
    if SampleVars.minutes < (21/60)
        minutes = (21/60); % why is a minimum time specified here?
    else
        minutes = SampleVars.minutes;
    end
    samplingInterval = 0.1; % how often the data is collected (seconds)
    [mass_balance, initialReading] = connectToBalance;
    figHandle = figure('Name','Accumulated Sediment','NumberTitle','off');
    set(gcf,'Visible','on')
    firstbeeps = 10;
    secondbeeps = 4;
    time_between_beeps = 2;
    
    t1 = timer();
    t1.StartDelay = time_between_beeps * (firstbeeps + secondbeeps + 1);
    t1.ExecutionMode = 'fixedRate';
    t1.TasksToExecute = (60*minutes)/samplingInterval;
    t1.Period = samplingInterval;
    t1.UserData = cell(1,3);
    t1.UserData{1,1} = zeros(60*minutes,2);
    t1.UserData{1,3} = figHandle;
    t1.TimerFcn = @(~,~)collectMass(t1, mass_balance, initialReading, figHandle);
    t1.StartFcn = @(~,~)startSounds(firstbeeps, secondbeeps, time_between_beeps);
    t1.StopFcn = {@closeCollection, mass_balance};
    
    t0 = timer();
    t0.ExecutionMode = 'singleShot';
    t0.TimerFcn = @(~,~)waitfor(msgbox('Press OK to begin the Settling Tube data collection.'));
    t0.StopFcn = @(~,~)start(t1);

    start(t0)
    wait(t1)
    [kvel,phiT,~] = settlingVelocity(STvars);
    t1.UserData{1,2} = [kvel,phiT];
    data_out = t1.UserData;
    data_mass_timeseries = array2table(data_out{1}, ...
        'VariableNames',{'time','mass'});
    data_expected_kinematics = array2table(data_out{2}, ...
        'VariableNames',{'velocity','phiT'});
    figHandle = data_out{3};
    stop(t1)
    new_mass_timeseries = compareExpectedMeasuredPhi(data_mass_timeseries, ...
        data_expected_kinematics);
    results.grainSizeResults = new_mass_timeseries;
    results.massPlot = figHandle;
    results.dataMassTimeseries = data_mass_timeseries;
    results.dataExpectedKinematics = data_expected_kinematics;
end