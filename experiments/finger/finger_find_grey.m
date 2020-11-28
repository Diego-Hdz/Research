function [grey] = finger_find_grey(i, m, r, avg, num_samples, key)
%% Calculate the grey values for the finger experiment
% Grey values are the average euclidean distance of each sample of
% keys not from a specified key from the specified average vector
%   param i: Index finger data
%   param m: Middle finger data
%   param r: Ring finger data
%   param avg: Average vector
%   param num_samples: The number of samples per key (30)
%   param key: The key being experimented on
num_keys = length(i)/num_samples; % 300/30 = 10
grey = [];
%% Index finger
for k = 0:num_keys-1
    i_avg_dist = 0;
    if k ~= key
        for s=1:num_samples
            i_sample = i{num_samples*k+s};
            i_sample_dist = norm(i_sample - avg);
            i_avg_dist = i_avg_dist + i_sample_dist;
        end
        grey = cat(2,grey,i_avg_dist/s);
    end
end

%% Middle finger
for k = 0:num_keys-1
    m_avg_dist = 0;
    if k ~= key
        for s=1:num_samples
            m_sample = m{num_samples*k+s};
            m_sample_dist = norm(m_sample - avg);
            m_avg_dist = m_avg_dist + m_sample_dist;
        end
        grey = cat(2,grey,m_avg_dist/s);
    end
end

%% Ring finger
for k = 0:num_keys-1
    r_avg_dist = 0;
    if k ~= key
        for s=1:num_samples
            r_sample = r{num_samples*k+s};
            r_sample_dist = norm(r_sample - avg);
            r_avg_dist = r_avg_dist + r_sample_dist;
        end
        grey = cat(2,grey,r_avg_dist/s);
    end
end
end