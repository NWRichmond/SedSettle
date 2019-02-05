%% PLOT MASS VS. TIME
function figHandle = plotMass(figHandle, mass_record, varargin)
% Create a plot of Mass vs. Time
    if isvalid(figHandle)
        figure(figHandle)
    else
        figHandle = figure('Name','Accumulated Sediment','NumberTitle','off');
    end
    if isnumeric(mass_record) == 1
        dataTable = array2table(mass_record, ...
        'VariableNames',{'time','mass'});
    elseif istable(mass_record)
        dataTable = mass_record;
    end
    dataTable.mass(dataTable.mass < 0) = 0; % adjust for minor issues with
        % zeroing the balance, should it zero to a slightly negative value
    scatter(dataTable.mass,dataTable.time, ...
        'MarkerEdgeColor',[0 .5 .5], ...
        'MarkerFaceColor',[0 .7 .7], ...
        'LineWidth',1.5)
    set(gca,'Ydir','reverse')
    title('Accumulated Sediment Mass vs. Time')
    xlabel('Mass (g)')
    ylabel('Time (s)')
    xlim([0 inf])
    if ~isempty(varargin)
        samplingInterval = varargin{1};
        ylim([0 size(mass_record,1)*samplingInterval])
    end
    drawnow
end