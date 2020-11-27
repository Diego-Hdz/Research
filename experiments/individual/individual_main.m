%% Individual Experiment Script with Sequential Selection
clc; clear; close all;
i_file = "data_segmented/18-Sep-2020_diego_30key_sum_12.mat";
%data_p/15-Jul-2020_diego_10keyP1.mat
%data_segmented/17-Aug-2020_diego_10key_sum_P%d.mat
%data_segmented/18-Sep-2020_diego_30key_sum_1.mat
red = [];
grey = [];
for i=0:9
    [i_red, i_grey] = individual(i_file, i);
    red = cat(2, red, i_red);
    grey = cat(2, grey, i_grey);
end
individual_plot(red, grey, i_file);