function [red] = individual_find_red(i_data, avg, range)
%% Calculates the red values of the individual experiment
% Red values are the average euclidean distance of the samples of a 
% certain key to the average vector of that key
%   param i_data: the individual data
%   param avg: the average vector
%   param range: the range of samples to be considered
dist = 0;
n = range(2) - range(1) + 1;
for s = range(1): range(2)
    dist = dist + norm(i_data{s} - avg);
end
red = (dist/n);
