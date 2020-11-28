function [grey] = people_find_grey(p1, p2, p3, p4, p5, avg, num_samples, key)
%% Calculate the grey values for the finger experiment
% Grey values are the average euclidean distance of each sample of
% keys not from a specified key from the specified average vector
%   param p1: The p1 data
%   param p2: The p2 data
%   param p3: The p3 data
%   param p4: The p4 data
%   param p5: The p5 data
%   param avg: The average vector of key
%   param num_samples: The number of samples per key (30)
%   param key: The key being experimented on
num_keys = length(p1)/num_samples; % 300/30 = 10
grey = [];

%% Person 1
for k = 0:num_keys-1
    p1_avg_dist = 0;
    if k ~= key
        for s=1:num_samples
            p1_sample = p1{num_samples*k+s};
            p1_sample_dist = norm(p1_sample - avg);
            p1_avg_dist = p1_avg_dist + p1_sample_dist;
        end
        grey = cat(2,grey,p1_avg_dist/num_samples);
    end
end

%% Person 2
for k = 0:num_keys-1
    p2_avg_dist = 0;
    if k ~= key
        for s=1:num_samples
            p2_sample = p2{num_samples*k+s};
            p2_sample_dist = norm(p2_sample - avg);
            p2_avg_dist = p2_avg_dist + p2_sample_dist;
        end
        grey = cat(2,grey,p2_avg_dist/num_samples);
    end
end

%% Person 3
for k = 0:num_keys-1
    p3_avg_dist = 0;
    if k ~= key
        for s=1:num_samples
            p3_sample = p3{num_samples*k+s};
            p3_sample_dist = norm(p3_sample - avg);
            p3_avg_dist = p3_avg_dist + p3_sample_dist;
        end
        grey = cat(2,grey,p3_avg_dist/num_samples);
    end
end

%% Person 4
for k = 0:num_keys-1
    p4_avg_dist = 0;
    if k ~= key
        for s=1:num_samples
            p4_sample = p4{num_samples*k+s};
            p4_sample_dist = norm(p4_sample - avg);
            p4_avg_dist = p4_avg_dist + p4_sample_dist;
        end
        grey = cat(2,grey,p4_avg_dist/num_samples);
    end
end

%% Person 5
for k = 0:num_keys-1
    p5_avg_dist = 0;
    if k ~= key
        for s=1:num_samples
            p5_sample = p5{num_samples*k+s};
            p5_sample_dist = norm(p5_sample - avg);
            p5_avg_dist = p5_avg_dist + p5_sample_dist;
        end
        grey = cat(2,grey,p5_avg_dist/num_samples);
    end
end
end