%% Saves az data to folders organized by person
clear; clc; close all;

%% Create Data Directories
mkdir("data_export");
mkdir("data_export/withGCC");
mkdir("data_export/withoutGCC");

%% Preparation
[p1_data, p1_s] = prep_az_data("12-Aug-2020_diego_10key_sum_P1.mat");
[p2_data, p2_s] = prep_az_data("12-Aug-2020_diego_10key_sum_P2.mat");
[p3_data, p3_s] = prep_az_data("12-Aug-2020_diego_10key_sum_P3.mat");
[p4_data, p4_s] = prep_az_data("12-Aug-2020_diego_10key_sum_P4.mat");
[p5_data, p5_s] = prep_az_data("12-Aug-2020_diego_10key_sum_P5.mat");

%% Adjustments
shortest = min([p1_s, p2_s, p3_s, p4_s, p5_s]);
p1_data = shorten_az(p1_data, shortest);
p2_data = shorten_az(p2_data, shortest);
p3_data = shorten_az(p3_data, shortest);
p4_data = shorten_az(p4_data, shortest);
p5_data = shorten_az(p5_data, shortest);

% %% Concatenation of data (ax-ay-az-gx-gy-gz)
% p1_data = concatenate(p1_data);
% p2_data = concatenate(p2_data);
% p3_data = concatenate(p3_data);
% p4_data = concatenate(p4_data);
% p5_data = concatenate(p5_data);

%% Apply GCC
p1_gcc_data = modded_batchGCC(p1_data{1},p1_data,0);
p2_gcc_data = modded_batchGCC(p2_data{1},p2_data,0);
p3_gcc_data = modded_batchGCC(p3_data{1},p3_data,0);
p4_gcc_data = modded_batchGCC(p4_data{1},p4_data,0);
p5_gcc_data = modded_batchGCC(p5_data{1},p5_data,0);

%% Create Person Directories
for p=1:5
    mkdir(sprintf("data_export/withGCC/p%d",p));
    mkdir(sprintf("data_export/withoutGCC/p%d",p));
end

%% Save withoutGCC data
save_data(p1_data, 1, false);
save_data(p2_data, 2, false);
save_data(p3_data, 3, false);
save_data(p4_data, 4, false);
save_data(p5_data, 5, false);

%% Save withGCC data
save_data(p1_gcc_data, 1, true);
save_data(p2_gcc_data, 2, true);
save_data(p3_gcc_data, 3, true);
save_data(p4_gcc_data, 4, true);
save_data(p5_gcc_data, 5, true);