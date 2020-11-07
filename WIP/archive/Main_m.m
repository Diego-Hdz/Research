function [] = Main_m(folder, fft_, gcc_, dtw_, knn_, svm_, bpnn_, hmm_)
%% Applies algorithms on segmented data
% Runs functions and algorithms on segmented data; also runs some models
%       param folder: folder with segmented data
%       param (all the others): booleans opting in use of function
%           (fitknn model runs every time)
%% Function Preparation
close all;
load(folder);
samplingFreq = 15000;       % set in Segment.m, modify as needed
disp("Running data in " + folder);
disp("Sampling frequency " + samplingFreq);

%% Apply FFT
if(fft_ == true)
    for i=(1:length(data))
       data{i} = getFFT(data{i}, samplingFreq);
    end
    disp("Applied FFT");
end
%% Trim data
% Trim the data to the shortest length
shortestDataLength = length(data{1});
for i=(1:length(data))
    if (length(data{i})) < shortestDataLength
        shortestDataLength = length(data{i});
    end
end
% BAD CODE, CAN BE OPTIMIZED!!!
fixedLengthData = data;
for i=(1:length(data))
    fixedLengthData{i} = data{i}(1:shortestDataLength);
end

%% Apply GCC
if(gcc_ == true)
    fixedLengthData = modded_batchGCC(fixedLengthData{1},fixedLengthData,0);
    disp("Applied GCC");
end

%% Separate Data
% separate data into training set and validation set
trainingData = [];
validationData = [];
counter = 1;
i = 1;
while i<=length(fixedLengthData)
    if counter == 30
        validationData = [validationData; fixedLengthData{i}'];
        counter = 1;
    elseif counter > 20
        validationData = [validationData; fixedLengthData{i}'];
        counter = counter + 1;
    else
        trainingData = [trainingData; fixedLengthData{i}'];
        counter = counter + 1;
    end
    i = i + 1;
end

%% Prepare Labels
trainingLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20).';
validationLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10).';
%% Algorithms
% KNN
if(knn_ == true)
    if(dtw_ == true)
        knn_dtw_trainingLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 9, 20).';
        knn_dtw_validationLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 9, 10).';
        [accuracy, ~] = knnWithDTW(trainingData, knn_dtw_trainingLabels, validationData, knn_dtw_validationLabels);
        disp("KNN algorithm with DTW: " + accuracy*100 + "% accuracy");
    end
    for k=1:size(trainingData, 1)-1
        [accuracy, ~] = knn(trainingData, trainingLabels, validationData, validationLabels, k);
        disp("KNN algorithm, k = " + k + " : " + (accuracy * 100) + "% accuracy");
    end
end

% SVM
if(svm_ == true)
    [accuracy, ~] = svm(trainingData, trainingLabels, validationData, validationLabels);
    disp("SVM algorithm: " + accuracy*100 + "% accuracy");
end

%BPNN
if(bpnn_ == true)
    bpnn_trainingLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 9, 20).';
    bpnn_validationLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 9, 10).';
    [accuracy, ~] = bpnn(trainingData, bpnn_trainingLabels, validationData, bpnn_validationLabels);
    disp("BPNN algorithm: " + accuracy*100 + "% accuracy");
end

%HMM (2 - 12 states)
if(hmm_ == true)
    for s=2:12
        %hmm_trainingLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 9, 20).';
        %hmm_validationLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 9, 10).';
        [accuracy, ~] = new_hmm(trainingData, trainingLabels, validationData, validationLabels, s);
        disp("HMM algorithm, " + s + " states accuracy: " + accuracy*100 + "% accuracy");
    end
end

%d_k_means(trainingData, trainingLabels);
autoencoder(trainingData);

%% Matlab Models - KNN
% Create KNN model
KNNmodel = fitcknn(trainingData,trainingLabels,'OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',...
    struct('AcquisitionFunctionName','expected-improvement-plus'));

% Predict
predictedValidation = predict(KNNmodel, validationData);
cm = confusionchart(validationLabels,predictedValidation)
%cm.RowSummary = 'row-normalized';
%cm.ColumnSummary = 'column-normalized';
numCorrect =  0;
for j=1 : length(predictedValidation)
    if predictedValidation(j) == validationLabels(j)
        numCorrect = numCorrect + 1;
    end
end
percentageCorrect = numCorrect / length(validationLabels) * 100;
disp("KNN (model) accuracy: " + percentageCorrect + "%");

% Apply DTW
%% Try with DTW
% Create Validation and Training Sets (again)
trainingData = [];
validationData = [];
counter = 1;
i = 1;
while i<=length(data)
    if counter == 30
        validationData = [validationData; data(i)];
        counter = 1;
    elseif counter > 20
        validationData = [validationData; data(i)];
        counter = counter + 1;
    else
        trainingData = [trainingData; data(i)];
        counter = counter + 1;
    end
    i = i + 1;
end

trainingLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20).';
validationLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10).';

allInputs = trainingData';
truth=trainingLabels;

% Find best K
bestKPercent = 0;
bestKValue = 1;
bestGuess = [];
% Iterate through all possible values for K
for k=1 : length(allInputs)-1
    guesses = [];

    % Predict all test values at this k 
    for test=1:length(trainingLabels)
       guess = predictWithDTW(k, allInputs{test}, allInputs, truth, true); % brace probelm
       guesses = [guesses, guess{3}];
    end
    % Check how many are correct
    numCorrect =  0;
    for j=1 : length(guesses)
        if guesses(j) == truth(j)
            numCorrect = numCorrect + 1;
        end
    end
    percentageCorrect = numCorrect / size(guesses, 2);
    if percentageCorrect > bestKPercent
        bestKPercent = percentageCorrect;
        bestKValue = k;
        bestGuess = guesses;
    end
    disp("KNN with DTW (model), k = " + k + " : " + (percentageCorrect * 100) + "% accuracy");
    %disp("Guess: " + guesses);
    if bestKPercent == 1
        break;
    end
end
disp("Best K value: "+ bestKValue);
disp("Accuracy: "+ bestKPercent);
%disp("bestGuess (below): ");
%disp(bestGuess);

confusionchart(categorical(cellstr(truth)),bestGuess);
%% Matlab Models - SVM
% Create SVM Model
%{
SVMmodel = fitcsvm(trainingData, trainingLabels, 'OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',...
    struct('AcquisitionFunctionName','expected-improvement-plus'));

% Predict
predictedValidation = predict(SVMmodel, validationData);
cm = confusionchart(validationLabels,predictedValidation)
%cm.RowSummary = 'row-normalized';
%cm.ColumnSummary = 'column-normalized';
numCorrect =  0;
for j=1 : length(predictedValidation)
    if predictedValidation(j) == validationLabels(j)
        numCorrect = numCorrect + 1;
    end
end
percentageCorrect = numCorrect / length(validationLabels) * 100;
disp("SVM (with model) accuracy: " + percentageCorrect + "%");
%}
%% Matlab Models - BPNN
% Create BPNN Model
end