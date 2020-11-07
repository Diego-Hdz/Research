function [acc] = kmeans_acc(res)
%% Calculates the accuracy of Kmeans performed in Experiment 1
% Iterates through each index of the kmeans resultant and creates a matrix
% of the cluster data by the key-values. The accuracy (acc) is the sum of the
% number of the most prevalent key-values in each cluster divided by
% the number of resultant datums
%   param res: the resultant matrix of Kmeans

%% Compute Cluster-Key Matrix 
cluster_matrix = zeros(10, 10);
for c=1:10
    for v=1:5
        for k=0:9
            for s=1:30
                if res((v-1)*300 + 30*k + s) == c
                    cluster_matrix(c, k+1) = cluster_matrix(c, k+1) + 1;
                end
            end
        end
    end
end

%% Calculate Accuracy
count = 0;
for i=1:10
    count = count + max(cluster_matrix(i,1:end));
end
acc = count / length(res) * 100;
end