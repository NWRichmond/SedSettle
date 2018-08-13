%% COMPARE DATA TO EXPECTED PHI TIMES
function new_mass_timeseries = compareExpectedMeasuredPhi(mass_timeseries, expected_kinematics)
    interval_weight = zeros(size(expected_kinematics,1),1);
    phi = -1;
    fprintf('%s\n', ...
            'phi      t_expected t_observed   interval_weight');
    measured_mass = mass_timeseries.mass; % QQ
    measured_time = mass_timeseries.time; % T
    expected_time = expected_kinematics.phiT; % PHIT
    for i = 1:size(expected_kinematics,1) % 1:21

        low = expected_time(i) - 0.03;
        for j = 1:size(mass_timeseries,1) % 1:1000
            if measured_time(j) >= low
                measured_time(i) = measured_time(j);
                break
            end
        end
        measured_mass(i) = measured_mass(j);
        if i == 1
            interval_weight(i) = 0;
        elseif i > 1
            interval_weight(i) = measured_mass(i) - measured_mass(i-1);
        end
        if interval_weight(i) < 0
            interval_weight(i) = 0;
        end
        fprintf('%.2f    %.2f        %.2f        %.2f\n', ...
            phi,expected_time(i),measured_time(i),interval_weight(i));
        phi = phi + 0.25;
    end
    new_mass_timeseries.time = measured_time(1:i);
    new_mass_timeseries.mass = measured_mass(1:i);
    new_mass_timeseries.interval_weight = interval_weight(1:i);
end