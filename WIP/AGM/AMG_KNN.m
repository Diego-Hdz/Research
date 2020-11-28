folder = "";
load(folder, 'data');
num_keys = 10;
num_samples = 300;
num_train = 200;
num_test = 100;

%% training/testing data/labels (no cross validation)
[trainingData,testData,trainingLabels,testLabels] = nnPrep_seq(data,num_keys,num_samples,num_train,num_test);

%% KNN
for k=1:30
    [accuracy, ~] = knn(trainingData, trainingLabels, testData, testLabels, k);
    if accuracy * 100 > best_acc
        best_acc = accuracy * 100;
    end
end
[accuracy, ~] = knnWithModel(trainingData, trainingLabels, testData, testLabels, false);
if accuracy > best_acc
    best_acc = accuracy;
end