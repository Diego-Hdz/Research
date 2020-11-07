%% 5 person dataset KNN classification
% Performs KNN classification on 5 different person datasets combined
% and reports the best result
%% Parameters
clear; clc; close all;
num_keys=10;
num_samples=30;
kfold = 3;
start = datetime;
avg_acc = zeros(1,kfold);
range = (1:1:num_samples/kfold);

%% Threefold cross-validation
for kf=1:kfold
    %% Generate training and testing data and labels
    testData = [];
    trainingData = [];
    testLabels = [];
    trainingLabels = [];
    for p=1:5
        folder = sprintf("data_segmented/17-Aug-2020_diego_10key_sum_P%d.mat",p);
        load(folder, 'data');  
        % Apply signal processing
        %data = applyLowPass(data,200,50);
        %data = applyHighPass(data,200,5);
        %data = applyFFT(data,200);
        %data = applyZScore(data);
        %data = applyMinMax(data);
        %data = applyMapStd(data);
        %data = applyGCC(data,1,0);
        data = concatenate(data);
        
        for n=1:num_keys
            for s=1:num_samples
                if any(range(:) == s)
                    testData = vertcat(testData, data{(n-1)*num_samples+s});
                else
                    trainingData = vertcat(trainingData, data{(n-1)*num_samples+s});
                end
            end
        end
        trainingLabels = vertcat(trainingLabels, repelem((1:1:num_keys), (num_samples-length(range))).');
        testLabels = vertcat(testLabels, repelem((1:1:num_keys), length(range)).');
    end
    
    %% KNN
    best_acc = 0;
    for k=1:30
        [accuracy, ~] = knn(trainingData, trainingLabels, testData, testLabels, k);
        if accuracy > best_acc
            best_acc = accuracy;
        end
    end
    
    %% KNN Model
    [accuracy, ~] = knnWithModel(trainingData, trainingLabels, testData, testLabels, false);
    if accuracy > best_acc
        best_acc = accuracy;
    end
    close all;
    avg_acc(kf) = best_acc;
    range = range + num_samples/kfold;
end
%% Display results
finish = datetime;
disp("START TIME: " + datestr(start));
disp("END TIME: " + datestr(finish));
disp("RUN TIME: " + char(finish - start));
disp("5 Person average accuracy: " + mean(avg_acc) + "%");
disp(avg_acc);