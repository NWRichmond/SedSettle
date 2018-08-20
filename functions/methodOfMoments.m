function methodOfMoments(new_mass_timeseries)
%METHODOFMOMENTS calculates the mean x, variance, skewness, standard
%deviation, and kurtosis
G = new_mass_timeseries.interval_weight;
F = -1:0.25:4;
F = F(:);
XX = 0;
GG = 0;
PP = 0;
QQ = 0;
RR = 0;
N = 0;
for k = -1:0.25:4
    N = N + 1;
    XX = XX + (F(N) * G(N));
    GG = GG + G(N);
end
MM = XX / GG;
N = 0;
for k = -1:0.25:4
    N = N + 1;
    PP = PP + (G(N) * (F(N) - MM) ^ 2);
	QQ = QQ + (G(N) * (F(N) - MM) ^ 3);
	RR = RR + (G(N) * (F(N) - MM) ^ 4);
end
M2 = PP / GG;
DD = sqrt(M2);
% *** SKEWNESS = M3/(M2^1.5) ***
M3 = QQ / GG;
SS = M3 / (M2 ^ 1.5);
% *** FOURTH MOMENT: KURTOSIS = M4/(M2^2) ***
M4 = RR / GG;
KK = M4 / (M2 ^ 2);

fprintf('MEAN X =\t\t%.4f\n',MM);
fprintf('VARIANCE =\t\t%.4f\n',M2);
fprintf('SKEWNESS =\t\t%.4f\n',SS);
fprintf('STD DEVIATION =\t\t%.4f\n',DD);
fprintf('KURTOSIS =\t\t%.4f\n\n',KK);
end

