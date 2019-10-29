% 2/24/2019
% Nicole Bienert
% Purpose: To create a coherent and incoherent sums of all data in a folder

%Important Notes:
%   The raw time domain data should always have a quantization number <
%   6,000. Any higher indicates that the maximum input voltage to the SDR
%   has been exceeded and the SDR will get damaged. 

%Version History:
%ver3: handles cases where there are no peaks detected. Returns plot for
%troubleshooting. 
%ver4: more options for troubleshooting. 

clc 
close all
clear all

%vars that may need to change:

dataFolder = '/home/radioglaciology/upward_radar/data/trial'; %

%dataFolder = 'D:\Krishna\projects\upward_radar\data\arboretum_14_sep_2019\check';
%dataFolder = '/data/schroeder/bienert/Antarctica_2019_back_up/dx0900m/slw-bistatic-dx0900-i132-f330';
display = 2; %how much data is returned for troubleshooting
%display = 0 => only display coherent summation at the end
%display = 1 => display match filter of data where peaks weren't detected
%display = 2 => display match filter of ALL data as well as the raw time
%               domain data

myTitle = 'trial';

%myTitle = '06:00';
fs = 15360000; %sample rate = 15360000MHz
dataType='short'; %data type from the SDR file
%number of phase shifts tested to align phases of chirps for summation.
numPhaseShifts = 6; %a larger number enables better SNR summations, but requires more computation

%Constants
fileType = '*.dat';
T=1/fs; %sample period
sampsPerChirp=1/200e6*fs^2; %number of expected samples in a chirp
c=3e8; % speed of light
maxOffset = 1300; %maximum antenna separation
thickness = 1000; %ice thickness
anticipatedDelay = 2*sqrt(thickness^2+maxOffset^2)/c-1300/c; %estimate of delay between bed and direct path
windowSize=anticipatedDelay*4/T; %Display window for viewing match filtered data
phaseRange = pi/2; %phases will be shifted from -phaseRange to +phaseRange
%center freq = 330
%dur = 8s
%gain = 62


% %% Rename files add .DAT
% 
% % Get all PDF files in the current folder
% files = dir('*.pdf');
% % Loop through each
% for id = 1:length(files)
%     % Get the file name (minus the extension)
%     [~, f] = fileparts(files(id).name);
%       % Convert to number
%       num = str2double(f);
%       if ~isnan(num)
%           % If numeric, rename
%           movefile(files(id).name, sprintf('%03d.pdf', num));
%       end
% end

%% Read Data
cd(dataFolder);
% rename all files to .dat
temp_files = dir('E312*');

for id = 1:length(temp_files)
    if temp_files(id).name(end-2:end) == 'dat'
        continue
    end
    movefile(temp_files(id).name, sprintf('%s.dat',temp_files(id).name));    
end

% cd('/home/radioglaciology/upward_radar/codes/Processing_SDR_Data');
cd ('D:\Krishna\projects\upward_radar\codes\bistatic\Processing_SDR_Data');
% cd('/home/krishna/upwardradar/codes/Processing_SDR_Data');

%Create directory of filenames sorted by date
b = subdir(fullfile(dataFolder,fileType));
S = [b(:).datenum].';%obtain date
[S,S] = sort(S);%sort dates
directory = {b(S).name}'; % %make directory be filenames in order of date recorded

dataFolderStr = regexprep(dataFolder,'\','\\\');

%obtain the filename
name=regexprep(regexprep(regexprep(regexprep(directory,dataFolderStr,''),'\\',''),regexprep(fileType,'*',''),''),'_','-'); %isolate filename from directory

%load pre-recorded chirp
load ref_chirp
%ref_chirp = ref_
set(0,'defaultAxesFontsize',18)

numNoChirpsFiles=0;
%iterate over each measurement in the folder

for i = 1:length(directory)
    [coherentSum,incoherentSum,numChirpsDetected,noChirpsFiles] = coherentIncoherentSums_ver8(ref_chirp,fs,char(directory{i}),windowSize,dataType,numPhaseShifts,phaseRange,display);
    
    %check if there were chirps in the file
    if ~isempty(noChirpsFiles)
        numNoChirpsFiles = numNoChirpsFiles+1;
        allNoChirpsFiles{numNoChirpsFiles}=noChirpsFiles;
    else
    %sum data
        if (i-numNoChirpsFiles)==1
            coherentSumTotal = coherentSum;
            incoherentSumTotal=incoherentSum;
            totalNumChirps=numChirpsDetected;
        else
            coherentSumTotal = coherentSumTotal+coherentSum;
            incoherentSumTotal=incoherentSumTotal+incoherentSum;
            totalNumChirps=totalNumChirps+numChirpsDetected;
        end
        %plot sums of chirps in this measurement
        figure()
        plot([0:T:(length(incoherentSum)-1)*T]*10^6,abs(incoherentSum));
        hold on
        plot([0:T:(length(coherentSum)-1)*T]*10^6,abs(coherentSum));
        hTitle=title('Match Filter');
        hXlabel= xlabel('Time (seconds)');
        hYlabel=ylabel('Magnitude');
        hLegend=legend('Incoherent Sums','Coherent Sums');
        Aesthetics_Script;
    end
    

    pause(0.1)
end
% 
% %if any chirps were detected, display the sums
% if numNoChirpsFiles<length(directory)
%     %average 
%     coherentSumTotal=coherentSumTotal/totalNumChirps;
%     incoherentSumTotal=incoherentSumTotal/totalNumChirps;
% 
%     gcf=figure();
%     plot([0:T:(length(incoherentSumTotal)-1)*T]*10^6,abs(incoherentSumTotal));
%     hold on
%     plot([0:T:(length(coherentSumTotal)-1)*T]*10^6,abs(coherentSumTotal));
%     hTitle=title(['Match Filter of ',num2str(totalNumChirps),' Chirps']);
%     hXlabel= xlabel('Time (microseconds)');
%     hYlabel=ylabel('Magnitude');
%     hLegend=legend('Incoherent Sums','Coherent Sums');
%     Aesthetics_Script;
%     saveas(gcf, [myTitle,'_coherentIncoherentPlot_',num2str(totalNumChirps),'_Sums'], 'fig')
%     saveas(gcf, [myTitle,'_coherentIncoherentPlot_',num2str(totalNumChirps),'_Sums'], 'png')
%     save([myTitle,'_coherentSum.mat'],'coherentSumTotal')
%     save([myTitle,'_incoherentSum.mat'],'incoherentSumTotal')
% end
