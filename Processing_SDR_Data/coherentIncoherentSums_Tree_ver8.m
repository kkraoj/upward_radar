p% 2/25/2019
% Nicole Bienert
% Purpose: To create the coherent and incoherent sums of chirps detected in
% a file
%returns: coherent sum, incoherent sum, number of peaks detected. Note that
%sums are NOT averaged, just a+b+c.

%history
%ver1: use findpeaks, use for loop logic to keep only real peaks
%ver2: uses a faster peak search algorithm. Remove expectedNumPks algorithm
%because it isn't reliable, and assume that anything above threshold is a
%real peak. It just plots zoomed in match filtered peaks, and centers on
%the direct path
%ver3: added phase shifting to complete coherent and incoherent summations.
%The code is stand alone, not a function. This was tested with both
%Antarctica data and Greenland data. Corrected logic for removing clipped
%chirps
%ver4: turned into a function
%ver5: handles cases where there are no chirps in the file
%ver6: No longer general. It assumes that files will either always see a direct
%path and bed reflection or only ever see direct path. 
%ver7: Return match filtered data if no peaks were detected. (For
%troubleshooting). Corrected version of removing chirps too close to edge.
%ver8: Returns Time and match filtered data if display ==2. 

function [coherentSumReturned,incoherentSumReturned,numChirpsDetected,noChirpsFiles] = coherentIncoherentSums_Tree_ver8(ref_chirp,fs,directory,windowSize,dataType,numPhaseShifts,phaseRange,display)
phaseIncrement = (phaseRange*2/numPhaseShifts);
sampsPerChirp=1/200e6*fs^2; % always even
T=1/fs;
sampsSepPks=20; %number of samples required to make two peaks not be considered the same peak 
p
%read data
fID = fopen(directory); %open data file
data = single(fread(fID,dataType,)); %read data
fclose(fID);
data = complex(data(1:2:length(data)),data(2:2:length(data))); %data is complex


% perform match filtering
[R,lags] = xcorr(data,ref_chirp);

% take only positive side
R = R(lags>=0);
lags = lags(lags>=0)/fs;
clear lags 

%% find the direct path for phase shift data processing
%if bed is visible, it may be higher than the direct path. If bed is
%visible then use only the first peak as the direct path.
%find all direct paths and bed reflections.

% find peaks above noise floor
noiseFlr=mean(abs(R))+10*std(abs(R));
threshold = max(noiseFlr,max(abs(R))/4);
[locs,peaks]=peakseek(abs(R),sampsSepPks,threshold); 

%Display returned data if requested

if display ==2
    figure()
    plot([0:T:(length(R)-1)*T],abs(R));
    xlim([0, (length(R)-1)*T])
    hTitle=title('Match Filtered Data')
    hXlabel= xlabel('Time (microseconds)')
    hYlabel=ylabel('Magnitude')
    Aesthetics_Script

    figure()
    plot([0:T:(length(data)-1)*T],abs(data));
    xlim([0, (length(data)-1)*T])
    hTitle=title('Time Domain Data')
    hXlabel= xlabel('Time (microseconds)')
    hYlabel=ylabel('Quantization Number')
    Aesthetics_Script
    pause(0.01)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%only continue if there were chirps in the file
if isempty(locs)
    coherentSumReturned = [];
    incoherentSumReturned = [];
    numChirpsDetected = [];
    noChirpsFiles = directory;
    if display ==1
        figure()
        plot([0:T:(length(R)-1)*T],abs(R));
        xlim([0, (length(R)-1)*T])
        hTitle=title('Match Filter - No Peaks Above Threshold')
        hXlabel= xlabel('Time (microseconds)')
        hYlabel=ylabel('Magnitude')
        Aesthetics_Script
    end
