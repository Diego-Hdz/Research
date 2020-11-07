clc; clear;

addpath('./util');

FS = 100;
MODELS = getStrokeGestureModels();

FIELD_LIST = {'xGyroData', 'yGyroData', 'zGyroData'};
FIELD_LEN= size(FIELD_LIST, 2);

DATA_FODLER = './data/stroke/';

confusionMatrix = zeros(6, 6);

for number=0:29
    data = cell(1, 3);
    rawdata = cell(1, 3);
    for fi=1:FIELD_LEN
        field = FIELD_LIST{fi};
        tmp = dlmread(sprintf('%s%s%d', DATA_FODLER, field, number));
        rawdata{fi} = tmp;

        for i=1:length(tmp) - 10
            tmp(i) = mean(tmp(i:i + 10));
        end
        tmp(abs(tmp) < 0.2) = 0;

        data{fi} = tmp;
    end

    lines = [];
    minLen = 20;

    bp = {-1, -1, -1}; % 起始位置
    isDetectEnd = [false, false, false];
    backupBp = [-1, -1, -1];
    waitSecondZero = [false, false, false];
    count = [0, 0, 0];
    maxAbsVal = [-1, -1, -1];
    lastVal = [0, 0, 0];
    for i=1:length(data{1})
        for fi=1:FIELD_LEN
            val = data{fi}(i);
            
            if isDetectEnd(fi)
                isDetectEnd(fi) = (count(fi) < 7) && (rawdata{fi}(i) < rawdata{fi}(i - 1));
                if isDetectEnd(fi)
                    count(fi) = count(fi) + 1;
                else
                    lines = [lines, [backupBp(fi), i - 1]];
                end
            end
            
            if waitSecondZero(fi)
                waitSecondZero(fi) = false;
                
                if val == 0
                    sigLen = i - bp{fi}(1);

                    if sigLen > minLen
                        overlap = false;
                        for fieldIndex2 = 1:FIELD_LEN
                            if fieldIndex2 ~= fi && 0 < bp{fieldIndex2}(end)
                                if bp{fieldIndex2}(end) < bp{fi}(end)
                                    overlap = true;
                                    break;
                                end
                            end
                        end
                        if ~overlap
                            for fieldIndex2 = 1:FIELD_LEN
                                if fieldIndex2 ~= fi && 0 < bp{fieldIndex2}(end)
                                    if (bp{fieldIndex2}(end) == bp{fi}(end) && maxAbsVal(fi) < maxAbsVal(fieldIndex2))
                                        overlap = true;
                                    elseif (i - bp{fieldIndex2}(end)) / (i - bp{fi}(end)) >= 0.2
                                        overlap = true;
                                        bp{fieldIndex2} = [bp{fi}(1), bp{fieldIndex2}(end)];
                                    end
                                end
                            end
                        end

                        if ~overlap
                            isDetectEnd(fi) = true;
                            backupBp(fi) = bp{fi}(1);
                            count(fi) = 0;
                        end
                    end

                    bp{fi} = -1;
                    maxAbsVal(fi) = -1;
                end
            else
                crossZero = val * lastVal(fi) == 0 && ~(val == 0 && lastVal(fi) == 0);

                if crossZero
                    if bp{fi}(end) < 0
                        if val ~= 0
                            bp{fi} = i - 1;
                        end
                    else
                        waitSecondZero(fi) = true;
                    end
                end
            end

            lastVal(fi) = val;
            if bp{fi}(end) >= 0
                maxAbsVal(fi) = max([abs(val), maxAbsVal(fi)]);
            end
        end
    end

    classifiedRes = [];
    allInfo = '';
    for j=1:2:length(lines)
        b = lines(j);
        e = lines(j + 1);

        signal = {};
        for fi=1:FIELD_LEN
            fieldData = rawdata{fi};
            field = FIELD_LIST{fi};
            signal.(field) = fieldData(b:e);
        end

        [isFound, model] = trainingFreeClassifier(signal, MODELS);

        if isFound
            classifiedRes = [classifiedRes, model];
            allInfo = sprintf('%s%s ', allInfo, model.gesture);
        else
            allInfo = sprintf('%sempty ', allInfo);
        end
    end

    for i=1:length(classifiedRes)
        m = classifiedRes(i);
        fprintf('%s ', m.gesture);
        confusionMatrix(i, m.id) = confusionMatrix(i, m.id) + 1;
    end
    fprintf(' <- %s\n', allInfo);
end

confusionMatrix
