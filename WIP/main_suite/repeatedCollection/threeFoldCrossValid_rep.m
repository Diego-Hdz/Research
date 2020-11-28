function [best_acc] = threeFoldCrossValid_rep(data,num_keys,num_samples,num_train,num_test,range)
%% Performs KNN with threefold cross-validation
% Specifically for data collected as repeated taps (0,0,0,0, x30, then 1,1,1,1, x30, etc.) 
%   param data: Input data
%   param num_keys: Number of keys (10)
%   param num_samples: Number of samples per key (30)
%   param num_train: Number of samples per key to use as training data (20)
%   param num_test: Number of samples per key to use as testing data (10)
%   param range: range of samples per key to use as testing data ([1,10],[11,20],[21,30])
%% Prepare training and testing data and labels
best_acc = 0;
trainingData = [];
testData = [];
for k=1:num_keys
    % x = randperm(num_samples); % Randomly choose samples
    x = (1:1:num_samples); % Choose samples in numeric order
    for s=1:num_samples
        if any(range(:) == s)
            testData = vertcat(testData, data{(n-1)*num_samples+x(s)});
        else
            trainingData = vertcat(trainingData, data{(n-1)*num_samples+x(s)});
        end
    end
end
trainingLabels = repelem((1:1:num_keys), num_train).';
testLabels = repelem((1:1:num_keys), num_test).';

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