function [] = plot_data(data)
%% Plots data
%   param data: Input data
hold on;
for i=1:length(data)
    plot(data{1,i}.a.z); % Modify sensor plotted here
end
hold off;
end