else

    %remove any peaks which have been clipped or are too close to the edge for
    %the summation algorithm. Must use while loop since locs changes size
    n=1;
    while (n<=length(locs))
        %center of chirp is at locs+sampsPerChirp/2, because locs is at the
        %start of the chirp
        if ((locs(n)+sampsPerChirp/2< (sampsPerChirp+1))) %edge must be farther than sampsPerChirp for summation algorithm
            %remove peak from list if chirp is clipped
            locs(n)=[];
            peaks(n)=[];
        elseif ((locs(n)+sampsPerChirp/2> (length(data)-sampsPerChirp-1)))
            %remove peak from list if chirp is clipped
            locs(n)=[];
            peaks(n)=[];
        else
            n=n+1; %only increment if a number wasn't removed. If a num was removed, then there is a new num at locs(n)
        end
    end


    %% go through each locs and see if other peaks are nearby. 
    %Pick direct path over bed
    j=1;
    l=1;
    doublesLocs=[];
    doublesPks=[];
    singlesPks=[];
    singlesLocs=[];
    for n=1:length(locs)
        %are other peaks nearby?
        for k=1:length(locs)
            if k ~= n
                %if there is another peak in the window
                if ((abs(locs(n)-locs(k))<(windowSize/2)) )
                    %if there are others nearby, record the one that came first
                    if locs(n)<locs(k)
                        if ~(any(ismember(locs(n),doublesLocs)))
                            doublesLocs(j) = locs(n);
                            doublesPks(j) = peaks(n);
                            j=j+1;
                        end
                    else 
                        if ~(any(ismember(locs(k),doublesLocs)))
                            doublesLocs(j) = locs(k);
                            doublesPks(j) = peaks(k);
                            j=j+1;
                        end
                    end

                    break %terminate the loop so that a single or duplicate isn't recorded
                %if get to the end and there isn't another in the window, then it
                %is a single peak
                elseif(k== length(locs))
                    singlesLocs(l) = locs(n);
                    singlesPks(l) = peaks(n);
                    l=l+1;
                end
            end
        end
    end

    %Assume all peaks above threshold are real
    if isempty(doublesPks)
        directPathPks = singlesPks;
        directPathLocs=singlesLocs;
    else
        directPathPks = doublesPks;
        directPathLocs= doublesLocs;
    end
    numChirpsDetected=length(directPathLocs);


    %% zoom in on each rx chirp and find best phase shift
    for n=1:numChirpsDetected
        %grab time domain data centered around chirp at 2x chirp width
        dataCenter=directPathLocs(n)+sampsPerChirp/2; %sampsPerChirp is always even
        d1 = dataCenter - sampsPerChirp;
        d2 = dataCenter + sampsPerChirp;
        data_sub=data(d1:d2);


        %create several phase shifts of this data subset and find the one where
        %there is no phase shift with the direct path.
        for d = 1:numPhaseShifts+1
            clear R_pre
            clear lags_pre
            %create several phase shifted versions of the data
            phaseShift(d) = (-1*phaseRange+(d-1)*phaseIncrement);
            %find the real and imaginary components for the phase shifts
            [re,im] = pol2cart(wrapToPi(unwrap(angle(data_sub))+phaseShift(d)),abs(data_sub));
            %re-combine the real and imaginary components
            shiftPhaseData(d,:) = complex(re,im);
            %xcorr with ref chirp
            [R_pre,lags_pre] = xcorr(shiftPhaseData(d,:),ref_chirp);
            lags_shifted(d,:) = lags_pre(lags_pre>=0)/fs;
            R_shifted(d,:) = R_pre(lags_pre>=0);
            a(d,1:length(lags_shifted(d,:))) = phaseShift(d);
        end

        %Note that center of time data is located at sampsPerChirp+1
        %center of R_phaseShifted at sampsPerChirp/2+1

        % find best phase shift
        imaginaryPts = imag(R_shifted(:,sampsPerChirp/2+1)).^2; % sampsPerChirp/2+1 should be the peak of the match filter
        % signals most in phase when imaginary part is the smallest. 
        %Index at peak of correlation which is the same for every phase shift
        [~,bestPhaseInd] = min(imaginaryPts); 
        %if perfectly out of phase, then flip it
        if (real(R_shifted(bestPhaseInd,sampsPerChirp/2+1))<0)
            R_phaseShifted(n,:) = -R_shifted(bestPhaseInd,:);
        else
            R_phaseShifted(n,:) = R_shifted(bestPhaseInd,:);
        end

    %     plot match filter selected as best phase. Put an o at the center of the 
%         time data and an x at the peak of the match filtered data. 
%         figure()
%         hold on
%         plot(lags_shifted(1,:),abs(R_phaseShifted(n,:)),'r')
%         plot(lags_shifted(1,:),imag(R_phaseShifted(n,:)),'g')
%         plot(lags_shifted(1,:),real(R_phaseShifted(n,:)),'b')
%         scatter(lags_shifted(1,sampsPerChirp+1),max(abs(R_phaseShifted(n,:))),'o')
%         scatter(lags_shifted(1,sampsPerChirp/2+1),max(abs(R_phaseShifted(n,:))),'x')
    end



    %plot all the chirps which are in phase
%     figure()
%     for n=1:numChirpsDetected
%         hold on
%         plot([0:T:(floor(windowSize/2)*2)*T]*10^6,abs(R_phaseShifted(n,sampsPerChirp/2+1-floor(windowSize/2):sampsPerChirp/2+1+floor(windowSize/2))));
%     end
%     hTitle=title({'Match Filter Magnitude of each Chirp in file:',directory});
%     hXlabel= xlabel('Time (microseconds)');
%     hYlabel=ylabel('Magnitude');
%     Aesthetics_Script
% 
% 
%     figure()
%     for n=1:numChirpsDetected
%         hold on
%         plot([0:T:(floor(windowSize/2)*2)*T]*10^6,real(R_phaseShifted(n,sampsPerChirp/2+1-floor(windowSize/2):sampsPerChirp/2+1+floor(windowSize/2))));
%     end
%     hTitle=title('Match Filter Real Part of each Chirp');
%     hXlabel= xlabel('Time (microseconds)');
%     hYlabel=ylabel('Magnitude');
%     Aesthetics_Script
% 
%     figure()
%     for n=1:numChirpsDetected
%     hold on
%     plot([0:T:(floor(windowSize/2)*2)*T]*10^6,imag(R_phaseShifted(n,sampsPerChirp/2+1-floor(windowSize/2):sampsPerChirp/2+1+floor(windowSize/2))));
%     end
%     hTitle=title('Match Filter Imag Component of each Chirp');
%     hXlabel= xlabel('Time (microseconds)');
%     hYlabel=ylabel('Magnitude');
%     Aesthetics_Script


    coherentSum=zeros(1,length(data_sub));
    %create coherent sums
    for n=1:numChirpsDetected
        coherentSum=coherentSum+R_phaseShifted(n,:);
    end

    incoherentSum =zeros(1,length(data_sub));
    %create incoherent sums
    for n=1:numChirpsDetected
        incoherentSum=incoherentSum+abs(R_phaseShifted(n,:));
    end


    %return only the matched filtered sums centered around the direct path peak
    %of the window width
    incoherentSumReturned = incoherentSum(sampsPerChirp/2+1-floor(windowSize/2):sampsPerChirp/2+1+floor(windowSize/2));
    coherentSumReturned = coherentSum(sampsPerChirp/2+1-floor(windowSize/2):sampsPerChirp/2+1+floor(windowSize/2));
    noChirpsFiles = [];

end %end of if statement that checks that there are chirps
end % end for function