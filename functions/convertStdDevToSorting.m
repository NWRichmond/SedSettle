%% ASSIGN SORTING LABELS BASED ON GRAHIC STANDARD DEVIATION
function sortingLabel = convertStdDevToSorting(std_dev)
    if std_dev < -0.35
        sortingLabel = "VERY WELL SORTED";
    elseif (std_dev < 0.5 && std_dev >= -0.35)
        sortingLabel = "WELL SORTED";
    elseif (std_dev < 0.71 && std_dev >= -0.5)
        sortingLabel = "MODERATELY WELL SORTED";
    elseif (std_dev < 1 && std_dev >= -0.71)
        sortingLabel = "MODERATELY SORTED";
    elseif (std_dev < 2 && std_dev >= 1)
        sortingLabel = "POORLY SORTED";
    elseif (std_dev < 4 && std_dev >= 2)
        sortingLabel = "VERY POORLY SORTED";
    elseif (std_dev >4)
        sortingLabel = "EXTREMELY POORLY SORTED";
    else
        warning('Unknown standard deviation.')
    end
end