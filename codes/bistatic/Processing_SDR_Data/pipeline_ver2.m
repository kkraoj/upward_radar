clear all
close all 
clc

ref_chirp = '/media/krishna/Seagate Backup Plus Drive/upwardradar/ref_430/ref_chirp_430.dat';
ref_chirp_upsampled = '/media/krishna/Seagate Backup Plus Drive/upwardradar/ref_430_upsampled/ref_chirp_430_upsampled_x8.dat';

% dataFolder = '/media/krishna/Seagate Backup Plus Drive/upwardradar/jrbp_31_oct_2020_0925'; %
dataFolder = '/media/krishna/USB30FD/jrbp_10_nov_2020_0733' ;
savefolder = '/media/krishna/Seagate Backup Plus Drive/upwardradar/filtered/jrbp_10_nov_2020_0733';
writeDataFolder = '/media/krishna/Seagate Backup Plus Drive/upwardradar/temp';
if ~exist(savefolder, 'dir')
       mkdir(savefolder)
end

files = dir(sprintf('%s/**/*.dat',dataFolder));

interpFactor = 8;
dataType = 'short';
freq = 15.36*1e6;
    
% cd '/home/krishna/upwardradar/radar';
for i = 1:length(files)
    time  = string(datetime('now','TimeZone','local','Format','HH:mm:ss'));
    fprintf('[INFO] Approximately filtering %d of %d files at %s\n', i,length(files), time) ;  
    inputname = fullfile(files(i).folder, files(i).name);
%     timerecorded = files(i).folder; 
%     timerecorded = timerecorded(end-25:end-22);
    savename = fullfile(writeDataFolder, sprintf('temp_filtered.dat'));
    command = sprintf('/home/krishna/upwardradar/radar/xcorr-fast "%s" "%s" > "%s"',ref_chirp, inputname, savename);
    [status,cmdout] = system(command);    
    
    time  = string(datetime('now','TimeZone','local','Format','HH:mm:ss'));
    fprintf('[INFO] Peak detecting %d of %d files at %s\n', i,length(files), time) ;  
    
    peakLocs = detectPeaks(savename, 0.02);
    
    clip(inputname, peakLocs, 0.1, freq, writeDataFolder); %0.05 seconds clipped on each side
   
    fprintf('[INFO] Upsampling %d of %d files at %s\n', i,length(files), time) ;  
    %read data
    fullfilename = fullfile(writeDataFolder, 'temp_filtered_clipped.dat');
    fID = fopen(fullfilename); %open data file
    rawDataRead = single(fread(fID,dataType));
    fclose(fID);
    data = complex(rawDataRead(1:2:length(rawDataRead)),rawDataRead(2:2:length(rawDataRead))); %data is complex
    data_upsampled = interpft(data,length(data)*interpFactor);
    mywriteData(data_upsampled,writeDataFolder,['temp_filtered_clipped_upsampled_x',num2str(interpFactor)],dataType,0);
    
    
    time  = string(datetime('now','TimeZone','local','Format','HH:mm:ss'));
    fprintf('[INFO] Filtering %d of %d files at %s\n', i,length(files), time) ;  
    inputname = fullfile(writeDataFolder, strcat('temp_filtered_clipped_upsampled_x',num2str(interpFactor),'.dat'));
    splits = split(files(i).name,"_");
    burst = splits(6); burst = burst{1}; burst = extractAfter(burst,"burst");
    subBurst = splits(7); subBurst = subBurst{1}; subBurst = extractAfter(subBurst,"subBurst");
%     timerecorded = files(i).folder; 
%     timerecorded = timerecorded(end-25:end-22);
    savename = fullfile(savefolder, sprintf('%s_%s.dat',burst,subBurst));
    command = sprintf('/home/krishna/upwardradar/radar/xcorr-fast "%s" "%s" > "%s"',ref_chirp_upsampled, inputname, savename);
    [status,cmdout] = system(command);
    
    break
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
