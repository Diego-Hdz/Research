function [best_acc] = threeFoldCrossValidFunc_seq(data,num_keys,num_train,num_test,range)
%% Performs KNN with threefold cross-validation
% Specifically for data collected as sequential taps (0,1,2,3,4,5,6,7,8,9 x30) 
%   param data: Input data
%   param num_keys: Number of keys (10)
%   param num_train: Number of samples per key to use as training data (20)
%   param num_test: Number of samples per key to use as testing data (10)
%   param range: range of samples per key to use as testing data ([1,10],[11,20],[21,30])
%% Prepare training and testing data and labels
best_acc = 0;
trainingData = [];
testData = [];
range_start = range(1) * 10 - 9; % (1, 11, 21)
range_end = range(length(range)) * 10; % (100, 200, 300)
for i=1:length(data)
    if i >= range_start && i <= range_end
        testData = vertcat(testData, data{i});
    else
        trainingData = vertcat(trainingData, data{i});
    end  
end
trainingLabels = repmat((1:1:num_keys), [1, num_train]).';
testLabels = repmat((1:1:num_keys), [1, num_test]).';
%% KNN
for k=1:30
    [accuracy, ~] = knn(trainingData, trainingLabels, testData, testLabels, k);
    if accuracy > best_acc
        best_acc = accuracy;
    end
end
[accuracy, ~] = knnWithModel(trainingData, trainingLabels, testData, testLabels, false);
if accuracy > best_acc
    best_acc = accuracy;
end
end