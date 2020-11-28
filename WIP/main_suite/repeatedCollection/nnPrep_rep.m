function [trainingData,testData,trainingLabels,testLabels] = nnPrep_rep(data,num_keys,num_samples,num_train,num_test)
%% Generates training and testing data and labels for classification
% Specifically for data collected as repeated taps (0,0,0,0, x30, then 1,1,1,1, x30, etc.) 
%   param data: Input Data
%   param num_keys: Number of keys (10)
%   param num_samples: Number of samples per key (30)
%   param num_train: Number of samples per key to use as training data (20)
%   param num_test: Number of samples per key to use as testing data (10)
%% Generate training and testing data
trainingData = zeros(num_train*num_keys,length(data{1,1}));
testData = zeros(num_test*num_keys,length(data{1,1}));
for k=1:num_keys
    % x = randperm(num_samples); % Randomly choose samples
    x = (1:1:num_samples); % Choose samples in numeric order
    for s=1:num_samples
        if s <= num_test
            testData((k-1)*num_test+s,1:end) = data{(k-1)*num_samples+x(s)};
        else
            trainingData((k-1)*num_train+s-num_test,1:end) = data{(k-1)*num_samples+x(s)};
        end
    end
end

%% Generate training and testing labels
trainingLabels = repelem((1:1:num_keys), num_train).';
testLabels = repelem((1:1:num_keys), num_test).';
end