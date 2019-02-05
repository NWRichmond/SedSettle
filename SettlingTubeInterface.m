%% WELCOME TO THE SETTLING TUBE INTERFACE
% TO USE: Set the variables in the 'SETUP' section
% ...and press 'Run' to begin the data collection
%% CLEANUP
clear; clc;
%% SETUP
sampleName = 'ottawa_20-30_test';
drySedimentMass = 9.36; % g
minutes = 0.5; % number of minutes to collect data (default is 10 minutes)
waterTemperature = 24; % degrees C
settlingTubeLength = 203.3; % cm
%% PACKAGE DATA AS STRUCTS
SampleVars = struct('minutes',minutes, ...
    'dry_weight_input',drySedimentMass);
STvars = struct('waterTemperature',waterTemperature, ...
    'st_length',settlingTubeLength);
%% TAKE MEASUREMENTS WITH THE MASS BALANCE
results = runSettlingTube(SampleVars, STvars);
%% RUN THE STATISTICS
grainStatistics(drySedimentMass, results.grainSizeResults)
folkWardStats(results.grainSizeResults, phiPercentiles(results.grainSizeResults))
methodOfMoments(results.grainSizeResults)
%% PLOT RESULTS
results.massPlot = plotMass(results.massPlot, results.dataMassTimeseries);
cumulativeCurvePlot = plotCumulativeCurve(results.grainSizeResults);
phiSizeDistribution = plotPhiDistribution(results.grainSizeResults);
%% SAVE RESULTS
% NOTE: This happens automatically if you are in the SedSettle directory
sampleLongName = strcat(sampleName,'_', ...
    string(datetime('now','Format','d-MMM-y_HH:mm')));
pwdParts = strsplit(pwd,'/');
if strcmp(pwdParts(end), 'SedSettle') == 1
    workspaceOut = fullfile('results',sampleLongName);
else % if not in the SedSettle directory, prompt to choose a save location
    msgbox('Select a directory to save the SedSettle results in.')
    selpath = uigetdir(pwd,'Select save location for SedSettle results');
    workspaceOut = fullfile(selpath,sampleLongName);
end
warning('off','MATLAB:Figure:FigureSavedToMATFile')
save(strcat(workspaceOut,'.mat'))
disp('Settling tube data collection COMPLETE')