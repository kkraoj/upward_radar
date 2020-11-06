clc
clear all
close all

cd '/home/krishna/upwardradar/Processing_SDR_Data';
files =["ref_chirp.dat","ref_chirp_upsampled.dat","ref_chirp_upsampled_x8.dat"];
labels = ["raw","time upsampled 10x","fft upsampled 8x"];

dataType = 'short';
hold on
for c = 1:3
    directoryl = files(c);
    fID = fopen(directoryl); %open data file
    rawDataRead = single(fread(fID,dataType));
    fclose(fID);

    data = complex(rawDataRead(1:2:length(rawDataRead)),rawDataRead(2:2:length(rawDataRead))); %data is complex

    [R,lags] = xcorr(data,data, 'normalized');
    R = R(lags>=0);
    lags = lags(lags>=0);

    plot(lags(1:20),abs(R(1:20)),'LineWidth',3,'DisplayName',labels(c));
    
    
end

xlabel('Lags');
ylabel('Autocorrelation');
legend();
title('ACF for reference chirps');
