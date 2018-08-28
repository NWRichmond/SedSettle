%% Define timer callback function for collecting data from the balance
function collectMass(~, ~, mass_balance, timer, sampling_interval, figHandle)
% 'TimerFcn' for the timer
    seconds = int64(timer.TasksExecuted);
    mass_record = timer.UserData{1,1};
    mass_record(seconds,1) = double(seconds)*sampling_interval;
    disp(fscanf(mass_balance))
    mass_record(seconds,2) = str2double(erase(fscanf(mass_balance),'?'));
    timer.UserData{1,1} = mass_record;
    timer.UserData{1,3} = figHandle;
    flushinput(mass_balance); % Flush the data in the input buffer
    plotMass(figHandle, mass_record, sampling_interval);
end