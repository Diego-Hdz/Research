function [gcc_data] = applyGCC(data, n, cacheSize)
%% Applies GCC to data
%   param data: Input data
%   param n: Sample to align with
%   param cacheSize: Cache size
gcc_data = data;
for i=1:length(gcc_data)
    for s = 'ag'
        for a = 'xyz'
            gcc_data{1,i}.(s).(a) = modded_GCC(data{1,n}.(s).(a), data{1,i}.(s).(a), cacheSize);
        end
    end
end
end