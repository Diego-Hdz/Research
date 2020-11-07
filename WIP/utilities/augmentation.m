function [] = augmentation(file, sample_num)
%% Creates 'new' data through an augmentation algorithm
%   param file: File containing the data (.mat)
%   param sample_num: Identifying dataset number

%% Augment
mat = load(file, 'labels', 'data', 'num_key' ,'seginfo', 'rawdata');
num_key = mat.num_key;
seginfo = mat.seginfo;
rawdata = mat.rawdata;
aug_data = {};
aug_labels = {};

labels = repelem([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 30);
for i=1:num_key
	for j=1:num_key
        for k=j:min((j + 1), num_key)
            for include_before=[true, false]
                for include_end=[true, false]
                    if j == 1
                        if include_before
                            b = 1;
                        else
                            b = seginfo.peaks_b{i}(j);
                        end
                    else
                        if include_before
                            b = seginfo.peaks_e{i}(j - 1);
                        else
                            b = seginfo.peaks_b{i}(j);
                        end
                    end
                    if k == num_key
                        if include_end
                            e = numel(rawdata(i).a.z);
                        else
                            e = seginfo.peaks_e{i}(k);
                        end
                    else
                        if include_end
                            e = seginfo.peaks_b{i}(k + 1);
                        else
                            e = seginfo.peaks_e{i}(k);
                        end
                    end
                    range = b:e-40; %orginially 3

                    for s='ag'
                        for axis='xyz'
                            sample.(s).(axis) = rawdata(i).(s).(axis)(range);
                        end
                    end

                    aug_data = [aug_data, sample];
                    aug_labels = [aug_labels, labels(((j - 1) * 2 + 1):(k * 2))];
                end
            end
        end
	end
end

%% Save as .mat
data = aug_data;
labels = aug_labels;
save(sprintf('data_augmented/%s_AUG_%d.mat', date, sample_num), 'labels', 'data', 'num_key' ,'seginfo', 'rawdata');
end