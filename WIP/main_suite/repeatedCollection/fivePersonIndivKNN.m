%% 5 person KNN classification
% Performs KNN classification on 5 different person datasets individually
% and reports the best results and the average of the best results
%% Parameters
clear; clc; close all;
start = datetime;
num_its = 10;
a1List=zeros(1,num_its);
a2List=zeros(1,num_its);
a3List=zeros(1,num_its);
a4List=zeros(1,num_its);
a5List=zeros(1,num_its);
num_keys=10;
num_samples=30;
num_train=floor(num_samples*2/3);
num_test=num_samples-num_train;

%% Classification
for t=1:num_its
    a1=0;a2=0;a3=0;a4=0;a5=0;
    for p=1:5
        %% Prepare training and testing data and labels
        folder = sprintf("data_segmented/17-Aug-2020_diego_10key_sum_P%d.mat",p);
        load(folder, 'data');
        % Apply signal processing
        %data = applyLowPass(data,200,50);
        %data = applyLowPass(data,200,50);
        %data = applyHighPass(data,200,5);
        %data = applyFFT(data,200);
        %data = applyZScore(data);
        %data = applyMinMax(data);
        %data = applyMapStd(data);
        %data = applyGCC(data,1,0);
        data = concatenate(data);
        [trainingData,testData,trainingLabels,testLabels] = nnPrep_rep(data,num_keys,num_samples,num_train,num_test);

        %% KNN
        best_acc = 0;
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
        close all;
        if p==1
            a1 = best_acc;
        elseif p==2
            a2 = best_acc;
        elseif p==3
            a3 = best_acc;
        elseif p==4
            a4 = best_acc;
        elseif p==5
            a5 = best_acc;
        else
            error("Accuracy saving error: p > 5");
        end
    end
    
    %% Fill in accuracies
    a1List(t) = acc1;
    a2List(t) = acc2;
    a3List(t) = acc3;
    a4List(t) = acc4;
    a5List(t) = acc5;
end

%% Display results
finish = datetime;
disp("Person 1 average accuracy: " + mean(a1List) + "%");
disp(a1List);
disp("Person 2 average accuracy: " + mean(a2List) + "%");
disp(a2List);
disp("Person 3 average accuracy: " + mean(a3List) + "%");
disp(a3List);
disp("Person 4 average accuracy: " + mean(a4List) + "%");
disp(a4List);
disp("Person 5 average accuracy: " + mean(a5List) + "%");
disp(a5List);
disp("START TIME: " + datestr(start));
disp("END TIME: " + datestr(finish));
disp("RUN TIME: " + char(finish - start));