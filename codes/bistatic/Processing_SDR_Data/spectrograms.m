% 7 Nov peak
filename = 'H:\upwardradar\jrbp_10_nov_2020_0733\E312_TreeRadar_freq430_gain50_BW15_burst0_subBurst0_date011270_burstTime131158_callTime131201.dat';
%7 Nov no peak
filename = 'H:\upwardradar\jrbp_10_nov_2020_0733\E312_TreeRadar_freq430_gain50_BW15_burst1_subBurst0_date011270_burstTime132158_callTime132201.dat';
filename = 'H:\upwardradar\jrbp_10_nov_2020_0733\E312_TreeRadar_freq430_gain50_BW15_burst10_subBurst0_date011270_burstTime145158_callTime145201.dat';
filename = 'H:\upwardradar\jrbp_31_oct_2020_0925\E312_TreeRadar_freq430_gain40_BW15_burst92_subBurst2_date010770_burstTime085553_callTime085705.dat';
filename = 'H:\upwardradar\jrbp_31_oct_2020_0925\E312_TreeRadar_freq430_gain40_BW15_burst0_subBurst0_date010370_burstTime125553_callTime125556.dat';

%% 31st Oct chirps
files = ["H:\upwardradar\jrbp_31_oct_2020_0925\E312_TreeRadar_freq430_gain40_BW15_burst14_subBurst2_date010470_burstTime025553_callTime025705.dat",
         "H:\upwardradar\jrbp_31_oct_2020_0925\E312_TreeRadar_freq430_gain40_BW15_burst18_subBurst0_date010470_burstTime065553_callTime065556.dat"];
% %% 31st Oct no chirps
files = ["H:\upwardradar\jrbp_31_oct_2020_0925\E312_TreeRadar_freq430_gain40_BW15_burst73_subBurst3_date010670_burstTime135553_callTime135739.dat",
         "H:\upwardradar\jrbp_31_oct_2020_0925\E312_TreeRadar_freq430_gain40_BW15_burst78_subBurst4_date010670_burstTime185553_callTime185814.dat"];
% %% 7 Nov chirps
files = ["H:\upwardradar\jrbp_7_nov_2020_1350\E312_TreeRadar_freq430_gain50_BW15_burst1_subBurst1_date010970_burstTime192701_callTime192738.dat",
         "H:\upwardradar\jrbp_7_nov_2020_1350\E312_TreeRadar_freq430_gain50_BW15_burst22_subBurst4_date011070_burstTime162702_callTime162924.dat"];
% %% 7 Nov no chirps
files = ["H:\upwardradar\jrbp_7_nov_2020_1350\E312_TreeRadar_freq430_gain50_BW15_burst62_subBurst1_date011270_burstTime082702_callTime082740.dat",
         "H:\upwardradar\jrbp_7_nov_2020_1350\E312_TreeRadar_freq430_gain50_BW15_burst66_subBurst0_date011270_burstTime122702_callTime122705.dat"];

% %% 10 Nov chirps
files = ["H:\upwardradar\jrbp_10_nov_2020_0733\E312_TreeRadar_freq430_gain50_BW15_burst15_subBurst0_date011270_burstTime154158_callTime154201.dat",
         "H:\upwardradar\jrbp_10_nov_2020_0733\E312_TreeRadar_freq430_gain50_BW15_burst36_subBurst1_date011270_burstTime191158_callTime191235.dat"];


close all
dataType = 'short';
fs = 15.36*1e6;
T = 1/fs;

dataFolder = 'H:\upwardradar\spectrograms\5_nov_unaffected' ;
files = dir(sprintf('%s/**/*.dat',dataFolder));

dataType = 'short';
% cd '/home/krishna/upwardradar/radar';
load ref_chirp_430
figure('units','inch','position',[0,0,7,3.1*length(files)],'DefaultAxesFontSize',12);

for i = 1:length(files)
%     splits = split(files(i).name,"_");
%     burst = splits(6); burst = burst{1}; burst = extractAfter(burst,"burst");
%     subBurst = splits(7); subBurst = subBurst{1}; subBurst = extractAfter(subBurst,"subBurst");
%     if subBurst=='0'
%     fprintf(burst);
    filename = fullfile(files(i).folder, files(i).name);
    fID = fopen(filename); %open data file
    rawDataRead = single(fread(fID,dataType));
    fclose(fID);
    data = complex(rawDataRead(1:2:length(rawDataRead)),rawDataRead(2:2:length(rawDataRead))); %data is complex
    data = data(1:round(length(data)/7));
%     [R,lags] = xcorr(data,ref_chirp);
%     R = R(lags>=0);
   
    Y = fft(data);
    
    L = length(data);
    P2 = abs(Y/L);
%     P1 = P2(1:L/2+1);
%     P1(2:end-1) = 2*P1(2:end-1);
%     f = fs*(0:(L/2))/L/1e6;
    P2 = fftshift(P2);
    f = (-L/2:L/2-1)*(fs/L)/1e6;
    subplot(length(files),2,2*i-1)
%     plot(f,P1) 
    plot(f,P2,'LineWidth',2)
    title('Spectral Amplitude')
    xlabel('Frequency (MHz)')
    ylabel('Spectral Amplitude')
%     ylim([0,3e8]);
    
    subplot(length(files),2,2*i)
    pkurtosis(abs(data),fs);
    
%     ylim([-2,18]);
    title(sprintf('Spectral kurtosis'));
    drawnow
%     end
            
end

