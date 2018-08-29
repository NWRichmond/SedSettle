function saveResults(fname)
%SAVERESULTS helps to save results either in the default 'results'
%directory or in a custom location.
pwd_parts = strsplit(pwd,'/');
if strcmp(pwd_parts(end), 'SedSettle') == 1
    fileOut = fullfile('results',fname);
else
    msgbox('Select a directory to save the SedSettle results in.')
    selpath = uigetdir(pwd,'Select save location for SedSettle results');
    fileOut = fullfile(selpath,fname);
end
save(strcat(fileOut,'.mat'))

end
