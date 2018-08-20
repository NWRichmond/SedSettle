function folkWardStats(new_mass_timeseries, phi_percentile_record)
% Calculate the mode, graphic mean, skewness, and kurtosis.
%% MODE
P = phi_percentile_record;
N = 0;
[M,N] = folkWardModeLoop(new_mass_timeseries,-1,4,N,'<','stride',0.25);
printMode(new_mass_timeseries,M)
while N < 20
    [~,N] = folkWardModeLoop(new_mass_timeseries,N,20,N,'>=');
    if N < 20
    [M,~] = folkWardModeLoop(new_mass_timeseries,N,20,N,'<=');
    printMode(new_mass_timeseries,M)
    end
end
fprintf('\nFollowing are the Folk-Ward Statistical Parameters:\n\n');
%% GRAPHIC MEAN
graphic_mean = (P(2) + P(4) + P(6)) / 3;
sizeLabel = convertPhiToSize(graphic_mean);
fprintf('Graphic Mean: \t\t\t\t%.4f\t\t: %s\n',graphic_mean,sizeLabel);
%% GRAPHIC MEAN INCLUDING GRAPHIC STANDARD DEVIATION
incl_std_dev = (P(6) - P(2)) / 4 + (P(7) - P(1)) / 6.6;
sortingLabel = convertStdDevToSorting(incl_std_dev);
fprintf('Including Graphic Standard Deviation: \t%.4f\t\t: %s\n', ...
    incl_std_dev,sortingLabel);
%% GRAPHIC MEAN INCLUDING GRAPHIC SKEWNESS
skew_1 = (P(2) + P(6) - (2 * P(4))) / (2 * (P(6) - P(2)));
skew_2 = (P(1) + P(7) - (2 * P(4))) / (2 * (P(7) - P(1)));
skewness = skew_1 + skew_2;
skewnessLabel = createSkewnessLabel(skewness);
fprintf('Including Graphic Standard Deviation: \t%.4f\t\t: %s\n', ...
    skewness,skewnessLabel);
%% GRAPHIC KURTOSIS
kurtosis = (P(7) - P(1)) / (2.44 * (P(5) - P(3)));
kurtosisLabel = createKurtosisLabel(kurtosis);
fprintf('Graphic Kurtosis: \t\t\t%.4f\t\t: %s\n',kurtosis,kurtosisLabel);
%% NORMALIZED KURTOSIS
normalized_kurtosis = kurtosis / (1 + kurtosis);
fprintf('Normalized Kurtosis: \t\t\t%.4f\n\n',normalized_kurtosis);
end
