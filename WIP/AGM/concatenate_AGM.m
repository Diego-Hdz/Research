function [concatData] = concatenate_AGM(data)
%% Concatenates data: accel-x, accel-y, accel-z, gyro-x, gyro-y, gyro-z, microphone
%   param data: Input data
concatData = cell(1, length(data));
for i=1:length(data)
    for s='ag'
        for a='xyz'
            concatData{i} = [concatData{i}, data{i}.(s).(a)];
        end
    end
    concatData{i} = [concatData{i}, data{i}.m];
end
end