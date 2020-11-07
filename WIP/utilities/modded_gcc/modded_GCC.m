function [ data, offset ] = modded_GCC( data1, data2, cacheSize )
%% Performs Generalized Cross Correlation
% Modified from GCC.m
%   param data1: Data to align with
%   param data2: Data to be aligned
%   param cacheSize:
    len = size(data1,2); % Length of the first signal (data1 and data2 should be the same length?)
    m = sum(data1 .* data2); % Multiply every index in data1 by its corresponding index in data2 and then sum that array  
    offset = 1;
    % Loop through every element the data
    for i=1:len
        % aaaaa000
        % 000bbbbb
        tmp = sum(data1(i:end) .* data2(1:len - i + 1));
        if tmp > m
            m = tmp;
            offset = i;
        end
        % 000aaaaa
        % bbbbb000
        tmp = sum(data2(i:end) .* data1(1:len - i + 1));
        if tmp > m
            m = tmp;
            offset = -i;
        end
    end
    data = data2;
    if offset < 0
        offset = offset;
        data(1:end + offset + 1) = data2(-offset:end);
    else
        offset = offset;
        data(offset:end) = data2(1:end - offset + 1);
    end
    
    %data = data(:, cacheSize + 1 : end - cacheSize);
    % Trim the output by the cacheSize?
end