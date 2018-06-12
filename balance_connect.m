%% Setup
minutes = 0.5; % number of minutes to collect data

%% Instrument Connection

% Find a serial port object.
mass_balance = instrfind('Type', 'serial', 'Port', 'COM3', 'Tag', '');

% Create the serial port object if it does not exist
% otherwise use the object that was found.
if isempty(mass_balance)
    mass_balance = serial('COM3');
else
    fclose(mass_balance);
    mass_balance = mass_balance(1);
end

% Connect to instrument object, mass_balance.
fopen(mass_balance);

mass_record = zeros(60*minutes,2);
plot_mass(mass_record)

% Take measurements every second for the total duration ('minutes')
t = timer();
t.ExecutionMode = 'fixedRate';
t.Period = 1;
t.TasksToExecute = 60*minutes;
t.UserData = zeros(60*minutes,2);
t.TimerFcn = {@collect_mass, mass_balance, t};
t.StopFcn = {@close_instrument, mass_balance, t};
start(t)

%% Define timer callback function for collecting data from the balance
function collect_mass(~, ~, mass_balance, timer)
    seconds = int64(timer.TasksExecuted);
    mass_record = timer.UserData;
    mass_record(seconds,1) = seconds;
    mass_record(seconds,2) = str2double(fscanf(mass_balance));
    timer.UserData = mass_record;
    flushinput(mass_balance); % Flush the data in the input buffer
    mass_record = get(timer, 'UserData');
    plot_mass(mass_record)
end

%% Define timer end function for disconnecting from the mass balance instrument
function close_instrument(~, ~, mass_balance, timer)
    fclose(mass_balance);
    stop(timer)
    mass_record = get(timer, 'UserData');
    plot_mass(mass_record)
end

%% Get the UserData from the timer and plot it
function plot_mass(mass_record)
    dataTable = array2table(mass_record, ...
    'VariableNames',{'Time','Mass'});
    scatter(dataTable.Time,dataTable.Mass, ...
        'MarkerEdgeColor',[0 .5 .5], ...
        'MarkerFaceColor',[0 .7 .7], ...
        'LineWidth',1.5)
    title('Accumulated Sediment Mass vs. Time')
    xlabel('Time (s)')
    ylabel('Mass (g)')
    xlim([0 size(mass_record,1)])
    ylim([0 inf])
    drawnow
end