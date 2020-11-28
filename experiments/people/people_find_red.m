function [red] = people_find_red(p1, p2, p3, p4, p5, avg, num_samples, key)
%% Calculate the red values for the finger experiment
% Red values are the average euclidean distance of the samples of a 
% certain key to the average vector of that key
%   param p1: The p1 data
%   param p2: The p2 data
%   param p3: The p3 data
%   param p4: The p4 data
%   param p5: The p5 data
%   param avg: The average vector
%   param range: The range of samples to be considered
%   param key: The key
p1_key_dist = 0;
p2_key_dist = 0;
p3_key_dist = 0;
p4_key_dist = 0;
p5_key_dist = 0;
key_range = (num_samples*key + 1:1:num_samples*key + num_samples);
for s = key_range
    p1_key_dist = p1_key_dist + norm(p1{s} - avg);
    p2_key_dist = p2_key_dist + norm(p2{s} - avg);
    p3_key_dist = p3_key_dist + norm(p3{s} - avg);
    p4_key_dist = p4_key_dist + norm(p4{s} - avg);
    p5_key_dist = p5_key_dist + norm(p5{s} - avg);
end
red = [p1_key_dist, p2_key_dist, p3_key_dist, p4_key_dist, p5_key_dist] / num_samples;
end