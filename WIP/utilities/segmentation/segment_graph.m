function [] = segment_graph(energy, data, peaks_b, peaks_e, threshold)
%% Graph segmentation results
% Plots energy and raw data graphs with the threshold and segments indicated; blue bars
% indicate the beginning of a segment, red bars indicate the end of a segment
%   param energy: Energy for segementation
%   param data: Raw data
%   param peaks_b: Matrix of segment beginings
%   param peaks_e: Matrix of segment endings
%   param threshold: Segmentation threshold
close all;
%% Plot energy with threshold and segments indicated
subplot(2, 1, 1);
hold off;
plot(energy);
hold on
plot([0 numel(energy)], [threshold threshold], 'c', 'linewidth', 1);
for j=1:numel(peaks_b)
    plot([peaks_b(j) peaks_b(j)], [threshold-threshold/2 threshold+threshold/2], 'b', 'linewidth', 1);
    plot([peaks_e(j) peaks_e(j)], [threshold-threshold/2 threshold+threshold/2], 'r', 'linewidth', 1);
end
%% Plot raw data with segments indicated
subplot(2, 1, 2);
hold off;
plot(data);
hold on;
for j=1:numel(peaks_b)
    plot([peaks_b(j) peaks_b(j)], [min(data) max(data)], 'b', 'linewidth', 1);
    plot([peaks_e(j) peaks_e(j)], [min(data) max(data)], 'r', 'linewidth', 1);
end
end