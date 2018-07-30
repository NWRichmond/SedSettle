%% COMPARE DATA TO EXPECTED PHI TIMES
function [ new_mass_timeseries ] = compareExpectedMeasuredPhi(mass_timeseries, expected_kinematics)
    interval_weight = zeros(20,1);
    phi = -1;
    fprintf('%s\n', ...
            'phi      t_expected t_observed   interval_weight');
    for i = 1:size(expected_kinematics,1)
        measured_mass = mass_timeseries.mass;
        measured_time = mass_timeseries.time;
        expected_time = expected_kinematics.phiT;
        low = expected_time(i) - 0.03;
        for j = 1:size(mass_timeseries,1)
            if measured_time(j) >= low
                measured_time(i) = measured_time(j);
                measured_mass(i) = measured_mass(j);
                if i == 1
                    interval_weight(i) = 0;
                elseif i > 1
                    interval_weight(i) = measured_mass(i) - measured_mass(i-1);
                end
                if interval_weight(i) < 0
                    interval_weight = 0;
                end
            end
        end
        fprintf('%.2f    %.1f        %.1f        %.1f\n', ...
            phi,expected_time(i),measured_time(i),interval_weight(i));
        phi = phi + 0.25;
    end
    new_mass_timeseries.time = measured_time;
    new_mass_timeseries.mass = measured_mass;
    new_mass_timeseries.interval_weight = interval_weight;
end