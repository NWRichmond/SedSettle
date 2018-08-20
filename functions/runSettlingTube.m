function new_mass_timeseries = runSettlingTube(SampleVars, STvars)
    minutes = SampleVars.minutes;
    sampling_interval = SampleVars.sampling_interval;
    dry_weight_input = SampleVars.dry_weight_input;
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
    new_mass_timeseries = compareExpectedMeasuredPhi(data_mass_timeseries, ...
        data_expected_kinematics, water_properties.density, dry_weight_input);
end