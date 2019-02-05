%% Instrument Connection
function [mass_balance, initialReading] = connectToBalance
% Establish connection with the balance
    % Find a serial port object.
    if ismac
        serials = seriallist;
        COM_port = serials(contains(serials,'cu.usbserial'));
    elseif isunix
        serials = seriallist;
        COM_port = serials(contains(serials,'cu.usbserial'));
    elseif ispc
        serials = seriallist;
        COM_port = serials(contains(serials,'COM3'));
    else
        disp('Platform not supported')
    end
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
    
    % Take an initial reading for taring purposes
    initialReading = str2double(erase(fscanf(mass_balance),'?'));
end