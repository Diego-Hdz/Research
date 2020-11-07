function [gccData] = modded_batchGCC(base, data, cacheSize)
%% Performs Generalized Cross Correlation in batches
% Modified from batchGCC.m
%   param base: Data to align with
%   param data: Data to be aligned
%   param cacheSize:
    gccData = cell(1,size(data, 2)); 
    for i=1:size(data, 2)
        gccData{i} = modded_GCC(base, data{i}, cacheSize);
    end
end