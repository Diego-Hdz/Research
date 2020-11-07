%% Prepare Data
clear
clc
load('data_segmented/11-Jun-2020_diego_10keyM.mat')
samplingFreq = 20000; % This is set in the segment file
dataFFT = [];

%% Get FFT
for i=(1:length(data))
   data{i} = getFFT(data{i}, samplingFreq);
end 

%% Trim/Pad Data to Be the Same Length
% Since we're using GCC, all samples need to have the same length.
% First I will try shortening them 
padded = true;
if padded == false
    % Find the shortest signal
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
else
    % Find the longest signal
    longestDataLength = length(data{1});
    for i=(1:length(data))
        if (length(data{i})) > longestDataLength
            longestDataLength = length(data{i});
        end
    end
    % BAD CODE, CAN BE OPTIMIZED!!!
    fixedLengthData = data;
    for i=(1:length(data))
        if length(data{i}) < longestDataLength
            paddedZeros = zeros(longestDataLength - length(data{i}), 1);
            fixedLengthData{i} = [data{i}; paddedZeros];
            fixedLengthData{i};
        end
    end
end

%% Apply GCC to all data so they align with the first sample
dataGCC = modded_batchGCC(fixedLengthData{1},fixedLengthData,0);


%% Make training and Validation Data
numberOfTraining = 20;
numberOfTest = 10;
samplesPerFile = 30;

% Separate Data
trainingData = [];
validationData = [];
counter = 1;
i = 1;
while i<=length(dataGCC)
    if counter == samplesPerFile
        validationData = [validationData; dataGCC{i}'];
        counter = 1;
    elseif counter > numberOfTraining
        validationData = [validationData; dataGCC{i}'];
        counter = counter + 1;
    else
        trainingData = [trainingData; dataGCC{i}'];
        counter = counter + 1;
    end
    i = i + 1;
end

% Reformat Labels
%{
for labelIndex=(1:length(labels))
    labels{labelIndex} = num2str(labels{labelIndex}+1); 
end
trainingLabels = repelem(labels ,numberOfTraining);
validationLabels = repelem(labels ,numberOfTest);
%}
trainingLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20).';
validationLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10).';

%% Make KNN Model
Mdl = fitcknn(trainingData,trainingLabels,'OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',...
    struct('AcquisitionFunctionName','expected-improvement-plus'));
%% Predict
% Predict and make confusion chart
predictedValidation = predict(Mdl, validationData);
cm = confusionchart(validationLabels,predictedValidation);
% Check how many are correct
numCorrect =  0;
for j=1 : length(predictedValidation)
    if predictedValidation(j) == validationLabels(j)
        numCorrect = numCorrect + 1;
    end
end
percentageCorrect = numCorrect / length(validationLabels);
disp("Accuracy:");
disp(percentageCorrect);
