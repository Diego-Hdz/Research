function [ models ] = getOrientationGestureModels()
% 免训练方向手势模型定义/Definition of training-free direction gesture model
% condition 状态定义: ['field', 'action', 'threshold']
%                    Action
%                       options: '>', '<', '|>|', '|<|', 'convex', 'concave', 'angle28'
%                    Threshold
%                       options: number or axis: 'x', 'y', 'z'
    models = [...
        struct('id', 1, 'gesture', 'up', 'conditions', [...
            struct('field', 'yGyroData', 'action', '|>|', 'threshold', 'z'),...
            struct('field', 'yGyroData', 'action', 'convex', 'threshold', 10),...
        ]),...
        struct('id', 2, 'gesture', 'down', 'conditions', [...
            struct('field', 'yGyroData', 'action', '|>|', 'threshold', 'z'),...
            struct('field', 'yGyroData', 'action', 'concave', 'threshold', -10),...
        ]),...
        struct('id', 3, 'gesture', 'left', 'conditions', [...
            struct('field', 'zGyroData', 'action', 'convex', 'threshold', 10),...
        ]),...
        struct('id', 4, 'gesture', 'right', 'conditions', [...
            struct('field', 'zGyroData', 'action', 'concave', 'threshold', -10),...
        ]),...
        struct('id', 5, 'gesture', 'rotate', 'conditions', [...
            struct('field', 'xGyroData', 'action', 'concave', 'threshold', -40),...
        ]),...
    ];
end

