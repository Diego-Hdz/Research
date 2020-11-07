function [] = Main(folder, fft_, gcc_, dtw_, knn_, svm_, bpnn_, hmm_)
%% Applies classification algorithms on segmented data
% Runs functions and algorithms on segmented data; also runs some models
%   param folder: Folder with segmented data
%   param (all the others): Booleans opting in use of function
%% Function Preparation
close all;
load(folder, 'data');
samplingFreq = 200; % Set in Segment.m, modify as needed
disp("Running data in " + folder);

%% Apply FFT
if(fft_ == true)
    data = applyFFT(data, samplingFreq);
    disp("Applied FFT");
end

%% Trim data to the shortest length
shortestLength = find_az_shortest(data);
data = shorten_az(data, shortestLength);

%% Apply Z-Score
%data = applyZScore(data);

%% Apply GCC
if(gcc_ == true)
    data = applyGCC(data,1,0);
    disp("Applied GCC");
end
%% Concatenate Data: accel-x, accel-y, accel-z, gyro-x, gyro-y, gyro-z
data = concatenate(data);

%% Separate Data into training set and test set
trainingData = [];
testData = [];
counter = 1;
i = 1;
while i <= length(data)
    if counter == 30
        testData = [testData; data{i}];
        counter = 1;
    elseif counter > 20
        testData = [testData; data{i}];
        counter = counter + 1;
    else
        trainingData = [trainingData; data{i}];
        counter = counter + 1;
    end
    i = i + 1;
end

%% Prepare Labels
trainingLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20).';
testLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10).';

%% KNN
if(knn_ == true)
    if(dtw_ == true)
        knn_dtw_trainingLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, 20).';
        knn_dtw_validationLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, 10).';
        [accuracy, ~] = knnWithDTW(trainingData, knn_dtw_trainingLabels, testData, knn_dtw_validationLabels);
        disp("KNN algorithm with DTW: " + accuracy + "% accuracy");
    end
    for k=1:size(trainingData, 1)-1 % Returns diminish quickly, but computation is short
        [accuracy, ~] = knn(trainingData, trainingLabels, testData, testLabels, k);
        disp("KNN algorithm, k = " + k + " : " + accuracy + "% accuracy");
    end
end

%% SVM
if(svm_ == true)
    [accuracy, ~] = svm(trainingData, trainingLabels, testData, testLabels);
    disp("SVM algorithm: " + accuracy + "% accuracy");
end

%% BPNN
if(bpnn_ == true)
    bpnn_trainingLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, 20).';
    bpnn_validationLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, 10).';
    [accuracy, ~] = bpnn(trainingData, bpnn_trainingLabels, testData, bpnn_validationLabels);
    disp("BPNN algorithm: " + accuracy + "% accuracy");
end

%% HMM (2 - 12 states)
if(hmm_ == true)
    for s=2:12
        [accuracy, ~] = hmm(trainingData, trainingLabels, testData, testLabels, s);
        disp("HMM algorithm, " + s + " states accuracy: " + accuracy + "% accuracy");
    end
end

%% KNN Model
if(knn_ == true)
    [accuracy, dtw_accuracy] = knnWithModel(trainingData, trainingLabels, testData, testLabels, dtw_);
    disp("KNN (model) accuracy: " + accuracy + "%");
    disp("KNN with DTW (model) accuracy: " + dtw_accuracy + "%");
end
end