%% PLOT WEIGHTS AS A PERCENTAGE OF CUMULATIVE TOTAL
function figHandle = plotCumulativeCurve(new_mass_record)
% Create a plot of Mass vs. Time
    figHandle = figure;
    scatter(new_mass_record.cumulative_percent,new_mass_record.phi, ...
        'MarkerEdgeColor',[0 .5 .5], ...
        'MarkerFaceColor',[0 .7 .7], ...
        'LineWidth',1.5)
    set(gca,'Ydir','reverse')
    title('Weights As a Percentage of Cumulative Total')
    xlabel('Percent of Sample')
    ylabel('Phi Size')
    drawnow
end