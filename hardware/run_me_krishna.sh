#!/bin/bash

usage="$(basename "$0") [-h] [-g gain] -n name
Program to take samples at a fixed frequency from the direction antenna.
where: 
    -h|--help              show this help text
    -g|--gain     (=60)    set the gain of the receiver
    -r|--rate     (=15360000)  set the sampling rate of the receiver
    -d|--duration (=8)   set the duration (seconds) during which to take samples
    -i|--nfiles   (=32)   number of files of samples to save
    -f|--freq     (=330)   set the frequency (MHz) at which to take samples
    -n|--name              set the name of the folder and archive in which samples will be saved
    -p|--pause    (=3600)  pause time in seconds between start of first burst recording and next burst recording. Each burst consits of nfiles number of files. Each nfile file is a recording of duration  seconds.
    -b|-nbursts   (=72) Number of bursts to record. Each burst consists of -n files number of sub-bursts of duration seconds each. "

while [[ $# -gt 0 ]] 
do
key="$1"
case $key in
    -n|--name)
    NAME="$2"
    shift
    ;;
    -p|--pause)
    PAUSE="$2"
    shift
    ;;
    -b|--nbursts)
    NBURSTS="$2"
    shift
    ;;
    -g|--gain)
    GAIN="$2"
    shift
    ;;
    -r|--rate)
    RATE="$2"
    shift
    ;;
    -d|--duration)
    DUR="$2"
    shift
    ;;
    -i|--nfiles)
    NFILES="$2"
    shift
    ;;
    -f|--freq)
    FREQ="$2"
    shift
    ;;
    -h|--help)
    echo "$usage"
    exit
    ;;
  esac
  shift
done

NAME=${NAME:-"NA"}
if [ "$NAME" == "NA" ]; then
    echo "Please input name (-n)"
    exit 0
fi


GAIN=${GAIN:-62}
RATE=${RATE:-15360000}
DUR=${DUR:-8}
NFILES=${NFILES:-100}
FREQ=${FREQ:-330}
PAUSE=${PAUSE:-3600} # pause time in secs
NBURSTS=${NBURSTS:-72} 

#check if pause time is sufficient enough to  allow recording of whole burst

if [ "$PAUSE" -lt "$((NFILES*70))" ]; then
	echo "[ERROR] Pause time less than $((70*NFILES))s (NFILESx70). Please increase --pause."
	exit 0
fi



M=1000000       # MHz
freq=$[FREQ*M]
FILE="E312_TreeRadar_freq"$FREQ"_gain"$GAIN"_BW"$[RATE/M]"_date"
mkdir /media/usb0/$NAME

BURSTCOUNTER=0
while [ $BURSTCOUNTER -lt $NBURSTS ]; do
	BURSTSTARTTIME=$SECONDS
	BURSTSTARTLOCALTIME="$(date +%H%M%S)"
	COUNTER=0
	while [ $COUNTER -lt $NFILES ]; do
 		echo Burst: $BURSTCOUNTER SubBurst: $COUNTER
		sleep 3
		DATE="$(date +%m%d%y)"
		CALLTIME="$(date +%H%M%S)"
		FILE="E312_TreeRadar_freq"$FREQ"_gain"$GAIN"_BW"$[RATE/M]"_burst"$BURSTCOUNTER"_subBurst"$COUNTER"_date"$DATE"_burstTime"$BURSTSTARTLOCALTIME"_callTime"$CALLTIME".dat"
		/usr/lib/uhd/examples/rx_samples_to_file --file /tmp/$FILE --gain $GAIN --rate $RATE --bw $RATE --duration $DUR --freq $freq --ant RX2 --subdev A:A --args="master_clock_rate=61440000" --stats --progress
		cd /tmp
		mv $FILE /media/usb0/$NAME
		let COUNTER+=1
	#	rm $FILE$COUNTER
	done
	let BURSTCOUNTER+=1
	ELAPSEDTIME=$(($SECONDS - $BURSTSTARTTIME))
	SLEEPTIME=$(($PAUSE-$ELAPSEDTIME))
	echo Sleeping for $SLEEPTIME s.
	sleep $SLEEPTIME
done
#~/grc/applications/take_samples_fixed/build/take_samples_fixed --file ~/grc/samples/$NAME/ --gain $GAIN --nfiles $NFILES --freq $FREQ --rate $RATE --duration $DUR


# #make archive and clean up
# echo "Compressing..."
# ARCHIVENAME="dir_fixed_"
# ARCHIVENAME+=$NAME
# ARCHIVENAME+=".tar.xz"
#
cd /media/usb0/$NAME
ls
pwd

#
# #tar -cf ~/$ARCHIVENAME $NAME/*
# tar -cf /media/usb0/$ARCHIVENAME $NAME/*
# rm -r ~/grc/samples/$NAME
#
# cd ~adar_NoGPS_freq"$FREQ"_gain"$GAIN"_BW"$[RATE/M]"_date"

