%% Single dataset KNN classification
% Uses a KNN and applies threefold cross-validation to classify data from one dataset
%% Parameters
clear; clc; close all;
num_keys=10;
num_samples=30;
num_train=20;
num_test=10;
kfold = 3;
start = datetime;
range = (1:1:num_samples/kfold);

%% Classification
folder="data_segmented/25-Sep-2020_diego_30key_sum_12.mat";
load(folder, 'data');

% Appy signal processing
%data = applyLowPass(data,200,30);
%data = applyHighPass(data,200,5);
%data = applyFFT(data,200);
%data = applyZScore(data);
%data = applyMinMax(data);
%data = applyMapStd(data);
%data = applyGCC(data,1,0);
data = concatenate(data);

best_acc = zeros(1,3);
for kf=1:kfold
    best_acc(kf) = threeFoldCrossValidFunc_seq(data,num_keys,num_train,num_test,range);
    close all;
    range = range + num_samples/kfold;
end

%% Display results
finish = datetime;
disp("Best accuracy: " + mean(best_acc));
disp("Accuracies: " + best_acc);
disp("START TIME: " + datestr(start));
disp("END TIME: " + datestr(finish));
disp("RUN TIME: " + char(finish - start));