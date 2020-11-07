function [red] = finger_find_red(i, m, r, avg, range)
%% Calculate the red values for the finger experiment
% Red values are the average euclidean distance of the samples of a 
% certain key to the specified average vector
%   param i: the index finger data
%   param m: the middle finger data
%   param r: the ring finger data
%   param avg: the average vector
%   param range: the range of the key of the average vector
i_key_dist = 0;
r_key_dist = 0;
m_key_dist = 0;
n = range(2) - range(1) + 1;
for s = range(1): range(2)
    i_key_dist = i_key_dist + norm(i{s} - avg);
    m_key_dist = m_key_dist + norm(m{s} - avg);
    r_key_dist = r_key_dist + norm(r{s} - avg);
end
red = [i_key_dist/n, m_key_dist/n, r_key_dist/n];
end