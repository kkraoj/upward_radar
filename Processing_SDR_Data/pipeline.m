clear all
close all 
clc


ref_chirp = '/home/krishna/upwardradar/codes/refchirps/ref_chirp_upsampled_x8.dat';
% ref_chirp = '/home/krishna/upwardradar/Processing_SDR_Data/ref_chirp.dat';

dataFolder = '/media/krishna/Seagate Backup Plus Drive/upwardradar/arboretum_14_sep_2019_upsampled'; %
% directory = '/home/krishna/upwardradar/20_may_2019_2humanssittinginline_100ft_NS';
% cd(directory);
savefolder = '/home/krishna/upwardradar/filtered/arboretum_14_sep_2019';
if ~exist(savefolder, 'dir')
       mkdir(savefolder)
end

files = dir(sprintf('%s/**/*.dat',dataFolder));

interpFactor = 8
% cd '/home/krishna/upwardradar/radar';
for i = 1:length(files)
    fprintf('[INFO] Upsampling %d of %d files\n', i,length(filenames)) ;  
    %read data
    fullfilename = fullfile(filenames(i).folder, filenames(i).name);
    fID = fopen(fullfilename); %open data file
    rawDataRead = single(fread(fID,dataType));
    fclose(fID);
    data = complex(rawDataRead(1:2:length(rawDataRead)),rawDataRead(2:2:length(rawDataRead))); %data is complex
    data_upsampled = interpft(data,length(data)*interpFactor);

    writeDataFolder = something temp
%     if ~exist(writeDataFolder, 'dir')
%        mkdir(writeDataFolder);
%     end
    mywriteData(data_upsampled,writeDataFolder,[filenames(i).name,'_upsampled_x',num2str(interpFactor)],dataType,0);
    
    fprintf('[INFO] Filtering %d of %d files\n', i,length(files)) ;  
    inputname = fullfile(files(i).folder, files(i).name);
    dosometimethinghere
    timerecorded = files(i).folder; 
    timerecorded = timerecorded(end-25:end-22);
    savename = fullfile(savefolder, sprintf('%s_%03d.dat',timerecorded,c));
    command = sprintf('/home/krishna/upwardradar/radar/xcorr-fast "%s" "%s" > "%s"',ref_chirp, inputname, savename);
    [status,cmdout] = system(command)
    if status ~=0
        sprintf('[FAILED] %s\n',inputname);
    else
        sprintf('[INFO] file processed : %d\n',c);
    end
end

