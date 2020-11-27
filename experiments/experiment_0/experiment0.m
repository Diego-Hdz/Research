function [filtered] = experiment0(folder, f, fs, sensor, axis)
%% Tests the fact that we can filter out noise from data collected
%   param folder: folder containing data
%   param f: frequency to filter out
%   param fs: sampling frequency
%   param sample: data sample to graph (ex: 9)(0 - 9)
%   param sensor: sensor data to use ('a' or 'g')
%   param axis: sensor axis to use ('x' or 'y' or 'z')
%% Load
close all;
load(folder, 'rawdata', 'seginfo');
n = 10; %shorten to n signals
if (sensor == 'a')
    s = "Accelerometer";
elseif (sensor == 'g')
    s = "Gyroscope";
else
    error("Something went wrong with the given sensor")
end

for key=0:9
    %% Filter
    original = rawdata(key+1).(sensor).(axis);
    original = original(1: seginfo.peaks_b{1,key+1}(n+1));
    [filtered, ~] = highpass(original, f, fs);

    %[b,a] = butter(2, f/fs*2, 'high');
    %filtered = filter(b, a, original);

    %% Plot
    figure
    tiledlayout(2,2);

    nexttile
    plot(original);
    title("Originial Signal of Key " + key + " " + s + " " + upper(axis) + "-Axis Data");
    xlabel("Time");
    ylabel("Amplitude");

    nexttile
    plot(filtered);
    title("Filtered Signal of Key " + key + " " + s + " " + upper(axis) + "-Axis Data");
    xlabel("Time");
    ylabel("Amplitude");

    nexttile
    [spec, freqdomain] = getFFT(original, 200);
    plot(freqdomain, spec);
    title("FFT of Originial Signal of Key " + key + " " + s + " " + upper(axis) + "-Axis Data");
    xlabel("Frequency");
    ylabel("Amplitude");

    nexttile
    [spec, freqdomain] = getFFT(filtered, 200);
    plot(freqdomain, spec);
    title("FFT of Filtered Signal of Key " + key + " " + s + " " + upper(axis) + "-Axis Data");
    xlabel("Frequency");
    ylabel("Amplitude");

    x0 = 200;
    y0 = 100;
    width = 1000;
    height= 700;
    set(gcf, 'position', [x0, y0, width, height]);
    
    %% Save
    savefig(sprintf("experiments/experiment_0/figures_exp0/Filter_Test_%d%s%s_%dHz", key, sensor, axis, f));
    %savas(gcf, sprintf("experiments/experiment_0/figures_exp0/Filter_Test_%d%s%s_%dHz.png", key, sensor, axis, f));
    close all;
end
end