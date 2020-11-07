% 由手表应用采集的单个数据合并成 mat 文件

clc; clear;

DATA_FOLDER = '/Users/diegohernandez/Desktop/tap_data'; %changed from '/Users/chenlin/PencilCloud/rawdata/ftpdata/tmp'
SAVE_FILENAME = './data/knuckle.mat'; %changed from '../data/number.mat'

KEY_NUM = 4; %changed from 10
PER_KEY_NUM = 30; %changed from _
FIELD_LIST = {'xAcceData', 'yAcceData', 'zAcceData',...
    'xGyroData', 'yGyroData', 'zGyroData'};

alldata = {[], [], [], [], [], []};
%{
for k=1:KEY_NUM
    for i=1:PER_KEY_NUM
        for fi=1:size(FIELD_LIST, 2)
            field = FIELD_LIST{fi};
            data = dlmread(sprintf('%s/%s%d', DATA_FOLDER, field, (i - 1) * KEY_NUM + k - 1));
            alldata{fi} = [alldata{fi}; {data}];
        end
    end
end
%}

for k=1:KEY_NUM
    for fi=1:size(FIELD_LIST, 2)
        field = FIELD_LIST{fi};
        data = dlmread(sprintf('%s/%s%d.csv', DATA_FOLDER, field, k));
        alldata{fi} = [alldata{fi}; {data}];
    end
end

xadata = alldata{1};
yadata = alldata{2};
zadata = alldata{3};
xgdata = alldata{4};
ygdata = alldata{5};
zgdata = alldata{6};

save(SAVE_FILENAME, 'xadata', 'yadata', 'zadata', 'xgdata', 'ygdata', 'zgdata');
