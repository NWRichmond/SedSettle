%% Define timer callback function for collecting data from the balance
function collectMass(timer, mass_balance, initialReading, figHandle)
% 'TimerFcn' for the timer
    seconds = int64(timer.TasksExecuted);
    mass_record = timer.UserData{1,1};
    mass_record(seconds,1) = double(seconds)*timer.Period;
    mass_record(seconds,2) = str2double(erase(fscanf(mass_balance),'?'));
    if seconds < 2
        mass_record(seconds,2) = 0; % allow 2 seconds to initialize
    else
        reading = str2double(erase(fscanf(mass_balance),'?')) ...
            - initialReading; % tare based on first measured mass
        if reading < 0
            mass_record(seconds,2) = 0;
        elseif reading > 0
            mass_record(seconds,2) = reading;
        end
    end
    fprintf('%0.2f\n\n',mass_record(seconds,2))
    timer.UserData{1,1} = mass_record;
    timer.UserData{1,3} = figHandle;
    flushinput(mass_balance); % Flush the data in the input buffer
    figHandle = plotMass(figHandle, mass_record, timer.Period);
    timer.UserData{1,3} = figHandle;
end