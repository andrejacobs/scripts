#!/bin/bash
# Check drive states and report it as metrics for the node exporter textfile collector

echo '# HELP andre_drive_powermode Report the power mode of the /dev/sd? drives'
echo '# TYPE andre_drive_powermode gauge'

function checkPowerMode() {
    local guage=1.0
    local powerMode=$(/usr/local/bin/openSeaChest/openSeaChest_PowerControl -q -d $1 --checkPowerMode)
    
    if echo $powerMode | grep -q -w 'Active'; then
        guage=1.0
    elif echo $powerMode | grep -q -w 'Standby'; then
        guage=0.0
    elif echo $powerMode | grep -q -w 'Idle_c'; then
        guage=0.25
    elif echo $powerMode | grep -q -w 'Idle_b'; then
        guage=0.5
    elif echo $powerMode | grep -q -w 'Idle_a'; then
        guage=0.75
    fi
        
    echo "andre_drive_powermode{dev=\"$1\"} $guage"
}

for drive in /dev/sd? ; do
    checkPowerMode $drive
done
