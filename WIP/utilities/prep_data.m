function [data,shortest] = prep_data(folder)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
load(folder, 'data');
shortest = data{1,1}.a.x;
for i=2:size(data)
    if length(data{1,i}.a.x) < shortest
        shortest = length(data{1,i}).a.x;
    end
end

