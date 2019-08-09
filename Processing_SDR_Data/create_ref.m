% 2/24/19
% Nicole Bienert
%Purpose: Read binary file for reference chirp, finds the chirp through 
%autocorrelation and exports the .mat file of the reference

clc 
close all
clear all


%% Vars
file = 'C:\Users\jeany\OneDrive - Leland Stanford Junior University\Documents\School\Research\Antarctica_2019\Data_Copy_for_Code\dirfix_DV2018_1012_freq330_gain0_BW15_4';
fileType = '.dat';
fs = 15360000;
dataType='short';
%center freq = 330
%dur = 8s
%gain = 62

T=1/fs;
shift=1000;
%% Read Data
fID = fopen([file,fileType]); %open data file
rawDataRead = single(fread(fID,dataType));
fclose(fID);
allData = complex(rawDataRead(1:2:length(rawDataRead)),rawDataRead(2:2:length(rawDataRead))); %data is complex
%use only part of the data for processing, so that the code is faster
data=allData(ceil(length(allData)/7):ceil(length(allData)/7)*2);
t = (0:length(data)-1)*T;


%% Process Data
%make a rectangle to correlate against
sampsPerChirp=1/200e6*fs^2;
rect=[zeros(1,shift),ones(1,sampsPerChirp),zeros(1,shift)];
rectT= [0:T:(length(rect)-1)*T];

% perform correlation with rectangle
[R,lags] = xcorr(data,rect);

% take only 1 side
R = R(lags>=0);
lags = lags(lags>=0)/fs;



%Calculate center of chirp
%correct for the zero buffer in the rectangle
Rcorrect=[zeros(shift,1);R];
%Normalize data to R and find where R is max in the chirp
[val,middleChirpInd]=max(real(Rcorrect(1:length(data))).*abs(data)*max(real(Rcorrect))/max(abs(data)));

%I don't care about phase, so I'm only using the real part of R
figure()
hold on
plot(t,abs(data)*max(real(R))/max(abs(data)))
hold on
plot(lags+shift*T,real(R),'r')
hold on
scatter(t(middleChirpInd),real(Rcorrect(middleChirpInd)),'o')
hTitle = title('Data and xCorr with Rectangle')
hYlabel= ylabel('Magnitude')
hXlabel=xlabel('Delay (sec)')
legend('Data','xCorr with Rect','Middle of Chirp')
Aesthetics_Script

%grab chirp from time domain
x1 = middleChirpInd - sampsPerChirp/2; 
x2 = middleChirpInd + sampsPerChirp/2;
% take subset of data
ref_t = t(x1:x2);
ref_data = data(x1:x2);

figure()
plot(ref_t,abs(ref_data))
hTitle = title('Reference Chirp Saved')
hYlabel= ylabel('Magnitude')
hXlabel=xlabel('Delay (sec)')
Aesthetics_Script

ref_chirp=ref_data;
%save reference 
save('ref_chirp.mat','ref_chirp')