close all
clear all
dirData = 'D:\Krishna\projects\upward_radar\data';
dataPath1= '8_apr_2019_roble_field_1human_obstacle_sitting_99ft_v1_upsampled_processed'; 
dataPath2 = '8_apr_2019_roble_field_no_obstacle_99ft_v1_upsampled_processed';
%addMyMatlabTools
% addpath('C:\Users\jeany\OneDrive - Leland Stanford Junior University\Documents\School\Research\Matlab Code\myTools')
addpath(fullfile(dirData,dataPath1), fullfile(dirData,dataPath2));

myTitle= '99ft Comparison Human vs No Human'; 
load 8_apr_2019_roble_field_no_obstacle_99ft_v1_incoherentSum
load 8_apr_2019_roble_field_no_obstacle_99ft_v1_coherentSum
% load roble_field_11ft_no_obstacles_v1_totalNumChirps
noObstacles_incoherentSum = incoherentSumTotal;
noObstacles_coherentSum = coherentSumTotal;
% noObstacles_totalNumChirps = totalNumChirps;

load 8_apr_2019_roble_field_1human_obstacle_sitting_99ft_v1_incoherentSum
load 8_apr_2019_roble_field_1human_obstacle_sitting_99ft_v1_coherentSum
%load roble_field_11ft_2human_obstacles_v1_totalNumChirps


fs = 15360000; %sample rate = 15360000MHz
T=1/fs;

figure();
plot([0:T:(length(noObstacles_coherentSum)-1)*T]*10^6,abs(noObstacles_coherentSum));
hold on
plot([0:T:(length(coherentSumTotal)-1)*T]*10^6,abs(coherentSumTotal));
hTitle=title({'Match Filter of Coherent Summations';myTitle});
hXlabel= xlabel('Time (microseconds)');
hYlabel=ylabel('Quantization Number');
hLegend=legend('No Obstacles','Obstacles');
% xlim([10.50 10.65]) 
% ylim([-1 inf])
Aesthetics_Script;
%saveas(gcf, fullfile(dataPath,[myTitle,'_coherentIncoherentPlot_',num2str(totalNumChirps),'_Sums_ver2']), 'fig')
%saveas(gcf, fullfile(dataPath,[myTitle,'_coherentIncoherentPlot_',num2str(totalNumChirps),'_Sums_ver2']), 'png')

figure();
plot([0:T:(length(noObstacles_coherentSum)-1)*T]*10^6,abs(noObstacles_incoherentSum));
hold on
plot([0:T:(length(coherentSumTotal)-1)*T]*10^6,abs(incoherentSumTotal));
hTitle=title({'Match Filter Incoherent Summations';myTitle});
hXlabel= xlabel('Time (microseconds)');
hYlabel=ylabel('Quantization Number');
hLegend=legend('No Obstacles','Obstacles');
% xlim([10.50 10.65]) 
Aesthetics_Script;
%saveas(gcf, fullfile(dataPath,[myTitle,'_coherentIncoherentPlot_',num2str(totalNumChirps),'_Sums_ver2']), 'fig')
%saveas(gcf, fullfile(dataPath,[myTitle,'_coherentIncoherentPlot_',num2str(totalNumChirps),'_Sums_ver2']), 'png')


figure();
plot([0:T:(length(noObstacles_coherentSum)-1)*T]*10^6,abs(noObstacles_coherentSum-coherentSumTotal));
hTitle=title({['Match Filter '];myTitle});
hXlabel= xlabel('Time (microseconds)');
hYlabel=ylabel('Quantization Number');
hLegend=legend('Coherent Sum Difference');
% xlim([10.50 10.65]) 
Aesthetics_Script;