function [data] = diff_a(data)
%% Computes Diff_A
% Diff_A is a computation for accelerometer data defined as:
% Diff_A(i) = A(i+1) - A(i)
%   param data: Input data
for i=1:length(data)-1
    data(i) = data(i+1) - data(i);
end
data = data(1:end-1);
end

