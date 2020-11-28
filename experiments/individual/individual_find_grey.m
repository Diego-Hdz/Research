function [grey] = individual_find_grey(i_data, avg, num_samples, key, repeated)
%% Calculates the grey values for the individual experiment
% Grey values are the average distance of values of keys not 
% equal to the key parameter from the average of the key parameter
%   param i_data: The individual data
%   param avg: The average vector of key
%   param num_samples: The number of samples per key (30)
%   param key: The key being experimented on
num_keys = length(i_data)/num_samples; % 300/30 = 10
grey = [];

for k=0:num_keys-1
    i_avg_dist = 0;
    if k ~= key
        for s = 1:num_samples
            if repeated
                % Repeatedly collected
                i_sample = i_data{num_samples*k+s};
            else
                % Sequentially collected
                i_sample = i_data{(s-1)*num_keys+(k+1)};
            end
            i_sample_dist = norm(i_sample - avg);
            i_avg_dist = i_avg_dist + i_sample_dist;
        end
        grey = cat(2, grey, i_avg_dist/num_samples);
    end
end
end
