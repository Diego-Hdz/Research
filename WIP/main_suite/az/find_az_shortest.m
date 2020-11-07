function [shortestLength] = find_az_shortest(data)
%% Finds the shortest segment from the az data
%   param data: Input data
    shortestLength = length(data{1,1}.a.z);
    for i=1:length(data)
        if (length(data{1,i}.a.z)) < shortestLength
            shortestLength = length(data{1,i}.a.z);
        end
    end
end