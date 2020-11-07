function [i_red, i_grey] = individual(i_file, key)
%% Generates the red and grey values for the plot
%   param i_file: file containing data
%   param key: key to generate data on
key_range = [30*key + 1, 30*key + 30];
i_data = load(i_file, 'data');
i_data = concatenate(i_data.data);
i_avg = find_avg(i_data, key_range);
i_red = individual_find_red(i_data, i_avg, key_range);
i_grey = individual_find_grey(i_data, i_avg, key);
end
