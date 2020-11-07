function [grey, red] = people(p1, p2, p3, p4, p5, key)
%% Creates figures needed for the people experiment
%   param p1: file with person 1 data
%   param p2: file with person 2 data
%   param p3: file with person 3 data
%   param p4: file with person 4 data
%   param p5: file with person 5 data
%   param key: key to perform analysis on

%% Preparation
[p1_data, p1_s] = prep_data(p1);
[p2_data, p2_s] = prep_data(p2);
[p3_data, p3_s] = prep_data(p3);
[p4_data, p4_s] = prep_data(p4);
[p5_data, p5_s] = prep_data(p5);
key_range = [30*key + 1, 30*key + 30];

%% Adjustments
shortest = min([p1_s, p2_s, p3_s, p4_s, p5_s]);
p1_data = shorten(p1_data, shortest);
p2_data = shorten(p2_data, shortest);
p3_data = shorten(p3_data, shortest);
p4_data = shorten(p4_data, shortest);
p5_data = shorten(p5_data, shortest);

%% Concatenation of data (ax-ay-az-gx-gy-gz)
p1_data = concatenate(p1_data);
p2_data = concatenate(p2_data);
p3_data = concatenate(p3_data);
p4_data = concatenate(p4_data);
p5_data = concatenate(p5_data);

%% Calculate Average Vector
p1_avg_vector = find_avg(p1_data, key_range);
p2_avg_vector = find_avg(p2_data, key_range);
p3_avg_vector = find_avg(p3_data, key_range);
p4_avg_vector = find_avg(p4_data, key_range);
p5_avg_vector = find_avg(p5_data, key_range);

%% Calculate Red Values
p1_red = people_find_red(p1_data, p2_data, p3_data, p4_data, p5_data, p1_avg_vector, key_range);
p2_red = people_find_red(p1_data, p2_data, p3_data, p4_data, p5_data, p2_avg_vector, key_range);
p3_red = people_find_red(p1_data, p2_data, p3_data, p4_data, p5_data, p3_avg_vector, key_range);
p4_red = people_find_red(p1_data, p2_data, p3_data, p4_data, p5_data, p4_avg_vector, key_range);
p5_red = people_find_red(p1_data, p2_data, p3_data, p4_data, p5_data, p5_avg_vector, key_range);

%% Calculate Grey Values
p1_grey = people_find_grey(p1_data, p2_data, p3_data, p4_data, p5_data, p1_avg_vector, key);
p2_grey = people_find_grey(p1_data, p2_data, p3_data, p4_data, p5_data, p2_avg_vector, key);
p3_grey = people_find_grey(p1_data, p2_data, p3_data, p4_data, p5_data, p3_avg_vector, key);
p4_grey = people_find_grey(p1_data, p2_data, p3_data, p4_data, p5_data, p4_avg_vector, key);
p5_grey = people_find_grey(p1_data, p2_data, p3_data, p4_data, p5_data, p5_avg_vector, key);

%% Plot Values - Combine Red and Grey Values
red = cat(2,p1_red, p2_red, p3_red, p4_red, p5_red);
grey = cat(2,p1_grey, p2_grey, p3_grey, p4_grey, p5_grey);
person_plot(red, grey, key);
end