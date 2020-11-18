clear all
close all 
clc
dataType = 'short';
fs = 15.36*1e6;
    
files = ['/media/krishna/Seagate Backup Plus Drive/upwardradar/jrbp_5_nov_2020_0939/E312_TreeRadar_freq430_gain50_BW15_burst17_subBurst0_date010870_burstTime071617_callTime071620.dat',
            '/media/krishna/Seagate Backup Plus Drive/upwardradar/jrbp_5_nov_2020_0939/E312_TreeRadar_freq430_gain50_BW15_burst18_subBurst0_date010870_burstTime081617_callTime081620.dat'];
 
% cd '/home/krishna/upwardradar/radar';
for i = 1:length(files(:,1))
    fID = fopen(files(i,:)); %open data file
    rawDataRead = single(fread(fID,dataType));
    fclose(fID);
    data = complex(rawDataRead(1:2:length(rawDataRead)),rawDataRead(2:2:length(rawDataRead))); %data is complex
%     dataf = fft(data);
%     L = length(data);
%     P2 = abs(dataf/L);
% %     P1 = fftshift(P2);
%     P1 = P2(1:L/2+1);
%     P1(2:end-1) = 2*P1(2:end-1);
%     f = fs*(0:(L/2))/L;
%     figure
%     plot(f, P1);
%     xlim([7e4,9e4])
    figure
    pkurtosis(real(data), fs);
      
    
end

function peakLocs = detectPeaks(filename, lowThresh)
    fID = fopen(filename); %open data file
    data = (fread(fID,'float')); %read data  ,'ieee-be'?
    fclose(fID);
    t = data(1:2:length(data));
    data=data(2:2:length(data)); %only abs is spit out
    peakLocs = [];
    inds = 0;
    for k = 1:8 % 8 peaks in a chirp
        sample = data((t>k-1)&(t<k));
        if not(isempty(sample))
            [peak, index] = max(sample);
            if peak>lowThresh
                peakLocs(length(peakLocs)+1) = index+inds;
            end
        end
        inds = inds + length(sample);
    end
    peakLocs = t(peakLocs);
end

function clip(inputname, peakLocs, delta, freq, writeDataFolder)

    fID = fopen(inputname); %open data file
    rawDataRead = single(fread(fID,'short'));
    fclose(fID);
    
    lo = 2*floor((peakLocs-delta)*freq/2)+1;
    up = 2*round((peakLocs+delta)*freq/2);
    inds = cumsum(accumarray(cumsum([1;up(:)-lo(:)+1]),[lo(:);0]-[0;up(:)]-1)+1);
    inds = inds(1:end-1);
    rawDataWrite = rawDataRead(inds);
    
    
    name = 'temp_filtered_clipped';
    ext = '.dat';
    fid = fopen(fullfile(writeDataFolder,[name,ext]),'w'); % create file to write to
    fwrite(fid,rawDataWrite,'short');
    fclose(fid);
  
end 
