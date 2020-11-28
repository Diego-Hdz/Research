function [peaks_b, peaks_e] = segment_az_AGM(folder, ofs, fs, sample_num)
%% Segments data from a folder based on accelerometer z-axis
%   param folder: Folder with data
%   param ofs: Orginial sampling rate
%   param fs: Sampling rate to resample to (if desired)
%   param sample_num: Identifying dataset number

num_key = 10; % number of keys
w_size = int32(0.025 * fs); % Window size for finding the mean energy?
min_signal_len = 10; % Minimum signal length
min_interval_len = 20; % Minimum length between signals
threshold = 0.9; % Energy thresholds
filtered = false; % Option to save filtered data
fixed = true; % Option to fix data length (segment average)
setLength = 0; % Option to set data length (set here, when non-zero)
augment = false; % Option to create augmented data

data = {};
all_data = [];
seginfo.peaks_b = {};
seginfo.peaks_e = {};

%% Segment
for i=0:num_key - 1
    rawdata = loaddata_AGM(folder, i);
    %% Resample
    if ofs ~= fs
        for s='ag'
            for axis='xyz'
                rawdata.(s).(axis) = resample(lowpass(rawdata.(s).(axis), ofs, fs / 2), fs, ofs);
            end
        end
        rawdata.n = resample(lowpass(rawdata.m, ofs, fs / 2), fs, ofs);
    end
    
    %% Filter
    % Apply a lowpass-butterworth filter FOR SEGMENTATION ONLY 
    unfilteredData = rawdata; 
%     [b,a] = butter(1,0.2,'low');
%     for s='ag'
%         rawdata.(s).z = detrend(rawdata.(s).z, 0);
%         rawdata.(s).z = filter(b, a,rawdata.(s).z );
%     end
%     plot(rawdata.a.z)
    
    %% Find Energy based off accelerometer z-axis
    energy = zeros(1, numel(rawdata.a.z));
    energy = energy + (highpass(rawdata.a.z, 1, fs) .^ 2); 
    m_energy = zeros(1, numel(energy));
    for j=1:length(energy)
        m_energy(j) = mean(energy(max(1, j - w_size + 1):j));
    end
    
    %% Find Events
    pass = false;
    while ~pass
        peaks_b = []; % Where peaks begin (blue)
        peaks_e = []; % Where peaks end (red)
        find_begin = true;
        for j=1:numel(m_energy)
            % If we're trying to find where an event BEGINS, check to see
            % if the energy passes the threshold. If it does, we have found
            % a beginning point (change find_begin to false). Set b, the
            % beginning point (blue dots when we graph). 
            if find_begin       
                if m_energy(j) >= threshold
                    find_begin = false;
                    b = max(1,j - w_size);
                    continue;
                end
            % If we're trying to find where and event ENDS, check to see if
            % if the energy is lower than the threshold. If it is lower,
            % then we have found the end of an event (and we are now 
            % searching for the next event, set find_begin to true). We
            % then save our event by appending b, the beginning point, to
            % peaks_b and appending e, the ending point, to peaks_e.
            else
                if m_energy(j) < threshold
                    find_begin = true;
                    peaks_b = [peaks_b, b];
                    peaks_e = [peaks_e, j];
                end
            end
        end
        
        %% Merge close events
        j = 2;
        while j <= numel(peaks_b)
            if (peaks_b(j) + w_size) - peaks_e(j - 1) < min_interval_len
                peaks_b(j) = [];
                peaks_e(j - 1) = [];
            elseif peaks_b(j) <= peaks_e(j-1)
                peaks_b(j) = [];
                peaks_e(j - 1) = [];
            else
                j = j + 1;
            end
        end
        
        %% Remove short signals
        j = 1;
        while j <= numel(peaks_b)
            if peaks_e(j) - peaks_b(j) < min_signal_len
                peaks_b(j) = [];
                peaks_e(j) = [];
            else
                j = j + 1;
            end
        end
        
        %% Add padding for GCC
        for index = 1:length(peaks_e)
            peaks_b(index) = peaks_b(index) - min_signal_len/2;
            peaks_e(index) = peaks_e(index) + min_signal_len/2;
        end
        
        %% Segment by hand
        if length(peaks_b) ~= 30
            segment_graph(m_energy,sum_data, peaks_b, peaks_e, threshold)
            fprintf("Paused on key: %d\n", i);
            fprintf("Average segment size: %d\n", floor(mean(int32(peaks_e)-peaks_b)));
            x = "Pause here to edit by hand";
        end
        
        %% Fix length
        if fixed == true
            peaks_b = int32(peaks_e) + floor(mean(int32(peaks_e)-peaks_b));
        end
        if setLength ~= 0
            peaks_b = int32(peaks_e) + setLength;
        end
             
        %% Graph
        segment_graph(m_energy,sum_data, peaks_b, peaks_e, threshold)
    end
    %% Graph
    segment_graph(m_energy,sum_data, peaks_b, peaks_e, threshold)
    
    %% Save data as variables
    seginfo.peaks_b = [seginfo.peaks_b, peaks_b];
    seginfo.peaks_e = [seginfo.peaks_e, peaks_e];
    for j=1:numel(peaks_b)
        for s='ag'
            for axis='xyz'
                if filtered == true
                    sample.(s).(axis) = rawdata.(s).(axis)(peaks_b(j):peaks_e(j));
                else
                    sample.(s).(axis) = unfilteredData.(s).(axis)(peaks_b(j):peaks_e(j));
                end
            end
        end
        if filtered == true
            sample.m = rawdata.m(peaks_b(j):peaks_e(j));
        else
            sample.m = unfilteredData.m(peaks_b(j):peaks_e(j));
        end
        data = [data, sample];
    end
    all_data = [all_data, unfilteredData];
end

%% Save as .mat
labels = (0:1:num_key-1);
rawdata = all_data;
filename = sprintf('data_segmented/%s_SUMAGM_%d.mat', date, sample_num);
save(filename, 'labels', 'data', 'num_key' ,'seginfo', 'rawdata');

%% Augmentation
if augment == true
    augmentation(filename, sample_num);
end
end