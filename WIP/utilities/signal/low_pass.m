function [dataOut]=low_pass(data,fs,f)
%% Low-pass filter: filters out signals above f HZ
%   param data: Input signal
%   param fs: Data sampling frequency
%   param f: Cut-off frequency of low-pass filtering
[b,a] = butter(8, f / fs * 2);
dataOut = filter(b, a, data);
end