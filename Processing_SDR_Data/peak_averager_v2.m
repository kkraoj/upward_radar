clear all 
close all 
clc 

% dataFolder = '/home/krishna/upwardradar/filtered/arboretum_14_sep_2019';
dataFolder = 'F:\upwardradar\filtered\50db_upsampled';
dataType='float';

%% Read Data
%read data

files = dir(sprintf('%s/*.dat',dataFolder));
peaks = [];
for i = 1:length(files)

    fID = fopen(fullfile(files(i).folder, files(i).name)); %open data file
    data = (fread(fID,dataType)); %read data  ,'ieee-be'?
    fclose(fID);
    t = data(1:2:length(data))/8; % upsampled by 8
    data=data(2:2:length(data)); %only abs is spit out

    %peak detection
    for j = 1:8 % 8 peaks in a chirp
        sample = data((t>j-1)&(t<j));
        peak = max(sample);
%         disp(peak);
        if peak>2.5e-3
            peaks(length(peaks)+1) = peak;
        end
    end
end

%% averaging
fprintf('%d peaks found',length(peaks));
fprintf('Average magnitude = %0.5f',mean(peaks));
fprintf('Std magnitude = %0.5f',std(peaks));

%% make summary plot for all scenarios
% 
figure()
hold on


ms = 12;
histogram(peaks,10)

set(findall(gcf,'-property','FontSize'),'FontSize',14)
% ylim([0.01,0.020]);
% xlim([0,6]);
% xticks([1,2,3,4,5]);
xlabel('Echo power');
ylabel('Frequency');
% xticklabels({'standing sidebyside', 'standing inline', 'sitting inline','sitting sidebyside','no obstacles'});
% xtickangle(45)
% axis square
% ylabel('Magnitude received');
