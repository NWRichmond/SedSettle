function grainStatistics(dry_weight, mass_timeseries)
    immersed_weight = dry_weight / 1.65; % E
    interval_weight = mass_timeseries.interval_weight; % WT
    cumulative_weight = zeros(size(-1:0.25:4,2),1);
    j = 0;
    for i = -1:0.25:4
        j = j + 1;
        if j == 1
            cumulative_weight(j) = interval_weight(j);
        else
            cumulative_weight(j) = cumulative_weight(j-1) + interval_weight(j);
        end
    end
    percent_weight_error = ((cumulative_weight(end) / immersed_weight) - 1) * 100;
    if (abs(percent_weight_error) > 5)
        disp('Weight Error is >5%')
    end
    fprintf('\nTotal Immersed Weight (grams): \t\t%.2f\n', immersed_weight);
    fprintf('\nCumulative Total Weight (grams):\t%.2f\n', cumulative_weight(end));
    fprintf('\nPercent Weight Error: \t\t\t%.2f\n', percent_weight_error);
    fprintf('\n');
end