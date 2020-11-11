clear all 
close all 
clc 

% dataFolder = '/home/krishna/upwardradar/filtered/arboretum_14_sep_2019';
% dataFolder = '/media/krishna/Seagate Backup Plus Drive/upwardradar/filtered/jrbp_5_nov_2020_0939';
dataFolder = 'H:/upwardradar/filtered/jrbp_5_nov_2020_0939';
dataType='float';

% filesorder = ["1800","1900","2000","2100","2200","2300","0000","0100","0200","0300","0400","0500","0600","0700","0800","0900","1000","1100"];
% howmanyfilestotal = [10,9,10,10,10,10,10,10,9,10,10,10,8];
% numhoursrecorded = length(filesorder);
% howmanyfilessaved = zeros(1, numhoursrecorded);
startTime = "2020-11-05 09:30:00";
startTime = datetime(startTime,'InputFormat','yyyy-MM-dd HH:mm:ss');

%% Read Data
%read data

files = dir(sprintf('%s/*.dat',dataFolder));
numHours = split({files.name},"_"); numHours = numHours(:,:,1); numHours = cellfun(@str2num,numHours);
numHours = unique(numHours);
allpeaks = NaN(8*ceil(length(files)/length(numHours)),length(numHours)); %6pm - 11am x 10 chirps per each hour with 8 peaks each
for i = 0:length(numHours)-1
    subFiles = dir(sprintf('%s/%d_*.dat',dataFolder,i));
    for j = 1:length(subFiles)
        
%     timerecorded = files(i).name(1:2); 
%     timeindex = str2double(timerecorded) - 17 ; % first valid reading at 1800
%     if timeindex < 0
%         timeindex = timeindex+24;
%     end
% %     disp(timeindex)
        fID = fopen(fullfile(subFiles(j).folder, subFiles(j).name)); %open data file
        data = (fread(fID,dataType)); %read data  ,'ieee-be'?
        fclose(fID);
        t = data(1:2:length(data))/8; % upsampled by 8
        data=data(2:2:length(data)); %only abs is spit out

    %peak detection
        peaks = [];
        for k = 1:8 % 8 peaks in a chirp
            sample = data((t>k-1)&(t<k));
            peak = max(sample);
            
    %         disp(peak);
            if peak>0.02
                peaks(length(peaks)+1) = peak;
            end

        end
%     disp(length(peaks));
%         colstart = howmanyfilessaved(timeindex)*8+1; % 8 peaks in each file
%         colend = colstart + length(peaks) - 1;
%     disp(colend);
        rowStart = (j-1)*8+1;
        allpeaks(rowStart:rowStart+length(peaks)-1, i+1) = peaks ;
%         howmanyfilessaved(timeindex) = howmanyfilessaved(timeindex)+1;
    end
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

% csvwrite('/media/krishna/Seagate Backup Plus Drive/upwardradar/results/jrbp_5_nov_2020_0939.csv',allpeaks);
%% make timeseries
size = [0, 0, 750, 250];
figure('position', size)
hold on

ms = 4;

x = numHours+9;
y = nanmean(allpeaks);
yerr = nanstd(allpeaks);
% yyaxis right
% plot(x,y,'-o','MarkerSize', ms, 'LineWidth',2);
% yyaxis left
errorbar(x, y, yerr,  'LineStyle','none', 'LineWidth',1,'Color',[0.7 0.7 0.7]);
l = plot(x,y, '-o','MarkerSize', ms, 'LineWidth',1,'color','black','MarkerFaceColor','black'); 
% l.MarkerFaceColor = l.Color;

res = 300;
set(findall(gcf,'-property','FontSize'),'FontSize',14);
% set(gcf,'paperunits','inches','paperposition',[0 0 size/res]);
% ylim([0.0,0.1]);
% xlim([17,36]);
% xticks(linspace(18,35, 18));
% xticks([12,18,24,30,36]);
% xticklabels({'12pm','6pm','12am','6am','12pm'});
xticks(min(x):12:round(max(x)/12)*12);
xticklabels(rem(min(x):12:round(max(x)/12)*12,24));
% xticklabels({'standing sidebyside', 'standing inline', 'sitting inline','sitting sidebyside','no obstacles'});
% xticklabels(filesorder);
% newlabels = filesorder;
% for i = 1:length(filesorder)
%     templabel = filesorder(i);
%     newlabels(i) = templabel(1:2);
% end 
    

% xticklabels('});
% xtickangle(45)
% axis square
ylabel('Radar amplitude');
xlabel('Time of day');
% print('arboretum_diurnal_cycle.jpg','-r300');
% 
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 9 3];


% print('-r300','-djpeg','jrbp_5_nov_2020_0939.jpg');
