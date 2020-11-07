function [trainingData,testData,trainingLabels,testLabels] = avgAlgPrep(data,num_keys,num_samples,range)
%% Generates training and testing data and labels for classification
%   param data: Input Data
%   param num_keys: Number of keys
%   param num_samples: Number of samples per key
%   param range: range of samples to use as testing data
%% Generate training and testing data
best_acc = 0;
trainingData = [];
testData = [];

for i=1:length(data)
    if i > 100
        trainingData = vertcat(trainingData, data{i});
    else
        testData = vertcat(testData, data{i});
    end  
end

%% Generate training and testing labels
trainingLabels = repmat((1:1:num_keys), [1, num_samples - length(range)]).';
testLabels = repmat((1:1:num_keys), [1, length(range)]).';
end

