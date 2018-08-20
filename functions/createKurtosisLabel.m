%% ASSIGN KURTOSIS LABELS
function kurtosisLabel = createKurtosisLabel(kurtosis)
    if kurtosis < 0.67
        kurtosisLabel = "VERY PLATYKURTIC";
    elseif (kurtosis < 0.9 && kurtosis >= 0.67)
        kurtosisLabel = "PLATYKURTIC";
    elseif (kurtosis < 1.11 && kurtosis >= 0.9)
        kurtosisLabel = "MESOKURTIC";
    elseif (kurtosis < 1.5 && kurtosis >= 1.11)
        kurtosisLabel = "LEPTOKURTIC";
    elseif (kurtosis <= 3 && kurtosis >= 1.5)
        kurtosisLabel = "VERY LEPTOKURTIC";
    elseif (kurtosis > 3)
        kurtosisLabel = "EXTREMELY LEPTOKURTIC";
    else
        warning('Unknown skewness.')
    end
end