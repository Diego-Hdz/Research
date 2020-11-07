%% People Experiment Script
clc; clear; close all;
p1_file = "15-Jul-2020_diego_10keyP1.mat";
p2_file = "15-Jul-2020_diego_10keyP2.mat";
p3_file = "15-Jul-2020_diego_10keyP3.mat";
p4_file = "15-Jul-2020_diego_10keyP4.mat";
p5_file = "15-Jul-2020_diego_10keyP5.mat";

for i=0:9
    [grey, red] = people(p1_file, p2_file, p3_file, p4_file, p5_file, i);
end