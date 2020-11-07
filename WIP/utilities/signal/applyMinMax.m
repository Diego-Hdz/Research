function [minmax_data] = applyMinMax(data)
%% Applies Min-Max, maps values to [-1,1]
%   param data: data
for i=1:length(data(1,1:end))
    data{1,i}.a.x = mapminmax(data{1,i}.a.x);
    data{1,i}.a.y = mapminmax(data{1,i}.a.y);
    data{1,i}.a.z = mapminmax(data{1,i}.a.z);
    data{1,i}.g.x = mapminmax(data{1,i}.g.x);
    data{1,i}.g.y = mapminmax(data{1,i}.g.y);
    data{1,i}.g.z = mapminmax(data{1,i}.g.z);
end
minmax_data = data;
end