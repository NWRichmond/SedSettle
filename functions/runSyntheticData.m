function [new_mass_timeseries, figHandle, dry_weight_input] = runSyntheticData(SampleVars, STvars)
% Use artificial data instead of data collected with the settling tube.
%   Requires the Fuzzy Logic Toolbox.
    minutes = SampleVars.minutes;
    sampling_interval = SampleVars.sampling_interval;
    x = (0:sampling_interval:((60*minutes)-sampling_interval)); % time in seconds
    x = x(:);
    y = cumsum(gaussmf(x,[80 120])/99); % cumulative sum of gaussian distribution
        % NOTE: this produces a sediment record just shy of 10 grams
    immersed_mass_record = [x (y/1.65)];
    STvars.dry_weight_input = max(y);
    dry_weight_input = STvars.dry_weight_input;
    [kvel,phiT] = settlingVelocity(STvars);
    vel = [kvel phiT];
    data_mass_timeseries = array2table(immersed_mass_record, ...
        'VariableNames',{'time','mass'});
    data_expected_kinematics = array2table(vel, ...
        'VariableNames',{'velocity','phiT'});
    new_mass_timeseries = compareExpectedMeasuredPhi(data_mass_timeseries, ...
        data_expected_kinematics);
    figHandle = figure('Name','Accumulated Sediment','NumberTitle','off');
    plotMass(figHandle,[x y],sampling_interval);
end