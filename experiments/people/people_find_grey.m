function [grey] = people_find_grey(p1, p2, p3, p4, p5, avg, key)
%% Calculate the grey values for the finger experiment
% Grey values are the average euclidean distance of each sample of
% keys not from a specified key from the specified average vector
%   param p1: the p1 data
%   param p2: the p2 data
%   param p3: the p3 data
%   param p4: the p4 data
%   param p5: the p5 data
%   param avg: the average vector of key
%   param key: the key of the samples to be excluded
grey = [];
%% Person 1
for k = 0:9
    p1_avg_dist = 0;
    if k ~= key
        for s=1:30
            p1_sample = p1{10*k+s};
            p1_sample_dist = norm(p1_sample - avg);
            p1_avg_dist = p1_avg_dist + p1_sample_dist;
        end
        grey = cat(2,grey,p1_avg_dist/s);
    end
end

%% Person 2
for k = 0:9
    p2_avg_dist = 0;
    if k ~= key
        for s=1:30
            p2_sample = p2{10*k+s};
            p2_sample_dist = norm(p2_sample - avg);
            p2_avg_dist = p2_avg_dist + p2_sample_dist;
        end
        grey = cat(2,grey,p2_avg_dist/s);
    end
end

%% Person 3
for k = 0:9
    p3_avg_dist = 0;
    if k ~= key
        for s=1:30
            p3_sample = p3{10*k+s};
            p3_sample_dist = norm(p3_sample - avg);
            p3_avg_dist = p3_avg_dist + p3_sample_dist;
        end
        grey = cat(2,grey,p3_avg_dist/s);
    end
end

%% Person 4
for k = 0:9
    p4_avg_dist = 0;
    if k ~= key
        for s=1:30
            p4_sample = p4{10*k+s};
            p4_sample_dist = norm(p4_sample - avg);
            p4_avg_dist = p4_avg_dist + p4_sample_dist;
        end
        grey = cat(2,grey,p4_avg_dist/s);
    end
end

%% Person 5
for k = 0:9
    p5_avg_dist = 0;
    if k ~= key
        for s=1:30
            p5_sample = p5{10*k+s};
            p5_sample_dist = norm(p5_sample - avg);
            p5_avg_dist = p5_avg_dist + p5_sample_dist;
        end
        grey = cat(2,grey,p5_avg_dist/s);
    end
end
end