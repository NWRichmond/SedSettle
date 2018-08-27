%% PERFORM ACTIONS AFTER FINISHED RECORDING MASS
function closeCollection(~, ~, mass_balance)
% 'StopFcn' for the timer
    fclose(mass_balance); % terminate connection with the mass balance
    load gong.mat y;
    sound(y); % play the gong sound to signal the end of data collection
end