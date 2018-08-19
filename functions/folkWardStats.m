function folkWardStats(new_mass_timeseries)
% Calculate the mode, graphic mean, skewness, and kurtosis.
F = -1:0.25:4;
F = F(:);
G = new_mass_timeseries.interval_weight;
L = new_mass_timeseries.cumulative_percent;
N = 0;
for i = -1:0.25:4
    N = N + 1;
    M = N - 1;
    if N <= 1
        G_temp = 0;
    else
        G_temp = G(M);
    end
    if (G(N) < G_temp)
        mode = F(M);
        cum_wt_percent = L(M);
        fprintf('MODE =  %.2f PHI      %.2f Cumulative Weight %%\n', ...
            mode,cum_wt_percent)
        fprintf('N=%.0f \n',N)
        break
    end
end
Z = 20;
for j = N:Z
    N = N + 1;
    M = N - 1;
    if N <= 1
        G_temp = 0;
    else
        G_temp = G(M);
    end
    if (G(N) >= G_temp)
        for k = N:Z
            N = N + 1;
            M = N - 1;
            if (G(N) <= G(M))
                % print 1640 here
            end
        end
        break
    end
end


end
