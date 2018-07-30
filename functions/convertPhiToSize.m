%% ASSIGN SIZE LABELS BASED ON PHI SIZE
function sizeLabel = convertPhiToSize(phi)
    if phi < -6 
        sizeLabel = "BOULDERS";
    elseif (phi >= -6 && phi < -2)
        sizeLabel = "COBBLES";
    elseif (phi >= -2 && phi < -1)
        sizeLabel = "PEBBLES";
    elseif (phi >= -1 && phi < 0)
        sizeLabel = "GRANULES";
    elseif (phi >= 0 && phi < 1)
        sizeLabel = "VERY COARSE SAND";
    elseif (phi >= 1 && phi < 2)
        sizeLabel = "COARSE SAND";
    elseif (phi >= 2 && phi < 3)
        sizeLabel = "MEDIUM SAND";
    elseif (phi >= 3 && phi < 4)
        sizeLabel = "FINE SAND";
    elseif (phi >= 4 && phi < 5)
        sizeLabel = "VERY FINE SAND";
    elseif (phi >= 5 && phi < 6)
        sizeLabel = "COARSE SILT";
    elseif (phi >= 6 && phi < 7)
        sizeLabel = "FINE SILT";
    elseif (phi >= 7 && phi < 8)
        sizeLabel = "VERY FINE SILT";
    elseif (phi >8)
        sizeLabel = "CLAY";
    else
        warning('Unknown phi size.')
    end
end