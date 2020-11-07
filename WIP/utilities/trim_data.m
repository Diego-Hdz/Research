function [] = trim_data(path, file, trim)
%% Trims a specified amount off of the beginning of a .wav data file
%   param path: Folder name
%   param file: A number representing the file name
%   param trim: Amount of data to trim
%% Read .wav, create file and folder destination
filename = path + file + ".wav";
[data, fs] = audioread(filename);
trim_folder = "trim_" + path;
mkdir(trim_folder);
%% Trim and save
data = data(trim:end);
audiowrite(filename, data, fs);
movefile(filename, trim_folder);
end