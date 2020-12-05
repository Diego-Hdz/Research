%% Average Vector Classifier
% Classifies the samples based off their distance from the average vector and
% applies threefold cross-validation (not yet)
%% Parameters
clc; clear; close all;
i_file = "data_p/15-Jul-2020_diego_10keyP1.mat";
%"data_segmented/data12_SUM_0034.mat"
%"data_segmented/data_p_SUM_P1_0006.mat"
%"data_p/15-Jul-2020_diego_10keyP1.mat"
repeated = true;
rand = repeated & true;
num_keys = 10;
num_samples = 30;
num_train = 20;
num_test = 10;
kfold = 3;
start = datetime;
range = (1:1:num_samples/kfold);
data = prep_az_data(i_file);
data = concatenate(data);
best_acc = zeros(1,3);

%% Classification
for kf=1:kfold
    if repeated
        [trainingData,testData,trainingLabels,testLabels] = nnPrep_rep(data,num_keys,num_samples,num_train,num_test,rand);
        %[acc] = threeFoldCrossValid_rep(data,num_keys,num_samples,num_train,num_test,range);
    else
        [trainingData,testData,trainingLabels,testLabels] = nnPrep_seq(data,num_keys,num_train,num_test);
        %[acc] = threeFoldCrossValid_seq(data,num_keys,num_samples,num_train,num_test,range);
    end
    avgs = avgAlgGener(trainingData, repeated);
    [~, acc] = avgAlgComp(avgs, testData, testLabels);
    best_acc(kf) = acc;
    range = range + num_samples/kfold;
end

%% Display results
finish = datetime;
disp("Average accuracy: " + mean(best_acc));
disp("Accuracies: " + best_acc);
disp("START TIME: " + datestr(start));
disp("END TIME: " + datestr(finish));
disp("RUN TIME: " + char(finish - start));