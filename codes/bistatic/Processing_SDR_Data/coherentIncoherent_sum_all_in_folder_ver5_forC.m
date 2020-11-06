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
%ver4: more options for troublegshooting. 

clc 
close all
clear all

%vars that may need to change:
%dataFolder = 'C:\Users\jeany\OneDrive - Leland Stanford Junior University\Documents\School\Research\Antarctica_2019\Data_Copy_for_Code'; %
dataFolder = '/home/krishna/upwardradar/mytest';
display = 2; %how much data is returned for troubleshooting
%display = 0 => only display coherent summation at the end
%display = 1 => display match filter of data where peaks weren't detected
%display = 2 => display match filter of ALL data as well as the raw time
%               domain data
myTitle = '2 humans sitting in line';
interpFactor=1;
fs = 15360000*interpFactor; %sample rate = 15360000MHz
dataType='short'; %data type from the SDR file
%number of phase shifts tested to align phases of chirps for summation.
numPhaseShifts = 6; %a larger number enables better SNR summations, but requires more computation

%Constants
fileType = '*.dat';
T=1/fs; %sample period
sampsPerChirp=1/200e6*(fs/interpFactor)^2; %number of expected samples in a chirp
c=3e8; % speed of light
maxOffset = 1300; %maximum antenna separation
thickness = 1000; %ice thickness
anticipatedDelay = 2*sqrt(thickness^2+maxOffset^2)/c-1300/c; %estimate of delay between bed and direct path
windowSize=ceil(anticipatedDelay*4/T*8); %Display window for viewing match filtered data
phaseRange = pi/2; %phases will be shifted from -phaseRange to +phaseRange
%center freq = 330
%dur = 8s
%gain = 62

addpath('/home/krishna/upwardradar/myTools')

%% Read Data
%Create directory of filenames sorted by date
b = subdir(fullfile(dataFolder,fileType));
S = [b(:).datenum].';%obtain date
[S,S] = sort(S);%sort dates
directory = {b(S).name}'; % %make directory be filenames in order of date recorded

dataFolderStr = regexprep(dataFolder,'\','\\\');

%obtain the filename
name=regexprep(regexprep(regexprep(regexprep(directory,dataFolderStr,''),'\\',''),regexprep(fileType,'*',''),''),'_','-'); %isolate filename from directory

%ref_chirp = ref_
set(0,'defaultAxesFontsize',18)

allNoChirpsFiles=[];
coherentSumTotal=[];
numNoChirpsFiles=0;
%iterate over each measurement in the folder

i=1;
%load i
%load coherentSumTotal
%load incoherentSumTotal
%load totalNumChirps
%load numNoChirpsFiles
%load allNoChirpsFiles

for i = i:length(directory)    
    i
    [incoherentSum,numChirpsDetected,noChirpsFiles] = coherentIncoherentSums_ver8_modForC(fs,char(directory{i}),windowSize,dataType,numPhaseShifts,phaseRange,display);
    
    %check if there were chirps in the file
    if ~isempty(noChirpsFiles)
        numNoChirpsFiles = numNoChirpsFiles+1;
        allNoChirpsFiles{numNoChirpsFiles}=noChirpsFiles;
    else
    %sum data
        if (i-numNoChirpsFiles)==1
            %coherentSumTotal = coherentSum;
            incoherentSumTotal=incoherentSum;
            totalNumChirps=numChirpsDetected;
        else
            %coherentSumTotal = coherentSumTotal+coherentSum;
            incoherentSumTotal=incoherentSumTotal+incoherentSum;
            totalNumChirps=totalNumChirps+numChirpsDetected;
        end
        %plot sums of chirps in this measurement
%         figure()
%         plot([0:T:(length(incoherentSum)-1)*T]*10^6,abs(incoherentSum));
%         hold on
%         plot([0:T:(length(coherentSum)-1)*T]*10^6,abs(coherentSum));
%         hTitle=title('Match Filter')
%         hXlabel= xlabel('Time (microseconds)')
%         hYlabel=ylabel('Magnitude')
%         hLegend=legend('Incoherent Sums','Coherent Sums')
%         Aesthetics_Script
    end
    if ~isempty(coherentSumTotal)
        %save('coherentSumTotal.mat','coherentSumTotal')
        save('incoherentSumTotal.mat','incoherentSumTotal')
        save('totalNumChirps.mat','totalNumChirps')
    elseif ~isempty(allNoChirpsFiles)
        save('numNoChirpsFiles.mat','numNoChirpsFiles')
        save('allNoChirpsFiles.mat','allNoChirpsFiles')
    end
    save('i.mat','i')
    
    pause(0.1)
end

%if any chirps were detected, display the sums
if numNoChirpsFiles<length(directory)
    %average 
    %coherentSumTotal=coherentSumTotal/totalNumChirps;
    incoherentSumTotal=incoherentSumTotal/totalNumChirps;

    gcf=figure();
    plot([0:T:(length(incoherentSumTotal)-1)*T]*10^6,abs(incoherentSumTotal));
    hold on
    %plot([0:T:(length(coherentSumTotal)-1)*T]*10^6,abs(coherentSumTotal));
    hTitle=title(['Match Filter of ',num2str(totalNumChirps),' Chirps, ',myTitle]);
    hXlabel= xlabel('Time (microseconds)');
    hYlabel=ylabel('Magnitude');
    hLegend=legend('Incoherent Sums');
    Aesthetics_Script;
    saveas(gcf, [myTitle,'_coherentIncoherentPlot_',num2str(totalNumChirps),'_Sums'], 'fig')
    saveas(gcf, [myTitle,'_coherentIncoherentPlot_',num2str(totalNumChirps),'_Sums'], 'png')
    %save([myTitle,'_coherentSum.mat'],'coherentSumTotal')
    save([myTitle,'_incoherentSum.mat'],'incoherentSumTotal')
end
