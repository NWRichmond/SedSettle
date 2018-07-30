%% PLOT MASS VS. TIME
function plotMass(mass_record, sampling_interval)
% Create a plot of Mass vs. Time
    dataTable = array2table(mass_record, ...
    'VariableNames',{'Time','Mass'});
    scatter(dataTable.Time,dataTable.Mass, ...
        'MarkerEdgeColor',[0 .5 .5], ...
        'MarkerFaceColor',[0 .7 .7], ...
        'LineWidth',1.5)
    title('Accumulated Sediment Mass vs. Time')
    xlabel('Time (s)')
    ylabel('Mass (g)')
    xlim([0 size(mass_record,1)*sampling_interval])
    ylim([0 inf])
    drawnow
end