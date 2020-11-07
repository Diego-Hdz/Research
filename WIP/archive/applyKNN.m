%% Prepare data
% modify load() and samplingFreq lines as appropriate
clear; clc;
load('segmented_data/18-Jun-2020_diego_10key.mat')
samplingFreq = 20000; % set in Semgent.m function

%% Apply FFT
for i=(1:length(data))
   data{i} = getFFT(data{i}, samplingFreq);
end 

%% Prepare data
% Trim data
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

% Separate Data
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

% Create Labels
trainingLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 1, 20).';
validationLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 1, 10).';
%% Create KNN Model
Mdl = fitcknn(trainingData,trainingLabels,'OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',...
    struct('AcquisitionFunctionName','expected-improvement-plus'));

%% Predict
predictedValidation = predict(Mdl, validationData);
cm = confusionchart(validationLabels,predictedValidation)
%cm.RowSummary = 'row-normalized';
%cm.ColumnSummary = 'column-normalized';
% Accuracy= ( number of true classified samples)/ ( number of total test data) × 100;
%         = 48 / 90 x 100 = 48.8% accuracy???
% Check how many are correct
numCorrect =  0;
for j=1 : length(predictedValidation)
    if predictedValidation(j) == validationLabels(j)
        numCorrect = numCorrect + 1;
    end
end
percentageCorrect = numCorrect / length(validationLabels) * 100;
disp("Accuracy without DTW");
disp(percentageCorrect);
%% Try with DTW
% Separate Data
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

% Create Labels
trainingLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 1, 20).';
validationLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 1, 10).';

allInputs = trainingData';
truth=trainingLabels;

% Find best K
bestKPercent = 0;
bestKValue = 1;
bestGuess = [];
% Iterate through all possible values for K
for k=1 : length(allInputs)-1
    guesses = [];
    disp("CURRENT CYCLE! k: " + k);
    disp("bestKValue: "+ bestKValue);
    disp("bestKPercent: "+ bestKPercent);
    disp("bestGuess (below): ");
    %disp(bestGuess);
    disp(" ");
    % Predict all test values at this k 
    for test=1:length(trainingLabels)
       guess = predictWithDTW(k, allInputs{test}, allInputs, truth, true);
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
    if bestKPercent == 1
        break;
    end
end


confusionchart(categorical(cellstr(truth)),bestGuess);
%% Test

% Predict all test values at this k 
guesses = [];
for test=1:length(validationLabels)
   guess = predictWithDTW(bestKValue, validationData{test}, allInputs, truth, false);
   guesses = [guesses, guess{3}];
end
% Check how many are correct
numCorrect =  0;
for j=1 : length(guesses)
    if guesses(j) == validationLabels(j)
        numCorrect = numCorrect + 1;
    end
end
percentageCorrect = numCorrect / size(guesses, 2);

cm = confusionchart(categorical(cellstr(validationLabels)),guesses);
disp("Accuracy with DTW");
disp(percentageCorrect);

%Predicting part
function chunkPreditionAndData = predictWithDTW(k, chunk, allInputs_input, truth, train)
    chunkPreditionAndData = {};             % Return Value
    distancesFromNeighbors = [];            % Distances from all other points
    neighbhorClasses = [];                  % Classes of all other points
    currentSampleData = chunk;     % Data from the current sample
    
    % Iterate over all neighbhors and calculate the distance between them
    % via DTW
    for j = 1 : length(allInputs_input)    % j will be column
        % Find distance (self vs j) 
        distancesFromNeighbors = [distancesFromNeighbors, dtw(currentSampleData, allInputs_input(j))]; 
        neighbhorClasses = [neighbhorClasses, truth(j)]; 
    end
    % START PREDICTION 
    [distancesFromNeighbors, neighbhorClasses] = sortChunk(distancesFromNeighbors, neighbhorClasses);
    % It will always find itsself and report that as '0' distance, so once
    % we sort the lists, we remove the first element to remove that '0'
    % distance
    if train
        distancesFromNeighbors = distancesFromNeighbors(2:end);
        neighbhorClasses = neighbhorClasses(2:end);
    end
    %chunk_classPrediction = mode(categorical( cellstr(neighbhorClasses(1:k))));                     % The class repeated the most if the predicted class
    chunk_classPrediction = mode(neighbhorClasses(1:k));
    chunkPreditionAndData = {distancesFromNeighbors, neighbhorClasses, chunk_classPrediction};
end

function [sortedChunk, sortedClasses] = sortChunk(distancesPassedIn, chunk_classes)
    [sortedChunk, sortedIndex] = sort(distancesPassedIn);
    sortedClasses = chunk_classes(sortedIndex);
end

