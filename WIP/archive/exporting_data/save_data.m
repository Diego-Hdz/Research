function [] = save_data(data, num, gcc_)
%% Saves person data to csv files
%   param data: data to be saved
%   parm num: file(person) number number
%   param gcc: boolean for saving in withGCC folder
if(gcc_ == false)
    for d=1:300
        writematrix(data{1,d},sprintf("data_export/withoutGCC/p%d/sample_%d.csv",num,d));
    end
elseif(gcc_ == true)
   for d=1:300
        writematrix(data{1,d},sprintf("data_export/withGCC/p%d/sample_%d_gcc.csv",num,d));
    end
else
    error("GCC boolean error");
end
end