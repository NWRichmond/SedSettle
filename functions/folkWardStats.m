function folkWardStats(new_mass_timeseries)
% Calculate the mode, graphic mean, skewness, and kurtosis.
% G is a copy of WT, interval weight
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


% for i = -1:0.25:4
%     N = N + 1;
%     M = N - 1;
%     if N <= 1
%         G_temp = 0;
%     else
%         G_temp = G(M);
%     end
%     if (G(N) < G_temp)
%         mode = F(M);
%         cum_wt_percent = L(M);
%         fprintf('MODE =  %.2f PHI      %.2f Cumulative Weight %%\n', ...
%             mode,cum_wt_percent)
%         fprintf('N=%.0f \n',N)
%         break
%     end
% end
% Z = 20;
% for j = N:Z
%     N = N + 1;
%     M = N - 1;
%     if (G(N) >= G(M))
%         for k = N:Z
%             N = N + 1;
%             M = N - 1;
%             if (G(N) <= G(M))
%                 mode = F(M);
%                 cum_wt_percent = L(M);
%                 fprintf('MODE =  %.2f PHI      %.2f Cumulative Weight %%\n', ...
%                     mode,cum_wt_percent)
%                 fprintf('N=%.0f \n',N)
%             end
%         end
%         break
%     end
% end


end
