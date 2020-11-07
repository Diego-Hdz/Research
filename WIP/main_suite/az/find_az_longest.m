function [longestLength] = find_az_longest(data)
%% Finds the longest segment from the az data
%   param data: Input data
    longestLength = length(data{1,1}.a.z);
    for i=1:length(data)
        if (length(data{1,i}.a.z)) > longestLength
            longestLength = length(data{1,i}.a.z);
        end
    end
end