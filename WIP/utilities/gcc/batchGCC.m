function [gccData] = batchGCC(base, data, cacheSize)
%% Performs Generalized Cross Correlation in batches
%   param base: Data to align with
%   param data: Data to be aligned
%   param cacheSize:
gccData = [];
% OLD CODE
% gccData = zeros(size(data, 1), size(data, 2) - 2 * cacheSize);

% OLD CODE
% for i=1:size(data, 2)
for i=1:size(data, 1)
    gccData{i} = GCC(base, data{i}, cacheSize);
end
end