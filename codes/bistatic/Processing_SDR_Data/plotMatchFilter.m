% ver1: correctly parses gps and radar data into raw binary for 1000 samp
% buffer
%ver2: read gps binary and short for

%be sure to change the buffer size and data type in the fread commands


clc 
close all
clear all

% directory = '/media/krishna/Seagate Backup Plus Drive/upwardradar/filtered/jrbp_10_nov_2020_0733/0_0.dat';
directory = 'H:\upwardradar\filtered\jrbp_10_nov_2020_0733\107_1.dat';
mytitle = 'Filtered';

dataType='float';

%% Read Data
%read data
fID = fopen(directory); %open data file
data = (fread(fID,dataType)); %read data  ,'ieee-be'?
fclose(fID);
t = data(1:2:length(data))/8;
data=data(2:2:length(data)); %only abs is spit out


%% Process Data


figure()
plot(t,data)
title(sprintf('Low peak (3:50am)'));
hXLabel = xlabel('Time (s)');
hYLabel = ylabel('Radar amplitude');
% xlim([3.444766,3.444768]); %122
% xlim([3.994788,3.994792]) %120
% xlim([6.50046,6.50047]) %120
%Aesthetics_Script

%% peak detection
% 
% for c = 1:8
%     sample = data((t>c-1)&(t<c));
%     peaks(c) = max(sample);
% end
% peaks = peaks(peaks>0.005);
% maxdiff = max(peaks) - min(peaks);
% dim = [.2 .5 .3 .3];
% str = sprintf('Max Difference = %0.4f',maxdiff);
% annotation('textbox',dim,'String',str,'FitBoxToText','on');

