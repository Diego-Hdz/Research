%% Function Preparation
close all;
folder = "segmented_data/27-Jun-2020-daniel-10key-1-origin";
load(folder);
samplingFreq = 200;       % set in Segment.m, modify as needed
disp("Running data in " + folder);
disp("Sampling frequency " + samplingFreq);
%% Trim data
% Trim the data to the shortest length
shortestDataLength = length(data{1}.a.x);
for i=1:length(data)
    for s='ag'
        for a='xyz'
            if (length(data{i}.(s).(a))) < shortestDataLength
                shortestDataLength = length(data{i}.(s).(a));
            end
        end
    end
end
% BAD CODE, CAN BE OPTIMIZED!!!
fixedLengthData = data;
for i=1:length(data)
    for s='ag'
        for a='xyz'
            fixedLengthData{i}.(s).(a) = data{i}.(s).(a)(1:shortestDataLength);
        end
    end
end

%% Concatenate Data
% concatenate accel-x, accel-y, accel-z, gyro-x, gyro-y, gyro-z
% in that order

concatData = cell(1, 300);
for i=1:length(fixedLengthData)
    for s='ag'
        for a='xyz'
            concatData{i} = [concatData{i}, fixedLengthData{i}.(s).(a)];
        end
    end
end
%% Separate Data
% separate data into training set and validation set
trainingData = [];
validationData = [];
counter = 1;
i = 1;
while i<=length(concatData)
    if counter == 30
        validationData = [validationData; concatData{i}];
        counter = 1;
    elseif counter > 20
        validationData = [validationData; concatData{i}];
        counter = counter + 1;
    else
        trainingData = [trainingData; concatData{i}];
        counter = counter + 1;
    end
    i = i + 1;
end

%% Prepare Labels
trainingLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20).';
validationLabels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10).';
%% Results set-up
results = zeros(10);
for c1 = 0: 9
    for c2 = 0:9
        if c1 ~= c2
            %% Separate into two classes
            class1_train_data = trainingData(20*c1 + 1: 20*c1 +20, 1:end);
            class1_train_labels = trainingLabels(20*c1 + 1: 20*c1 +20, 1:end);
            class1_valid_data = validationData(10*c1 + 1: 10*c1 +10, 1:end);
            class1_valid_labels = validationLabels(10*c1 + 1: 10*c1 +10, 1:end);

            class2_train_data = trainingData(20*c2 + 1: 20*c2 +20, 1:end);
            class2_train_labels = trainingLabels(20*c2 + 1: 20*c2 +20, 1:end);
            class2_valid_data = validationData(10*c2 + 1: 10*c2 +10, 1:end);
            class2_valid_labels = validationLabels(10*c2 + 1: 10*c2 +10, 1:end);

            svm_train_data = vertcat(class1_train_data, class2_train_data);
            svm_train_labels = vertcat(class1_train_labels, class2_train_labels);
            svm_valid_data = vertcat(class1_valid_data, class2_valid_data);
            svm_valid_labels = vertcat(class1_valid_labels, class2_valid_labels);
            %% SVM
            SVMmodel = fitcsvm(svm_train_data, svm_train_labels, 'OptimizeHyperparameters','auto',...
                'HyperparameterOptimizationOptions',...
                struct('AcquisitionFunctionName','expected-improvement-plus'));

            % Predict
            predictedValidation = predict(SVMmodel, svm_valid_data);
            cm = confusionchart(svm_valid_labels,predictedValidation);
            %cm.RowSummary = 'row-normalized';
            %cm.ColumnSummary = 'column-normalized';
            numCorrect =  0;
            for j=1 : length(predictedValidation)
                if predictedValidation(j) == svm_valid_labels(j)
                    numCorrect = numCorrect + 1;
                end
            end
            percentageCorrect = numCorrect / length(svm_valid_labels) * 100;
            results(c1+1, c2+1) = percentageCorrect;
            close all;
        end
    end
end
disp(results);