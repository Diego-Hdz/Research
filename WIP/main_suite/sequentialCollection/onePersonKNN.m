%% Single dataset KNN classification
% Uses a KNN and applies threefold cross-validation to classify data from one dataset
%% Parameters
clear; clc; close all;
folder="data_segmented/18-Sep-2020_diego_30key_sum_1.mat";
load(folder, 'data');
num_keys=10;
num_samples=30;
num_train=floor(num_samples*2/3);
num_test=num_samples-num_train;
start = datetime;

%% Classification
% Apply signal processing
%data = applyLowPass(data,200,50);
%data = applyHighPass(data,200,5);
%data = applyFFT(data,200);
%data = applyZScore(data);
%data = applyMinMax(data);
%data = applyMapStd(data);
%data = applyGCC(data,1,0);
data = applySGolay(data, 20, 41);
data = concatenate(data);

[trainingData,testData,trainingLabels,testLabels] = nnPrep_seq(data,num_keys,num_train,num_test);
best_acc = 0;
for k=1:30
    [accuracy, ~] = knn(trainingData, trainingLabels, testData, testLabels, k);
    disp(accuracy);
    if accuracy > best_acc
        best_acc = accuracy;
    end
end
[accuracy, ~] = knnWithModel(trainingData, trainingLabels, testData, testLabels, false);
if accuracy > best_acc
    best_acc = accuracy;
end

%% Display Results
finish = datetime;
disp("Best accuracy: " + best_acc);
disp("START TIME: " + datestr(start));
disp("END TIME: " + datestr(finish));
disp("RUN TIME: " + char(finish - start));