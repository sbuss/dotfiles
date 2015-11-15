#!/bin/bash
# bash battery.sh -- prints battery usage of a battery (default bat0)
# bash battery.sh 1 -- given an argument, prints info about that battery
bat_n=${1:-0}
time=`upower -i /org/freedesktop/UPower/devices/battery_BAT$bat_n| grep -E "to\ full|to\ empty" | cut -f2 -d":" | xargs`
pct=`upower -i /org/freedesktop/UPower/devices/battery_BAT$bat_n| grep -E "percentage" | cut -f2 -d":" | xargs`
if [[ ! -z $time ]]; then
    time=" ($time)"
fi
echo "BAT$bat_n: $pct$time"
