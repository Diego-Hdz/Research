function [peaks_b, peaks_e] = Segment_m(folder, fs)
%% 两个数字信号切段 ("Two digital signal cut")
% Segments data from a folder
%   param folder: folder who's data is to be segmented
%   param fs: sampling rate to resample to (if desired)

% 原始数据信息 ("Raw data information")
% folder = '../rawdata/single';
% user = 'LWk';
% date = '20200412';
folder = "trim_data2/";     % Folder that contains the data to be segmented
no = 0;                     % ???
ofs = 44100;                % Original sample rate
fs = 20000;                 % Sample rate is resampled to
num_key = 10;               % Number of files

b_i = 0;                            % The "beginning index" - file names should be numbers (ex: "5.wav")
w_size = int32(0.025 * fs);         % Window size for finding the mean energy(?)
min_signal_len = int32(0.05 * fs);  % The smallest possible length of a signal 
min_interval = int32(0.1 * fs);     % This is the smallest space between two signals. If the space between two signals is smaller than this number, they get combined into one signal
threshold = .00001;                 % Lowest possible 'energy' for an event

data = {};                          % Holds segmented signals (each index is a different signal)
all_data = [];                      % Raw data(?)
seginfo.peaks_b = {};               % These are the beginning points of each event
seginfo.peaks_e = {};               % These are the ending points of each event


%% Segment
% Import files from ONE folder
for i=b_i:(b_i + num_key - 1)
    path = folder;
    rawdata = loaddata(path, i);    % Imports data from a file (read over the file please)
    % ----------------------------Resample---------------------------------
    if ofs ~= fs
        rawdata.dataFromFile = resample(lowpass(rawdata.dataFromFile, ofs, fs / 2), fs, ofs);
    end
    
    % --------------------------Find Energy--------------------------------
    % Find energy at every point in our data
    energy = zeros(1, numel(rawdata.dataFromFile));              % Initialize empty array same length as raw data
    highPassed = (highpass(rawdata.dataFromFile, 1, fs) .^ 2);   % Apply a highpass filter
    energy = energy(1:length(highPassed)) + highPassed';         
    % energy = energy + (highpass(rawdata.(s).(axis), fs, 1) .^ 2);
    % ^ This was what is was originally, flipped the "fs" and the
    % "1" because of there error "Warning: Specified passband 
    % frequency is beyond the Nyquist range so signal has been 
    % filtered with an allstop filter." 
    % Length was also not equal? 
    
    
    % Find mean energy from the windows
    m_energy = zeros(1, numel(energy));                          % Initialize empty array same length as raw data
    for j=1:length(energy)
        m_energy(j) = mean(energy(max(1, j - w_size + 1):j));    % Calculate the energy within a window
    end
    
    % --------------------------Find Events--------------------------------
    pass = false;
    while ~pass
        subplot(2, 1, 1);
        hold off;
        plot(m_energy);
        hold on
        plot([0 numel(m_energy)], [threshold threshold], 'r');
        subplot(2, 1, 2);
        hold off;
        plot(rawdata.dataFromFile);
        hold on;
        
        peaks_b = [];   % Where peaks begin (blue dots)
        peaks_e = [];   % Where peaks end (red dots)
        find_begin = true;
        for j=1:numel(m_energy)     % Traverse through all elements in mean energy list
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
        j = 2;
        while j <= numel(peaks_b)
            % If the distance between two events is smaller than the
            % min_interval, we combine them to form one event.
            if (peaks_b(j) + w_size) - peaks_e(j - 1) < min_interval
                peaks_b(j) = [];
                peaks_e(j - 1) = [];
            elseif peaks_b(j) <= peaks_e(j-1)
                peaks_b(j) = [];
                peaks_e(j - 1) = [];
            else
                j = j + 1;
            end
        end
        
        % ------------------------Filter Noise-----------------------------
        % If a signal is too short, it's probably noise and we can get rid
        % of it.
        j = 1;
        while j <= numel(peaks_b)
            if peaks_e(j) - peaks_b(j) < min_signal_len
                peaks_b(j) = [];
                peaks_e(j) = [];
            else
                j = j + 1;
            end
        end
        % -------------If not 30 points, pause and edit by hand--------------
        if length(peaks_b) ~= 30
            subplot(2, 1, 1);
            hold off;
            plot(m_energy);
            hold on
            plot([0 numel(m_energy)], [threshold threshold], 'r');
            title(folder + i);
            subplot(2, 1, 2);
            hold off;
            plot(rawdata.dataFromFile);
            hold on;
            for j=1:numel(peaks_b)
                plot([peaks_b(j) peaks_b(j)], [-0.02 0.02], 'b', 'linewidth', 1);
                plot([peaks_e(j) peaks_e(j)], [-0.02 0.02], 'r', 'linewidth', 1);
            end
            x = "PAUSE HERE! FILLER INSTRUCTION"; % use this line to pause! Press the line besides the "142" and adjust the peaks_b and peaks_e by hand! (Add more points, remove points, move points)
        end
        
        % ------------------------Plot Points-----------------------------
        for j=1:numel(peaks_b)
            plot([peaks_b(j) peaks_b(j)], [-0.02 0.2], 'b', 'linewidth', 1);
            plot([peaks_e(j) peaks_e(j)], [-0.02 0.2], 'r', 'linewidth', 1);
        end
        peaksize=size(peaks_b,2);
        pass = true;
    end
    % ------------------------Plot Graphs again-----------------------------
    subplot(2, 1, 1);
    hold off;
    plot(m_energy);
    hold on
    plot([0 numel(m_energy)], [threshold threshold], 'r');
    subplot(2, 1, 2);
    hold off;
    plot(rawdata.dataFromFile);
    hold on;
    for j=1:numel(peaks_b)
        plot([peaks_b(j) peaks_b(j)], [-0.2 0.2], 'b', 'linewidth', 1);
        plot([peaks_e(j) peaks_e(j)], [-0.2 0.2], 'r', 'linewidth', 1);
    end
    % ------------------------Save as Variable-----------------------------
    seginfo.peaks_b = [seginfo.peaks_b, peaks_b];
    seginfo.peaks_e = [seginfo.peaks_e, peaks_e];
    for j=1:numel(peaks_b)
            sample = rawdata.dataFromFile(peaks_b(j):peaks_e(j));
        data = [data, sample];
    end
    all_data = [all_data; rawdata.dataFromFile];
