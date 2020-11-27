function [i_red, i_grey] = individual(i_file, key)
%% Generates the red and grey values for the plot
%   param i_file: File containing data
%   param key: Key to generate data on
key_range = [30*key + 1, 30*key + 30];
%load(i_file, 'data');
[data, ~] = prep_az_data(i_file);
%data = shorten_az(i_data, i_s);
i_data = concatenate(data);
i_avg = find_avg(i_data, key_range);
i_red = individual_find_red(i_data, i_avg, key_range);
i_grey = individual_find_grey(i_data, i_avg, key);
end
