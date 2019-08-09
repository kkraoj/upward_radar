clc
close all 
clear all



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataType = 'short';
interpFactor=8;
fs = 15360000;
T=1/fs;
T2=1/(fs*interpFactor);

tic
directoryl = 'D:\Krishna\projects\upward_radar\data\folder_for_time_trial/dirfix_DV2018_1012_freq360_gain0_BW15_0.dat';
% directoryl = '/home/krishna/upwardradar/Processing_SDR_Data/ref_chirp.dat';

fID = fopen(directoryl); %open data file
rawDataRead = single(fread(fID,dataType));
% rawDataRead = rawDataRead(1:1000);
fclose(fID);
% 
data = complex(rawDataRead(1:2:length(rawDataRead)),rawDataRead(2:2:length(rawDataRead))); %data is complex
% t=[0:T:(length(data)-1)*T];
% t_up=[0:T2:(length(data)-1)*T];

% datau = interpft(data,length(data)*interpFactor);
datau = resampleFDZP(data, interpFactor);

writeDataFolder = 'D:\Krishna\projects\upward_radar\data\folder_for_time_trial';
% writeDataFolder = '/home/krishna/upwardradar/Processing_SDR_Data';
name = 'dirfix_DV2018_1012_freq360_gain0_BW15_0_upsampled_x8';
% name = 'ref_chirp_upsampled_x8';


% % mywriteData(datau,writeDataFolder,name,dataType,0);

% ext = '.dat';
% fid = fopen(fullfile(writeDataFolder,[name,ext]),'w'); % create file to write to
% count = fwrite(fid,datau,dataType);
% fclose(fid);
toc
