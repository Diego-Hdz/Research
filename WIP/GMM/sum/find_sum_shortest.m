function [shortestLength] = find_sum_shortest(data)
%% Finds the shortest segment from the sum data
%   param data: Input data
    shortestLength = length(data{1,1});
    for i=1:length(data)
        if (length(data{1,i})) < shortestLength
            shortestLength = length(data{1,i});
        end
    end
end

