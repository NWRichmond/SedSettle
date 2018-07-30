%% GRAINSIZE STATISTICS
function grainsizeStatistics(dry_weight_input)
    B = -1;
    C = 4;
    D = 0.25;
    G = zeros(20);
    H = 0; % Cumulative total weight
    N = 0;
    total_immersed_weight = dry_weight_input / 1.65;
    for F = B:D:C % from B to C in increments of D
       N = N + 1;
       G(N) = WT(N);
       H = H + G(N);
    end
    K = ((H / total_immersed_weight) - 1) * 100;
    if (abs(K) > 5)
        disp('Weight Error is >5%')
    end
end