%Purpose: To interpolate data in the time domain and prevent match filter power
%differences from occuring due to processing
clc 
close all
clear all

dataFolder = '/data3/schroeder/TreeRadar/TreeData/20_may_2019_2humanstandingsidebyside_100ft_NS';
writeDataFolder = strcat(dataFolder, '_upsampled');
fileType = '*.dat';

interpFactor=10;
fs = 15360000;
T=1/fs;
T2=1/(fs*interpFactor);

dataType='short';

%center freq = 360
%dur = 8s
%gain = -8dB

%% create folder if already does not exist
if ~exist(writeDataFolder, 'dir')
    mkdir(writeDataFolder);
end

%% Read Data
%Create directory of filenames sorted by date
b = subdir(fullfile(dataFolder,fileType));
S = [b(:).datenum].';%obtain date
[S,S] = sort(S);%sort dates
directory = {b(S).name}'; % %make directory be filenames in order of date recorded

dataFolderStr = regexprep(dataFolder,'\','\\\');

%read distance between tx and rx antennas (which is the file name)
name=regexprep(regexprep(regexprep(directory,dataFolderStr,''),'\\',''),regexprep(fileType,'*',''),''); %isolate filename from directory


for i = 1:length(directory)
    directory1=directory{i};

    %read data
    fID = fopen(directory1); %open data file
    rawDataRead = single(fread(fID,dataType));
    fclose(fID);
    data = complex(rawDataRead(1:2:length(rawDataRead)),rawDataRead(2:2:length(rawDataRead))); %data is complex
    t=[0:T:(length(data)-1)*T];
    t_up=[0:T2:(length(data)-1)*T];
    data_upsampled = spline(t,data,t_up);
    
    
    %write data
    writeData(data_upsampled,writeDataFolder,[name{i},'_upsampled_x',num2str(interpFactor)],dataType,0);
end  
