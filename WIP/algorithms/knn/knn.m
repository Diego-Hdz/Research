function [ acc, res ] = knn( trainData, trainLabel, testData, testLabel, k )
%% Runs KNN algorithm
%   param trainData: Training data, one datum per row
%   param trainLabel: Training data labels, one label per row
%   param testData: Testing data, one datum per row
%   param testLabel: Testing data labels, one label per row
%   param k: k value for algorithm
%% KNN implementation
dis = pdist2(testData, trainData);
[~, index] = sort(dis, 2);  
res = mode(index(:, 1:k), 2);

%% Calculate accuracy
acc = 0;

% OLD CODE
% for i=1:size(testData, 1)
%     %res(i) = find(trainLabel(res(i), :) == 1);
%     if testLabel(i, find(trainLabel(res(i), :) == 1)) == 1 
%         count = count + 1;
%     end
% end

for i = 1:size(testData, 1)
    res(i) = trainLabel(res(i));
    if res(i) == testLabel(i)
        acc = acc + 1;
    end
end
acc = acc / size(testData, 1) * 100;
end