%% Prepare Data
clear
clc
%addpath('gcc')
load('gyroAccelDataSegmented/16-Jun-2020-daniel-10key-1-origin.mat')
samplingFreq = 200; % This is set in the segment file

%% Trim Data to Be the Same Length
% Since we're using GCC, all samples need to have the same length.
% Find the shortest signal
shortestDataLength = length(data{1}.a.x);
for i=(1:length(data))
    for sensor='ag'
        for direction='xyz'
            if (length(data{i}.(sensor).(direction))) < shortestDataLength
                shortestDataLength = length(data{i}.(sensor).(direction));
            end
        end
    end
end
% BAD CODE, CAN BE OPTIMIZED!!!
fixedLengthData = data;
for i=(1:length(data))
    for sensor='ag'
        for direction='xyz'
             fixedLengthData{i}.(sensor).(direction) = data{i}.(sensor).(direction)(1:shortestDataLength);
        end
    end
end

%% Apply GCC to all data so they align with the first sample
applyGCC = true; % turn GCC off by setting to false
if applyGCC
    dataGCC = batchGCC(fixedLengthData{1}.a.x,fixedLengthData,0);
else
 dataGCC = fixedLengthData;
end
%% String all data together (make each one into one LONG signal)
for i=(1:length(dataGCC))
    longSignal = [];
    for sensor='ag'
        for direction='xyz'
            longSignal= [longSignal, dataGCC{i}.(sensor).(direction)];
        end
    end
    dataGCC{i} = longSignal;
end

%% Make training and Validation Data
numberOfTraining = 20;
numberOfTest = 10;
samplesPerFile = 30;

% Seperate Data
trainingData = [];
validationData = [];
counter = 1;
i = 1;
while i<=length(dataGCC)
    if counter == samplesPerFile
        validationData = [validationData; dataGCC{i}];
        counter = 1;
    elseif counter > numberOfTraining
        validationData = [validationData; dataGCC{i}];
        counter = counter + 1;
    else
        trainingData = [trainingData; dataGCC{i}];
        counter = counter + 1;
    end
    i = i + 1;
end

%% Reformat Labels
%Forgot to add a 9 into the labels oops
if labels{end} ~= 9
    labels{end+1} = 9;
end
for labelIndex=(1:length(labels))
    labels{labelIndex} = num2str(labels{labelIndex}); 
end
trainingLabels = repelem(labels ,numberOfTraining);
validationLabels = repelem(labels ,numberOfTest);

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
    if predictedValidation{j} == validationLabels{j}
        numCorrect = numCorrect + 1;    
    end
end
percentageCorrect = numCorrect / length(validationLabels);
disp("Accuracy:");
disp(percentageCorrect);
