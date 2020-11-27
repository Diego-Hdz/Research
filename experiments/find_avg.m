function [avg_vector] = find_avg(data, range)
%% Calculate the average vector of a set of data
%   param data: Input data
%   param range: Key range (ex: [1, 30])

% Repeatedly collected
% avg_vector = zeros(1,length(data{range(1)}));
% for i = range(1): range(2)
%     avg_vector = avg_vector + data{i};
% end
% avg_vector = avg_vector/(range(2)-range(1)+1);

% Sequentially collected
avg_vector = zeros(1,length(data{1}));
for i = 1:10
    index = (i-1)*30+((range(2)/30-1)+1);
    avg_vector = avg_vector + data{index};
end
avg_vector = avg_vector/30;
end