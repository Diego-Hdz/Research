function [ isFound, model ] = trainingFreeClassifier( data, models )
    FS = 100;

    LEFT_THRESHOLD = 5;
    RIGHT_THRESHOLD = 10;
    FLAT_VALE_RATIO = 0.6;
    MAX_FLAT_VALE_RATIO = 2;

    isFound = false;
    model = {};

    fields = fieldnames(data);
    axisesInfo = {};
    for f=1:length(fields)
        axisesInfo.(fields{f}) = getAxisInfo(data.(fields{f}), FS, FLAT_VALE_RATIO, MAX_FLAT_VALE_RATIO);
    end

    for g=1:length(models)
        m = models(g);
        res = judge(m, axisesInfo, LEFT_THRESHOLD, RIGHT_THRESHOLD);
        if res
            isFound = true;
            model = m;
            break;
        end
    end

end

function [ res ] = judge( model, axisesInfo, LEFT_THRESHOLD, RIGHT_THRESHOLD )
    conditions = model.conditions;
    res = true;
    for c=1:length(conditions)
        res = judgeCondition(conditions(c), axisesInfo, LEFT_THRESHOLD, RIGHT_THRESHOLD);
        if ~res
            break;
        end
    end
end

function [ axisInfo ] = getAxisInfo( data, FS, FLAT_VALE_RATIO, MAX_FLAT_VALE_RATIO )
        cs = cumsum(data .* (1 / FS)) .* 180 / pi;

        [hasVale, left, right, vale, absMax] = findVale(cs, FLAT_VALE_RATIO, MAX_FLAT_VALE_RATIO);
        [leftFeature, rightFeature] = getFeature(cs, left, right);

        axisInfo = struct(...
            'data', cs, 'hasVale', hasVale,...
            'left', left, 'leftValue', cs(left),...
            'right', right, 'rightValue', cs(right),...
            'vale', vale, 'value', cs(vale),...
            'absMax', absMax,...
            'leftFeature', leftFeature, 'rightFeature', rightFeature...
        );
end

function [ res ] = judgeCondition( cond, axisesInfo, LEFT_THRESHOLD, RIGHT_THRESHOLD )
    axisInfo = axisesInfo.(cond.field);
    action = cond.action;
    threshold = cond.threshold;

    switch threshold
        case 'x'
            threshold = axisesInfo.xGyroData.absMax;
        case 'y'
            threshold = axisesInfo.yGyroData.absMax;
        case 'z'
            threshold = axisesInfo.zGyroData.absMax;
    end

    switch action
        case '<'
            res = axisInfo.absMax < threshold;
        case '>'
            res = axisInfo.absMax > threshold;
        case '|<|'
            res = abs(axisInfo.absMax) < abs(threshold);
        case '|>|'
            res = abs(axisInfo.absMax) > abs(threshold);
        case 'convex'
            res = axisInfo.hasVale &&...
                axisInfo.value > threshold &&...
                axisInfo.leftFeature < LEFT_THRESHOLD &&...
                axisInfo.rightFeature < RIGHT_THRESHOLD;
        case 'concave'
            res = axisInfo.hasVale &&...
                axisInfo.value < threshold &&...
                axisInfo.leftFeature < LEFT_THRESHOLD &&...
                axisInfo.rightFeature < RIGHT_THRESHOLD;
        case 'angle28'
            a1 = abs(axisInfo.absMax);
            a2 = abs(threshold);
            rad = atan(a1 / a2);
            res = rad > 0.488; % 0.488rad ≈ 28°
        case 'angle12'
            a1 = abs(axisInfo.absMax);
            a2 = abs(threshold);
            rad = atan(a1 / a2);
            res = rad > 0.21; % 0.21rad ≈ 12°
        otherwise
            res = true;
    end
end

function [ leftFeature, rightFeature ] = getFeature( data, left, right )
    leftFeature = var(data(1:left));
    rightFeature = var(data(right:end));
end

function [ hasVale, left, right, vale, absMax ] = findVale( data, FLAT_VALE_RATIO, MAX_FLAT_VALE_RATIO )
    hasVale = false;
    left = 1;
    right = length(data);
    absMax = data(1);
    maxAbsVale = -1;
    for i=2:length(data)
        if i == length(data) || (data(i) ~= data(i - 1) && (data(i) - data(i - 1)) * (data(i) - data(i + 1)) >= 0)

            if abs(data(i)) > abs(absMax)
                absMax = data(i);
            end

            if exist('vale', 'var')
                valeValue = data(vale);

                if maxAbsVale < abs(valeValue)
                    maxAbsVale = abs(valeValue);
                    if data(vale) == 0 || (data(vale) * (data(vale) - data(vale - 1)) > 0 || data(vale) * (data(vale) - data(vale + 1)) > 0)
                        thres = valeValue * FLAT_VALE_RATIO;
                        if i - left > 40 && (data(i) - thres) * valeValue <= 0 && abs(data(i)) <= abs(valeValue * MAX_FLAT_VALE_RATIO)
                            hasVale = true;
                            v = [left, vale, i];
                        end
                    end
                end

                left = vale;
            end
            vale = i;
        end
    end

    if hasVale
        left = v(1);
        vale = v(2);
        right = v(3);
    end
end
