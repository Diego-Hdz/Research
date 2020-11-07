function [fft_data] = applyFFT(data, fs)
%% Applies FFT on data
%   param data: Data to apply FFT to
%   param fs: Sampling frequency
fft_data = data;
for i=1:length(fft_data)
    for s = 'ag'
        for a = 'xyz'
            [f,~] = getFFT(data{1,i}.(s).(a), fs);
            fft_data{1,i}.(s).(a) = f;
        end
    end
end
end