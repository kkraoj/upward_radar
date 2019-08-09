function writeData(data,dataFolder,name,dataType,plotWritten);

ext = '.dat';
fid = fopen(fullfile(dataFolder,[name,ext]),'w'); % create file to write to
rawDataWrite(1:2:length(data)*2) = real(data);
rawDataWrite(2:2:length(data)*2)=imag(data);
count = fwrite(fid,rawDataWrite,dataType);
fclose(fid)

if plotWritten

    %read  from file to make sure it was written correctly
    fID = fopen(fullfile(dataFolder,[name,ext])); % create file to write to
    rawDataRead = single(fread(fID,dataType));
    fclose(fID);
    data = complex(rawDataRead(1:2:length(rawDataRead)),rawDataRead(2:2:length(rawDataRead))); %data is complex
    figure()
    plot([1:length(data)],abs(data))
    xlabel('samples')
    title('Data Written to File')
end

