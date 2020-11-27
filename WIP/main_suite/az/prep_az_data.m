function [final_data, shortestLength] = prep_az_data(folder)
%% Prepares az data from folder by trimming it to the shortest segment length
%   param data: Input data
    load(folder, 'data')
    shortestLength = find_az_shortest(data);
    final_data = shorten_az(data, shortestLength);
end