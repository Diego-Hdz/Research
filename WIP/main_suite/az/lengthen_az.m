function [lengthed_data] = lengthen_az(data, long)
%% Lengthens data to a specified length
% Lengths by adding an equal amount of each end
% (adds more to front in odd case)
%   @param data: data to be lengthened
%   @param long: index to be lengthened to
lengthed_data = data;
for i=1:length(data)
    for s='ag'
        for a='xyz'
            if length(data{i}.(s).(a)) ~= long
                begin = ceil((length(data{i}.(s).(a))-long)/2);
                last = floor((length(data{i}.(s).(a))-long)/2);
                lengthed_data{i}.(s).(a) = data{i}.(s).(a)(begin-1:end+last);
            end
        end
    end
end
end