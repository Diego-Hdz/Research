function [tempStruct] = loaddata(path,file)
%% Loads IMU data from a folder of csv files
%   param path: Path to data folder
%   param file: Identifying file name
% OLD CODE
% a_filename = path + "Accelerometer_" + num2str(file) + ".csv";
% g_filename = path + "Gyroscope_" + num2str(file) + ".csv";

%% Extract data
% Ex: "Accelerometer-0001.csv", "Gyroscope-0023.csv"
a_filename = path + "Accelerometer-" + num2str(file, '%04d') + ".csv";
g_filename = path + "Gyroscope-" + num2str(file, '%04d') + ".csv";
a_matrix = readmatrix(a_filename, 'Range', 1);
a_matrix(:,1) = [];
g_matrix = readmatrix(g_filename, 'Range', 1);
g_matrix(:,1) = [];

%% Build Struct
tempStruct = struct("a", struct("x", [], "y", [], "z", []), "g", struct("x", [], "y", [], "z", []));
tempStruct.a.x = a_matrix(1,:);
tempStruct.a.y = a_matrix(2,:);
tempStruct.a.z = a_matrix(3,:);
tempStruct.g.x = g_matrix(1,:);
tempStruct.g.y = g_matrix(2,:);
tempStruct.g.z = g_matrix(3,:);
end