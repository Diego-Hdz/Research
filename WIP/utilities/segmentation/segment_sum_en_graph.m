function [] = segment_sum_en_graph(energy, peaks_b, peaks_e, threshold)
%% Graphs sum of individual axis energies from a range
% Also plots the threshold and segments; blue bars indicate the
% beginning of a segment, red bars indicate the end of a segment
%   param energy: Energy for segementation
%   param peaks_b: Matrix of segment beginings
%   param peaks_e: Matrix of segment endings
%   threshold: Segmentation threshold
close all;
hold on;
range = (1:(peaks_e(5)+(peaks_b(6)-peaks_e(5))/2)); % Range determined here
plot(energy(range));
plot([0 numel(energy)], [threshold threshold], 'c', 'linewidth', 1);
for j=1:numel(peaks_b)
    plot([peaks_b(j) peaks_b(j)], [threshold-threshold/2 threshold+threshold/2], 'b', 'linewidth', 1);
    plot([peaks_e(j) peaks_e(j)], [threshold-threshold/2 threshold+threshold/2], 'r', 'linewidth', 1);
end
title("Sum of the energies of the 6 axes");
ylabel("Energy");
xlabel("Time");
axis([0 range(end) 0 max(energy)+threshold]);
end