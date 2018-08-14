%% Instrument Connection
function mass_balance = connectToBalance(COM_port)
% Establish connection with the balance
% Note that 'COM3' is a typical Windows COM port,
% whereas on MacOS, the typical port is preceded by
% '/dev/cu.usbserial' and is likely followed by an 8-character
% alphanumeric code, e.g., "/dev/cu.usbserial-DN02DXXM"
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