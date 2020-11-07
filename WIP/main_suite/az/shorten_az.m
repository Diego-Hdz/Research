function [shortened_data] = shorten_az(data, short)
%% Shortens az data to a specified length
% Shortens by taking an equal amount of each end;
% takes off more off front in odd case
%   param data: data to be shortened
%   param short: index to be shortened to
shortened_data = data;
for i=1:length(data)
    for s='ag'
        for a='xyz'
            if length(data{i}.(s).(a)) ~= short
                begin = ceil((length(data{i}.(s).(a))-short)/2);
                last = floor((length(data{i}.(s).(a))-short)/2);
                shortened_data{i}.(s).(a) = data{i}.(s).(a)(begin+1:end-last);
            end
        end
    end
end
end