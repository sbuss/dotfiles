#!/bin/bash
temp1=`cat /sys/devices/virtual/thermal/thermal_zone0/temp`
echo `expr $temp1 / 1000`
