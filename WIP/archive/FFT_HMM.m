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
trainingLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 9, 20).';
validationLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 9, 10).';
%% Apply HMM
for s=2:12
    [accuracy, res] = hmm(trainingData, trainingLabels, validationData, validationLabels, s);
    disp("HMM, " + s + "states accuracy: " + (accuracy * 100) + "%");
end