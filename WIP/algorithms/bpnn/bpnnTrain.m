function [net] = bpnnTrain( trainData, trainLabel )
%% Training a neural network
%   param trainData: Training data, one sample per row
%   param trainLabel: Training data labels, labels duplicated 10 time per row

% OLD CODE
% net = newff(minmax(trainData'), [20 20 size(trainLabel, 2)], {'logsig', 'logsig', 'logsig'}, 'traingdx');
% net = newff(minmax(trainData'), [70 size(trainLabel, 2)], {'logsig', 'logsig'}, 'traingdx');

%% Create network
hiddenLayerSize = 10;
trainFcn = 'trainscg';

net = feedforwardnet(hiddenLayerSize, trainFcn);
%% Set training parameters and train
net.trainparam.show = 1;
net.trainparam.epochs = 1000;
net.trainparam.goal = 0.001;
net.trainParam.lr = 0.05;
net.performFcn = 'msereg';
net.performParam.regularization = 0.01;
net = train(net, trainData', trainLabel');
end