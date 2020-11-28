function [grey, red] = finger(i, m, r, key, num_samples, repeated)
%% Creates figures needed for the finger experiment
%   param i: file with index finger data
%   param m: file with middle finger data
%   param r: file with ring finger data
%   param key: key to perform analysis on

%% Preparation
[i_data, i_s] = prep_az_data(i);
[m_data, m_s] = prep_az_data(m);
[r_data, r_s] = prep_az_data(r);

%% Adjustments
shortest = min([i_s, m_s, r_s]);
i_data = shorten_az(i_data, shortest);
m_data = shorten_az(m_data, shortest);
r_data = shorten_az(r_data, shortest);

%% Concatenation of data (ax-ay-az-gx-gy-gz)
i_data = concatenate(i_data);
m_data = concatenate(m_data);
r_data = concatenate(r_data);

%% Calculate Average Vector
i_avg_vector = find_avg(i_data, num_samples, key, repeated);
m_avg_vector = find_avg(m_data, num_samples, key, repeated);
r_avg_vector = find_avg(r_data, num_samples, key, repeated);

%% Calculate Red Values (I, M, R)
i_red = finger_find_red(i_data, m_data, r_data, i_avg_vector, num_samples, key);
m_red = finger_find_red(i_data, m_data, r_data, m_avg_vector, num_samples, key);
r_red = finger_find_red(i_data, m_data, r_data, r_avg_vector, num_samples, key);

%% Calculate Grey Values (I dists, M dists, R dists)
i_grey = finger_find_grey(i_data, m_data, r_data, i_avg_vector, num_samples, key);
m_grey = finger_find_grey(i_data, m_data, r_data, m_avg_vector, num_samples, key);
r_grey = finger_find_grey(i_data, m_data, r_data, r_avg_vector, num_samples, key);

%% Plot Values - Combine Red and Grey Values
red = cat(2, i_red, m_red, r_red);
grey = cat(2, i_grey, m_grey, r_grey);
finger_plot(red, grey, key);
end