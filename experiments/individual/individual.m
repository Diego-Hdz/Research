function [i_red, i_grey] = individual(i_file, key, num_samples, repeated)
%% Generates the red and grey values for the plot
%   param i_file: File containing data
%   param key: Key to generate data on
[data, ~] = prep_az_data(i_file);
i_data = concatenate(data);
i_avg = find_avg(i_data, num_samples, key, repeated);
i_red = individual_find_red(i_data, i_avg, num_samples, key, repeated);
i_grey = individual_find_grey(i_data, i_avg, num_samples, key, repeated);
end
