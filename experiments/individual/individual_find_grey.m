function [grey] = individual_find_grey(i_data, avg, key)
%% Calculates the grey values for the individual experiment
% Grey values are the average distance of values of keys not 
% equal to the key parameter from the average of the key parameter
%   param i_data: the individual data
%   param avg: the average vector of key
%   param key: the key being experimented on

% Sequentially collected
grey = [];
for k=0:9
    if k ~= key
        i_avg_dist = 0;
        for s = 1:10
            i_sample = i_data{(s-1)*30+(k+1)};
            i_sample_dist = norm(i_sample - avg);
            i_avg_dist = i_avg_dist + i_sample_dist;
        end
        grey = cat(2, grey, i_avg_dist/30);
    end
end

% Repeatedly collected
% grey = [];
% for k =0:9
%     i_avg_dist = 0;
%     if k ~= key
%         for s=1:30
%             i_sample = i_data{10*k+s};
%             i_sample_dist = norm(i_sample - avg);
%             i_avg_dist = i_avg_dist + i_sample_dist;
%         end
%         grey = cat(2, grey, i_avg_dist/s);
%     end
% end
