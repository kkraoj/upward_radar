clear all
close all 
clc


ref_chirp = '/media/krishna/Seagate Backup Plus Drive/upwardradar/ref_430_upsampled/ref_chirp_430_upsampled_x8.dat';

dataFolder = '/media/krishna/Seagate Backup Plus Drive/upwardradar/jrbp_22_oct_1153am'; %
savefolder = '/home/krishna/upwardradar/filtered/jrbp_22_oct_1153am';
if ~exist(savefolder, 'dir')
       mkdir(savefolder)
end

files = dir(sprintf('%s/**/*.dat',dataFolder));

interpFactor = 8;
dataType = 'short';
% cd '/home/krishna/upwardradar/radar';
for i = 1:length(files)
    time  = string(datetime('now','TimeZone','local','Format','HH:mm:ss'));
    fprintf('[INFO] Upsampling %d of %d files at %s\n', i,length(files), time) ;  
    %read data
    fullfilename = fullfile(files(i).folder, files(i).name);
    fID = fopen(fullfilename); %open data file
    rawDataRead = single(fread(fID,dataType));
    fclose(fID);
    data = complex(rawDataRead(1:2:length(rawDataRead)),rawDataRead(2:2:length(rawDataRead))); %data is complex
    data_upsampled = interpft(data,length(data)*interpFactor);

    writeDataFolder = '/media/krishna/Seagate Backup Plus Drive/upwardradar/temp';
    mywriteData(data_upsampled,writeDataFolder,['temp_upsampled_x',num2str(interpFactor)],dataType,0);
    
    time  = string(datetime('now','TimeZone','local','Format','HH:mm:ss'));
    fprintf('[INFO] Filtering %d of %d files at %s\n', i,length(files), time) ;  
    inputname = fullfile(writeDataFolder, strcat('temp_upsampled_x',num2str(interpFactor),'.dat'));
    splits = split(files(i).name,"_");
    burst = splits(6); burst = burst{1}; burst = extractAfter(burst,"burst");
    subBurst = splits(7); subBurst = subBurst{1}; subBurst = extractAfter(subBurst,"subBurst");
%     timerecorded = files(i).folder; 
%     timerecorded = timerecorded(end-25:end-22);
    savename = fullfile(savefolder, sprintf('%s_%s.dat',burst,subBurst));
    command = sprintf('/home/krishna/upwardradar/radar/xcorr-fast "%s" "%s" > "%s"',ref_chirp, inputname, savename);
    [status,cmdout] = system(command);
    if status ~=0
        sprintf('[FAILED] %s\n',inputname);
    else
        sprintf('[INFO] file processed : %d\n',i);
    end
end

