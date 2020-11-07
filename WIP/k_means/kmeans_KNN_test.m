%% Prepare Script
clear; clc; close all;
attacker = 'experiments/people/data_p/15-Jul-2020_diego_10keyP1.mat';
victim1 = 'experiments/people/data_p/15-Jul-2020_diego_10keyP5.mat';
victim2 = 'experiments/people/data_p/15-Jul-2020_diego_10keyP2.mat';
victim3 = 'experiments/people/data_p/15-Jul-2020_diego_10keyP3.mat';
victim4 = 'experiments/people/data_p/15-Jul-2020_diego_10keyP4.mat';
victim5 = 'experiments/people/data_p/15-Jul-2020_diego_10keyP1.mat';

%% Prepare data
[a, a_s] = prep_data(attacker);
[v1, v1_s] = prep_data(victim1);
[v2, v2_s] = prep_data(victim2);
[v3, v3_s] = prep_data(victim3);
[v4, v4_s] = prep_data(victim4);
[v5, v5_s] = prep_data(victim4);

%% Shorten data to same length
shortest = min([a_s, v1_s, v2_s, v3_s, v4_s, v5_s]);
a = shorten(a, shortest);
v1 = shorten(v1, shortest);
v2 = shorten(v2, shortest);
v3 = shorten(v3, shortest);
v4 = shorten(v4, shortest);
v5 = shorten(v5, shortest);

%% Concatenation of data (ax-ay-az-gx-gy-gz)
a = concatenate(a);
v1 = concatenate(v1);
v2 = concatenate(v2);
v3 = concatenate(v3);
v4 = concatenate(v4);
v5 = concatenate(v5);

%% Prepare Data
attacker_data = prep_train(a);
victim_data1 = prep_train(v1);
victim_data2 = prep_train(v2);
victim_data3 = prep_train(v3);
victim_data4 = prep_train(v4);
victim_data5 = prep_train(v5);
data = [a, v1, v2, v3, v4, v5];
data2 = vertcat(victim_data1, victim_data2, victim_data3, victim_data4, victim_data5);

%% Separate Data
% separate data into training set and validation set
trainingData = [];
validationData = [];
counter = 1;
i = 1;
while i<=length(data2)
    if counter == 30
        validationData = [validationData; data2(i,1:end)];
        counter = 1;
    elseif counter > 20
        validationData = [validationData; data2(i,1:end)];
        counter = counter + 1;
    else
        trainingData = [trainingData; data2(i,1:end)];
        counter = counter + 1;
    end
    i = i + 1;
end

%% Prepare Labels
trainingLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20).';
trainingLabels = repmat(trainingLabels, 5, 1);
validationLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10).';
validationLabels = repmat(validationLabels, 5, 1);

%% Run KNN
[acc,~] = knnwithModel(trainingData, trainingLabel, validationData,validationLabels,false);
disp("KNN (model) accuracy: " + acc + "%");