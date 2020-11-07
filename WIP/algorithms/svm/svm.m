function [ acc, res ] = svm( trainData, trainLabel, testData, testLabel )
%% Runs SVM algorithm
%   param trainData: Training data
%   param trainLabel: Training data labels
%   param testData: Testing data
%   param testLabel: Testing data labels

% OLD CODE
% [~, trainLabel] = max(trainLabel, [], 1);
% [~, testLabel] = max(testLabel, [], 1);

%% SVM implementation
mdl = fitcecoc(trainData, trainLabel);
res = predict(mdl, testData);

%% Calculate accuracy
acc = sum(res == testLabel) / size(testData, 1) * 100;
end