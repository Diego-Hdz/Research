function [trainingData,testData,trainingLabels,testLabels] = nnPrep_seq(data,num_keys,num_samples,num_train,num_test)
%% Generates training and testing data and labels for classification
% Specifically for data collected as sequential taps (0,1,2,3,4,5,6,7,8,9 x30) 
%   param data: Input Data
%   param num_keys: Number of keys
%   param num_samples: Number of samples per key
%   param num_train: Number of samples per key to use as training data
%   param num_test: Number of samples per key to use as testing data
%% Generate training and testing data
trainingData = zeros(num_train*num_keys,length(data{1,1}));
testData = zeros(num_test*num_keys,length(data{1,1}));
for k=1:length(data)
    if k <= num_keys * num_test
        testData(k,1:end) = data{k};
    else
        trainingData(k - num_keys * num_test,1:end) = data{k};
    end
end

%% Generate training and testing labels
trainingLabels = repmat((0:1:num_keys-1), [1, num_train]).';
testLabels = repmat((0:1:num_keys-1), [1, num_test]).';
end

