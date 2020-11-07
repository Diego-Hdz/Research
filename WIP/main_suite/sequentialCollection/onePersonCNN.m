%% Single dataset CNN classification
% Uses a CNN and applies threefold cross-validation to classify data from one dataset
%% Parameters
clear; clc; close all;
folder="data_segmented/17-Aug-2020_diego_10key_sum_P1.mat";
load(folder, 'data');
num_keys=10;
num_samples=30;
num_train=floor(num_samples*2/3);
num_test=num_samples-num_train;
start = datetime;

%% Generate training and testing data and labels
% Apply signal processing
%data = applyLowPass(data,200,50);
%data = applyHighPass(data,200,5);
%data = applyFFT(data,200);
%data = applyZScore(data);
%data = applyMinMax(data);
%data = applyMapStd(data);
%data = applyGCC(data,1,0);
data = concatenate(data);
[trainingData,testData,trainingLabels,testLabels] = nnPrep_seq(data,num_keys,num_samples,num_train,num_test);

trainingData = num2cell(trainingData,2);
testData = num2cell(testData,2);
trainingLabels = categorical(trainingLabels);
testLabels = categorical(testLabels);
%trainingData = {trainingData, trainingLabels};

%% CNN
inputSize = 1;
numHiddenUnits = 100;
numClasses = 10;
layers = [    
    sequenceInputLayer(inputSize)
    lstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

maxEpochs = 70;
miniBatchSize = 27;
options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'GradientThreshold',1, ...
    'Verbose',false, ...
    'Plots','training-progress');

net = trainNetwork(trainingData, trainingLabels,layers,options);

YPred = classify(net,testData);

accuracy = sum(YPred == testLabels)/numel(testLabels);
disp(accuracy);
