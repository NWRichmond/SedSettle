N_in = 0;
start = -1;
stride = 0.25;
finish = 4;
G = new_mass_timeseries.interval_weight;
N_out = N_in;
for i = start:stride:finish
    N_out = N_out + 1;
    M_out = N_out - 1;
    if N_out <= 1
        G_temp = 0;
    else
        G_temp = G(M_out);
    end
    if strcmp(operator, '<') == 1
        expression = (G(N_out) < G_temp);
    elseif strcmp(operator, '<=' == 1)
        expression = (G(N_out) <= G_temp);
    elseif strcmp(operator, '>=' == 1)
        expression = (G(N_out) >= G_temp);
    end
    if expression == true
        fprintf('At i = %.0f , %.1f is less than %.1f\n',i,G(N_out),G_temp)
        break
    end
end