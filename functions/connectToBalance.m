%% Instrument Connection
function mass_balance = connectToBalance(COM_port)
% Establish connection with the balance
    % Find a serial port object.
    mass_balance = instrfind('Type', 'serial', 'Port', COM_port, 'Tag', '');

    % Create the serial port object if it does not exist
    if isempty(mass_balance)
        mass_balance = serial(COM_port);
    else % otherwise use the object that was found.
        fclose(mass_balance);
        mass_balance = mass_balance(1);
    end

    % Connect to instrument object, mass_balance.
    fopen(mass_balance);
end