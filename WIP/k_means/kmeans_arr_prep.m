function [new_arr] = kmeans_arr_prep(cell)
%% Concatenates each of the input's data vertically in an array
%   param cell: A cell object containing arrays of data
new_arr = [];
for k = 0:9
    for s = 1:30
        new_arr = vertcat(new_arr, cell{30*k+s});
    end
end 
end