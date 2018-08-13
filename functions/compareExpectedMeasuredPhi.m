%% COMPARE DATA TO EXPECTED PHI TIMES
function new = compareExpectedMeasuredPhi(mass_timeseries, expected_kinematics, water_density, dry_mass)
    interval_weight = zeros(size(expected_kinematics,1),1);
    measured_mass = mass_timeseries.mass; % QQ
    measured_time = mass_timeseries.time; % T
    expected_time = expected_kinematics.phiT; % PHIT
    phi = zeros(size(expected_kinematics,1),1);
    phi(1) = -1;
    new = table;
%     fprintf('%s\n', ...
%             'phi      t_expected t_observed   interval_weight');
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
%         fprintf('%.2f    %.2f        %.2f        %.2f\n', ...
%             phi(i),expected_time(i),measured_time(i),interval_weight(i));
        if i > 1
            phi(i) = phi(i-1) + 0.25;
        end
    end
    new.phi = phi;
    new.diameter_mm = 2.^(-1*phi);
    radius_cm = (new.diameter_mm / 2) * 0.1;
    volume_cm3 = (4 * pi * radius_cm.^3) / 3;
    new.volume_cm3 = volume_cm3;
    new.time_expected = expected_time(1:i);
    new.time_observed = measured_time(1:i);
    new.interval_weight = interval_weight;
    new.cumulative_sum_weight = cumsum(interval_weight);
    new.percent_of_sample = (interval_weight / ...
        max(new.cumulative_sum_weight))*100;
    dry_mass_interval =  (new.percent_of_sample/100) * dry_mass;
    new.dry_mass_interval = dry_mass_interval;
    new.dry_mass_cumulative = cumsum(dry_mass_interval);
    new.interval_volume = 2.65 * dry_mass_interval;
    new.submerged_mass = dry_mass_interval - (water_density * new.interval_volume);
    new.theoretical_cumulative = cumsum(new.submerged_mass);
end