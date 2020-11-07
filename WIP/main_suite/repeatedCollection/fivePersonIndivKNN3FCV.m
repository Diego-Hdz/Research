%% 5 person KNN classification with threefold cross-validation
% Performs KNN classification with  on 5 different person datasets individually
% and reports the best results and the average of the best results
%% Parameters
clear; clc; close all;
a1=0;a2=0;a3=0;a4=0;a5=0;
num_keys=10;
num_samples=30;
kfold = 3;
start = datetime;
range = (1:1:num_samples/kfold);

%% KNN with threefold cross-validation
for p=1:5
    folder = sprintf("data_segmented/17-Aug-2020_diego_10key_sum_P%d.mat",p);
    load(folder, 'data');
    % Apply signal processing
    %data = applyLowPass(data,200,50);
    %data = applyHighPass(data,200,5);
    %data = applyFFT(data,200);
    %data = applyZScore(data);
    %data = applyMinMax(data);
    %data = applyMapStd(data);
    %data = applyGCC(data,1,0);
    data = concatenate(data);
    
    best_acc = 0;
    for kf=1:kfold
        best_acc = best_acc + threeFoldCrossValid_rep(data,num_keys,num_samples,range);
        close all;
        range = range + num_samples/kfold;
    end
    range = (1:1:num_samples/kfold);
    best_acc = best_acc / kfold;
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
        error("accuracy saving error");
    end
end

%% Display results
finish = datetime;
disp("START TIME: " + datestr(start));
disp("END TIME: " + datestr(finish));
disp("RUN TIME: " + char(finish - start));
disp("Person 1 average accuracy: " + mean(a1) + "%");
disp(a1);
disp("Person 2 average accuracy: " + mean(a2) + "%");
disp(a2);
disp("Person 3 average accuracy: " + mean(a3) + "%");
disp(a3);
disp("Person 4 average accuracy: " + mean(a4) + "%");
disp(a4);
disp("Person 5 average accuracy: " + mean(a5) + "%");
disp(a5);