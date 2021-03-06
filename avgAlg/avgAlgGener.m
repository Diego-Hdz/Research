function [avgs] = avgAlgGener(trainingData, repeated)
%% Generates the average vector each key
%   param trainingData: Input data
%   param repeated: True if data was collected repeatedly
num_keys = 10;
num_samples = length(trainingData)/num_keys; % 200/10 = 20
avgs = zeros(10, length(trainingData(1,1:end))); % 10 rows of length of trainingData

if repeated
    % Repeated Collection
    for i = 1:size(trainingData)
        if i <= 20
            avgs(1,1:end) = avgs(1,1:end) + trainingData(i,1:end);
        elseif i > 20 && i <= 40
            avgs(2,1:end) = avgs(2,1:end) + trainingData(i,1:end);
        elseif i > 40 && i <= 60
            avgs(3,1:end) = avgs(3,1:end) + trainingData(i,1:end);
        elseif i > 60 && i <= 80
            avgs(4,1:end) = avgs(4,1:end) + trainingData(i,1:end);
        elseif i > 80 && i <= 100
            avgs(5,1:end) = avgs(5,1:end) + trainingData(i,1:end);
        elseif i > 100 && i <= 120
            avgs(6,1:end) = avgs(6,1:end) + trainingData(i,1:end);
        elseif i > 120 && i <= 140
            avgs(7,1:end) = avgs(7,1:end) + trainingData(i,1:end);
        elseif i > 140 && i <= 160
            avgs(8,1:end) = avgs(8,1:end) + trainingData(i,1:end);
        elseif i > 160 && i <= 180
            avgs(9,1:end) = avgs(9,1:end) + trainingData(i,1:end);
        elseif i > 180 && i <= 200
            avgs(10,1:end) = avgs(10,1:end) + trainingData(i,1:end);
        else
            error("Average vector finding error: indexing"); 
        end
    end
else
    % Sequential Collection
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
end

avgs = avgs / num_samples;
