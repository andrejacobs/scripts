#!/bin/bash
# Who is spinning up the drive?

# Megalodon
DRIVE1=/dev/sdc
DRIVE2=/dev/sdd
DM4=dm-4

# Greatwhite
DRIVE3=/dev/sde
DRIVE4=/dev/sdf
DM5=dm-5

# Hammerhead
DRIVE5=/dev/sdi
DRIVE6=/dev/sdj
DM2=dm-2

# Lemon
DRIVE7=/dev/sdg
DM3=dm-3

# Zebra
DRIVE8=/dev/sdh
DM6=dm-6


CHECK_DRIVES=( $DRIVE1 $DRIVE2 $DRIVE3 $DRIVE4 $DRIVE5 $DRIVE6 $DRIVE7 $DRIVE8 )
LOG_DIR=/home/andre/temp/spinlogs

# Trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
    echo ""
    echo ">>> CTRL-C"
    echo 0 > /proc/sys/vm/block_dump
    exit 0
}

function spindown() {
    echo "Spinning down: $1"
    hdparm -y $1
}

function check() {
    if hdparm -C $1 | grep -E 'active/idle|unknown' ; then
        echo "$1 is ACTIVE"
        
        local DRIVE_NAME=${1##*/}
        local LOG_FILE="$LOG_DIR/$DRIVE_NAME.txt"
        date >> "$LOG_FILE"
        which_dm $1
        echo "$1 ($WHICH_DM) is ACTIVE" >> "$LOG_FILE"
        dmesg | grep "$WHICH_DM" >> "$LOG_FILE"
        echo "------------------------------------------------------------" >> "$LOG_FILE"
        echo "" >> "$LOG_FILE"
    fi
}

WHICH_DM=""
function which_dm() {
    case "$1" in
        "$DRIVE1")
            WHICH_DM="$DM4"
        ;;
        "$DRIVE2")
            WHICH_DM="$DM4"
        ;;
        "$DRIVE3")
            WHICH_DM="$DM5"
        ;;
        "$DRIVE4")
            WHICH_DM="$DM5"
        ;;
        "$DRIVE5")
            WHICH_DM="$DM2"
        ;;
        "$DRIVE6")
            WHICH_DM="$DM2"
        ;;
        "$DRIVE7")
            WHICH_DM="$DM3"
        ;;
        "$DRIVE8")
            WHICH_DM="$DM6"
        ;;
    esac
}

mkdir -p "$LOG_DIR"

# Turn on read/write logging for drives
sync
echo 1 > /proc/sys/vm/block_dump

# Spin down drives
for d in ${CHECK_DRIVES[@]}; do
    spindown $d
done

# Clear ring buffer
dmesg -C

# Start monitoring
while true; do
    for d in ${CHECK_DRIVES[@]}; do
        check $d
    done
    dmesg -C
    sleep 600
done
