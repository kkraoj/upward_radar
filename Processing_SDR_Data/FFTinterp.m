clc
close all 
clear all

% t = 0:0.05:1;
% y = sin(t*2*pi);
% interpfactor = 16;
% tu = linspace(min(t),max(t),length(t)*interpfactor);
% yu = resampleFDZP(y,interpfactor);
% plot(t,y, 'DisplayName','raw');
% hold on
% plot(tu,yu, 'DisplayName',sprintf('upsampled %dx', interpfactor));
% xlim([0 1]);
% ylim([-1,1]);
% xticks([0,0.25,0.5,0.75,1]);
% grid on
% legend();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataType = 'short';
interpFactor=8;
fs = 15360000;
T=1/fs;
T2=1/(fs*interpFactor);


directoryl = '/home/krishna/upwardradar/20_may_2019_2humanssittinginline_100ft_NS/dirfix_DV2018_1012_freq360_gain0_BW15_0.dat';
% directoryl = '/home/krishna/upwardradar/Processing_SDR_Data/ref_chirp.dat';

fID = fopen(directoryl); %open data file
rawDataRead = single(fread(fID,dataType));
% rawDataRead = rawDataRead(1:1000);
fclose(fID);
% 
data = complex(rawDataRead(1:2:length(rawDataRead)),rawDataRead(2:2:length(rawDataRead))); %data is complex
% t=[0:T:(length(data)-1)*T];
% t_up=[0:T2:(length(data)-1)*T];

datau = interpft(data,length(data)*interpFactor);

writeDataFolder = '/home/krishna/upwardradar/20_may_2019_2humanssittinginline_100ft_NS';
% writeDataFolder = '/home/krishna/upwardradar/Processing_SDR_Data';
name = 'dirfix_DV2018_1012_freq360_gain0_BW15_0_upsampled_x8';
% name = 'ref_chirp_upsampled_x8';


writeData(datau,writeDataFolder,name,dataType,0);

% ext = '.dat';
% fid = fopen(fullfile(writeDataFolder,[name,ext]),'w'); % create file to write to
% count = fwrite(fid,datau,dataType);
% fclose(fid);
