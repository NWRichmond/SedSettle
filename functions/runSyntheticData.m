function [new_mass_timeseries, figHandle] = runSyntheticData(STvars,minutes,sampling_interval)
% Use artificial data instead of data collected with the settling tube
    x = (0:sampling_interval:((60*minutes)-sampling_interval)); % time in seconds
    x = x(:);
    y = cumsum(gaussmf(x,[80 120])/33); % cumulative sum of gaussian distribution
    immersed_mass_record = [x (y/1.65)];
    dry_weight_input = max(y);
    [kvel,phiT, water_properties] = settlingVelocity(STvars);
    vel = [kvel phiT];
    data_mass_timeseries = array2table(immersed_mass_record, ...
        'VariableNames',{'time','mass'});
    data_expected_kinematics = array2table(vel, ...
        'VariableNames',{'velocity','phiT'});
    new_mass_timeseries = compareExpectedMeasuredPhi(data_mass_timeseries, ...
        data_expected_kinematics, water_properties.density, dry_weight_input);
    figHandle = figure('Name','Accumulated Sediment','NumberTitle','off');
    plotMass(figHandle,[x y],sampling_interval);
end