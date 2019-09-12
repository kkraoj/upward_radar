clear all 
close all 
clc 

dataFolder = '/home/krishna/upwardradar/filtered/arboretum';

dataType='float';

howmanyfilestotal = [10,9,10,10,10,10,10,10,9,10,10,10,8];
howmanyfilessaved = zeros(1, 13);
%% Read Data
%read data

files = dir(sprintf('%s/*.dat',dataFolder));
allpeaks = NaN(13,80); %6am - 6pm x 10 chirps per each hour
for i = 1:length(files)
    timerecorded = files(i).name(1:2); 
    timeindex = str2double(timerecorded) - 5 ; % first reading at 6am
    
    fID = fopen(fullfile(files(i).folder, files(i).name)); %open data file
    data = (fread(fID,dataType)); %read data  ,'ieee-be'?
    fclose(fID);
    t = data(1:2:length(data))/8; % upsampled by 8
    data=data(2:2:length(data)); %only abs is spit out

    %peak detection
    peaks = [];
    for j = 1:8 % 8 peaks in a chirp
        sample = data((t>j-1)&(t<j));
        peak = max(sample);
        disp(peak);
        if peak>0.005
            peaks(length(peaks)+1) = peak;
        end
    end
    colstart = howmanyfilessaved(timeindex)*10+1;
    colend = colstart + length(peaks) - 1;
    allpeaks(timeindex, colstart:colend) = peaks ;
    howmanyfilessaved(timeindex) = howmanyfilessaved(timeindex)+1;
    
end

%% averaging
% fprintf('%d peaks found',length(peaks));
% fprintf('Average magnitude = %0.5f',mean(peaks));
% fprintf('Std magnitude = %0.5f',std(peaks));

%% make summary plot for all scenarios
% 
% figure()
% hold on
% 
% 
% ms = 12;
% 
% x = [1,2,3,4,5];
% y = [0.01830, 0.01829, 0.01514, 0.01506, 0.01444];
% yerr = [3, 2, 2,8, 12]*1e-4;
% 
% errorbar(x, y, yerr, 'k', 'LineStyle','none', 'LineWidth',2);
% 
% l = plot(x,y, 's','MarkerSize', ms, 'MarkerEdgeColor', 'k', 'LineWidth',1); 
% l.MarkerFaceColor = l.Color;
% 
% 
% set(findall(gcf,'-property','FontSize'),'FontSize',14)
% ylim([0.01,0.020]);
% xlim([0,6]);
% xticks([1,2,3,4,5]);
% xticklabels({'standing sidebyside', 'standing inline', 'sitting inline','sitting sidebyside','no obstacles'});
% xtickangle(45)
% axis square
% ylabel('Magnitude received');


%% make timeseries

% figure()
% hold on
% 
% 
% ms = 12;
% 
% x = linspace(6, 18, 13);
% y = mean(peaks,1);
% yerr = std(peaks,1);
% 
% errorbar(x, y, yerr, 'k', 'LineStyle','none', 'LineWidth',2);
% 
% l = plot(x,y, 's','MarkerSize', ms, 'MarkerEdgeColor', 'k', 'LineWidth',1); 
% l.MarkerFaceColor = l.Color;
% 
% 
% set(findall(gcf,'-property','FontSize'),'FontSize',14)
% ylim([0.01,0.020]);
% xlim([0,6]);
% xticks([1,2,3,4,5]);
% xticklabels({'standing sidebyside', 'standing inline', 'sitting inline','sitting sidebyside','no obstacles'});
% xtickangle(45)
% axis square
% ylabel('Magnitude received');

