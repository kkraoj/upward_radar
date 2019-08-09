clear all 
close all 
clc


ref_chirp = '/home/krishna/upwardradar/Processing_SDR_Data/ref_chirp_upsampled_x8.dat';
% ref_chirp = '/home/krishna/upwardradar/Processing_SDR_Data/ref_chirp.dat';

directory = '/home/krishna/upwardradar/upsampling_experiment';
% directory = '/home/krishna/upwardradar/20_may_2019_2humanssittinginline_100ft_NS';
cd(directory);
savefolder = '/home/krishna/upwardradar/upsampling_experiment';
if ~exist(savefolder, 'dir')
       mkdir(savefolder)
end

files = dir('*.dat');

cd '/home/krishna/upwardradar/radar';
for c = 1:length(files)
    inputname = fullfile(files(c).folder, files(c).name);
    savename = fullfile(savefolder, sprintf('correlated_%02d.dat',c));
    
    command = sprintf('./xcorr-fast "%s" "%s" > "%s"',ref_chirp, inputname, savename);
    [status,cmdout] = system(command)
    if status ~=0
        sprintf('[FAILED] %s',inputname);
    else
        sprintf('[INFO] file processed : %d',c);
    end
end

