function [grey, red] = finger(i, m, r, key)
%% Creates figures needed for the finger experiment
%   param i: file with index finger data
%   param m: file with middle finger data
%   param r: file with ring finger data
%   param key: key to perform analysis on

%% Preparation
[i_data, i_s] = prep_data(i);
[m_data, m_s] = prep_data(m);
[r_data, r_s] = prep_data(r);
key_range = [30*key + 1, 30*key + 30];

%% Adjustments
shortest = min([i_s, m_s, r_s]);
i_data = shorten(i_data, shortest);
m_data = shorten(m_data, shortest);
r_data = shorten(r_data, shortest);

%% Concatenation of data (ax-ay-az-gx-gy-gz)
i_data = concatenate(i_data);
m_data = concatenate(m_data);
r_data = concatenate(r_data);

%% Calculate Average Vector
i_avg_vector = find_avg(i_data, key_range);
m_avg_vector = find_avg(m_data, key_range);
r_avg_vector = find_avg(r_data, key_range);

%% Calculate Red Values (I, M, R)
i_red = finger_find_red(i_data, m_data, r_data, i_avg_vector, key_range);
m_red = finger_find_red(i_data, m_data, r_data, m_avg_vector, key_range);
r_red = finger_find_red(i_data, m_data, r_data, r_avg_vector, key_range);

%% Calculate Grey Values (I dists, M dists, R dists)
i_grey = finger_find_grey(i_data, m_data, r_data, i_avg_vector, key);
m_grey = finger_find_grey(i_data, m_data, r_data, m_avg_vector, key);
r_grey = finger_find_grey(i_data, m_data, r_data, r_avg_vector, key);

%% Plot Values - Combine Red and Grey Values
red = cat(2, i_red, m_red, r_red);
grey = cat(2, i_grey, m_grey, r_grey);
finger_plot(red, grey, key);
end