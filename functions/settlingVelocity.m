%% CALCULATE SETTLING VELOCITY (EXPECTED PHI TIMES)
function [kvel,phiT] = settlingVelocity(water_temp, settling_tube_length)
% Calculate settling velocities for 1/4 phi intervals
%   NOTE: Density and Viscosity interploation is valid only for 16-30 degC
    density = 1.002878 - (0.000236 * water_temp);
    kinVisc = 1.657 * exp(-0.0248 * water_temp);
    dynVisc = kinVisc / (density * 100);
    diamm = zeros(20,1);
    rcm = zeros(20,1);
    kvel = zeros(20,1);
    phiT = zeros(20,1);
    for i = 1:20
        if i == 1
            diamm(i) = 2.37841423;
        else
            diamm(i) = diamm(i-1) / sqrt(sqrt(2));
        end
        rcm(i) = diamm(i) * 0.05;
        % Gibbs Settling Equation after Komar, 1981
        gibbs_a = -3 * dynVisc;
        gibbs_b = 9 * dynVisc^2;
        gibbs_c = 981 * rcm(i)^2 * (density * (2.65 - density));
        gibbs_d = 0.015476 + 0.19841 * rcm(i);
        gibbs_e = density * (.011607 + .14881 * rcm(i));
        % Komar correction for velocity = 1.0269 below
        kvel(i) = 1.0269 * (gibbs_a + sqrt(gibbs_b + gibbs_c * gibbs_d)) / gibbs_e;
        % Phi Settling Time = Tube Length / Velocity
        phiT(i) = settling_tube_length / kvel(i);
    end
end