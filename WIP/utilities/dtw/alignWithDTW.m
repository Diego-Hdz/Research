function [ alignedData ] = alignWithDTW( base, data, n )
    alignedData = cell(size(data));
    for i=1:length(alignedData)
        alignedData{i} = zeros(size(data{i}));
    end

    for i=1:size(data{1}, 1)
        d = [];
        for j=1:length(data)
            d = [d; data{j}(i, :)];
        end

        [~, ix, iy] = dtw(base ./ max(base, [], 2), d ./ max(d, [], 2));
        [~, ia, ic] = unique(ix);
        tmp = d(:, iy);
        tmp = tmp(:, ia);

        for j=1:length(data)
            alignedData{j}(i, :) = tmp(j, :);
        end
    end
end