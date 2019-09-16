clear all 
close all 
clc 

dataFolder = '/home/krishna/upwardradar/filtered/arboretum_14_sep_2019';

dataType='float';

filesorder = ['1800','1900','2000','2100','2200','2300','0000','0100','0200','0300','0400','0500','0600','0700','0800','0900','1000','1100'];
howmanyfilestotal = [10,9,10,10,10,10,10,10,9,10,10,10,8];
numhoursrecorded = 18;
howmanyfilessaved = zeros(1, numhoursrecorded);
%% Read Data
%read data

files = dir(sprintf('%s/*.dat',dataFolder));
allpeaks = NaN(80,numhoursrecorded); %6pm - 11am x 10 chirps per each hour with 8 peaks each
for i = 1:length(files)
    timerecorded = files(i).name(1:2); 
    timeindex = str2double(timerecorded) - 17 ; % first valid reading at 1800
    if timeindex < 0
        timeindex = timeindex+24;
    end
%     disp(timeindex)
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
%         disp(peak);
        if peak>0.02
            peaks(length(peaks)+1) = peak;
        end
        
    end
%     disp(length(peaks));
    colstart = howmanyfilessaved(timeindex)*8+1; % 8 peaks in each file
    colend = colstart + length(peaks) - 1;
%     disp(colend);
    allpeaks(colstart:colend, timeindex) = peaks ;
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

figure()
hold on


ms = 6;

x = linspace(18, 35, numhoursrecorded);
y = nanmean(allpeaks);
yerr = nanstd(allpeaks);

errorbar(x, y, yerr, 'k', 'LineStyle','none', 'LineWidth',2);

l = plot(x,y, '-s','MarkerSize', ms, 'Color','k','MarkerEdgeColor', 'k','LineWidth',2); 
% l.MarkerFaceColor = l.Color;


set(findall(gcf,'-property','FontSize'),'FontSize',14)
% ylim([0.0,0.1]);
% xlim([0,6]);
% xticks([1,2,3,4,5]);
% xticklabels({'standing sidebyside', 'standing inline', 'sitting inline','sitting sidebyside','no obstacles'});
% xtickangle(45)
% axis square
ylabel('Magnitude received');
xlabel('Time of day');
% print('arboretum_diurnal_cycle.jpg','-r300');

fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 6 3];

print('-r300','-djpeg','arboretum_diurnal_12-sep-2019.jpg');
