function [acc, res] = hmm(trainData, trainLabel, testData, testLabel, statesNum)
%% Runs HMM algorithm
%   param trainData: Training data
%   param trainlabel: Training data labels
%   param testData: Testing data
%   param testLabel: Testing data labels
%   param statesNum: Number of states
if ~exist('statesNum', 'var')
    statesNum = 12;
end

classNum = size(trainLabel, 2);

nBins = 32;
% obtain histogram for the sequence array
[~, bins] = hist(trainData, nBins);
% obtain the bin distance
% indexing each float value to the nearest bin
for i = 1:size(trainData, 1)
    row = trainData(i, :);
    for d=1:size(row, 2)
        dist = abs(bins - row(d));
        [~, indx] = min(dist);
        row(d) = indx;
    end
    trainData(i, :) = row;
end

for i = 1:size(testData, 1)
    row = testData(i, :);
    for d=1:size(row, 2)
        dist = abs(bins - row(d));
        [~, indx] = min(dist);
        row(d) = indx;
    end
    testData(i, :) = row;
end

% 按手势类别对训练数据分组 / Group training data by gesture category
groupData = cell(classNum, 1);
for i=1:classNum
    groupData{i} = trainData(trainLabel(:, i) == 1, :);
end

% 为每种手势建立 HMM / Create for each gesture
transESTs = cell(classNum, 1);
emisESTs = cell(classNum, 1);
Q = statesNum;
TRANS_GUESS = rand(Q, Q);
TRANS_GUESS = TRANS_GUESS ./ (sum(TRANS_GUESS, 2) * ones(1, Q));
M = nBins;
EMIS_GUESS = rand(Q, M);
EMIS_GUESS = EMIS_GUESS ./ (sum(EMIS_GUESS, 2) ./ ones(1, M));
parfor i=1:classNum
    [transESTs{i}, emisESTs{i}] = hmmtrain(groupData{i, 1}, TRANS_GUESS, EMIS_GUESS);
end

% 分类 / classification
logP = zeros(size(testData, 1),  classNum);
for i=1:size(testData, 1)
    for c=1:classNum
        [~, logP(i, c)] = hmmdecode(testData(i, :), transESTs{c}, emisESTs{c});
    end
end
[~, res] = max(logP, [], 2);

% Calculate accuracy
acc = 0;

% OLD CODE
%for i=1:size(testData, 1)
%    if testLabel(i, res(i)) == 1
%        count = count + 1;
%    end
%end

for i=1:size(testData, 1)
    if testLabel(i, 1) == trainLabel(res(i), 1)
        acc = acc + 1;
    end
end
acc = acc / size(testData, 1) * 100;
end