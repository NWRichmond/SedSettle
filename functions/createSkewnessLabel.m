%% ASSIGN SKEWNESS LABELS
function skewnessLabel = createSkewnessLabel(skewness)
    if skewness > 0.3
        skewnessLabel = "STRONGLY FINE SKEWED";
    elseif (skewness > 0.1 && skewness >= 0.3)
        skewnessLabel = "FINE SKEWED";
    elseif (skewness > -0.1 && skewness >= 0.1)
        skewnessLabel = "NEAR SYMMETRICAL";
    elseif (skewness > -0.3 && skewness >= -0.1)
        skewnessLabel = "COARSE SKEWED";
    elseif (skewness >= -1)
        skewnessLabel = "STRONGLY COARSE SKEWED";
    else
        warning('Unknown skewness.')
    end
end