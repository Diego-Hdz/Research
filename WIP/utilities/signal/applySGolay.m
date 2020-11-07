function [sgolay_data] = applySGolay(data, order, framelen)
%% Applies Savitzky-Golay filter
%   param data: Input data
%   param order: filter order
%   param frameLen: filter frame length
sgolay_data = data;
for i=1:length(sgolay_data)
    for s = 'ag'
        for a = 'xyz'
            sgolay_data{1, i}.(s).(a) = sgolayfilt(sgolay_data{1, i}.(s).(a), order, framelen);
        end
    end
end
