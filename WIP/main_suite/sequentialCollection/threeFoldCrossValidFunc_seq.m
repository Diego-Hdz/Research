function [trainingData,testData,trainingLabels,testLabels] = threeFoldCrossValidFunc_seq(data,num_keys,num_samples,range)
%% Performs KNN with threefold cross-validation
% Specifically for data collected as sequential taps (0,1,2,3,4,5,6,7,8,9 x30) 
%   param data: Input data
%   param num_keys: Number of keys
%   param num_samples: Number of samples
%   param range: range of samples to use as testing data
%% Prepare training and testing data and labels
best_acc = 0;
trainingData = [];
testData = [];
% for n=1:num_keys
%     for s=1:num_samples
%         if any(range(:) == s)
%             testData = vertcat(testData, data{(n-1)*num_samples+s});
%         else
%             trainingData = vertcat(trainingData, data{(n-1)*num_samples+s});
%         end
%     end
% end

for i=1:length(data)
    if i > 100
        trainingData = vertcat(trainingData, data{i});
    else
        testData = vertcat(testData, data{i});
    end  
end
trainingLabels = repmat((1:1:num_keys), [1, num_samples - length(range)]).';
testLabels = repmat((1:1:num_keys), [1, length(range)]).';
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