function [res, C] = k_means(data)
%% Performs K-means with 10 clusters
%   param data: Input data
[idx, C] = kmeans(data, 10, 'Display', 'off', 'Distance', 'sqeuclidean', 'Replicates', 100, 'Start', 'plus', 'MaxIter', 5000);
res = idx;
end