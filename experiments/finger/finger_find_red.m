function [red] = finger_find_red(i, m, r, avg, num_samples, key)
%% Calculate the red values for the finger experiment
% Red values are the average euclidean distance of the samples of a 
% certain key to the specified average vector
%   param i: The index finger data
%   param m: The middle finger data
%   param r: The ring finger data
%   param avg: The average vector
%   param range: The range of samples to be considered
%   param key: The key
i_key_dist = 0;
r_key_dist = 0;
m_key_dist = 0;
key_range = (num_samples*key + 1:1:num_samples*key + num_samples);
for s = key_range
    i_key_dist = i_key_dist + norm(i{s} - avg);
    m_key_dist = m_key_dist + norm(m{s} - avg);
    r_key_dist = r_key_dist + norm(r{s} - avg);
end
red = [i_key_dist, m_key_dist, r_key_dist] / num_samples;
end