function [l_data] = applyLowPass(data, fs, f)
%% Applies Low-Pass filter
%   param data: Input data
%   param fs: Sampling frequency
%   param f: Filtering frequency
l_data = data;
for i=1:length(data)
    for s = 'ag'
        for a ='xyz'
            % l_data{1,i}.(s).(a) = low_pass(data{1,i}.(s).(a), fs, f);
            l_data{1,i}.(s).(a) = lowpass(data{1,i}.(s).(a), f, fs);
        end
    end
end