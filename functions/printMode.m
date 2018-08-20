function printMode(new_mass_timeseries,M)
%PRINTMODE Prints the mode of the PHI sizes
F = -1:0.25:4;
F = F(:);
L = new_mass_timeseries.cumulative_percent;
mode = F(M);
cum_wt_percent = L(M);
fprintf('MODE =  %.2f PHI      %.2f Cumulative Weight %%\n', ...
    mode,cum_wt_percent);
end

