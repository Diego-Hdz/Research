function [avgs] = avgAlgGener(trainingData)
%% Generates the average vector each key
%   param trainingData: Input data
num_keys = 10;
num_samples = length(trainingData); % 200
avgs = zeros(10, length(trainingData(1,1:end))); % 10 rows of length of trainingData
for i = 1:size(trainingData)
    if mod(i, num_keys) == 1
        avgs(1,1:end) = avgs(1,1:end) + trainingData(i,1:end);
    elseif mod(i, num_keys) == 2
        avgs(2,1:end) = avgs(2,1:end) + trainingData(i,1:end);
    elseif mod(i, num_keys) == 3
        avgs(3,1:end) = avgs(3,1:end) + trainingData(i,1:end);
    elseif mod(i, num_keys) == 4
        avgs(4,1:end) = avgs(4,1:end) + trainingData(i,1:end);
    elseif mod(i, num_keys) == 5
        avgs(5,1:end) = avgs(5,1:end) + trainingData(i,1:end);
    elseif mod(i, num_keys) == 6
        avgs(6,1:end) = avgs(6,1:end) + trainingData(i,1:end);
    elseif mod(i, num_keys) == 7
        avgs(7,1:end) = avgs(7,1:end) + trainingData(i,1:end);
    elseif mod(i, num_keys) == 8
        avgs(8,1:end) = avgs(8,1:end) + trainingData(i,1:end);
    elseif mod(i, num_keys) == 9
        avgs(9,1:end) = avgs(9,1:end) + trainingData(i,1:end);
    elseif mod(i, num_keys) == 0
        avgs(10,1:end) = avgs(10,1:end) + trainingData(i,1:end);
    else
        error("Average vector finding error: indexing"); 
    end
end
avgs = avgs / (num_samples/num_keys);
