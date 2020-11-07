function [ peakBeg,peakEnd ] = seg_var( data,fs )
%使用方差表示信号的能量/Uses variance to represent the energy of the signal
    peakBeg = [];
    peakEnd = [];
    % 参数设置/parameter settings
    dataLen=length(data);   % 信号长度/Signal length
    frameEnergy=[];         % 帧能量/Frame energy
    frameLen=200/1000*fs;   % 帧长/Frame length
    frameMove=20/1000*fs;   % 帧移/Frame shift
    frameNum=(dataLen-frameLen)/frameMove+1;    % 帧数/Number of frames
    thres=1e5;             % 阈值/Threshold
    minPeakLen=0.5;           % 可接受的一个峰的最短总长度（帧），如果小于该长度，则将该峰删除/Acceptable minimum total length of a peak (frame), if less than this length, the peak is deleted
    minInterval=30;          % 可接受的相邻峰最小间隔（帧），如果相邻两峰小于该间隔，则后一个峰被删除/Acceptable minimum interval between adjacent peaks (frames), if two adjacent peaks are smaller than this interval, the latter peak is deleted
    peakLen=8;             % 一个峰需要的长度（帧)/Length required for one peak (frame)
    delBegLen=40;           % 信号开头需要平滑的峰长度，如不需要平滑信号开头可设为0/The peak length of the signal needs to be smoothed, if the smoothing of the signal is not needed, it can be set to 0
    Debug=1;                % 是否画图/Whether to draw
    isWarning=1;            % 是否警告/Whether to warn
    
    % 获取帧能量/Get frame energy
    for i=1:frameNum
        frameBeg=(i-1)*frameMove+1;             % 每帧的开始位置/Start of each frame
        frameEnd=frameBeg+frameLen-1;           % 每帧的结束位置/End of each frame
        tmpFrame=data(frameBeg:frameEnd);       % 获取当前帧/Get current frame
        tmpFrame=(tmpFrame-mean(tmpFrame));
        tmpFrame=tmpFrame.*hamming(frameLen)';  % 加窗（汉明窗）Add window (Hanming window)
        tmpEnergty=sum(tmpFrame.^2);            % 计算方差/Calculate variance
        frameEnergy=[frameEnergy,tmpEnergty];   % 记录帧能量/Record frame energy
    end
    
    % 把前面几帧变小，使前面几帧不影响阈值判断/Reduce the previous frames so that the previous frames do not affect the threshold judgment
    for i=1:delBegLen
        frameEnergy(i)=frameEnergy(i)*i/delBegLen/2;
    end
    
    % 寻找起始点与结束点/Find starting and ending points
    begFrame=[];
    endFrame=[];
    flag=1;
    for i=1:frameNum
        % 起始点/Starting point
        if frameEnergy(i)>thres && flag==1
            begFrame=[begFrame,i];
            flag=0;
        end
        % 结束点/End point
        if frameEnergy(i)<=thres && flag==0
            endFrame=[endFrame,i];
            flag=1;
            i = i - 10;
        end
    end
    
    % 删除极短峰/Delete very short peaks
    peakNum=length(endFrame);
    i=1;
    while i<=peakNum
        if endFrame(i)-begFrame(i)<minPeakLen
            if isWarning==1
                disp('发现极短峰！已删除。')
            end
            begFrame(i)=[];
            endFrame(i)=[];
            i=i-1;
            peakNum=peakNum-1;
        end
        i=i+1;
    end
    
    % 合并相邻峰/Merge adjacent peaks
    peakNum=length(endFrame);
    i=2;
    while i<=peakNum
        if begFrame(i)-endFrame(i-1)<minInterval
            if isWarning==1
                disp('发现相邻峰相隔太近！已删除后一个峰。') %Found that adjacent peaks are too close together! The last peak has been deleted
            end
            begFrame(i)=[];
            endFrame(i)=[];
            i=i-1;
            peakNum=peakNum-1;
        end
        i=i+1;
    end
    
    % 异常检测/abnormal detection
    if isempty(begFrame)
        disp('没有切割到峰！'); %No cutting to the peak!
        result=-1;
    else
        % 获取原始数据的起始与结束位置/Get the starting and ending positions of the original data
        endFrame=begFrame+peakLen;      %输出峰取固定长度/The output peak takes a fixed length
        peakBeg=begFrame.*frameMove;    %计算真实起始位置/Calculate the real starting position
        peakEnd=endFrame.*frameMove;    %计算真实结束位置/Calculate true end position
        peakBeg=peakBeg + 20;            %增加缓存区/Increase the cache area
        peakEnd=peakEnd + 150;           %增加缓存区/Increase the cache area
        result=1;

        % 出现结束点超过信号长度的情况/The end point exceeds the signal length
        if peakEnd(end)>dataLen
            if peakEnd(end)-dataLen>peakLen*frameMove*0.25
                % 该峰不够完整/The peak is not complete
                if isWarning==1
                    disp('起始数组与结束数组不一致！已自动删除最后一个起始点'); %The start array and the end array are inconsistent! The last starting point has been automatically deleted
                end
                peakBeg(end)=[];
                peakEnd(end)=[];
            else
                % 该峰足够完整/The peak is complete enough
                if isWarning==1
                    disp('起始数组与结束数组不一致！已自动取信号尾部为结束点'); %The start array and the end array are inconsistent! The tail of the signal has been automatically taken as the end point
                end
                peakEnd(end)=dataLen;      %计算真实结束位置/Calculate true end position
                peakBeg(end)=peakEnd(end)-(peakEnd(1)-peakBeg(1))+1;    %计算真实起始位置/Calculate the real starting position
            end
        end
    end
    
    
    % 画图/Drawing
    if Debug==1
        % 原图像/Original image
        close all;
        h=figure(1);
        set(h,'Position',[10,410,500,350]);
        plot(data);
        hold on;
        for i=1:length(peakBeg)
            plot([peakBeg(i),peakBeg(i)],[min(data),max(data)],'r');
            plot([peakEnd(i),peakEnd(i)],[min(data),max(data)],'r');
        end

        % 帧能量图像/Frame energy image
        h=figure(2);
        set(h,'Position',[510,410,500,350]);
        plot(frameEnergy);
        hold on;
        for i=1:length(begFrame)
            plot([begFrame(i),begFrame(i)],[0,max(frameEnergy)],'r');
            plot([endFrame(i),endFrame(i)],[0,max(frameEnergy)],'r');
        end
    end
end