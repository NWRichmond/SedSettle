%% PERFORM ACTIONS AFTER FINISHED RECORDING MASS
function closeCollection(~, ~, mass_balance, timer, sampling_interval, STvars)
% 'StopFcn' for the timer
    load gong.mat y;
    fclose(mass_balance); % Terminate connection with the mass balance
    mass_record = get(timer, 'UserData');
    plotMass(mass_record, sampling_interval)
    [kvel,phiT] = settlingVelocity(STvars);
    timer.UserData = {timer.UserData,[kvel,phiT]};
    sound(y);
end