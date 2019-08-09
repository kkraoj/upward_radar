clear all 
close all 
clc

interpFactor=10;
fs = 15360000;
T=1/fs;
T2=1/(fs*interpFactor);

dataType='short';

tic
directory1 = 'D:/Krishna/projects/upward_radar/data/folder_for_time_trial/dirfix_DV2018_1012_freq360_gain0_BW15_0.dat';
fID = fopen(directory1); %open data file
rawDataRead = single(fread(fID,dataType));
fclose(fID);
data = complex(rawDataRead(1:2:length(rawDataRead)),rawDataRead(2:2:length(rawDataRead))); %data is complex
t=[0:T:(length(data)-1)*T];
t_up=[0:T2:(length(data)-1)*T];
data_upsampled = spline(t,data,	t_up);

%write data
mywriteData(data_upsampled,'D:/Krishna/projects/upward_radar/data/folder_for_time_trial','dirfix_DV2018_1012_freq360_gain0_BW15_0_upsampled_x10',dataType,0);
toc


