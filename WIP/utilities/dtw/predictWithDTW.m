function chunkPreditionAndData = predictWithDTW(k, chunk, allInputs_input, truth, train)
    chunkPreditionAndData = {};             % Return Value
    distancesFromNeighbors = [];            % Distances from all other points
    neighbhorClasses = [];                  % Classes of all other points
    currentSampleData = chunk;     % Data from the current sample
    
    % Iterate over all neighbhors and calculate the distance between them
    % via DTW
    for j = 1 : length(allInputs_input)    % j will be column
        % Find distance (self vs j) 
        distancesFromNeighbors = [distancesFromNeighbors, dtw(currentSampleData, allInputs_input{j})]; 
        neighbhorClasses = [neighbhorClasses, truth(j)]; 
    end
    % START PREDICTION 
    %[distancesFromNeighbors, neighbhorClasses] = sortChunk(distancesFromNeighbors, neighbhorClasses);
    [sortedChunk, sortedIndex] = sort(distancesFromNeighbors);
    sortedClasses = neighbhorClasses(sortedIndex);
    distancesFromNeighbors = sortedChunk;
    neighbhorClasses = sortedClasses;
    
    % It will always find itsself and report that as '0' distance, so once
    % we sort the lists, we remove the first element to remove that '0'
    % distance
    if train
        distancesFromNeighbors = distancesFromNeighbors(2:end);
        neighbhorClasses = neighbhorClasses(2:end);
    end
    %chunk_classPrediction = mode(categorical( cellstr(neighbhorClasses(1:k))));                     % The class repeated the most if the predicted class
    chunk_classPrediction = mode(neighbhorClasses(1:k));
    chunkPreditionAndData = {distancesFromNeighbors, neighbhorClasses, chunk_classPrediction};
end
%{
function [sortedChunk, sortedClasses] = sortChunk(distancesPassedIn, chunk_classes)
    [sortedChunk, sortedIndex] = sort(distancesPassedIn);
    sortedClasses = chunk_classes(sortedIndex);
end
%}