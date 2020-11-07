function [dataOut]= high_pass(data,fs,f)
%% High-pass filter: filter out signals below f HZ
%   param data: Input signal
%   param fs: Data sampling frequency
%   param f: Cut-off frequency of high-pass filtering
[b,a] = butter(2, f / fs * 2, 'high');
dataOut = filter(b, a, data);
end