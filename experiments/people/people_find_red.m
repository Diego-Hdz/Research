function [red] = people_find_red(p1, p2, p3, p4, p5, avg, range)
%% Calculate the red values for the finger experiment
% Red values are the average euclidean distance of the samples of a 
% certain key to the average vector of that key
%   param p1: the p1 data
%   param p2: the p2 data
%   param p3: the p3 data
%   param p4: the p4 data
%   param p5: the p5 data
%   param avg: the average vector
%   param range: the range of samples to be considered
p1_key_dist = 0;
p2_key_dist = 0;
p3_key_dist = 0;
p4_key_dist = 0;
p5_key_dist = 0;
n = range(2) - range(1) + 1;
for s = range(1): range(2)
    p1_key_dist = p1_key_dist + norm(p1{s} - avg);
    p2_key_dist = p2_key_dist + norm(p2{s} - avg);
    p3_key_dist = p3_key_dist + norm(p3{s} - avg);
    p4_key_dist = p4_key_dist + norm(p4{s} - avg);
    p5_key_dist = p5_key_dist + norm(p5{s} - avg);
end
red = [p1_key_dist/n, p2_key_dist/n, p3_key_dist/n, p4_key_dist/n, p5_key_dist/n];
end