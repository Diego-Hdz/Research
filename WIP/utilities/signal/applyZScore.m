function [z_data] = applyZScore(data)
%% Performs z-score normalization on data
%   param data: Input data
for i=1:length(data(1,1:end))
    data{1,i}.a.x = normalize(data{1,i}.a.x,2,'zscore','std');
    data{1,i}.a.y = normalize(data{1,i}.a.y,2,'zscore','std');
    data{1,i}.a.z = normalize(data{1,i}.a.z,2,'zscore','std');
    data{1,i}.g.x = normalize(data{1,i}.g.x,2,'zscore','std');
    data{1,i}.g.y = normalize(data{1,i}.g.y,2,'zscore','std');
    data{1,i}.g.z = normalize(data{1,i}.g.z,2,'zscore','std');
end
z_data = data;
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
%     hold on;
%     plot(ax','r')
%     ax = normalize(ax,2,'zscore','std');
%     ay = normalize(ay,2,'zscore','std');
%     az = normalize(az,2,'zscore','std');
%     gx = normalize(gx,2,'zscore','std');
%     gy = normalize(gy,2,'zscore','std');
%     gz = normalize(gz,2,'zscore','std');
%     plot(ax','b')
%     hold off;
%     close all;
%     for s=1:30
%         data{1,30*i+s}.a.x = ax(s,1:end);
%         data{1,30*i+s}.a.y = ay(s,1:end);
%         data{1,30*i+s}.a.z = az(s,1:end);
%         data{1,30*i+s}.g.x = gx(s,1:end);
%         data{1,30*i+s}.g.y = gy(s,1:end);
%         data{1,30*i+s}.g.z = gz(s,1:end);
%     end
% end
% z_data = data;

% ax = zeros(length(data),length(data{1,1}.a.x));
% ay = zeros(length(data),length(data{1,1}.a.x));
% az = zeros(length(data),length(data{1,1}.a.x));
% gx = zeros(length(data),length(data{1,1}.a.x));
% gy = zeros(length(data),length(data{1,1}.a.x));
% gz = zeros(length(data),length(data{1,1}.a.x));
% for i=1:length(data(1,1:end))
%     ax(i,1:end) = data{1,i}.a.x;
%     ay(i,1:end) = data{1,i}.a.y;
%     az(i,1:end) = data{1,i}.a.z;
%     gx(i,1:end) = data{1,i}.g.x;
%     gy(i,1:end) = data{1,i}.g.y;
%     gz(i,1:end) = data{1,i}.g.z;
% end
% % hold on
% % plot(ax'+5)
% % ax = zscore(ax,0,2);
% % plot(ax')
% % hold off
% % close all;
% ax = normalize(ax,2);
% ay = normalize(ay,2);
% az = normalize(az,2);
% gx = normalize(gx,2);
% gy = normalize(gy,2);
% gz = normalize(gz,2);
% 
% for i=1:length(data)
%     data{1,i}.a.x = ax(i,1:end);
%     data{1,i}.a.y = ay(i,1:end);
%     data{1,i}.a.z = az(i,1:end);
%     data{1,i}.g.x = gx(i,1:end);
%     data{1,i}.g.y = gy(i,1:end);
%     data{1,i}.g.z = gz(i,1:end);
% end
% z_data = data;
end