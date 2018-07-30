%% Define timer callback function for collecting data from the balance
function collectMass(~, ~, mass_balance, timer, sampling_interval)
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