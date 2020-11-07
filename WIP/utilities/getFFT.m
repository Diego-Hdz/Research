function [dataTable, frequencyDomain] = getFFT(inputData, samplingFrequency)
%% Applies FFT with butterworth filter
%   https://www.youtube.com/watch?v=dM1y6ZfQkDU&t=389s
%   param inputData: Input data
%   param samplingFrequency: Sampling frequency of input data
    fouried = fft(inputData);  
    lengthInput = length(inputData);
    twoSidedSpec = abs(fouried/lengthInput);
    oneSidedSpec = twoSidedSpec(1:(floor(lengthInput/2)+1));
    oneSidedSpec = 2*oneSidedSpec(2:end-1);
    frequencyDomain = samplingFrequency * (1:(lengthInput/2))/lengthInput;
    frequencyDomain = frequencyDomain(1:end - 1);
    dataTable = oneSidedSpec;
end 