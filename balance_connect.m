%% Setup
minutes = 0.2; % number of minutes to collect data

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
dataTable = array2table(mass_record,...
    'VariableNames',{'Time','Mass'});
mass_plot = scatter(dataTable.Time,dataTable.Mass);
drawnow
%mass_record(:,1) = 1:size(mass_record,1);

% Take measurements every second for the total duration ('minutes')
t = timer();
t.ExecutionMode = 'fixedRate';
t.Period = 1;
t.TasksToExecute = 60*minutes;
t.UserData = zeros(60*minutes,2);
t.TimerFcn = {@collect_mass, mass_balance, t};
t.StopFcn = {@close_instrument, mass_balance, t};
start(t)

while strcmp(t.Running,'on') == 1
    mass_record = get(t, 'UserData');
    dataTable = array2table(mass_record,...
    'VariableNames',{'Time','Mass'});
    scatter(dataTable.Time,dataTable.Mass)
    drawnow
end
if strcmp(t.Running,'off') == 1
    mass_record = get(t, 'UserData');
    dataTable = array2table(mass_record,...
    'VariableNames',{'Time','Mass'});
    scatter(dataTable.Time,dataTable.Mass)
end

%% Define timer callback function for collecting data from the balance
function collect_mass(~, ~, mass_balance, timer)
    seconds = int64(timer.TasksExecuted);
    mass_record = timer.UserData;
    mass_record(seconds,1) = seconds;
    mass_record(seconds,2) = str2double(fscanf(mass_balance));
    timer.UserData = mass_record;
    flushinput(mass_balance); % Flush the data in the input buffer
    dataTable = array2table(mass_record,...
    'VariableNames',{'Time','Mass'});
    scatter(dataTable.Time,dataTable.Mass)
end

%% Define timer end function for disconnecting from the mass balance instrument
function close_instrument(~, ~, mass_balance, timer)
    fclose(mass_balance);
    stop(timer)
end