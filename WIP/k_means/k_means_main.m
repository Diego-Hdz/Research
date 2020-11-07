%% Prepare Script
clear; clc; close all;
% In 1 attacker, 4 victim scenario, first 4 victim vars are used as
% victims
attacker = 'data_segmented/17-Aug-2020_diego_10key_sum_P5.mat';   %file should match line 12

victim1 = 'data_segmented/17-Aug-2020_diego_10key_sum_P1.mat';   %these 4 should not match line 5 
victim2 = 'data_segmented/17-Aug-2020_diego_10key_sum_P2.mat';
victim3 = 'data_segmented/17-Aug-2020_diego_10key_sum_P3.mat';
victim4 = 'data_segmented/17-Aug-2020_diego_10key_sum_P4.mat';

victim5 = 'data_segmented/17-Aug-2020_diego_10key_sum_P5.mat';%file should match line 5

temp = load(attacker,'data');
a = temp.data;
temp = load(victim1,'data');
v1 = temp.data;
temp = load(victim2,'data');
v2 = temp.data;
temp = load(victim3,'data');
v3 = temp.data;
temp = load(victim4,'data');
v4 = temp.data;
temp = load(victim5,'data');
v5 = temp.data;
%% Prepare data
% [a, a_s] = prep_az_data(attacker);
% [v1, v1_s] = prep_az_data(victim1);
% [v2, v2_s] = prep_az_data(victim2);
% [v3, v3_s] = prep_az_data(victim3);
% [v4, v4_s] = prep_az_data(victim4);
% [v5, v5_s] = prep_az_data(victim5);

% %% Shorten data to same length
% shortest = min([a_s, v1_s, v2_s, v3_s, v4_s, v5_s]);
% a = shorten_sum(a, shortest);
% v1 = shorten_sum(v1, shortest);
% v2 = shorten_sum(v2, shortest);
% v3 = shorten_sum(v3, shortest);
% v4 = shorten_sum(v4, shortest);
% v5 = shorten_sum(v5, shortest);
% v1 = applyZScore(v1);
% v2 = applyZScore(v2);
% v3 = applyZScore(v3);
% v4 = applyZScore(v4);
% v5 = applyZScore(v5);
% 
% v1 = applyGCC(v1,1,0);
% v2 = applyGCC(v2,1,0);
% v3 = applyGCC(v3,1,0);
% v4 = applyGCC(v4,1,0);
% v5 = applyGCC(v5,1,0);

%% Concatenation of data (ax-ay-az-gx-gy-gz)
a = concatenate(a);
v1 = concatenate(v1);
v2 = concatenate(v2);
v3 = concatenate(v3);
v4 = concatenate(v4);
v5 = concatenate(v5);

%% Prepare Attacker Data
attacker_data = zeros(10,length(a{1}));
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

%% Run K-Means Experiment 1
[res1, C1] = k_means(victim_data_exp1);
acc = kmeans_acc(res1);
disp("Experiment 1: " + acc + "%");

%% Run K-Means Experiment 2
[res2, C2] = k_means(victim_data_exp2);
acc = kmeans_acc2(res2);
disp("Experiment 2: " + acc + "%");

%% Generate Figures
%kmeansgraph(victim_data_exp1, res1, C1);
%kmeansgraph2(victim_data_exp2, res2, C2);