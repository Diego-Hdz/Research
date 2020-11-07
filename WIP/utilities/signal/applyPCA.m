function [sf] = applyPCA(data)
%% Applies PCA
%   param data: Input data
t = zeros(300,41);
sf = [];
for s = 'ag'
    for a = 'xyz'
        for i=1:300
            t(i,1:end) = data{1,i}.(s).(a);
        end
        [c,sc,l,ts,e] = pca(t);
        sf = horzcat(sf,sc(1:end,1:3));
    end
end

% [c,s,l,t,e] = pca(t);
% disp(e)
% %scatter3(s(:,1),s(:,2),s(:,3),'.b')
% coeff = 0;

% ax = zeros(30,length(data{1,1}.a.x));
% ay = zeros(30,length(data{1,1}.a.x));
% az = zeros(30,length(data{1,1}.a.x));
% gx = zeros(30,length(data{1,1}.a.x));
% gy = zeros(30,length(data{1,1}.a.x));
% gz = zeros(30,length(data{1,1}.a.x));
% for i=0:9
%     for s=1:30
%         ax(s,1:end) = data{1,30*i+s}.a.x;
%         ay(s,1:end) = data{1,30*i+s}.a.y;
%         az(s,1:end) = data{1,30*i+s}.a.z;
%         gx(s,1:end) = data{1,30*i+s}.g.x;
%         gy(s,1:end) = data{1,30*i+s}.g.y;
%         gz(s,1:end) = data{1,30*i+s}.g.z;
%         disp(30*i+s);
%     end
%     [c,s,l,t,e] = pca(ax);
%     ay = pca(ay);
%     az = pca(az);
%     gx = pca(gx);
%     gy = pca(gy);
%     gz = pca(gz);
% end
% coeff = 0;
end