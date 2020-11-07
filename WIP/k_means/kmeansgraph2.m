function [] = kmeansgraph2(data, kmeans, C)
%% Graphs the results of the Kmeans Experiment 2 using MDS
%   param data: the originial data
%   param kmeans: the Kmeans resultant matrix
%   param C: the centroids of the Kmeans calculation

%% Figure 1
figure;
set(gcf,'position',[100,250,1000,450])
tiledlayout(1, 2)
nexttile;

hold on
D = pdist(C);
D = squareform(D);
[M, ~] = cmdscale(D, 2);
plot(M(:,1), M(:,2), 'kx', 'MarkerSize',10, 'LineWidth',3);

D = pdist(data);
D = squareform(D);
[M, ~] = cmdscale(D, 2);
plot(M(kmeans==1,1), M(kmeans==1,2), 'r.');
plot(M(kmeans==2,1), M(kmeans==2,2), 'g.');
plot(M(kmeans==3,1), M(kmeans==3,2), 'b.');
plot(M(kmeans==4,1), M(kmeans==4,2), 'm.');
plot(M(kmeans==5,1), M(kmeans==5,2), 'c.');
plot(M(kmeans==6,1), M(kmeans==6,2), 'r*');
plot(M(kmeans==7,1), M(kmeans==7,2), 'k.');
plot(M(kmeans==8,1), M(kmeans==8,2), 'k*');
plot(M(kmeans==9,1), M(kmeans==9,2), 'b*');
plot(M(kmeans==10,1), M(kmeans==10,2), 'm*');
title("1 attacker, 4 victim scenario");
hold off

%% Figure 2
nexttile;
hold on

for i = 1:10
    x = M(i,1);
    y = M(i,2);
    if i == 1
        hold on
        plot(x, y, 'kx', 'MarkerSize',10, 'LineWidth',3);
    elseif i == 2
        hold on
        plot(x, y, 'kx', 'MarkerSize',10, 'LineWidth',3);
    elseif i == 3
        hold on
        plot(x, y, 'kx', 'MarkerSize',10, 'LineWidth',3);
    elseif i == 4
        hold on
        plot(x, y, 'kx', 'MarkerSize',10, 'LineWidth',3);
    elseif i == 5
        hold on
        plot(x, y, 'kx', 'MarkerSize',10, 'LineWidth',3);
    elseif i == 6
        hold on
        plot(x, y, 'kx', 'MarkerSize',10, 'LineWidth',3);
    elseif i == 7
        hold on
        plot(x, y, 'kx', 'MarkerSize',10, 'LineWidth',3);
    elseif i == 8 
        hold on
        plot(x, y, 'kx', 'MarkerSize',10, 'LineWidth',3);
    elseif i == 9
        hold on
        plot(x, y, 'kx', 'MarkerSize',10, 'LineWidth',3);
    elseif i == 10
        hold on
        plot(x, y, 'kx', 'MarkerSize',10, 'LineWidth',3);
    else
        error("Something went wrong while plotting");
    end 
end

for v=1:4
    for k=0:9
        for s=1:30
            x = M(((v-1)*300 + 30*k + s),1);
            y = M(((v-1)*300 + 30*k + s),2);
            if k == 0
                hold on
                plot(x, y, 'r.', 'MarkerSize', 6);
            elseif k == 1
                hold on
                plot(x, y, 'g.', 'MarkerSize', 6);
            elseif k == 2
                hold on
                plot(x, y, 'b.', 'MarkerSize', 6);
            elseif k == 3
                hold on
                plot(x, y, 'c.', 'MarkerSize', 6);
            elseif k == 4
                hold on
                plot(x, y, 'm.', 'MarkerSize', 6);
            elseif k == 5
                hold on
                plot(x, y, 'r*', 'MarkerSize', 3);
            elseif k == 6
                hold on
                plot(x, y, 'k.', 'MarkerSize', 6);
            elseif k == 7 
                hold on
                plot(x, y, 'k*', 'MarkerSize', 3);
            elseif k == 8
                hold on
                plot(x, y, 'b*', 'MarkerSize', 3);
            elseif k == 9
                hold on
                plot(x, y, 'm*', 'MarkerSize', 3);
            else
                error("Something went wrong while plotting");
            end 
        end
    end
end
hold off
title("1 attacker, 4 victim scenario");
end