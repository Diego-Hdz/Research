function [res, acc] = avgAlgComp(avgs, testData, testLabels)
%% Classifies data based off of distance from set of averages vectors
%   param avgs: Set of average vectors
%   parm testData: Testing Data
%   param testLabels: Testing Labels
%% Implementation
res = zeros(size(testData,1),1);
for i = 1: size(testData,1) % each row in testingData
    minDist = Inf;
    for a = 1: size(avgs,1)
        sample_i = norm(testData(i,1:end) - avgs(a,1:end));
        % disp(sample_i);
        if sample_i < minDist
            res(i) = a;
            minDist = sample_i;
        end
    end
    % disp('---------------');
end

%% Calculate accuracy
acc = 0;
for i = 1: length(res)
    if res(i) == testLabels(i)
        acc = acc + 1;
    end
end
acc = acc / length(res) * 100;