%% PERFORM ACTIONS AFTER FINISHED RECORDING MASS
function closeCollection(~, ~, mass_balance, timer, sampling_interval, STvars)
% 'StopFcn' for the timer
    fclose(mass_balance); % Terminate connection with the mass balance
    mass_record = get(timer, 'UserData');
    plot_mass(mass_record, sampling_interval)
    settling_tube_length = STvars.st_length;
    water_temp = STvars.water_temp;
    [kvel,phiT] = settlingVelocity(water_temp, settling_tube_length);
    timer.UserData = {timer.UserData,[kvel,phiT]};
end