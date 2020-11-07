clear; clc; close all;
victim1 = 'data_segmented/17-Aug-2020_diego_10key_sum_P1.mat';
victim2 = 'data_segmented/17-Aug-2020_diego_10key_sum_P2.mat';
victim3 = 'data_segmented/17-Aug-2020_diego_10key_sum_P3.mat';
victim4 = 'data_segmented/17-Aug-2020_diego_10key_sum_P4.mat';
victim5 = 'data_segmented/17-Aug-2020_diego_10key_sum_P5.mat';
mm = false;
ms = false;
zs = false;
[v1, ~] = prep_az_data(victim1);
[v2, ~] = prep_az_data(victim2);
[v3, ~] = prep_az_data(victim3);
[v4, ~] = prep_az_data(victim4);
[v5, ~] = prep_az_data(victim5);

if mm == true
    v1 = applyMinMax(v1);
    v2 = applyMinMax(v2);
    v3 = applyMinMax(v3);
    v4 = applyMinMax(v4);
    v5 = applyMinMax(v5);
end
if ms == true
    v1 = applyMapStd(v1);
    v2 = applyMapStd(v2);
    v3 = applyMapStd(v3);
    v4 = applyMapStd(v4);
    v5 = applyMapStd(v5);
end
if zs == true
    v1 = applyZScore(v1);
    v2 = applyZScore(v2);
    v3 = applyZScore(v3);
    v4 = applyZScore(v4);
    v5 = applyZScore(v5);
end

v1 = applyGCC(v1,1,0);
v2 = applyGCC(v2,1,0);
v3 = applyGCC(v3,1,0);
v4 = applyGCC(v4,1,0);
v5 = applyGCC(v5,1,0);

% v1 = concatenate(v1);
% v2 = concatenate(v2);
% v3 = concatenate(v3);
% v4 = concatenate(v4);
% v5 = concatenate(v5);

s1 = applyPCA(v1);
s2 = applyPCA(v2);
s3 = applyPCA(v3);
s4 = applyPCA(v4);
s5 = applyPCA(v5);
hold on
scatter3(s1(:,1),s1(:,2),s1(:,3),'.b')
scatter3(s2(:,1),s2(:,2),s2(:,3),'.r')
scatter3(s3(:,1),s3(:,2),s3(:,3),'.m')
scatter3(s4(:,1),s4(:,2),s4(:,3),'.g')
scatter3(s5(:,1),s5(:,2),s5(:,3),'.c')
xlabel('1st Principal Component')
ylabel('2nd Principal Component')
zlabel('3rd Principal Component')
hold off
s = vertcat(s1,s2,s3,s4,s5);
[res, C] = k_means(s);
disp("Accuracy: " + kmeans_acc(res) + "%");
kmeansgraph(s, res, C);
victim_data1 = kmeans_arr_prep(v1);
victim_data2 = kmeans_arr_prep(v2);
victim_data3 = kmeans_arr_prep(v3);
victim_data4 = kmeans_arr_prep(v4);
victim_data5 = kmeans_arr_prep(v5);

vplot = victim_data5;
figure;
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.1, 1, 0.5]);
for i = 1:length(vplot)
    hold on;
%     if i < 31 || i > 60
%         plot(vplot(i,1:end));
%     end
    plot(vplot(i,1:end));
    %pause(0.1);
    disp(i);
end
saveas(gcf, "f/5.png");
%--------------------------GCC Testing-------------------------
% clear;clc;
% close all;
% load("data_segmented/17-Aug-2020_diego_10key_sum_P2.mat", 'data');
% s = cell(1,length(data));
% sensor = 'a';
% axis = 'x';
% figure;
% subplot(1,3,1);
% plot(data{1,1}.(sensor).(axis));
% title("Alignment sample");
% subplot(1,3,2);
% for i = 1:length(data)
%     hold on;
%     s{i} = data{1,i}.(sensor).(axis);
%     plot(s{i});
% end
% title("Raw");
% hold off;
% g = modded_batchGCC(s{1},s,10);
% subplot(1,3,3);
% for i = 1:length(data)
%     hold on;
%     plot(g{i});
% end
% title("GCC");
% hold off;
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.1, 1, 0.5]);

%------------------------------------------------------------
% for i = 1:length(data)
%      hold on;
%      plot(g{1,i});
%      plot(data{1,i}.a.z);
% 
% %     plot(data{1,i}.a.x);
% %     plot(data{1,i}.a.y);
% %     plot(data{1,i}.a.z);
% %     plot(data{1,i}.g.x);
% %     plot(data{1,i}.g.y);
% %     plot(data{1,i}.g.z);
% %     title("Summed data of sample " + i + " (key " + idivide(int32(i-1), int32(30)) + ")");
%      hold off;
%      pause(2);
%      close all;
% end

% rawdata = loaddata("experiments/people/data_p/p2/", 2);
% % ------------------------------Sum------------------------------------
% m = min([length(rawdata.a.x),length(rawdata.a.y),length(rawdata.a.z), ...
%     length(rawdata.g.x), length(rawdata.g.y), length(rawdata.g.z)]);
% sum_data = zeros(1,m);
% for s='ag'
%     for axis='xyz'
%         sum_data = sum_data + rawdata.(s).(axis)(1,1:m);
%     end
% end
% %subplot(2, 1, 1);
% hold on;
% %plot(rawdata.a.x);
% %rawdata.a.y = rawdata.a.y(20:end-20);
% %plot(detrend(rawdata.a.z, 0), 'r')
% %rawdata.a.z = rawdata.a.z - rawdata.a.z(1);
% rawdata.a.z = detrend(rawdata.a.z, 0);
% [b,a] = butter(1,0.2,'low');
% f = filter(b, a,rawdata.a.z);
% %f = f(20:end-20);
% plot(rawdata.a.z(100:250),'m');
% plot(f(100:250),'b');
% %subplot(2, 1, 2);
% energy = zeros(1, numel(f));
% energy = energy + (highpass(f, 1, 200) .^ 2);
% m_energy = zeros(1, numel(energy));
% for j=1:length(energy)
%     m_energy(j) = mean(energy(max(1, j - int32(0.025 * 200) + 1):j));
% end
% %plot(m_energy(1:250),'r');
% 
% %f = f - 9;
% %plot(rawdata.a.y * -1);
% %plot(rawdata.a.z);
% %plot(rawdata.g.x);
% %plot(rawdata.g.y);
% %plot(rawdata.g.z);
% %plot(sum_data);