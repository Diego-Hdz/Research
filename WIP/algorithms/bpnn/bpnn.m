function [acc, res] = bpnn(trainData, trainLabel, testData, testLabel)
%% Runs BPNN algorithm
%   param trainData: Training data, one datum per row
%   param trainLabel: Training data labels, nine labels per row
%   param testData: Testing data, one datum per row
%   param testLabel: Testing data labels, nine labels per row
%% Train and simulate
net = bpnnTrain(trainData, trainLabel);
s = sim(net, testData');
[~, index] = max(s);
res = index' - 1;

%% Calculate accuracy
acc = 0;
for i=1:size(testLabel, 1)
    if res(i) == testLabel(i)
        acc = acc + 1;
    end
end
acc = acc / size(testLabel, 1) * 100;
end