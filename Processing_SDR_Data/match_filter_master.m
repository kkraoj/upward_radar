clear all
close all 
clc


ref_chirp = '/home/krishna/upwardradar/codes/refchirps/ref_chirp_upsampled_x8.dat';
% ref_chirp = '/home/krishna/upwardradar/Processing_SDR_Data/ref_chirp.dat';

dataFolder = '/media/krishna/Seagate Backup Plus Drive/upwardradar/arboretum_upsampled'; %
% directory = '/home/krishna/upwardradar/20_may_2019_2humanssittinginline_100ft_NS';
% cd(directory);
savefolder = '/home/krishna/upwardradar/filtered/arboretum';
if ~exist(savefolder, 'dir')
       mkdir(savefolder)
end

files = dir(sprintf('%s/**/*.dat',dataFolder));

% cd '/home/krishna/upwardradar/radar';
for c = 1:length(files)
    fprintf('[INFO] Filtering %d of %d files\n', c,length(files)) ;  
    inputname = fullfile(files(c).folder, files(c).name);
    timerecorded = files(c).folder; 
    timerecorded = timerecorded(end-13:end-10);
    savename = fullfile(savefolder, sprintf('%s_%03d.dat',timerecorded,c));
    command = sprintf('/home/krishna/upwardradar/radar/xcorr-fast "%s" "%s" > "%s"',ref_chirp, inputname, savename);
    [status,cmdout] = system(command)
    if status ~=0
        sprintf('[FAILED] %s\n',inputname);
    else
        sprintf('[INFO] file processed : %d\n',c);
    end
end

