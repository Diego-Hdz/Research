function [] = individual_plot(red, grey, i_file)
%% Creates a plot of the individual experiment
%   param red: the red points for the graph
%   param grey: the grey points for the graph
%   param key: the reference key of the graph
%   param i_file: the data fie
key0 = zeros(1,11)+1;
key1 = zeros(1,11)+2;
key2 = zeros(1,11)+3;
key3 = zeros(1,11)+4;
key4 = zeros(1,11)+5;
key5 = zeros(1,11)+6;
key6 = zeros(1,11)+7;
key7 = zeros(1,11)+8;
key8 = zeros(1,11)+9;
key9 = zeros(1,11)+10;

%% Plot grey points
hold on
for i=1:length(grey)
    if i <= length(grey)/10
        plot(key0, grey(i), 'ko', 'MarkerSize' ,6, 'MarkerFaceColor', [0.5, 0.5, 0.5], 'LineWidth', 1);
    elseif length(grey)/10 < i && i <= length(grey)*2/10
        plot(key1, grey(i), 'ko', 'MarkerSize' ,6, 'MarkerFaceColor', [0.5, 0.5, 0.5], 'LineWidth', 1);
    elseif length(grey)*2/10 < i && i <= length(grey)*3/10
        plot(key2, grey(i), 'ko', 'MarkerSize' ,6, 'MarkerFaceColor', [0.5, 0.5, 0.5], 'LineWidth', 1);
    elseif length(grey)*3/10 < i && i <= length(grey)*4/10
        plot(key3, grey(i), 'ko', 'MarkerSize' ,6, 'MarkerFaceColor', [0.5, 0.5, 0.5], 'LineWidth', 1);
    elseif length(grey)*4/10 < i && i <= length(grey)*5/10
        plot(key4, grey(i), 'ko', 'MarkerSize' ,6, 'MarkerFaceColor', [0.5, 0.5, 0.5], 'LineWidth', 1);
    elseif length(grey)*5/10 < i && i <= length(grey)*6/10
        plot(key5, grey(i), 'ko', 'MarkerSize' ,6, 'MarkerFaceColor', [0.5, 0.5, 0.5], 'LineWidth', 1);
    elseif length(grey)*6/10 < i && i <= length(grey)*7/10
        plot(key6, grey(i), 'ko', 'MarkerSize' ,6, 'MarkerFaceColor', [0.5, 0.5, 0.5], 'LineWidth', 1);
    elseif length(grey)*7/10 < i && i <= length(grey)*8/10
        plot(key7, grey(i), 'ko', 'MarkerSize' ,6, 'MarkerFaceColor', [0.5, 0.5, 0.5], 'LineWidth', 1);
    elseif length(grey)*8/10 < i && i <= length(grey)*9/10
        plot(key8, grey(i), 'ko', 'MarkerSize' ,6, 'MarkerFaceColor', [0.5, 0.5, 0.5], 'LineWidth', 1);
    elseif length(grey)*9/10 < i
        plot(key9, grey(i), 'ko', 'MarkerSize' ,6, 'MarkerFaceColor', [0.5, 0.5, 0.5], 'LineWidth', 1);
    else
        error("Grey values for loop plotting error");
    end
end

%% Plot red points
plot(key0,red(1), 'ko', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'DisplayName', '0', 'LineWidth', 1);
plot(key1,red(2), 'ko', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'DisplayName', '1', 'LineWidth', 1);
plot(key2,red(3), 'ko', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'DisplayName', '2', 'LineWidth', 1);
plot(key3,red(4), 'ko', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'DisplayName', '3', 'LineWidth', 1);
plot(key4,red(5), 'ko', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'DisplayName', '4', 'LineWidth', 1);
plot(key5,red(6), 'ko', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'DisplayName', '5', 'LineWidth', 1);
plot(key6,red(7), 'ko', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'DisplayName', '6', 'LineWidth', 1);
plot(key7,red(8), 'ko', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'DisplayName', '7', 'LineWidth', 1);
plot(key8,red(9), 'ko', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'DisplayName', '8', 'LineWidth', 1);
plot(key9,red(10), 'ko', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'DisplayName', '9', 'LineWidth', 1);

%% Plot information
titleString = strrep(i_file, "_", "\_");
title({"Euclidean distance of samples generated by one person",...
    "from the " + titleString + " dataset"}, 'FontSize', 14);
xlabel("Keys", 'FontSize', 14)
ylabel("Euclidean Distance", 'FontSize', 14)
set(gca, 'XLim',[0.5, 10.5]);
set(gca, 'XTick',(1:1.0:10));
set(gca, 'XTickLabel', {'0 Key', '1 Key', '2 Key', '3 Key', '4 Key', '5 Key', '6 Key', '7 Key', '8 Key', '9 Key'});
h = zeros(2, 1);
h(1) = plot(NaN,NaN, 'ko', 'MarkerSize' ,6, 'MarkerFaceColor', [0.5, 0.5, 0.5], 'LineWidth', 1);
h(2) = plot(NaN,NaN, 'ko', 'MarkerSize', 7, 'MarkerFaceColor', [1, 0, 0], 'LineWidth', 1);
legend(h, 'Different Key', 'Same Key');

%% Save
savefig("experiments/individual/figures_i/Individualseq12.fig");
%savas(gcf, sprintf("experiments2/individual/figures_i/Individual_%s", i_file))
end

