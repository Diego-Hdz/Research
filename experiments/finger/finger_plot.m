function [] = finger_plot(red, grey, key)
%% Creates a plot of the finger experiment
%   param red: the red points for the graph
%   param grey: the grey points for the graph
%   param key: the reference key of the graph
i_col = zeros(1,1)+1;
m_col = zeros(1,1)+2;
r_col = zeros(1,1)+3;
figure
hold on
for i=1:length(grey)
    if i <= length(grey)/3
        plot(i_col, grey(i), 'ko', 'MarkerSize' ,6, 'MarkerFaceColor', [0.5, 0.5, 0.5], 'LineWidth', 1);
    elseif (length(grey)/3 < i && i <= length(grey)*2/3)
        plot(m_col, grey(i), 'ko', 'MarkerSize', 6, 'MarkerFaceColor', [0.5, 0.5, 0.5], 'LineWidth', 1);
    elseif i > length(grey)*2/3
        plot(r_col, grey(i), 'ko', 'MarkerSize', 6, 'MarkerFaceColor', [0.5, 0.5, 0.5], 'LineWidth', 1);
    else
        error("Grey values for loop plotting error");
    end
end
hold on
for i=1:3
    if i == 1
        plot(i_col,red(i), 'ko', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'DisplayName', 'Index', 'LineWidth', 1);
        plot(m_col,red(i+3), 'ko', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'DisplayName', 'Middle', 'LineWidth', 1);
        plot(r_col,red(i+6), 'ko', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'DisplayName', 'Ring', 'LineWidth', 1);
    elseif i == 2
        plot(i_col,red(i), 'ks', 'MarkerSize',7, 'MarkerFaceColor', [1, 0, 0], 'DisplayName', 'Index', 'LineWidth', 1);
        plot(m_col,red(i+3), 'ks', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'DisplayName', 'Middle', 'LineWidth', 1);
        plot(r_col,red(i+6), 'ks', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'DisplayName', 'Ring', 'LineWidth', 1);
    else
        plot(i_col,red(i), 'k^', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'DisplayName', 'Index', 'LineWidth', 1);
        plot(m_col,red(i+3), 'k^', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'DisplayName', 'Middle', 'LineWidth', 1);
        plot(r_col,red(i+6), 'k^', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'DisplayName', 'Ring', 'LineWidth', 1);
    end
end  
title({"Euclidean distance of samples generated by different fingers",...
    "using the " + key + " key as the reference key"}, 'FontSize', 14);
xlabel("Fingers", 'FontSize', 14)
set(gca, 'XLim',[0.5, 3.5]);
set(gca, 'XTick',(1:1.0:3));
set(gca, 'XTickLabel', {'Index Finger', 'Middle Finger', 'Ring Finger'});
h = zeros(4, 1);
h(1) = plot(NaN,NaN, 'ko', 'MarkerSize' ,6, 'MarkerFaceColor', [0.5, 0.5, 0.5], 'LineWidth', 1);
h(2) = plot(NaN,NaN, 'ko', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'LineWidth', 1);
h(3) = plot(NaN,NaN, 'ks', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'LineWidth', 1);
h(4) = plot(NaN,NaN, 'k^', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'LineWidth', 1);
legend(h, 'Others', 'Index Finger','Middle Finger','Ring Finger')
ylabel("Euclidean Distance", 'FontSize', 14)
savefig(sprintf("experiments/finger/figures_f/Finger Distances_%d", key));
%savas(gcf, sprintf("experiments/finger/figures_f/Finger Distances_%d.jpg", key));
close all;
end