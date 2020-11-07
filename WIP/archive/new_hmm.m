function [ acc, res ] = new_hmm( trainData, trainLabel, testData, testLabel, statesNum )

if ~exist('statesNum', 'var')
    statesNum = 12;
end

classNum = 10; %size(trainLabel, 2);

nBins = ceil(sqrt(size(trainData, 1) * size(trainData, 2)));
% obtain histogram for the sequence array
%histogram(trainData);
histogram(trainData, nBins)
[~, bins] = histcounts(trainData, nBins);
bin_centers = bins(1:end-1) + diff(bins) / 2;
% obtain the bin distance
% indexing each float value to the nearest bin
for i = 1:size(trainData, 1)
    row = trainData(i, :);
    for d=1:size(row, 2)
        dist = abs(bin_centers - row(d));
        [~, indx] = min(dist);
        row(d) = indx;
    end
    trainData(i, :) = row;
end

for i = 1:size(testData, 1)
    row = testData(i, :);
    for d=1:size(row, 2)
        dist = abs(bin_centers - row(d));
        [~, indx] = min(dist);
        row(d) = indx;
    end
    testData(i, :) = row;
end

% 按手势类别对训练数据分组 / Group training data by gesture category
groupData = cell(classNum, 1);
for i=1:classNum
    groupData{i} = trainData(20*(i-1)+1:20*i, :);
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

% 统计精度 / Statistical accuracy

[~, res] = max(logP, [], 2);
count = 0;

for i=1:size(testData, 1)
    if res(i) - 1 == testLabel(i)
        count = count + 1;
    end
end

%{
for i=1:size(testData, 1)
    if testLabel(i, res(i)) == 1
        count = count + 1;
    end
end
%}


%replaces above text
%matches the number in res(i)th row of trainLabel with the ith row of
%testLabel, if they match, count++
%{
for i=1:size(testData, 1)
    if testLabel(i, 1) == trainLabel(res(i), 1)
        count = count + 1;
    end
end
%}

acc = count / size(testData, 1);
end

