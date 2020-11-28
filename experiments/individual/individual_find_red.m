function [red] = individual_find_red(i_data, avg, num_samples, key, repeated)
%% Calculates the red values of the individual experiment
% Red values are the average euclidean distance of the samples of a 
% certain key to the average vector of that same key
%   param i_data: The individual data
%   param avg: The average vector
%   param num_samples: The number of samples per key (30)
%   param key: The key
dist = 0;
num_keys = length(i_data)/num_samples; % 300/30 = 10

if repeated
    % Repeatedly collected
    key_range = (num_samples*key + 1:1:num_samples*key + num_samples);
else
    % Sequentially collected
    key_range = (1:num_keys:length(i_data))+key;
end

for i = key_range
    dist = dist + norm(i_data{i} - avg);
end
red = (dist/num_samples);
end