function [M_out,N_out] = folkWardModeLoop(new_mass_timeseries, start, finish, N_in, operator, varargin)
% Calculate the mode, graphic mean, skewness, and kurtosis.
%% Parse the input variables
validScalarNum = @(x) isnumeric(x) && isscalar(x);
validStride = @(x) isnumeric(x) && (x > 0) && (x <= 1);
expectedOperators = {'<','<=','>='};
defaultStride = 1;
p = inputParser;
    addRequired(p,'new_mass_timeseries', @(x) istable(x))
    addRequired(p,'start',validScalarNum);
    addRequired(p,'finish',validScalarNum);
    validNvalues = @(x) isnumeric(x) && isscalar(x) && (x >= 0) && (x <= 20);
    addRequired(p,'N_in', validNvalues);
    addRequired(p,'operator', @(x) any(validatestring(x,expectedOperators)));
    addParameter(p,'stride', defaultStride, validStride);
parse(p, new_mass_timeseries, start, finish, N_in, operator, varargin{:});
%% Define variables based on the parsed inputs
new_mass_timeseries = p.Results.new_mass_timeseries;
start = p.Results.start;
finish = p.Results.finish;
N_in = p.Results.N_in;
operator = p.Results.operator;
stride = p.Results.stride;
G = new_mass_timeseries.interval_weight;
N_out = N_in; % initialize N
%% Loop until expression is satisfied
for i = start:stride:finish
    N_out = N_out + 1;
    M_out = N_out - 1;
    if N_out <= 1
        G_temp = 0;
    else
        G_temp = G(M_out);
    end
    if strcmp(operator, '<') == 1
        expression = (G(N_out) < G_temp);
    elseif strcmp(operator, '<=') == 1
        expression = (G(N_out) <= G_temp);
    elseif strcmp(operator, '>=') == 1
        expression = (G(N_out) >= G_temp);
    end
    if expression == true
        break
    end
end
end
