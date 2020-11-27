function [final_data, shortestLength] = prep_sum_data(folder)
%% Prepares sum data from folder by trimming it to the shortest segment length
%   param folder: Folder containing data
    load(folder, 'data');
    shortestLength = find_sum_shortest(data);
    final_data = shorten_sum(data, shortestLength);
end