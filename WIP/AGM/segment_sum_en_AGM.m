function [peaks_b, peaks_e] = segment_sum_en_AGM(folder, ofs, fs)
%% Segments data from a folder using energy sum
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
    close all;
    rawdata = loaddata_AGM(folder, i);
    
     %% Find Energy based off energy sum
    [sum_energy, unfilteredData] = sum_energy_AGM(rawdata, fs, ofs);
    
    %% Find Events
    pass = false;
    while ~pass     
        peaks_b = []; % Where peaks begin (blue)
        peaks_e = []; % Where peaks end (red)
        find_begin = true;
        for j=1:numel(sum_energy)
            % If we're trying to find where an event BEGINS, check to see
            % if the energy passes the threshold. If it does, we have found
            % a beginning point (change find_begin to false). Set b, the
            % beginning point (blue dots when we graph). 
            if find_begin       
                if sum_energy(j) >= threshold
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
                if sum_energy(j) < threshold
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
            segmentation_graph(sum_energy,rawdata.a.z, peaks_b, peaks_e, threshold)
            fprintf("Paused on key: %d\n", i);
            fprintf("Average segment size: %d\n", floor(mean(peaks_e-peaks_b)));
            x = "Pause here";
        end
        
        %% Fix length
        if fixed == true
            peaks_e = peaks_b + floor(mean(peaks_e-peaks_b));
        end
        if setLength ~= 0
            peaks_e = peaks_b + setLength;
        end
        
        %% Graph
        segmentation_graph(sum_energy,rawdata.a.z, peaks_b, peaks_e, threshold)
        pass = true;
    end 
    %% Graph again
    segmentation_graph(sum_energy,rawdata.a.z, peaks_b, peaks_e, threshold)
    segment_sum_en_graph(sum_energy, peaks_b, peaks_e, threshold);

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
sample_num = randi([0 9999], 1, 1);
filename = sprintf('data_segmented/%s_SUM-AGM_%04d.mat', folder, sample_num);
save(filename, 'labels', 'data', 'num_key' ,'seginfo', 'rawdata');

%% Augmentation
if augment == true
    augmentation(filename, sample_num);
end
end