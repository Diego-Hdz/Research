function [mapstd_data] = applyMapStd(data)
%% Applies MapStd, maps means to 0 and deviations to 1
%   param data: Input data
mapstd_data = data;
for i=1:length(data(1,1:end))
    data{1,i}.a.x = mapstd(data{1,i}.a.x);
    data{1,i}.a.y = mapstd(data{1,i}.a.y);
    data{1,i}.a.z = mapstd(data{1,i}.a.z);
    data{1,i}.g.x = mapstd(data{1,i}.g.x);
    data{1,i}.g.y = mapstd(data{1,i}.g.y);
    data{1,i}.g.z = mapstd(data{1,i}.g.z);
end
end