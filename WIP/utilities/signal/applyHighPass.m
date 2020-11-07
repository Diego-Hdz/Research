function [h_data] = applyHighPass(data, fs, f)
%% Applies High-Pass filter
%   param data: Input data
%   param fs: Sampling frequency
%   param f: Filtering frequency
h_data = data;
for i=1:length(data)
    for s = 'ag'
        for a ='xyz'
            % h_data{1,i}.(s).(a) = high_pass(data{1,i}.(s).(a), fs, f);
            t = fft(data{1,i}.(s).(a));
            t(1) = 0;
            x_ac = real(ifft(t));
            h_data{1,i}.(s).(a) = highpass(x_ac, f, fs);
        end
    end
end