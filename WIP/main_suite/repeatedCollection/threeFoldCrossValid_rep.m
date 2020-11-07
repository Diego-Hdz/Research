function [best_acc] = threeFoldCrossValid_rep(data,num_keys,num_samples,range)
%% Performs KNN with threefold cross-validation
% Specifically for data collected as repeated taps (0,0,0,0, x30, then 1,1,1,1, x30, etc.) 
%   param data: Input data
%   param num_keys: Number of keys
%   param num_samples: Number of samples
%   param range: range of samples to use as testing data
%% Prepare training and testing data and labels
best_acc = 0;
trainingData = [];
testData = [];
for n=1:num_keys
    for s=1:num_samples
        if any(range(:) == s)
            testData = vertcat(testData, data{(n-1)*num_samples+s});
        else
            trainingData = vertcat(trainingData, data{(n-1)*num_samples+s});
        end
    end
end
trainingLabels = repelem((1:1:num_keys), (num_samples-length(range))).';
testLabels = repelem((1:1:num_keys), length(range)).';

%% KNN
for k=1:30
    [accuracy, ~] = knn(trainingData, trainingLabels, testData, testLabels, k);
    if accuracy * 100 > best_acc
        best_acc = accuracy * 100;
    end
end
[accuracy, ~] = knnWithModel(trainingData, trainingLabels, testData, testLabels, false);
if accuracy > best_acc
    best_acc = accuracy;
end
end