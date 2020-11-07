function [peaks_b, peaks_e] = segment_sum(folder, ofs, fs, sample_num)
%% Segments summed data from a folder 
%   param folder: folder who's data is to be segmented
%   param ofs: orginial sampling rate
%   param fs: sampling rate to resample to (if desired)

num_key = 10;
b_i = 0;
w_size = round(0.025 * fs); % Window size for finding the mean energy?
min_signal_len = 20;
min_interval_len = 100;
threshold = 5;
filtered = false; % Option to save filtered data
fixed = true; % Option to fix data length (segment average)
fixedLength = 40; %Option to fix data length (set here, when non-zero)

data = {};
all_data = [];
seginfo.peaks_b = {};
seginfo.peaks_e = {};

%% Segment
for i=b_i:(b_i + num_key - 1)
    rawdata = loaddata(folder, i);
    % ------------------------------Sum------------------------------------
    m = min([length(rawdata.a.x),length(rawdata.a.y),length(rawdata.a.z), ...
        length(rawdata.g.x), length(rawdata.g.y), length(rawdata.g.z)]);
    sum_data = zeros(1,m);
    for s='ag'
        for axis='xyz'
            sum_data = sum_data + rawdata.(s).(axis)(1,1:m);
        end
    end
    
    % ----------------------------Resample---------------------------------
    if ofs ~= fs
        sum_data = resample(lowpass(sum_data, ofs, fs / 2), fs, ofs);
    end
    
    % ----------------------------Filter Data------------------------------
    % Applying a lowpass-butterworth filter
    % "sum_data" uses a low pass filter to reduce noise FOR SEGMENTATION ONLY 
    unfilteredData = sum_data;
%     sum_data = detrend(rawdata.a.z, 0);
%     [b,a] = butter(1,0.2,'low');
%     sum_data = filter(b, a,sum_data);
%     plot(sum_data)
    
    % --------------------------Find Energy--------------------------------
    % Find energy at every point in our data based on accelerometer z-axis
    energy = zeros(1, numel(sum_data));
    energy = energy + (highpass(detrend(sum_data,0), 1, fs) .^ 2); 
    
    % Find mean energy from the windows
    m_energy = zeros(1, numel(energy));
    for j=1:length(energy)
        m_energy(j) = mean(energy(max(1, j - w_size + 1):j));
    end
    
    % --------------------------Find Events--------------------------------
    pass = false;
    while ~pass
        subplot(2, 1, 1);
        hold off;
        plot(m_energy);
        hold on;
        plot([0 numel(m_energy)], [threshold threshold], 'r');
        subplot(2, 1, 2);
        %hold off;
        hold on;
        plot(sum_data);
        plot(unfilteredData);
        %hold on;
        
        peaks_b = []; % Where peaks begin (blue dots)
        peaks_e = []; % Where peaks end (red dots)
        find_begin = true;
        for j=1:numel(m_energy) %Traverse through all elements in mean energy list
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
        
        % ------------------------Merge Events-----------------------------
        % If the distance between two events is smaller than the
        % min_interval, combine them to form one event.
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
        
        % ----------------------Add Padding for GCC------------------------
        % Add padding GCC and get more peak data
        for index = 1:length(peaks_e)
            peaks_b(index) = peaks_b(index) - min_signal_len/2;
            peaks_e(index) = peaks_e(index) + min_signal_len/2;
        end
        
        % ------------------------Filter Noise-----------------------------
        % If a signal is too short, filter it
        j = 1;
        while j <= numel(peaks_b)
            if peaks_e(j) - peaks_b(j) < min_signal_len
                peaks_b(j) = [];
                peaks_e(j) = [];
            else
                j = j + 1;
            end
        end
        
        % -------------If not 30 points, pause and edit by hand------------
        if length(peaks_b) ~= 30
            segmentation_graph(m_energy,sum_data, peaks_b, peaks_e, threshold)
            fprintf("Paused on key: %d\n", i);
            fprintf("Average segment size: %d\n", floor(mean(int32(peaks_e)-peaks_b)));
            x = "Pause here";
        end
        % --------------------------Fix Length-----------------------------
        if fixed == true
            peaks_e = int32(peaks_b) + floor(mean(int32(peaks_e)-peaks_b));
        end
        if fixedLength ~= 0
            peaks_e = int32(peaks_b) + fixedLength;
        end
        
        % ----------------------------Graph--------------------------------
        segmentation_graph(m_energy,sum_data, peaks_b, peaks_e, threshold)
        pass = true;
    end
    
    % -----------------------------Graph again-----------------------------
    segmentation_graph(m_energy,sum_data, peaks_b, peaks_e, threshold)
    segment_sum_graph(m_energy, peaks_b, peaks_e, threshold); % Additional graph

    % ------------------------Save as Variable-----------------------------
    seginfo.peaks_b = [seginfo.peaks_b, peaks_b];
    seginfo.peaks_e = [seginfo.peaks_e, peaks_e];
    for j=1:numel(peaks_b)
        if filtered == true
            sample = sum_data(peaks_b(j):peaks_e(j));
        else
            sample = unfilteredData(peaks_b(j):peaks_e(j));
        end
        data = [data, sample];
    end
    all_data = [all_data, unfilteredData];
end

%% Save
labels = zeros(1,num_key);
for l = 0:(num_key - 1)
    labels(l + 1) = l;
end
raw_data = all_data;
save(sprintf('data_segmented/%s_%s_%dkey_sum_P%d.mat', date, "diego", num_key, sample_num), 'labels', 'data', 'num_key' ,'seginfo', 'raw_data');

%% Augmentation
% Algorithm to get more data from a smaller set of data
augment = false;
if augment == true
    augmentation(sprintf('data_segmented/%s_%s_%dkey_sum_P%d.mat', date, "diego", num_key, sample_num));
end
end