end


%% Save
labels = {};
for i=0:(num_key - 1)
    labels = [labels, i];
end
rawdata = all_data;

%d = datetime(now, 'ConvertFrom', 'datenum');

save(sprintf('segmented_data/%s_%s_%dkeyM.mat', date, "diego", num_key), 'labels', 'data', 'num_key' ,'seginfo', 'rawdata');
%save(sprintf('segmented_data/%s-%s-%dkey-%d-origin.mat', date, "diego", num_key, no + 1), 'labels', 'data', 'num_key' ,'seginfo', 'rawdata');


%% Augmentation
% Purpose of this algorithm is to get more data from our smaller set of
% data

% WIP

% mat = load(sprintf('../../data/%s-%s-%dkey-%d.mat', date, user, num_key, no + 1), 'num_key', 'seginfo', 'rawdata');
% num_key = mat.num_key;
% seginfo = mat.seginfo;
% rawdata = mat.rawdata;
% 
% aug_data = {};
% aug_labels = {};
% 
% for i=1:num_key
%     label = [];
%     for j=0:(num_key - 1)
%         label = [label, i - 1, j];
%     end
% 
%     for j=1:num_key
% %        for k=j:min((j + 1), num_key)
%          for k=j:10
%             for include_before=[true, false]
%                 for include_end=[true, false]
%                     if j == 1
%                         if include_before
%                             b = 1;
%                         else
%                             b = seginfo.peaks_b{i}(j);
%                         end
%                     else
%                         if include_before
%                             b = seginfo.peaks_e{i}(j - 1);
%                         else
%                             b = seginfo.peaks_b{i}(j);
%                         end
%                     end
%                     if k == num_key
%                         if include_end
%                             e = numel(rawdata(i));
%                         else
%                             e = seginfo.peaks_e{i}(k);
%                         end
%                     else
%                         if include_end
%                             e = seginfo.peaks_b{i}(k + 1);
%                         else
%                             e = seginfo.peaks_e{i}(k);
%                         end
%                     end
%                     range = b:e-3;
% 
% 
%                     sample = rawdata(i);
% 
% 
%                     aug_data = [aug_data, sample];
%                     aug_labels = [aug_labels, label(((j - 1) * 2 + 1):(k * 2))];
%                 end
%             end
%         end
%     end
% end
% 
% %% Save augment data
% 
% data = aug_data;
% labels= aug_labels;
% save(sprintf('daniel_data_segmented/%s-%s-%dkey-%d-augment.mat', date, "daniel", num_key, no + 1), 'labels', 'data', 'num_key' ,'seginfo', 'rawdata');
end
