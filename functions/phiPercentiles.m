function phiPercentiles(new_mass_timeseries)
%PHIPERCENTILES computes the phi percentiles by linear interpolation.
%   Use caution for phi intervals > 0.5.
percentile = [5;16;25;50;75;84;95];
phiPercentile = zeros(7,1);
L = new_mass_timeseries.cumulative_percent;
F = -1:0.25:4;
F = F(:);
for i = 1:7
    N = 0;
        for k = -1:0.25:4
            N = N + 1;
            M = N - 1;
            Ftemp = F(N) - 0.25;
%             if k < 4
                if (L(N) >= percentile(i))
                    phiPercentile(i) = (0.25 * (percentile(i) - L(M)) / (L(N) - L(M))) + Ftemp;
%                     fprintf('percentile:    %.0f%%  , L(M) =  %.2f , L(N) = %.2f , F(M) = %.2f\n', ...
%                     percentile(i),L(M),L(N),F(M));
                end
%             end
        end
        
        
        fprintf('PHI    %.0f%%   =  %.2f\n', ...
             percentile(i),phiPercentile(i));
end

end
