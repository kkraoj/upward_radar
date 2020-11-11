function value=process_chirps_master(fullfilename)
    ref_chirp = '$OAK/upward_radar/refchirps/ref_chirp_430_upsampled_x8.dat';
    savefolder = '$OAK/upward_radar/filtered/trial';
    if ~exist(savefolder, 'dir')
           mkdir(savefolder)
    end
    interpFactor = 8;
    dataType = 'short';
    % cd '/home/krishna/upwardradar/radar';
    time  = string(datetime('now','TimeZone','local','Format','HH:mm:ss'));
    fprintf('[INFO] Upsampling %d of %d files at %s\n', i,length(files), time) ;  
    %read data
    fID = fopen(fullfilename); %open data file
    rawDataRead = single(fread(fID,dataType));
    fclose(fID);
    data = complex(rawDataRead(1:2:length(rawDataRead)),rawDataRead(2:2:length(rawDataRead))); %data is complex
    data_upsampled = interpft(data,length(data)*interpFactor);

    writeDataFolder = '/media/krishna/Seagate Backup Plus Drive/upwardradar/temp2';
    mywriteData(data_upsampled,writeDataFolder,['temp_upsampled_x',num2str(interpFactor)],dataType,0);

    time  = string(datetime('now','TimeZone','local','Format','HH:mm:ss'));
    fprintf('[INFO] Filtering %d of %d files at %s\n', i,length(files), time) ;  
    inputname = fullfile(writeDataFolder, strcat('temp_upsampled_x',num2str(interpFactor),'.dat'));

    [~,name,~] = fileparts(fullfilename);
    splits = split(name,"_");
    burst = splits(6); burst = burst{1}; burst = extractAfter(burst,"burst");
    subBurst = splits(7); subBurst = subBurst{1}; subBurst = extractAfter(subBurst,"subBurst");
%     timerecorded = files(i).folder; 
%     timerecorded = timerecorded(end-25:end-22);
    savename = fullfile(savefolder, sprintf('%s_%s.dat',burst,subBurst));
    command = sprintf('/home/krishna/upwardradar/radar/xcorr-fast "%s" "%s" > "%s"',ref_chirp, inputname, savename);
    [status,~] = system(command);
    if status ~=0
        sprintf('[FAILED] %s\n',inputname);
    else
        sprintf('[INFO] file processed : %d\n',i);
    end
    value = 0;
end

