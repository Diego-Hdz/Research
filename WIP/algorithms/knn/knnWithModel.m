function [acc, acc_dtw] = knnWithModel(trainingData, trainingLabels, testData, testLabels, dtw_)
%% Runs KNN algorithm with model and DTW option
%   param trainData: Training data, one sample per row
%   param trainLabel: Training data labels
%   param testData: Testing data, one sample per row
%   param testLabel: Testing data labels
%   param dtw: boolean for running KNN with DTW
%% KNN Model implementation
KNNmodel = fitcknn(trainingData,trainingLabels,'OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',...
    struct('AcquisitionFunctionName','expected-improvement-plus'));
res = predict(KNNmodel, testData);

cm = confusionchart(testLabels,res);
cm.RowSummary = 'row-normalized';
cm.ColumnSummary = 'column-normalized';

%% Calculate accuracy
acc = 0;
for i = 1:length(res)
    if res(i) == testLabels(i)
        acc = acc + 1;
    end
end
acc = acc / length(testLabels) * 100;

%% KNN with DTW implementation
acc_dtw = 0;
if dtw_ == true
    allInputs = trainingData';
    truth = trainingLabels;
    bestKValue = 1;
    bestGuess = [];
    
    for i=1:length(allInputs)-1
        guesses = [];
        for test=1:length(trainingLabels)
            % PROBLEMS: bracing indexing
           guess = predictWithDTW(i, allInputs(test,1:end), allInputs, truth, true);
           guesses = [guesses, guess{3}];
        end
        
        acc =  0;
        for j=1:length(guesses)
            if guesses(j) == truth(j)
                acc = acc + 1;
            end
        end
        acc = acc / size(guesses, 2) * 100;
        
        if acc > acc_dtw
            acc_dtw = acc;
            bestKValue = i;
            bestGuess = guesses;
        end
        
        disp("KNN with DTW (model), k = " + i + " : " + acc + "% accuracy");
        disp("Guess: " + guesses);
        if acc_dtw == 100
            break;
        end
    end
    disp("Best K value: "+ bestKValue);
    disp("Accuracy: "+ acc_dtw);
    disp("bestGuess (below): ");
    disp(bestGuess);

    %confusionchart(categorical(cellstr(truth)),bestGuess); - not working
    confusionchart(truth, bestGuess');
end
end