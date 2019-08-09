%Purpose: To interpolate data in the time domain and prevent match filter power
%differences from occuring due to processing
clc 
close all
clear all

dataFolder = '/media/krishna/Seagate Backup Plus Drive/upwardradar/20_may_2019_2humanssittinginline_100ft_NS'; %
writeDataFolder = strcat(dataFolder,'_upsampled');
fileType = '*.dat';

if ~exist(writeDataFolder, 'dir')
       mkdir(writeDataFolder)
end

interpFactor=8;
fs = 15360000;
T=1/fs;
T2=1/(fs*interpFactor);

dataType='short';

%center freq = 360
%dur = 8s
%gain = -8dB

%% Read Data
%Create directory of filenames sorted by date
cd(dataFolder);
b = dir(fileType);
% b = subdir(fullfile(dataFolder,fileType));
S = [b(:).datenum].';%obtain date
[S,S] = sort(S);%sort dates
directory = {b(S).name}'; % %make directory be filenames in order of date recorded

dataFolderStr = regexprep(dataFolder,'\','\\\');

%read distance between tx and rx antennas (which is the file name)
name=regexprep(regexprep(regexprep(directory,dataFolderStr,''),'\\',''),regexprep(fileType,'*',''),''); %isolate filename from directory


for i = 1:length(directory)
    cd(dataFolder);
    directory1=directory{i};

    %read data
    fID = fopen(directory1); %open data file
    rawDataRead = single(fread(fID,dataType));
    fclose(fID);
    data = complex(rawDataRead(1:2:length(rawDataRead)),rawDataRead(2:2:length(rawDataRead))); %data is complex
%     t=[0:T:(length(data)-1)*T];
%     t_up=[0:T2:(length(data)-1)*T];
%     data_upsampled = spline(t,data,	t_up);
    data_upsampled = interpft(data,length(data)*interpFactor);
        
    %write data
    cd('/home/krishna/upwardradar/Processing_SDR_Data');
    mywriteData(data_upsampled,writeDataFolder,[name{i},'_upsampled_x',num2str(interpFactor)],dataType,0)
end   