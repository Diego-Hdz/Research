function tempStruct = loaddata_m(path, file)
%% Loads in data and places it in a struct
%   param path: folder name (ex: "data/")
%   param file: a number representing the file name (ex: "0")
    filename = path + num2str(file) + ".wav";                               % the filename to be loaded
    tempStruct = struct("dataFromFile", [], "sampleRate", []);              % create the struct
    [tempStruct.dataFromFile, tempStruct.sampleRate]= audioread(filename);  % load data into the struct
    %plot(tempStruct.dataFromFile);         % plots the data from the file
    %title("Raw data for " + filename);     % titles the plot
end