clc; clear;

%% Load algorithm and utils
addpath(genpath('./algorithm/'));
addpath('./common-utils-matlab/feature/asd/');
addpath('./common-utils-matlab/gcc/');
addpath('./common-utils-matlab/signal/');
addpath('./util/');
addpath('./util/dtw/');

%% Config
DATA_FILE = './data/number.mat'; % changed from '../data/number.mat'
KEY_NUM = 10; % 按键个数/Number of keys || changed from 10
PER_KEY_NUM = 30; % 每个按键的样本数/Number of samples per key
TRAIN_NUM = 20; % 训练样本数量/Number of training samples
TEST_NUM = PER_KEY_NUM - TRAIN_NUM; % 测试样本数量/Number of test samples
PER_NUM = KEY_NUM * PER_KEY_NUM;
TIMES = 5; % 测试次数/Testing frequency
DAY = 1; % 数据中每个人包含 DAY 天的数据/Everyone in the data contains DAY days of data
SHUFFLE = true; % 打乱训练样本/Disrupt training samples
% Feature config
AMP_ACCE = true; % 使用加速度计数据/Use accelerometer data
AMP_GYRO = true; % 使用陀螺仪数据/Use gyroscope data
FEATURE_AMP = true; % 是否使用振幅特征/Whether to use amplitude characteristic data
FEATURE_ASD = true; % 是否使用 ASD 特征/Whether to use ASD features
USE_WEIGHT = false; % 是否加权/Whether to weight
NORMALIZE = true; % 归一化/Normalized
USE_DTW = false;
USE_GCC = true;
GCC_CACHE_SIZE = 5;
USE_DWT = false;
% Algorithm
%   options: knn/knnWithDTW/bpnn/svm
algo = @bpnn;

%% Begin
% Load data
data = load(DATA_FILE);
data = struct2cell(data);

for i=1:length(data)
    tmp = data{i, 1};
    tmp2 = [];
    for j=1:size(tmp, 1)
        if USE_DWT
            dwtdata = dwt(data{i, 1}{j, :}, 'db1');
            tmp2 = [tmp2; dwtdata];
        else
            tmp2 = [tmp2; data{i, 1}{j, :}];
        end
    end
    data{i, 1} = tmp2;
end

dataRange = [];
if AMP_ACCE
    dataRange = [dataRange, 1, 3, 5];
end
if AMP_GYRO
    dataRange = [dataRange, 2, 4, 6];
end

pNum = size(data{1}, 1) / PER_NUM / DAY; % 人数/Number of people

% Cal the K of k-fold
if TEST_NUM < TRAIN_NUM
    K = floor(PER_KEY_NUM / TEST_NUM);
else
    K = floor(PER_KEY_NUM / TRAIN_NUM);
end

acc = zeros(pNum, TIMES, K, DAY);
confusionMatrix = zeros(KEY_NUM, KEY_NUM);
baseRange = 1:PER_KEY_NUM;
for p=1:pNum
    % Create label
    label = 1:KEY_NUM;
    label = repmat(label, PER_KEY_NUM, 1);
    label = reshape(label, 1, []);

    for t=1:TIMES
        if SHUFFLE
            baseRange = randperm(PER_KEY_NUM);
        end
        for k=1:KEY_NUM
            prange((k - 1) * PER_KEY_NUM + 1 : k * PER_KEY_NUM) = (k - 1) * PER_KEY_NUM + baseRange;
        end
        prange = prange + (p - 1) * PER_NUM * DAY;
        dayRange = [];
        if DAY > 1
            dayRange = (PER_NUM + 1 : PER_NUM * DAY) + (p - 1) * PER_NUM * DAY;
        end

        % GCC process
        tmpData = {};
        for i=dataRange
            tmpData{i} = data{i}([prange, dayRange], :);
            if USE_GCC
                tmpData{i} = batchGCC(tmpData{i}(1, :), tmpData{i}, GCC_CACHE_SIZE);
            end
        end

        % 结合三轴进行 dtw/Combining with three axes dtw
        if USE_DTW
            for s=1:(length(tmpData) / 3)
                offset = s - 1;
                aligned = alignWithDTW(...
                    [tmpData{offset + 1}(1, :);tmpData{offset + 3}(1, :);tmpData{offset + 5}(1, :)],...
                    {tmpData{s:2:length(tmpData)}},...
                    GCC_CACHE_SIZE...
                );
                tmpData{offset + 1} = aligned{1};
                tmpData{offset + 3} = aligned{2};
                tmpData{offset + 5} = aligned{3};
            end
        end

        % k-fold
        for k = 1 : K
            if TEST_NUM < TRAIN_NUM
                testRange = (k - 1) * TEST_NUM + 1 : k * TEST_NUM;
                trainRange = 1:PER_KEY_NUM;
                trainRange(testRange) = [];
            else
                trainRange = (k - 1) * TRAIN_NUM + 1 : k * TRAIN_NUM;
                testRange = 1:PER_KEY_NUM;
                testRange(trainRange) = [];
            end

            range = 0:(KEY_NUM - 1);
            range = range .* PER_KEY_NUM;
            range = repmat(range, TRAIN_NUM, 1);
            trainRange = range + reshape(trainRange, [], 1);
            trainRange = reshape(trainRange, 1, []);
            testRange = 1:(KEY_NUM * PER_KEY_NUM);
            testRange(trainRange) = [];

            % Feature extract
            feature = [];
            if FEATURE_AMP
                for i=dataRange
                    feature = [feature, tmpData{i}];
                end
            end
            if FEATURE_ASD
                for i=dataRange
                    feature = [feature, getASD(tmpData{i})];
                end
            end
            if NORMALIZE
                feature = (feature - mean(feature(trainRange, :))) ./ std(feature(trainRange, :));
            end
            if USE_WEIGHT
                feature = feature .* calVariance(feature(trainRange, :), KEY_NUM);
            end

            trainData = feature(trainRange, :);
            testData = feature(testRange, :);

            trainLabel = zeros(length(trainRange), KEY_NUM);
            for i=1:size(trainRange, 2)
                trainLabel(i, label(trainRange(i))) = 1;
            end
            testLabel = zeros(length(testRange), KEY_NUM);
            for i=1:size(testRange, 2)
                testLabel(i, label(testRange(i))) = 1;
            end

            [acc(p, t, k, 1), pred] = algo(trainData, trainLabel, testData, testLabel);
            for i=1:size(testRange, 2)
                confusionMatrix(label(testRange(i)), pred(i)) = confusionMatrix(label(testRange(i)), pred(i)) + 1;
            end
            dayLabel = zeros(length(label));
            for i=1:length(label)
                dayLabel(i, label(i)) = 1;
            end
            for day=2:DAY
                [acc(p, t, k, day), pred] = algo(trainData, trainLabel, feature((day - 1) * PER_NUM + 1 : day * PER_NUM, :), dayLabel);
                for i=1:size(testRange, 2)
                    confusionMatrix(label(testRange(i)), pred(i)) = confusionMatrix(label(testRange(i)), pred(i)) + 1;
                end
            end
        end
    end

    for day=1:DAY
        fprintf('第 %d 天 = %.4f ', day, mean(mean(acc(p, :, :, day))));
    end
    fprintf('\n');
end
% fprintf('%.4f ', mean(mean(acc(1, :, :, 1))));
confusionMatrix = confusionMatrix / sum(confusionMatrix(1, :));

fprintf('平均:\n');
for day=1:DAY
    fprintf('第 %d 天 = %.4f ', day, mean(mean(mean(acc(:, :, :, day)))));
end
fprintf('\n');