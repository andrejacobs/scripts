#!/bin/bash
# Drive status

# Megalodon
DRIVE1=/dev/sdc
DRIVE2=/dev/sdd

# Greatwhite
DRIVE3=/dev/sde
DRIVE4=/dev/sdf

# Hammerhead
DRIVE5=/dev/sdi
DRIVE6=/dev/sdj

# Lemon
DRIVE7=/dev/sdg

# Zebra
DRIVE8=/dev/sdh


CHECK_DRIVES=( $DRIVE1 $DRIVE2 $DRIVE3 $DRIVE4 $DRIVE5 $DRIVE6 $DRIVE7 $DRIVE8 )

function check() {
    if hdparm -C $1 | grep -E 'active/idle|unknown' ; then
        echo "$1 is ACTIVE"        
    fi
}

for d in ${CHECK_DRIVES[@]}; do
    check $d
done
