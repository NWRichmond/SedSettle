%% PERFORM ACTIONS AFTER FINISHED RECORDING MASS
function closeCollection(~, ~, mass_balance, timer, sampling_interval, STvars)
% 'StopFcn' for the timer
    load gong.mat y;
    fclose(mass_balance); % terminate connection with the mass balance
    mass_record = timer.UserData{1,1};
    plotMass(mass_record, sampling_interval)
    [kvel,phiT] = settlingVelocity(STvars);
    timer.UserData{1,2} = [kvel,phiT];
    sound(y); % play the gong sound to signal the end of data collection
end