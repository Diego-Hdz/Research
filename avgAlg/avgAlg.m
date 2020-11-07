%% Average Vector Classifier
% Classifies the samples based off their distance from the average vector and
% applies threefold cross-validation
%% Parameters
clc; clear; close all;
i_file = "data_segmented/18-Sep-2020_diego_30key_sum_4.mat";
%data_segmented/17-Aug-2020_diego_10key_sum_P1.mat
%data_segmented/18-Sep-2020_diego_30key_sum_4.mat
num_keys=10;
num_samples=30;
kfold = 3;
start = datetime;
range = (1:1:num_samples/kfold);
i_data = load(i_file, 'data');
data = concatenate(i_data.data);
best_acc = zeros(1,3);

%% Classification
for kf=1:kfold
    [trainingData,testData,trainingLabels,testLabels] = avgAlgPrep(data,num_keys,num_samples,range);
    avgs = avgAlgGener(trainingData);
    [~, acc] = avgAlgComp(avgs, testData, testLabels);
    best_acc(kf) = acc;
    range = range + num_samples/kfold;
end

%% Display results
finish = datetime;
disp("Best accuracy: " + mean(best_acc));
disp("Accuracies: " + best_acc);
disp("START TIME: " + datestr(start));
disp("END TIME: " + datestr(finish));
disp("RUN TIME: " + char(finish - start));