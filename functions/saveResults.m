function saveResults(fname)
%SAVERESULTS helps to save results either in the default 'results'
%directory or in a custom location.
pwd_parts = strsplit(pwd,'/');
if strcmp(pwd_parts(end), 'SedSettle') == 1
    fileOut = fullfile('results',fname);
    save(fileOut)
else
    selpath = uigetdir(pwd,'Select save location for SedSettle results');
    fileOut = fullfile(selpath,fname);
    save(fileOut)
end

end
