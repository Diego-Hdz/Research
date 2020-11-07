function [] = determineResampleHz(folder, file)
%% Aids in determining the resample frequency using FFT
%   param folder: The folder to pull the data file from
%   param file: A number representing the file name
rawdata = loaddata(folder, file);
[fftData, freqDom] = getFFT(rawdata.dataFromFile, rawdata.sampleRate);
subplot(2,1,1)
plot(freqDom, fftData)

subplot(2,1,2)
ofs = rawdata.sampleRate;
fs = 15000;
resampledData = resample(lowpass(rawdata.dataFromFile, ofs, fs / 2), fs, ofs);
[resampFFTData, resampFreqDom] = getFFT(resampledData, fs);
plot(resampFreqDom, resampFFTData)
end