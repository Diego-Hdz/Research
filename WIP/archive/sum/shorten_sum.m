function [shortened_data] = shorten_sum(data, short)
%% Shortens sum data to a specified length
% Shortens by taking an equal amount of each end (takes off more off front in odd case)
%   @param data: data to be shortened
%   @param short: index to be shortened to
shortened_data = data;
for i=1:length(data)
    begin = ceil((length(data{i})-short)/2);
    last = floor((length(data{i})-short)/2);
    shortened_data{i} = data{i}(begin+1:end-last);
end
end