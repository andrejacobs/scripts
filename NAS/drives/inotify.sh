#!/bin/bash
# Monitor when the mounted directories are being accessed

DRIVE1=/media/megalodon
DRIVE2=/media/greatwhite
DRIVE3=/media/hammerhead
DRIVE4=/media/lemon
DRIVE5=/media/zebra

#CHECK_DIRS=( $DRIVE1 $DRIVE2 $DRIVE3 $DRIVE4 $DRIVE5 )
CHECK_DIRS=( $DRIVE2 $DRIVE3 $DRIVE4 $DRIVE5 )

LOG_DIR=/home/andre/temp/inotifylogs

function monitor() {
    echo "Monitoring: $1"
    
    local FILE_NAME=${1##*/}
    local LOG_FILE="$LOG_DIR/$FILE_NAME.txt"
    date >> "$LOG_FILE"
    
    inotifywait --timefmt '%F %T' --format '%T,%w,%|e,%f' -d -o "$LOG_FILE" -r "$1"
}

mkdir -p $LOG_DIR

sync

# Monitor each one
for d in ${CHECK_DIRS[@]}; do
    monitor $d
done
