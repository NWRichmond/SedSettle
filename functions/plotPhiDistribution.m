%% PLOT WEIGHTS AS A PERCENTAGE OF CUMULATIVE TOTAL
function figHandle = plotPhiDistribution(new_mass_record)
% Create a plot of Mass vs. Time
    figHandle = figure('Name',' Phi Size Distribution','NumberTitle','off');
    bar(new_mass_record.phi,new_mass_record.percent_of_sample, ...
        'EdgeColor',[0 .5 .5], ...
        'FaceColor',[0 .7 .7])
    title('Phi Size Distribution')
    xlabel('Phi Size')
    ylabel('Percent of Sample')
    xlim([-1.25 4.25])
    drawnow
end