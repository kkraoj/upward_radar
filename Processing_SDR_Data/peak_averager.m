clear all 
close all 
clc 

directory = '/home/krishna/upwardradar/100ft_2_stand_inline';

dataType='float';

%% Read Data
% %read data
% 
% cd(directory);
% files = dir('*.dat');
% peaks = [];
% for i = 1:length(files)
%     file = files(i).name;
%     fID = fopen(file); %open data file
%     data = (fread(fID,dataType)); %read data  ,'ieee-be'?
%     fclose(fID);
%     t = data(1:2:length(data))/8;
%     data=data(2:2:length(data)); %only abs is spit out
% 
%     %peak detection
% 
%     for j = 1:8
%         sample = data((t>j-1)&(t<j));
%         peak = max(sample);
%         disp(peak);
%         if peak>0.005
%             peaks(length(peaks)+1) = peak;
%         end
%     end
%     
% end
% 
% %% averaging
% fprintf('%d peaks found',length(peaks));
% fprintf('Average magnitude = %0.5f',mean(peaks));
% fprintf('Std magnitude = %0.5f',std(peaks));

%% make summary plot for all scenarios
% 
figure()
hold on


ms = 12;

x = [1,2,3,4,5];
y = [0.01830, 0.01829, 0.01514, 0.01506, 0.01444];
yerr = [3, 2, 2,8, 12]*1e-4;

errorbar(x, y, yerr, 'k', 'LineStyle','none', 'LineWidth',2);

l = plot(x,y, 's','MarkerSize', ms, 'MarkerEdgeColor', 'k', 'LineWidth',1); 
l.MarkerFaceColor = l.Color;


set(findall(gcf,'-property','FontSize'),'FontSize',14)
ylim([0.01,0.020]);
xlim([0,6]);
xticks([1,2,3,4,5]);
xticklabels({'standing sidebyside', 'standing inline', 'sitting inline','sitting sidebyside','no obstacles'});
xtickangle(45)
axis square
ylabel('Magnitude received');

