function [acc, res ] = knnWithDTW(trainData, trainLabel, testData, testLabel)
%% Runs KNN algotihm with DTW
%   param trainData: Training data, one sample per row
%   param trainLabel: Training data labels, labels duplicated 10 time per row
%   param testData: Testing data, one sample per row
%   param testLabel: Testing data labels, labels duplicated 10 time per row
    % KNN with DTW implementation
    dis = zeros(size(testData, 1), size(trainData, 1));
    for i=1:size(testData, 1)
        for j=1:size(trainData, 1)
            data1 = testData(i, :);
            data2 = trainData(j, :);
            for k=1:length(data1)
                dis(i, j) = dis(i, j) + dtw(data1(k), data2(k));
            end
        end
    end
    [~, res] = min(dis, [], 2);

    % Calculate accuracy
    acc = 0;
    
%     OLD CODE
%     for i=1:size(testData, 1)
%         if testLabel(i, trainLabel(res(i), :) == 1) == 1
%             count = count + 1;
%         end
%     end

    for i = 1:size(testData, 1)
        res(i) = trainLabel(res(i));
        if(res(i) == testLabel(i))
            acc = acc + 1;
        end
    end
    acc = acc / size(testData, 1) * 100;
end