function [avg_vector] = find_avg(data, num_samples, key, repeated)
%% Calculate the average vector of a set of data
%   param data: Input data
%   param num_samples: Number of samples per key (30)
%   param range: Range of data
%   param repeated: True is data was collected repeatedly
avg_vector = zeros(1,length(data{1}));

if repeated    
    % Repeatedly collected
    key_range = (num_samples*key + 1:1:num_samples*key + num_samples);
else
    % Sequentially collected
    key_range = (1:length(data)/num_samples:length(data))+key;
end

for i = key_range
    avg_vector = avg_vector + data{i};
end
avg_vector = avg_vector/num_samples;
end