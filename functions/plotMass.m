%% PLOT MASS VS. TIME
function plotMass(figHandle, mass_record, sampling_interval)
% Create a plot of Mass vs. Time
    figure(figHandle)
    dataTable = array2table(mass_record, ...
    'VariableNames',{'Time','Mass'});
    dataTable.Mass(dataTable.Mass < 0) = 0; % adjust for minor issues with
        % zeroing the balance, should it zero to a slightly negative value
    scatter(dataTable.Mass,dataTable.Time, ...
        'MarkerEdgeColor',[0 .5 .5], ...
        'MarkerFaceColor',[0 .7 .7], ...
        'LineWidth',1.5)
    set(gca,'Ydir','reverse')
    title('Accumulated Sediment Mass vs. Time')
    xlabel('Mass (g)')
    ylabel('Time (s)')
    xlim([0 inf])
    ylim([0 size(mass_record,1)*sampling_interval])
    drawnow
end