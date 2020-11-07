function [avg_vector] = find_avg(d, range)
%% Calculate the average vector of a set of data
%   param d: data
%   param range: key range (ex: [1, 30])
avg_vector = zeros(1,length(d{range(1)}));
for i = range(1): range(2)
    avg_vector = avg_vector + d{i};
end
avg_vector = avg_vector/(range(2)-range(1)+1);
end