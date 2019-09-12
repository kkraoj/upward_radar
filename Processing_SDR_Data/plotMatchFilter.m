% ver1: correctly parses gps and radar data into raw binary for 1000 samp
% buffer
%ver2: read gps binary and short for

%be sure to change the buffer size and data type in the fread commands


clc 
close all
clear all

directory = '/home/krishna/upwardradar/filtered/arboretum/0800_025.dat';
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
title(sprintf('Match filtered data : %s',mytitle));
hXLabel = xlabel('Time (s)')
hYLabel = ylabel('Magnitude')
%Aesthetics_Script

%% peak detection

for c = 1:8
    sample = data((t>c-1)&(t<c));
    peaks(c) = max(sample);
end
peaks = peaks(peaks>0.005);
maxdiff = max(peaks) - min(peaks);
dim = [.2 .5 .3 .3];
str = sprintf('Max Difference = %0.4f',maxdiff);
annotation('textbox',dim,'String',str,'FitBoxToText','on');

