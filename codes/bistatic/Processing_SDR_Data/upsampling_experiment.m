%Purpose: To interpolate data in the time domain and prevent match filter power
%differences from occuring due to processing
clc 
close all
clear all

filename = '/home/krishna/upwardradar/Processing_SDR_Data/ref_chirp.dat'; %
writeDataFolder = '/home/krishna/upwardradar/upsampling_experiment/ref_chirp';
fileType = '*.dat';

if ~exist(writeDataFolder, 'dir')
       mkdir(writeDataFolder)
end

dataType='short';


%% Read Data

for interpFactor = [2,4,6]
    %read data
    fID = fopen(filename); %open data file
    rawDataRead = single(fread(fID,dataType));
    fclose(fID);
    data = complex(rawDataRead(1:2:length(rawDataRead)),rawDataRead(2:2:length(rawDataRead))); %data is complex

    data_upsampled = interpft(data,length(data)*interpFactor);
    
    %write data
    cd('/home/krishna/upwardradar/Processing_SDR_Data');
    mywriteData(data_upsampled,writeDataFolder,['ref_chirp_upsampled_x',num2str(interpFactor)],dataType,0)
end   


%% graph
x = [0,2,4,6,8];
y = [38,20,5,7,7]*1e-4;
figure()
hold on


ms = 12;

l = plot(x,y, 'o','MarkerSize', ms, 'MarkerEdgeColor', 'k', 'LineWidth',1); 
l.MarkerFaceColor = l.Color;

set(findall(gcf,'-property','FontSize'),'FontSize',14)
% ylim([0.01,0.020]);
ylim([0,0.004]);
% xticks([1,2,3,4,5]);
% xticklabels({'standing sidebyside', 'standing inline', 'sitting inline','sitting sidebyside','no obstacles'});
% xtickangle(45)
axis square
xlabel('Interpolation factor');
ylabel('Max difference between peaks');