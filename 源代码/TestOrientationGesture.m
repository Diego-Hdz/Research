clc; clear;

addpath('./util');

FIELDS = { 'xGyroData', 'yGyroData', 'zGyroData' };

GESTURE_MODELS = getOrientationGestureModels();
DATASET = [...
    struct('gestureModel', GESTURE_MODELS(1), 'path', 'orientation', 'numberList', 0:5:149),...
    struct('gestureModel', GESTURE_MODELS(2), 'path', 'orientation', 'numberList', 1:5:149),...
    struct('gestureModel', GESTURE_MODELS(3), 'path', 'orientation', 'numberList', 2:5:149),...
    struct('gestureModel', GESTURE_MODELS(4), 'path', 'orientation', 'numberList', 3:5:149),...
    struct('gestureModel', GESTURE_MODELS(5), 'path', 'orientation', 'numberList', 4:5:149),...
];

confusionMatrix = zeros(length(DATASET), length(GESTURE_MODELS) + 1);
for d=1:length(DATASET)
    dataset = DATASET(d);

    fprintf('============= Gesture %s ============\n', dataset.gestureModel.gesture);

    dataPath = sprintf('./data/%s/', dataset.path);
    rightCount = 0;
    for number=dataset.numberList
        data = {};
        for f=1:length(FIELDS)
            field = FIELDS{f};
            filepath = sprintf('%s%s%d', dataPath, field, number);
            data.(field) = dlmread(filepath);
        end

        [isFound, model] = trainingFreeClassifier(data, GESTURE_MODELS);

        if isFound
            gestureId = model.id;
            fprintf('%s\n', model.gesture);
        else
            gestureId = 0;
            fprintf('noise\n');
        end

        confusionMatrix(d, gestureId + 1) = confusionMatrix(d, gestureId + 1) + 1;
    end

    fprintf('%s: %.2f\n', dataset.gestureModel.gesture, confusionMatrix(d, dataset.gestureModel.id + 1) / sum(confusionMatrix(d, :)));
end

fprintf('============== Statistics ===============\n');
fprintf('mean: %.2f\n', sum(diag(confusionMatrix, 1)) / sum(sum(confusionMatrix)));
confusionMatrixPercent = confusionMatrix ./ sum(confusionMatrix, 2);
