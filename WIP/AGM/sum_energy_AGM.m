function [sum_energy, unfilteredData] = sum_energy_AGM(rawdata, fs, ofs, w_size, threshold)
%% Find Energy based off energy sum (AGM data)
%   param rawdata: raw data
%   param fs: original sampling rate
%   param ofs: resampling rate
    m = min([length(rawdata.a.x),length(rawdata.a.y),length(rawdata.a.z), ...
        length(rawdata.g.x), length(rawdata.g.y), length(rawdata.g.z), length(rawdata.m)]);
    sum_energy = zeros(1, numel(rawdata.a.z(1,1:m)));
    unfilteredData = rawdata; 

    % Accelerometer and Gyroscope
    hold on;
    for s='ag'
        for axis='xyz'
            rawdata.(s).(axis) = rawdata.(s).(axis)(1,1:m);
            
            % Resample
            if ofs ~= fs
                rawdata.(s).(axis) = resample(lowpass(rawdata.(s).(axis), ofs, fs / 2), fs, ofs);
            end
                        energy = zeros(1, numel(rawdata.(s).(axis)));
            energy = energy + (highpass(detrend(rawdata.(s).(axis)), 1, fs) .^ 2);
            m_energy = zeros(1, numel(energy));
            plot(energy);
            for j=1:length(energy)
                m_energy(j) = mean(energy(max(1, j - w_size + 1):j));
            end
            sum_energy = sum_energy + m_energy;
        end
    end
    
    % Microphone
    rawdata.m = rawdata.m(1,1:m);

    % Resample
    if ofs ~= fs
        rawdata.m = resample(lowpass(rawdata.m, ofs, fs / 2), fs, ofs);
    end
    energy = zeros(1, numel(rawdata.m));
    energy = energy + (highpass(detrend(rawdata.m), 1, fs) .^ 2);
    m_energy = zeros(1, numel(energy));
    plot(energy);
    for j=1:length(energy)
        m_energy(j) = mean(energy(max(1, j - w_size + 1):j));
    end
    sum_energy = sum_energy + m_energy;
            
    plot(sum_energy, 'b');
    plot([0 numel(sum_energy)], [threshold threshold], '--m');
    hold off;
    close all;
end

