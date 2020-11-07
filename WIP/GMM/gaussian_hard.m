%% Classifys data using a Gaussian Mixture Model
clear; clc; close all;
% In 1 attacker, 4 victim scenario, first 4 victim vars are used as
% victims
attacker = 'data_segmented/17-Aug-2020_diego_10key_sum_P5.mat';   %file should match line 12

victim1 = 'data_segmented/17-Aug-2020_diego_10key_sum_P1.mat';   %these 4 should not match line 5 
victim2 = 'data_segmented/17-Aug-2020_diego_10key_sum_P2.mat';
victim3 = 'data_segmented/17-Aug-2020_diego_10key_sum_P3.mat';
victim4 = 'data_segmented/17-Aug-2020_diego_10key_sum_P4.mat';

victim5 = 'data_segmented/17-Aug-2020_diego_10key_sum_P5.mat';    %file should match line 5
%% Prepare data
[a, a_s] = prep_sum_data(attacker);
[v1, v1_s] = prep_sum_data(victim1);
[v2, v2_s] = prep_sum_data(victim2);
[v3, v3_s] = prep_sum_data(victim3);
[v4, v4_s] = prep_sum_data(victim4);
[v5, v5_s] = prep_sum_data(victim5);

%% Shorten data to same length
shortest = min([a_s, v1_s, v2_s, v3_s, v4_s, v5_s]);
a = shorten_sum(a, shortest);
v1 = shorten_sum(v1, shortest);
v2 = shorten_sum(v2, shortest);
v3 = shorten_sum(v3, shortest);
v4 = shorten_sum(v4, shortest);
v5 = shorten_sum(v5, shortest);

%% Concatenation of data (ax-ay-az-gx-gy-gz)
a = concatenate(a);
v1 = concatenate(v1);
v2 = concatenate(v2);
v3 = concatenate(v3);
v4 = concatenate(v4);
v5 = concatenate(v5);

%% Prepare Attacker Data
attacker_data = zeros(10, length(a{1}));
for i = 0:9
    attacker_data(i+1,1:end) = a{30*i+1};
end

%% Prepare Victim Data
victim_data1 = kmeans_arr_prep(v1);
victim_data2 = kmeans_arr_prep(v2);
victim_data3 = kmeans_arr_prep(v3);
victim_data4 = kmeans_arr_prep(v4);
victim_data5 = kmeans_arr_prep(v5);
victim_data_exp1 = vertcat(victim_data1, victim_data2, victim_data3, victim_data4, victim_data5);
victim_data_exp2 = vertcat(attacker_data, victim_data1, victim_data2, victim_data3, victim_data4);
options = statset('Display','iter','MaxIter',1500,'TolFun',1e-5);
gm1 = fitgmdist(victim_data_exp1,10,'Options',options);
idx = cluster(gm1, victim_data_exp1);
acc = kmeans_acc(idx.');
disp("Experiment 1: " + acc + "%");

gm2 = fitgmdist(victim_data_exp2,10,'Options',options);
idx = cluster(gm2, victim_data_exp1);
acc = kmeans_acc2(idx.');
disp("Experiment 2: " + acc + "%");