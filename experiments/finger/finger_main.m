%% Finger Experiment Script
clc; clear; close all;
index_finger_file = "13-Jul-2020_diego_10keyAG_I.mat";
middle_finer_file = "13-Jul-2020_diego_10keyAG_M.mat";
ring_finger_file = "13-Jul-2020_diego_10keyAG_R2.mat";
num_samples = 30;
repeated = true;

for i=0:9
    [grey, red] = finger(index_finger_file, middle_finer_file, ring_finger_file, i, num_samples, repeated);
end