function [grey] = finger_find_grey(i, m, r, avg, key)
%% Calculate the grey values for the finger experiment
% Grey values are the average euclidean distance of each sample of
% keys not from a specified key from the specified average vector
%   param i: Index finger data
%   param m: Middle finger data
%   param r: Ring finger data
%   param avg: Average vector
%   param key: Key of the samples to be excluded
grey = [];
%% Index finger
i_avg_dist = 0;
for k = 0:9
    if k ~= key
        for s=1:30
            i_sample = i{10*k+s};
            i_sample_dist = norm(i_sample - avg);
            i_avg_dist = i_avg_dist + i_sample_dist;
        end
        grey = cat(2,grey,i_avg_dist/s);
    end
end

%% Middle finger
m_avg_dist = 0;
for k = 0:9
    if k ~= key
        for s=1:30
            m_sample = m{10*k+s};
            m_sample_dist = norm(m_sample - avg);
            m_avg_dist = m_avg_dist + m_sample_dist;
        end
        grey = cat(2,grey,m_avg_dist/s);
    end
end

%% Ring finger
r_avg_dist = 0;
for k = 0:9
    if k ~= key
        for s=1:30
            r_sample = r{10*k+s};
            r_sample_dist = norm(r_sample - avg);
            r_avg_dist = r_avg_dist + r_sample_dist;
        end
        grey = cat(2,grey,r_avg_dist/s);
    end
end
end