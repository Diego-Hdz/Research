%% Individual Experiment Script with Sequential Selection
clc; clear; close all;
i_file = "data_p/15-Jul-2020_diego_10keyP2.mat";
%data_p/15-Jul-2020_diego_10keyP1.mat
%data_segmented/17-Aug-2020_diego_10key_sum_P%d.mat
%data_segmented/12_SUM_0034.mat
red = [];
grey = [];
num_samples = 30;
repeated = true;
for i=0:9
    [i_red, i_grey] = individual(i_file, i, num_samples, repeated);
    red = cat(2, red, i_red);
    grey = cat(2, grey, i_grey);
end
individual_plot(red, grey, i_file);