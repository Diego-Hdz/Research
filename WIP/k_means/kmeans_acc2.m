function [acc] = kmeans_acc2(res)
%% Calculates the accuracy of Kmeans performed in Experiment 2
% Iterates through each index of the kmeans resultant and creates a matrix
% of the cluster data by the key-values. The accuracy (acc) is the sum of the
% most number of the most prevalent key-values in each cluster divided by
% the number of resultant datums
%   param res: the resultant matrix of Kmeans

%% Initialize Cluster-Key Matrix
cluster_matrix = zeros(10, 10);

%% Add Attacker Data to Cluster-Key Matrix
for c = 0:9
    for i = 1:10
        if res(i) == c+1
            cluster_matrix(c+1, i) = cluster_matrix(c+1, i) + 1;
        end
    end
end

%% Add Victim Data Data to Cluster-Key Matrix
for c=0:9
    for v=1:4
        for k=0:9
            for s=1:30
                if res((v-1)*300 + 30*k + s + 10) == c+1
                    cluster_matrix(c+1, k+1) = cluster_matrix(c+1, k+1) + 1;
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